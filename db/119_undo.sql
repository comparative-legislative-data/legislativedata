-- db/119_undo.sql: takes db/119 off again
--
-- Removes whose terms each kind of source comes under, and the four sets of
-- terms. Then retake the published copy with the build script as it was
-- before db/119, so the copy loses its terms file. Refuses unless db/119 is
-- what it finds.

\set ON_ERROR_STOP on
BEGIN;

DO $$
BEGIN
  IF to_regclass('public.source_terms') IS NULL THEN
    RAISE EXCEPTION 'Refusing: there is no source_terms; db/119 is not on.';
  END IF;
  IF (SELECT string_agg(code, ',' ORDER BY code) FROM source_terms)
     IS DISTINCT FROM 'legislation_gov_uk,our_own_work,scottish_parliament,supreme_court' THEN
    RAISE EXCEPTION 'Refusing: source_terms is not the one db/119 leaves.';
  END IF;
END $$;

ALTER TABLE ref_source DROP COLUMN terms;
DROP TABLE source_terms;

COMMIT;
