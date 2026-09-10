-- 019_sp_bill_id_is_session_scoped.sql
-- SP Bill numbers restart at 1 in each session, so a bare number is not unique.
--
-- bill.sp_bill_id was declared UNIQUE on the value alone. The factsheet survey
-- (docs/FACTSHEET-SURVEY.md) found SP Bill 7 in Sessions 2 and 3; SP Bill 13 in
-- Sessions 2, 6 and 7; SP Bill 65 in Sessions 4, 5 and 6; and SP Bills 70, 71
-- and 72 each in three sessions. The constraint holds today only because one
-- session is loaded and none of its rows carries a number at all.
--
-- The number is scoped to the session, so the uniqueness is too. The alternative
-- — storing a qualified string such as 'S5-70' — was rejected because it invents
-- an identifier the Parliament does not use, and every comparison against a
-- source would then have to undo it.

BEGIN;

ALTER TABLE bill DROP CONSTRAINT bill_sp_bill_id_key;

ALTER TABLE bill
    ADD CONSTRAINT bill_sp_bill_id_unique_in_session
    UNIQUE (session_number, sp_bill_id);

COMMENT ON COLUMN bill.sp_bill_id IS
 'The Parliament''s bill number within its session, e.g. 70 for SP Bill 70. Unique within a session, not across sessions. Null where none is known: the Session 1 factsheet gives no numbers at all, and Sessions 2-5 give them only for bills that did not become Acts.';

COMMIT;
