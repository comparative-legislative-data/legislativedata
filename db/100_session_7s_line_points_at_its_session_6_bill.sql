-- db/100_session_7s_line_points_at_its_session_6_bill.sql
--
-- The Gender Recognition Reform Bill is listed in the Session 6 and the
-- Session 7 fact sheets. It is one bill, introduced on 2 March 2022, and by
-- methodology note M6 it belongs to Session 6, the session it was introduced
-- in. Session 7's line is a further appearance of it and must say so.
--
-- It could not say so until now. The error checker has been refusing the line
-- since it was loaded -- "introduced before the session began; if this line is
-- a bill already on the clean sheet, continues_bill_id must say which" -- and
-- the answer was unavailable, because bill 393 reached the clean sheet only
-- when Session 6 was promoted on 2026-09-15, minutes before this. That one
-- problem is the whole of what the error checker has been holding.
--
-- WHY 393 AND NOT SOMETHING ELSE. A matching title alone does not make it the
-- same bill; a bill of the same name reintroduced after an earlier one ended is
-- two bills (DECISIONS.md, 2026-09-10). The test is the same title AND the same
-- introduction date, and both hold: line 474 and bill 393 agree on the title
-- exactly, on 2 March 2022, and on the note word for word. The one stage row on
-- line 474, Stage 3 completed on 22 December 2022, is already on the bill from
-- the Session 6 sheet, so nothing about the bill changes.
--
-- WHAT THIS DOES NOT DO. It does not admit or promote Session 7. The line stays
-- 'new' and waits for the owner's review with the session's other line.
--
-- Whether this migration is right is for a session that did not write it.

\set ON_ERROR_STOP on
BEGIN;

DO $$
DECLARE n integer;
BEGIN
  -- The bill it will point at is on the clean sheet, belongs to an earlier
  -- session, and agrees on the two things that identify a bill.
  SELECT count(*) INTO n FROM bill_candidate c, bill b
   WHERE c.candidate_id = 474 AND b.bill_id = 393
     AND c.session_number = 7 AND b.session_number = 6
     AND c.short_title = b.short_title
     AND c.date_introduced = b.date_introduced
     AND c.date_introduced = DATE '2022-03-02'
     AND c.continues_bill_id IS NULL
     AND c.review_status = 'new'
     AND c.promoted_bill_id IS NULL;
  IF n <> 1 THEN
    RAISE EXCEPTION 'Refusing: line 474 and bill 393 are not where this migration expects them.';
  END IF;

  -- No other line already claims this bill.
  SELECT count(*) INTO n FROM bill_candidate WHERE continues_bill_id = 393;
  IF n <> 0 THEN
    RAISE EXCEPTION 'Refusing: % line(s) already continue bill 393.', n;
  END IF;

  -- The error checker is holding exactly this, and nothing else.
  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n <> 1 THEN
    RAISE EXCEPTION 'Refusing: the error checker finds % problem(s), expected 1.', n;
  END IF;
  SELECT count(*) INTO n FROM v_candidate_problems WHERE candidate_id = 474;
  IF n <> 1 THEN
    RAISE EXCEPTION 'Refusing: the one problem is not line 474''s.';
  END IF;
END $$;

UPDATE bill_candidate
   SET continues_bill_id = 393,
       review_note = btrim(coalesce(review_note || E'\n', '')
         || 'A further appearance of bill 393, the Session 6 bill of the same name, '
         || 'introduced on 2 March 2022. The Session 7 fact sheet lists it again because '
         || 'it was still a live bill, stopped before Royal Assent by a section 35 order '
         || 'and neither reconsidered nor withdrawn, when Session 6 ended. By methodology '
         || 'note M6 the bill belongs to Session 6. Pointed at it on 2026-09-15, once '
         || 'Session 6 reached the clean sheet; until then the answer did not exist and '
         || 'the error checker refused the line.'),
       updated_at = now()
 WHERE candidate_id = 474;

DO $$
DECLARE n integer;
BEGIN
  -- The error checker is empty, for the first time since Session 6 was loaded.
  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n <> 0 THEN RAISE EXCEPTION 'The error checker still finds % problem(s).', n; END IF;

  -- And so is the gaps list. The two Stage 1 and Stage 2 gaps it held against
  -- line 474 were never missing dates: they are on bill 393, put there by the
  -- owner's dataset, and db/086 stops a further appearance being asked for
  -- stages the bill it continues already has.
  SELECT count(*) INTO n FROM v_stage_date_gaps;
  IF n <> 0 THEN RAISE EXCEPTION 'The gaps list still holds % row(s).', n; END IF;

  -- Session 7 is still waiting for the owner.
  SELECT count(*) INTO n FROM bill_candidate
   WHERE session_number = 7 AND review_status <> 'new';
  IF n <> 0 THEN RAISE EXCEPTION '% Session 7 line(s) are no longer waiting for review.', n; END IF;

  -- The clean sheet did not move.
  SELECT count(*) INTO n FROM bill;
  IF n <> 469 THEN RAISE EXCEPTION '% bills on the clean sheet, expected 469.', n; END IF;
  SELECT count(*) INTO n FROM stage_event;
  IF n <> 1291 THEN RAISE EXCEPTION '% stage records, expected 1291.', n; END IF;
  SELECT count(*) INTO n FROM field_source;
  IF n <> 186 THEN RAISE EXCEPTION '% provenance notes, expected 186.', n; END IF;
END $$;

COMMIT;
