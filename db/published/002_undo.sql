-- db/published/002_undo: takes db/published/002 off again
--
-- The site's login loses everything in the published workbook, in whichever
-- copy has it, and the workbook itself. Once a page reads the copy, running
-- this takes the data pages down, so it is not run then without the owner
-- saying so; roll the site back first (tools/deploy_site.sh --rollback).
--
-- Run as postgres, connected to the postgres database:
--
--   sudo -u postgres psql -X -d postgres -f 002_undo.sql

\set ON_ERROR_STOP on

\connect published
BEGIN;
DO $$
DECLARE s text;
BEGIN
  FOR s IN SELECT nspname FROM pg_namespace WHERE nspname IN ('live', 'previous') LOOP
    EXECUTE format('REVOKE ALL ON ALL TABLES IN SCHEMA %I FROM legsite', s);
    EXECUTE format('REVOKE ALL ON SCHEMA %I FROM legsite', s);
  END LOOP;
END $$;
COMMIT;

\connect postgres
ALTER ROLE legsite IN DATABASE published RESET default_transaction_read_only;
REVOKE ALL ON DATABASE published FROM legsite;
COMMENT ON ROLE legsite IS
 'The website''s own login. No password: usable only by the machine account of the same name, on the machine. Can open the accounts database and no other.';

SELECT has_database_privilege('legsite', 'published', 'CONNECT') AS site_can_still_open_published;
