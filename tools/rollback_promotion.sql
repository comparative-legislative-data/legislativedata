-- rollback_promotion.sql
--
-- Takes one session back off the clean sheet, as if it had never been
-- promoted. The staging lines are untouched apart from having their promotion
-- stamps cleared, so promotion can simply be run again.
--
--   -v session=1   which session to take back
--   -v save=false  see what it would remove, and change nothing
--   -v save=true   remove it
--
-- ONE THING DOES NOT COME BACK OFF. The provenance notes in field_source can
-- never be deleted — that is deliberate, and it is what makes a revised
-- published record impossible to hide. They are left in place. Because a
-- bill's number now comes from its staging line (db/026), they still point at
-- the right bill after the session is promoted again, and promote_session.sql
-- will not file a second copy of a note it already made.

\set ON_ERROR_STOP on

BEGIN;

CREATE TEMP TABLE rollback_arg ON COMMIT DROP AS SELECT :session::int AS session_number;

\echo ''
\echo '--- About to remove'
SELECT (SELECT count(*) FROM bill b JOIN rollback_arg a USING (session_number)) AS bills,
       (SELECT count(*) FROM stage_event e JOIN bill b USING (bill_id)
          JOIN rollback_arg a USING (session_number))                          AS stage_rows;

\echo '--- Left in place, because it cannot be deleted'
SELECT count(*) AS provenance_notes FROM field_source;

-- Stage rows go with their bills.
DELETE FROM bill b USING rollback_arg a WHERE b.session_number = a.session_number;

-- Each staging line's link empties itself when its bill goes; the date does not.
UPDATE bill_candidate c
   SET promoted_at = NULL
  FROM rollback_arg a
 WHERE c.session_number = a.session_number
   AND c.promoted_bill_id IS NULL;

DO $$
DECLARE s integer; n integer;
BEGIN
  SELECT session_number INTO s FROM rollback_arg;
  SELECT count(*) INTO n FROM bill WHERE session_number = s;
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % bill(s) still on the clean sheet.', n; END IF;
  SELECT count(*) INTO n FROM bill_candidate
   WHERE session_number = s AND (promoted_bill_id IS NOT NULL OR promoted_at IS NOT NULL);
  IF n > 0 THEN RAISE EXCEPTION 'Check failed: % staging line(s) still stamped as promoted.', n; END IF;
  RAISE NOTICE 'All checks passed. The session can be promoted again.';
END $$;

\echo ''
\echo '--- After'
SELECT (SELECT count(*) FROM bill)         AS bills,
       (SELECT count(*) FROM stage_event)  AS stage_rows,
       (SELECT count(*) FROM field_source) AS provenance_notes;

\echo ''
\if :save
  \echo '=== SAVING'
  COMMIT;
\else
  \echo '=== NOT SAVING - changing nothing'
  ROLLBACK;
\endif
