-- 057_session_3_review.sql
--
-- The gateway's admission step for Session 3, as db/016 recorded Session 1's
-- and db/034 recorded Session 2's. Nothing here promotes anything: the lines
-- and their stage dates become 'accepted', which makes them eligible for
-- promotion. Promotion is tools/promote_session.sql.
--
-- The review. The owner checked Session 3's 62 staging lines across 12 and 13
-- September 2026 and was content. Behind that review:
--   - the load reconciles with the factsheet's own summary on page 8 in every
--     cell and both margins, counting the Forth Crossing Bill under Executive
--     as the factsheet does: Executive 45, Member's 13, Private 2, Committee 2;
--     53 Acts, 2 withdrawn, 7 fallen (STATE.md, "Reconciliation figures");
--   - all 62 lines pair with the owner's own dataset, with ten titles corrected
--     in that dataset so the two lists pair, and no differences (db/054);
--   - the Forth Crossing Act's type was settled as Hybrid against the
--     Parliament's own bill page, and three disputed dates were adjudicated
--     (db/054);
--   - the five bills the factsheet says fell without saying why were coded from
--     the Official Report: three rejected at Stage 1, one rejected at Stage 3,
--     and the Creative Scotland Bill, which fell because its financial
--     resolution was not agreed with its general principles already agreed
--     (db/055);
--   - where each of the other four bills that did not pass had got to was read
--     off the Parliament's own bill pages (db/056);
--   - the error checker is empty for the session, and the gaps list holds only
--     the 108 Stage 1 and Stage 2 dates the owner's dataset will supply.
--
-- The stage dates admitted are the 53 passing dates read off the legislation
-- factsheet (51 Stage 3 and 2 Final Stage), 5 read from the Official Report
-- (4 Stage 1 and the Stage 3 the Budget (Scotland) (No. 2) Bill was rejected
-- at), and 4 read off the Parliament's bill pages. The owner's Stage 1 and
-- Stage 2 dates are not yet loaded and are not admitted here; this migration
-- refuses to admit a date from any source but those three.
--
-- Session 3 goes onto the clean sheet without those dates, in the state
-- Sessions 1 and 2 were in between 11 September's promotion and the load that
-- followed, and is taken off and put back when they arrive. That is the order
-- STATE.md sets, not an exception to anything: no coding change is left
-- unbuilt by it.

\set ON_ERROR_STOP on
BEGIN;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM v_candidate_problems WHERE session_number = 3;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing to accept Session 3: v_candidate_problems has % row(s).', n;
  END IF;

  SELECT count(*) INTO n
    FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number = 3
     AND t.source NOT IN ('spice_factsheet_legislation', 'official_report', 'bill_page');
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing to accept Session 3: % stage date(s) from a source this review did not cover.', n;
  END IF;
END $$;

-- Guarded on 'new', so a line or date since set to rejected or held stays as
-- it is.
UPDATE bill_candidate
   SET review_status = 'accepted',
       reviewed_at   = now()
 WHERE session_number = 3
   AND review_status  = 'new';

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
    FROM bill_candidate WHERE session_number = 3 AND review_status = 'accepted';
  SELECT count(*) INTO m
    FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number = 3 AND t.review_status = 'accepted';
  RAISE NOTICE 'Session 3: % lines and % stage dates accepted, none promoted.', n, m;
  IF n <> 62 THEN RAISE EXCEPTION 'Expected 62 accepted lines, found %.', n; END IF;
  IF m <> 62 THEN RAISE EXCEPTION 'Expected 62 accepted stage dates, found %.', m; END IF;

  SELECT count(*) INTO n FROM v_candidate_problems WHERE session_number = 3;
  IF n > 0 THEN
    RAISE EXCEPTION 'The error checker finds % problem(s) in Session 3 after admission.', n;
  END IF;
END $$;

COMMIT;
