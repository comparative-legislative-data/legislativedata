-- db/116_the_sources_own_words_are_the_sources.sql
--
-- value_seen is published as value_as_the_source_gave_it, and M8 tells a reader
-- it holds "the value in the source's own words". On 2026-09-18 only 38 of the
-- 192 lines did. The owner agreed the proposal in
-- docs/PHASE-2-SOURCE-WORDS.md (DECISIONS.md, 2026-09-18):
--
--   1. 91 lines that only repeated the cell, in our format (2021-03-30,
--      stage_3, enacted), are emptied. The rule: the source's own words where
--      they say something the cell does not; empty where the cell already says
--      it, or where no one wording carries it.
--   2. The 31 outcomes read from the Official Report held our account of the
--      decision. Each is split: the account moves to the note, where our words
--      belong, and value_seen keeps only the passages the Official Report
--      printed, word for word and in order, separated by " … ". A passage the
--      account quotes from the bill page is not the Official Report's and is
--      left out (the Restricted Roads (20 mph Speed Limit) (Scotland) Bill). The
--      14 that quote nothing are left empty.
--   3. The seven from Session 6 lose the review note's opening phrase,
--      "Outcome from the Official Report, not the fact sheet:", which promotion
--      failed to cut because it looked for "factsheet". The account's first
--      letter is made a capital, as it now opens a note.
--
-- tools/promote_session.sql writes all of these except the 13 session dates,
-- and changes in the same commit to write the same, so a session taken off and
-- put back comes back as this leaves it. Rehearsed as db/115 was: every session
-- taken off and put back inside a thrown-away transaction, compared cell by
-- cell.
--
-- WHAT DOES NOT CHANGE. The other 70 values; every note but the 31; any other
-- column of any line; any bill, stage record or methodology note.

\set ON_ERROR_STOP on
BEGIN;

DO $$
BEGIN
  IF (SELECT md5(string_agg(field_source_id || chr(9) || coalesce(value_seen, chr(1)) || chr(9) || coalesce(note, chr(1)), chr(10) ORDER BY field_source_id))
        FROM field_source) <> 'ba368e0f80d2671a25bb60524a7b5995' THEN
    RAISE EXCEPTION 'Refusing: the provenance lines are not the ones this was written against.';
  END IF;
END $$;

CREATE TEMP TABLE fs_before ON COMMIT DROP AS SELECT * FROM field_source;

DO $$
DECLARE n integer;
BEGIN
  -- 1. A value that only repeats its cell.
  UPDATE field_source f
     SET value_seen = NULL
   WHERE f.value_seen IS NOT NULL
     AND f.value_seen = CASE f.entity
           WHEN 'bill'        THEN (SELECT to_jsonb(b) ->> f.field_name FROM bill b WHERE b.bill_id = f.entity_id)
           WHEN 'session'     THEN (SELECT to_jsonb(s) ->> f.field_name FROM session s WHERE s.session_number = f.entity_id)
           WHEN 'stage_event' THEN (SELECT to_jsonb(e) ->> f.field_name FROM stage_event e WHERE e.stage_event_id = f.entity_id)
         END;
  GET DIAGNOSTICS n = ROW_COUNT;
  IF n <> 91 THEN RAISE EXCEPTION '1: % values emptied, expected 91.', n; END IF;

  -- 2 and 3. The Official Report outcomes, split.
  WITH acc AS (
    SELECT f.field_source_id,
           upper(left(a.t, 1)) || substr(a.t, 2) AS account
      FROM field_source f
     CROSS JOIN LATERAL (SELECT regexp_replace(f.value_seen,
             '^Outcome from the Official Report, not the fact ?sheet:\s*', '') AS t) a
     WHERE f.entity = 'bill' AND f.field_name = 'outcome' AND f.source = 'official_report')
  UPDATE field_source f
     SET note = acc.account,
         value_seen = (SELECT string_agg(q[1], ' … ' ORDER BY k)
                         FROM regexp_matches(
                                regexp_replace(acc.account, 'bill page[^"]*"[^"]*"', 'bill page', 'g'),
                                '"([^"]*)"', 'g') WITH ORDINALITY AS m(q, k))
    FROM acc
   WHERE f.field_source_id = acc.field_source_id
     AND f.note IS NULL;
  GET DIAGNOSTICS n = ROW_COUNT;
  IF n <> 31 THEN RAISE EXCEPTION '2: % outcomes split, expected 31.', n; END IF;
END $$;

COMMENT ON COLUMN field_source.value_seen IS
 'The source''s own words, before any tidying: what was actually printed or said, not what we made of it. Empty where the cell already says it, or where the fact is our coding and no one wording carries it. For an outcome read from the Official Report, the passages it printed, word for word and in order, separated by " … "; our account of the decision is in the note. Published as value_as_the_source_gave_it.';

DO $$
DECLARE n integer;
BEGIN
  -- Only value_seen and note moved, on the lines they were meant to.
  SELECT count(*) INTO n FROM field_source f FULL JOIN fs_before b USING (field_source_id)
   WHERE f.field_source_id IS NULL OR b.field_source_id IS NULL
      OR (f.entity, f.entity_id, f.field_name, f.source, f.source_ref, f.observed_at, f.created_at)
         IS DISTINCT FROM (b.entity, b.entity_id, b.field_name, b.source, b.source_ref, b.observed_at, b.created_at);
  IF n <> 0 THEN RAISE EXCEPTION '% lines changed in something other than the value and the note.', n; END IF;
  SELECT count(*) INTO n FROM field_source f JOIN fs_before b USING (field_source_id)
   WHERE f.note IS DISTINCT FROM b.note;
  IF n <> 31 THEN RAISE EXCEPTION '% notes changed, expected 31.', n; END IF;
  SELECT count(*) INTO n FROM field_source f JOIN fs_before b USING (field_source_id)
   WHERE f.value_seen IS DISTINCT FROM b.value_seen;
  IF n <> 122 THEN RAISE EXCEPTION '% values changed, expected 122.', n; END IF;

  -- What the column now holds.
  SELECT count(*) INTO n FROM field_source WHERE value_seen IS NOT NULL;
  IF n <> 55 THEN RAISE EXCEPTION '% values left, expected 55: 38 own words and 17 Official Report passages.', n; END IF;
  SELECT count(*) INTO n FROM field_source f
   WHERE f.value_seen = CASE f.entity
           WHEN 'bill'        THEN (SELECT to_jsonb(b) ->> f.field_name FROM bill b WHERE b.bill_id = f.entity_id)
           WHEN 'session'     THEN (SELECT to_jsonb(s) ->> f.field_name FROM session s WHERE s.session_number = f.entity_id)
           WHEN 'stage_event' THEN (SELECT to_jsonb(e) ->> f.field_name FROM stage_event e WHERE e.stage_event_id = f.entity_id)
         END;
  IF n <> 0 THEN RAISE EXCEPTION '% values still only repeat their cell.', n; END IF;
  SELECT count(*) INTO n FROM field_source
   WHERE note LIKE 'Outcome from the Official Report%' OR value_seen LIKE 'Outcome from the Official Report%';
  IF n <> 0 THEN RAISE EXCEPTION '% lines still carry the review note''s opening phrase.', n; END IF;
  SELECT count(*) INTO n FROM field_source WHERE value_seen ~ 'That the Parliament agrees to the general principles of the Restricted Roads';
  IF n <> 0 THEN RAISE EXCEPTION 'The bill page''s motion text is in the Official Report''s words.'; END IF;
  SELECT count(*) INTO n FROM field_source
   WHERE field_name = 'outcome' AND source = 'official_report' AND value_seen IS NULL;
  IF n <> 14 THEN RAISE EXCEPTION '% Official Report outcomes with no passage, expected 14.', n; END IF;

  SELECT count(*) INTO n FROM methodology_note; IF n <> 14 THEN RAISE EXCEPTION '% notes', n; END IF;
  SELECT count(*) INTO n FROM bill; IF n <> 470 THEN RAISE EXCEPTION '% bills', n; END IF;
  SELECT count(*) INTO n FROM stage_event; IF n <> 1291 THEN RAISE EXCEPTION '% stage records', n; END IF;
  SELECT count(*) INTO n FROM field_source; IF n <> 192 THEN RAISE EXCEPTION '% provenance notes', n; END IF;
  SELECT count(*) INTO n FROM v_candidate_problems; IF n <> 0 THEN RAISE EXCEPTION 'checker %', n; END IF;
  SELECT count(*) INTO n FROM v_stage_date_gaps; IF n <> 0 THEN RAISE EXCEPTION 'gaps %', n; END IF;

  RAISE NOTICE '91 repeated values emptied; 31 Official Report outcomes split into passage and note; nothing else moved.';
END $$;

COMMIT;
