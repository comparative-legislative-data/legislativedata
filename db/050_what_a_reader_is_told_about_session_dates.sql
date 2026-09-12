-- db/050_what_a_reader_is_told_about_session_dates.sql
--
-- Settled by the owner on 2026-09-12, who approved both wordings.
--
-- Two changes to what a reader is told, both consequences of db/048.
--
-- M7 rested on a date that was not in the data. It told a reader that in
-- Sessions 1 and 2 every bill that fell before the dissolution date was in fact
-- rejected at Stage 1 -- a better observation than the factsheets allow, and
-- one the reader had no way of checking, because no session carried a date. Now
-- they do, so M7 states them and says where they came from.
--
-- M8 stated an honest negative and never stated the available positive. It said
-- that only dates where two sources disagreed have been checked, which is true,
-- and left a reader to conclude that everything else rests on one source, which
-- is not. The owner confirms the PhD dataset was compiled from the ground up
-- and is independent of the SPICe factsheets; since the corrections of
-- 2026-09-12 the two agree on every introduction date and every date of Royal
-- Assent in Sessions 1 and 2. That is weaker than checking the Act and stronger
-- than one source alone, and it is the footing most of this data rests on. A
-- reader should be told which of the two they have.
--
-- The anchors below are matched exactly and the migration refuses if any of
-- them is not found once, so a note that has been edited since cannot be
-- half-rewritten.

\set ON_ERROR_STOP on
BEGIN;

-- ---------------------------------------------------------------------------
-- 1. M7 states the dates it reasons from
-- ---------------------------------------------------------------------------

DO $$
DECLARE
  a1 text := 'for Sessions 1 and 2, where every bill that fell before the dissolution date was in fact rejected at Stage 1 rather than lost to the calendar';
  a2 text := 'conceals a real distinction. Until the remainder is done';
  a3 text := 'Checking every Royal Assent date against legislation.gov.uk is possible and has not been done.';
  b   text;
  n   integer;
BEGIN
  SELECT body INTO b FROM methodology_note WHERE code = 'M7';
  IF b IS NULL THEN RAISE EXCEPTION 'Refusing: M7 not found.'; END IF;

  IF (length(b) - length(replace(b, a1, ''))) / length(a1) <> 1 THEN
    RAISE EXCEPTION 'Refusing: M7 does not contain the first anchor exactly once.';
  END IF;
  IF (length(b) - length(replace(b, a2, ''))) / length(a2) <> 1 THEN
    RAISE EXCEPTION 'Refusing: M7 does not contain the second anchor exactly once.';
  END IF;

  b := replace(b, a1,
    'for Sessions 1 and 2. Session 1 ended on 31 March 2003 and Session 2 on 2 April 2007, '
    'from SPICe''s factsheet of recess and dissolution dates. Seven bills concluded on those '
    'two days and are recorded as having run out of time; every other bill that fell in those '
    'sessions was in fact rejected at Stage 1 rather than lost to the calendar');

  b := replace(b, a2,
    'conceals a real distinction. The day each session ended is held in this data, so that '
    'coding can be checked rather than taken on trust. Until the remainder is done');

  UPDATE methodology_note SET body = b WHERE code = 'M7';

  -- 2. M8 states the positive as well as the negative
  SELECT body INTO b FROM methodology_note WHERE code = 'M8';
  IF b IS NULL THEN RAISE EXCEPTION 'Refusing: M8 not found.'; END IF;
  IF (length(b) - length(replace(b, a3, ''))) / length(a3) <> 1 THEN
    RAISE EXCEPTION 'Refusing: M8 does not contain its anchor exactly once.';
  END IF;

  b := replace(b, a3, a3 ||
    ' The two sources are independently compiled, and for Sessions 1 and 2 they now agree on '
    'every one of the 154 introduction dates and all 128 dates of Royal Assent. Agreement '
    'between two independent records is weaker than checking the Act itself and stronger than '
    'a single source standing alone, and it is the footing most of this data rests on.');

  UPDATE methodology_note SET body = b WHERE code = 'M8';

  -- 3. What should now be true
  SELECT count(*) INTO n FROM methodology_note
   WHERE code = 'M7' AND body LIKE '%Session 1 ended on 31 March 2003 and Session 2 on 2 April 2007%';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: M7 does not now state the two dates.'; END IF;

  SELECT count(*) INTO n FROM methodology_note
   WHERE code = 'M7' AND body LIKE '%so that coding can be checked rather than taken on trust%';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: M7 does not now say the coding is checkable.'; END IF;

  SELECT count(*) INTO n FROM methodology_note
   WHERE code = 'M8' AND body LIKE '%The two sources are independently compiled%';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: M8 does not now state the corroboration.'; END IF;

  SELECT count(*) INTO n FROM methodology_note WHERE body IS NULL OR btrim(body) = '';
  IF n > 0 THEN RAISE EXCEPTION 'Refusing: % methodology note(s) are empty.', n; END IF;

  SELECT count(*) INTO n FROM methodology_note;
  IF n <> 8 THEN RAISE EXCEPTION 'Refusing: % methodology notes, expected 8.', n; END IF;

  RAISE NOTICE 'M7 states the session end dates it reasons from; M8 states the corroboration as well as the caveat. Eight notes, none empty.';
END $$;

COMMIT;
