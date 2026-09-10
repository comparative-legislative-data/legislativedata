-- 007_field_provenance.sql
-- Provenance per field, not only per row.
--
-- One source per row breaks as soon as a bill's outcome comes from a factsheet
-- and its dates from the Official Report. This table records the source of an
-- individual field where it differs from the row's default.
--
-- It is APPEND-ONLY. A field observed twice gets two rows, not an update. That
-- makes it the answer to D5 as well: when a published record is revised, the
-- new observation is added and the old one remains, so the change is visible
-- rather than silent.

BEGIN;

CREATE TABLE field_source (
    field_source_id serial PRIMARY KEY,
    entity          text    NOT NULL CHECK (entity IN ('bill','stage_event','session')),
    entity_id       integer NOT NULL,
    field_name      text    NOT NULL,
    source          text    NOT NULL REFERENCES ref_source,
    source_ref      text,
    value_seen      text,
    observed_at     date    NOT NULL DEFAULT current_date,
    note            text,
    created_at      timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE field_source IS
 'Source of one field of one row. Only needed where the field differs from the row-level source. Append-only: never update a row here, add another observation.';
COMMENT ON COLUMN field_source.value_seen IS
 'The value as the source gave it, in the source''s own words. Lets a later revision be compared against what was originally read.';
COMMENT ON COLUMN field_source.observed_at IS
 'When the source was read. Two rows for one field with different observed_at means the record changed.';

CREATE INDEX field_source_entity_idx ON field_source (entity, entity_id);
CREATE INDEX field_source_field_idx  ON field_source (entity, entity_id, field_name, observed_at DESC);

-- A misspelled field_name would silently orphan the provenance, so check it exists.
CREATE FUNCTION field_source_check_field() RETURNS trigger AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_schema = 'public'
                     AND table_name  = NEW.entity
                     AND column_name = NEW.field_name) THEN
        RAISE EXCEPTION '% has no column named %', NEW.entity, NEW.field_name;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER field_source_field_exists
    BEFORE INSERT OR UPDATE ON field_source
    FOR EACH ROW EXECUTE FUNCTION field_source_check_field();

-- Latest observation per field.
CREATE VIEW v_field_source_current AS
SELECT DISTINCT ON (entity, entity_id, field_name)
       entity, entity_id, field_name, source, source_ref, value_seen, observed_at, note
FROM field_source
ORDER BY entity, entity_id, field_name, observed_at DESC, field_source_id DESC;

-- Fields observed more than once with differing values: the revision log.
CREATE VIEW v_field_revisions AS
SELECT entity, entity_id, field_name,
       count(*)                        AS observations,
       min(observed_at)                AS first_seen,
       max(observed_at)                AS last_seen,
       count(DISTINCT value_seen)      AS distinct_values
FROM field_source
GROUP BY 1,2,3
HAVING count(DISTINCT value_seen) > 1;

COMMIT;
