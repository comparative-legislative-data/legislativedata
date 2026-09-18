-- db/published/001_undo: takes db/published/001 off again
--
-- Drops the named published workbook and the named login that reads the
-- working data, with everything that login was allowed to read. No data is lost:
-- the working workbook is where everything lives, and the copy is rebuilt from
-- it. Once the site reads the copy (block 4), dropping it takes the data pages
-- down until it is rebuilt, so it is not run then without the owner saying so.
--
-- Run as postgres, connected to the postgres database:
--
--   sudo -u postgres psql -X -d postgres -v published_db=published_rehearsal -v reader=copy_reader_rehearsal -f 001_undo.sql

\set ON_ERROR_STOP on

\if :{?published_db}
\else
  \echo 'Refusing: say which database to drop, with -v published_db=...'
  \quit
\endif
\if :{?reader}
\else
  \echo 'Refusing: say which login to drop, with -v reader=...'
  \quit
\endif

DROP DATABASE IF EXISTS :"published_db" WITH (FORCE);

SELECT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = :'reader') AS reader_exists
\gset
\if :reader_exists
  \connect legdata
  -- The login owns nothing; this takes away everything it was allowed.
  DROP OWNED BY :"reader";
  REVOKE CONNECT ON DATABASE legdata FROM :"reader";
  \connect postgres
  DROP ROLE :"reader";
\endif

SELECT (SELECT count(*) FROM pg_database WHERE datname = :'published_db') AS databases_left,
       (SELECT count(*) FROM pg_roles WHERE rolname = :'reader') AS logins_left;
