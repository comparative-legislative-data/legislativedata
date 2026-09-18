-- db/118_undo.sql: takes db/118 off again
--
-- Puts "In progress" back at 7, sharing the place with "Fell: financial
-- resolution not agreed" as before. Then retake the published copy
-- (docs/BLOCK-2-IN-PROGRESS.md, "The undo"), so the copy says the same.
-- Refuses unless db/118 is what it finds.

\set ON_ERROR_STOP on
BEGIN;

DO $$
BEGIN
  IF (SELECT string_agg(code || '=' || sort_order, ',' ORDER BY code) FROM ref_outcome)
     IS DISTINCT FROM 'fell_dissolution=5,fell_financial_resolution_not_agreed=7,fell_other=6,in_progress=8,passed=1,rejected_stage_1=2,rejected_stage_3=3,withdrawn=4' THEN
    RAISE EXCEPTION 'Refusing: the list of outcomes is not the one db/118 leaves: %',
      (SELECT string_agg(code || '=' || sort_order, ',' ORDER BY code) FROM ref_outcome);
  END IF;
END $$;

UPDATE ref_outcome SET sort_order = 7 WHERE code = 'in_progress';

COMMIT;
