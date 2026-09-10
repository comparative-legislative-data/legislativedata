-- 012_bill_type_stated.sql
-- The contemporaneous label, kept beside the normalised research variable.
--
-- A separate lookup rather than adding 'executive' to ref_bill_type: if
-- 'executive' entered the research vocabulary it would appear in outcome-by-type
-- cross-tabs and split the government series in two, which is exactly what D4
-- exists to prevent. See methodology note M1.
--
-- The changeover is NOT the 2007 renaming of the Scottish Executive. The Session 4
-- factsheet marks bills E, G, and G* — the last footnoted 'Introduced as an
-- Executive Bill (E)' — for bills introduced in 2011 and 2012. So the label
-- cannot be derived from the session or from the introduction date, and has to
-- be recorded as stated.

BEGIN;

CREATE TABLE ref_bill_type_stated (
    code        text PRIMARY KEY,
    label       text NOT NULL,
    definition  text,
    sort_order  integer NOT NULL DEFAULT 0
);
COMMENT ON TABLE ref_bill_type_stated IS
 'The type as styled at the time of introduction. Descriptive, not the research variable — that is ref_bill_type.';

INSERT INTO ref_bill_type_stated (code, label, definition, sort_order) VALUES
 ('executive','Executive Bill','Styled an Executive Bill when introduced. Recorded as bill_type = government.',1),
 ('government','Government Bill','Styled a Government Bill when introduced.',2),
 ('members','Member''s Bill',NULL,3),
 ('committee','Committee Bill',NULL,4),
 ('private','Private Bill',NULL,5),
 ('hybrid','Hybrid Bill','First possible in Session 3; the Forth Crossing Bill is the only one so far.',6);

ALTER TABLE bill           ADD COLUMN bill_type_stated text REFERENCES ref_bill_type_stated;
ALTER TABLE bill_candidate ADD COLUMN bill_type_stated text;

COMMENT ON COLUMN bill.bill_type_stated IS
 'How the type was styled when the bill was introduced. Null means not known. A bill introduced as an Executive Bill keeps ''executive'' here even if it was styled a Government Bill by the time it passed; the change is recorded in note.';

CREATE INDEX bill_type_stated_idx ON bill (bill_type_stated);

COMMIT;
