-- 003_slice_views.sql
-- The two slice questions, as views. Nothing here is stored: both are computed
-- from bill and stage_event so they cannot drift from the data.

BEGIN;

-- Slice 1: outcome by bill type.
CREATE OR REPLACE VIEW v_outcome_by_type AS
SELECT b.session_number,
       b.bill_type,
       b.procedure,
       b.outcome,
       b.enactment_status,
       count(*) AS bills
FROM bill b
GROUP BY 1,2,3,4,5
ORDER BY 1,2,3,4;

-- Slice 2, per bill: days between each completed stage and the one before it.
CREATE OR REPLACE VIEW v_bill_stage_durations AS
WITH ordered AS (
    SELECT se.bill_id,
           se.stage,
           se.stage_order,
           se.date_completed,
           lag(se.stage)          OVER w AS previous_stage,
           lag(se.date_completed) OVER w AS previous_date
    FROM stage_event se
    WHERE se.completed
    WINDOW w AS (PARTITION BY se.bill_id ORDER BY se.stage_order)
)
SELECT b.bill_id,
       b.session_number,
       b.short_title,
       b.bill_type,
       b.procedure,
       o.previous_stage,
       o.stage,
       o.previous_date,
       o.date_completed,
       (o.date_completed - o.previous_date) AS calendar_days
FROM ordered o
JOIN bill b USING (bill_id)
WHERE o.previous_date IS NOT NULL;

-- Slice 2, aggregated. Calendar days pending decision D3 (sitting days needs a
-- parliamentary calendar, which is its own slice).
CREATE OR REPLACE VIEW v_stage_duration_summary AS
SELECT session_number,
       bill_type,
       procedure,
       previous_stage,
       stage,
       count(*)                                                              AS bills,
       round(avg(calendar_days))                                             AS mean_days,
       percentile_cont(0.5) WITHIN GROUP (ORDER BY calendar_days)            AS median_days,
       min(calendar_days)                                                    AS min_days,
       max(calendar_days)                                                    AS max_days
FROM v_bill_stage_durations
GROUP BY 1,2,3,4,5
ORDER BY 1,2,3,4,5;

COMMIT;
