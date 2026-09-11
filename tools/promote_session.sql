-- promote_session.sql
--
-- Copies one session's accepted staging lines onto the clean sheet.
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
-- Taking a session off (rollback_promotion.sql) removes its notes, and putting
-- it back writes them again (db/030).

\set ON_ERROR_STOP on

BEGIN;

CREATE TEMP TABLE promote_arg ON COMMIT DROP AS SELECT :session::int AS session_number;

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

-- A bill that passed completed the third stage of its own type's sequence:
-- Stage 3 for a public bill, Final Stage for a private or hybrid one. The
-- name comes from ref_bill_type_stage, so it is right by construction and the
-- trigger on stage_event has nothing to object to.
INSERT INTO stage_event (bill_id, stage, stage_order, date_completed, completed,
                         fell_here, source, source_ref, observed_at)
SELECT p.candidate_id, s.stage, 3, p.end_stage_3_date, true, false,
       p.source, p.source_ref, p.observed_at
  FROM promoting p
  JOIN ref_bill_type_stage s
    ON s.bill_type = p.bill_type AND s.stage_order = 3
 WHERE p.outcome = 'passed'
   AND p.end_stage_3_date IS NOT NULL;

-- A bill rejected at its first stage reached that stage and did not get through
-- it, so completed is false and this is where it ended. The date and the
-- outcome both came from the Official Report rather than the factsheet, and the
-- citation is in the staging line's review note; the stage row carries its own
-- source, so this needs no separate provenance note. It is dated by when the
-- Official Report was read, not when the factsheet was (db/031).
INSERT INTO stage_event (bill_id, stage, stage_order, date_completed, completed,
                         fell_here, source, source_ref, observed_at)
SELECT p.candidate_id, s.stage, 1, p.end_stage_1_date, false, true,
       'official_report',
       substring(p.review_note from 'https?://\S+'),
       p.official_report_read_on
  FROM promoting p
  JOIN ref_bill_type_stage s
    ON s.bill_type = p.bill_type AND s.stage_order = 1
 WHERE p.outcome = 'rejected_stage_1'
   AND p.end_stage_1_date IS NOT NULL;

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

-- ---------------------------------------------------------------------------
-- Stamp the staging lines
-- ---------------------------------------------------------------------------

UPDATE bill_candidate c
   SET promoted_bill_id = c.candidate_id,
       promoted_at      = now()
  FROM promoting p
 WHERE c.candidate_id = p.candidate_id;

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

  -- A stage row for every bill that should have one, and none that should not.
  SELECT count(*) INTO n FROM bill_candidate c
   WHERE c.session_number = s AND c.review_status = 'accepted'
     AND c.end_stage_3_date IS NOT NULL
     AND NOT EXISTS (SELECT 1 FROM stage_event e
                      WHERE e.bill_id = c.candidate_id AND e.stage_order = 3);
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % bill(s) that passed have no final stage row.', n; END IF;

  SELECT count(*) INTO n FROM bill_candidate c
   WHERE c.session_number = s AND c.review_status = 'accepted'
     AND c.end_stage_1_date IS NOT NULL
     AND NOT EXISTS (SELECT 1 FROM stage_event e
                      WHERE e.bill_id = c.candidate_id AND e.stage_order = 1);
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % bill(s) rejected at their first stage have no stage row.', n; END IF;

  -- Every stage date matches the line it came from.
  SELECT count(*) INTO n
    FROM stage_event e JOIN bill_candidate c ON c.candidate_id = e.bill_id
   WHERE c.session_number = s
     AND e.date_completed IS DISTINCT FROM
         (CASE e.stage_order WHEN 1 THEN c.end_stage_1_date WHEN 3 THEN c.end_stage_3_date END);
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % stage date(s) do not match their staging line.', n; END IF;

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
SELECT e.stage, e.stage_order, e.completed, e.fell_here, count(*)
  FROM stage_event e JOIN bill b USING (bill_id) JOIN promote_arg a USING (session_number)
 GROUP BY 1,2,3,4 ORDER BY 2,1;

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
