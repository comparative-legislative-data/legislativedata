-- db/056_where_four_bills_ended_and_one_that_ended_nowhere.sql
--
-- Two things, both left over from db/055.
--
-- First, the four Session 3 bills that did not pass and had nothing recording
-- where they had got to: two withdrawn by the member in charge, two that fell
-- at dissolution. Every bill in Sessions 1 and 2 that did not pass has this;
-- these four did not, and db/055 did not notice because the error checker does
-- not carry it -- v_stage_date_gaps does. Established by the owner from the
-- Parliament's own bill pages, as kept by the web archive.
--
-- No date is recorded on any of the four, which is the rule Sessions 1 and 2
-- set: a stage a bill did not complete has no completion date, because none of
-- these bills ended on a decision of the Parliament. The day each concluded is
-- on the bill itself, from the fact sheet, and for the two withdrawn bills it
-- agrees with the owner's reading of the bill page to the day.
--
-- Second, the gaps list asks every bill that did not pass where it ended. That
-- is wrong for exactly one kind of bill, and db/055 created it: a bill that
-- fell because its financial resolution was not agreed did not stop at a stage.
-- It completed the stage it reached and then fell between that stage and the
-- next. The list was reporting "where the bill ended is not recorded" for the
-- Creative Scotland Bill, which is false -- it is recorded, on the bill.
--
-- This only changes the staging sheet. Session 3 is not on the clean sheet.

\set ON_ERROR_STOP on
BEGIN;

-- ---------------------------------------------------------------------------
-- 1. Where the four bills had got to
-- ---------------------------------------------------------------------------

CREATE TEMP TABLE ending (
  candidate_id integer, title_fragment text, stage text, url text, note text
) ON COMMIT DROP;

INSERT INTO ending VALUES
 (208, 'Criminal Sentencing (Equity Fines)', 'stage_1',
  'https://webarchive.nrscotland.gov.uk/public/+/archive2021.parliament.scot/parliamentarybusiness/Bills/17999.aspx',
  'Withdrawn by the member in charge on 25 November 2010, before the Stage 1 debate was held. '
  || 'No Stage 1 date is recorded: the stage was never completed.'),

 (209, 'Palliative Care', 'stage_1',
  'https://webarchive.nrscotland.gov.uk/public/+/archive2021.parliament.scot/parliamentarybusiness/Bills/22327.aspx',
  'Withdrawn by the member in charge on 2 December 2010, before any Stage 1 debate was held. '
  || 'No Stage 1 date is recorded: the stage was never completed.'),

 (212, 'Commissioner for Victims and Witnesses', 'stage_1',
  'https://webarchive.nrscotland.gov.uk/public/+/archive2021.parliament.scot/parliamentarybusiness/Bills/17994.aspx',
  'Fell at dissolution during Stage 1. No Stage 1 date is recorded: the stage was never '
  || 'completed.'),

 (215, 'Long Leases', 'stage_1',
  'https://webarchive.nrscotland.gov.uk/public/+/archive2021.parliament.scot/parliamentarybusiness/Bills/22395.aspx',
  'Fell at dissolution before a Stage 1 debate took place. No Stage 1 date is recorded: the '
  || 'stage was never completed.');

-- A mistyped line number must fail here, not write to the wrong bill.
DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM ending a JOIN bill_candidate c USING (candidate_id)
   WHERE c.short_title NOT ILIKE '%' || a.title_fragment || '%';
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % ending row(s) name a line whose title does not match.', n;
  END IF;
  SELECT count(*) INTO n FROM ending a JOIN bill_candidate c USING (candidate_id)
   WHERE c.outcome NOT IN ('withdrawn', 'fell_dissolution');
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % ending row(s) name a bill that did not end this way.', n;
  END IF;
  SELECT count(*) INTO n FROM ending a
   WHERE EXISTS (SELECT 1 FROM stage_candidate s
                  WHERE s.candidate_id = a.candidate_id AND s.fell_here);
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % bill(s) already record where they ended.', n;
  END IF;
END $$;

INSERT INTO stage_candidate
       (candidate_id, stage, date_completed, completed, fell_here,
        source, source_ref, observed_at, note)
SELECT a.candidate_id, a.stage, NULL, false, true,
       'bill_page', a.url, DATE '2026-09-13', a.note
  FROM ending a;

-- ---------------------------------------------------------------------------
-- 2. The one bill that did not end at a stage
--
--    Copied from db/039 with one change, marked in place. Everything else is
--    as db/039 left it.
-- ---------------------------------------------------------------------------

CREATE OR REPLACE VIEW v_stage_date_gaps AS
WITH lines AS (
    SELECT c.candidate_id, c.session_number, c.short_title, c.bill_type, c.outcome
      FROM bill_candidate c
     WHERE c.review_status <> 'rejected'
),
stage_rows AS (
    SELECT t.* FROM stage_candidate t WHERE t.review_status <> 'rejected'
),
ended AS (
    SELECT candidate_id, min(stage_order) AS ended_at
      FROM stage_rows WHERE fell_here GROUP BY candidate_id
),
furthest AS (
    SELECT candidate_id, max(stage_order) AS furthest
      FROM stage_rows GROUP BY candidate_id
),
expected AS (
    -- A bill that passed: each of its three stages.
    SELECT l.*, g.pos
      FROM lines l CROSS JOIN generate_series(1, 3) AS g(pos)
     WHERE l.outcome = 'passed'
    UNION ALL
    -- A bill that ended early: each stage before the one it ended at.
    SELECT l.*, g.pos
      FROM lines l JOIN ended e USING (candidate_id)
     CROSS JOIN LATERAL generate_series(1, e.ended_at - 1) AS g(pos)
     WHERE l.outcome IS DISTINCT FROM 'passed'
    UNION ALL
    -- A bill still in progress: each stage before the furthest recorded.
    SELECT l.*, g.pos
      FROM lines l JOIN furthest f USING (candidate_id)
     CROSS JOIN LATERAL generate_series(1, least(f.furthest, 4) - 1) AS g(pos)
     WHERE l.outcome = 'in_progress'
       AND NOT EXISTS (SELECT 1 FROM ended e WHERE e.candidate_id = l.candidate_id)
)
SELECT x.candidate_id, x.session_number, x.short_title, x.bill_type, x.outcome,
       x.pos AS stage_order, s.stage,
       CASE WHEN d.rows_completed = 0 THEN 'date not yet entered'
            ELSE 'completed, date not known: '||coalesce(d.notes, '(no note)') END AS gap
  FROM expected x
  LEFT JOIN ref_bill_type_stage s ON s.bill_type = x.bill_type AND s.stage_order = x.pos
  CROSS JOIN LATERAL (
      SELECT count(*) AS rows_completed,
             bool_or(t.date_completed IS NOT NULL) AS dated,
             string_agg(t.note, '; ') AS notes
        FROM stage_rows t
       WHERE t.candidate_id = x.candidate_id AND t.stage_order = x.pos AND t.completed
  ) d
 WHERE NOT coalesce(d.dated, false)
   -- Added at db/039: a stage the bill never had is not a date to find.
   AND NOT EXISTS (SELECT 1 FROM stage_rows t
                    WHERE t.candidate_id = x.candidate_id AND t.stage_order = x.pos
                      AND t.did_not_happen)
UNION ALL
-- A bill that did not pass, with nothing recording where it ended.
SELECT l.candidate_id, l.session_number, l.short_title, l.bill_type, l.outcome,
       NULL, NULL, 'where the bill ended is not recorded'
  FROM lines l
   -- Added at db/056: a bill that fell because its financial resolution was
   -- not agreed did not stop at a stage. It completed the stage it reached --
   -- the Parliament agreed its general principles -- and then fell between
   -- that stage and the next, on a vote that is not part of any stage. Asking
   -- where it ended would be asking for a stage that does not exist, and the
   -- answer would be a wrong one. Its ending is on the bill, in outcome.
 WHERE l.outcome IS NOT NULL
   AND l.outcome NOT IN ('passed', 'in_progress',
                         'fell_financial_resolution_not_agreed')
   AND NOT EXISTS (SELECT 1 FROM ended e WHERE e.candidate_id = l.candidate_id)
ORDER BY 2, 1, 6;


COMMENT ON VIEW v_stage_date_gaps IS
 'The gaps to fill in stage dates, read from the staging sheets: one row per missing date. A bill that passed should have a date for each of its three stages, and a bill that ended early a date for each stage before the one it ended at. A stage completed on a date not known is listed with its note, and a bill that did not pass is listed if nothing records where it ended -- except one that fell because its financial resolution was not agreed, which did not stop at a stage (db/056). A stage a bill never had, because its procedure skipped it, is not listed at all (db/039). A gap does not stop promotion (DECISIONS.md, 2026-09-11); a contradiction does, and is in v_candidate_problems instead. Lines and rows rejected at review are left out.';

ALTER VIEW v_stage_date_gaps OWNER TO legdata;

-- ---------------------------------------------------------------------------
-- 3. What should now be true
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer;
BEGIN
  -- Every Session 3 bill that did not pass now says where it ended, except the
  -- one that did not end at a stage.
  SELECT count(*) INTO n FROM bill_candidate c
   WHERE c.session_number = 3
     AND c.outcome NOT IN ('passed', 'in_progress', 'fell_financial_resolution_not_agreed')
     AND NOT EXISTS (SELECT 1 FROM stage_candidate s
                      WHERE s.candidate_id = c.candidate_id AND s.fell_here);
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % Session 3 bill(s) still do not say where they ended.', n;
  END IF;

  -- And that one is not asked to.
  SELECT count(*) INTO n FROM v_stage_date_gaps
   WHERE gap = 'where the bill ended is not recorded';
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % bill(s) are still listed as not recording where they ended.', n;
  END IF;

  -- The four new rows carry no date, which is the rule Sessions 1 and 2 set.
  SELECT count(*) INTO n FROM stage_candidate s JOIN ending a USING (candidate_id)
   WHERE s.stage = a.stage AND (s.date_completed IS NOT NULL OR s.completed OR NOT s.fell_here);
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % of the four new rows is not an undated, uncompleted ending.', n;
  END IF;

  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: the error checker is not empty (% problem(s)).', n;
  END IF;

  RAISE NOTICE 'Four bills now say where they ended; the Creative Scotland Bill is no longer asked. Checker empty.';
END $$;

COMMIT;
