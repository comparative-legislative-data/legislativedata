-- closure_check_session_4.sql
--
-- The mechanical half of the closure test for Session 4. Reads only; changes
-- nothing. Run it and compare every line against the expected answers in
-- docs/CLOSURE-TESTS.md. It does not say whether the answers are right -- that
-- is what the expected answers are for, and the session that wrote this script
-- does not get to mark it.
--
-- Written on 2026-09-13 by a session that did none of Session 4's work: it did
-- not read the fact sheet in, did not build the review, and did not admit it.
-- Session 4 was deliberately still off the clean sheet when this was written,
-- so every expected answer below is a prediction made from the fact sheet, the
-- owner's dataset and the rules, and not a description of anything.
--
-- Run it when Session 4 is on the clean sheet and its Stage 1 and Stage 2 dates
-- are loaded. Before that the counts are of a session half admitted and the
-- expected answers do not apply.
--
--   cat tools/closure_check_session_4.sql | <connector> 'sudo -u postgres psql -d legdata -X -f -'
--
-- Where an answer is about the whole database rather than Session 4 -- the
-- counts, the sources, the notes -- it is here because Session 4 moves it.
-- Sessions 1, 2 and 3 are not re-argued; see docs/CLOSURE-TESTS.md, the
-- procedure.

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
\echo '=== 2. Every staging line reviewed, admitted, on the clean sheet and compared'
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

\echo '--- and the four Session 4 cells, in full, with what was read and when'
SELECT f.entity_id, left(b.short_title, 38) AS short_title, f.field_name,
       f.source, f.value_seen, f.observed_at
  FROM field_source f JOIN bill b ON b.bill_id = f.entity_id
 WHERE f.entity = 'bill' AND b.session_number = 4
   AND f.field_name IN ('asp_number', 'short_title', 'date_royal_assent', 'date_introduced')
 ORDER BY f.entity_id, f.field_name;

\echo ''
\echo '=== 6. Reconciliation: Session 4 counts, to be read against page 9 of its fact sheet'
SELECT bc.raw_section,
       count(*) FILTER (WHERE b.bill_type IN ('government', 'hybrid')) AS government_or_hybrid,
       count(*) FILTER (WHERE b.bill_type = 'members')   AS members,
       count(*) FILTER (WHERE b.bill_type = 'private')   AS private,
       count(*) FILTER (WHERE b.bill_type = 'committee') AS committee,
       count(*) AS total
  FROM bill b JOIN bill_candidate bc ON bc.promoted_bill_id = b.bill_id
 WHERE b.session_number = 4
 GROUP BY 1 ORDER BY 1;

\echo '--- and the same on bill_type alone, which for Session 4 must be identical'
SELECT b.bill_type, count(*)
  FROM bill b WHERE b.session_number = 4 GROUP BY 1 ORDER BY 1;

\echo ''
\echo '=== 7. Outcomes, and what happened to each Session 4 bill'
SELECT outcome, enactment_status, count(*)
  FROM bill WHERE session_number = 4 GROUP BY 1, 2 ORDER BY 1;

\echo ''
\echo '=== 8. Required cells: any empty where the database demands a value'
SELECT count(*) FILTER (WHERE short_title IS NULL)      AS no_title,
       count(*) FILTER (WHERE bill_type IS NULL)        AS no_type,
       count(*) FILTER (WHERE outcome IS NULL)          AS no_outcome,
       count(*) FILTER (WHERE enactment_status IS NULL) AS no_enactment_status,
       count(*) FILTER (WHERE source IS NULL)           AS no_source,
       count(*) FILTER (WHERE observed_at IS NULL)      AS no_date_read,
       count(*) FILTER (WHERE date_introduced IS NULL)  AS no_introduction_date
  FROM bill WHERE session_number = 4;

\echo '--- and the cells the fact sheet does not fill, which are empty on purpose'
SELECT count(*) FILTER (WHERE sp_bill_id IS NULL)          AS no_sp_bill_number,
       count(*) FILTER (WHERE procedure IS NOT NULL)       AS has_a_procedure,
       count(*) FILTER (WHERE title_as_introduced IS NOT NULL) AS has_a_title_as_introduced
  FROM bill WHERE session_number = 4;

\echo ''
\echo '=== 9. Every Act has its number, its assent, and a year that agrees'
SELECT count(*) AS enacted,
       count(*) FILTER (WHERE asp_number IS NULL)        AS no_asp_number,
       count(*) FILTER (WHERE date_royal_assent IS NULL) AS no_assent_date,
       count(*) FILTER (WHERE asp_number IS NOT NULL AND date_royal_assent IS NOT NULL
                          AND left(asp_number, 4) <> to_char(date_royal_assent, 'YYYY'))
         AS asp_year_disagrees_with_assent
  FROM bill WHERE enactment_status = 'enacted' AND session_number = 4;

\echo '--- and no Act anywhere on the clean sheet has a number without a year'
SELECT count(*) AS acts_whose_number_has_no_year
  FROM bill WHERE asp_number IS NOT NULL AND asp_number !~ '^\d{4} asp \d+$';

\echo ''
\echo '=== 10. Stage records per Session 4 bill, by what happened to it'
SELECT b.outcome, x.n_stages, count(*) AS bills
  FROM bill b
  JOIN LATERAL (SELECT count(*) AS n_stages FROM stage_event e WHERE e.bill_id = b.bill_id) x ON true
 WHERE b.session_number = 4
 GROUP BY 1, 2 ORDER BY 1, 2;

\echo ''
\echo '=== 11. Where every Session 4 stage date came from'
SELECT e.source, count(*) AS stage_records,
       count(*) FILTER (WHERE e.date_completed IS NULL) AS undated,
       count(*) FILTER (WHERE e.did_not_happen)         AS never_happened
  FROM stage_event e JOIN bill b USING (bill_id)
 WHERE b.session_number = 4 GROUP BY 1 ORDER BY 1;

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

\echo '--- where two rows exist in Session 4, which was carried and which was not'
SELECT t.candidate_id, left(c.short_title, 40) AS short_title, t.stage,
       t.source, t.date_completed,
       t.promoted_stage_event_id IS NOT NULL AS carried
  FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
 WHERE c.session_number = 4
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
  FROM bill WHERE stage_1_rejection_route IS NOT NULL GROUP BY 1 ORDER BY 1;

\echo '--- the five Session 4 bills rejected at Stage 1, and the day each ended'
SELECT b.bill_id, left(b.short_title, 44) AS short_title, b.stage_1_rejection_route,
       b.date_concluded, e.date_completed AS stage_1_dated, e.source
  FROM bill b LEFT JOIN stage_event e ON e.bill_id = b.bill_id AND e.stage_order = 1
 WHERE b.session_number = 4 AND b.outcome = 'rejected_stage_1'
 ORDER BY b.date_concluded;

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
\echo '=== 16. Anything on a Session 4 staging line the checker has not been asked about'
SELECT count(*) FILTER (WHERE review_note IS NOT NULL) AS lines_with_a_review_note,
       count(*) FILTER (WHERE bill_note IS NOT NULL)   AS lines_with_a_note_for_readers,
       count(*) FILTER (WHERE parser_note IS NOT NULL) AS lines_the_reader_remarked_on
  FROM bill_candidate WHERE session_number = 4;

\echo '--- what the reader remarked on, and how often'
SELECT left(parser_note, 76) AS the_reader_said, count(*)
  FROM bill_candidate WHERE session_number = 4 AND parser_note IS NOT NULL
 GROUP BY 1 ORDER BY 2 DESC, 1;

\echo ''
\echo '=== 17. Where the Parliament changed what it called its own bills'
SELECT b.session_number, b.bill_type_stated, count(*) AS government_bills
  FROM bill b WHERE b.bill_type = 'government'
 GROUP BY 1, 2 ORDER BY 1, 2;

\echo '--- the five Session 4 bills the fact sheet footnotes, and the day each was introduced'
SELECT b.bill_id, left(b.short_title, 52) AS short_title, b.date_introduced,
       bc.raw_type, b.bill_type_stated
  FROM bill b JOIN bill_candidate bc ON bc.promoted_bill_id = b.bill_id
 WHERE b.session_number = 4 AND bc.raw_type = 'G*'
 ORDER BY b.date_introduced;

\echo ''
\echo '=== 18. Every bill that did not pass says where it ended'
SELECT count(*) AS bills_not_recording_where_they_ended
  FROM v_stage_date_gaps WHERE gap = 'where the bill ended is not recorded';

\echo '--- the stage each Session 4 bill that did not pass ended at, and whether it is dated'
SELECT b.bill_id, left(b.short_title, 45) AS short_title, b.outcome, b.date_concluded,
       e.stage, e.date_completed, e.completed, e.source
  FROM bill b LEFT JOIN stage_event e ON e.bill_id = b.bill_id AND e.fell_here
 WHERE b.session_number = 4 AND b.outcome <> 'passed'
 ORDER BY b.bill_id;

\echo ''
\echo '=== 19. Every stage date held for a Session 4 bill that did not pass'
SELECT b.bill_id, left(b.short_title, 45) AS short_title, e.stage, e.stage_order,
       e.date_completed, e.completed, e.fell_here, e.source
  FROM bill b JOIN stage_event e ON e.bill_id = b.bill_id
 WHERE b.session_number = 4 AND b.outcome <> 'passed'
 ORDER BY b.bill_id, e.stage_order;

\echo ''
\echo '=== 20. The Transplantation Bill''s motion as amended, kept in full'
-- quotes_the_division was replaced on 2026-09-14. It looked for the Official
-- Report's phrase "as amended, agreed to" in a note that says the same thing the
-- other way round, so it tested a wording rather than a fact, and it was the one
-- item of the twenty-seven that failed. The two divisions below are read from
-- the Official Report of 9 February 2016 and were published beside the bill by
-- db/069. See docs/CLOSURE-TESTS.md, item 20.
SELECT b.bill_id, length(b.note) AS characters,
       b.note LIKE '%soft opt-out%'                        AS keeps_the_resolution,
       b.note LIKE '%S4M-15128.1%'                         AS names_the_amendment,
       b.note LIKE '%(For 59, Against 56, Abstentions 0)%' AS gives_the_amendment_division,
       b.note LIKE '%(For 65, Against 48, Abstentions 2)%' AS gives_the_motion_division
  FROM bill b
 WHERE b.session_number = 4 AND b.stage_1_rejection_route = 'member_motion_amended_agreed';

\echo ''
\echo '=== 21. A Private Bill''s stages are recorded under a Private Bill''s names'
SELECT b.bill_type, e.stage_order, e.stage, count(*) AS stage_records
  FROM bill b JOIN stage_event e USING (bill_id)
 WHERE b.session_number = 4
 GROUP BY 1, 2, 3 ORDER BY 1, 2;
