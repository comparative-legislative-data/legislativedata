-- 039_a_private_bill_can_skip_a_stage.sql
--
-- A stage record can say the bill never had this stage, because its procedure
-- skipped it. Settled with the owner on 2026-09-11, after the Session 2 Robin
-- Rigg Act showed as having two dates to find that do not exist: a Private Bill
-- reintroduced after falling does not repeat its earlier scrutiny, so that bill
-- went straight to its Final Stage.
--
-- Only a Private Bill may skip a stage. That is the only exception the Standing
-- Orders make, in the owner's words, so the clean sheet refuses the mark on a
-- Government, Member's, Committee or Hybrid Bill outright, the way it already
-- refuses a Stage 2 on a Private Bill.
--
-- What it does:
--   1. did_not_happen on the clean sheet's stage records and on the stage-dates
--      sheet. False is the ordinary case: the bill had this stage.
--   2. The clean sheet's rules: no date, not completed, not where the bill
--      ended, a note saying why, and a Private Bill.
--   3. The error checker flags the same things on the staging sheet, so they
--      are seen before promotion rather than as a refusal.
--   4. The gaps list stops expecting a date for a stage that never happened.
--   5. Methodology note M2 says what it means for durations.
--   6. The Session 2 Robin Rigg Act's Preliminary and Consideration Stages are
--      recorded this way, from the page the owner read. No other bill in
--      Sessions 1 and 2 is in this position, which this migration checks.

BEGIN;

-- ---------------------------------------------------------------------------
-- 1. The new mark
-- ---------------------------------------------------------------------------

ALTER TABLE stage_event
    ADD COLUMN did_not_happen boolean NOT NULL DEFAULT false;

ALTER TABLE stage_candidate
    ADD COLUMN did_not_happen boolean NOT NULL DEFAULT false;

COMMENT ON COLUMN stage_event.did_not_happen IS
 'True where the bill never had this stage, because its procedure skipped it: a Private Bill reintroduced after falling does not repeat its earlier scrutiny. Only a Private Bill may have it. Such a row has no date, is neither completed nor where the bill ended, and must carry a note saying why; the database refuses it otherwise. False, the ordinary case, means the bill had this stage.';

COMMENT ON COLUMN stage_candidate.did_not_happen IS
 'True where the bill never had this stage, because its procedure skipped it, as on stage_event. Nothing in this table enforces the rules that go with it: the error checker flags a breach, and stage_event refuses one. False, the ordinary case, means the bill had this stage.';

-- ---------------------------------------------------------------------------
-- 2. What the clean sheet refuses
-- ---------------------------------------------------------------------------

ALTER TABLE stage_event
    ADD CONSTRAINT stage_event_did_not_happen_is_empty_and_noted
    CHECK (NOT did_not_happen
           OR (date_completed IS NULL AND completed IS FALSE AND fell_here IS FALSE
               AND nullif(btrim(note), '') IS NOT NULL));

-- Only a Private Bill may skip a stage. The bill type lives on bill, so this
-- goes where db/018 already checks the stage name against the bill type.
CREATE OR REPLACE FUNCTION stage_event_check_type() RETURNS trigger AS $$
DECLARE
    bt text;
BEGIN
    SELECT bill_type INTO bt FROM bill WHERE bill_id = NEW.bill_id;

    -- A bill whose type is not yet known cannot have its stages checked. Let it
    -- through rather than blocking; the candidate problems view is where an
    -- unknown type is chased.
    IF bt IS NULL THEN
        RETURN NEW;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM ref_bill_type_stage r
                    WHERE r.bill_type = bt
                      AND r.stage = NEW.stage
                      AND r.stage_order = NEW.stage_order) THEN
        RAISE EXCEPTION
          'a % bill has no stage % at position % — see ref_bill_type_stage',
          bt, quote_literal(NEW.stage), NEW.stage_order;
    END IF;

    -- Added at db/039: only a Private Bill may skip a stage.
    IF NEW.did_not_happen AND bt <> 'private' THEN
        RAISE EXCEPTION
          'a % bill cannot skip a stage: only a Private Bill may, and only where it was reintroduced — see methodology note M2',
          bt;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ---------------------------------------------------------------------------
-- 3. The error checker, as db/033 left it, with the new mark's rules
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
)
SELECT * FROM line_checks WHERE problem IS NOT NULL
UNION ALL
SELECT * FROM stage_checks WHERE problem IS NOT NULL;

COMMENT ON VIEW v_candidate_problems IS
 'One row per problem with a staging line or a stage-dates row. Empty before promotion, or the promotion will refuse the session. Extended at db/015; amended at db/020, where the date_concluded rule became a rule about enactment rather than about passing; at db/028 it also flags an SP Bill number or a stated introduced title left inside short_title; at db/031 it requires a route for every Stage 1 rejection, the announcement that route rests on, and the date the Official Report was read. At db/033 it reads the stage-dates staging sheet: the date checks moved there, and it checks that stage dates run in order, stage names fit the bill type, nothing comes after the stage a bill ended at, two sources for the same stage agree, and a stage completed on a date not known has a note. At db/039 it checks that a stage marked as one that did not happen belongs to a Private Bill, has no date, is not also completed or where the bill ended, and carries a note. A problem with a stage-dates row names the stage and its source, and gives the row in stage_candidate_id. A missing date is not a problem; it is listed in v_stage_date_gaps.';

-- ---------------------------------------------------------------------------
-- 4. The gaps list stops expecting a date for a stage that never happened
-- ---------------------------------------------------------------------------

CREATE OR REPLACE VIEW v_stage_date_gaps AS
WITH lines AS (
    SELECT c.candidate_id, c.session_number, c.short_title, c.bill_type, c.outcome
      FROM bill_candidate c
     WHERE c.review_status <> 'rejected'
),
stage_rows AS (
    SELECT t.* FROM stage_candidate t WHERE t.review_status <> 'rejected'
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
UNION ALL
-- A bill that did not pass, with nothing recording where it ended.
SELECT l.candidate_id, l.session_number, l.short_title, l.bill_type, l.outcome,
       NULL, NULL, 'where the bill ended is not recorded'
  FROM lines l
 WHERE l.outcome IS NOT NULL AND l.outcome NOT IN ('passed', 'in_progress')
   AND NOT EXISTS (SELECT 1 FROM ended e WHERE e.candidate_id = l.candidate_id)
ORDER BY 2, 1, 6;

COMMENT ON VIEW v_stage_date_gaps IS
 'The gaps to fill in stage dates, read from the staging sheets: one row per missing date. A bill that passed should have a date for each of its three stages, and a bill that ended early a date for each stage before the one it ended at. A stage completed on a date not known is listed with its note, and a bill that did not pass is listed if nothing records where it ended. A stage a bill never had, because its procedure skipped it, is not listed at all (db/039). A gap does not stop promotion (DECISIONS.md, 2026-09-11); a contradiction does, and is in v_candidate_problems instead. Lines and rows rejected at review are left out.';

-- ---------------------------------------------------------------------------
-- 5. What a reader is told
-- ---------------------------------------------------------------------------

UPDATE methodology_note
   SET body = body || E'\n\n' ||
       'A Private Bill reintroduced after falling does not repeat its earlier scrutiny. A stage '
       'such a bill never had is recorded as a stage that did not happen, with no date and a note '
       'saying why, and it is not counted as a date still to find. Only a Private Bill may skip a '
       'stage: for every other kind of bill the database refuses the record. A stage that never '
       'happened gives no duration, so such a bill gives a time from introduction to passing but '
       'no figure for that stage.'
 WHERE code = 'M2';

-- ---------------------------------------------------------------------------
-- 6. The Session 2 Robin Rigg Act
-- ---------------------------------------------------------------------------
--
-- Established by the owner from the Parliament's page for the bill, read on
-- 2026-09-11 and quoted in DECISIONS.md. The same page is already the source of
-- the note on the bill itself. These rows are admitted here, as db/038 admitted
-- the rest: the owner settled what they say before they were written.

INSERT INTO stage_candidate (candidate_id, stage, date_completed, completed, fell_here,
                             did_not_happen, source, source_ref, observed_at, note,
                             review_status, reviewed_at)
SELECT 124, s.stage, NULL, false, false, true, 'bill_document',
       'https://webarchive.nrscotland.gov.uk/public/+/http://archive2021.parliament.scot/parliamentarybusiness/Bills/24953.aspx',
       DATE '2026-09-11',
       'The bill was reintroduced in Session 2 after falling at dissolution, and a reintroduced Private Bill does not repeat its earlier scrutiny, so it never had this stage. The Session 1 bill''s Preliminary Stage was on 9 January 2003.',
       'accepted', now()
  FROM ref_bill_type_stage s
 WHERE s.bill_type = 'private' AND s.stage_order IN (1, 2)
 ORDER BY s.stage_order;

-- ---------------------------------------------------------------------------
-- Checks
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM stage_candidate WHERE did_not_happen;
  IF n <> 2 THEN RAISE EXCEPTION 'Expected 2 skipped stages, found %.', n; END IF;

  SELECT count(*) INTO n FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
   WHERE t.did_not_happen AND c.bill_type <> 'private';
  IF n > 0 THEN RAISE EXCEPTION '% skipped stage(s) are not on a Private Bill.', n; END IF;

  SELECT count(*) INTO n FROM stage_candidate WHERE review_status <> 'accepted';
  IF n > 0 THEN RAISE EXCEPTION '% stage-dates row(s) are not accepted.', n; END IF;

  -- No other bill in Sessions 1 and 2 passed without all three stages recorded.
  SELECT count(*) INTO n
    FROM bill_candidate c
   WHERE c.outcome = 'passed'
     AND (SELECT count(*) FROM stage_candidate t
           WHERE t.candidate_id = c.candidate_id
             AND (t.date_completed IS NOT NULL OR t.did_not_happen)) <> 3;
  IF n > 0 THEN
    RAISE EXCEPTION '% bill(s) that passed still lack a record for every stage.', n;
  END IF;

  SELECT count(*) INTO n FROM v_stage_date_gaps;
  IF n > 0 THEN RAISE EXCEPTION 'The gaps list still holds % row(s).', n; END IF;

  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n > 0 THEN RAISE EXCEPTION 'The error checker finds % problem(s).', n; END IF;

  IF NOT EXISTS (SELECT 1 FROM methodology_note
                  WHERE code = 'M2' AND body LIKE '%does not repeat its earlier scrutiny%') THEN
    RAISE EXCEPTION 'M2 was not extended as expected.';
  END IF;

  RAISE NOTICE 'Two skipped stages recorded, the gaps list empty, the error checker empty.';
END $$;

-- Postico's user can read the rebuilt lists.
SET LOCAL ROLE legdata;
SELECT (SELECT count(*) FROM stage_candidate)      AS stage_date_rows,
       (SELECT count(*) FROM v_stage_date_gaps)    AS gaps,
       (SELECT count(*) FROM v_candidate_problems) AS problems;
RESET ROLE;

COMMIT;
