-- 053_three_notes_say_what_a_reader_needs.sql
--
-- Five changes to the words of three notes, settled with the owner on
-- 2026-09-12 while signing them off. Nothing about any bill changes: no
-- column, no value, no bill's coding, no note added or removed. Eight notes
-- before and eight after.
--
-- The one that matters is M8 on Royal Assent. It said the date "is taken from
-- legislation.gov.uk". That states which source settles a disagreement, but it
-- reads as a statement of where the dates came from, and as that it is false:
-- eight of the 128 Acts in Sessions 1 and 2 have been checked there and the
-- other 120 stand on the fact sheet. Found by the owner, reading the notes in
-- full for the closure test's seventh sign-off.
--
-- Each change is made by replacing an anchor that must be present exactly
-- once, so a note whose wording has moved on stops the migration instead of
-- being quietly rewritten.

\set ON_ERROR_STOP on

BEGIN;

DO $$
DECLARE b text; n integer;
BEGIN
  -- M4: the hybrid bill is the only one
  SELECT body INTO b FROM methodology_note WHERE code = 'M4';
  IF b IS NULL THEN RAISE EXCEPTION 'Refusing: M4 not found.'; END IF;
  IF (length(b) - length(replace(b, 'One has ever been introduced in the Scottish Parliament', ''))) / length('One has ever been introduced in the Scottish Parliament') <> 1 THEN
    RAISE EXCEPTION 'Refusing: M4 does not contain the anchor "the hybrid bill is the only one" exactly once.';
  END IF;
  UPDATE methodology_note SET body = replace(b, 'One has ever been introduced in the Scottish Parliament', 'Only one has ever been introduced in the Scottish Parliament') WHERE code = 'M4';

  -- M7: the plumbing goes, the warning to a reader stays
  SELECT body INTO b FROM methodology_note WHERE code = 'M7';
  IF b IS NULL THEN RAISE EXCEPTION 'Refusing: M7 not found.'; END IF;
  IF (length(b) - length(replace(b, ' That comparison is made against the day held in this data, and not by the program that reads the fact sheet, which is given the fact sheet and nothing else; each of those bills carries a note giving the rule and the source of its session''s last day. Until the remainder is done, a count of bills by outcome will show fallen bills under a general code, and that should not be read as a finding that they ran out of time.', ''))) / length(' That comparison is made against the day held in this data, and not by the program that reads the fact sheet, which is given the fact sheet and nothing else; each of those bills carries a note giving the rule and the source of its session''s last day. Until the remainder is done, a count of bills by outcome will show fallen bills under a general code, and that should not be read as a finding that they ran out of time.') <> 1 THEN
    RAISE EXCEPTION 'Refusing: M7 does not contain the anchor "the plumbing goes, the warning to a reader stays" exactly once.';
  END IF;
  UPDATE methodology_note SET body = replace(b, ' That comparison is made against the day held in this data, and not by the program that reads the fact sheet, which is given the fact sheet and nothing else; each of those bills carries a note giving the rule and the source of its session''s last day. Until the remainder is done, a count of bills by outcome will show fallen bills under a general code, and that should not be read as a finding that they ran out of time.', ' Where this has not yet been done for a session, its fallen bills show under a general code, and that should not be read as a finding that they ran out of time.') WHERE code = 'M7';

  -- M8: Royal Assent: which source settles it, not where the dates came from
  SELECT body INTO b FROM methodology_note WHERE code = 'M8';
  IF b IS NULL THEN RAISE EXCEPTION 'Refusing: M8 not found.'; END IF;
  IF (length(b) - length(replace(b, 'The date of Royal Assent is taken from legislation.gov.uk, where recording it is one of the site''s purposes.', ''))) / length('The date of Royal Assent is taken from legislation.gov.uk, where recording it is one of the site''s purposes.') <> 1 THEN
    RAISE EXCEPTION 'Refusing: M8 does not contain the anchor "Royal Assent: which source settles it, not where the dates came from" exactly once.';
  END IF;
  UPDATE methodology_note SET body = replace(b, 'The date of Royal Assent is taken from legislation.gov.uk, where recording it is one of the site''s purposes.', 'Royal Assent is definitive on legislation.gov.uk, where recording it is one of the site''s purposes, and any disagreement about it is settled there. Most Royal Assent dates here have not been checked against it individually; they stand on the fact sheet, and a date that has been checked says so.') WHERE code = 'M8';

  -- M8: a count that would need rewriting every session
  SELECT body INTO b FROM methodology_note WHERE code = 'M8';
  IF b IS NULL THEN RAISE EXCEPTION 'Refusing: M8 not found.'; END IF;
  IF (length(b) - length(replace(b, ' Thirteen such disagreements were found in Sessions 1 and 2, between the factsheets and the PhD dataset: eight confirmed the factsheet and five did not, and all five of those were dates of Royal Assent.', ''))) / length(' Thirteen such disagreements were found in Sessions 1 and 2, between the factsheets and the PhD dataset: eight confirmed the factsheet and five did not, and all five of those were dates of Royal Assent.') <> 1 THEN
    RAISE EXCEPTION 'Refusing: M8 does not contain the anchor "a count that would need rewriting every session" exactly once.';
  END IF;
  UPDATE methodology_note SET body = replace(b, ' Thirteen such disagreements were found in Sessions 1 and 2, between the factsheets and the PhD dataset: eight confirmed the factsheet and five did not, and all five of those were dates of Royal Assent.', '') WHERE code = 'M8';

  -- M8: the same paragraph, cut to what a reader needs
  SELECT body INTO b FROM methodology_note WHERE code = 'M8';
  IF b IS NULL THEN RAISE EXCEPTION 'Refusing: M8 not found.'; END IF;
  IF (length(b) - length(replace(b, 'Two things follow that a reader should know. First, a date that carries a source of its own has been checked against that source; a date that does not carries the source of the row it sits on, normally a factsheet, and has not been individually checked. The two look alike in the data and are told apart by the source recorded against them. Second, only dates where two sources actually disagreed have been checked, so nothing here should be read as the factsheets having been verified generally. Checking every Royal Assent date against legislation.gov.uk is possible and has not been done. The two sources are independently compiled, and for Sessions 1 and 2 they now agree on every one of the 154 introduction dates and all 128 dates of Royal Assent. Agreement between two independent records is weaker than checking the Act itself and stronger than a single source standing alone, and it is the footing most of this data rests on.', ''))) / length('Two things follow that a reader should know. First, a date that carries a source of its own has been checked against that source; a date that does not carries the source of the row it sits on, normally a factsheet, and has not been individually checked. The two look alike in the data and are told apart by the source recorded against them. Second, only dates where two sources actually disagreed have been checked, so nothing here should be read as the factsheets having been verified generally. Checking every Royal Assent date against legislation.gov.uk is possible and has not been done. The two sources are independently compiled, and for Sessions 1 and 2 they now agree on every one of the 154 introduction dates and all 128 dates of Royal Assent. Agreement between two independent records is weaker than checking the Act itself and stronger than a single source standing alone, and it is the footing most of this data rests on.') <> 1 THEN
    RAISE EXCEPTION 'Refusing: M8 does not contain the anchor "the same paragraph, cut to what a reader needs" exactly once.';
  END IF;
  UPDATE methodology_note SET body = replace(b, 'Two things follow that a reader should know. First, a date that carries a source of its own has been checked against that source; a date that does not carries the source of the row it sits on, normally a factsheet, and has not been individually checked. The two look alike in the data and are told apart by the source recorded against them. Second, only dates where two sources actually disagreed have been checked, so nothing here should be read as the factsheets having been verified generally. Checking every Royal Assent date against legislation.gov.uk is possible and has not been done. The two sources are independently compiled, and for Sessions 1 and 2 they now agree on every one of the 154 introduction dates and all 128 dates of Royal Assent. Agreement between two independent records is weaker than checking the Act itself and stronger than a single source standing alone, and it is the footing most of this data rests on.', 'A date that carries a source of its own has been checked against that source; a date that does not carries the source of the row it sits on, normally a fact sheet, and has not been individually checked. Only dates where two sources disagreed have been checked, so nothing here should be read as the fact sheets having been verified generally: the two sources are independently compiled and now agree throughout Sessions 1 and 2, which is weaker than checking the Act itself and stronger than a single source standing alone.') WHERE code = 'M8';
  -- What should now be true
  SELECT count(*) INTO n FROM methodology_note;
  IF n <> 8 THEN RAISE EXCEPTION 'Refusing: % notes, expected 8.', n; END IF;

  SELECT count(*) INTO n FROM methodology_note
   WHERE body IS NULL OR btrim(body) = '' OR title IS NULL OR btrim(title) = '';
  IF n <> 0 THEN RAISE EXCEPTION 'Refusing: % note(s) left empty.', n; END IF;

  SELECT count(*) INTO n FROM methodology_note
   WHERE code = 'M8' AND body LIKE '%Most Royal Assent dates here have not been checked against it individually%';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: M8 does not now say most assent dates are unchecked.'; END IF;

  SELECT count(*) INTO n FROM methodology_note
   WHERE code = 'M8' AND body LIKE '%A date that carries a source of its own has been checked against that source%';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: M8 no longer tells a checked date from an unchecked one.'; END IF;

  SELECT count(*) INTO n FROM methodology_note
   WHERE code = 'M7' AND body LIKE '%should not be read as a finding that they ran out of time%';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: M7 no longer warns about an uncoded session.'; END IF;

  -- Nothing that was removed may still be there
  SELECT count(*) INTO n FROM methodology_note
   WHERE body LIKE '%not by the program that reads the fact sheet%'
      OR body LIKE '%Thirteen such disagreements were found%'
      OR body LIKE '%The date of Royal Assent is taken from legislation.gov.uk%';
  IF n <> 0 THEN RAISE EXCEPTION 'Refusing: % note(s) still carry wording this migration removes.', n; END IF;

  RAISE NOTICE 'Three notes rewritten; eight notes, none empty.';
END $$;

\echo ''
\echo '--- The eight notes, by length'
SELECT code, length(body) AS characters,
       array_length(regexp_split_to_array(btrim(body), '\s+'), 1) AS words
  FROM methodology_note ORDER BY sort_order;

COMMIT;
