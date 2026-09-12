-- compare_with_copy.sql
--
-- Compares the staging and clean sheets, cell by cell, with a copy taken by
-- tools/take_copy.sql. Changes nothing.
--
--   psql -d legdata -v copy=copy_before_033 -f compare_with_copy.sql
--
-- For each sheet it reports lines found on only one side, columns found on
-- only one side, and every cell that differs, counted by column.
--
-- Stage records and provenance notes are matched by what they are about, not
-- by their own numbers: a stage record by its bill and position, a note about a
-- bill by that bill and the column it is about, a note about a stage record by
-- that record's bill and position and the column it is about, a stage-dates row
-- by its line, position and source.
--
-- Some columns always differ when a session is taken off and put back, and are
-- counted as expected: the numbers of stage records and provenance notes,
-- which are reissued, and the times things were written or stamped. Columns
-- added or removed are listed, and are for the reader to judge against the
-- change. The verdict at the end counts everything else.
--
-- If the copy still has the old stage date columns and the stage-dates sheet
-- exists, it also checks every date in those columns is on the new sheet.

\set ON_ERROR_STOP on

DROP TABLE IF EXISTS pg_temp.compare_result;
CREATE TEMP TABLE compare_result (
    sheet text, line text, column_name text, in_copy text, now_value text, kind text);

CREATE OR REPLACE FUNCTION pg_temp.compare_sheet(p_sheet text, p_old text, p_new text,
                                                  p_also_expected text[] DEFAULT '{}')
RETURNS void LANGUAGE plpgsql AS $f$
BEGIN
  EXECUTE format($q$
    INSERT INTO pg_temp.compare_result (sheet, line, column_name, in_copy, now_value, kind)
    WITH o AS (%1$s), n AS (%2$s),
    pairs AS (
      SELECT coalesce(o.k, n.k) AS k, o.j AS oj, n.j AS nj
        FROM o FULL JOIN n ON n.k = o.k)
    SELECT %3$L, NULL, NULL,
           (SELECT count(*) FROM o)::text, (SELECT count(*) FROM n)::text, 'lines counted'
    UNION ALL
    SELECT %3$L, k, NULL, NULL, NULL,
           CASE WHEN oj IS NULL THEN 'line only now' ELSE 'line only in copy' END
      FROM pairs WHERE oj IS NULL OR nj IS NULL
    UNION ALL
    SELECT DISTINCT %3$L, NULL, key, NULL, NULL, 'column only in copy'
      FROM pairs, jsonb_object_keys(oj) AS key
     WHERE oj IS NOT NULL AND nj IS NOT NULL AND NOT nj ? key
    UNION ALL
    SELECT DISTINCT %3$L, NULL, key, NULL, NULL, 'column only now'
      FROM pairs, jsonb_object_keys(nj) AS key
     WHERE oj IS NOT NULL AND nj IS NOT NULL AND NOT oj ? key
    UNION ALL
    SELECT %3$L, k, key, oj->>key, nj->>key,
           CASE WHEN key IN ('stage_event_id', 'field_source_id', 'created_at', 'updated_at',
                             'promoted_at', 'promoted_stage_event_id')
                  OR key = ANY (%4$L::text[])
                THEN 'cell, expected' ELSE 'cell' END
      FROM pairs, jsonb_object_keys(oj) AS key
     WHERE oj IS NOT NULL AND nj IS NOT NULL AND nj ? key
       AND (oj->key) IS DISTINCT FROM (nj->key)
  $q$, p_old, p_new, p_sheet, p_also_expected);
END $f$;

SELECT pg_temp.compare_sheet('bill_candidate',
  format('SELECT candidate_id::text AS k, to_jsonb(x) AS j FROM %I.bill_candidate x', :'copy'),
  'SELECT candidate_id::text AS k, to_jsonb(x) AS j FROM public.bill_candidate x');

SELECT pg_temp.compare_sheet('bill',
  format('SELECT bill_id::text AS k, to_jsonb(x) AS j FROM %I.bill x', :'copy'),
  'SELECT bill_id::text AS k, to_jsonb(x) AS j FROM public.bill x');

SELECT pg_temp.compare_sheet('stage_event',
  format('SELECT bill_id || ''/'' || stage_order AS k, to_jsonb(x) AS j FROM %I.stage_event x', :'copy'),
  'SELECT bill_id || ''/'' || stage_order AS k, to_jsonb(x) AS j FROM public.stage_event x');

-- A note about a stage record is keyed by that record's bill and position, the
-- same key the stage_event sheet uses, because promotion reissues stage record
-- numbers. Keyed by the number, a note that had not changed at all was reported
-- as one note vanishing and another appearing (found by the closure test,
-- 2026-09-13). `entity_id` is then expected to differ for such a note, and is
-- not a weaker check: what the note is about is already in the key.
SELECT pg_temp.compare_sheet('field_source',
  format($k$SELECT x.entity || '/'
             || CASE WHEN x.entity = 'stage_event' THEN e.bill_id || '/' || e.stage_order
                     ELSE x.entity_id::text END
             || '/' || x.field_name AS k,
             to_jsonb(x) AS j
        FROM %I.field_source x
        LEFT JOIN %I.stage_event e
          ON x.entity = 'stage_event' AND e.stage_event_id = x.entity_id$k$, :'copy', :'copy'),
  $k$SELECT x.entity || '/'
       || CASE WHEN x.entity = 'stage_event' THEN e.bill_id || '/' || e.stage_order
               ELSE x.entity_id::text END
       || '/' || x.field_name AS k,
       to_jsonb(x) AS j
  FROM public.field_source x
  LEFT JOIN public.stage_event e
    ON x.entity = 'stage_event' AND e.stage_event_id = x.entity_id$k$,
  ARRAY['entity_id']);

SELECT to_regclass(format('%I.stage_candidate', :'copy')) IS NOT NULL
   AND to_regclass('public.stage_candidate') IS NOT NULL AS both_have_stage_sheet \gset
\if :both_have_stage_sheet
  SELECT pg_temp.compare_sheet('stage_candidate',
    format('SELECT candidate_id || ''/'' || stage_order || ''/'' || coalesce(source, '''') AS k, to_jsonb(x) AS j FROM %I.stage_candidate x', :'copy'),
    'SELECT candidate_id || ''/'' || stage_order || ''/'' || coalesce(source, '''') AS k, to_jsonb(x) AS j FROM public.stage_candidate x');
\endif

\echo ''
\echo '--- Lines on each side'
SELECT sheet, in_copy AS lines_in_copy, now_value AS lines_now
  FROM compare_result WHERE kind = 'lines counted' ORDER BY sheet;

\echo '--- Lines found on only one side'
SELECT sheet, kind, count(*) AS lines
  FROM compare_result WHERE kind LIKE 'line only%' GROUP BY 1, 2 ORDER BY 1, 2;

\echo '--- Columns found on only one side'
SELECT sheet, kind, column_name
  FROM compare_result WHERE kind LIKE 'column only%' ORDER BY 1, 2, 3;

\echo '--- Cells that differ, by column'
SELECT sheet, column_name, kind, count(*) AS cells
  FROM compare_result WHERE kind LIKE 'cell%' GROUP BY 1, 2, 3 ORDER BY 3 DESC, 1, 2;

SELECT EXISTS (SELECT 1 FROM information_schema.columns
                WHERE table_schema = :'copy' AND table_name = 'bill_candidate'
                  AND column_name = 'end_stage_3_date')
   AND to_regclass('public.stage_candidate') IS NOT NULL AS check_moved_dates \gset
\if :check_moved_dates
  \echo '--- Dates that were in the copy''s two old columns, and whether each is on the stage-dates sheet'
  DROP TABLE IF EXISTS pg_temp.moved;
  CREATE TEMP TABLE moved AS
  WITH old AS (
    SELECT (x->>'candidate_id')::int AS candidate_id, 'end_stage_3_date' AS old_column, 3 AS stage_order,
           (x->>'end_stage_3_date')::date AS d, true AS completed, false AS fell_here,
           x->>'source' AS source, x->>'source_ref' AS source_ref,
           (x->>'observed_at')::date AS observed_at, x->>'review_status' AS review_status
      FROM (SELECT to_jsonb(b) AS x FROM :"copy".bill_candidate b) q
     WHERE x->>'end_stage_3_date' IS NOT NULL
    UNION ALL
    SELECT (x->>'candidate_id')::int, 'end_stage_1_date', 1,
           (x->>'end_stage_1_date')::date, false, true,
           'official_report', substring(x->>'review_note' from 'https?://\S+'),
           (x->>'official_report_read_on')::date, x->>'review_status'
      FROM (SELECT to_jsonb(b) AS x FROM :"copy".bill_candidate b) q
     WHERE x->>'end_stage_1_date' IS NOT NULL
  )
  SELECT o.*, EXISTS (
           SELECT 1 FROM public.stage_candidate t
            WHERE t.candidate_id = o.candidate_id AND t.stage_order = o.stage_order
              AND t.date_completed = o.d AND t.completed = o.completed
              AND t.fell_here = o.fell_here AND t.source = o.source
              AND t.source_ref IS NOT DISTINCT FROM o.source_ref
              AND t.observed_at IS NOT DISTINCT FROM o.observed_at
              AND t.review_status = o.review_status) AS arrived
    FROM old o;
  SELECT m.old_column, c.session_number, count(*) AS dates, count(*) FILTER (WHERE m.arrived) AS arrived_unchanged
    FROM moved m JOIN :"copy".bill_candidate c USING (candidate_id)
   GROUP BY 1, 2 ORDER BY 1, 2;
  INSERT INTO compare_result (sheet, line, column_name, kind)
  SELECT 'stage_candidate', candidate_id::text, old_column, 'moved date missing'
    FROM moved WHERE NOT arrived;
\endif

\echo '--- Unexpected differences, first 40'
SELECT sheet, line, column_name, left(in_copy, 50) AS in_copy, left(now_value, 50) AS now_value, kind
  FROM compare_result
 WHERE kind IN ('line only in copy', 'line only now', 'cell', 'moved date missing')
 ORDER BY 1, 2, 3 LIMIT 40;

\echo '--- Verdict'
SELECT CASE WHEN count(*) = 0 THEN 'No unexpected differences.'
            ELSE count(*) || ' unexpected difference(s), listed above.' END AS verdict
  FROM compare_result
 WHERE kind IN ('line only in copy', 'line only now', 'cell', 'moved date missing');
