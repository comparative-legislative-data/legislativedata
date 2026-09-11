-- 036_stage_order_fills_itself_in.sql
--
-- On the stage-dates sheet, a row's position in its bill's sequence
-- (stage_order) fills itself in from the stage name, as the title has since
-- db/035. Asked for by the owner on 2026-09-11 as a failsafe while typing
-- stage dates into Postico: the name is typed, the number follows, and the two
-- cannot disagree.
--
-- Each stage name has one position whatever the kind of bill: Stage 1 and the
-- Preliminary Stage are 1, Stage 2 and the Consideration Stage 2, Stage 3 and
-- the Final Stage 3, Reconsideration 4. So the position comes from the name
-- alone. A real name that belongs to another kind of bill, such as Stage 1 on a
-- Private Bill, still gets its position, and the error checker says it is the
-- wrong name for that bill. A name not on the list gets no position, and the
-- checker says so.
--
-- Every row already on the sheet has the position its name gives, so no value
-- changes. Proved by saving every row again and comparing it, cell by cell,
-- with how it was.

BEGIN;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM ref_bill_type_stage
              GROUP BY stage HAVING count(DISTINCT stage_order) > 1) THEN
    RAISE EXCEPTION 'Refusing to run: a stage name sits at more than one position in ref_bill_type_stage, so a position cannot come from the name alone.';
  END IF;
  IF EXISTS (SELECT 1 FROM stage_candidate t
              WHERE t.stage_order IS DISTINCT FROM
                    (SELECT max(x.stage_order) FROM ref_bill_type_stage x WHERE x.stage = t.stage)) THEN
    RAISE EXCEPTION 'Refusing to run: a row on the stage-dates sheet has a position its stage name does not give, and this would change it.';
  END IF;
END $$;

CREATE TEMP TABLE kept_rows ON COMMIT DROP AS SELECT * FROM stage_candidate;

CREATE FUNCTION stage_candidate_fill_stage_order() RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
  NEW.stage_order := (SELECT max(x.stage_order) FROM ref_bill_type_stage x
                       WHERE x.stage = NEW.stage);
  RETURN NEW;
END;
$$;

ALTER FUNCTION stage_candidate_fill_stage_order() OWNER TO legdata;

COMMENT ON FUNCTION stage_candidate_fill_stage_order() IS
 'Fills in stage_candidate.stage_order from the row''s stage name whenever a row is added or changed, replacing anything typed there. Relies on each stage name having one position in ref_bill_type_stage, which db/036 checked.';

CREATE TRIGGER stage_candidate_fill_stage_order
    BEFORE INSERT OR UPDATE ON stage_candidate
    FOR EACH ROW EXECUTE FUNCTION stage_candidate_fill_stage_order();

COMMENT ON COLUMN stage_candidate.stage_order IS
 'Where the stage comes in its bill type''s sequence: 1, 2 or 3, or 4 for Reconsideration. Filled in automatically from the stage name whenever the row is saved, and anything typed here is replaced: each name has one position whatever the kind of bill, as ref_bill_type_stage gives it. Empty only when the stage name is empty or not on the list, which the error checker flags.';

-- ---------------------------------------------------------------------------
-- Checks
-- ---------------------------------------------------------------------------

-- Save every row again, so the new rule fills in every position, then compare.
-- Nothing should differ, not even the last-changed time.
UPDATE stage_candidate SET stage = stage;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n
    FROM kept_rows k FULL JOIN stage_candidate t USING (stage_candidate_id)
   WHERE to_jsonb(k) IS DISTINCT FROM to_jsonb(t);
  IF n > 0 THEN
    RAISE EXCEPTION '% row(s) changed when saved again under the new rule.', n;
  END IF;

  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n > 0 THEN RAISE EXCEPTION 'The error checker finds % problem(s).', n; END IF;
END $$;

SET LOCAL ROLE legdata;
SELECT (SELECT count(*) FROM stage_candidate)      AS stage_date_rows,
       (SELECT count(*) FROM v_stage_date_gaps)    AS gaps,
       (SELECT count(*) FROM v_candidate_problems) AS problems;
RESET ROLE;

COMMIT;
