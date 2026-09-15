-- db/097_m12_cut_to_what_it_is_saying.sql
--
-- M12 is text a reader sees, and it ran to 290 words for a judgement that takes
-- about ninety. The owner read it whole on 15 September, in answer to the
-- fourteenth item of db/089-091's closure test, and asked: "Why such a detailed
-- explanation for the simple fact that we found the data to replace stale dates
-- in the factsheet? Isn't that all we are saying?" Mostly it was.
--
-- WHAT IS CUT, and why none of it is a claim the data relies on:
--
--   * The second telling of "a fact sheet is not a running record". The first
--     sentence already says it.
--   * The paragraph distinguishing where the line came from (the fact sheet)
--     from where particular facts came from (legislation.gov.uk). A reader does
--     not need that explained in the abstract: every such cell carries its own
--     note naming legislation.gov.uk and the day it was read, and the data
--     dictionary says what field_source holds. One clause survives it.
--   * The list of the seven Session 6 Acts. It duplicates the data, and it goes
--     out of date the moment another session brings more. The bills are
--     findable by the source on their own cells, which is the point of
--     recording provenance per field at all.
--   * The closing paragraph on blocked bills, reduced to a clause pointing at
--     M5, which is where that case is actually explained.
--
-- WHAT SURVIVES, because a reader would be worse off without it:
--
--   * A fact sheet is a snapshot, and seven Session 6 bills had already become
--     Acts when we read it. The fact, and the evidence that it matters.
--   * Every bill a sheet leaves awaiting Royal Assent is checked, and the
--     answer recorded whether or not anything changed. This is the sentence the
--     owner picked out as earning its place: it is what lets a reader tell
--     "looked up, still no Act" from "never looked at", and it is why the four
--     blocked bills read blocked rather than unknown.
--   * Where the Act was made, three named facts come from legislation.gov.uk,
--     with the day each was read.
--
-- Nothing else changes. applies_to is untouched, the four cells it names are
-- untouched, and no bill, line, stage record or provenance note is altered by
-- this migration. The error checker's complaint on an awaiting-assent line
-- without a look-up citation still says "see methodology note M12" and still
-- means this note.
--
-- Settled by the owner on 2026-09-15. See DECISIONS.md of the same date.
--
-- The wording this replaces is quoted in full in docs/STATE.md as committed at
-- ccac41c, which is where to look if any of it is ever wanted back.

\set ON_ERROR_STOP on
BEGIN;

UPDATE methodology_note
   SET title = 'A fact sheet is a snapshot',
       body  = 'A fact sheet says where each bill had got to on the day it was compiled, not where it stands now. Seven bills the Session 6 sheet leaves awaiting Royal Assent had become Acts four months before we read it.

So every bill a fact sheet leaves awaiting Royal Assent is checked at legislation.gov.uk before it is admitted, and the answer recorded either way — including where no Act has been made, as for the four bills M5 covers. Where the Act was made, its date of Royal Assent, its number and its title come from legislation.gov.uk and say so, with the day each was read. The rest of the bill''s line still comes from the fact sheet.'
 WHERE code = 'M12';

-- ---------------------------------------------------------------------------
-- Checks. Any failure aborts, and nothing is written.
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer; t text; b text;
BEGIN
  SELECT count(*) INTO n FROM methodology_note WHERE code = 'M12';
  IF n <> 1 THEN RAISE EXCEPTION 'M12 matched % row(s), expected 1.', n; END IF;

  SELECT title, body INTO t, b FROM methodology_note WHERE code = 'M12';

  IF t <> 'A fact sheet is a snapshot' THEN
    RAISE EXCEPTION 'M12 title did not take: %', t;
  END IF;

  -- The sentence the owner kept it for.
  IF b !~ 'the answer recorded either way' THEN
    RAISE EXCEPTION 'M12 no longer says the answer is recorded either way.';
  END IF;

  -- The cross-reference M5 is still carrying.
  IF b !~ 'M5' THEN
    RAISE EXCEPTION 'M12 no longer points a reader at M5.';
  END IF;

  IF length(b) > 800 THEN
    RAISE EXCEPTION 'M12 is % characters; it was cut to be short.', length(b);
  END IF;

  -- The twelve notes are still twelve, and nothing else moved.
  SELECT count(*) INTO n FROM methodology_note;
  IF n <> 12 THEN RAISE EXCEPTION '% methodology notes, expected 12.', n; END IF;

  SELECT count(*) INTO n FROM methodology_note
   WHERE code <> 'M12' AND updated_at > TIMESTAMPTZ '2026-09-15 00:00:00+00'
     AND updated_at > created_at + INTERVAL '1 second'
     AND updated_at >= now() - INTERVAL '5 minutes';
  IF n > 0 THEN RAISE EXCEPTION '% other note(s) were changed by this migration.', n; END IF;

  SELECT count(*) INTO n FROM methodology_note
   WHERE code = 'M12'
     AND applies_to = ARRAY['bill.date_royal_assent','bill.asp_number',
                            'bill.short_title','bill.enactment_status'];
  IF n <> 1 THEN RAISE EXCEPTION 'M12 applies_to was changed; it should not have been.'; END IF;

  -- Nothing about the data.
  SELECT count(*) INTO n FROM bill;
  IF n <> 389 THEN RAISE EXCEPTION '% bills on the clean sheet, expected 389.', n; END IF;

  SELECT count(*) INTO n FROM stage_event;
  IF n <> 1071 THEN RAISE EXCEPTION '% stage records, expected 1071.', n; END IF;

  SELECT count(*) INTO n FROM field_source;
  IF n <> 112 THEN RAISE EXCEPTION '% provenance notes, expected 112.', n; END IF;

  SELECT count(*) INTO n FROM stage_candidate s JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number = 6 AND s.review_status <> 'new';
  IF n > 0 THEN RAISE EXCEPTION '% Session 6 stage row(s) are no longer waiting for review.', n; END IF;

  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n <> 1 THEN RAISE EXCEPTION 'The error checker finds % problem(s), expected 1.', n; END IF;

  RAISE NOTICE 'M12 is now % characters, down from 1662. Nothing else changed.', length(b);
END $$;

COMMIT;
