-- db/092_why_session_6s_ten_bills_fell.sql
--
-- Step 7 of the runbook for Session 6. The fact sheet says ten bills "Fell" and
-- nothing more; the word covers three different things, and telling them apart
-- is one of the questions this database exists to answer. All ten were read,
-- the seven the loader left uncoded and the three it proposed as having run out
-- of time alike, because that proposal rests only on the bill having concluded
-- on the day the session ended, which is necessary and not sufficient.
--
-- All ten are Member's Bills. The ten split three ways.
--
-- FIVE WERE REJECTED AT STAGE 1, every one on the member in charge's own motion
-- being disagreed to. Each is recorded with its route, the motion and its mover,
-- and the Presiding Officer's announcement quoted.
--
--   400  Disabled Children and Young People (Transitions to Adulthood)
--          23 November 2023  S6M-11381  Pam Duncan-Glancy   19 / 90 / 0
--   405  Scottish Employment Injuries Advisory Council
--          18 April 2024     S6M-12882  Mark Griffin        20 / 95 / 0
--   404  Right to Addiction Recovery
--          9 October 2025    S6M-19128  Douglas Ross        52 / 63 / 0
--   407  Wellbeing and Sustainable Development
--          22 January 2026   S6M-20414  Sarah Boyack        25 / 91 / 0
--   403  Prostitution (Offences and Support)
--          3 February 2026   S6M-20627  Ash Regan           54 / 64 / 0
--
-- TWO WERE REJECTED AT STAGE 3, having got all the way through Stages 1 and 2.
-- This is the second and third case of `rejected_stage_3` in the database; the
-- first is the Budget (Scotland) (No.2) Bill of Session 3, decided on the
-- Presiding Officer's casting vote. A Stage 3 rejection takes no route: there is
-- only one way for it to happen, the motion to pass the bill being disagreed to,
-- and the error checker refuses a route on any outcome but a Stage 1 rejection.
--
--   406  Scottish Parliament (Recall of Members)
--          24 February 2026  S6M-20904  Graham Simpson      30 / 66 / 27
--   398  Assisted Dying for Terminally Ill Adults
--          17 March 2026     S6M-21005  Liam McArthur       57 / 69 / 1
--
-- THREE RAN OUT OF TIME, and the loader's proposal stands. None of the three had
-- anything decided on 8 April 2026, and nothing could have been: the Parliament
-- rose for the pre-election recess on 26 March 2026, as the session row itself
-- records. Each bill's last recorded activity is weeks or months before.
--
--   399  Commissioner for Older People. Stage 1 never completed; the lead
--          committee's call for views closed 12 September 2025 and the last
--          thing on the bill is Finance Committee correspondence of 5 February
--          2026.
--   401  Ecocide. Stage 1 completed 5 February 2026, Stage 2 begun 17 February
--          and not finished; last activity 10 March 2026.
--   402  Freedom of Information Reform. Stage 1 completed 17 February 2026,
--          Stage 2 in progress; last activity a letter of 25 March 2026.
--
-- Where each answer comes from. `db/067` sets the order: the Official Report
-- where the Parliament decided, the bill page where it did not. So the seven
-- rejections are read from the Official Report and cite the page they were read
-- on, and the three that ran out of time are read from the Parliament's page for
-- each bill, because there was no decision to read. This is not a formality:
-- for the Disabled Children bill a secondary summary of the division gave
-- figures that are not the ones the Official Report records, and the Official
-- Report is what is written here.
--
-- What is not done here. None of the ten has a stage record yet — there are no
-- rows at all for any of them — so nothing about which stage a bill ended at is
-- recorded by this migration. That comes with the stage dates, and the error
-- checker's rules about the stage a bill fell at will apply then.
--
-- This only changes the staging sheet. Session 6 is not on the clean sheet.

\set ON_ERROR_STOP on
BEGIN;

CREATE TEMP TABLE fell (
  candidate_id integer, title_fragment text, outcome text, route text,
  from_official_report boolean, note text
) ON COMMIT DROP;

INSERT INTO fell VALUES

 (400, 'Disabled Children and Young People', 'rejected_stage_1', 'member_motion_disagreed', true,
  'Outcome from the Official Report, not the fact sheet: general principles not agreed to at '
  || 'Stage 1, 23 November 2023. Route: the member''s motion, S6M-11381 in the name of Pam '
  || 'Duncan-Glancy, disagreed to. Result as recorded: "For 19, Against 90, Abstentions 0. '
  || 'Motion disagreed to." Read at https://www.parliament.scot/chamber-and-committees/'
  || 'official-report/search-what-was-said-in-parliament/meeting-of-parliament-23-11-2023?'
  || 'meeting=15565&iob=132856'),

 (405, 'Scottish Employment Injuries', 'rejected_stage_1', 'member_motion_disagreed', true,
  'Outcome from the Official Report, not the fact sheet: general principles not agreed to at '
  || 'Stage 1, 18 April 2024. Route: the member''s motion, S6M-12882 in the name of Mark '
  || 'Griffin, disagreed to. Result as recorded: "For 20, Against 95, Abstentions 0. Motion '
  || 'disagreed to." Read at https://www.parliament.scot/chamber-and-committees/'
  || 'official-report/search-what-was-said-in-parliament/meeting-of-parliament-18-04-2024?'
  || 'meeting=15804&iob=134939'),

 (404, 'Right to Addiction Recovery', 'rejected_stage_1', 'member_motion_disagreed', true,
  'Outcome from the Official Report, not the fact sheet: general principles not agreed to at '
  || 'Stage 1, 9 October 2025. Route: the member''s motion, S6M-19128 in the name of Douglas '
  || 'Ross, disagreed to. Result as recorded: "For 52, Against 63, Abstentions 0. Motion '
  || 'disagreed to." Read at https://www.parliament.scot/chamber-and-committees/'
  || 'official-report/search-what-was-said-in-parliament/meeting-of-parliament-09-10-2025?'
  || 'meeting=16626&iob=141998'),

 (407, 'Wellbeing and Sustainable Development', 'rejected_stage_1', 'member_motion_disagreed', true,
  'Outcome from the Official Report, not the fact sheet: general principles not agreed to at '
  || 'Stage 1, 22 January 2026. Route: the member''s motion, S6M-20414 in the name of Sarah '
  || 'Boyack, disagreed to. Result as recorded: "For 25, Against 91, Abstentions 0. Motion '
  || 'disagreed to." Read at https://www.parliament.scot/chamber-and-committees/'
  || 'official-report/search-what-was-said-in-parliament/meeting-of-parliament-22-01-2026?'
  || 'meeting=20020&iob=202028'),

 (403, 'Prostitution', 'rejected_stage_1', 'member_motion_disagreed', true,
  'Outcome from the Official Report, not the fact sheet: general principles not agreed to at '
  || 'Stage 1, 3 February 2026. Route: the member''s motion, S6M-20627 in the name of Ash '
  || 'Regan, disagreed to. Result as recorded: "For 54, Against 64, Abstentions 0. Motion '
  || 'disagreed to." Read at https://www.parliament.scot/chamber-and-committees/'
  || 'official-report/search-what-was-said-in-parliament/meeting-of-parliament-03-02-2026?'
  || 'meeting=20044&iob=225275'),

 (406, 'Recall of Members', 'rejected_stage_3', NULL, true,
  'Outcome from the Official Report, not the fact sheet: the bill was rejected at Stage 3, '
  || '24 February 2026, on the motion S6M-20904 in the name of Graham Simpson that it be '
  || 'passed. Result as recorded: "For 30, Against 66, Abstentions 27. Motion disagreed to." '
  || 'The Presiding Officer then: "the Scottish Parliament (Recall of Members) Bill is '
  || 'therefore not passed." The bill was renamed during its Stage 3 proceedings the same '
  || 'day, from the Scottish Parliament (Recall and Removal of Members) Bill; the title it '
  || 'was introduced under is on this line, and the Official Report of that day lists the '
  || 'Stage 3 business under the old title and the decision under the new. Read at '
  || 'https://www.parliament.scot/chamber-and-committees/official-report/'
  || 'search-what-was-said-in-parliament/meeting-of-parliament-24-02-2026?'
  || 'meeting=20092&iob=224668'),

 (398, 'Assisted Dying', 'rejected_stage_3', NULL, true,
  'Outcome from the Official Report, not the fact sheet: the bill was rejected at Stage 3, '
  || '17 March 2026, on the motion S6M-21005 in the name of Liam McArthur that it be passed. '
  || 'Result as recorded: "For 57, Against 69, Abstentions 1. Motion disagreed to." The '
  || 'Presiding Officer then: "The Assisted Dying for Terminally Ill Adults (Scotland) Bill '
  || 'falls." The bill had completed Stage 1 on 13 May 2025 and Stage 2 on 25 November 2025. '
  || 'Read at https://www.parliament.scot/chamber-and-committees/official-report/'
  || 'search-what-was-said-in-parliament/meeting-of-parliament-17-03-2026?'
  || 'meeting=20140&iob=224973'),

 (399, 'Commissioner for Older People', 'fell_dissolution', NULL, false,
  'The loader proposed this from the bill concluding on the day the session ended, and the '
  || 'proposal is checked and stands. The Parliament''s page for the bill says: "The Bill '
  || 'fell at the dissolution of Parliament on 8 April 2026." Nothing was decided that day '
  || 'and nothing could have been: the Parliament rose for the pre-election recess on 26 '
  || 'March 2026. The bill never completed Stage 1; the lead committee''s call for views '
  || 'closed on 12 September 2025 and the last thing recorded on the bill is Finance '
  || 'Committee correspondence of 5 February 2026. Read on 2026-09-15 at '
  || 'https://www.parliament.scot/bills-and-laws/bills/s6/commissioner-for-older-people-scotland-bill'),

 (401, 'Ecocide', 'fell_dissolution', NULL, false,
  'The loader proposed this from the bill concluding on the day the session ended, and the '
  || 'proposal is checked and stands. The Parliament''s page for the bill says: "The Bill '
  || 'fell at the dissolution of Parliament on 8 April 2026." Nothing was decided that day '
  || 'and nothing could have been: the Parliament rose for the pre-election recess on 26 '
  || 'March 2026. The bill completed Stage 1 on 5 February 2026 and was in Stage 2 when the '
  || 'session ended, its last recorded activity being a committee meeting of 10 March 2026. '
  || 'Read on 2026-09-15 at '
  || 'https://www.parliament.scot/bills-and-laws/bills/s6/ecocide-scotland-bill'),

 (402, 'Freedom of Information Reform', 'fell_dissolution', NULL, false,
  'The loader proposed this from the bill concluding on the day the session ended, and the '
  || 'proposal is checked and stands. The Parliament''s page for the bill says: "The Bill '
  || 'fell at the dissolution of Parliament on 8 April 2026." Nothing was decided that day '
  || 'and nothing could have been: the Parliament rose for the pre-election recess on 26 '
  || 'March 2026. The bill completed Stage 1 on 17 February 2026 and was in Stage 2 when the '
  || 'session ended, its last recorded activity being a letter of 25 March 2026. Read on '
  || '2026-09-15 at '
  || 'https://www.parliament.scot/bills-and-laws/bills/s6/freedom-of-information-reform-scotland-bill');

-- ---------------------------------------------------------------------------
-- Nothing is written to a line that is not the one meant
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM fell a JOIN bill_candidate c USING (candidate_id)
   WHERE c.short_title NOT ILIKE '%' || a.title_fragment || '%';
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % row(s) name a line whose title does not match.', n;
  END IF;

  -- Every one must be a Session 6 line the fact sheet put in its Fallen table,
  -- and this must cover all ten of them.
  SELECT count(*) INTO n FROM fell a JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number <> 6 OR c.raw_section <> 'fallen';
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % row(s) are not Session 6 fallen lines.', n;
  END IF;

  SELECT count(*) INTO n FROM bill_candidate
   WHERE session_number = 6 AND raw_section = 'fallen'
     AND candidate_id NOT IN (SELECT candidate_id FROM fell);
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % fallen line(s) this migration does not answer.', n;
  END IF;

  -- The three the loader proposed must be the three this says ran out of time,
  -- and it must not be quietly changing one of them.
  SELECT count(*) INTO n FROM fell a JOIN bill_candidate c USING (candidate_id)
   WHERE c.outcome IS NOT NULL AND c.outcome <> a.outcome;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % line(s) already hold a different outcome.', n;
  END IF;

  SELECT count(*) INTO n FROM fell WHERE outcome = 'fell_dissolution';
  IF n <> 3 THEN RAISE EXCEPTION 'Refusing: % ran out of time, expected 3.', n; END IF;

  -- A route belongs to a Stage 1 rejection and to nothing else.
  SELECT count(*) INTO n FROM fell
   WHERE (route IS NOT NULL) <> (outcome = 'rejected_stage_1');
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % row(s) put a route where one does not belong.', n;
  END IF;

  -- Every answer read from the Official Report must quote the announcement.
  SELECT count(*) INTO n FROM fell
   WHERE from_official_report AND note !~ 'Result as recorded: "[^"]+"';
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % row(s) from the Official Report quote no announcement.', n;
  END IF;

  SELECT count(*) INTO n FROM fell WHERE note !~ 'https?://';
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % row(s) cite no address.', n;
  END IF;

  SELECT count(*) INTO n FROM fell a JOIN bill_candidate c USING (candidate_id)
   WHERE coalesce(c.review_note, '') <> '';
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % line(s) already carry a review note.', n;
  END IF;
END $$;

-- ---------------------------------------------------------------------------
-- What was read
-- ---------------------------------------------------------------------------

UPDATE bill_candidate c
   SET outcome                 = a.outcome,
       stage_1_rejection_route = a.route,
       official_report_read_on = CASE WHEN a.from_official_report
                                      THEN DATE '2026-09-15' ELSE NULL END,
       review_note             = a.note
  FROM fell a
 WHERE a.candidate_id = c.candidate_id;

-- ---------------------------------------------------------------------------
-- What this leaves
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM bill_candidate
   WHERE session_number = 6 AND raw_section = 'fallen' AND outcome IS NULL;
  IF n <> 0 THEN RAISE EXCEPTION '% fallen line(s) still have no outcome.', n; END IF;

  SELECT count(*) INTO n FROM bill_candidate
   WHERE session_number = 6 AND outcome = 'rejected_stage_1';
  IF n <> 5 THEN RAISE EXCEPTION '% Stage 1 rejection(s), expected 5.', n; END IF;

  SELECT count(*) INTO n FROM bill_candidate
   WHERE session_number = 6 AND outcome = 'rejected_stage_3';
  IF n <> 2 THEN RAISE EXCEPTION '% Stage 3 rejection(s), expected 2.', n; END IF;

  SELECT count(*) INTO n FROM bill_candidate
   WHERE session_number = 6 AND outcome = 'fell_dissolution';
  IF n <> 3 THEN RAISE EXCEPTION '% ran out of time, expected 3.', n; END IF;

  -- Every rejection carries its Official Report date; nothing else does.
  SELECT count(*) INTO n FROM bill_candidate
   WHERE session_number = 6 AND raw_section = 'fallen'
     AND (official_report_read_on IS NOT NULL)
         <> (outcome IN ('rejected_stage_1','rejected_stage_3'));
  IF n <> 0 THEN RAISE EXCEPTION '% line(s) date the Official Report wrongly.', n; END IF;

  -- The checker had seven complaints about these lines and should have none.
  SELECT count(*) INTO n FROM v_candidate_problems
   WHERE problem = 'outcome not proposed — needs a judgement';
  IF n <> 0 THEN RAISE EXCEPTION '% line(s) still need a judgement.', n; END IF;

  SELECT count(*) INTO n FROM v_candidate_problems p
   WHERE p.candidate_id IN (SELECT candidate_id FROM bill_candidate
                             WHERE session_number = 6 AND raw_section = 'fallen');
  IF n <> 0 THEN RAISE EXCEPTION 'The checker still finds % problem(s) on the ten.', n; END IF;

  -- The clean sheet is not touched by any of this.
  SELECT count(*) INTO n FROM bill;
  IF n <> 389 THEN RAISE EXCEPTION '% bills on the clean sheet, expected 389.', n; END IF;

  SELECT count(*) INTO n FROM field_source;
  IF n <> 112 THEN RAISE EXCEPTION '% provenance notes, expected 112.', n; END IF;

  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n <> 15 THEN
    RAISE EXCEPTION 'The error checker finds % problem(s), expected 15.', n;
  END IF;

  RAISE NOTICE 'Ten bills read: 5 rejected at Stage 1, 2 at Stage 3, 3 ran out of time. 15 problem(s) left for step 9.';
END $$;

COMMIT;
