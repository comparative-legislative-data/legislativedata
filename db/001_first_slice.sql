-- 001_first_slice.sql
-- Tables for the first slice: outcome by bill type, and time per stage.
-- Applied 2026-09-10. See docs/VARIABLES.md for definitions and docs/DECISIONS.md
-- for why the vocabularies are shaped this way.
--
-- Vocabularies are lookup TABLES rather than Postgres enums, so that values can
-- be read, added and re-labelled in the grid without writing DDL. Codes are text
-- and readable, so `bill.bill_type` shows 'government' rather than an integer.

BEGIN;

-- ---------------------------------------------------------------- vocabularies

CREATE TABLE ref_bill_type (
    code        text PRIMARY KEY,
    label       text NOT NULL,
    definition  text,
    sort_order  integer NOT NULL DEFAULT 0
);
COMMENT ON TABLE ref_bill_type IS 'Who introduced the bill. Distinct from ref_procedure, which is how it was handled.';

CREATE TABLE ref_procedure (
    code        text PRIMARY KEY,
    label       text NOT NULL,
    definition  text,
    sort_order  integer NOT NULL DEFAULT 0
);
COMMENT ON TABLE ref_procedure IS 'How the bill was handled under standing orders. An emergency bill is a government bill that compressed its stages.';

CREATE TABLE ref_outcome (
    code        text PRIMARY KEY,
    label       text NOT NULL,
    definition  text,
    is_final    boolean NOT NULL DEFAULT true,
    sort_order  integer NOT NULL DEFAULT 0
);
COMMENT ON TABLE ref_outcome IS 'What Parliament did with the bill. Whether it became law is ref_enactment_status.';

CREATE TABLE ref_enactment_status (
    code        text PRIMARY KEY,
    label       text NOT NULL,
    definition  text,
    sort_order  integer NOT NULL DEFAULT 0
);
COMMENT ON TABLE ref_enactment_status IS 'Whether the bill became an Act. Separate from outcome: a bill can pass and not be enacted.';

CREATE TABLE ref_stage (
    code         text PRIMARY KEY,
    label        text NOT NULL,
    definition   text,
    applies_to   text NOT NULL DEFAULT 'public'
                 CHECK (applies_to IN ('public','private','both')),
    sort_order   integer NOT NULL DEFAULT 0
);
COMMENT ON TABLE ref_stage IS 'Stage names. Private bills use their own sequence, which is why stage_event carries stage_order.';

CREATE TABLE ref_source (
    code        text PRIMARY KEY,
    label       text NOT NULL,
    definition  text,
    sort_order  integer NOT NULL DEFAULT 0
);
COMMENT ON TABLE ref_source IS 'Where an admitted fact came from. Every row of bill and stage_event names one.';

-- --------------------------------------------------------------------- session

CREATE TABLE session (
    session_number      integer PRIMARY KEY CHECK (session_number BETWEEN 1 AND 20),
    date_first_meeting  date,
    date_dissolution    date,
    is_current          boolean NOT NULL DEFAULT false,
    note                text,
    CHECK (date_dissolution IS NULL OR date_first_meeting IS NULL
           OR date_dissolution > date_first_meeting)
);
COMMENT ON COLUMN session.is_current IS 'Stored, not derived, because date_dissolution is null for the current session.';

-- ------------------------------------------------------------------------ bill

CREATE TABLE bill (
    bill_id           serial PRIMARY KEY,
    sp_bill_id        text UNIQUE,
    session_number    integer NOT NULL REFERENCES session,
    short_title       text NOT NULL,
    bill_type         text NOT NULL REFERENCES ref_bill_type,
    procedure         text NOT NULL REFERENCES ref_procedure DEFAULT 'standard',
    date_introduced   date,
    outcome           text NOT NULL REFERENCES ref_outcome DEFAULT 'in_progress',
    date_outcome      date,
    enactment_status  text NOT NULL REFERENCES ref_enactment_status DEFAULT 'pending',
    date_royal_assent date,
    asp_number        text,
    source            text NOT NULL REFERENCES ref_source,
    source_ref        text,
    observed_at       date NOT NULL DEFAULT current_date,
    note              text,
    created_at        timestamptz NOT NULL DEFAULT now(),
    updated_at        timestamptz NOT NULL DEFAULT now(),
    CHECK (date_outcome IS NULL OR date_introduced IS NULL OR date_outcome >= date_introduced),
    CHECK (date_royal_assent IS NULL OR date_outcome IS NULL OR date_royal_assent >= date_outcome)
);
COMMENT ON COLUMN bill.sp_bill_id IS 'The Parliament''s identifier, where one exists and is trusted. Nullable on purpose.';
COMMENT ON COLUMN bill.short_title IS 'Title as introduced. Titles can change during passage.';
COMMENT ON COLUMN bill.observed_at IS 'When the source was read. Published records are revised.';

CREATE INDEX bill_session_idx ON bill (session_number);
CREATE INDEX bill_type_idx    ON bill (bill_type);

-- ------------------------------------------------------------------ stage_event

CREATE TABLE stage_event (
    stage_event_id  serial PRIMARY KEY,
    bill_id         integer NOT NULL REFERENCES bill ON DELETE CASCADE,
    stage           text NOT NULL REFERENCES ref_stage,
    stage_order     integer NOT NULL,
    date_completed  date,
    completed       boolean NOT NULL DEFAULT false,
    fell_here       boolean NOT NULL DEFAULT false,
    source          text NOT NULL REFERENCES ref_source,
    source_ref      text,
    observed_at     date NOT NULL DEFAULT current_date,
    note            text,
    created_at      timestamptz NOT NULL DEFAULT now(),
    updated_at      timestamptz NOT NULL DEFAULT now(),
    UNIQUE (bill_id, stage),
    UNIQUE (bill_id, stage_order)
);
COMMENT ON TABLE stage_event IS 'One row per stage a bill actually reached. A bill that fell at Stage 1 has two rows, not five.';
COMMENT ON COLUMN stage_event.stage_order IS 'Position in this bill''s own sequence, so private bills can be compared with public ones.';

-- A concluded bill fell at exactly one stage.
CREATE UNIQUE INDEX stage_event_one_fell_idx ON stage_event (bill_id) WHERE fell_here;

CREATE INDEX stage_event_bill_idx ON stage_event (bill_id);

-- --------------------------------------------------------------- updated_at

CREATE FUNCTION touch_updated_at() RETURNS trigger AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER bill_touch        BEFORE UPDATE ON bill
    FOR EACH ROW EXECUTE FUNCTION touch_updated_at();
CREATE TRIGGER stage_event_touch BEFORE UPDATE ON stage_event
    FOR EACH ROW EXECUTE FUNCTION touch_updated_at();

COMMIT;
