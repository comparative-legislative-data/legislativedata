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
-- ended (db/081). Where such a line wrote over cells of that bill, there is no
-- copy of what they read before -- deliberately, because a copy is another
-- thing that can go stale. So that bill comes off too, and its own session is
-- promoted again to put it back, which writes it from its own staging line by
-- the ordinary route. This script says which session to run and how many lines
-- it will find; it does not run it, because promotion is a separate rehearsal
-- with its own things to look at.
--
-- A line that wrote over nothing is different, and since db/103 is treated
-- differently. The Session 7 fact sheet lists the Gender Recognition Reform
-- Bill, which belongs to Session 6, and restates its record without altering a
-- single cell. Nothing was written over, so there is nothing to put back, and
-- THE BILL MUST NOT DISAPPEAR WHEN SESSION 7 COMES OFF. It is a Session 6 bill
-- and Session 6 is not being taken off. The stages such a line added are
-- removed, because each one is stamped with the record it made; the bill
-- itself stays where it is.
--
-- The line says which case it is: continued_bill_cells_changed, written by
-- promotion at the moment it worked out what changed. Nought, and the bill
-- stays. More than nought, and the bill comes off. Empty on a promoted line,
-- and this script refuses -- it will not guess about deleting a bill.

\set ON_ERROR_STOP on

BEGIN;

CREATE TEMP TABLE rollback_arg ON COMMIT DROP AS SELECT :session::int AS session_number;

-- Held before anything is deleted, because the link that finds these bills is
-- cleared by the deleting.
--
-- Every bill of an earlier session this session's lines point at, with how
-- many of its cells each line changed. A bill is taken off only where a line
-- actually wrote over something (db/103).
CREATE TEMP TABLE rollback_pointed_at ON COMMIT DROP AS
SELECT DISTINCT c.candidate_id, c.continues_bill_id AS bill_id,
       b.session_number AS own_session, c.continued_bill_cells_changed AS cells_changed
  FROM bill_candidate c
  JOIN rollback_arg a USING (session_number)
  JOIN bill b ON b.bill_id = c.continues_bill_id
 WHERE c.continues_bill_id IS NOT NULL;

-- It will not guess. A promoted line that points at an earlier bill and does
-- not say how many cells it changed is a line this script cannot reason about,
-- and the bill is not deleted on a hunch.
DO $$
DECLARE bad text;
BEGIN
  SELECT string_agg(p.candidate_id::text, ', ' ORDER BY p.candidate_id) INTO bad
    FROM rollback_pointed_at p JOIN bill_candidate c USING (candidate_id)
   WHERE c.promoted_at IS NOT NULL AND p.cells_changed IS NULL;
  IF bad IS NOT NULL THEN
    RAISE EXCEPTION 'Refusing: line(s) % point at an earlier session''s bill and do not record how many cells they changed. Promote the session again with the current tool, which writes it, before taking it off.', bad;
  END IF;
END $$;

-- The bills that must be rebuilt: something was written over them.
CREATE TEMP TABLE rollback_continued ON COMMIT DROP AS
SELECT DISTINCT bill_id, own_session FROM rollback_pointed_at
 WHERE coalesce(cells_changed, 0) > 0;

-- The bills that stay: nothing was written over them. Only the stage records
-- this session's lines made on them come off.
CREATE TEMP TABLE rollback_spared ON COMMIT DROP AS
SELECT DISTINCT bill_id, own_session FROM rollback_pointed_at
 WHERE coalesce(cells_changed, 0) = 0
   AND bill_id NOT IN (SELECT bill_id FROM rollback_pointed_at WHERE coalesce(cells_changed, 0) > 0);

-- The stage records this session's lines made on a bill that is staying. Each
-- is stamped on the stage-dates row that made it, so they can be removed one by
-- one without touching anything the bill already had.
CREATE TEMP TABLE rollback_spared_stages ON COMMIT DROP AS
SELECT t.promoted_stage_event_id AS stage_event_id, s.bill_id
  FROM rollback_spared s
  JOIN rollback_pointed_at p USING (bill_id)
  JOIN stage_candidate t ON t.candidate_id = p.candidate_id
 WHERE t.promoted_stage_event_id IS NOT NULL;

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
\echo '--- Bills of an earlier session that this session wrote over, and which come off with it'
SELECT r.bill_id, r.own_session, left(b.short_title, 50) AS short_title
  FROM rollback_continued r JOIN bill b USING (bill_id) ORDER BY 1;

\echo ''
\echo '--- Bills of an earlier session that this session only restated, and which STAY'
SELECT r.bill_id, r.own_session, left(b.short_title, 50) AS short_title,
       (SELECT count(*) FROM rollback_spared_stages g WHERE g.bill_id = r.bill_id) AS stage_records_coming_off
  FROM rollback_spared r JOIN bill b USING (bill_id) ORDER BY 1;

-- Counts everything the script is about to delete, the bills of an earlier
-- session included. Before db/103 this table counted only the session's own
-- bills and so reported less than the script then removed, which is the one
-- number a reader running with save=false has to be able to trust.
\echo ''
\echo '--- About to remove'
SELECT (SELECT count(*) FROM bill b JOIN rollback_arg a USING (session_number))
     + (SELECT count(*) FROM rollback_continued)                               AS bills,
       (SELECT count(*) FROM stage_event e JOIN bill b USING (bill_id)
          JOIN rollback_arg a USING (session_number))
     + (SELECT count(*) FROM stage_event e JOIN rollback_continued r USING (bill_id))
     + (SELECT count(*) FROM rollback_spared_stages)                           AS stage_rows,
       (SELECT count(*) FROM field_source f JOIN bill b ON f.entity = 'bill' AND f.entity_id = b.bill_id
          JOIN rollback_arg a USING (session_number))
     + (SELECT count(*) FROM field_source f JOIN stage_event e ON f.entity = 'stage_event' AND f.entity_id = e.stage_event_id
          JOIN bill b USING (bill_id) JOIN rollback_arg a USING (session_number))
     + (SELECT count(*) FROM field_source f JOIN rollback_continued r ON f.entity = 'bill' AND f.entity_id = r.bill_id)
     + (SELECT count(*) FROM field_source f JOIN stage_event e ON f.entity = 'stage_event' AND f.entity_id = e.stage_event_id
          JOIN rollback_continued r USING (bill_id))
     + (SELECT count(*) FROM field_source f JOIN rollback_spared_stages g
          ON f.entity = 'stage_event' AND f.entity_id = g.stage_event_id)      AS provenance_notes;

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

-- A bill that is staying keeps everything it had; only the stage records this
-- session made on it come off, with their own provenance notes.
DELETE FROM field_source f
 USING rollback_spared_stages g
 WHERE f.entity = 'stage_event' AND f.entity_id = g.stage_event_id;

DELETE FROM stage_event e USING rollback_spared_stages g
 WHERE e.stage_event_id = g.stage_event_id;

-- Stage rows go with their bills.
DELETE FROM bill b USING rollback_arg a WHERE b.session_number = a.session_number;

DELETE FROM bill b USING rollback_continued r WHERE b.bill_id = r.bill_id;

-- This session's own lines are cleared outright. Before db/103 every one of
-- them lost its link when its bill was deleted, and clearing the date was
-- enough; a line pointing at a bill that is staying keeps its link, so it has
-- to be said plainly.
UPDATE bill_candidate c
   SET promoted_bill_id             = NULL,
       promoted_at                  = NULL,
       continued_bill_cells_changed = NULL
  FROM rollback_arg a
 WHERE c.session_number = a.session_number
   AND (c.promoted_bill_id IS NOT NULL OR c.promoted_at IS NOT NULL
        OR c.continued_bill_cells_changed IS NOT NULL);

-- Each other staging line's link empties itself when its bill goes; the date
-- does not. This covers the lines of an earlier session whose bill came off
-- because this session had written over it.
UPDATE bill_candidate c
   SET promoted_at                  = NULL,
       continued_bill_cells_changed = NULL
 WHERE c.promoted_bill_id IS NULL
   AND (c.promoted_at IS NOT NULL OR c.continued_bill_cells_changed IS NOT NULL);

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
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % bill(s) this session wrote over are still on the clean sheet.', n; END IF;

  -- The other half of the same rule, and the one db/103 exists for: a bill this
  -- session only restated belongs to an earlier session and must still be here.
  SELECT count(*) INTO n FROM rollback_spared r
   WHERE NOT EXISTS (SELECT 1 FROM bill b WHERE b.bill_id = r.bill_id);
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % bill(s) of an earlier session were removed although this session changed nothing on them.', n; END IF;

  SELECT count(*) INTO n FROM rollback_spared_stages g
   WHERE EXISTS (SELECT 1 FROM stage_event e WHERE e.stage_event_id = g.stage_event_id);
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % stage record(s) this session made on an earlier bill are still there.', n; END IF;
  SELECT count(*) INTO n FROM stage_candidate t
   WHERE t.promoted_stage_event_id IS NULL AND t.promoted_at IS NOT NULL;
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % stage-dates row(s) are stamped with a date and no record.', n; END IF;
  SELECT count(*) INTO n FROM field_source f JOIN bill_candidate c
      ON f.entity = 'bill' AND f.entity_id = c.candidate_id
   WHERE c.session_number = s;
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % provenance note(s) still refer to this session''s bills.', n; END IF;
  RAISE NOTICE 'All checks passed. The session can be promoted again.';

  FOR n IN SELECT DISTINCT own_session FROM rollback_continued LOOP
    RAISE NOTICE 'Session % also came off, because this session had written over % of its bills. Promote Session % again as well, and in that order.',
      n, (SELECT count(*) FROM rollback_continued WHERE own_session = n), n;
  END LOOP;

  FOR n IN SELECT DISTINCT own_session FROM rollback_spared LOOP
    RAISE NOTICE 'Session % stayed where it is: this session restated % of its bills and changed nothing on them, so they were left alone. Nothing to promote again.',
      n, (SELECT count(*) FROM rollback_spared WHERE own_session = n);
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
