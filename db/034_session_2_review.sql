-- 034_session_2_review.sql
--
-- The gateway's admission step for Session 2, recorded as db/016 recorded
-- Session 1's. Nothing here promotes anything: the lines and their stage dates
-- become 'accepted', which makes them eligible for promotion. Promotion is
-- tools/promote_session.sql.
--
-- The review. The owner checked Session 2's 81 staging lines on 2026-09-11 and
-- was content. Behind that review:
--   - the load reconciled with the factsheet's own summary in every cell
--     (page 8: Executive 53, Member's 18, Private 9, Committee 1; 66 Acts,
--     5 withdrawn, 10 fallen);
--   - the six bills that fell before dissolution were coded from the Official
--     Report as rejected at Stage 1 (db/029), with how each was rejected
--     (db/032), and every citation was read against the Parliament's page;
--   - the error checker is empty for the session.
--
-- The stage dates admitted are the 66 passing dates read off the factsheet and
-- the six Stage 1 rejection dates read from the Official Report, moved onto the
-- stage-dates sheet by db/033. No PhD date exists yet, and this migration
-- refuses to admit a date from any other source.
--
-- AN EXCEPTION, decided by the owner. The stage-dates change is not finished:
-- the script that loads the owner's PhD spreadsheets is not built, and the rule
-- is that no session a change touches is admitted until it is. Everything that
-- holds, checks and promotes stage dates is built and proved; only the reader
-- of the spreadsheets is missing. Session 2 goes onto the clean sheet in the
-- state Session 1 is in, and both are taken off and put back when the dates
-- are added. DECISIONS.md, 2026-09-11, "Session 2 is promoted before the PhD
-- loader is built".

BEGIN;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM v_candidate_problems WHERE session_number = 2;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing to accept Session 2: v_candidate_problems has % row(s).', n;
  END IF;

  SELECT count(*) INTO n
    FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number = 2
     AND t.source IS DISTINCT FROM 'spice_factsheet'
     AND t.source IS DISTINCT FROM 'official_report';
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing to accept Session 2: % stage date(s) from a source this review did not cover.', n;
  END IF;
END $$;

-- Guarded on 'new', so a line or date since set to rejected or held stays as
-- it is.
UPDATE bill_candidate
   SET review_status = 'accepted',
       reviewed_at   = now()
 WHERE session_number = 2
   AND review_status  = 'new';

UPDATE stage_candidate t
   SET review_status = 'accepted',
       reviewed_at   = now()
  FROM bill_candidate c
 WHERE c.candidate_id = t.candidate_id
   AND c.session_number = 2
   AND t.review_status = 'new';

DO $$
DECLARE n integer; m integer;
BEGIN
  SELECT count(*) INTO n
    FROM bill_candidate WHERE session_number = 2 AND review_status = 'accepted';
  SELECT count(*) INTO m
    FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number = 2 AND t.review_status = 'accepted';
  RAISE NOTICE 'Session 2: % lines and % stage dates accepted, none promoted.', n, m;
  IF n <> 81 THEN RAISE EXCEPTION 'Expected 81 accepted lines, found %.', n; END IF;
  IF m <> 72 THEN RAISE EXCEPTION 'Expected 72 accepted stage dates, found %.', m; END IF;

  SELECT count(*) INTO n FROM v_candidate_problems WHERE session_number = 2;
  IF n > 0 THEN
    RAISE EXCEPTION 'The error checker finds % problem(s) in Session 2 after admission.', n;
  END IF;
END $$;

COMMIT;
