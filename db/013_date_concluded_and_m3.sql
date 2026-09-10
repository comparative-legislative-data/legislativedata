-- 013_date_concluded_and_m3.sql
-- Two decisions taken at the close of the 2026-09-10 session.
--
-- 1. date_concluded returns to bill. db/004 dropped date_outcome because for a
--    bill that passed or was defeated it is the Stage 3 date. That holds for the
--    62 Session 1 Acts; it does not hold for the other 11. A bill that was
--    withdrawn or fell has a date that is not a stage completion, and it was
--    being lost.
--
-- 2. For enacted bills, short_title carries the Act title. Accepted rather than
--    sourced separately, and published as methodology note M3.

BEGIN;

ALTER TABLE bill ADD COLUMN date_concluded date;

COMMENT ON COLUMN bill.date_concluded IS
 'Date the bill was withdrawn or fell — an ending with no stage date. Null for a bill that passed: its conclusion is end_stage_3_date. Not a duplicate of the dropped date_outcome, which tried to cover both cases with one column.';

ALTER TABLE bill
    ADD CONSTRAINT bill_concluded_after_introduction CHECK (
        date_concluded IS NULL OR date_introduced IS NULL
        OR date_concluded >= date_introduced
    );

-- A bill that passed concluded at Stage 3, so this column stays empty for it.
-- Encodes the definition above rather than trusting it to be remembered.
ALTER TABLE bill
    ADD CONSTRAINT bill_concluded_only_if_not_passed CHECK (
        date_concluded IS NULL OR outcome <> 'passed'
    );

INSERT INTO methodology_note (code, title, body, applies_to, sort_order) VALUES
('M3',
 'For bills that became Acts, the title recorded is the Act title',
 'A bill''s title can change while it is before Parliament, and a bill that is passed becomes an Act under the Act''s title. The SPICe factsheets list enacted bills under their Act title and unenacted ones under their bill title, and this resource records what the factsheet gives: the Act title where a bill was enacted, the bill title where it was withdrawn or fell. So a title here is the title at the end of the bill''s passage, not necessarily the title it was introduced under. The asp number is held separately in bill.asp_number rather than left inside the title. This is one of several places where a value differs between introduction and passage — the styling of the bill type is another, which methodology note M1 covers.',
 '{bill.short_title,bill.asp_number}', 3);

COMMIT;
