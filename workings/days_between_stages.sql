-- The days between stages, worked out from bills and stages.
-- For each bill, its dated points are put in order: the day it was introduced,
-- the day each stage ended, and the day of Royal Assent. Each line is the gap
-- from one point to the next, counted in calendar days. A stage with no date
-- is left out, so the gap runs across it to the next dated point. See M2.
WITH points AS (
  SELECT bill_number, 0 AS position, 'Introduction' AS point,
         date_introduced AS on_date, 'Yes' AS got_through
    FROM bills WHERE date_introduced IS NOT NULL
  UNION ALL
  SELECT bill_number, stage_position, stage, date_ended, got_through
    FROM stages WHERE date_ended IS NOT NULL
  UNION ALL
  SELECT bill_number, 9, 'Royal Assent', date_royal_assent, 'Yes'
    FROM bills WHERE date_royal_assent IS NOT NULL
),
gaps AS (
  SELECT bill_number, position,
         LAG(point)   OVER (PARTITION BY bill_number ORDER BY position) AS measured_from,
         LAG(on_date) OVER (PARTITION BY bill_number ORDER BY position) AS date_measured_from,
         point AS measured_to, on_date AS date_measured_to, got_through
    FROM points
)
SELECT b.bill_number, b.title, b.session, b.bill_type, b.procedure, b.outcome,
       g.measured_from, g.date_measured_from, g.measured_to, g.date_measured_to,
       g.date_measured_to - g.date_measured_from AS days,
       g.got_through AS got_through_the_later_stage,
       CASE WHEN b.outcome = 'Passed' THEN 'Yes'
            WHEN b.outcome IS NOT NULL THEN 'No' END AS bill_passed
  FROM gaps g JOIN bills b ON b.bill_number = g.bill_number
 WHERE g.date_measured_from IS NOT NULL
 ORDER BY b.bill_number, g.position;
