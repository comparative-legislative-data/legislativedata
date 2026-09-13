-- db/067_where_session_4s_two_bills_ended.sql
--
-- The two Session 4 bills that had nothing recording where they had got to,
-- found by writing the closure test rather than by the review. db/056 did the
-- same for Session 3's four. Both were settled by the owner on 2026-09-13 from
-- the sources quoted below, and both are admitted here, because the review that
-- admitted Session 4 (db/066) was over before they were found.
--
-- They are not the same shape as each other, and the second is not the same
-- shape as Session 3's four.
--
--   Inquiries into Deaths (Scotland) Bill, line 296. Withdrawn by the member in
--   charge on 24 September 2015. The Justice Committee had reported on it at
--   Stage 1 (14th Report, 2015), but the Parliament never debated or decided its
--   general principles, so Stage 1 was never completed and there is no date to
--   record. This is Session 3's Criminal Sentencing (Equity Fines) and
--   Palliative Care Bills again.
--
--   Footway Parking and Double Parking (Scotland) Bill, line 300. The Parliament
--   agreed its general principles on 1 March 2016 -- motion S4M-15759 in Sandra
--   White's name, agreed to at Decision Time without a division -- so Stage 1
--   was completed, on the day the owner's dataset also gives. No Stage 2 was
--   scheduled, and the bill fell when the session ended on 23 March 2016. It
--   therefore stopped at Stage 2, undated. This is Session 1's Gaelic Language
--   Bill again: Stage 1 completed 6 March 2003, fell at Stage 2 at dissolution.
--
-- The Parliament's current bill page for the Footway Parking Bill says "The Bill
-- fell at Stage 1 on 23 March 2016". Read literally that contradicts the
-- Official Report, which records the general principles as agreed. It is the
-- site's coarse label -- the bill got no further than Stage 1 -- and the
-- Official Report is the record of what the Parliament decided, which is the
-- order this project already uses: the Official Report where the Parliament
-- decided, the bill page where it did not. Settled by the owner on 2026-09-13.
--
-- Three stage rows, so the closure test's N is 3.
--
-- This only changes the staging sheet. Session 4 is not on the clean sheet.

\set ON_ERROR_STOP on
BEGIN;

-- ---------------------------------------------------------------------------
-- 1. The three rows
-- ---------------------------------------------------------------------------

CREATE TEMP TABLE ending (
  candidate_id integer, title_fragment text, stage text,
  date_completed date, completed boolean, fell_here boolean,
  source text, source_ref text, note text
) ON COMMIT DROP;

INSERT INTO ending VALUES

 (296, 'Inquiries into Deaths', 'stage_1',
  NULL, false, true,
  'bill_page',
  'https://www.parliament.scot/bills-and-laws/bills/s4/inquiries-into-deaths-scotland-bill',
  'Withdrawn by the member in charge on 24 September 2015, before the Parliament debated or '
  || 'decided the bill''s general principles. The bill page records the ending and no stage: '
  || '"On 24 September 2015 the Bill was withdrawn." No Stage 1 date is recorded: the stage '
  || 'was never completed. Patricia Ferguson announced the withdrawal the same day, during the '
  || 'Stage 1 debate on the Government''s Inquiries into Fatal Accidents and Sudden Deaths etc. '
  || '(Scotland) Bill: "In the spirit of that collaboration, I wrote today to the Parliament''s '
  || 'clerk to withdraw my bill with immediate effect."'),

 (300, 'Footway Parking', 'stage_1',
  DATE '2016-03-01', true, false,
  'official_report',
  'https://www.parliament.scot/chamber-and-committees/official-report/search-what-was-said-in-parliament/meeting-of-parliament-01-03-2016?meeting=10400&iob=95714',
  'General principles agreed at Stage 1 on 1 March 2016. Motion S4M-15759, in the name of '
  || 'Sandra White, put at Decision Time and agreed to without a division. Result as recorded: '
  || '"Motion agreed to, That the Parliament agrees to the general principles of the Footway '
  || 'Parking and Double Parking (Scotland) Bill." The owner''s dataset gives the same date.'),

 (300, 'Footway Parking', 'stage_2',
  NULL, false, true,
  'official_report',
  'https://www.parliament.scot/chamber-and-committees/official-report/search-what-was-said-in-parliament/meeting-of-parliament-01-03-2016?meeting=10400&iob=95714',
  'The general principles were agreed at Stage 1 on 1 March 2016, but no Stage 2 proceedings '
  || 'were scheduled for the bill, and it fell at the end of the session on 23 March 2016. No '
  || 'Stage 2 date is recorded: the stage was never reached. The Parliament''s bill page labels '
  || 'this "The Bill fell at Stage 1 on 23 March 2016", meaning the bill got no further than '
  || 'Stage 1; the Official Report is what says the stage itself was completed.');

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
   WHERE c.session_number <> 4;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % ending row(s) name a line outside Session 4.', n;
  END IF;

  SELECT count(*) INTO n FROM ending a JOIN bill_candidate c USING (candidate_id)
   WHERE c.outcome NOT IN ('withdrawn', 'fell_dissolution');
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % ending row(s) name a bill that did not end this way.', n;
  END IF;

  -- Exactly the two bills the gaps list is asking about, and nothing else.
  SELECT count(*) INTO n FROM v_stage_date_gaps
   WHERE gap = 'where the bill ended is not recorded';
  IF n <> 2 THEN
    RAISE EXCEPTION 'Refusing: the gaps list asks % bill(s) where they ended, expected 2.', n;
  END IF;
  SELECT count(*) INTO n FROM v_stage_date_gaps g
   WHERE g.gap = 'where the bill ended is not recorded'
     AND g.candidate_id NOT IN (SELECT candidate_id FROM ending);
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % bill(s) are asked where they ended and are not named here.', n;
  END IF;

  SELECT count(*) INTO n FROM ending a
   WHERE EXISTS (SELECT 1 FROM stage_candidate s
                  WHERE s.candidate_id = a.candidate_id);
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % row(s) name a bill that already has a stage recorded.', n;
  END IF;
END $$;

-- Admitted as they are written: the review that admitted Session 4 was over
-- before these two bills were found, and the owner settled them on 2026-09-13.
INSERT INTO stage_candidate
       (candidate_id, stage, date_completed, completed, fell_here,
        source, source_ref, observed_at, detail_note,
        review_status, review_note, reviewed_at)
SELECT a.candidate_id, a.stage, a.date_completed, a.completed, a.fell_here,
       a.source, a.source_ref, DATE '2026-09-13', a.note,
       'accepted',
       'Settled by the owner on 2026-09-13 from the source named, after Session 4''s '
       || 'review. See db/067 and DECISIONS.md.',
       now()
  FROM ending a;

-- ---------------------------------------------------------------------------
-- 2. What should now be true
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer;
BEGIN
  -- Every Session 4 bill that did not pass now says where it ended.
  SELECT count(*) INTO n FROM bill_candidate c
   WHERE c.session_number = 4
     AND c.outcome NOT IN ('passed', 'in_progress', 'fell_financial_resolution_not_agreed')
     AND NOT EXISTS (SELECT 1 FROM stage_candidate s
                      WHERE s.candidate_id = c.candidate_id AND s.fell_here);
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % Session 4 bill(s) still do not say where they ended.', n;
  END IF;

  -- And nothing anywhere is still asked.
  SELECT count(*) INTO n FROM v_stage_date_gaps
   WHERE gap = 'where the bill ended is not recorded';
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % bill(s) are still listed as not recording where they ended.', n;
  END IF;

  -- The Footway Parking Bill's Stage 1 is the only one of the three that is a
  -- completed, dated stage; the other two are undated endings.
  SELECT count(*) INTO n FROM stage_candidate s JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number = 4
     AND c.short_title ILIKE '%Footway Parking%'
     AND s.stage = 'stage_1'
     AND (s.date_completed <> DATE '2016-03-01' OR NOT s.completed OR s.fell_here);
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: the Footway Parking Bill''s Stage 1 is not a completed 1 March 2016.';
  END IF;

  SELECT count(*) INTO n FROM stage_candidate s JOIN ending a USING (candidate_id)
   WHERE s.stage = a.stage AND a.fell_here
     AND (s.date_completed IS NOT NULL OR s.completed OR NOT s.fell_here);
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % ending row(s) are not undated and uncompleted.', n;
  END IF;

  -- Three rows, which is the closure test's N.
  SELECT count(*) INTO n FROM stage_candidate s JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number = 4 AND c.candidate_id IN (296, 300);
  IF n <> 3 THEN
    RAISE EXCEPTION 'Refusing: the two bills produced % stage row(s), expected 3.', n;
  END IF;

  -- Session 4's stage-dates sheet is 84 + 3, all accepted.
  SELECT count(*) INTO n FROM stage_candidate s JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number = 4 AND s.review_status = 'accepted';
  IF n <> 87 THEN
    RAISE EXCEPTION 'Refusing: Session 4 has % accepted stage dates, expected 87.', n;
  END IF;

  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: the error checker is not empty (% problem(s)).', n;
  END IF;

  -- Nothing reached the clean sheet.
  SELECT count(*) INTO n FROM bill;
  IF n <> 216 THEN
    RAISE EXCEPTION 'The clean sheet moved: % bills, expected 216.', n;
  END IF;

  RAISE NOTICE 'Both Session 4 endings recorded, three rows. Checker empty, clean sheet untouched.';
END $$;

COMMIT;
