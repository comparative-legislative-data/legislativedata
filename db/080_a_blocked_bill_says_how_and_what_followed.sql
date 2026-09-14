-- db/080_a_blocked_bill_says_how_and_what_followed.sql
--
-- Two cells that record a bill having been stopped before Royal Assent: how it
-- was stopped, and what happened to it afterwards.
--
-- Agreed with the owner on 2026-09-14, as part of the piece of work STATE.md
-- puts before Session 6 is loaded. The owner's reasoning, in their words: "it
-- is clearly essential that users (and us) know that the Bill passed, was
-- blocked and was then withdrawn. That's the three elements which all of these
-- cases share."
--
-- -------------------------------------------------------------------------
-- Why the existing cells are not enough.
--
-- Four bills passed and were stopped before Royal Assent. Today each carries
-- outcome = passed and enactment_status = blocked, and three of the four carry
-- the date they were stopped. That is a true record of where they stand while
-- they stand there -- and it is erased the moment they move on. The European
-- Charter and UNCRC Bills were reconsidered and are now enacted Acts; once
-- Session 6 is promoted their enactment_status will read 'enacted' and nothing
-- on the row will say either bill was ever stopped. The UK Withdrawal (Legal
-- Continuity) Bill is worse: its fact sheet footnote gives no date at all, so
-- even date_assent_blocked is empty for it, and after its withdrawal is
-- recorded there would be no trace of the block anywhere.
--
-- So the fact that a bill was blocked needs a cell of its own, and it may as
-- well be the cell that says how it ended. That is assent_block_outcome:
-- filled means the bill was blocked, and says what followed.
--
-- outcome is not touched. All four bills passed, and passed is what the
-- Parliament did with them. enactment_status is not touched either: it carries
-- where the bill ended up, which is a different question and already right.
--
-- -------------------------------------------------------------------------
-- Why the mechanism gets a cell too.
--
-- The section 33 and section 35 routes are different events with different
-- actors: a reference to the Supreme Court by the law officers, and an order by
-- a UK Government minister. The fact sheets state which in a footnote, and the
-- footnote is already captured word for word on every staging line that has
-- one, so nothing has to be read again.
--
-- STATE.md has carried this as a question since 2026-09-11, to be revisited at
-- a fifth bill. There is no fifth. It is taken now because the block is being
-- given a proper shape anyway, and because taking it later would mean
-- re-reading four footnotes and reopening whichever sessions they sit in. The
-- owner's reasoning: "it's of scholarly interest."
--
-- -------------------------------------------------------------------------
-- What this migration does not do.
--
-- It adds no constraint tying the two cells to enactment_status. Three bills on
-- the clean sheet are blocked and have neither cell filled, so such a
-- constraint would refuse the database it is added to. The values arrive on the
-- staging sheet in db/084 and reach the clean sheet by the ordinary route --
-- Session 5 taken off and put back -- and db/085 adds the constraints once the
-- data satisfies them. That is db/078's shape.

\set ON_ERROR_STOP on
BEGIN;

-- ---------------------------------------------------------------------------
-- The two dropdown lists
-- ---------------------------------------------------------------------------

CREATE TABLE ref_assent_block_route (
    code        text PRIMARY KEY,
    label       text NOT NULL,
    definition  text,
    sort_order  integer NOT NULL DEFAULT 0
);

-- Owned by legdata, like the other dropdown lists and the error checker, for
-- the reason db/031 records: migrations run as postgres, and the checker reads
-- with its owner's permissions.
ALTER TABLE ref_assent_block_route OWNER TO legdata;

INSERT INTO ref_assent_block_route (code, label, definition, sort_order) VALUES
 ('s33_reference',
  'Section 33 reference to the Supreme Court',
  'A law officer referred the bill to the Supreme Court under section 33 of the Scotland Act 1998, on the question whether it was within the Parliament''s legislative competence, and the Court ruled that some of its provisions were not. Three bills, all in Session 5, all referred by the Attorney General and the Advocate General for Scotland and all ruled on by the Court on 6 October 2021. The fact sheet''s own footnote for each is kept word for word as the provenance of enactment_status.',
  1),
 ('s35_order',
  'Section 35 order by a UK Government minister',
  'A Secretary of State made an order under section 35 of the Scotland Act 1998 prohibiting the Presiding Officer from submitting the bill for Royal Assent. One bill, the Gender Recognition Reform (Scotland) Bill of Session 6, on 16 January 2023. No court was involved: this is an executive decision, not a ruling on competence, which is why it is not the same value as a section 33 reference.',
  2);

COMMENT ON TABLE ref_assent_block_route IS
 'How a bill that had passed came to be stopped before Royal Assent. Every allowed value for bill.assent_block_route is a row here, with its own definition, so a value can be added or re-labelled without changing the schema and so each one carries the text explaining it to a reader. See methodology note M5.';
COMMENT ON COLUMN ref_assent_block_route.code IS
 'The short word stored in bill.assent_block_route and used in queries. Readable on purpose, so a row shows "s35_order" rather than a number that has to be looked up.';
COMMENT ON COLUMN ref_assent_block_route.label IS
 'The wording shown to a reader wherever the value appears on the site.';
COMMENT ON COLUMN ref_assent_block_route.definition IS
 'What the value means, in enough detail for a reader to judge whether it is the right one. Empty means nobody has written the definition yet.';
COMMENT ON COLUMN ref_assent_block_route.sort_order IS
 'The order the values are listed in, smallest first. Not alphabetical, so the list can read in the order that makes sense.';

CREATE TABLE ref_assent_block_outcome (
    code        text PRIMARY KEY,
    label       text NOT NULL,
    definition  text,
    sort_order  integer NOT NULL DEFAULT 0
);

ALTER TABLE ref_assent_block_outcome OWNER TO legdata;

INSERT INTO ref_assent_block_outcome (code, label, definition, sort_order) VALUES
 ('still_blocked',
  'Still blocked',
  'The bill has been neither reconsidered nor withdrawn since it was stopped, and it has not received Royal Assent. It has not fallen: a bill that has passed does not fall at dissolution the way an unfinished bill does, which is why the Gender Recognition Reform Bill is still counted as a live bill by the Session 7 fact sheet. The value is a statement about the latest reading of the sources, not a prediction.',
  1),
 ('withdrawn',
  'Withdrawn after being blocked',
  'The bill was withdrawn after it was stopped, so it will not become an Act. Its enactment_status is not_enacted and date_concluded holds the day it was withdrawn. One bill: the UK Withdrawal from the European Union (Legal Continuity) (Scotland) Bill, withdrawn on 10 March 2022, which the Session 6 fact sheet prints in a section of its own and excludes from that session''s totals.',
  2),
 ('reconsidered_passed',
  'Reconsidered and passed',
  'The Parliament reconsidered the bill under the Reconsideration Stage, approved it, and it went on to Royal Assent. Its enactment_status is enacted, and its Reconsideration Stage row carries the date the stage ended. Two bills, both Session 5 bills reconsidered in Session 6.',
  3),
 ('reconsidered_fell',
  'Reconsidered and fell',
  'The Parliament reconsidered the bill under the Reconsideration Stage and did not approve it, so the bill fell there. No bill has done this. The value exists so that the next one has somewhere to go, and the owner agreed to it on that basis on 2026-09-14; nothing in the database uses it, and the error checker will refuse it unless the bill has a Reconsideration Stage row where it ended.',
  4);

COMMENT ON TABLE ref_assent_block_outcome IS
 'What happened to a bill after it was stopped before Royal Assent. Every allowed value for bill.assent_block_outcome is a row here, with its own definition, so a value can be added or re-labelled without changing the schema and so each one carries the text explaining it to a reader. See methodology note M5.';
COMMENT ON COLUMN ref_assent_block_outcome.code IS
 'The short word stored in bill.assent_block_outcome and used in queries. Readable on purpose, so a row shows "reconsidered_passed" rather than a number that has to be looked up.';
COMMENT ON COLUMN ref_assent_block_outcome.label IS
 'The wording shown to a reader wherever the value appears on the site.';
COMMENT ON COLUMN ref_assent_block_outcome.definition IS
 'What the value means, in enough detail for a reader to judge whether it is the right one. Empty means nobody has written the definition yet.';
COMMENT ON COLUMN ref_assent_block_outcome.sort_order IS
 'The order the values are listed in, smallest first. Not alphabetical, so the list can read in the order that makes sense.';

-- ---------------------------------------------------------------------------
-- The cells, on the clean sheet and on the staging sheet
-- ---------------------------------------------------------------------------

ALTER TABLE bill
  ADD COLUMN assent_block_route   text REFERENCES ref_assent_block_route(code),
  ADD COLUMN assent_block_outcome text REFERENCES ref_assent_block_outcome(code);

COMMENT ON COLUMN bill.assent_block_route IS
 'How the bill was stopped before Royal Assent after it had passed: a section 33 reference to the Supreme Court, or a section 35 order by a UK Government minister. Allowed values are in ref_assent_block_route. Empty means the bill was never stopped, which is all but three bills today, and will be all but four once Session 6 is loaded. Kept even after the block is lifted, so a bill that was reconsidered and is now an Act still says how it was held up. See methodology note M5.';
COMMENT ON COLUMN bill.assent_block_outcome IS
 'What happened to the bill after it was stopped before Royal Assent: still blocked, withdrawn, reconsidered and passed, or reconsidered and fell. Allowed values are in ref_assent_block_outcome. Empty means the bill was never stopped, which is all but three bills today, and will be all but four once Session 6 is loaded. This cell, not enactment_status, is the lasting record that a bill was stopped: enactment_status says where the bill ended up and moves on when it does. See methodology note M5.';

ALTER TABLE bill_candidate
  ADD COLUMN assent_block_route   text,
  ADD COLUMN assent_block_outcome text;

COMMENT ON COLUMN bill_candidate.assent_block_route IS
 'Proposed value for bill.assent_block_route: how the bill was stopped before Royal Assent, read from the fact sheet footnote kept in raw_footnote. Should be a code from ref_assent_block_route; nothing in this table enforces that, but bill.assent_block_route does. Empty means the bill was never stopped. Carried to the clean sheet at promotion.';
COMMENT ON COLUMN bill_candidate.assent_block_outcome IS
 'Proposed value for bill.assent_block_outcome: what happened to the bill after it was stopped before Royal Assent. Should be a code from ref_assent_block_outcome; nothing in this table enforces that, but bill.assent_block_outcome does. Empty means the bill was never stopped. Carried to the clean sheet at promotion.';

COMMIT;
