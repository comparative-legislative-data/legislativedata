-- db/055_session_3_why_five_bills_fell.sql
--
-- The five Session 3 bills the factsheet says fell without saying why. The
-- owner established each from the Parliament's own record; every one was then
-- read in the Official Report for that day, and the Presiding Officer's words
-- are quoted on the line. See DECISIONS.md, 2026-09-13.
--
-- Three were rejected at Stage 1 in the ordinary way. One was rejected at
-- Stage 3 -- the first time this database has recorded that. The fifth is a way
-- of falling this database could not previously express, and most of this file
-- is about it.
--
-- A bill whose costs require it must have a financial resolution agreed before
-- it can go to Stage 2. Rule 9.12: the Presiding Officer decides whether a bill
-- needs one. The Creative Scotland Bill's general principles were agreed at
-- Stage 1 on 18 June 2008 and the financial resolution was then disagreed to,
-- so the bill fell with its general principles standing. That is neither a
-- rejection nor running out of time, and the Parliament's own website calls it
-- "fell at Stage 1", which is wrong in a way that matters: the Parliament
-- agreed the principles.
--
-- This only changes the staging sheet. Session 3 is not on the clean sheet.

\set ON_ERROR_STOP on
BEGIN;

-- ---------------------------------------------------------------------------
-- 1. The new way of falling
-- ---------------------------------------------------------------------------

INSERT INTO ref_outcome (code, label, definition, is_final, sort_order) VALUES
 ('fell_financial_resolution_not_agreed',
  'Fell: financial resolution not agreed',
  'The bill fell because the Parliament did not agree the financial resolution '
  || 'its costs required. Under Rule 9.12 a bill whose provisions charge public '
  || 'funds needs a financial resolution, and the Presiding Officer decides '
  || 'whether it does; without one agreed the bill cannot proceed to Stage 2. A '
  || 'bill recorded this way has completed Stage 1 -- its general principles were '
  || 'agreed -- so it is not a rejection, and it did not run out of time, so it is '
  || 'not a dissolution. One case at 2026-09-13: the Creative Scotland Bill, '
  || '18 June 2008.',
  true, 7);

-- fell_other is now narrower than it was: it means a reason this database has
-- not named, and the financial resolution is named.
COMMENT ON TABLE ref_outcome IS
 'The list of ways a bill can end, used by the outcome column on the clean sheet and the staging sheet. One row per allowed value. Empty is not allowed on the clean sheet; on the staging sheet an empty outcome means the factsheet did not say and nobody has worked it out yet.';

-- ---------------------------------------------------------------------------
-- 2. The error checker learns the new value
--
--    Copied from db/051 with one change: the list of outcomes a bill read from
--    the factsheet's Fallen table may hold now includes the new one. Everything
--    else is as db/051 left it.
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
        (CASE WHEN r.did_not_happen AND nullif(btrim(r.note), '') IS NULL
              THEN 'marked as a stage that did not happen, but no note says why' END),

        -- Whether it holds together.
        (CASE WHEN r.completed AND r.fell_here
              THEN 'marked completed, and also as where the bill ended' END),
        (CASE WHEN r.completed AND r.date_completed IS NULL
               AND nullif(btrim(r.note), '') IS NULL
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
-- 3. The five codings
--
--    Each line names the meeting whose Official Report was read, the motion put
--    and who moved it, and quotes the Presiding Officer after "Result as
--    recorded:", which is the form the checker requires.
-- ---------------------------------------------------------------------------

CREATE TEMP TABLE coding (
  candidate_id integer, title_fragment text, outcome text, route text,
  decided_on date, stage text, completed boolean, url text, note text
) ON COMMIT DROP;

INSERT INTO coding VALUES
 (210, 'Autism', 'rejected_stage_1', 'member_motion_disagreed', DATE '2011-01-12',
  'stage_1', false,
  'https://www.parliament.scot/api/sitecore/CustomMedia/OfficialReport?meetingId=6230',
  'Outcome from the Official Report, not the factsheet: general principles not agreed to at '
  || 'Stage 1, 12 January 2011. Route: the member''s motion, S3M-7676 in the name of Hugh '
  || 'O''Donnell, disagreed to. Result as recorded: "For 5, Against 109, Abstentions 2. '
  || 'Motion disagreed to."'),

 (214, 'End of Life Assistance', 'rejected_stage_1', 'member_motion_disagreed', DATE '2010-12-01',
  'stage_1', false,
  'https://www.parliament.scot/api/sitecore/CustomMedia/OfficialReport?meetingId=6031',
  'Outcome from the Official Report, not the factsheet: general principles not agreed to at '
  || 'Stage 1, 1 December 2010. Route: the member''s motion, S3M-7438 in the name of Margo '
  || 'MacDonald, disagreed to. Result as recorded: "For 16, Against 85, Abstentions 2. '
  || 'Motion disagreed to."'),

 (216, 'Protection of Workers', 'rejected_stage_1', 'member_motion_disagreed', DATE '2010-12-22',
  'stage_1', false,
  'https://www.parliament.scot/api/sitecore/CustomMedia/OfficialReport?meetingId=6093',
  'Outcome from the Official Report, not the factsheet: general principles not agreed to at '
  || 'Stage 1, 22 December 2010. Route: the member''s motion, S3M-7592 in the name of Hugh '
  || 'Henry, disagreed to. Result as recorded: "For 42, Against 75, Abstentions 0. '
  || 'Motion disagreed to."'),

 (211, 'Budget (Scotland) (No.2)', 'rejected_stage_3', NULL, DATE '2009-01-28',
  'stage_3', false,
  'https://www.parliament.scot/api/sitecore/CustomMedia/OfficialReport?meetingId=4843',
  'Outcome from the Official Report, not the factsheet: the bill was rejected at Stage 3, '
  || '28 January 2009, on the motion S3M-3299 in the name of John Swinney that it be passed. '
  || 'The division was tied and the Presiding Officer''s casting vote decided it, against the '
  || 'motion and for the status quo. Result as recorded: "For 64, Against 64, Abstentions 0. '
  || 'It is a well-established convention here and elsewhere that Presiding Officers cast in '
  || 'favour of the status quo. As the passing of the bill would result in a change to the '
  || 'present position with regard to the budget, and as I advised all business managers, I '
  || 'cast my vote against the motion. Motion disagreed to." The Presiding Officer then: "The '
  || 'Budget (Scotland) (No 2) Bill therefore falls."'),

 (213, 'Creative Scotland', 'fell_financial_resolution_not_agreed', NULL, DATE '2008-06-18',
  'stage_1', true,
  'https://www.parliament.scot/api/sitecore/CustomMedia/OfficialReport?meetingId=4805',
  'Outcome from the Official Report, not the factsheet: the bill fell on 18 June 2008 because '
  || 'the financial resolution was not agreed. Its general principles WERE agreed the same '
  || 'day, on motion S3M-2028 in the name of Linda Fabiani: "Motion agreed to. That the '
  || 'Parliament agrees to the general principles of the Creative Scotland Bill." The '
  || 'financial resolution, motion S3M-1776 in the name of John Swinney, was then put. Result '
  || 'as recorded: "For 49, Against 68, Abstentions 0. Motion disagreed to." The Presiding '
  || 'Officer then: "Standing orders are quite clear; the Creative Scotland Bill therefore '
  || 'falls." The Parliament''s own bill page says the bill "fell at Stage 1", which this '
  || 'record contradicts: Stage 1 was completed.');

-- A mistyped line number must fail here, not write to the wrong bill.
DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM coding a JOIN bill_candidate c USING (candidate_id)
   WHERE c.short_title NOT ILIKE '%' || a.title_fragment || '%';
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % coding row(s) name a line whose title does not match.', n;
  END IF;
  SELECT count(*) INTO n FROM coding a JOIN bill_candidate c USING (candidate_id)
   WHERE c.outcome IS NOT NULL;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % line(s) already hold an outcome.', n;
  END IF;
  SELECT count(*) INTO n FROM coding a JOIN bill_candidate c USING (candidate_id)
   WHERE c.date_concluded IS DISTINCT FROM a.decided_on;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % line(s) conclude on a day other than the one the Official Report gives.', n;
  END IF;
END $$;

UPDATE bill_candidate c
   SET outcome                 = a.outcome,
       stage_1_rejection_route = a.route,
       official_report_read_on = DATE '2026-09-13',
       review_note             = btrim(coalesce(c.review_note || E'\n', '') || a.note)
  FROM coding a
 WHERE a.candidate_id = c.candidate_id;

-- ---------------------------------------------------------------------------
-- 4. Where each bill stopped, on the stage-dates sheet
--
--    For four of them the stage is where the bill fell. The Creative Scotland
--    Bill is the exception and the reason the new value exists: its Stage 1 is
--    recorded as completed, because the Parliament agreed its general
--    principles, and no stage is marked as where it fell -- it did not fall at
--    a stage.
-- ---------------------------------------------------------------------------

INSERT INTO stage_candidate
       (candidate_id, stage, date_completed, completed, fell_here,
        source, source_ref, observed_at)
SELECT a.candidate_id, a.stage, a.decided_on, a.completed, NOT a.completed,
       'official_report', a.url, DATE '2026-09-13'
  FROM coding a
 WHERE NOT EXISTS (SELECT 1 FROM stage_candidate s
                    WHERE s.candidate_id = a.candidate_id AND s.stage = a.stage);

-- ---------------------------------------------------------------------------
-- 5. What a reader is told
--
--    M7 already tells a reader that why a bill fell is our coding and names
--    the reasons. It named three. There are four, and a ninth note saying so
--    separately would split one subject across two notes, so M7 is amended
--    where it is wrong rather than added to.
-- ---------------------------------------------------------------------------

UPDATE methodology_note SET body = replace(body,
 'a bill that simply ran out of time at dissolution was never voted on at all.',
 'a bill that simply ran out of time at dissolution was never voted on at all, and a bill '
 || 'can fall having been voted on and won, because the Parliament did not agree the '
 || 'financial resolution its costs required.')
 WHERE code = 'M7';

UPDATE methodology_note SET body = replace(body,
 'at the time of writing it has been done for Sessions 1 and 2.',
 'at the time of writing it has been done for Sessions 1, 2 and 3.')
 WHERE code = 'M7';

UPDATE methodology_note SET body = body || E'\n\n' ||
 'The fourth reason needs care, because it is the one that looks like a defeat and is not. '
 || 'A bill whose provisions charge public funds requires a financial resolution before it '
 || 'can proceed beyond Stage 1; under Rule 9.12 the Presiding Officer decides whether a bill '
 || 'needs one, and the resolution is moved separately, normally by the minister responsible '
 || 'for finance. If it is not agreed, the bill falls however the Parliament voted on the bill '
 || 'itself. One bill in the first three sessions ended this way. The Parliament agreed the '
 || 'general principles of the Creative Scotland Bill on 18 June 2008 and defeated the '
 || 'financial resolution the same afternoon, so the bill fell with its principles carried. '
 || 'It is recorded as having fallen for want of a financial resolution and not as a '
 || 'rejection, and counting it among the bills the Parliament rejected would misstate what '
 || 'happened. The Parliament''s own bill page describes it as having fallen at Stage 1; the '
 || 'Official Report of that day is what this database follows.'
 WHERE code = 'M7';

DO $$
DECLARE b text;
BEGIN
  SELECT body INTO b FROM methodology_note WHERE code = 'M7';
  IF b IS NULL THEN RAISE EXCEPTION 'Refusing: M7 does not exist.'; END IF;
  IF b NOT LIKE '%did not agree the financial resolution its costs required%' THEN
    RAISE EXCEPTION 'Refusing: M7''s list of reasons was not amended -- its wording has changed.';
  END IF;
  IF b NOT LIKE '%Sessions 1, 2 and 3.%' THEN
    RAISE EXCEPTION 'Refusing: M7 still says the work has been done for Sessions 1 and 2 only.';
  END IF;
  IF b NOT LIKE '%Rule 9.12%' THEN
    RAISE EXCEPTION 'Refusing: M7 does not carry the financial resolution paragraph.';
  END IF;
END $$;

-- ---------------------------------------------------------------------------
-- 6. What should now be true
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM bill_candidate c JOIN coding a USING (candidate_id)
   WHERE c.outcome IS DISTINCT FROM a.outcome;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % line(s) do not hold the coded outcome.', n;
  END IF;

  SELECT count(*) INTO n FROM bill_candidate
   WHERE session_number = 3 AND raw_section = 'fallen' AND outcome IS NULL;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % Session 3 fallen line(s) still have no outcome.', n;
  END IF;

  SELECT count(*) INTO n FROM bill_candidate
   WHERE candidate_id = 213
     AND (outcome <> 'fell_financial_resolution_not_agreed'
          OR stage_1_rejection_route IS NOT NULL);
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: the Creative Scotland Bill is not coded as this file says.';
  END IF;

  SELECT count(*) INTO n FROM stage_candidate
   WHERE candidate_id = 213 AND stage = 'stage_1' AND completed AND NOT fell_here;
  IF n <> 1 THEN
    RAISE EXCEPTION 'Refusing: the Creative Scotland Bill has no completed Stage 1.';
  END IF;

  SELECT count(*) INTO n FROM stage_candidate s JOIN coding a USING (candidate_id)
   WHERE s.stage = a.stage AND s.fell_here <> (NOT a.completed);
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % stage row(s) disagree with this file about where the bill stopped.', n;
  END IF;

  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: the error checker is not empty (% problem(s)).', n;
  END IF;

  RAISE NOTICE 'Session 3: five fallen bills coded -- 3 rejected at Stage 1, 1 at Stage 3, 1 for want of a financial resolution. Checker empty.';
END $$;

COMMIT;
