-- 029_session_2_fallen_bills_coded.sql
--
-- Why six Session 2 bills fell, coded against the Official Report. The
-- factsheet lists all ten fallen bills under one heading and says why for none
-- of them (methodology note M7). Four fell on the dissolution date, 2 April 2007,
-- and the extractor already proposed fell_dissolution for those. These are the
-- other six.
--
-- This records the judgement and its citations. It admits nothing: the lines
-- stay 'new' until the owner has read all 81 Session 2 lines, and admission is
-- its own step, as db/016 was for Session 1. Session 1's equivalent coding was
-- typed into Postico and has no record of its own; this does.
--
-- All six were rejected at Stage 1, and every decision date matches the date the
-- factsheet gives, which the update below requires.
--
-- Two of them did not reach the vote by the usual route (DECISIONS.md,
-- 2026-09-11). The Rail Passenger Services and Civil Appeals Bills were not
-- defeated on the member's motion. The Presiding Officer had stated each to be
-- outwith competence, the lead committee lodged a motion under Rule 9.14.18 that
-- the Parliament does not agree to the general principles, and the Parliament
-- agreed. The outcome is still rejection at Stage 1: the Parliament decided on
-- the general principles. The route is recorded in the review note for now, and
-- becomes a variable of its own after Session 2 is promoted.
--
-- Which limb of 9.14.18 is our view, not a formal fact. Neither motion cites a
-- limb. The committees' stated grounds repeat the words of limb (b), outwith
-- legislative competence, without its letter. The rule text is read from the
-- current Standing Orders and taken to be unchanged since 2006.
--
-- THE SHAPE OF EACH NOTE MATTERS. promote_session.sql files a provenance note
-- for the outcome from it: the words before the first link become the value
-- seen, and the first link becomes the reference. So each note is the outcome
-- sentence, then the link to the decision, and only then anything else — the
-- route, our view on the limb, further citations. That tail is our commentary,
-- stays in the review note, and never reaches the provenance note.

BEGIN;

DO $$
DECLARE n integer;
BEGIN
  UPDATE bill_candidate c
     SET outcome          = 'rejected_stage_1',
         end_stage_1_date = v.decided::date,
         review_note      = v.note
    FROM (VALUES
      ('35', '2006-01-25',
       'Outcome from the Official Report, not the factsheet: general principles not agreed to at Stage 1, 25 January 2006. '
       'https://www.parliament.scot/chamber-and-committees/official-report/search-what-was-said-in-parliament/meeting-of-parliament-25-01-2006?meeting=4629&iob=36212 '
       'Route: the member''s motion, S2M-3808 in the name of Colin Fox, disagreed to: For 40, Against 77, Abstentions 1.'),

      ('72', '2007-03-21',
       'Outcome from the Official Report, not the factsheet: general principles not agreed to at Stage 1, 21 March 2007. '
       'https://www.parliament.scot/chamber-and-committees/official-report/search-what-was-said-in-parliament/meeting-of-parliament-21-03-2007?meeting=4717&iob=38461 '
       'Route: the member''s motion, S2M-5758 in the name of John Swinney, disagreed to: For 47, Against 64, Abstentions 2. '
       'Rejected twelve days before dissolution, so not a dissolution case.'),

      ('77', '2006-12-20',
       'Outcome from the Official Report, not the factsheet: general principles not agreed to at Stage 1, 20 December 2006. '
       'https://www.parliament.scot/chamber-and-committees/official-report/search-what-was-said-in-parliament/meeting-of-parliament-20-12-2006?meeting=4695&iob=37886 '
       'Route: a committee motion under Rule 9.14.18, S2M-5246 in the name of David Davidson for the Justice 2 Committee, that the Parliament does not agree to the general principles: agreed, For 75, Against 36, Abstentions 0. '
       'Limb, our view: 9.14.18(b), clearly outwith legislative competence. The motion cites no limb. In the chamber the convener gave as grounds that the majority of the bill is outwith competence and unlikely to be brought within it by amendment at Stages 2 and 3, which are the words of (b), and described the rest as rendered nugatory; Adam Ingram said the committee acted under rule 9.14.18. '
       'Debate: https://www.parliament.scot/chamber-and-committees/official-report/search-what-was-said-in-parliament/meeting-of-parliament-20-12-2006?meeting=4695&iob=37883 '
       'Not yet read: the Justice 2 Committee''s own record of its decision. Rule text from the current Standing Orders, taken as unchanged since 2006.'),

      ('31', '2006-02-01',
       'Outcome from the Official Report, not the factsheet: general principles not agreed to at Stage 1, 1 February 2006. '
       'https://www.parliament.scot/chamber-and-committees/official-report/search-what-was-said-in-parliament/meeting-of-parliament-01-02-2006?meeting=4631&iob=36271 '
       'Route: the member''s motion, S2M-3893 in the name of Tommy Sheridan, disagreed to: For 12, Against 94, Abstentions 6.'),

      ('63', '2007-01-31',
       'Outcome from the Official Report, not the factsheet: general principles not agreed to at Stage 1, 31 January 2007. '
       'https://www.parliament.scot/chamber-and-committees/official-report/search-what-was-said-in-parliament/meeting-of-parliament-31-01-2007?meeting=4703&iob=38089 '
       'Route: the member''s motion, S2M-5478 in the name of Bill Butler, disagreed to: For 55, Against 64, Abstentions 0.'),

      ('78', '2006-11-09',
       'Outcome from the Official Report, not the factsheet: general principles not agreed to at Stage 1, 9 November 2006. '
       'https://www.parliament.scot/chamber-and-committees/official-report/search-what-was-said-in-parliament/meeting-of-parliament-09-11-2006?meeting=4684&iob=37614 '
       'Route: a committee motion under Rule 9.14.18, S2M-5018 in the name of Bristow Muldoon for the Local Government and Transport Committee, that the Parliament does not agree to the general principles: agreed, For 99, Against 16, Abstentions 0. '
       'Limb, our view: 9.14.18(b), clearly outwith legislative competence. The motion cites no limb, but the committee''s recommendation repeats the words of (b) without its letter: "on the grounds that, in the opinion of the Committee, having regard to the terms of the Presiding Officer''s statement on legislative competence under Rule 9.3.1, the Bill appears to be clearly outwith the legislative competence of the Parliament and it is unlikely to be possible to amend it at Stages 2 and 3 to bring it within legislative competence". '
       'Local Government and Transport Committee, Official Report, 24 October 2006, col 4163: https://webarchive.nrscotland.gov.uk/public/+/archive.scottish.parliament.uk/business/committees/lg/or-06/lg06-2502.htm#Col4163 '
       'The Presiding Officer''s statement held the bill outwith competence because railway services are reserved (Scotland Act 1998, Schedule 5, Section E2). Rule text from the current Standing Orders, taken as unchanged since 2006.')
    ) AS v(sp_bill_id, decided, note)
   WHERE c.session_number   = 2
     AND c.raw_section      = 'fallen'
     AND c.sp_bill_id       = v.sp_bill_id
     AND c.date_concluded   = v.decided::date   -- the Official Report agrees with the factsheet
     AND c.outcome          IS NULL             -- never overwrite a judgement already made
     AND c.review_status    = 'new';

  GET DIAGNOSTICS n = ROW_COUNT;
  IF n <> 6 THEN
    RAISE EXCEPTION 'Expected to code 6 Session 2 fallen bills, coded %. Nothing written.', n;
  END IF;

  SELECT count(*) INTO n FROM v_candidate_problems WHERE session_number = 2;
  IF n > 0 THEN
    RAISE EXCEPTION 'Session 2 still has % problem(s) after coding. Nothing written.', n;
  END IF;
END $$;

COMMIT;
