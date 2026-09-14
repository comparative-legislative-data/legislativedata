-- db/086_a_second_appearance_is_not_asked_for_stages_it_already_has.sql
--
-- The gaps list, taught what the error checker was taught at db/082.
--
-- Agreed with the owner on 2026-09-14, after the closure test on db/080-085
-- found it. db/081 made a fact sheet row that is a further appearance of a bill
-- already on the clean sheet land on that bill, and db/082 rebuilt the error
-- checker so that it reads such a row correctly. The gaps list was not rebuilt,
-- and it asks every line that passed for all three of its stages.
--
-- So the European Charter Bill's Session 6 line would be listed as missing its
-- Stage 1 and Stage 2 dates. They are not missing: they are on the bill, from
-- Session 5, 4 and 24 February 2021. The UNCRC Bill would do the same, as would
-- the Legal Continuity Bill, and the Gender Recognition Reform Bill when
-- Session 7 is read in. Four bills, up to eight entries, none of them real, on
-- the list the owner opens at the end of a promotion to see what the session
-- went in without.
--
-- Nothing is recorded differently. No cell, no value, no dropdown list, nothing
-- new on either sheet, nothing for promotion to carry, no provenance, no
-- methodology note: no reader ever sees the gaps list. The error checker is
-- untouched, because it already knows. This changes only when a working list
-- complains, and it is applied before the first row that would trip it exists.
--
-- THE RULE. A stage is not missing from a line that continues an earlier bill
-- if the bill it continues already has that stage -- either with a date, or
-- marked as one that never happened. That is the same shape as the rule db/039
-- added for a stage a bill never had.
--
-- THE ALTERNATIVE, rejected: leave continuing lines off the gaps list
-- altogether. A line that genuinely arrived with no stage dates at all would
-- then show nothing, and the gaps list exists to catch exactly that.
--
-- It reads the clean sheet, as db/082's Reconsideration Stage check does. A
-- line cannot continue a bill that is not on the clean sheet: the error checker
-- says so and promotion refuses it.
--
-- The second half of the list -- a bill that did not pass with nothing saying
-- where it ended -- is left alone. A second appearance is where the bill ended,
-- so its own line is the one that has to record the ending. No bill has ever
-- appeared in three fact sheets.
--
-- WRITTEN OUT IN FULL, and then diffed against the live view, because that is
-- the only way to be sure the rebuilt text and the running one differ in the
-- one place intended. db/062 had to say the same thing: a view rebuilt from an
-- older migration's text quietly carries that text's stale names with it.
--
-- Not marked here. A session may not mark the check on a rule it added itself
-- (DECISIONS.md, 2026-09-14), and this session added it. Four items are written
-- up in docs/CLOSURE-TESTS.md for the next session.

\set ON_ERROR_STOP on

BEGIN;

CREATE OR REPLACE VIEW v_stage_date_gaps AS
WITH lines AS (
    SELECT c.candidate_id, c.session_number, c.short_title, c.bill_type, c.outcome,
           c.continues_bill_id
      FROM bill_candidate c
     WHERE c.review_status <> 'rejected'
),
stage_rows AS (
    -- detail_note is aliased to note because two checks below still call it
    -- that. db/061 renamed the column and the view's own alias was left
    -- pointing at the old name; db/062 hit the same trap in the error checker
    -- and said so out loud. Nothing outside the view reads this alias.
    SELECT t.*, t.detail_note AS note
      FROM stage_candidate t WHERE t.review_status <> 'rejected'
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
   -- Added at db/086: a bill that appears in two fact sheets has two lines and
   -- is one bill (M6). A stage the bill completed before this second appearance
   -- is on the bill already; it is not on this line, and it is not a date to
   -- find. A stage the bill never had counts the same way here as it does above.
   AND NOT EXISTS (SELECT 1 FROM stage_event e
                    WHERE e.bill_id = x.continues_bill_id
                      AND e.stage_order = x.pos
                      AND (e.date_completed IS NOT NULL OR e.did_not_happen))
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
 'The gaps to fill in stage dates, read from the staging sheets: one row per missing date. A bill that passed should have a date for each of its three stages, and a bill that ended early a date for each stage before the one it ended at. A stage completed on a date not known is listed with its note, and a bill that did not pass is listed if nothing records where it ended -- except one that fell because its financial resolution was not agreed, which did not stop at a stage (db/056). A stage a bill never had, because its procedure skipped it, is not listed at all (db/039), and neither is a stage that the bill this line continues has already (db/086) -- a bill in two fact sheets is one bill, and its earlier stages are on the bill, not on the second line. A gap does not stop promotion (DECISIONS.md, 2026-09-11); a contradiction does, and is in v_candidate_problems instead. Lines and rows rejected at review are left out.';

ALTER VIEW v_stage_date_gaps OWNER TO legdata;

-- ---------------------------------------------------------------------------
-- What should now be true
-- ---------------------------------------------------------------------------
--
-- Nothing on the clean sheet may move, because nothing here writes. The list
-- was empty before this and must be empty after it: the change can only make
-- the list quieter, and there is nothing for it to be quieter about yet. The
-- four checks that prove it does become quieter in the one place it should are
-- in docs/CLOSURE-TESTS.md, for a session that did not write this rule.

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM v_stage_date_gaps;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: the gaps list is not empty (% row(s)). It was empty before this.', n;
  END IF;

  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: the error checker is not empty (% problem(s)).', n;
  END IF;

  -- The Robin Rigg Act's line, which the rule db/039 added keeps off the list,
  -- must still be off it. It is the one line with a stage it never had.
  SELECT count(*) INTO n FROM v_stage_date_gaps WHERE candidate_id = 124;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: the Robin Rigg Act is now listed as missing % stage date(s).', n;
  END IF;

  RAISE NOTICE 'Gaps list and error checker both empty; the Robin Rigg Act is still not asked.';
END $$;

COMMIT;
