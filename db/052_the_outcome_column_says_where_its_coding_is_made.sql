-- db/052_the_outcome_column_says_where_its_coding_is_made.sql
--
-- 2026-09-12, immediately after db/051.
--
-- db/051 moved the decision that a bill fell at dissolution out of the fact
-- sheet reader and onto the staging sheet. It should have brought the two
-- columns' descriptions with it and did not. They are the data dictionary, and
-- the dictionary is what lets the owner be the check on every claim this
-- project makes, so a description that describes the old behaviour is not a
-- tidiness problem.
--
-- Separate rather than folded into db/051 because db/051 has been applied, and
-- a migration file has to be what was actually run.
--
-- Nothing but the two descriptions changes.

\set ON_ERROR_STOP on
BEGIN;

COMMENT ON COLUMN bill_candidate.outcome IS
 'What the Parliament did with the bill: passed, withdrawn, or one of the ways a bill can fall. Taken from which of the factsheet''s tables the line sat in — Acts means passed, Withdrawn means withdrawn. A line from the Fallen table arrives empty, because no factsheet says why a bill fell; the reader records that the bill fell and on what date, and nothing more. tools/load_session.sql then proposes fell_dissolution for a line that concluded on the day its session ended, comparing against session.date_session_end, and leaves every other fallen line empty for review — where the distinction is ours to make against the Official Report. Empty therefore means not yet coded, and the error checker refuses to let a line be accepted that way. Should be a code from ref_outcome. Nothing in this table enforces that, but bill.outcome does. See db/051 and methodology note M7.';

COMMENT ON COLUMN bill.outcome IS
 'What the Parliament did with the bill: passed, rejected at Stage 1 or Stage 3, withdrawn, or fell. Allowed values are in ref_outcome. Deliberately separate from whether it became an Act, which is enactment_status. No source states why a bill fell — rejection, defeat at the final vote and running out of time at dissolution are one heading in every factsheet — so the distinction between the values is ours: a Stage 1 rejection against the Official Report, and running out of time at dissolution by the bill having concluded on the day its session ended. Every bill coded either way carries a provenance note on this column saying which source the coding rests on. See methodology note M7.';

-- The reader's own remarks column. Its description gave "a bill that fell
-- before dissolution so the reason is unknown" as an example of what the reader
-- notices, which was its old wording for a fallen bill and is not what it says
-- now.
COMMENT ON COLUMN bill_candidate.parser_note IS
 'What the extraction script noticed while reading this line — a date it could not read, a type letter it did not recognise, a row the factsheet split across a page, a bill the factsheet says fell without saying why. Mechanical observations only; the script never guesses, and since db/051 it makes no claim about why a bill fell. Empty means it saw nothing unusual.';

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n
    FROM pg_description d
    JOIN pg_class c ON c.oid = d.objoid
    JOIN pg_attribute a ON a.attrelid = c.oid AND a.attnum = d.objsubid
   WHERE c.relname IN ('bill','bill_candidate')
     AND a.attname IN ('outcome','parser_note')
     AND (d.description LIKE '%unless it fell on the dissolution date%'
       OR d.description LIKE '%fell before dissolution so the reason is unknown%');
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % description(s) still describe the old behaviour.', n;
  END IF;
  RAISE NOTICE 'Both outcome columns and the reader''s remarks column describe how the coding is now made.';
END $$;

COMMIT;
