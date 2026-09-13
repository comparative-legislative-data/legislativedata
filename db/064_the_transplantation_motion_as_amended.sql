-- db/064_the_transplantation_motion_as_amended.sql
--
-- The Transplantation Bill's motion as amended, recorded in full. Supplied by
-- the owner on 2026-09-13. See DECISIONS.md.
--
-- What this replaces. db/063 recorded that the bill was rejected at Stage 1 by
-- the member in charge's own motion being amended into one that did not agree to
-- the general principles and then agreed to as amended, and it ended by saying
-- the wording was not printed in the Official Report for that day. That was true
-- of the page the result was read on and it is still true of that page. It was
-- the wrong thing to leave there: the text exists, and a reader meeting the only
-- bill of its session rejected this way should be able to read what the
-- Parliament actually resolved instead of a note saying we could not find it.
--
-- Why it matters beyond this bill. The resolution is the whole difference
-- between this route and the ordinary one. On the ordinary route the Parliament
-- simply declines to agree the general principles and says nothing else. Here it
-- declined them AND resolved what should happen instead -- a soft opt-out system,
-- a consultation, and legislation in the next session if appropriate -- so the
-- rejection carries a policy direction that a count of rejections cannot see.
-- That is why ref_stage_1_rejection_route asks for the reason the resolution
-- gives to be kept on the bill, and until now it was not kept.
--
-- Quoted in full and not summarised. This text is published beside the bill.
--
-- Source. The owner's own record; the motion as amended is not printed on the
-- Official Report page the division was read on, which is cited on the line and
-- stays cited there.
--
-- This only changes the staging sheet. Session 4 is not on the clean sheet.

\set ON_ERROR_STOP on
BEGIN;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM bill_candidate
   WHERE candidate_id = 302
     AND short_title LIKE 'Transplantation%'
     AND stage_1_rejection_route = 'member_motion_amended_agreed'
     AND bill_note LIKE '%The amendment''s own wording is not printed%';
  IF n <> 1 THEN
    RAISE EXCEPTION 'Refusing: line 302 is not the Transplantation Bill as db/063 left it.';
  END IF;
  SELECT count(*) INTO n FROM bill_candidate WHERE promoted_bill_id IS NOT NULL AND session_number = 4;
  IF n > 0 THEN RAISE EXCEPTION 'Refusing: Session 4 has reached the clean sheet.'; END IF;
END $$;

UPDATE bill_candidate
   SET bill_note = replace(bill_note,
         'The amendment''s own wording is not printed in the Official Report for that day.',
         'The motion as amended, which is what the Parliament resolved, reads in full: '
         || '"That the Parliament does not agree to the general principles of the '
         || 'Transplantation (Authorisation of Removal of Organs etc.) (Scotland) Bill because '
         || 'it has serious concerns about the practical impact of the specific details in the '
         || 'bill that relate to organ donation rates and transplants; agrees the merits of '
         || 'developing a workable soft opt-out system for Scotland, and calls on the Scottish '
         || 'Government to commence work in preparation for a detailed consultation on further '
         || 'methods to increase organ donations and transplants in Scotland, including soft '
         || 'opt-out, as an early priority in the next parliamentary session, learning from the '
         || 'experiences in Wales, which is currently implementing its own opt-out legislation, '
         || 'and to consider bringing forward legislation as appropriate." The amendment''s own '
         || 'wording is not printed in the Official Report for that day; this is the motion it '
         || 'produced.')
 WHERE candidate_id = 302;

DO $$
DECLARE n integer; note text;
BEGIN
  SELECT bill_note INTO note FROM bill_candidate WHERE candidate_id = 302;

  -- The text is there, whole, and in quotation marks.
  IF note NOT LIKE '%"That the Parliament does not agree to the general principles%' THEN
    RAISE EXCEPTION 'Check failed: the motion does not open as it should.';
  END IF;
  IF note NOT LIKE '%to consider bringing forward legislation as appropriate."%' THEN
    RAISE EXCEPTION 'Check failed: the motion does not close as it should.';
  END IF;
  IF note NOT LIKE '%learning from the experiences in Wales%' THEN
    RAISE EXCEPTION 'Check failed: the middle of the motion is missing.';
  END IF;

  -- What db/063 wrote is still there: the route is still explained.
  IF note NOT LIKE '%S4M-15128.1 in the name of Maureen Watt%'
     OR note NOT LIKE '%the fate of the motion and the fate of the bill point opposite ways%' THEN
    RAISE EXCEPTION 'Check failed: db/063''s account of the route was lost.';
  END IF;

  -- The sentence this replaces is gone as a standalone claim.
  IF note LIKE '%agreed to as amended on 9 February 2016. The motion carried and the bill fell, so the fate of the motion and the fate of the bill point opposite ways. The amendment''s own wording is not printed in the Official Report for that day.' THEN
    RAISE EXCEPTION 'Check failed: the note was not changed.';
  END IF;

  -- Nothing else moved.
  SELECT count(*) INTO n FROM bill_candidate
   WHERE candidate_id = 302 AND outcome = 'rejected_stage_1'
     AND stage_1_rejection_route = 'member_motion_amended_agreed'
     AND date_concluded = DATE '2016-02-09';
  IF n <> 1 THEN RAISE EXCEPTION 'Check failed: the coding of line 302 moved.'; END IF;

  SELECT count(*) INTO n FROM bill_candidate WHERE bill_note IS NOT NULL AND session_number = 4;
  IF n <> 1 THEN RAISE EXCEPTION 'Check failed: % Session 4 line(s) now carry a bill note.', n; END IF;

  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n <> 0 THEN RAISE EXCEPTION 'The error checker is no longer empty: % item(s).', n; END IF;

  RAISE NOTICE 'After: the motion as amended is recorded in full, % characters on the line.',
               length(note);
END $$;

COMMIT;
