-- 030_provenance_notes_are_rebuilt_with_their_bill.sql
--
-- Provenance notes stop being permanent. Decided by the owner, 2026-09-11:
-- provenance notes may change, provided the owner clears the change, and the
-- owner is the judge of what is acceptable to claim as academic quality.
--
-- What this undoes. db/025 made field_source append-only: a trigger refused
-- every edit and delete, on the reasoning that a revision to a published record
-- should add a second note, not overwrite the first (D5). In practice the rule
-- protected our own mistakes more than any source's words. db/027 had to
-- suspend it to fix a script's error, and on 2026-09-11 it turned a routine
-- re-promotion into a question about five duplicate-looking notes.
--
-- What replaces it. A provenance note is treated like a stage row:
--   - promotion writes it from the staging sheet, one note per fact;
--   - taking the session back off removes it (tools/rollback_promotion.sql);
--   - putting the session back on writes it again.
-- A note therefore records the latest reading of its source. Approving that
-- rehearsed procedure clears the notes it rebuilds, because every note is shown
-- before anything is saved. Any other change to a note comes to the owner
-- individually.
--
-- What is given up, stated rather than left to be discovered. The notes no
-- longer hold a history of readings. The source's own words stay on the
-- staging sheet, which is never emptied. Nothing yet records a second reading
-- of a source that gives a different answer, and none has happened. How to
-- record one is to be settled when the first real revision arrives
-- (DECISIONS.md and STATE.md, 2026-09-11). v_field_revisions stays, and will
-- show nothing until then.
--
-- Methodology note M5 told readers that a blocked bill's earlier state "is
-- recoverable from field_source, which is append-only". It is corrected to say
-- where that state actually is.

BEGIN;

DROP TRIGGER field_source_no_change ON field_source;
DROP FUNCTION field_source_append_only();

COMMENT ON TABLE field_source IS
 'Where one individual fact about a bill came from, when that is not where the rest of its row came from — for example a bill whose outcome came from the Official Report while the rest of its line came from a factsheet. Written by promotion from the staging sheet, one note per fact, and removed when the session is taken back off, like stage rows. A note therefore records the latest reading of its source; a history of readings is not kept here. Changing a note other than by that procedure needs the owner''s clearance.';

COMMENT ON COLUMN field_source.entity_id IS
 'Which row in that table, by its identifier. For a bill the number comes from its staging line, so a note written again after its session is taken off and put back points at the same bill. A stage row''s number is reissued each time, which is why a stage date''s source is recorded on the stage row itself rather than here.';

COMMENT ON COLUMN field_source.observed_at IS
 'The date we read the source. Not the date of the event it describes: the date we looked.';

COMMENT ON COLUMN field_source.value_seen IS
 'The value in the source''s own words, before any tidying — what was actually printed or said, not what we made of it. Empty where the fact is our coding and no single wording carries it.';

COMMENT ON COLUMN bill.bill_id IS
 'Our own identifier for the bill, invented by us and never the Parliament''s. It is the candidate_id of the staging line this bill was promoted from, so a bill keeps the same number if its session is taken off the clean sheet and put back, and anything that refers to a bill by number keeps pointing at the right one. Not an unbroken run: the four bills that appear in two factsheets take the number of the first line promoted. Never changes.';

UPDATE methodology_note
   SET body = replace(body,
         'the earlier state is recoverable from field_source, which is append-only.',
         'the earlier state is kept in the fact sheet lines this resource holds for every session, where the bill appears as each fact sheet printed it at the time, and the date of the block stays in bill.date_assent_blocked.')
 WHERE code = 'M5';

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'field_source_no_change') THEN
    RAISE EXCEPTION 'The rule refusing changes to provenance notes is still in place.';
  END IF;
  IF EXISTS (SELECT 1 FROM methodology_note WHERE body ILIKE '%append-only%') THEN
    RAISE EXCEPTION 'A methodology note still tells readers provenance notes are append-only.';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM methodology_note
                  WHERE code = 'M5' AND body LIKE '%fact sheet lines this resource holds%') THEN
    RAISE EXCEPTION 'M5 was not updated as expected: its wording no longer matches what this migration looks for.';
  END IF;
END $$;

COMMIT;
