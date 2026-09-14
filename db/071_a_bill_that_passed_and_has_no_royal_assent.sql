-- db/071_a_bill_that_passed_and_has_no_royal_assent.sql
--
-- Session 5's fact sheet has a fourth table, "Bills awaiting Royal Assent",
-- with three bills in it: the European Charter of Local Self-Government
-- (Incorporation), the UNCRC (Incorporation), and the UK Withdrawal from the
-- European Union (Legal Continuity) Bills. Each carries a footnote saying the
-- Supreme Court has ruled on a reference under section 33 of the Scotland Act
-- 1998 that some of its provisions are outwith competence, and that the bill
-- cannot be submitted for Royal Assent in its unamended form.
--
-- Settled by the owner on 2026-09-14, in two decisions:
--   1. these three are recorded as blocked, not as pending, because the fact
--      sheet's own footnotes say they cannot be submitted for Royal Assent;
--   2. they are coded as Session 5's fact sheet leaves them. Two were later
--      reconsidered and enacted in Session 6 and one was withdrawn there, and
--      that is Session 6's fact sheet to say, not this one's.
--
-- Almost all of the thinking was already done and none of the plumbing. The
-- value 'blocked' and its definition, the cell for the date, and methodology
-- note M5 have all existed since the schema was built. What did not exist:
--   * the staging sheet had nowhere to put the date the bill was stopped, so
--     the date could not reach the clean sheet at all;
--   * promotion did not carry it;
--   * the error checker had no rule about a blocked bill, and -- the hole this
--     found -- no rule at all about a bill that passed and has no Royal Assent
--     date. Such a bill could have been admitted as 'not_enacted' with nothing
--     on the line saying why.
--
-- Nothing on the clean sheet changes. No bill on it is blocked or pending: all
-- 302 are enacted, withdrawn, rejected or fallen. This migration adds two cells
-- to the staging sheet and eight rules to the error checker, and touches no
-- data.
--
-- The reader (tools/extract_factsheet.py) and promotion (tools/promote_session.sql)
-- change with it, in the same commit.

\set ON_ERROR_STOP on
BEGIN;

-- ---------------------------------------------------------------------------
-- 1. Two cells on the staging sheet
--
--    date_assent_blocked already exists on the clean sheet and has never been
--    used. It could not be: nothing carried a value to it.
-- ---------------------------------------------------------------------------

ALTER TABLE bill_candidate ADD COLUMN date_assent_blocked date;
ALTER TABLE bill_candidate ADD COLUMN raw_footnote        text;

COMMENT ON COLUMN bill_candidate.date_assent_blocked IS
 'The date the bill was stopped from being sent for Royal Assent, read from the fact sheet''s footnote against the row. Carried to bill.date_assent_blocked at promotion. Empty means the footnote gives no date, which is the case for the UK Withdrawal from the European Union (Legal Continuity) Bill, or that nothing stopped the bill.';

COMMENT ON COLUMN bill_candidate.raw_footnote IS
 'The footnote the fact sheet prints against this row, word for word, with its number taken off. This is where a fact sheet says why a bill that passed has not received Royal Assent, and the row alone does not say it. Empty means the row carries no footnote.';

-- ---------------------------------------------------------------------------
-- 2. The error checker
--
--    Copied from db/062, which is where it currently stands, with eight rules
--    added and marked db/071. Everything else is as db/062 left it.
-- ---------------------------------------------------------------------------

CREATE OR REPLACE VIEW v_candidate_problems AS
WITH stage_rows AS (
    -- The title comes from the stage row itself, which db/035 fills in from the
    -- line and keeps in step with it. Taking it from the line as well would
    -- leave two columns of the same name.
    SELECT t.*,
           c.session_number, c.bill_type, c.outcome,
           c.date_introduced, c.date_royal_assent, c.date_concluded,
           coalesce(rs.label, t.stage,
                    'The stage at position ' || coalesce(t.stage_order::text, '?')) AS stage_label
      FROM stage_candidate t
      JOIN bill_candidate c USING (candidate_id)
      LEFT JOIN ref_stage rs ON rs.code = t.stage
     WHERE t.review_status <> 'rejected'
),
line_checks AS (
    SELECT c.candidate_id, c.session_number, c.short_title, c.review_status, p.problem,
           NULL::integer AS stage_candidate_id
    FROM bill_candidate c
    LEFT JOIN session s ON s.session_number = c.session_number
    LEFT JOIN LATERAL (
        SELECT max(r.date_completed) FILTER (WHERE r.stage_order = 3 AND r.completed) AS passed_on
          FROM stage_rows r WHERE r.candidate_id = c.candidate_id
    ) f ON true
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
        (CASE WHEN c.date_concluded IS NOT NULL AND c.date_introduced IS NOT NULL
               AND c.date_concluded < c.date_introduced
              THEN 'concluded before it was introduced' END),
        (CASE WHEN c.raw_date_introduced IS NOT NULL AND c.date_introduced IS NULL
              THEN 'date_introduced unparsed: '||quote_literal(c.raw_date_introduced) END),
        (CASE WHEN c.raw_date_royal_assent IS NOT NULL AND c.date_royal_assent IS NULL
              THEN 'royal assent unparsed: '||quote_literal(c.raw_date_royal_assent) END),
        (CASE WHEN c.raw_date_final IS NOT NULL
               AND f.passed_on IS NULL AND c.date_concluded IS NULL
              THEN 'final date unparsed: '||quote_literal(c.raw_date_final) END),
        (CASE WHEN c.enactment_status = 'enacted' AND c.date_royal_assent IS NULL
              THEN 'enacted but no Royal Assent date' END),
        (CASE WHEN c.outcome <> 'passed' AND c.enactment_status = 'enacted'
              THEN 'enacted but outcome is not passed' END),

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
        -- ---------------------------------- changed at db/033: reads the
        -- stage-dates sheet.
        (CASE WHEN c.outcome = 'passed' AND f.passed_on IS NULL
              THEN 'passed, but has no Stage 3 date' END),

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
        (CASE WHEN c.asp_number IS NOT NULL
               AND substring(c.asp_number from '^\d{4}') IS NULL
              THEN 'asp_number carries no year: the factsheet printed none, so it must be settled from legislation.gov.uk before this line is admitted' END),
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

        -- ---------------------------------- added at db/031: the route to a
        -- Stage 1 rejection, and the date the Official Report was read.
        (CASE WHEN c.stage_1_rejection_route IS NOT NULL
               AND NOT EXISTS (SELECT 1 FROM ref_stage_1_rejection_route r
                               WHERE r.code = c.stage_1_rejection_route)
              THEN 'stage_1_rejection_route '||quote_literal(c.stage_1_rejection_route)
                   ||' is not in ref_stage_1_rejection_route' END),
        (CASE WHEN c.outcome = 'rejected_stage_1' AND c.stage_1_rejection_route IS NULL
              THEN 'rejected at Stage 1, but no route to the rejection is recorded' END),
        (CASE WHEN c.stage_1_rejection_route IS NOT NULL
               AND c.outcome IS DISTINCT FROM 'rejected_stage_1'
              THEN 'a route to a Stage 1 rejection is recorded, but the outcome is not '
                   ||'rejected at Stage 1' END),
        (CASE WHEN c.stage_1_rejection_route = 'committee_motion_9_14_18'
               AND c.bill_type IS DISTINCT FROM 'members'
              THEN 'Rule 9.14.18 route recorded on a bill that is not a Member''s Bill' END),
        -- ---------------------------------- added at db/046: the open route
        -- is for a path nobody anticipated, so it is the one route that cannot
        -- stand on its code alone. The announcement is already required of
        -- every route below; this also requires the note that says what the
        -- effect on the bill was, because the code itself says nothing.
        (CASE WHEN c.stage_1_rejection_route = 'other_route'
               AND coalesce(btrim(c.bill_note), '') = ''
              THEN 'the route is recorded as some other route, but bill_note does '
                   ||'not say what happened or what its effect was' END),

        (CASE WHEN c.stage_1_rejection_route IS NOT NULL
               AND coalesce(c.review_note, '') !~ 'Result as recorded: "[^"]+"'
              THEN 'a route is recorded, but review_note does not quote the Presiding '
                   ||'Officer''s announcement after "Result as recorded:"' END),
        -- A Stage 1 date read from the Official Report now carries its own read
        -- date on the stage-dates sheet (db/033).
        (CASE WHEN (c.stage_1_rejection_route IS NOT NULL
                    OR c.review_note ILIKE 'Outcome from the Official Report%')
               AND c.official_report_read_on IS NULL
              THEN 'something on this line came from the Official Report, but '
                   ||'official_report_read_on is empty' END),

        -- ---------------------------------- added at db/058: and it must cite
        -- the page. db/055 recorded five outcomes and three routes out of the
        -- Official Report with the address on the stage-dates row only, and
        -- nothing on the line promotion reads. The rehearsal of Session 3's
        -- promotion refused the three routes, because a route has always had to
        -- carry its citation; the other two would have reached the clean sheet
        -- with the reference simply empty, and nothing would have said so. The
        -- checker now asks for the address on the line, which is where it has
        -- to be for the provenance note to get it.
        (CASE WHEN (c.stage_1_rejection_route IS NOT NULL
                    OR c.review_note ILIKE 'Outcome from the Official Report%')
               AND coalesce(c.review_note, '') !~ 'https?://'
              THEN 'something on this line came from the Official Report, but '
                   ||'review_note carries no address for the page it was read '
                   ||'on, so promotion has nothing to cite' END),

        -- ---------------------------------- added at db/042: a date that does
        -- not match the factsheet's own printed words has been checked against
        -- a more definitive source, and must say so. The citation is the same
        -- fixed form promotion reads to write the provenance note, so a date
        -- cannot be quietly overridden.
        (CASE WHEN c.date_royal_assent IS NOT NULL
               AND c.raw_date_royal_assent IS NOT NULL
               AND c.date_royal_assent
                   IS DISTINCT FROM factsheet_date(c.raw_date_royal_assent)
               AND coalesce(c.review_note, '')
                   !~ 'Checked: date_royal_assent = \d{4}-\d{2}-\d{2} \([^)]+\)'
              THEN 'date_royal_assent differs from the factsheet''s own words ('
                   ||c.raw_date_royal_assent||'), but review_note carries no '
                   ||'"Checked: date_royal_assent = ..." citation' END),
        (CASE WHEN c.date_introduced IS NOT NULL
               AND c.raw_date_introduced IS NOT NULL
               AND c.date_introduced
                   IS DISTINCT FROM factsheet_date(c.raw_date_introduced)
               AND coalesce(c.review_note, '')
                   !~ 'Checked: date_introduced = \d{4}-\d{2}-\d{2} \([^)]+\)'
              THEN 'date_introduced differs from the factsheet''s own words ('
                   ||c.raw_date_introduced||'), but review_note carries no '
                   ||'"Checked: date_introduced = ..." citation' END),

        -- ---------------------------------- added at db/044: a line cannot
        -- be admitted before its dates have been compared against every other
        -- source that states them. Sessions 1 and 2 found thirteen
        -- disagreements that way and the factsheet was wrong in five of them;
        -- the list was made by hand, and this is what makes it happen every
        -- time instead.
        (CASE WHEN c.review_status = 'accepted' AND c.sources_compared_at IS NULL
              THEN 'accepted, but its dates have never been compared against the '
                   ||'other sources: run tools/compare_sources.py' END),

        -- ---------------------------------- added at db/071: a bill that has
        -- been passed and has not become an Act. Session 5's fact sheet has a
        -- fourth table of them, headed 'Bills awaiting Royal Assent', and a
        -- footnote against each row saying the Supreme Court has ruled on a
        -- section 33 reference and the bill cannot be submitted for Royal
        -- Assent. 'Awaiting' is the heading; the footnote is the fact. So the
        -- heading alone proposes 'pending', and the footnote's own words are
        -- what turn it into 'blocked'. See methodology note M5.
        (CASE WHEN c.enactment_status = 'blocked'
               AND c.outcome IS DISTINCT FROM 'passed'
              THEN 'recorded as blocked, but the outcome is '
                   ||coalesce(quote_literal(c.outcome),'null')
                   ||' — only a bill that passed can be stopped before Royal Assent' END),
        (CASE WHEN c.enactment_status = 'blocked'
               AND coalesce(btrim(c.bill_note), '') = ''
              THEN 'recorded as blocked, but bill_note does not say what stopped '
                   ||'it, so a reader would be told the bill is blocked and not '
                   ||'why — see methodology note M5' END),
        (CASE WHEN c.enactment_status = 'blocked'
               AND coalesce(btrim(c.raw_footnote), '') = ''
               AND coalesce(c.review_note, '') !~ 'Checked: enactment_status = '
              THEN 'recorded as blocked, but the line carries neither the fact '
                   ||'sheet''s own words saying so nor a "Checked: '
                   ||'enactment_status = ..." citation' END),
        -- A blocked or pending bill has not ended. Nothing has concluded it and
        -- it has no Royal Assent; both cells stay empty until something happens
        -- to it, which may be in a later session's fact sheet.
        (CASE WHEN c.enactment_status IN ('blocked', 'pending')
               AND c.date_concluded IS NOT NULL
              THEN 'recorded as '||c.enactment_status||', so still a live bill, '
                   ||'but it has an ending date of '||c.date_concluded END),
        (CASE WHEN c.enactment_status IN ('blocked', 'pending')
               AND c.date_royal_assent IS NOT NULL
              THEN 'recorded as '||c.enactment_status||', but it has a Royal '
                   ||'Assent date of '||c.date_royal_assent END),
        (CASE WHEN c.date_assent_blocked IS NOT NULL
               AND c.date_introduced IS NOT NULL
               AND c.date_assent_blocked < c.date_introduced
              THEN 'stopped from going for Royal Assent on '||c.date_assent_blocked
                   ||', before the bill was introduced on '||c.date_introduced END),
        -- The hole this closes, and the reason it is worded about the Royal
        -- Assent date rather than about enactment: until now a bill could be
        -- coded as passed, given no Royal Assent date, left as 'not_enacted'
        -- with nothing on the line saying why, and the checker would have
        -- passed it.
        (CASE WHEN c.outcome = 'passed' AND c.date_royal_assent IS NULL
               AND c.enactment_status NOT IN ('blocked', 'pending')
              THEN 'passed, but has no Royal Assent date and is recorded as '
                   ||coalesce(quote_literal(c.enactment_status),'null')
                   ||' rather than as blocked or awaiting one' END),
        (CASE WHEN c.raw_section = 'awaiting_assent'
               AND (c.outcome IS DISTINCT FROM 'passed'
                    OR c.enactment_status NOT IN ('blocked', 'pending'))
              THEN 'read from the Bills awaiting Royal Assent table, but outcome is '
                   ||coalesce(quote_literal(c.outcome),'null')||' and it is recorded as '
                   ||coalesce(quote_literal(c.enactment_status),'null') END),
        (CASE WHEN c.raw_section = 'acts' AND c.outcome IS DISTINCT FROM 'passed'
              THEN 'read from the Acts table, but outcome is '
                   ||coalesce(quote_literal(c.outcome),'null') END),
        (CASE WHEN c.raw_section = 'withdrawn' AND c.outcome IS DISTINCT FROM 'withdrawn'
              THEN 'read from the Withdrawn table, but outcome is '
                   ||coalesce(quote_literal(c.outcome),'null') END),
        (CASE WHEN c.raw_section = 'fallen'
               AND c.outcome NOT IN ('fell_dissolution','fell_other','rejected_stage_1',
                                     'rejected_stage_3',
                                     'fell_financial_resolution_not_agreed')
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
        (CASE WHEN s.date_session_end IS NOT NULL AND c.date_introduced IS NOT NULL
               AND c.date_introduced > s.date_session_end
              THEN 'introduced after the session ended' END),
        (CASE WHEN s.date_session_end IS NOT NULL AND f.passed_on IS NOT NULL
               AND f.passed_on > s.date_session_end
              THEN 'passed after the session ended' END),
        (CASE WHEN s.date_session_end IS NOT NULL AND c.date_concluded IS NOT NULL
               AND c.date_concluded > s.date_session_end
              THEN 'concluded after the session ended' END),

        -- A bill said to have fallen at dissolution concluded on its session's
        -- last day. Added at db/049, once db/048 gave the database that date.
        --
        -- This is the converse of what the reader already does.
        -- tools/extract_factsheet.py is handed the session's last day and
        -- PROPOSES fell_dissolution for a bill in the Fallen table whose final
        -- date matches; everything else it leaves for review. That proposal is
        -- reviewed and may be overridden. Nothing until now checked the other
        -- way round, so a bill could be coded as having fallen at dissolution
        -- on a date that was not the end of its session and nothing would say
        -- so. Seven bills in Sessions 1 and 2 carry that coding.
        --
        -- It does not work the other way about on purpose. A fallen bill that
        -- concluded on the last day but is coded as something else is NOT
        -- flagged here: a Stage 1 rejection on the final sitting day is
        -- possible, and a check nobody can satisfy is worse than no check.
        -- That direction is the reader's proposal, which a person reviews.
        --
        -- Strengthened at db/051. The rule used to go quiet where a session had
        -- no last day recorded, which left a hole: Session 7 is still running,
        -- so a bill of its coded this way would have been checked against
        -- nothing and would then have reached promotion with no session date to
        -- cite in its provenance note. The coding now needs the date to exist.
        (CASE WHEN c.outcome = 'fell_dissolution' AND s.date_session_end IS NULL
              THEN 'coded as having fallen at dissolution, but no last day is'
                   || ' recorded for Session ' || coalesce(c.session_number::text, '?')
                   || ', so the coding cannot be checked and its provenance'
                   || ' cannot be written'
              WHEN c.outcome = 'fell_dissolution'
               AND c.date_concluded IS DISTINCT FROM s.date_session_end
              THEN 'coded as having fallen at dissolution, but concluded '
                   || coalesce(c.date_concluded::text, 'on no recorded date')
                   || ' and the session ended ' || s.date_session_end END)
    ) AS p(problem)
),
stage_checks AS (
    SELECT r.candidate_id, r.session_number, r.short_title, r.review_status,
           r.stage_label || ', from ' || coalesce(r.source, 'no stated source') || ': ' || p.problem
             AS problem,
           r.stage_candidate_id
    FROM stage_rows r
    CROSS JOIN LATERAL (VALUES
        -- What the row is.
        (CASE WHEN r.stage_order IS NULL OR r.stage_order NOT BETWEEN 1 AND 4
              THEN 'position '||coalesce(r.stage_order::text, 'empty')||' is not 1 to 4' END),
        (CASE WHEN r.stage IS NULL THEN 'no stage named'
              WHEN NOT EXISTS (SELECT 1 FROM ref_stage x WHERE x.code = r.stage)
              THEN 'stage '||quote_literal(r.stage)||' is not in ref_stage' END),
        (CASE WHEN r.stage IS NOT NULL AND r.stage_order IS NOT NULL AND r.bill_type IS NOT NULL
               AND NOT EXISTS (SELECT 1 FROM ref_bill_type_stage x
                                WHERE x.bill_type = r.bill_type AND x.stage = r.stage
                                  AND x.stage_order = r.stage_order)
              THEN 'not the right stage name for a '||r.bill_type||' bill at position '
                   ||r.stage_order||' — see ref_bill_type_stage' END),
        (CASE WHEN r.source IS NULL THEN 'no source'
              WHEN NOT EXISTS (SELECT 1 FROM ref_source x WHERE x.code = r.source)
              THEN 'source '||quote_literal(r.source)||' is not in ref_source' END),
        (CASE WHEN r.observed_at IS NULL THEN 'when the source was read is not recorded' END),
        (CASE WHEN r.completed IS NULL THEN 'completed is empty' END),
        (CASE WHEN r.fell_here IS NULL THEN 'fell_here is empty' END),

        -- ---------------------------------- added at db/039: a stage the bill
        -- never had, because its procedure skipped it.
        (CASE WHEN r.did_not_happen AND r.bill_type IS DISTINCT FROM 'private'
              THEN 'marked as a stage that did not happen, but only a Private Bill may skip '
                   ||'a stage — see methodology note M2' END),
        (CASE WHEN r.did_not_happen AND r.date_completed IS NOT NULL
              THEN 'marked as a stage that did not happen, but dated '||r.date_completed END),
        (CASE WHEN r.did_not_happen AND (r.completed OR r.fell_here)
              THEN 'marked as a stage that did not happen, and also as completed or as where '
                   ||'the bill ended' END),
        (CASE WHEN r.did_not_happen AND nullif(btrim(r.detail_note), '') IS NULL
              THEN 'marked as a stage that did not happen, but no note says why' END),

        -- Whether it holds together.
        (CASE WHEN r.completed AND r.fell_here
              THEN 'marked completed, and also as where the bill ended' END),
        (CASE WHEN r.completed AND r.date_completed IS NULL
               AND nullif(btrim(r.detail_note), '') IS NULL
              THEN 'completed on a date not known, but no note says why' END),
        (CASE WHEN r.completed IS FALSE AND r.fell_here IS FALSE AND r.date_completed IS NOT NULL
              THEN 'not completed and not where the bill ended, but dated' END),
        (CASE WHEN r.fell_here AND r.outcome = 'passed'
              THEN 'marked as where the bill ended, but the bill passed' END),
        (CASE WHEN r.fell_here AND r.outcome = 'rejected_stage_1' AND r.stage_order <> 1
              THEN 'marked as where the bill ended, but the bill was rejected at Stage 1' END),
        (CASE WHEN r.fell_here AND r.outcome = 'rejected_stage_3' AND r.stage_order <> 3
              THEN 'marked as where the bill ended, but the bill was rejected at Stage 3' END),
        (CASE WHEN r.completed AND r.stage_order = 3 AND r.outcome IS DISTINCT FROM 'passed'
              THEN 'final stage completed, but the outcome is not passed' END),

        -- Dates in order: introduction, each stage, Royal Assent; and nothing
        -- after the bill concluded.
        (CASE WHEN r.date_completed < r.date_introduced
              THEN 'dated '||r.date_completed||', before the bill was introduced on '
                   ||r.date_introduced END),
        (CASE WHEN r.completed AND r.date_completed > r.date_royal_assent
              THEN 'dated '||r.date_completed||', after Royal Assent on '||r.date_royal_assent END),
        (CASE WHEN r.date_completed > r.date_concluded
              THEN 'dated '||r.date_completed||', after the bill concluded on '||r.date_concluded END),
        (CASE WHEN r.fell_here AND r.outcome IN ('rejected_stage_1', 'rejected_stage_3')
               AND r.date_completed <> r.date_concluded
              THEN 'the decision that ended the bill is dated '||r.date_completed
                   ||', but the bill concluded on '||r.date_concluded END),
        ((SELECT 'dated '||r.date_completed||', before '||e.stage_label||' on '||e.date_completed
            FROM stage_rows e
           WHERE e.candidate_id = r.candidate_id AND e.stage_order < r.stage_order
             AND e.date_completed > r.date_completed
           ORDER BY e.stage_order LIMIT 1)),

        -- Nothing after the stage where the bill ended, or after one it did not
        -- get through. A stage that never happened is not one it failed to get
        -- through, so it is left out (db/039).
        ((SELECT 'recorded after '||e.stage_label||', where the bill ended'
            FROM stage_rows e
           WHERE e.candidate_id = r.candidate_id AND e.fell_here
             AND e.stage_order < r.stage_order
           ORDER BY e.stage_order LIMIT 1)),
        ((SELECT 'recorded, but '||e.stage_label||' before it was not completed'
            FROM stage_rows e
           WHERE e.candidate_id = r.candidate_id AND e.completed IS FALSE
             AND e.fell_here IS FALSE AND NOT e.did_not_happen
             AND e.stage_order < r.stage_order
           ORDER BY e.stage_order LIMIT 1)),

        -- Two sources for the same stage must agree.
        ((SELECT 'disagrees with '||coalesce(e.source, 'another row')||', which gives '
                 ||coalesce(e.date_completed::text, 'no date')
                 ||CASE WHEN e.completed THEN ', completed' ELSE ', not completed' END
                 ||CASE WHEN e.fell_here THEN ', where the bill ended' ELSE '' END
            FROM stage_rows e
           WHERE e.candidate_id = r.candidate_id AND e.stage_order = r.stage_order
             AND e.stage_candidate_id <> r.stage_candidate_id
             AND (e.date_completed IS DISTINCT FROM r.date_completed
                  OR e.completed IS DISTINCT FROM r.completed
                  OR e.fell_here IS DISTINCT FROM r.fell_here
                  OR e.stage IS DISTINCT FROM r.stage)
           ORDER BY e.stage_candidate_id LIMIT 1))
    ) AS p(problem)
),
difference_checks AS (
    -- ---------------------------------- added at db/044. A line records what
    -- another source gives for a date, as "Differs: <column> = <value>
    -- (<source>)", written by tools/compare_sources.py when the session is
    -- loaded. It stays a problem until the owner has adjudicated it and the
    -- line carries the matching "Checked: <column> = ..." citation. A line can
    -- carry more than one, so this is its own branch rather than another CASE.
    SELECT c.candidate_id, c.session_number, c.short_title, c.review_status,
           'another source gives a different ' || d.m[1]
             || ', and it has not been adjudicated: no "Checked: ' || d.m[1]
             || ' = ..." citation' AS problem,
           NULL::integer AS stage_candidate_id
      FROM bill_candidate c
      CROSS JOIN LATERAL regexp_matches(coalesce(c.review_note, ''),
            'Differs: ([a-z0-9_]+) = ', 'g') AS d(m)
     WHERE c.review_status <> 'rejected'
       AND coalesce(c.review_note, '') NOT LIKE '%Checked: ' || d.m[1] || ' = %'
)
SELECT * FROM line_checks WHERE problem IS NOT NULL
UNION ALL
SELECT * FROM stage_checks WHERE problem IS NOT NULL
UNION ALL
SELECT * FROM difference_checks;

COMMENT ON VIEW v_candidate_problems IS
 'The error checker: every problem the database can find on the staging sheets, one row per problem, for the owner to clear before a session is admitted. A line or stage row with nothing wrong does not appear. Empty means nothing found, not nothing checked.';
ALTER VIEW v_candidate_problems OWNER TO legdata;

-- ---------------------------------------------------------------------------
-- 3. What must be true afterwards
--
--    The rules are tested against rows made up inside this transaction and
--    thrown away with it, rather than described. A rule nobody has seen fire is
--    a rule nobody has tested: db/070's own check asserted a change of eight
--    characters where the change was two, and the rehearsal caught it.
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer; before_n integer; line integer;
BEGIN
  -- Nothing on the clean sheet is affected: no bill is blocked or pending.
  SELECT count(*) INTO n FROM bill WHERE enactment_status IN ('blocked','pending');
  IF n <> 0 THEN
    RAISE EXCEPTION 'Refusing: % bill(s) on the clean sheet are already blocked or pending. This migration assumes none are, and its account of what changes is then wrong.', n;
  END IF;

  SELECT count(*) INTO n FROM bill;
  IF n <> 302 THEN
    RAISE EXCEPTION 'Refusing: % bills on the clean sheet, expected 302.', n;
  END IF;

  -- The checker is clear before the new rules are tried, so anything it finds
  -- below is the made-up row and not something that was already there.
  SELECT count(*) INTO before_n FROM v_candidate_problems;
  IF before_n <> 0 THEN
    RAISE EXCEPTION 'Refusing: the error checker already finds % problem(s) before this migration adds any rules.', before_n;
  END IF;
END $$;

-- A line that is everything a blocked bill should be, and seven spoilings of
-- it. Each must produce the problem it is meant to and no other; the whole lot
-- is rolled back below.
SAVEPOINT rules_under_test;

INSERT INTO bill_candidate
  (session_number, raw_title, raw_type, raw_section, short_title, title_kind,
   bill_type, bill_type_stated, date_introduced, outcome, enactment_status,
   date_assent_blocked, raw_footnote, bill_note, source, source_ref,
   observed_at, sources_compared_at, review_status)
VALUES
  (5, 'A Test Bill', 'G', 'awaiting_assent', 'A Test Bill', 'bill',
   'government', 'government', DATE '2020-01-01', 'passed', 'blocked',
   DATE '2021-10-06', 'The Bill cannot be submitted for Royal Assent in its unamended form.',
   'Stopped by a ruling of the Supreme Court.', 'spice_factsheet_legislation', 'test',
   DATE '2026-09-14', DATE '2026-09-14', 'new');

-- It needs a Stage 3 date, or 'passed, but has no Stage 3 date' fires and the
-- clean row is not clean.
INSERT INTO stage_candidate
  (candidate_id, stage, stage_order, date_completed, completed, fell_here,
   did_not_happen, source, source_ref, observed_at, review_status)
SELECT c.candidate_id, 'stage_3', 3, DATE '2021-03-16', true, false, false,
       'spice_factsheet_legislation', 'test', DATE '2026-09-14', 'new'
  FROM bill_candidate c WHERE c.source_ref = 'test';

DO $$
DECLARE cid integer; got text; n integer;
BEGIN
  SELECT max(candidate_id) INTO cid FROM bill_candidate WHERE source_ref = 'test';

  SELECT count(*) INTO n FROM v_candidate_problems WHERE candidate_id = cid;
  IF n <> 0 THEN
    SELECT string_agg(problem, ' | ') INTO got FROM v_candidate_problems WHERE candidate_id = cid;
    RAISE EXCEPTION 'A properly recorded blocked bill should raise nothing, and raised %: %', n, got;
  END IF;
  RAISE NOTICE 'A properly recorded blocked bill raises nothing. Good.';

  -- 1. blocked, but the outcome is not passed.
  UPDATE bill_candidate SET outcome = 'withdrawn', date_concluded = DATE '2021-05-01' WHERE candidate_id = cid;
  IF NOT EXISTS (SELECT 1 FROM v_candidate_problems WHERE candidate_id = cid
                   AND problem LIKE 'recorded as blocked, but the outcome is%') THEN
    RAISE EXCEPTION 'Rule 1 did not fire: blocked with an outcome that is not passed.';
  END IF;
  UPDATE bill_candidate SET outcome = 'passed', date_concluded = NULL WHERE candidate_id = cid;

  -- 2. blocked, with nothing telling a reader why.
  UPDATE bill_candidate SET bill_note = NULL WHERE candidate_id = cid;
  IF NOT EXISTS (SELECT 1 FROM v_candidate_problems WHERE candidate_id = cid
                   AND problem LIKE 'recorded as blocked, but bill_note does not say%') THEN
    RAISE EXCEPTION 'Rule 2 did not fire: blocked with no note saying what stopped it.';
  END IF;
  UPDATE bill_candidate SET bill_note = 'Stopped by a ruling of the Supreme Court.' WHERE candidate_id = cid;

  -- 3. blocked, with none of the fact sheet's words behind it.
  UPDATE bill_candidate SET raw_footnote = NULL WHERE candidate_id = cid;
  IF NOT EXISTS (SELECT 1 FROM v_candidate_problems WHERE candidate_id = cid
                   AND problem LIKE 'recorded as blocked, but the line carries neither%') THEN
    RAISE EXCEPTION 'Rule 3 did not fire: blocked with no source words and no citation.';
  END IF;
  -- and the citation is the way out of it, for a block a fact sheet does not
  -- print a footnote for.
  UPDATE bill_candidate SET review_note = 'Checked: enactment_status = blocked (the Parliament''s own bill page, https://example.invalid, 2026-09-14)' WHERE candidate_id = cid;
  IF EXISTS (SELECT 1 FROM v_candidate_problems WHERE candidate_id = cid
               AND problem LIKE 'recorded as blocked, but the line carries neither%') THEN
    RAISE EXCEPTION 'Rule 3 still fires when the line carries a "Checked: enactment_status = ..." citation.';
  END IF;
  UPDATE bill_candidate SET review_note = NULL,
         raw_footnote = 'The Bill cannot be submitted for Royal Assent in its unamended form.'
   WHERE candidate_id = cid;

  -- 4. a live bill with an ending date.
  UPDATE bill_candidate SET date_concluded = DATE '2021-05-01' WHERE candidate_id = cid;
  IF NOT EXISTS (SELECT 1 FROM v_candidate_problems WHERE candidate_id = cid
                   AND problem LIKE '%so still a live bill, but it has an ending date%') THEN
    RAISE EXCEPTION 'Rule 4 did not fire: a blocked bill with an ending date.';
  END IF;
  UPDATE bill_candidate SET date_concluded = NULL WHERE candidate_id = cid;

  -- 5. a live bill with a Royal Assent date.
  UPDATE bill_candidate SET date_royal_assent = DATE '2022-01-16' WHERE candidate_id = cid;
  IF NOT EXISTS (SELECT 1 FROM v_candidate_problems WHERE candidate_id = cid
                   AND problem LIKE '%but it has a Royal Assent date%') THEN
    RAISE EXCEPTION 'Rule 5 did not fire: a blocked bill with a Royal Assent date.';
  END IF;
  UPDATE bill_candidate SET date_royal_assent = NULL WHERE candidate_id = cid;

  -- 6. stopped before it was introduced.
  UPDATE bill_candidate SET date_assent_blocked = DATE '2019-01-01' WHERE candidate_id = cid;
  IF NOT EXISTS (SELECT 1 FROM v_candidate_problems WHERE candidate_id = cid
                   AND problem LIKE 'stopped from going for Royal Assent on%before the bill was introduced%') THEN
    RAISE EXCEPTION 'Rule 6 did not fire: stopped before the bill was introduced.';
  END IF;
  UPDATE bill_candidate SET date_assent_blocked = DATE '2021-10-06' WHERE candidate_id = cid;

  -- 7. THE HOLE. Passed, no Royal Assent date, and quietly not enacted.
  UPDATE bill_candidate SET enactment_status = 'not_enacted', raw_section = 'acts',
         title_kind = 'bill' WHERE candidate_id = cid;
  IF NOT EXISTS (SELECT 1 FROM v_candidate_problems WHERE candidate_id = cid
                   AND problem LIKE 'passed, but has no Royal Assent date and is recorded as%') THEN
    RAISE EXCEPTION 'Rule 7 did not fire: passed, no Royal Assent date, not recorded as blocked or pending. This is the rule the migration exists to add.';
  END IF;

  -- 8. the table it was read from and what it says must agree.
  UPDATE bill_candidate SET raw_section = 'awaiting_assent' WHERE candidate_id = cid;
  IF NOT EXISTS (SELECT 1 FROM v_candidate_problems WHERE candidate_id = cid
                   AND problem LIKE 'read from the Bills awaiting Royal Assent table, but%') THEN
    RAISE EXCEPTION 'Rule 8 did not fire: read from the awaiting table but recorded as something else.';
  END IF;

  RAISE NOTICE 'All eight rules fired on the row made to break them, and the clean row raised nothing.';
END $$;

ROLLBACK TO SAVEPOINT rules_under_test;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM bill_candidate WHERE source_ref = 'test';
  IF n <> 0 THEN RAISE EXCEPTION 'The made-up line survived the rollback: % row(s).', n; END IF;

  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n <> 0 THEN
    RAISE EXCEPTION 'The error checker finds % problem(s) across all sessions after this. It found none before.', n;
  END IF;

  SELECT count(*) INTO n FROM bill;
  IF n <> 302 THEN RAISE EXCEPTION '% bills on the clean sheet, expected 302.', n; END IF;

  RAISE NOTICE 'Staging sheet has two new cells; error checker has eight new rules and finds nothing; 302 bills untouched.';
END $$;

COMMIT;
