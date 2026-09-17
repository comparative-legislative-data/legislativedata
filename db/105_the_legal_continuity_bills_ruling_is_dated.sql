-- db/105_the_legal_continuity_bills_ruling_is_dated.sql
--
-- Settled by the owner on 2026-09-17: where a date is missing, add it with its
-- provenance, then correct the note.
--
-- THE GAP. The UK Withdrawal from the European Union (Legal Continuity)
-- (Scotland) Bill, bill 305, is one of four bills stopped before Royal Assent.
-- The other three carry the date they were stopped, read from the fact sheet's
-- footnote. This one's footnote gives no date, so its cell was left empty and
-- its note said "The fact sheet states no date for the ruling." M5 then misdated
-- the ruling, putting it with the other two section 33 rulings on 6 October
-- 2021. Found by the check of Phase 2's plan, 16 September.
--
-- THE DATE: 13 December 2018, the Supreme Court's judgment on the reference
-- ([2018] UKSC 64), from the Court's own case page, UKSC/2018/0080, read
-- 2026-09-17 and kept in sources/judgments/. The same page gives 17 April 2018
-- as the day the reference was lodged. The ruling date is used because it is
-- the point the fact sheets date the UNCRC and European Charter bills by, so
-- the four dates mean the same thing.
--
-- WHAT THIS CHANGES: the staging sheet only, and the list of sources.
--   * A new source, supreme_court. None on the list fitted: bill_page is the
--     Parliament's, legislation_gov_uk holds Acts.
--   * Line 305, Session 5: the date, a "Checked:" citation, which promotion
--     turns into the provenance note, and the note giving the date.
--   * Line 412, Session 6, the bill's further appearance: its note, which is
--     the one that ends up on the bill, gives the date too.
--   * Both lines' reviewed_at move to today, because the note is dated by the
--     day it was written (db/101) and it was written today.
-- The clean sheet changes when Sessions 7, 6 and 5 are taken off and put back,
-- which is the ordinary route for a closed session and follows this migration.
--
-- A FAULT IN PROMOTION, mended in the same commit. The step that credits a
-- blocked bill's date to the fact sheet's footnote ran whenever there was a date
-- and a footnote, and ran before the "Checked:" step. So this date would have
-- been attributed to a fact sheet that does not print it. It now leaves a date
-- with a "Checked:" citation to the step that cites the source that gives it.
--
-- EVERY BILL CODED THE OLD WAY, RECHECKED. Four bills are stopped before Royal
-- Assent; three had their date from the footnote and keep it. Four lines carry
-- those dates: lines 303, 304 and 393, and line 474, Session 7's restatement of
-- bill 393, which promotion does not carry onto the bill. None carries a
-- "Checked: date_assent_blocked" citation, so the mended step writes them
-- exactly as before. No other line has a stopped date.

\set ON_ERROR_STOP on
BEGIN;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM ref_source WHERE code = 'supreme_court';
  IF n > 0 THEN RAISE EXCEPTION 'Refusing: supreme_court is already a source.'; END IF;

  SELECT count(*) INTO n FROM bill_candidate
   WHERE candidate_id = 305 AND session_number = 5 AND date_assent_blocked IS NULL
     AND bill_note LIKE '%The fact sheet states no date for the ruling.';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: line 305 is not as it was.'; END IF;

  SELECT count(*) INTO n FROM bill_candidate
   WHERE candidate_id = 412 AND continues_bill_id = 305 AND date_assent_blocked IS NULL
     AND bill_note LIKE '%The fact sheet states no date for the ruling. The bill was withdrawn on 10 March 2022.';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: line 412 is not as it was.'; END IF;

  SELECT count(*) INTO n FROM bill_candidate WHERE date_assent_blocked IS NOT NULL;
  IF n <> 4 THEN RAISE EXCEPTION 'Refusing: % lines carry a stopped date, expected 4.', n; END IF;

  SELECT count(*) INTO n FROM bill_candidate
   WHERE review_note ~ 'Checked: date_assent_blocked = ';
  IF n > 0 THEN RAISE EXCEPTION 'Refusing: % line(s) already cite a checked stopped date.', n; END IF;

  SELECT count(*) INTO n FROM bill;
  IF n <> 470 THEN RAISE EXCEPTION 'Refusing: % bills, expected 470.', n; END IF;
  SELECT count(*) INTO n FROM field_source;
  IF n <> 187 THEN RAISE EXCEPTION 'Refusing: % provenance notes, expected 187.', n; END IF;
END $$;

-- ---------------------------------------------------------------------------
-- 1. The source
-- ---------------------------------------------------------------------------

INSERT INTO ref_source (code, label, definition, sort_order)
SELECT 'supreme_court', 'Supreme Court',
       'The UK Supreme Court''s own page for a case, or its judgment. Definitive for the date the Court ruled on a reference, such as one under section 33 of the Scotland Act 1998. Put the address of the case page in source_ref.',
       max(sort_order) + 1
  FROM ref_source;

-- ---------------------------------------------------------------------------
-- 2. The two lines
-- ---------------------------------------------------------------------------

UPDATE bill_candidate
   SET date_assent_blocked = DATE '2018-12-13',
       bill_note = 'Not submitted for Royal Assent. Following a reference under section 33 of the Scotland Act 1998 by the Attorney General and the Advocate General for Scotland, the Supreme Court ruled on 13 December 2018 that some provisions of the bill were outwith the Parliament''s legislative competence, and it could not be submitted for Royal Assent in its unamended form.',
       review_note = review_note || E'\n'
         || 'Checked: date_assent_blocked = 2018-12-13 (supreme_court, https://www.supremecourt.uk/cases/uksc-2018-0080, 2026-09-17)' || E'\n'
         || 'The fact sheet''s footnote gives no date for the ruling. The Supreme Court''s case page gives its judgment on the reference as 13 December 2018, [2018] UKSC 64, which is the point the fact sheets date the other two section 33 rulings by. The note now gives the date instead of saying none is stated. Settled by the owner on 2026-09-17; see db/105.',
       reviewed_at = now()
 WHERE candidate_id = 305;

UPDATE bill_candidate
   SET bill_note = 'Not submitted for Royal Assent. Following a reference under section 33 of the Scotland Act 1998 by the Attorney General and the Advocate General for Scotland, the Supreme Court ruled on 13 December 2018 that some provisions of the bill were outwith the Parliament''s legislative competence, and it could not be submitted for Royal Assent in its unamended form. The bill was withdrawn on 10 March 2022.',
       review_note = review_note || E'\n'
         || 'The note was rewritten on 2026-09-17 to give the date of the Supreme Court''s ruling, now recorded on line 305 from the Court''s case page, in place of saying the fact sheet states none. See db/105.',
       reviewed_at = now()
 WHERE candidate_id = 412;

-- ---------------------------------------------------------------------------
-- 3. Proof
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM bill_candidate WHERE date_assent_blocked IS NOT NULL;
  IF n <> 5 THEN RAISE EXCEPTION '% lines carry a stopped date, expected 5.', n; END IF;

  SELECT count(*) INTO n FROM bill_candidate
   WHERE bill_note ~ 'states no date for the ruling';
  IF n > 0 THEN RAISE EXCEPTION '% line(s) still say no date is stated.', n; END IF;

  SELECT count(*) INTO n FROM bill_candidate c
   CROSS JOIN LATERAL regexp_matches(coalesce(c.review_note, ''),
        'Checked: ([a-z0-9_]+) = ([^\n]+?) \(([a-z_]+), ([^,]+), (\d{4}-\d{2}-\d{2})\)', 'g') m
   WHERE c.candidate_id = 305 AND m[1] = 'date_assent_blocked' AND m[2] = '2018-12-13'
     AND m[3] = 'supreme_court' AND m[5] = '2026-09-17';
  IF n <> 1 THEN RAISE EXCEPTION 'Line 305''s citation does not read as promotion reads it.'; END IF;

  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n <> 0 THEN RAISE EXCEPTION 'The error checker finds % problem(s), expected none.', n; END IF;

  SELECT count(*) INTO n FROM bill;
  IF n <> 470 THEN RAISE EXCEPTION '% bills, expected 470.', n; END IF;
  SELECT count(*) INTO n FROM field_source;
  IF n <> 187 THEN RAISE EXCEPTION '% provenance notes, expected 187.', n; END IF;

  RAISE NOTICE 'Lines 305 and 412 carry the ruling date. The clean sheet is unchanged until the sessions are put back.';
END $$;

COMMIT;
