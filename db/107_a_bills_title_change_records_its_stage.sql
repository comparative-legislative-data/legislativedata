-- db/107_a_bills_title_change_records_its_stage.sql
--
-- Settled by the owner on 2026-09-17, with every part agreed before this was
-- written (docs/PHASE-2-NOTES.md, "M3").
--
-- WHAT WAS WRONG. M3 said the date of a known rename is recorded in the bill's
-- note. None was. Three bills carried the title they were introduced under and
-- nothing about when it changed, and a fourth, the Buildings (Recovery of
-- Expenses) (Scotland) Act 2014, carried nothing at all: the Session 4 fact
-- sheet gives its earlier title in footnote 1, and the reader removed the
-- footnote's marker from the title and kept neither the footnote nor the title
-- it names. The full text of all seven fact sheets was searched on 2026-09-17:
-- these four are every title change the fact sheets state.
--
-- WHAT IS RECORDED. The same bill throughout, as before. Its final title and
-- the title it was introduced under, as before, and now the stage at which the
-- title changed. Not the date: the owner, 2026-09-17, "changes to bill titles
-- are always taken at the end (so that they're done once)", so the date of the
-- change is the date that stage ended, which is already held. Storing it again
-- would be a second copy of one fact. M3 tells a reader so.
--
-- THE FOUR, and what says which stage:
--   * 127, Scottish Commission for Human Rights Act 2006, Stage 3. The
--     Parliament's archived bill page: the Executive's amendments changing the
--     Commissioner to a Commission failed at Stage 2 and succeeded at Stage 3.
--   * 231, Buildings (Recovery of Expenses) (Scotland) Act 2014, Stage 2. The
--     archived bill page: "After stage 2 consideration of the Bill, the short
--     title of the Bill was changed ... to reflect amendments made to the Bill
--     at Stage 2."
--   * 423, Care Reform (Scotland) Act 2025, Stage 2, and 406, Scottish
--     Parliament (Recall of Members) Bill, Stage 3. The Session 6 fact sheet
--     dates each rename, 4 March 2025 and 24 February 2026, and those are the
--     days those stages ended.
-- Both bill pages were read by the owner on 2026-09-17.
--
-- LINE 231'S TWO RAW CELLS. raw_footnote is filled with footnote 1's words as
-- the Session 4 fact sheet prints them, and title_as_introduced with the title
-- it names. A raw cell records what the fact sheet said and is never edited;
-- this fills one the reader failed to fill, from the same page. The fault is in
-- tools/extract_factsheet.py's handling of that footnote, recorded here and in
-- STATE.md; every session is read in, so it will not run on these sheets again.
--
-- THE CHECKER learns five rules, in title_checks. Everything else in its
-- definition is as it stood; the rehearsal compares the old and new definitions
-- as text. THE CLEAN SHEET refuses a stage not on the list of stages, and a
-- stage with no title as introduced.
--
-- NOTHING ELSE CHANGES on the staging sheet. The clean sheet changes when
-- Sessions 2 and 4, and 7, 6 and 5, are taken off and put back.

\set ON_ERROR_STOP on
BEGIN;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM information_schema.columns
   WHERE table_name IN ('bill', 'bill_candidate') AND column_name = 'title_changed_at_stage';
  IF n > 0 THEN RAISE EXCEPTION 'Refusing: title_changed_at_stage already exists.'; END IF;

  SELECT count(*) INTO n FROM bill_candidate WHERE title_as_introduced IS NOT NULL;
  IF n <> 3 THEN RAISE EXCEPTION 'Refusing: % lines carry a title as introduced, expected 3.', n; END IF;

  SELECT count(*) INTO n FROM bill_candidate
   WHERE candidate_id = 231 AND session_number = 4 AND title_as_introduced IS NULL
     AND raw_footnote IS NULL AND raw_title LIKE 'Buildings (Recovery of Expenses) (Scotland) Act 20141%';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: line 231 is not as it was.'; END IF;

  SELECT count(*) INTO n FROM methodology_note
   WHERE code = 'M3' AND body LIKE '%the date of it is recorded in bill.note%';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: M3 is not the wording this replaces.'; END IF;

  SELECT count(*) INTO n FROM bill;
  IF n <> 470 THEN RAISE EXCEPTION 'Refusing: % bills, expected 470.', n; END IF;
  SELECT count(*) INTO n FROM field_source;
  IF n <> 188 THEN RAISE EXCEPTION 'Refusing: % provenance notes, expected 188.', n; END IF;
END $$;

-- ---------------------------------------------------------------------------
-- 1. The cells
-- ---------------------------------------------------------------------------

ALTER TABLE bill ADD COLUMN title_changed_at_stage text REFERENCES ref_stage (code);

COMMENT ON COLUMN bill.title_changed_at_stage IS
 'The stage at which the bill''s title changed from title_as_introduced to the title it ended with. A title is changed at the end of a stage, so the date of the change is the date that stage ended, held on the bill''s stage record and not stored again here. Filled wherever title_as_introduced is filled. Empty means no change of title is known. A bill renamed more than once would hold the stage of the last change, with the earlier one in its note. See methodology note M3.';

ALTER TABLE bill ADD CONSTRAINT bill_title_change_needs_an_introduced_title
  CHECK (title_changed_at_stage IS NULL OR title_as_introduced IS NOT NULL);

ALTER TABLE bill_candidate ADD COLUMN title_changed_at_stage text;

COMMENT ON COLUMN bill_candidate.title_changed_at_stage IS
 'Proposed value for bill.title_changed_at_stage: the stage at which the bill''s title changed, filled at review from a source that says so, with a "Checked: title_changed_at_stage = ..." citation in review_note, which promotion turns into the provenance note. Should be a code from ref_stage that the line''s kind of bill has; the error checker requires that, a dated stage row for it, and the citation, and refuses a title as introduced with this empty. Empty means no change of title is known. Carried to the clean sheet at promotion.';

COMMENT ON COLUMN bill.note IS
 'Free text for anything irregular about this bill that a reader should see, carried from bill_candidate.bill_note at promotion. Where the reason a bill was blocked goes, and, for a bill rejected at Stage 1 by an unusual route, the amendment that did it or our view of which limb of Rule 9.14.18 applied. Not where a change of title goes: that is title_as_introduced and title_changed_at_stage, since db/107. Empty means nothing irregular has been recorded.';

COMMENT ON COLUMN bill.title_as_introduced IS
 'The title the bill had when it was introduced. Empty means not known, which is the usual case. Empty never means the title did not change. Where it is filled, title_changed_at_stage says at which stage it changed.';

-- ---------------------------------------------------------------------------
-- 2. The checker
-- ---------------------------------------------------------------------------

CREATE OR REPLACE VIEW v_candidate_problems AS
 WITH stage_rows AS (
         SELECT t.stage_candidate_id,
            t.candidate_id,
            t.short_title,
            t.stage,
            t.stage_order,
            t.date_completed,
            t.completed,
            t.fell_here,
            t.source,
            t.source_ref,
            t.observed_at,
            t.detail_note,
            t.review_status,
            t.review_note,
            t.reviewed_at,
            t.promoted_stage_event_id,
            t.promoted_at,
            t.created_at,
            t.updated_at,
            t.did_not_happen,
            t.date_reached,
            c.session_number,
            c.bill_type,
            c.outcome,
            c.date_introduced,
            c.date_royal_assent,
            c.date_concluded,
            COALESCE(rs.label, t.stage, 'The stage at position '::text || COALESCE(t.stage_order::text, '?'::text)) AS stage_label
           FROM stage_candidate t
             JOIN bill_candidate c USING (candidate_id)
             LEFT JOIN ref_stage rs ON rs.code = t.stage
          WHERE t.review_status <> 'rejected'::text
        ), line_checks AS (
         SELECT c.candidate_id,
            c.session_number,
            c.short_title,
            c.review_status,
            p.problem,
            NULL::integer AS stage_candidate_id
           FROM bill_candidate c
             LEFT JOIN bill cb ON cb.bill_id = c.continues_bill_id
             LEFT JOIN session s ON s.session_number = COALESCE(cb.session_number, c.session_number)
             LEFT JOIN LATERAL ( SELECT max(r.date_completed) FILTER (WHERE r.stage_order = 3 AND r.completed) AS passed_on
                   FROM stage_rows r
                  WHERE r.candidate_id = c.candidate_id) f ON true
             CROSS JOIN LATERAL ( VALUES (
                        CASE
                            WHEN c.short_title IS NULL OR btrim(c.short_title) = ''::text THEN 'short_title is empty'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.session_number IS NULL THEN 'session_number is null'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.session_number IS NOT NULL AND s.session_number IS NULL THEN ('session_number '::text || c.session_number) || ' has no session row'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.bill_type IS NULL THEN 'bill_type not proposed'::text
                            WHEN NOT (EXISTS ( SELECT 1
                               FROM ref_bill_type r
                              WHERE r.code = c.bill_type)) THEN ('bill_type '::text || quote_literal(c.bill_type)) || ' is not in ref_bill_type'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.procedure IS NOT NULL AND NOT (EXISTS ( SELECT 1
                               FROM ref_procedure r
                              WHERE r.code = c.procedure)) THEN ('procedure '::text || quote_literal(c.procedure)) || ' is not in ref_procedure'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.outcome IS NULL THEN 'outcome not proposed — needs a judgement'::text
                            WHEN NOT (EXISTS ( SELECT 1
                               FROM ref_outcome r
                              WHERE r.code = c.outcome)) THEN ('outcome '::text || quote_literal(c.outcome)) || ' is not in ref_outcome'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.enactment_status IS NULL THEN 'enactment_status not proposed'::text
                            WHEN NOT (EXISTS ( SELECT 1
                               FROM ref_enactment_status r
                              WHERE r.code = c.enactment_status)) THEN ('enactment_status '::text || quote_literal(c.enactment_status)) || ' is not in ref_enactment_status'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.source IS NOT NULL AND NOT (EXISTS ( SELECT 1
                               FROM ref_source r
                              WHERE r.code = c.source)) THEN ('source '::text || quote_literal(c.source)) || ' is not in ref_source'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.date_concluded IS NOT NULL AND c.date_introduced IS NOT NULL AND c.date_concluded < c.date_introduced THEN 'concluded before it was introduced'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.raw_date_introduced IS NOT NULL AND c.date_introduced IS NULL THEN 'date_introduced unparsed: '::text || quote_literal(c.raw_date_introduced)
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.raw_date_royal_assent IS NOT NULL AND c.date_royal_assent IS NULL THEN 'royal assent unparsed: '::text || quote_literal(c.raw_date_royal_assent)
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.raw_date_final IS NOT NULL AND f.passed_on IS NULL AND c.date_concluded IS NULL THEN 'final date unparsed: '::text || quote_literal(c.raw_date_final)
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.enactment_status = 'enacted'::text AND c.date_royal_assent IS NULL THEN 'enacted but no Royal Assent date'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.outcome <> 'passed'::text AND c.enactment_status = 'enacted'::text THEN 'enacted but outcome is not passed'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.enactment_status = 'enacted'::text AND c.date_concluded IS NOT NULL THEN ('enacted, but date_concluded is set — a bill that received '::text || 'Royal Assent concluded at Royal Assent; bill''s CHECK '::text) || 'constraint would refuse this row'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.outcome IS NOT NULL AND (c.outcome <> ALL (ARRAY['passed'::text, 'in_progress'::text])) AND c.date_concluded IS NULL THEN 'did not pass, but has no date_concluded'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.outcome = 'passed'::text AND f.passed_on IS NULL THEN 'passed, but has no Stage 3 date'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.bill_type_stated IS NULL THEN 'bill_type_stated not proposed'::text
                            WHEN NOT (EXISTS ( SELECT 1
                               FROM ref_bill_type_stated r
                              WHERE r.code = c.bill_type_stated)) THEN ('bill_type_stated '::text || quote_literal(c.bill_type_stated)) || ' is not in ref_bill_type_stated'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.title_kind IS NOT NULL AND (c.title_kind <> ALL (ARRAY['act'::text, 'bill'::text])) THEN ('title_kind '::text || quote_literal(c.title_kind)) || ' is not act or bill'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.enactment_status = 'enacted'::text AND c.title_kind IS DISTINCT FROM 'act'::text THEN 'enacted, but title_kind is not act — see methodology note M3'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.enactment_status IS DISTINCT FROM 'enacted'::text AND c.title_kind = 'act'::text THEN 'title_kind is act, but the bill was not enacted'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.enactment_status = 'enacted'::text AND c.asp_number IS NULL THEN 'enacted, but no asp_number'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.asp_number IS NOT NULL AND "substring"(c.asp_number, '^\d{4}'::text) IS NULL THEN 'asp_number carries no year: the factsheet printed none, so it must be settled from legislation.gov.uk before this line is admitted'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.asp_number IS NOT NULL AND c.date_royal_assent IS NOT NULL AND "substring"(c.asp_number, '^\d{4}'::text) <> to_char(c.date_royal_assent::timestamp with time zone, 'YYYY'::text) THEN 'asp_number year does not match the year of Royal Assent'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.enactment_status = 'enacted'::text AND c.short_title !~ '\d{4}$'::text THEN 'enacted, but short_title carries no year: an Act''s title ends in its year, and the fact sheet printed this one short, so it must be settled from legislation.gov.uk before this line is admitted'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.short_title ~* '\masp\M'::text THEN 'short_title still contains the asp number'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.short_title ~* '\mSP\s*Bill\s*\d'::text THEN 'short_title still contains the SP Bill number'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.short_title ~* '\mintroduced as\M'::text THEN 'short_title still contains a stated introduced title'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.stage_1_rejection_route IS NOT NULL AND NOT (EXISTS ( SELECT 1
                               FROM ref_stage_1_rejection_route r
                              WHERE r.code = c.stage_1_rejection_route)) THEN ('stage_1_rejection_route '::text || quote_literal(c.stage_1_rejection_route)) || ' is not in ref_stage_1_rejection_route'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.outcome = 'rejected_stage_1'::text AND c.stage_1_rejection_route IS NULL THEN 'rejected at Stage 1, but no route to the rejection is recorded'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.stage_1_rejection_route IS NOT NULL AND c.outcome IS DISTINCT FROM 'rejected_stage_1'::text THEN 'a route to a Stage 1 rejection is recorded, but the outcome is not '::text || 'rejected at Stage 1'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.stage_1_rejection_route = 'committee_motion_9_14_18'::text AND c.bill_type IS DISTINCT FROM 'members'::text THEN 'Rule 9.14.18 route recorded on a bill that is not a Member''s Bill'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.stage_1_rejection_route = 'other_route'::text AND COALESCE(btrim(c.bill_note), ''::text) = ''::text THEN 'the route is recorded as some other route, but bill_note does '::text || 'not say what happened or what its effect was'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.stage_1_rejection_route IS NOT NULL AND COALESCE(c.review_note, ''::text) !~ 'Result as recorded: "[^"]+"'::text THEN 'a route is recorded, but review_note does not quote the Presiding '::text || 'Officer''s announcement after "Result as recorded:"'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN (c.stage_1_rejection_route IS NOT NULL OR c.review_note ~~* 'Outcome from the Official Report%'::text) AND c.official_report_read_on IS NULL THEN 'something on this line came from the Official Report, but '::text || 'official_report_read_on is empty'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN (c.stage_1_rejection_route IS NOT NULL OR c.review_note ~~* 'Outcome from the Official Report%'::text) AND COALESCE(c.review_note, ''::text) !~ 'https?://'::text THEN ('something on this line came from the Official Report, but '::text || 'review_note carries no address for the page it was read '::text) || 'on, so promotion has nothing to cite'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.date_royal_assent IS NOT NULL AND c.date_royal_assent IS DISTINCT FROM factsheet_date(c.raw_date_royal_assent) AND COALESCE(c.review_note, ''::text) !~ 'Checked: date_royal_assent = \d{4}-\d{2}-\d{2} \([^)]+\)'::text THEN (('date_royal_assent '::text ||
                            CASE
                                WHEN c.raw_date_royal_assent IS NULL THEN 'fills a cell the fact sheet left empty'::text
                                ELSE ('differs from the factsheet''s own words ('::text || c.raw_date_royal_assent) || ')'::text
                            END) || ', but review_note carries no '::text) || '"Checked: date_royal_assent = ..." citation'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.date_introduced IS NOT NULL AND c.date_introduced IS DISTINCT FROM factsheet_date(c.raw_date_introduced) AND COALESCE(c.review_note, ''::text) !~ 'Checked: date_introduced = \d{4}-\d{2}-\d{2} \([^)]+\)'::text THEN (('date_introduced '::text ||
                            CASE
                                WHEN c.raw_date_introduced IS NULL THEN 'fills a cell the fact sheet left empty'::text
                                ELSE ('differs from the factsheet''s own words ('::text || c.raw_date_introduced) || ')'::text
                            END) || ', but review_note carries no '::text) || '"Checked: date_introduced = ..." citation'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.review_status = 'accepted'::text AND c.sources_compared_at IS NULL THEN 'accepted, but its dates have never been compared against the '::text || 'other sources: run tools/compare_sources.py'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.enactment_status = 'blocked'::text AND c.outcome IS DISTINCT FROM 'passed'::text THEN ('recorded as blocked, but the outcome is '::text || COALESCE(quote_literal(c.outcome), 'null'::text)) || ' — only a bill that passed can be stopped before Royal Assent'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.enactment_status = 'blocked'::text AND COALESCE(btrim(c.bill_note), ''::text) = ''::text THEN ('recorded as blocked, but bill_note does not say what stopped '::text || 'it, so a reader would be told the bill is blocked and not '::text) || 'why — see methodology note M5'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.enactment_status = 'blocked'::text AND COALESCE(btrim(c.raw_footnote), ''::text) = ''::text AND COALESCE(c.review_note, ''::text) !~ 'Checked: enactment_status = '::text THEN ('recorded as blocked, but the line carries neither the fact '::text || 'sheet''s own words saying so nor a "Checked: '::text) || 'enactment_status = ..." citation'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN (c.enactment_status = ANY (ARRAY['blocked'::text, 'pending'::text])) AND c.date_concluded IS NOT NULL THEN ((('recorded as '::text || c.enactment_status) || ', so still a live bill, '::text) || 'but it has an ending date of '::text) || c.date_concluded
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN (c.enactment_status = ANY (ARRAY['blocked'::text, 'pending'::text])) AND c.date_royal_assent IS NOT NULL THEN ((('recorded as '::text || c.enactment_status) || ', but it has a Royal '::text) || 'Assent date of '::text) || c.date_royal_assent
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.date_assent_blocked IS NOT NULL AND c.date_introduced IS NOT NULL AND c.date_assent_blocked < c.date_introduced THEN (('stopped from going for Royal Assent on '::text || c.date_assent_blocked) || ', before the bill was introduced on '::text) || c.date_introduced
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.outcome = 'passed'::text AND c.date_royal_assent IS NULL AND (c.enactment_status <> ALL (ARRAY['blocked'::text, 'pending'::text])) AND c.assent_block_outcome IS NULL THEN (('passed, but has no Royal Assent date, is recorded as '::text || COALESCE(quote_literal(c.enactment_status), 'null'::text)) || ' rather than as blocked or awaiting one, and says nothing '::text) || 'about what followed the bill being stopped'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.raw_section = 'awaiting_assent'::text AND (c.outcome IS DISTINCT FROM 'passed'::text OR (c.enactment_status <> ALL (ARRAY['blocked'::text, 'pending'::text, 'enacted'::text]))) THEN (('read from the Bills awaiting Royal Assent table, but outcome is '::text || COALESCE(quote_literal(c.outcome), 'null'::text)) || ' and it is recorded as '::text) || COALESCE(quote_literal(c.enactment_status), 'null'::text)
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.raw_section = 'awaiting_assent'::text AND c.outcome = 'passed'::text AND COALESCE(c.review_note, ''::text) !~ 'Checked: enactment_status = [a-z_]+ \([^)]+\)'::text THEN ((('the fact sheet leaves this bill awaiting Royal Assent, and nothing '::text || 'says legislation.gov.uk has been read to see whether the Act has '::text) || 'since been made: review_note carries no '::text) || '"Checked: enactment_status = ..." citation — see methodology '::text) || 'note M12'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.raw_section = 'acts'::text AND c.outcome IS DISTINCT FROM 'passed'::text THEN 'read from the Acts table, but outcome is '::text || COALESCE(quote_literal(c.outcome), 'null'::text)
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.raw_section = 'withdrawn'::text AND c.outcome IS DISTINCT FROM 'withdrawn'::text THEN 'read from the Withdrawn table, but outcome is '::text || COALESCE(quote_literal(c.outcome), 'null'::text)
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.raw_section = 'fallen'::text AND (c.outcome <> ALL (ARRAY['fell_dissolution'::text, 'fell_other'::text, 'rejected_stage_1'::text, 'rejected_stage_3'::text, 'fell_financial_resolution_not_agreed'::text])) THEN 'read from the Fallen table, but outcome is '::text || COALESCE(quote_literal(c.outcome), 'null'::text)
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN s.date_first_meeting IS NOT NULL AND c.date_introduced IS NOT NULL AND c.date_introduced < s.date_first_meeting THEN 'introduced before the session began'::text ||
                            CASE
                                WHEN c.continues_bill_id IS NULL THEN ' — if this line is a bill already on the clean'::text || ' sheet, continues_bill_id must say which'::text
                                ELSE ''::text
                            END
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN s.date_session_end IS NOT NULL AND c.date_introduced IS NOT NULL AND c.date_introduced > s.date_session_end THEN 'introduced after the session ended'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.continues_bill_id IS NULL AND s.date_session_end IS NOT NULL AND f.passed_on IS NOT NULL AND f.passed_on > s.date_session_end THEN 'passed after the session ended'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.continues_bill_id IS NULL AND s.date_session_end IS NOT NULL AND c.date_concluded IS NOT NULL AND c.date_concluded > s.date_session_end THEN 'concluded after the session ended'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.outcome = 'fell_dissolution'::text AND s.date_session_end IS NULL THEN ((('coded as having fallen at dissolution, but no last day is'::text || ' recorded for Session '::text) || COALESCE(c.session_number::text, '?'::text)) || ', so the coding cannot be checked and its provenance'::text) || ' cannot be written'::text
                            WHEN c.outcome = 'fell_dissolution'::text AND c.date_concluded IS DISTINCT FROM s.date_session_end THEN (('coded as having fallen at dissolution, but concluded '::text || COALESCE(c.date_concluded::text, 'on no recorded date'::text)) || ' and the session ended '::text) || s.date_session_end
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.continues_bill_id IS NOT NULL AND cb.bill_id IS NULL THEN ('says it continues bill '::text || c.continues_bill_id) || ', which is not on the clean sheet'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.continues_bill_id IS NOT NULL AND cb.bill_id IS NOT NULL AND c.date_introduced IS DISTINCT FROM cb.date_introduced THEN (((('says it continues bill '::text || c.continues_bill_id) || ', which was introduced '::text) || COALESCE(cb.date_introduced::text, 'on no recorded date'::text)) || ', but this line says '::text) || COALESCE(c.date_introduced::text, 'no date'::text)
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.continues_bill_id IS NOT NULL AND cb.bill_id IS NOT NULL AND cb.session_number >= c.session_number THEN ((('says it continues bill '::text || c.continues_bill_id) || ', which belongs to Session '::text) || cb.session_number) || '. Only a later session can continue a bill'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN (c.assent_block_route IS NULL) <> (c.assent_block_outcome IS NULL) THEN 'assent_block_route and assent_block_outcome must be filled'::text || ' together or left empty together'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.assent_block_route IS NOT NULL AND NOT (EXISTS ( SELECT 1
                               FROM ref_assent_block_route x
                              WHERE x.code = c.assent_block_route)) THEN ('assent_block_route '::text || quote_literal(c.assent_block_route)) || ' is not in ref_assent_block_route'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.assent_block_outcome IS NOT NULL AND NOT (EXISTS ( SELECT 1
                               FROM ref_assent_block_outcome x
                              WHERE x.code = c.assent_block_outcome)) THEN ('assent_block_outcome '::text || quote_literal(c.assent_block_outcome)) || ' is not in ref_assent_block_outcome'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.assent_block_outcome IS NOT NULL AND c.outcome IS DISTINCT FROM 'passed'::text THEN ('stopped before Royal Assent, but its outcome is '::text || COALESCE(c.outcome, 'empty'::text)) || '. Only a bill that passed can be stopped before assent'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.enactment_status = 'blocked'::text AND c.assent_block_outcome IS NULL THEN 'recorded as blocked, but nothing says how it was stopped or'::text || ' what followed'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.enactment_status = 'blocked'::text AND c.assent_block_outcome IS NOT NULL AND c.assent_block_outcome <> 'still_blocked'::text THEN 'recorded as blocked, but says what followed was '::text || quote_literal(c.assent_block_outcome)
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.assent_block_outcome = 'still_blocked'::text AND c.enactment_status IS DISTINCT FROM 'blocked'::text THEN 'says it is still blocked, but its enactment status reads '::text || COALESCE(quote_literal(c.enactment_status), 'empty'::text)
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.assent_block_outcome = 'reconsidered_passed'::text AND c.enactment_status IS DISTINCT FROM 'enacted'::text THEN 'reconsidered and passed, but not recorded as enacted'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.assent_block_outcome = 'withdrawn'::text AND c.date_concluded IS NULL THEN 'withdrawn after being blocked, but no date says when'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN (c.assent_block_outcome = ANY (ARRAY['reconsidered_passed'::text, 'reconsidered_fell'::text])) AND NOT (EXISTS ( SELECT 1
                               FROM stage_candidate t
                              WHERE t.candidate_id = c.candidate_id AND t.stage = 'reconsideration'::text AND t.review_status <> 'rejected'::text)) AND NOT (EXISTS ( SELECT 1
                               FROM stage_event e
                              WHERE e.bill_id = c.continues_bill_id AND e.stage = 'reconsideration'::text)) THEN 'says it was reconsidered, but has no Reconsideration Stage'::text || ' row'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN (EXISTS ( SELECT 1
                               FROM stage_candidate t
                              WHERE t.candidate_id = c.candidate_id AND t.stage = 'reconsideration'::text AND t.review_status <> 'rejected'::text)) AND (COALESCE(c.assent_block_outcome, ''::text) <> ALL (ARRAY['reconsidered_passed'::text, 'reconsidered_fell'::text])) THEN 'has a Reconsideration Stage row, but does not say it was'::text || ' reconsidered after being stopped before Royal Assent'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.reintroduced_from_bill_id IS NULL AND (EXISTS ( SELECT 1
                               FROM stage_candidate t
                              WHERE t.candidate_id = c.candidate_id AND t.did_not_happen AND t.review_status <> 'rejected'::text)) THEN 'has a stage recorded as never having happened, but does not'::text || ' say which earlier bill''s scrutiny it carried'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.reintroduced_from_bill_id IS NOT NULL AND NOT (EXISTS ( SELECT 1
                               FROM bill b2
                              WHERE b2.bill_id = c.reintroduced_from_bill_id)) THEN ('says it carried the scrutiny of bill '::text || c.reintroduced_from_bill_id) || ', which is not on the clean sheet'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.reintroduced_from_bill_id IS NOT NULL AND (EXISTS ( SELECT 1
                               FROM bill b2
                              WHERE b2.bill_id = c.reintroduced_from_bill_id AND b2.date_introduced >= c.date_introduced)) THEN ('says it carried the scrutiny of bill '::text || c.reintroduced_from_bill_id) || ', which was not introduced before it'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.reintroduced_from_bill_id IS NOT NULL AND c.continues_bill_id IS NOT NULL THEN (('says both that it continues an earlier bill and that it'::text || ' carried an earlier bill''s scrutiny. A bill either did'::text) || ' not end, in which case it is one bill, or it ended and'::text) || ' another was introduced'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.date_procedure_agreed IS NOT NULL AND c.procedure IS NULL THEN ('says a procedure was agreed on '::text || c.date_procedure_agreed) || ', but does not say which procedure'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.date_procedure_agreed IS NOT NULL AND c.date_introduced IS NOT NULL AND c.date_procedure_agreed < c.date_introduced THEN (('procedure agreed on '::text || c.date_procedure_agreed) || ', before the bill was introduced on '::text) || c.date_introduced
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.date_procedure_agreed IS NOT NULL AND f.passed_on IS NOT NULL AND c.date_procedure_agreed > f.passed_on THEN (('procedure agreed on '::text || c.date_procedure_agreed) || ', after the bill had passed on '::text) || f.passed_on
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.date_procedure_agreed IS NOT NULL AND c.date_concluded IS NOT NULL AND c.date_procedure_agreed > c.date_concluded THEN (('procedure agreed on '::text || c.date_procedure_agreed) || ', after the bill had concluded on '::text) || c.date_concluded
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.continues_bill_id IS NOT NULL AND (c.procedure IS NOT NULL OR c.date_procedure_agreed IS NOT NULL) THEN ((('continues bill '::text || c.continues_bill_id) || ' and states how the bill was handled. A further'::text) || ' appearance does not carry the procedure onto the bill,'::text) || ' so this would be lost. See db/087'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN c.continues_bill_id IS NOT NULL AND COALESCE(btrim(c.bill_note), ''::text) = ''::text AND (EXISTS ( SELECT 1
                               FROM bill b3
                              WHERE b3.bill_id = c.continues_bill_id AND COALESCE(btrim(b3.note), ''::text) <> ''::text)) THEN (((((('continues bill '::text || c.continues_bill_id) || ', which carries a note written from an earlier fact'::text) || ' sheet, and this line has no note of its own. Say here'::text) || ' what the note should now read — repeating the earlier'::text) || ' wording if it still stands — so that the note cannot be'::text) || ' left behind by what this line changes. See methodology'::text) || ' note M6'::text
                            ELSE NULL::text
                        END)) p(problem)
        ), stage_checks AS (
         SELECT r.candidate_id,
            r.session_number,
            r.short_title,
            r.review_status,
            (((r.stage_label || ', from '::text) || COALESCE(r.source, 'no stated source'::text)) || ': '::text) || p.problem AS problem,
            r.stage_candidate_id
           FROM stage_rows r
             CROSS JOIN LATERAL ( VALUES (
                        CASE
                            WHEN r.stage_order IS NULL OR r.stage_order < 1 OR r.stage_order > 4 THEN ('position '::text || COALESCE(r.stage_order::text, 'empty'::text)) || ' is not 1 to 4'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN r.stage IS NULL THEN 'no stage named'::text
                            WHEN NOT (EXISTS ( SELECT 1
                               FROM ref_stage x
                              WHERE x.code = r.stage)) THEN ('stage '::text || quote_literal(r.stage)) || ' is not in ref_stage'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN r.stage IS NOT NULL AND r.stage_order IS NOT NULL AND r.bill_type IS NOT NULL AND NOT (EXISTS ( SELECT 1
                               FROM ref_bill_type_stage x
                              WHERE x.bill_type = r.bill_type AND x.stage = r.stage AND x.stage_order = r.stage_order)) THEN ((('not the right stage name for a '::text || r.bill_type) || ' bill at position '::text) || r.stage_order) || ' — see ref_bill_type_stage'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN r.source IS NULL THEN 'no source'::text
                            WHEN NOT (EXISTS ( SELECT 1
                               FROM ref_source x
                              WHERE x.code = r.source)) THEN ('source '::text || quote_literal(r.source)) || ' is not in ref_source'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN r.observed_at IS NULL THEN 'when the source was read is not recorded'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN r.completed IS NULL THEN 'completed is empty'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN r.fell_here IS NULL THEN 'fell_here is empty'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN r.did_not_happen AND r.bill_type IS DISTINCT FROM 'private'::text THEN 'marked as a stage that did not happen, but only a Private Bill may skip '::text || 'a stage — see methodology note M2'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN r.did_not_happen AND r.date_completed IS NOT NULL THEN 'marked as a stage that did not happen, but dated '::text || r.date_completed
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN r.did_not_happen AND (r.completed OR r.fell_here) THEN 'marked as a stage that did not happen, and also as completed or as where '::text || 'the bill ended'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN r.did_not_happen AND NULLIF(btrim(r.detail_note), ''::text) IS NULL THEN 'marked as a stage that did not happen, but no note says why'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN r.date_reached IS NOT NULL AND r.date_completed IS NOT NULL AND r.date_reached > r.date_completed THEN (('reached on '::text || r.date_reached) || ', after it ended on '::text) || r.date_completed
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN r.date_reached IS NOT NULL AND r.date_introduced IS NOT NULL AND r.date_reached < r.date_introduced THEN (('reached on '::text || r.date_reached) || ', before the bill was introduced on '::text) || r.date_introduced
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN r.did_not_happen AND r.date_reached IS NOT NULL THEN 'marked as a stage that did not happen, but reached on '::text || r.date_reached
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN r.completed AND r.fell_here THEN 'marked completed, and also as where the bill ended'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN r.completed AND r.date_completed IS NULL AND NULLIF(btrim(r.detail_note), ''::text) IS NULL THEN 'completed on a date not known, but no note says why'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN r.completed IS FALSE AND r.fell_here IS FALSE AND r.date_completed IS NOT NULL THEN 'not completed and not where the bill ended, but dated'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN r.fell_here AND r.outcome = 'passed'::text THEN 'marked as where the bill ended, but the bill passed'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN r.fell_here AND r.outcome = 'rejected_stage_1'::text AND r.stage_order <> 1 THEN 'marked as where the bill ended, but the bill was rejected at Stage 1'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN r.fell_here AND r.outcome = 'rejected_stage_3'::text AND r.stage_order <> 3 THEN 'marked as where the bill ended, but the bill was rejected at Stage 3'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN r.completed AND r.stage_order = 3 AND r.outcome IS DISTINCT FROM 'passed'::text THEN 'final stage completed, but the outcome is not passed'::text
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN r.date_completed < r.date_introduced THEN (('dated '::text || r.date_completed) || ', before the bill was introduced on '::text) || r.date_introduced
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN r.completed AND r.date_completed > r.date_royal_assent THEN (('dated '::text || r.date_completed) || ', after Royal Assent on '::text) || r.date_royal_assent
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN r.date_completed > r.date_concluded THEN (('dated '::text || r.date_completed) || ', after the bill concluded on '::text) || r.date_concluded
                            ELSE NULL::text
                        END), (
                        CASE
                            WHEN r.fell_here AND (r.outcome = ANY (ARRAY['rejected_stage_1'::text, 'rejected_stage_3'::text])) AND r.date_completed <> r.date_concluded THEN (('the decision that ended the bill is dated '::text || r.date_completed) || ', but the bill concluded on '::text) || r.date_concluded
                            ELSE NULL::text
                        END), (( SELECT (((('dated '::text || r.date_completed) || ', before '::text) || e.stage_label) || ' on '::text) || e.date_completed
                           FROM stage_rows e
                          WHERE e.candidate_id = r.candidate_id AND e.stage_order < r.stage_order AND e.date_completed > r.date_completed
                          ORDER BY e.stage_order
                         LIMIT 1)), (( SELECT ('recorded after '::text || e.stage_label) || ', where the bill ended'::text
                           FROM stage_rows e
                          WHERE e.candidate_id = r.candidate_id AND e.fell_here AND e.stage_order < r.stage_order
                          ORDER BY e.stage_order
                         LIMIT 1)), (( SELECT ('recorded, but '::text || e.stage_label) || ' before it was not completed'::text
                           FROM stage_rows e
                          WHERE e.candidate_id = r.candidate_id AND e.completed IS FALSE AND e.fell_here IS FALSE AND NOT e.did_not_happen AND e.stage_order < r.stage_order
                          ORDER BY e.stage_order
                         LIMIT 1)), (( SELECT (((('disagrees with '::text || COALESCE(e.source, 'another row'::text)) || ', which gives '::text) || COALESCE(e.date_completed::text, 'no date'::text)) ||
                                CASE
                                    WHEN e.completed THEN ', completed'::text
                                    ELSE ', not completed'::text
                                END) ||
                                CASE
                                    WHEN e.fell_here THEN ', where the bill ended'::text
                                    ELSE ''::text
                                END
                           FROM stage_rows e
                          WHERE e.candidate_id = r.candidate_id AND e.stage_order = r.stage_order AND e.stage_candidate_id <> r.stage_candidate_id AND (e.date_completed IS DISTINCT FROM r.date_completed OR e.completed IS DISTINCT FROM r.completed OR e.fell_here IS DISTINCT FROM r.fell_here OR e.stage IS DISTINCT FROM r.stage)
                          ORDER BY e.stage_candidate_id
                         LIMIT 1))) p(problem)
        ), title_checks AS (
         SELECT c.candidate_id,
            c.session_number,
            c.short_title,
            c.review_status,
            p.problem,
            NULL::integer AS stage_candidate_id
           FROM bill_candidate c
             CROSS JOIN LATERAL ( VALUES
                (CASE WHEN c.title_changed_at_stage IS NOT NULL AND NOT (EXISTS ( SELECT 1
                           FROM ref_bill_type_stage x
                          WHERE x.bill_type = c.bill_type AND x.stage = c.title_changed_at_stage))
                      THEN ((('title_changed_at_stage '::text || quote_literal(c.title_changed_at_stage)) || ' is not a stage a '::text) || COALESCE(c.bill_type, '?'::text)) || ' bill has — see ref_bill_type_stage'::text
                      ELSE NULL::text END),
                (CASE WHEN c.title_changed_at_stage IS NOT NULL AND c.title_as_introduced IS NULL
                      THEN 'says at which stage its title changed, but records no title as introduced'::text
                      ELSE NULL::text END),
                (CASE WHEN c.title_as_introduced IS NOT NULL AND c.title_changed_at_stage IS NULL
                      THEN 'records a title as introduced, but not the stage at which the title changed. A title is changed at the end of a stage, so the stage gives the date: see methodology note M3'::text
                      ELSE NULL::text END),
                (CASE WHEN c.title_changed_at_stage IS NOT NULL AND NOT (EXISTS ( SELECT 1
                           FROM stage_rows r
                          WHERE r.candidate_id = c.candidate_id AND r.stage = c.title_changed_at_stage AND r.date_completed IS NOT NULL))
                      THEN ('says its title changed at '::text || c.title_changed_at_stage) || ', but has no dated row for that stage, so the change would have no date'::text
                      ELSE NULL::text END),
                (CASE WHEN c.title_changed_at_stage IS NOT NULL AND COALESCE(c.review_note, ''::text) !~ (('Checked: title_changed_at_stage = '::text || c.title_changed_at_stage) || ' \('::text)
                      THEN 'says at which stage its title changed, but review_note carries no "Checked: title_changed_at_stage = ..." citation'::text
                      ELSE NULL::text END)
             ) p(problem)
          WHERE c.review_status <> 'rejected'::text
        ), difference_checks AS (
         SELECT c.candidate_id,
            c.session_number,
            c.short_title,
            c.review_status,
            ((('another source gives a different '::text || d.m[1]) || ', and it has not been adjudicated: no "Checked: '::text) || d.m[1]) || ' = ..." citation'::text AS problem,
            NULL::integer AS stage_candidate_id
           FROM bill_candidate c
             CROSS JOIN LATERAL regexp_matches(COALESCE(c.review_note, ''::text), 'Differs: ([a-z0-9_]+) = '::text, 'g'::text) d(m)
          WHERE c.review_status <> 'rejected'::text AND COALESCE(c.review_note, ''::text) !~~ (('%Checked: '::text || d.m[1]) || ' = %'::text)
        )
 SELECT line_checks.candidate_id,
    line_checks.session_number,
    line_checks.short_title,
    line_checks.review_status,
    line_checks.problem,
    line_checks.stage_candidate_id
   FROM line_checks
  WHERE line_checks.problem IS NOT NULL
UNION ALL
 SELECT stage_checks.candidate_id,
    stage_checks.session_number,
    stage_checks.short_title,
    stage_checks.review_status,
    stage_checks.problem,
    stage_checks.stage_candidate_id
   FROM stage_checks
  WHERE stage_checks.problem IS NOT NULL
UNION ALL
 SELECT difference_checks.candidate_id,
    difference_checks.session_number,
    difference_checks.short_title,
    difference_checks.review_status,
    difference_checks.problem,
    difference_checks.stage_candidate_id
   FROM difference_checks
UNION ALL
 SELECT title_checks.candidate_id,
    title_checks.session_number,
    title_checks.short_title,
    title_checks.review_status,
    title_checks.problem,
    title_checks.stage_candidate_id
   FROM title_checks
  WHERE title_checks.problem IS NOT NULL;

COMMENT ON VIEW v_candidate_problems IS
 'The error checker: every problem the database can find on the staging sheets, one row per problem, for the owner to clear before a session is admitted. A line or stage row with nothing wrong does not appear. Empty means nothing found, not nothing checked. At db/090 the Royal Assent and introduction date rules also ask about a date filled into a cell the fact sheet left empty, and every line read from an awaiting-assent table must say legislation.gov.uk has been read to see whether the Act has since been made. At db/094 a bill that passed and has no Royal Assent date may also account for itself by saying what followed the bill being stopped, instead of being recorded as blocked or awaiting assent. At db/098 a line that lists again a bill whose note was written from an earlier fact sheet must say what that note should now read. At db/107 a line recording a title as introduced must say at which stage the title changed, a stage its kind of bill has and it has a dated row for, with a "Checked:" citation.';

-- ---------------------------------------------------------------------------
-- 3. The four lines
-- ---------------------------------------------------------------------------

UPDATE bill_candidate
   SET title_changed_at_stage = 'stage_3',
       review_note = coalesce(review_note || E'\n', '')
         || 'Checked: title_changed_at_stage = stage_3 (bill_page, https://webarchive.nrscotland.gov.uk/public/+/archive2021.parliament.scot/parliamentarybusiness/Bills/25125.aspx, 2026-09-17)' || E'\n'
         || 'The bill page says the Executive''s amendments changing the Commissioner to a Commission failed at Stage 2 and succeeded at Stage 3. A title is changed at the end of a stage, so the change is dated by Stage 3. Read by the owner; see db/107.'
 WHERE candidate_id = 127;

UPDATE bill_candidate
   SET raw_footnote = 'Was introduced as the Defective and Dangerous Buildings (Recovery of Expenses) (Scotland) Bill',
       title_as_introduced = 'Defective and Dangerous Buildings (Recovery of Expenses) (Scotland) Bill',
       title_changed_at_stage = 'stage_2',
       review_note = coalesce(review_note || E'\n', '')
         || 'Checked: title_changed_at_stage = stage_2 (bill_page, https://webarchive.nrscotland.gov.uk/public/+/archive2021.parliament.scot/parliamentarybusiness/Bills/69042.aspx, 2026-09-17)' || E'\n'
         || 'The Session 4 fact sheet''s footnote 1 gives the title this bill was introduced under; the reader removed its marker and kept neither the footnote nor the title, both filled from the fact sheet by db/107. The bill page says: "After stage 2 consideration of the Bill, the short title of the Bill was changed to the Buildings (Recovery of Expenses) (Scotland) Bill to reflect amendments made to the Bill at Stage 2." Read by the owner; see db/107.'
 WHERE candidate_id = 231;

UPDATE bill_candidate
   SET title_changed_at_stage = 'stage_3',
       review_note = coalesce(review_note || E'\n', '')
         || 'Checked: title_changed_at_stage = stage_3 (spice_factsheet_legislation, session 6 retrieved 2026-09-10, 2026-09-10)' || E'\n'
         || 'The fact sheet dates the rename 24 February 2026, the day of this bill''s Stage 3. A title is changed at the end of a stage. See db/107.'
 WHERE candidate_id = 406;

UPDATE bill_candidate
   SET title_changed_at_stage = 'stage_2',
       review_note = coalesce(review_note || E'\n', '')
         || 'Checked: title_changed_at_stage = stage_2 (spice_factsheet_legislation, session 6 retrieved 2026-09-10, 2026-09-10)' || E'\n'
         || 'The fact sheet dates the rename 4 March 2025, the day this bill''s Stage 2 ended. A title is changed at the end of a stage. See db/107.'
 WHERE candidate_id = 423;

-- ---------------------------------------------------------------------------
-- 4. What a reader is told: M3, as the owner approved it on 2026-09-17
-- ---------------------------------------------------------------------------

UPDATE methodology_note
   SET title = 'A bill''s title can change while it is before the Parliament',
       body = 'A bill''s short title can be changed by amendment while the bill is before the Parliament, and a bill that becomes an Act takes the Act''s title. We record the title a bill ended with, which is the Act''s title where there is one, and, where a source states it, the title it was introduced under and the stage at which the title changed.

An amendment to a bill''s title is taken at the end of a stage, once the rest of the bill has been amended, so that it is made once. The date of the change is therefore the date that stage ended.

Four bills are recorded with an earlier title: the Scottish Commission for Human Rights Act 2006, introduced as the Scottish Commissioner for Human Rights Bill and changed at Stage 3; the Buildings (Recovery of Expenses) (Scotland) Act 2014, introduced as the Defective and Dangerous Buildings (Recovery of Expenses) (Scotland) Bill and changed at Stage 2; the Care Reform (Scotland) Act 2025, introduced as the National Care Service (Scotland) Bill and changed at Stage 2; and the Scottish Parliament (Recall of Members) Bill, introduced as the Scottish Parliament (Recall and Removal of Members) Bill and changed at Stage 3.

For every other bill no earlier title is recorded. That means none is known, not that the title never changed.',
       applies_to = ARRAY['bill.short_title', 'bill.title_as_introduced', 'bill.title_changed_at_stage']
 WHERE code = 'M3';

-- ---------------------------------------------------------------------------
-- 5. Proof
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM bill_candidate
   WHERE title_as_introduced IS NOT NULL AND title_changed_at_stage IS NOT NULL;
  IF n <> 4 THEN RAISE EXCEPTION '% lines carry both a title as introduced and a stage, expected 4.', n; END IF;

  SELECT count(*) INTO n FROM bill_candidate
   WHERE (title_as_introduced IS NULL) <> (title_changed_at_stage IS NULL);
  IF n > 0 THEN RAISE EXCEPTION '% line(s) carry one of the two title cells without the other.', n; END IF;

  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n <> 0 THEN RAISE EXCEPTION 'The error checker finds % problem(s), expected none.', n; END IF;

  SELECT count(*) INTO n FROM methodology_note WHERE code = 'M3' AND body !~ '[a-z_]+\.[a-z_]+' AND body LIKE '%Defective and Dangerous%';
  IF n <> 1 THEN RAISE EXCEPTION 'M3 did not take.'; END IF;
  SELECT count(*) INTO n FROM methodology_note; IF n <> 14 THEN RAISE EXCEPTION '% notes', n; END IF;

  SELECT count(*) INTO n FROM bill; IF n <> 470 THEN RAISE EXCEPTION '% bills', n; END IF;
  SELECT count(*) INTO n FROM field_source; IF n <> 188 THEN RAISE EXCEPTION '% provenance notes', n; END IF;

  RAISE NOTICE 'Four lines record the stage their title changed at; M3 rewritten. The clean sheet changes when the sessions are put back.';
END $$;

COMMIT;
