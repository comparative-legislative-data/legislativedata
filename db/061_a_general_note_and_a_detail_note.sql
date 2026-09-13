-- db/061_a_general_note_and_a_detail_note.sql
--
-- The owner's ruling of 2026-09-13, built. A stage row carries two notes where
-- it carried one: a general note, the same words every time, and a detail note
-- holding whatever a source records beyond it. See DECISIONS.md.
--
-- What this fixes. Nineteen bills stopped at a stage without the Parliament
-- deciding anything -- withdrawn by the member in charge, or still at that
-- stage when the session ended. They are the only stage rows with no date, and
-- the note on each exists to account for the empty cell. Written by hand, one
-- session at a time, they came out in eight different wordings for one
-- situation, two of them contradicting each other about the same fact: the
-- Session 3 bills that fell at dissolution say "during Stage 1" and "before a
-- Stage 1 debate took place" of two bills in identical positions.
--
-- Why a column that fills itself in. The general note is a restatement of the
-- row it sits on and is not an observation of anything, so it is not typed and
-- has no provenance. There is one place its words live, and a later session
-- cannot word it a ninth way. What the note says is exactly what the row says:
-- this is where the bill ended, there is no date, and the stage is not one the
-- bill never had.
--
-- A bill rejected at Stage 1 or Stage 3 gets no general note and never did.
-- Its rejection is the explanation, it carries the date of the decision, and
-- the row accounts for itself.
--
-- The two Robin Rigg stages that never happened keep the note they have. That
-- bill was reintroduced in Session 2 and did not repeat its earlier scrutiny;
-- it is not a bill that stopped without a decision, and db/039 gave it its own
-- handling.
--
-- Nothing moves on the clean sheet but wording. No date, no outcome, no coding,
-- no count. Every bill already coded this way is rechecked here, and the two
-- sheets are left saying the same words, so taking a session off and putting it
-- back reproduces them.

\set ON_ERROR_STOP on
BEGIN;

-- What is there before this, so the migration proves its own effect.
CREATE TEMP TABLE before_counts ON COMMIT DROP AS
SELECT (SELECT count(*) FROM stage_event)                                  AS stage_rows,
       (SELECT count(*) FROM stage_event WHERE note IS NOT NULL)           AS with_a_note,
       (SELECT count(*) FROM stage_event
         WHERE fell_here AND date_completed IS NULL AND NOT did_not_happen) AS stopped_without_a_decision,
       (SELECT count(DISTINCT note) FROM stage_event
         WHERE fell_here AND date_completed IS NULL AND NOT did_not_happen) AS wordings;

DO $$
DECLARE b record;
BEGIN
  SELECT * INTO b FROM before_counts;
  IF b.stopped_without_a_decision <> 19 THEN
    RAISE EXCEPTION 'Refusing: expected 19 rows that stopped without a decision, found %.',
                    b.stopped_without_a_decision;
  END IF;
  RAISE NOTICE 'Before: % stage rows, % with a note, % stopped without a decision in % wordings.',
               b.stage_rows, b.with_a_note, b.stopped_without_a_decision, b.wordings;
END $$;

-- ---------------------------------------------------------------------------
-- 1. The note that is there becomes the detail note, on both sheets
--
--    A rename, not a new column: nothing is copied, nothing can be lost, and
--    the views and checks that read it follow the name on their own.
-- ---------------------------------------------------------------------------

ALTER TABLE stage_event     RENAME COLUMN note TO detail_note;
ALTER TABLE stage_candidate RENAME COLUMN note TO detail_note;

ALTER TABLE stage_event
  RENAME CONSTRAINT stage_event_undated_completion_has_a_note
                 TO stage_event_undated_completion_has_a_detail_note;

-- ---------------------------------------------------------------------------
-- 2. The general note
--
--    It is not stored by anybody: the database works it out from the row and
--    keeps it beside it, so it reads like any other column and cannot drift.
-- ---------------------------------------------------------------------------

ALTER TABLE stage_event
  ADD COLUMN general_note text
  GENERATED ALWAYS AS (
    CASE WHEN fell_here AND date_completed IS NULL AND NOT did_not_happen
         THEN 'The bill stopped at this stage without a decision, so no date is recorded.'
    END) STORED;

-- ---------------------------------------------------------------------------
-- 3. Every row already coded this way, rechecked
--
--    The general sentence comes out of each detail note. What is left is what
--    a source recorded beyond it, and where nothing was, the detail note is
--    emptied. The Gaelic Language Bill's Stage 1 remark comes off: the row
--    already says the stage was completed and on what day, and its Stage 2
--    detail now carries the fact.
-- ---------------------------------------------------------------------------

CREATE TEMP TABLE rewrite (
  session_number integer, title_fragment text, stage text, detail_note text
) ON COMMIT DROP;

INSERT INTO rewrite VALUES
 (1, 'Gaelic Language',                   'stage_1', NULL),
 (1, 'Gaelic Language',                   'stage_2',
     'The general principles were agreed at Stage 1 on 6 March 2003, but no Stage 2 '
  || 'proceedings were scheduled for the bill, and it fell at the end of the session.'),
 (1, 'Robin Rigg',                        'final',       NULL),
 (1, 'Stirling-Alloa-Kincardine',         'preliminary', NULL),
 (1, 'Education (Graduate Endowment and Student Support) (Scotland) Bill', 'stage_1',
     'Withdrawn during Stage 1 consideration, before the Stage 1 vote, and reintroduced '
  || 'in redrafted form.'),
 (1, 'Family Homes and Homelessness',     'stage_1', NULL),
 (1, 'Tobacco Advertising',               'stage_1',
     'No Stage 1 debate took place, so the dataset’s Stage 1 date is not a completed stage.'),

 (2, 'Commissioner for Older People',     'stage_1', 'No timetable for concluding Stage 1 was set.'),
 (2, 'Education (School Meals etc) (Scotland) Bill', 'stage_1', 'Partial scrutiny was undertaken, with no Stage 1 vote.'),
 (2, 'Home Energy Efficiency Targets',    'stage_1', NULL),
 (2, 'Treatment of Drug Users',           'stage_1', NULL),
 (2, 'Environmental Levy on Plastic Bags','stage_1', 'Withdrawn after the Stage 1 report and before the Stage 1 debate.'),
 (2, 'Fire Sprinklers',                   'stage_1', NULL),
 (2, 'Prohibition of Smoking in Regulated Areas', 'stage_1', NULL),
 (2, 'Prostitution Tolerance Zones',      'stage_1', NULL),
 (2, 'Scottish Register of Tartans',      'stage_1', 'Withdrawn before the Stage 1 debate.'),

 (3, 'Commissioner for Victims and Witnesses', 'stage_1', NULL),
 (3, 'Long Leases',                       'stage_1', NULL),
 (3, 'Criminal Sentencing (Equity Fines)','stage_1',
     'Withdrawn by the member in charge on 25 November 2010, before the Stage 1 debate was held.'),
 (3, 'Palliative Care',                   'stage_1',
     'Withdrawn by the member in charge on 2 December 2010, before the Stage 1 debate was held.');

-- Two titles are given in full rather than as a fragment: each session holds
-- both the bill that was withdrawn and a later Act of nearly the same name,
-- and a fragment matched both. The guard below caught it.
-- Each line must name exactly one stage row. A fragment that matches two bills,
-- or none, must fail here rather than write to the wrong bill or silently miss.
CREATE TEMP TABLE target ON COMMIT DROP AS
SELECT r.session_number, r.title_fragment, r.stage, r.detail_note,
       e.stage_event_id, b.short_title, e.detail_note AS was
  FROM rewrite r
  JOIN bill b ON b.session_number = r.session_number
             AND b.short_title ILIKE '%' || r.title_fragment || '%'
  JOIN stage_event e ON e.bill_id = b.bill_id AND e.stage = r.stage;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM rewrite;
  IF n <> 20 THEN RAISE EXCEPTION 'Refusing: expected 20 rewrite lines, found %.', n; END IF;

  SELECT count(*) INTO n FROM target;
  IF n <> 20 THEN
    RAISE EXCEPTION 'Refusing: 20 rewrite lines named % stage row(s); each must name exactly one.', n;
  END IF;

  -- Every row that gets the general note is in the list, and no row is in the
  -- list that should not be touched.
  SELECT count(*) INTO n
    FROM stage_event e
   WHERE e.fell_here AND e.date_completed IS NULL AND NOT e.did_not_happen
     AND e.stage_event_id NOT IN (SELECT stage_event_id FROM target);
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % row(s) stopped without a decision and are not in the rewrite list.', n;
  END IF;
END $$;

UPDATE stage_event e
   SET detail_note = nullif(btrim(t.detail_note), '')
  FROM target t
 WHERE e.stage_event_id = t.stage_event_id;

-- The staging sheet says the same words, so promotion reproduces them. The link
-- is the stamp promotion left, not a second search by title.
UPDATE stage_candidate c
   SET detail_note = nullif(btrim(t.detail_note), '')
  FROM target t
 WHERE c.promoted_stage_event_id = t.stage_event_id;

-- ---------------------------------------------------------------------------
-- 4. What each column holds
-- ---------------------------------------------------------------------------

COMMENT ON COLUMN stage_event.detail_note IS
 'The detail note: whatever a source records about this stage beyond what the row and the general note already say, carried from stage_candidate.detail_note at promotion. Required where a stage was completed on a date not known, to say why, and where a stage is recorded as one the bill never had; the database refuses either row without one. Called note until db/061, which split the one note in two. Empty means no extra detail has been collected for that bill — not that none exists, and not that any was sought.';

COMMENT ON COLUMN stage_event.general_note IS
 'The general note: one sentence, the same words every time, on a stage where the bill stopped without the Parliament deciding anything — withdrawn by the member in charge, or still at that stage when the session ended. It accounts for the empty date. Nobody types it and it has no provenance: the database writes it from this row, so it cannot be worded two ways. Empty means the row accounts for itself — a completed stage, a rejection, which carries the date of the decision, or a stage the bill never had.';

COMMENT ON COLUMN stage_candidate.detail_note IS
 'The detail note as proposed for this stage: whatever a source records beyond what the row itself says, carried onto stage_event.detail_note at promotion. Required for a stage completed on a date not known, to say why. There is no general note here, because nothing is typed for one: the clean sheet writes it from the row. Called note until db/061. Empty means no extra detail has been collected for that bill.';

-- ---------------------------------------------------------------------------
-- 5. What a reader is told
-- ---------------------------------------------------------------------------

UPDATE methodology_note SET body = replace(body,
 'Where a stage was completed but its date could not be established, it is recorded as completed with no date, and a note says why.',
 'Where a stage was completed but its date could not be established, it is recorded as completed with no date, and a detail note says why. '
 || 'Where a bill stopped at a stage without the Parliament deciding anything — withdrawn by the member in charge, or still at that stage when '
 || 'the session ended — the stage is recorded as not completed and has no date, there being no decision to date it from. Such a row carries a '
 || 'general note saying so, in the same words every time; it is written by the database from the row itself rather than typed, so one situation '
 || 'cannot be described two ways. A bill rejected at a stage carries no general note: its rejection is the explanation, and it has the date of '
 || 'the decision. A detail note sits beside the general note and holds whatever a source records beyond it; an empty detail note means no extra '
 || 'detail has been collected for that bill, not that none exists and not that any was sought.')
 WHERE code = 'M2';

UPDATE methodology_note
   SET applies_to = array_replace(applies_to, 'stage_event.note', 'stage_event.detail_note')
                    || ARRAY['stage_event.general_note']
 WHERE code = 'M2';

-- ---------------------------------------------------------------------------
-- Checks
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer; b record; w integer;
BEGIN
  SELECT * INTO b FROM before_counts;

  -- Nothing but wording moved.
  SELECT count(*) INTO n FROM stage_event;
  IF n <> b.stage_rows THEN RAISE EXCEPTION 'Stage rows changed from % to %.', b.stage_rows, n; END IF;

  SELECT count(*) INTO n FROM stage_event
   WHERE fell_here AND date_completed IS NULL AND NOT did_not_happen;
  IF n <> 19 THEN RAISE EXCEPTION 'Rows stopped without a decision changed from 19 to %.', n; END IF;

  -- All nineteen carry the general note, and only they do.
  SELECT count(*) INTO n FROM stage_event WHERE general_note IS NOT NULL;
  IF n <> 19 THEN RAISE EXCEPTION 'Expected 19 general notes, found %.', n; END IF;

  SELECT count(DISTINCT general_note) INTO w FROM stage_event WHERE general_note IS NOT NULL;
  IF w <> 1 THEN RAISE EXCEPTION 'The general note has % wordings; it must have one.', w; END IF;

  -- The assumption the general note rests on: every bill it speaks for stopped
  -- without a decision because it was withdrawn or ran out of time.
  SELECT count(*) INTO n
    FROM stage_event e JOIN bill bl USING (bill_id)
   WHERE e.general_note IS NOT NULL
     AND bl.outcome NOT IN ('withdrawn', 'fell_dissolution');
  IF n > 0 THEN
    RAISE EXCEPTION 'Check failed: % row(s) carry the general note for a bill that was neither withdrawn nor fell at dissolution.', n;
  END IF;

  -- No general note anywhere a decision dated the stage.
  SELECT count(*) INTO n FROM stage_event
   WHERE general_note IS NOT NULL AND date_completed IS NOT NULL;
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % general note(s) on a dated stage.', n; END IF;

  -- The two sheets say the same words, so promotion reproduces them.
  SELECT count(*) INTO n
    FROM stage_candidate c JOIN stage_event e ON e.stage_event_id = c.promoted_stage_event_id
   WHERE c.detail_note IS DISTINCT FROM e.detail_note;
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % stage-dates row(s) disagree with the clean sheet about the detail note.', n; END IF;

  -- The rows nobody asked us to touch are untouched.
  SELECT count(*) INTO n FROM stage_event
   WHERE did_not_happen AND detail_note NOT LIKE '%reintroduced in Session 2%';
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % stage(s) that never happened lost the note explaining it.', n; END IF;

  SELECT count(*) INTO n FROM stage_event e JOIN bill bl USING (bill_id)
   WHERE bl.outcome IN ('rejected_stage_1', 'rejected_stage_3')
     AND (e.general_note IS NOT NULL OR e.detail_note IS NOT NULL);
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % rejected bill(s) gained a note they never had.', n; END IF;

  -- The error checker and the gaps list are still empty.
  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n > 0 THEN RAISE EXCEPTION 'The error checker is no longer empty: % problem(s).', n; END IF;
  SELECT count(*) INTO n FROM v_stage_date_gaps;
  IF n > 0 THEN RAISE EXCEPTION 'The gaps list is no longer empty: % gap(s).', n; END IF;

  -- M2 says it.
  SELECT count(*) INTO n FROM methodology_note
   WHERE code = 'M2' AND body LIKE '%written by the database from the row itself%';
  IF n <> 1 THEN RAISE EXCEPTION 'M2 was not amended: the sentence it was anchored on has changed.'; END IF;

  SELECT count(*) INTO n FROM methodology_note
   WHERE code = 'M2' AND applies_to @> ARRAY['stage_event.detail_note', 'stage_event.general_note']
     AND NOT applies_to @> ARRAY['stage_event.note'];
  IF n <> 1 THEN RAISE EXCEPTION 'M2 does not name both notes and only them.'; END IF;

  RAISE NOTICE 'After: 19 rows carry one general note in one wording; % detail note(s) remain.',
               (SELECT count(*) FROM stage_event WHERE detail_note IS NOT NULL);
END $$;

COMMIT;
