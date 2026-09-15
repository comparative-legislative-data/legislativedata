-- db/096_neither_bill_reached_a_stage_2_meeting.sql
--
-- A correction to two notes, and the owner's ruling that settles the question
-- db/095 left open. No column, no value, no rule, and no date changes.
--
-- WHAT db/095 GOT WRONG. Ecocide and Freedom of Information Reform both
-- completed Stage 1 and then fell at Stage 2. db/095 read Ecocide's page as
-- listing two Stage 2 committee meetings, 17 February and 10 March 2026, and
-- Freedom of Information Reform's as listing none, and wrote that difference
-- into the notes on the two Stage 2 rows. There is no such difference. The
-- meetings under that heading are the lead committee's meetings, not Stage 2
-- proceedings on the bill, and further down the same page the Parliament says
-- so in terms:
--
--   "A date for Stage 2 consideration of the Bill was not set prior to the
--    dissolution of Parliament. Marshalled List and Groupings documents were
--    therefore not produced. The daily lists of amendments below reflect
--    amendments that MSPs had lodged for consideration at Stage 2."
--
-- Amendments to the Ecocide Bill were lodged on 6, 10 and 24 February 2026 and
-- never considered. Freedom of Information Reform's page carries no such section
-- and lists no amendments at all. So neither bill had any Stage 2 proceedings:
-- one got as far as amendments being lodged and the other did not, and neither
-- got as far as a meeting to decide on them.
--
-- THE OWNER'S RULING, 2026-09-15. Both bills completed Stage 1 and no more, and
-- the Stage 1 date is the one the data is interested in. They are recorded the
-- same way, which is what db/095 already did with the dates and is now what the
-- notes say too.
--
-- WHAT THIS SETTLES. db/095 left a question for the owner: whether a committee
-- meeting date should be read as the day a bill reached Stage 2, which would
-- have been the first use of date_reached outside a Reconsideration Stage. The
-- answer is no, and the question turns out not to arise -- the meetings were
-- not Stage 2 proceedings. M11 stands unchanged: the day a bill reached a stage
-- is recorded only where a source states it, and is never worked out. Both rows
-- keep an empty date_reached.
--
-- This only changes the staging sheet. Session 6 is not on the clean sheet, and
-- both rows are still waiting for review.

\set ON_ERROR_STOP on
BEGIN;

CREATE TEMP TABLE correction (
  candidate_id integer, title_fragment text, detail_note text
) ON COMMIT DROP;

INSERT INTO correction VALUES
 (401, 'Ecocide',
  'The bill stopped here, undecided, when the session ended. The page reads: '
  || '"Ecocide (Scotland) Bill fell on 08 April 2026" under Stage 2, and "This Bill fell at '
  || 'Stage 2 of the process to decide if it should become an Act." No Stage 2 proceedings '
  || 'took place: the page reads "A date for Stage 2 consideration of the Bill was not set '
  || 'prior to the dissolution of Parliament. Marshalled List and Groupings documents were '
  || 'therefore not produced." Amendments were lodged on 6, 10 and 24 February 2026 and were '
  || 'never considered.'),
 (402, 'Freedom of Information Reform',
  'The bill stopped here, undecided, when the session ended. The page reads: '
  || '"Freedom of Information Reform (Scotland) Bill fell on 08 April 2026" under Stage 2, and '
  || '"This Bill fell at Stage 2 of the process to decide if it should become an Act." No '
  || 'Stage 2 proceedings took place and no amendments were lodged. The bill''s financial '
  || 'resolution, without which Stage 2 cannot get under way, was agreed on 5 March 2026.');

DO $$
DECLARE n integer;
BEGIN
  -- A mistyped line number must fail here, not rewrite the wrong bill's note.
  SELECT count(*) INTO n FROM correction a JOIN bill_candidate c USING (candidate_id)
   WHERE c.short_title NOT ILIKE '%' || a.title_fragment || '%';
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % row(s) name a line whose title does not match.', n;
  END IF;

  -- Each must have exactly the Stage 2 row db/095 wrote, still unreviewed.
  SELECT count(*) INTO n FROM correction a
   WHERE NOT EXISTS (SELECT 1 FROM stage_candidate s
                      WHERE s.candidate_id = a.candidate_id AND s.stage_order = 2
                        AND s.fell_here AND NOT s.completed
                        AND s.date_completed IS NULL AND s.date_reached IS NULL
                        AND s.source = 'bill_page' AND s.review_status = 'new');
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % line(s) do not hold the unreviewed Stage 2 row this corrects.', n;
  END IF;

  -- The claim being removed must actually be there, or this is correcting
  -- something that has already changed underneath it.
  SELECT count(*) INTO n FROM correction a JOIN stage_candidate s
      ON s.candidate_id = a.candidate_id AND s.stage_order = 2
   WHERE s.detail_note NOT LIKE '%Stage 2 committee%';
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % note(s) do not say what db/095 wrote.', n;
  END IF;
END $$;

UPDATE stage_candidate s
   SET detail_note = a.detail_note
  FROM correction a
 WHERE s.candidate_id = a.candidate_id AND s.stage_order = 2;

DO $$
DECLARE n integer;
BEGIN
  -- Two notes changed and nothing else.
  SELECT count(*) INTO n FROM stage_candidate s JOIN correction a
      ON a.candidate_id = s.candidate_id AND s.stage_order = 2
   WHERE s.detail_note IS DISTINCT FROM a.detail_note;
  IF n > 0 THEN RAISE EXCEPTION '% note(s) did not take.', n; END IF;

  -- No date moved anywhere, and Stage 1 still reads as the only completed stage.
  SELECT count(*) INTO n FROM stage_candidate s JOIN correction a USING (candidate_id)
   WHERE s.completed <> (s.stage_order = 1) OR s.fell_here <> (s.stage_order = 2)
      OR s.date_reached IS NOT NULL;
  IF n > 0 THEN RAISE EXCEPTION '% row(s) no longer read as completed at Stage 1 only.', n; END IF;

  SELECT count(*) INTO n FROM stage_candidate s JOIN correction a USING (candidate_id)
   WHERE s.stage_order = 1 AND s.date_completed IS NULL;
  IF n > 0 THEN RAISE EXCEPTION '% Stage 1 date(s) went missing.', n; END IF;

  -- Neither bill may be left saying anything the other does not, bar the
  -- amendments and the dates: the whole point of the ruling.
  SELECT count(*) INTO n FROM stage_candidate s JOIN correction a USING (candidate_id)
   WHERE s.stage_order = 2 AND s.detail_note NOT LIKE '%No Stage 2 proceedings took place%';
  IF n <> 0 THEN RAISE EXCEPTION '% Stage 2 note(s) do not say no proceedings took place.', n; END IF;

  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n <> 1 THEN RAISE EXCEPTION 'The error checker finds % problem(s), expected 1.', n; END IF;

  SELECT count(*) INTO n FROM v_stage_date_gaps;
  IF n <> 2 THEN RAISE EXCEPTION 'The gaps list holds % row(s), expected 2.', n; END IF;

  SELECT count(*) INTO n FROM bill;
  IF n <> 389 THEN RAISE EXCEPTION '% bills on the clean sheet, expected 389.', n; END IF;

  SELECT count(*) INTO n FROM stage_event;
  IF n <> 1071 THEN RAISE EXCEPTION '% stage records, expected 1071.', n; END IF;

  RAISE NOTICE 'Two notes corrected. Both bills read the same: Stage 1 completed, Stage 2 never in proceedings.';
END $$;

COMMIT;
