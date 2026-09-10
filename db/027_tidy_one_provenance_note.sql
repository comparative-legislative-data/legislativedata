-- 027_tidy_one_provenance_note.sql
--
-- Corrects one cell, written wrong by the promotion script on its first run.
--
-- The provenance note for bill 17's corrected title had the whole reviewer's
-- comment in source_ref, which is meant to hold a short pointer to where the
-- fact came from. The comment ended "Needs a field_source row at promotion,
-- source = manual, recording both" — an instruction to whoever wrote the
-- promotion script, saved into the database as though it were a citation. The
-- script was fixed at the same time and files a short reference now, so no
-- later session can do this again.
--
-- Why this needs a migration at all. db/025 made field_source append-only, so
-- the row cannot be changed while that rule is in force. The rule is suspended
-- for the length of this transaction and put back before it ends.
--
-- The rule is not weakened by this and is not going to be. It exists so that a
-- published record revised in 2030 cannot be quietly overwritten, leaving no
-- trace that the Parliament changed its mind. It does not exist to preserve a
-- mistake made by a script an hour after the table was first written to, on
-- data nobody outside this project has seen. Treating it as though it did was
-- an error of judgement recorded in DECISIONS.md, not a property of the rule.
--
-- The test for a future case: is the row a record of what a source said, or is
-- it debris from our own tooling? A source's words stay, always, even when
-- they turn out to be wrong — that is the whole point. Our debris gets cleaned
-- up, in a migration that says what it changed and why.

BEGIN;

ALTER TABLE field_source DISABLE TRIGGER field_source_no_change;

UPDATE field_source
   SET source_ref = 'review of staging line 17'
 WHERE entity     = 'bill'
   AND entity_id  = 17
   AND field_name = 'short_title'
   AND source     = 'manual'
   AND source_ref LIKE '%Needs a field_source row at promotion%';

ALTER TABLE field_source ENABLE TRIGGER field_source_no_change;

-- The reasoning is not lost: it is in this row's note, and the factsheet's own
-- wording is in bill_candidate.raw_title, which is never edited.
DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM field_source
   WHERE source_ref LIKE '%Needs a field_source row at promotion%';
  IF n > 0 THEN RAISE EXCEPTION 'Not corrected: % row(s) still hold the instruction text.', n; END IF;

  SELECT count(*) INTO n FROM field_source
   WHERE entity = 'bill' AND entity_id = 17 AND field_name = 'short_title'
     AND source_ref = 'review of staging line 17';
  IF n <> 1 THEN RAISE EXCEPTION 'Expected exactly one corrected row, found %.', n; END IF;

  SELECT count(*) INTO n FROM field_source;
  IF n <> 6 THEN RAISE EXCEPTION 'Expected 6 provenance notes, found %.', n; END IF;

  RAISE NOTICE 'Corrected. The append-only rule is back on.';
END $$;

COMMIT;
