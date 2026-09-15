-- Feeds tools/make_data_dictionary.py. Emits one pipe-delimited line per table
-- and per column, in the order the columns appear in the table, then one line
-- per methodology note: code, title and the columns it applies to. The note
-- bodies are deliberately not emitted. They live in the database, which is
-- where they are published from, and a copy of them in the repository would be
-- a second version to keep true. The index exists so that a column description
-- saying "see methodology note M5" points at something a reader can name.
WITH fk AS (
    SELECT con.conrelid, unnest(con.conkey) AS attnum,
           cl.relname AS ref_table,
           (SELECT a2.attname FROM pg_attribute a2
             WHERE a2.attrelid = con.confrelid
               AND a2.attnum = con.confkey[1]) AS ref_column
    FROM pg_constraint con
    JOIN pg_class cl ON cl.oid = con.confrelid
    WHERE con.contype = 'f'
)
SELECT line FROM (
    SELECT c.relname AS t, 0 AS ord,
           'T|' || c.relname || '|||||' || coalesce(obj_description(c.oid), '') AS line
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace AND n.nspname = 'public'
    WHERE c.relkind = 'r'
    UNION ALL
    SELECT c.relname, a.attnum,
           'C|' || c.relname || '|' || a.attname || '|'
              || format_type(a.atttypid, a.atttypmod) || '|'
              || CASE WHEN a.attnotnull THEN 'required' ELSE '' END || '|'
              || coalesce((SELECT f.ref_table || '.' || f.ref_column FROM fk f
                            WHERE f.conrelid = c.oid AND f.attnum = a.attnum
                            LIMIT 1), '') || '|'
              || coalesce(col_description(c.oid, a.attnum), '')
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace AND n.nspname = 'public'
    JOIN pg_attribute a ON a.attrelid = c.oid AND a.attnum > 0 AND NOT a.attisdropped
    WHERE c.relkind = 'r'
) s
ORDER BY t, ord;

SELECT 'M|' || code || '|' || title || '|'
       || array_to_string(applies_to, ', ')
FROM methodology_note
ORDER BY sort_order;
