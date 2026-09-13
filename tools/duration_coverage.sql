-- duration_coverage.sql
--
-- Every bill, every stage: counted into a period, or a stated reason why not.
-- There is no third category, and the script stops if one appears.
--
--   psql -d legdata -f duration_coverage.sql
--
-- Asked for by the owner on 2026-09-13, as the check that goes with the ruling
-- that time is counted to every stage the Parliament decided (DECISIONS.md).
-- Run it before and after any change to how periods are calculated: a change
-- that is right moves rows from "not counted" to "counted" and names which,
-- and a change that is wrong shows up as a bill quietly leaving the figures.
--
-- Changes nothing.

\set ON_ERROR_STOP on
\pset pager off

-- Inside a transaction that is thrown away, so the working list can be a
-- temporary table and so this can never write anything even by accident.
BEGIN;

-- Every point in a bill's life that a period could be counted to: each stage
-- record, whether or not it has a day. Introduction is where a bill's first
-- period is counted from, never to, so it is not in this list; Royal Assent is,
-- because a period is counted to it.
CREATE TEMP TABLE coverage ON COMMIT DROP AS
WITH points AS (
    SELECT b.bill_id, b.session_number, b.short_title, b.bill_type, b.outcome,
           e.stage_order, e.stage, e.date_completed, e.completed, e.fell_here,
           e.did_not_happen
      FROM bill b JOIN stage_event e USING (bill_id)
    UNION ALL
    SELECT b.bill_id, b.session_number, b.short_title, b.bill_type, b.outcome,
           9, 'royal_assent', b.date_royal_assent, true, false, false
      FROM bill b WHERE b.enactment_status = 'enacted'
)
SELECT p.*,
       EXISTS (SELECT 1 FROM v_bill_stage_durations d
                WHERE d.bill_id = p.bill_id AND d.stage_order = p.stage_order) AS counted,
       CASE
         WHEN EXISTS (SELECT 1 FROM v_bill_stage_durations d
                       WHERE d.bill_id = p.bill_id AND d.stage_order = p.stage_order)
              THEN NULL
         WHEN p.did_not_happen
              THEN 'the stage did not happen: a reintroduced Private Bill does not '
                   || 'repeat its earlier scrutiny, so there is no period to count'
         WHEN p.date_completed IS NULL
              THEN 'no day recorded against this stage: the stage never reached its '
                   || 'terminal point, so there is nothing to count to'
         WHEN NOT EXISTS (SELECT 1 FROM bill b WHERE b.bill_id = p.bill_id
                            AND b.date_introduced IS NOT NULL)
              THEN 'the bill has no introduction date, so nothing is dated before this stage'
         ELSE NULL                     -- no reason: this is the failure case
       END AS reason
  FROM points p;

\echo ''
\echo '--- Every stage of every bill: counted, or why not'
SELECT CASE WHEN counted THEN 'counted into a period'
            WHEN reason IS NOT NULL THEN reason
            ELSE '*** NOT COUNTED AND NO REASON: the third category ***'
       END AS outcome_of_the_check,
       count(*) AS stages, count(DISTINCT bill_id) AS bills
  FROM coverage GROUP BY 1 ORDER BY 1;

\echo ''
\echo '--- By session and bill type, how many stages are counted'
SELECT session_number, bill_type,
       count(*) FILTER (WHERE counted)     AS counted,
       count(*) FILTER (WHERE NOT counted) AS not_counted,
       count(*)                            AS stages
  FROM coverage GROUP BY 1, 2 ORDER BY 1, 2;

\echo ''
\echo '--- Every stage not counted, one row each'
SELECT session_number AS s, bill_id, left(short_title, 40) AS bill, outcome,
       stage, date_completed, completed, fell_here, did_not_happen, reason
  FROM coverage WHERE NOT counted ORDER BY bill_id, stage_order;

\echo ''
\echo '--- Periods counted, by the stage they are counted to'
SELECT d.previous_stage, d.stage, count(*) AS periods, count(DISTINCT d.bill_id) AS bills
  FROM v_bill_stage_durations d GROUP BY 1, 2 ORDER BY 1, 2;

-- ---------------------------------------------------------------------------
-- The check itself
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer; m integer;
BEGIN
  SELECT count(*) INTO n FROM coverage WHERE NOT counted AND reason IS NULL;
  IF n > 0 THEN
    RAISE EXCEPTION 'Check failed: % stage(s) are counted into no period and have no reason. That is the third category, and there must not be one.', n;
  END IF;

  -- The rule the ruling rests on: a day recorded against a stage means the
  -- Parliament reached that stage's end. A stage that carries a day without
  -- either getting the bill through or ending it is the case that would make
  -- the rule silently wrong.
  SELECT count(*) INTO n FROM coverage
   WHERE stage_order < 9 AND date_completed IS NOT NULL
     AND NOT completed AND NOT fell_here AND NOT did_not_happen;
  IF n > 0 THEN
    RAISE EXCEPTION 'Check failed: % stage(s) carry a day but neither completed the bill''s passage through the stage nor ended the bill there. A day means the Parliament reached the end of the stage.', n;
  END IF;

  -- Nothing is counted that has no day.
  SELECT count(*) INTO n FROM coverage WHERE counted AND date_completed IS NULL;
  IF n > 0 THEN
    RAISE EXCEPTION 'Check failed: % stage(s) are counted into a period with no day recorded.', n;
  END IF;

  SELECT count(*) INTO n FROM coverage WHERE counted;
  SELECT count(*) INTO m FROM v_bill_stage_durations;
  IF n <> m THEN
    RAISE EXCEPTION 'Check failed: % stages are marked counted but the duration table holds % periods.', n, m;
  END IF;

  RAISE NOTICE 'Coverage is complete: % stage(s) counted, every other one with a stated reason.', n;
END $$;

ROLLBACK;
