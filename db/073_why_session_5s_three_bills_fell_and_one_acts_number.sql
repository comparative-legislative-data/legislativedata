-- db/073_why_session_5s_three_bills_fell_and_one_acts_number.sql
--
-- The four things the error checker asked for when Session 5 was read in on
-- 2026-09-14. All four were settled by the owner the same day, from the sources
-- quoted on each line. This is db/055 again for a new session, in the same
-- shape and with nothing new in it: no column, no value, no rule.
--
-- Three of Session 5's seven fallen bills did not run out of time. Each lost a
-- division on its own Stage 1 motion, which is the ordinary route and the one
-- 15 of the 19 rejections already on the clean sheet took. The fact sheet lists
-- them under "Bills fallen" and says no more, exactly as Session 3's and
-- Session 4's did.
--
--   Culpable Homicide (Scotland) Bill, line 306, 21 January 2021.
--   Post-mortem Examinations (Defence Time Limit) (Scotland) Bill, line 309,
--     26 January 2021.
--   Restricted Roads (20 mph Speed Limit) (Scotland) Bill, line 310,
--     13 June 2019.
--
-- Where the evidence came from, because it is not quite the usual way round.
-- The owner found all three on the Parliament's Session 5 bill pages, which
-- print the division figures and, for two of the three, name the motion -- more
-- than the fact sheet gives and more than the bill pages gave for earlier
-- sessions. The record cited here is still the Official Report, because that is
-- where the Parliament decided, which is the order settled on 2026-09-13 (see
-- db/067). The figures agree between the two sources on all three bills. The
-- checker has required the Presiding Officer's announcement and the Official
-- Report's address on the line since db/031 and db/058, and nothing here asks
-- it to accept anything less.
--
-- The Restricted Roads announcement does not name the motion on its page. The
-- number and the member are taken from the Parliament's bill page and the line
-- says so. Only the Official Report's address appears on the line, because
-- promotion cites the first address it finds and that must be the record of the
-- decision.
--
-- The fourth thing is not a rejection. The Period Products (Free Provision)
-- (Scotland) Act, line 360, is the first Act whose number the fact sheet prints
-- without a year -- "(asp 1)". db/062 made that a refusal rather than something
-- to notice. It is settled at legislation.gov.uk in the "Checked:" form db/042
-- established, and the year agrees with the Royal Assent date already on the
-- line.
--
-- This only changes the staging sheet. Session 5 is not on the clean sheet.

\set ON_ERROR_STOP on
BEGIN;

-- ---------------------------------------------------------------------------
-- 1. The three codings
--
--    Each line names the meeting whose Official Report was read, the motion put
--    and who moved it, and quotes the Presiding Officer after "Result as
--    recorded:", which is the form the checker requires and the words
--    promotion keeps as the route's provenance.
-- ---------------------------------------------------------------------------

CREATE TEMP TABLE coding (
  candidate_id integer, title_fragment text, outcome text, route text,
  decided_on date, url text, note text
) ON COMMIT DROP;

INSERT INTO coding VALUES

 (306, 'Culpable Homicide', 'rejected_stage_1', 'member_motion_disagreed',
  DATE '2021-01-21',
  'https://www.parliament.scot/chamber-and-committees/official-report/search-what-was-said-in-parliament/meeting-of-parliament-21-01-2021?meeting=13068&iob=118279',
  'Outcome from the Official Report, not the factsheet: general principles not agreed to at '
  || 'Stage 1, 21 January 2021. Route: the member''s motion, S5M-23917 in the name of Claire '
  || 'Baker, disagreed to. Result as recorded: "For 26, Against 89, Abstentions 0. Motion '
  || 'disagreed to." Read at '
  || 'https://www.parliament.scot/chamber-and-committees/official-report/search-what-was-said-in-parliament/meeting-of-parliament-21-01-2021?meeting=13068&iob=118279'),

 (309, 'Post-mortem Examinations', 'rejected_stage_1', 'member_motion_disagreed',
  DATE '2021-01-26',
  'https://www.parliament.scot/chamber-and-committees/official-report/search-what-was-said-in-parliament/meeting-of-parliament-26-01-2021?meeting=13077&iob=118361',
  'Outcome from the Official Report, not the factsheet: general principles not agreed to at '
  || 'Stage 1, 26 January 2021. Route: the member''s motion, S5M-23803 in the name of Gil '
  || 'Paterson, disagreed to. Result as recorded: "For 26, Against 90, Abstentions 1. Motion '
  || 'disagreed to." Read at '
  || 'https://www.parliament.scot/chamber-and-committees/official-report/search-what-was-said-in-parliament/meeting-of-parliament-26-01-2021?meeting=13077&iob=118361'),

 (310, 'Restricted Roads', 'rejected_stage_1', 'member_motion_disagreed',
  DATE '2019-06-13',
  'https://www.parliament.scot/chamber-and-committees/official-report/search-what-was-said-in-parliament/meeting-of-parliament-13-06-2019?meeting=12183&iob=110075',
  'Outcome from the Official Report, not the factsheet: general principles not agreed to at '
  || 'Stage 1, 13 June 2019. Route: the member''s motion, S5M-17660 in the name of Mark '
  || 'Ruskell, disagreed to. Result as recorded: "For 26, Against 83, Abstentions 4. Motion '
  || 'disagreed to." The Presiding Officer''s announcement on this page does not name the '
  || 'motion; the number and the member are from the Parliament''s own bill page for the bill, '
  || 'which gives motion S5M-17660, lodged by Mark Ruskell on 11 June 2019: "That the '
  || 'Parliament agrees to the general principles of the Restricted Roads (20 mph Speed Limit) '
  || '(Scotland) Bill." Read at '
  || 'https://www.parliament.scot/chamber-and-committees/official-report/search-what-was-said-in-parliament/meeting-of-parliament-13-06-2019?meeting=12183&iob=110075');

-- A mistyped line number must fail here, not write to the wrong bill.
DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM coding a JOIN bill_candidate c USING (candidate_id)
   WHERE c.short_title NOT ILIKE '%' || a.title_fragment || '%';
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % coding row(s) name a line whose title does not match.', n;
  END IF;

  SELECT count(*) INTO n FROM coding a JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number <> 5;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % coding row(s) name a line that is not in Session 5.', n;
  END IF;

  SELECT count(*) INTO n FROM coding a JOIN bill_candidate c USING (candidate_id)
   WHERE c.outcome IS NOT NULL;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % line(s) already hold an outcome.', n;
  END IF;

  SELECT count(*) INTO n FROM coding a JOIN bill_candidate c USING (candidate_id)
   WHERE c.date_concluded IS DISTINCT FROM a.decided_on;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % line(s) conclude on a day other than the one the Official Report gives.', n;
  END IF;

  -- The day each bill fell must not be the day the session ended, or the bill
  -- would be a dissolution faller and this coding would be wrong.
  SELECT count(*) INTO n FROM coding a
    JOIN bill_candidate c USING (candidate_id)
    JOIN session s ON s.session_number = c.session_number
   WHERE a.decided_on = s.date_session_end;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % line(s) were decided on the day the session ended.', n;
  END IF;
END $$;

UPDATE bill_candidate c
   SET outcome                 = a.outcome,
       stage_1_rejection_route = a.route,
       official_report_read_on = DATE '2026-09-14',
       review_note             = btrim(coalesce(c.review_note || E'\n', '') || a.note)
  FROM coding a
 WHERE a.candidate_id = c.candidate_id;

-- ---------------------------------------------------------------------------
-- 2. Where each bill stopped, on the stage-dates sheet
--
--    Stage 1, not completed, and the stage the bill fell at. The owner's own
--    dates for Session 5 are not loaded yet; when they are, each of these gets
--    a second row from the PhD dataset and the checker compares the two.
-- ---------------------------------------------------------------------------

INSERT INTO stage_candidate
       (candidate_id, stage, date_completed, completed, fell_here,
        source, source_ref, observed_at)
SELECT a.candidate_id, 'stage_1', a.decided_on, false, true,
       'official_report', a.url, DATE '2026-09-14'
  FROM coding a
 WHERE NOT EXISTS (SELECT 1 FROM stage_candidate s
                    WHERE s.candidate_id = a.candidate_id AND s.stage = 'stage_1');

-- ---------------------------------------------------------------------------
-- 3. The Act number the fact sheet printed without its year
-- ---------------------------------------------------------------------------

DO $$
DECLARE v text;
BEGIN
  SELECT asp_number INTO v FROM bill_candidate WHERE candidate_id = 360;
  IF v IS DISTINCT FROM 'asp 1' THEN
    RAISE EXCEPTION 'Refusing: line 360 holds asp_number %, not the % the factsheet printed.',
                    quote_literal(v), quote_literal('asp 1');
  END IF;
END $$;

UPDATE bill_candidate
   SET asp_number  = '2021 asp 1',
       review_note = btrim(coalesce(review_note || E'\n', '')
       || 'Checked: asp_number = 2021 asp 1 (legislation_gov_uk, '
       || 'https://www.legislation.gov.uk/asp/2021/1/enacted, 2026-09-14)' || E'\n'
       || 'The factsheet prints the number as "(asp 1)" and gives no year, which db/062 '
       || 'refuses. legislation.gov.uk gives "Period Products (Free Provision) (Scotland) '
       || 'Act 2021" and "2021 asp 1". The year agrees with the Royal Assent date of '
       || '12 January 2021 already on the line.')
 WHERE candidate_id = 360;

-- ---------------------------------------------------------------------------
-- 4. What this leaves
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n <> 0 THEN
    RAISE EXCEPTION 'The error checker still finds % problem(s). Session 5 is not ready.', n;
  END IF;

  SELECT count(*) INTO n FROM bill_candidate
   WHERE session_number = 5 AND outcome = 'rejected_stage_1';
  IF n <> 3 THEN RAISE EXCEPTION '% Session 5 rejections, expected 3.', n; END IF;

  SELECT count(*) INTO n FROM bill_candidate
   WHERE session_number = 5 AND outcome = 'fell_dissolution';
  IF n <> 4 THEN RAISE EXCEPTION '% Session 5 dissolution fallers, expected 4.', n; END IF;

  SELECT count(*) INTO n FROM bill;
  IF n <> 302 THEN RAISE EXCEPTION '% bills on the clean sheet, expected 302.', n; END IF;

  RAISE NOTICE 'Session 5: 3 rejected at Stage 1, 4 fell at dissolution, error checker empty, 302 bills untouched.';
END $$;

COMMIT;
