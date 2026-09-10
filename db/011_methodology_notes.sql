-- 011_methodology_notes.sql
-- Where a variable is not simply read from a source but involves a judgement,
-- the judgement is published alongside the data rather than buried in a repo.
--
-- This table is the single source of that text. The front end reads it and shows
-- the note wherever the variable appears, so the site and the repo cannot drift:
-- the wording is version-controlled here, in the migration, and nowhere else.
--
-- DECISIONS.md records that a decision was taken and why. This records what a
-- reader of the data needs to be told. They are different documents.

BEGIN;

CREATE TABLE methodology_note (
    code        text PRIMARY KEY,
    title       text NOT NULL,
    body        text NOT NULL,
    applies_to  text[] NOT NULL DEFAULT '{}',   -- e.g. '{bill.bill_type}'
    sort_order  integer NOT NULL DEFAULT 0,
    created_at  timestamptz NOT NULL DEFAULT now(),
    updated_at  timestamptz NOT NULL DEFAULT now()
);
COMMENT ON TABLE methodology_note IS
 'Value judgements made in building the data, published with it. One row per judgement.';
COMMENT ON COLUMN methodology_note.applies_to IS
 'Qualified column names the note attaches to, so the front end can show it next to the variable.';

CREATE TRIGGER methodology_note_touch BEFORE UPDATE ON methodology_note
    FOR EACH ROW EXECUTE FUNCTION touch_updated_at();

INSERT INTO methodology_note (code, title, body, applies_to, sort_order) VALUES
('M1',
 'Executive Bills and Government Bills are counted as one type',
 'Bills introduced by the Scottish Government were formally styled Executive Bills for part of the Parliament''s history. This resource records both as "government", so that a count of government legislation is continuous across all sessions. The label used at the time is retained separately in bill.bill_type_stated, and can be cross-tabulated or filtered on.',
 '{bill.bill_type,bill.bill_type_stated}', 1),
('M2',
 'A stage is completed on the date of the decision that ended it',
 'For Stage 3, that decision is the vote on whether to pass the bill, so Stage 3 completion is the date the bill was passed. Stage 1 and Stage 2 completion dates are not yet recorded: which date marks their completion is still open, because the committee report, the chamber debate and the decision itself give materially different durations. Durations measured to Stage 3 are therefore stable; durations to Stages 1 and 2 do not yet exist.',
 '{bill.end_stage_3_date,bill.end_stage_1_date,bill.end_stage_2_date}', 2);

COMMIT;
