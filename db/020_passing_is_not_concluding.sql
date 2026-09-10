-- 020_passing_is_not_concluding.sql
-- Passing Stage 3 is the completion of Stage 3. It is not the end of the bill.
--
-- db/013 added the constraint bill_concluded_only_if_not_passed:
--
--     date_concluded IS NULL OR outcome <> 'passed'
--
-- on the reasoning that a bill which passed already has its ending recorded as
-- the Stage 3 date, so date_concluded belongs only to a bill that was withdrawn
-- or fell. The factsheet survey found four bills for which that is false, and
-- they are four different endings from the same starting point:
--
--   UK Withdrawal from the EU (Legal Continuity) (Scotland) Bill
--       passed 21 March 2018, referred to the Supreme Court under section 33,
--       ruled partly outwith competence, and WITHDRAWN on 10 March 2022 —
--       nearly four years after it passed, and in the following session.
--   UNCRC (Incorporation) (Scotland) Bill
--   European Charter of Local Self-Government (Incorporation) (Scotland) Bill
--       both passed in Session 5, both referred under section 33 and ruled
--       partly outwith competence on 6 October 2021, both taken through
--       Reconsideration Stage in Session 6, and both enacted.
--   Gender Recognition Reform (Scotland) Bill
--       passed 22 December 2022 and blocked on 16 January 2023 by an order of
--       the UK Government under section 35 of the Scotland Act 1998. The
--       Scottish Government has neither sought reconsideration nor withdrawn
--       it, so it is still a live bill: it did not fall at the end of Session 6
--       the way an unfinished bill does, and the Session 7 factsheet carries it
--       forward as one of that session's own bills.
--
-- So a bill that has passed is in one of several states, and only one of them
-- is finished. The constraint is rewritten to say what was actually meant:
-- a bill that received Royal Assent concluded at Royal Assent, so it needs no
-- separate concluding date. Everything else may have one.

BEGIN;

ALTER TABLE bill DROP CONSTRAINT bill_concluded_only_if_not_passed;

ALTER TABLE bill
    ADD CONSTRAINT bill_concluded_only_if_not_enacted CHECK (
        date_concluded IS NULL OR enactment_status <> 'enacted'
    );

COMMENT ON COLUMN bill.date_concluded IS
 'Date the bill stopped being a live bill without becoming an Act — withdrawn, or fell. Null for a bill that received Royal Assent, whose conclusion is date_royal_assent, and null for a bill that is still live, including one blocked from assent and left in that state. A bill can pass and be withdrawn afterwards: see methodology note M5.';

-- ---------------------------------------------------------------------------
-- The date assent was blocked.
--
-- This is the one addition here that is not forced by a constraint, and it is
-- added deliberately rather than by drift. Without it, 'blocked' is a state
-- with no time attached, in a project whose second research question is about
-- time. The Gender Recognition Reform Bill has been blocked since 16 January
-- 2023; that duration is a fact about the Parliament, and it is not derivable
-- from any other column. It is one nullable date holding the date of a value
-- already stored, not a new structure.
--
-- It deliberately does NOT duplicate date_royal_assent or date_concluded. It
-- records the intervention, which is a different event from the ending, and it
-- stays populated after the block is lifted — which is how the bills that were
-- blocked and recovered can be found at all.
ALTER TABLE bill ADD COLUMN date_assent_blocked date;

COMMENT ON COLUMN bill.date_assent_blocked IS
 'Date the bill was prevented from being submitted for Royal Assent: the date of a Supreme Court ruling on a section 33 reference, or of an order under section 35 of the Scotland Act 1998. Kept even after the block is lifted, so a bill that was blocked and later enacted remains findable. Which mechanism applied goes in note. Null means it never happened.';

ALTER TABLE bill
    ADD CONSTRAINT bill_assent_blocked_after_introduction CHECK (
        date_assent_blocked IS NULL OR date_introduced IS NULL
        OR date_assent_blocked >= date_introduced
    );

-- ---------------------------------------------------------------------------
-- The enactment vocabulary: no new values, two corrected definitions.
--
-- 'pending' said "including referral". Under that wording a bill referred to
-- the Supreme Court and ruled against is describable both as pending and as
-- blocked, depending which clause of the definition is read. Referral with an
-- adverse outcome is blocked; pending means nothing adverse has happened.
--
-- 'blocked' covers both mechanisms, and covers a bill left in that state
-- indefinitely. There is no separate value for stasis: the absence of any
-- further event is what "still blocked" means, and enactment_status records
-- the current state rather than a history. The history is in field_source,
-- which is append-only for exactly this reason.
UPDATE ref_enactment_status SET definition =
 'Passed, and awaiting Royal Assent with nothing adverse recorded. A bill referred to the Supreme Court or subject to a section 35 order is ''blocked'', not ''pending''.'
 WHERE code = 'pending';

UPDATE ref_enactment_status SET definition =
 'Passed, but prevented from being submitted for Royal Assent — by a Supreme Court ruling on a section 33 reference, or by an order under section 35 of the Scotland Act 1998. Which mechanism applied is recorded in bill.note, and the date in bill.date_assent_blocked. A bill can remain in this state indefinitely: see methodology note M5.'
 WHERE code = 'blocked';

-- ---------------------------------------------------------------------------
-- v_candidate_problems encoded the old rule and would now reject a legitimate
-- row. Only the two date_concluded clauses change; the rest is restated because
-- the view has to be replaced whole.
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
 'One row per problem with a candidate. Empty before promotion, or the promotion will refuse the row. Extended at db/015; amended at db/020, where the date_concluded rule became a rule about enactment rather than about passing.';

-- ---------------------------------------------------------------------------
INSERT INTO methodology_note (code, title, body, applies_to, sort_order) VALUES
('M5',
 'Passing a bill is not the same as the bill being finished',
 'A bill that is passed by the Parliament does not automatically become an Act. It must be submitted for Royal Assent, and that submission can be prevented in two ways: the Law Officers may refer the bill to the Supreme Court under section 33 of the Scotland Act 1998, and the Supreme Court may rule that some of it is outwith the Parliament''s legislative competence; or a Secretary of State may make an order under section 35 prohibiting submission. This resource therefore records what the Parliament did (bill.outcome) separately from whether the bill became an Act (bill.enactment_status), and a count of bills passed will not equal a count of Acts. Four bills are affected. Three were referred under section 33 and ruled against on 6 October 2021: the UNCRC (Incorporation) and European Charter of Local Self-Government (Incorporation) Bills were subsequently taken through Reconsideration Stage and enacted, and the UK Withdrawal from the European Union (Legal Continuity) Bill was withdrawn on 10 March 2022, nearly four years after it passed. The fourth, the Gender Recognition Reform (Scotland) Bill, was blocked by a section 35 order on 16 January 2023, and no further step has been taken. A bill in that position does not fall at the end of a session in the way an unfinished bill does; it remains a live bill, and the Parliament''s own fact sheets carry it forward into the next session. The status ''blocked'' covers both mechanisms and covers a bill left in that state indefinitely; which mechanism applied is recorded in bill.note, and the date in bill.date_assent_blocked. Because enactment_status records a bill''s current state rather than its history, a bill that was blocked and later enacted shows as enacted; the earlier state is recoverable from field_source, which is append-only.',
 '{bill.outcome,bill.enactment_status,bill.date_assent_blocked,bill.date_concluded}', 5);

COMMIT;
