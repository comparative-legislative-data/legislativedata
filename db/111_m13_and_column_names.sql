-- db/111_m13_and_column_names.sql
--
-- Settled by the owner on 2026-09-17 (docs/PHASE-2-NOTES.md, "M13's sentence,
-- and the column names in M1, M4 and M11"). Sentence replacements only; every
-- other sentence of each note is unchanged, and the proof below checks that each
-- body is the old body with exactly these replacements.
--
-- M13 said a bill still before the Parliament "has not yet completed a stage, so
-- there is nothing to measure for it at all", which is true of today's one live
-- bill and not of every live bill: the calculations give a live bill a time for
-- each stage it has completed. The rest of that paragraph repeated M2. Kept, as
-- settled on 2026-09-15: a session with nothing to measure is shown blank, not
-- nought days; neither withdrawn draft of db/102 returns.
--
-- M1, M4 and M11 named database columns. The notes a reader sees name none now.

\set ON_ERROR_STOP on
BEGIN;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM methodology_note WHERE code = 'M13' AND position('It has not yet completed a stage, so there is nothing to measure for it at all, on any basis a figure might use. Which bills a figure about time covers is decided when the figure is drawn, not here: a bill that stopped at Stage 1 has a real introduction-to-Stage-1 period and it is recorded like any other, and every bill carries what happened to it, so a figure can cover all bills or only those that passed.' in body) > 0;
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: M13 does not contain the sentence this replaces.'; END IF;
  SELECT count(*) INTO n FROM methodology_note WHERE code = 'M1' AND position('The label used at the time is retained separately in bill.bill_type_stated, and can be cross-tabulated or filtered on.' in body) > 0;
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: M1 does not contain the sentence this replaces.'; END IF;
  SELECT count(*) INTO n FROM methodology_note WHERE code = 'M4' AND position('It is recorded here with bill_type "hybrid", which is what it was. Where bill types are grouped for counting, it is grouped with government bills, because it was introduced by the Scottish Government; ref_bill_type.analysis_group holds that grouping, and grouping instead by bill_type keeps it separate.' in body) > 0;
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: M4 does not contain the sentence this replaces.'; END IF;
  SELECT count(*) INTO n FROM methodology_note WHERE code = 'M11' AND position('so both are recorded — the first in date_reached, the second in date_completed.' in body) > 0;
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: M11 does not contain the sentence this replaces.'; END IF;
  SELECT count(*) INTO n FROM methodology_note WHERE code = 'M11' AND position('An empty date_reached means no source has told us when the bill reached that stage.' in body) > 0;
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: M11 does not contain the sentence this replaces.'; END IF;
END $$;

CREATE TEMP TABLE before_notes ON COMMIT DROP AS
SELECT code, title, body, applies_to, sort_order FROM methodology_note;

UPDATE methodology_note SET body = replace(body, 'It has not yet completed a stage, so there is nothing to measure for it at all, on any basis a figure might use. Which bills a figure about time covers is decided when the figure is drawn, not here: a bill that stopped at Stage 1 has a real introduction-to-Stage-1 period and it is recorded like any other, and every bill carries what happened to it, so a figure can cover all bills or only those that passed.', 'Time is measured for it as for any other bill, between the stages it has completed; the stage it is at gives no figure until it ends. Which bills a figure about time covers is decided when the figure is drawn, as M2 says.') WHERE code = 'M13';
UPDATE methodology_note SET body = replace(body, 'The label used at the time is retained separately in bill.bill_type_stated, and can be cross-tabulated or filtered on.', 'The label used at the time, Executive or Government, is kept beside it, so a table can be split or filtered by it.') WHERE code = 'M1';
UPDATE methodology_note SET body = replace(body, 'It is recorded here with bill_type "hybrid", which is what it was. Where bill types are grouped for counting, it is grouped with government bills, because it was introduced by the Scottish Government; ref_bill_type.analysis_group holds that grouping, and grouping instead by bill_type keeps it separate.', 'It is recorded here as a Hybrid Bill, which is what it was. Where bill types are grouped for counting, it is grouped with government bills, because it was introduced by the Scottish Government; both are held, so a count can use that grouping, or the bill''s own type, which keeps it separate.') WHERE code = 'M4';
UPDATE methodology_note SET body = replace(body, 'so both are recorded — the first in date_reached, the second in date_completed.', 'so both are recorded: the first as the day the stage was reached, the second as the day it ended.') WHERE code = 'M11';
UPDATE methodology_note SET body = replace(body, 'An empty date_reached means no source has told us when the bill reached that stage.', 'Where a stage has no day reached, no source has told us when the bill reached it.') WHERE code = 'M11';

DO $$
DECLARE n integer; b text;
BEGIN
  SELECT count(*) INTO n FROM methodology_note WHERE code = 'M13' AND position('Time is measured for it as for any other bill, between the stages it has completed; the stage it is at gives no figure until it ends. Which bills a figure about time covers is decided when the figure is drawn, as M2 says.' in body) > 0 AND position('It has not yet completed a stage, so there is nothing to measure for it at all, on any basis a figure might use. Which bills a figure about time covers is decided when the figure is drawn, not here: a bill that stopped at Stage 1 has a real introduction-to-Stage-1 period and it is recorded like any other, and every bill carries what happened to it, so a figure can cover all bills or only those that passed.' in body) = 0;
  IF n <> 1 THEN RAISE EXCEPTION 'M13 does not read as approved.'; END IF;
  SELECT count(*) INTO n FROM methodology_note WHERE code = 'M1' AND position('The label used at the time, Executive or Government, is kept beside it, so a table can be split or filtered by it.' in body) > 0 AND position('The label used at the time is retained separately in bill.bill_type_stated, and can be cross-tabulated or filtered on.' in body) = 0;
  IF n <> 1 THEN RAISE EXCEPTION 'M1 does not read as approved.'; END IF;
  SELECT count(*) INTO n FROM methodology_note WHERE code = 'M4' AND position('It is recorded here as a Hybrid Bill, which is what it was. Where bill types are grouped for counting, it is grouped with government bills, because it was introduced by the Scottish Government; both are held, so a count can use that grouping, or the bill''s own type, which keeps it separate.' in body) > 0 AND position('It is recorded here with bill_type "hybrid", which is what it was. Where bill types are grouped for counting, it is grouped with government bills, because it was introduced by the Scottish Government; ref_bill_type.analysis_group holds that grouping, and grouping instead by bill_type keeps it separate.' in body) = 0;
  IF n <> 1 THEN RAISE EXCEPTION 'M4 does not read as approved.'; END IF;
  SELECT count(*) INTO n FROM methodology_note WHERE code = 'M11' AND position('so both are recorded: the first as the day the stage was reached, the second as the day it ended.' in body) > 0 AND position('so both are recorded — the first in date_reached, the second in date_completed.' in body) = 0;
  IF n <> 1 THEN RAISE EXCEPTION 'M11 does not read as approved.'; END IF;
  SELECT count(*) INTO n FROM methodology_note WHERE code = 'M11' AND position('Where a stage has no day reached, no source has told us when the bill reached it.' in body) > 0 AND position('An empty date_reached means no source has told us when the bill reached that stage.' in body) = 0;
  IF n <> 1 THEN RAISE EXCEPTION 'M11 does not read as approved.'; END IF;

  SELECT count(*) INTO n FROM methodology_note m JOIN before_notes o USING (code)
   WHERE (m.code NOT IN ('M1', 'M4', 'M11', 'M13') AND m.body IS DISTINCT FROM o.body)
      OR (m.title, m.applies_to, m.sort_order) IS DISTINCT FROM (o.title, o.applies_to, o.sort_order);
  IF n > 0 THEN RAISE EXCEPTION '% note(s) changed beyond the four bodies.', n; END IF;

  SELECT count(*) INTO n FROM methodology_note
   WHERE regexp_replace(body, 'legislation\.gov\.uk', '', 'g') ~ '([a-z]+_[a-z_]+|[a-z_]+\.[a-z_]+)';
  IF n > 0 THEN RAISE EXCEPTION '% note(s) still name a column.', n; END IF;

  SELECT body INTO b FROM methodology_note WHERE code = 'M13';
  IF b ~ 'the difference is the bills still before the Parliament' OR b ~ 'never reached its final stage' THEN
    RAISE EXCEPTION 'M13 has one of the two withdrawn drafts in it again.';
  END IF;
  IF b !~ 'shown blank' OR b !~ 'nought days' THEN
    RAISE EXCEPTION 'M13 no longer says a session with no completed stage is blank rather than zero.';
  END IF;

  SELECT count(*) INTO n FROM methodology_note; IF n <> 14 THEN RAISE EXCEPTION '% notes', n; END IF;
  SELECT count(*) INTO n FROM bill; IF n <> 470 THEN RAISE EXCEPTION '% bills', n; END IF;
  SELECT count(*) INTO n FROM field_source; IF n <> 192 THEN RAISE EXCEPTION '% provenance notes', n; END IF;
  SELECT count(*) INTO n FROM v_candidate_problems; IF n <> 0 THEN RAISE EXCEPTION 'checker %', n; END IF;

  RAISE NOTICE 'M13, M1, M4 and M11 changed as approved; no note names a column. Nothing else changed.';
END $$;

COMMIT;
