-- 004_stage_dates_and_party.sql
-- Requested 2026-09-10: drop date_outcome; put the stage end dates directly on
-- bill; add reconsideration as a flag; add party.
--
-- Column names are snake_case to match the rest of the schema.

BEGIN;

-- date_outcome removed. Its two CHECK constraints go with it automatically.
ALTER TABLE bill DROP COLUMN date_outcome;

-- Stage end dates on the bill row, so a bill is one line to type.
ALTER TABLE bill
    ADD COLUMN end_stage_1_date      date,
    ADD COLUMN end_stage_2_date      date,
    ADD COLUMN end_stage_3_date      date,
    ADD COLUMN reconsideration_stage boolean NOT NULL DEFAULT false;

COMMENT ON COLUMN bill.end_stage_1_date IS 'Date Stage 1 completed. Which date counts is decision D2 in docs/VARIABLES.md, still open.';
COMMENT ON COLUMN bill.reconsideration_stage IS 'Whether the bill went to Reconsideration Stage. Breaks the assumption that Stage 3 is the end.';

-- Dates must run in order where present.
ALTER TABLE bill
    ADD CONSTRAINT bill_stage_dates_ordered CHECK (
        (end_stage_1_date IS NULL OR date_introduced  IS NULL OR end_stage_1_date >= date_introduced)
    AND (end_stage_2_date IS NULL OR end_stage_1_date IS NULL OR end_stage_2_date >= end_stage_1_date)
    AND (end_stage_3_date IS NULL OR end_stage_2_date IS NULL OR end_stage_3_date >= end_stage_2_date)
    );
-- Royal Assent cannot precede Stage 3.
ALTER TABLE bill
    ADD CONSTRAINT bill_assent_after_stage_3 CHECK (
        date_royal_assent IS NULL OR end_stage_3_date IS NULL
        OR date_royal_assent >= end_stage_3_date
    );

-- ------------------------------------------------------------------- party

CREATE TABLE ref_party (
    code        text PRIMARY KEY,
    label       text NOT NULL,
    definition  text,
    sort_order  integer NOT NULL DEFAULT 0
);
COMMENT ON TABLE ref_party IS 'Party of the member in charge. A starting list — add, re-label or remove rows as needed.';

INSERT INTO ref_party (code, label, definition, sort_order) VALUES
 ('snp','Scottish National Party',NULL,1),
 ('labour','Scottish Labour',NULL,2),
 ('conservative','Scottish Conservative and Unionist',NULL,3),
 ('libdem','Scottish Liberal Democrats',NULL,4),
 ('green','Scottish Greens',NULL,5),
 ('independent','Independent','Member sitting as an independent.',6),
 ('other','Other','Any party not listed; name it in bill.note.',7);

ALTER TABLE bill ADD COLUMN party text REFERENCES ref_party;
COMMENT ON COLUMN bill.party IS 'Party of the member in charge. Null means not applicable or not yet known — including law officer bills, which carry no member. Independent is a value, not a null.';

CREATE INDEX bill_party_idx ON bill (party);

COMMIT;
