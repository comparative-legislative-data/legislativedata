-- db/095_where_session_6s_fourteen_bills_ended.sql
--
-- Step 9 of the runbook for Session 6, and the thing standing between Session 6
-- and its stage dates. Nothing new in it: no column, no value, no rule. Every
-- row below is a shape the clean sheet already holds, and the same shape
-- db/075 wrote for Session 5's six.
--
-- tools/phd_stage_dates.py refuses a whole session outright if any bill in it
-- that did not pass has nothing on the stage-dates sheet saying where it
-- stopped. Session 6 has fourteen such bills and not one stage row between
-- them. Two of the fourteen reached Stage 3 and the loader writes their first
-- two stages itself; the other twelve need a row saying where they ended, and
-- two of those twelve completed a stage first. Sixteen rows in all.
--
-- WHERE EACH ANSWER COMES FROM. db/067 sets the order: the Official Report
-- where the Parliament decided, the Parliament's page for the bill where it did
-- not. Seven of the fourteen were decided and their rows cite the Official
-- Report page read on 15 September, already quoted on each line's review_note
-- by db/092. The other seven were not decided and their rows cite the bill
-- page, read on 15 September.
--
-- FIVE WERE REJECTED AT STAGE 1. Each stopped at Stage 1 without completing it,
-- on the day the member in charge's own motion was disagreed to. The date is
-- the day of the decision, which is also the day the bill concluded; the error
-- checker requires those two to be the same date, and refuses a row like this
-- at any position but Stage 1.
--
--   400  Disabled Children and Young People (Transitions to Adulthood)  2023-11-23
--   405  Scottish Employment Injuries Advisory Council                  2024-04-18
--   404  Right to Addiction Recovery                                    2025-10-09
--   407  Wellbeing and Sustainable Development                          2026-01-22
--   403  Prostitution (Offences and Support)                            2026-02-03
--
-- TWO WERE REJECTED AT STAGE 3, having completed Stages 1 and 2 first. Only the
-- Stage 3 row is written here: the two stages before it are dated by the owner's
-- dataset and the loader writes them, which is the whole point of not blocking
-- it. The checker refuses a Stage 3 rejection recorded at any other position.
--
--   406  Scottish Parliament (Recall of Members)                        2026-02-24
--   398  Assisted Dying for Terminally Ill Adults                       2026-03-17
--
-- THREE RAN OUT OF TIME, and their pages say where each had got to on the day
-- the session ended. One had not completed Stage 1; two had, and were in
-- Stage 2. The row where a bill ran out of time carries no date: the session
-- ending is not a decision about the bill, and 8 April 2026 is already on each
-- line as the day it concluded.
--
--   399  Commissioner for Older People    "fell at Stage 1", Stage 2 never reached
--   401  Ecocide                          Stage 1 ended 2026-02-05, then fell at Stage 2
--   402  Freedom of Information Reform    Stage 1 ended 2026-02-17, then fell at Stage 2
--
-- The two Stage 1 dates are the Parliament's own words on each page -- "The Bill
-- ended Stage 1 on 5 February 2026" and "... on 17 February 2026" -- and the
-- owner's dataset gives the same two dates independently. That agreement is
-- what the loader will check when it runs; it is recorded here because the
-- page, not the dataset, is the source that says so.
--
-- FOUR WERE WITHDRAWN, and had not completed Stage 1 when they were. All four
-- pages say it in the same words, and each gives the same withdrawal date the
-- fact sheet already put on the line. No date is recorded on these rows for the
-- reason db/075 gave for Session 5's six: the row says where the bill stopped,
-- and the day it stopped is held on its line.
--
--   408  Desecration of War Memorials     withdrawn 2026-02-03
--   409  Disability Commissioner          withdrawn 2025-09-30
--   410  Leases (Automatic Continuation etc.)  withdrawn 2025-09-10
--   411  Prevention of Domestic Abuse     withdrawn 2026-01-16
--
-- WHAT IS DELIBERATELY NOT RECORDED. Ecocide's page lists two Stage 2 committee
-- meetings, 17 February and 10 March 2026, and Freedom of Information Reform's
-- lists none at all -- its financial resolution was not agreed until 5 March
-- 2026, and until one is agreed Stage 2 cannot get under way. The day a bill
-- reached a stage has a column of its own since db/088, but M11 says it is
-- never worked out and only ever recorded where a source states it, and neither
-- page states when the bill reached Stage 2. Both rows are therefore left
-- without one. Whether a committee meeting date should be read as the day a
-- bill reached Stage 2 is a question for the owner, and it is not opened here.
--
-- This only changes the staging sheet. Session 6 is not on the clean sheet.

\set ON_ERROR_STOP on
BEGIN;

-- ---------------------------------------------------------------------------
-- The sixteen rows, and what each rests on
-- ---------------------------------------------------------------------------

CREATE TEMP TABLE ending (
  candidate_id  integer,
  title_fragment text,
  stage         text,
  date_completed date,
  completed     boolean,
  fell_here     boolean,
  source        text,
  source_ref    text,
  detail_note   text
) ON COMMIT DROP;

INSERT INTO ending VALUES

-- Five rejected at Stage 1. Each cites the Official Report of the day, and the
-- division and the Presiding Officer's words are quoted on the line (db/092).
 (400, 'Disabled Children', 'stage_1', DATE '2023-11-23', false, true, 'official_report',
  'https://www.parliament.scot/chamber-and-committees/official-report/search-what-was-said-in-parliament/meeting-of-parliament-23-11-2023?meeting=15565&iob=132856',
  'The bill stopped here: the Parliament disagreed to the motion that its general principles be agreed to. The motion, its mover and the division are on the line.'),
 (405, 'Employment Injuries', 'stage_1', DATE '2024-04-18', false, true, 'official_report',
  'https://www.parliament.scot/chamber-and-committees/official-report/search-what-was-said-in-parliament/meeting-of-parliament-18-04-2024?meeting=15804&iob=134939',
  'The bill stopped here: the Parliament disagreed to the motion that its general principles be agreed to. The motion, its mover and the division are on the line.'),
 (404, 'Right to Addiction Recovery', 'stage_1', DATE '2025-10-09', false, true, 'official_report',
  'https://www.parliament.scot/chamber-and-committees/official-report/search-what-was-said-in-parliament/meeting-of-parliament-09-10-2025?meeting=16626&iob=141998',
  'The bill stopped here: the Parliament disagreed to the motion that its general principles be agreed to. The motion, its mover and the division are on the line.'),
 (407, 'Wellbeing and Sustainable Development', 'stage_1', DATE '2026-01-22', false, true, 'official_report',
  'https://www.parliament.scot/chamber-and-committees/official-report/search-what-was-said-in-parliament/meeting-of-parliament-22-01-2026?meeting=20020&iob=202028',
  'The bill stopped here: the Parliament disagreed to the motion that its general principles be agreed to. The motion, its mover and the division are on the line.'),
 (403, 'Prostitution', 'stage_1', DATE '2026-02-03', false, true, 'official_report',
  'https://www.parliament.scot/chamber-and-committees/official-report/search-what-was-said-in-parliament/meeting-of-parliament-03-02-2026?meeting=20044&iob=225275',
  'The bill stopped here: the Parliament disagreed to the motion that its general principles be agreed to. The motion, its mover and the division are on the line.'),

-- Two rejected at Stage 3. Stages 1 and 2 are left for the loader.
 (406, 'Recall of Members', 'stage_3', DATE '2026-02-24', false, true, 'official_report',
  'https://www.parliament.scot/chamber-and-committees/official-report/search-what-was-said-in-parliament/meeting-of-parliament-24-02-2026?meeting=20092&iob=224668',
  'The bill stopped here: the Parliament disagreed to the motion that the bill be passed, having completed Stages 1 and 2. The motion, its mover and the division are on the line.'),
 (398, 'Assisted Dying', 'stage_3', DATE '2026-03-17', false, true, 'official_report',
  'https://www.parliament.scot/chamber-and-committees/official-report/search-what-was-said-in-parliament/meeting-of-parliament-17-03-2026?meeting=20140&iob=224973',
  'The bill stopped here: the Parliament disagreed to the motion that the bill be passed, having completed Stages 1 and 2. The motion, its mover and the division are on the line.'),

-- Three ran out of time.
 (399, 'Commissioner for Older People', 'stage_1', NULL, false, true, 'bill_page',
  'https://www.parliament.scot/bills-and-laws/bills/s6/commissioner-for-older-people-scotland-bill',
  'The bill stopped here, undecided, when the session ended. The page reads: "Commissioner for Older People (Scotland) Bill fell on 08 April 2026", with "Stage 2 has not been reached yet" below it, and "This Bill fell at Stage 1 of the process to decide if it should become an Act."'),
 (401, 'Ecocide', 'stage_1', DATE '2026-02-05', true, false, 'bill_page',
  'https://www.parliament.scot/bills-and-laws/bills/s6/ecocide-scotland-bill',
  'From the Parliament''s page for the bill, which reads: "The Bill ended Stage 1 on 5 February 2026." The owner''s dataset gives the same date.'),
 (401, 'Ecocide', 'stage_2', NULL, false, true, 'bill_page',
  'https://www.parliament.scot/bills-and-laws/bills/s6/ecocide-scotland-bill',
  'The bill stopped here, undecided, when the session ended. The page reads: "Ecocide (Scotland) Bill fell on 08 April 2026" under Stage 2, and "This Bill fell at Stage 2 of the process to decide if it should become an Act." The Stage 2 committee met on it twice, on 17 February and 10 March 2026.'),
 (402, 'Freedom of Information Reform', 'stage_1', DATE '2026-02-17', true, false, 'bill_page',
  'https://www.parliament.scot/bills-and-laws/bills/s6/freedom-of-information-reform-scotland-bill',
  'From the Parliament''s page for the bill, which reads: "The Bill ended Stage 1 on 17 February 2026." The owner''s dataset gives the same date.'),
 (402, 'Freedom of Information Reform', 'stage_2', NULL, false, true, 'bill_page',
  'https://www.parliament.scot/bills-and-laws/bills/s6/freedom-of-information-reform-scotland-bill',
  'The bill stopped here, undecided, when the session ended. The page reads: "Freedom of Information Reform (Scotland) Bill fell on 08 April 2026" under Stage 2, and "This Bill fell at Stage 2 of the process to decide if it should become an Act." No Stage 2 committee meeting is listed: the bill''s financial resolution was not agreed until 5 March 2026, and until one is agreed Stage 2 cannot get under way.'),

-- Four withdrawn, none having completed Stage 1.
 (408, 'Desecration of War Memorials', 'stage_1', NULL, false, true, 'bill_page',
  'https://www.parliament.scot/bills-and-laws/bills/s6/desecration-of-war-memorials-scotland-bill',
  'The bill stopped here. The page reads: "Desecration of War Memorials (Scotland) Bill fell on 03 February 2026", with "Stage 2 has not been reached yet" below it, and "This Bill was withdrawn at Stage 1 of the process to determine if it should become an Act." The day it was withdrawn is on the line.'),
 (409, 'Disability Commissioner', 'stage_1', NULL, false, true, 'bill_page',
  'https://www.parliament.scot/bills-and-laws/bills/s6/disability-commissioner-scotland-bill',
  'The bill stopped here. The page reads: "Disability Commissioner (Scotland) Bill fell on 30 September 2025", with "Stage 2 has not been reached yet" below it, and "This Bill was withdrawn at Stage 1 of the process to determine if it should become an Act." The day it was withdrawn is on the line.'),
 (410, 'Leases', 'stage_1', NULL, false, true, 'bill_page',
  'https://www.parliament.scot/bills-and-laws/bills/s6/leases-automatic-continuation-etc-scotland-bill',
  'The bill stopped here. The page reads: "Leases (Automatic Continuation etc.) (Scotland) Bill fell on 10 September 2025", with "Stage 2 has not been reached yet" below it, and "This Bill was withdrawn at Stage 1 of the process to determine if it should become an Act." The day it was withdrawn is on the line.'),
 (411, 'Prevention of Domestic Abuse', 'stage_1', NULL, false, true, 'bill_page',
  'https://www.parliament.scot/bills-and-laws/bills/s6/prevention-of-domestic-abuse-scotland-bill',
  'The bill stopped here. The page reads: "Prevention of Domestic Abuse (Scotland) Bill fell on 16 January 2026", with "Stage 2 has not been reached yet" below it, and "This Bill was withdrawn at Stage 1 of the process to determine if it should become an Act." The day it was withdrawn is on the line.');

-- ---------------------------------------------------------------------------
-- Refusals: a mistyped line number must fail here, not record the wrong bill
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM ending a JOIN bill_candidate c USING (candidate_id)
   WHERE c.short_title NOT ILIKE '%' || a.title_fragment || '%';
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % row(s) name a line whose title does not match.', n;
  END IF;

  SELECT count(*) INTO n FROM ending a JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number <> 6;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % row(s) name a line that is not in Session 6.', n;
  END IF;

  -- A bill that passed has no ending to record.
  SELECT count(*) INTO n FROM ending a JOIN bill_candidate c USING (candidate_id)
   WHERE c.outcome IS NULL OR c.outcome = 'passed';
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % line(s) passed or have no outcome.', n;
  END IF;

  -- Nothing may be recorded twice, and no line may be given a second ending.
  SELECT count(*) INTO n FROM ending a JOIN stage_candidate s USING (candidate_id);
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % line(s) already hold a stage row.', n;
  END IF;

  -- Every bill of Session 6 that did not pass must be here, and only those.
  SELECT count(*) INTO n FROM bill_candidate c
   WHERE c.session_number = 6 AND c.review_status <> 'rejected'
     AND c.outcome <> 'passed'
     AND NOT EXISTS (SELECT 1 FROM ending a WHERE a.candidate_id = c.candidate_id);
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % Session 6 bill(s) that did not pass are not named here.', n;
  END IF;

  -- Where the bill ended: exactly one row per line, and the two that reached
  -- Stage 3 end there while the twelve that did not end before it.
  SELECT count(*) INTO n FROM (SELECT candidate_id FROM ending WHERE fell_here
                                GROUP BY candidate_id HAVING count(*) <> 1) x;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % line(s) do not have exactly one ending.', n;
  END IF;

  SELECT count(*) INTO n FROM ending a JOIN bill_candidate c USING (candidate_id)
   WHERE a.fell_here AND (a.stage = 'stage_3') <> (c.outcome = 'rejected_stage_3');
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % ending(s) are at the wrong stage for the outcome.', n;
  END IF;

  -- A decision that ended a bill is dated the day the bill concluded; a bill
  -- that ran out of time or was withdrawn carries no date on its ending.
  SELECT count(*) INTO n FROM ending a JOIN bill_candidate c USING (candidate_id)
   WHERE a.fell_here AND c.outcome IN ('rejected_stage_1', 'rejected_stage_3')
     AND a.date_completed IS DISTINCT FROM c.date_concluded;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % rejection(s) are not dated the day the bill concluded.', n;
  END IF;

  SELECT count(*) INTO n FROM ending a JOIN bill_candidate c USING (candidate_id)
   WHERE a.fell_here AND c.outcome NOT IN ('rejected_stage_1', 'rejected_stage_3')
     AND a.date_completed IS NOT NULL;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % ending(s) are dated where nothing decided anything.', n;
  END IF;

  -- A completed stage must be dated, and must sit inside the bill's own life.
  SELECT count(*) INTO n FROM ending a JOIN bill_candidate c USING (candidate_id)
   WHERE a.completed AND (a.date_completed IS NULL
         OR a.date_completed <= c.date_introduced
         OR a.date_completed >= c.date_concluded);
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % completed stage(s) are undated or outside the bill''s life.', n;
  END IF;

  -- A rejection is read from the Official Report; everything else from the
  -- bill page. This is db/067's order, stated as a refusal.
  SELECT count(*) INTO n FROM ending a JOIN bill_candidate c USING (candidate_id)
   WHERE (a.source = 'official_report') <> (c.outcome IN ('rejected_stage_1','rejected_stage_3'));
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % row(s) cite the wrong kind of source for the outcome.', n;
  END IF;

  -- A row citing the Official Report must cite the page the line already does.
  SELECT count(*) INTO n FROM ending a JOIN bill_candidate c USING (candidate_id)
   WHERE a.source = 'official_report'
     AND a.source_ref IS DISTINCT FROM substring(c.review_note from 'Read at (\S+)');
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % row(s) cite a different Official Report page from the line.', n;
  END IF;
END $$;

-- ---------------------------------------------------------------------------

INSERT INTO stage_candidate
       (candidate_id, stage, date_completed, completed, fell_here,
        source, source_ref, observed_at, detail_note)
SELECT a.candidate_id, a.stage, a.date_completed, a.completed, a.fell_here,
       a.source, a.source_ref, DATE '2026-09-15', a.detail_note
  FROM ending a
 ORDER BY a.candidate_id, a.stage;

-- ---------------------------------------------------------------------------
-- What this leaves
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM stage_candidate s JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number = 6 AND s.fell_here;
  IF n <> 14 THEN RAISE EXCEPTION '% Session 6 ending(s) recorded, expected 14.', n; END IF;

  -- The whole point: no Session 6 bill is left without an ending.
  SELECT count(*) INTO n FROM v_stage_date_gaps
   WHERE session_number = 6 AND stage_order IS NULL;
  IF n <> 0 THEN
    RAISE EXCEPTION '% Session 6 bill(s) still do not say where they ended.', n;
  END IF;

  -- The checker must find nothing new. Its one standing problem is Session 7's
  -- line waiting on Session 6's promotion.
  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n <> 1 THEN
    RAISE EXCEPTION 'The error checker finds % problem(s), expected 1.', n;
  END IF;

  SELECT count(*) INTO n FROM v_candidate_problems WHERE session_number = 6;
  IF n <> 0 THEN
    RAISE EXCEPTION 'The error checker finds % problem(s) on Session 6, expected none.', n;
  END IF;

  -- The clean sheet is not touched by any of this.
  SELECT count(*) INTO n FROM bill;
  IF n <> 389 THEN RAISE EXCEPTION '% bills on the clean sheet, expected 389.', n; END IF;

  SELECT count(*) INTO n FROM stage_event;
  IF n <> 1071 THEN RAISE EXCEPTION '% stage records, expected 1071.', n; END IF;

  SELECT count(*) INTO n FROM field_source;
  IF n <> 112 THEN RAISE EXCEPTION '% provenance notes, expected 112.', n; END IF;

  SELECT count(*) INTO n FROM v_stage_date_gaps;
  RAISE NOTICE 'Fourteen endings recorded, and two Stage 1 dates with them. Gaps list now %, all of it dates. 389 bills untouched.', n;
END $$;

COMMIT;
