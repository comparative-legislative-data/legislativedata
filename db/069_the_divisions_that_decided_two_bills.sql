-- db/069_the_divisions_that_decided_two_bills.sql
--
-- The two bills rejected at Stage 1 by their own motion being amended now
-- publish both divisions that decided them. Settled by the owner on
-- 2026-09-14. See DECISIONS.md.
--
-- Why. This route decides a bill twice: once on the amendment, which turns the
-- member in charge's motion into its opposite, and once on the motion as
-- amended, which formally ends the bill. The first is where the bill is in fact
-- lost; the second is the one that looks like a defeat and is the lesser of the
-- two as a measure of support. Giving only the second misleads -- the
-- Transplantation Bill's amendment carried by three votes and its motion as
-- amended by seventeen -- and giving only the first omits the decision that
-- ended the bill. Both are given, in the order they were taken.
--
-- The figures are not new. Every Stage 1 rejection in this database already
-- carries its division against the bill, in the Official Report's own words.
-- This moves them into the text a reader sees, for these two bills only.
--
-- Which bills. The two rejected by this route: bill 68, the Proportional
-- Representation (Local Government Elections) (Scotland) Bill of Session 1, and
-- bill 302, the Transplantation (Authorisation of Removal of Organs etc.)
-- (Scotland) Bill of Session 4. Bill 68 already published the amendment's
-- division and gains the motion's; bill 302 published neither and gains both.
-- The fifteen bills rejected on the ordinary route and the two rejected on a
-- committee's motion are deliberately not touched: they have no published note,
-- and one that only repeated a figure already recorded against the bill would
-- earn its place less than one explaining an unusual route.
--
-- Bill 68's two divisions differ by one member moving from abstaining to
-- against between them -- 65/54/2 on the amendment, 65/53/3 on the motion as
-- amended. Both are as the Official Report records them and the owner has
-- confirmed both; the near-identical For counts are a coincidence, not a slip.
--
-- Both sessions are on the clean sheet, so this changes the staging line and
-- the published note together, and then checks the two are the same text. The
-- note a reader sees is copied from the staging line every time a session is
-- put on, so changing the clean sheet alone would be undone by the next
-- promotion.
--
-- Source. Already recorded: the Official Report of 6 February 2003 for bill 68
-- and of 9 February 2016 for bill 302, both cited against the bill with the
-- day they were read. No new provenance is written and none is changed.
--
-- M7 is amended to say that these figures are prose and not vote data. A
-- structured record of divisions is intended later in this project; when it
-- arrives it supersedes them.

\set ON_ERROR_STOP on
BEGIN;

-- ---------------------------------------------------------------- before
DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM bill_candidate c JOIN bill b ON b.bill_id = c.promoted_bill_id
   WHERE c.candidate_id = 68 AND c.promoted_bill_id = 68
     AND b.stage_1_rejection_route = 'member_motion_amended_agreed'
     AND c.bill_note = b.note
     AND c.bill_note LIKE '%(For 65, Against 54, Abstentions 2) turned it into a motion%'
     AND c.bill_note NOT LIKE '%Against 53%';
  IF n <> 1 THEN
    RAISE EXCEPTION 'Refusing: line 68 is not the Proportional Representation Bill as expected.';
  END IF;

  SELECT count(*) INTO n FROM bill_candidate c JOIN bill b ON b.bill_id = c.promoted_bill_id
   WHERE c.candidate_id = 302 AND c.promoted_bill_id = 302
     AND b.stage_1_rejection_route = 'member_motion_amended_agreed'
     AND c.bill_note = b.note
     AND c.bill_note LIKE '%was amended by S4M-15128.1 in the name of Maureen Watt into a motion%'
     AND c.bill_note NOT LIKE '%Abstentions%';
  IF n <> 1 THEN
    RAISE EXCEPTION 'Refusing: line 302 is not the Transplantation Bill as db/064 left it.';
  END IF;

  SELECT count(*) INTO n FROM bill WHERE stage_1_rejection_route = 'member_motion_amended_agreed';
  IF n <> 2 THEN
    RAISE EXCEPTION 'Refusing: % bills are rejected by this route, not 2.', n;
  END IF;

  -- How many bills publish a note at all, so the check afterwards can prove
  -- that none gained one and none lost one. Six today: the four bills rejected
  -- at Stage 1 by an unusual route, and the Robin Rigg and Forth Crossing Acts,
  -- whose notes are about something else entirely.
  CREATE TEMP TABLE notes_before ON COMMIT DROP AS
    SELECT bill_id FROM bill WHERE note IS NOT NULL AND note <> '';
END $$;

-- ------------------------------------------------- bill 68, both divisions
UPDATE bill_candidate
   SET bill_note = replace(bill_note,
         'turned it into a motion that did not agree to the general principles.',
         'turned it into a motion that did not agree to the general principles, and the '
         || 'Parliament then agreed to it as amended (For 65, Against 53, Abstentions 3).')
 WHERE candidate_id = 68;

-- ------------------------------------------------ bill 302, both divisions
UPDATE bill_candidate
   SET bill_note = replace(bill_note,
         'was amended by S4M-15128.1 in the name of Maureen Watt into a motion that did not '
         || 'agree to the bill''s general principles, and was then agreed to as amended on '
         || '9 February 2016.',
         'was amended by S4M-15128.1 in the name of Maureen Watt (For 59, Against 56, '
         || 'Abstentions 0) into a motion that did not agree to the bill''s general '
         || 'principles, and was then agreed to as amended on 9 February 2016 (For 65, '
         || 'Against 48, Abstentions 2).')
 WHERE candidate_id = 302;

-- ------------------------------------- carry both onto the published notes
UPDATE bill b SET note = c.bill_note
  FROM bill_candidate c
 WHERE c.promoted_bill_id = b.bill_id AND c.candidate_id IN (68, 302);

-- ------------------------------------------------------ what M7 now says
UPDATE methodology_note
   SET body = body || E'\n\nWhere a division decided how a bill was rejected, its figures are '
       || 'given in bill.note as the Official Report records them. A bill rejected by its own '
       || 'motion being amended was decided twice, once on the amendment and once on the motion '
       || 'as amended, and both divisions are given: the first is where the bill was in fact '
       || 'lost and the second where it formally ended, and the two can differ widely enough '
       || 'that either alone would mislead. A structured record of how members voted is not yet '
       || 'part of this resource. These figures are prose beside a bill, not data: they cannot '
       || 'be counted, and when a record of divisions is added it supersedes them.'
 WHERE code = 'M7';

-- ----------------------------------------------------------------- after
DO $$
DECLARE n integer; n68 text; n302 text; m7 text;
BEGIN
  SELECT note INTO n68  FROM bill WHERE bill_id = 68;
  SELECT note INTO n302 FROM bill WHERE bill_id = 302;
  SELECT body INTO m7   FROM methodology_note WHERE code = 'M7';

  -- Bill 68: both divisions, and what was already there still there.
  IF n68 NOT LIKE '%(For 65, Against 54, Abstentions 2)%' THEN
    RAISE EXCEPTION 'Check failed: bill 68 lost the amendment''s division.';
  END IF;
  IF n68 NOT LIKE '%(For 65, Against 53, Abstentions 3)%' THEN
    RAISE EXCEPTION 'Check failed: bill 68 did not gain the motion''s division.';
  END IF;
  IF n68 NOT LIKE '%S1M-3727.1 in the name of Iain Smith%'
     OR n68 NOT LIKE '%renewing local democracy%'
     OR n68 NOT LIKE '%meeting-of-parliament-06-02-2003%' THEN
    RAISE EXCEPTION 'Check failed: bill 68''s note lost text it had.';
  END IF;

  -- Bill 302: both divisions, and db/064's motion still whole.
  IF n302 NOT LIKE '%(For 59, Against 56, Abstentions 0)%' THEN
    RAISE EXCEPTION 'Check failed: bill 302 did not gain the amendment''s division.';
  END IF;
  IF n302 NOT LIKE '%(For 65, Against 48, Abstentions 2)%' THEN
    RAISE EXCEPTION 'Check failed: bill 302 did not gain the motion''s division.';
  END IF;
  IF n302 NOT LIKE '%"That the Parliament does not agree to the general principles%'
     OR n302 NOT LIKE '%to consider bringing forward legislation as appropriate."%'
     OR n302 NOT LIKE '%learning from the experiences in Wales%'
     OR n302 NOT LIKE '%the fate of the motion and the fate of the bill point opposite ways%' THEN
    RAISE EXCEPTION 'Check failed: bill 302''s note lost text db/064 put there.';
  END IF;

  -- The published note and the line it is copied from are the same text.
  SELECT count(*) INTO n FROM bill_candidate c JOIN bill b ON b.bill_id = c.promoted_bill_id
   WHERE c.candidate_id IN (68, 302) AND c.bill_note IS DISTINCT FROM b.note;
  IF n <> 0 THEN
    RAISE EXCEPTION 'Check failed: % published note(s) differ from their staging line.', n;
  END IF;

  -- Nothing else gained a note, and no coding moved.
  SELECT count(*) INTO n FROM (
      SELECT bill_id FROM bill WHERE note IS NOT NULL AND note <> ''
      EXCEPT SELECT bill_id FROM notes_before
    UNION ALL
      SELECT bill_id FROM notes_before
      EXCEPT SELECT bill_id FROM bill WHERE note IS NOT NULL AND note <> ''
  ) AS moved;
  IF n <> 0 THEN
    RAISE EXCEPTION 'Check failed: % bill(s) gained or lost a published note.', n;
  END IF;

  SELECT count(*) INTO n FROM bill
   WHERE stage_1_rejection_route = 'member_motion_amended_agreed'
     AND outcome = 'rejected_stage_1';
  IF n <> 2 THEN RAISE EXCEPTION 'Check failed: the coding of the two bills moved.'; END IF;

  -- M7 says what a reader needs and the other seven are untouched.
  IF m7 NOT LIKE '%not yet part of this resource%'
     OR m7 NOT LIKE '%both divisions are given%' THEN
    RAISE EXCEPTION 'Check failed: M7 does not say what it should.';
  END IF;
  SELECT count(*) INTO n FROM methodology_note WHERE body IS NULL OR body = '';
  IF n <> 0 THEN RAISE EXCEPTION 'Check failed: % methodology note(s) are empty.', n; END IF;

  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n <> 0 THEN RAISE EXCEPTION 'The error checker is no longer empty: % item(s).', n; END IF;
  SELECT count(*) INTO n FROM v_stage_date_gaps;
  IF n <> 0 THEN RAISE EXCEPTION 'The gaps list is no longer empty: % item(s).', n; END IF;

  RAISE NOTICE 'Bill 68 note: % characters. Bill 302 note: % characters. M7: % characters.',
               length(n68), length(n302), length(m7);
END $$;

COMMIT;
