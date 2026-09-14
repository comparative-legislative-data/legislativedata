-- db/072_m5_says_where_the_data_has_got_to.sql
--
-- M5 already described the four bills that passed and were stopped before
-- Royal Assent, and it described them to the end: the UNCRC and European
-- Charter Bills reconsidered and enacted, the UK Withdrawal from the European
-- Union (Legal Continuity) Bill withdrawn on 10 March 2022, the Gender
-- Recognition Reform Bill blocked by a section 35 order and left there.
--
-- On 2026-09-14 the owner settled that the three in Session 5's fact sheet are
-- recorded as that fact sheet leaves them: blocked. Session 6's fact sheet is
-- where the reconsiderations and the withdrawal are recorded, and it has not
-- been read in. So a reader of M5 would be told these bills were enacted or
-- withdrawn, look at the data, and find them blocked.
--
-- Two sentences, agreed word for word by the owner before this was run. They
-- state the rule rather than the present position, so they do not go stale as
-- each session is read in.
--
-- Nothing else in M5 changes, and nothing else at all changes: no bill, no
-- stage record, no provenance note, no other methodology note.

\set ON_ERROR_STOP on
BEGIN;

DO $$
DECLARE n integer;
BEGIN
  SELECT length(body) INTO n FROM methodology_note WHERE code = 'M5';
  IF n IS NULL THEN RAISE EXCEPTION 'Refusing: there is no methodology note M5.'; END IF;
  IF n <> 1940 THEN
    RAISE EXCEPTION 'Refusing: M5 is % characters, expected 1940. It has changed since this migration was written, and appending to it blind could repeat or contradict what is already there.', n;
  END IF;

  SELECT count(*) INTO n FROM methodology_note
   WHERE code = 'M5' AND body LIKE '%latest fact sheet that has been read in%';
  IF n <> 0 THEN
    RAISE EXCEPTION 'Refusing: M5 already says this. This migration has run before.';
  END IF;

  -- The sentences are only true while Session 6 is unread. If it has been read
  -- in, what M5 should say is different and this is the wrong change.
  SELECT count(*) INTO n FROM bill WHERE session_number > 5;
  IF n <> 0 THEN
    RAISE EXCEPTION 'Refusing: % bill(s) from a session after 5 are on the clean sheet. Reconsider what M5 should say.', n;
  END IF;
END $$;

UPDATE methodology_note
   SET body = body || ' A bill''s recorded state is the one given by the latest fact sheet that has been read in, not by the latest fact sheet that exists. So a bill stopped in one session''s fact sheet stays recorded as blocked here until the fact sheet saying what happened to it next has itself been read in, and the account above of what became of these four bills runs ahead of the data until that has happened.'
 WHERE code = 'M5';

DO $$
DECLARE n integer; changed integer;
BEGIN
  SELECT length(body) INTO n FROM methodology_note WHERE code = 'M5';
  IF n <> 2331 THEN
    RAISE EXCEPTION 'M5 is now % characters, expected 2331 -- 1940 plus 391.', n;
  END IF;

  SELECT count(*) INTO n FROM methodology_note
   WHERE code = 'M5'
     AND body LIKE '%blocked by a section 35 order on 16 January 2023%'
     AND body LIKE '%the date of the block stays in bill.date_assent_blocked.%'
     AND body LIKE '%runs ahead of the data until that has happened.';
  IF n <> 1 THEN
    RAISE EXCEPTION 'M5 has lost something it had, or has not gained what it should.';
  END IF;

  SELECT count(*) INTO changed FROM methodology_note WHERE code <> 'M5'
     AND updated_at > now() - interval '1 minute';
  IF changed <> 0 THEN
    RAISE EXCEPTION '% other methodology note(s) changed.', changed;
  END IF;

  SELECT count(*) INTO n FROM methodology_note;
  IF n <> 8 THEN RAISE EXCEPTION '% methodology notes, expected 8.', n; END IF;

  SELECT count(*) INTO n FROM bill;
  IF n <> 302 THEN RAISE EXCEPTION '% bills, expected 302.', n; END IF;

  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n <> 0 THEN RAISE EXCEPTION 'The error checker finds % problem(s).', n; END IF;

  RAISE NOTICE 'M5 1940 -> 2331 characters. The other seven notes, 302 bills and the error checker are untouched.';
END $$;

COMMIT;
