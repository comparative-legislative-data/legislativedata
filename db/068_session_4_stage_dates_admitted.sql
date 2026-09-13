-- 068_session_4_stage_dates_admitted.sql
--
-- The gateway's admission step for Session 4's Stage 1 and Stage 2 dates, as
-- db/059 recorded Session 3's and db/038 Sessions 1 and 2's. Nothing here
-- promotes anything: the rows become 'accepted', which makes them eligible to
-- be carried onto the clean sheet. Carrying them is tools/promote_session.sql,
-- after the session has been taken back off with tools/rollback_promotion.sql.
--
-- The review. The 158 rows were loaded on 2026-09-13 by
-- tools/phd_stage_dates.py --sessions 4 and tools/load_phd_stage_dates.sql, and
-- listed for the owner by tools/check_stage_entry.sql: each row beside its
-- bill's own introduction date, the date it finished its last stage, its source
-- and when it was read. Every row was also checked against its own bill for a
-- date outside it -- earlier than the introduction, later than the last stage,
-- or a second stage before the first -- and none was. The owner read them and
-- was content.
--
-- What the 158 are: 74 Stage 1 and 74 Stage 2 for the public bills that reached
-- Stage 3, and Preliminary and Consideration for the five Private Bills. 79
-- bills, two stages each. All 79 passed; unlike Session 3 there is no bill here
-- that reached Stage 3 and was rejected there. They are exactly what
-- v_stage_date_gaps held, and it is now empty -- for the first time since the
-- database was built, no bill on the staging sheet is missing a stage date.
--
-- This migration admits rows from the owner's dataset and no other source. The
-- 87 Session 4 rows already on the clean sheet -- 74 Stage 3 dates and 5 Final
-- Stage dates off the fact sheet, 5 Stage 1 dates read in the Official Report,
-- and the 3 endings of db/067 -- were admitted by db/066 and db/067 and are not
-- touched here.

\set ON_ERROR_STOP on
BEGIN;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM v_candidate_problems WHERE session_number = 4;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing to accept Session 4''s stage dates: v_candidate_problems has % row(s).', n;
  END IF;

  SELECT count(*) INTO n
    FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number = 4 AND t.review_status = 'new' AND t.source <> 'phd';
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % row(s) waiting for review are not from the owner''s dataset.', n;
  END IF;

  SELECT count(*) INTO n
    FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number = 4 AND t.review_status = 'new';
  IF n <> 158 THEN
    RAISE EXCEPTION 'Refusing: expected 158 rows waiting for review, found %.', n;
  END IF;

  -- No date may sit outside its own bill. This is the check the owner's review
  -- was shown, made again here so that what was read and what is admitted are
  -- the same thing.
  SELECT count(*) INTO n
    FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number = 4 AND t.review_status = 'new'
     AND (t.date_completed IS NULL
          OR t.date_completed < c.date_introduced
          OR t.date_completed > (SELECT s.date_completed FROM stage_candidate s
                                  WHERE s.candidate_id = t.candidate_id AND s.stage_order = 3
                                    AND s.review_status = 'accepted' LIMIT 1));
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % date(s) fall outside their own bill.', n;
  END IF;
END $$;

-- Guarded on 'new', so a row since set to rejected or held stays as it is.
UPDATE stage_candidate t
   SET review_status = 'accepted',
       reviewed_at   = now()
  FROM bill_candidate c
 WHERE c.candidate_id = t.candidate_id
   AND c.session_number = 4
   AND t.review_status = 'new';

DO $$
DECLARE n integer; m integer;
BEGIN
  SELECT count(*) INTO n
    FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number = 4 AND t.review_status = 'accepted';
  IF n <> 245 THEN
    RAISE EXCEPTION 'Expected 245 accepted stage dates in Session 4, found %.', n;
  END IF;

  SELECT count(*) INTO m
    FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number = 4 AND t.review_status <> 'accepted';
  IF m > 0 THEN
    RAISE EXCEPTION '% Session 4 stage date(s) are still not accepted or rejected.', m;
  END IF;

  -- Session 4's 158 are the last gap anywhere.
  SELECT count(*) INTO n FROM v_stage_date_gaps;
  IF n > 0 THEN
    RAISE EXCEPTION 'The gaps list still holds % row(s) after admission.', n;
  END IF;

  RAISE NOTICE 'Session 4: 158 stage dates accepted, 245 in all, none carried yet.';

  SELECT count(*) INTO n FROM v_candidate_problems WHERE session_number = 4;
  IF n > 0 THEN
    RAISE EXCEPTION 'The error checker finds % problem(s) in Session 4 after admission.', n;
  END IF;
END $$;

COMMIT;
