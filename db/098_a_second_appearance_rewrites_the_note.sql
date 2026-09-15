-- db/098_a_second_appearance_rewrites_the_note.sql
--
-- A bill's note becomes the eighth cell that a further appearance can change.
--
-- WHAT WENT WRONG, AND WOULD HAVE. When a later fact sheet lists a bill that is
-- already on the clean sheet, promotion updates seven cells on that bill: the
-- title, the Act's number, whether it became an Act, the Royal Assent date, the
-- date it ended, how it was stopped before Royal Assent, and what followed.
-- The note was not one of them, and was never touched.
--
-- Session 6 is where that bites. The European Charter of Local Self-Government
-- (Incorporation) and United Nations Convention on the Rights of the Child
-- (Incorporation) Bills were passed in Session 5, stopped before Royal Assent
-- by a section 33 reference, and each carries a note ending "it could not be
-- submitted for Royal Assent in its unamended form". Both were reconsidered and
-- passed in Session 6 and are now Acts. Promoting Session 6 without this would
-- have filled in each Act's title, number and Royal Assent date and left the
-- note beside it saying the bill never got one. The UK Withdrawal from the
-- European Union (Legal Continuity) Bill is the same shape: its note stops at
-- the block, and Session 6 is where it was withdrawn.
--
-- THE RULE, settled with the owner on 2026-09-15.
--   - The note is carried like the other seven cells: a further appearance that
--     has a note of its own replaces the note on the bill it continues.
--   - An empty note on such a line means the earlier note stands, and promotion
--     never blanks one. But the error checker asks for a note wherever the bill
--     being continued has one, so that leaving the earlier wording in place is
--     something somebody decided rather than something nobody noticed. Where
--     the earlier wording is still right it is repeated, which changes nothing
--     and writes no provenance.
--   - Promotion writes a provenance note for the note as it does for the other
--     seven, recording what it read before.
--   - M6 says what a reader needs to know.
--
-- This migration adds the rule, updates M6, and writes the three notes onto the
-- Session 6 lines that need them. tools/promote_session.sql carries the cell,
-- and is changed in the same commit.
--
-- THE FOURTH BILL THAT APPEARS TWICE needs nothing here. The Gender Recognition
-- Reform Bill's Session 7 line already carries its own note, in full, and will
-- replace the Session 6 bill's when that line is pointed at it — which cannot
-- happen until Session 6 is on the clean sheet.
--
-- WHERE EVERY DATE IN THESE NOTES COMES FROM.
--   - 6 October 2021, the Supreme Court's ruling: already in the notes being
--     replaced, from the Session 5 fact sheet's footnotes (db/071, db/072).
--   - 15 April 2026, the European Charter Act's Royal Assent: the Session 6
--     fact sheet, confirmed at legislation.gov.uk on 2026-09-15 in the Act's
--     own words, "approved by the Parliament on 3rd March 2026 and received
--     Royal Assent on 15th April 2026", at 2026 asp 11. The citation is on
--     line 440.
--   - 16 January 2024, the UNCRC Act's Royal Assent: the Session 6 fact sheet,
--     which prints the Act's number as 2024 asp 1, and legislation.gov.uk's
--     list of Acts for 2024 agrees. Read 2026-09-15. The account is on line 468.
--   - 10 March 2022, the Legal Continuity Bill's withdrawal: the Session 6 fact
--     sheet, "Passed on 21 March 2018. Withdrawn on 10 March 2022" (db/094).
--
-- Nothing here touches the clean sheet. Nothing here admits or promotes
-- anything. Whether this migration is right is for a session that did not
-- write it.

\set ON_ERROR_STOP on
BEGIN;

-- ---------------------------------------------------------------------------
-- Before anything changes
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM bill_candidate
   WHERE candidate_id IN (412, 440, 468)
     AND session_number = 6
     AND continues_bill_id IS NOT NULL
     AND coalesce(btrim(bill_note), '') = '';
  IF n <> 3 THEN
    RAISE EXCEPTION 'Refusing: expected 3 Session 6 second appearances with no note, found %.', n;
  END IF;

  SELECT count(*) INTO n FROM bill
   WHERE bill_id IN (303, 304, 305)
     AND coalesce(btrim(note), '') <> ''
     AND note LIKE 'Not submitted for Royal Assent.%';
  IF n <> 3 THEN
    RAISE EXCEPTION 'Refusing: the three bills being continued do not carry the notes this expects.';
  END IF;

  SELECT count(*) INTO n FROM bill_candidate
   WHERE continues_bill_id IS NOT NULL AND candidate_id NOT IN (412, 440, 468);
  IF n <> 0 THEN
    RAISE EXCEPTION 'Refusing: % other line(s) continue a bill and this migration has not looked at them.', n;
  END IF;
END $$;

-- ---------------------------------------------------------------------------
-- The error checker
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
        -- ---------------------------------- widened at db/090. Until now this
        -- asked only about a date that contradicted the fact sheet, so a date
        -- filled into a cell the fact sheet left empty needed no citation and
        -- got none. That is how a value from another source could reach the
        -- clean sheet with nothing saying where it came from. See M12.
        (CASE WHEN c.date_royal_assent IS NOT NULL
               AND c.date_royal_assent
                   IS DISTINCT FROM factsheet_date(c.raw_date_royal_assent)
               AND coalesce(c.review_note, '')
                   !~ 'Checked: date_royal_assent = \d{4}-\d{2}-\d{2} \([^)]+\)'
              THEN 'date_royal_assent '
                   ||CASE WHEN c.raw_date_royal_assent IS NULL
                          THEN 'fills a cell the fact sheet left empty'
                          ELSE 'differs from the factsheet''s own words ('
                               ||c.raw_date_royal_assent||')' END
                   ||', but review_note carries no '
                   ||'"Checked: date_royal_assent = ..." citation' END),
        (CASE WHEN c.date_introduced IS NOT NULL
               AND c.date_introduced
                   IS DISTINCT FROM factsheet_date(c.raw_date_introduced)
               AND coalesce(c.review_note, '')
                   !~ 'Checked: date_introduced = \d{4}-\d{2}-\d{2} \([^)]+\)'
              THEN 'date_introduced '
                   ||CASE WHEN c.raw_date_introduced IS NULL
                          THEN 'fills a cell the fact sheet left empty'
                          ELSE 'differs from the factsheet''s own words ('
                               ||c.raw_date_introduced||')' END
                   ||', but review_note carries no '
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
        -- ---------------------------------- widened at db/094. The rule was
        -- written at db/020, before the cells that say what followed a bill
        -- being stopped before Royal Assent existed at all (db/084). Its job is
        -- to stop a bill that passed being recorded as never becoming an Act
        -- with nothing saying why, and assent_block_outcome does that job
        -- better than the rule does: a line that says the bill was stopped and
        -- then withdrawn has explained itself. The first bill to need this is
        -- the UK Withdrawal from the European Union (Legal Continuity) Bill,
        -- which passed on 21 March 2018, was stopped by the Supreme Court, and
        -- was withdrawn on 10 March 2022. See methodology note M5.
        (CASE WHEN c.outcome = 'passed' AND c.date_royal_assent IS NULL
               AND c.enactment_status NOT IN ('blocked', 'pending')
               AND c.assent_block_outcome IS NULL
              THEN 'passed, but has no Royal Assent date, is recorded as '
                   ||coalesce(quote_literal(c.enactment_status),'null')
                   ||' rather than as blocked or awaiting one, and says nothing '
                   ||'about what followed the bill being stopped' END),
        -- ---------------------------------- widened at db/090. 'enacted' joins
        -- the two values this table could take. A fact sheet is a snapshot: it
        -- prints the state of a bill on the day it was compiled, and seven of
        -- Session 6's had received Royal Assent months before the sheet was
        -- read. The rule below is what makes that visible rather than silent.
        (CASE WHEN c.raw_section = 'awaiting_assent'
               AND (c.outcome IS DISTINCT FROM 'passed'
                    OR c.enactment_status NOT IN ('blocked', 'pending', 'enacted'))
              THEN 'read from the Bills awaiting Royal Assent table, but outcome is '
                   ||coalesce(quote_literal(c.outcome),'null')||' and it is recorded as '
                   ||coalesce(quote_literal(c.enactment_status),'null') END),

        -- ---------------------------------- added at db/090: every bill a fact
        -- sheet leaves awaiting Royal Assent is looked up at legislation.gov.uk
        -- before the line can be admitted, and says so whether or not the
        -- answer changed anything. A check that only speaks when it finds
        -- something is not a check; that is how the comparison against the
        -- owner's dataset went unrun for two sessions. See M12.
        (CASE WHEN c.raw_section = 'awaiting_assent'
               AND c.outcome = 'passed'
               AND coalesce(c.review_note, '')
                   !~ 'Checked: enactment_status = [a-z_]+ \([^)]+\)'
              THEN 'the fact sheet leaves this bill awaiting Royal Assent, and nothing '
                   ||'says legislation.gov.uk has been read to see whether the Act has '
                   ||'since been made: review_note carries no '
                   ||'"Checked: enactment_status = ..." citation — see methodology '
                   ||'note M12' END),
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

        -- Promotion carries eight cells from a further appearance onto the
        -- bill it continues, and procedure is not one of them, because no fact
        -- sheet states the procedure of a carried-over row. A line that did
        -- would have the value dropped in silence. Refuse it instead, so that
        -- whoever meets the first one decides what should happen to it.
        (CASE WHEN c.continues_bill_id IS NOT NULL
               AND (c.procedure IS NOT NULL OR c.date_procedure_agreed IS NOT NULL)
              THEN 'continues bill ' || c.continues_bill_id
                   || ' and states how the bill was handled. A further'
                   || ' appearance does not carry the procedure onto the bill,'
                   || ' so this would be lost. See db/087' END),

        -- ---------------------------------- added at db/098: the note is the
        -- eighth cell a further appearance carries, and this is what stops an
        -- earlier fact sheet's note being left standing beside what a later one
        -- changed. The European Charter and UNCRC Bills were stopped before
        -- Royal Assent in Session 5, and each carries a note saying the bill
        -- could not be submitted for Royal Assent in its unamended form. Both
        -- were reconsidered and enacted in Session 6. Without this rule the
        -- promotion would have filled in the Act's title, number and Royal
        -- Assent date and left the note saying the bill never got one.
        --
        -- Empty still MEANS the earlier note stands, and promotion never blanks
        -- a note. The rule is that somebody has to have looked: if the earlier
        -- wording is still right, it is repeated on this line, which changes
        -- nothing and writes no provenance, and the line is clear. A check that
        -- only speaks when the wording happens to be wrong would not have
        -- spoken here. See methodology note M6.
        (CASE WHEN c.continues_bill_id IS NOT NULL
               AND coalesce(btrim(c.bill_note), '') = ''
               AND EXISTS (SELECT 1 FROM bill b3
                            WHERE b3.bill_id = c.continues_bill_id
                              AND coalesce(btrim(b3.note), '') <> '')
              THEN 'continues bill ' || c.continues_bill_id
                   || ', which carries a note written from an earlier fact'
                   || ' sheet, and this line has no note of its own. Say here'
                   || ' what the note should now read — repeating the earlier'
                   || ' wording if it still stands — so that the note cannot be'
                   || ' left behind by what this line changes. See methodology'
                   || ' note M6' END)
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

        -- ---------------------------------- added at db/088: the day the bill
        -- reached the stage, beside the day the stage ended. Three refusals,
        -- and no more: the day reached cannot be after the day the stage
        -- ended, cannot be before the bill existed, and cannot be on a stage
        -- the bill never had.
        (CASE WHEN r.date_reached IS NOT NULL AND r.date_completed IS NOT NULL
               AND r.date_reached > r.date_completed
              THEN 'reached on '||r.date_reached||', after it ended on '||r.date_completed END),
        (CASE WHEN r.date_reached IS NOT NULL AND r.date_introduced IS NOT NULL
               AND r.date_reached < r.date_introduced
              THEN 'reached on '||r.date_reached||', before the bill was introduced on '
                   ||r.date_introduced END),
        (CASE WHEN r.did_not_happen AND r.date_reached IS NOT NULL
              THEN 'marked as a stage that did not happen, but reached on '||r.date_reached END),

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
 'The error checker: every problem the database can find on the staging sheets, one row per problem, for the owner to clear before a session is admitted. A line or stage row with nothing wrong does not appear. Empty means nothing found, not nothing checked. At db/090 the Royal Assent and introduction date rules also ask about a date filled into a cell the fact sheet left empty, and every line read from an awaiting-assent table must say legislation.gov.uk has been read to see whether the Act has since been made. At db/094 a bill that passed and has no Royal Assent date may also account for itself by saying what followed the bill being stopped, instead of being recorded as blocked or awaiting assent. At db/098 a line that lists again a bill whose note was written from an earlier fact sheet must say what that note should now read.';

-- ---------------------------------------------------------------------------
-- What a reader is told
-- ---------------------------------------------------------------------------

UPDATE methodology_note
   SET body = body || E'\n\nTHE NOTE ON SUCH A BILL is written to cover the whole of its life, not the part of it the first fact sheet could see. Where a later fact sheet changes what the note should say, the note is rewritten, and what it read before is kept with the record of where each fact came from.',
       updated_at = now()
 WHERE code = 'M6';

-- ---------------------------------------------------------------------------
-- The three notes
-- ---------------------------------------------------------------------------

-- Bill 303, the European Charter of Local Self-Government (Incorporation)
-- Bill: stopped before Royal Assent in Session 5, reconsidered and enacted in
-- Session 6 as 2026 asp 11.
UPDATE bill_candidate
   SET bill_note =
         'Not submitted for Royal Assent when first passed. Following a reference under '
      || 'section 33 of the Scotland Act 1998 by the Attorney General and the Advocate '
      || 'General for Scotland, the Supreme Court ruled on 6 October 2021 that some '
      || 'provisions of the bill were outwith the Parliament''s legislative competence, '
      || 'and it could not be submitted for Royal Assent in its unamended form. The '
      || 'Parliament reconsidered the bill in Session 6 and passed it again, and it '
      || 'received Royal Assent on 15 April 2026.',
       updated_at = now()
 WHERE candidate_id = 440;

-- Bill 304, the United Nations Convention on the Rights of the Child
-- (Incorporation) Bill: the same, enacted in Session 6 as 2024 asp 1.
UPDATE bill_candidate
   SET bill_note =
         'Not submitted for Royal Assent when first passed. Following a reference under '
      || 'section 33 of the Scotland Act 1998 by the Attorney General and the Advocate '
      || 'General for Scotland, the Supreme Court ruled on 6 October 2021 that some '
      || 'provisions of the bill were outwith the Parliament''s legislative competence, '
      || 'and it could not be submitted for Royal Assent in its unamended form. The '
      || 'Parliament reconsidered the bill in Session 6 and passed it again, and it '
      || 'received Royal Assent on 16 January 2024.',
       updated_at = now()
 WHERE candidate_id = 468;

-- Bill 305, the UK Withdrawal from the European Union (Legal Continuity) Bill:
-- stopped before Royal Assent and never reconsidered. It was withdrawn in
-- Session 6. The first three sentences are the note as it stands, unchanged,
-- because the Session 5 fact sheet's footnote is still what it rests on.
UPDATE bill_candidate
   SET bill_note =
         'Not submitted for Royal Assent. Following a reference under section 33 of the '
      || 'Scotland Act 1998 by the Attorney General and the Advocate General for '
      || 'Scotland, the Supreme Court ruled that some provisions of the bill were '
      || 'outwith the Parliament''s legislative competence, and it could not be '
      || 'submitted for Royal Assent in its unamended form. The fact sheet states no '
      || 'date for the ruling. The bill was withdrawn on 10 March 2022.',
       updated_at = now()
 WHERE candidate_id = 412;

-- ---------------------------------------------------------------------------
-- What should now be true
-- ---------------------------------------------------------------------------
--
-- These are statements of fact about what this migration did, and nothing more.
-- The new rule is not given its own fault to catch here, because the session
-- that writes a rule does not get to mark it. That belongs in Session 6's
-- closure test, in docs/CLOSURE-TESTS.md, for a session that did not write this.

DO $$
DECLARE n integer; t text;
BEGIN
  -- The three lines carry their notes, and each says what the earlier note did
  -- not: that the bill has since become an Act, or that it was withdrawn.
  SELECT count(*) INTO n FROM bill_candidate
   WHERE candidate_id IN (440, 468) AND bill_note LIKE '%received Royal Assent on%';
  IF n <> 2 THEN RAISE EXCEPTION 'Expected 2 notes saying the Act was made, found %.', n; END IF;

  SELECT count(*) INTO n FROM bill_candidate
   WHERE candidate_id = 412 AND bill_note LIKE '%withdrawn on 10 March 2022.';
  IF n <> 1 THEN RAISE EXCEPTION 'Line 412''s note does not end with the withdrawal.'; END IF;

  -- No note ends mid-sentence: db/079's rule, asked again here because these
  -- three are typed in rather than read off a sheet.
  SELECT count(*) INTO n FROM bill_candidate
   WHERE candidate_id IN (412, 440, 468) AND btrim(bill_note) !~ '\.$';
  IF n <> 0 THEN RAISE EXCEPTION '% of the three notes does not end in a full stop.', n; END IF;

  -- Each note still says how the bill was stopped. That is what M5 requires of
  -- a bill recorded as blocked, and it is the half of the story the rewrite
  -- must not lose.
  SELECT count(*) INTO n FROM bill_candidate
   WHERE candidate_id IN (412, 440, 468)
     AND bill_note LIKE '%section 33 of the Scotland Act 1998%';
  IF n <> 3 THEN RAISE EXCEPTION 'Only % of the three notes still says how the bill was stopped.', n; END IF;

  -- M6 says it.
  SELECT body INTO t FROM methodology_note WHERE code = 'M6';
  IF t NOT LIKE '%THE NOTE ON SUCH A BILL%' THEN
    RAISE EXCEPTION 'M6 does not tell a reader what happens to the note.';
  END IF;
  IF t !~ '\.$' THEN RAISE EXCEPTION 'M6 now ends mid-sentence.'; END IF;

  -- Session 6 is clear again, and the error checker is back where it was: the
  -- one problem left is the sequencing one, Session 7's Gender Recognition
  -- Reform line, which cannot be answered until Session 6 is on the clean sheet.
  SELECT count(*) INTO n FROM v_candidate_problems p
    JOIN bill_candidate c USING (candidate_id) WHERE c.session_number = 6;
  IF n <> 0 THEN RAISE EXCEPTION 'Session 6 has % problem(s).', n; END IF;

  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n <> 1 THEN RAISE EXCEPTION 'The error checker finds % problem(s), expected 1.', n; END IF;

  SELECT count(*) INTO n FROM v_candidate_problems WHERE candidate_id = 474;
  IF n <> 1 THEN RAISE EXCEPTION 'The one problem left is not line 474''s.'; END IF;

END $$;

-- ---------------------------------------------------------------------------
-- The clean sheet did not move
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM bill;
  IF n <> 389 THEN RAISE EXCEPTION '% bills on the clean sheet, expected 389.', n; END IF;
  SELECT count(*) INTO n FROM stage_event;
  IF n <> 1071 THEN RAISE EXCEPTION '% stage records, expected 1071.', n; END IF;
  SELECT count(*) INTO n FROM field_source;
  IF n <> 112 THEN RAISE EXCEPTION '% provenance notes, expected 112.', n; END IF;
  SELECT count(*) INTO n FROM bill WHERE bill_id IN (303, 304, 305)
     AND note LIKE '%unamended form.%';
  IF n <> 3 THEN RAISE EXCEPTION 'The notes on the clean sheet have moved, and nothing here should move them.'; END IF;
  SELECT count(*) INTO n FROM bill_candidate
   WHERE session_number = 6 AND review_status <> 'new';
  IF n <> 0 THEN RAISE EXCEPTION '% Session 6 line(s) are no longer waiting for review.', n; END IF;
END $$;

COMMIT;
