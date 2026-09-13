-- 059_session_3_stage_dates_admitted.sql
--
-- The gateway's admission step for Session 3's Stage 1 and Stage 2 dates, as
-- db/038 recorded Sessions 1 and 2's. Nothing here promotes anything: the rows
-- become 'accepted', which makes them eligible to be carried onto the clean
-- sheet. Carrying them is tools/promote_session.sql, after the session has been
-- taken back off with tools/rollback_promotion.sql.
--
-- The review. The 108 rows were loaded on 2026-09-13 by
-- tools/phd_stage_dates.py --sessions 3 and tools/load_phd_stage_dates.sql, and
-- listed for the owner by tools/check_stage_entry.sql: each row beside its
-- bill's own introduction and concluding dates, its source and when it was
-- read. The owner read them and was content.
--
-- What the 108 are: 52 Stage 1 and 52 Stage 2 for the bills that reached Stage
-- 3, and Preliminary and Consideration for the two Private Bills. 54 bills, two
-- stages each. 53 of the 54 passed; the 54th is the Budget (Scotland) (No. 2)
-- Bill, which was rejected at Stage 3 and so completed the two stages before
-- it. They are exactly what v_stage_date_gaps held, and it is now empty.
--
-- This migration admits rows from the owner's dataset and no other source. The
-- 62 Session 3 rows already on the clean sheet -- the fact sheet's passing
-- dates, the Official Report's, the bill pages' -- were admitted by db/057 and
-- are not touched here.

\set ON_ERROR_STOP on
BEGIN;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM v_candidate_problems WHERE session_number = 3;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing to accept Session 3''s stage dates: v_candidate_problems has % row(s).', n;
  END IF;

  SELECT count(*) INTO n
    FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number = 3 AND t.review_status = 'new' AND t.source <> 'phd';
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % row(s) waiting for review are not from the owner''s dataset.', n;
  END IF;

  SELECT count(*) INTO n
    FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number = 3 AND t.review_status = 'new';
  IF n <> 108 THEN
    RAISE EXCEPTION 'Refusing: expected 108 rows waiting for review, found %.', n;
  END IF;
END $$;

-- Guarded on 'new', so a row since set to rejected or held stays as it is.
UPDATE stage_candidate t
   SET review_status = 'accepted',
       reviewed_at   = now()
  FROM bill_candidate c
 WHERE c.candidate_id = t.candidate_id
   AND c.session_number = 3
   AND t.review_status = 'new';

DO $$
DECLARE n integer; m integer;
BEGIN
  SELECT count(*) INTO n
    FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number = 3 AND t.review_status = 'accepted';
  IF n <> 170 THEN
    RAISE EXCEPTION 'Expected 170 accepted stage dates in Session 3, found %.', n;
  END IF;

  SELECT count(*) INTO m
    FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number = 3 AND t.review_status <> 'accepted';
  IF m > 0 THEN
    RAISE EXCEPTION '% Session 3 stage date(s) are still not accepted or rejected.', m;
  END IF;

  RAISE NOTICE 'Session 3: 108 stage dates accepted, 170 in all, none carried yet.';

  SELECT count(*) INTO n FROM v_candidate_problems WHERE session_number = 3;
  IF n > 0 THEN
    RAISE EXCEPTION 'The error checker finds % problem(s) in Session 3 after admission.', n;
  END IF;
END $$;

COMMIT;
