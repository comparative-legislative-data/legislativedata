-- 009_candidate_checks.sql
-- The staging table has no constraints, so problems have to be visible as rows
-- instead of as import errors. This view is where they show up: one row per
-- problem, naming the candidate and what is wrong with it.
--
-- Work the list to empty before promoting. Anything still listed here would be
-- refused by bill's own constraints anyway.

BEGIN;

CREATE VIEW v_candidate_problems AS
WITH checks AS (
    SELECT c.candidate_id, c.session_number, c.short_title, c.review_status, p.problem
    FROM bill_candidate c
    CROSS JOIN LATERAL (VALUES
        (CASE WHEN c.short_title IS NULL OR btrim(c.short_title) = ''
              THEN 'short_title is empty' END),
        (CASE WHEN c.session_number IS NULL
              THEN 'session_number is null' END),
        (CASE WHEN c.session_number IS NOT NULL
               AND NOT EXISTS (SELECT 1 FROM session s
                               WHERE s.session_number = c.session_number)
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
        -- dates: the same ordering bill enforces, checked before promotion
        (CASE WHEN c.end_stage_3_date IS NOT NULL AND c.date_introduced IS NOT NULL
               AND c.end_stage_3_date < c.date_introduced
              THEN 'passed before it was introduced' END),
        (CASE WHEN c.date_royal_assent IS NOT NULL AND c.end_stage_3_date IS NOT NULL
               AND c.date_royal_assent < c.end_stage_3_date
              THEN 'Royal Assent before Stage 3' END),
        (CASE WHEN c.date_concluded IS NOT NULL AND c.date_introduced IS NOT NULL
               AND c.date_concluded < c.date_introduced
              THEN 'concluded before it was introduced' END),
        -- a date the factsheet printed that the parser could not read
        (CASE WHEN c.raw_date_introduced IS NOT NULL AND c.date_introduced IS NULL
              THEN 'date_introduced unparsed: '||quote_literal(c.raw_date_introduced) END),
        (CASE WHEN c.raw_date_royal_assent IS NOT NULL AND c.date_royal_assent IS NULL
              THEN 'royal assent unparsed: '||quote_literal(c.raw_date_royal_assent) END),
        (CASE WHEN c.raw_date_final IS NOT NULL
               AND c.end_stage_3_date IS NULL AND c.date_concluded IS NULL
              THEN 'final date unparsed: '||quote_literal(c.raw_date_final) END),
        -- consistency between the two settled variables
        (CASE WHEN c.enactment_status = 'enacted' AND c.date_royal_assent IS NULL
              THEN 'enacted but no Royal Assent date' END),
        (CASE WHEN c.outcome <> 'passed' AND c.enactment_status = 'enacted'
              THEN 'enacted but outcome is not passed' END)
    ) AS p(problem)
)
SELECT * FROM checks WHERE problem IS NOT NULL;

COMMENT ON VIEW v_candidate_problems IS
 'One row per problem with a candidate. Empty before promotion, or the promotion will refuse the row.';

COMMIT;
