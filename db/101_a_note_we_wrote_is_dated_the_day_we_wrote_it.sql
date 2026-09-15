-- db/101_a_note_we_wrote_is_dated_the_day_we_wrote_it.sql
--
-- WHAT WENT WRONG. db/098 made a bill's note the eighth cell a further
-- appearance carries, and said in terms why the note is different from the
-- other seven: the other seven are read off a fact sheet, and the note is
-- written by us at review. So promotion was changed to record the note's
-- source as 'manual' rather than as the fact sheet.
--
-- Only half of that landed. The row's source says 'manual', and beside it
-- source_ref still says 'session 6, retrieved 2026-09-10' and observed_at
-- still says 2026-09-10 -- the reference and the date belong to the fact
-- sheet the rest of the line was read off. The three notes were written on
-- 2026-09-15, by us, at review. A reader asking where the note came from is
-- told it was seen in a document on a day when it did not exist.
--
-- Nothing on the clean sheet is wrong. The three notes say what the owner
-- agreed word for word, and the facts they state carry their own provenance
-- rows, correctly dated. What is wrong is the account of where the note
-- itself came from.
--
-- Found by Session 6's closure test, item 14, run on 2026-09-15 by a session
-- that wrote none of db/098 to db/100. That is the item working as intended:
-- it asked for 2026-09-15 and got 2026-09-10.
--
-- THE RULE, settled with the owner on 2026-09-15.
--   - A note written by us at review is dated the day it was written and
--     cites us, not a fact sheet. source stays 'manual'; observed_at becomes
--     the day the line was reviewed; source_ref becomes 'written at review of
--     session N'.
--   - The day the line was reviewed is taken from the line's own reviewed_at
--     rather than written in, so this holds for every session after this one
--     without anybody remembering to. Promotion already refuses a line that is
--     not accepted, and no accepted line has ever lacked a reviewed_at.
--   - It applies only to the note. The other seven cells are read off a fact
--     sheet and go on citing it, on the day it was retrieved.
--   - An empty note still means the earlier note stands, and still writes no
--     provenance row. Nothing about M6 changes: its closing paragraph says
--     what the note covers and that the earlier wording is kept, and says
--     nothing about dates.
--   - The error checker is unchanged. This is provenance, not a staging cell,
--     and there is nothing for a reviewer to answer.
--
-- EVERY ROW ALREADY WRITTEN THE OLD WAY is rewritten here. There are exactly
-- three, on bills 303, 304 and 305, all written by the Session 6 promotion
-- twenty-six seconds after the three lines were reviewed. What each row said
-- before is kept in the row's own words, which is the same thing db/098 did
-- for the notes themselves.
--
-- tools/promote_session.sql is changed in the same commit, so the next session
-- writes these rows right in the first place.
--
-- Whether this migration is right is for a session that did not write it.
-- Its test is docs/CLOSURE-TESTS.md, "A note we wrote is dated the day we
-- wrote it", written by this session and deliberately not run by it.

\set ON_ERROR_STOP on
BEGIN;

DO $$
DECLARE n integer;
BEGIN
  -- Exactly three note rows exist, and all three are as db/098 left them.
  SELECT count(*) INTO n FROM field_source
   WHERE entity = 'bill' AND field_name = 'note';
  IF n <> 3 THEN
    RAISE EXCEPTION 'Refusing: % note provenance row(s), expected 3.', n;
  END IF;

  SELECT count(*) INTO n FROM field_source
   WHERE entity = 'bill' AND field_name = 'note'
     AND entity_id IN (303, 304, 305)
     AND source = 'manual'
     AND source_ref = 'session 6, retrieved 2026-09-10'
     AND observed_at = DATE '2026-09-10'
     AND note LIKE 'Rewritten when Session 6 was reviewed,%';
  IF n <> 3 THEN
    RAISE EXCEPTION 'Refusing: the three note rows are not where this migration expects them.';
  END IF;

  -- The three lines that wrote them were reviewed on the day the notes were
  -- written. If that is not so, the date this migration is about to write is
  -- not the date the note was written and the whole change is wrong.
  SELECT count(*) INTO n FROM bill_candidate
   WHERE candidate_id IN (412, 440, 468)
     AND continues_bill_id IN (303, 304, 305)
     AND review_status = 'accepted'
     AND reviewed_at::date = DATE '2026-09-15';
  IF n <> 3 THEN
    RAISE EXCEPTION 'Refusing: the three Session 6 lines were not reviewed on 2026-09-15.';
  END IF;

  -- Nothing is being fixed under cover of something else being broken.
  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n <> 0 THEN
    RAISE EXCEPTION 'Refusing: the error checker finds % problem(s).', n;
  END IF;
END $$;

-- A photograph of every provenance row as it stands, so that what this
-- migration moved can be shown rather than asserted. Nothing else may differ
-- by so much as a character afterwards. (The other cells are NOT all cited to
-- the Session 6 fact sheet -- assent_block_route still cites the Session 5
-- footnote it was read off -- so a check that named an expected citation would
-- be checking the wrong thing. This compares each row against itself.)
CREATE TEMP TABLE db101_before ON COMMIT DROP AS
SELECT field_source_id, field_name,
       md5(ROW(entity, entity_id, field_name, source, source_ref,
               value_seen, observed_at, note)::text) AS fingerprint
  FROM field_source;

-- The date and the citation follow the line that wrote the note, not the fact
-- sheet that line was read off.
UPDATE field_source f
   SET observed_at = c.reviewed_at::date,
       source_ref  = 'written at review of session ' || c.session_number,
       note        = f.note
         || ' Corrected by db/101: this row first said the note was seen on '
         || to_char(f.observed_at, 'FMDD Month YYYY')
         || ' in ' || quote_literal(f.source_ref)
         || ', which is the fact sheet the rest of the line was read off. The '
         || 'note is ours and was written at review.'
  FROM bill_candidate c
 WHERE f.entity = 'bill'
   AND f.field_name = 'note'
   AND c.continues_bill_id = f.entity_id
   AND c.promoted_bill_id  = f.entity_id;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM field_source
   WHERE entity = 'bill' AND field_name = 'note'
     AND source = 'manual'
     AND source_ref = 'written at review of session 6'
     AND observed_at = DATE '2026-09-15'
     AND note LIKE '%Corrected by db/101: this row first said the note was seen on 10 September 2026%';
  IF n <> 3 THEN
    RAISE EXCEPTION 'Expected 3 corrected note rows, found %.', n;
  END IF;

  -- No note row anywhere still cites a fact sheet.
  SELECT count(*) INTO n FROM field_source
   WHERE entity = 'bill' AND field_name = 'note' AND source_ref !~ '^written at review of session ';
  IF n <> 0 THEN
    RAISE EXCEPTION '% note row(s) still cite something other than our own review.', n;
  END IF;

  -- Exactly three rows moved, and they are the three note rows. Every other
  -- provenance row in the database is character-for-character what it was.
  SELECT count(*) INTO n
    FROM field_source f JOIN db101_before b USING (field_source_id)
   WHERE md5(ROW(f.entity, f.entity_id, f.field_name, f.source, f.source_ref,
                 f.value_seen, f.observed_at, f.note)::text) <> b.fingerprint;
  IF n <> 3 THEN
    RAISE EXCEPTION '% provenance row(s) moved, expected exactly 3.', n;
  END IF;

  SELECT count(*) INTO n
    FROM field_source f JOIN db101_before b USING (field_source_id)
   WHERE f.field_name <> 'note'
     AND md5(ROW(f.entity, f.entity_id, f.field_name, f.source, f.source_ref,
                 f.value_seen, f.observed_at, f.note)::text) <> b.fingerprint;
  IF n <> 0 THEN
    RAISE EXCEPTION '% row(s) other than the three notes moved.', n;
  END IF;

  -- None appeared and none vanished.
  SELECT count(*) INTO n FROM field_source f
   WHERE NOT EXISTS (SELECT 1 FROM db101_before b WHERE b.field_source_id = f.field_source_id);
  IF n <> 0 THEN RAISE EXCEPTION '% provenance row(s) appeared.', n; END IF;
  SELECT count(*) INTO n FROM db101_before b
   WHERE NOT EXISTS (SELECT 1 FROM field_source f WHERE f.field_source_id = b.field_source_id);
  IF n <> 0 THEN RAISE EXCEPTION '% provenance row(s) vanished.', n; END IF;

  -- Nothing else in the database moved.
  SELECT count(*) INTO n FROM bill;
  IF n <> 469 THEN RAISE EXCEPTION '% bills on the clean sheet, expected 469.', n; END IF;
  SELECT count(*) INTO n FROM stage_event;
  IF n <> 1291 THEN RAISE EXCEPTION '% stage records, expected 1291.', n; END IF;
  SELECT count(*) INTO n FROM field_source;
  IF n <> 186 THEN RAISE EXCEPTION '% provenance notes, expected 186.', n; END IF;
  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n <> 0 THEN RAISE EXCEPTION 'The error checker now finds % problem(s).', n; END IF;
  SELECT count(*) INTO n FROM v_stage_date_gaps;
  IF n <> 0 THEN RAISE EXCEPTION 'The gaps list now holds % row(s).', n; END IF;

  -- The notes themselves are untouched. What a reader sees on the clean sheet
  -- is exactly what the owner agreed word for word.
  SELECT count(*) INTO n FROM bill
   WHERE bill_id IN (303, 304, 305)
     AND note LIKE 'Not submitted for Royal Assent%';
  IF n <> 3 THEN RAISE EXCEPTION 'A note on the clean sheet moved.'; END IF;
END $$;

COMMIT;
