-- db/102_a_bill_still_before_the_parliament.sql
--
-- Adds methodology note M13. It is the last unbuilt piece of recording a bill
-- that has not finished, and it is built before Session 7 is promoted because
-- Session 7 brings the first such bill this database has ever held.
--
-- WHY IT IS NEEDED. Everything else about a live bill was already in place and
-- was rehearsed against Session 7 on 2026-09-15 before this migration was
-- written: 'in_progress' and 'pending' are allowed values with definitions of
-- their own; the loader sets them from the fact sheet's own table; promotion
-- carries them with the line's own source; the error checker asks nothing
-- extra; and v_stage_date_gaps was already written with live bills in mind --
-- it asks such a bill only for the stages below the furthest one it has
-- reached, so a bill that has reached none is asked for none. There is no
-- earlier bill coded this way to go back over: bill 473 is the first.
--
-- What was missing was the only part a reader sees. M5 covers a bill that
-- passed and was then stopped. Nothing covered a bill that has simply not
-- finished yet, and the consequence is visible in every figure this project
-- will publish about time: a live bill is counted as a bill of its session and
-- has no duration.
--
-- TWO DRAFTS OF THIS NOTE SAID SOMETHING FALSE, both caught before it was
-- applied. Neither is a fault in the data; both were the note overreaching.
--
--   * The first said a count of bills and a count of bills with a recorded
--     duration differ by the number of live bills. They do not, and already
--     differed by 62 before Session 7 existed: v_bill_total_duration measures
--     introduction to FINAL stage, so a bill that stopped earlier is not in it.
--     The rehearsal's per-session counts showed this.
--   * The second, replacing it, said that a bill which never reached its final
--     stage has no timing figure either. That takes one view's scope for a
--     property of the data, and it would have written a front-end decision into
--     published methodology. The owner's instruction of 2026-09-15: the
--     flexibility to cover every bill with any terminal point, or only bills
--     that completed every stage, must stay open, because it is a decision
--     about what to include and on what basis, not a question about the
--     database. v_bill_stage_durations already works this way and its own
--     description says so -- a bill rejected at Stage 1 has a real
--     introduction-to-Stage-1 period, and bill_passed is carried beside every
--     row precisely so that neither choice is built in.
--
-- So the note now says only what is true of a bill that has completed no stage:
-- there is nothing to measure for it on any basis. What is genuinely new about
-- Session 7 is narrower and is the third paragraph's subject: it is the first
-- session in which no bill has reached any terminal point, so a timescale chart
-- has an empty column rather than a short one.
--
-- THE SESSION 7 COLUMN OF A TIMESCALE CHART IS BLANK, NOT ZERO. The owner's
-- instruction of 2026-09-15, and the second half of the note. It is also what
-- the data already does: v_stage_duration_summary is grouped over the periods
-- between stages, and a bill with no stages contributes no period, so Session 7
-- produces no row at all rather than a row of zeros. A chart drawn from what is
-- there is therefore right on its own; a chart that supplies a zero where the
-- data gives nothing would be wrong, and the note says which is meant.
--
-- applies_to names the four columns a reader meets this at: the two cells that
-- hold it, and the two duration views' columns are not columns of a table, so
-- the bill's own date_introduced stands where the timing question is asked.
--
-- Nothing about any bill, line, stage record or provenance note changes here.
--
-- Agreed by the owner on 2026-09-15. See DECISIONS.md of the same date.

\set ON_ERROR_STOP on
BEGIN;

INSERT INTO methodology_note (code, title, body, applies_to, sort_order)
VALUES (
  'M13',
  'A bill still before the Parliament is counted, and has no ending',
  'A fact sheet lists bills still before the Parliament alongside those that have finished. Such a bill is recorded here with its outcome given as in progress, and with nothing recorded about an Act, because neither is yet known — which is not the same as a bill whose ending we could not find. It is counted as a bill of its session like any other.

It has not yet completed a stage, so there is nothing to measure for it at all, on any basis a figure might use. Which bills a figure about time covers is decided when the figure is drawn, not here: a bill that stopped at Stage 1 has a real introduction-to-Stage-1 period and it is recorded like any other, and every bill carries what happened to it, so a figure can cover all bills or only those that passed.

Where a chart shows timescales by session, a session whose bills have not yet completed a stage is shown blank, and this note is given against it. Blank means there is nothing yet to measure. It does not mean nought days.',
  ARRAY['bill.outcome','bill.enactment_status','bill.date_introduced','stage_event.date_completed'],
  13
);

-- ---------------------------------------------------------------------------
-- Checks. Any failure aborts, and nothing is written.
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer; t text; b text;
BEGIN
  SELECT count(*) INTO n FROM methodology_note WHERE code = 'M13';
  IF n <> 1 THEN RAISE EXCEPTION 'M13 matched % row(s), expected 1.', n; END IF;

  SELECT title, body INTO t, b FROM methodology_note WHERE code = 'M13';

  IF t <> 'A bill still before the Parliament is counted, and has no ending' THEN
    RAISE EXCEPTION 'M13 title did not take: %', t;
  END IF;

  -- The distinction the note exists to draw: not known yet is not not found.
  IF b !~ 'not the same as a bill whose ending we could not find' THEN
    RAISE EXCEPTION 'M13 no longer separates "not yet known" from "not found".';
  END IF;

  -- The note must leave the choice of which bills a timing figure covers where
  -- it belongs, and must not state it as a fact about the data.
  IF b !~ 'decided when the figure is drawn, not here' THEN
    RAISE EXCEPTION 'M13 no longer leaves the choice of which bills a timing figure covers to the front end.';
  END IF;

  IF b !~ 'a figure can cover all bills or only those that passed' THEN
    RAISE EXCEPTION 'M13 no longer says both choices stay open.';
  END IF;

  -- Neither withdrawn draft may creep back.
  IF b ~ 'the difference is the bills still before the Parliament'
     OR b ~ 'never reached its final stage' THEN
    RAISE EXCEPTION 'M13 has one of the two withdrawn drafts in it again.';
  END IF;

  -- The owner's instruction of 2026-09-15, in the note a reader sees.
  IF b !~ 'shown blank' OR b !~ 'nought days' THEN
    RAISE EXCEPTION 'M13 no longer says a session with no completed stage is blank rather than zero.';
  END IF;

  -- Short, like M12. M2 and M7 are the ones that are not.
  IF length(b) > 1200 THEN
    RAISE EXCEPTION 'M13 is % characters; it was written to be short.', length(b);
  END IF;

  -- Thirteen notes, and no other note touched.
  SELECT count(*) INTO n FROM methodology_note;
  IF n <> 13 THEN RAISE EXCEPTION '% methodology notes, expected 13.', n; END IF;

  SELECT count(*) INTO n FROM methodology_note
   WHERE code <> 'M13' AND updated_at >= now() - INTERVAL '5 minutes'
     AND updated_at > created_at + INTERVAL '1 second';
  IF n > 0 THEN RAISE EXCEPTION '% other note(s) were changed by this migration.', n; END IF;

  SELECT count(*) INTO n FROM methodology_note WHERE sort_order = 13 AND code <> 'M13';
  IF n > 0 THEN RAISE EXCEPTION 'Another note is already at sort_order 13.'; END IF;

  -- Nothing about the data. These are the figures before Session 7 is promoted.
  SELECT count(*) INTO n FROM bill;
  IF n <> 469 THEN RAISE EXCEPTION '% bills on the clean sheet, expected 469.', n; END IF;

  SELECT count(*) INTO n FROM stage_event;
  IF n <> 1291 THEN RAISE EXCEPTION '% stage records, expected 1291.', n; END IF;

  SELECT count(*) INTO n FROM field_source;
  IF n <> 186 THEN RAISE EXCEPTION '% provenance notes, expected 186.', n; END IF;

  SELECT count(*) INTO n FROM bill_candidate
   WHERE session_number = 7 AND review_status <> 'new';
  IF n > 0 THEN RAISE EXCEPTION '% Session 7 line(s) are no longer waiting for review.', n; END IF;

  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n <> 0 THEN RAISE EXCEPTION 'The error checker finds % problem(s), expected none.', n; END IF;

  RAISE NOTICE 'M13 added, % characters. Nothing else changed.', length(b);
END $$;

COMMIT;
