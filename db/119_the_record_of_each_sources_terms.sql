-- db/119_the_record_of_each_sources_terms.sql
--
-- The record of each source's terms: strand 1, item 3 of docs/PHASE-2.md.
-- Settled 17 September that no source's data is published until its licence,
-- credit line, restrictions and a link are written down, and that the
-- statements follow each value's recorded source. Every part laid out in
-- docs/STRAND-1-SOURCE-TERMS.md and agreed by the owner on 2026-09-18,
-- "Manual" coming under the Scottish Parliament's terms.
--
-- What it adds:
--   1. source_terms, four lines: the Scottish Parliament, legislation.gov.uk,
--      the Supreme Court, and our own work.
--   2. ref_source.terms: whose terms each kind of source comes under. Required.
--   3. The published copy's connector may read source_terms.
--
-- WHAT DOES NOT CHANGE. No bill, stage, provenance line, note, staging line or
-- session, and no cell of any list but the new column. Proved by a fingerprint
-- of all of it before and after.
--
-- Refuses if source_terms already exists, so it cannot run twice. The undo is
-- db/119_undo.sql, followed by retaking the published copy.

\set ON_ERROR_STOP on
BEGIN;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_class WHERE relname = 'source_terms' AND relnamespace = 'public'::regnamespace) THEN
    RAISE EXCEPTION 'Refusing: source_terms already exists.';
  END IF;
  IF (SELECT string_agg(code, ',' ORDER BY code) FROM ref_source)
     IS DISTINCT FROM 'api,bill_document,bill_page,legislation_gov_uk,manual,official_report,phd,spice_factsheet_dates,spice_factsheet_legislation,supreme_court' THEN
    RAISE EXCEPTION 'Refusing: the kinds of source are not the ten this was written against.';
  END IF;
END $$;

CREATE TEMP TABLE before ON COMMIT DROP AS
SELECT (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY bill_id)) FROM bill t) AS bills,
       (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY stage_event_id)) FROM stage_event t) AS stages,
       (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY field_source_id)) FROM field_source t) AS sources,
       (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY code)) FROM methodology_note t) AS notes,
       (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY session_number)) FROM session t) AS sessions,
       (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY candidate_id)) FROM bill_candidate t) AS staging_bills,
       (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY stage_candidate_id)) FROM stage_candidate t) AS staging_stages,
       (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY code)) FROM ref_source t) AS kinds_of_source;

CREATE TEMP TABLE lists_before ON COMMIT DROP AS
SELECT c.relname AS list,
       (xpath('/row/f/text()', query_to_xml(format(
          'SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY to_jsonb(t)::text)) AS f FROM %I t', c.relname),
          false, true, '')))[1]::text AS fingerprint
  FROM pg_class c
 WHERE c.relnamespace = 'public'::regnamespace AND c.relkind = 'r'
   AND c.relname LIKE 'ref\_%' AND c.relname <> 'ref_source';

-- ---------------------------------------------------------------------------
-- 1. The four sets of terms
-- ---------------------------------------------------------------------------

CREATE TABLE source_terms (
    code             text PRIMARY KEY,
    terms_for        text NOT NULL,
    covers_note      text,
    licence          text NOT NULL,
    licence_link     text NOT NULL,
    credit_line      text NOT NULL,
    restrictions     text NOT NULL,
    terms_page       text,
    date_terms_read  date,
    sort_order       integer NOT NULL
);
ALTER TABLE source_terms OWNER TO legdata;

INSERT INTO source_terms VALUES
 ('scottish_parliament', 'Scottish Parliament', NULL,
  'Scottish Parliament Copyright Licence',
  'https://www.parliament.scot/about/copyright',
  'Contains information licensed under the Scottish Parliament Copyright Licence',
  'This licence does not grant you any right to use the information in a way that suggests any official status or that the SPCB endorses you or your use of the information. This licence does not allow you to use published material provided in any format in connection with party political purposes or in connection with advertising endorsement.',
  'https://www.parliament.scot/about/copyright', '2026-09-18', 1),
 ('legislation_gov_uk', 'legislation.gov.uk', NULL,
  'Open Government Licence v3.0',
  'https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/',
  'Contains public sector information licensed under the Open Government Licence v3.0.',
  'This licence does not grant you any right to use the Information in a way that suggests any official status or that the Information Provider and/or Licensor endorse you or your use of the Information.',
  'https://www.legislation.gov.uk/help', '2026-09-18', 2),
 ('supreme_court', 'Supreme Court', NULL,
  'Open Government Licence v3.0',
  'https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/',
  'Contains public sector information licensed under the Open Government Licence v3.0.',
  'This licence does not grant you any right to use the Information in a way that suggests any official status or that the Information Provider and/or Licensor endorse you or your use of the Information. You may use and re-use Crown copyright material from this website, other than the Royal Arms and departmental logos, under the terms of the Open Government Licence, provided it is reproduced accurately and not in a misleading context.',
  'https://www.supremecourt.uk/about/terms-and-conditions', '2026-09-18', 3),
 ('our_own_work', 'legislativedata.org',
  'Everything without a source named in the other lines: our coding, our bill numbers, the notes, and the worked-out figures.',
  'Creative Commons Attribution 4.0 International (CC BY 4.0)',
  'https://creativecommons.org/licenses/by/4.0/',
  'Contains data from legislativedata.org, licensed under CC BY 4.0. Stage 1 and Stage 2 dates compiled for Steven MacGregor, ''Does government dominate the legislative process?'' (PhD thesis, University of Stirling, 2021).',
  'None.',
  NULL, NULL, 4);

COMMENT ON TABLE source_terms IS
 'The terms each source''s data is published under, one line per set of terms: the Scottish Parliament, legislation.gov.uk, the Supreme Court, and our own work. Each kind of source in ref_source names the line it comes under. No source''s data is published until its line is here (DECISIONS.md, 2026-09-17), and the published copy refuses to build if a source it uses has none. See docs/STRAND-1-SOURCE-TERMS.md.';
COMMENT ON COLUMN source_terms.code IS
 'The short word ref_source.terms stores to point at this line.';
COMMENT ON COLUMN source_terms.terms_for IS
 'Whose terms these are, as a reader sees it.';
COMMENT ON COLUMN source_terms.covers_note IS
 'For terms no kind of source comes under, what they cover, in words. Filled only for our own work, which covers everything without a named source. Empty for the others, whose cover is the kinds of source that point at them.';
COMMENT ON COLUMN source_terms.licence IS
 'The licence the data is under, by its own name.';
COMMENT ON COLUMN source_terms.licence_link IS
 'Where the licence is published.';
COMMENT ON COLUMN source_terms.credit_line IS
 'The words to use when crediting this source. For an outside source, its own words, copied; for our own work, the wording the owner agreed on 2026-09-18.';
COMMENT ON COLUMN source_terms.restrictions IS
 'What the source does not allow, in its own words, copied and not interpreted. For the Scottish Parliament, the broader of its two bans, as settled on 2026-09-17.';
COMMENT ON COLUMN source_terms.terms_page IS
 'The page where the source publishes its terms. Empty for our own work.';
COMMENT ON COLUMN source_terms.date_terms_read IS
 'The day we read those terms. Empty for our own work.';
COMMENT ON COLUMN source_terms.sort_order IS
 'The order to list the lines in. A display choice.';

-- ---------------------------------------------------------------------------
-- 2. Whose terms each kind of source comes under
-- ---------------------------------------------------------------------------

ALTER TABLE ref_source ADD COLUMN terms text REFERENCES source_terms (code);
UPDATE ref_source SET terms = CASE code
    WHEN 'legislation_gov_uk' THEN 'legislation_gov_uk'
    WHEN 'supreme_court' THEN 'supreme_court'
    ELSE 'scottish_parliament' END;
ALTER TABLE ref_source ALTER COLUMN terms SET NOT NULL;

COMMENT ON COLUMN ref_source.terms IS
 'Whose terms this kind of source comes under, pointing at source_terms. Never empty. The PhD dataset is under the Scottish Parliament''s, its values being Parliament facts (DECISIONS.md, 2026-09-17), and so is Manual, whose facts restate or correct what the Parliament published (the owner, 2026-09-18).';

-- ---------------------------------------------------------------------------
-- 3. The published copy may read it
-- ---------------------------------------------------------------------------

GRANT SELECT ON source_terms TO copy_reader;

-- ---------------------------------------------------------------------------
-- Checks
-- ---------------------------------------------------------------------------

DO $$
BEGIN
  IF (SELECT string_agg(code || '=' || terms, ',' ORDER BY code) FROM ref_source) IS DISTINCT FROM
     'api=scottish_parliament,bill_document=scottish_parliament,bill_page=scottish_parliament,legislation_gov_uk=legislation_gov_uk,manual=scottish_parliament,official_report=scottish_parliament,phd=scottish_parliament,spice_factsheet_dates=scottish_parliament,spice_factsheet_legislation=scottish_parliament,supreme_court=supreme_court' THEN
    RAISE EXCEPTION 'Check failed: the kinds of source are not under the agreed terms.';
  END IF;
  IF (SELECT row(bills, stages, sources, notes, sessions, staging_bills, staging_stages, kinds_of_source)::text FROM before) IS DISTINCT FROM
     (SELECT row((SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY bill_id)) FROM bill t),
                 (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY stage_event_id)) FROM stage_event t),
                 (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY field_source_id)) FROM field_source t),
                 (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY code)) FROM methodology_note t),
                 (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY session_number)) FROM session t),
                 (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY candidate_id)) FROM bill_candidate t),
                 (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY stage_candidate_id)) FROM stage_candidate t),
                 (SELECT md5(string_agg((to_jsonb(t) - 'terms')::text, chr(10) ORDER BY code)) FROM ref_source t))::text) THEN
    RAISE EXCEPTION 'Check failed: a cell other than the new column has moved.';
  END IF;
  IF EXISTS (SELECT 1 FROM lists_before b
              WHERE b.fingerprint IS DISTINCT FROM (xpath('/row/f/text()', query_to_xml(format(
                      'SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY to_jsonb(t)::text)) AS f FROM %I t', b.list),
                      false, true, '')))[1]::text) THEN
    RAISE EXCEPTION 'Check failed: another list of allowed values has moved.';
  END IF;
  IF (SELECT count(*) FROM lists_before) <> 11 THEN
    RAISE EXCEPTION 'Check failed: expected 11 other lists, found %.', (SELECT count(*) FROM lists_before);
  END IF;
  IF (SELECT count(*) FROM v_candidate_problems) <> 0 OR (SELECT count(*) FROM v_stage_date_gaps) <> 0 THEN
    RAISE EXCEPTION 'Check failed: the error checker or the gaps list is not empty.';
  END IF;
  IF NOT has_table_privilege('copy_reader', 'source_terms', 'SELECT')
     OR NOT has_table_privilege('legdata', 'source_terms', 'SELECT') THEN
    RAISE EXCEPTION 'Check failed: the copy''s connector or Postico cannot read source_terms.';
  END IF;
  RAISE NOTICE 'Four sets of terms; every kind of source under one; nothing else moved.';
END $$;

COMMIT;
