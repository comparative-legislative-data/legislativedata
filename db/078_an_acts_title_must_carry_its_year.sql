-- db/078_an_acts_title_must_carry_its_year.sql
--
-- The Period Products Act's title is settled at legislation.gov.uk, and the
-- error checker is taught the rule that would have caught it. M7 is brought up
-- to the five sessions now coded.
--
-- Three things, settled with the owner on 2026-09-14 after Session 5's closure
-- test was run and reported. None changes what any bill is or what happened to
-- it; all three are about what a reader is shown.
--
-- -------------------------------------------------------------------------
-- 1. The title.
--
-- The Session 5 fact sheet prints the line as "Period Products (Free
-- Provision) (Scotland) Act (asp 1)", with no year anywhere in it. db/073
-- settled the number from legislation.gov.uk as '2021 asp 1' and left the
-- title as the fact sheet printed it. Session 4's equivalent line, the Higher
-- Education Governance Act, had BOTH cells settled by db/063. So the same
-- fault was handled two ways in two sessions, and the half a reader actually
-- sees is the half that was left wrong.
--
-- db/073's own note already quotes legislation.gov.uk giving "Period Products
-- (Free Provision) (Scotland) Act 2021", so nothing needed looking up; the
-- page was read again on 2026-09-14 for this migration's citation.
--
-- The correction is made on the staging sheet, with its citation in the form
-- promotion reads, and Session 5 is then taken off the clean sheet and put
-- back so that the new title and its provenance note arrive by the same route
-- as every other admitted fact. That is db/063's shape, and it is why this
-- migration writes no provenance note of its own. Provenance goes 105 to 106.
--
-- -------------------------------------------------------------------------
-- 2. The rule that would have caught it.
--
-- db/062 added a check that an Act's NUMBER carries its year, because two fact
-- sheet rows print the year in neither cell. It said nothing about the title.
-- That is the gap this line fell through: the number was caught and settled at
-- review, and the title was not looked at. The checker now asks the same of
-- the title.
--
-- It is worded about enactment rather than about the number, because a bill
-- that has not become an Act carries a bill's title and must not carry a year:
-- Session 5's three bills stopped before Royal Assent are recorded as blocked
-- and their titles rightly end in "Bill". See methodology note M3.
--
-- Before this migration, 335 lines are recorded as enacted and 334 of their
-- titles end in a year. The one exception is corrected above, so the check is
-- added to a sheet that already satisfies it.
--
-- The rule is proved to bite, as db/062 proved its own: a year is taken off a
-- title, the checker is read, and the title is put back.
--
-- -------------------------------------------------------------------------
-- 3. M7.
--
-- M7 says the coding of why a bill fell has been done for Sessions 1, 2, 3 and
-- 4. Session 5's seven fallen bills were coded on 2026-09-14 into three
-- rejected at Stage 1 and four out of time, so the note a reader sees has been
-- a session out of date since then. This is exactly the correction db/070 had
-- to make at Session 4's closure, and it was found the same way: while a
-- closure test's Part B was being prepared.
--
-- Two sentences change, and nothing else in M7 or in any other note.
--
--   "it has been done for Sessions 1, 2, 3 and 4"  ->  "1, 2, 3, 4 and 5"
--   "One bill in the first four sessions ended this way"  ->  "first five"
--
-- The second is about the Creative Scotland Bill, still the only bill to have
-- fallen for want of a financial resolution. It was true of four sessions and
-- is true of five: Session 5 added no second case. The sentence counts how far
-- the database has been looked at, not how many such bills exist, so it moves
-- with the first. M7 grows by three characters, from 5003 to 5006.
--
-- No provenance is written for M7: a methodology note is this project's own
-- words about its own coding, not a fact admitted from a source.

\set ON_ERROR_STOP on
BEGIN;

-- ---------------------------------------------------------------- before
CREATE TEMP TABLE before_counts AS
SELECT (SELECT count(*) FROM bill)                                   AS bills,
       (SELECT count(*) FROM stage_event)                            AS stage_records,
       (SELECT count(*) FROM field_source)                           AS provenance,
       (SELECT count(*) FROM bill_candidate)                         AS lines,
       (SELECT count(*) FROM bill_candidate WHERE enactment_status = 'enacted')
                                                                     AS enacted_lines,
       (SELECT count(*) FROM bill_candidate
         WHERE enactment_status = 'enacted' AND short_title ~ '\d{4}$')
                                                                     AS titles_with_a_year,
       (SELECT count(*) FROM v_candidate_problems)                   AS problems;

CREATE TEMP TABLE notes_before AS SELECT code, body FROM methodology_note;

DO $$
DECLARE b record;
BEGIN
  SELECT * INTO b FROM before_counts;
  IF b.problems <> 0 THEN
    RAISE EXCEPTION 'Refusing: the error checker is not empty (% item(s)).', b.problems;
  END IF;
  IF b.enacted_lines - b.titles_with_a_year <> 1 THEN
    RAISE EXCEPTION 'Refusing: % enacted line(s) have a title with no year, expected exactly 1.',
                    b.enacted_lines - b.titles_with_a_year;
  END IF;
END $$;

-- ---------------------------------------------------------------------------
-- 1. The title, on the staging sheet, with the citation promotion reads.
-- ---------------------------------------------------------------------------

UPDATE bill_candidate
   SET short_title = 'Period Products (Free Provision) (Scotland) Act 2021',
       review_note = btrim(coalesce(review_note || E'\n', '')
         || 'Checked: short_title = Period Products (Free Provision) (Scotland) Act 2021 '
         || '(legislation_gov_uk, https://www.legislation.gov.uk/asp/2021/1/contents, '
         || '2026-09-14)' || E'\n'
         || 'The fact sheet prints the title with no year in it and so the number with '
         || 'none either. db/073 settled the number and left the title; this settles the '
         || 'title from the same page, as db/063 did for the Higher Education Governance '
         || 'Act. See db/062, db/078 and DECISIONS.md, 2026-09-14.')
 WHERE candidate_id = 360
   AND short_title = 'Period Products (Free Provision) (Scotland) Act';

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM bill_candidate
   WHERE candidate_id = 360
     AND short_title = 'Period Products (Free Provision) (Scotland) Act 2021';
  IF n <> 1 THEN RAISE EXCEPTION 'Check failed: line 360 did not take the settled title.'; END IF;
END $$;

-- ---------------------------------------------------------------------------
-- 2. The error checker
--
--    Copied from db/071, which is where it currently stands, with one rule
--    added and marked db/078. Everything else is as db/071 left it.
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
-- 3. M7 says five sessions are coded.
-- ---------------------------------------------------------------------------

DO $$
DECLARE new_body text; n integer;
BEGIN
  SELECT m.body INTO new_body FROM methodology_note m WHERE m.code = 'M7';
  IF new_body IS NULL THEN RAISE EXCEPTION 'Refusing: M7 not found.'; END IF;

  n := (length(new_body) - length(replace(new_body, 'it has been done for Sessions 1, 2, 3 and 4', ''))) / length('it has been done for Sessions 1, 2, 3 and 4');
  IF n <> 1 THEN
    RAISE EXCEPTION 'Refusing: M7 says "Sessions 1, 2, 3 and 4" % time(s), not once.', n;
  END IF;
  n := (length(new_body) - length(replace(new_body, 'One bill in the first four sessions', ''))) / length('One bill in the first four sessions');
  IF n <> 1 THEN
    RAISE EXCEPTION 'Refusing: M7 says "One bill in the first four sessions" % time(s), not once.', n;
  END IF;

  new_body := replace(new_body, 'it has been done for Sessions 1, 2, 3 and 4',
                                'it has been done for Sessions 1, 2, 3, 4 and 5');
  new_body := replace(new_body, 'One bill in the first four sessions',
                                'One bill in the first five sessions');

  UPDATE methodology_note SET body = new_body WHERE code = 'M7';
END $$;

-- ---------------------------------------------------------------------------
-- 4. What must be true afterwards.
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer; b record; probe_id integer; probe_title text; m7 text;
BEGIN
  SELECT * INTO b FROM before_counts;

  -- The title, and only that title.
  SELECT count(*) INTO n FROM bill_candidate
   WHERE enactment_status = 'enacted' AND short_title !~ '\d{4}$';
  IF n <> 0 THEN
    RAISE EXCEPTION 'Check failed: % enacted line(s) still have a title with no year.', n;
  END IF;
  SELECT count(*) INTO n FROM bill_candidate
   WHERE enactment_status = 'enacted' AND short_title ~ '\d{4}$';
  IF n <> b.enacted_lines THEN
    RAISE EXCEPTION 'Check failed: % enacted titles carry a year, expected %.', n, b.enacted_lines;
  END IF;

  -- The citation is in the form promotion reads, brackets in the value and all.
  SELECT count(*) INTO n FROM bill_candidate
   WHERE candidate_id = 360
     AND review_note ~ 'Checked: short_title = Period Products \(Free Provision\) \(Scotland\) Act 2021 \(legislation_gov_uk, [^,]+, 2026-09-14\)';
  IF n <> 1 THEN
    RAISE EXCEPTION 'Check failed: line 360 carries no short_title citation promotion can read.';
  END IF;
  SELECT count(*) INTO n
    FROM bill_candidate c
   WHERE c.candidate_id = 360
     AND (length(coalesce(c.review_note, '')) - length(replace(coalesce(c.review_note, ''), 'Checked: ', '')))
         / length('Checked: ')
       <> (SELECT count(*) FROM regexp_matches(coalesce(c.review_note, ''),
             'Checked: ([a-z0-9_]+) = ([^\n]+?) \(([a-z_]+), ([^,]+), (\d{4}-\d{2}-\d{2})\)', 'g'));
  IF n > 0 THEN
    RAISE EXCEPTION 'Check failed: line 360 carries a "Checked:" citation promotion cannot read.';
  END IF;

  -- The new rule is really there: a title without a year is caught. Proved by
  -- taking one off, reading the checker, and putting it back.
  SELECT candidate_id, short_title INTO probe_id, probe_title
    FROM bill_candidate WHERE enactment_status = 'enacted' ORDER BY candidate_id LIMIT 1;

  UPDATE bill_candidate SET short_title = regexp_replace(probe_title, ' \d{4}$', '')
   WHERE candidate_id = probe_id;

  SELECT count(*) INTO n FROM v_candidate_problems
   WHERE problem LIKE 'enacted, but short_title carries no year%';
  IF n <> 1 THEN
    RAISE EXCEPTION 'Check failed: an Act title with no year was not caught (% row(s) reported).', n;
  END IF;

  UPDATE bill_candidate SET short_title = probe_title WHERE candidate_id = probe_id;

  SELECT count(*) INTO n FROM bill_candidate
   WHERE candidate_id = probe_id AND short_title IS DISTINCT FROM probe_title;
  IF n <> 0 THEN RAISE EXCEPTION 'Check failed: the probed line was not put back as it was.'; END IF;

  -- A bill that is not an Act is not asked for a year.
  SELECT count(*) INTO n FROM v_candidate_problems
   WHERE problem LIKE 'enacted, but short_title carries no year%';
  IF n <> 0 THEN
    RAISE EXCEPTION 'Check failed: % title(s) still reported without a year.', n;
  END IF;

  -- The number rule db/062 added still works.
  SELECT count(*) INTO n FROM v_candidate_problems
   WHERE problem = 'asp_number year does not match the year of Royal Assent';
  IF n <> 0 THEN RAISE EXCEPTION 'Check failed: % Act number year(s) disagree with Royal Assent.', n; END IF;

  -- M7, and only M7.
  SELECT count(*) INTO n FROM methodology_note m JOIN notes_before x USING (code)
   WHERE m.body IS DISTINCT FROM x.body;
  IF n <> 1 THEN RAISE EXCEPTION 'Check failed: % notes changed, not 1.', n; END IF;
  SELECT length(m.body) - length(x.body) INTO n
    FROM methodology_note m JOIN notes_before x USING (code) WHERE code = 'M7';
  IF n <> 3 THEN RAISE EXCEPTION 'Check failed: M7 changed by % characters, not 3.', n; END IF;
  SELECT m.body INTO m7 FROM methodology_note m WHERE m.code = 'M7';
  IF m7 NOT LIKE '%it has been done for Sessions 1, 2, 3, 4 and 5%' THEN
    RAISE EXCEPTION 'Check failed: M7 does not say five sessions are coded.';
  END IF;
  IF m7 LIKE '%Sessions 1, 2, 3 and 4%' OR m7 LIKE '%first four sessions%' THEN
    RAISE EXCEPTION 'Check failed: M7 still tells a reader four sessions.';
  END IF;
  SELECT count(*) INTO n FROM methodology_note;
  IF n <> 8 THEN RAISE EXCEPTION 'Check failed: % methodology notes, not 8.', n; END IF;

  -- Nothing about the bills moved. The clean sheet still holds the old title:
  -- it is put right by taking Session 5 off and putting it back, not here.
  SELECT count(*) INTO n FROM bill;
  IF n <> b.bills THEN RAISE EXCEPTION 'Check failed: % bills, not %.', n, b.bills; END IF;
  SELECT count(*) INTO n FROM stage_event;
  IF n <> b.stage_records THEN RAISE EXCEPTION 'Check failed: % stage records, not %.', n, b.stage_records; END IF;
  SELECT count(*) INTO n FROM field_source;
  IF n <> b.provenance THEN RAISE EXCEPTION 'Check failed: % provenance notes, not %.', n, b.provenance; END IF;
  SELECT count(*) INTO n FROM bill_candidate;
  IF n <> b.lines THEN RAISE EXCEPTION 'Check failed: % staging lines, not %.', n, b.lines; END IF;

  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n <> 0 THEN RAISE EXCEPTION 'The error checker is no longer empty: % item(s).', n; END IF;
  SELECT count(*) INTO n FROM v_stage_date_gaps;
  IF n <> 0 THEN RAISE EXCEPTION 'The gaps list is no longer empty: % item(s).', n; END IF;

  RAISE NOTICE 'Line 360 titled from legislation.gov.uk. The checker now asks an Act title for its year, and bites. M7 is % characters.', length(m7);
END $$;

DROP TABLE before_counts;
DROP TABLE notes_before;

COMMIT;
