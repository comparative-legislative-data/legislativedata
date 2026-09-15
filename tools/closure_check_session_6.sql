-- closure_check_session_6.sql
--
-- The mechanical half of the closure test for Session 6. Reads only; changes
-- nothing. Run it and compare every line against the expected answers in
-- docs/CLOSURE-TESTS.md, "Session 6". It does not say whether the answers are
-- right -- that is what the expected answers are for, and the session that
-- wrote this script does not get to mark it.
--
-- Written on 2026-09-15 by the session that admitted Session 6, promoted it,
-- built db/098 to db/100 and changed tools/promote_session.sql. So the usual
-- protection -- the test written by someone who did none of the work -- is not
-- available, and its place is taken by a stricter rule on where each expected
-- answer comes from: the fact sheet's own counted summary as read entry by
-- entry on 2026-09-14, the owner's dataset, methodology note M6's arithmetic,
-- the migrations and the decisions they record, or Session 5's closed test.
-- Where a figure could only have come from the database, the expected answer
-- says so and is not treated as a prediction.
--
--   cat tools/closure_check_session_6.sql | <connector> 'sudo -u postgres psql -d legdata -X -f -'
--
-- Sessions 1 to 5 are not re-argued; see docs/CLOSURE-TESTS.md, the procedure.
-- Items 16 and 17 are not here: they are deliberate faults, and the session
-- running this builds and throws them away itself, as docs/CLOSURE-TESTS.md
-- sets out.

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
\echo '=== 5. Session 6 on the clean sheet, by type and outcome'
SELECT bill_type, outcome, count(*) AS bills
  FROM bill WHERE session_number = 6 GROUP BY 1, 2 ORDER BY 1, 2;

\echo ''
\echo '=== 6. The arithmetic: printed entries, second appearances, bills'
SELECT (SELECT count(*) FROM bill_candidate WHERE session_number = 6) AS printed_entries,
       (SELECT count(*) FROM bill_candidate
         WHERE session_number = 6 AND continues_bill_id IS NOT NULL) AS second_appearances,
       (SELECT count(*) FROM bill WHERE session_number = 6) AS bills;

\echo ''
\echo '=== 7. The fourteen that did not pass'
SELECT outcome, count(*) AS bills
  FROM bill WHERE session_number = 6 AND outcome <> 'passed'
 GROUP BY 1 ORDER BY 1;

\echo ''
\echo '=== 8. The seven the fact sheet left awaiting Royal Assent, which are Acts'
SELECT bill_id, short_title, enactment_status, asp_number, date_royal_assent
  FROM bill WHERE bill_id IN (390, 391, 392, 394, 395, 396, 397)
 ORDER BY bill_id;

\echo ''
\echo '=== 9. The one bill still stopped before Royal Assent'
SELECT bill_id, short_title, outcome, enactment_status, assent_block_route,
       assent_block_outcome, date_assent_blocked
  FROM bill WHERE enactment_status = 'blocked' ORDER BY bill_id;

\echo ''
\echo '=== 10. The bills handled under emergency procedure, and the day it was agreed'
SELECT bill_id, left(short_title, 60) AS bill, procedure, date_procedure_agreed
  FROM bill WHERE procedure IS NOT NULL ORDER BY bill_id;

\echo ''
\echo '=== 11. The three second appearances made no bills, and are stamped'
SELECT c.candidate_id, c.continues_bill_id, c.promoted_bill_id,
       EXISTS (SELECT 1 FROM bill b WHERE b.bill_id = c.candidate_id) AS made_a_bill_of_its_own
  FROM bill_candidate c
 WHERE c.session_number = 6 AND c.continues_bill_id IS NOT NULL
 ORDER BY c.candidate_id;

\echo ''
\echo '=== 12. The two bills reconsidered and passed, and their Reconsideration Stage'
SELECT b.bill_id, left(b.short_title, 58) AS bill, b.enactment_status, b.asp_number,
       b.date_royal_assent, b.assent_block_outcome,
       e.date_reached, e.date_completed
  FROM bill b LEFT JOIN stage_event e ON e.bill_id = b.bill_id AND e.stage = 'reconsideration'
 WHERE b.assent_block_outcome IN ('reconsidered_passed', 'reconsidered_fell')
 ORDER BY b.bill_id;

\echo ''
\echo '=== 13. The three rewritten notes, in full, as a reader sees them'
\x on
SELECT bill_id, short_title, enactment_status, date_royal_assent, date_concluded, note
  FROM bill WHERE bill_id IN (303, 304, 305) ORDER BY bill_id;
\x off

\echo ''
\echo '=== 14. What those notes said before, and who says so'
SELECT entity_id, source, observed_at, length(note) AS note_length,
       note LIKE '%It read ''Not submitted for Royal Assent.%' AS keeps_the_earlier_wording
  FROM field_source
 WHERE entity = 'bill' AND field_name = 'note' ORDER BY entity_id;

\echo ''
\echo '=== 15. No Act on the clean sheet carries a note saying it never got Royal Assent'
SELECT bill_id, left(short_title, 50) AS bill, left(note, 70) AS note_starts
  FROM bill
 WHERE enactment_status = 'enacted'
   AND note LIKE '%could not be submitted for Royal Assent%'
   AND note NOT LIKE '%received Royal Assent on%'
 ORDER BY bill_id;

\echo ''
\echo '=== 18. Stage records for Session 6 bills, by stage and source'
SELECT e.stage, e.source, count(*) AS rows
  FROM stage_event e JOIN bill b USING (bill_id)
 WHERE b.session_number = 6 GROUP BY 1, 2 ORDER BY 1, 2;

\echo ''
\echo '=== 19. Accepted stage dates not carried, and why'
SELECT t.candidate_id, t.stage, t.date_completed, t.source,
       EXISTS (SELECT 1 FROM stage_event e
                WHERE e.bill_id = c.continues_bill_id AND e.stage = t.stage
                  AND e.date_completed = t.date_completed) AS already_on_the_bill
  FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
 WHERE c.session_number = 6 AND t.review_status = 'accepted'
   AND t.promoted_stage_event_id IS NULL
 ORDER BY t.candidate_id, t.stage_order;

\echo ''
\echo '=== 20. Session 7''s line, and the checker and the gaps list'
SELECT candidate_id, session_number, left(short_title, 45) AS bill, continues_bill_id,
       review_status, promoted_bill_id
  FROM bill_candidate WHERE session_number = 7 ORDER BY candidate_id;
SELECT (SELECT count(*) FROM v_candidate_problems) AS checker_problems,
       (SELECT count(*) FROM v_stage_date_gaps)    AS gaps;

\echo ''
\echo '=== 21. Nothing absurd in the durations'
SELECT count(*) FILTER (WHERE calendar_days_to_final_stage < 0)   AS negative_to_final,
       count(*) FILTER (WHERE calendar_days_to_assent < 0)        AS negative_to_assent,
       count(*) FILTER (WHERE calendar_days_to_final_stage > 2000) AS over_2000,
       count(*) FILTER (WHERE calendar_days_to_final_stage IS NULL AND bill_passed) AS passed_with_no_road
  FROM v_bill_total_duration;
SELECT bill_id, left(short_title, 52) AS bill, procedure, calendar_days_to_final_stage
  FROM v_bill_total_duration WHERE session_number = 6 AND procedure = 'emergency'
 ORDER BY calendar_days_to_final_stage;

\echo ''
\echo '=== 22. Every bill has a source, a reference and the day it was read'
SELECT count(*) FILTER (WHERE source IS NULL)      AS no_source,
       count(*) FILTER (WHERE source_ref IS NULL)  AS no_reference,
       count(*) FILTER (WHERE observed_at IS NULL) AS no_date_read
  FROM bill;

\echo ''
\echo '=== 23. No note on the clean sheet ends mid-sentence'
SELECT count(*) AS notes_ending_badly
  FROM bill WHERE note IS NOT NULL AND btrim(note) !~ '[.?!"]$';
