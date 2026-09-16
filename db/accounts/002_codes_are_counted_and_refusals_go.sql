-- db/accounts/002: a code's row is kept for an hour, and a refused person is not kept
--
-- Two descriptions change, and nothing else. No column, no rule, no permission.
-- Both follow decisions the owner took on 2026-09-16:
--
--   "Applying for an account" -- a refused application is deleted once the
--   person has been told, so nobody stays in the refused state.
--
--   "The admin screen and email", point 5 -- at most three codes an hour for
--   one address. To count them a code's row is kept for an hour after it was
--   made, used or not. It stops working as before: once used, after 15
--   minutes, or after five wrong tries.
--
-- The site does the deleting in both cases; these say what a reader of the
-- database will find.
--
-- Run as postgres against the accounts database, rehearsed first with ROLLBACK:
--
--   sudo -u postgres psql -X -d accounts -v end=ROLLBACK -f 002_codes_are_counted_and_refusals_go.sql
--   sudo -u postgres psql -X -d accounts -v end=COMMIT   -f 002_codes_are_counted_and_refusals_go.sql
--
-- Undo: db/accounts/002_undo.sql puts the two descriptions back as they were.

\set ON_ERROR_STOP on

\if :{?end}
\else
  \echo 'Refusing: say how to end, with -v end=ROLLBACK or -v end=COMMIT'
  \quit
\endif

BEGIN;

COMMENT ON TABLE sign_in_code IS
 'One row per code sent to a person, or made on the machine for the owner. A code works once, within 15 minutes, and stops after five wrong tries. The row is kept for an hour after the code was made, used or not, so that no address is sent more than three codes an hour, and is then removed.';

COMMENT ON COLUMN person.state IS
 'Where their application stands: applied or approved. Only an approved person can be sent a code. A refused application is deleted once the person has been told, so refused is allowed here but no row stays in it. Never empty.';

DO $$
BEGIN
  IF obj_description('sign_in_code'::regclass, 'pg_class') NOT LIKE '%kept for an hour%' THEN
    RAISE EXCEPTION 'Refusing: the codes description did not change.';
  END IF;
  IF col_description('person'::regclass,
       (SELECT attnum FROM pg_attribute WHERE attrelid = 'person'::regclass AND attname = 'state'))
     NOT LIKE '%no row stays in it%' THEN
    RAISE EXCEPTION 'Refusing: the state description did not change.';
  END IF;
  RAISE NOTICE 'Both descriptions changed; nothing else touched.';
END $$;

:end;
