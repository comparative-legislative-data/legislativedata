-- db/048_the_session_tab_holds_the_last_day_of_each_session.sql
--
-- Settled by the owner on 2026-09-12.
--
-- WHY THIS IS NOT A TIDY-UP. The date a session ended already decides how bills
-- are coded. tools/extract_factsheet.py takes --dissolution, and any bill in a
-- factsheet's "fallen" table whose final date matches it is proposed as having
-- fallen at dissolution; anything else is flagged for review. Seven bills in
-- Sessions 1 and 2 are coded that way. Until now that date was typed on a
-- command line, taken from a note in FACTSHEET-SURVEY.md quoting a different
-- document, and recorded nowhere. The database could not check it and neither
-- could the owner.
--
-- THE COLUMN IS RENAMED, because its old name meant something else. SPICe's
-- dates factsheet puts Session 1's dissolution period at 1 April to 1 May 2003,
-- beginning at midnight on 31 March. So the last day the Parliament existed is
-- 31 March and dissolution takes effect from 1 April. The value this database
-- wants -- the one the coding already uses, and the one every fallen bill's
-- concluding date matches -- is the session's last day. `date_dissolution`
-- holding 31 March would contradict the source it came from. `date_session_end`
-- does not. Postgres carries the rename into the check constraint and into
-- v_candidate_problems by itself, so nothing is rebuilt.
--
-- THE DATES. From SPICe, "Dates of recess, dissolution, parliamentary years and
-- recalls of Parliament", published 2 September 2026, its parliamentary years
-- table. Session 7 has begun and has not ended, so its end stays empty and
-- is_current already says which session that is.
--
-- The seven rows exist already, each carrying "Dates to be filled in." This
-- fills them in; it creates no session and changes no session's number. The old
-- notes are replaced only where there is now something to say.
--
-- CHECKED AGAINST A SECOND SOURCE, AND NOT RECORDED AS ONE. Every date here was
-- compared on 2026-09-12 against data.parliament.scot/api/sessions, which gives
-- Sessions 1 to 6; all six first meetings and all five of its end dates agree to
-- the day, and the five it shares with the legislation factsheets' own page 1
-- agree as well. Three sources, no disagreement. That agreement is recorded here
-- and in DECISIONS.md, and NOT as a second provenance row per date: this slice
-- has no need to tell corroboration apart from revision in the data, and
-- inventing a way to do so would be schema nobody asked for. The API does not
-- know about Session 7 and gives no end for Session 6, so it could not have
-- supplied two of these dates in any case.

\set ON_ERROR_STOP on
BEGIN;

-- ---------------------------------------------------------------------------
-- 1. The column says what it holds
-- ---------------------------------------------------------------------------

ALTER TABLE session RENAME COLUMN date_dissolution TO date_session_end;

COMMENT ON TABLE session IS
 'The parliamentary sessions, one row each. A session runs from the Parliament''s first meeting after an election to its last day before the next. Every bill belongs to the session it was introduced in.';

COMMENT ON COLUMN session.date_session_end IS
 'The last day of the session: the last day the Parliament existed before the next election. Dissolution begins at midnight on this date and runs until the election, so the dissolution period starts the following day and is not held here. Empty means either not yet filled in, or the session is still running. Called date_dissolution until db/048, which was the wrong name: it held this date, not the date the dissolution period began.';

COMMENT ON COLUMN session.is_current IS
 'True for the session running now. Stored rather than worked out, so the current session is unambiguous while its end date is still empty.';

COMMENT ON COLUMN session.note IS
 'Anything a reader needs to know about this session''s dates that the dates themselves do not say. Empty means there is nothing unusual.';

-- ---------------------------------------------------------------------------
-- 2. The seven sessions get their dates
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM session;
  IF n <> 7 THEN
    RAISE EXCEPTION 'Refusing: the session tab holds % row(s), expected the 7 already there.', n;
  END IF;

  SELECT count(*) INTO n FROM session
   WHERE date_first_meeting IS NOT NULL OR date_session_end IS NOT NULL;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % session(s) already carry a date. This migration fills empty ones.', n;
  END IF;

  SELECT count(*) INTO n FROM field_source WHERE entity = 'session';
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % provenance note(s) already exist for session dates.', n;
  END IF;
END $$;

UPDATE session SET date_first_meeting = v.first_meeting,
                   date_session_end   = v.session_end,
                   note               = v.note
  FROM (VALUES
 (1, DATE '1999-05-12', DATE '2003-03-31', NULL::text),
 (2, DATE '2003-05-07', DATE '2007-04-02', NULL),
 (3, DATE '2007-05-09', DATE '2011-03-22', NULL),
 (4, DATE '2011-05-11', DATE '2016-03-23', NULL),
 (5, DATE '2016-05-12', DATE '2021-05-04',
  'The only session whose last day is not followed by a long dissolution. Instead of dissolving on 25 March 2021 the Parliament went into what SPICe calls a "campaign recess" until the day before the election, so that it could be recalled; dissolution was 5 May 2021, the day before the poll. The arrangement was made because of Covid. The session''s last day, held here, is 4 May 2021.'),
 (6, DATE '2021-05-13', DATE '2026-04-08',
  'A pre-election recess ran from 26 March to 8 April 2026 and the dissolution period from 9 April to 6 May 2026; SPICe calls the two together the campaign period. The session''s last day, held here, is 8 April 2026.'),
 (7, DATE '2026-05-14', NULL,
  'Running. Its last day is empty because the session has not ended, not because it is unknown. Not covered by data.parliament.scot/api/sessions, which knows only Sessions 1 to 6.')
  ) AS v(session_number, first_meeting, session_end, note)
 WHERE session.session_number = v.session_number;

-- ---------------------------------------------------------------------------
-- 3. Where each of the thirteen dates came from
-- ---------------------------------------------------------------------------

INSERT INTO field_source (entity, entity_id, field_name, source, source_ref, value_seen, observed_at, note)
SELECT 'session', s.session_number, f.field_name, 'spice_factsheet_dates',
       'published 2 September 2026, ' || CASE WHEN s.session_number = 7 THEN 'p3' ELSE 'p2' END
         || ', parliamentary years table',
       f.value::text, DATE '2026-09-12',
       'Compared against data.parliament.scot/api/sessions on 2026-09-12; agreed, where the API states it.'
  FROM session s
  CROSS JOIN LATERAL (VALUES
        ('date_first_meeting', s.date_first_meeting),
        ('date_session_end',   s.date_session_end)) AS f(field_name, value)
 WHERE f.value IS NOT NULL;

-- ---------------------------------------------------------------------------
-- 4. What should now be true
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM session;
  IF n <> 7 THEN RAISE EXCEPTION 'Refusing: % sessions, expected 7.', n; END IF;

  SELECT count(*) INTO n FROM session WHERE date_first_meeting IS NULL;
  IF n > 0 THEN RAISE EXCEPTION 'Refusing: % session(s) with no first meeting.', n; END IF;

  SELECT count(*) INTO n FROM session WHERE date_session_end IS NULL;
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: % session(s) with no last day, expected 1 (Session 7).', n; END IF;

  SELECT count(*) INTO n FROM session WHERE is_current;
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: % current session(s), expected 1.', n; END IF;

  SELECT count(*) INTO n FROM session WHERE is_current AND date_session_end IS NOT NULL;
  IF n > 0 THEN RAISE EXCEPTION 'Refusing: the current session has a last day.'; END IF;

  SELECT count(*) INTO n FROM field_source WHERE entity = 'session';
  IF n <> 13 THEN RAISE EXCEPTION 'Refusing: % provenance notes for session dates, expected 13.', n; END IF;

  -- Every bill already coded as having fallen at dissolution is rechecked here
  -- against the dates now loaded. All seven concluded on their session's last
  -- day. If a future load breaks that, db/049 refuses it; this asserts it for
  -- the bills already on the clean sheet.
  SELECT count(*) INTO n
    FROM bill b JOIN session s USING (session_number)
   WHERE b.outcome = 'fell_dissolution'
     AND b.date_concluded IS DISTINCT FROM s.date_session_end;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % bill(s) coded as fallen at dissolution did not conclude on their session''s last day.', n;
  END IF;

  -- The four session-window checks in v_candidate_problems have been dormant
  -- while this tab was empty. They wake with these dates. Nothing may fire.
  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: the error checker is not empty (% problem(s)) now the session dates are in.', n;
  END IF;

  RAISE NOTICE 'Seven sessions, thirteen dates with their provenance, the window checks awake and silent, and all seven bills that fell at dissolution concluded on their session''s last day.';
END $$;

COMMIT;
