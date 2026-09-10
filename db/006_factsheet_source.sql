-- 006_factsheet_source.sql
-- The SPICe legislation factsheets are the source for the first slice, so they
-- need their own code. They are derived documents: SPICe made the outcome-by-type
-- judgement themselves, so rows taken from them are attributed to the factsheet
-- rather than recorded as our own work.

BEGIN;

INSERT INTO ref_source (code, label, definition, sort_order) VALUES
 ('spice_factsheet','SPICe legislation factsheet',
  'Session factsheet published by SPICe. A derived source: the outcome and type coding is theirs. Put the session and retrieval date in source_ref, e.g. "session 6, retrieved 2026-09-10". The retrieved copy is in sources/factsheets/.',
  2);

UPDATE ref_source SET sort_order = sort_order + 1 WHERE code <> 'spice_factsheet' AND sort_order >= 2;

COMMIT;
