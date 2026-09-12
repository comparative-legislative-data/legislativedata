-- db/047_two_families_of_spice_factsheet_named_apart.sql
--
-- Settled by the owner on 2026-09-12.
--
-- Until now there was one SPICe factsheet as far as this database was
-- concerned, so `spice_factsheet` needed no qualifier. That stops being true
-- today: the owner has added "Dates of recess, dissolution, parliamentary years
-- and recalls of Parliament", published by SPICe on 2 September 2026, which is
-- a different document about a different subject. SPICe publishes many
-- factsheets and more will be met.
--
-- So the families are named apart before the second one is used, rather than
-- after. The cost is paid once and it only ever grows: the old code is written
-- on 154 bills, 154 staging lines, 128 stage records and 128 stage-date rows,
-- and every session loaded from here would add to that.
--
-- Nothing about any bill changes. This renames a source and adds another; no
-- date, outcome, type or note moves. The definitions are rewritten so each says
-- which document it means and what to put in source_ref, because two sources
-- whose names differ by one word have to be told apart by their descriptions.
--
-- The old code is removed rather than left as an alias. An alias would let a
-- later load quietly write the ambiguous name again.

\set ON_ERROR_STOP on
BEGIN;

-- ---------------------------------------------------------------------------
-- 1. The two families
-- ---------------------------------------------------------------------------

INSERT INTO ref_source (code, label, definition, sort_order) VALUES
 ('spice_factsheet_legislation',
  'SPICe legislation factsheet',
  'One of SPICe''s per-session legislation factsheets: the list of bills introduced in a session and what happened to each. A derived source: the outcome and type coding is theirs. Put the session and retrieval date in source_ref, e.g. "session 6, retrieved 2026-09-10". The retrieved copy is in sources/factsheets/. Called spice_factsheet until db/047, when a second family of SPICe factsheet arrived and the two had to be told apart.',
  2),
 ('spice_factsheet_dates',
  'SPICe dates factsheet',
  'SPICe''s factsheet "Dates of recess, dissolution, parliamentary years and recalls of Parliament": when each session began and ended, when the Parliament was in recess or dissolved, and when it was recalled. One document covering every session, not one per session, so put the publication date and the page in source_ref, e.g. "published 2 September 2026, p2". A derived source, and hand-maintained -- it carries at least one typographical error in its own tables -- so it is read with the same care as any other factsheet. The retrieved copy is in sources/factsheets/.',
  9);

-- ---------------------------------------------------------------------------
-- 2. Every row that carried the old name now carries the new one
--
-- The foreign keys do not cascade on update, so the new code is added, the rows
-- are moved across, and the old code is then removed. bill_candidate and
-- stage_candidate hold the code without a foreign key and are moved too.
-- ---------------------------------------------------------------------------

UPDATE bill            SET source = 'spice_factsheet_legislation' WHERE source = 'spice_factsheet';
UPDATE stage_event     SET source = 'spice_factsheet_legislation' WHERE source = 'spice_factsheet';
UPDATE field_source    SET source = 'spice_factsheet_legislation' WHERE source = 'spice_factsheet';
UPDATE bill_candidate  SET source = 'spice_factsheet_legislation' WHERE source = 'spice_factsheet';
UPDATE stage_candidate SET source = 'spice_factsheet_legislation' WHERE source = 'spice_factsheet';

DELETE FROM ref_source WHERE code = 'spice_factsheet';

-- ---------------------------------------------------------------------------
-- 3. What should now be true
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer; m integer;
BEGIN
  SELECT count(*) INTO n FROM ref_source WHERE code = 'spice_factsheet';
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: the ambiguous source code is still on the list.';
  END IF;

  SELECT count(*) INTO n FROM bill            WHERE source = 'spice_factsheet_legislation';
  IF n <> 154 THEN RAISE EXCEPTION 'Refusing: % bills on the renamed source, expected 154.', n; END IF;

  SELECT count(*) INTO n FROM bill_candidate  WHERE source = 'spice_factsheet_legislation';
  IF n <> 154 THEN RAISE EXCEPTION 'Refusing: % staging lines, expected 154.', n; END IF;

  SELECT count(*) INTO n FROM stage_event     WHERE source = 'spice_factsheet_legislation';
  IF n <> 128 THEN RAISE EXCEPTION 'Refusing: % stage records, expected 128.', n; END IF;

  SELECT count(*) INTO n FROM stage_candidate WHERE source = 'spice_factsheet_legislation';
  IF n <> 128 THEN RAISE EXCEPTION 'Refusing: % stage-date rows, expected 128.', n; END IF;

  -- The new source is on the list and nothing uses it yet. db/048 is the first
  -- use; if anything already carried it, something has been loaded out of order.
  SELECT count(*) INTO n FROM ref_source WHERE code = 'spice_factsheet_dates';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: the dates factsheet is not on the list.'; END IF;

  SELECT count(*) INTO m FROM field_source WHERE source = 'spice_factsheet_dates';
  IF m > 0 THEN
    RAISE EXCEPTION 'Refusing: % row(s) already cite the dates factsheet before it is loaded.', m;
  END IF;

  SELECT count(*) INTO n FROM ref_source;
  IF n <> 9 THEN RAISE EXCEPTION 'Refusing: % sources, expected 9.', n; END IF;

  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: the error checker is not empty (% problem(s)).', n;
  END IF;

  RAISE NOTICE 'Two SPICe families named apart. 564 rows moved to spice_factsheet_legislation; spice_factsheet_dates added and unused.';
END $$;

COMMIT;
