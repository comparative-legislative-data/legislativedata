-- db/accounts/001: the accounts, in a database of their own
--
-- The third of the three databases settled on 2026-09-15 ("Three databases: the
-- working one, the published one, and the accounts"), and the first time this
-- project holds anything about a person. What it holds is exactly the list in
-- "No passwords; what is held about a user, in full", and nothing that list
-- does not name:
--
--   a person     email, name, title, position; applied, approved or refused,
--                and when
--   a code       for 15 minutes, used once, kept as a one-way scramble
--   a device     signed in for 30 days, kept as a one-way scramble of the marker
--
-- Deleting a person deletes their codes and devices with them. That is the
-- owner's "delete an account and everything attached to it", and it is a
-- property of how the tabs are joined rather than something a page has to
-- remember to do.
--
-- The site's own way in. The site runs as the machine account `legsite`, and
-- this makes a database login of the same name, with no password: it can be used
-- only by that machine account, on the machine. It can reach this database and
-- no other. The working database has until now let any login on the machine
-- open it, because that is PostgreSQL's default and there were no other logins.
-- That is taken away here, so that the site cannot see the working data at all
-- rather than being trusted not to look. The working database's own login and
-- the postgres superuser are unaffected.
--
-- What the site may do, column by column. It may add a person, but it may not
-- say who the owner is: that is set on the machine only, because the owner's
-- account "cannot be applied for" (2026-09-15). It may change a person's state
-- and the date it changed, and nothing else about them. It may add, use and
-- remove codes and devices. It may delete a person.
--
-- Unlike the working database's migrations, this one cannot sit inside one
-- all-or-nothing transaction, because a database cannot be created inside one.
-- The database and the logins are made first, then the tabs are made inside a
-- transaction, then everything is checked. If anything fails after the database
-- is made, db/accounts/001_undo.sql takes all of it off again.
--
-- Run as postgres, connected to the postgres database:
--
--   sudo -u postgres psql -d postgres -v accounts_db=accounts -f 001_the_accounts.sql
--
-- Rehearsed under another name first, with accounts_db=accounts_rehearsal, and
-- undone. See docs/ACCOUNTS-RUNBOOK.md.

\set ON_ERROR_STOP on

\if :{?accounts_db}
\else
  \echo 'Refusing: say which database to make, with -v accounts_db=accounts'
  \quit
\endif

-- ---------------------------------------------------------------------------
-- The site's login, the database, and who may open it
-- ---------------------------------------------------------------------------

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'legsite') THEN
    CREATE ROLE legsite LOGIN;
  END IF;
END $$;

COMMENT ON ROLE legsite IS
 'The website''s own login. No password: usable only by the machine account of the same name, on the machine. Can open the accounts database and no other.';

CREATE DATABASE :"accounts_db" OWNER postgres;

REVOKE ALL ON DATABASE :"accounts_db" FROM PUBLIC;
GRANT CONNECT ON DATABASE :"accounts_db" TO legsite;

REVOKE CONNECT, TEMPORARY ON DATABASE legdata FROM PUBLIC;

\connect :"accounts_db"

BEGIN;

COMMENT ON DATABASE :"accounts_db" IS
 'The people who have applied to use the site, their sign-in codes and their signed-in devices. Nothing about bills. Personal data: no row from here goes into a commit, a document or a conversation.';

REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT USAGE ON SCHEMA public TO legsite;

-- ---------------------------------------------------------------------------
-- A person
-- ---------------------------------------------------------------------------

CREATE TABLE person (
  person_id   bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  email       text NOT NULL UNIQUE,
  name        text NOT NULL,
  title       text,
  position    text NOT NULL,
  state       text NOT NULL DEFAULT 'applied',
  applied_at  timestamptz NOT NULL DEFAULT now(),
  decided_at  timestamptz,
  is_owner    boolean NOT NULL DEFAULT false,

  CONSTRAINT person_email_lower_case CHECK (email = lower(email)),
  CONSTRAINT person_email_shape      CHECK (email ~ '^[^@[:space:]]+@[^@[:space:]]+\.[^@[:space:]]+$'),
  CONSTRAINT person_name_not_blank   CHECK (btrim(name) <> ''),
  CONSTRAINT person_title_not_blank  CHECK (title IS NULL OR btrim(title) <> ''),
  CONSTRAINT person_position_not_blank CHECK (btrim(position) <> ''),
  CONSTRAINT person_state_known      CHECK (state IN ('applied', 'approved', 'refused')),
  CONSTRAINT person_decided_when_decided
    CHECK ((state = 'applied') = (decided_at IS NULL)),
  CONSTRAINT person_decided_after_applied
    CHECK (decided_at IS NULL OR decided_at >= applied_at),
  CONSTRAINT person_owner_is_approved CHECK (NOT is_owner OR state = 'approved')
);

CREATE UNIQUE INDEX person_only_one_owner ON person (is_owner) WHERE is_owner;

COMMENT ON TABLE person IS
 'One row per person who has applied to use the site, and one for the owner. Deleting a row deletes that person''s codes and signed-in devices with it, and nothing about them is left anywhere in this database.';
COMMENT ON COLUMN person.person_id IS
 'A number the database gives each person, so the other tabs can point at them without repeating their email. Means nothing outside this database.';
COMMENT ON COLUMN person.email IS
 'The address codes are sent to, stored in lower case. Also how a person is told they were approved or refused. No two people share one. Never empty.';
COMMENT ON COLUMN person.name IS
 'The name the person gave when they applied. Held because the owner decides on applications. Never empty.';
COMMENT ON COLUMN person.title IS
 'The title the person gave, such as Dr or Professor. Held because the owner decides on applications. Empty means they gave none.';
COMMENT ON COLUMN person.position IS
 'The position the person gave, such as their post and institution. Held because the owner decides on applications. Never empty.';
COMMENT ON COLUMN person.state IS
 'Where their application stands: applied, approved or refused. Only an approved person can be sent a code. Never empty.';
COMMENT ON COLUMN person.applied_at IS
 'When they applied. For the owner''s own account, when it was made on the machine. Never empty.';
COMMENT ON COLUMN person.decided_at IS
 'When the owner approved or refused them. Empty means nobody has decided yet, and the database refuses an empty cell here once the state is approved or refused.';
COMMENT ON COLUMN person.is_owner IS
 'True for the owner''s account, which alone sees the admin screen; false for everyone else. At most one person is the owner, and only an approved one. The site cannot set this: it is set on the machine.';

-- ---------------------------------------------------------------------------
-- A sign-in code
-- ---------------------------------------------------------------------------

CREATE TABLE sign_in_code (
  sign_in_code_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  person_id       bigint NOT NULL REFERENCES person ON DELETE CASCADE,
  code_hash       text NOT NULL,
  created_at      timestamptz NOT NULL DEFAULT now(),
  expires_at      timestamptz NOT NULL,
  used_at         timestamptz,
  failed_attempts integer NOT NULL DEFAULT 0,

  CONSTRAINT sign_in_code_lasts_15_minutes
    CHECK (expires_at > created_at AND expires_at <= created_at + interval '15 minutes'),
  CONSTRAINT sign_in_code_used_in_time
    CHECK (used_at IS NULL OR (used_at >= created_at AND used_at <= expires_at)),
  CONSTRAINT sign_in_code_attempts_not_negative CHECK (failed_attempts >= 0)
);

CREATE INDEX sign_in_code_by_person ON sign_in_code (person_id);

COMMENT ON TABLE sign_in_code IS
 'One row per code emailed to a person. A code lasts 15 minutes and works once. Rows are there only while a code could matter and are removed once it has been used or has run out.';
COMMENT ON COLUMN sign_in_code.sign_in_code_id IS
 'A number the database gives each code. Means nothing outside this database.';
COMMENT ON COLUMN sign_in_code.person_id IS
 'Which person the code was sent to. Deleting the person deletes this row. Never empty.';
COMMENT ON COLUMN sign_in_code.code_hash IS
 'A one-way scramble of the code, never the code itself, so that reading this database does not let anyone sign in. Never empty.';
COMMENT ON COLUMN sign_in_code.created_at IS
 'When the code was made and sent. Never empty.';
COMMENT ON COLUMN sign_in_code.expires_at IS
 'When the code stops working. The database refuses a code that lasts longer than 15 minutes. Never empty.';
COMMENT ON COLUMN sign_in_code.used_at IS
 'When the code was used to sign in. Empty means it has not been used, and a code with a date here does not work again.';
COMMENT ON COLUMN sign_in_code.failed_attempts IS
 'How many wrong codes have been tried against this one, so that guessing can be stopped. Nought if none. Never empty.';

-- ---------------------------------------------------------------------------
-- A signed-in device
-- ---------------------------------------------------------------------------

CREATE TABLE signed_in_device (
  signed_in_device_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  person_id           bigint NOT NULL REFERENCES person ON DELETE CASCADE,
  marker_hash         text NOT NULL UNIQUE,
  signed_in_at        timestamptz NOT NULL DEFAULT now(),
  expires_at          timestamptz NOT NULL,

  CONSTRAINT signed_in_device_lasts_30_days
    CHECK (expires_at > signed_in_at AND expires_at <= signed_in_at + interval '30 days')
);

CREATE INDEX signed_in_device_by_person ON signed_in_device (person_id);

COMMENT ON TABLE signed_in_device IS
 'One row per device a person is signed in on. A device stays signed in for 30 days. Signing out on the device removes its row, and rows past their 30 days are removed too.';
COMMENT ON COLUMN signed_in_device.signed_in_device_id IS
 'A number the database gives each signed-in device. Means nothing outside this database.';
COMMENT ON COLUMN signed_in_device.person_id IS
 'Which person is signed in. Deleting the person deletes this row, which signs them out everywhere. Never empty.';
COMMENT ON COLUMN signed_in_device.marker_hash IS
 'A one-way scramble of the marker the browser holds, never the marker itself, so that reading this database does not let anyone sign in as the person. Nothing else about the device is held: not its address, its browser or where it is. Never empty.';
COMMENT ON COLUMN signed_in_device.signed_in_at IS
 'When the person signed in on this device. Never empty.';
COMMENT ON COLUMN signed_in_device.expires_at IS
 'When the device stops being signed in. The database refuses a sign-in that lasts longer than 30 days. Never empty.';

-- ---------------------------------------------------------------------------
-- What the site may do
-- ---------------------------------------------------------------------------

GRANT SELECT, DELETE ON person TO legsite;
GRANT INSERT (email, name, title, position) ON person TO legsite;
GRANT UPDATE (state, decided_at) ON person TO legsite;

GRANT SELECT, INSERT, UPDATE, DELETE ON sign_in_code, signed_in_device TO legsite;

-- ---------------------------------------------------------------------------
-- Checked before it is kept
-- ---------------------------------------------------------------------------

DO $$
DECLARE
  n int;
  missing text;
BEGIN
  SELECT count(*) INTO n FROM pg_tables WHERE schemaname = 'public';
  IF n <> 3 THEN RAISE EXCEPTION 'Refusing: % tabs, not 3.', n; END IF;

  SELECT string_agg(c.relname || '.' || coalesce(a.attname, '(the table)'), ', ')
    INTO missing
    FROM pg_class c
    JOIN pg_namespace s ON s.oid = c.relnamespace AND s.nspname = 'public'
    LEFT JOIN pg_attribute a ON a.attrelid = c.oid AND a.attnum > 0 AND NOT a.attisdropped
   WHERE c.relkind = 'r'
     AND (CASE WHEN a.attname IS NULL THEN obj_description(c.oid, 'pg_class')
               ELSE col_description(c.oid, a.attnum) END) IS NULL;
  IF missing IS NOT NULL THEN RAISE EXCEPTION 'Refusing: no description on %.', missing; END IF;

  IF has_database_privilege('legsite', 'legdata', 'CONNECT') THEN
    RAISE EXCEPTION 'Refusing: the site''s login can still open the working database.';
  END IF;
  IF NOT has_database_privilege('legsite', current_database(), 'CONNECT') THEN
    RAISE EXCEPTION 'Refusing: the site''s login cannot open the accounts.';
  END IF;
  IF has_column_privilege('legsite', 'person', 'is_owner', 'INSERT')
     OR has_column_privilege('legsite', 'person', 'is_owner', 'UPDATE') THEN
    RAISE EXCEPTION 'Refusing: the site''s login could make someone the owner.';
  END IF;
  IF has_column_privilege('legsite', 'person', 'email', 'UPDATE') THEN
    RAISE EXCEPTION 'Refusing: the site''s login could change a person''s email.';
  END IF;

  SELECT (SELECT count(*) FROM person) + (SELECT count(*) FROM sign_in_code)
       + (SELECT count(*) FROM signed_in_device) INTO n;
  IF n <> 0 THEN RAISE EXCEPTION 'Refusing: % row(s) in a database just made.', n; END IF;

  RAISE NOTICE 'The accounts are made: three tabs, every column described, empty, and the site''s login can reach them and not the working database.';
END $$;

COMMIT;
