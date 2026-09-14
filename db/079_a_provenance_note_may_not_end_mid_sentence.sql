-- db/079_a_provenance_note_may_not_end_mid_sentence.sql
--
-- Eight provenance notes ended with the words "Read at" and then stopped. The
-- copying step that produced them is mended, the eight are rewritten by the
-- ordinary route, and the database is taught to refuse a ninth.
--
-- Settled with the owner on 2026-09-14, while they were signing Session 5 off
-- and reading the three Official Report notes as a reader would see them. It
-- changes no bill, no date and no coding: only the words a reader is shown.
--
-- -------------------------------------------------------------------------
-- 1. What was wrong, and where.
--
-- A bill whose outcome was read in the Official Report carries a note giving
-- the outcome in words. The staging line holds that note in full, ending
-- "... Read at https://www.parliament.scot/...", and it was right: nothing had
-- been typed wrongly anywhere.
--
-- tools/promote_session.sql cuts the note at the first address before filing
-- it, on purpose, so that our own commentary can never be recorded as though
-- the source had said it. But "Read at" exists only to introduce the address,
-- so cutting the address and keeping the phrase left the note hanging:
--
--   ... Result as recorded: "For 26, Against 89, Abstentions 0. Motion
--   disagreed to." Read at
--
-- The address itself was never lost -- it is on the same note, as the note's
-- reference, with the day it was read beside it. Only the sentence was broken.
--
-- Eight notes, all of them outcomes cited to the Official Report: five in
-- Session 4 and three in Session 5. Sessions 1 to 3 worded their review notes
-- differently and never had an address to cut, so their sixteen are unharmed.
-- The check that was run before anything moved: of the twenty-four lines whose
-- outcome came from the Official Report, exactly eight change under the mend,
-- each by the eight characters of " Read at", and all twenty-four still yield
-- an address for the note's reference.
--
-- -------------------------------------------------------------------------
-- 2. How the eight were mended: by the ordinary route, not by hand.
--
-- tools/promote_session.sql now cuts "Read at" together with the address it
-- introduces. Sessions 5 and 4 were then taken off the clean sheet and put
-- straight back, so the notes were written afresh from staging lines that had
-- never been wrong. Nothing was typed into a provenance note by hand, which is
-- what field_source's own description requires.
--
-- Rehearsed first, against a copy taken before anything moved:
--
--   Session 5 rehearsed:  3 cells differed, the three notes, nothing else.
--   Session 4 rehearsed:  5 cells differed, the five notes, nothing else.
--   Run for real, both:   8 cells differed, the eight notes, nothing else.
--
-- Everything else that moves when a session is taken off and put back -- the
-- numbers given to stage records and notes, and the times things were written
-- -- moved as it always does and is counted as expected. Bills stayed at 389,
-- stage records at 1071 and provenance notes at 106 throughout.
--
-- Session 4 is closed, and the owner agreed on 2026-09-14 to reopening it for
-- this. Its closure test lists these notes but checks how many there are and
-- what each is cited to, not their wording, so no answer of its test moves.
-- The listing is marked there so the next reader is not puzzled.
--
-- -------------------------------------------------------------------------
-- 3. The rule that would have caught it.
--
-- This is the part of the fault that matters, because the copying step is
-- mended for this one phrase and the next connective phrase would slip through
-- the same way. The database now refuses to hold a note whose words end in
-- "Read at".
--
-- It sits on the note itself rather than in v_candidate_problems, and the
-- reason is worth saying plainly: v_candidate_problems reads the staging
-- sheets, and the staging sheets were never wrong. There was nothing there to
-- refuse. A rule about what a note may say has to live where the note lives,
-- and it then binds every writer -- promotion, a migration, or a hand at the
-- keyboard -- rather than only the one route that happened to produce this.
--
-- The rule is narrow on purpose. A vaguer one about notes ending mid-sentence
-- would have to guess at what a sentence is, and a source's own words are
-- quoted verbatim here: they end in dates, numbers, titles and closing quotes,
-- and a rule that expected a full stop would refuse most of the 106.
--
-- It is proved to bite below. That proof is this migration's account of
-- itself and is not a check on it: item 32 of Session 5's closure test asks
-- the same question from outside, and is written by this session and
-- deliberately not run by it.

\set ON_ERROR_STOP on

BEGIN;

-- Nothing may be holding a dangling note when the rule arrives.
DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM field_source WHERE value_seen ~* 'Read at\s*$';
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing to add the rule: % note(s) still end in "Read at".', n;
  END IF;
END $$;

ALTER TABLE field_source
  ADD CONSTRAINT field_source_value_seen_not_left_hanging
  CHECK (value_seen !~* 'Read at\s*$');

COMMENT ON CONSTRAINT field_source_value_seen_not_left_hanging ON field_source IS
 'A note''s words may not end with "Read at". That phrase only ever introduces the address, which is kept in source_ref, so a note ending in it is one whose sentence was cut in half. Eight notes did, in Sessions 4 and 5, until db/079.';

-- Proof that it bites: put the phrase back on one note and watch it refused.
DO $$
DECLARE refused boolean := false; victim integer;
BEGIN
  SELECT field_source_id INTO victim
    FROM field_source
   WHERE entity = 'bill' AND field_name = 'outcome' AND source = 'official_report'
   ORDER BY field_source_id LIMIT 1;
  IF victim IS NULL THEN
    RAISE EXCEPTION 'No Official Report outcome note to test the rule against.';
  END IF;

  BEGIN
    UPDATE field_source
       SET value_seen = value_seen || ' Read at'
     WHERE field_source_id = victim;
  EXCEPTION WHEN check_violation THEN
    refused := true;
  END;

  IF NOT refused THEN
    RAISE EXCEPTION 'The rule did not bite: note % was allowed to end in "Read at".', victim;
  END IF;
  RAISE NOTICE 'The rule bites: note % was refused.', victim;
END $$;

-- And the sheets are as they were.
DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM bill;
  IF n <> 389 THEN RAISE EXCEPTION 'bills is %, expected 389.', n; END IF;
  SELECT count(*) INTO n FROM stage_event;
  IF n <> 1071 THEN RAISE EXCEPTION 'stage records is %, expected 1071.', n; END IF;
  SELECT count(*) INTO n FROM field_source;
  IF n <> 106 THEN RAISE EXCEPTION 'provenance notes is %, expected 106.', n; END IF;
  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n <> 0 THEN RAISE EXCEPTION 'The error checker is no longer empty: % item(s).', n; END IF;
  SELECT count(*) INTO n FROM v_stage_date_gaps;
  IF n <> 0 THEN RAISE EXCEPTION 'The gaps list is no longer empty: % item(s).', n; END IF;

  RAISE NOTICE 'Eight notes mended by the ordinary route. A note may no longer end in "Read at".';
END $$;

COMMIT;
