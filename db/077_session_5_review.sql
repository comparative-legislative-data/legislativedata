-- db/077_session_5_review.sql
--
-- The gateway's admission step for Session 5, as db/016, db/034, db/057 and
-- db/066 recorded Sessions 1 to 4. Nothing here promotes anything: the lines
-- and their stage dates become 'accepted', which makes them eligible for
-- promotion. Promotion is tools/promote_session.sql.
--
-- Unlike Sessions 1 to 4, this admits a session's lines and all of its stage
-- dates in one step. Those sessions went onto the clean sheet without the
-- owner's Stage 1 and Stage 2 dates, which arrived later and were admitted
-- separately by db/038, db/059 and db/068, each needing the session taken off
-- and put back. Session 5's dates were loaded before the review, so there is
-- nothing here to come back for and the session goes on once.
--
-- The review. The owner cleared Session 5's 87 staging lines and their 243
-- stage dates on 2026-09-14, having read them. Behind that review:
--   - the load reconciles with the fact sheet's own summary in every cell:
--     63 government, 16 Member's, 5 private, 3 committee; 75 Acts, 3 awaiting
--     Royal Assent, 2 withdrawn, 7 fallen; 87 in all, and nothing unrecognised;
--   - the fourth table, "Bills awaiting Royal Assent", is read for the first
--     time. Its three bills passed and are recorded as blocked, on the footnote
--     the fact sheet prints against each rather than on the table's heading,
--     with the date each was stopped and the footnote word for word on the line
--     (db/071, db/072). The three notes a reader sees were typed in from the
--     words the owner agreed before the session was loaded;
--   - all 87 lines were compared against the owner's dataset, with ten pairings
--     made by hand where the two sources name a bill differently, every one
--     confirmed on both dates the sources share, and one bill -- the Domestic
--     Abuse (Protection) (Scotland) Act 2021 -- having no row in the dataset at
--     all, which is why 87 lines pair with 86 rows;
--   - the three dates the two sources genuinely disagreed about were
--     adjudicated (db/074): two confirm the fact sheet, and the Solicitors Bill
--     was introduced on 26 September 2019, not 2020, which its own committee's
--     establishment in October 2019 makes plain;
--   - of the seven bills the fact sheet says fell without saying why, three lost
--     a division on their own Stage 1 motion and are recorded as rejected at
--     Stage 1 by the ordinary route, the Presiding Officer quoted and the
--     Official Report cited as db/031 and db/058 require; the other four fell at
--     dissolution, each checked on its own page rather than assumed (db/073);
--   - the Period Products Act, the first whose number the fact sheet prints with
--     no year, is settled at 2021 asp 1 from legislation.gov.uk (db/073);
--   - the six bills that did not pass and had nothing saying where they ended
--     carry Stage 1, not completed, fell here, no date, from their own bill
--     pages (db/075), and the Civil Partnership Act's Stage 2 is settled at the
--     bill page where the dataset had the month wrong (db/076);
--   - the error checker is empty for the session and the gaps list is empty;
--   - db/075, db/076 and the change to tools/phd_stage_dates.py were marked by a
--     session that did not build them, against the sources rather than against
--     the migrations' account of them, and all three pass.
--
-- The 243 stage dates admitted are 78 passing dates off the legislation fact
-- sheet (73 Stage 3 and 5 Final Stage), 153 from the owner's dataset (72 Stage 1,
-- 71 Stage 2, and Preliminary and Consideration for the five Private Bills), 9
-- from the Parliament's own bill pages (the six endings, the Domestic Abuse Act's
-- Stage 1 and Stage 2, and the Civil Partnership Act's Stage 2), and 3 read in
-- the Official Report, being the Stage 1 each rejected bill was rejected at.
-- This migration refuses to admit a date from any other source.
--
-- Whether this migration is right is for a session that did not write it.

\set ON_ERROR_STOP on
BEGIN;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM v_candidate_problems WHERE session_number = 5;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing to accept Session 5: v_candidate_problems has % row(s).', n;
  END IF;

  SELECT count(*) INTO n FROM v_stage_date_gaps WHERE session_number = 5;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing to accept Session 5: the gaps list holds % row(s).', n;
  END IF;

  SELECT count(*) INTO n
    FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number = 5
     AND t.source NOT IN ('spice_factsheet_legislation', 'official_report',
                          'phd', 'bill_page');
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing to accept Session 5: % stage date(s) from a source this review did not cover.', n;
  END IF;

  -- The comparison against every other source that states these dates has been
  -- made, which db/044 requires before a line may be admitted.
  SELECT count(*) INTO n FROM bill_candidate
   WHERE session_number = 5 AND sources_compared_at IS NULL;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing to accept Session 5: % line(s) have not been compared against the other sources.', n;
  END IF;

  -- Every bill has an outcome. A line with none is a question nobody answered.
  SELECT count(*) INTO n FROM bill_candidate
   WHERE session_number = 5 AND outcome IS NULL;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing to accept Session 5: % line(s) still have no outcome.', n;
  END IF;

  -- No date may sit outside its own bill: earlier than the introduction, or
  -- later than the day the bill ended. This is the check the owner's review was
  -- shown, made again here so that what was read and what is admitted are the
  -- same thing.
  --
  -- The ceiling is the day the bill ended, and where it has not ended -- the
  -- three bills that passed and were stopped from Royal Assent -- the day the
  -- session ended. db/068 used the bill's own last stage date instead, which
  -- on a bill with no ending is the date being tested, so a last stage dated
  -- anywhere at all was its own ceiling and escaped. The error checker catches
  -- such a date by another route, but this guard did not, and does now.
  --
  -- A bill carried over into the next session will have stages after its own
  -- session ended, and this will refuse it. No bill here is one; the four that
  -- are, are work STATE.md puts before Session 6 is loaded, and this line is
  -- part of it.
  SELECT count(*) INTO n
    FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
    JOIN session ss ON ss.session_number = c.session_number
   WHERE c.session_number = 5 AND t.review_status = 'new'
     AND t.date_completed IS NOT NULL
     AND (t.date_completed < c.date_introduced
          OR t.date_completed > COALESCE(c.date_royal_assent, c.date_concluded,
                                         ss.date_session_end));
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % date(s) fall outside their own bill.', n;
  END IF;

  -- No stage dated before the stage before it.
  SELECT count(*) INTO n
    FROM stage_candidate a
    JOIN stage_candidate b ON b.candidate_id = a.candidate_id
                          AND b.stage_order > a.stage_order
    JOIN bill_candidate c ON c.candidate_id = a.candidate_id
   WHERE c.session_number = 5 AND a.date_completed > b.date_completed;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % stage(s) dated before the stage before them.', n;
  END IF;

  -- The only rows admitted without a date are the six bills that ended at
  -- Stage 1 with no decision to date, recorded from their own bill pages by
  -- db/075. Any other dateless row is a stage completed on a date not known,
  -- which is a different thing and was not what the owner read.
  SELECT count(*) INTO n
    FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number = 5 AND t.date_completed IS NULL
     AND NOT (t.completed IS FALSE AND t.fell_here IS TRUE);
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % dateless row(s) are not a bill ending where it stopped.', n;
  END IF;

  SELECT count(*) INTO n
    FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number = 5 AND t.date_completed IS NULL;
  IF n <> 6 THEN
    RAISE EXCEPTION 'Refusing: expected 6 dateless rows, found %.', n;
  END IF;

  -- Nothing of Session 5 has reached the clean sheet.
  SELECT count(*) INTO n FROM bill_candidate
   WHERE session_number = 5 AND promoted_bill_id IS NOT NULL;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % Session 5 line(s) are already marked promoted.', n;
  END IF;
END $$;

-- Guarded on 'new', so a line or date since set to rejected or held stays as
-- it is.
UPDATE bill_candidate
   SET review_status = 'accepted',
       reviewed_at   = now()
 WHERE session_number = 5
   AND review_status  = 'new';

UPDATE stage_candidate t
   SET review_status = 'accepted',
       reviewed_at   = now()
  FROM bill_candidate c
 WHERE c.candidate_id = t.candidate_id
   AND c.session_number = 5
   AND t.review_status = 'new';

DO $$
DECLARE n integer; m integer;
BEGIN
  SELECT count(*) INTO n
    FROM bill_candidate WHERE session_number = 5 AND review_status = 'accepted';
  SELECT count(*) INTO m
    FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number = 5 AND t.review_status = 'accepted';
  RAISE NOTICE 'Session 5: % lines and % stage dates accepted, none promoted.', n, m;
  IF n <> 87 THEN RAISE EXCEPTION 'Expected 87 accepted lines, found %.', n; END IF;
  IF m <> 243 THEN RAISE EXCEPTION 'Expected 243 accepted stage dates, found %.', m; END IF;

  SELECT count(*) INTO n
    FROM bill_candidate WHERE session_number = 5 AND review_status = 'new';
  SELECT count(*) INTO m
    FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number = 5 AND t.review_status = 'new';
  IF n > 0 OR m > 0 THEN
    RAISE EXCEPTION '% line(s) and % stage date(s) are still new.', n, m;
  END IF;

  SELECT count(*) INTO n FROM v_candidate_problems WHERE session_number = 5;
  IF n > 0 THEN
    RAISE EXCEPTION 'The error checker finds % problem(s) in Session 5 after admission.', n;
  END IF;

  SELECT count(*) INTO n FROM v_stage_date_gaps WHERE session_number = 5;
  IF n > 0 THEN
    RAISE EXCEPTION 'The gaps list holds % row(s) after admission.', n;
  END IF;

  -- Nothing reached the clean sheet.
  SELECT count(*) INTO n FROM bill;
  IF n <> 302 THEN RAISE EXCEPTION 'The clean sheet moved: % bills, expected 302.', n; END IF;
  SELECT count(*) INTO n FROM stage_event;
  IF n <> 828 THEN RAISE EXCEPTION 'The clean sheet moved: % stage records, expected 828.', n; END IF;
  SELECT count(*) INTO n FROM bill_candidate
   WHERE session_number = 5 AND promoted_bill_id IS NOT NULL;
  IF n > 0 THEN RAISE EXCEPTION '% Session 5 line(s) are marked promoted.', n; END IF;
END $$;

COMMIT;
