-- closure_check_sessions_1_2.sql
--
-- The mechanical half of the closure test for Sessions 1 and 2. Reads only;
-- changes nothing. Run it and compare every line against the expected answers
-- in docs/CLOSURE-TESTS.md. It does not say whether the answers are right --
-- that is what the expected answers are for, and the session that wrote this
-- script does not get to mark it.
--
--   cat tools/closure_check_sessions_1_2.sql | <connector> 'sudo -u postgres psql -d legdata -X -f -'

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
SELECT review_status, count(*) AS rows,
       count(*) FILTER (WHERE promoted_stage_event_id IS NOT NULL) AS carried
  FROM stage_candidate GROUP BY 1 ORDER BY 1;

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
\echo '=== 6. Reconciliation: our counts, to be read against each factsheet'
SELECT b.session_number, bc.raw_section,
       count(*) FILTER (WHERE b.bill_type IN ('government', 'hybrid')) AS government_or_hybrid,
       count(*) FILTER (WHERE b.bill_type = 'members')   AS members,
       count(*) FILTER (WHERE b.bill_type = 'private')   AS private,
       count(*) FILTER (WHERE b.bill_type = 'committee') AS committee,
       count(*) AS total
  FROM bill b JOIN bill_candidate bc ON bc.promoted_bill_id = b.bill_id
 GROUP BY 1, 2 ORDER BY 1, 2;

\echo ''
\echo '=== 7. Outcomes, and what happened to each bill'
SELECT session_number, outcome, enactment_status, count(*)
  FROM bill GROUP BY 1, 2, 3 ORDER BY 1, 2;

\echo ''
\echo '=== 8. Required cells: any empty where the database demands a value'
SELECT count(*) FILTER (WHERE short_title IS NULL)      AS no_title,
       count(*) FILTER (WHERE bill_type IS NULL)        AS no_type,
       count(*) FILTER (WHERE outcome IS NULL)          AS no_outcome,
       count(*) FILTER (WHERE enactment_status IS NULL) AS no_enactment_status,
       count(*) FILTER (WHERE source IS NULL)           AS no_source,
       count(*) FILTER (WHERE observed_at IS NULL)      AS no_date_read,
       count(*) FILTER (WHERE date_introduced IS NULL)  AS no_introduction_date
  FROM bill;

\echo ''
\echo '=== 9. Every Act has its number, its assent, and a year that agrees'
SELECT count(*) AS enacted,
       count(*) FILTER (WHERE asp_number IS NULL)        AS no_asp_number,
       count(*) FILTER (WHERE date_royal_assent IS NULL) AS no_assent_date,
       count(*) FILTER (WHERE asp_number IS NOT NULL AND date_royal_assent IS NOT NULL
                          AND left(asp_number, 4) <> to_char(date_royal_assent, 'YYYY'))
         AS asp_year_disagrees_with_assent
  FROM bill WHERE enactment_status = 'enacted';

\echo ''
\echo '=== 10. Stage records per bill, by what happened to it'
SELECT b.outcome, x.n_stages, count(*) AS bills
  FROM bill b
  JOIN LATERAL (SELECT count(*) AS n_stages FROM stage_event e WHERE e.bill_id = b.bill_id) x ON true
 GROUP BY 1, 2 ORDER BY 1, 2;

\echo ''
\echo '=== 11. Where every stage date came from'
SELECT source, count(*) AS stage_records,
       count(*) FILTER (WHERE date_completed IS NULL) AS undated,
       count(*) FILTER (WHERE did_not_happen)         AS never_happened
  FROM stage_event GROUP BY 1 ORDER BY 1;

\echo ''
\echo '=== 12. Two accepted rows for the same stage that disagree'
SELECT count(*) AS stages_with_two_rows FROM (
  SELECT candidate_id, stage FROM stage_candidate
   WHERE review_status = 'accepted' GROUP BY 1, 2 HAVING count(*) > 1) x;

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
SELECT code, left(title, 66) AS title, length(body) AS characters
  FROM methodology_note ORDER BY sort_order;

\echo ''
\echo '=== 16. Anything on a staging line the checker has not been asked about'
SELECT count(*) FILTER (WHERE review_note IS NOT NULL) AS lines_with_a_review_note,
       count(*) FILTER (WHERE bill_note IS NOT NULL)   AS lines_with_a_note_for_readers,
       count(*) FILTER (WHERE parser_note IS NOT NULL) AS lines_the_reader_remarked_on
  FROM bill_candidate;
