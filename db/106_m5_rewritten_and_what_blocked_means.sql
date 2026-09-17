-- db/106_m5_rewritten_and_what_blocked_means.sql
--
-- M5, and the meaning a reader sees for the status "Blocked", rewritten in the
-- words the owner approved on 2026-09-17 (docs/PHASE-2-NOTES.md). No methodology
-- note is published with an open question against it; M5 had three.
--
-- WHAT WAS WRONG, and is not carried into the new wording:
--   * It dated all three section 33 rulings to 6 October 2021. The Legal
--     Continuity Bill's was 13 December 2018, now also on the bill (db/105).
--   * It said how a bill was stopped is recorded in the bill's note. Since
--     db/084 it has a cell of its own, and so does what followed.
--   * Its closing sentences said the four bills' story ran ahead of the data
--     until later fact sheets were read in. Every session is read in, and all
--     four bills are recorded as they stand.
--   * It sent a reader to the fact sheet lines for a bill's earlier state. The
--     staging sheet is never published (DECISIONS.md, 17 September).
--   * It named database columns. The notes are to be in readers' words when the
--     published layout is built, so the rewrite names none.
--   * It ran to 470 words. The rule set by M12 (DECISIONS.md, 15 September): a
--     note says what the judgement is and what follows, not how we got there.
-- "Blocked" repeated the second fault and named two columns.
--
-- Nothing else changes: M5's title and applies_to, every other note, every
-- other value's meaning, and no bill, line, stage record or provenance note.

\set ON_ERROR_STOP on
BEGIN;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM methodology_note
   WHERE code = 'M5' AND body LIKE '%ruled against on 6 October 2021%'
     AND body LIKE '%runs ahead of the%';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: M5 is not the wording this replaces.'; END IF;

  SELECT count(*) INTO n FROM ref_enactment_status
   WHERE code = 'blocked' AND definition LIKE '%recorded in bill.note%';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: the meaning of blocked is not the wording this replaces.'; END IF;

  SELECT count(*) INTO n FROM bill WHERE date_assent_blocked = DATE '2018-12-13' AND bill_id = 305;
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: db/105 has not dated bill 305, which the new M5 states.'; END IF;
END $$;

CREATE TEMP TABLE before_notes ON COMMIT DROP AS
SELECT code, title, body, applies_to, sort_order, updated_at FROM methodology_note;
CREATE TEMP TABLE before_status ON COMMIT DROP AS
SELECT code, label, definition, sort_order FROM ref_enactment_status;

UPDATE methodology_note SET body = 'A bill the Parliament has passed becomes an Act only when it receives Royal Assent, and it can be stopped before it is submitted: by a reference to the Supreme Court under section 33 of the Scotland Act 1998, or by an order of a UK Government minister under section 35. So what the Parliament did with a bill is recorded separately from whether it became an Act, and a count of bills passed is not a count of Acts.

Four bills have been stopped. The UK Withdrawal from the European Union (Legal Continuity) (Scotland) Bill was referred under section 33; the Supreme Court ruled on 13 December 2018, and the bill was withdrawn on 10 March 2022. The UNCRC (Incorporation) (Scotland) Bill and the European Charter of Local Self-Government (Incorporation) (Scotland) Bill were referred under section 33, and the Supreme Court ruled on 6 October 2021; both were reconsidered, passed again and became Acts. The Gender Recognition Reform (Scotland) Bill was stopped by a section 35 order on 16 January 2023, and remains stopped.

A stopped bill does not fall when its session ends: it stays live, and later fact sheets carry it forward. For each of the four we record how it was stopped, when, and what happened next. A bill stopped and later enacted is recorded as enacted, and keeps the date it was stopped.'
 WHERE code = 'M5';

UPDATE ref_enactment_status SET definition = 'Passed, but stopped from being submitted for Royal Assent, by a Supreme Court ruling on a section 33 reference or by an order under section 35 of the Scotland Act 1998, and neither enacted nor withdrawn since. A bill can stay in this state indefinitely. See methodology note M5.'
 WHERE code = 'blocked';

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM methodology_note m JOIN before_notes b USING (code)
   WHERE m.code <> 'M5' AND (m.title, m.body, m.applies_to, m.sort_order)
         IS DISTINCT FROM (b.title, b.body, b.applies_to, b.sort_order);
  IF n > 0 THEN RAISE EXCEPTION '% other note(s) changed.', n; END IF;

  SELECT count(*) INTO n FROM methodology_note m JOIN before_notes b USING (code)
   WHERE m.code = 'M5' AND (m.title, m.applies_to, m.sort_order)
         IS DISTINCT FROM (b.title, b.applies_to, b.sort_order);
  IF n > 0 THEN RAISE EXCEPTION 'M5''s title, applies_to or position changed.'; END IF;

  SELECT count(*) INTO n FROM ref_enactment_status s JOIN before_status b USING (code)
   WHERE (s.code <> 'blocked' AND s.definition IS DISTINCT FROM b.definition)
      OR s.label IS DISTINCT FROM b.label OR s.sort_order IS DISTINCT FROM b.sort_order;
  IF n > 0 THEN RAISE EXCEPTION '% other value(s) of enactment status changed.', n; END IF;

  SELECT count(*) INTO n FROM methodology_note
   WHERE code = 'M5' AND (body ~ '[a-z_]+\.[a-z_]+' OR body LIKE '%6 October 2021: the%');
  IF n > 0 THEN RAISE EXCEPTION 'M5 still names a column or carries the old date.'; END IF;

  SELECT count(*) INTO n FROM methodology_note; IF n <> 14 THEN RAISE EXCEPTION '% notes', n; END IF;
  SELECT count(*) INTO n FROM bill; IF n <> 470 THEN RAISE EXCEPTION '% bills', n; END IF;
  SELECT count(*) INTO n FROM stage_event; IF n <> 1291 THEN RAISE EXCEPTION '% stage records', n; END IF;
  SELECT count(*) INTO n FROM field_source; IF n <> 188 THEN RAISE EXCEPTION '% provenance notes', n; END IF;
  SELECT count(*) INTO n FROM v_candidate_problems; IF n <> 0 THEN RAISE EXCEPTION 'checker %', n; END IF;

  RAISE NOTICE 'M5 rewritten, % words; blocked''s meaning rewritten. Nothing else changed.',
    (SELECT array_length(regexp_split_to_array(body, '\s+'), 1) FROM methodology_note WHERE code = 'M5');
END $$;

COMMIT;
