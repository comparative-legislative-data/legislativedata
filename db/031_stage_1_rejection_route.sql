-- 031_stage_1_rejection_route.sql
--
-- How the Parliament came to reject a bill at Stage 1, as a variable of its
-- own. Every part was settled with the owner before this was written;
-- DECISIONS.md, 2026-09-11, "A Rule 9.14.18 motion is a Stage 1 vote reached by
-- another route", and the rule recorded the same day that a change to how data
-- is coded is finished before anything moves on.
--
-- Structure only. The routes themselves are recorded in db/032.
--
-- PRECONDITION: Session 1 must be off the clean sheet. The bill gains a rule
-- that every bill rejected at Stage 1 has a route, and Session 1's five were
-- promoted before routes existed. They come off (tools/rollback_promotion.sql),
-- this and db/032 run, and they go back on. This migration refuses to run
-- otherwise, rather than failing halfway with a less helpful message.
--
-- What it adds:
--   1. A dropdown list of three routes.
--   2. The route on the bill, beside the outcome it qualifies, with two rules:
--      a bill rejected at Stage 1 has a route and no other bill does; and the
--      9.14.18 route only on a Member's Bill, which is all the rule covers.
--   3. Three columns on the staging sheet: the route; a note to carry onto
--      bill.note, which until now nothing could fill; and the date the Official
--      Report was read, because Official Report facts were being dated by when
--      the factsheet was read.
--   4. The error checker's matching requirements.
--   5. Methodology note M7: a paragraph on the routes, and its count of coded
--      sessions brought up to date.

BEGIN;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM bill WHERE outcome = 'rejected_stage_1') THEN
    RAISE EXCEPTION 'Refusing to run: bills rejected at Stage 1 are on the clean sheet without a route. Take their session off with tools/rollback_promotion.sql first.';
  END IF;
END $$;

-- ---------------------------------------------------------------------------
-- 1. The dropdown list
-- ---------------------------------------------------------------------------

CREATE TABLE ref_stage_1_rejection_route (
    code        text PRIMARY KEY,
    label       text NOT NULL,
    definition  text,
    sort_order  integer NOT NULL DEFAULT 0
);

-- Owned by legdata, like the other dropdown lists and the error checker.
-- Migrations run as postgres, so anything they create belongs to postgres
-- unless told otherwise, and the checker, which reads with its owner's
-- permissions, was refused this table in rehearsal.
ALTER TABLE ref_stage_1_rejection_route OWNER TO legdata;

INSERT INTO ref_stage_1_rejection_route (code, label, definition, sort_order) VALUES
 ('member_motion_disagreed',
  'Motion of the member in charge, disagreed to',
  'The member in charge of the Bill moved that the Parliament agree to its general principles, and the Parliament disagreed to that motion. The usual way a bill is rejected at Stage 1.',
  1),
 ('member_motion_amended_agreed',
  'Motion of the member in charge, amended to reject the general principles, agreed to as amended',
  'The member in charge moved that the Parliament agree to the general principles; an amendment turned the motion into one that did not agree to them; and the Parliament agreed to the motion as amended. The amendment, who moved it and the reason the resolution gives are in bill.note.',
  2),
 ('committee_motion_9_14_18',
  'Committee motion under Rule 9.14.18, agreed to',
  'The convener of the lead committee moved, under Rule 9.14.18, that the general principles of a Member''s Bill not be agreed to, and the Parliament agreed. The rule lets the committee recommend this where, in its opinion, (a) the consultation or published material does not demonstrate a reasonable case for the policy objectives or that legislation is needed; (b) the Bill appears clearly outwith legislative competence and is unlikely to be brought within it by amendment at Stages 2 and 3; or (c) its drafting is too deficient to be put right by amendment. The motion does not state which; our view, where the grounds allow one, is in bill.note. Cited as numbered and worded in the current Standing Orders, taken to be unchanged since 2006.',
  3);

COMMENT ON TABLE ref_stage_1_rejection_route IS
 'How the Parliament came to reject a bill''s general principles at Stage 1. Every allowed value for bill.stage_1_rejection_route is a row here, with its own definition, so a value can be added or re-labelled without changing the schema and so each one carries the text explaining it to a reader. See methodology note M7.';
COMMENT ON COLUMN ref_stage_1_rejection_route.code IS
 'The short word stored in bill.stage_1_rejection_route and used in queries. Readable on purpose, so a row shows "committee_motion_9_14_18" rather than a number that has to be looked up.';
COMMENT ON COLUMN ref_stage_1_rejection_route.label IS
 'The full name to show a reader, e.g. "Committee motion under Rule 9.14.18, agreed to". The code is what queries and data files use; this is what a person sees on screen.';
COMMENT ON COLUMN ref_stage_1_rejection_route.definition IS
 'What this route means, in the Parliament''s terms. This is the text to show a reader who asks what a value means, and it is the reason the allowed values live in a table rather than as a bare list inside the schema.';
COMMENT ON COLUMN ref_stage_1_rejection_route.sort_order IS
 'The order to list these values in on screen. A display choice, not a fact about the route.';

-- ---------------------------------------------------------------------------
-- 2. The route on the bill
-- ---------------------------------------------------------------------------

ALTER TABLE bill
  ADD COLUMN stage_1_rejection_route text REFERENCES ref_stage_1_rejection_route;

ALTER TABLE bill
  ADD CONSTRAINT bill_route_for_every_stage_1_rejection_and_no_other
  CHECK ((outcome = 'rejected_stage_1') = (stage_1_rejection_route IS NOT NULL));

ALTER TABLE bill
  ADD CONSTRAINT bill_route_9_14_18_only_on_a_members_bill
  CHECK (stage_1_rejection_route IS DISTINCT FROM 'committee_motion_9_14_18'
         OR bill_type = 'members');

COMMENT ON COLUMN bill.stage_1_rejection_route IS
 'How the Parliament came to reject the bill''s general principles at Stage 1: the member in charge''s motion disagreed to; that motion amended to reject them and agreed to; or a committee motion under Rule 9.14.18 agreed to. Allowed values are in ref_stage_1_rejection_route. Filled for every bill whose outcome is rejected_stage_1 and for no other, and the database enforces both halves, so empty means only that the bill was not rejected at Stage 1. The 9.14.18 route is refused on anything but a Member''s Bill. Our coding against the Official Report; see methodology note M7.';

COMMENT ON COLUMN bill.note IS
 'Free text for anything irregular about this bill that a reader should see, carried from bill_candidate.bill_note at promotion. Where a rename date goes, where the reason a bill was blocked goes, and, for a bill rejected at Stage 1 by an unusual route, the amendment that did it or our view of which limb of Rule 9.14.18 applied. Empty means nothing irregular has been recorded.';

-- ---------------------------------------------------------------------------
-- 3. The staging sheet
-- ---------------------------------------------------------------------------

ALTER TABLE bill_candidate ADD COLUMN stage_1_rejection_route text;
ALTER TABLE bill_candidate ADD COLUMN bill_note text;
ALTER TABLE bill_candidate ADD COLUMN official_report_read_on date;

COMMENT ON COLUMN bill_candidate.stage_1_rejection_route IS
 'How the Parliament came to reject the bill''s general principles at Stage 1, read from the Official Report at review; no factsheet states it. Should be a code from ref_stage_1_rejection_route. Nothing in this table enforces that, but bill.stage_1_rejection_route does. The error checker requires it on every line whose outcome is rejected_stage_1 and refuses it on any other. The Presiding Officer''s announcement it rests on is quoted in review_note after "Result as recorded:", and becomes the provenance note''s value seen at promotion.';

COMMENT ON COLUMN bill_candidate.bill_note IS
 'The note to carry onto bill.note at promotion: anything irregular about the bill that a reader of the published data should see. Not the same as review_note, which is the reviewer''s reasoning and stays on this sheet. Empty means there is nothing to carry.';

COMMENT ON COLUMN bill_candidate.official_report_read_on IS
 'The date the Official Report was read for this line, for its outcome, its Stage 1 date or its Stage 1 rejection route. Promotion dates the provenance of those facts by this, not by observed_at, which is when the factsheet was read. Empty means nothing on this line came from the Official Report; the error checker requires it whenever something did.';

-- ---------------------------------------------------------------------------
-- 4. The error checker
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
        (CASE WHEN (c.end_stage_1_date IS NOT NULL
                    OR c.stage_1_rejection_route IS NOT NULL
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
 'One row per problem with a candidate. Empty before promotion, or the promotion will refuse the row. Extended at db/015; amended at db/020, where the date_concluded rule became a rule about enactment rather than about passing; at db/028 it also flags an SP Bill number or a stated introduced title left inside short_title; at db/031 it requires a route for every Stage 1 rejection, the announcement that route rests on, and the date the Official Report was read.';

-- ---------------------------------------------------------------------------
-- 5. Methodology note M7
-- ---------------------------------------------------------------------------

UPDATE methodology_note
   SET body = replace(body,
         'at the time of writing it has been done for the five fallen bills of Session 1, all of which were rejected at Stage 1 rather than lost at dissolution',
         'at the time of writing it has been done for Sessions 1 and 2, where every bill that fell before the dissolution date was in fact rejected at Stage 1 rather than lost to the calendar')
       || E'\n\n'
       || 'For every bill rejected at Stage 1, bill.stage_1_rejection_route records how the Parliament came to reject its general principles, and this too is our coding against the Official Report. Usually the member in charge moved that the general principles be agreed to and the Parliament disagreed. A bill can also be rejected by the Parliament agreeing to the member in charge''s own motion after it has been amended so as not to agree to the general principles, as happened to the Proportional Representation (Local Government Elections) (Scotland) Bill in February 2003; or by the Parliament agreeing to a motion of the lead committee, under Rule 9.14.18, that the general principles of a Member''s Bill not be agreed to. That rule allows the committee to recommend rejection where, in its opinion, (a) the consultation or published material does not demonstrate a reasonable case for the bill''s policy objectives or that legislation is needed, (b) the bill is clearly outwith legislative competence and unlikely to be brought within it by amendment, or (c) its drafting is too deficient to be put right by amendment. The motion does not say which of these applied. Where the committee''s stated grounds allow a view, it is given in bill.note, and it is our reading of those grounds rather than a recorded fact. The rule is cited as numbered and worded in the current Standing Orders; earlier editions are not published, and it is taken to be unchanged since 2006.',
       applies_to = applies_to || ARRAY['bill.stage_1_rejection_route', 'bill.note']
 WHERE code = 'M7';

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM methodology_note
                  WHERE code = 'M7'
                    AND body LIKE '%done for Sessions 1 and 2%'
                    AND body NOT LIKE '%five fallen bills of Session 1%'
                    AND body LIKE '%Rule 9.14.18%') THEN
    RAISE EXCEPTION 'M7 was not updated as expected: its wording no longer matches what this migration looks for.';
  END IF;
END $$;

COMMIT;
