-- db/112_the_robin_rigg_acts_note_dates_both_stages.sql
--
-- Settled by the owner on 2026-09-17 (docs/PHASE-2-NOTES.md, "The Robin Rigg
-- Act's note, and Session 5's four bills that ran out of time").
--
-- THE GAP. The Robin Rigg Offshore Wind Farm (Navigation and Fishing)
-- (Scotland) Act 2003, bill 124, was reintroduced in Session 2 and never had a
-- Preliminary or Consideration Stage of its own. Its note names both and dated
-- only the Session 1 bill's Preliminary Stage, 9 January 2003. Raised when
-- Phase 2's plan was checked, 16 September.
--
-- THE DATE: 11 March 2003, already held twice. On the Session 1 bill's
-- Consideration Stage record (bill 71, from the owner's dataset), and in the
-- detail note on this Act's own Consideration Stage record, which cites the
-- same archived bill page as this note. Nothing new is read, and the source the
-- note cites is unchanged.
--
-- WHAT THIS CHANGES: line 124, Session 2 only: its note, a review note saying
-- why, and its review time. The clean sheet changes when Session 2 is taken off
-- and put back, which follows this migration.
--
-- ALSO SETTLED, AND NOT BUILT BECAUSE NOTHING CHANGES: Session 5's four bills
-- that ran out of time are left as they are. Each carries the same short note on
-- the stage it stopped at as every such bill; Session 6's three carry a longer
-- one quoting the bill page, and Sessions 1 to 5 do not.

\set ON_ERROR_STOP on
BEGIN;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM bill_candidate
   WHERE candidate_id = 124 AND session_number = 2
     AND md5(bill_note) = 'af063d2326d012f440a50035ddd5963d' AND review_note IS NULL;
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: line 124 is not as it was.'; END IF;

  SELECT count(*) INTO n FROM stage_event
   WHERE (bill_id = 71 AND stage = 'consideration' AND date_completed = DATE '2003-03-11')
      OR (bill_id = 124 AND stage = 'consideration' AND did_not_happen
          AND detail_note LIKE '%Consideration Stage was on 11 March 2003.');
  IF n <> 2 THEN RAISE EXCEPTION 'Refusing: 11 March 2003 is not held where this relies on it.'; END IF;

  SELECT count(*) INTO n FROM bill; IF n <> 470 THEN RAISE EXCEPTION 'Refusing: % bills', n; END IF;
  SELECT count(*) INTO n FROM field_source; IF n <> 192 THEN RAISE EXCEPTION 'Refusing: % provenance notes', n; END IF;
END $$;

UPDATE bill_candidate
   SET bill_note = replace(bill_note,
         'The Session 1 bill’s Preliminary Stage was on 9 January 2003.',
         'The Session 1 bill’s Preliminary Stage was on 9 January 2003 and its Consideration Stage on 11 March 2003.'),
       review_note = 'The note named both stages this bill never had and dated only the Preliminary Stage. It now gives the Consideration Stage date too, 11 March 2003, already held on the Session 1 bill''s Consideration Stage record and in this bill''s own. Settled by the owner on 2026-09-17; see db/112.',
       reviewed_at = now()
 WHERE candidate_id = 124;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM bill_candidate
   WHERE candidate_id = 124
     AND bill_note = 'Reintroduced in Session 2 after falling at dissolution. A reintroduced Private Bill does not repeat its earlier scrutiny, so this bill went straight to the Final Stage vote and has no Preliminary or Consideration Stage of its own. The Session 1 bill’s Preliminary Stage was on 9 January 2003 and its Consideration Stage on 11 March 2003. Source: https://webarchive.nrscotland.gov.uk/public/+/http://archive2021.parliament.scot/parliamentarybusiness/Bills/24953.aspx';
  IF n <> 1 THEN RAISE EXCEPTION 'Line 124''s note does not read as approved.'; END IF;

  SELECT count(*) INTO n FROM v_candidate_problems; IF n <> 0 THEN RAISE EXCEPTION 'checker %', n; END IF;
  SELECT count(*) INTO n FROM bill; IF n <> 470 THEN RAISE EXCEPTION '% bills', n; END IF;
  SELECT count(*) INTO n FROM field_source; IF n <> 192 THEN RAISE EXCEPTION '% provenance notes', n; END IF;

  RAISE NOTICE 'Line 124''s note dates both stages. The clean sheet is unchanged until Session 2 is put back.';
END $$;

COMMIT;
