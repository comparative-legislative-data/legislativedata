-- db/117_factsheet_is_one_word.sql
--
-- "Factsheet" is one word, everywhere a reader sees it. db/114 to db/116 wrote
-- "fact sheet" in the notes and definitions while the source list's labels
-- kept "SPICe legislation factsheet", so the published copy showed both, on
-- the Legal Continuity Bill's own line. The owner chose the one word on
-- 2026-09-18 (DECISIONS.md, "Factsheet is one word").
--
-- Changed: "fact sheet" to "factsheet" and "fact sheets" to "factsheets", in
--   * the methodology notes' titles (2) and texts (9);
--   * bill notes (1: the Gender Recognition Reform Bill's), and the bill notes
--     on the staging sheet (2), which are what promotion copies a bill's note
--     from and checks it against: a published note's own source;
--   * provenance notes (101);
--   * the definitions of allowed values (5);
--   * the descriptions stored on the working tables and columns, so the data
--     dictionary uses one spelling throughout.
-- None of these sits inside words quoted from someone else; checked by hand
-- on 2026-09-18.
--
-- Not changed, on purpose: the review and reader notes on the two staging
-- sheets, which are working records, never published, and already mix the
-- two spellings. Where
-- promotion carries a staging note's words into a provenance note, it now
-- changes the spelling as it does so (tools/promote_session.sql, same commit).
--
-- WHAT DOES NOT CHANGE. Any other cell. A line's updated_at moves with its
-- note, as it always does.

\set ON_ERROR_STOP on
BEGIN;

CREATE TEMP TABLE spelled_before ON COMMIT DROP AS
SELECT (SELECT count(*) FROM methodology_note WHERE title ~ 'fact sheet') AS note_titles,
       (SELECT count(*) FROM methodology_note WHERE body ~ 'fact sheet') AS note_bodies,
       (SELECT count(*) FROM bill WHERE note ~ 'fact sheet')
     + (SELECT count(*) FROM bill_candidate WHERE bill_note ~ 'fact sheet') AS bill_notes,
       (SELECT count(*) FROM field_source WHERE note ~ 'fact sheet') AS provenance_notes,
       (SELECT count(*) FROM ref_source WHERE definition ~ 'fact sheet')
     + (SELECT count(*) FROM ref_assent_block_outcome WHERE definition ~ 'fact sheet')
     + (SELECT count(*) FROM ref_assent_block_route WHERE definition ~ 'fact sheet') AS definitions;

DO $$
BEGIN
  IF (SELECT row(note_titles, note_bodies, bill_notes, provenance_notes, definitions)::text FROM spelled_before)
     <> '(2,9,3,101,5)' THEN
    RAISE EXCEPTION 'Refusing: the cells with "fact sheet" are not the ones this was written against: %',
      (SELECT row(note_titles, note_bodies, bill_notes, provenance_notes, definitions)::text FROM spelled_before);
  END IF;
  IF EXISTS (SELECT 1 FROM methodology_note WHERE title || body ~ 'Fact [Ss]heet|fact Sheet')
     OR EXISTS (SELECT 1 FROM field_source WHERE note ~ 'Fact [Ss]heet|fact Sheet') THEN
    RAISE EXCEPTION 'Refusing: a capitalised spelling this does not handle.';
  END IF;
END $$;

-- Every other cell, to compare afterwards.
CREATE TEMP TABLE others_before ON COMMIT DROP AS
SELECT (SELECT md5(string_agg((to_jsonb(t) - 'note' - 'updated_at')::text, chr(10) ORDER BY bill_id)) FROM bill t) AS bills,
       (SELECT md5(string_agg((to_jsonb(t) - 'note')::text, chr(10) ORDER BY field_source_id)) FROM field_source t) AS sources,
       (SELECT md5(string_agg((to_jsonb(t) - 'title' - 'body' - 'updated_at')::text, chr(10) ORDER BY code)) FROM methodology_note t) AS notes,
       (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY stage_event_id)) FROM stage_event t) AS stages,
       (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY session_number)) FROM session t) AS sessions,
       (SELECT md5(string_agg((to_jsonb(t) - 'bill_note' - 'updated_at')::text, chr(10) ORDER BY candidate_id)) FROM bill_candidate t) AS staging_bills,
       (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY stage_candidate_id)) FROM stage_candidate t) AS staging_stages;

UPDATE methodology_note SET title = regexp_replace(title, 'fact sheet', 'factsheet', 'g') WHERE title ~ 'fact sheet';
UPDATE methodology_note SET body = regexp_replace(body, 'fact sheet', 'factsheet', 'g') WHERE body ~ 'fact sheet';
UPDATE bill SET note = regexp_replace(note, 'fact sheet', 'factsheet', 'g') WHERE note ~ 'fact sheet';
UPDATE bill_candidate SET bill_note = regexp_replace(bill_note, 'fact sheet', 'factsheet', 'g') WHERE bill_note ~ 'fact sheet';
UPDATE field_source SET note = regexp_replace(note, 'fact sheet', 'factsheet', 'g') WHERE note ~ 'fact sheet';
UPDATE ref_source SET definition = regexp_replace(definition, 'fact sheet', 'factsheet', 'g') WHERE definition ~ 'fact sheet';
UPDATE ref_assent_block_outcome SET definition = regexp_replace(definition, 'fact sheet', 'factsheet', 'g') WHERE definition ~ 'fact sheet';
UPDATE ref_assent_block_route SET definition = regexp_replace(definition, 'fact sheet', 'factsheet', 'g') WHERE definition ~ 'fact sheet';

-- The descriptions on the working tables, views and columns.
DO $$
DECLARE r record; n integer := 0;
BEGIN
  FOR r IN SELECT c.oid, c.relname, c.relkind, obj_description(c.oid, 'pg_class') AS d
             FROM pg_class c JOIN pg_namespace s ON s.oid = c.relnamespace AND s.nspname = 'public'
            WHERE obj_description(c.oid, 'pg_class') ~ 'fact sheet' LOOP
    EXECUTE format('COMMENT ON %s public.%I IS %L',
                   CASE r.relkind WHEN 'v' THEN 'VIEW' ELSE 'TABLE' END,
                   r.relname, regexp_replace(r.d, 'fact sheet', 'factsheet', 'g'));
    n := n + 1;
  END LOOP;
  FOR r IN SELECT c.relname, a.attname, col_description(c.oid, a.attnum) AS d
             FROM pg_class c JOIN pg_namespace s ON s.oid = c.relnamespace AND s.nspname = 'public'
             JOIN pg_attribute a ON a.attrelid = c.oid AND a.attnum > 0 AND NOT a.attisdropped
            WHERE col_description(c.oid, a.attnum) ~ 'fact sheet' LOOP
    EXECUTE format('COMMENT ON COLUMN public.%I.%I IS %L',
                   r.relname, r.attname, regexp_replace(r.d, 'fact sheet', 'factsheet', 'g'));
    n := n + 1;
  END LOOP;
  RAISE NOTICE '% descriptions changed.', n;
END $$;

-- Checks.
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM methodology_note WHERE title || body ~* 'fact sheet')
     OR EXISTS (SELECT 1 FROM bill WHERE note ~* 'fact sheet')
     OR EXISTS (SELECT 1 FROM bill_candidate WHERE bill_note ~* 'fact sheet')
     OR EXISTS (SELECT 1 FROM field_source WHERE note ~* 'fact sheet')
     OR EXISTS (SELECT 1 FROM ref_source WHERE definition ~* 'fact sheet')
     OR EXISTS (SELECT 1 FROM ref_assent_block_outcome WHERE definition ~* 'fact sheet')
     OR EXISTS (SELECT 1 FROM ref_assent_block_route WHERE definition ~* 'fact sheet') THEN
    RAISE EXCEPTION 'Check failed: "fact sheet" is still in a cell a reader sees.';
  END IF;
  IF EXISTS (SELECT 1 FROM pg_class c JOIN pg_namespace s ON s.oid = c.relnamespace AND s.nspname = 'public'
              LEFT JOIN pg_attribute a ON a.attrelid = c.oid AND a.attnum > 0
              WHERE obj_description(c.oid, 'pg_class') ~* 'fact sheet'
                 OR col_description(c.oid, a.attnum) ~* 'fact sheet') THEN
    RAISE EXCEPTION 'Check failed: "fact sheet" is still in a description.';
  END IF;
  IF (SELECT row(bills, sources, notes, stages, sessions, staging_bills, staging_stages)::text FROM others_before) IS DISTINCT FROM
     (SELECT row((SELECT md5(string_agg((to_jsonb(t) - 'note' - 'updated_at')::text, chr(10) ORDER BY bill_id)) FROM bill t),
                 (SELECT md5(string_agg((to_jsonb(t) - 'note')::text, chr(10) ORDER BY field_source_id)) FROM field_source t),
                 (SELECT md5(string_agg((to_jsonb(t) - 'title' - 'body' - 'updated_at')::text, chr(10) ORDER BY code)) FROM methodology_note t),
                 (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY stage_event_id)) FROM stage_event t),
                 (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY session_number)) FROM session t),
                 (SELECT md5(string_agg((to_jsonb(t) - 'bill_note' - 'updated_at')::text, chr(10) ORDER BY candidate_id)) FROM bill_candidate t),
                 (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY stage_candidate_id)) FROM stage_candidate t))::text) THEN
    RAISE EXCEPTION 'Check failed: a cell other than the ones this changes has moved.';
  END IF;
  IF (SELECT count(*) FROM bill) <> 470 OR (SELECT count(*) FROM stage_event) <> 1291
     OR (SELECT count(*) FROM field_source) <> 192 OR (SELECT count(*) FROM methodology_note) <> 14 THEN
    RAISE EXCEPTION 'Check failed: the counts moved.';
  END IF;
  RAISE NOTICE 'Factsheet is one word in every cell and description a reader or the dictionary shows; nothing else moved.';
END $$;

COMMIT;
