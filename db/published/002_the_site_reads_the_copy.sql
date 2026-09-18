-- db/published/002: the site reads the copy
--
-- Strand 2, item 1 (docs/STRAND-2-THE-SITE-READS-THE-COPY.md), agreed by the
-- owner on 2026-09-18. The site's own login, `legsite`, which until now could
-- open the accounts and nothing else, may also open the published workbook and
-- read the live copy. Nothing more:
--
--   * it reads `live` and cannot change a cell of it;
--   * it gets nothing in `previous`, `from_working` or `public`;
--   * it cannot use the connector to the working data, nor see its password;
--   * every transaction it starts in this workbook is read-only, whatever the
--     permissions say, as a second lock on the first.
--
-- Each new copy gets the same permission from the refresh as it goes live
-- (tools/published_copy.sql), which also takes it off the copy renamed to
-- `previous`; the refresh's undo (tools/put_back_previous.sql) gives it back to
-- the copy it puts live again.
--
-- The workbook-wide lines cannot sit inside a transaction with the rest, since
-- they are made from the postgres database; the undo takes all of it off.
--
-- Run as postgres, connected to the postgres database:
--
--   sudo -u postgres psql -X -d postgres -f 002_the_site_reads_the_copy.sql
--
-- Then, as the site: sudo -u legsite bash 002_check_as_the_site.sh
-- Undo:              sudo -u postgres psql -X -d postgres -f 002_undo.sql

\set ON_ERROR_STOP on

GRANT CONNECT ON DATABASE published TO legsite;
ALTER ROLE legsite IN DATABASE published SET default_transaction_read_only = on;
COMMENT ON ROLE legsite IS
 'The website''s own login. No password: usable only by the machine account of the same name, on the machine. Can open the accounts database, and read the live published copy; can open no other.';

\connect published

BEGIN;

GRANT USAGE ON SCHEMA live TO legsite;
GRANT SELECT ON ALL TABLES IN SCHEMA live TO legsite;

-- What the permissions say, read from the workbook's own record of them. The
-- check run as the site (002_check_as_the_site.sh) then tries each one.
DO $$
DECLARE
  bad text;
BEGIN
  SELECT string_agg(c.relname, ', ') INTO bad
    FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
   WHERE n.nspname = 'live' AND c.relkind = 'r'
     AND (NOT has_table_privilege('legsite', c.oid, 'SELECT')
          OR has_table_privilege('legsite', c.oid, 'INSERT, UPDATE, DELETE, TRUNCATE'));
  IF bad IS NOT NULL THEN
    RAISE EXCEPTION 'Check failed: the site cannot read, or can change, live.%.', bad;
  END IF;
  IF (SELECT count(*) FROM pg_tables WHERE schemaname = 'live') <> 12 THEN
    RAISE EXCEPTION 'Check failed: live does not have twelve files.';
  END IF;
  SELECT string_agg(s, ', ') INTO bad
    FROM unnest(ARRAY['previous', 'from_working', 'public']) s
   WHERE to_regnamespace(s) IS NOT NULL
     AND has_schema_privilege('legsite', s, 'USAGE');
  IF bad IS NOT NULL THEN
    RAISE EXCEPTION 'Check failed: the site can open %.', bad;
  END IF;
  IF has_schema_privilege('legsite', 'live', 'CREATE')
     OR has_database_privilege('legsite', current_database(), 'CREATE, TEMPORARY') THEN
    RAISE EXCEPTION 'Check failed: the site can make something in the workbook.';
  END IF;
  IF has_server_privilege('legsite', 'working', 'USAGE') THEN
    RAISE EXCEPTION 'Check failed: the site can use the connector to the working data.';
  END IF;
  IF has_database_privilege('legsite', 'legdata', 'CONNECT') THEN
    RAISE EXCEPTION 'Check failed: the site can open the working database.';
  END IF;
  RAISE NOTICE 'The site can read the twelve files of live, change none, and open nothing else here.';
END $$;

COMMIT;
