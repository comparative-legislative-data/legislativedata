-- db/server/001: only the owner and the server's master login open `postgres`
--
-- `postgres` is the database the software makes for its own housekeeping. It
-- holds none of this project's data. Until now every login could open it and
-- make scratch tables in it, by the default everyone gets, which the accounts
-- database had taken away and this one had not. Found running the closure test
-- of strand 2, item 1 (docs/CLOSURE-TESTS.md, "The site reads the copy");
-- agreed by the owner on 2026-09-18: only the owner and Claude, not the site.
--
-- Takes the default away from everyone and gives it back, by name, to the
-- owner's login (`legdata`, Postico's). The master login, `postgres`, is not
-- affected by permissions. The site's login (`legsite`) and the connector's
-- (`copy_reader`) lose it; neither ever opens this database.
--
--   sudo -u postgres psql -X -d postgres -v save=false -f 001_the_housekeeping_database.sql
--   sudo -u postgres psql -X -d postgres -v save=true  -f 001_the_housekeeping_database.sql
-- Undo: sudo -u postgres psql -X -d postgres -v save=true -f 001_undo.sql

\set ON_ERROR_STOP on
\if :{?save}
\else
  \echo 'Refusing: say -v save=false to look and throw away, or -v save=true to keep.'
  \quit
\endif

BEGIN;

REVOKE ALL ON DATABASE postgres FROM PUBLIC;
GRANT CONNECT, TEMPORARY ON DATABASE postgres TO legdata;

DO $$
DECLARE bad text;
BEGIN
  SELECT string_agg(r.rolname, ', ') INTO bad
    FROM pg_roles r
   WHERE r.rolcanlogin AND NOT r.rolsuper AND r.rolname <> 'legdata'
     AND (has_database_privilege(r.oid, 'postgres', 'CONNECT')
          OR has_database_privilege(r.oid, 'postgres', 'TEMPORARY'));
  IF bad IS NOT NULL THEN
    RAISE EXCEPTION 'Check failed: % can still open the housekeeping database.', bad;
  END IF;
  IF NOT has_database_privilege('legdata', 'postgres', 'CONNECT') THEN
    RAISE EXCEPTION 'Check failed: the owner''s login cannot open it.';
  END IF;
  RAISE NOTICE 'Only the owner''s login and the master login open the housekeeping database.';
END $$;

\if :save
  COMMIT;
  \echo 'Kept.'
\else
  ROLLBACK;
  \echo 'Thrown away: save=false.'
\endif
