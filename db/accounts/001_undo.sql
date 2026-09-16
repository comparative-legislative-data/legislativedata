-- db/accounts/001_undo: takes db/accounts/001 off again
--
-- Drops the named accounts database, removes the site's login if nothing else
-- still needs it, and lets any login on the machine open the working database
-- again, which is how it stood before.
--
-- This deletes every person, code and device in the database named. It is for
-- the rehearsal, and for a failed first run. Once a real person has applied it
-- is not an undo, it is a deletion of their data, and it is not run without the
-- owner saying so in terms.
--
-- Run as postgres, connected to the postgres database:
--
--   sudo -u postgres psql -d postgres -v accounts_db=accounts_rehearsal -f 001_undo.sql

\set ON_ERROR_STOP on

\if :{?accounts_db}
\else
  \echo 'Refusing: say which database to drop, with -v accounts_db=...'
  \quit
\endif

DROP DATABASE IF EXISTS :"accounts_db" WITH (FORCE);

SELECT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'legsite') AS legsite_exists
\gset
\if :legsite_exists
  SELECT count(*) > 0 AS other_accounts_db_left
    FROM pg_database
   WHERE has_database_privilege('legsite', datname, 'CONNECT')
     AND datname NOT IN ('template0', 'template1', 'postgres')
  \gset
\else
  \set other_accounts_db_left false
\endif

-- PostgreSQL's default had no written list of who may open the working
-- database; this writes the default out. It behaves identically, and looks
-- different in the catalogue, which the rehearsal records rather than hides.
\if :other_accounts_db_left
  \echo 'The site login still reaches another database, so it and the working database''s setting are left alone.'
\else
  DROP ROLE IF EXISTS legsite;
  GRANT CONNECT, TEMPORARY ON DATABASE legdata TO PUBLIC;
  \echo 'Undone: the database is gone, the site login is gone, and the working database is as it was.'
\endif
