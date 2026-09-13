-- db/065_a_provenance_note_names_a_column_that_exists.sql
--
-- The owner's ruling of 2026-09-13: make the provenance notes consistent.
-- See DECISIONS.md.
--
-- What was wrong, and it is worse than a difference of wording. Promotion wrote
-- the standard sentence on a checked value by working the raw column's name out
-- of the column's own name: it replaced a leading "date_" with "raw_date_" and
-- then put "bill_candidate.raw_" in front of the result. For a date that gives
-- "bill_candidate.raw_raw_date_royal_assent" -- the prefix twice. For anything
-- else it gives a column that was never there at all. Every one of the eighteen
-- notes of this kind on the clean sheet points at a column that does not exist:
--
--     date_royal_assent   10  bill_candidate.raw_raw_date_royal_assent
--     date_introduced      5  bill_candidate.raw_raw_date_introduced
--     asp_number           1  bill_candidate.raw_asp_number
--     bill_type            1  bill_candidate.raw_bill_type
--     date_completed       1  (no second sentence at all)
--
-- The real columns are raw_date_royal_assent, raw_date_introduced, raw_title --
-- the asp number is inside the title -- and raw_type.
--
-- Why it matters rather than being tidiness. The owner is the check on every
-- research claim this project makes, and a provenance note exists so that claim
-- can be followed back to what said so. A note that sends the reader to a column
-- that does not exist cannot be followed anywhere, and it fails silently: it
-- reads like a citation.
--
-- The fix. One sentence that is true of every column rather than a name worked
-- out per column, which is what produced this. The raw_ columns are described
-- one by one in the data dictionary, so the note points at the group and the
-- dictionary says which. Promotion writes the same sentence from now on, so a
-- session taken off and put back reproduces what is here.
--
-- Also wrong and fixed with it: the sentence said "the source that owns this
-- date" on notes about an Act's number and a bill's type, neither of which is a
-- date.
--
-- This changes notes already on the clean sheet, which the owner cleared
-- individually on 2026-09-13 under their standing position. No value, source,
-- address or date read changes -- only the sentence that explains them.

\set ON_ERROR_STOP on
BEGIN;

CREATE TEMP TABLE before_notes ON COMMIT DROP AS
SELECT count(*)                                                        AS notes,
       count(*) FILTER (WHERE note LIKE 'Checked at review%')          AS checked,
       count(*) FILTER (WHERE note LIKE '%raw_raw_%')                  AS doubled,
       count(*) FILTER (WHERE note IS NULL)                            AS empty,
       md5(string_agg(coalesce(source,'') || '|' || coalesce(source_ref,'') || '|'
                      || coalesce(value_seen,'') || '|' || observed_at::text,
                      E'\n' ORDER BY field_source_id))                 AS facts
  FROM field_source;

DO $$
DECLARE b record;
BEGIN
  SELECT * INTO b FROM before_notes;
  IF b.notes <> 71 THEN RAISE EXCEPTION 'Refusing: expected 71 provenance notes, found %.', b.notes; END IF;
  IF b.checked <> 18 THEN RAISE EXCEPTION 'Refusing: expected 18 checked-at-review notes, found %.', b.checked; END IF;
  IF b.doubled <> 15 THEN RAISE EXCEPTION 'Refusing: expected 15 with a doubled prefix, found %.', b.doubled; END IF;
  RAISE NOTICE 'Before: % notes, % of them checked-at-review, % naming raw_raw_.',
               b.notes, b.checked, b.doubled;
END $$;

UPDATE field_source
   SET note = 'Checked at review against the source that owns this value. The '
              || 'factsheet''s own printed words are kept in the raw_ columns of '
              || 'bill_candidate.'
 WHERE note LIKE 'Checked at review%';

DO $$
DECLARE n integer; b record;
BEGIN
  SELECT * INTO b FROM before_notes;

  -- Every one rewritten, and none left naming a column that is not there.
  SELECT count(*) INTO n FROM field_source WHERE note LIKE 'Checked at review%';
  IF n <> 18 THEN RAISE EXCEPTION 'Check failed: % checked-at-review notes, expected 18.', n; END IF;
  SELECT count(*) INTO n FROM field_source WHERE note LIKE '%raw_raw_%';
  IF n <> 0 THEN RAISE EXCEPTION 'Check failed: % note(s) still name raw_raw_.', n; END IF;
  SELECT count(*) INTO n FROM field_source
   WHERE note LIKE 'Checked at review%' AND note ~ 'bill_candidate\.raw_[a-z_]+';
  IF n <> 0 THEN RAISE EXCEPTION 'Check failed: % rewritten note(s) still name a particular raw_ column.', n; END IF;

  -- Every raw_ column any note still names must actually exist. One note does
  -- name one -- db/026's correction of a title, which cites raw_title, and
  -- rightly: that column is there and holds the words it quotes.
  SELECT count(*) INTO n
    FROM field_source f
    CROSS JOIN LATERAL regexp_matches(f.note, 'bill_candidate\.(raw_[a-z_]+)', 'g') AS m
   WHERE NOT EXISTS (SELECT 1 FROM information_schema.columns c
                      WHERE c.table_schema = 'public' AND c.table_name = 'bill_candidate'
                        AND c.column_name = m[1]);
  IF n <> 0 THEN
    RAISE EXCEPTION 'Check failed: % note(s) name a raw_ column that does not exist.', n;
  END IF;
  SELECT count(*) INTO n FROM field_source
   WHERE note LIKE 'Checked at review%' AND note LIKE '%owns this date%';
  IF n <> 0 THEN RAISE EXCEPTION 'Check failed: % note(s) still say "this date".', n; END IF;
  SELECT count(DISTINCT note) INTO n FROM field_source WHERE note LIKE 'Checked at review%';
  IF n <> 1 THEN RAISE EXCEPTION 'Check failed: % wordings for one sentence.', n; END IF;

  -- Nothing but the sentence moved: same rows, same facts, same empties.
  SELECT count(*) INTO n FROM field_source;
  IF n <> b.notes THEN RAISE EXCEPTION 'Check failed: the number of notes changed.'; END IF;
  SELECT count(*) INTO n FROM field_source WHERE note IS NULL;
  IF n <> b.empty THEN RAISE EXCEPTION 'Check failed: notes without a sentence changed in number.'; END IF;
  SELECT count(*) INTO n FROM (
    SELECT md5(string_agg(coalesce(source,'') || '|' || coalesce(source_ref,'') || '|'
                          || coalesce(value_seen,'') || '|' || observed_at::text,
                          E'\n' ORDER BY field_source_id)) AS facts FROM field_source) x
   WHERE x.facts IS DISTINCT FROM b.facts;
  IF n <> 0 THEN
    RAISE EXCEPTION 'Check failed: a value, source, address or date read moved. Only the sentence may.';
  END IF;

  -- And promotion will write the same sentence, so a re-promotion reproduces it.
  RAISE NOTICE 'After: 18 notes in one wording, naming no column that is not there; % notes in all.', b.notes;
END $$;

COMMIT;
