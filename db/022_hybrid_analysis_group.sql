-- 022_hybrid_analysis_group.sql
-- Hybrid Bills are government bills for analysis, and Hybrid Bills in the data.
--
-- There is exactly one Hybrid Bill in the whole history: the Forth Crossing Bill
-- of Session 3, which became the Forth Crossing Act 2011. The Session 3 fact
-- sheet defines H for Hybrid Bill, applies it to that row — and then prints a
-- summary table with columns Executive, Member's, Private and Committee, and no
-- Hybrid column at all. Counting the type letters gives 44 Executive and 1
-- Hybrid; the summary says Executive 45.
--
-- Both add to 62. So the reconciliation gate passes on a document that has
-- silently agreed a Hybrid Bill is an Executive Bill, and would have gone on
-- passing. That is worth stating plainly: an arithmetic check against a source's
-- own totals catches a dropped row, and does not catch a coding decision.
--
-- The requirement here is to be able to include or exclude Hybrid Bills in later
-- analysis. Two ways were available. Coding it as 'government' with the true
-- type held elsewhere would put a false value in the type column and make the
-- exclusion the hard case. Instead the type column keeps the truth and the
-- lookup carries the grouping, so the choice is made at query time by picking a
-- column, and neither answer is privileged. This is the same argument that put
-- bill_type_stated beside bill_type rather than inside it.

BEGIN;

ALTER TABLE ref_bill_type
    ADD COLUMN analysis_group text REFERENCES ref_bill_type;

COMMENT ON COLUMN ref_bill_type.analysis_group IS
 'The bill type this one is counted as when types are grouped for analysis. Every type groups to itself except hybrid, which groups to government. Group by bill_type to see Hybrid Bills separately; group by analysis_group to fold them in, which is what the SPICe fact sheets do without saying so. See methodology note M4.';

UPDATE ref_bill_type SET analysis_group = code;
UPDATE ref_bill_type SET analysis_group = 'government' WHERE code = 'hybrid';

ALTER TABLE ref_bill_type ALTER COLUMN analysis_group SET NOT NULL;

-- While here: the 'government' definition claimed the contemporary label was
-- "reconstructable from the session". db/012 established that it is not — the
-- Session 4 fact sheet marks bills E, G and G* within one session — and that is
-- why bill_type_stated exists. Leaving the false claim in the published
-- definition of the value would contradict the note that corrects it.
UPDATE ref_bill_type SET definition =
 'Introduced by the Scottish Government. Styled an Executive Bill for part of the Parliament''s history; the label used at the time cannot be derived from the session or the date and is recorded separately in bill.bill_type_stated. See methodology note M1.'
 WHERE code = 'government';

UPDATE ref_bill_type SET definition =
 'Introduced under the hybrid bill procedure: a bill of a public character that affects particular private interests. One exists, the Forth Crossing Bill of Session 3. Counted as a government bill when types are grouped — see analysis_group and methodology note M4.'
 WHERE code = 'hybrid';

-- ---------------------------------------------------------------------------
-- Slice question 1, with both groupings side by side so a chart has to choose
-- rather than inherit one.
-- Dropped and recreated rather than replaced: CREATE OR REPLACE VIEW cannot
-- insert a column into the middle of a view's column list, and putting
-- analysis_group at the end to avoid that would separate it from the column
-- it qualifies.
DROP VIEW IF EXISTS v_outcome_by_type;

CREATE VIEW v_outcome_by_type AS
SELECT b.session_number,
       b.bill_type,
       t.analysis_group,
       b.procedure,
       b.outcome,
       b.enactment_status,
       count(*) AS bills
FROM bill b
JOIN ref_bill_type t ON t.code = b.bill_type
GROUP BY 1,2,3,4,5,6
ORDER BY 1,2,3,4,5;

COMMENT ON VIEW v_outcome_by_type IS
 'Slice question 1. Carries both bill_type and analysis_group: aggregate on whichever the question wants. They differ only for the one Hybrid Bill. Any published chart must say which it used — see methodology note M4.';

-- ---------------------------------------------------------------------------
INSERT INTO methodology_note (code, title, body, applies_to, sort_order) VALUES
('M4',
 'Hybrid Bills are recorded as Hybrid Bills and counted as government bills',
 'A Hybrid Bill is a bill of a public character that affects particular private interests. One has ever been introduced in the Scottish Parliament: the Forth Crossing Bill of Session 3, which became the Forth Crossing Act 2011. It is recorded here with bill_type "hybrid", which is what it was. Where bill types are grouped for counting, it is grouped with government bills, because it was introduced by the Scottish Government; ref_bill_type.analysis_group holds that grouping, and grouping instead by bill_type keeps it separate. Either is available, and a table or chart published from this resource should state which it used, because the two differ. The Parliament''s own Session 3 fact sheet makes the same grouping without saying so: it defines a type letter H, applies it to that one bill, and then prints a summary table with no Hybrid column, counting the bill under Executive. Its stated total of 45 Executive bills is 44 Executive bills and one Hybrid Bill.',
 '{bill.bill_type,ref_bill_type.analysis_group}', 4);

COMMIT;
