-- check_a_blocked_bill.sql
--
-- Written on 2026-09-14 by the session that built db/071 and db/072, to be run
-- by a session that did none of that work. It marks its own predictions: every
-- line prints what it should say beside what it does say, so it can be read
-- without knowing what was built.
--
--   psql -d legdata -f tools/check_a_blocked_bill.sql
--
-- Nothing here writes. Items 1 to 6 hold from the moment db/072 was run.
-- Items 7 to 9 are about Session 5's lines and can only be answered once
-- Session 5 has been loaded; before that they should print no rows, and that
-- is not a failure.
--
-- What an outside change can move: item 4 counts the bills on the clean sheet
-- and item 9 the lines on the staging sheet. Loading a session changes both,
-- and the figures in the "should say" column are the ones true on 2026-09-14.

\pset footer off

\echo ''
\echo '=== 1. The two cells db/071 added exist, and both are described.'
\echo '    Should say: date_assent_blocked date, raw_footnote text, both with a comment.'
SELECT a.attname AS column_name, format_type(a.atttypid, a.atttypmod) AS type,
       CASE WHEN col_description(a.attrelid, a.attnum) IS NULL
            THEN '*** NO COMMENT ***' ELSE 'described' END AS comment
  FROM pg_attribute a
 WHERE a.attrelid = 'bill_candidate'::regclass
   AND a.attname IN ('date_assent_blocked', 'raw_footnote')
 ORDER BY a.attname;

\echo ''
\echo '=== 2. The error checker knows about a blocked bill: eight rules, three of'
\echo '    them opening "recorded as blocked".  Should say: 8.'
SELECT count(*) AS rules_mentioning_blocked_or_awaiting
  FROM regexp_matches(pg_get_viewdef('v_candidate_problems'::regclass, true),
                      'recorded as blocked|so still a live bill|but it has a Royal |stopped from going for Royal Assent|passed, but has no Royal Assent date|read from the Bills awaiting Royal Assent', 'g');

\echo ''
\echo '=== 3. M5 tells a reader where the data has got to.'
\echo '    Should say: 2331 characters, and yes to all three.'
SELECT length(body) AS characters,
       body LIKE '%blocked by a section 35 order on 16 January 2023%' AS keeps_the_section_35_account,
       body LIKE '%the date of the block stays in bill.date_assent_blocked.%' AS keeps_where_the_date_lives,
       body LIKE '%runs ahead of the data until that has happened.' AS says_it_runs_ahead
  FROM methodology_note WHERE code = 'M5';

\echo ''
\echo '=== 4. Nothing on the clean sheet moved when this was built.'
\echo '    Should say: 302 bills, 828 stage records, 86 provenance notes, 8 notes, 0 problems, 0 gaps.'
SELECT (SELECT count(*) FROM bill)                  AS bills,
       (SELECT count(*) FROM stage_event)           AS stage_records,
       (SELECT count(*) FROM field_source)          AS provenance_notes,
       (SELECT count(*) FROM methodology_note)      AS methodology_notes,
       (SELECT count(*) FROM v_candidate_problems)  AS problems,
       (SELECT count(*) FROM v_stage_date_gaps)     AS gaps;

\echo ''
\echo '=== 5. The hole db/071 found is shut: a bill cannot pass, have no Royal'
\echo '    Assent date, and be quietly recorded as not enacted.'
\echo '    Should say: yes.'
SELECT pg_get_viewdef('v_candidate_problems'::regclass, true)
       LIKE '%passed, but has no Royal Assent date and is recorded as%' AS the_rule_is_there;

\echo ''
\echo '=== 6. Promotion carries the date a bill was stopped, and compares it'
\echo '    afterwards. Run in the shell, not here:'
\echo '      grep -c date_assent_blocked tools/promote_session.sql   -> should say 6'
\echo '      grep -c raw_footnote        tools/promote_session.sql   -> should say 4'
\echo '      grep -c date_assent_blocked tools/load_session.sql      -> should say 5'
\echo ''
\echo '=== 7. Session 5, once loaded: the fourth table arrived, and says what it'
\echo '    should. Should say three rows, each passed and blocked; 2021-10-06 on'
\echo '    the European Charter and UNCRC Bills and empty on Legal Continuity;'
\echo '    no ending date and no Royal Assent date on any of them.'
SELECT c.candidate_id, left(c.short_title, 42) AS bill, c.outcome, c.enactment_status,
       c.date_assent_blocked, c.date_concluded, c.date_royal_assent,
       CASE WHEN coalesce(btrim(c.bill_note), '') = '' THEN '*** EMPTY ***'
            ELSE left(c.bill_note, 30) || '...' END AS note_a_reader_sees
  FROM bill_candidate c
 WHERE c.raw_section = 'awaiting_assent'
 ORDER BY c.candidate_id;

\echo ''
\echo '=== 8. Each of those three carries the fact sheet''s own footnote, word'
\echo '    for word. Should say three rows, each ending "in its unamended form."'
SELECT c.candidate_id, right(c.raw_footnote, 60) AS how_the_footnote_ends,
       c.raw_footnote LIKE '%cannot be submitted for Royal Assent%' AS says_it_cannot_be_submitted
  FROM bill_candidate c
 WHERE c.raw_section = 'awaiting_assent'
 ORDER BY c.candidate_id;

\echo ''
\echo '=== 9. Session 5''s lines reconcile with its own printed summary on page'
\echo '    12: 63 government, 16 member''s, 5 private, 3 committee, 87 in all.'
SELECT coalesce(c.raw_section, 'TOTAL') AS factsheet_table,
       count(*) FILTER (WHERE c.raw_type IN ('E','G','G*')) AS government,
       count(*) FILTER (WHERE c.raw_type = 'M') AS members,
       count(*) FILTER (WHERE c.raw_type = 'P') AS private,
       count(*) FILTER (WHERE c.raw_type = 'C') AS committee,
       count(*) AS total
  FROM bill_candidate c
 WHERE c.session_number = 5
 GROUP BY GROUPING SETS ((c.raw_section), ())
 ORDER BY c.raw_section NULLS LAST;
