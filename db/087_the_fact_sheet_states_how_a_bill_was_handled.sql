-- db/087_the_fact_sheet_states_how_a_bill_was_handled.sql
--
-- Procedure becomes a variable, and a bill records the day the Parliament
-- agreed to handle it that way.
--
-- Agreed with the owner on 2026-09-14, in full and before anything was
-- written, as a change to how data is coded must be. Found by reading the
-- Session 6 fact sheet for the prose reader: it prints a sentence no earlier
-- fact sheet has ever printed.
--
--     Motion agreed to treat as Emergency Bill on 22 June 2021.
--
-- Five bills carry it: Coronavirus (Extension and Expiry), 22 June 2021; Cost
-- of Living (Tenant Protection), 4 October 2022; Post Office (Horizon System)
-- Offences, 15 May 2024; Prisoners (Early Release), 20 November 2024; and
-- Non-Domestic Rates for Unoccupied Properties, 25 November 2025.
--
-- WHY IT IS TAKEN. bill.procedure has existed since db/010 and has never held
-- a value, because no source consulted stated one and a default of 'standard'
-- would have recorded budget and emergency bills as standard procedure on no
-- evidence. Session 6 states one. An emergency bill passes in days rather than
-- months -- Prisoners (Early Release) was introduced on 18 November 2024 and
-- passed on 26 November -- so a chart of how long a bill took cannot be read
-- without knowing which bills those are. The owner: "we should capture the
-- procedure and date".
--
-- WHAT IT RECORDS, AND WHAT EMPTY MEANS. procedure keeps the six values it has
-- always had. Session 6 gives evidence for one of them. The new cell holds the
-- date the Parliament agreed to handle the bill under that procedure, and is
-- empty where the procedure needed no such decision -- a Budget Bill is one by
-- its nature, and there is no motion -- or where we have not been told. An
-- empty procedure means WE HAVE NOT BEEN TOLD. It has never meant standard and
-- it does not mean it now, and after this change five bills out of an eventual
-- 471 carry a value. That is what M10 exists to say.
--
-- NO CELL FOR THE SENTENCE ITSELF. The Royal Assent block footnotes are kept
-- word for word in raw_footnote because they carry reasoning the coded cells
-- throw away. This sentence carries nothing the two cells do not: "emergency"
-- and the date rebuild it exactly. The reader writes it into parser_note, so
-- the fact sheet's own words are on the staging line and the line is kept for
-- ever, and provenance records the value as read -- which is what value_seen
-- holds for bill_type, asp_number and date_introduced already. Agreed with the
-- owner, who was shown the alternative.
--
-- BACKFILLING IS EXPECTED AND IS NOT OPENED HERE. Sessions 1 to 5 certainly
-- had emergency bills, and their fact sheets do not state procedure at all, so
-- filling them in means a source we have not agreed -- the Official Report, or
-- the Parliament's own bill pages. The owner expects to do it "in due course".
-- M10 says the coverage is partial and why, so that nothing built on the cell
-- in the meantime reads as complete.
--
-- WHAT THE CHECKS ASK. A date with no procedure is a contradiction and stops a
-- session; so is a date before the bill was introduced, or after it passed or
-- concluded. An emergency bill with no date is a GAP, not a contradiction: it
-- goes on the gaps list, which does not stop promotion, because a later source
-- may well state the procedure without giving the motion's date. That was the
-- owner's instruction: "flagged for you to look at rather than refused".
--
-- AND ONE SILENT LOSS CLOSED. A further appearance of a bill carries seven
-- cells onto the bill it continues, and procedure is not among them. No fact
-- sheet states the procedure of a carried-over row, so nothing is missing --
-- but a line that did state one would have had it dropped without a word. The
-- checker now refuses that line instead.
--
-- Nothing on the clean sheet moves. No bill has a procedure today and none
-- gains one here; what changes is what the sheets can hold and what the checks
-- ask. The reader for Sessions 6 and 7 is built next, on top of this.
--
-- Not marked here. A session may not mark the check on a rule it added itself
-- (DECISIONS.md, 2026-09-14), and this session added all of them. They are
-- written up as items in docs/CLOSURE-TESTS.md for a session that did not
-- write them.

\set ON_ERROR_STOP on
BEGIN;

-- ---------------------------------------------------------------------------
-- The cells
-- ---------------------------------------------------------------------------

ALTER TABLE bill           ADD COLUMN date_procedure_agreed date;
ALTER TABLE bill_candidate ADD COLUMN date_procedure_agreed date;

COMMENT ON COLUMN bill.date_procedure_agreed IS
 'The date the Parliament agreed to handle the bill under the procedure in the procedure column — for an emergency bill, the day the motion to treat it as one was agreed to. Empty means either that the procedure needed no such decision, as a Budget Bill does not, or that we have not been told. Never a guess: it is filled only where a source states it.';

COMMENT ON COLUMN bill_candidate.date_procedure_agreed IS
 'The date the fact sheet says the Parliament agreed to handle the bill under the procedure this line proposes — for an emergency bill, the day the motion to treat it as one was agreed to. Empty means either that the procedure needed no such decision, or that the fact sheet does not say. Carried to bill.date_procedure_agreed at promotion.';

-- Both descriptions said no source states procedure. Session 6 does.
COMMENT ON COLUMN bill.procedure IS
 'How the bill was handled under the Parliament''s rules: standard, emergency, budget and so on. Allowed values are in ref_procedure. Empty means NOT KNOWN, and never standard — filling it in with "standard" as a guess would record budget and emergency bills as standard procedure on no evidence (db/010). Only the Session 6 and 7 fact sheets state procedure, and only for emergency bills, so the cell is filled for a handful of bills and empty for the rest; Sessions 1 to 5 are expected to be filled in from another source in due course. Methodology note M10 tells a reader this, and any chart drawn on this column must carry it.';

COMMENT ON COLUMN bill_candidate.procedure IS
 'How the fact sheet says the bill was handled under the Parliament''s rules — standard, emergency, budget and so on. Should be a code from ref_procedure. Empty means the fact sheet does not say, which is the usual case: only Sessions 6 and 7 state procedure, in the sentence "Motion agreed to treat as Emergency Bill on <date>", and only for emergency bills. Never defaulted to "standard" (db/010).';

-- ---------------------------------------------------------------------------
-- The error checker
-- ---------------------------------------------------------------------------
--
-- Written out in full from db/082, which is where its text last lived, with
-- one new block added to line_checks and nothing else touched. The rebuilt
-- text is diffed against the running view before this is applied: db/062 and
-- db/086 both had to say that a view rebuilt from an older migration quietly
-- carries that migration's stale names with it.

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
    LEFT JOIN bill cb ON cb.bill_id = c.continues_bill_id
    LEFT JOIN session s
           ON s.session_number = coalesce(cb.session_number, c.session_number)
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

        -- ---------------------------------- added at db/078. The rule above
        -- is about an Act's number; this one is about its title, which is the
        -- half a reader sees. db/062 added the number check because two fact
        -- sheet rows print the year in neither cell, and it said nothing about
        -- the title. Session 5's Period Products Act then reached the clean
        -- sheet with its number settled as '2021 asp 1' and its title still
        -- ending in 'Act', where Session 4's Higher Education Governance Act
        -- had both cells settled. Found while Session 5's closure test was
        -- being written, 2026-09-14.
        --
        -- Worded about enactment, not about the number: a bill that has not
        -- become an Act carries a bill's title and must not carry a year. The
        -- three bills stopped before Royal Assent are recorded as blocked and
        -- their titles rightly end in 'Bill'. See methodology note M3.
        (CASE WHEN c.enactment_status = 'enacted' AND c.short_title !~ '\d{4}$'
              THEN 'enacted, but short_title carries no year: an Act''s title ends in its year, and the fact sheet printed this one short, so it must be settled from legislation.gov.uk before this line is admitted' END),
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
        -- These ask about the session the BILL belongs to, not the session of
        -- the fact sheet the line was read off. For an ordinary line the two
        -- are the same thing. For a line continuing a bill already on the clean
        -- sheet they are not, and until db/082 the fact sheet's session was
        -- used for both -- which STATE.md carried as a known limitation, since
        -- the four bills that appear in two fact sheets would have been flagged
        -- although they are correct. A false alarm rather than a false pass,
        -- and now neither.
        (CASE WHEN s.date_first_meeting IS NOT NULL AND c.date_introduced IS NOT NULL
               AND c.date_introduced < s.date_first_meeting
              THEN 'introduced before the session began'
                   || CASE WHEN c.continues_bill_id IS NULL
                           THEN ' — if this line is a bill already on the clean'
                                || ' sheet, continues_bill_id must say which'
                           ELSE '' END END),
        (CASE WHEN s.date_session_end IS NOT NULL AND c.date_introduced IS NOT NULL
               AND c.date_introduced > s.date_session_end
              THEN 'introduced after the session ended' END),
        -- The two below are asked only of a line that is a bill in its own
        -- right. A line continuing an earlier bill exists BECAUSE that bill's
        -- business ran past the end of its own session, so asking these of it
        -- would refuse exactly the rows they were written to let through. What
        -- keeps such a line honest is that its dates must sit inside the bill's
        -- own life, which the stage checks below ask of every row: nothing
        -- before the introduction, nothing after Royal Assent.
        (CASE WHEN c.continues_bill_id IS NULL
               AND s.date_session_end IS NOT NULL AND f.passed_on IS NOT NULL
               AND f.passed_on > s.date_session_end
              THEN 'passed after the session ended' END),
        (CASE WHEN c.continues_bill_id IS NULL
               AND s.date_session_end IS NOT NULL AND c.date_concluded IS NOT NULL
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
                   || ' and the session ended ' || s.date_session_end END),

        -- ------------------------------------------------------------------
        -- A line that is a further appearance of a bill already on the clean
        -- sheet. See db/081 and methodology note M6.
        -- ------------------------------------------------------------------

        -- The tie between the two rows is the introduction date, and it is the
        -- one fact no fact sheet ever changes: a bill counted in two sessions
        -- keeps its introduction date, and a reintroduced bill has a new one
        -- (DECISIONS.md, 2026-09-10). Titles change; this does not.
        (CASE WHEN c.continues_bill_id IS NOT NULL AND cb.bill_id IS NULL
              THEN 'says it continues bill ' || c.continues_bill_id
                   || ', which is not on the clean sheet' END),
        (CASE WHEN c.continues_bill_id IS NOT NULL AND cb.bill_id IS NOT NULL
               AND c.date_introduced IS DISTINCT FROM cb.date_introduced
              THEN 'says it continues bill ' || c.continues_bill_id
                   || ', which was introduced '
                   || coalesce(cb.date_introduced::text, 'on no recorded date')
                   || ', but this line says '
                   || coalesce(c.date_introduced::text, 'no date') END),
        (CASE WHEN c.continues_bill_id IS NOT NULL AND cb.bill_id IS NOT NULL
               AND cb.session_number >= c.session_number
              THEN 'says it continues bill ' || c.continues_bill_id
                   || ', which belongs to Session ' || cb.session_number
                   || '. Only a later session can continue a bill' END),

        -- ------------------------------------------------------------------
        -- A bill stopped before Royal Assent after it had passed. See db/080
        -- and methodology note M5.
        -- ------------------------------------------------------------------

        -- The two cells are filled together or empty together.
        -- assent_block_outcome is the lasting record that the bill was
        -- stopped, and a bill that was stopped was stopped somehow.
        (CASE WHEN (c.assent_block_route IS NULL) <> (c.assent_block_outcome IS NULL)
              THEN 'assent_block_route and assent_block_outcome must be filled'
                   || ' together or left empty together' END),
        (CASE WHEN c.assent_block_route IS NOT NULL
               AND NOT EXISTS (SELECT 1 FROM ref_assent_block_route x
                                WHERE x.code = c.assent_block_route)
              THEN 'assent_block_route '||quote_literal(c.assent_block_route)
                   ||' is not in ref_assent_block_route' END),
        (CASE WHEN c.assent_block_outcome IS NOT NULL
               AND NOT EXISTS (SELECT 1 FROM ref_assent_block_outcome x
                                WHERE x.code = c.assent_block_outcome)
              THEN 'assent_block_outcome '||quote_literal(c.assent_block_outcome)
                   ||' is not in ref_assent_block_outcome' END),
        (CASE WHEN c.assent_block_outcome IS NOT NULL
               AND c.outcome IS DISTINCT FROM 'passed'
              THEN 'stopped before Royal Assent, but its outcome is '
                   || coalesce(c.outcome, 'empty')
                   || '. Only a bill that passed can be stopped before assent' END),
        (CASE WHEN c.enactment_status = 'blocked' AND c.assent_block_outcome IS NULL
              THEN 'recorded as blocked, but nothing says how it was stopped or'
                   || ' what followed' END),
        (CASE WHEN c.enactment_status = 'blocked'
               AND c.assent_block_outcome IS NOT NULL
               AND c.assent_block_outcome <> 'still_blocked'
              THEN 'recorded as blocked, but says what followed was '
                   || quote_literal(c.assent_block_outcome) END),
        (CASE WHEN c.assent_block_outcome = 'still_blocked'
               AND c.enactment_status IS DISTINCT FROM 'blocked'
              THEN 'says it is still blocked, but its enactment status reads '
                   || coalesce(quote_literal(c.enactment_status), 'empty') END),
        (CASE WHEN c.assent_block_outcome = 'reconsidered_passed'
               AND c.enactment_status IS DISTINCT FROM 'enacted'
              THEN 'reconsidered and passed, but not recorded as enacted' END),
        (CASE WHEN c.assent_block_outcome = 'withdrawn' AND c.date_concluded IS NULL
              THEN 'withdrawn after being blocked, but no date says when' END),

        -- A reconsideration is a stage, and its date lives on the stage row.
        -- The cell and the row have to say the same thing. The row may be on
        -- this line or already on the bill this line continues.
        (CASE WHEN c.assent_block_outcome IN ('reconsidered_passed','reconsidered_fell')
               AND NOT EXISTS (SELECT 1 FROM stage_candidate t
                                WHERE t.candidate_id = c.candidate_id
                                  AND t.stage = 'reconsideration'
                                  AND t.review_status <> 'rejected')
               AND NOT EXISTS (SELECT 1 FROM stage_event e
                                WHERE e.bill_id = c.continues_bill_id
                                  AND e.stage = 'reconsideration')
              THEN 'says it was reconsidered, but has no Reconsideration Stage'
                   || ' row' END),
        (CASE WHEN EXISTS (SELECT 1 FROM stage_candidate t
                            WHERE t.candidate_id = c.candidate_id
                              AND t.stage = 'reconsideration'
                              AND t.review_status <> 'rejected')
               AND coalesce(c.assent_block_outcome, '')
                   NOT IN ('reconsidered_passed','reconsidered_fell')
              THEN 'has a Reconsideration Stage row, but does not say it was'
                   || ' reconsidered after being stopped before Royal Assent' END),

        -- ------------------------------------------------------------------
        -- A bill that carried an earlier bill's scrutiny. See db/081 and
        -- methodology note M9.
        -- ------------------------------------------------------------------

        -- Empty stage rows have to be explained by something a chart can read.
        -- Without this the Robin Rigg Act's 42 days would sit in a chart of how
        -- long bills take with nothing beside it.
        (CASE WHEN c.reintroduced_from_bill_id IS NULL
               AND EXISTS (SELECT 1 FROM stage_candidate t
                            WHERE t.candidate_id = c.candidate_id
                              AND t.did_not_happen
                              AND t.review_status <> 'rejected')
              THEN 'has a stage recorded as never having happened, but does not'
                   || ' say which earlier bill''s scrutiny it carried' END),
        (CASE WHEN c.reintroduced_from_bill_id IS NOT NULL
               AND NOT EXISTS (SELECT 1 FROM bill b2
                                WHERE b2.bill_id = c.reintroduced_from_bill_id)
              THEN 'says it carried the scrutiny of bill '
                   || c.reintroduced_from_bill_id
                   || ', which is not on the clean sheet' END),
        (CASE WHEN c.reintroduced_from_bill_id IS NOT NULL
               AND EXISTS (SELECT 1 FROM bill b2
                            WHERE b2.bill_id = c.reintroduced_from_bill_id
                              AND b2.date_introduced >= c.date_introduced)
              THEN 'says it carried the scrutiny of bill '
                   || c.reintroduced_from_bill_id
                   || ', which was not introduced before it' END),
        (CASE WHEN c.reintroduced_from_bill_id IS NOT NULL
               AND c.continues_bill_id IS NOT NULL
              THEN 'says both that it continues an earlier bill and that it'
                   || ' carried an earlier bill''s scrutiny. A bill either did'
                   || ' not end, in which case it is one bill, or it ended and'
                   || ' another was introduced' END),

        -- ------------------------------------------------------------------
        -- How the bill was handled under the Parliament's rules. See db/087
        -- and methodology note M10. The value itself is checked against
        -- ref_procedure further up, with the other dropdown lists.
        -- ------------------------------------------------------------------

        -- A date saying when a procedure was agreed, with no procedure to
        -- agree, records an event with nothing to attach it to.
        (CASE WHEN c.date_procedure_agreed IS NOT NULL AND c.procedure IS NULL
              THEN 'says a procedure was agreed on '
                   || c.date_procedure_agreed
                   || ', but does not say which procedure' END),
        (CASE WHEN c.date_procedure_agreed IS NOT NULL
               AND c.date_introduced IS NOT NULL
               AND c.date_procedure_agreed < c.date_introduced
              THEN 'procedure agreed on ' || c.date_procedure_agreed
                   || ', before the bill was introduced on '
                   || c.date_introduced END),
        (CASE WHEN c.date_procedure_agreed IS NOT NULL
               AND f.passed_on IS NOT NULL
               AND c.date_procedure_agreed > f.passed_on
              THEN 'procedure agreed on ' || c.date_procedure_agreed
                   || ', after the bill had passed on ' || f.passed_on END),
        (CASE WHEN c.date_procedure_agreed IS NOT NULL
               AND c.date_concluded IS NOT NULL
               AND c.date_procedure_agreed > c.date_concluded
              THEN 'procedure agreed on ' || c.date_procedure_agreed
                   || ', after the bill had concluded on '
                   || c.date_concluded END),

        -- Promotion carries seven cells from a further appearance onto the
        -- bill it continues, and procedure is not one of them, because no fact
        -- sheet states the procedure of a carried-over row. A line that did
        -- would have the value dropped in silence. Refuse it instead, so that
        -- whoever meets the first one decides what should happen to it.
        (CASE WHEN c.continues_bill_id IS NOT NULL
               AND (c.procedure IS NOT NULL OR c.date_procedure_agreed IS NOT NULL)
              THEN 'continues bill ' || c.continues_bill_id
                   || ' and states how the bill was handled. A further'
                   || ' appearance does not carry the procedure onto the bill,'
                   || ' so this would be lost. See db/087' END)
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
-- The gaps list
-- ---------------------------------------------------------------------------
--
-- Written out in full from db/086, its last text, with one branch added and
-- the line CTE given the two cells it needs. Diffed against the running view
-- before this is applied, for the same reason the error checker is.

CREATE OR REPLACE VIEW v_stage_date_gaps AS
WITH lines AS (
    SELECT c.candidate_id, c.session_number, c.short_title, c.bill_type, c.outcome,
           c.continues_bill_id, c.procedure, c.date_procedure_agreed
      FROM bill_candidate c
     WHERE c.review_status <> 'rejected'
),
stage_rows AS (
    -- detail_note is aliased to note because two checks below still call it
    -- that. db/061 renamed the column and the view's own alias was left
    -- pointing at the old name; db/062 hit the same trap in the error checker
    -- and said so out loud. Nothing outside the view reads this alias.
    SELECT t.*, t.detail_note AS note
      FROM stage_candidate t WHERE t.review_status <> 'rejected'
),
ended AS (
    SELECT candidate_id, min(stage_order) AS ended_at
      FROM stage_rows WHERE fell_here GROUP BY candidate_id
),
furthest AS (
    SELECT candidate_id, max(stage_order) AS furthest
      FROM stage_rows GROUP BY candidate_id
),
expected AS (
    -- A bill that passed: each of its three stages.
    SELECT l.*, g.pos
      FROM lines l CROSS JOIN generate_series(1, 3) AS g(pos)
     WHERE l.outcome = 'passed'
    UNION ALL
    -- A bill that ended early: each stage before the one it ended at.
    SELECT l.*, g.pos
      FROM lines l JOIN ended e USING (candidate_id)
     CROSS JOIN LATERAL generate_series(1, e.ended_at - 1) AS g(pos)
     WHERE l.outcome IS DISTINCT FROM 'passed'
    UNION ALL
    -- A bill still in progress: each stage before the furthest recorded.
    SELECT l.*, g.pos
      FROM lines l JOIN furthest f USING (candidate_id)
     CROSS JOIN LATERAL generate_series(1, least(f.furthest, 4) - 1) AS g(pos)
     WHERE l.outcome = 'in_progress'
       AND NOT EXISTS (SELECT 1 FROM ended e WHERE e.candidate_id = l.candidate_id)
)
SELECT x.candidate_id, x.session_number, x.short_title, x.bill_type, x.outcome,
       x.pos AS stage_order, s.stage,
       CASE WHEN d.rows_completed = 0 THEN 'date not yet entered'
            ELSE 'completed, date not known: '||coalesce(d.notes, '(no note)') END AS gap
  FROM expected x
  LEFT JOIN ref_bill_type_stage s ON s.bill_type = x.bill_type AND s.stage_order = x.pos
  CROSS JOIN LATERAL (
      SELECT count(*) AS rows_completed,
             bool_or(t.date_completed IS NOT NULL) AS dated,
             string_agg(t.note, '; ') AS notes
        FROM stage_rows t
       WHERE t.candidate_id = x.candidate_id AND t.stage_order = x.pos AND t.completed
  ) d
 WHERE NOT coalesce(d.dated, false)
   -- Added at db/039: a stage the bill never had is not a date to find.
   AND NOT EXISTS (SELECT 1 FROM stage_rows t
                    WHERE t.candidate_id = x.candidate_id AND t.stage_order = x.pos
                      AND t.did_not_happen)
   -- Added at db/086: a bill that appears in two fact sheets has two lines and
   -- is one bill (M6). A stage the bill completed before this second appearance
   -- is on the bill already; it is not on this line, and it is not a date to
   -- find. A stage the bill never had counts the same way here as it does above.
   AND NOT EXISTS (SELECT 1 FROM stage_event e
                    WHERE e.bill_id = x.continues_bill_id
                      AND e.stage_order = x.pos
                      AND (e.date_completed IS NOT NULL OR e.did_not_happen))
UNION ALL
-- A bill that did not pass, with nothing recording where it ended.
SELECT l.candidate_id, l.session_number, l.short_title, l.bill_type, l.outcome,
       NULL, NULL, 'where the bill ended is not recorded'
  FROM lines l
   -- Added at db/056: a bill that fell because its financial resolution was
   -- not agreed did not stop at a stage. It completed the stage it reached --
   -- the Parliament agreed its general principles -- and then fell between
   -- that stage and the next, on a vote that is not part of any stage. Asking
   -- where it ended would be asking for a stage that does not exist, and the
   -- answer would be a wrong one. Its ending is on the bill, in outcome.
 WHERE l.outcome IS NOT NULL
   AND l.outcome NOT IN ('passed', 'in_progress',
                         'fell_financial_resolution_not_agreed')
   AND NOT EXISTS (SELECT 1 FROM ended e WHERE e.candidate_id = l.candidate_id)
UNION ALL
-- Added at db/087. A bill recorded as handled under a procedure the Parliament
-- had to agree to should say when it agreed. This is a gap and not a
-- contradiction: a source may well state the procedure and not the day the
-- motion was moved, and the owner asked for it to be flagged rather than
-- refused. Only emergency is asked for. A Budget Bill is a Budget Bill by its
-- nature and there is no motion to date, and the three consolidation and
-- statute law procedures have no such moment either.
SELECT l.candidate_id, l.session_number, l.short_title, l.bill_type, l.outcome,
       NULL, NULL, 'recorded as an emergency bill, and nothing says when the '
                   'Parliament agreed to treat it as one'
  FROM lines l
 WHERE l.procedure = 'emergency'
   AND l.date_procedure_agreed IS NULL
ORDER BY 2, 1, 6;


COMMENT ON VIEW v_stage_date_gaps IS
 'The gaps to fill in, read from the staging sheets: one row per missing date. Mostly stage dates, which is what it was built for. A bill that passed should have a date for each of its three stages, and a bill that ended early a date for each stage before the one it ended at. A stage completed on a date not known is listed with its note, and a bill that did not pass is listed if nothing records where it ended -- except one that fell because its financial resolution was not agreed, which did not stop at a stage (db/056). A stage a bill never had, because its procedure skipped it, is not listed at all (db/039), and neither is a stage that the bill this line continues has already (db/086) -- a bill in two fact sheets is one bill, and its earlier stages are on the bill, not on the second line. An emergency bill with nothing saying when the Parliament agreed to treat it as one is listed too (db/087), and is the only entry here that is not about a stage. A gap does not stop promotion (DECISIONS.md, 2026-09-11); a contradiction does, and is in v_candidate_problems instead. Lines and rows rejected at review are left out.';

ALTER VIEW v_stage_date_gaps OWNER TO legdata;


-- ---------------------------------------------------------------------------
-- What a reader is told
-- ---------------------------------------------------------------------------
--
-- M10 has one job: to stop a reader treating the procedure column as a survey
-- of how bills were handled. It is not one. It is five bills out of an
-- eventual 471, all of them Session 6, because the Session 6 and 7 fact sheets
-- are the only sources so far that state procedure at all.

INSERT INTO methodology_note (code, title, body, applies_to, sort_order) VALUES
 ('M10',
  'How a bill was handled is recorded only where a source says so',
  'The Parliament handles some bills differently from most: an emergency bill takes its three stages in days rather than months, a Budget Bill runs to a timetable of its own, and consolidation bills have their own procedure. This resource records that where a source states it, and leaves it empty everywhere else.'
    || E'\n\n' ||
    'An empty cell therefore means we have not been told. It does not mean the bill went through the standard procedure. Filling the column in with "standard" wherever nothing else was stated would have recorded every budget and emergency bill as a standard one, on no evidence, and that has been refused since the column was made.'
    || E'\n\n' ||
    'What is stated, and by whom: the Session 6 and Session 7 fact sheets print a sentence of the form "Motion agreed to treat as Emergency Bill on 22 June 2021" against a bill handled as an emergency bill, and no fact sheet for Sessions 1 to 5 mentions procedure at all. So the column is filled for five bills, all of them in Session 6, and empty for every other bill in the resource. The date the Parliament agreed to treat the bill that way is recorded beside it, and is empty for a procedure that needed no such decision.'
    || E'\n\n' ||
    'Sessions 1 to 5 certainly contained emergency bills, and filling them in means reading a source that states procedure — the Official Report, or the Parliament''s own pages for each bill. That is expected but not yet done. Until it is, a count of emergency bills is a count of the ones Session 6 happens to name, and a chart that groups bills by procedure is a chart of five bills and a very large "not known". Any chart drawn on this column carries this note.',
  '{bill.procedure,bill.date_procedure_agreed}',
  10);


-- ---------------------------------------------------------------------------
-- What should now be true
-- ---------------------------------------------------------------------------
--
-- Nothing on the clean sheet may move. Two cells are added and neither is
-- filled; the two lists are rebuilt and both must still be empty, because no
-- line states a procedure yet. The checks that prove the new rules bite are in
-- docs/CLOSURE-TESTS.md, for a session that did not write them.

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM bill;
  IF n <> 389 THEN RAISE EXCEPTION 'Refusing: % bills, not the 389 there were.', n; END IF;

  SELECT count(*) INTO n FROM stage_event;
  IF n <> 1071 THEN RAISE EXCEPTION 'Refusing: % stage records, not the 1071 there were.', n; END IF;

  SELECT count(*) INTO n FROM field_source;
  IF n <> 112 THEN RAISE EXCEPTION 'Refusing: % provenance notes, not the 112 there were.', n; END IF;

  SELECT count(*) INTO n FROM bill
   WHERE procedure IS NOT NULL OR date_procedure_agreed IS NOT NULL;
  IF n > 0 THEN RAISE EXCEPTION 'Refusing: % bill(s) have a procedure. None should, yet.', n; END IF;

  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n > 0 THEN RAISE EXCEPTION 'Refusing: the error checker is not empty (% problem(s)).', n; END IF;

  SELECT count(*) INTO n FROM v_stage_date_gaps;
  IF n > 0 THEN RAISE EXCEPTION 'Refusing: the gaps list is not empty (% row(s)).', n; END IF;

  SELECT count(*) INTO n FROM methodology_note WHERE code = 'M10';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: M10 was not written.'; END IF;

  RAISE NOTICE 'Two cells added, both empty; error checker and gaps list both empty; M10 written.';
END $$;

COMMIT;
