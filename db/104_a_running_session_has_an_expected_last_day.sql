-- db/104_a_running_session_has_an_expected_last_day.sql
--
-- Settled by the owner on 2026-09-17: chart 5, bills introduced in each quarter
-- of a session, measures Session 7 to an estimated last day, explained upfront.
-- All nine parts were agreed before this was written; they are the last section
-- of docs/PHASE-2-CALCULATIONS.md, with M14's wording as approved.
--
-- WHY A CELL OF ITS OWN. date_session_end is treated as fact. The error checker
-- tests a bill coded as fallen at dissolution against it, and promotion writes
-- that bill's provenance from it. An estimate there would be checked as if it
-- were fact, and "empty means the session is still running" would stop being
-- true. So the estimate sits beside the real last day and nothing that reads
-- the real one is changed. Nothing but chart 5's calculation, not yet built,
-- will read this cell.
--
-- THE DATE, 1 APRIL 2031, IS WORKED OUT, NOT STATED ANYWHERE.
--   * Scotland Act 1998 s2(2): the poll is on the first Thursday in May in the
--     fifth calendar year after the previous ordinary general election. That
--     was 7 May 2026, so the poll is due on 1 May 2031.
--   * s2(3)-(4): the Parliament is dissolved at the beginning of the "minimum
--     period" ending with polling day, set by order under s12(1).
--   * Scottish Parliament (Elections etc.) Order 2015 (SSI 2015/425) art 84: 20
--     days, since SSI 2025/313 art 10 replaced 28, computed under sch 2 rule 2,
--     which leaves out weekends, Christmas Eve, Christmas Day, Good Friday,
--     Easter Monday and Scottish bank holidays.
--   * Counting back 20 such days from 1 May 2031, and leaving out Good Friday
--     (11 April) and Easter Monday (14 April), the period begins on 2 April. The
--     last day is 1 April 2031.
--   * The same count from the poll of 7 May 2026 gives 8 April 2026, which is
--     Session 6's recorded last day, taken from SPICe by db/048. The rule is
--     checked against the one session held under it.
-- Copies of the three pages are kept in sources/legislation/, retrieved
-- 2026-09-17.
--
-- WHAT WOULD MOVE IT: a poll moved by proclamation under s2(5), an
-- extraordinary general election, a clash with a UK general election (s2(2A)),
-- or the rules changing. M14 tells a reader so.

\set ON_ERROR_STOP on
BEGIN;

-- ---------------------------------------------------------------------------
-- 0. Refuse to run on anything but the database as it stands
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM information_schema.columns
   WHERE table_schema = 'public' AND table_name = 'session'
     AND column_name = 'date_session_end_expected';
  IF n > 0 THEN RAISE EXCEPTION 'Refusing: session already has date_session_end_expected.'; END IF;

  SELECT count(*) INTO n FROM session
   WHERE session_number = 7 AND is_current AND date_session_end IS NULL
     AND date_first_meeting = DATE '2026-05-14';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: Session 7 is not the running session with no last day it was.'; END IF;

  SELECT count(*) INTO n FROM session WHERE date_session_end IS NULL;
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: % sessions have no last day, expected only Session 7.', n; END IF;

  SELECT count(*) INTO n FROM methodology_note WHERE code = 'M14' OR sort_order = 14;
  IF n > 0 THEN RAISE EXCEPTION 'Refusing: M14, or a note at sort_order 14, already exists.'; END IF;

  SELECT count(*) INTO n FROM bill;
  IF n <> 470 THEN RAISE EXCEPTION 'Refusing: % bills, expected 470.', n; END IF;
  SELECT count(*) INTO n FROM stage_event;
  IF n <> 1291 THEN RAISE EXCEPTION 'Refusing: % stage records, expected 1291.', n; END IF;
  SELECT count(*) INTO n FROM field_source;
  IF n <> 186 THEN RAISE EXCEPTION 'Refusing: % provenance notes, expected 186.', n; END IF;
  SELECT count(*) INTO n FROM methodology_note;
  IF n <> 13 THEN RAISE EXCEPTION 'Refusing: % methodology notes, expected 13.', n; END IF;
END $$;

-- ---------------------------------------------------------------------------
-- 1. The cell
-- ---------------------------------------------------------------------------

ALTER TABLE session ADD COLUMN date_session_end_expected date;

COMMENT ON COLUMN session.date_session_end_expected IS
 'The day a session still running is expected to end, worked out from the law on when the next election is held and when the Parliament is dissolved before it. An estimate, never a fact: it is used to divide a running session into quarters and for nothing else, and the real last day is date_session_end. Filled for the running session and only for it. Empty means the session has ended and its real last day is recorded; when a session ends, its last day goes in and this comes out in the same change. See methodology note M14.';

-- ---------------------------------------------------------------------------
-- 2. Session 7's expected last day, what the database refuses, and where it
--    came from
-- ---------------------------------------------------------------------------

UPDATE session SET date_session_end_expected = DATE '2031-04-01'
 WHERE session_number = 7;

-- The refusals go on once Session 7 holds its date, since the first one would
-- otherwise refuse the empty cell the column starts with.
-- A session has a real last day or an expected one, never both and never neither.
ALTER TABLE session ADD CONSTRAINT session_expected_end_only_while_running
  CHECK ((date_session_end IS NULL) = (date_session_end_expected IS NOT NULL));

ALTER TABLE session ADD CONSTRAINT session_expected_end_after_first_meeting
  CHECK (date_session_end_expected IS NULL OR date_first_meeting IS NULL
         OR date_session_end_expected > date_first_meeting);

INSERT INTO field_source (entity, entity_id, field_name, source, source_ref, value_seen, observed_at, note)
VALUES ('session', 7, 'date_session_end_expected', 'legislation_gov_uk',
        'Scotland Act 1998 s2(2)-(4); Scottish Parliament (Elections etc.) Order 2015 (SSI 2015/425) art 84, as amended by SSI 2025/313 art 10, and sch 2 rule 2 (computation of time)',
        NULL, DATE '2026-09-17',
        'Worked out, not stated. The poll is due on 1 May 2031. Counting back the 20 days that end on polling day, leaving out weekends, Good Friday (11 April 2031) and Easter Monday (14 April 2031), the Parliament is dissolved at the start of 2 April 2031, so the last day is 1 April 2031. The same count from the poll of 7 May 2026 gives 8 April 2026, Session 6''s recorded last day. Copies of the three pages are kept in sources/legislation/.');

-- ---------------------------------------------------------------------------
-- 3. What a reader is told: M14, as the owner approved it on 2026-09-17
-- ---------------------------------------------------------------------------

INSERT INTO methodology_note (code, title, body, applies_to, sort_order)
VALUES (
  'M14',
  'Session 7 is measured to the day it is expected to end',
  'Session 7 has not ended, so its last day is not yet known. To divide it into quarters we use the day it is expected to end: 1 April 2031.

The next election is due on 1 May 2031, the first Thursday in May five years after the last (Scotland Act 1998, section 2). The Parliament is dissolved at the start of the 20 days that end on polling day, not counting weekends and public holidays, and 1 April 2031 is the last day before that. Counted the same way, the rule gives Session 6''s actual last day, 8 April 2026.

The date can move: the poll can be brought forward or put back by proclamation, or an early election held. Until the session ends, its quarters are an estimate, and its later quarters hold only the bills introduced so far. When it ends, its real last day replaces the estimate and its figures are worked out again.',
  ARRAY['session.date_session_end_expected'],
  14
);

-- ---------------------------------------------------------------------------
-- 4. Proof that it took, and that nothing else moved
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM session
   WHERE date_session_end_expected IS NOT NULL;
  IF n <> 1 THEN RAISE EXCEPTION '% sessions carry an expected last day, expected 1.', n; END IF;

  SELECT count(*) INTO n FROM session
   WHERE session_number = 7 AND date_session_end_expected = DATE '2031-04-01'
     AND date_session_end IS NULL AND is_current;
  IF n <> 1 THEN RAISE EXCEPTION 'Session 7 does not read as running with 1 April 2031 expected.'; END IF;

  SELECT count(*) INTO n FROM field_source
   WHERE entity = 'session' AND entity_id = 7 AND field_name = 'date_session_end_expected';
  IF n <> 1 THEN RAISE EXCEPTION '% provenance notes for the expected last day, expected 1.', n; END IF;

  SELECT count(*) INTO n FROM methodology_note;
  IF n <> 14 THEN RAISE EXCEPTION '% methodology notes, expected 14.', n; END IF;

  SELECT count(*) INTO n FROM methodology_note
   WHERE code <> 'M14' AND updated_at >= now() - INTERVAL '5 minutes'
     AND updated_at > created_at + INTERVAL '1 second';
  IF n > 0 THEN RAISE EXCEPTION '% other note(s) were changed by this migration.', n; END IF;

  SELECT count(*) INTO n FROM bill;
  IF n <> 470 THEN RAISE EXCEPTION '% bills, expected 470.', n; END IF;
  SELECT count(*) INTO n FROM stage_event;
  IF n <> 1291 THEN RAISE EXCEPTION '% stage records, expected 1291.', n; END IF;
  SELECT count(*) INTO n FROM field_source;
  IF n <> 187 THEN RAISE EXCEPTION '% provenance notes, expected 187.', n; END IF;

  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n <> 0 THEN RAISE EXCEPTION 'The error checker finds % problem(s), expected none.', n; END IF;
  SELECT count(*) INTO n FROM v_stage_date_gaps;
  IF n <> 0 THEN RAISE EXCEPTION 'The gaps list holds % row(s), expected none.', n; END IF;

  RAISE NOTICE 'Session 7 expects to end on 1 April 2031; M14 added. Nothing else changed.';
END $$;

COMMIT;
