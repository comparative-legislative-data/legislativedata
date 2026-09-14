-- db/084_the_values_for_three_blocked_bills_and_one_carried_scrutiny.sql
--
-- The values themselves, put on the staging sheets so that they reach the
-- clean sheet by the ordinary route. Nothing here writes to the clean sheet.
-- Sessions 5 and 2 are taken off and put back afterwards, which is db/063's
-- and db/078's shape and the reason this migration files no provenance note of
-- its own.
--
-- Agreed with the owner on 2026-09-14.
--
-- -------------------------------------------------------------------------
-- 1. Session 5's three bills stopped before Royal Assent.
--
-- Each already carries outcome = passed, enactment_status = blocked and the
-- fact sheet's own footnote word for word in raw_footnote. The footnote is
-- where the route is read from, so nothing is looked up. All three read, in
-- the Session 5 fact sheet's own words:
--
--   "Following a reference under section 33 of the Scotland Act 1998 by the
--    Attorney General and the Advocate General for Scotland, the Supreme Court
--    has ruled ... that some provisions of the ... Bill are outwith the
--    legislative competence of the Scottish Parliament. The Bill cannot be
--    submitted for Royal Assent in its unamended form."
--
-- So the route is a section 33 reference for all three.
--
-- What followed is 'still_blocked' for all three, and that is the right value
-- AS SESSION 5 KNOWS THEM. Two of the three were reconsidered and enacted in
-- Session 6 and the third was withdrawn in Session 6, and all three of those
-- facts arrive when Session 6 is loaded, on that session's own lines, by the
-- route db/081 built. Writing them now would be recording a fact from a source
-- this session has not read.
--
-- -------------------------------------------------------------------------
-- 2. The Robin Rigg Act, and one note that names the wrong stage.
--
-- The Session 2 Act carried the Session 1 bill's scrutiny, so it says so.
--
-- While setting that, a fault in text a reader sees. Both of its empty stage
-- rows carry the same sentence, and it ends "The Session 1 bill's Preliminary
-- Stage was on 9 January 2003." On the Preliminary row that is the fact the
-- reader wants. On the Consideration row it is not: the fact wanted there is
-- that the Session 1 bill's Consideration Stage was on 11 March 2003. The
-- sentence is true on both rows and right on only one. That date is already on
-- the clean sheet as the Session 1 bill's Consideration Stage, cited to the
-- PhD dataset, so nothing is looked up here either.
--
-- The bill's own note has the same shape of gap -- it names both stages and
-- gives one date -- and is left alone, because it is incomplete rather than
-- wrong and because mending it was not agreed. It is raised with the owner.

\set ON_ERROR_STOP on
BEGIN;

-- ---------------------------------------------------------------------------
-- Session 5's three bills
-- ---------------------------------------------------------------------------

UPDATE bill_candidate
   SET assent_block_route   = 's33_reference',
       assent_block_outcome = 'still_blocked'
 WHERE session_number = 5
   AND enactment_status = 'blocked'
   AND raw_footnote LIKE 'Following a reference under section 33 of the Scotland Act 1998%';

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM bill_candidate
   WHERE assent_block_route IS NOT NULL OR assent_block_outcome IS NOT NULL;
  IF n <> 3 THEN RAISE EXCEPTION 'Expected 3 lines with the block cells filled, found %.', n; END IF;

  SELECT count(*) INTO n FROM bill_candidate
   WHERE enactment_status = 'blocked' AND assent_block_outcome IS NULL;
  IF n > 0 THEN RAISE EXCEPTION '% line(s) are blocked and say nothing about it.', n; END IF;

  SELECT count(*) INTO n FROM bill_candidate
   WHERE assent_block_outcome IS NOT NULL AND outcome <> 'passed';
  IF n > 0 THEN RAISE EXCEPTION '% line(s) say they were stopped before assent but did not pass.', n; END IF;
END $$;

-- ---------------------------------------------------------------------------
-- The Robin Rigg Act
-- ---------------------------------------------------------------------------

-- Named by what it is, not by its number, so that a wrong number cannot pass
-- unnoticed: the line is the Session 2 Act and the bill it points at is the
-- Session 1 bill of the same name.
UPDATE bill_candidate c
   SET reintroduced_from_bill_id = b.bill_id
  FROM bill b
 WHERE c.session_number = 2
   AND c.short_title LIKE 'Robin Rigg Offshore Wind Farm%'
   AND b.session_number = 1
   AND b.short_title LIKE 'Robin Rigg Offshore Wind Farm%';

UPDATE stage_candidate t
   SET detail_note = replace(t.detail_note,
         'The Session 1 bill''s Preliminary Stage was on 9 January 2003.',
         'The Session 1 bill''s Consideration Stage was on 11 March 2003.')
  FROM bill_candidate c
 WHERE c.candidate_id = t.candidate_id
   AND c.session_number = 2
   AND c.short_title LIKE 'Robin Rigg Offshore Wind Farm%'
   AND t.stage = 'consideration'
   AND t.did_not_happen;

DO $$
DECLARE n integer; v text;
BEGIN
  SELECT count(*) INTO n FROM bill_candidate WHERE reintroduced_from_bill_id IS NOT NULL;
  IF n <> 1 THEN RAISE EXCEPTION 'Expected 1 line carrying a reintroduction, found %.', n; END IF;

  -- The bill it points at is the one that did the scrutiny, and it is earlier.
  SELECT count(*) INTO n
    FROM bill_candidate c JOIN bill b ON b.bill_id = c.reintroduced_from_bill_id
   WHERE b.date_introduced < c.date_introduced
     AND EXISTS (SELECT 1 FROM stage_event e
                  WHERE e.bill_id = b.bill_id AND e.stage = 'consideration'
                    AND e.date_completed = DATE '2003-03-11');
  IF n <> 1 THEN RAISE EXCEPTION 'The line does not point at the Session 1 bill that did the scrutiny.'; END IF;

  -- The two notes now name their own stage, and no note names the other's.
  SELECT t.detail_note INTO v FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number = 2 AND c.short_title LIKE 'Robin Rigg%' AND t.stage = 'consideration';
  IF v NOT LIKE '%Consideration Stage was on 11 March 2003.' THEN
    RAISE EXCEPTION 'The Consideration row still does not give its own date: %', v;
  END IF;
  SELECT t.detail_note INTO v FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number = 2 AND c.short_title LIKE 'Robin Rigg%' AND t.stage = 'preliminary';
  IF v NOT LIKE '%Preliminary Stage was on 9 January 2003.' THEN
    RAISE EXCEPTION 'The Preliminary row no longer gives its own date: %', v;
  END IF;

  -- Every stage recorded as never having happened now says whose scrutiny it
  -- was, which is the rule db/082 added.
  SELECT count(*) INTO n FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
   WHERE t.did_not_happen AND t.review_status <> 'rejected'
     AND c.reintroduced_from_bill_id IS NULL;
  IF n > 0 THEN RAISE EXCEPTION '% stage(s) never happened and nothing says where they did.', n; END IF;
END $$;

-- ---------------------------------------------------------------------------
-- Nothing reached the clean sheet, and the checker is clear
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM bill;
  IF n <> 389 THEN RAISE EXCEPTION 'The clean sheet moved: % bills, expected 389.', n; END IF;
  SELECT count(*) INTO n FROM stage_event;
  IF n <> 1071 THEN RAISE EXCEPTION 'The clean sheet moved: % stage records, expected 1071.', n; END IF;
  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n > 0 THEN RAISE EXCEPTION 'The error checker finds % problem(s).', n; END IF;
  SELECT count(*) INTO n FROM v_stage_date_gaps;
  IF n > 0 THEN RAISE EXCEPTION 'The gaps list holds % row(s).', n; END IF;
END $$;

COMMIT;
