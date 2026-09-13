-- db/066_session_4_review.sql
--
-- The gateway's admission step for Session 4, as db/016, db/034 and db/057
-- recorded Sessions 1, 2 and 3. Nothing here promotes anything: the lines and
-- their stage dates become 'accepted', which makes them eligible for promotion.
-- Promotion is tools/promote_session.sql.
--
-- The review. The owner cleared Session 4's 86 staging lines on 2026-09-13.
-- Behind that review:
--   - the load reconciles with the factsheet's own summary on page 9 in every
--     cell and both margins: 67 government, 13 Member's, 5 private, 1 committee;
--     79 Acts, 1 withdrawn, 6 fallen; 86 in all, and nothing unrecognised;
--   - all 86 lines pair with the owner's own dataset, with eight pairings made
--     by hand where the two sources name a bill differently -- the four Budget
--     Acts, which the dataset numbers within the session, and six wording slips
--     -- every one confirmed on both dates the two sources share;
--   - the two dates the sources genuinely disagreed about were adjudicated: the
--     Land Reform Act's Royal Assent is 22 April 2016 from legislation.gov.uk,
--     so the factsheet is wrong, and the National Galleries Act's introduction
--     is 25 June 2015 on the owner's own record, so the factsheet is right and
--     the dataset a day out (db/063);
--   - the six bills the factsheet says fell without saying why are coded: one
--     fell at dissolution, having concluded on the session's last day, and the
--     other five were rejected at Stage 1, read in the Official Report for the
--     day each was decided, with the Presiding Officer's words quoted on the
--     line (db/063). The Transplantation Bill is the second case of the member's
--     own motion being amended into a rejection and agreed to as amended, and
--     the motion the Parliament resolved is recorded in full (db/064);
--   - the Higher Education Governance Act, whose factsheet line prints no year
--     in the title and so none before its number, is settled as 2016 asp 15 from
--     legislation.gov.uk, in both cells (db/062, db/063);
--   - the error checker is empty for the session, and the gaps list holds only
--     the Stage 1 and Stage 2 dates the owner's dataset will supply.
--
-- The stage dates admitted are the 79 passing dates read off the legislation
-- factsheet (74 Stage 3 and 5 Final Stage) and 5 read from the Official Report,
-- being the Stage 1 each rejected bill was rejected at. The owner's Stage 1 and
-- Stage 2 dates are not yet loaded and are not admitted here; this migration
-- refuses to admit a date from any source but those two.
--
-- Session 4 goes onto the clean sheet without those dates, as Sessions 1 to 3
-- did, and is taken off and put back when they arrive. That is the order
-- STATE.md sets, not an exception to anything.

\set ON_ERROR_STOP on
BEGIN;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM v_candidate_problems WHERE session_number = 4;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing to accept Session 4: v_candidate_problems has % row(s).', n;
  END IF;

  SELECT count(*) INTO n
    FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number = 4
     AND t.source NOT IN ('spice_factsheet_legislation', 'official_report');
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing to accept Session 4: % stage date(s) from a source this review did not cover.', n;
  END IF;

  -- The comparison against every other source that states these dates has been
  -- made, which db/044 requires before a line may be admitted.
  SELECT count(*) INTO n FROM bill_candidate
   WHERE session_number = 4 AND sources_compared_at IS NULL;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing to accept Session 4: % line(s) have not been compared against the other sources.', n;
  END IF;

  -- Every bill has an outcome. A line with none is a question nobody answered.
  SELECT count(*) INTO n FROM bill_candidate
   WHERE session_number = 4 AND outcome IS NULL;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing to accept Session 4: % line(s) still have no outcome.', n;
  END IF;
END $$;

-- Guarded on 'new', so a line or date since set to rejected or held stays as
-- it is.
UPDATE bill_candidate
   SET review_status = 'accepted',
       reviewed_at   = now()
 WHERE session_number = 4
   AND review_status  = 'new';

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
    FROM bill_candidate WHERE session_number = 4 AND review_status = 'accepted';
  SELECT count(*) INTO m
    FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number = 4 AND t.review_status = 'accepted';
  RAISE NOTICE 'Session 4: % lines and % stage dates accepted, none promoted.', n, m;
  IF n <> 86 THEN RAISE EXCEPTION 'Expected 86 accepted lines, found %.', n; END IF;
  IF m <> 84 THEN RAISE EXCEPTION 'Expected 84 accepted stage dates, found %.', m; END IF;

  SELECT count(*) INTO n FROM v_candidate_problems WHERE session_number = 4;
  IF n > 0 THEN
    RAISE EXCEPTION 'The error checker finds % problem(s) in Session 4 after admission.', n;
  END IF;

  -- Nothing reached the clean sheet.
  SELECT count(*) INTO n FROM bill;
  IF n <> 216 THEN RAISE EXCEPTION 'The clean sheet moved: % bills, expected 216.', n; END IF;
  SELECT count(*) INTO n FROM bill_candidate WHERE session_number = 4 AND promoted_bill_id IS NOT NULL;
  IF n > 0 THEN RAISE EXCEPTION '% Session 4 line(s) are marked promoted.', n; END IF;
END $$;

COMMIT;
