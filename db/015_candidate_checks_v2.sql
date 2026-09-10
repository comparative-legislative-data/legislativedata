-- 015_candidate_checks_v2.sql
-- v_candidate_problems was written at db/009 and has not moved since, but the
-- staging table has: db/012 added bill_type_stated, db/013 added the rule that
-- date_concluded belongs only to a bill that did not pass, and db/014 added
-- end_stage_1_date. None of the three were checked.
--
-- This matters more than it sounds. The view's emptiness is what the gateway
-- rests on — "work it to empty before promoting" — so a check that does not
-- exist is a promotion that is not gated. Session 1 passes all of the new checks
-- as it stands; they were run by hand before this migration was written. The
-- point is that Sessions 2-7 will be gated on them automatically.
--
-- Additions:
--   * end_stage_1_date ordering, against introduction, Stage 3 and conclusion
--   * date_concluded set if and only if the bill did not pass — bill's own
--     CHECK constraint would refuse the row at promotion otherwise
--   * a bill that passed must have a Stage 3 date, and one that did not must not
--   * bill_type_stated present and in ref_bill_type_stated
--   * title_kind restricted to its two values, and agreeing with enactment
--   * asp_number present for an enacted bill, and its year matching Royal Assent
--   * raw_section and outcome telling the same story
--   * dates falling inside the session they are claimed for, where the session
--     row has dates to check against

BEGIN;

CREATE OR REPLACE VIEW v_candidate_problems AS
WITH checks AS (
    SELECT c.candidate_id, c.session_number, c.short_title, c.review_status, p.problem
    FROM bill_candidate c
    LEFT JOIN session s ON s.session_number = c.session_number
    CROSS JOIN LATERAL (VALUES
        -- ------------------------------------------------ db/009, unchanged
        (CASE WHEN c.short_title IS NULL OR btrim(c.short_title) = ''
              THEN 'short_title is empty' END),
        (CASE WHEN c.session_number IS NULL
              THEN 'session_number is null' END),
        (CASE WHEN c.session_number IS NOT NULL AND s.session_number IS NULL
              THEN 'session_number '||c.session_number||' has no session row' END),
        (CASE WHEN c.bill_type IS NULL THEN 'bill_type not proposed'
              WHEN NOT EXISTS (SELECT 1 FROM ref_bill_type r WHERE r.code = c.bill_type)
              THEN 'bill_type '||quote_literal(c.bill_type)||' is not in ref_bill_type' END),
        (CASE WHEN c.procedure IS NOT NULL
               AND NOT EXISTS (SELECT 1 FROM ref_procedure r WHERE r.code = c.procedure)
              THEN 'procedure '||quote_literal(c.procedure)||' is not in ref_procedure' END),
        (CASE WHEN c.outcome IS NULL THEN 'outcome not proposed — needs a judgement'
              WHEN NOT EXISTS (SELECT 1 FROM ref_outcome r WHERE r.code = c.outcome)
              THEN 'outcome '||quote_literal(c.outcome)||' is not in ref_outcome' END),
        (CASE WHEN c.enactment_status IS NULL THEN 'enactment_status not proposed'
              WHEN NOT EXISTS (SELECT 1 FROM ref_enactment_status r
                               WHERE r.code = c.enactment_status)
              THEN 'enactment_status '||quote_literal(c.enactment_status)
                   ||' is not in ref_enactment_status' END),
        (CASE WHEN c.source IS NOT NULL
               AND NOT EXISTS (SELECT 1 FROM ref_source r WHERE r.code = c.source)
              THEN 'source '||quote_literal(c.source)||' is not in ref_source' END),
        (CASE WHEN c.end_stage_3_date IS NOT NULL AND c.date_introduced IS NOT NULL
               AND c.end_stage_3_date < c.date_introduced
              THEN 'passed before it was introduced' END),
        (CASE WHEN c.date_royal_assent IS NOT NULL AND c.end_stage_3_date IS NOT NULL
               AND c.date_royal_assent < c.end_stage_3_date
              THEN 'Royal Assent before Stage 3' END),
        (CASE WHEN c.date_concluded IS NOT NULL AND c.date_introduced IS NOT NULL
               AND c.date_concluded < c.date_introduced
              THEN 'concluded before it was introduced' END),
        (CASE WHEN c.raw_date_introduced IS NOT NULL AND c.date_introduced IS NULL
              THEN 'date_introduced unparsed: '||quote_literal(c.raw_date_introduced) END),
        (CASE WHEN c.raw_date_royal_assent IS NOT NULL AND c.date_royal_assent IS NULL
              THEN 'royal assent unparsed: '||quote_literal(c.raw_date_royal_assent) END),
        (CASE WHEN c.raw_date_final IS NOT NULL
               AND c.end_stage_3_date IS NULL AND c.date_concluded IS NULL
              THEN 'final date unparsed: '||quote_literal(c.raw_date_final) END),
        (CASE WHEN c.enactment_status = 'enacted' AND c.date_royal_assent IS NULL
              THEN 'enacted but no Royal Assent date' END),
        (CASE WHEN c.outcome <> 'passed' AND c.enactment_status = 'enacted'
              THEN 'enacted but outcome is not passed' END),

        -- ------------------------------------- new: end_stage_1_date (db/014)
        (CASE WHEN c.end_stage_1_date IS NOT NULL AND c.date_introduced IS NOT NULL
               AND c.end_stage_1_date < c.date_introduced
              THEN 'Stage 1 completed before introduction' END),
        (CASE WHEN c.end_stage_1_date IS NOT NULL AND c.end_stage_3_date IS NOT NULL
               AND c.end_stage_1_date > c.end_stage_3_date
              THEN 'Stage 1 completed after Stage 3' END),
        (CASE WHEN c.end_stage_1_date IS NOT NULL AND c.date_concluded IS NOT NULL
               AND c.end_stage_1_date > c.date_concluded
              THEN 'Stage 1 completed after the bill concluded' END),
        -- A bill rejected at Stage 1 fell on the date of that decision, so the
        -- two dates are the same event. See methodology note M2.
        (CASE WHEN c.outcome = 'rejected_stage_1' AND c.end_stage_1_date IS NOT NULL
               AND c.date_concluded IS NOT NULL
               AND c.end_stage_1_date <> c.date_concluded
              THEN 'rejected at Stage 1 but the Stage 1 date and the date it '
                   ||'concluded differ' END),

        -- ------------------------------------ new: date_concluded rule (db/013)
        (CASE WHEN c.outcome = 'passed' AND c.date_concluded IS NOT NULL
              THEN 'passed, but date_concluded is set — bill''s CHECK constraint '
                   ||'would refuse this row' END),
        (CASE WHEN c.outcome IS NOT NULL AND c.outcome NOT IN ('passed','in_progress')
               AND c.date_concluded IS NULL
              THEN 'did not pass, but has no date_concluded' END),
        (CASE WHEN c.outcome = 'passed' AND c.end_stage_3_date IS NULL
              THEN 'passed, but has no Stage 3 date' END),
        (CASE WHEN c.outcome IS NOT NULL AND c.outcome <> 'passed'
               AND c.end_stage_3_date IS NOT NULL
              THEN 'did not pass, but has a Stage 3 date' END),

        -- --------------------------------- new: bill_type_stated (db/012)
        (CASE WHEN c.bill_type_stated IS NULL THEN 'bill_type_stated not proposed'
              WHEN NOT EXISTS (SELECT 1 FROM ref_bill_type_stated r
                               WHERE r.code = c.bill_type_stated)
              THEN 'bill_type_stated '||quote_literal(c.bill_type_stated)
                   ||' is not in ref_bill_type_stated' END),

        -- ------------------------------------- new: title_kind and asp (db/013)
        (CASE WHEN c.title_kind IS NOT NULL AND c.title_kind NOT IN ('act','bill')
              THEN 'title_kind '||quote_literal(c.title_kind)||' is not act or bill' END),
        (CASE WHEN c.enactment_status = 'enacted' AND c.title_kind IS DISTINCT FROM 'act'
              THEN 'enacted, but title_kind is not act — see methodology note M3' END),
        (CASE WHEN c.enactment_status IS DISTINCT FROM 'enacted' AND c.title_kind = 'act'
              THEN 'title_kind is act, but the bill was not enacted' END),
        (CASE WHEN c.enactment_status = 'enacted' AND c.asp_number IS NULL
              THEN 'enacted, but no asp_number' END),
        (CASE WHEN c.asp_number IS NOT NULL AND c.date_royal_assent IS NOT NULL
               AND substring(c.asp_number from '^\d{4}')
                   <> to_char(c.date_royal_assent,'YYYY')
              THEN 'asp_number year does not match the year of Royal Assent' END),
        (CASE WHEN c.short_title ~* '\masp\M'
              THEN 'short_title still contains the asp number' END),

        -- ------------------------- new: the factsheet's own section vs outcome
        -- The section a row was read from is the factsheet's own classification.
        -- A disagreement is not necessarily an error — the five Session 1 bills
        -- SPICe listed as fallen were rejected at Stage 1 — but it should never
        -- pass unnoticed.
        (CASE WHEN c.raw_section = 'acts' AND c.outcome IS DISTINCT FROM 'passed'
              THEN 'read from the Acts table, but outcome is '
                   ||coalesce(quote_literal(c.outcome),'null') END),
        (CASE WHEN c.raw_section = 'withdrawn' AND c.outcome IS DISTINCT FROM 'withdrawn'
              THEN 'read from the Withdrawn table, but outcome is '
                   ||coalesce(quote_literal(c.outcome),'null') END),
        (CASE WHEN c.raw_section = 'fallen'
               AND c.outcome NOT IN ('fell_dissolution','fell_other','rejected_stage_1',
                                     'rejected_stage_3')
              THEN 'read from the Fallen table, but outcome is '
                   ||coalesce(quote_literal(c.outcome),'null') END),

        -- ------------------------------------- new: dates inside their session
        -- Only checked where the session row carries dates; all seven are still
        -- null, so this lies dormant until they are filled in.
        (CASE WHEN s.date_first_meeting IS NOT NULL AND c.date_introduced IS NOT NULL
               AND c.date_introduced < s.date_first_meeting
              THEN 'introduced before the session began' END),
        (CASE WHEN s.date_dissolution IS NOT NULL AND c.date_introduced IS NOT NULL
               AND c.date_introduced > s.date_dissolution
              THEN 'introduced after the session ended' END),
        (CASE WHEN s.date_dissolution IS NOT NULL AND c.end_stage_3_date IS NOT NULL
               AND c.end_stage_3_date > s.date_dissolution
              THEN 'passed after the session ended' END),
        (CASE WHEN s.date_dissolution IS NOT NULL AND c.date_concluded IS NOT NULL
               AND c.date_concluded > s.date_dissolution
              THEN 'concluded after the session ended' END)
    ) AS p(problem)
)
SELECT * FROM checks WHERE problem IS NOT NULL;

COMMENT ON VIEW v_candidate_problems IS
 'One row per problem with a candidate. Empty before promotion, or the promotion will refuse the row. Extended at db/015 to cover end_stage_1_date, the date_concluded rule, bill_type_stated, title_kind, asp_number, section-versus-outcome, and dates falling outside their own session.';

COMMIT;
