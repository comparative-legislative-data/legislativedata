-- promote_session.sql
--
-- Copies one session's accepted staging lines onto the clean sheet, with the
-- accepted stage dates waiting for them on the stage-dates sheet.
--
-- Run it through docs/PROMOTION-RUNBOOK.md, which explains what to look at.
-- Two things must be supplied on the command line and there are no defaults,
-- so a mistyped run fails instead of guessing:
--
--   -v session=1   which session to promote
--   -v save=false  look at the result and throw it away
--   -v save=true   keep it
--
-- Safe to run more than once. It only touches staging lines that are accepted
-- and not already promoted, and it files at most one provenance note per fact.
-- Taking a session off (rollback_promotion.sql) removes its notes and stage
-- records, and putting it back writes them again (db/030, db/033).
--
-- Stage records come from stage_candidate, one per stage of a bill. Where two
-- accepted rows give the same stage, the error checker has made sure they
-- agree, and the more primary source is carried: the Official Report, then a
-- factsheet, then the PhD dataset (DECISIONS.md, 2026-09-11). No order is
-- settled between any other sources, and the script stops rather than choose.
--
-- A date checked at review against the source that owns it carries its own
-- source on the clean sheet, written from the "Checked: ..." line on the
-- staging row (db/042, db/043). A date with no such note carries the source of
-- the row it sits on, and nobody has checked it individually.
--
-- A line that names a bill already on the clean sheet in continues_bill_id is
-- a further appearance of that bill, not a bill of its own: the fact sheet is
-- listing a bill that was still live when an earlier session ended. Such a
-- line UPDATES the bill it names and adds the stages that bill does not have,
-- and makes nothing. See db/081 and methodology note M6. Everything else here
-- treats the two kinds separately and says which it means.

\set ON_ERROR_STOP on

BEGIN;

CREATE TEMP TABLE promote_arg ON COMMIT DROP AS SELECT :session::int AS session_number;

CREATE TEMP TABLE stage_source_rank ON COMMIT DROP AS
SELECT * FROM (VALUES ('official_report', 1), ('spice_factsheet_legislation', 2), ('phd', 3)) AS r(source, rank);

-- ---------------------------------------------------------------------------
-- Before anything is written
-- ---------------------------------------------------------------------------

-- Refuse to promote a session that still has an unresolved problem.
DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n
    FROM v_candidate_problems p JOIN promote_arg a USING (session_number);
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing to promote: % outstanding problem(s) in this session. Look at v_candidate_problems.', n;
  END IF;
END $$;

-- Refuse to promote a session that has not been reviewed to a conclusion.
DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n
    FROM bill_candidate c JOIN promote_arg a USING (session_number)
   WHERE c.review_status NOT IN ('accepted','rejected');
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing to promote: % staging line(s) in this session are not yet accepted or rejected.', n;
  END IF;
END $$;

-- The same for its stage dates, whatever their source: the owner's own dates
-- are read a second time before they are admitted (DECISIONS.md, 2026-09-11).
DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n
    FROM stage_candidate t
    JOIN bill_candidate c USING (candidate_id)
    JOIN promote_arg a ON a.session_number = c.session_number
   WHERE t.review_status NOT IN ('accepted','rejected')
     AND c.review_status <> 'rejected';
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing to promote: % stage-dates row(s) in this session are not yet accepted or rejected.', n;
  END IF;
END $$;

-- The exact set being promoted in this run. Everything below reads from here,
-- so a re-run cannot pick up a different set halfway through.
--
-- Two sets, because there are two things to do. promoting holds the lines that
-- become bills. continuing holds the lines that are a further appearance of a
-- bill already on the clean sheet, and updates it. target_bill_id is the bill
-- each line's facts belong to, which for a new bill is its own number, since a
-- bill's number is its staging line's number (db/026).
CREATE TEMP TABLE promoting ON COMMIT DROP AS
SELECT c.*, c.candidate_id AS target_bill_id
  FROM bill_candidate c JOIN promote_arg a USING (session_number)
 WHERE c.review_status = 'accepted'
   AND c.promoted_bill_id IS NULL
   AND c.continues_bill_id IS NULL;

CREATE TEMP TABLE continuing ON COMMIT DROP AS
SELECT c.*, c.continues_bill_id AS target_bill_id
  FROM bill_candidate c JOIN promote_arg a USING (session_number)
 WHERE c.review_status = 'accepted'
   AND c.promoted_bill_id IS NULL
   AND c.continues_bill_id IS NOT NULL;

CREATE TEMP TABLE promoting_all ON COMMIT DROP AS
SELECT candidate_id, target_bill_id FROM promoting
UNION ALL
SELECT candidate_id, target_bill_id FROM continuing;

-- A line may not continue a bill that is not there yet, and may not continue
-- one out of its own session's reach. The error checker says both of these of
-- the staging sheet; this says them again at the gate, so that what was
-- reviewed and what is written are the same thing.
DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM continuing c
   WHERE NOT EXISTS (SELECT 1 FROM bill b WHERE b.bill_id = c.target_bill_id);
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing to promote: % line(s) continue a bill that is not on the clean sheet.', n;
  END IF;

  SELECT count(*) INTO n FROM continuing c JOIN bill b ON b.bill_id = c.target_bill_id
   WHERE b.session_number >= c.session_number
      OR b.date_introduced IS DISTINCT FROM c.date_introduced;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing to promote: % line(s) continue a bill from a later or equal session, or one introduced on a different day.', n;
  END IF;
END $$;

-- A bill that appears in two factsheets has two staging lines and must become
-- one bill, not two. Sessions 5, 6 and 7 have them (M6). Stop rather than
-- quietly create a duplicate.
--
-- A matching title alone does not make it the same bill. The Prostitution
-- Tolerance Zones (Scotland) Bill was rejected at Stage 1 in Session 1, and a
-- new bill of the same name was introduced in Session 2: two bills, one title.
-- A bill counted in two factsheets keeps its introduction date; a reintroduced
-- bill has a new one. So the test is the same title AND the same date.
--
-- This cannot see a bill whose title changed between its two fact sheets: the
-- UNCRC Bill is listed as an Act in Session 6. That is why it is no longer the
-- only net. The error checker refuses a line whose introduction date falls
-- before its own fact sheet's session began unless it names the bill it
-- continues, and that catches a further appearance whatever its title does.
-- This guard remains as the second net, and asks only about lines that are
-- claiming to be bills of their own.
DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n
    FROM promoting p
   WHERE EXISTS (SELECT 1 FROM bill b
                  WHERE b.short_title = p.short_title
                    AND b.date_introduced IS NOT DISTINCT FROM p.date_introduced);
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing to promote: % staging line(s) match the title and introduction date of a bill already on the clean sheet. A bill counted in two sessions needs handling before this can run.', n;
  END IF;
END $$;

-- Two accepted dates for the same stage from sources with no settled order
-- between them.
DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM (
    SELECT t.candidate_id, t.stage_order
      FROM stage_candidate t
      JOIN promoting p USING (candidate_id)
      LEFT JOIN stage_source_rank r ON r.source = t.source
     WHERE t.review_status = 'accepted'
     GROUP BY t.candidate_id, t.stage_order
    HAVING count(*) > 1 AND bool_or(r.rank IS NULL)) x;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing to promote: % stage(s) have accepted dates from more than one source with no order of preference settled between them. See DECISIONS.md, 2026-09-11.', n;
  END IF;
END $$;

-- The stage-dates rows being carried: one per stage of each bill being
-- promoted, from its most primary accepted source.
--
-- A continuing line only adds stages its bill does not already have. A bill
-- listed in a second fact sheet has its earlier stages printed again, and the
-- later document is not the source those stages were settled from: the Session
-- 6 fact sheet says the European Charter Bill passed on 23 May 2021, and the
-- Parliament's own bill page settles it at 23 March (DECISIONS.md,
-- 2026-09-13). A restated stage stays on the staging sheet as what that
-- document said, and a disagreement goes through the ordinary route for one --
-- the "Checked: ..." citation the error checker demands.
CREATE TEMP TABLE promoting_stages ON COMMIT DROP AS
SELECT DISTINCT ON (t.candidate_id, t.stage_order) t.*, p.target_bill_id
  FROM stage_candidate t
  JOIN promoting_all p USING (candidate_id)
  LEFT JOIN stage_source_rank r ON r.source = t.source
 WHERE t.review_status = 'accepted'
   AND NOT EXISTS (SELECT 1 FROM stage_event e
                    WHERE e.bill_id = p.target_bill_id
                      AND e.stage_order = t.stage_order)
 ORDER BY t.candidate_id, t.stage_order, r.rank;

-- ---------------------------------------------------------------------------
-- The bills
-- ---------------------------------------------------------------------------

INSERT INTO bill (bill_id, session_number, sp_bill_id, short_title, bill_type,
                  procedure, date_introduced, outcome, enactment_status,
                  date_royal_assent, asp_number, date_concluded,
                  date_assent_blocked, bill_type_stated, title_as_introduced,
                  title_changed_at_stage, stage_1_rejection_route, note, date_procedure_agreed,
                  assent_block_route, assent_block_outcome,
                  reintroduced_from_bill_id,
                  source, source_ref, observed_at)
SELECT p.candidate_id, p.session_number, p.sp_bill_id, p.short_title, p.bill_type,
       p.procedure, p.date_introduced, p.outcome, p.enactment_status,
       p.date_royal_assent, p.asp_number, p.date_concluded,
       p.date_assent_blocked, p.bill_type_stated, p.title_as_introduced,
       p.title_changed_at_stage, p.stage_1_rejection_route, p.bill_note, p.date_procedure_agreed,
       p.assent_block_route, p.assent_block_outcome,
       p.reintroduced_from_bill_id,
       p.source, p.source_ref, p.observed_at
  FROM promoting p;

-- ---------------------------------------------------------------------------
-- The bills a later fact sheet says more about
-- ---------------------------------------------------------------------------

-- Eight cells, and no others. A further appearance of a bill says what has
-- happened to it since; it does not restate what the bill is. The session, the
-- introduction date, the bill type, who introduced it and its SP Bill number
-- belong to the bill's own session and are not touched. A cell the later fact
-- sheet leaves empty is left as it was: a second appearance adds and corrects,
-- and never blanks.
--
-- The note is the eighth, added at db/098. It was left out until then, on the
-- reasoning that it is written when a session is reviewed rather than by a
-- script -- which is true of where it comes from and wrong about where it goes.
-- The note on a bill stopped before Royal Assent in Session 5 ends "it could
-- not be submitted for Royal Assent in its unamended form", and Session 6 is
-- where two such bills were reconsidered and became Acts. Leaving it out would
-- have written each Act's title, number and Royal Assent date onto the bill and
-- left that sentence standing beside them. It is still written when a session
-- is reviewed: this carries what the review wrote. The error checker asks for a
-- note on any line continuing a bill that has one, so an empty note here is a
-- decision and not an oversight.
--
-- What each changed cell used to say is captured first, so that the provenance
-- note below can say what it read before.
CREATE TEMP TABLE continuing_changes ON COMMIT DROP AS
SELECT c.candidate_id, c.target_bill_id, x.field_name, x.was, x.reads_now
  FROM continuing c
  JOIN bill b ON b.bill_id = c.target_bill_id
  CROSS JOIN LATERAL (VALUES
      ('short_title',          b.short_title,              c.short_title),
      ('asp_number',           b.asp_number,               c.asp_number),
      ('enactment_status',     b.enactment_status,         c.enactment_status),
      ('date_royal_assent',    b.date_royal_assent::text,  c.date_royal_assent::text),
      ('date_concluded',       b.date_concluded::text,     c.date_concluded::text),
      ('assent_block_route',   b.assent_block_route,       c.assent_block_route),
      ('assent_block_outcome', b.assent_block_outcome,     c.assent_block_outcome),
      ('note',                 b.note,                     c.bill_note)
  ) AS x(field_name, was, reads_now)
 WHERE x.reads_now IS NOT NULL
   AND x.reads_now IS DISTINCT FROM x.was;

UPDATE bill b
   SET short_title          = coalesce(c.short_title,          b.short_title),
       asp_number           = coalesce(c.asp_number,           b.asp_number),
       enactment_status     = coalesce(c.enactment_status,     b.enactment_status),
       date_royal_assent    = coalesce(c.date_royal_assent,    b.date_royal_assent),
       date_concluded       = coalesce(c.date_concluded,       b.date_concluded),
       assent_block_route   = coalesce(c.assent_block_route,   b.assent_block_route),
       assent_block_outcome = coalesce(c.assent_block_outcome, b.assent_block_outcome),
       note                 = coalesce(c.bill_note,           b.note),
       updated_at           = now()
  FROM continuing c
 WHERE b.bill_id = c.target_bill_id;

-- ---------------------------------------------------------------------------
-- The stages each bill reached
-- ---------------------------------------------------------------------------

-- Each row carries its own source, reference and date read, so stage dates
-- need no provenance notes. The stage name was checked against the bill type
-- by the error checker, and the trigger on stage_event checks it again.
--
-- date_reached, added at db/088, is the day the bill reached the stage where a
-- source states one. It is empty on every stage but the Reconsideration Stage,
-- and it travels with the row like every other cell on it.
INSERT INTO stage_event (bill_id, stage, stage_order, date_reached, date_completed,
                         completed, fell_here, did_not_happen, source, source_ref,
                         observed_at, detail_note)
SELECT s.target_bill_id, s.stage, s.stage_order, s.date_reached, s.date_completed,
       s.completed, s.fell_here, s.did_not_happen, s.source, s.source_ref,
       s.observed_at, s.detail_note
  FROM promoting_stages s
 ORDER BY s.target_bill_id, s.stage_order;

-- ---------------------------------------------------------------------------
-- Where individual facts came from, when it was not the row's own source
-- ---------------------------------------------------------------------------

-- A title corrected by hand at review.
INSERT INTO field_source (entity, entity_id, field_name, source, source_ref,
                          value_seen, observed_at, note)
SELECT 'bill', p.candidate_id, 'short_title', 'manual',
       'review of staging line ' || p.candidate_id,
       p.short_title, p.observed_at,
       -- Not the review note: bill 17's ends with an instruction to whoever
       -- wrote this script, which db/027 had to take out of a note once.
       -- The fact sheet's words go in the note itself, because the staging
       -- column that keeps them is not published (db/115).
       'Corrected at review. The fact sheet printed it as: ' || p.raw_title
  FROM promoting p
 WHERE p.review_note ILIKE '%short_title corrected at review%'
   AND NOT EXISTS (SELECT 1 FROM field_source f
                    WHERE f.entity = 'bill' AND f.entity_id = p.candidate_id
                      AND f.field_name = 'short_title');

-- An outcome read out of the Official Report rather than off the factsheet.
-- The review note is the outcome in words, then the link to the decision, then
-- optionally our own commentary (from Session 2: the route to the vote, and our
-- view of which limb of Rule 9.14.18 applied). Only the words before the first
-- link are the value seen; everything from the link on is cut, so our
-- commentary never reaches a provenance note.
--
-- The cut takes "Read at" with it. That phrase exists only to introduce the
-- address, so cutting the address and leaving the phrase ended eight notes
-- mid-sentence, in Sessions 4 and 5, in text a reader sees. Found on
-- 2026-09-14 while the owner was signing Session 5 off; see DECISIONS.md.
INSERT INTO field_source (entity, entity_id, field_name, source, source_ref,
                          value_seen, observed_at)
SELECT 'bill', p.candidate_id, 'outcome', 'official_report',
       substring(p.review_note from 'https?://\S+'),
       regexp_replace(
         regexp_replace(p.review_note, '^Outcome from the Official Report, not the factsheet:\s*', ''),
         '\s*(Read at\s*)?https?://.*$', ''),
       p.official_report_read_on
  FROM promoting p
 WHERE p.review_note ILIKE 'Outcome from the Official Report%'
   AND NOT EXISTS (SELECT 1 FROM field_source f
                    WHERE f.entity = 'bill' AND f.entity_id = p.candidate_id
                      AND f.field_name = 'outcome');

-- A bill that passed and was stopped before Royal Assent. The fact sheet says
-- so in a footnote against the row, not in the row, so the words a reader would
-- have to be shown are not in any cell the clean sheet carries: bill.note says
-- what stopped the bill in our words, and this is where the fact sheet's own
-- words are kept. One note for the status and, where the footnote gives a date,
-- one for the date. See methodology note M5.
INSERT INTO field_source (entity, entity_id, field_name, source, source_ref,
                          value_seen, observed_at)
SELECT 'bill', p.candidate_id, 'enactment_status', p.source, p.source_ref,
       p.raw_footnote, p.observed_at
  FROM promoting p
 WHERE p.enactment_status = 'blocked'
   AND coalesce(btrim(p.raw_footnote), '') <> ''
   AND NOT EXISTS (SELECT 1 FROM field_source f
                    WHERE f.entity = 'bill' AND f.entity_id = p.candidate_id
                      AND f.field_name = 'enactment_status');

-- Not where the date was checked against another source at review: then the
-- footnote did not give it, and crediting the fact sheet with a date it does
-- not print is the fault db/105 found. The "Checked:" route below writes that
-- note instead, citing the source that does give it.
INSERT INTO field_source (entity, entity_id, field_name, source, source_ref,
                          value_seen, observed_at)
SELECT 'bill', p.candidate_id, 'date_assent_blocked', p.source, p.source_ref,
       p.raw_footnote, p.observed_at
  FROM promoting p
 WHERE p.date_assent_blocked IS NOT NULL
   AND coalesce(btrim(p.raw_footnote), '') <> ''
   AND coalesce(p.review_note, '') !~ 'Checked: date_assent_blocked = '
   AND NOT EXISTS (SELECT 1 FROM field_source f
                    WHERE f.entity = 'bill' AND f.entity_id = p.candidate_id
                      AND f.field_name = 'date_assent_blocked');

-- How a bill that passed came to be stopped before Royal Assent, and what
-- followed. Both are read from the same footnote as the enactment status, and
-- the footnote is kept here in the fact sheet's own words. The route is put on
-- its own cell rather than left to enactment_status because enactment_status
-- moves on when the bill does -- a reconsidered bill becomes an enacted Act --
-- and this must not move with it. See db/080 and methodology note M5.
INSERT INTO field_source (entity, entity_id, field_name, source, source_ref,
                          value_seen, observed_at)
SELECT 'bill', p.candidate_id, f.field_name, p.source, p.source_ref,
       p.raw_footnote, p.observed_at
  FROM promoting p
  CROSS JOIN LATERAL (VALUES ('assent_block_route'), ('assent_block_outcome'))
       AS f(field_name)
 WHERE p.assent_block_outcome IS NOT NULL
   AND coalesce(btrim(p.raw_footnote), '') <> ''
   AND NOT EXISTS (SELECT 1 FROM field_source g
                    WHERE g.entity = 'bill' AND g.entity_id = p.candidate_id
                      AND g.field_name = f.field_name);

-- How the bill was handled under the Parliament's rules, and the day the
-- Parliament agreed to handle it that way. Both are read from a sentence the
-- Session 6 and 7 fact sheets print against the bill -- "Motion agreed to
-- treat as Emergency Bill on 22 June 2021" -- and no fact sheet for Sessions 1
-- to 5 mentions procedure at all, so these notes exist only where a source
-- actually said something. What is kept is the value as read, which is what
-- value_seen holds for bill_type, asp_number and date_introduced; the fact
-- sheet's own sentence is on the staging line, in parser_note. There is no
-- cell for the sentence because it carries nothing the two values do not. See
-- db/087 and methodology note M10.
INSERT INTO field_source (entity, entity_id, field_name, source, source_ref,
                          value_seen, observed_at)
SELECT 'bill', p.candidate_id, 'procedure', p.source, p.source_ref,
       p.procedure, p.observed_at
  FROM promoting p
 WHERE p.procedure IS NOT NULL
   AND NOT EXISTS (SELECT 1 FROM field_source f
                    WHERE f.entity = 'bill' AND f.entity_id = p.candidate_id
                      AND f.field_name = 'procedure');

INSERT INTO field_source (entity, entity_id, field_name, source, source_ref,
                          value_seen, observed_at)
SELECT 'bill', p.candidate_id, 'date_procedure_agreed', p.source, p.source_ref,
       p.date_procedure_agreed::text, p.observed_at
  FROM promoting p
 WHERE p.date_procedure_agreed IS NOT NULL
   AND NOT EXISTS (SELECT 1 FROM field_source f
                    WHERE f.entity = 'bill' AND f.entity_id = p.candidate_id
                      AND f.field_name = 'date_procedure_agreed');

-- How a bill came to be rejected at Stage 1, read from the Official Report. The
-- value seen is the Presiding Officer's announcement, word for word, which is
-- what tells the three routes apart; the review note carries it in the fixed
-- form Result as recorded: "…". The reference is the same link as the outcome's.
INSERT INTO field_source (entity, entity_id, field_name, source, source_ref,
                          value_seen, observed_at)
SELECT 'bill', p.candidate_id, 'stage_1_rejection_route', 'official_report',
       substring(p.review_note from 'https?://\S+'),
       substring(p.review_note from 'Result as recorded: "([^"]+)"'),
       p.official_report_read_on
  FROM promoting p
 WHERE p.stage_1_rejection_route IS NOT NULL
   AND NOT EXISTS (SELECT 1 FROM field_source f
                    WHERE f.entity = 'bill' AND f.entity_id = p.candidate_id
                      AND f.field_name = 'stage_1_rejection_route');

-- Why a bill is coded as having fallen at dissolution. No factsheet says why a
-- bill fell; this coding is ours, from two recorded dates -- the day the bill
-- concluded, off the legislation factsheet, and the day the session ended, off
-- the dates factsheet. The note cites the same document, page and reading date
-- as the session's own date_session_end note, so the two cannot drift apart.
-- value_seen is empty because no source printed these words: the rule is the
-- note, and M7 states it. Before 2026-09-12 these bills carried no note at all.
INSERT INTO field_source (entity, entity_id, field_name, source, source_ref,
                          value_seen, observed_at, note)
SELECT 'bill', p.candidate_id, 'outcome', f.source, f.source_ref,
       NULL, f.observed_at,
       -- It names the published heading, not the working column (db/115).
       'Our coding, not the fact sheet''s: the legislation fact sheet says the '
       'bill fell, and not why. Coded as having fallen at dissolution because it '
       'concluded on ' || p.date_concluded || ', the day Session '
       || p.session_number || ' ended. That day is date_session_ended in the '
       'sessions file, from the source cited here. See methodology note M7.'
  FROM promoting p
  JOIN field_source f ON f.entity = 'session' AND f.entity_id = p.session_number
                     AND f.field_name = 'date_session_end'
 WHERE p.outcome = 'fell_dissolution'
   AND NOT EXISTS (SELECT 1 FROM field_source g
                    WHERE g.entity = 'bill' AND g.entity_id = p.candidate_id
                      AND g.field_name = 'outcome');

-- A date checked at review against the source that owns it: Royal Assent from
-- legislation.gov.uk, any other date from the Parliament's own pages. The
-- review note carries one line per check, in the fixed form
--   Checked: <column> = <value> (<source>, <address>, <date read>)
-- The value is usually a date, and need not be: a bill type settled between two
-- sources is cited the same way (db/045).
-- and the error checker refuses a date that differs from the factsheet's own
-- words without one (db/042). A line can carry more than one check, so every
-- match is read, not just the first. Confirmed and corrected dates alike get a
-- note: what it records is that somebody looked, which is what tells a checked
-- date from one nobody has checked. See DECISIONS.md, 2026-09-12, and M8.
INSERT INTO field_source (entity, entity_id, field_name, source, source_ref,
                          value_seen, observed_at, note)
SELECT 'bill', p.candidate_id, m[1], m[3], m[4], m[2], m[5]::date,
       -- Not a pointer to the raw_ columns: they are not published (db/115).
       'Checked at review against the source named on this line, which is '
       'the one that settles this fact. Where the fact sheet printed it '
       'differently, this line''s value is the one used.'
  FROM promoting p
  CROSS JOIN LATERAL regexp_matches(
        coalesce(p.review_note, ''),
        'Checked: ([a-z0-9_]+) = ([^\n]+?) \(([a-z_]+), ([^,]+), (\d{4}-\d{2}-\d{2})\)',
        'g') AS m
 WHERE NOT EXISTS (SELECT 1 FROM field_source f
                    WHERE f.entity = 'bill' AND f.entity_id = p.candidate_id
                      AND f.field_name = m[1]);

-- ---------------------------------------------------------------------------
-- Stamp the staging lines and the stage-dates rows
-- ---------------------------------------------------------------------------

-- A line that made a bill is stamped with its own number, because a bill's
-- number is its staging line's (db/026). A line that added to a bill already
-- there is stamped with that bill's number, which is how a re-run knows it has
-- nothing left to do and how rollback finds it again.
-- A continuing line also records how many cells of that bill it changed, which
-- is what tells rollback whether the bill can be left alone when this session
-- comes off (db/103). It is written here, in the same statement as the stamp,
-- because this is the last moment continuing_changes still says what the cells
-- read before they were written over.
UPDATE bill_candidate c
   SET promoted_bill_id = p.target_bill_id,
       promoted_at      = now(),
       continued_bill_cells_changed =
         CASE WHEN c.continues_bill_id IS NULL THEN NULL
              ELSE (SELECT count(*) FROM continuing_changes ch
                     WHERE ch.candidate_id = c.candidate_id)
         END
  FROM promoting_all p
 WHERE c.candidate_id = p.candidate_id;

-- What a further appearance changed, and what it read before. One note per
-- changed cell, replacing whatever the earlier fact sheet left there, so a
-- reader always sees the provenance of the value in front of them. The
-- footnote that explains the block is not lost with it: it sits on
-- assent_block_route, which a later fact sheet never changes.
DELETE FROM field_source f
 USING continuing_changes ch
 WHERE f.entity = 'bill' AND f.entity_id = ch.target_bill_id
   AND f.field_name = ch.field_name;

CREATE TEMP TABLE continuing_labels ON COMMIT DROP AS
SELECT 'enactment_status' AS field_name, code, label FROM ref_enactment_status
UNION ALL SELECT 'assent_block_route',   code, label FROM ref_assent_block_route
UNION ALL SELECT 'assent_block_outcome', code, label FROM ref_assent_block_outcome;

-- The quotes around what it read are written out rather than made by
-- quote_literal, which doubles an apostrophe for SQL and put "Parliament''s"
-- in front of a reader (db/115).
INSERT INTO field_source (entity, entity_id, field_name, source, source_ref,
                          value_seen, observed_at, note)
SELECT 'bill', ch.target_bill_id, ch.field_name,
       -- The note is written by us at review, so it is not attributed to the
       -- fact sheet the rest of the line was read off (db/098). All three of
       -- source, source_ref and observed_at have to move together, or the row
       -- says it was written by hand and then cites a document and a date it
       -- was never in -- which is what db/098 left and db/101 mended.
       CASE WHEN ch.field_name = 'note' THEN 'manual' ELSE c.source END,
       CASE WHEN ch.field_name = 'note'
            THEN 'written at review of session ' || c.session_number
            ELSE c.source_ref END,
       CASE WHEN ch.field_name = 'short_title' THEN c.raw_title END,
       -- The day the note was written is the day the line was reviewed, taken
       -- from the line itself so no future session has to remember (db/101).
       CASE WHEN ch.field_name = 'note' THEN c.reviewed_at::date
            ELSE c.observed_at END,
       CASE WHEN ch.field_name = 'note'
            -- The note is in our own words, not the fact sheet's, so its
            -- provenance says who wrote it and when rather than claiming it was
            -- read off a sheet. What it said before is kept here, which is the
            -- whole reason this row exists (db/098).
            THEN 'Rewritten when Session ' || c.session_number || ' was reviewed, '
                 || 'because that fact sheet lists this bill again and changed what '
                 || 'the note had to say. It read '
                 || coalesce('''' || ch.was || '''', 'nothing') || ' and now reads '
                 || '''' || ch.reads_now || ''''
                 || '. The facts it states carry their own entries here. The bill '
                 || 'belongs to Session ' || b.session_number
                 || ', the session it was introduced in. See methodology note M6.'
            ELSE 'Read off the Session ' || c.session_number || ' fact sheet, which lists '
                 || 'this bill again because it was still live when Session '
                 || b.session_number || ' ended. It read '
                 || coalesce('''' || coalesce(lw.label, ch.was) || '''', 'nothing')
                 || ' and now reads '
                 || '''' || coalesce(ln.label, ch.reads_now) || ''''
                 || '. The bill belongs to Session ' || b.session_number
                 || ', the session it was introduced in. See methodology note M6.'
       END
  FROM continuing_changes ch
  JOIN continuing c ON c.candidate_id = ch.candidate_id
  JOIN bill b ON b.bill_id = ch.target_bill_id
  -- A coded cell is quoted as the word a reader sees in it, not the stored
  -- code: 'Still blocked', not 'still_blocked' (db/115).
  LEFT JOIN continuing_labels lw ON lw.field_name = ch.field_name AND lw.code = ch.was
  LEFT JOIN continuing_labels ln ON ln.field_name = ch.field_name AND ln.code = ch.reads_now;

UPDATE stage_candidate t
   SET promoted_stage_event_id = e.stage_event_id,
       promoted_at             = now()
  FROM promoting_stages s
  JOIN stage_event e ON e.bill_id = s.target_bill_id AND e.stage_order = s.stage_order
 WHERE t.stage_candidate_id = s.stage_candidate_id;

-- The same for a stage date checked at review. It hangs off the stage record
-- rather than the bill, so it is written after the stamping above, which is
-- what gives the stage record its number.
INSERT INTO field_source (entity, entity_id, field_name, source, source_ref,
                          value_seen, observed_at, note)
SELECT 'stage_event', t.promoted_stage_event_id, m[1], m[3], m[4], m[2], m[5]::date,
       -- Not a pointer to the raw_ columns: they are not published (db/115).
       'Checked at review against the source named on this line, which is '
       'the one that settles this fact. Where the fact sheet printed it '
       'differently, this line''s value is the one used.'
  FROM stage_candidate t
  JOIN promoting_all p ON p.candidate_id = t.candidate_id
  CROSS JOIN LATERAL regexp_matches(
        coalesce(t.review_note, ''),
        'Checked: ([a-z0-9_]+) = ([^\n]+?) \(([a-z_]+), ([^,]+), (\d{4}-\d{2}-\d{2})\)',
        'g') AS m
 WHERE t.promoted_stage_event_id IS NOT NULL
   AND NOT EXISTS (SELECT 1 FROM field_source f
                    WHERE f.entity = 'stage_event'
                      AND f.entity_id = t.promoted_stage_event_id
                      AND f.field_name = m[1]);

-- What the rule says should be on the clean sheet for the whole session,
-- including bills promoted in an earlier run, for the checks below.
CREATE TEMP TABLE carried_stages ON COMMIT DROP AS
SELECT DISTINCT ON (t.candidate_id, t.stage_order) t.*
  FROM stage_candidate t
  JOIN bill b ON b.bill_id = t.candidate_id
  JOIN promote_arg a ON a.session_number = b.session_number
  LEFT JOIN stage_source_rank r ON r.source = t.source
 WHERE t.review_status = 'accepted'
 ORDER BY t.candidate_id, t.stage_order, r.rank;

-- ---------------------------------------------------------------------------
-- Checks. Any failure aborts, and nothing is written.
-- ---------------------------------------------------------------------------

DO $$
DECLARE
  s   integer;
  n   integer;
  bad text;
BEGIN
  SELECT session_number INTO s FROM promote_arg;

  -- Every accepted line is now promoted.
  SELECT count(*) INTO n FROM bill_candidate
   WHERE session_number = s AND review_status = 'accepted' AND promoted_bill_id IS NULL;
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % accepted line(s) were not promoted.', n; END IF;

  -- One bill per accepted line that was a bill in its own right, and no
  -- others. A line that is a further appearance of an earlier bill makes
  -- nothing, which is the whole point of it, so it is not counted here.
  SELECT count(*) INTO n FROM bill WHERE session_number = s;
  IF n <> (SELECT count(*) FROM bill_candidate
            WHERE session_number = s AND review_status = 'accepted'
              AND continues_bill_id IS NULL)
  THEN RAISE EXCEPTION 'Check failed: % bills on the clean sheet, % accepted lines that are bills of their own.',
       n, (SELECT count(*) FROM bill_candidate WHERE session_number = s
            AND review_status = 'accepted' AND continues_bill_id IS NULL);
  END IF;

  -- Every bill says the same as the line it came from.
  SELECT string_agg(b.bill_id::text, ', ') INTO bad
    FROM bill b JOIN bill_candidate c ON c.candidate_id = b.bill_id
   WHERE b.session_number = s
     AND (b.short_title       IS DISTINCT FROM c.short_title
       OR b.bill_type         IS DISTINCT FROM c.bill_type
       OR b.outcome           IS DISTINCT FROM c.outcome
       OR b.enactment_status  IS DISTINCT FROM c.enactment_status
       OR b.date_introduced   IS DISTINCT FROM c.date_introduced
       OR b.date_royal_assent IS DISTINCT FROM c.date_royal_assent
       OR b.date_concluded    IS DISTINCT FROM c.date_concluded
       OR b.date_assent_blocked IS DISTINCT FROM c.date_assent_blocked
       OR b.asp_number        IS DISTINCT FROM c.asp_number
       OR b.sp_bill_id        IS DISTINCT FROM c.sp_bill_id
       OR b.bill_type_stated  IS DISTINCT FROM c.bill_type_stated
       OR b.title_as_introduced IS DISTINCT FROM c.title_as_introduced
       OR b.title_changed_at_stage IS DISTINCT FROM c.title_changed_at_stage
       OR b.stage_1_rejection_route IS DISTINCT FROM c.stage_1_rejection_route
       OR b.procedure         IS DISTINCT FROM c.procedure
       OR b.date_procedure_agreed IS DISTINCT FROM c.date_procedure_agreed
       OR b.assent_block_route      IS DISTINCT FROM c.assent_block_route
       OR b.assent_block_outcome    IS DISTINCT FROM c.assent_block_outcome
       OR b.reintroduced_from_bill_id IS DISTINCT FROM c.reintroduced_from_bill_id
       OR b.note              IS DISTINCT FROM c.bill_note);
  IF bad IS NOT NULL THEN RAISE EXCEPTION 'Check failed: bill(s) % differ from their staging line.', bad; END IF;

  -- A bill that says how it was handled says who said so. Added at db/087:
  -- the value is read off a fact sheet sentence that is kept nowhere else on
  -- the clean sheet, so without the note there is nothing behind the cell.
  SELECT string_agg(b.bill_id::text, ', ') INTO bad
    FROM bill b
   WHERE b.session_number = s
     AND b.procedure IS NOT NULL
     AND NOT EXISTS (SELECT 1 FROM field_source f
                      WHERE f.entity = 'bill' AND f.entity_id = b.bill_id
                        AND f.field_name = 'procedure');
  IF bad IS NOT NULL THEN RAISE EXCEPTION 'Check failed: bill(s) % say how they were handled with nothing recording where that came from.', bad; END IF;

  SELECT string_agg(b.bill_id::text, ', ') INTO bad
    FROM bill b
   WHERE b.session_number = s
     AND b.date_procedure_agreed IS NOT NULL
     AND NOT EXISTS (SELECT 1 FROM field_source f
                      WHERE f.entity = 'bill' AND f.entity_id = b.bill_id
                        AND f.field_name = 'date_procedure_agreed');
  IF bad IS NOT NULL THEN RAISE EXCEPTION 'Check failed: bill(s) % date the agreeing of a procedure with nothing recording where that came from.', bad; END IF;

  -- Every bill's stage records are exactly the stage-dates rows carried for
  -- it: one per stage, field by field, and none without one.
  SELECT count(*) INTO n
    FROM carried_stages k
    FULL JOIN (SELECT e.* FROM stage_event e JOIN bill b USING (bill_id)
                WHERE b.session_number = s) e
      ON e.bill_id = k.candidate_id AND e.stage_order = k.stage_order
   WHERE k.candidate_id IS NULL OR e.bill_id IS NULL
      OR e.stage          IS DISTINCT FROM k.stage
      OR e.date_completed IS DISTINCT FROM k.date_completed
      OR e.completed      IS DISTINCT FROM k.completed
      OR e.fell_here      IS DISTINCT FROM k.fell_here
      OR e.source         IS DISTINCT FROM k.source
      OR e.source_ref     IS DISTINCT FROM k.source_ref
      OR e.observed_at    IS DISTINCT FROM k.observed_at
      OR e.detail_note    IS DISTINCT FROM k.detail_note;
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % stage record(s) do not match the stage-dates rows they come from.', n; END IF;

  -- Every row carried is stamped with its own record, and no other row in the
  -- session is stamped. Asked of the lines that became bills: a continuing
  -- line's rows are stamped with a record on a bill of an earlier session, and
  -- some of its rows are deliberately not carried at all, so both halves of
  -- this would be false of it. They are checked separately below.
  SELECT count(*) INTO n
    FROM stage_candidate t
    JOIN bill_candidate c USING (candidate_id)
    LEFT JOIN carried_stages k ON k.stage_candidate_id = t.stage_candidate_id
    LEFT JOIN stage_event e ON e.stage_event_id = t.promoted_stage_event_id
   WHERE c.session_number = s AND c.continues_bill_id IS NULL
     AND ((k.stage_candidate_id IS NOT NULL) <> (t.promoted_stage_event_id IS NOT NULL)
          OR e.bill_id <> t.candidate_id OR e.stage_order <> t.stage_order);
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % stage-dates row(s) stamped wrongly.', n; END IF;

  -- Every bill that passed has a final stage record.
  SELECT count(*) INTO n FROM bill b
   WHERE b.session_number = s AND b.outcome = 'passed'
     AND NOT EXISTS (SELECT 1 FROM stage_event e
                      WHERE e.bill_id = b.bill_id AND e.stage_order = 3 AND e.completed);
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % bill(s) that passed have no final stage record.', n; END IF;

  -- No bill ended in two places.
  SELECT count(*) INTO n FROM (
    SELECT bill_id FROM stage_event WHERE fell_here GROUP BY bill_id HAVING count(*) > 1) x;
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % bill(s) end at more than one stage.', n; END IF;

  -- One provenance note per fact.
  SELECT count(*) INTO n FROM (
    SELECT entity, entity_id, field_name FROM field_source
     GROUP BY 1,2,3 HAVING count(*) > 1) x;
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % fact(s) have more than one provenance note.', n; END IF;

  -- Every route has a provenance note quoting the announcement, dated by when
  -- the Official Report was read.
  SELECT count(*) INTO n
    FROM bill b JOIN bill_candidate c ON c.candidate_id = b.bill_id
   WHERE b.session_number = s AND b.stage_1_rejection_route IS NOT NULL
     AND NOT EXISTS (SELECT 1 FROM field_source f
                      WHERE f.entity = 'bill' AND f.entity_id = b.bill_id
                        AND f.field_name = 'stage_1_rejection_route'
                        AND f.observed_at = c.official_report_read_on
                        AND f.value_seen IS NOT NULL AND f.source_ref IS NOT NULL);
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % route(s) without a provenance note quoting the announcement.', n; END IF;

  -- The general note on a stage row says the bill stopped there without a
  -- decision. Nobody types it -- the clean sheet works it out from the row --
  -- so the one thing that could make it false is a bill it speaks for that did
  -- not stop that way. See db/061.
  SELECT count(*) INTO n
    FROM stage_event e JOIN bill b USING (bill_id)
   WHERE b.session_number = s AND e.general_note IS NOT NULL
     AND b.outcome NOT IN ('withdrawn', 'fell_dissolution');
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % stage row(s) carry the general note for a bill that was neither withdrawn nor fell at dissolution.', n; END IF;

  -- Every bill coded as having fallen at dissolution carries the note saying so,
  -- dated by the reading of the source the session's last day came from. A
  -- coding of ours with nothing recording that it is ours is the thing this
  -- whole change exists to stop, so promotion refuses rather than warns.
  SELECT count(*) INTO n
    FROM bill b JOIN session ss ON ss.session_number = b.session_number
   WHERE b.session_number = s AND b.outcome = 'fell_dissolution'
     AND NOT EXISTS (SELECT 1 FROM field_source f
                      WHERE f.entity = 'bill' AND f.entity_id = b.bill_id
                        AND f.field_name = 'outcome'
                        AND f.note LIKE '%fallen at dissolution%'
                        AND f.source_ref IS NOT NULL);
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % bill(s) coded as having fallen at dissolution without the note saying it is our coding.', n; END IF;

  -- The day each of them concluded is the day its session ended. The error
  -- checker says this of a staging line; this says it of the clean sheet.
  SELECT count(*) INTO n
    FROM bill b JOIN session ss ON ss.session_number = b.session_number
   WHERE b.session_number = s AND b.outcome = 'fell_dissolution'
     AND b.date_concluded IS DISTINCT FROM ss.date_session_end;
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % bill(s) fell at dissolution on a day that is not their session''s last.', n; END IF;

  -- ------------------------------------------------------------------------
  -- The bills this session added to rather than made
  -- ------------------------------------------------------------------------

  -- Every one of them is stamped with the bill it added to, and that bill is
  -- still the bill it was: same session, same introduction date, same type.
  SELECT count(*) INTO n
    FROM bill_candidate c JOIN bill b ON b.bill_id = c.continues_bill_id
   WHERE c.session_number = s AND c.review_status = 'accepted'
     AND (c.promoted_bill_id IS DISTINCT FROM c.continues_bill_id
       OR c.promoted_at IS NULL
       OR b.session_number   >= c.session_number
       OR b.date_introduced  IS DISTINCT FROM c.date_introduced
       OR b.bill_type        IS DISTINCT FROM c.bill_type);
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % continuing line(s) are not stamped, or changed what their bill is.', n; END IF;

  -- No continuing line made a bill.
  SELECT count(*) INTO n FROM bill b
    JOIN bill_candidate c ON c.candidate_id = b.bill_id
   WHERE c.continues_bill_id IS NOT NULL;
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % continuing line(s) became bills of their own.', n; END IF;

  -- Each of the eight cells a further appearance may change now reads what
  -- that line says, where the line says anything. The note joined them at
  -- db/098.
  SELECT string_agg(DISTINCT b.bill_id::text, ', ') INTO bad
    FROM bill_candidate c JOIN bill b ON b.bill_id = c.continues_bill_id
   WHERE c.session_number = s AND c.review_status = 'accepted'
     AND ((c.short_title          IS NOT NULL AND b.short_title          IS DISTINCT FROM c.short_title)
       OR (c.asp_number           IS NOT NULL AND b.asp_number           IS DISTINCT FROM c.asp_number)
       OR (c.enactment_status     IS NOT NULL AND b.enactment_status     IS DISTINCT FROM c.enactment_status)
       OR (c.date_royal_assent    IS NOT NULL AND b.date_royal_assent    IS DISTINCT FROM c.date_royal_assent)
       OR (c.date_concluded       IS NOT NULL AND b.date_concluded       IS DISTINCT FROM c.date_concluded)
       OR (c.assent_block_route   IS NOT NULL AND b.assent_block_route   IS DISTINCT FROM c.assent_block_route)
       OR (c.assent_block_outcome IS NOT NULL AND b.assent_block_outcome IS DISTINCT FROM c.assent_block_outcome)
       OR (c.bill_note            IS NOT NULL AND b.note                 IS DISTINCT FROM c.bill_note));
  IF bad IS NOT NULL THEN RAISE EXCEPTION 'Check failed: bill(s) % do not say what the line continuing them says.', bad; END IF;

  -- Every stage a continuing line carried is on its bill, and nothing it
  -- restated overwrote a stage that was already there.
  SELECT count(*) INTO n
    FROM stage_candidate t
    JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number = s AND c.continues_bill_id IS NOT NULL
     AND t.review_status = 'accepted'
     AND t.promoted_stage_event_id IS NOT NULL
     AND NOT EXISTS (SELECT 1 FROM stage_event e
                      WHERE e.stage_event_id = t.promoted_stage_event_id
                        AND e.bill_id = c.continues_bill_id
                        AND e.stage_order = t.stage_order
                        AND e.date_completed IS NOT DISTINCT FROM t.date_completed);
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % stage(s) from a continuing line are not on the bill they belong to.', n; END IF;

  -- And every accepted row it did NOT carry is one the bill already had, at
  -- the same position. That is the only reason a row may be left behind.
  SELECT count(*) INTO n
    FROM stage_candidate t
    JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number = s AND c.continues_bill_id IS NOT NULL
     AND t.review_status = 'accepted'
     AND t.promoted_stage_event_id IS NULL
     AND NOT EXISTS (SELECT 1 FROM stage_event e
                      WHERE e.bill_id = c.continues_bill_id
                        AND e.stage_order = t.stage_order);
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % accepted stage(s) from a continuing line were neither carried nor already on the bill.', n; END IF;

  -- Every continuing line records how many cells it changed, and the number is
  -- the number of changes there actually were (db/103). Rollback deletes a bill
  -- or spares it on the strength of this, so it is checked here rather than
  -- trusted.
  -- Only the lines this run promoted: a re-run finds nothing to promote, and
  -- continuing_changes is then empty for lines that were promoted earlier.
  SELECT string_agg(DISTINCT c.candidate_id::text, ', ') INTO bad
    FROM continuing cn JOIN bill_candidate c ON c.candidate_id = cn.candidate_id
   WHERE c.continued_bill_cells_changed IS DISTINCT FROM
         (SELECT count(*) FROM continuing_changes ch WHERE ch.candidate_id = c.candidate_id);
  IF bad IS NOT NULL THEN RAISE EXCEPTION 'Check failed: line(s) % do not record how many cells they changed.', bad; END IF;

  SELECT count(*) INTO n FROM bill_candidate c
   WHERE c.session_number = s AND c.continues_bill_id IS NULL
     AND c.continued_bill_cells_changed IS NOT NULL;
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % line(s) continue nothing and carry a count of changed cells.', n; END IF;

  -- Every changed cell carries a provenance note from the fact sheet that
  -- changed it, and nothing changed without one.
  SELECT count(*) INTO n
    FROM continuing_changes ch
   WHERE NOT EXISTS (SELECT 1 FROM field_source f
                      WHERE f.entity = 'bill' AND f.entity_id = ch.target_bill_id
                        AND f.field_name = ch.field_name
                        AND f.note LIKE '%lists this bill again%');
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % changed cell(s) have no note saying which fact sheet changed them.', n; END IF;

  -- A bill that was ever stopped before Royal Assent still says so, however
  -- far it has since got. This is the whole reason the two cells exist.
  SELECT count(*) INTO n
    FROM bill b JOIN bill_candidate c ON c.continues_bill_id = b.bill_id
   WHERE c.session_number = s
     AND b.assent_block_outcome IS NULL
     AND EXISTS (SELECT 1 FROM field_source f
                  WHERE f.entity = 'bill' AND f.entity_id = b.bill_id
                    AND f.field_name = 'assent_block_route');
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % bill(s) lost the record that they were stopped before Royal Assent.', n; END IF;

  RAISE NOTICE 'All checks passed.';
END $$;

-- ---------------------------------------------------------------------------
-- What you are being asked to keep
-- ---------------------------------------------------------------------------

\echo ''
\echo '--- Bills by type and outcome (compare with the factsheet''s own summary)'
SELECT b.bill_type, b.outcome, count(*)
  FROM bill b JOIN promote_arg a USING (session_number)
 GROUP BY 1,2 ORDER BY 1,2;

\echo '--- Totals by type'
SELECT b.bill_type, count(*)
  FROM bill b JOIN promote_arg a USING (session_number) GROUP BY 1 ORDER BY 1;

\echo '--- Totals by outcome'
SELECT b.outcome, count(*)
  FROM bill b JOIN promote_arg a USING (session_number) GROUP BY 1 ORDER BY 1;

\echo '--- Stage rows written'
SELECT e.stage, e.stage_order, e.completed, e.fell_here, e.source, count(*)
  FROM stage_event e JOIN bill b USING (bill_id) JOIN promote_arg a USING (session_number)
 GROUP BY 1,2,3,4,5 ORDER BY 2,1,5;

\echo '--- Accepted stage dates not carried, because a more primary source gave the same stage'
SELECT t.candidate_id, t.stage, t.source, t.date_completed, k.source AS carried_instead
  FROM stage_candidate t
  JOIN carried_stages k ON k.candidate_id = t.candidate_id AND k.stage_order = t.stage_order
 WHERE t.review_status = 'accepted' AND t.stage_candidate_id <> k.stage_candidate_id
 ORDER BY 1, t.stage_order;

\echo '--- Bills rejected at Stage 1: route, and the start of any note a reader will see'
SELECT b.bill_id, left(b.short_title, 45) AS short_title, b.stage_1_rejection_route,
       left(b.note, 70) AS note
  FROM bill b JOIN promote_arg a USING (session_number)
 WHERE b.stage_1_rejection_route IS NOT NULL
 ORDER BY b.bill_id;

\echo '--- Bills this session added to rather than made, and what changed'
SELECT ch.target_bill_id AS bill_id, left(b.short_title, 45) AS short_title,
       ch.field_name, coalesce(ch.was, '(empty)') AS was, ch.reads_now
  FROM continuing_changes ch JOIN bill b ON b.bill_id = ch.target_bill_id
 ORDER BY 1, 3;

\echo '--- Stages added to a bill this session added to'
SELECT c.continues_bill_id AS bill_id, t.stage, t.date_completed, t.source,
       left(t.detail_note, 60) AS detail_note
  FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
  JOIN promote_arg a ON a.session_number = c.session_number
 WHERE c.continues_bill_id IS NOT NULL AND t.promoted_stage_event_id IS NOT NULL
 ORDER BY 1, t.stage_order;

\echo '--- Provenance notes written'
SELECT f.entity_id, f.field_name, f.source, left(f.value_seen, 60) AS value_seen
  FROM field_source f ORDER BY f.entity_id, f.field_name;

\echo '--- Row counts'
SELECT (SELECT count(*) FROM bill)         AS bills,
       (SELECT count(*) FROM stage_event)  AS stage_rows,
       (SELECT count(*) FROM field_source) AS provenance_notes;

\echo ''
\if :save
  \echo '=== SAVING'
  COMMIT;
\else
  \echo '=== NOT SAVING - discarding everything above'
  ROLLBACK;
\endif
