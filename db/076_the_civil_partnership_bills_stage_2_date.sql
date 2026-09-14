-- db/076_the_civil_partnership_bills_stage_2_date.sql
--
-- The Civil Partnership (Scotland) Act 2020, line 329, dated at its own bill
-- page after the owner's dataset gave a Stage 2 date that cannot be right.
--
-- What the rehearsal found. Loading Session 5's stage dates was rehearsed on
-- 2026-09-14 and refused: the dataset, row 360, dates Stage 1 at 19 May 2020
-- and Stage 2 at 11 February 2020, three months earlier. The error checker
-- has refused a stage dated before the stage before it since the sheet was
-- built, and it refused this. Nothing was saved.
--
-- What the source says. The Parliament's own bill page gives:
--
--   "A Stage 1 debate took place on 19 May 2020"   -- agrees with the dataset
--   "The Bill ended Stage 2 on 11 June 2020"       -- the day is right, not the month
--
-- The same page gives introduction 30 September 2019, Stage 3 on 23 June 2020
-- and Royal Assent 28 July 2020, all three agreeing with what the fact sheet
-- already put on the line. So this is one month typed wrong in one cell, not a
-- question about the bill, and it is settled at the source that publishes the
-- value -- the order settled on 2026-09-13, db/067.
--
-- Why this comes before the dataset is corrected. The rule settled on
-- 2026-09-14 (db/074, DECISIONS.md): the database is settled first, so the
-- record that the two sources ever disagreed survives the working file being
-- put right. The row below carries what the dataset said, in its own words.
--
-- Once the file is corrected, tools/phd_stage_dates.py writes nothing for this
-- stage: it keeps the source that outranks the dataset and only compares the
-- two. Session 5 then loads 153 rows rather than 154.
--
-- This only changes the staging sheet. Session 5 is not on the clean sheet.

\set ON_ERROR_STOP on
BEGIN;

DO $$
DECLARE c record; s3 date; s2 CONSTANT date := DATE '2020-06-11';
BEGIN
  SELECT short_title, session_number, outcome, date_introduced
    INTO c FROM bill_candidate WHERE candidate_id = 329;

  IF c.short_title NOT ILIKE '%Civil Partnership%' THEN
    RAISE EXCEPTION 'Refusing: line 329 is %, not the Civil Partnership Act.',
                    quote_literal(c.short_title);
  END IF;
  IF c.session_number <> 5 THEN
    RAISE EXCEPTION 'Refusing: line 329 is in Session %, not Session 5.', c.session_number;
  END IF;
  IF c.outcome <> 'passed' THEN
    RAISE EXCEPTION 'Refusing: line 329 did not pass, so it has no completed Stage 2.';
  END IF;

  IF EXISTS (SELECT 1 FROM stage_candidate WHERE candidate_id = 329 AND stage_order = 2) THEN
    RAISE EXCEPTION 'Refusing: line 329 already holds a Stage 2 row.';
  END IF;

  -- The date must sit after the bill was introduced and before the Stage 3
  -- date already held from the fact sheet. Getting the month wrong the other
  -- way would fail here.
  SELECT date_completed INTO s3 FROM stage_candidate
   WHERE candidate_id = 329 AND stage_order = 3;
  IF s3 IS NULL THEN
    RAISE EXCEPTION 'Refusing: line 329 holds no Stage 3 date to check against.';
  END IF;
  IF s2 <= c.date_introduced OR s2 >= s3 THEN
    RAISE EXCEPTION 'Refusing: % does not fall between introduction on % and Stage 3 on %.',
                    s2, c.date_introduced, s3;
  END IF;
END $$;

INSERT INTO stage_candidate
       (candidate_id, stage, date_completed, completed, fell_here,
        source, source_ref, observed_at, review_note)
VALUES
 (329, 'stage_2', DATE '2020-06-11', true, false, 'bill_page',
  'https://www.parliament.scot/bills-and-laws/bills/s5/civil-partnership-scotland-bill',
  DATE '2026-09-14',
  'Checked: stage_2 date_completed = 2020-06-11 (bill_page, '
  || 'https://www.parliament.scot/bills-and-laws/bills/s5/civil-partnership-scotland-bill, '
  || '2026-09-14)' || E'\n'
  || 'The PhD dataset, row 360, dated Stage 2 at 11 February 2020, three months before its own '
  || 'Stage 1 date of 19 May 2020, which the error checker refused when Session 5''s stage dates '
  || 'were rehearsed. The bill page reads: "The Bill ended Stage 2 on 11 June 2020." Its Stage 1 '
  || 'date agrees with the dataset, and its introduction, Stage 3 and Royal Assent dates agree '
  || 'with the fact sheet already on the line, so one month was typed wrong in one cell. The '
  || 'dataset is corrected separately; this row is the record that the two disagreed.');

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n <> 0 THEN
    RAISE EXCEPTION 'The error checker finds % problem(s).', n;
  END IF;

  SELECT count(*) INTO n FROM bill;
  IF n <> 302 THEN RAISE EXCEPTION '% bills on the clean sheet, expected 302.', n; END IF;

  SELECT count(*) INTO n FROM v_stage_date_gaps;
  IF n <> 153 THEN RAISE EXCEPTION 'Gaps list at %, expected 153.', n; END IF;

  RAISE NOTICE 'Line 329 Stage 2 dated 11 June 2020 from the bill page. Gaps list 153. 302 bills untouched.';
END $$;

COMMIT;
