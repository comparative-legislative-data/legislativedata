-- db/108_m2_and_m8_rewritten.sql
--
-- M2 and M8 rewritten in the words the owner approved on 2026-09-17
-- (docs/PHASE-2-NOTES.md). Applied together, because the thesis citation moves
-- from M2 to M8 and neither note may be without it for a moment.
--
-- M2 said a session without its Stage 1 and 2 dates has none (every session has
-- them), repeated where dates come from (M8's subject) and got that slightly
-- wrong, explained database mechanics, quoted procedure pages to show how we got
-- there, carried a rule with no case, repeated M9, and ran to 947 words. It now
-- says only when a stage is complete, and how time is counted between stages.
--
-- M8 said only dates where sources disagreed were checked (every bill a fact
-- sheet left awaiting Royal Assent has been checked too, M12), that the sources
-- agree "throughout Sessions 1 and 2" (every session is compared), and missed
-- two sources: SPICe's dates fact sheet and the Supreme Court. It now lists
-- every source by what it owns, and carries the thesis citation.
--
-- Nothing else changes: both titles and applies_to, every other note, and no
-- bill, line, stage record or provenance note.

\set ON_ERROR_STOP on
BEGIN;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM methodology_note
   WHERE code = 'M2' AND body LIKE '%a session whose dates have not yet been added%'
     AND body LIKE '%Does government dominate the legislative process?%';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: M2 is not the wording this replaces.'; END IF;

  SELECT count(*) INTO n FROM methodology_note
   WHERE code = 'M8' AND body LIKE '%Only dates where two sources disagreed have been checked%';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: M8 is not the wording this replaces.'; END IF;
END $$;

CREATE TEMP TABLE before_notes ON COMMIT DROP AS
SELECT code, title, body, applies_to, sort_order FROM methodology_note;

UPDATE methodology_note SET body = 'Every stage is dated at the same point for every bill. Stage 1 ends on the day the Parliament decides whether to agree to the bill''s general principles. Stage 2 ends at the meeting at which the last amendments are disposed of; every bill at Stage 2 has one, because even when no amendments are lodged the committee, or for an emergency bill the whole Parliament, still meets to agree to each section. Stage 3 ends on the day the Parliament votes on whether to pass the bill.

A Private Bill''s Preliminary, Consideration and Final Stages are recorded under those names and dated at the equivalent points: the decision whether it should proceed, the meeting at which the last amendments are disposed of, and the vote to pass. They are different stages from a public bill''s, and are compared with them only by their place in the sequence. The one Hybrid Bill went through Stages 1, 2 and 3 and is dated as a public bill is.

A stage the Parliament decided against, such as general principles not agreed to at Stage 1, carries the date of that decision. A stage at which a bill stopped without any decision, because it was withdrawn or was still at that stage when the session ended, has no date, and a note on it says so in the same words every time.

Time is counted between these dated points, from introduction to Royal Assent. A stage that ended in a decision counts whatever the decision was, so a bill rejected at Stage 1 has a real time to Stage 1. Every period also records whether the bill got through that stage and whether it went on to pass, so a figure can cover every bill that reached a stage or only those that passed, and a chart says which. Where a stage has no date, time is counted across it, from the stage before to the stage after, and never shown as that stage''s own.

Where each date comes from is in M8. A Private Bill that did not repeat stages an earlier bill completed is in M9.'
 WHERE code = 'M2';

UPDATE methodology_note SET body = 'Each bill starts from the Scottish Parliament''s legislation fact sheets, compiled by SPICe, which give its type, when it was introduced, what happened to it and, for an Act, the date of Royal Assent. They are a derived source and have been found wrong, so where another source owns a fact, that source is used:

- for an Act''s date of Royal Assent, its number and its title, legislation.gov.uk;
- for other dates about a bill, the Parliament''s own bill pages and the Official Report, which is also the source for how a bill was rejected;
- for the dates of Stages 1 and 2, the dataset compiled for Steven MacGregor, "Does government dominate the legislative process?" (PhD thesis, University of Stirling, 2021), maintained since to cover Sessions 6 and 7, used where no source above gives the date and nothing contradicts it;
- for when each session began and ended, SPICe''s fact sheet of recess and dissolution dates;
- for the date the Supreme Court ruled on a reference, the Court''s own case page.

The Explanatory Notes published with an Act give its parliamentary passage, but are not used, because they are written by government officials rather than by the Parliament''s.

When a session is added, its dates and bill types are compared with the thesis dataset. Where the two disagree, the difference is settled against the source that owns the fact, and the value then names that source. Nothing is settled silently or averaged. No disagreement about a bill''s type has arisen, so which source would settle one has not been decided.

A value that names its own source has been checked against it, and says which page and the day it was read. That includes every value where the sources disagreed, and every bill a fact sheet left awaiting Royal Assent (M12). Every other value stands on the fact sheet and has not been checked individually. Agreeing with the thesis dataset, which was compiled independently, is weaker evidence than checking the Act itself and stronger than one source alone.'
 WHERE code = 'M8';

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM methodology_note m JOIN before_notes b USING (code)
   WHERE (m.code NOT IN ('M2', 'M8') AND (m.title, m.body, m.applies_to, m.sort_order)
          IS DISTINCT FROM (b.title, b.body, b.applies_to, b.sort_order))
      OR (m.title, m.applies_to, m.sort_order) IS DISTINCT FROM (b.title, b.applies_to, b.sort_order);
  IF n > 0 THEN RAISE EXCEPTION '% note(s) changed beyond the two bodies.', n; END IF;

  SELECT count(*) INTO n FROM methodology_note
   WHERE body LIKE '%"Does government dominate the legislative process?" (PhD thesis, University of Stirling, 2021)%';
  IF n <> 1 THEN RAISE EXCEPTION 'The thesis is cited in full by % notes, expected 1 (M8).', n; END IF;
  SELECT count(*) INTO n FROM methodology_note WHERE code = 'M8' AND body LIKE '%University of Stirling, 2021%';
  IF n <> 1 THEN RAISE EXCEPTION 'M8 does not carry the thesis citation.'; END IF;

  SELECT count(*) INTO n FROM methodology_note WHERE code = 'M2' AND body ~ '[a-z_]+\.[a-z_]+';
  IF n > 0 THEN RAISE EXCEPTION 'M2 names a column.'; END IF;

  SELECT count(*) INTO n FROM methodology_note; IF n <> 14 THEN RAISE EXCEPTION '% notes', n; END IF;
  SELECT count(*) INTO n FROM bill; IF n <> 470 THEN RAISE EXCEPTION '% bills', n; END IF;
  SELECT count(*) INTO n FROM field_source; IF n <> 192 THEN RAISE EXCEPTION '% provenance notes', n; END IF;
  SELECT count(*) INTO n FROM v_candidate_problems; IF n <> 0 THEN RAISE EXCEPTION 'checker %', n; END IF;

  RAISE NOTICE 'M2 and M8 rewritten. Nothing else changed.';
END $$;

COMMIT;
