-- 026_a_bill_keeps_its_number.sql
--
-- A bill's number is now the number of the staging line it came from, instead
-- of one handed out in sequence as rows are added.
--
-- Why. Promotion is supposed to be free to redo — that is the reason it was
-- safe to promote Session 1 before the other six were even loaded. It nearly
-- is. bill_candidate is permanent, stage_event rows go with their bill, and a
-- staging line's promoted_bill_id empties itself when its bill goes. One thing
-- did not unwind: field_source records which bill a provenance note is about by
-- the bill's number, and that table is append-only (db/025), so those rows
-- cannot be corrected afterwards. Empty bill, promote again, and the numbers
-- are reissued in a different order while six notes still hold the old ones —
-- silently pointing at the wrong bill, or at none.
--
-- The fix is to stop the numbers moving. Each bill takes the candidate_id of
-- the staging line it was promoted from, so the same line always yields the
-- same bill number however many times promotion is run.
--
-- What this costs. Bill numbers are no longer an unbroken run. Four bills
-- appear in two factsheets each (M6) and take the number of the first line
-- promoted, so four candidate_ids are never used as bill numbers. bill_id was
-- always our own invented identifier, never shown to a reader and never the
-- Parliament's, so a gap in it means nothing.
--
-- What this buys, besides the fix. The number is now readable in both
-- directions with no lookup: staging line 17 is bill 17. And a bill can no
-- longer exist without a staging line behind it, which is the gateway rule
-- from CLAUDE.md turned into something the database enforces rather than
-- something the promotion script is trusted to honour.
--
-- bill and field_source are both empty today, so this costs nothing to apply.

BEGIN;

-- Nothing hands out bill numbers any more; promotion supplies them.
ALTER TABLE bill ALTER COLUMN bill_id DROP DEFAULT;
DROP SEQUENCE bill_bill_id_seq;

-- A bill's number must be a staging line's number. This also refuses a bill
-- that never went through the gate.
ALTER TABLE bill
  ADD CONSTRAINT bill_id_is_its_candidate_id
  FOREIGN KEY (bill_id) REFERENCES bill_candidate (candidate_id);

COMMENT ON COLUMN bill.bill_id IS
  'Our own identifier for the bill, invented by us and never the Parliament''s. It is the candidate_id of the staging line this bill was promoted from, so a bill keeps the same number if the table is emptied and promotion is run again — which is what keeps the provenance notes in field_source pointing at the right bill. Not an unbroken run: the four bills that appear in two factsheets take the number of the first line promoted. Never changes.';

COMMENT ON COLUMN field_source.entity_id IS
  'Which row in that table, by its identifier. For a bill this is stable: its number comes from its staging line, so it survives the table being emptied and promotion being run again. For a stage row it is not — stage rows are reissued along with their bill. That is rarely a problem, because a stage row carries its own source, source_ref and observed_at, so a stage date that came from somewhere other than the bill''s source is recorded there and needs nothing here. Only a second, later observation of the same stage date needs a row here, and it should be checked after any re-promotion.';

COMMIT;
