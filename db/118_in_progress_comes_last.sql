-- db/118_in_progress_comes_last.sql
--
-- "In progress" moves to the end of the list of outcomes. It shared place 7
-- with "Fell: financial resolution not agreed", so nothing decided which came
-- first in a chart or a table, and the published copy's what_the_words_mean
-- gave both an order of 7. It goes last because it is not an ending. Agreed by
-- the owner on 2026-09-17 (DECISIONS.md, the build plan, point 7); every part
-- settled on 2026-09-18 (docs/BLOCK-2-IN-PROGRESS.md).
--
-- Changed: one number. In progress, 7 to 8.
--
-- WHAT DOES NOT CHANGE. Any other cell of the working workbook: no bill, no
-- stage, no provenance line, no note, no staging line, and no other place in
-- any list, including the order of the two "Fell" outcomes. Proved by a
-- fingerprint of all of it before and after.
--
-- Refuses unless the list is exactly as it was written against, so it cannot
-- run twice. Refuses to finish if any outcome still shares a place.
--
-- The undo is db/118_undo.sql, followed by retaking the published copy.

\set ON_ERROR_STOP on
BEGIN;

DO $$
BEGIN
  IF (SELECT string_agg(code || '=' || sort_order, ',' ORDER BY code) FROM ref_outcome)
     IS DISTINCT FROM 'fell_dissolution=5,fell_financial_resolution_not_agreed=7,fell_other=6,in_progress=7,passed=1,rejected_stage_1=2,rejected_stage_3=3,withdrawn=4' THEN
    RAISE EXCEPTION 'Refusing: the list of outcomes is not the one this was written against: %',
      (SELECT string_agg(code || '=' || sort_order, ',' ORDER BY code) FROM ref_outcome);
  END IF;
END $$;

-- Everything else, to compare afterwards.
CREATE TEMP TABLE others_before ON COMMIT DROP AS
SELECT (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY bill_id)) FROM bill t) AS bills,
       (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY stage_event_id)) FROM stage_event t) AS stages,
       (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY field_source_id)) FROM field_source t) AS sources,
       (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY code)) FROM methodology_note t) AS notes,
       (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY session_number)) FROM session t) AS sessions,
       (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY candidate_id)) FROM bill_candidate t) AS staging_bills,
       (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY stage_candidate_id)) FROM stage_candidate t) AS staging_stages,
       (SELECT md5(string_agg(CASE WHEN code = 'in_progress' THEN (to_jsonb(t) - 'sort_order')::text
                                   ELSE to_jsonb(t)::text END, chr(10) ORDER BY code)) FROM ref_outcome t) AS outcomes;

CREATE TEMP TABLE lists_before ON COMMIT DROP AS
SELECT c.relname AS list,
       (xpath('/row/f/text()', query_to_xml(format(
          'SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY to_jsonb(t)::text)) AS f FROM %I t', c.relname),
          false, true, '')))[1]::text AS fingerprint
  FROM pg_class c
 WHERE c.relnamespace = 'public'::regnamespace AND c.relkind = 'r'
   AND c.relname LIKE 'ref\_%' AND c.relname <> 'ref_outcome';

UPDATE ref_outcome SET sort_order = 8 WHERE code = 'in_progress';

-- Checks.
DO $$
BEGIN
  IF (SELECT string_agg(label, ' | ' ORDER BY sort_order) FROM ref_outcome)
     IS DISTINCT FROM 'Passed | Rejected at Stage 1 | Rejected at Stage 3 | Withdrawn | Fell at dissolution | Fell (other) | Fell: financial resolution not agreed | In progress' THEN
    RAISE EXCEPTION 'Check failed: the list does not read in the agreed order.';
  END IF;
  IF (SELECT count(*) - count(DISTINCT sort_order) FROM ref_outcome) <> 0 THEN
    RAISE EXCEPTION 'Check failed: two outcomes still share a place.';
  END IF;
  IF (SELECT row(bills, stages, sources, notes, sessions, staging_bills, staging_stages, outcomes)::text FROM others_before) IS DISTINCT FROM
     (SELECT row((SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY bill_id)) FROM bill t),
                 (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY stage_event_id)) FROM stage_event t),
                 (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY field_source_id)) FROM field_source t),
                 (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY code)) FROM methodology_note t),
                 (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY session_number)) FROM session t),
                 (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY candidate_id)) FROM bill_candidate t),
                 (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY stage_candidate_id)) FROM stage_candidate t),
                 (SELECT md5(string_agg(CASE WHEN code = 'in_progress' THEN (to_jsonb(t) - 'sort_order')::text
                                             ELSE to_jsonb(t)::text END, chr(10) ORDER BY code)) FROM ref_outcome t))::text) THEN
    RAISE EXCEPTION 'Check failed: a cell other than In progress''s place has moved.';
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
  RAISE NOTICE 'In progress is last, at 8; no outcome shares a place; nothing else moved.';
END $$;

COMMIT;
