-- 017_drop_scratch_test.sql
-- scratch_test was created on 2026-09-10 to prove that Postico's grid edits
-- really reached the VPS, which they did. Three rows, named 'first row',
-- 'second row' and 'third row', with notes reading 'edit me' and 'delete me'.
-- It has served its purpose and is now debris in the schema.
--
-- Dropped rather than kept: an unexplained table sitting beside bill and
-- bill_candidate is a small trap for anyone reading the schema later. Its
-- contents are in the backup taken earlier today if they are ever wanted, which
-- they will not be.
--
-- Note what is NOT dropped here. stage_event is also empty, and db/004 said to
-- drop it unless a reason to keep it appeared. A reason has appeared — see
-- DECISIONS.md — so it stays.

BEGIN;

DROP TABLE IF EXISTS scratch_test;

COMMIT;
