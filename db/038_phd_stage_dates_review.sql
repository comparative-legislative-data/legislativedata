-- 038_phd_stage_dates_review.sql
--
-- The gateway's admission step for the stage dates, as db/016 and db/034
-- recorded the admission of Session 1 and Session 2's lines. Nothing here
-- promotes anything: the rows become 'accepted', which makes them eligible for
-- promotion. Promotion is tools/promote_session.sql.
--
-- The review. The owner read the 272 rows loaded on 2026-09-11 and was content.
-- Behind that review:
--   - 256 rows come from the owner's own PhD dataset, for the bills that
--     passed, matched to the staging lines one to one and loaded by
--     tools/load_phd_stage_dates.sql, which refuses a title that does not
--     match its line number;
--   - 13 rows come from the Parliament's bill pages and 3 from the Official
--     Report, for the bills that did not pass. Each records where the bill
--     stopped, and carries the page the owner read as its source. What each
--     page established is in DECISIONS.md, 2026-09-11;
--   - two of the 256 are the rows the owner typed in Postico as a practice,
--     which say what the dataset says;
--   - the error checker is empty.
--
-- Every accepted row belongs to a Session 1 or Session 2 bill. This migration
-- refuses to admit a row from any other session, or a source outside the three
-- the load used.

BEGIN;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing to accept: the error checker has % row(s).', n;
  END IF;

  SELECT count(*) INTO n
    FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
   WHERE t.review_status = 'new' AND c.session_number NOT IN (1, 2);
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing to accept: % waiting row(s) belong to another session.', n;
  END IF;

  SELECT count(*) INTO n FROM stage_candidate
   WHERE review_status = 'new' AND source NOT IN ('phd', 'bill_document', 'official_report');
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing to accept: % waiting row(s) come from another source.', n;
  END IF;
END $$;

UPDATE stage_candidate
   SET review_status = 'accepted',
       reviewed_at   = now()
 WHERE review_status = 'new';

-- ---------------------------------------------------------------------------
-- Checks
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer; m integer;
BEGIN
  SELECT count(*) INTO n FROM stage_candidate WHERE review_status <> 'accepted';
  IF n > 0 THEN RAISE EXCEPTION '% stage-dates row(s) are still not accepted.', n; END IF;

  SELECT count(*) INTO n FROM stage_candidate;
  IF n <> 411 THEN RAISE EXCEPTION 'Expected 411 stage-dates rows, found %.', n; END IF;

  SELECT count(*) INTO n FROM stage_candidate WHERE source = 'phd';
  SELECT count(*) INTO m FROM stage_candidate WHERE source = 'bill_document';
  IF n <> 256 OR m <> 13 THEN
    RAISE EXCEPTION 'Expected 256 rows from the PhD dataset and 13 from bill pages, found % and %.', n, m;
  END IF;

  -- Every bill that passed has all three of its stages, except the Session 2
  -- Robin Rigg Act, which went straight to its Final Stage and carries a note.
  SELECT count(*) INTO n
    FROM bill_candidate c
   WHERE c.outcome = 'passed'
     AND (SELECT count(*) FROM stage_candidate t
           WHERE t.candidate_id = c.candidate_id AND t.date_completed IS NOT NULL) <> 3;
  IF n <> 1 THEN
    RAISE EXCEPTION 'Expected one passed bill without all three dates, found %.', n;
  END IF;

  -- Every bill that did not pass, apart from the eleven rejected at Stage 1,
  -- now records where it stopped.
  SELECT count(*) INTO n
    FROM bill_candidate c
   WHERE c.outcome NOT IN ('passed', 'rejected_stage_1')
     AND NOT EXISTS (SELECT 1 FROM stage_candidate t
                      WHERE t.candidate_id = c.candidate_id AND t.fell_here);
  IF n > 0 THEN
    RAISE EXCEPTION '% bill(s) that did not pass still have nothing recording where they stopped.', n;
  END IF;

  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n > 0 THEN RAISE EXCEPTION 'The error checker finds % problem(s) after admission.', n; END IF;

  RAISE NOTICE 'All 411 stage-dates rows accepted, none promoted yet.';
END $$;

COMMIT;
