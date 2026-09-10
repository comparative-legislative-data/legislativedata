-- 008_bill_candidate.sql
-- The staging table for the gateway. Extraction writes candidates here; nothing
-- reaches `bill` except by review and an explicit promotion.
--
-- This table is deliberately PERMISSIVE: no foreign keys, almost nothing NOT
-- NULL. A bad parse must be able to land, because a row you can look at is more
-- use than an import error. Strictness lives at promotion, where `bill`'s own
-- constraints do the enforcing.
--
-- Two layers of columns:
--   raw_*   what the factsheet said, verbatim. Never edited. Feeds
--           field_source.value_seen if a field ever needs per-field provenance.
--   typed   what the extractor PROPOSES to record. This is what the reviewer
--           edits. It is a claim about the raw value, not a result.

BEGIN;

CREATE TABLE bill_candidate (
    candidate_id      serial PRIMARY KEY,

    -- ---------------------------------------------- what the factsheet said
    session_number    integer,
    raw_title         text,
    raw_type          text,          -- 'E', 'M', 'C', 'P'
    raw_date_introduced   text,      -- '6 October 1999'
    raw_introduced_by     text,      -- person, committee or promoter
    raw_date_final        text,      -- passed / withdrawn / fell, per section
    raw_date_royal_assent text,
    raw_section       text,          -- acts | withdrawn | fallen

    -- ------------------------------------------- what the extractor proposes
    sp_bill_id        text,
    short_title       text,
    title_kind        text,          -- act | bill; see note below
    bill_type         text,
    procedure         text DEFAULT 'standard',
    date_introduced   date,
    end_stage_3_date  date,
    date_concluded    date,          -- withdrawn/fell date; no home in bill yet
    date_royal_assent date,
    asp_number        text,
    outcome           text,
    enactment_status  text,

    -- ------------------------------------------------------------ provenance
    source            text DEFAULT 'spice_factsheet',
    source_ref        text,
    observed_at       date,
    src_file          text,
    src_page          integer,
    parser_note       text,          -- mechanical observations only, no guesses
    extracted_at      timestamptz NOT NULL DEFAULT now(),

    -- ---------------------------------------------------------- the gateway
    review_status     text NOT NULL DEFAULT 'new'
                      CHECK (review_status IN ('new','accepted','rejected','held')),
    review_note       text,
    reviewed_at       timestamptz,
    promoted_bill_id  integer REFERENCES bill ON DELETE SET NULL,
    promoted_at       timestamptz,
    updated_at        timestamptz NOT NULL DEFAULT now(),

    -- Re-running an extraction must not duplicate rows or clobber edits.
    UNIQUE (session_number, raw_section, raw_title)
);

COMMENT ON TABLE bill_candidate IS
 'Staging for the gateway. Rows here are candidates, never facts. Permissive on purpose: a bad parse lands as a row rather than as an import error.';
COMMENT ON COLUMN bill_candidate.title_kind IS
 'act = the title came from an Acts table and is the ACT title, not the title as introduced (which is what bill.short_title is defined as). bill = a bill title.';
COMMENT ON COLUMN bill_candidate.date_concluded IS
 'Date a bill was withdrawn or fell. bill has no column for this since date_outcome was dropped in 004. Held here pending a decision.';
COMMENT ON COLUMN bill_candidate.raw_introduced_by IS
 'Not a first-slice variable. Kept so the member/party slice does not require re-reading the PDF. Never promoted.';
COMMENT ON COLUMN bill_candidate.parser_note IS
 'What the parser observed mechanically: unmapped codes, unparsed dates, inferences it made. Not an opinion about the bill.';

CREATE INDEX bill_candidate_review_idx  ON bill_candidate (review_status);
CREATE INDEX bill_candidate_session_idx ON bill_candidate (session_number);

CREATE TRIGGER bill_candidate_touch BEFORE UPDATE ON bill_candidate
    FOR EACH ROW EXECUTE FUNCTION touch_updated_at();

COMMIT;
