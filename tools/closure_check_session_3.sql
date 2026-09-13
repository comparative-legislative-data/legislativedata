-- closure_check_session_3.sql
--
-- The mechanical half of the closure test for Session 3. Reads only; changes
-- nothing. Run it and compare every line against the expected answers in
-- docs/CLOSURE-TESTS.md. It does not say whether the answers are right -- that
-- is what the expected answers are for, and the session that wrote this script
-- does not get to mark it.
--
-- Run it when Session 3 is on the clean sheet and its Stage 1 and Stage 2 dates
-- are loaded. Before that the counts are of a session half admitted and the
-- expected answers do not apply.
--
--   cat tools/closure_check_session_3.sql | <connector> 'sudo -u postgres psql -d legdata -X -f -'
--
-- Where an answer is about the whole database rather than Session 3 -- the
-- counts, the sources, the notes -- it is here because Session 3 moves it.
-- Sessions 1 and 2 are not re-argued; see docs/CLOSURE-TESTS.md, the procedure.

\pset pager off

\echo '=== 1. Counts'
SELECT (SELECT count(*) FROM bill)                     AS bills,
       (SELECT count(*) FROM stage_event)              AS stage_records,
       (SELECT count(*) FROM field_source)             AS provenance_notes,
       (SELECT count(*) FROM v_candidate_problems)     AS checker_problems,
       (SELECT count(*) FROM v_stage_date_gaps)        AS gaps,
       (SELECT count(*) FROM bill_candidate)           AS staging_lines,
       (SELECT count(*) FROM stage_candidate)          AS stage_date_rows;

\echo ''
\echo '=== 2. Every staging line reviewed, admitted and on the clean sheet'
SELECT session_number, review_status, count(*) AS lines,
       count(*) FILTER (WHERE promoted_at IS NOT NULL) AS promoted,
       count(*) FILTER (WHERE sources_compared_at IS NOT NULL) AS compared
  FROM bill_candidate GROUP BY 1, 2 ORDER BY 1, 2;

\echo ''
\echo '=== 3. Every stage-date row reviewed, admitted and carried'
SELECT c.session_number, t.review_status, count(*) AS rows,
       count(*) FILTER (WHERE t.promoted_stage_event_id IS NOT NULL) AS carried
  FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
 GROUP BY 1, 2 ORDER BY 1, 2;

\echo ''
\echo '=== 4. A recorded difference with no adjudication'
SELECT count(*) AS unadjudicated_differences
  FROM bill_candidate c
  CROSS JOIN LATERAL regexp_matches(coalesce(c.review_note, ''),
        'Differs: ([a-z0-9_]+) = ', 'g') AS d(m)
 WHERE coalesce(c.review_note, '') NOT LIKE '%Checked: ' || d.m[1] || ' = %';

\echo ''
\echo '=== 5. What has been checked against the source that owns it'
SELECT field_name, source, count(*) AS cells
  FROM field_source GROUP BY 1, 2 ORDER BY 1, 2;

\echo ''
\echo '=== 6. Reconciliation: Session 3 counts, to be read against its factsheet'
SELECT bc.raw_section,
       count(*) FILTER (WHERE b.bill_type IN ('government', 'hybrid')) AS government_or_hybrid,
       count(*) FILTER (WHERE b.bill_type = 'members')   AS members,
       count(*) FILTER (WHERE b.bill_type = 'private')   AS private,
       count(*) FILTER (WHERE b.bill_type = 'committee') AS committee,
       count(*) AS total
  FROM bill b JOIN bill_candidate bc ON bc.promoted_bill_id = b.bill_id
 WHERE b.session_number = 3
 GROUP BY 1 ORDER BY 1;

\echo '--- and the same on bill_type alone, where the Hybrid Bill stands apart'
SELECT b.bill_type, count(*)
  FROM bill b WHERE b.session_number = 3 GROUP BY 1 ORDER BY 1;

\echo ''
\echo '=== 7. Outcomes, and what happened to each Session 3 bill'
SELECT outcome, enactment_status, count(*)
  FROM bill WHERE session_number = 3 GROUP BY 1, 2 ORDER BY 1;

\echo ''
\echo '=== 8. Required cells: any empty where the database demands a value'
SELECT count(*) FILTER (WHERE short_title IS NULL)      AS no_title,
       count(*) FILTER (WHERE bill_type IS NULL)        AS no_type,
       count(*) FILTER (WHERE outcome IS NULL)          AS no_outcome,
       count(*) FILTER (WHERE enactment_status IS NULL) AS no_enactment_status,
       count(*) FILTER (WHERE source IS NULL)           AS no_source,
       count(*) FILTER (WHERE observed_at IS NULL)      AS no_date_read,
       count(*) FILTER (WHERE date_introduced IS NULL)  AS no_introduction_date
  FROM bill WHERE session_number = 3;

\echo ''
\echo '=== 9. Every Act has its number, its assent, and a year that agrees'
SELECT count(*) AS enacted,
       count(*) FILTER (WHERE asp_number IS NULL)        AS no_asp_number,
       count(*) FILTER (WHERE date_royal_assent IS NULL) AS no_assent_date,
       count(*) FILTER (WHERE asp_number IS NOT NULL AND date_royal_assent IS NOT NULL
                          AND left(asp_number, 4) <> to_char(date_royal_assent, 'YYYY'))
         AS asp_year_disagrees_with_assent
  FROM bill WHERE enactment_status = 'enacted' AND session_number = 3;

\echo ''
\echo '=== 10. Stage records per Session 3 bill, by what happened to it'
SELECT b.outcome, x.n_stages, count(*) AS bills
  FROM bill b
  JOIN LATERAL (SELECT count(*) AS n_stages FROM stage_event e WHERE e.bill_id = b.bill_id) x ON true
 WHERE b.session_number = 3
 GROUP BY 1, 2 ORDER BY 1, 2;

\echo ''
\echo '=== 11. Where every Session 3 stage date came from'
SELECT e.source, count(*) AS stage_records,
       count(*) FILTER (WHERE e.date_completed IS NULL) AS undated,
       count(*) FILTER (WHERE e.did_not_happen)         AS never_happened
  FROM stage_event e JOIN bill b USING (bill_id)
 WHERE b.session_number = 3 GROUP BY 1 ORDER BY 1;

\echo '--- and across the whole clean sheet'
SELECT source, count(*) AS stage_records,
       count(*) FILTER (WHERE date_completed IS NULL) AS undated,
       count(*) FILTER (WHERE did_not_happen)         AS never_happened
  FROM stage_event GROUP BY 1 ORDER BY 1;

\echo ''
\echo '=== 12. Two accepted rows for the same stage'
SELECT c.session_number, count(*) AS stages_with_two_rows FROM (
  SELECT candidate_id, stage_order FROM stage_candidate
   WHERE review_status = 'accepted' GROUP BY 1, 2 HAVING count(*) > 1) x
  JOIN bill_candidate c USING (candidate_id)
 GROUP BY 1 ORDER BY 1;

\echo '--- where two rows exist, which was carried and which was not'
SELECT t.candidate_id, left(c.short_title, 40) AS short_title, t.stage,
       t.source, t.date_completed,
       t.promoted_stage_event_id IS NOT NULL AS carried
  FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
 WHERE c.session_number = 3
   AND t.review_status = 'accepted'
   AND EXISTS (SELECT 1 FROM stage_candidate u
                WHERE u.candidate_id = t.candidate_id
                  AND u.stage_order = t.stage_order
                  AND u.review_status = 'accepted'
                  AND u.stage_candidate_id <> t.stage_candidate_id)
 ORDER BY 1, t.stage_order, t.source;

\echo ''
\echo '=== 13. How each Stage 1 rejection came about'
SELECT stage_1_rejection_route, count(*) AS bills,
       count(*) FILTER (WHERE note IS NOT NULL) AS with_a_note_for_readers
  FROM bill WHERE outcome = 'rejected_stage_1' GROUP BY 1 ORDER BY 1;

\echo ''
\echo '=== 14. Every source in use is on the list and says what it means'
SELECT s.code, s.definition IS NOT NULL AND btrim(s.definition) <> '' AS has_a_definition,
       (SELECT count(*) FROM stage_event e WHERE e.source = s.code)  AS stage_records,
       (SELECT count(*) FROM bill b WHERE b.source = s.code)         AS bill_rows,
       (SELECT count(*) FROM field_source f WHERE f.source = s.code) AS cells
  FROM ref_source s ORDER BY s.sort_order;

\echo ''
\echo '=== 15. The notes a reader is given'
SELECT code, left(title, 66) AS title, length(body) AS characters,
       body ILIKE '%financial resolution%' AS mentions_a_financial_resolution
  FROM methodology_note ORDER BY sort_order;

\echo ''
\echo '=== 16. Anything on a Session 3 staging line the checker has not been asked about'
SELECT count(*) FILTER (WHERE review_note IS NOT NULL) AS lines_with_a_review_note,
       count(*) FILTER (WHERE bill_note IS NOT NULL)   AS lines_with_a_note_for_readers,
       count(*) FILTER (WHERE parser_note IS NOT NULL) AS lines_the_reader_remarked_on
  FROM bill_candidate WHERE session_number = 3;

\echo ''
\echo '=== 17. The bill that did not end at a stage'
SELECT b.bill_id, left(b.short_title, 30) AS short_title, b.outcome, b.date_concluded,
       (SELECT count(*) FROM stage_event e WHERE e.bill_id = b.bill_id) AS stage_records,
       (SELECT count(*) FROM stage_event e WHERE e.bill_id = b.bill_id AND e.completed) AS completed_stages,
       (SELECT count(*) FROM stage_event e WHERE e.bill_id = b.bill_id AND e.fell_here) AS stages_it_fell_at
  FROM bill b WHERE b.outcome = 'fell_financial_resolution_not_agreed'
 ORDER BY 1;

\echo ''
\echo '=== 18. Every bill that did not pass says where it ended'
SELECT count(*) AS bills_not_recording_where_they_ended
  FROM v_stage_date_gaps WHERE gap = 'where the bill ended is not recorded';

\echo '--- the stage each Session 3 bill that did not pass ended at, and whether it is dated'
SELECT b.bill_id, left(b.short_title, 45) AS short_title, b.outcome,
       e.stage, e.date_completed, e.completed, e.source
  FROM bill b LEFT JOIN stage_event e ON e.bill_id = b.bill_id AND e.fell_here
 WHERE b.session_number = 3 AND b.outcome <> 'passed'
 ORDER BY b.bill_id;

\echo ''
\echo '=== 19. The four Stage 1 dates the dataset gives for a bill that did not pass'
SELECT b.bill_id, left(b.short_title, 45) AS short_title, e.stage,
       e.date_completed, e.source
  FROM bill b JOIN stage_event e ON e.bill_id = b.bill_id AND e.stage_order = 1
 WHERE b.session_number = 3 AND b.outcome <> 'passed' AND e.date_completed IS NOT NULL
 ORDER BY b.bill_id;
