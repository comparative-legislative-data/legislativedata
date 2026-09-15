-- db/099_session_6_review.sql
--
-- The gateway's admission step for Session 6, as db/016, db/034, db/057, db/066
-- and db/077 recorded Sessions 1 to 5. Nothing here promotes anything: the
-- lines and their stage dates become 'accepted', which makes them eligible for
-- promotion. Promotion is tools/promote_session.sql.
--
-- As with Session 5, this admits the session's lines and all of its stage dates
-- in one step, because the owner's Stage 1 and Stage 2 dates were loaded before
-- the review. The session goes onto the clean sheet once.
--
-- THE REVIEW. The owner read Session 6's 83 staging lines and their 223 stage
-- dates on 2026-09-15 and was content with them. Behind that review:
--   - all four steps the runbook puts between loading a session and the review
--     were done, and were written down for the first time on 2026-09-14 after
--     this session had already been loaded without them;
--   - all 83 lines were compared against the owner's dataset;
--   - seven bills the fact sheet leaves in its "Bills awaiting Royal Assent"
--     table had become Acts four months before the sheet was read. Nothing in
--     the database could see it, and the three blind spots that hid it were
--     closed at db/090 and db/091. Every one of the twelve lines in that table
--     was looked up at legislation.gov.uk and says what was found, whether or
--     not the answer changed anything. See methodology note M12;
--   - all ten bills the fact sheet says fell were read in the Official Report,
--     where "fell" turned out to be three different things: five rejected at
--     Stage 1, two rejected at Stage 3, and three that ran out of time
--     (db/092). Each rejection quotes the Presiding Officer and cites the page;
--   - where each of the fourteen bills that did not pass stopped is recorded
--     from its own source (db/095), and the two bills that reached no Stage 2
--     meeting read the same as each other after the owner caught a misreading
--     of one of the two pages (db/096);
--   - the fact sheet's three dates and two titles that disagreed with the
--     dataset were adjudicated (db/089), and the blocked bills and two Act
--     titles settled at legislation.gov.uk (db/093);
--   - the UK Withdrawal from the European Union (Legal Continuity) Bill, which
--     passed, was stopped before Royal Assent and was then withdrawn, is
--     recorded as all three (db/094);
--   - the notes on the three bills this session lists again were rewritten to
--     cover what Session 6 did to them, and the note became the eighth cell a
--     further appearance carries (db/098). Without it two bills would have
--     reached the clean sheet as Acts carrying a note saying they never
--     received Royal Assent;
--   - the error checker is empty for the session and the gaps list is empty;
--   - everything built for Session 6 in the week to 2026-09-15 was tested by a
--     session that built none of it: five tests, thirty-eight items,
--     thirty-five of them mechanical and all thirty-five passing, with every
--     figure checked against the source again rather than against the database.
--
-- THE 223 STAGE DATES admitted are 136 from the owner's dataset, 71 passing
-- dates off the legislation fact sheet, 9 from the Parliament's own bill pages
-- and 7 read in the Official Report. This migration refuses to admit a date
-- from any other source.
--
-- Whether this migration is right is for a session that did not write it.

\set ON_ERROR_STOP on
BEGIN;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM v_candidate_problems WHERE session_number = 6;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing to accept Session 6: v_candidate_problems has % row(s).', n;
  END IF;

  SELECT count(*) INTO n FROM v_stage_date_gaps WHERE session_number = 6;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing to accept Session 6: the gaps list holds % row(s).', n;
  END IF;

  SELECT count(*) INTO n
    FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number = 6
     AND t.source NOT IN ('spice_factsheet_legislation', 'official_report',
                          'phd', 'bill_page');
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing to accept Session 6: % stage date(s) from a source this review did not cover.', n;
  END IF;

  -- The comparison against every other source that states these dates has been
  -- made, which db/044 requires before a line may be admitted.
  SELECT count(*) INTO n FROM bill_candidate
   WHERE session_number = 6 AND sources_compared_at IS NULL;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing to accept Session 6: % line(s) have not been compared against the other sources.', n;
  END IF;

  -- Every bill has an outcome. A line with none is a question nobody answered.
  SELECT count(*) INTO n FROM bill_candidate
   WHERE session_number = 6 AND outcome IS NULL;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing to accept Session 6: % line(s) still have no outcome.', n;
  END IF;

  -- Added at db/098, and this is the first session it is asked of. A line that
  -- lists again a bill already on the clean sheet must say what that bill's
  -- note should now read, so that an earlier fact sheet's wording cannot be
  -- left standing beside what this line changes.
  SELECT count(*) INTO n FROM bill_candidate c
   WHERE c.session_number = 6 AND c.continues_bill_id IS NOT NULL
     AND coalesce(btrim(c.bill_note), '') = ''
     AND EXISTS (SELECT 1 FROM bill b WHERE b.bill_id = c.continues_bill_id
                   AND coalesce(btrim(b.note), '') <> '');
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing to accept Session 6: % further appearance(s) leave an earlier note unanswered.', n;
  END IF;

  -- No date may sit outside its own bill: earlier than the introduction, or
  -- later than the day the bill ended. This is the check the owner's review was
  -- shown, made again here so that what was read and what is admitted are the
  -- same thing.
  --
  -- The ceiling is the day the bill ended, and where it has not ended the day
  -- the session ended. A line that continues an earlier bill is exempt: it
  -- exists because that bill's business ran past the end of its own session,
  -- and its dates are checked against the bill's own life by the error checker.
  SELECT count(*) INTO n
    FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
    JOIN session ss ON ss.session_number = c.session_number
   WHERE c.session_number = 6 AND t.review_status = 'new'
     AND c.continues_bill_id IS NULL
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
   WHERE c.session_number = 6 AND a.date_completed > b.date_completed;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % stage(s) dated before the stage before them.', n;
  END IF;

  -- The only rows admitted without a date are bills that ended where they
  -- stopped, with no decision of the Parliament to date. Any other dateless row
  -- is a stage completed on a date not known, which is a different thing and
  -- was not what the owner read.
  SELECT count(*) INTO n
    FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number = 6 AND t.date_completed IS NULL
     AND NOT (t.completed IS FALSE AND t.fell_here IS TRUE);
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % dateless row(s) are not a bill ending where it stopped.', n;
  END IF;

  SELECT count(*) INTO n
    FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number = 6 AND t.date_completed IS NULL;
  IF n <> 7 THEN
    RAISE EXCEPTION 'Refusing: expected 7 dateless rows, found %.', n;
  END IF;

  -- Nothing of Session 6 has reached the clean sheet.
  SELECT count(*) INTO n FROM bill_candidate
   WHERE session_number = 6 AND promoted_bill_id IS NOT NULL;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % Session 6 line(s) are already marked promoted.', n;
  END IF;
END $$;

-- Guarded on 'new', so a line or date since set to rejected or held stays as
-- it is.
UPDATE bill_candidate
   SET review_status = 'accepted',
       reviewed_at   = now()
 WHERE session_number = 6
   AND review_status  = 'new';

UPDATE stage_candidate t
   SET review_status = 'accepted',
       reviewed_at   = now()
  FROM bill_candidate c
 WHERE c.candidate_id = t.candidate_id
   AND c.session_number = 6
   AND t.review_status = 'new';

DO $$
DECLARE n integer; m integer;
BEGIN
  SELECT count(*) INTO n
    FROM bill_candidate WHERE session_number = 6 AND review_status = 'accepted';
  SELECT count(*) INTO m
    FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number = 6 AND t.review_status = 'accepted';
  RAISE NOTICE 'Session 6: % lines and % stage dates accepted, none promoted.', n, m;
  IF n <> 83 THEN RAISE EXCEPTION 'Expected 83 accepted lines, found %.', n; END IF;
  IF m <> 223 THEN RAISE EXCEPTION 'Expected 223 accepted stage dates, found %.', m; END IF;

  SELECT count(*) INTO n
    FROM bill_candidate WHERE session_number = 6 AND review_status = 'new';
  SELECT count(*) INTO m
    FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number = 6 AND t.review_status = 'new';
  IF n > 0 OR m > 0 THEN
    RAISE EXCEPTION '% line(s) and % stage date(s) are still new.', n, m;
  END IF;

  SELECT count(*) INTO n FROM v_candidate_problems WHERE session_number = 6;
  IF n > 0 THEN
    RAISE EXCEPTION 'The error checker finds % problem(s) in Session 6 after admission.', n;
  END IF;

  SELECT count(*) INTO n FROM v_stage_date_gaps WHERE session_number = 6;
  IF n > 0 THEN
    RAISE EXCEPTION 'The gaps list holds % row(s) after admission.', n;
  END IF;

  -- Nothing reached the clean sheet.
  SELECT count(*) INTO n FROM bill;
  IF n <> 389 THEN RAISE EXCEPTION 'The clean sheet moved: % bills, expected 389.', n; END IF;
  SELECT count(*) INTO n FROM stage_event;
  IF n <> 1071 THEN RAISE EXCEPTION 'The clean sheet moved: % stage records, expected 1071.', n; END IF;
  SELECT count(*) INTO n FROM bill_candidate
   WHERE session_number = 6 AND promoted_bill_id IS NOT NULL;
  IF n > 0 THEN RAISE EXCEPTION '% Session 6 line(s) are marked promoted.', n; END IF;
END $$;

COMMIT;
