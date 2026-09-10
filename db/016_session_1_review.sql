-- 016_session_1_review.sql
-- The gateway's admission step for Session 1, recorded rather than typed into a
-- client and forgotten. Nothing here promotes anything: these rows become
-- 'accepted', which makes them eligible for promotion to bill. Promotion is a
-- separate script.
--
-- Why this is a migration and not a session in Postico. review_status is the
-- gateway. If the record of who admitted what, and on what basis, lives only in
-- a client's query history, then the one column the architecture rests on is the
-- one column with no provenance. db/010 set the precedent by carrying its own
-- data fix.
--
-- The review: the owner read all 73 rows on 2026-09-10 and found no errors of
-- substance. Independently, before this migration, three checks were run —
-- the factsheet's own summary cross-tab (all twelve cells and both margins),
-- a re-parse of every date from the verbatim raw_* string against the typed
-- column (73 rows, three date fields, no discrepancy), and the extended
-- v_candidate_problems from db/015 (empty). One correction came out of it,
-- below.

BEGIN;

-- ---------------------------------------------------------------------------
-- 1. A misprint in the source, corrected in the proposal and kept in the raw.
--
-- The factsheet cell reads 'Criminal Procedure (Amendment) Scotland Act 2002
-- asp 4'. The Act is the Criminal Procedure (Amendment) (Scotland) Act 2002:
-- SPICe dropped the brackets around Scotland. The extraction is faithful and the
-- source is wrong, which is the case short_title exists to be corrected in and
-- raw_title exists to preserve.
--
-- This is a divergence from the row's stated source, so at promotion it needs a
-- field_source row of its own. It cannot have one yet — field_source keys on a
-- bill_id and no bill exists. The promotion script is responsible for emitting
-- it; review_note carries the reason until then.
UPDATE bill_candidate
   SET short_title = 'Criminal Procedure (Amendment) (Scotland) Act 2002',
       review_note = concat_ws(' ', review_note,
         'short_title corrected at review: the factsheet prints ''Criminal '
         'Procedure (Amendment) Scotland Act 2002'', omitting the brackets '
         'around Scotland. Corrected to the title of the Act as enacted. '
         'raw_title keeps the factsheet''s wording. Needs a field_source row '
         'at promotion, source = manual, recording both.')
 WHERE session_number = 1
   AND raw_title = 'Criminal Procedure (Amendment) Scotland Act 2002 asp 4'
   AND short_title = 'Criminal Procedure (Amendment) Scotland Act 2002';

-- ---------------------------------------------------------------------------
-- 2. Refuse to admit anything if the checks are not clean.
--
-- The instruction has always been "work v_candidate_problems to empty before
-- promoting". This makes that an enforced precondition of admission rather than
-- a note in a document, so the two cannot drift apart.
DO $$
DECLARE n integer;
BEGIN
    SELECT count(*) INTO n FROM v_candidate_problems WHERE session_number = 1;
    IF n > 0 THEN
        RAISE EXCEPTION
          'refusing to accept Session 1: v_candidate_problems has % row(s)', n;
    END IF;
END $$;

-- ---------------------------------------------------------------------------
-- 3. Admit the 73.
--
-- Guarded on review_status = 'new' so re-running cannot overwrite a later
-- judgement — a row since set to 'rejected' or 'held' stays as it is.
UPDATE bill_candidate
   SET review_status = 'accepted',
       reviewed_at   = now()
 WHERE session_number = 1
   AND review_status  = 'new';

DO $$
DECLARE n integer;
BEGIN
    SELECT count(*) INTO n
      FROM bill_candidate
     WHERE session_number = 1 AND review_status = 'accepted';
    RAISE NOTICE 'Session 1: % candidates accepted, 0 promoted', n;
    IF n <> 73 THEN
        RAISE EXCEPTION 'expected 73 accepted candidates, found %', n;
    END IF;
END $$;

COMMIT;
