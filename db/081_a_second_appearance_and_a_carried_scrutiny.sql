-- db/081_a_second_appearance_and_a_carried_scrutiny.sql
--
-- Two cells for the two ways a bill's business crosses a session boundary.
-- They look alike and are opposites, which is the reason for saying so here.
--
-- Agreed with the owner on 2026-09-14, as part of the piece of work STATE.md
-- puts before Session 6 is loaded.
--
-- -------------------------------------------------------------------------
-- The test that tells the two apart: did the first bill end?
--
-- IT DID NOT END -- one bill, two rows. The bill was still live when the
-- session closed, so the next fact sheet lists it again. Four bills: the
-- European Charter, UNCRC and UK Withdrawal (Legal Continuity) Bills, listed
-- in Sessions 5 and 6, and the Gender Recognition Reform Bill, listed in
-- Sessions 6 and 7. The second row is not a bill. It is more facts about a
-- bill already on the clean sheet, and it must land on that bill rather than
-- make another one. That is bill_candidate.continues_bill_id.
--
-- IT ENDED -- two bills, two rows. It fell, or was withdrawn, or was rejected,
-- and something new was introduced afterwards. Six such pairs, of which the
-- Robin Rigg Bill is peculiar: a reintroduced Private Bill does not repeat its
-- earlier scrutiny, so the Session 2 Act went straight to the Final Stage vote
-- and its Preliminary and Consideration Stages are recorded as stages that
-- never happened. They happened to the Session 1 bill. That is
-- bill.reintroduced_from_bill_id.
--
-- Both are still counted. Two bills were introduced, and M6's arithmetic
-- counts them both.
--
-- -------------------------------------------------------------------------
-- Why the second cell is wanted at all, when the fact is already recorded.
--
-- It is recorded, in prose, on the Robin Rigg Act and on both of its empty
-- stage rows, with the archived bill page cited. What prose cannot do is reach
-- a chart. The Act's journey from introduction to the Final Stage reads 42
-- days, against a next-shortest Private Bill of 132 and a median around 240,
-- because eleven of its twelve months happened to a bill with a different
-- number. With the cell, a chart can offer the journey either way and say
-- which it used; without it, 42 days sits in the chart with nothing beside it.
-- The owner asked for the methodology to be visible to a reader "whether they
-- agree with it or not", and this is the cell that lets it be.
--
-- -------------------------------------------------------------------------
-- Where the cells do not go.
--
-- continues_bill_id is on the staging sheet only. Its whole job is to stop a
-- second bill being made, and once promotion has obeyed it there is nothing
-- for the clean sheet to hold: the later facts are on the bill itself. What
-- session a bill belongs to is settled by M6 and needs no cell.
--
-- reintroduced_from_bill_id is on both sheets, because it is a fact about the
-- bill that has to survive the session being taken off the clean sheet and put
-- back.
--
-- -------------------------------------------------------------------------
-- Why the two staging cells do not point at the clean sheet, and the one on
-- the clean sheet does.
--
-- On the clean sheet the number is a link, and the database refuses a bill
-- that names one that is not there. On the staging sheet it is a PROPOSAL, and
-- a proposal has to be able to name a bill that is off the clean sheet at the
-- moment, because that is exactly the state during a rollback: taking Session
-- 6 off means deleting the Session 5 bill it added to, while the Session 6
-- line that says so is still sitting there saying it. Made a link, the two
-- would deadlock and a session could not be taken off at all. Found in
-- rehearsal on 2026-09-14, where it did.
--
-- Nothing is lost by it. The error checker refuses a line naming a bill that
-- is not on the clean sheet, and promotion refuses it again at the gate, so a
-- mistyped number is caught twice before it can do anything.

\set ON_ERROR_STOP on
BEGIN;

ALTER TABLE bill_candidate
  ADD COLUMN continues_bill_id integer;

COMMENT ON COLUMN bill_candidate.continues_bill_id IS
 'The bill already on the clean sheet that this line is a further appearance of, by its number. Filled by hand at review for a line read off a fact sheet that lists a bill which was still live when an earlier session ended; promotion then adds this line''s facts to that bill instead of making a second one. Empty means a bill in its own right, which is every line so far. A line whose introduction date falls before its own fact sheet''s session began and which leaves this empty is refused by the error checker. See methodology note M6.';

ALTER TABLE bill
  ADD COLUMN reintroduced_from_bill_id integer REFERENCES bill(bill_id),
  ADD CONSTRAINT bill_not_reintroduced_from_itself
      CHECK (reintroduced_from_bill_id IS DISTINCT FROM bill_id);

COMMENT ON COLUMN bill.reintroduced_from_bill_id IS
 'The earlier bill whose scrutiny this bill carried, by its number. Filled where a bill was reintroduced after an earlier one ended and did not have to repeat the stages the earlier one completed, so that a chart of how long the bill took can be built either from this bill''s own introduction or from the earlier one''s and say which it used. Empty means the bill did its own scrutiny, which is every bill but one: the Robin Rigg Offshore Wind Farm (Navigation and Fishing) (Scotland) Act 2003, whose Preliminary and Consideration Stages happened to the Session 1 bill of the same name. Both bills are counted. See methodology note M9.';

ALTER TABLE bill_candidate
  ADD COLUMN reintroduced_from_bill_id integer;

COMMENT ON COLUMN bill_candidate.reintroduced_from_bill_id IS
 'Proposed value for bill.reintroduced_from_bill_id: the earlier bill whose scrutiny this bill carried, by its number. Filled by hand at review. Empty means the bill did its own scrutiny, which is every line but one. A line with a stage row marked as a stage that never happened and this cell empty is refused by the error checker. Carried to the clean sheet at promotion.';

COMMIT;
