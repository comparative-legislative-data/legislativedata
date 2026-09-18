-- db/115_the_sources_notes_name_what_a_reader_sees.sql
--
-- The notes on the provenance lines are published as the note column of the
-- sources file, and 92 of them named working columns, stored codes or a folder
-- in the repository, none of which a reader of the published copy can see.
-- Rewritten in the wording the owner agreed on 2026-09-18
-- (docs/PHASE-2-SOURCES-NOTES.md; DECISIONS.md, 2026-09-18).
--
-- WHAT CHANGES. The note, and nothing else, on 95 of the 192 lines:
--   A. 67 "Checked at review" notes stop pointing at the raw_ columns of the
--      staging sheet, which are not published;
--   B. 17 "fell at dissolution" notes name date_session_ended in the sessions
--      file, not session.date_session_end, and spell "fact sheet" as the notes
--      and definitions now do;
--   C. 6 notes on the bills the Session 6 fact sheet lists again quote the
--      word a reader sees in the cell ('Still blocked'), not the stored code
--      ('still_blocked');
--   D. the corrected title's note gives the fact sheet's words without naming
--      bill_candidate.raw_title;
--   E. Session 7's expected last day loses its pointer to sources/legislation/,
--      which a reader cannot follow once the repository is private; the three
--      pages are named in its source_ref.
-- And three more, found while building this: the three "Rewritten when Session
-- 6 was reviewed" notes showed every apostrophe doubled ("Parliament''s"),
-- because promotion quoted the old and new bill notes with quote_literal,
-- which escapes a quote for SQL rather than for a reader.
--
-- tools/promote_session.sql writes A, B, C, D and the "Rewritten" notes, and is
-- changed in the same commit to write the new wording, so a session taken off
-- and put back comes back as this leaves it. That was rehearsed by rebuilding
-- every session from the staging sheets inside a thrown-away transaction and
-- comparing it cell by cell with the result of this file.
--
-- WHAT DOES NOT CHANGE. Any other column of any provenance line; any bill,
-- stage record, value, definition or methodology note.

\set ON_ERROR_STOP on
BEGIN;

-- Refuse unless the notes are exactly as read on 2026-09-18, and hold a copy of
-- every other column to prove afterwards that none moved.
DO $$
BEGIN
  IF (SELECT md5(string_agg(field_source_id || chr(9) || coalesce(note, chr(1)), chr(10) ORDER BY field_source_id))
        FROM field_source) <> '688636fdde9599c57b6e4da6c1e92cc3' THEN
    RAISE EXCEPTION 'Refusing: the provenance notes are not the ones this was written against.';
  END IF;
END $$;

CREATE TEMP TABLE fs_before ON COMMIT DROP AS SELECT * FROM field_source;

DO $$
DECLARE n integer;
BEGIN
  -- A. Checked at review.
  UPDATE field_source
     SET note = 'Checked at review against the source named on this line, which is '
                'the one that settles this fact. Where the fact sheet printed it '
                'differently, this line''s value is the one used.'
   WHERE note = 'Checked at review against the source that owns this value. The '
                'factsheet''s own printed words are kept in the raw_ columns of '
                'bill_candidate.';
  GET DIAGNOSTICS n = ROW_COUNT;
  IF n <> 67 THEN RAISE EXCEPTION 'A: % notes, expected 67.', n; END IF;

  -- B. Fell at dissolution.
  UPDATE field_source
     SET note = replace(replace(note,
                  'Our coding, not the factsheet''s: the legislation factsheet says the bill fell and not why.',
                  'Our coding, not the fact sheet''s: the legislation fact sheet says the bill fell, and not why.'),
                  'That day is session.date_session_end, from the source cited here.',
                  'That day is date_session_ended in the sessions file, from the source cited here.')
   WHERE note LIKE 'Our coding, not the factsheet''s: the legislation factsheet says the bill fell and not why.%'
     AND note LIKE '%That day is session.date_session_end, from the source cited here. See methodology note M7.';
  GET DIAGNOSTICS n = ROW_COUNT;
  IF n <> 17 THEN RAISE EXCEPTION 'B: % notes, expected 17.', n; END IF;

  -- C. The codes a later fact sheet changed, quoted as their labels.
  WITH labels(field_name, code, label) AS (
         SELECT 'enactment_status', code, label FROM ref_enactment_status
         UNION ALL SELECT 'assent_block_outcome', code, label FROM ref_assent_block_outcome
         UNION ALL SELECT 'assent_block_route', code, label FROM ref_assent_block_route),
       parts AS (
         SELECT f.field_source_id,
                substring(f.note from 'It read ''([a-z_0-9]+)'' and now reads') AS was,
                substring(f.note from 'and now reads ''([a-z_0-9]+)''\. ') AS now_reads
           FROM field_source f
          WHERE f.note LIKE 'Read off the Session % fact sheet,%'
            AND f.field_name IN ('enactment_status', 'assent_block_outcome', 'assent_block_route'))
  UPDATE field_source f
     SET note = replace(f.note,
                  'It read ''' || p.was || ''' and now reads ''' || p.now_reads || '''.',
                  'It read ''' || lw.label || ''' and now reads ''' || ln.label || '''.')
    FROM parts p
    JOIN labels lw ON lw.code = p.was
    JOIN labels ln ON ln.code = p.now_reads
   WHERE f.field_source_id = p.field_source_id
     AND lw.field_name = f.field_name AND ln.field_name = f.field_name;
  GET DIAGNOSTICS n = ROW_COUNT;
  IF n <> 6 THEN RAISE EXCEPTION 'C: % notes, expected 6.', n; END IF;

  -- D. The corrected title.
  UPDATE field_source
     SET note = replace(note,
                  'Corrected at review. The factsheet''s wording is kept verbatim in bill_candidate.raw_title: ',
                  'Corrected at review. The fact sheet printed it as: ')
   WHERE note LIKE 'Corrected at review. The factsheet''s wording is kept verbatim in bill\_candidate.raw\_title: %';
  GET DIAGNOSTICS n = ROW_COUNT;
  IF n <> 1 THEN RAISE EXCEPTION 'D: % notes, expected 1.', n; END IF;

  -- E. Session 7's expected last day.
  UPDATE field_source
     SET note = replace(note, ' Copies of the three pages are kept in sources/legislation/.', '')
   WHERE entity = 'session' AND field_name = 'date_session_end_expected'
     AND note LIKE '% Copies of the three pages are kept in sources/legislation/.';
  GET DIAGNOSTICS n = ROW_COUNT;
  IF n <> 1 THEN RAISE EXCEPTION 'E: % notes, expected 1.', n; END IF;

  -- The doubled apostrophes in the three rewritten bill notes.
  UPDATE field_source
     SET note = replace(note, '''''', '''')
   WHERE note LIKE 'Rewritten when Session % was reviewed,%'
     AND note LIKE '%''''%';
  GET DIAGNOSTICS n = ROW_COUNT;
  IF n <> 3 THEN RAISE EXCEPTION 'Apostrophes: % notes, expected 3.', n; END IF;
END $$;

-- What must hold afterwards.
DO $$
DECLARE n integer;
BEGIN
  -- Only the note moved, and on exactly 95 lines.
  SELECT count(*) INTO n FROM field_source f JOIN fs_before b USING (field_source_id)
   WHERE f.note IS DISTINCT FROM b.note;
  IF n <> 95 THEN RAISE EXCEPTION '% notes changed, expected 95.', n; END IF;
  SELECT count(*) INTO n FROM field_source f FULL JOIN fs_before b USING (field_source_id)
   WHERE f.field_source_id IS NULL OR b.field_source_id IS NULL
      OR (f.entity, f.entity_id, f.field_name, f.source, f.source_ref, f.value_seen, f.observed_at, f.created_at)
         IS DISTINCT FROM (b.entity, b.entity_id, b.field_name, b.source, b.source_ref, b.value_seen, b.observed_at, b.created_at);
  IF n <> 0 THEN RAISE EXCEPTION '% lines changed in something other than the note.', n; END IF;

  -- No working name, stored code, folder or doubled quote left in a note.
  SELECT count(*) INTO n FROM field_source
   WHERE note ~ ('(raw_|bill_candidate|session\.date_session_end|sources/|factsheet|' || chr(39) || chr(39)
                 || '|' || chr(39) || '[a-z]+_[a-z_]+' || chr(39)
                 || '|' || chr(39) || '(blocked|enacted|pending|withdrawn)' || chr(39) || ')');
  IF n <> 0 THEN RAISE EXCEPTION '% notes still name something a reader cannot see.', n; END IF;

  SELECT count(*) INTO n FROM methodology_note; IF n <> 14 THEN RAISE EXCEPTION '% notes', n; END IF;
  SELECT count(*) INTO n FROM bill; IF n <> 470 THEN RAISE EXCEPTION '% bills', n; END IF;
  SELECT count(*) INTO n FROM stage_event; IF n <> 1291 THEN RAISE EXCEPTION '% stage records', n; END IF;
  SELECT count(*) INTO n FROM field_source; IF n <> 192 THEN RAISE EXCEPTION '% provenance notes', n; END IF;
  SELECT count(*) INTO n FROM v_candidate_problems; IF n <> 0 THEN RAISE EXCEPTION 'checker %', n; END IF;
  SELECT count(*) INTO n FROM v_stage_date_gaps; IF n <> 0 THEN RAISE EXCEPTION 'gaps %', n; END IF;

  RAISE NOTICE 'Ninety-five provenance notes rewritten for a reader; nothing else moved.';
END $$;

COMMIT;
