-- db/085_the_rules_that_hold_the_blocked_bill_cells_together.sql
--
-- The constraints on the two cells db/080 added, put on last, once the data
-- satisfies them.
--
-- db/080 could not carry these. Three bills on the clean sheet were recorded as
-- blocked with neither cell filled, so any rule tying the two together would
-- have refused the database it was added to. The values reached the staging
-- sheet in db/084 and the clean sheet by Session 5 being taken off and put
-- back. This is the last step, and it is the one that makes the arrangement
-- impossible to get wrong by hand as well as by script. db/078 did the same
-- thing in the same order.
--
-- Four rules, and one thing deliberately not made a rule.
--
--   - The two cells are filled together or empty together. assent_block_outcome
--     is the lasting record that a bill was stopped, and a bill that was
--     stopped was stopped somehow.
--   - Only a bill that passed can have been stopped before Royal Assent. A
--     bill that fell never reached the point of being sent for assent.
--   - A bill recorded as currently blocked says so in both places: its
--     enactment_status is blocked exactly when what followed is still_blocked.
--     That is written as an equivalence, so neither can move without the other.
--   - A bill reconsidered and passed is an enacted Act.
--
-- NOT a rule: that date_assent_blocked is filled whenever a bill was stopped.
-- The Session 5 fact sheet's footnote for the UK Withdrawal (Legal Continuity)
-- Bill gives no date, and an empty cell there means the source does not state
-- one. A rule nobody can satisfy is worse than no rule (db/049's reasoning).
--
-- Whether these rules bite is for a session that did not write them. They are
-- written up as items in docs/CLOSURE-TESTS.md.

\set ON_ERROR_STOP on
BEGIN;

-- Refuse to add a rule to a sheet that does not already satisfy it, so that a
-- failure here is about the data and not about the rule.
DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM bill
   WHERE (assent_block_route IS NULL) <> (assent_block_outcome IS NULL);
  IF n > 0 THEN RAISE EXCEPTION '% bill(s) have one block cell filled and the other empty.', n; END IF;

  SELECT count(*) INTO n FROM bill
   WHERE assent_block_outcome IS NOT NULL AND outcome IS DISTINCT FROM 'passed';
  IF n > 0 THEN RAISE EXCEPTION '% bill(s) were stopped before assent without having passed.', n; END IF;

  SELECT count(*) INTO n FROM bill
   WHERE (enactment_status = 'blocked')
         <> (coalesce(assent_block_outcome, '') = 'still_blocked');
  IF n > 0 THEN RAISE EXCEPTION '% bill(s) disagree with themselves about whether they are still blocked.', n; END IF;

  SELECT count(*) INTO n FROM bill
   WHERE assent_block_outcome = 'reconsidered_passed' AND enactment_status IS DISTINCT FROM 'enacted';
  IF n > 0 THEN RAISE EXCEPTION '% bill(s) were reconsidered and passed but are not enacted.', n; END IF;

  SELECT count(*) INTO n FROM bill WHERE assent_block_outcome IS NOT NULL;
  RAISE NOTICE '% bill(s) carry the record of having been stopped before Royal Assent.', n;
  IF n <> 3 THEN RAISE EXCEPTION 'Expected 3, found %.', n; END IF;
END $$;

ALTER TABLE bill
  ADD CONSTRAINT bill_block_cells_are_filled_together
      CHECK ((assent_block_route IS NULL) = (assent_block_outcome IS NULL)),
  ADD CONSTRAINT bill_only_a_passed_bill_can_be_blocked
      CHECK (assent_block_outcome IS NULL OR outcome = 'passed'),
  ADD CONSTRAINT bill_blocked_says_still_blocked
      CHECK ((enactment_status = 'blocked')
             = (coalesce(assent_block_outcome, '') = 'still_blocked')),
  ADD CONSTRAINT bill_reconsidered_and_passed_is_enacted
      CHECK (assent_block_outcome IS DISTINCT FROM 'reconsidered_passed'
             OR enactment_status = 'enacted');

COMMIT;
