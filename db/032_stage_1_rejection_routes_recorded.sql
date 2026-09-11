-- 032_stage_1_rejection_routes_recorded.sql
--
-- The route to rejection for every bill rejected at Stage 1 so far: Session 1's
-- five and Session 2's six. Structure is db/031.
--
-- All eleven were read from the Official Report on 2026-09-11. Session 1's five
-- had first been read on 2026-09-10 for their outcome and Stage 1 date, and were
-- read again today for their route, so today is the date they were last read.
-- Provenance notes are rebuilt when a session is put back (db/030), so their
-- outcome notes will carry today's date, the latest reading.
--
-- For each line, three things are added:
--   - the route;
--   - the date the Official Report was read;
--   - in review_note, the Presiding Officer's announcement in a fixed form,
--     Result as recorded: "…", which promotion quotes as the route's
--     provenance. Appended after the existing note, so the outcome's wording,
--     which promotion takes from before the first link, is untouched. Session
--     1's notes also gain the route in words; Session 2's already have it
--     (db/029).
--
-- Three lines also get a note for the bill, which is what a reader will see:
-- the amendment that rejected the Proportional Representation Bill, and our
-- view of the 9.14.18 limb for the Civil Appeals and Rail Passenger Services
-- Bills.
--
-- Every statement is guarded so it cannot overwrite a judgement already made,
-- and must touch exactly the lines expected or nothing is written.

BEGIN;

-- ---------------------------------------------------------------------------
-- Session 1
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer;
BEGIN
  UPDATE bill_candidate c
     SET stage_1_rejection_route = v.route,
         official_report_read_on = DATE '2026-09-11',
         review_note             = c.review_note || ' ' || v.addition
    FROM (VALUES
      (67, 'Organic Farming Targets (Scotland) Bill', 'member_motion_disagreed',
       'Route: the member in charge''s motion, S1M-3856 in the name of Robin Harper, disagreed to. Result as recorded: "For 39, Against 61, Abstentions 18. Motion disagreed to."'),
      (68, 'Proportional Representation (Local Government Elections) (Scotland) Bill', 'member_motion_amended_agreed',
       'Route: the member in charge''s motion, S1M-3727 in the name of Tricia Marwick, amended by S1M-3727.1 in the name of Iain Smith (For 65, Against 54, Abstentions 2; amendment agreed to) so that it did not agree to the general principles, and agreed to as amended. Result as recorded: "For 65, Against 53, Abstentions 3. Motion, as amended, agreed to."'),
      (69, 'Prostitution Tolerance Zones (Scotland) Bill', 'member_motion_disagreed',
       'Route: the member in charge''s motion, S1M-3939 in the name of Margo MacDonald, disagreed to. Result as recorded: "For 11, Against 86, Abstentions 0. Motion disagreed to."'),
      (70, 'Public Appointments (Parliamentary Approval) (Scotland) Bill', 'member_motion_disagreed',
       'Route: the member in charge''s motion, S1M-2619 in the name of Alex Neil, disagreed to. Result as recorded: "For 50, Against 63, Abstentions 0. Motion disagreed to."'),
      (72, 'School Meals (Scotland) Bill', 'member_motion_disagreed',
       'Route: the member in charge''s motion, S1M-3223 in the name of Tommy Sheridan, disagreed to. Result as recorded: "For 37, Against 74, Abstentions 0. Motion disagreed to."')
    ) AS v(candidate_id, short_title, route, addition)
   WHERE c.candidate_id            = v.candidate_id
     AND c.session_number          = 1
     AND c.short_title             = v.short_title
     AND c.outcome                 = 'rejected_stage_1'
     AND c.stage_1_rejection_route IS NULL
     AND c.promoted_bill_id        IS NULL;   -- Session 1 must be off the clean sheet

  GET DIAGNOSTICS n = ROW_COUNT;
  IF n <> 5 THEN
    RAISE EXCEPTION 'Expected to record 5 Session 1 routes, recorded %. Nothing written.', n;
  END IF;
END $$;

-- ---------------------------------------------------------------------------
-- Session 2
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer;
BEGIN
  UPDATE bill_candidate c
     SET stage_1_rejection_route = v.route,
         official_report_read_on = DATE '2026-09-11',
         review_note             = c.review_note || ' ' || v.addition
    FROM (VALUES
      (145, '35', 'member_motion_disagreed',
       'Result as recorded: "For 40, Against 77, Abstentions 1. Motion disagreed to."'),
      (146, '72', 'member_motion_disagreed',
       'Result as recorded: "For 47, Against 64, Abstentions 2. Motion disagreed to."'),
      (147, '77', 'committee_motion_9_14_18',
       'Result as recorded: "For 75, Against 36, Abstentions 0. Motion agreed to."'),
      (149, '31', 'member_motion_disagreed',
       'Result as recorded: "For 12, Against 94, Abstentions 6. Motion disagreed to."'),
      (151, '63', 'member_motion_disagreed',
       'Result as recorded: "For 55, Against 64, Abstentions 0. Motion disagreed to."'),
      (153, '78', 'committee_motion_9_14_18',
       'Result as recorded: "For 99, Against 16, Abstentions 0. Motion agreed to."')
    ) AS v(candidate_id, sp_bill_id, route, addition)
   WHERE c.candidate_id            = v.candidate_id
     AND c.session_number          = 2
     AND c.sp_bill_id              = v.sp_bill_id
     AND c.outcome                 = 'rejected_stage_1'
     AND c.stage_1_rejection_route IS NULL
     AND c.promoted_bill_id        IS NULL;

  GET DIAGNOSTICS n = ROW_COUNT;
  IF n <> 6 THEN
    RAISE EXCEPTION 'Expected to record 6 Session 2 routes, recorded %. Nothing written.', n;
  END IF;
END $$;

-- ---------------------------------------------------------------------------
-- The notes a reader will see
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer;
BEGIN
  UPDATE bill_candidate c
     SET bill_note = v.note
    FROM (VALUES
      (68, 'member_motion_amended_agreed',
       'Rejected at Stage 1 by the Parliament agreeing to the member in charge''s own motion, S1M-3727 in the name of Tricia Marwick, after amendment S1M-3727.1 in the name of Iain Smith (For 65, Against 54, Abstentions 2) turned it into a motion that did not agree to the general principles. The resolution gives as its reason that the Bill''s "provisions demonstrably do not meet the extensive requirements for renewing local democracy". Official Report, 6 February 2003: https://www.parliament.scot/chamber-and-committees/official-report/search-what-was-said-in-parliament/meeting-of-parliament-06-02-2003?meeting=4426&iob=31672'),
      (147, 'committee_motion_9_14_18',
       'Rule 9.14.18: our view is limb (b), clearly outwith legislative competence. The motion, S2M-5246 in the name of David Davidson for the Justice 2 Committee, cites no limb; the grounds the convener gave in the chamber repeat the words of (b): that the majority of the Bill is outwith legislative competence and unlikely to be brought within it by amendment at Stages 2 and 3. The Presiding Officer had stated provisions of the Bill to be outwith competence. Official Report, 20 December 2006: https://www.parliament.scot/chamber-and-committees/official-report/search-what-was-said-in-parliament/meeting-of-parliament-20-12-2006?meeting=4695&iob=37883'),
      (153, 'committee_motion_9_14_18',
       'Rule 9.14.18: our view is limb (b), clearly outwith legislative competence. The motion, S2M-5018 in the name of Bristow Muldoon for the Local Government and Transport Committee, cites no limb; the Committee''s recommendation repeats the words of (b) without its letter. The Presiding Officer had stated the Bill to be outwith competence because railway services are reserved. Local Government and Transport Committee, Official Report, 24 October 2006, col 4163: https://webarchive.nrscotland.gov.uk/public/+/archive.scottish.parliament.uk/business/committees/lg/or-06/lg06-2502.htm#Col4163')
    ) AS v(candidate_id, route, note)
   WHERE c.candidate_id            = v.candidate_id
     AND c.stage_1_rejection_route = v.route
     AND c.bill_note               IS NULL;

  GET DIAGNOSTICS n = ROW_COUNT;
  IF n <> 3 THEN
    RAISE EXCEPTION 'Expected to write 3 bill notes, wrote %. Nothing written.', n;
  END IF;
END $$;

-- ---------------------------------------------------------------------------
-- Checks
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer;
BEGIN
  -- Every Stage 1 rejection has a route, a read date and a quotable announcement.
  SELECT count(*) INTO n FROM bill_candidate
   WHERE outcome = 'rejected_stage_1'
     AND (stage_1_rejection_route IS NULL
          OR official_report_read_on IS NULL
          OR substring(review_note from 'Result as recorded: "([^"]+)"') IS NULL);
  IF n > 0 THEN
    RAISE EXCEPTION '% Stage 1 rejection(s) still lack a route, a read date or a recorded result.', n;
  END IF;

  SELECT count(*) INTO n FROM v_candidate_problems WHERE session_number IN (1, 2);
  IF n > 0 THEN
    RAISE EXCEPTION 'The error checker still finds % problem(s) in Sessions 1 and 2.', n;
  END IF;
END $$;

COMMIT;
