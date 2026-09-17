-- db/110_m6_rewritten.sql
--
-- M6 rewritten in the words the owner approved on 2026-09-17
-- (docs/PHASE-2-NOTES.md, "M6").
--
-- Every fact in M6 was right. What was wrong: "six pairs of bills" were
-- reintroduced, which the data cannot check (only Robin Rigg is linked, and
-- matching titles finds nine); totals and Session 7 counts (474, 473, 470, 80
-- and 1 against 82 and 2) that move each time Session 7's fact sheet is read
-- again, as M7's list of sessions did; how the database sees it ("one bill and
-- two fact sheet rows"); headings in capitals; 625 words. It now gives the
-- difference from each session's fact sheet total (none for Sessions 1 to 5,
-- two for Session 6, one for Session 7), which moves only if another bill is
-- left stopped across a session end.
--
-- Kept, as settled on 2026-09-14: every chart of bill numbers carries this note;
-- a rewritten note keeps its earlier wording with its source.
--
-- Nothing else changes: the title and applies_to, every other note, and no
-- bill, line, stage record or provenance note.

\set ON_ERROR_STOP on
BEGIN;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM methodology_note
   WHERE code = 'M6' AND body LIKE '%Six pairs of bills do this.%';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: M6 is not the wording this replaces.'; END IF;
END $$;

CREATE TEMP TABLE before_notes ON COMMIT DROP AS
SELECT code, title, body, applies_to, sort_order FROM methodology_note;

UPDATE methodology_note SET body = 'A bill is counted once, in the session in which it was introduced, however long it takes and whatever happens to it later. Its later events are recorded on the same bill, so what is held is the whole of its life rather than the part that fell inside one session.

The Parliament''s fact sheets count differently: a bill still live when a session ends is listed again in the next session''s fact sheet and counted in both. Four bills are affected. The United Nations Convention on the Rights of the Child (Incorporation) and European Charter of Local Self-Government (Incorporation) Bills were introduced and passed in Session 5, stopped before Royal Assent, and reconsidered and enacted in Session 6; here they are Session 5 bills. The Gender Recognition Reform Bill was introduced and passed in Session 6, blocked by a section 35 order, and is listed again in Session 7''s fact sheet; here it is a Session 6 bill. The UK Withdrawal from the European Union (Legal Continuity) Bill was passed in Session 5 and withdrawn in Session 6; Session 6''s fact sheet lists it separately and leaves it out of its totals.

So our count for each session matches the fact sheet''s own total for Sessions 1 to 5, is two lower for Session 6 and one lower for Session 7. Added across every session, the fact sheets'' totals count three bills twice.

A bill that ended, by falling, being withdrawn or being rejected, and was then introduced again is two bills, each counted in its own session. A reintroduced Private Bill may not repeat scrutiny the earlier bill completed, which changes how long the second bill appears to take; M9 is about that.

Counting a bill in every session in which it was live, as the fact sheets do, was rejected: it makes a bill''s session ambiguous and the total depend on how the sessions are added up. Every chart of how many bills there were carries this note, so a reader can see what the rule did and disagree with it.

Where a later fact sheet changes what a bill''s note should say, the note is rewritten, and its earlier wording is kept with its source.'
 WHERE code = 'M6';

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM methodology_note m JOIN before_notes b USING (code)
   WHERE (m.code <> 'M6' AND (m.title, m.body, m.applies_to, m.sort_order)
          IS DISTINCT FROM (b.title, b.body, b.applies_to, b.sort_order))
      OR (m.title, m.applies_to, m.sort_order) IS DISTINCT FROM (b.title, b.applies_to, b.sort_order);
  IF n > 0 THEN RAISE EXCEPTION '% note(s) changed beyond M6''s body.', n; END IF;

  SELECT count(*) INTO n FROM methodology_note WHERE code = 'M6' AND body ~ '[a-z_]+\.[a-z_]+';
  IF n > 0 THEN RAISE EXCEPTION 'M6 names a column.'; END IF;

  -- What M6 says about the counts is true of the data.
  SELECT count(*) INTO n FROM bill_candidate WHERE continues_bill_id IS NOT NULL;
  IF n <> 4 THEN RAISE EXCEPTION '% bills listed in two fact sheets, M6 says four.', n; END IF;
  SELECT count(*) INTO n FROM (
    SELECT c.session_number, count(*) - count(*) FILTER (WHERE c.continues_bill_id IS NULL) AS diff
      FROM bill_candidate c GROUP BY 1) d
   WHERE diff <> CASE session_number WHEN 6 THEN 3 WHEN 7 THEN 1 ELSE 0 END;
  IF n > 0 THEN RAISE EXCEPTION 'The sessions'' second listings are not 3 in Session 6 and 1 in Session 7.'; END IF;

  SELECT count(*) INTO n FROM methodology_note; IF n <> 14 THEN RAISE EXCEPTION '% notes', n; END IF;
  SELECT count(*) INTO n FROM bill; IF n <> 470 THEN RAISE EXCEPTION '% bills', n; END IF;
  SELECT count(*) INTO n FROM field_source; IF n <> 192 THEN RAISE EXCEPTION '% provenance notes', n; END IF;
  SELECT count(*) INTO n FROM v_candidate_problems; IF n <> 0 THEN RAISE EXCEPTION 'checker %', n; END IF;

  RAISE NOTICE 'M6 rewritten. Nothing else changed.';
END $$;

COMMIT;
