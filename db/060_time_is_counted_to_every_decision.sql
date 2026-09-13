-- db/060_time_is_counted_to_every_decision.sql
--
-- The owner's ruling of 2026-09-13, built. A period is counted to a stage where
-- the stage reached its terminal point and the Parliament took a decision.
-- Which way the decision went, and what became of the bill afterwards, do not
-- bear on it. See DECISIONS.md.
--
-- Two faults, opposite to each other, and both in the derived tables only. No
-- recorded date moves, no bill's coding changes, nothing on the clean sheet is
-- touched: every day this needs is already held, with its source.
--
-- 1. The stage-by-stage table counted a period only where the bill got THROUGH
--    the stage. That dropped fifteen periods whose two ends are both recorded:
--    the fourteen bills rejected at Stage 1, and the Budget (Scotland) (No. 2)
--    Bill's Stage 2 to its Stage 3 vote. It dropped them one-sidedly, because
--    only Members' Bills lose Stage 1 votes, and it did not even do it
--    consistently -- the Creative Scotland Bill's Stage 1 was counted and the
--    Autism Bill's was not, the difference being which way the vote went.
--
-- 2. The introduction-to-passing table did the reverse: it took whatever day
--    sat against the final stage without asking what happened, so the Budget
--    (Scotland) (No. 2) Bill appeared with 20 days "to passing" for a bill the
--    Parliament rejected. The 20 days are real; the word was false. The column
--    now says what it measures -- introduction to the final stage's decision --
--    and the outcome travels with it so a reader can take all bills or only
--    those that passed.
--
-- Methodology note M2 already said "durations are measured between consecutive
-- dated points". The note was right and the calculation disagreed with it. M2
-- gains only what the note never said: that the decision taken does not bear on
-- the period, and that whether the bill passed is carried alongside it.

\set ON_ERROR_STOP on
BEGIN;

-- What the tables hold before this, so the migration proves its own effect
-- rather than asserting it.
CREATE TEMP TABLE before_counts ON COMMIT DROP AS
SELECT (SELECT count(*) FROM v_bill_stage_durations) AS periods,
       (SELECT count(*) FROM v_bill_total_duration)  AS whole_bills;

-- ---------------------------------------------------------------------------
-- 1. Stage by stage
--
--    The summary is built on this one, so it comes off first and goes back on
--    at the end.
-- ---------------------------------------------------------------------------

DROP VIEW v_stage_duration_summary;
DROP VIEW v_bill_stage_durations;

CREATE VIEW v_bill_stage_durations AS
WITH points AS (
    SELECT b.bill_id, 0 AS stage_order, 'introduction'::text AS stage,
           b.date_introduced AS on_date, true AS got_through
      FROM bill b WHERE b.date_introduced IS NOT NULL
    UNION ALL
    -- Every stage with a day against it. A day means the Parliament reached the
    -- end of the stage: a stage that never reached its end carries none, and
    -- the day a bill was withdrawn partway through sits on the bill instead.
    -- tools/duration_coverage.sql holds that to be true.
    SELECT e.bill_id, e.stage_order, e.stage, e.date_completed, e.completed
      FROM stage_event e WHERE e.date_completed IS NOT NULL
    UNION ALL
    SELECT b.bill_id, 9, 'royal_assent'::text, b.date_royal_assent, true
      FROM bill b WHERE b.date_royal_assent IS NOT NULL
),
ordered AS (
    SELECT p.bill_id, p.stage_order, p.stage, p.on_date, p.got_through,
           lag(p.stage)       OVER w AS previous_stage,
           lag(p.stage_order) OVER w AS previous_order,
           lag(p.on_date)     OVER w AS previous_date
      FROM points p
    WINDOW w AS (PARTITION BY p.bill_id ORDER BY p.stage_order)
)
SELECT b.bill_id, b.session_number, b.short_title, b.bill_type, b.procedure, b.party,
       b.outcome,
       o.previous_order, o.previous_stage, o.previous_date,
       o.stage_order, o.stage, o.on_date AS date_completed,
       o.on_date - o.previous_date AS calendar_days,
       o.got_through AS bill_got_through_this_stage,
       b.outcome = 'passed' AS bill_passed
  FROM ordered o JOIN bill b USING (bill_id)
 WHERE o.previous_date IS NOT NULL;

COMMENT ON VIEW v_bill_stage_durations IS
 'Days between each stage a bill reached the end of and the point before it. A period is counted wherever the Parliament took the decision that ends a stage, whatever it decided: a bill rejected at Stage 1 has a real introduction-to-Stage-1 period, and so does one whose principles were agreed. bill_got_through_this_stage and bill_passed say what happened, so a figure can cover all bills or only those that passed without either being built in. Group by stage_order to compare across bill types; group by stage to keep the real stage names apart. See DECISIONS.md, 2026-09-13, and methodology note M2.';

ALTER VIEW v_bill_stage_durations OWNER TO legdata;

CREATE VIEW v_stage_duration_summary AS
SELECT session_number, bill_type, procedure,
       previous_order, stage_order, previous_stage, stage,
       count(*) AS bills,
       count(*) FILTER (WHERE bill_passed) AS bills_that_passed,
       round(avg(calendar_days)) AS mean_days,
       percentile_cont(0.5) WITHIN GROUP (ORDER BY calendar_days::double precision) AS median_days,
       min(calendar_days) AS min_days,
       max(calendar_days) AS max_days
  FROM v_bill_stage_durations
 GROUP BY session_number, bill_type, procedure, previous_order, stage_order, previous_stage, stage
 ORDER BY session_number, bill_type, procedure, previous_order, stage_order;

COMMENT ON VIEW v_stage_duration_summary IS
 'The stage-by-stage periods averaged, by session and bill type. bills is every bill counted into the cell and bills_that_passed how many of them went on to pass, so a figure covering a mix of bills cannot be read as a figure about successful ones. Choosing which bills a published chart covers is a front-end decision, not one made here.';

ALTER VIEW v_stage_duration_summary OWNER TO legdata;

-- ---------------------------------------------------------------------------
-- 2. Introduction to the end of the final stage
--
--    Named for what it measures. A bill the Parliament rejected at its final
--    stage took a real length of time to get there; what it does not have is a
--    passing, and bill_passed says so.
-- ---------------------------------------------------------------------------

DROP VIEW v_bill_total_duration;

CREATE VIEW v_bill_total_duration AS
SELECT b.bill_id, b.session_number, b.short_title, b.bill_type, b.procedure, b.party,
       b.outcome, b.outcome = 'passed' AS bill_passed,
       b.date_introduced, d.final_stage, d.final_stage_end,
       d.final_stage_end - b.date_introduced AS calendar_days_to_final_stage,
       b.date_royal_assent - d.final_stage_end AS calendar_days_to_assent
  FROM bill b JOIN v_bill_stage_dates d USING (bill_id)
 WHERE b.date_introduced IS NOT NULL AND d.final_stage_end IS NOT NULL;

COMMENT ON VIEW v_bill_total_duration IS
 'One row per bill, from introduction to the day its final stage was decided. calendar_days_to_final_stage is not a time to passing: a bill rejected at its final stage is here too, took that long to get there, and has bill_passed false. Until db/060 this column was called calendar_days_to_passing and the Budget (Scotland) (No. 2) Bill sat in it under that name having been rejected. calendar_days_to_assent is empty unless the bill became an Act.';

ALTER VIEW v_bill_total_duration OWNER TO legdata;

-- ---------------------------------------------------------------------------
-- 3. What makes the rule safe rather than lucky
--
--    The whole calculation now rests on this: a day recorded against a stage
--    means the Parliament reached that stage's end. Nothing enforced it. A
--    rehearsal put the day a bill was withdrawn onto its Stage 1 -- the
--    Family Homes and Homelessness (Scotland) Bill, withdrawn during Stage 1 --
--    and both sheets took it without complaint, at which point a bill that was
--    never debated would have contributed a period as though it had been.
--
--    So: a stage the bill did not get through may carry a day only where the
--    Official Report gives it, because only a decision of the Parliament ends a
--    stage the bill did not get through, and the Official Report is the record
--    of the Parliament's decisions. All fifteen such rows satisfy it today. If
--    a case ever arises where such a decision is evidenced elsewhere, this
--    refuses it rather than counting it quietly, which is the point.
-- ---------------------------------------------------------------------------

ALTER TABLE stage_event
  ADD CONSTRAINT stage_event_undated_unless_parliament_decided
  CHECK (completed OR did_not_happen OR date_completed IS NULL
         OR source = 'official_report');

ALTER TABLE stage_candidate
  ADD CONSTRAINT stage_candidate_undated_unless_parliament_decided
  CHECK (completed OR did_not_happen OR date_completed IS NULL
         OR source = 'official_report');

-- ---------------------------------------------------------------------------
-- 4. What must be true afterwards
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer; m integer; b record;
BEGIN
  SELECT * INTO b FROM before_counts;

  SELECT count(*) INTO n FROM v_bill_stage_durations;
  IF n <> b.periods + 15 THEN
    RAISE EXCEPTION 'Expected % periods, 15 more than before; found %.', b.periods + 15, n;
  END IF;

  -- The fifteen are the ones named in the header, and nothing else.
  SELECT count(*) INTO n FROM v_bill_stage_durations
   WHERE NOT bill_got_through_this_stage;
  IF n <> 15 THEN
    RAISE EXCEPTION 'Expected 15 periods ending at a stage the bill did not get through; found %.', n;
  END IF;

  SELECT count(*) INTO n FROM v_bill_stage_durations
   WHERE NOT bill_got_through_this_stage AND outcome = 'rejected_stage_1' AND stage_order = 1;
  IF n <> 14 THEN
    RAISE EXCEPTION 'Expected 14 of them to be Stage 1 rejections; found %.', n;
  END IF;

  SELECT count(*) INTO n FROM v_bill_stage_durations
   WHERE NOT bill_got_through_this_stage AND outcome = 'rejected_stage_3';
  IF n <> 1 THEN
    RAISE EXCEPTION 'Expected 1 of them to be the bill rejected at Stage 3; found %.', n;
  END IF;

  -- Nothing is counted from or to a day that is not recorded.
  SELECT count(*) INTO n FROM v_bill_stage_durations
   WHERE date_completed IS NULL OR previous_date IS NULL OR calendar_days IS NULL;
  IF n > 0 THEN RAISE EXCEPTION '% period(s) have an end with no day.', n; END IF;

  -- No period runs backwards.
  SELECT count(*) INTO n FROM v_bill_stage_durations WHERE calendar_days < 0;
  IF n > 0 THEN RAISE EXCEPTION '% period(s) are negative.', n; END IF;

  -- The whole-bill table keeps its rows and gains the two columns.
  SELECT count(*) INTO m FROM v_bill_total_duration;
  IF m <> b.whole_bills THEN
    RAISE EXCEPTION 'The introduction-to-final-stage table held % rows and now holds %.', b.whole_bills, m;
  END IF;
  SELECT count(*) INTO n FROM v_bill_total_duration WHERE NOT bill_passed;
  IF n <> 1 THEN
    RAISE EXCEPTION 'Expected exactly 1 row in it for a bill that did not pass; found %.', n;
  END IF;

  -- Every stage that carries a day and that the bill did not get through is
  -- the Official Report's, which is what the new rule requires. Stated as a
  -- count rather than trusted to the constraint, because the constraint was
  -- added a moment ago and a constraint that matches nothing proves nothing.
  SELECT count(*) INTO n FROM stage_event
   WHERE date_completed IS NOT NULL AND NOT completed AND NOT did_not_happen;
  IF n <> 15 THEN
    RAISE EXCEPTION 'Expected 15 dated stages the bill did not get through; found %.', n;
  END IF;
  SELECT count(*) INTO n FROM stage_event
   WHERE date_completed IS NOT NULL AND NOT completed AND NOT did_not_happen
     AND source <> 'official_report';
  IF n > 0 THEN
    RAISE EXCEPTION '% of them do not come from the Official Report.', n;
  END IF;

  RAISE NOTICE 'Periods: % before, % now. 15 added, all of them ending at a decision the bill lost.', b.periods, (SELECT count(*) FROM v_bill_stage_durations);
END $$;

-- ---------------------------------------------------------------------------
-- 5. What a reader is told
--
--    M2's account of durations was already right -- "measured between
--    consecutive dated points" -- and the calculation disagreed with it. It
--    gains the two things it never said.
-- ---------------------------------------------------------------------------

UPDATE methodology_note SET body = replace(body,
 'Durations are measured between consecutive dated points: introduction, each dated stage, and Royal Assent.',
 'Durations are measured between consecutive dated points: introduction, each dated stage, and Royal Assent. '
 || 'A stage has a date where it reached its terminal point and the Parliament took the decision that ends it, '
 || 'and what the Parliament decided does not bear on the length of time taken to reach it: a bill whose general '
 || 'principles were refused at Stage 1 has an introduction-to-Stage-1 period exactly as one whose principles were '
 || 'agreed, and a bill rejected at its final stage has a period from the stage before it. Whether the bill got '
 || 'through the stage, and whether it went on to pass, are recorded alongside each period, so a figure can cover '
 || 'every bill that reached that stage or only the bills that completed their passage. Which of those a published '
 || 'chart shows is stated on the chart.')
 WHERE code = 'M2';

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM methodology_note
   WHERE code = 'M2' AND body LIKE '%what the Parliament decided does not bear on the length of time%';
  IF n <> 1 THEN RAISE EXCEPTION 'M2 was not amended: the sentence it was anchored on has changed.'; END IF;
END $$;

COMMIT;
