-- take_copy.sql
--
-- Takes a copy of the staging and clean sheets inside the database before a
-- change, so tools/compare_with_copy.sql can check the change cell by cell
-- afterwards. Changes no data.
--
--   psql -d legdata -v copy=copy_before_033 -f take_copy.sql
--
-- The copy goes in a schema of its own, which Postico's user cannot open and
-- the data dictionary does not read. Refused if the name is already in use, so
-- a copy is never overwritten. Drop it once the change it guards is confirmed:
--
--   DROP SCHEMA copy_before_033 CASCADE;

\set ON_ERROR_STOP on

BEGIN;

CREATE SCHEMA :"copy";

COMMENT ON SCHEMA :"copy" IS
 'A copy of the staging and clean sheets, taken by tools/take_copy.sql before a change, for tools/compare_with_copy.sql. Not part of the database: drop it once the change is confirmed.';

CREATE TABLE :"copy".bill_candidate AS SELECT * FROM public.bill_candidate;
CREATE TABLE :"copy".bill           AS SELECT * FROM public.bill;
CREATE TABLE :"copy".stage_event    AS SELECT * FROM public.stage_event;
CREATE TABLE :"copy".field_source   AS SELECT * FROM public.field_source;

SELECT to_regclass('public.stage_candidate') IS NOT NULL AS has_stage_sheet \gset
\if :has_stage_sheet
  CREATE TABLE :"copy".stage_candidate AS SELECT * FROM public.stage_candidate;
\endif

\echo ''
\echo '--- What the copy holds'
SELECT session_number, count(*) AS staging_lines
  FROM :"copy".bill_candidate GROUP BY 1 ORDER BY 1;
SELECT (SELECT count(*) FROM :"copy".bill)         AS bills,
       (SELECT count(*) FROM :"copy".stage_event)  AS stage_records,
       (SELECT count(*) FROM :"copy".field_source) AS provenance_notes;

COMMIT;
