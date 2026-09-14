-- closure_check_session_5.sql
--
-- The mechanical half of the closure test for Session 5. Reads only; changes
-- nothing. Run it and compare every line against the expected answers in
-- docs/CLOSURE-TESTS.md. It does not say whether the answers are right -- that
-- is what the expected answers are for, and the session that wrote this script
-- does not get to mark it.
--
-- Written on 2026-09-14 by a session that did none of Session 5's work: it did
-- not read the fact sheet in, did not build the review, did not admit it and
-- did not promote it.
--
-- Unlike Sessions 1 to 4, Session 5 was already on the clean sheet when this was
-- written, because the session that promoted it also marked it closed, which is
-- the thing the procedure exists to stop. So the usual protection -- the test
-- written before the data exists -- is not available here, and its place is
-- taken by a stricter rule on where each expected answer comes from: every one
-- is derived from a fresh extraction of the Session 5 fact sheet, from the
-- owner's dataset read directly, from the migrations db/071 to db/077 and the
-- decisions they record, or from Session 4's closed test. Not one is read out of
-- the database it is testing. Where a figure could only have come from the
-- database, the expected answer says so and is not treated as a prediction.
--
--   cat tools/closure_check_session_5.sql | <connector> 'sudo -u postgres psql -d legdata -X -f -'
--
-- Where an answer is about the whole database rather than Session 5 -- the
-- counts, the sources, the notes -- it is here because Session 5 moves it.
-- Sessions 1 to 4 are not re-argued; see docs/CLOSURE-TESTS.md, the procedure.

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

\echo '--- and every Session 5 cell, in full, with what was read and when'
SELECT f.entity_id, left(b.short_title, 34) AS short_title, f.field_name,
       f.source, left(f.value_seen, 44) AS value_seen, f.observed_at
  FROM field_source f JOIN bill b ON b.bill_id = f.entity_id
 WHERE f.entity = 'bill' AND b.session_number = 5
 ORDER BY f.field_name, f.entity_id;

\echo ''
\echo '=== 6. Reconciliation: Session 5 counts, to be read against its fact sheet''s summary'
SELECT bc.raw_section,
       count(*) FILTER (WHERE b.bill_type IN ('government', 'hybrid')) AS government_or_hybrid,
       count(*) FILTER (WHERE b.bill_type = 'members')   AS members,
       count(*) FILTER (WHERE b.bill_type = 'private')   AS private,
       count(*) FILTER (WHERE b.bill_type = 'committee') AS committee,
       count(*) AS total
  FROM bill b JOIN bill_candidate bc ON bc.promoted_bill_id = b.bill_id
 WHERE b.session_number = 5
 GROUP BY 1 ORDER BY 1;

\echo '--- and the same on bill_type alone, which for Session 5 must be identical'
SELECT b.bill_type, count(*)
  FROM bill b WHERE b.session_number = 5 GROUP BY 1 ORDER BY 1;

\echo ''
\echo '=== 7. Outcomes, and what happened to each Session 5 bill'
SELECT outcome, enactment_status, count(*)
  FROM bill WHERE session_number = 5 GROUP BY 1, 2 ORDER BY 1, 2;

\echo ''
\echo '=== 8. Required cells: any empty where the database demands a value'
SELECT count(*) FILTER (WHERE short_title IS NULL)      AS no_title,
       count(*) FILTER (WHERE bill_type IS NULL)        AS no_type,
       count(*) FILTER (WHERE outcome IS NULL)          AS no_outcome,
       count(*) FILTER (WHERE enactment_status IS NULL) AS no_enactment_status,
       count(*) FILTER (WHERE source IS NULL)           AS no_source,
       count(*) FILTER (WHERE observed_at IS NULL)      AS no_date_read,
       count(*) FILTER (WHERE date_introduced IS NULL)  AS no_introduction_date
  FROM bill WHERE session_number = 5;

\echo '--- and the cells the fact sheet does not fill, which are empty on purpose'
SELECT count(*) FILTER (WHERE sp_bill_id IS NULL)          AS no_sp_bill_number,
       count(*) FILTER (WHERE procedure IS NOT NULL)       AS has_a_procedure,
       count(*) FILTER (WHERE title_as_introduced IS NOT NULL) AS has_a_title_as_introduced
  FROM bill WHERE session_number = 5;

\echo ''
\echo '=== 9. Every Act has its number, its assent, and a year that agrees'
SELECT count(*) AS enacted,
       count(*) FILTER (WHERE asp_number IS NULL)        AS no_asp_number,
       count(*) FILTER (WHERE date_royal_assent IS NULL) AS no_assent_date,
       count(*) FILTER (WHERE asp_number IS NOT NULL AND date_royal_assent IS NOT NULL
                          AND left(asp_number, 4) <> to_char(date_royal_assent, 'YYYY'))
         AS asp_year_disagrees_with_assent
  FROM bill WHERE enactment_status = 'enacted' AND session_number = 5;

\echo '--- and no Act anywhere on the clean sheet has a number without a year'
SELECT count(*) AS acts_whose_number_has_no_year
  FROM bill WHERE asp_number IS NOT NULL AND asp_number !~ '^\d{4} asp \d+$';

\echo '--- nor a title without one: the same fault in the half a reader sees'
SELECT count(*) AS acts_whose_title_has_no_year
  FROM bill WHERE enactment_status = 'enacted' AND short_title !~ '\m\d{4}\M';

\echo '--- and the titles themselves, where any is short'
SELECT bill_id, session_number, short_title, asp_number
  FROM bill
 WHERE enactment_status = 'enacted' AND short_title !~ '\m\d{4}\M'
 ORDER BY bill_id;

\echo ''
\echo '=== 10. Stage records per Session 5 bill, by what happened to it'
SELECT b.outcome, x.n_stages, count(*) AS bills
  FROM bill b
  JOIN LATERAL (SELECT count(*) AS n_stages FROM stage_event e WHERE e.bill_id = b.bill_id) x ON true
 WHERE b.session_number = 5
 GROUP BY 1, 2 ORDER BY 1, 2;

\echo ''
\echo '=== 11. Where every Session 5 stage date came from'
SELECT e.source, count(*) AS stage_records,
       count(*) FILTER (WHERE e.date_completed IS NULL) AS undated,
       count(*) FILTER (WHERE e.did_not_happen)         AS never_happened
  FROM stage_event e JOIN bill b USING (bill_id)
 WHERE b.session_number = 5 GROUP BY 1 ORDER BY 1;

\echo '--- and by the position in the sequence, which is where the derivation is checked'
SELECT e.source, e.stage_order, count(*) AS stage_records
  FROM stage_event e JOIN bill b USING (bill_id)
 WHERE b.session_number = 5 GROUP BY 1, 2 ORDER BY 1, 2;

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

\echo '--- where two rows exist in Session 5, which was carried and which was not'
SELECT t.candidate_id, left(c.short_title, 40) AS short_title, t.stage,
       t.source, t.date_completed,
       t.promoted_stage_event_id IS NOT NULL AS carried
  FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
 WHERE c.session_number = 5
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

\echo '--- the three Session 5 bills rejected at Stage 1, and the day each ended'
SELECT b.bill_id, left(b.short_title, 44) AS short_title, b.stage_1_rejection_route,
       b.date_concluded, e.date_completed AS stage_1_dated, e.source
  FROM bill b LEFT JOIN stage_event e ON e.bill_id = b.bill_id AND e.stage_order = 1
 WHERE b.session_number = 5 AND b.outcome = 'rejected_stage_1'
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

\echo '--- and whether the two notes Session 5 moves say what the data now holds'
SELECT (SELECT body LIKE '%Sessions 1, 2, 3, 4 and 5%' FROM methodology_note WHERE code = 'M7')
         AS m7_says_five_sessions_are_coded,
       (SELECT body LIKE '%Sessions 1, 2, 3 and 4%' FROM methodology_note WHERE code = 'M7')
         AS m7_still_says_four,
       (SELECT body LIKE '%Four bills are affected%' FROM methodology_note WHERE code = 'M5')
         AS m5_counts_the_four_blocked_bills,
       (SELECT body LIKE '%runs ahead of the data%' FROM methodology_note WHERE code = 'M5')
         AS m5_says_it_runs_ahead_of_the_data;

\echo ''
\echo '=== 16. Anything on a Session 5 staging line the checker has not been asked about'
SELECT count(*) FILTER (WHERE review_note IS NOT NULL) AS lines_with_a_review_note,
       count(*) FILTER (WHERE bill_note IS NOT NULL)   AS lines_with_a_note_for_readers,
       count(*) FILTER (WHERE parser_note IS NOT NULL) AS lines_the_reader_remarked_on
  FROM bill_candidate WHERE session_number = 5;

\echo '--- what the reader remarked on, and how often'
SELECT left(parser_note, 76) AS the_reader_said, count(*)
  FROM bill_candidate WHERE session_number = 5 AND parser_note IS NOT NULL
 GROUP BY 1 ORDER BY 2 DESC, 1;

\echo ''
\echo '=== 17. Where the Parliament changed what it called its own bills'
SELECT b.session_number, b.bill_type_stated, count(*) AS government_bills
  FROM bill b WHERE b.bill_type = 'government'
 GROUP BY 1, 2 ORDER BY 1, 2;

\echo ''
\echo '=== 18. Every bill that did not pass says where it ended'
SELECT count(*) AS bills_not_recording_where_they_ended
  FROM v_stage_date_gaps WHERE gap = 'where the bill ended is not recorded';

\echo '--- the stage each Session 5 bill that did not pass ended at, and whether it is dated'
SELECT b.bill_id, left(b.short_title, 45) AS short_title, b.outcome, b.date_concluded,
       e.stage, e.date_completed, e.completed, e.source
  FROM bill b LEFT JOIN stage_event e ON e.bill_id = b.bill_id AND e.fell_here
 WHERE b.session_number = 5 AND b.outcome <> 'passed'
 ORDER BY b.bill_id;

\echo ''
\echo '=== 19. Every stage date held for a Session 5 bill that did not pass'
SELECT b.bill_id, left(b.short_title, 45) AS short_title, e.stage, e.stage_order,
       e.date_completed, e.completed, e.fell_here, e.source
  FROM bill b JOIN stage_event e ON e.bill_id = b.bill_id
 WHERE b.session_number = 5 AND b.outcome <> 'passed'
 ORDER BY b.bill_id, e.stage_order;

\echo ''
\echo '=== 20. The three bills that passed and were stopped before Royal Assent'
SELECT b.bill_id, left(b.short_title, 40) AS short_title, b.bill_type,
       b.outcome, b.enactment_status, b.date_royal_assent, b.asp_number,
       b.date_assent_blocked, length(b.note) AS note_characters
  FROM bill b
 WHERE b.enactment_status = 'blocked'
 ORDER BY b.bill_id;

\echo '--- and what each of those notes keeps, which is the fact and not a wording'
SELECT b.bill_id,
       b.note LIKE 'Not submitted for Royal Assent.%'            AS opens_with_the_fact,
       b.note LIKE '%section 33 of the Scotland Act 1998%'       AS names_the_mechanism,
       b.note LIKE '%Advocate General for Scotland%'             AS names_who_referred_it,
       b.note LIKE '%outwith the Parliament''s legislative competence%' AS says_what_was_ruled,
       b.note LIKE '%6 October 2021%'                            AS gives_the_ruling_date,
       b.note LIKE '%no date for the ruling%'                    AS says_the_fact_sheet_gives_no_date
  FROM bill b WHERE b.enactment_status = 'blocked' ORDER BY b.bill_id;

\echo '--- the stage records and the periods those three bills have'
SELECT b.bill_id, left(b.short_title, 34) AS short_title,
       count(e.stage_event_id) AS stage_records,
       max(e.date_completed) FILTER (WHERE e.stage_order = 3) AS stage_3,
       (SELECT count(*) FROM v_bill_stage_durations d WHERE d.bill_id = b.bill_id) AS periods_counted
  FROM bill b LEFT JOIN stage_event e USING (bill_id)
 WHERE b.enactment_status = 'blocked'
 GROUP BY b.bill_id, b.short_title ORDER BY b.bill_id;

\echo ''
\echo '=== 21. A bill that passed, has no Royal Assent date and does not say why'
SELECT count(*) AS passed_with_no_assent_and_not_blocked
  FROM bill
 WHERE outcome = 'passed' AND date_royal_assent IS NULL
   AND enactment_status <> 'blocked';

\echo '--- and no blocked bill without the words a reader would need'
SELECT count(*) AS blocked_with_nothing_said_to_a_reader
  FROM bill WHERE enactment_status = 'blocked'
   AND coalesce(btrim(note), '') = '';

\echo ''
\echo '=== 22. A Private Bill''s stages are recorded under a Private Bill''s names'
SELECT b.bill_type, e.stage_order, e.stage, count(*) AS stage_records
  FROM bill b JOIN stage_event e USING (bill_id)
 WHERE b.session_number = 5
 GROUP BY 1, 2, 3 ORDER BY 1, 2;

\echo ''
\echo '=== 23. db/077''s guards, derived again from the rules rather than re-run'
\echo '--- no stage date outside its own bill: before introduction, or after the'
\echo '--- day the bill ended, or after the day the session ended where it has not'
SELECT count(*) AS stage_dates_before_introduction
  FROM stage_event e JOIN bill b USING (bill_id)
 WHERE e.date_completed IS NOT NULL AND b.date_introduced IS NOT NULL
   AND e.date_completed < b.date_introduced;

SELECT count(*) AS stage_dates_after_the_bill_or_its_session_ended
  FROM stage_event e
  JOIN bill b USING (bill_id)
  JOIN session s ON s.session_number = b.session_number
 WHERE e.date_completed IS NOT NULL
   AND e.date_completed > coalesce(b.date_royal_assent, b.date_concluded,
                                   s.date_session_end);

\echo '--- no stage dated before the stage before it'
SELECT count(*) AS stages_out_of_order
  FROM stage_event a JOIN stage_event p
    ON p.bill_id = a.bill_id AND p.stage_order = a.stage_order - 1
 WHERE a.date_completed IS NOT NULL AND p.date_completed IS NOT NULL
   AND a.date_completed < p.date_completed;

\echo '--- every Session 5 stage date comes from one of the four sources the review covered'
SELECT count(*) AS session_5_stage_dates_from_another_source
  FROM stage_event e JOIN bill b USING (bill_id)
 WHERE b.session_number = 5
   AND e.source NOT IN ('spice_factsheet_legislation', 'phd', 'official_report', 'bill_page');

\echo '--- and the dateless rows are exactly the bills that ended where they stopped'
SELECT b.bill_id, left(b.short_title, 50) AS short_title, b.outcome, e.stage
  FROM bill b JOIN stage_event e USING (bill_id)
 WHERE b.session_number = 5 AND e.date_completed IS NULL
 ORDER BY b.bill_id;

\echo ''
\echo '=== 24. Every period counted for Session 5, by the stage it is counted to'
SELECT d.previous_stage, d.stage, count(*) AS periods
  FROM v_bill_stage_durations d
 WHERE d.session_number = 5
 GROUP BY 1, 2 ORDER BY 1, 2;

\echo '--- the shortest and the longest road through Session 5, introduction to Stage 3'
SELECT left(b.short_title, 46) AS short_title, b.bill_type,
       b.date_introduced, e.date_completed AS end_of_stage_3,
       e.date_completed - b.date_introduced AS calendar_days
  FROM bill b JOIN stage_event e USING (bill_id)
 WHERE b.session_number = 5 AND e.stage_order = 3 AND e.date_completed IS NOT NULL
 ORDER BY calendar_days
 LIMIT 3;

SELECT left(b.short_title, 46) AS short_title, b.bill_type,
       b.date_introduced, e.date_completed AS end_of_stage_3,
       e.date_completed - b.date_introduced AS calendar_days
  FROM bill b JOIN stage_event e USING (bill_id)
 WHERE b.session_number = 5 AND e.stage_order = 3 AND e.date_completed IS NOT NULL
 ORDER BY calendar_days DESC
 LIMIT 3;
