-- rollback_promotion.sql
--
-- Takes one session back off the clean sheet, as if it had never been
-- promoted. The staging lines and stage-dates rows are untouched apart from
-- having their promotion stamps cleared, so promotion can simply be run again.
--
--   -v session=1   which session to take back
--   -v save=false  see what it would remove, and change nothing
--   -v save=true   remove it
--
-- Everything promotion wrote comes off: the bills, their stage records and
-- their provenance notes. Putting the session back writes all three again from
-- the staging sheets (db/030, db/033).
--
-- A session may also have added to a bill belonging to an EARLIER session,
-- where a fact sheet lists a bill that was still live when its own session
-- ended (db/081). Such a bill's cells were changed and stages added, and there
-- is no copy of what they were before -- deliberately, because a copy is
-- another thing that can go stale. So those bills come off too, and their own
-- session is promoted again to put them back, which writes them from their own
-- staging lines by the ordinary route. This script says which session to run
-- and how many lines it will find; it does not run it, because promotion is a
-- separate rehearsal with its own things to look at.

\set ON_ERROR_STOP on

BEGIN;

CREATE TEMP TABLE rollback_arg ON COMMIT DROP AS SELECT :session::int AS session_number;

-- The bills of an earlier session that this session added to. Held before
-- anything is deleted, because the link that finds them is cleared by the
-- deleting.
CREATE TEMP TABLE rollback_continued ON COMMIT DROP AS
SELECT DISTINCT c.continues_bill_id AS bill_id, b.session_number AS own_session
  FROM bill_candidate c
  JOIN rollback_arg a USING (session_number)
  JOIN bill b ON b.bill_id = c.continues_bill_id
 WHERE c.continues_bill_id IS NOT NULL;

-- A later session may point at this session's bills: one of its lines may be a
-- further appearance of one (db/081), or may have carried one's scrutiny. Those
-- links are on the staging sheet, which rollback does not touch, so taking this
-- session off would break them. Refuse, and say what to take off first, rather
-- than let the database refuse with a message about a constraint.
DO $$
DECLARE s integer; n integer; who text;
BEGIN
  SELECT session_number INTO s FROM rollback_arg;

  -- Both ask about what is ON the clean sheet, not what the staging sheet
  -- proposes. A session already taken off depends on nothing.
  SELECT count(*), string_agg(DISTINCT c.session_number::text, ', ') INTO n, who
    FROM bill_candidate c JOIN bill b ON b.bill_id = c.continues_bill_id
   WHERE b.session_number = s AND c.session_number <> s
     AND c.promoted_bill_id IS NOT NULL;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % promoted line(s) in Session(s) % are a further appearance of a bill of this session. Take those sessions off first.', n, who;
  END IF;

  SELECT count(*), string_agg(DISTINCT b2.session_number::text, ', ') INTO n, who
    FROM bill b2 JOIN bill b ON b.bill_id = b2.reintroduced_from_bill_id
   WHERE b.session_number = s AND b2.session_number <> s;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % bill(s) in Session(s) % carried the scrutiny of a bill of this session. Take those sessions off first.', n, who;
  END IF;
END $$;

\echo ''
\echo '--- Bills of an earlier session that this session added to, and which come off with it'
SELECT r.bill_id, r.own_session, left(b.short_title, 50) AS short_title
  FROM rollback_continued r JOIN bill b USING (bill_id) ORDER BY 1;

\echo ''
\echo '--- About to remove'
SELECT (SELECT count(*) FROM bill b JOIN rollback_arg a USING (session_number)) AS bills,
       (SELECT count(*) FROM stage_event e JOIN bill b USING (bill_id)
          JOIN rollback_arg a USING (session_number))                          AS stage_rows,
       (SELECT count(*) FROM field_source f JOIN bill b ON f.entity = 'bill' AND f.entity_id = b.bill_id
          JOIN rollback_arg a USING (session_number))
     + (SELECT count(*) FROM field_source f JOIN stage_event e ON f.entity = 'stage_event' AND f.entity_id = e.stage_event_id
          JOIN bill b USING (bill_id) JOIN rollback_arg a USING (session_number)) AS provenance_notes;

-- Provenance notes first, while their bills and stage rows still exist to say
-- which session they belong to.
DELETE FROM field_source f
 USING stage_event e, bill b, rollback_arg a
 WHERE f.entity = 'stage_event' AND f.entity_id = e.stage_event_id
   AND e.bill_id = b.bill_id AND b.session_number = a.session_number;

DELETE FROM field_source f
 USING bill b, rollback_arg a
 WHERE f.entity = 'bill' AND f.entity_id = b.bill_id
   AND b.session_number = a.session_number;

-- The same for the bills of an earlier session that this one added to.
DELETE FROM field_source f
 USING stage_event e, rollback_continued r
 WHERE f.entity = 'stage_event' AND f.entity_id = e.stage_event_id
   AND e.bill_id = r.bill_id;

DELETE FROM field_source f
 USING rollback_continued r
 WHERE f.entity = 'bill' AND f.entity_id = r.bill_id;

-- Stage rows go with their bills.
DELETE FROM bill b USING rollback_arg a WHERE b.session_number = a.session_number;

DELETE FROM bill b USING rollback_continued r WHERE b.bill_id = r.bill_id;

-- Each staging line's link empties itself when its bill goes; the date does
-- not. This covers the lines of the session being taken off and, because a
-- continued bill has gone too, the lines of its own session that made it.
UPDATE bill_candidate c
   SET promoted_at = NULL
 WHERE c.promoted_bill_id IS NULL
   AND c.promoted_at IS NOT NULL;

-- The same for each stage-dates row, whose link empties itself when its stage
-- record goes.
UPDATE stage_candidate t
   SET promoted_at = NULL
 WHERE t.promoted_stage_event_id IS NULL AND t.promoted_at IS NOT NULL;

DO $$
DECLARE s integer; n integer;
BEGIN
  SELECT session_number INTO s FROM rollback_arg;
  SELECT count(*) INTO n FROM bill WHERE session_number = s;
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % bill(s) still on the clean sheet.', n; END IF;
  SELECT count(*) INTO n FROM bill_candidate
   WHERE session_number = s AND (promoted_bill_id IS NOT NULL OR promoted_at IS NOT NULL);
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % staging line(s) still stamped as promoted.', n; END IF;
  SELECT count(*) INTO n FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number = s AND (t.promoted_stage_event_id IS NOT NULL OR t.promoted_at IS NOT NULL);
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % stage-dates row(s) still stamped as promoted.', n; END IF;
  SELECT count(*) INTO n FROM bill b JOIN rollback_continued r USING (bill_id);
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % bill(s) this session added to are still on the clean sheet.', n; END IF;
  SELECT count(*) INTO n FROM stage_candidate t
   WHERE t.promoted_stage_event_id IS NULL AND t.promoted_at IS NOT NULL;
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % stage-dates row(s) are stamped with a date and no record.', n; END IF;
  SELECT count(*) INTO n FROM field_source f JOIN bill_candidate c
      ON f.entity = 'bill' AND f.entity_id = c.candidate_id
   WHERE c.session_number = s;
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % provenance note(s) still refer to this session''s bills.', n; END IF;
  RAISE NOTICE 'All checks passed. The session can be promoted again.';

  FOR n IN SELECT DISTINCT own_session FROM rollback_continued LOOP
    RAISE NOTICE 'Session % also came off, because this session had added to % of its bills. Promote Session % again as well, and in that order.',
      n, (SELECT count(*) FROM rollback_continued WHERE own_session = n), n;
  END LOOP;
END $$;

\echo ''
\echo '--- After'
SELECT (SELECT count(*) FROM bill)         AS bills,
       (SELECT count(*) FROM stage_event)  AS stage_rows,
       (SELECT count(*) FROM field_source) AS provenance_notes;

\echo ''
\if :save
  \echo '=== SAVING'
  COMMIT;
\else
  \echo '=== NOT SAVING - changing nothing'
  ROLLBACK;
\endif
