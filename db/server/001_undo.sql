-- db/server/001_undo: every login may open `postgres` again, as before 001.
--
-- The default is put back as a written permission rather than as the blank it
-- was; what each login can do is the same.
--
--   sudo -u postgres psql -X -d postgres -v save=true -f 001_undo.sql

\set ON_ERROR_STOP on
\if :{?save}
\else
  \echo 'Refusing: say -v save=false to look and throw away, or -v save=true to keep.'
  \quit
\endif

BEGIN;

REVOKE ALL ON DATABASE postgres FROM legdata;
GRANT CONNECT, TEMPORARY ON DATABASE postgres TO PUBLIC;

DO $$
BEGIN
  IF NOT has_database_privilege('legsite', 'postgres', 'CONNECT') THEN
    RAISE EXCEPTION 'Check failed: the default is not back.';
  END IF;
END $$;

\if :save
  COMMIT;
  \echo 'Kept: undone.'
\else
  ROLLBACK;
  \echo 'Thrown away: save=false.'
\endif
