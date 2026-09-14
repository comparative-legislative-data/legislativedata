-- db/070_m7_says_four_sessions_are_coded.sql
--
-- M7 says the coding of why a bill fell has been done for Sessions 1, 2 and 3.
-- Session 4 was coded on 2026-09-13 and promoted the same day, so the note a
-- reader sees has been a session out of date since then. Found on 2026-09-14
-- while Session 4's Part B item 9 was being marked, which asks whether the
-- owner can explain the database from the documents alone; a methodology note
-- understating what the database holds is exactly what that item is for.
--
-- Two sentences change, and nothing else in M7 or in any other note.
--
--   "it has been done for Sessions 1, 2 and 3"  ->  "Sessions 1, 2, 3 and 4"
--   "One bill in the first three sessions ended this way"  ->  "first four"
--
-- The second is about the Creative Scotland Bill, the only bill that has fallen
-- for want of a financial resolution. It was true of three sessions and is true
-- of four: Session 4 added no second case. The sentence counts how far the
-- database has been looked at, not how many such bills exist, so it moves with
-- the first.
--
-- No data changes. No provenance is written: a methodology note is this
-- project's own words about its own coding, not a fact admitted from a source.

\set ON_ERROR_STOP on
BEGIN;

-- ---------------------------------------------------------------- before
DO $$
DECLARE m7 text; n integer;
BEGIN
  SELECT body INTO m7 FROM methodology_note WHERE code = 'M7';
  IF m7 IS NULL THEN RAISE EXCEPTION 'Refusing: M7 is not there.'; END IF;
  IF m7 NOT LIKE '%it has been done for Sessions 1, 2 and 3.%' THEN
    RAISE EXCEPTION 'Refusing: M7 does not say what this expects about which sessions are coded.';
  END IF;
  IF m7 NOT LIKE '%One bill in the first three sessions ended this way.%' THEN
    RAISE EXCEPTION 'Refusing: M7 does not carry the Creative Scotland sentence as expected.';
  END IF;

  -- The claim being corrected must be true of the database as it now stands:
  -- every bill in all four sessions that did not pass is coded with a reason,
  -- and no session beyond the fourth is on the clean sheet at all.
  SELECT count(*) INTO n FROM bill WHERE outcome = 'fell_other';
  IF n <> 0 THEN
    RAISE EXCEPTION 'Refusing: % bill(s) still carry the general fallen code, so the coding is not done.', n;
  END IF;
  SELECT count(*) INTO n FROM bill WHERE session_number > 4;
  IF n <> 0 THEN
    RAISE EXCEPTION 'Refusing: % bill(s) from a later session are on the clean sheet; four is no longer the right number.', n;
  END IF;
  SELECT count(*) INTO n FROM bill WHERE session_number = 4;
  IF n <> 86 THEN
    RAISE EXCEPTION 'Refusing: Session 4 holds % bills, not the 86 it was promoted with.', n;
  END IF;
  SELECT count(*) INTO n FROM bill WHERE outcome = 'fell_financial_resolution_not_agreed';
  IF n <> 1 THEN
    RAISE EXCEPTION 'Refusing: % bills fell for want of a financial resolution, so "one bill" is wrong.', n;
  END IF;

  CREATE TEMP TABLE notes_before ON COMMIT DROP AS
    SELECT code, body FROM methodology_note;
END $$;

-- ------------------------------------------------------ what M7 now says
UPDATE methodology_note
   SET body = replace(
                replace(body,
                  'it has been done for Sessions 1, 2 and 3.',
                  'it has been done for Sessions 1, 2, 3 and 4.'),
                'One bill in the first three sessions ended this way.',
                'One bill in the first four sessions ended this way.')
 WHERE code = 'M7';

-- ----------------------------------------------------------------- after
DO $$
DECLARE m7 text; n integer;
BEGIN
  SELECT body INTO m7 FROM methodology_note WHERE code = 'M7';

  IF m7 NOT LIKE '%it has been done for Sessions 1, 2, 3 and 4.%' THEN
    RAISE EXCEPTION 'Check failed: M7 does not name the four sessions.';
  END IF;
  IF m7 NOT LIKE '%One bill in the first four sessions ended this way.%' THEN
    RAISE EXCEPTION 'Check failed: M7 does not count four sessions for the Creative Scotland Bill.';
  END IF;
  IF m7 LIKE '%Sessions 1, 2 and 3.%' OR m7 LIKE '%first three sessions%' THEN
    RAISE EXCEPTION 'Check failed: M7 still says three somewhere.';
  END IF;

  -- Everything else M7 says is still there, including what db/069 added.
  IF m7 NOT LIKE '%There are 48 fallen bills across the seven sessions.%'
     OR m7 NOT LIKE '%Rule 9.14.18%'
     OR m7 NOT LIKE '%both divisions are given%'
     OR m7 NOT LIKE '%when a record of divisions is added it supersedes them.%' THEN
    RAISE EXCEPTION 'Check failed: M7 lost text it had.';
  END IF;

  -- Exactly one note changed, and it changed by exactly the two characters
  -- these two substitutions add on balance: "1, 2 and 3." becomes "1, 2, 3 and
  -- 4.", three characters longer, and "three" becomes "four", one shorter.
  -- This expected 8 when it was written and the rehearsal refused it; the
  -- arithmetic was wrong, not the database.
  SELECT count(*) INTO n FROM methodology_note m JOIN notes_before b USING (code)
   WHERE m.body IS DISTINCT FROM b.body;
  IF n <> 1 THEN RAISE EXCEPTION 'Check failed: % notes changed, not 1.', n; END IF;
  SELECT length(m.body) - length(b.body) INTO n
    FROM methodology_note m JOIN notes_before b USING (code) WHERE code = 'M7';
  IF n <> 2 THEN RAISE EXCEPTION 'Check failed: M7 changed by % characters, not 2.', n; END IF;

  SELECT count(*) INTO n FROM methodology_note;
  IF n <> 8 THEN RAISE EXCEPTION 'Check failed: % methodology notes, not 8.', n; END IF;

  -- Nothing about the bills moved.
  SELECT count(*) INTO n FROM bill;
  IF n <> 302 THEN RAISE EXCEPTION 'Check failed: % bills, not 302.', n; END IF;
  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n <> 0 THEN RAISE EXCEPTION 'The error checker is no longer empty: % item(s).', n; END IF;
  SELECT count(*) INTO n FROM v_stage_date_gaps;
  IF n <> 0 THEN RAISE EXCEPTION 'The gaps list is no longer empty: % item(s).', n; END IF;

  RAISE NOTICE 'M7 is now % characters.', length(m7);
END $$;

COMMIT;
