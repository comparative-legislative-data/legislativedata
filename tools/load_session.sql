-- load_session.sql
--
-- Puts one session's extracted factsheet lines onto the staging sheet, as new
-- lines waiting for review. Nothing is written to the clean sheet.
--
-- The extractor's CSV arrives on standard input, so the file is named in the
-- command rather than inside this script:
--
--   psql -d legdata -v session=2 -v save=false -f load_session.sql < s2.csv
--
--   -v session=2   which session the CSV must be, and nothing else
--   -v save=false  load it, show the result and its problems, throw it away
--   -v save=true   keep it
--
-- Neither has a default, so a mistyped run fails instead of guessing.
--
-- Refuses a session that already has staging lines. A second reading of the
-- same factsheet is something to compare against the first, not rows to add.
--
-- Staging line numbers are given out here, one after the highest already in
-- use, in the order the lines appear in the factsheet. Not from the sequence:
-- a rehearsal that is thrown away would still use up sequence numbers, and a
-- staging line's number becomes its bill's number (db/026).
--
-- A line from the Acts table also has its passing date put on the stage-dates
-- sheet (stage_candidate), as the completed third stage of its bill type's
-- sequence, arriving new like the line (db/033). The extractor is unchanged:
-- the date is read from its CSV's end_stage_3_date column.

-- A line from the Fallen table arrives with an empty outcome, because no
-- factsheet says why a bill fell. This script proposes fell_dissolution for one
-- that concluded on the day its session ended, and leaves every other fallen
-- bill empty for review (db/051).

\set ON_ERROR_STOP on

BEGIN;

CREATE TEMP TABLE load_arg ON COMMIT DROP AS SELECT :session::int AS session_number;

-- Every column as text, exactly as the extractor wrote it. line keeps the
-- factsheet's order.
CREATE TEMP TABLE extracted (
    line                  integer GENERATED ALWAYS AS IDENTITY,
    session_number        text,
    raw_title             text,
    raw_type              text,
    raw_date_introduced   text,
    raw_introduced_by     text,
    raw_date_final        text,
    raw_date_royal_assent text,
    raw_section           text,
    sp_bill_id            text,
    short_title           text,
    title_as_introduced   text,
    title_kind            text,
    bill_type             text,
    bill_type_stated      text,
    date_introduced       text,
    end_stage_3_date      text,
    date_concluded        text,
    date_royal_assent     text,
    asp_number            text,
    outcome               text,
    enactment_status      text,
    src_file              text,
    src_page              text,
    parser_note           text
) ON COMMIT DROP;

-- HEADER MATCH refuses a CSV whose columns are not exactly these, in this
-- order — for instance one written by an older version of the extractor.
\copy extracted (session_number, raw_title, raw_type, raw_date_introduced, raw_introduced_by, raw_date_final, raw_date_royal_assent, raw_section, sp_bill_id, short_title, title_as_introduced, title_kind, bill_type, bill_type_stated, date_introduced, end_stage_3_date, date_concluded, date_royal_assent, asp_number, outcome, enactment_status, src_file, src_page, parser_note) FROM pstdin WITH (FORMAT csv, HEADER MATCH)

-- ---------------------------------------------------------------------------
-- Before anything is written
-- ---------------------------------------------------------------------------

DO $$
DECLARE s integer; n integer;
BEGIN
  SELECT session_number INTO s FROM load_arg;

  SELECT count(*) INTO n FROM extracted;
  IF n = 0 THEN RAISE EXCEPTION 'Refusing to load: the CSV has no lines.'; END IF;

  SELECT count(*) INTO n FROM extracted WHERE session_number::int IS DISTINCT FROM s;
  IF n > 0 THEN RAISE EXCEPTION 'Refusing to load: % line(s) in the CSV are not Session %.', n, s; END IF;

  SELECT count(*) INTO n FROM bill_candidate WHERE session_number = s;
  IF n > 0 THEN RAISE EXCEPTION 'Refusing to load: Session % already has % staging line(s).', s, n; END IF;

  SELECT count(DISTINCT src_file) INTO n FROM extracted;
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing to load: the CSV comes from % files, not one.', n; END IF;

  -- The date the source was read comes from the file's name, which is how the
  -- factsheets are stored in sources/factsheets/.
  SELECT count(*) INTO n FROM extracted
   WHERE src_file IS NULL OR src_file !~ 'retrieved-\d{4}-\d{2}-\d{2}\.pdf$';
  IF n > 0 THEN RAISE EXCEPTION 'Refusing to load: the file name carries no retrieval date, so when the source was read is unknown.'; END IF;
END $$;

-- The highest staging line number in use before this load.
CREATE TEMP TABLE load_base ON COMMIT DROP AS
SELECT coalesce(max(candidate_id), 0) AS base FROM bill_candidate;

-- ---------------------------------------------------------------------------
-- The staging lines
-- ---------------------------------------------------------------------------

INSERT INTO bill_candidate (
    candidate_id, session_number,
    raw_title, raw_type, raw_date_introduced, raw_introduced_by,
    raw_date_final, raw_date_royal_assent, raw_section,
    sp_bill_id, short_title, title_as_introduced, title_kind,
    bill_type, bill_type_stated,
    date_introduced, date_concluded, date_royal_assent,
    asp_number, outcome, enactment_status,
    source, source_ref, observed_at, src_file, src_page, parser_note)
SELECT b.base + e.line,
       e.session_number::int,
       e.raw_title, e.raw_type, e.raw_date_introduced, e.raw_introduced_by,
       e.raw_date_final, e.raw_date_royal_assent, e.raw_section,
       e.sp_bill_id, e.short_title, e.title_as_introduced, e.title_kind,
       e.bill_type, e.bill_type_stated,
       e.date_introduced::date, e.date_concluded::date, e.date_royal_assent::date,
       e.asp_number, e.outcome, e.enactment_status,
       'spice_factsheet_legislation',
       'session ' || e.session_number || ', retrieved '
         || substring(e.src_file from 'retrieved-(\d{4}-\d{2}-\d{2})'),
       substring(e.src_file from 'retrieved-(\d{4}-\d{2}-\d{2})')::date,
       e.src_file, e.src_page::int, e.parser_note
  FROM extracted e CROSS JOIN load_base b
 ORDER BY e.line;

-- ---------------------------------------------------------------------------
-- The passing dates, onto the stage-dates sheet
-- ---------------------------------------------------------------------------

-- The completed third stage of the line's own sequence: Stage 3 for a public
-- or Hybrid Bill, Final Stage for a Private Bill. Same source, reference and
-- date read as the line.
INSERT INTO stage_candidate (candidate_id, stage, stage_order, date_completed,
                             completed, fell_here, source, source_ref, observed_at)
SELECT c.candidate_id, s.stage, 3, e.end_stage_3_date::date, true, false,
       c.source, c.source_ref, c.observed_at
  FROM extracted e
  CROSS JOIN load_base b
  JOIN bill_candidate c ON c.candidate_id = b.base + e.line
  LEFT JOIN ref_bill_type_stage s ON s.bill_type = c.bill_type AND s.stage_order = 3
 WHERE e.end_stage_3_date IS NOT NULL
 ORDER BY e.line;

-- ---------------------------------------------------------------------------
-- Checks. Any failure aborts, and nothing is written.
-- ---------------------------------------------------------------------------

DO $$
DECLARE s integer; n integer;
BEGIN
  SELECT session_number INTO s FROM load_arg;

  -- One staging line per CSV line.
  SELECT count(*) INTO n FROM bill_candidate WHERE session_number = s;
  IF n <> (SELECT count(*) FROM extracted) THEN
    RAISE EXCEPTION 'Check failed: % staging lines, % CSV lines.', n, (SELECT count(*) FROM extracted);
  END IF;

  -- One passing date on the stage-dates sheet per CSV line with one, and no
  -- other stage dates for the session.
  SELECT count(*) INTO n
    FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number = s;
  IF n <> (SELECT count(*) FROM extracted WHERE end_stage_3_date IS NOT NULL) THEN
    RAISE EXCEPTION 'Check failed: % stage-dates rows, % passing dates in the CSV.',
      n, (SELECT count(*) FROM extracted WHERE end_stage_3_date IS NOT NULL);
  END IF;

  -- Every staging line says exactly what the CSV said, dates included, and its
  -- passing date is the CSV's.
  SELECT count(*) INTO n
    FROM extracted e
   WHERE NOT EXISTS (
     SELECT 1 FROM bill_candidate c
      WHERE c.session_number = s
        AND c.raw_title             IS NOT DISTINCT FROM e.raw_title
        AND c.raw_type              IS NOT DISTINCT FROM e.raw_type
        AND c.raw_date_introduced   IS NOT DISTINCT FROM e.raw_date_introduced
        AND c.raw_introduced_by     IS NOT DISTINCT FROM e.raw_introduced_by
        AND c.raw_date_final        IS NOT DISTINCT FROM e.raw_date_final
        AND c.raw_date_royal_assent IS NOT DISTINCT FROM e.raw_date_royal_assent
        AND c.raw_section           IS NOT DISTINCT FROM e.raw_section
        AND c.sp_bill_id            IS NOT DISTINCT FROM e.sp_bill_id
        AND c.short_title           IS NOT DISTINCT FROM e.short_title
        AND c.title_as_introduced   IS NOT DISTINCT FROM e.title_as_introduced
        AND c.title_kind            IS NOT DISTINCT FROM e.title_kind
        AND c.bill_type             IS NOT DISTINCT FROM e.bill_type
        AND c.bill_type_stated      IS NOT DISTINCT FROM e.bill_type_stated
        AND c.date_introduced::text   IS NOT DISTINCT FROM e.date_introduced
        AND (SELECT t.date_completed::text FROM stage_candidate t
              WHERE t.candidate_id = c.candidate_id AND t.stage_order = 3)
                                      IS NOT DISTINCT FROM e.end_stage_3_date
        AND c.date_concluded::text    IS NOT DISTINCT FROM e.date_concluded
        AND c.date_royal_assent::text IS NOT DISTINCT FROM e.date_royal_assent
        AND c.asp_number            IS NOT DISTINCT FROM e.asp_number
        AND c.outcome               IS NOT DISTINCT FROM e.outcome
        AND c.enactment_status      IS NOT DISTINCT FROM e.enactment_status
        AND c.src_page::text        IS NOT DISTINCT FROM e.src_page
        AND c.parser_note           IS NOT DISTINCT FROM e.parser_note);
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % CSV line(s) did not arrive on the staging sheets unchanged.', n; END IF;

  RAISE NOTICE 'All checks passed.';
END $$;

-- ---------------------------------------------------------------------------
-- Why a bill fell: the one reason that can be worked out
-- ---------------------------------------------------------------------------

-- The factsheet says which bills fell and never why, so the reader leaves the
-- outcome of every fallen bill empty. One reason can be worked out, and this is
-- where it is done, because this is where both dates are: a bill that concluded
-- on the day its session ended ran out of time.
--
-- It sits here and not in the reader because the reader sees one PDF and
-- nothing else. The day a session ended is on the session tab, from the SPICe
-- dates factsheet, with its own provenance note. Until 2026-09-12 the reader
-- was handed that date on the command line, which made the coding of seven
-- bills depend on something recorded nowhere. See db/051 and M7.
--
-- Deliberately one-way. A fallen bill that concluded on any other day keeps an
-- empty outcome and waits for review, and the error checker will not let an
-- empty outcome be accepted. Nothing here overrides a value already present.
--
-- It runs after the check above, so "the reader's rows arrived unchanged" is
-- proved against the CSV before anything of ours is added to them.
UPDATE bill_candidate c
   SET outcome = 'fell_dissolution'
  FROM load_arg a
  JOIN session s ON s.session_number = a.session_number
 WHERE c.session_number = a.session_number
   AND c.raw_section = 'fallen'
   AND c.outcome IS NULL
   AND c.date_concluded IS NOT NULL
   AND s.date_session_end IS NOT NULL
   AND c.date_concluded = s.date_session_end;

-- ---------------------------------------------------------------------------
-- What you are being asked to keep
-- ---------------------------------------------------------------------------

\echo ''
\echo '--- Lines by factsheet table and type letter (compare with the factsheet''s own summary)'
SELECT coalesce(c.raw_section, 'TOTAL') AS factsheet_table,
       count(*) FILTER (WHERE c.raw_type IN ('E','G','G*')) AS executive_or_government,
       count(*) FILTER (WHERE c.raw_type = 'M') AS members,
       count(*) FILTER (WHERE c.raw_type = 'P') AS private,
       count(*) FILTER (WHERE c.raw_type = 'C') AS committee,
       count(*) FILTER (WHERE c.raw_type = 'H') AS hybrid,
       count(*) FILTER (WHERE c.raw_type NOT IN ('E','G','G*','M','P','C','H')
                           OR c.raw_type IS NULL) AS unrecognised,
       count(*) AS total
  FROM bill_candidate c JOIN load_arg a USING (session_number)
 GROUP BY GROUPING SETS ((c.raw_section), ())
 ORDER BY c.raw_section NULLS LAST;

\echo '--- Bills the factsheet says fell: what was proposed, and what waits for you'
SELECT c.candidate_id, c.short_title, c.date_concluded,
       s.date_session_end AS session_ended,
       coalesce(c.outcome, '(empty - your judgement)') AS outcome
  FROM bill_candidate c JOIN load_arg a USING (session_number)
  LEFT JOIN session s USING (session_number)
 WHERE c.raw_section = 'fallen'
 ORDER BY c.candidate_id;

\echo '--- Passing dates put on the stage-dates sheet, by stage name'
SELECT t.stage, t.stage_order, t.source, t.review_status, count(*)
  FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
  JOIN load_arg a ON a.session_number = c.session_number
 GROUP BY 1,2,3,4 ORDER BY 2,1;

\echo '--- Taken out of a title: SP Bill numbers and introduced titles'
SELECT c.candidate_id, c.sp_bill_id, c.short_title, c.title_as_introduced
  FROM bill_candidate c JOIN load_arg a USING (session_number)
 WHERE c.sp_bill_id IS NOT NULL OR c.title_as_introduced IS NOT NULL
 ORDER BY c.candidate_id;

\echo '--- Problems the error checker finds (these are the review list)'
SELECT p.candidate_id, p.short_title, p.problem
  FROM v_candidate_problems p JOIN load_arg a USING (session_number)
 ORDER BY p.candidate_id, p.problem;

\echo '--- Staging line numbers given out, and where the source is recorded'
SELECT min(c.candidate_id) AS first_line, max(c.candidate_id) AS last_line, count(*) AS lines,
       c.source_ref, c.observed_at
  FROM bill_candidate c JOIN load_arg a USING (session_number)
 GROUP BY c.source_ref, c.observed_at;

\echo ''
\if :save
  \echo '=== SAVING'
  -- Keep the sequence ahead of the numbers given out above, so a line added
  -- by hand later cannot collide with one.
  SELECT setval('bill_candidate_candidate_id_seq', (SELECT max(candidate_id) FROM bill_candidate));
  COMMIT;
\else
  \echo '=== NOT SAVING - discarding everything above'
  ROLLBACK;
\endif
