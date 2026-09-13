-- check_stage_entry.sql
--
-- After the owner has typed stage dates into Postico: lists every stage-dates
-- row still waiting for review, beside its bill's own dates, with when it
-- reached the server and anything the error checker finds wrong. Changes
-- nothing.
--
--   psql -d legdata -f check_stage_entry.sql
--
-- Rows waiting for review are those marked new or held, whatever their source,
-- so a row whose source was mistyped is listed too. See
-- docs/PROMOTION-RUNBOOK.md, "Typing stage dates into Postico".

\set ON_ERROR_STOP on
\pset footer off

\echo ''
\echo '--- Rows waiting for review, by session, source and stage'
SELECT c.session_number, t.source, t.stage, t.completed, t.fell_here, count(*) AS rows
  FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
 WHERE t.review_status IN ('new', 'held')
 GROUP BY 1, 2, 3, 4, 5 ORDER BY 1, 2, 3;

\echo '--- Each row, beside its bill (introduced, and passed or concluded), and when it reached the server'
SELECT t.stage_candidate_id AS row, t.candidate_id AS line, left(t.short_title, 40) AS title,
       c.bill_type, c.date_introduced AS introduced,
       coalesce((SELECT s.date_completed FROM stage_candidate s
                  WHERE s.candidate_id = t.candidate_id AND s.stage_order = 3
                    AND s.review_status = 'accepted' LIMIT 1),
                c.date_concluded) AS passed_or_concluded,
       t.stage, t.stage_order AS pos, t.date_completed, t.completed, t.fell_here,
       t.source, t.source_ref, t.observed_at, t.detail_note, t.review_status,
       to_char(t.created_at AT TIME ZONE 'Europe/London', 'DD Mon HH24:MI') AS saved
  FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
 WHERE t.review_status IN ('new', 'held')
 ORDER BY t.candidate_id, t.stage_order;

\echo '--- What the error checker finds, anywhere (empty is the target)'
SELECT p.stage_candidate_id AS row, p.candidate_id AS line, left(p.short_title, 40) AS title, p.problem
  FROM v_candidate_problems p
 ORDER BY p.candidate_id, p.stage_candidate_id, p.problem;

\echo '--- Dates still to find'
SELECT session_number, gap, count(*) AS gaps
  FROM v_stage_date_gaps GROUP BY 1, 2 ORDER BY 1, 2;
