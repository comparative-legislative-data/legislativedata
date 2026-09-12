-- db/045_a_type_disagreement_is_a_question_not_a_crash.sql
--
-- Settled by the owner on 2026-09-12. Bill type is half of the first question
-- this data answers -- what happened to each bill, by bill type -- so two
-- sources disagreeing about what kind of bill it was is a research question.
-- Until now it came out as the stage-date loader refusing to pair the bill at
-- all, which stopped the whole session with a message about plumbing.
--
-- From here tools/compare_sources.py compares the type along with the two dates
-- and records a disagreement the same way, as
--   Differs: bill_type = <value> (<source>)
-- which the error checker already refuses to let past without the matching
-- "Checked: bill_type = ..." citation (db/044). The stage-date loader still
-- refuses to pair a bill whose type is disputed and not yet adjudicated,
-- because attaching one bill's stage dates to another is the harm; once the
-- line carries the adjudication, the pairing stands.
--
-- Nothing in the data changes. There is no such disagreement in Sessions 1 or
-- 2: the loader would have refused to run if there were.
--
-- Also here, because it is one sentence and the owner settled it today: M8 said
-- "the 2022 PhD dataset". The thesis is 2021, published April 2021.
--
-- Which source settles a type disagreement is NOT decided, because there has
-- never been one to settle. It is decided when the first case arrives, as the
-- order between sources was (DECISIONS.md, 2026-09-11). The Parliament's own
-- bill page is the obvious candidate and is not assumed here.

\set ON_ERROR_STOP on
BEGIN;

UPDATE methodology_note
   SET body = replace(
         body,
         'Every session''s dates are compared against every other source that states them when the session is loaded',
         'Every session''s dates, and what kind of bill each was, are compared against every other source that states them when the session is loaded')
 WHERE code = 'M8';

UPDATE methodology_note
   SET body = body || E'\n\nWhere two sources disagree about what kind of bill it was, that is treated as a question about the bill and not as a fault in the data: it is recorded, put to the project''s author, and settled before the session is published. No such disagreement has arisen, so which source settles one is not yet decided.'
 WHERE code = 'M8';

-- ---------------------------------------------------------------------------
-- The thesis year, settled by the owner on 2026-09-12
-- ---------------------------------------------------------------------------

-- 2021, published April 2021. The "final for submission - 25 February 2022" on
-- the copy held on the server is the submission draft, not the published
-- version. M2 already cited 2021 correctly; M8, written on 2026-09-12, said
-- 2022 and is corrected here. This closes the open question in STATE.md.
UPDATE methodology_note
   SET body = replace(body, 'The 2022 PhD dataset',
                            'The PhD dataset compiled for the 2021 thesis')
 WHERE code = 'M8';

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM methodology_note WHERE body LIKE '%2022 PhD dataset%';
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: a note still calls it the 2022 PhD dataset.';
  END IF;
  SELECT count(*) INTO n FROM methodology_note
   WHERE code = 'M8' AND body LIKE '%what kind of bill each was, are compared%'
     AND body LIKE '%not yet decided.%';
  IF n <> 1 THEN
    RAISE EXCEPTION 'Refusing: M8 does not read as intended.';
  END IF;
  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: the error checker is not empty (% problem(s)).', n;
  END IF;
  RAISE NOTICE 'M8 now covers bill type. Checker empty.';
END $$;

COMMIT;
