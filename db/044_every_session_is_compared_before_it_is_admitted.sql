-- db/044_every_session_is_compared_before_it_is_admitted.sql
--
-- What made Sessions 1 and 2 checkable was a list of the dates two sources
-- state differently. That list was made by hand. This makes it every time.
--
-- tools/compare_sources.py compares a session's staging lines against every
-- other source that states the same dates, stamps each line with the date it
-- was compared, and writes what the other source gives on any line where they
-- differ. The error checker then refuses to let a line be accepted before it
-- has been compared, and refuses to let a session be promoted while a recorded
-- difference has not been adjudicated with a citation.
--
-- Sessions 1 and 2 are stamped here from the same tool, and their seven
-- remaining differences written down. Seven, not thirteen: the five the owner
-- corrected now agree with the dataset, and the thirteenth was a passing date,
-- which lives on the stage-dates sheet and is not compared here.

\set ON_ERROR_STOP on
BEGIN;

-- ---------------------------------------------------------------------------
-- 1. When this line's sources were compared
-- ---------------------------------------------------------------------------

ALTER TABLE bill_candidate ADD COLUMN sources_compared_at date;

COMMENT ON COLUMN bill_candidate.sources_compared_at IS
 'The date this line''s dates were compared against every other source that states them, by tools/compare_sources.py. Empty means the comparison has never been run for this line, and the error checker refuses to let it be accepted: a disagreement nobody looked for is a disagreement nobody finds. Comparing against every source there is and finding only one still counts, so a line with no row in any other source is stamped too.';

-- ---------------------------------------------------------------------------
-- 2. Sessions 1 and 2, compared on 2026-09-12
-- ---------------------------------------------------------------------------

UPDATE bill_candidate SET sources_compared_at = DATE '2026-09-12'
 WHERE session_number = 1;


-- line 3: Adults with Incapacity (Scotland) Act 2000
--   this line 2000-05-09, dataset row 6 2000-05-19
UPDATE bill_candidate
   SET review_note = btrim(coalesce(review_note || E'\n', '') || 'Differs: date_royal_assent = 2000-05-19 (phd); this line gives 2000-05-09')
 WHERE candidate_id = 3
   AND coalesce(review_note, '') NOT LIKE '%Differs: date_royal_assent = 2000-05-19 %';

-- line 29: International Criminal Court (Scotland) Act 2001
--   this line 2001-04-04, dataset row 28 2001-04-05
UPDATE bill_candidate
   SET review_note = btrim(coalesce(review_note || E'\n', '') || 'Differs: date_introduced = 2001-04-05 (phd); this line gives 2001-04-04')
 WHERE candidate_id = 29
   AND coalesce(review_note, '') NOT LIKE '%Differs: date_introduced = 2001-04-05 %';

-- line 59: Transport (Scotland) Act 2001
--   this line 2001-01-25, dataset row 19 2001-01-23
UPDATE bill_candidate
   SET review_note = btrim(coalesce(review_note || E'\n', '') || 'Differs: date_royal_assent = 2001-01-23 (phd); this line gives 2001-01-25')
 WHERE candidate_id = 59
   AND coalesce(review_note, '') NOT LIKE '%Differs: date_royal_assent = 2001-01-23 %';

-- line 62: Water Industry (Scotland) Act 2002
--   this line 2001-09-26, dataset row 36 2001-09-25
UPDATE bill_candidate
   SET review_note = btrim(coalesce(review_note || E'\n', '') || 'Differs: date_introduced = 2001-09-25 (phd); this line gives 2001-09-26')
 WHERE candidate_id = 62
   AND coalesce(review_note, '') NOT LIKE '%Differs: date_introduced = 2001-09-25 %';

-- line 71: Robin Rigg Offshore Wind Farm (Navigation and Fishing) (Scotland) Bill
--   this line 2002-06-27, dataset row 60 2002-02-27
UPDATE bill_candidate
   SET review_note = btrim(coalesce(review_note || E'\n', '') || 'Differs: date_introduced = 2002-02-27 (phd); this line gives 2002-06-27')
 WHERE candidate_id = 71
   AND coalesce(review_note, '') NOT LIKE '%Differs: date_introduced = 2002-02-27 %';
UPDATE bill_candidate SET sources_compared_at = DATE '2026-09-12'
 WHERE session_number = 2;


-- line 129: Senior Judiciary (Vacancies and Incapacity) (Scotland) Act 2006
--   this line 2006-06-15, dataset row 139 2006-06-13
UPDATE bill_candidate
   SET review_note = btrim(coalesce(review_note || E'\n', '') || 'Differs: date_introduced = 2006-06-13 (phd); this line gives 2006-06-15')
 WHERE candidate_id = 129
   AND coalesce(review_note, '') NOT LIKE '%Differs: date_introduced = 2006-06-13 %';

-- line 134: Tourist Boards (Scotland) Act 2006
--   this line 2006-11-30, dataset row 134 2006-11-29
UPDATE bill_candidate
   SET review_note = btrim(coalesce(review_note || E'\n', '') || 'Differs: date_royal_assent = 2006-11-29 (phd); this line gives 2006-11-30')
 WHERE candidate_id = 134
   AND coalesce(review_note, '') NOT LIKE '%Differs: date_royal_assent = 2006-11-29 %';

-- ---------------------------------------------------------------------------
-- 3. The error checker: nothing admitted uncompared, no difference passed over
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
        (CASE WHEN s.date_dissolution IS NOT NULL AND f.passed_on IS NOT NULL
               AND f.passed_on > s.date_dissolution
              THEN 'passed after the session ended' END),
        (CASE WHEN s.date_dissolution IS NOT NULL AND c.date_concluded IS NOT NULL
               AND c.date_concluded > s.date_dissolution
              THEN 'concluded after the session ended' END)
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
 'One row per problem with a staging line or a stage-dates row. Empty before promotion, or the promotion will refuse the session. Extended at db/015; amended at db/020, where the date_concluded rule became a rule about enactment rather than about passing; at db/028 it also flags an SP Bill number or a stated introduced title left inside short_title; at db/031 it requires a route for every Stage 1 rejection, the announcement that route rests on, and the date the Official Report was read. At db/033 it reads the stage-dates staging sheet: the date checks moved there, and it checks that stage dates run in order, stage names fit the bill type, nothing comes after the stage a bill ended at, two sources for the same stage agree, and a stage completed on a date not known has a note. At db/039 it checks that a stage marked as one that did not happen belongs to a Private Bill, has no date, is not also completed or where the bill ended, and carries a note. A problem with a stage-dates row names the stage and its source, and gives the row in stage_candidate_id. At db/042 it requires a date that differs from the factsheet''s own printed words to carry a "Checked: ... = date (source, address, date read)" citation in review_note, so the factsheet is never overridden silently. At db/044 it requires every accepted line to have had its dates compared against the other sources, and requires a difference the comparison recorded to have been adjudicated before the session can be promoted. A missing date is not a problem; it is listed in v_stage_date_gaps.';

ALTER VIEW v_candidate_problems OWNER TO legdata;

-- ---------------------------------------------------------------------------
-- 4. What a reader is told
-- ---------------------------------------------------------------------------

UPDATE methodology_note
   SET body = body || E'\n\nEvery session''s dates are compared against every other source that states them when the session is loaded, and each line records the date that was done. Where the sources disagree, the difference is written on the line and the session cannot be published until it has been settled against the definitive source above. This is a check on the sources, not on the data entry: it finds the places where two published records of the same event do not match.'
 WHERE code = 'M8';

-- ---------------------------------------------------------------------------
-- 5. What should now be true
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM bill_candidate WHERE sources_compared_at IS NULL;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % line(s) are not stamped as compared.', n;
  END IF;

  SELECT count(*) INTO n FROM bill_candidate
   WHERE review_note LIKE '%Differs:%';
  IF n <> 7 THEN
    RAISE EXCEPTION 'Refusing: % line(s) record a difference, expected 7.', n;
  END IF;

  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: the error checker is not empty (% problem(s)).', n;
  END IF;
  RAISE NOTICE 'Sessions 1 and 2 compared: 154 lines stamped, 7 differences recorded, all adjudicated. Checker empty.';
END $$;

COMMIT;
