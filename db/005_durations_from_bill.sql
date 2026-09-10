-- 005_durations_from_bill.sql
-- The stage end dates now live on bill, so the duration views read from there
-- rather than from stage_event. Same two slice questions, one table behind them.

BEGIN;

DROP VIEW IF EXISTS v_stage_duration_summary;
DROP VIEW IF EXISTS v_bill_stage_durations;

-- One row per completed stage transition, per bill.
CREATE VIEW v_bill_stage_durations AS
SELECT b.bill_id, b.session_number, b.short_title, b.bill_type, b.procedure,
       b.party, t.previous_stage, t.stage, t.from_date, t.to_date,
       (t.to_date - t.from_date) AS calendar_days
FROM bill b
CROSS JOIN LATERAL (VALUES
      ('introduction','stage_1',      b.date_introduced,  b.end_stage_1_date),
      ('stage_1',     'stage_2',      b.end_stage_1_date, b.end_stage_2_date),
      ('stage_2',     'stage_3',      b.end_stage_2_date, b.end_stage_3_date),
      ('stage_3',     'royal_assent', b.end_stage_3_date, b.date_royal_assent)
   ) AS t(previous_stage, stage, from_date, to_date)
WHERE t.from_date IS NOT NULL AND t.to_date IS NOT NULL;

-- Whole-passage time, introduction to passing.
CREATE VIEW v_bill_total_duration AS
SELECT bill_id, session_number, short_title, bill_type, procedure, party,
       date_introduced, end_stage_3_date,
       (end_stage_3_date - date_introduced) AS calendar_days_to_passing,
       (date_royal_assent - end_stage_3_date) AS calendar_days_to_assent
FROM bill
WHERE date_introduced IS NOT NULL AND end_stage_3_date IS NOT NULL;

-- Slice 2, aggregated. Calendar days pending decision D3.
CREATE VIEW v_stage_duration_summary AS
SELECT session_number, bill_type, procedure, previous_stage, stage,
       count(*)                                                   AS bills,
       round(avg(calendar_days))                                  AS mean_days,
       percentile_cont(0.5) WITHIN GROUP (ORDER BY calendar_days)  AS median_days,
       min(calendar_days)                                         AS min_days,
       max(calendar_days)                                         AS max_days
FROM v_bill_stage_durations
GROUP BY 1,2,3,4,5
ORDER BY 1,2,3,4,5;

COMMIT;
