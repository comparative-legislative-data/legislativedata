-- switch_copy.sql: put the copy set aside as `next` live
--
-- The last database step of a refresh. tools/published_copy.sql sets the new
-- copy aside as `next`; the refresh makes its zip and checks it; only then
-- does this put it live, keeping the live copy as `previous` so that the undo
-- (tools/put_back_previous.sql) is one step. The one before that goes. One
-- step, all or nothing. Strand 2, item 6: docs/STRAND-2-ITEM-6-BUILD.md.
--
-- Refuses a copy taken the same day as the live one: the date names the copy,
-- its zip and its lines of what changed, so two copies on one day would give
-- two different things one name. To correct a refresh the same day, undo it
-- first. Refuses a copy set aside on an earlier day, too: the refresh builds
-- and switches in one run, so an older `next` is one that did not finish.
--
-- Run by tools/refresh_copy.sh. By hand:
--
--   sudo -u postgres psql -X -d published -v save=false -f tools/switch_copy.sql
--   sudo -u postgres psql -X -d published -v save=true  -f tools/switch_copy.sql

\set ON_ERROR_STOP on
\if :{?save}
\else
  \echo 'Refusing: say -v save=false to look and throw away, or -v save=true to keep.'
  \quit
\endif

BEGIN;

DO $$
DECLARE new_date date; live_date date;
BEGIN
  IF to_regclass('next.about') IS NULL THEN
    RAISE EXCEPTION 'Refusing: there is no copy set aside as next.';
  END IF;
  SELECT max(date_copy_taken) INTO new_date FROM next.about;
  IF new_date IS DISTINCT FROM current_date THEN
    RAISE EXCEPTION 'Refusing: the copy set aside is dated %, not today. It is from a refresh that did not finish.', new_date;
  END IF;
  IF to_regclass('live.about') IS NOT NULL THEN
    SELECT max(date_copy_taken) INTO live_date FROM live.about;
    IF live_date = new_date THEN
      RAISE EXCEPTION 'Refusing: the live copy was taken today too. Undo it first (tools/refresh_copy.sh --undo).';
    END IF;
  END IF;
END $$;

\echo '--- Being kept as previous'
SELECT file, rows, date_copy_taken FROM live.about ORDER BY file;

DROP SCHEMA IF EXISTS previous CASCADE;
DO $$
BEGIN
  IF to_regnamespace('live') IS NOT NULL THEN
    ALTER SCHEMA live RENAME TO previous;
    COMMENT ON SCHEMA previous IS 'The copy before the live one, kept so that a bad refresh can be undone in one step (tools/put_back_previous.sql). Served to nobody.';
    -- A permission follows a copy when it is renamed. The site reads only what
    -- is live, so its permission comes off here (db/published/002).
    REVOKE ALL ON ALL TABLES IN SCHEMA previous FROM legsite;
    REVOKE ALL ON SCHEMA previous FROM legsite;
  END IF;
END $$;
ALTER SCHEMA next RENAME TO live;
COMMENT ON SCHEMA live IS 'The published copy, as taken on the day in its about file. What a reader''s page reads.';
-- Read by legdata and by the site's login already, from when it was set aside.
GRANT USAGE ON SCHEMA live TO legdata, legsite;
GRANT SELECT ON ALL TABLES IN SCHEMA live TO legdata, legsite;
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
              WHERE n.nspname = 'live' AND c.relkind = 'r'
                AND NOT has_table_privilege('legsite', c.oid, 'SELECT'))
     OR to_regnamespace('previous') IS NOT NULL AND has_schema_privilege('legsite', 'previous', 'USAGE') THEN
    RAISE EXCEPTION 'The site''s login cannot read the new copy, or can still open previous.';
  END IF;
END $$;

\echo '--- Live'
SELECT file, rows, date_copy_taken FROM live.about ORDER BY file;

\if :save
  COMMIT;
  \echo 'Kept: the copy is live.'
\else
  ROLLBACK;
  \echo 'Thrown away: save=false.'
\endif
