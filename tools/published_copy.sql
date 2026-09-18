-- published_copy.sql
--
-- Takes the published copy: builds the eleven files inside the published
-- workbook, reading the working data through the connector that can only read,
-- checks every cell of them against the working data, and puts them live as
-- the area `live`. One all-or-nothing action: if anything is refused or any
-- check fails, nothing is left behind. See docs/PUBLISHED-COPY-RUNBOOK.md.
--
--   sudo -u postgres psql -X -d published -v save=false -f tools/published_copy.sql
--   sudo -u postgres psql -X -d published -v save=true  -f tools/published_copy.sql
--
-- Run from the folder holding tools/ and workings/: the worked-out files are
-- built from the text in workings/. -v workings=DIR names another folder.
--
-- save=false builds and checks and throws it all away; save=true keeps it.
-- For the rehearsal, -v fault=on alters one bill's outcome after the build,
-- -v fault_days=on one gap's days, -v fault_terms=on one credit line, and
-- -v fault_cover=on takes the Supreme Court out of its terms' covers; the
-- check must then fail on that cell and name it.
--
-- Block 1 of docs/PHASE-2-CHARTS-BUILD.md: the first copy. It refuses if `live`
-- already exists. Replacing a live copy, keeping the old one as `previous` and
-- filling what_changed belong to the refresh, block 3.
--
-- THE MAPPING. One list below says, for every heading of every file: the
-- working columns its cells come from (`feeds`), which translates each
-- methodology note's applies_to; where the check finds the working value to
-- compare with (`check_key`); the list its words come from, if any; and its
-- description, as agreed by the owner (docs/PHASE-2-PUBLISHED-COPY.md §2 to §4
-- and docs/PHASE-2-COPY-DESCRIPTIONS.md). It is the only place a heading is
-- paired with a working column.
--
-- THE WORKED-OUT FILES. A file worked out from other published files is built
-- by running its working, a text in workings/, on the copy's own files under
-- their published headings. The text is kept in the copy's `workings` file,
-- so the working a reader sees is the one that ran. Settled 2026-09-18: every
-- published figure is worked out from the published data. Today there is one,
-- the days between stages; docs/STRAND-1-DAYS-BETWEEN-STAGES.md.
--
-- THE BUILD writes each file with its own query. THE CHECK does not repeat the
-- build: it takes every cell of the copy, turns it back into what the working
-- database holds -- a word back into its code by looking the word up in the
-- working list, Yes and No back into true and false -- and compares that with
-- the working cell the mapping names. So a heading the build filled from the
-- wrong column, or a word that does not turn back into the right code, fails.

\set ON_ERROR_STOP on

\if :{?save}
\else
  \echo 'Refusing: say -v save=false to look and throw away, or -v save=true to keep.'
  \quit
\endif

BEGIN;

-- ---------------------------------------------------------------------------
-- The working data, through the connector
-- ---------------------------------------------------------------------------

DO $$
DECLARE r record;
BEGIN
  FOR r IN SELECT foreign_table_name FROM information_schema.foreign_tables
            WHERE foreign_table_schema = 'from_working' LOOP
    EXECUTE format('DROP FOREIGN TABLE from_working.%I', r.foreign_table_name);
  END LOOP;
END $$;

IMPORT FOREIGN SCHEMA public LIMIT TO (
    bill, stage_event, session, methodology_note, field_source,
    ref_assent_block_outcome, ref_assent_block_route, ref_bill_type,
    ref_bill_type_stage, ref_bill_type_stated, ref_enactment_status, ref_outcome,
    ref_procedure, ref_source, ref_stage, ref_stage_1_rejection_route,
    source_terms, v_bill_stage_dates,
    v_candidate_problems, v_stage_date_gaps)
  FROM SERVER working INTO from_working;

-- Refuse to start.
DO $$
DECLARE n integer;
BEGIN
  IF EXISTS (SELECT 1 FROM pg_namespace WHERE nspname = 'live') THEN
    RAISE EXCEPTION 'Refusing: a live copy already exists. Replacing one is the refresh, block 3.';
  END IF;
  IF EXISTS (SELECT 1 FROM pg_namespace WHERE nspname = 'copy_build') THEN
    RAISE EXCEPTION 'Refusing: a copy_build area is left from an earlier run.';
  END IF;
  SELECT count(*) INTO n FROM from_working.v_candidate_problems;
  IF n > 0 THEN RAISE EXCEPTION 'Refusing: the error checker lists % problem(s).', n; END IF;
  SELECT count(*) INTO n FROM from_working.v_stage_date_gaps;
  IF n > 0 THEN RAISE EXCEPTION 'Refusing: the gaps list has % line(s).', n; END IF;
END $$;

-- A fingerprint of the working data, to show at the end that nothing moved.
CREATE TEMP TABLE working_before ON COMMIT DROP AS
SELECT (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY bill_id)) FROM from_working.bill t) AS bills,
       (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY stage_event_id)) FROM from_working.stage_event t) AS stages,
       (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY field_source_id)) FROM from_working.field_source t) AS sources,
       (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY session_number)) FROM from_working.session t) AS sessions,
       (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY code)) FROM from_working.methodology_note t) AS notes,
       (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY code)) FROM from_working.source_terms t) AS terms;

-- ---------------------------------------------------------------------------
-- The mapping
-- ---------------------------------------------------------------------------

CREATE TEMP TABLE files (file text PRIMARY KEY, pos int NOT NULL, description text NOT NULL) ON COMMIT DROP;
INSERT INTO files (file, pos, description) VALUES
  ('bills', 1, 'One line per bill introduced in the Scottish Parliament since 1999, with the day each of its stages ended.'),
  ('stages', 2, 'One line per stage a bill reached, with everything recorded about it.'),
  ('days_between_stages', 3, 'Worked out from bills and stages: one line per gap between two dated points in a bill''s passage, and the calendar days it took. The working is in workings.'),
  ('sessions', 4, 'One line per session of the Parliament, with its first and last days.'),
  ('methodology_notes', 5, 'The judgements made in coding the data, one note per line, in full.'),
  ('sources', 6, 'One line per fact that names its own source, where that is not the source of the rest of its line.'),
  ('what_the_words_mean', 7, 'What each word in the other files means, one line per heading and word.'),
  ('what_changed', 8, 'Every published value that differs from the copy before, one line per cell.'),
  ('workings', 9, 'The working that produced each worked-out file, in full, as it ran when this copy was taken.'),
  ('terms', 10, 'The terms each source''s data is published under, and how to credit it. A value whose source is listed under covers is under that line''s terms; everything else is our own work.'),
  ('about', 11, 'The day this copy was taken, and how many lines each file has.');

CREATE TEMP TABLE mapping (
    file text NOT NULL REFERENCES files,
    pos int NOT NULL,
    heading text NOT NULL,
    feeds text[] NOT NULL,
    check_key text,
    list text,
    description text NOT NULL,
    PRIMARY KEY (file, heading),
    UNIQUE (file, pos)) ON COMMIT DROP;
INSERT INTO mapping (file, pos, heading, feeds, check_key, list, description) VALUES
  ('bills', 1, 'bill_number', '{bill.bill_id}'::text[], 'bill.bill_id', NULL,
   'Our number for the bill. Ours, never the Parliament''s.'),
  ('bills', 2, 'sp_bill_number', '{bill.sp_bill_id}'::text[], 'bill.sp_bill_id', NULL,
   'The Parliament''s number within its session. Empty where none is known.'),
  ('bills', 3, 'session', '{bill.session_number}'::text[], 'bill.session_number', NULL,
   'The session the bill was introduced in.'),
  ('bills', 4, 'title', '{bill.short_title}'::text[], 'bill.short_title', NULL,
   'The title the bill is known by: the Act''s title where it became an Act, otherwise the title it ended with.'),
  ('bills', 5, 'title_as_introduced', '{bill.title_as_introduced}'::text[], 'bill.title_as_introduced', NULL,
   'The title it was introduced under, where a source states it. Empty never means the title did not change.'),
  ('bills', 6, 'title_changed_at_stage', '{bill.title_changed_at_stage}'::text[], 'bill.title_changed_at_stage', 'ref_stage',
   'The stage at which the title changed.'),
  ('bills', 7, 'bill_type', '{bill.bill_type}'::text[], 'bill.bill_type', 'ref_bill_type',
   'Government, Member''s, Committee, Private or Hybrid Bill.'),
  ('bills', 8, 'bill_type_at_the_time', '{bill.bill_type_stated}'::text[], 'bill.bill_type_stated', 'ref_bill_type_stated',
   'Executive Bill or Government Bill, as it was styled then.'),
  ('bills', 9, 'bill_type_grouped', '{bill.bill_type,ref_bill_type.analysis_group}'::text[], 'ref_bill_type.analysis_group', 'ref_bill_type',
   'The type used when types are grouped for counting, which puts the one Hybrid Bill with the government bills.'),
  ('bills', 10, 'procedure', '{bill.procedure}'::text[], 'bill.procedure', 'ref_procedure',
   'How the bill was handled under the Parliament''s rules. Empty means not known, never standard.'),
  ('bills', 11, 'date_procedure_agreed', '{bill.date_procedure_agreed}'::text[], 'bill.date_procedure_agreed', NULL,
   'The day the Parliament agreed to handle it that way.'),
  ('bills', 12, 'date_introduced', '{bill.date_introduced}'::text[], 'bill.date_introduced', NULL,
   'The day it was introduced.'),
  ('bills', 13, 'first_stage', '{stage_event.stage}'::text[], 'v_bill_stage_dates.first_stage', 'ref_stage',
   'The name of its first stage: Stage 1, or Preliminary Stage for a Private Bill.'),
  ('bills', 14, 'first_stage_ended', '{stage_event.date_completed}'::text[], 'v_bill_stage_dates.first_stage_end', NULL,
   'The day that stage ended.'),
  ('bills', 15, 'second_stage', '{stage_event.stage}'::text[], 'v_bill_stage_dates.second_stage', 'ref_stage',
   'Stage 2, or Consideration Stage.'),
  ('bills', 16, 'second_stage_ended', '{stage_event.date_completed}'::text[], 'v_bill_stage_dates.second_stage_end', NULL,
   'The day that stage ended.'),
  ('bills', 17, 'third_stage', '{stage_event.stage}'::text[], 'v_bill_stage_dates.final_stage', 'ref_stage',
   'Stage 3, or Final Stage.'),
  ('bills', 18, 'third_stage_ended', '{stage_event.date_completed}'::text[], 'v_bill_stage_dates.final_stage_end', NULL,
   'The day that stage ended.'),
  ('bills', 19, 'reconsideration_reached', '{stage_event.date_reached}'::text[], 'reconsideration.date_reached', NULL,
   'The day the bill reached Reconsideration Stage, for the two bills that had one.'),
  ('bills', 20, 'reconsideration_ended', '{stage_event.date_completed}'::text[], 'v_bill_stage_dates.reconsideration_end', NULL,
   'The day that stage ended.'),
  ('bills', 21, 'outcome', '{bill.outcome}'::text[], 'bill.outcome', 'ref_outcome',
   'What the Parliament did with the bill.'),
  ('bills', 22, 'how_rejected_at_stage_1', '{bill.stage_1_rejection_route}'::text[], 'bill.stage_1_rejection_route', 'ref_stage_1_rejection_route',
   'Which of the three routes rejected its general principles. Filled only for a bill rejected at Stage 1.'),
  ('bills', 23, 'enactment_status', '{bill.enactment_status}'::text[], 'bill.enactment_status', 'ref_enactment_status',
   'Whether it became an Act: Enacted, Not enacted, Pending, Blocked.'),
  ('bills', 24, 'date_royal_assent', '{bill.date_royal_assent}'::text[], 'bill.date_royal_assent', NULL,
   'The day it became an Act.'),
  ('bills', 25, 'act_number', '{bill.asp_number}'::text[], 'bill.asp_number', NULL,
   'The Act''s number, such as 2016 asp 8.'),
  ('bills', 26, 'date_fell_or_withdrawn', '{bill.date_concluded}'::text[], 'bill.date_concluded', NULL,
   'The day it stopped being a live bill without becoming an Act. Empty for an Act and for a live bill.'),
  ('bills', 27, 'date_stopped_before_assent', '{bill.date_assent_blocked}'::text[], 'bill.date_assent_blocked', NULL,
   'The day it was stopped from being sent for Royal Assent.'),
  ('bills', 28, 'how_stopped_before_assent', '{bill.assent_block_route}'::text[], 'bill.assent_block_route', 'ref_assent_block_route',
   'A section 33 reference to the Supreme Court, or a section 35 order.'),
  ('bills', 29, 'outcome_after_being_stopped', '{bill.assent_block_outcome}'::text[], 'bill.assent_block_outcome', 'ref_assent_block_outcome',
   'What happened next: still stopped, withdrawn, reconsidered and passed, reconsidered and fell.'),
  ('bills', 30, 'carried_scrutiny_from_bill_number', '{bill.reintroduced_from_bill_id}'::text[], 'bill.reintroduced_from_bill_id', NULL,
   'The earlier bill whose scrutiny this bill carried. One bill has it.'),
  ('bills', 31, 'note', '{bill.note}'::text[], 'bill.note', NULL,
   'Anything irregular about this bill a reader should see.'),
  ('bills', 32, 'source', '{bill.source}'::text[], 'bill.source', 'ref_source',
   'Where this line''s facts came from.'),
  ('bills', 33, 'where_in_the_source', '{bill.source_ref}'::text[], 'bill.source_ref', NULL,
   'Which factsheet, which page.'),
  ('bills', 34, 'date_source_read', '{bill.observed_at}'::text[], 'bill.observed_at', NULL,
   'The day we read it.'),
  ('stages', 1, 'bill_number', '{stage_event.bill_id}'::text[], 'stage_event.bill_id', NULL,
   'Which bill.'),
  ('stages', 2, 'title', '{bill.short_title}'::text[], 'bill.short_title', NULL,
   'Its title, so this file reads on its own.'),
  ('stages', 3, 'session', '{bill.session_number}'::text[], 'bill.session_number', NULL,
   'Its session.'),
  ('stages', 4, 'stage', '{stage_event.stage}'::text[], 'stage_event.stage', 'ref_stage',
   'The stage''s real name for this kind of bill.'),
  ('stages', 5, 'stage_position', '{stage_event.stage_order}'::text[], 'stage_event.stage_order', NULL,
   'Where it comes in that bill type''s sequence: 1, 2, 3, or 4 for Reconsideration.'),
  ('stages', 6, 'date_reached', '{stage_event.date_reached}'::text[], 'stage_event.date_reached', NULL,
   'The day the bill reached the stage, where a source states it. Two rows have it.'),
  ('stages', 7, 'date_ended', '{stage_event.date_completed}'::text[], 'stage_event.date_completed', NULL,
   'The day the stage ended.'),
  ('stages', 8, 'got_through', '{stage_event.completed}'::text[], 'stage_event.completed', 'yesno',
   'Yes if the bill got through this stage.'),
  ('stages', 9, 'bill_ended_here', '{stage_event.fell_here}'::text[], 'stage_event.fell_here', 'yesno',
   'Yes on the stage where the bill ended.'),
  ('stages', 10, 'stage_never_happened', '{stage_event.did_not_happen}'::text[], 'stage_event.did_not_happen', 'yesno',
   'Yes where the bill never had this stage because its procedure skipped it.'),
  ('stages', 11, 'note', '{stage_event.detail_note}'::text[], 'stage_event.detail_note', NULL,
   'Whatever a source records beyond what the row says.'),
  ('stages', 12, 'why_there_is_no_date', '{stage_event.general_note}'::text[], 'stage_event.general_note', NULL,
   'The one sentence, the same words every time, on a stage where the bill stopped without the Parliament deciding anything.'),
  ('stages', 13, 'source', '{stage_event.source}'::text[], 'stage_event.source', 'ref_source',
   'Where this stage date came from.'),
  ('stages', 14, 'where_in_the_source', '{stage_event.source_ref}'::text[], 'stage_event.source_ref', NULL,
   'The exact place within it.'),
  ('stages', 15, 'date_source_read', '{stage_event.observed_at}'::text[], 'stage_event.observed_at', NULL,
   'The day we read it.'),
  ('days_between_stages', 1, 'bill_number', '{bill.bill_id}'::text[], NULL, NULL,
   'Which bill.'),
  ('days_between_stages', 2, 'title', '{bill.short_title}'::text[], NULL, NULL,
   'Its title.'),
  ('days_between_stages', 3, 'session', '{bill.session_number}'::text[], NULL, NULL,
   'Its session.'),
  ('days_between_stages', 4, 'bill_type', '{bill.bill_type}'::text[], NULL, 'ref_bill_type',
   'Its type.'),
  ('days_between_stages', 5, 'procedure', '{bill.procedure}'::text[], NULL, 'ref_procedure',
   'How it was handled, where known.'),
  ('days_between_stages', 6, 'outcome', '{bill.outcome}'::text[], NULL, 'ref_outcome',
   'What the Parliament did with it.'),
  ('days_between_stages', 7, 'measured_from', '{stage_event.stage}'::text[], NULL, 'ref_stage',
   'The dated point the gap starts at: introduction, or a stage.'),
  ('days_between_stages', 8, 'date_measured_from', '{bill.date_introduced,stage_event.date_completed}'::text[], NULL, NULL,
   'That day.'),
  ('days_between_stages', 9, 'measured_to', '{stage_event.stage}'::text[], NULL, 'ref_stage',
   'The dated point it ends at: a stage, or Royal Assent.'),
  ('days_between_stages', 10, 'date_measured_to', '{stage_event.date_completed,bill.date_royal_assent}'::text[], NULL, NULL,
   'That day.'),
  ('days_between_stages', 11, 'days', '{}'::text[], NULL, NULL,
   'Worked out: date_measured_to minus date_measured_from, in calendar days.'),
  ('days_between_stages', 12, 'got_through_the_later_stage', '{stage_event.completed}'::text[], NULL, 'yesno',
   'Yes if the bill got through the stage at the end of this gap.'),
  ('days_between_stages', 13, 'bill_passed', '{bill.outcome}'::text[], NULL, 'yesno',
   'Yes if the bill went on to pass.'),
  ('sessions', 1, 'session', '{session.session_number}'::text[], 'session.session_number', NULL,
   'The session''s number: 1 for the Parliament elected in 1999, counting up.'),
  ('sessions', 2, 'date_first_meeting', '{session.date_first_meeting}'::text[], 'session.date_first_meeting', NULL,
   'The day the Parliament first met in this session.'),
  ('sessions', 3, 'date_session_ended', '{session.date_session_end}'::text[], 'session.date_session_end', NULL,
   'The session''s last day. Empty for the session still running.'),
  ('sessions', 4, 'date_session_expected_to_end', '{session.date_session_end_expected}'::text[], 'session.date_session_end_expected', NULL,
   'For the session still running, the day it is expected to end, worked out from the law on when the next election is held. See M14.'),
  ('sessions', 5, 'is_the_current_session', '{session.is_current}'::text[], 'session.is_current', 'yesno',
   'Yes for the session running now.'),
  ('sessions', 6, 'note', '{session.note}'::text[], 'session.note', NULL,
   'Anything a reader needs to know about the session''s dates that the dates do not say.'),
  ('methodology_notes', 1, 'note', '{methodology_note.code}'::text[], 'methodology_note.code', NULL,
   'The note''s code, M1, M2 and so on, which the other files use to refer to it.'),
  ('methodology_notes', 2, 'title', '{methodology_note.title}'::text[], 'methodology_note.title', NULL,
   'What the note is about, in one line.'),
  ('methodology_notes', 3, 'text', '{methodology_note.body}'::text[], 'methodology_note.body', NULL,
   'The note in full.'),
  ('methodology_notes', 4, 'applies_to', '{methodology_note.applies_to}'::text[], 'methodology_note.applies_to', 'applies_to',
   'The headings the note bears on, each written as the file and the heading, such as bills.outcome.'),
  ('sources', 1, 'applies_to_file', '{field_source.entity}'::text[], 'field_source.entity', 'file',
   'The file holding the fact this line is about: bills, stages or sessions.'),
  ('sources', 2, 'bill_number', '{}'::text[], 'derived.bill_id', NULL,
   'The bill the fact is about. Empty for a fact about a session.'),
  ('sources', 3, 'stage', '{}'::text[], 'derived.stage', 'ref_stage',
   'For a fact about a stage, which stage.'),
  ('sources', 4, 'session', '{}'::text[], 'derived.session', NULL,
   'The session the fact belongs to: the bill''s session, or the session itself.'),
  ('sources', 5, 'applies_to_heading', '{field_source.field_name}'::text[], 'field_source.field_name', 'heading',
   'The heading the fact sits under, in that file.'),
  ('sources', 6, 'source', '{field_source.source}'::text[], 'field_source.source', 'ref_source',
   'Where this one fact came from.'),
  ('sources', 7, 'where_in_the_source', '{field_source.source_ref}'::text[], 'field_source.source_ref', NULL,
   'The exact place within it: a page''s address, or which factsheet and page.'),
  ('sources', 8, 'value_as_the_source_gave_it', '{field_source.value_seen}'::text[], 'field_source.value_seen', NULL,
   'The source''s own words, where they say something the cell does not. Empty where the cell already says it, or where the fact is our coding. For an outcome read from the Official Report, the passages it printed, joined by " … ".'),
  ('sources', 9, 'date_source_read', '{field_source.observed_at}'::text[], 'field_source.observed_at', NULL,
   'The day we read it.'),
  ('sources', 10, 'note', '{field_source.note}'::text[], 'field_source.note', NULL,
   'What we did with the fact, in our words: how it was checked, or why it is coded as it is.'),
  ('what_the_words_mean', 1, 'heading', '{}'::text[], NULL, NULL,
   'A heading whose cells hold a word from a fixed list.'),
  ('what_the_words_mean', 2, 'value', '{}'::text[], NULL, NULL,
   'One of the words that can appear under it.'),
  ('what_the_words_mean', 3, 'what_it_means', '{}'::text[], NULL, NULL,
   'What that word means.'),
  ('what_the_words_mean', 4, 'order', '{}'::text[], NULL, NULL,
   'Where the word comes in its list, for sorting.'),
  ('what_changed', 1, 'date_copy_taken', '{}'::text[], NULL, NULL,
   'The day of the copy in which the value changed.'),
  ('what_changed', 2, 'file', '{}'::text[], NULL, NULL,
   'The file the cell is in.'),
  ('what_changed', 3, 'bill_number', '{}'::text[], NULL, NULL,
   'The bill whose line it is.'),
  ('what_changed', 4, 'stage', '{}'::text[], NULL, NULL,
   'For a cell in stages, which stage.'),
  ('what_changed', 5, 'heading', '{}'::text[], NULL, NULL,
   'The heading the cell is under.'),
  ('what_changed', 6, 'old_value', '{}'::text[], NULL, NULL,
   'What the cell said in the copy before.'),
  ('what_changed', 7, 'new_value', '{}'::text[], NULL, NULL,
   'What it says now. Empty if the cell is now empty.'),
  ('workings', 1, 'file', '{}'::text[], NULL, NULL,
   'The worked-out file.'),
  ('workings', 2, 'working', '{}'::text[], NULL, NULL,
   'The working, as text a reader can run on the other files.'),
  ('terms', 1, 'terms_for', '{}'::text[], 'source_terms.terms_for', NULL,
   'Whose terms these are.'),
  ('terms', 2, 'covers', '{}'::text[], NULL, NULL,
   'The source names, as the source headings give them, that these terms cover.'),
  ('terms', 3, 'licence', '{}'::text[], 'source_terms.licence', NULL,
   'The licence the data is under.'),
  ('terms', 4, 'licence_link', '{}'::text[], 'source_terms.licence_link', NULL,
   'Where the licence is published.'),
  ('terms', 5, 'credit_line', '{}'::text[], 'source_terms.credit_line', NULL,
   'The words to use when crediting this source, as the source gives them.'),
  ('terms', 6, 'restrictions', '{}'::text[], 'source_terms.restrictions', NULL,
   'What the source does not allow, in its own words.'),
  ('terms', 7, 'terms_page', '{}'::text[], 'source_terms.terms_page', NULL,
   'The page where the source publishes its terms. Empty for our own work.'),
  ('terms', 8, 'date_terms_read', '{}'::text[], 'source_terms.date_terms_read', NULL,
   'The day we read those terms. Empty for our own work.'),
  ('about', 1, 'date_copy_taken', '{}'::text[], NULL, NULL,
   'The day this copy of the data was taken.'),
  ('about', 2, 'file', '{}'::text[], NULL, NULL,
   'Which file.'),
  ('about', 3, 'rows', '{}'::text[], NULL, NULL,
   'How many lines it has.'),
  ('about', 4, 'rows_added_since_last_copy', '{}'::text[], NULL, NULL,
   'How many lines were added since the copy before. Empty for the first copy.');

-- The words: every published list, code to word, with its definition.
CREATE TEMP TABLE words ON COMMIT DROP AS
          SELECT 'ref_assent_block_outcome' AS list, code, label, definition, sort_order FROM from_working.ref_assent_block_outcome
UNION ALL SELECT 'ref_assent_block_route', code, label, definition, sort_order FROM from_working.ref_assent_block_route
UNION ALL SELECT 'ref_bill_type', code, label, definition, sort_order FROM from_working.ref_bill_type
UNION ALL SELECT 'ref_bill_type_stated', code, label, definition, sort_order FROM from_working.ref_bill_type_stated
UNION ALL SELECT 'ref_enactment_status', code, label, definition, sort_order FROM from_working.ref_enactment_status
UNION ALL SELECT 'ref_outcome', code, label, definition, sort_order FROM from_working.ref_outcome
UNION ALL SELECT 'ref_procedure', code, label, definition, sort_order FROM from_working.ref_procedure
UNION ALL SELECT 'ref_source', code, label, definition, sort_order FROM from_working.ref_source
UNION ALL SELECT 'ref_stage', code, label, definition, sort_order FROM from_working.ref_stage
UNION ALL SELECT 'ref_stage_1_rejection_route', code, label, definition, sort_order FROM from_working.ref_stage_1_rejection_route;

-- A code as its word. Refuses a code the list does not have, rather than
-- leaving the cell empty.
CREATE FUNCTION pg_temp.w(p_list text, p_code text) RETURNS text
LANGUAGE plpgsql STABLE AS $$
DECLARE r text;
BEGIN
  IF p_code IS NULL THEN RETURN NULL; END IF;
  SELECT label INTO r FROM words WHERE list = p_list AND code = p_code;
  IF r IS NULL THEN RAISE EXCEPTION 'No word for % in %.', p_code, p_list; END IF;
  RETURN r;
END $$;

CREATE FUNCTION pg_temp.yn(p boolean) RETURNS text
LANGUAGE sql IMMUTABLE AS $$ SELECT CASE p WHEN true THEN 'Yes' WHEN false THEN 'No' END $$;

-- ---------------------------------------------------------------------------
-- The build
-- ---------------------------------------------------------------------------

CREATE SCHEMA copy_build;

CREATE TABLE copy_build.bills AS
SELECT b.bill_id                                              AS bill_number,
       b.sp_bill_id                                           AS sp_bill_number,
       b.session_number                                       AS session,
       b.short_title                                          AS title,
       b.title_as_introduced,
       pg_temp.w('ref_stage', b.title_changed_at_stage)       AS title_changed_at_stage,
       pg_temp.w('ref_bill_type', b.bill_type)                AS bill_type,
       pg_temp.w('ref_bill_type_stated', b.bill_type_stated)  AS bill_type_at_the_time,
       pg_temp.w('ref_bill_type', g.analysis_group)           AS bill_type_grouped,
       pg_temp.w('ref_procedure', b.procedure)                AS procedure,
       b.date_procedure_agreed,
       b.date_introduced,
       pg_temp.w('ref_stage', d.first_stage)                  AS first_stage,
       d.first_stage_end                                      AS first_stage_ended,
       pg_temp.w('ref_stage', d.second_stage)                 AS second_stage,
       d.second_stage_end                                     AS second_stage_ended,
       pg_temp.w('ref_stage', d.final_stage)                  AS third_stage,
       d.final_stage_end                                      AS third_stage_ended,
       rs.date_reached                                        AS reconsideration_reached,
       d.reconsideration_end                                  AS reconsideration_ended,
       pg_temp.w('ref_outcome', b.outcome)                    AS outcome,
       pg_temp.w('ref_stage_1_rejection_route', b.stage_1_rejection_route) AS how_rejected_at_stage_1,
       pg_temp.w('ref_enactment_status', b.enactment_status)  AS enactment_status,
       b.date_royal_assent,
       b.asp_number                                           AS act_number,
       b.date_concluded                                       AS date_fell_or_withdrawn,
       b.date_assent_blocked                                  AS date_stopped_before_assent,
       pg_temp.w('ref_assent_block_route', b.assent_block_route)     AS how_stopped_before_assent,
       pg_temp.w('ref_assent_block_outcome', b.assent_block_outcome) AS outcome_after_being_stopped,
       b.reintroduced_from_bill_id                            AS carried_scrutiny_from_bill_number,
       b.note,
       pg_temp.w('ref_source', b.source)                      AS source,
       b.source_ref                                           AS where_in_the_source,
       b.observed_at                                          AS date_source_read
  FROM from_working.bill b
  JOIN from_working.ref_bill_type g ON g.code = b.bill_type
  LEFT JOIN from_working.v_bill_stage_dates d ON d.bill_id = b.bill_id
  LEFT JOIN from_working.stage_event rs ON rs.bill_id = b.bill_id AND rs.stage = 'reconsideration'
 ORDER BY b.bill_id;

CREATE TABLE copy_build.stages AS
SELECT e.bill_id                              AS bill_number,
       b.short_title                          AS title,
       b.session_number                       AS session,
       pg_temp.w('ref_stage', e.stage)        AS stage,
       e.stage_order                          AS stage_position,
       e.date_reached,
       e.date_completed                       AS date_ended,
       pg_temp.yn(e.completed)                AS got_through,
       pg_temp.yn(e.fell_here)                AS bill_ended_here,
       pg_temp.yn(e.did_not_happen)           AS stage_never_happened,
       e.detail_note                          AS note,
       e.general_note                         AS why_there_is_no_date,
       pg_temp.w('ref_source', e.source)      AS source,
       e.source_ref                           AS where_in_the_source,
       e.observed_at                          AS date_source_read
  FROM from_working.stage_event e
  JOIN from_working.bill b ON b.bill_id = e.bill_id
 ORDER BY e.bill_id, e.stage_order;

-- The worked-out files, each run from its text on the copy's own files. The
-- text is read here, kept in workings as it is, and run with only the copy's
-- files in reach.
\if :{?workings}
\else
  \set workings workings
\endif
\set days_working `cat :workings/days_between_stages.sql`

CREATE TABLE copy_build.workings (file text, working text);
INSERT INTO copy_build.workings (file, working) VALUES ('days_between_stages', :'days_working');

CREATE FUNCTION pg_temp.run_working(p_file text, p_into text) RETURNS void
LANGUAGE plpgsql AS $$
DECLARE t text; old_path text := current_setting('search_path');
BEGIN
  SELECT working INTO t FROM copy_build.workings WHERE file = p_file;
  IF t IS NULL THEN RAISE EXCEPTION 'No working for %.', p_file; END IF;
  PERFORM set_config('search_path', 'copy_build', true);
  EXECUTE format('CREATE TABLE %s AS %s', p_into, regexp_replace(t, ';\s*$', ''));
  PERFORM set_config('search_path', old_path, true);
END $$;

SELECT pg_temp.run_working('days_between_stages', 'copy_build.days_between_stages');

CREATE TABLE copy_build.sessions AS
SELECT s.session_number             AS session,
       s.date_first_meeting,
       s.date_session_end           AS date_session_ended,
       s.date_session_end_expected  AS date_session_expected_to_end,
       pg_temp.yn(s.is_current)     AS is_the_current_session,
       s.note
  FROM from_working.session s
 ORDER BY s.session_number;

-- applies_to names every heading fed by a working column the note names,
-- each as file.heading, in the order of the files and their headings.
CREATE TABLE copy_build.methodology_notes AS
SELECT n.code   AS note,
       n.title,
       n.body   AS text,
       (SELECT string_agg(m.file || '.' || m.heading, ', ' ORDER BY f.pos, m.pos)
          FROM mapping m JOIN files f USING (file)
         WHERE m.feeds && n.applies_to) AS applies_to
  FROM from_working.methodology_note n
 ORDER BY n.sort_order;

CREATE TABLE copy_build.sources AS
SELECT x.applies_to_file,
       x.bill_number,
       pg_temp.w('ref_stage', x.stage_code)    AS stage,
       x.session,
       (SELECT m.heading FROM mapping m
         WHERE m.file = x.applies_to_file
           AND m.check_key = x.entity || '.' || x.field_name) AS applies_to_heading,
       pg_temp.w('ref_source', x.source)       AS source,
       x.source_ref                            AS where_in_the_source,
       x.value_seen                            AS value_as_the_source_gave_it,
       x.observed_at                           AS date_source_read,
       x.note
  FROM (SELECT f.*,
               CASE f.entity WHEN 'bill' THEN 'bills' WHEN 'stage_event' THEN 'stages'
                             WHEN 'session' THEN 'sessions' END AS applies_to_file,
               CASE f.entity WHEN 'bill' THEN f.entity_id WHEN 'stage_event' THEN e.bill_id END AS bill_number,
               e.stage AS stage_code,
               CASE f.entity WHEN 'bill' THEN b.session_number WHEN 'stage_event' THEN eb.session_number
                             WHEN 'session' THEN f.entity_id END AS session
          FROM from_working.field_source f
          LEFT JOIN from_working.bill b ON f.entity = 'bill' AND b.bill_id = f.entity_id
          LEFT JOIN from_working.stage_event e ON f.entity = 'stage_event' AND e.stage_event_id = f.entity_id
          LEFT JOIN from_working.bill eb ON eb.bill_id = e.bill_id) x
 ORDER BY x.applies_to_file, x.bill_number, x.session, x.field_name;

-- Each heading that holds words lists only the words it can hold: a stage
-- heading only the stages that can come at that point, measured_from
-- Introduction as well and measured_to Royal Assent as well. Under
-- bill_type_grouped, Government Bill counts the Hybrid Bill, so it has its own
-- definition, agreed by the owner on 2026-09-18.
CREATE TABLE copy_build.what_the_words_mean AS
WITH lh AS (SELECT DISTINCT heading, list FROM mapping WHERE list LIKE 'ref\_%'),
     st AS (SELECT stage, stage_order FROM from_working.ref_bill_type_stage)
SELECT lh.heading,
       wd.label AS value,
       CASE WHEN lh.heading = 'bill_type_grouped' AND wd.code = 'government'
            THEN 'Introduced by the Scottish Government, counting the one Hybrid Bill, the Forth Crossing Bill of Session 3, which the Scottish Government introduced. See methodology note M4.'
            ELSE wd.definition END AS what_it_means,
       wd.sort_order AS "order"
  FROM lh JOIN words wd ON wd.list = lh.list
 WHERE CASE lh.heading
         WHEN 'bill_type_grouped' THEN wd.code IN (SELECT analysis_group FROM from_working.ref_bill_type)
         WHEN 'first_stage'  THEN wd.code IN (SELECT stage FROM st WHERE stage_order = 1)
         WHEN 'second_stage' THEN wd.code IN (SELECT stage FROM st WHERE stage_order = 2)
         WHEN 'third_stage'  THEN wd.code IN (SELECT stage FROM st WHERE stage_order = 3)
         WHEN 'measured_from' THEN wd.code IN (SELECT stage FROM st) OR wd.code = 'introduction'
         WHEN 'measured_to'   THEN wd.code IN (SELECT stage FROM st) OR wd.code = 'royal_assent'
         WHEN 'stage'                  THEN wd.code IN (SELECT stage FROM st)
         WHEN 'title_changed_at_stage' THEN wd.code IN (SELECT stage FROM st)
         ELSE true END
 ORDER BY lh.heading, wd.sort_order;

CREATE TABLE copy_build.what_changed (
    date_copy_taken date, file text, bill_number integer, stage text,
    heading text, old_value text, new_value text);

-- For the rehearsal: one gap's days altered after the build.
\if :{?fault_days}
UPDATE copy_build.days_between_stages SET days = days + 1
 WHERE (bill_number, measured_to) = (SELECT bill_number, measured_to FROM copy_build.days_between_stages
                                      ORDER BY bill_number, date_measured_to LIMIT 1);
\echo 'FAULT PLANTED: the first gap is a day longer.'
\endif

-- The terms, one line per set. covers names the kinds of source under each,
-- as the source headings give them; our own work, which no kind of source
-- comes under, says in words what it covers.
CREATE TABLE copy_build.terms AS
SELECT t.terms_for,
       coalesce((SELECT string_agg(k.label, '; ' ORDER BY k.sort_order)
                   FROM from_working.ref_source k WHERE k.terms = t.code), t.covers_note) AS covers,
       t.licence, t.licence_link, t.credit_line, t.restrictions, t.terms_page, t.date_terms_read
  FROM from_working.source_terms t
 ORDER BY t.sort_order;

-- For the rehearsal: one credit line altered, and one source taken out of its
-- terms' covers, after the build.
\if :{?fault_terms}
UPDATE copy_build.terms SET credit_line = credit_line || ' (altered)' WHERE terms_for = 'Scottish Parliament';
\echo 'FAULT PLANTED: the Scottish Parliament''s credit line is altered.'
\endif
\if :{?fault_cover}
UPDATE copy_build.terms SET covers = NULL WHERE terms_for = 'Supreme Court';
\echo 'FAULT PLANTED: the Supreme Court is covered by no terms.'
\endif

CREATE TABLE copy_build.about (
    date_copy_taken date, file text, rows integer, rows_added_since_last_copy integer);
INSERT INTO copy_build.about (date_copy_taken, file, rows)
SELECT current_date, f.file,
       CASE f.file WHEN 'about' THEN (SELECT count(*) FROM files)
            ELSE (xpath('/row/c/text()', query_to_xml(format('SELECT count(*) AS c FROM copy_build.%I', f.file), false, true, '')))[1]::text::int END
  FROM files f ORDER BY f.pos;

-- The descriptions.
DO $$
DECLARE r record;
BEGIN
  FOR r IN SELECT file, description FROM files LOOP
    EXECUTE format('COMMENT ON TABLE copy_build.%I IS %L', r.file, r.description);
  END LOOP;
  FOR r IN SELECT file, heading, description FROM mapping LOOP
    EXECUTE format('COMMENT ON COLUMN copy_build.%I.%I IS %L', r.file, r.heading, r.description);
  END LOOP;
END $$;

-- For the rehearsal: one cell altered after the build, which the check must catch.
\if :{?fault}
UPDATE copy_build.bills SET outcome = 'Withdrawn'
 WHERE bill_number = (SELECT min(bill_number) FROM copy_build.bills WHERE outcome = 'Passed');
\echo 'FAULT PLANTED: the first passed bill now reads Withdrawn.'
\endif

-- ---------------------------------------------------------------------------
-- The check
-- ---------------------------------------------------------------------------

CREATE TEMP TABLE problems (check_no int, detail text) ON COMMIT DROP;

-- A word back into its code, looked up in the working lists directly.
CREATE TEMP TABLE back_words ON COMMIT DROP AS
          SELECT 'ref_assent_block_outcome' AS list, code, label, definition FROM from_working.ref_assent_block_outcome
UNION ALL SELECT 'ref_assent_block_route', code, label, definition FROM from_working.ref_assent_block_route
UNION ALL SELECT 'ref_bill_type', code, label, definition FROM from_working.ref_bill_type
UNION ALL SELECT 'ref_bill_type_stated', code, label, definition FROM from_working.ref_bill_type_stated
UNION ALL SELECT 'ref_enactment_status', code, label, definition FROM from_working.ref_enactment_status
UNION ALL SELECT 'ref_outcome', code, label, definition FROM from_working.ref_outcome
UNION ALL SELECT 'ref_procedure', code, label, definition FROM from_working.ref_procedure
UNION ALL SELECT 'ref_source', code, label, definition FROM from_working.ref_source
UNION ALL SELECT 'ref_stage', code, label, definition FROM from_working.ref_stage
UNION ALL SELECT 'ref_stage_1_rejection_route', code, label, definition FROM from_working.ref_stage_1_rejection_route;

CREATE FUNCTION pg_temp.back(p_list text, p_word text) RETURNS text
LANGUAGE sql STABLE AS $$
  SELECT CASE WHEN p_word IS NULL THEN NULL
              ELSE coalesce((SELECT code FROM back_words WHERE list = p_list AND label = p_word),
                            '<no such word: ' || p_word || '>') END $$;

CREATE FUNCTION pg_temp.pre(p text, j jsonb) RETURNS jsonb
LANGUAGE sql IMMUTABLE AS $$
  SELECT coalesce((SELECT jsonb_object_agg(p || k, v) FROM jsonb_each(j) e(k, v)), '{}'::jsonb) $$;

-- Each published line beside the working rows it came from. A line with no
-- working row finds nothing, and every one of its cells then fails.
CREATE TEMP TABLE pairs (file text, rowkey text, pj jsonb, wj jsonb) ON COMMIT DROP;

INSERT INTO pairs
SELECT 'bills', p.bill_number::text, to_jsonb(p),
       pg_temp.pre('bill.', to_jsonb(b)) || pg_temp.pre('ref_bill_type.', to_jsonb(g))
       || pg_temp.pre('v_bill_stage_dates.', to_jsonb(d)) || pg_temp.pre('reconsideration.', to_jsonb(rs))
  FROM copy_build.bills p
  LEFT JOIN from_working.bill b ON b.bill_id = p.bill_number
  LEFT JOIN from_working.ref_bill_type g ON g.code = b.bill_type
  LEFT JOIN from_working.v_bill_stage_dates d ON d.bill_id = b.bill_id
  LEFT JOIN from_working.stage_event rs ON rs.bill_id = b.bill_id AND rs.stage = 'reconsideration';

INSERT INTO pairs
SELECT 'stages', p.bill_number || ' ' || p.stage, to_jsonb(p),
       pg_temp.pre('stage_event.', to_jsonb(e)) || pg_temp.pre('bill.', to_jsonb(b))
  FROM copy_build.stages p
  LEFT JOIN from_working.stage_event e ON e.bill_id = p.bill_number AND e.stage = pg_temp.back('ref_stage', p.stage)
  LEFT JOIN from_working.bill b ON b.bill_id = e.bill_id;

-- The days between stages have no working rows: they are worked out in the
-- copy, and check 10 checks them against the copy's own files. They are here
-- so that checks 3 and 4 see their words.
INSERT INTO pairs
SELECT 'days_between_stages', p.bill_number || ' ' || p.measured_from || ' to ' || p.measured_to, to_jsonb(p), '{}'::jsonb
  FROM copy_build.days_between_stages p;

INSERT INTO pairs
SELECT 'sessions', p.session::text, to_jsonb(p), pg_temp.pre('session.', to_jsonb(s))
  FROM copy_build.sessions p
  LEFT JOIN from_working.session s ON s.session_number = p.session;

INSERT INTO pairs
SELECT 'methodology_notes', p.note, to_jsonb(p), pg_temp.pre('methodology_note.', to_jsonb(n))
  FROM copy_build.methodology_notes p
  LEFT JOIN from_working.methodology_note n ON n.code = p.note;

-- A source line is found from what it says it is about: the file, the bill or
-- session, the stage, and the heading, each turned back.
INSERT INTO pairs
SELECT 'sources', coalesce(p.bill_number::text, 'session ' || p.session) || ' ' || coalesce(p.stage || ' ', '') || p.applies_to_heading,
       to_jsonb(p),
       pg_temp.pre('field_source.', to_jsonb(f))
       || jsonb_build_object('derived.bill_id', coalesce(b.bill_id, e.bill_id),
                             'derived.stage', e.stage,
                             'derived.session', coalesce(b.session_number, eb.session_number, s.session_number))
  FROM copy_build.sources p
  LEFT JOIN from_working.stage_event pe
         ON p.applies_to_file = 'stages' AND pe.bill_id = p.bill_number
        AND pe.stage = pg_temp.back('ref_stage', p.stage)
  LEFT JOIN from_working.field_source f
         ON f.entity = CASE p.applies_to_file WHEN 'bills' THEN 'bill' WHEN 'stages' THEN 'stage_event' WHEN 'sessions' THEN 'session' END
        AND f.entity_id = CASE p.applies_to_file WHEN 'bills' THEN p.bill_number WHEN 'stages' THEN pe.stage_event_id WHEN 'sessions' THEN p.session END
        AND f.field_name = (SELECT split_part(m.check_key, '.', 2) FROM mapping m
                             WHERE m.file = p.applies_to_file AND m.heading = p.applies_to_heading)
  LEFT JOIN from_working.bill b ON f.entity = 'bill' AND b.bill_id = f.entity_id
  LEFT JOIN from_working.stage_event e ON f.entity = 'stage_event' AND e.stage_event_id = f.entity_id
  LEFT JOIN from_working.bill eb ON eb.bill_id = e.bill_id
  LEFT JOIN from_working.session s ON f.entity = 'session' AND s.session_number = f.entity_id;

INSERT INTO pairs
SELECT 'terms', p.terms_for, to_jsonb(p), pg_temp.pre('source_terms.', to_jsonb(t))
  FROM copy_build.terms p
  LEFT JOIN from_working.source_terms t ON t.terms_for = p.terms_for;

-- 1. Lines: each file has exactly as many as the working data, one for one.
INSERT INTO problems
SELECT 1, x.file || ': ' || x.published || ' lines, working ' || x.working
  FROM (VALUES
    ('bills', (SELECT count(*) FROM copy_build.bills), (SELECT count(*) FROM from_working.bill)),
    ('stages', (SELECT count(*) FROM copy_build.stages), (SELECT count(*) FROM from_working.stage_event)),
    ('sessions', (SELECT count(*) FROM copy_build.sessions), (SELECT count(*) FROM from_working.session)),
    ('methodology_notes', (SELECT count(*) FROM copy_build.methodology_notes), (SELECT count(*) FROM from_working.methodology_note)),
    ('sources', (SELECT count(*) FROM copy_build.sources), (SELECT count(*) FROM from_working.field_source)),
    ('terms', (SELECT count(*) FROM copy_build.terms), (SELECT count(*) FROM from_working.source_terms)),
    ('sources, distinct working lines', (SELECT count(DISTINCT wj->>'field_source.field_source_id') FROM pairs WHERE file = 'sources'), (SELECT count(*) FROM from_working.field_source))
  ) AS x(file, published, working)
 WHERE x.published <> x.working;

-- 2. Every cell, turned back, against the working cell.
INSERT INTO problems
SELECT 2, pr.file || ' ' || pr.rowkey || ', ' || m.heading || ': published ' || coalesce(pr.pj->>m.heading, '(empty)')
          || ', turned back ' || coalesce(tb.v, '(empty)') || ', working ' || coalesce(pr.wj->>m.check_key, '(empty)')
  FROM pairs pr
  JOIN mapping m ON m.file = pr.file AND m.check_key IS NOT NULL AND m.list IS DISTINCT FROM 'applies_to'
  CROSS JOIN LATERAL (SELECT CASE
      WHEN m.list IS NULL THEN pr.pj->>m.heading
      WHEN m.list = 'yesno' THEN CASE pr.pj->>m.heading WHEN 'Yes' THEN 'true' WHEN 'No' THEN 'false'
                                      ELSE CASE WHEN pr.pj->>m.heading IS NULL THEN NULL ELSE '<not Yes or No>' END END
      WHEN m.list = 'file' THEN CASE pr.pj->>m.heading WHEN 'bills' THEN 'bill' WHEN 'stages' THEN 'stage_event'
                                     WHEN 'sessions' THEN 'session' ELSE '<no such file>' END
      WHEN m.list = 'heading' THEN (SELECT split_part(m2.check_key, '.', 2) FROM mapping m2
                                     WHERE m2.file = pr.pj->>'applies_to_file' AND m2.heading = pr.pj->>m.heading)
      ELSE pg_temp.back(m.list, pr.pj->>m.heading) END AS v) tb
 WHERE tb.v IS DISTINCT FROM pr.wj->>m.check_key;

-- 3. Every word in a cell is in what_the_words_mean under its heading, and
--    every line of what_the_words_mean says what the working list says.
INSERT INTO problems
SELECT 3, pr.file || ' ' || pr.rowkey || ', ' || m.heading || ': ' || (pr.pj->>m.heading) || ' is not in what_the_words_mean'
  FROM pairs pr JOIN mapping m ON m.file = pr.file AND m.list LIKE 'ref\_%'
 WHERE pr.pj->>m.heading IS NOT NULL
   AND NOT EXISTS (SELECT 1 FROM copy_build.what_the_words_mean t
                    WHERE t.heading = m.heading AND t.value = pr.pj->>m.heading);
INSERT INTO problems
SELECT 3, 'what_the_words_mean ' || t.heading || ', ' || t.value || ': does not say what the working list says'
  FROM copy_build.what_the_words_mean t
  JOIN (SELECT DISTINCT heading, list FROM mapping WHERE list LIKE 'ref\_%') m USING (heading)
  LEFT JOIN back_words bw ON bw.list = m.list AND bw.label = t.value
 WHERE bw.code IS NULL
    OR t.what_it_means IS DISTINCT FROM
       CASE WHEN t.heading = 'bill_type_grouped' AND bw.code = 'government'
            THEN 'Introduced by the Scottish Government, counting the one Hybrid Bill, the Forth Crossing Bill of Session 3, which the Scottish Government introduced. See methodology note M4.'
            ELSE bw.definition END;
INSERT INTO problems
SELECT 3, 'what_the_words_mean has ' || count(*) || ' lines, expected 89'
  FROM copy_build.what_the_words_mean HAVING count(*) <> 89;
INSERT INTO problems
SELECT 3, 'heading ' || heading || ' draws on more than one list'
  FROM mapping WHERE list LIKE 'ref\_%' GROUP BY heading HAVING count(DISTINCT list) > 1;

-- 4. No stored code in a cell that should hold a word.
INSERT INTO problems
SELECT 4, pr.file || ' ' || pr.rowkey || ', ' || m.heading || ': ' || (pr.pj->>m.heading) || ' looks like a stored code'
  FROM pairs pr JOIN mapping m ON m.file = pr.file AND m.list LIKE 'ref\_%'
 WHERE pr.pj->>m.heading ~ '^[a-z0-9]+(_[a-z0-9]+)*$';

-- 5. applies_to: every heading it names exists, and turned back, the headings
--    cover exactly the working columns the note names.
INSERT INTO problems
SELECT 5, 'note ' || p.note || ' names ' || h || ', which is not a heading'
  FROM copy_build.methodology_notes p
  CROSS JOIN LATERAL unnest(string_to_array(p.applies_to, ', ')) AS h
 WHERE NOT EXISTS (SELECT 1 FROM mapping m WHERE m.file || '.' || m.heading = h);
INSERT INTO problems
SELECT 5, 'note ' || n.code || ': ' || c || ' reaches no published heading'
  FROM from_working.methodology_note n
  CROSS JOIN LATERAL unnest(n.applies_to) AS c
  JOIN copy_build.methodology_notes p ON p.note = n.code
 WHERE NOT EXISTS (SELECT 1 FROM unnest(string_to_array(p.applies_to, ', ')) h
                     JOIN mapping m ON m.file || '.' || m.heading = h
                    WHERE c = ANY (m.feeds));
INSERT INTO problems
SELECT 5, 'note ' || p.note || ' names ' || h || ', which none of its working columns feed'
  FROM copy_build.methodology_notes p
  JOIN from_working.methodology_note n ON n.code = p.note
  CROSS JOIN LATERAL unnest(string_to_array(p.applies_to, ', ')) AS h
  JOIN mapping m ON m.file || '.' || m.heading = h
 WHERE NOT (m.feeds && n.applies_to);

-- 6. Every heading a note's text names is a heading or a file of the copy.
INSERT INTO problems
SELECT DISTINCT 6, 'note ' || p.note || ' names ' || w[1] || ', which is not in the copy'
  FROM copy_build.methodology_notes p
  CROSS JOIN LATERAL regexp_matches(p.text, '([a-z0-9]+(?:_[a-z0-9]+)+)', 'g') AS w
 WHERE NOT EXISTS (SELECT 1 FROM mapping m WHERE m.heading = w[1])
   AND NOT EXISTS (SELECT 1 FROM files f WHERE f.file = w[1]);

-- 7. The files and their headings are exactly the mapping's, in its order:
--    nothing that must not cross has crossed.
INSERT INTO problems
SELECT 7, coalesce(a.file, b.file) || ': heading ' || coalesce(a.heading, '(none)') || ' at ' || coalesce(a.pos, b.pos)
          || ', the mapping has ' || coalesce(b.heading, '(none)')
  FROM (SELECT table_name AS file, column_name AS heading, ordinal_position AS pos
          FROM information_schema.columns WHERE table_schema = 'copy_build') a
  FULL JOIN (SELECT file, heading, pos FROM mapping) b
    ON a.file = b.file AND a.pos = b.pos AND a.heading = b.heading
 WHERE a.heading IS NULL OR b.heading IS NULL;
INSERT INTO problems
SELECT 7, 'file ' || coalesce(a.table_name, f.file) || ' is in one of the copy and the mapping only'
  FROM (SELECT table_name FROM information_schema.tables WHERE table_schema = 'copy_build') a
  FULL JOIN files f ON f.file = a.table_name
 WHERE a.table_name IS NULL OR f.file IS NULL;

-- 8. Every file and heading is described.
INSERT INTO problems
SELECT 8, c.relname || '.' || a.attname || ' has no description'
  FROM pg_class c
  JOIN pg_namespace ns ON ns.oid = c.relnamespace AND ns.nspname = 'copy_build'
  JOIN pg_attribute a ON a.attrelid = c.oid AND a.attnum > 0 AND NOT a.attisdropped
 WHERE c.relkind = 'r' AND coalesce(col_description(c.oid, a.attnum), '') = ''
UNION ALL
SELECT 8, c.relname || ' has no description'
  FROM pg_class c
  JOIN pg_namespace ns ON ns.oid = c.relnamespace AND ns.nspname = 'copy_build'
 WHERE c.relkind = 'r' AND coalesce(obj_description(c.oid, 'pg_class'), '') = '';

-- 9. Every source line names a heading of its file, and a bill that is in bills.
INSERT INTO problems
SELECT 9, 'sources ' || coalesce(bill_number::text, 'session ' || session) || ': heading ' || coalesce(applies_to_heading, '(none)')
  FROM copy_build.sources p
 WHERE p.applies_to_heading IS NULL
    OR NOT EXISTS (SELECT 1 FROM mapping m WHERE m.file = p.applies_to_file AND m.heading = p.applies_to_heading)
    OR (p.bill_number IS NOT NULL AND NOT EXISTS (SELECT 1 FROM copy_build.bills b WHERE b.bill_number = p.bill_number));

-- 10. The worked-out files, against the copy's own files, not against any sum
--     in the working database: one version of the arithmetic, never two.
--     Every dated point of every bill, from bills and stages as published.
CREATE TEMP TABLE points ON COMMIT DROP AS
SELECT bill_number, 0 AS position, 'Introduction' AS point, date_introduced AS on_date, 'Yes' AS got_through
  FROM copy_build.bills WHERE date_introduced IS NOT NULL
UNION ALL
SELECT bill_number, stage_position, stage, date_ended, got_through
  FROM copy_build.stages WHERE date_ended IS NOT NULL
UNION ALL
SELECT bill_number, 9, 'Royal Assent', date_royal_assent, 'Yes'
  FROM copy_build.bills WHERE date_royal_assent IS NOT NULL;

-- a. Every cell but days is its bill's, or its dated points'.
INSERT INTO problems
SELECT 10, 'days_between_stages ' || d.bill_number || ' ' || d.measured_from || ' to ' || d.measured_to
          || ': does not match its bill or its dated points'
  FROM copy_build.days_between_stages d
  LEFT JOIN copy_build.bills b ON b.bill_number = d.bill_number
  LEFT JOIN points pf ON pf.bill_number = d.bill_number AND pf.point = d.measured_from
  LEFT JOIN points pt ON pt.bill_number = d.bill_number AND pt.point = d.measured_to
 WHERE b.bill_number IS NULL OR pf.bill_number IS NULL OR pt.bill_number IS NULL
    OR d.title IS DISTINCT FROM b.title OR d.session IS DISTINCT FROM b.session
    OR d.bill_type IS DISTINCT FROM b.bill_type OR d.procedure IS DISTINCT FROM b.procedure
    OR d.outcome IS DISTINCT FROM b.outcome
    OR d.bill_passed IS DISTINCT FROM CASE WHEN b.outcome = 'Passed' THEN 'Yes' WHEN b.outcome IS NOT NULL THEN 'No' END
    OR d.date_measured_from IS DISTINCT FROM pf.on_date OR d.date_measured_to IS DISTINCT FROM pt.on_date
    OR d.got_through_the_later_stage IS DISTINCT FROM pt.got_through
    OR pf.position >= pt.position;

-- b. days is the later day less the earlier, and never below nought.
INSERT INTO problems
SELECT 10, 'days_between_stages ' || bill_number || ' ' || measured_from || ' to ' || measured_to
          || ': days ' || coalesce(days::text, '(empty)') || ', the dates give ' || (date_measured_to - date_measured_from)
  FROM copy_build.days_between_stages
 WHERE days IS DISTINCT FROM date_measured_to - date_measured_from OR days < 0;

-- c. Every dated point is the end of exactly one gap, but each bill's first,
--    which is the end of none; and so the file has exactly as many lines as
--    there are such points.
INSERT INTO problems
SELECT 10, 'days_between_stages ' || p.bill_number || ' ' || p.point || ': the end of ' || count(d.bill_number)
          || ' gap(s), should be ' || CASE WHEN p.position = f.first THEN 0 ELSE 1 END
  FROM points p
  JOIN (SELECT bill_number, min(position) AS first FROM points GROUP BY 1) f USING (bill_number)
  LEFT JOIN copy_build.days_between_stages d ON d.bill_number = p.bill_number AND d.measured_to = p.point
 GROUP BY p.bill_number, p.point, p.position, f.first
HAVING count(d.bill_number) <> CASE WHEN p.position = f.first THEN 0 ELSE 1 END;
INSERT INTO problems
SELECT 10, 'days_between_stages has ' || (SELECT count(*) FROM copy_build.days_between_stages)
          || ' lines; the dated points give ' || ((SELECT count(*) FROM points) - (SELECT count(DISTINCT bill_number) FROM points))
 WHERE (SELECT count(*) FROM copy_build.days_between_stages)
       <> (SELECT count(*) FROM points) - (SELECT count(DISTINCT bill_number) FROM points);

-- d. The text kept in workings, run again, gives exactly the file: the
--    working a reader sees is the one that ran.
SELECT pg_temp.run_working('days_between_stages', 'pg_temp.days_rerun');
INSERT INTO problems
SELECT 10, 'days_between_stages ' || x.bill_number || ' ' || x.measured_from || ' to ' || x.measured_to
          || ': ' || x.side || ' running the kept working again'
  FROM (SELECT 'not given by' AS side, * FROM (SELECT * FROM copy_build.days_between_stages EXCEPT ALL SELECT * FROM pg_temp.days_rerun) a
        UNION ALL
        SELECT 'only given by', * FROM (SELECT * FROM pg_temp.days_rerun EXCEPT ALL SELECT * FROM copy_build.days_between_stages) b) x;
INSERT INTO problems
SELECT 10, 'workings has ' || count(*) || ' lines, or not the one expected'
  FROM copy_build.workings HAVING count(*) <> 1 OR bool_or(file <> 'days_between_stages');

-- 11. No source's data is published without its terms (DECISIONS.md,
--     2026-09-17). Every source name in bills, stages and sources, and every
--     kind of source in the working list, is covered by exactly one line of
--     terms; and each line's covers is exactly the kinds of source under it.
CREATE TEMP TABLE covered ON COMMIT DROP AS
SELECT p.terms_for, trim(c) AS source
  FROM copy_build.terms p
  CROSS JOIN LATERAL unnest(string_to_array(p.covers, ';')) AS c;
INSERT INTO problems
SELECT 11, 'source ' || u.source || ' (' || u.used_in || '): covered by ' || count(c.terms_for) || ' line(s) of terms'
  FROM (SELECT DISTINCT source, 'bills' AS used_in FROM copy_build.bills
        UNION SELECT DISTINCT source, 'stages' FROM copy_build.stages
        UNION SELECT DISTINCT source, 'sources' FROM copy_build.sources
        UNION SELECT label, 'the working list' FROM from_working.ref_source) u
  LEFT JOIN covered c ON c.source = u.source
 WHERE u.source IS NOT NULL
 GROUP BY u.source, u.used_in
HAVING count(c.terms_for) <> 1;
INSERT INTO problems
SELECT 11, 'terms ' || p.terms_for || ': covers does not say what the working list says'
  FROM copy_build.terms p
  LEFT JOIN from_working.source_terms t ON t.terms_for = p.terms_for
 WHERE p.covers IS DISTINCT FROM
       coalesce((SELECT string_agg(k.label, '; ' ORDER BY k.sort_order)
                   FROM from_working.ref_source k WHERE k.terms = t.code), t.covers_note);

-- The about file counts what is there.
INSERT INTO problems
SELECT 1, 'about: ' || a.file || ' says ' || a.rows || ' lines'
  FROM copy_build.about a
 WHERE a.rows IS DISTINCT FROM CASE a.file WHEN 'about' THEN (SELECT count(*) FROM files)
        ELSE (xpath('/row/c/text()', query_to_xml(format('SELECT count(*) AS c FROM copy_build.%I', a.file), false, true, '')))[1]::text::int END;

\echo ''
\echo '--- The check: problems found, by check'
SELECT check_no, count(*) AS problems FROM problems GROUP BY 1 ORDER BY 1;
\echo '--- The first 40'
SELECT check_no, detail FROM problems ORDER BY check_no, detail LIMIT 40;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM problems;
  IF n > 0 THEN
    RAISE EXCEPTION 'The check found % problem(s). Nothing has been kept.', n;
  END IF;
END $$;

-- ---------------------------------------------------------------------------
-- Put it live
-- ---------------------------------------------------------------------------

ALTER SCHEMA copy_build RENAME TO live;
COMMENT ON SCHEMA live IS 'The published copy, as taken on the day in its about file. What a reader''s page reads.';
GRANT USAGE ON SCHEMA live TO legdata;
GRANT SELECT ON ALL TABLES IN SCHEMA live TO legdata;

-- The working data is as it was.
DO $$
BEGIN
  IF (SELECT row(bills, stages, sources, sessions, notes, terms)::text FROM working_before) IS DISTINCT FROM
     (SELECT row((SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY bill_id)) FROM from_working.bill t),
                 (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY stage_event_id)) FROM from_working.stage_event t),
                 (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY field_source_id)) FROM from_working.field_source t),
                 (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY session_number)) FROM from_working.session t),
                 (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY code)) FROM from_working.methodology_note t),
                 (SELECT md5(string_agg(to_jsonb(t)::text, chr(10) ORDER BY code)) FROM from_working.source_terms t))::text) THEN
    RAISE EXCEPTION 'The working data changed while the copy was taken.';
  END IF;
END $$;

-- The connector's tables go; the next build brings them in again.
DO $$
DECLARE r record;
BEGIN
  FOR r IN SELECT foreign_table_name FROM information_schema.foreign_tables
            WHERE foreign_table_schema = 'from_working' LOOP
    EXECUTE format('DROP FOREIGN TABLE from_working.%I', r.foreign_table_name);
  END LOOP;
END $$;

\echo ''
\echo '--- The copy'
SELECT file, rows, date_copy_taken FROM live.about ORDER BY rows DESC;

\if :save
  COMMIT;
  \echo 'Kept: the copy is live.'
\else
  ROLLBACK;
  \echo 'Thrown away: save=false.'
\endif
