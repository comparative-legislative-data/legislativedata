-- db/103: an undo leaves alone a bill that nothing was written over
--
-- A fact sheet sometimes lists a bill that belongs to an earlier session,
-- because the bill was still live when that session ended (M6). The later
-- line does not make a bill; it writes over cells of the bill already there,
-- and adds the stages that bill has not got.
--
-- Taking that later session off the clean sheet has, since db/081, taken the
-- earlier bill off with it, because nothing recorded what the cells read
-- before they were written over and there was no way to put them back. The
-- earlier session is then promoted again, which rebuilds the bill from its own
-- line. That is correct and it is two steps, and the second step is the one a
-- person forgets.
--
-- Session 7 showed the case where none of that is needed. Its second line
-- restated the Gender Recognition Reform Bill's Session 6 record and changed
-- not one cell of it. Nothing was written over, so nothing has to be put back,
-- and the bill has no business disappearing when Session 7 comes off.
--
-- What was missing was a recorded answer to "did this line change anything?".
-- It could be inferred from the provenance notes, which name the fact sheet
-- that changed each cell -- but that is reading prose to decide whether to
-- delete a bill. This migration records the answer instead, at the moment
-- promotion works it out, and the two tools read the number.
--
-- Owner's decision, 2026-09-15, having been shown both: write it down at the
-- time rather than work it out afterwards.

\set ON_ERROR_STOP on

BEGIN;

-- ---------------------------------------------------------------------------
-- The new cell
-- ---------------------------------------------------------------------------

ALTER TABLE bill_candidate
  ADD COLUMN continued_bill_cells_changed smallint;

COMMENT ON COLUMN bill_candidate.continued_bill_cells_changed IS
 'How many cells of the bill named in continues_bill_id this line changed when it was promoted, written by tools/promote_session.sql at the moment it works out what changed. Nought means the line restated the bill and altered nothing, and tools/rollback_promotion.sql then leaves that bill on the clean sheet when this line''s session is taken off. More than nought means cells were written over with no copy kept of what they read, so the bill comes off and its own session is promoted again to rebuild it. Empty means the line does not continue an earlier bill, or has not been promoted yet; rollback refuses rather than guess if a promoted continuing line has no number here. Bookkeeping about the ingest, like promoted_at: no reader of the data ever sees it.';

ALTER TABLE bill_candidate
  ADD CONSTRAINT bill_candidate_continued_count_only_on_continuing_lines
  CHECK (continued_bill_cells_changed IS NULL OR continues_bill_id IS NOT NULL);

ALTER TABLE bill_candidate
  ADD CONSTRAINT bill_candidate_continued_count_not_negative
  CHECK (continued_bill_cells_changed IS NULL OR continued_bill_cells_changed >= 0);

-- ---------------------------------------------------------------------------
-- The four lines already on the clean sheet
-- ---------------------------------------------------------------------------
--
-- Promotion writes exactly one provenance note per changed cell, and each such
-- note says so in its own words: it names the fact sheet that lists the bill
-- again and records what the cell read before. Counting those notes gives the
-- number this cell would have held had it existed at the time.
--
-- This is the route the owner did not want relied on, and it is not relied on:
-- the number is checked against a second, independent one. Taking Session 6
-- and Session 7 off and putting them back with the new tool makes promotion
-- work each number out from the staging line and the clean sheet, which is
-- where it comes from in the ordinary way. Both routes must agree, and the
-- rehearsal is written up in docs/STATE.md.

UPDATE bill_candidate c
   SET continued_bill_cells_changed = (
        SELECT count(*) FROM field_source f
         WHERE f.entity = 'bill'
           AND f.entity_id = c.continues_bill_id
           AND f.note LIKE '%lists this bill again%')
 WHERE c.continues_bill_id IS NOT NULL
   AND c.promoted_at IS NOT NULL;

-- ---------------------------------------------------------------------------
-- What should now be true
-- ---------------------------------------------------------------------------
--
-- Nothing on the clean sheet may move. Four staging lines gain a number and
-- nothing else does. The numbers themselves are checked by rehearsal, not
-- here: what is checked here is that every promoted continuing line has one
-- and no other line does.

DO $$
DECLARE n integer; bad text;
BEGIN
  SELECT count(*) INTO n FROM bill;
  IF n <> 470 THEN RAISE EXCEPTION 'Refusing: % bills, not the 470 there were.', n; END IF;

  SELECT count(*) INTO n FROM stage_event;
  IF n <> 1291 THEN RAISE EXCEPTION 'Refusing: % stage records, not the 1291 there were.', n; END IF;

  SELECT count(*) INTO n FROM field_source;
  IF n <> 186 THEN RAISE EXCEPTION 'Refusing: % provenance notes, not the 186 there were.', n; END IF;

  SELECT count(*) INTO n FROM bill_candidate
   WHERE continues_bill_id IS NOT NULL AND promoted_at IS NOT NULL
     AND continued_bill_cells_changed IS NULL;
  IF n > 0 THEN RAISE EXCEPTION 'Refusing: % promoted continuing line(s) have no number.', n; END IF;

  SELECT count(*) INTO n FROM bill_candidate
   WHERE continued_bill_cells_changed IS NOT NULL AND continues_bill_id IS NULL;
  IF n > 0 THEN RAISE EXCEPTION 'Refusing: % line(s) carry a number and continue nothing.', n; END IF;

  SELECT count(*) INTO n FROM bill_candidate WHERE continued_bill_cells_changed IS NOT NULL;
  IF n <> 4 THEN RAISE EXCEPTION 'Refusing: % line(s) carry a number, not the 4 that continue a bill.', n; END IF;

  SELECT string_agg(candidate_id||'='||continued_bill_cells_changed, ', ' ORDER BY candidate_id)
    INTO bad FROM bill_candidate WHERE continued_bill_cells_changed IS NOT NULL;
  IF bad <> '412=4, 440=6, 468=6, 474=0' THEN
    RAISE EXCEPTION 'Refusing: the four numbers came out as %, not 412=4, 440=6, 468=6, 474=0.', bad;
  END IF;

  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n > 0 THEN RAISE EXCEPTION 'Refusing: the error checker is not empty (% problem(s)).', n; END IF;

  SELECT count(*) INTO n FROM v_stage_date_gaps;
  IF n > 0 THEN RAISE EXCEPTION 'Refusing: the gaps list is not empty (% row(s)).', n; END IF;

  RAISE NOTICE 'Four continuing lines carry a number: 412=4, 440=6, 468=6, 474=0. Nothing on the clean sheet moved.';
END $$;

COMMIT;
