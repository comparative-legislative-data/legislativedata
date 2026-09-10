-- 018_stages_by_bill_type.sql
--
-- Record the stage a bill actually went through, under the name that stage
-- actually has for that kind of bill. Normalise for comparison in a view on top,
-- not in the storage underneath.
--
-- This reverses db/004 and db/005, which moved stage dates onto the bill row as
-- end_stage_1_date, end_stage_2_date and end_stage_3_date. See DECISIONS.md for
-- why that reversal is justified rather than a change of mind.
--
-- THE PROBLEM those columns had. Private Bills do not have Stages 1, 2 and 3.
-- They have Preliminary Stage, Consideration Stage and Final Stage. Hybrid Bills
-- use the same three. Session 1 has three Private Bills and the one that passed
-- had its Final Stage date sitting in a column named end_stage_3_date, which is
-- not a stage that bill ever had. There are roughly 20-25 Private Bills across
-- the seven sessions — nine of them in Session 2, the railway and tram bills,
-- which are exactly the slow cases that make a duration question interesting.
--
-- THE PATTERN. This is the same shape as bill_type_stated beside bill_type: the
-- contemporaneous fact is recorded as it stands, and the comparable research
-- variable is derived from it. D4 exists to stop the tidy version eating the
-- real one; the same argument applies one level down, to stages.
--
-- WHAT DOES NOT MOVE, and why. date_introduced and date_royal_assent stay on
-- bill. Every bill type has both, under the same name, so no nuance is lost by
-- holding them as columns — and moving them would duplicate two fields that
-- existing constraints and views already depend on. The distinction being served
-- here is that stage *names* differ by bill type. Introduction and Royal Assent
-- do not. date_concluded also stays: a bill being withdrawn is not a stage.
--
-- NOTHING IS POPULATED HERE. Five Stage 1 dates from the Official Report and 62
-- passing dates is the whole of the stage data that exists, and it is in
-- bill_candidate, not bill. The promotion script fans a candidate row out into
-- stage rows. This migration builds the shape that promotion writes into, while
-- bill is still empty and the shape is therefore free to change.

BEGIN;

-- ---------------------------------------------------------------------------
-- 1. Which stages each kind of bill has, and in what order.
--
-- This is the table that makes "the second stage" a meaningful thing to ask
-- about across bill types without asserting that Stage 2 and Consideration
-- Stage are the same stage. stage_order is the position; stage is the name.
CREATE TABLE ref_bill_type_stage (
    bill_type   text    NOT NULL REFERENCES ref_bill_type,
    stage_order integer NOT NULL,
    stage       text    NOT NULL REFERENCES ref_stage,
    PRIMARY KEY (bill_type, stage_order),
    UNIQUE (bill_type, stage)
);

COMMENT ON TABLE ref_bill_type_stage IS
 'The stage sequence for each kind of bill, and the only place that mapping lives. Positions 1-3 are the substantive stages; 4 is Reconsideration, which is optional and follows the final stage.';

INSERT INTO ref_bill_type_stage (bill_type, stage_order, stage) VALUES
 -- Public bills: Stages 1, 2 and 3, whoever introduced them.
 ('government', 1, 'stage_1'), ('government', 2, 'stage_2'),
 ('government', 3, 'stage_3'), ('government', 4, 'reconsideration'),
 ('members',    1, 'stage_1'), ('members',    2, 'stage_2'),
 ('members',    3, 'stage_3'), ('members',    4, 'reconsideration'),
 ('committee',  1, 'stage_1'), ('committee',  2, 'stage_2'),
 ('committee',  3, 'stage_3'), ('committee',  4, 'reconsideration'),
 -- Private and Hybrid Bills: Preliminary, Consideration, Final.
 ('private',    1, 'preliminary'), ('private', 2, 'consideration'),
 ('private',    3, 'final'),       ('private', 4, 'reconsideration'),
 ('hybrid',     1, 'preliminary'), ('hybrid',  2, 'consideration'),
 ('hybrid',     3, 'final'),       ('hybrid',  4, 'reconsideration');

-- ref_stage.applies_to is dropped rather than corrected. It marked the three
-- private stages 'private', which left Hybrid Bills unaccounted for, and its
-- CHECK allowed only public/private/both so it could not say otherwise. More to
-- the point, it was a second answer to a question ref_bill_type_stage now
-- answers properly — per bill type, in order — and two sources of truth about
-- which stages belong to which bills is how the wrong one gets used.
ALTER TABLE ref_stage DROP COLUMN applies_to;

-- ---------------------------------------------------------------------------
-- 2. Take the stage columns off bill.
--
-- The two CHECK constraints go with them: both encoded an ordering between
-- columns that no longer exist. The equivalent ordering now holds between rows
-- of stage_event, which is checked in the trigger below and in the candidate
-- problems view.
DROP VIEW IF EXISTS v_stage_duration_summary;
DROP VIEW IF EXISTS v_bill_stage_durations;
DROP VIEW IF EXISTS v_bill_total_duration;

ALTER TABLE bill DROP CONSTRAINT bill_stage_dates_ordered;
ALTER TABLE bill DROP CONSTRAINT bill_assent_after_stage_3;

ALTER TABLE bill DROP COLUMN end_stage_1_date;
ALTER TABLE bill DROP COLUMN end_stage_2_date;
ALTER TABLE bill DROP COLUMN end_stage_3_date;
-- reconsideration_stage was a boolean saying a bill went to Reconsideration.
-- It becomes a stage_event row at position 4, which also carries its date.
ALTER TABLE bill DROP COLUMN reconsideration_stage;

-- Royal Assent can no longer be checked against a column, so check it against
-- the final stage instead — done in the trigger below, where the stage rows are.
ALTER TABLE bill
    ADD CONSTRAINT bill_assent_after_introduction CHECK (
        date_royal_assent IS NULL OR date_introduced IS NULL
        OR date_royal_assent >= date_introduced
    );

-- ---------------------------------------------------------------------------
-- 3. A stage row has to be a stage that kind of bill actually has.
--
-- Without this the table would accept a Stage 2 row against a Private Bill,
-- which is the exact error the migration exists to prevent. It cannot be a
-- foreign key, because the bill type lives on bill rather than on stage_event.
CREATE FUNCTION stage_event_check_type() RETURNS trigger AS $$
DECLARE
    bt text;
BEGIN
    SELECT bill_type INTO bt FROM bill WHERE bill_id = NEW.bill_id;

    -- A bill whose type is not yet known cannot have its stages checked. Let it
    -- through rather than blocking; the candidate problems view is where an
    -- unknown type is chased.
    IF bt IS NULL THEN
        RETURN NEW;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM ref_bill_type_stage r
                    WHERE r.bill_type = bt
                      AND r.stage = NEW.stage
                      AND r.stage_order = NEW.stage_order) THEN
        RAISE EXCEPTION
          'a % bill has no stage % at position % — see ref_bill_type_stage',
          bt, quote_literal(NEW.stage), NEW.stage_order;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER stage_event_type_check
    BEFORE INSERT OR UPDATE ON stage_event
    FOR EACH ROW EXECUTE FUNCTION stage_event_check_type();

COMMENT ON TABLE stage_event IS
 'One row per stage a bill actually reached, under that stage''s real name for that kind of bill. Emptied of meaning by db/004 and restored by db/018. Introduction and Royal Assent are not held here — they are dates on bill, because every bill type has them under the same name.';

-- ---------------------------------------------------------------------------
-- 4. The stage dates, pivoted back into one row per bill.
--
-- This is the "normalise afterwards" half. It gives the convenience the columns
-- on bill used to give, while the names underneath stay true to the bill type.
CREATE VIEW v_bill_stage_dates AS
SELECT b.bill_id, b.session_number, b.short_title, b.bill_type, b.procedure,
       b.date_introduced,
       s1.stage AS first_stage,  s1.date_completed AS first_stage_end,
       s2.stage AS second_stage, s2.date_completed AS second_stage_end,
       s3.stage AS final_stage,  s3.date_completed AS final_stage_end,
       s4.date_completed AS reconsideration_end,
       (s4.stage_event_id IS NOT NULL) AS went_to_reconsideration,
       b.date_royal_assent,
       b.date_concluded
FROM bill b
LEFT JOIN stage_event s1 ON s1.bill_id = b.bill_id AND s1.stage_order = 1
LEFT JOIN stage_event s2 ON s2.bill_id = b.bill_id AND s2.stage_order = 2
LEFT JOIN stage_event s3 ON s3.bill_id = b.bill_id AND s3.stage_order = 3
LEFT JOIN stage_event s4 ON s4.bill_id = b.bill_id AND s4.stage_order = 4;

COMMENT ON VIEW v_bill_stage_dates IS
 'One row per bill with its stage dates as columns. first_stage/second_stage/final_stage name the stage for that bill type — Stage 1 for a public bill, Preliminary Stage for a Private or Hybrid Bill.';

-- ---------------------------------------------------------------------------
-- 5. Durations. Slice 2.
--
-- Introduction and Royal Assent are folded in as positions 0 and 9 so that the
-- first and last intervals can be measured, without storing them twice.
CREATE VIEW v_bill_stage_durations AS
WITH points AS (
    SELECT bill_id, 0 AS stage_order, 'introduction' AS stage, date_introduced AS on_date
      FROM bill WHERE date_introduced IS NOT NULL
    UNION ALL
    SELECT bill_id, stage_order, stage, date_completed
      FROM stage_event WHERE completed AND date_completed IS NOT NULL
    UNION ALL
    SELECT bill_id, 9, 'royal_assent', date_royal_assent
      FROM bill WHERE date_royal_assent IS NOT NULL
),
ordered AS (
    SELECT p.*,
           lag(p.stage)       OVER w AS previous_stage,
           lag(p.stage_order) OVER w AS previous_order,
           lag(p.on_date)     OVER w AS previous_date
      FROM points p
    WINDOW w AS (PARTITION BY p.bill_id ORDER BY p.stage_order)
)
SELECT b.bill_id, b.session_number, b.short_title, b.bill_type, b.procedure,
       b.party,
       o.previous_order, o.previous_stage, o.previous_date,
       o.stage_order,    o.stage,          o.on_date AS date_completed,
       (o.on_date - o.previous_date) AS calendar_days
FROM ordered o
JOIN bill b USING (bill_id)
WHERE o.previous_date IS NOT NULL;

COMMENT ON VIEW v_bill_stage_durations IS
 'Days between each stage a bill completed and the one before it. Group by stage_order to compare across bill types; group by stage to keep the real stage names apart.';

CREATE VIEW v_bill_total_duration AS
SELECT b.bill_id, b.session_number, b.short_title, b.bill_type, b.procedure,
       b.party, b.date_introduced,
       d.final_stage, d.final_stage_end,
       (d.final_stage_end - b.date_introduced) AS calendar_days_to_passing,
       (b.date_royal_assent - d.final_stage_end) AS calendar_days_to_assent
FROM bill b
JOIN v_bill_stage_dates d USING (bill_id)
WHERE b.date_introduced IS NOT NULL AND d.final_stage_end IS NOT NULL;

-- Aggregated by position, so a Private Bill's second stage lines up with a
-- public bill's second stage. The names are kept in the output rather than
-- collapsed, so it is always visible which stages are being compared.
CREATE VIEW v_stage_duration_summary AS
SELECT session_number, bill_type, procedure,
       previous_order, stage_order,
       previous_stage, stage,
       count(*)                                                  AS bills,
       round(avg(calendar_days))                                 AS mean_days,
       percentile_cont(0.5) WITHIN GROUP (ORDER BY calendar_days) AS median_days,
       min(calendar_days)                                        AS min_days,
       max(calendar_days)                                        AS max_days
FROM v_bill_stage_durations
GROUP BY 1,2,3,4,5,6,7
ORDER BY 1,2,3,4,5;

COMMIT;
