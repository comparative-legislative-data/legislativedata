-- 021_two_titles.sql
-- A bill's title at introduction and its title at the end are two variables,
-- not one variable with a caveat.
--
-- VARIABLES §3.2 defines short_title as "title as introduced". For 62 of the 73
-- Session 1 rows it is not: the factsheet lists an enacted bill under its Act
-- title. db/013 chose to publish that divergence as methodology note M3 rather
-- than resolve it, on the grounds that sourcing introduced titles separately was
-- disproportionate for the first slice.
--
-- The survey found that SPICe states the introduced title itself where a bill
-- was renamed, in three places across seven documents:
--
--   Session 4, footnote 1: "Was introduced as the Defective and Dangerous
--       Buildings (Recovery of Expenses) (Scotland) Bill"
--   Session 6: "Introduced as the National Care Service (Scotland) Bill (SP Bill
--       17) and renamed on 4 March 2025 to the Care Reform (Scotland) Bill (SP
--       Bill 17)."
--   Session 6: "Introduced as the Scottish Parliament (Recall and Removal of
--       Members) Bill (SP Bill 55) and renamed on 24 February 2026 to the
--       Scottish Parliament (Recall of Members) Bill (SP Bill 55)."
--
-- So the value exists in the source, sometimes. One column cannot hold both, and
-- overloading short_title means its definition is false for most rows — which it
-- currently is. Two columns make each row say plainly which titles are known.
--
-- This is the same shape as bill_type beside bill_type_stated (D4) and as stage
-- names by bill type (D6): record the nuance, normalise afterwards.
--
-- Note that the SP Bill number survives a rename in both Session 6 cases. That
-- is what makes it the stable identifier the title is not.

BEGIN;

ALTER TABLE bill ADD COLUMN title_as_introduced text;

COMMENT ON COLUMN bill.title_as_introduced IS
 'The bill''s short title when it was introduced. Null means not known, which is the normal case: the fact sheets state it only where a bill was renamed. Populate it only from a source that says so — never by copying short_title, which would assert as fact that the title did not change.';

COMMENT ON COLUMN bill.short_title IS
 'The title by which the bill is known at the latest point there is evidence for: the Act''s short title where it was enacted, otherwise the title it carried when it concluded or, for a live bill, now. This is the display title. The title at introduction, where known, is in title_as_introduced. See methodology note M3.';

-- The date of a rename is not given a column. Two bills in seven sessions state
-- one, and it goes in bill.note. If a third case appears, revisit; a column
-- carrying two values across ~470 rows is not yet worth its own variable.

-- ---------------------------------------------------------------------------
-- M3 is rewritten rather than replaced. It stops being an apology for one
-- column meaning two things and becomes a statement about coverage.
UPDATE methodology_note SET
 title = 'Two titles are recorded, and the title at introduction is usually not known',
 body  = 'A bill''s short title can change while it is before Parliament, and a bill that is passed becomes an Act under the Act''s title. This resource records two: bill.short_title is the title by which the bill is known at the latest point there is evidence for — the Act title where it was enacted, otherwise the title at its conclusion — and bill.title_as_introduced is the title it carried when it was introduced. The second is null for most bills, because the source used for the first slice, the SPICe fact sheets, lists enacted bills under their Act title and unenacted ones under their bill title, and states the introduced title only in the three cases across seven sessions where it explicitly noted a rename. Null therefore means not known, and never means unchanged: a reader should not infer from a null that a bill kept its title. Where a rename is known, the date of it is recorded in bill.note. The asp number is held separately in bill.asp_number rather than left inside the title. The styling of the bill type is a second value that differs between introduction and passage, and methodology note M1 covers it.',
 applies_to = '{bill.short_title,bill.title_as_introduced,bill.asp_number}'
 WHERE code = 'M3';

COMMIT;
