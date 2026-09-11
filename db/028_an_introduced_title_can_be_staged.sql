-- 028_an_introduced_title_can_be_staged.sql
--
-- Found loading Session 2. Its factsheet does three things with the title cell
-- that Session 1's never does, and the extractor handled none of them:
--
--   "Environmental Levy on Plastic Bags (Scotland) Bill SP Bill 43"
--   "Budget (Scotland) Act 2007 (asp 9)"
--   "Scottish Commission for Human Rights Act 2006 asp 16 Introduced as:
--    Scottish Commissioner for Human Rights Bill"
--
-- The extractor now separates all three (tools/extract_factsheet.py). This
-- migration does the two things the database needs for it.
--
-- 1. The staging sheet gains a place for a stated introduced title. The
--    factsheet survey recorded Session 2 as stating none, and on that basis
--    this column was deliberately not built (DECISIONS.md, 2026-09-10, "What
--    was deliberately not built"). Session 2 states one. bill already has
--    title_as_introduced; without a staging column, promotion has nothing to
--    carry into it.
--
-- 2. The error checker flags an SP Bill number or an introduced title left
--    inside short_title. It already flagged a leftover asp number, so two of
--    the three faults above would have been caught. The SP Bill number would
--    not: fifteen Session 2 bills would have reached the clean sheet with the
--    number in the title and none in sp_bill_id, and nothing would have said.
--
-- Also: methodology note M3 said the factsheets state an introduced title in
-- "three cases across seven sessions". This is a fourth, so the count comes out
-- rather than being corrected to a number the next session might falsify.
--
-- The checker is restated whole, because a view has to be. The body is db/020's
-- unchanged — the live definition has not moved since — with two cases added
-- after the asp number check.

BEGIN;

-- ---------------------------------------------------------------------------
-- 1. The staging column
-- ---------------------------------------------------------------------------

ALTER TABLE bill_candidate ADD COLUMN title_as_introduced text;

COMMENT ON COLUMN bill_candidate.title_as_introduced IS
 'The title the bill had when it was introduced, where the factsheet states it — Session 2 prints one inside the title cell, after "Introduced as:". Taken out of raw_title, which keeps the printed words. Empty means the factsheet does not state one, which is the usual case; empty never means the title did not change.';

COMMENT ON COLUMN bill_candidate.short_title IS
 'The bill or Act title, tidied for use: the asp number moved out into asp_number, the SP Bill number into sp_bill_id, any stated introduced title into title_as_introduced, and broken lines rejoined. raw_title stays as the record of what was printed. Whether this is the Act''s title or the bill''s is in title_kind.';

COMMENT ON COLUMN bill_candidate.sp_bill_id IS
 'The Parliament''s bill number within its session, as the factsheet gives it — printed at the end of the title cell, and taken out of it. Empty where the factsheet gives none: Session 1 gives no numbers at all, and Sessions 2 to 5 give them only for bills that did not become Acts.';

-- ---------------------------------------------------------------------------
-- 2. The error checker
-- ---------------------------------------------------------------------------

CREATE OR REPLACE VIEW v_candidate_problems AS
WITH checks AS (
    SELECT c.candidate_id, c.session_number, c.short_title, c.review_status, p.problem
    FROM bill_candidate c
    LEFT JOIN session s ON s.session_number = c.session_number
    CROSS JOIN LATERAL (VALUES
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

        (CASE WHEN c.end_stage_1_date IS NOT NULL AND c.date_introduced IS NOT NULL
               AND c.end_stage_1_date < c.date_introduced
              THEN 'Stage 1 completed before introduction' END),
        (CASE WHEN c.end_stage_1_date IS NOT NULL AND c.end_stage_3_date IS NOT NULL
               AND c.end_stage_1_date > c.end_stage_3_date
              THEN 'Stage 1 completed after Stage 3' END),
        (CASE WHEN c.end_stage_1_date IS NOT NULL AND c.date_concluded IS NOT NULL
               AND c.end_stage_1_date > c.date_concluded
              THEN 'Stage 1 completed after the bill concluded' END),
        (CASE WHEN c.outcome = 'rejected_stage_1' AND c.end_stage_1_date IS NOT NULL
               AND c.date_concluded IS NOT NULL
               AND c.end_stage_1_date <> c.date_concluded
              THEN 'rejected at Stage 1 but the Stage 1 date and the date it '
                   ||'concluded differ' END),

        -- ---------------------------------- changed at db/020: the rule is now
        -- about enactment, not about passing. A bill that passed and was later
        -- withdrawn is legitimate and needs its withdrawal date.
        (CASE WHEN c.enactment_status = 'enacted' AND c.date_concluded IS NOT NULL
              THEN 'enacted, but date_concluded is set — a bill that received '
                   ||'Royal Assent concluded at Royal Assent; bill''s CHECK '
                   ||'constraint would refuse this row' END),
        (CASE WHEN c.outcome IS NOT NULL AND c.outcome NOT IN ('passed','in_progress')
               AND c.date_concluded IS NULL
              THEN 'did not pass, but has no date_concluded' END),
        (CASE WHEN c.outcome = 'passed' AND c.end_stage_3_date IS NULL
              THEN 'passed, but has no Stage 3 date' END),
        (CASE WHEN c.outcome IS NOT NULL AND c.outcome <> 'passed'
               AND c.end_stage_3_date IS NOT NULL
              THEN 'did not pass, but has a Stage 3 date' END),

        (CASE WHEN c.bill_type_stated IS NULL THEN 'bill_type_stated not proposed'
              WHEN NOT EXISTS (SELECT 1 FROM ref_bill_type_stated r
                               WHERE r.code = c.bill_type_stated)
              THEN 'bill_type_stated '||quote_literal(c.bill_type_stated)
                   ||' is not in ref_bill_type_stated' END),

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

        -- ---------------------------------- added at db/028, from Session 2.
        (CASE WHEN c.short_title ~* '\mSP\s*Bill\s*\d'
              THEN 'short_title still contains the SP Bill number' END),
        (CASE WHEN c.short_title ~* '\mintroduced as\M'
              THEN 'short_title still contains a stated introduced title' END),

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

        -- Dates inside their session. Dormant until session rows carry dates.
        --
        -- KNOWN LIMITATION, recorded rather than papered over: these compare a
        -- candidate's dates against the session of the FACTSHEET it was read
        -- from, which is what bill_candidate.session_number means. For the four
        -- bills that appear in two factsheets the two are not the same, and
        -- these checks will fire on rows that are correct. Session 1 has no
        -- such bill, so nothing is done about it here; it must be handled
        -- before Session 5 is loaded. See docs/FACTSHEET-SURVEY.md §3.
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
 'One row per problem with a candidate. Empty before promotion, or the promotion will refuse the row. Extended at db/015; amended at db/020, where the date_concluded rule became a rule about enactment rather than about passing; at db/028 it also flags an SP Bill number or a stated introduced title left inside short_title.';

-- ---------------------------------------------------------------------------
-- 3. Methodology note M3
-- ---------------------------------------------------------------------------

UPDATE methodology_note
   SET body = replace(body,
         'states the introduced title only in the three cases across seven sessions where it explicitly noted a rename',
         'states the introduced title only in the few cases where it explicitly noted one')
 WHERE code = 'M3';

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM methodology_note WHERE code = 'M3' AND body LIKE '%three cases%') THEN
    RAISE EXCEPTION 'M3 was not updated: its wording no longer matches what this migration expects.';
  END IF;
  -- Session 1 is already admitted and promoted. A new check must not find
  -- fault with data that has been accepted.
  IF EXISTS (SELECT 1 FROM v_candidate_problems) THEN
    RAISE EXCEPTION 'The amended checker finds problems in lines already on the staging sheet.';
  END IF;
END $$;

COMMIT;
