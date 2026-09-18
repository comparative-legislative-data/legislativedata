-- put_back_previous.sql: the refresh's undo
--
-- Puts the copy before back as the live one, after a refresh that should not
-- have happened, and drops the copy that replaced it. One step, all or
-- nothing. Afterwards there is no `previous`: a second undo refuses.
-- docs/STRAND-1-THE-REFRESH.md; a step in docs/PROMOTION-RUNBOOK.md.
--
--   sudo -u postgres psql -X -d published -v save=false -f tools/put_back_previous.sql
--   sudo -u postgres psql -X -d published -v save=true  -f tools/put_back_previous.sql

\set ON_ERROR_STOP on
\if :{?save}
\else
  \echo 'Refusing: say -v save=false to look and throw away, or -v save=true to keep.'
  \quit
\endif

BEGIN;

DO $$
BEGIN
  IF to_regnamespace('previous') IS NULL THEN
    RAISE EXCEPTION 'Refusing: there is no previous copy to put back.';
  END IF;
  IF to_regnamespace('live') IS NULL THEN
    RAISE EXCEPTION 'Refusing: there is no live copy; nothing to replace.';
  END IF;
  IF to_regclass('previous.about') IS NULL THEN
    RAISE EXCEPTION 'Refusing: previous has no about file, so it is not a copy.';
  END IF;
END $$;

\echo '--- Being replaced'
SELECT file, rows, date_copy_taken FROM live.about ORDER BY file;

DROP SCHEMA live CASCADE;
ALTER SCHEMA previous RENAME TO live;
COMMENT ON SCHEMA live IS 'The published copy, as taken on the day in its about file. What a reader''s page reads.';
GRANT USAGE ON SCHEMA live TO legdata;
GRANT SELECT ON ALL TABLES IN SCHEMA live TO legdata;

\echo '--- Live again'
SELECT file, rows, date_copy_taken FROM live.about ORDER BY file;

\if :save
  COMMIT;
  \echo 'Kept: the copy before is live again.'
\else
  ROLLBACK;
  \echo 'Thrown away: save=false.'
\endif
