-- db/accounts/002_undo: puts back the two descriptions db/accounts/002 changed,
-- word for word as db/accounts/001 wrote them.
--
--   sudo -u postgres psql -X -d accounts -f 002_undo.sql

\set ON_ERROR_STOP on

BEGIN;

COMMENT ON TABLE sign_in_code IS
 'One row per code emailed to a person. A code lasts 15 minutes and works once. Rows are there only while a code could matter and are removed once it has been used or has run out.';

COMMENT ON COLUMN person.state IS
 'Where their application stands: applied, approved or refused. Only an approved person can be sent a code. Never empty.';

COMMIT;
