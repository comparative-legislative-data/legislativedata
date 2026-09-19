-- Bill outcomes by session and type: the figures behind the outcomes chart.
-- Every bill is counted once, in the session it was introduced in (M6), by how
-- its passage ended (M7). The Forth Crossing Bill is counted as a government
-- bill, from bill_type_grouped, or shown as a Hybrid Bill, from bill_type (M4).
-- Outcomes are shown in full, or as Passed, Not passed and In progress, where
-- Not passed is every ending other than those two. An outcome no bill has is
-- left out. Each figure lists the bills it counts, by bill_number.
WITH counted AS (
  SELECT 'Counted as a government bill' AS forth_crossing_bill,
         bill_type_grouped AS bill_type, session::text AS session,
         outcome, enactment_status, bill_number
    FROM bills
  UNION ALL
  SELECT 'Shown as a Hybrid Bill', bill_type, session::text,
         outcome, enactment_status, bill_number
    FROM bills
),
every_session AS (
  SELECT * FROM counted
  UNION ALL
  SELECT forth_crossing_bill, bill_type, 'All sessions',
         outcome, enactment_status, bill_number
    FROM counted
),
shown AS (
  SELECT 'Full breakdown' AS outcomes_shown, e.*, outcome AS shown_as
    FROM every_session e
  UNION ALL
  SELECT 'Passed or not', e.*,
         CASE WHEN outcome IN ('Passed', 'In progress') THEN outcome
              ELSE 'Not passed' END
    FROM every_session e
),
-- Every combination is given a line, so a nought is a nought and not a gap.
grid AS (
  SELECT v.outcomes_shown, t.forth_crossing_bill, t.bill_type, s.session,
         v.shown_as
    FROM (SELECT DISTINCT outcomes_shown, shown_as FROM shown) v
   CROSS JOIN (SELECT DISTINCT forth_crossing_bill, bill_type FROM counted) t
   CROSS JOIN (SELECT session::text AS session FROM sessions
               UNION ALL SELECT 'All sessions') s
),
of_this_type AS (
  SELECT forth_crossing_bill, bill_type, session, count(*) AS bills
    FROM every_session
   GROUP BY forth_crossing_bill, bill_type, session
),
figures AS (
  SELECT g.outcomes_shown, g.forth_crossing_bill, g.session, g.bill_type,
         g.shown_as AS outcome,
         coalesce(t.bills, 0) AS bills_of_this_type,
         count(s.bill_number) AS bills,
         round(100.0 * count(s.bill_number) / nullif(t.bills, 0)) AS percent_of_bills_of_this_type,
         CASE WHEN g.shown_as = 'Passed'
              THEN count(s.bill_number) FILTER (WHERE s.enactment_status = 'Enacted')
         END AS of_which_became_acts,
         string_agg(s.bill_number::text, '; ' ORDER BY s.bill_number) AS bill_numbers
    FROM grid g
    LEFT JOIN shown s
      ON s.outcomes_shown = g.outcomes_shown AND s.forth_crossing_bill = g.forth_crossing_bill
     AND s.bill_type = g.bill_type AND s.session = g.session AND s.shown_as = g.shown_as
    LEFT JOIN of_this_type t
      ON t.forth_crossing_bill = g.forth_crossing_bill AND t.bill_type = g.bill_type
     AND t.session = g.session
   GROUP BY g.outcomes_shown, g.forth_crossing_bill, g.session, g.bill_type, g.shown_as, t.bills
)
SELECT f.*
  FROM figures f
  LEFT JOIN what_the_words_mean ty
    ON ty.value = f.bill_type
   AND ty.heading = CASE WHEN f.forth_crossing_bill = 'Shown as a Hybrid Bill'
                         THEN 'bill_type' ELSE 'bill_type_grouped' END
  LEFT JOIN what_the_words_mean o
    ON o.value = f.outcome AND o.heading = 'outcome'
 ORDER BY f.outcomes_shown, f.forth_crossing_bill,
          f.session = 'All sessions', f.session, ty."order",
          CASE f.outcome WHEN 'Not passed' THEN 2 WHEN 'In progress' THEN 9 ELSE o."order" END;
