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
CREATE TEMP TABLE promoting ON COMMIT DROP AS
SELECT c.*
  FROM bill_candidate c JOIN promote_arg a USING (session_number)
 WHERE c.review_status = 'accepted'
   AND c.promoted_bill_id IS NULL;

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
-- KNOWN GAP: this cannot see a bill whose title changed between its two
-- factsheets. The European Charter and UNCRC Bills are "Bill" in Session 5 and
-- "Act" in Session 6. It must be dealt with before Session 6 is promoted; see
-- docs/STATE.md.
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
CREATE TEMP TABLE promoting_stages ON COMMIT DROP AS
SELECT DISTINCT ON (t.candidate_id, t.stage_order) t.*
  FROM stage_candidate t
  JOIN promoting p USING (candidate_id)
  LEFT JOIN stage_source_rank r ON r.source = t.source
 WHERE t.review_status = 'accepted'
 ORDER BY t.candidate_id, t.stage_order, r.rank;

-- ---------------------------------------------------------------------------
-- The bills
-- ---------------------------------------------------------------------------

INSERT INTO bill (bill_id, session_number, sp_bill_id, short_title, bill_type,
                  procedure, date_introduced, outcome, enactment_status,
                  date_royal_assent, asp_number, date_concluded,
                  bill_type_stated, title_as_introduced,
                  stage_1_rejection_route, note,
                  source, source_ref, observed_at)
SELECT p.candidate_id, p.session_number, p.sp_bill_id, p.short_title, p.bill_type,
       p.procedure, p.date_introduced, p.outcome, p.enactment_status,
       p.date_royal_assent, p.asp_number, p.date_concluded,
       p.bill_type_stated, p.title_as_introduced,
       p.stage_1_rejection_route, p.bill_note,
       p.source, p.source_ref, p.observed_at
  FROM promoting p;

-- ---------------------------------------------------------------------------
-- The stages each bill reached
-- ---------------------------------------------------------------------------

-- Each row carries its own source, reference and date read, so stage dates
-- need no provenance notes. The stage name was checked against the bill type
-- by the error checker, and the trigger on stage_event checks it again.
INSERT INTO stage_event (bill_id, stage, stage_order, date_completed, completed,
                         fell_here, did_not_happen, source, source_ref, observed_at, note)
SELECT s.candidate_id, s.stage, s.stage_order, s.date_completed, s.completed,
       s.fell_here, s.did_not_happen, s.source, s.source_ref, s.observed_at, s.note
  FROM promoting_stages s
 ORDER BY s.candidate_id, s.stage_order;

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
       'Corrected at review. The factsheet''s wording is kept verbatim in bill_candidate.raw_title: ' || p.raw_title
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
INSERT INTO field_source (entity, entity_id, field_name, source, source_ref,
                          value_seen, observed_at)
SELECT 'bill', p.candidate_id, 'outcome', 'official_report',
       substring(p.review_note from 'https?://\S+'),
       regexp_replace(
         regexp_replace(p.review_note, '^Outcome from the Official Report, not the factsheet:\s*', ''),
         '\s*https?://.*$', ''),
       p.official_report_read_on
  FROM promoting p
 WHERE p.review_note ILIKE 'Outcome from the Official Report%'
   AND NOT EXISTS (SELECT 1 FROM field_source f
                    WHERE f.entity = 'bill' AND f.entity_id = p.candidate_id
                      AND f.field_name = 'outcome');

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
       'Checked at review against the source that owns this date. The '
       'factsheet''s own printed words are kept in bill_candidate.raw_'
       || regexp_replace(m[1], '^date_', 'raw_date_') || '.'
  FROM promoting p
  CROSS JOIN LATERAL regexp_matches(
        coalesce(p.review_note, ''),
        'Checked: ([a-z0-9_]+) = ([^(]+?) \(([a-z_]+), ([^,]+), (\d{4}-\d{2}-\d{2})\)',
        'g') AS m
 WHERE NOT EXISTS (SELECT 1 FROM field_source f
                    WHERE f.entity = 'bill' AND f.entity_id = p.candidate_id
                      AND f.field_name = m[1]);

-- ---------------------------------------------------------------------------
-- Stamp the staging lines and the stage-dates rows
-- ---------------------------------------------------------------------------

UPDATE bill_candidate c
   SET promoted_bill_id = c.candidate_id,
       promoted_at      = now()
  FROM promoting p
 WHERE c.candidate_id = p.candidate_id;

UPDATE stage_candidate t
   SET promoted_stage_event_id = e.stage_event_id,
       promoted_at             = now()
  FROM promoting_stages s
  JOIN stage_event e ON e.bill_id = s.candidate_id AND e.stage_order = s.stage_order
 WHERE t.stage_candidate_id = s.stage_candidate_id;

-- The same for a stage date checked at review. It hangs off the stage record
-- rather than the bill, so it is written after the stamping above, which is
-- what gives the stage record its number.
INSERT INTO field_source (entity, entity_id, field_name, source, source_ref,
                          value_seen, observed_at, note)
SELECT 'stage_event', t.promoted_stage_event_id, m[1], m[3], m[4], m[2], m[5]::date,
       'Checked at review against the source that owns this date.'
  FROM stage_candidate t
  JOIN promoting p ON p.candidate_id = t.candidate_id
  CROSS JOIN LATERAL regexp_matches(
        coalesce(t.review_note, ''),
        'Checked: ([a-z0-9_]+) = ([^(]+?) \(([a-z_]+), ([^,]+), (\d{4}-\d{2}-\d{2})\)',
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

  -- One bill per accepted line, and no others.
  SELECT count(*) INTO n FROM bill WHERE session_number = s;
  IF n <> (SELECT count(*) FROM bill_candidate
            WHERE session_number = s AND review_status = 'accepted')
  THEN RAISE EXCEPTION 'Check failed: % bills on the clean sheet, % accepted lines.',
       n, (SELECT count(*) FROM bill_candidate WHERE session_number = s AND review_status = 'accepted');
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
       OR b.asp_number        IS DISTINCT FROM c.asp_number
       OR b.sp_bill_id        IS DISTINCT FROM c.sp_bill_id
       OR b.bill_type_stated  IS DISTINCT FROM c.bill_type_stated
       OR b.title_as_introduced IS DISTINCT FROM c.title_as_introduced
       OR b.stage_1_rejection_route IS DISTINCT FROM c.stage_1_rejection_route
       OR b.note              IS DISTINCT FROM c.bill_note);
  IF bad IS NOT NULL THEN RAISE EXCEPTION 'Check failed: bill(s) % differ from their staging line.', bad; END IF;

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
      OR e.note           IS DISTINCT FROM k.note;
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % stage record(s) do not match the stage-dates rows they come from.', n; END IF;

  -- Every row carried is stamped with its own record, and no other row in the
  -- session is stamped.
  SELECT count(*) INTO n
    FROM stage_candidate t
    JOIN bill_candidate c USING (candidate_id)
    LEFT JOIN carried_stages k ON k.stage_candidate_id = t.stage_candidate_id
    LEFT JOIN stage_event e ON e.stage_event_id = t.promoted_stage_event_id
   WHERE c.session_number = s
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
