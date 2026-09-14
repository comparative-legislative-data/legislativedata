-- db/075_where_session_5s_six_bills_ended_and_one_acts_two_dates.sql
--
-- The two things standing between Session 5 and its stage dates, settled by the
-- owner on 2026-09-14 from the Parliament's own bill pages. Nothing new in it:
-- no column, no value, no rule. Both are shapes the clean sheet already holds.
--
-- 1. Six bills that did not pass have nothing on the stage-dates sheet saying
--    where they ended. tools/phd_stage_dates.py refuses to run for a session
--    with such a bill in it, and would refuse the whole of Session 5 for these
--    six, so they come first. Each of the six pages says the same thing in the
--    same words: the bill "fell on" a date under Stage 1, with "Stage 2 has not
--    been reached yet" below it. So each stopped at Stage 1 without completing
--    it, and none has a decision behind it. They get the row the other 21 bills
--    that fell or were withdrawn already have: Stage 1, not completed, fell
--    here, and no date, because there was no decision to date.
--
--      307 Disabled Children and Young People (Transitions to Adulthood)
--      308 Fair Rents
--      311 Travelling Funfairs (Licensing)
--      312 Welfare of Dogs
--      313 Children and Young People (Information Sharing)
--      314 Liability for NHS Charges (Treatment of Industrial Disease)
--
--    The first four fell at dissolution, the last two were withdrawn. The
--    distinction is already coded on their lines and nothing here touches it;
--    what they have in common is that no stage was completed, so the row is the
--    same for all six.
--
--    This also disposes of the Fair Rents page contradicting itself on the day
--    the bill fell -- 4 May in its status line, 5 May a sentence below. No date
--    is recorded on a row of this kind, so nothing turns on which is right. The
--    day the bill fell is held on its line, from the fact sheet, as 4 May.
--
--    The Welfare of Dogs page has moved. The plain address now redirects into
--    the National Records of Scotland web archive, which is refusing automated
--    readers, because the Session 6 bill of the same name has taken it. The
--    Session 5 bill is at the address cited below, which ends "-session-5".
--
-- 2. The Domestic Abuse (Protection) (Scotland) Act 2021, line 339, has no row
--    at all in the owner's dataset -- the reason Session 5 reads 87 bills
--    against the dataset's 86 (DECISIONS.md, 2026-09-14). Its Stage 1 and
--    Stage 2 dates come from its own bill page instead, which is the source
--    that says so and the order settled on 2026-09-13 (db/067). Two stage dates
--    on the clean sheet already cite a bill page, so this is not new ground.
--
--      Stage 1  28 January 2021   "A Stage 1 debate took place on 28 January 2021"
--      Stage 2  23 February 2021  "The Bill ended Stage 2 on 23 February 2021"
--
--    The same page gives introduction 2 October 2020, Stage 3 on 17 March 2021
--    and Royal Assent 5 May 2021, all three agreeing with what the fact sheet
--    already put on the line. The checks below refuse the two dates if they do
--    not sit inside the bill's own life, which is what that agreement is for.
--
-- This only changes the staging sheet. Session 5 is not on the clean sheet.

\set ON_ERROR_STOP on
BEGIN;

-- ---------------------------------------------------------------------------
-- 1. Where the six bills ended
-- ---------------------------------------------------------------------------

CREATE TEMP TABLE ended (
  candidate_id integer, title_fragment text, url text
) ON COMMIT DROP;

INSERT INTO ended VALUES
 (307, 'Disabled Children',
  'https://www.parliament.scot/bills-and-laws/bills/s5/disabled-children-and-young-people-transitions-to-adulthood-scotland-bill'),
 (308, 'Fair Rents',
  'https://www.parliament.scot/bills-and-laws/bills/s5/fair-rents-scotland-bill'),
 (311, 'Travelling Funfairs',
  'https://www.parliament.scot/bills-and-laws/bills/s5/travelling-funfairs-licensing-scotland-bill'),
 (312, 'Welfare of Dogs',
  'https://www.parliament.scot/bills-and-laws/bills/s5/welfare-of-dogs-scotland-bill-session-5'),
 (313, 'Information Sharing',
  'https://www.parliament.scot/bills-and-laws/bills/s5/children-and-young-people-information-sharing-scotland-bill'),
 (314, 'Liability for NHS Charges',
  'https://www.parliament.scot/bills-and-laws/bills/s5/liability-for-nhs-charges-treatment-of-industrial-disease-scotland-bill');

DO $$
DECLARE n integer;
BEGIN
  -- A mistyped line number must fail here, not record the wrong bill's ending.
  SELECT count(*) INTO n FROM ended a JOIN bill_candidate c USING (candidate_id)
   WHERE c.short_title NOT ILIKE '%' || a.title_fragment || '%';
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % row(s) name a line whose title does not match.', n;
  END IF;

  SELECT count(*) INTO n FROM ended a JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number <> 5;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % row(s) name a line that is not in Session 5.', n;
  END IF;

  -- A bill that passed, or is still going, has no ending to record.
  SELECT count(*) INTO n FROM ended a JOIN bill_candidate c USING (candidate_id)
   WHERE c.outcome IS NULL OR c.outcome IN ('passed', 'in_progress');
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % line(s) did not end without passing.', n;
  END IF;

  -- Nothing may be recorded after the stage a bill ended at, so a line that
  -- already says where it ended must not be given a second answer.
  SELECT count(*) INTO n FROM ended a JOIN stage_candidate s USING (candidate_id)
   WHERE s.fell_here;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % line(s) already say where the bill ended.', n;
  END IF;

  -- The page says Stage 2 was never reached, so nothing may be held at or
  -- after it either.
  SELECT count(*) INTO n FROM ended a JOIN stage_candidate s USING (candidate_id)
   WHERE s.stage_order >= 2;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % line(s) hold a stage the bill never reached.', n;
  END IF;
END $$;

INSERT INTO stage_candidate
       (candidate_id, stage, date_completed, completed, fell_here,
        source, source_ref, observed_at)
SELECT a.candidate_id, 'stage_1', NULL, false, true,
       'bill_page', a.url, DATE '2026-09-14'
  FROM ended a;

-- ---------------------------------------------------------------------------
-- 2. The two dates the dataset does not have
-- ---------------------------------------------------------------------------

DO $$
DECLARE c record;
BEGIN
  SELECT short_title, session_number, outcome, date_introduced, date_royal_assent
    INTO c FROM bill_candidate WHERE candidate_id = 339;

  IF c.short_title NOT ILIKE '%Domestic Abuse (Protection)%' THEN
    RAISE EXCEPTION 'Refusing: line 339 is %, not the Domestic Abuse (Protection) Act.',
                    quote_literal(c.short_title);
  END IF;
  IF c.session_number <> 5 THEN
    RAISE EXCEPTION 'Refusing: line 339 is in Session %, not Session 5.', c.session_number;
  END IF;
  IF c.outcome <> 'passed' THEN
    RAISE EXCEPTION 'Refusing: line 339 did not pass, so it has no completed Stage 1 and 2.';
  END IF;

  -- The dates must sit inside the bill's own life, as the same page gives it.
  IF DATE '2021-01-28' <= c.date_introduced OR DATE '2021-02-23' <= DATE '2021-01-28'
     OR DATE '2021-02-23' >= c.date_royal_assent THEN
    RAISE EXCEPTION 'Refusing: the two dates do not run introduction -> Stage 1 -> Stage 2 -> Royal Assent.';
  END IF;

  IF EXISTS (SELECT 1 FROM stage_candidate
              WHERE candidate_id = 339 AND stage_order IN (1, 2)) THEN
    RAISE EXCEPTION 'Refusing: line 339 already holds a Stage 1 or Stage 2 row.';
  END IF;
END $$;

INSERT INTO stage_candidate
       (candidate_id, stage, date_completed, completed, fell_here,
        source, source_ref, observed_at, review_note)
VALUES
 (339, 'stage_1', DATE '2021-01-28', true, false, 'bill_page',
  'https://www.parliament.scot/bills-and-laws/bills/s5/domestic-abuse-protection-scotland-bill',
  DATE '2026-09-14',
  'From the Parliament''s bill page, not the PhD dataset, which has no row for this bill at '
  || 'all. The page reads: "A Stage 1 debate took place on 28 January 2021."'),
 (339, 'stage_2', DATE '2021-02-23', true, false, 'bill_page',
  'https://www.parliament.scot/bills-and-laws/bills/s5/domestic-abuse-protection-scotland-bill',
  DATE '2026-09-14',
  'From the Parliament''s bill page, not the PhD dataset, which has no row for this bill at '
  || 'all. The page reads: "The Bill ended Stage 2 on 23 February 2021."');

-- ---------------------------------------------------------------------------
-- 3. What this leaves
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n <> 0 THEN
    RAISE EXCEPTION 'The error checker finds % problem(s). Session 5 is not ready.', n;
  END IF;

  SELECT count(*) INTO n FROM v_stage_date_gaps
   WHERE session_number = 5 AND stage_order IS NULL;
  IF n <> 0 THEN
    RAISE EXCEPTION '% Session 5 bill(s) still do not say where they ended.', n;
  END IF;

  SELECT count(*) INTO n FROM v_stage_date_gaps WHERE candidate_id = 339;
  IF n <> 0 THEN
    RAISE EXCEPTION 'Line 339 still has % date(s) missing.', n;
  END IF;

  SELECT count(*) INTO n FROM bill;
  IF n <> 302 THEN RAISE EXCEPTION '% bills on the clean sheet, expected 302.', n; END IF;

  SELECT count(*) INTO n FROM v_stage_date_gaps;
  RAISE NOTICE 'Six endings and two dates recorded. Gaps list now %, all of it Session 5 dates from the dataset. 302 bills untouched.', n;
END $$;

COMMIT;
