-- 037_postico_shows_dates_day_first.sql
--
-- Postico shows dates the UK way, 03/05/2000, rather than 2000-05-03. Asked for
-- by the owner on 2026-09-11 while typing stage dates in.
--
-- Postico shows a date in whatever form the server sends it, and the server
-- sends it in the form set for the login. This sets that form for Postico's
-- login, legdata, only. Every script run for the project logs in as the
-- administrator and keeps the database's own form (year first, db/035), so
-- nothing those scripts read or compare changes.
--
-- What changes for Postico's login:
--   - dates show as 03/05/2000, and times as 11/09/2026 20:44:00 UTC;
--   - dates can be typed either way, 03/05/2000 or 2000-05-03;
--   - dates inside the error checker's messages read the same way. Checked
--     before this was made, with planted mistakes thrown away afterwards: the
--     checker and the gaps list found the same problems and the same gaps
--     under both forms. The one place a view turns a date into text is the
--     wording of a message.
--
-- Postico must reconnect to pick it up. To undo:
--   ALTER ROLE legdata IN DATABASE legdata RESET "DateStyle";

BEGIN;

ALTER ROLE legdata IN DATABASE legdata SET "DateStyle" = 'SQL, DMY';

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_db_role_setting s JOIN pg_database d ON d.oid = s.setdatabase
                  WHERE d.datname = 'legdata' AND s.setrole = 'legdata'::regrole
                    AND 'DateStyle=SQL, DMY' = ANY (s.setconfig)) THEN
    RAISE EXCEPTION 'The day-first display for Postico''s login is not stored.';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_db_role_setting s JOIN pg_database d ON d.oid = s.setdatabase
                  WHERE d.datname = 'legdata' AND s.setrole = 0
                    AND 'DateStyle=ISO, DMY' = ANY (s.setconfig)) THEN
    RAISE EXCEPTION 'The database''s own form is not as db/035 left it.';
  END IF;
END $$;

COMMIT;
