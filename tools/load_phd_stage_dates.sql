-- load_phd_stage_dates.sql
--
-- Puts the owner's PhD stage dates on the stage-dates sheet, as new rows
-- waiting for review, from the CSV written by tools/phd_stage_dates.py.
-- Nothing is written to the clean sheet.
--
--   psql -d legdata -v save=false -f load_phd_stage_dates.sql < phd_rows.csv
--
--   -v save=false  load it, show the result and its problems, throw it away
--   -v save=true   keep it
--
-- No default, so a mistyped run fails instead of guessing.
--
-- Every row must name a staging line whose title matches the one in the CSV,
-- which is the check that a line number is the bill it claims to be. A stage
-- already held from the same source is skipped if it says exactly the same
-- thing, and refused if it does not, so a second run changes nothing.
--
-- One row kind is not a stage: a note to carry onto the bill for a reader,
-- which goes on the staging line (bill_note).

\set ON_ERROR_STOP on

BEGIN;

CREATE TEMP TABLE incoming (
    kind           text,
    line           integer,
    short_title    text,
    stage          text,
    stage_order    integer,
    date_completed date,
    completed      boolean,
    fell_here      boolean,
    source         text,
    source_ref     text,
    observed_at    date,
    note           text
) ON COMMIT DROP;

\copy incoming (kind, line, short_title, stage, stage_order, date_completed, completed, fell_here, source, source_ref, observed_at, note) FROM pstdin WITH (FORMAT csv, HEADER MATCH)

-- ---------------------------------------------------------------------------
-- Before anything is written
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer; bad text;
BEGIN
  SELECT count(*) INTO n FROM incoming;
  IF n = 0 THEN RAISE EXCEPTION 'Refusing to load: the CSV has no rows.'; END IF;

  SELECT count(*) INTO n FROM incoming WHERE kind NOT IN ('stage', 'bill_note');
  IF n > 0 THEN RAISE EXCEPTION 'Refusing to load: % row(s) are of an unknown kind.', n; END IF;

  -- Every row names a staging line, and the title it claims is that line's.
  SELECT count(*) INTO n FROM incoming i LEFT JOIN bill_candidate c ON c.candidate_id = i.line
   WHERE c.candidate_id IS NULL;
  IF n > 0 THEN RAISE EXCEPTION 'Refusing to load: % row(s) name a staging line that does not exist.', n; END IF;

  SELECT string_agg(i.line || ' (' || i.short_title || ' / ' || c.short_title || ')', '; ')
    INTO bad
    FROM incoming i JOIN bill_candidate c ON c.candidate_id = i.line
   WHERE i.short_title IS DISTINCT FROM c.short_title;
  IF bad IS NOT NULL THEN
    RAISE EXCEPTION 'Refusing to load: the title does not match the staging line for %', bad;
  END IF;

  -- Stage rows: a stage name and position that fit the bill, a source on the
  -- list, and a date read.
  SELECT count(*) INTO n FROM incoming i JOIN bill_candidate c ON c.candidate_id = i.line
   WHERE i.kind = 'stage'
     AND NOT EXISTS (SELECT 1 FROM ref_bill_type_stage s
                      WHERE s.bill_type = c.bill_type AND s.stage = i.stage
                        AND s.stage_order = i.stage_order);
  IF n > 0 THEN RAISE EXCEPTION 'Refusing to load: % stage row(s) name a stage that does not belong to the bill at that position.', n; END IF;

  SELECT count(*) INTO n FROM incoming i
   WHERE i.kind = 'stage'
     AND (i.completed IS NULL OR i.fell_here IS NULL OR i.observed_at IS NULL
          OR NOT EXISTS (SELECT 1 FROM ref_source r WHERE r.code = i.source));
  IF n > 0 THEN RAISE EXCEPTION 'Refusing to load: % stage row(s) lack a source on the list, a date read, or one of the two marks.', n; END IF;

  -- Nothing dated before the bill was introduced, or after it concluded.
  SELECT count(*) INTO n FROM incoming i JOIN bill_candidate c ON c.candidate_id = i.line
   WHERE i.kind = 'stage' AND i.date_completed IS NOT NULL
     AND (i.date_completed < c.date_introduced
          OR (c.date_concluded IS NOT NULL AND i.date_completed > c.date_concluded));
  IF n > 0 THEN RAISE EXCEPTION 'Refusing to load: % stage date(s) fall outside the bill''s own dates.', n; END IF;

  -- A stage already held from the same source must say exactly the same thing.
  SELECT string_agg(t.candidate_id || ' ' || t.stage, '; ') INTO bad
    FROM incoming i JOIN stage_candidate t
      ON t.candidate_id = i.line AND t.stage_order = i.stage_order AND t.source = i.source
   WHERE i.kind = 'stage'
     AND (t.date_completed IS DISTINCT FROM i.date_completed
          OR t.completed IS DISTINCT FROM i.completed
          OR t.fell_here IS DISTINCT FROM i.fell_here
          OR t.stage IS DISTINCT FROM i.stage);
  IF bad IS NOT NULL THEN
    RAISE EXCEPTION 'Refusing to load: these stages are already held from the same source, saying something different: %', bad;
  END IF;

  -- A note for a bill does not overwrite a different note already there.
  SELECT string_agg(c.candidate_id::text, '; ') INTO bad
    FROM incoming i JOIN bill_candidate c ON c.candidate_id = i.line
   WHERE i.kind = 'bill_note' AND c.bill_note IS NOT NULL AND c.bill_note IS DISTINCT FROM i.note;
  IF bad IS NOT NULL THEN
    RAISE EXCEPTION 'Refusing to load: line(s) % already carry a different note for the bill.', bad;
  END IF;
END $$;

-- ---------------------------------------------------------------------------
-- The rows
-- ---------------------------------------------------------------------------

CREATE TEMP TABLE already ON COMMIT DROP AS
SELECT i.line, i.stage_order
  FROM incoming i JOIN stage_candidate t
    ON t.candidate_id = i.line AND t.stage_order = i.stage_order AND t.source = i.source
 WHERE i.kind = 'stage';

INSERT INTO stage_candidate (candidate_id, stage, stage_order, date_completed, completed,
                             fell_here, source, source_ref, observed_at, note)
SELECT i.line, i.stage, i.stage_order, i.date_completed, i.completed, i.fell_here,
       i.source, i.source_ref, i.observed_at, nullif(i.note, '')
  FROM incoming i
 WHERE i.kind = 'stage'
   AND NOT EXISTS (SELECT 1 FROM already a WHERE a.line = i.line AND a.stage_order = i.stage_order)
 ORDER BY i.line, i.stage_order;

UPDATE bill_candidate c
   SET bill_note = i.note
  FROM incoming i
 WHERE i.kind = 'bill_note' AND c.candidate_id = i.line
   AND c.bill_note IS DISTINCT FROM i.note;

-- ---------------------------------------------------------------------------
-- Checks. Any failure aborts, and nothing is written.
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer;
BEGIN
  -- Every stage row in the CSV is now on the sheet, saying what the CSV said.
  SELECT count(*) INTO n FROM incoming i
   WHERE i.kind = 'stage'
     AND NOT EXISTS (SELECT 1 FROM stage_candidate t
                      WHERE t.candidate_id = i.line AND t.stage_order = i.stage_order
                        AND t.source = i.source AND t.stage = i.stage
                        AND t.date_completed IS NOT DISTINCT FROM i.date_completed
                        AND t.completed = i.completed AND t.fell_here = i.fell_here
                        AND t.observed_at = i.observed_at);
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % row(s) did not arrive as the CSV had them.', n; END IF;

  -- Everything new is waiting for review.
  SELECT count(*) INTO n FROM stage_candidate t JOIN incoming i
      ON i.kind = 'stage' AND t.candidate_id = i.line AND t.stage_order = i.stage_order
     AND t.source = i.source
   WHERE t.review_status <> 'new' AND t.promoted_at IS NULL;
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % loaded row(s) are not waiting for review.', n; END IF;

  -- The error checker must be empty, for both sessions and everything else.
  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n > 0 THEN
    RAISE EXCEPTION 'Check failed: the error checker finds % problem(s) after loading. Look at v_candidate_problems.', n;
  END IF;

  RAISE NOTICE 'All checks passed.';
END $$;

-- ---------------------------------------------------------------------------
-- What you are being asked to keep
-- ---------------------------------------------------------------------------

\echo ''
\echo '--- Rows loaded, by session and source (already-held rows are skipped)'
SELECT c.session_number, i.source, count(*) AS in_csv,
       count(*) FILTER (WHERE a.line IS NOT NULL) AS already_held,
       count(*) FILTER (WHERE a.line IS NULL) AS loaded
  FROM incoming i JOIN bill_candidate c ON c.candidate_id = i.line
  LEFT JOIN already a ON a.line = i.line AND a.stage_order = i.stage_order
 WHERE i.kind = 'stage'
 GROUP BY 1, 2 ORDER BY 1, 2;

\echo '--- Bills that did not pass: the stage each stopped at, and any it completed'
SELECT t.candidate_id AS line, left(t.short_title, 46) AS bill, t.stage,
       t.date_completed, t.completed, t.fell_here, t.source, left(t.note, 60) AS note
  FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
 WHERE c.outcome NOT IN ('passed', 'rejected_stage_1') AND t.source <> 'spice_factsheet'
 ORDER BY t.candidate_id, t.stage_order;

\echo '--- Notes carried onto a bill'
SELECT c.candidate_id AS line, left(c.short_title, 40) AS bill, left(c.bill_note, 90) AS note
  FROM bill_candidate c JOIN incoming i ON i.kind = 'bill_note' AND i.line = c.candidate_id;

\echo '--- Every bill''s stages now, first ten bills of each session'
SELECT c.session_number, t.candidate_id AS line, left(t.short_title, 40) AS bill,
       string_agg(t.stage || ' ' || coalesce(t.date_completed::text, 'no date')
                  || ' (' || t.source || ')', ', ' ORDER BY t.stage_order) AS stages
  FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
 WHERE t.candidate_id IN (SELECT candidate_id FROM bill_candidate b
                           WHERE b.session_number = c.session_number
                           ORDER BY candidate_id LIMIT 10)
 GROUP BY 1, 2, 3 ORDER BY 1, 2;

\echo '--- Dates still to find'
SELECT session_number, gap, count(*) AS gaps FROM v_stage_date_gaps GROUP BY 1, 2 ORDER BY 1, 2;

\echo '--- The error checker (empty is the target)'
SELECT candidate_id, stage_candidate_id, problem FROM v_candidate_problems ORDER BY 1, 2;

\echo ''
\if :save
  \echo '=== SAVING'
  COMMIT;
\else
  \echo '=== NOT SAVING - discarding everything above'
  ROLLBACK;
\endif
