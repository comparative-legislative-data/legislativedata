-- db/published/001: the published copy's workbook, and the connector it reads through
--
-- The second of the three databases settled on 2026-09-15, set up as agreed on
-- 2026-09-18 (docs/PUBLISHED-COPY-RUNBOOK.md; DECISIONS.md, "How the published
-- copy is taken"). This makes the empty workbook and the way in. It holds no
-- data: tools/published_copy.sql builds the nine files into it.
--
--   * A login that can only read the working data, and only what crosses: the
--     clean sheet, the stages, the sessions, the notes, the provenance lines,
--     the published lists of allowed values, the error checker, the gaps list,
--     and the two calculations the copy carries. Never the staging sheets, the
--     party list, or anything added to the working workbook later: a new table
--     is not readable until a migration says so. Its password is made at random
--     here and kept only in the connector's settings, never written anywhere
--     else; if it is lost, run the undo and this again.
--   * The workbook, `published`, which no login may open but the superuser and
--     Postico's login, `legdata`, which may read it once there is something to
--     read. The site's own login gets nothing here until block 4.
--   * The connector (postgres_fdw, which comes with PostgreSQL), usable only by
--     the superuser the build runs as. Its tables are brought in by each build
--     into `from_working`, an area no other login can open.
--
-- Like db/accounts/001, it cannot be one all-or-nothing transaction, because a
-- database cannot be made inside one. If anything fails after the database is
-- made, db/published/001_undo.sql takes all of it off again.
--
-- Run as postgres, connected to the postgres database:
--
--   sudo -u postgres psql -X -d postgres -v published_db=published -v reader=copy_reader -f 001_the_published_copy.sql
--
-- Rehearsed first as published_db=published_rehearsal, reader=copy_reader_rehearsal,
-- and undone.

\set ON_ERROR_STOP on

\if :{?published_db}
\else
  \echo 'Refusing: say which database to make, with -v published_db=published'
  \quit
\endif
\if :{?reader}
\else
  \echo 'Refusing: say which login to make, with -v reader=copy_reader'
  \quit
\endif

-- ---------------------------------------------------------------------------
-- The login that reads the working data
-- ---------------------------------------------------------------------------

-- Two random identifiers side by side: 72 characters from the operating
-- system's own random source, held in this session's memory and nowhere else.
SELECT gen_random_uuid()::text || gen_random_uuid()::text AS reader_password
\gset

CREATE ROLE :"reader" LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT;
ALTER ROLE :"reader" PASSWORD :'reader_password';
ALTER ROLE :"reader" SET default_transaction_read_only = on;

COMMENT ON ROLE :"reader" IS
 'The published copy''s way into the working data. Can read what crosses into the published copy and nothing else, and every transaction it starts is read-only. Used only through the connector in the published workbook; its password is held there and nowhere else.';

\connect legdata

GRANT CONNECT ON DATABASE legdata TO :"reader";
GRANT USAGE ON SCHEMA public TO :"reader";
GRANT SELECT ON
    bill, stage_event, session, methodology_note, field_source,
    ref_assent_block_outcome, ref_assent_block_route, ref_bill_type,
    ref_bill_type_stage, ref_bill_type_stated, ref_enactment_status, ref_outcome,
    ref_procedure, ref_source, ref_stage, ref_stage_1_rejection_route,
    v_bill_stage_dates, v_bill_stage_durations,
    v_candidate_problems, v_stage_date_gaps
  TO :"reader";

-- ---------------------------------------------------------------------------
-- The workbook
-- ---------------------------------------------------------------------------

\connect postgres

CREATE DATABASE :"published_db" OWNER postgres;
REVOKE ALL ON DATABASE :"published_db" FROM PUBLIC;
GRANT CONNECT ON DATABASE :"published_db" TO legdata;

\connect :"published_db"

BEGIN;

COMMENT ON DATABASE :"published_db" IS
 'The published copy: only what is published, taken from the working database at one moment by tools/published_copy.sql. What a reader''s page reads. Not backed up: rebuilt from the working database instead.';

REVOKE ALL ON SCHEMA public FROM PUBLIC;
COMMENT ON SCHEMA public IS 'Unused. The copy lives in live.';

CREATE EXTENSION postgres_fdw;

CREATE SERVER working FOREIGN DATA WRAPPER postgres_fdw
  OPTIONS (host 'localhost', dbname 'legdata');
COMMENT ON SERVER working IS
 'The connector to the working database. Logs in as a login that can only read what crosses. Usable only by the superuser the build runs as.';

CREATE USER MAPPING FOR postgres SERVER working
  OPTIONS (user :'reader', password :'reader_password');

CREATE SCHEMA from_working;
REVOKE ALL ON SCHEMA from_working FROM PUBLIC;
COMMENT ON SCHEMA from_working IS
 'The working data, read through the connector while a copy is built. Emptied and brought in again by each build. No login but the superuser may open it.';

-- ---------------------------------------------------------------------------
-- Checks
-- ---------------------------------------------------------------------------

-- The connector reads, and reads only what it was given.
IMPORT FOREIGN SCHEMA public LIMIT TO (session, bill_candidate)
  FROM SERVER working INTO from_working;

DO $$
DECLARE n integer; refused boolean;
BEGIN
  SELECT count(*) INTO n FROM from_working.session;
  IF n <> 7 THEN RAISE EXCEPTION 'The connector read % sessions, expected 7.', n; END IF;

  refused := false;
  BEGIN
    PERFORM count(*) FROM from_working.bill_candidate;
  EXCEPTION WHEN insufficient_privilege THEN refused := true;
  END;
  IF NOT refused THEN RAISE EXCEPTION 'The connector can read the staging sheet.'; END IF;

  refused := false;
  BEGIN
    UPDATE from_working.session SET note = note WHERE session_number = 1;
  EXCEPTION WHEN insufficient_privilege OR read_only_sql_transaction THEN refused := true;
  END;
  IF NOT refused THEN RAISE EXCEPTION 'The connector can write to the working database.'; END IF;

  RAISE NOTICE 'The connector reads the sessions, cannot read the staging sheet, and cannot write.';
END $$;

-- Postico's login cannot open the connector's area.
SET ROLE legdata;
DO $$
DECLARE refused boolean := false;
BEGIN
  BEGIN
    PERFORM count(*) FROM from_working.session;
  EXCEPTION WHEN insufficient_privilege THEN refused := true;
  END;
  IF NOT refused THEN RAISE EXCEPTION 'Postico''s login can open from_working.'; END IF;
  RAISE NOTICE 'Postico''s login cannot open from_working.';
END $$;
RESET ROLE;

DROP FOREIGN TABLE from_working.session, from_working.bill_candidate;

COMMIT;
