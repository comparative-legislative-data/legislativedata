-- 010_procedure_nullable.sql
-- procedure was NOT NULL DEFAULT 'standard'. That made every row assert standard
-- procedure as a fact, when in fact no source consulted so far states procedure
-- at all — the SPICe factsheets have no such column. A budget bill and an
-- emergency bill were being recorded as standard on no evidence.
--
-- Same reasoning as party in 004: null means "not applicable or not known",
-- and 'standard' becomes a positive finding rather than a default.
--
-- Safe to apply: bill is empty.

BEGIN;

ALTER TABLE bill ALTER COLUMN procedure DROP NOT NULL;
ALTER TABLE bill ALTER COLUMN procedure DROP DEFAULT;

COMMENT ON COLUMN bill.procedure IS
 'How the bill was handled under standing orders. Null means not known — no source consulted so far states it. ''standard'' is a positive finding, not a default; do not backfill it.';

-- Candidates likewise: the extractor must not propose what it cannot see.
ALTER TABLE bill_candidate ALTER COLUMN procedure DROP DEFAULT;
UPDATE bill_candidate SET procedure = NULL WHERE procedure = 'standard';

COMMIT;
