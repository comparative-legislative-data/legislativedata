-- db/114_a_definition_is_written_for_a_reader.sql
--
-- The definitions beside the allowed values are rewritten for a reader of the
-- published data, in the wording the owner agreed item by item on 2026-09-18
-- (docs/PHASE-2-DEFINITIONS.md; DECISIONS.md, 2026-09-18). They are published
-- as what_the_words_mean, so this comes before the published copy is built.
--
-- WHAT CHANGES. Twenty-nine definitions on the ten published lists:
--   * two facts corrected: the section 33 rulings (the Legal Continuity Bill's
--     was 13 December 2018, not 6 October 2021, and the footnote is kept against
--     how and when the bill was stopped), and the PhD dataset (2021, not 2022,
--     and used as M8 says rather than as "ground truth");
--   * five empty ones filled;
--   * twelve that named a working column or code now name the published
--     heading, or the word in the cell;
--   * ten that told whoever enters data what to do now tell the reader what is
--     true, and the instructions move to the description of the column they
--     are about.
-- The rule goes on every list's definition column. The descriptions of
-- bill.assent_block_route and bill.assent_block_outcome also lose a stale
-- count ("all but three bills today, and will be all but four once Session 6
-- is loaded"): four bills were stopped, and Session 6 is loaded.
--
-- WHAT DOES NOT CHANGE. No value, label or position; the party list, which is
-- not published; and no bill, stage record, provenance note or methodology note.


\set ON_ERROR_STOP on
BEGIN;

-- Refuse unless every definition this replaces is exactly the wording read on 2026-09-18.
DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM ref_assent_block_outcome WHERE code = 'reconsidered_fell' AND md5(definition) = 'efe902e06b6c052bcfdc31bca2b1f634';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: ref_assent_block_outcome reconsidered_fell is not the wording this replaces.'; END IF;
  SELECT count(*) INTO n FROM ref_assent_block_outcome WHERE code = 'reconsidered_passed' AND md5(definition) = 'dc6295454fa0196f7cf725a52b5f24ba';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: ref_assent_block_outcome reconsidered_passed is not the wording this replaces.'; END IF;
  SELECT count(*) INTO n FROM ref_assent_block_outcome WHERE code = 'withdrawn' AND md5(definition) = '7a492fa11c8b7a0a9cde1141bbfbe632';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: ref_assent_block_outcome withdrawn is not the wording this replaces.'; END IF;
  SELECT count(*) INTO n FROM ref_assent_block_route WHERE code = 's33_reference' AND md5(definition) = '18d522b618333e574cc2decef16098a9';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: ref_assent_block_route s33_reference is not the wording this replaces.'; END IF;
  SELECT count(*) INTO n FROM ref_bill_type WHERE code = 'government' AND md5(definition) = 'e9439196907cb51211e601fba139071a';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: ref_bill_type government is not the wording this replaces.'; END IF;
  SELECT count(*) INTO n FROM ref_bill_type WHERE code = 'hybrid' AND md5(definition) = '8fe3d560a70989fc81d576b83213bbc1';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: ref_bill_type hybrid is not the wording this replaces.'; END IF;
  SELECT count(*) INTO n FROM ref_bill_type_stated WHERE code = 'committee' AND coalesce(definition,'') = '';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: ref_bill_type_stated committee is not the wording this replaces.'; END IF;
  SELECT count(*) INTO n FROM ref_bill_type_stated WHERE code = 'executive' AND md5(definition) = 'f3775515d1034be8e83de953b63a7162';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: ref_bill_type_stated executive is not the wording this replaces.'; END IF;
  SELECT count(*) INTO n FROM ref_bill_type_stated WHERE code = 'members' AND coalesce(definition,'') = '';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: ref_bill_type_stated members is not the wording this replaces.'; END IF;
  SELECT count(*) INTO n FROM ref_bill_type_stated WHERE code = 'private' AND coalesce(definition,'') = '';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: ref_bill_type_stated private is not the wording this replaces.'; END IF;
  SELECT count(*) INTO n FROM ref_enactment_status WHERE code = 'pending' AND md5(definition) = 'a97cc672944db62f5e813b2ccb5fb1aa';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: ref_enactment_status pending is not the wording this replaces.'; END IF;
  SELECT count(*) INTO n FROM ref_outcome WHERE code = 'fell_financial_resolution_not_agreed' AND md5(definition) = '76e68eb9d460ee916aaac3e2e5e4b6ea';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: ref_outcome fell_financial_resolution_not_agreed is not the wording this replaces.'; END IF;
  SELECT count(*) INTO n FROM ref_outcome WHERE code = 'fell_other' AND md5(definition) = '63f291326b6339bdb3f555e7450a93d8';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: ref_outcome fell_other is not the wording this replaces.'; END IF;
  SELECT count(*) INTO n FROM ref_procedure WHERE code = 'emergency' AND md5(definition) = '67bfdd7ccaa83d295e5bb8113716d800';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: ref_procedure emergency is not the wording this replaces.'; END IF;
  SELECT count(*) INTO n FROM ref_procedure WHERE code = 'statute_law_repeals' AND coalesce(definition,'') = '';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: ref_procedure statute_law_repeals is not the wording this replaces.'; END IF;
  SELECT count(*) INTO n FROM ref_procedure WHERE code = 'statute_law_revision' AND coalesce(definition,'') = '';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: ref_procedure statute_law_revision is not the wording this replaces.'; END IF;
  SELECT count(*) INTO n FROM ref_source WHERE code = 'api' AND md5(definition) = 'a6898a94575e907b799ffb744dd2c4a8';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: ref_source api is not the wording this replaces.'; END IF;
  SELECT count(*) INTO n FROM ref_source WHERE code = 'bill_document' AND md5(definition) = '4c91a4b18b5e71e6580164816b7c7062';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: ref_source bill_document is not the wording this replaces.'; END IF;
  SELECT count(*) INTO n FROM ref_source WHERE code = 'bill_page' AND md5(definition) = '521f156749994bba5516af1aeef42858';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: ref_source bill_page is not the wording this replaces.'; END IF;
  SELECT count(*) INTO n FROM ref_source WHERE code = 'legislation_gov_uk' AND md5(definition) = '21b0c8e15ca9cd5122edc87b3f0cd1e3';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: ref_source legislation_gov_uk is not the wording this replaces.'; END IF;
  SELECT count(*) INTO n FROM ref_source WHERE code = 'manual' AND md5(definition) = 'd5039f82a4549d1325582431c5bb8900';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: ref_source manual is not the wording this replaces.'; END IF;
  SELECT count(*) INTO n FROM ref_source WHERE code = 'phd' AND md5(definition) = '8cd4b4b352287ff29e2d4d1e0d30293b';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: ref_source phd is not the wording this replaces.'; END IF;
  SELECT count(*) INTO n FROM ref_source WHERE code = 'spice_factsheet_dates' AND md5(definition) = '5b4bf7f454906f48bcaa1e853ed95db6';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: ref_source spice_factsheet_dates is not the wording this replaces.'; END IF;
  SELECT count(*) INTO n FROM ref_source WHERE code = 'spice_factsheet_legislation' AND md5(definition) = '9ace5625a7d21e6f2b859d759d392304';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: ref_source spice_factsheet_legislation is not the wording this replaces.'; END IF;
  SELECT count(*) INTO n FROM ref_source WHERE code = 'supreme_court' AND md5(definition) = '03a017503841264c1d610dddd9cb01e7';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: ref_source supreme_court is not the wording this replaces.'; END IF;
  SELECT count(*) INTO n FROM ref_stage WHERE code = 'reconsideration' AND md5(definition) = '2269b707aaa5851db616d55d9a7ba1f6';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: ref_stage reconsideration is not the wording this replaces.'; END IF;
  SELECT count(*) INTO n FROM ref_stage_1_rejection_route WHERE code = 'committee_motion_9_14_18' AND md5(definition) = 'd9aec44e10e809a79db527239d106e94';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: ref_stage_1_rejection_route committee_motion_9_14_18 is not the wording this replaces.'; END IF;
  SELECT count(*) INTO n FROM ref_stage_1_rejection_route WHERE code = 'member_motion_amended_agreed' AND md5(definition) = '7d0d6bc8f1e166a0e51814b82d76ee1f';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: ref_stage_1_rejection_route member_motion_amended_agreed is not the wording this replaces.'; END IF;
  SELECT count(*) INTO n FROM ref_stage_1_rejection_route WHERE code = 'other_route' AND md5(definition) = '3c228bb9d3f51e9a26aa7c814a639144';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: ref_stage_1_rejection_route other_route is not the wording this replaces.'; END IF;
END $$;

CREATE TEMP TABLE before_defs AS
SELECT 'ref_assent_block_outcome' AS list, code, label, definition, sort_order FROM ref_assent_block_outcome
UNION ALL
SELECT 'ref_assent_block_route' AS list, code, label, definition, sort_order FROM ref_assent_block_route
UNION ALL
SELECT 'ref_bill_type' AS list, code, label, definition, sort_order FROM ref_bill_type
UNION ALL
SELECT 'ref_bill_type_stated' AS list, code, label, definition, sort_order FROM ref_bill_type_stated
UNION ALL
SELECT 'ref_enactment_status' AS list, code, label, definition, sort_order FROM ref_enactment_status
UNION ALL
SELECT 'ref_outcome' AS list, code, label, definition, sort_order FROM ref_outcome
UNION ALL
SELECT 'ref_party' AS list, code, label, definition, sort_order FROM ref_party
UNION ALL
SELECT 'ref_procedure' AS list, code, label, definition, sort_order FROM ref_procedure
UNION ALL
SELECT 'ref_source' AS list, code, label, definition, sort_order FROM ref_source
UNION ALL
SELECT 'ref_stage' AS list, code, label, definition, sort_order FROM ref_stage
UNION ALL
SELECT 'ref_stage_1_rejection_route' AS list, code, label, definition, sort_order FROM ref_stage_1_rejection_route;

-- The twenty-nine definitions, as agreed.
UPDATE ref_assent_block_outcome SET definition = 'The Parliament reconsidered the bill under the Reconsideration Stage and did not approve it, so the bill fell there. No bill has done this. The value exists so that the next one has somewhere to go.'
 WHERE code = 'reconsidered_fell';
UPDATE ref_assent_block_outcome SET definition = 'The Parliament reconsidered the bill under the Reconsideration Stage, approved it, and it went on to Royal Assent. Its enactment_status is Enacted, and its Reconsideration Stage line in the stages file carries the date the stage ended. Two bills, both Session 5 bills reconsidered in Session 6.'
 WHERE code = 'reconsidered_passed';
UPDATE ref_assent_block_outcome SET definition = 'The bill was withdrawn after it was stopped, so it will not become an Act. Its enactment_status is Not enacted, and date_fell_or_withdrawn holds the day it was withdrawn. One bill: the UK Withdrawal from the European Union (Legal Continuity) (Scotland) Bill, withdrawn on 10 March 2022, which the Session 6 fact sheet prints in a section of its own and excludes from that session''s totals.'
 WHERE code = 'withdrawn';
UPDATE ref_assent_block_route SET definition = 'A law officer referred the bill to the Supreme Court under section 33 of the Scotland Act 1998, on the question whether it was within the Parliament''s legislative competence, and the Court ruled that some of its provisions were not. Three bills, all in Session 5, all referred by the Attorney General and the Advocate General for Scotland: the UK Withdrawal from the European Union (Legal Continuity) (Scotland) Bill, ruled on on 13 December 2018, and two bills ruled on on 6 October 2021. The fact sheet''s own footnote for each is kept word for word in the sources file.'
 WHERE code = 's33_reference';
UPDATE ref_bill_type SET definition = 'Introduced by the Scottish Government. Styled an Executive Bill for part of the Parliament''s history; the label used at the time cannot be worked out from the session or the date, and is kept in bill_type_at_the_time. See methodology note M1.'
 WHERE code = 'government';
UPDATE ref_bill_type SET definition = 'Introduced under the hybrid bill procedure: a bill of a public character that affects particular private interests. One exists, the Forth Crossing Bill of Session 3. Counted as a government bill when types are grouped, in bill_type_grouped; see methodology note M4.'
 WHERE code = 'hybrid';
UPDATE ref_bill_type_stated SET definition = 'Styled a Committee Bill when introduced.'
 WHERE code = 'committee';
UPDATE ref_bill_type_stated SET definition = 'Styled an Executive Bill when introduced. Its bill_type is Government Bill; see methodology note M1.'
 WHERE code = 'executive';
UPDATE ref_bill_type_stated SET definition = 'Styled a Member''s Bill when introduced.'
 WHERE code = 'members';
UPDATE ref_bill_type_stated SET definition = 'Styled a Private Bill when introduced.'
 WHERE code = 'private';
UPDATE ref_enactment_status SET definition = 'No Act yet, and nothing adverse recorded: a bill still before the Parliament, or one that has passed and is awaiting Royal Assent. A bill referred to the Supreme Court or subject to a section 35 order is Blocked, not Pending.'
 WHERE code = 'pending';
UPDATE ref_outcome SET definition = 'The bill fell because the Parliament did not agree the financial resolution its costs required. Under Rule 9.12 a bill whose provisions charge public funds needs a financial resolution, and the Presiding Officer decides whether it does; without one agreed the bill cannot proceed to Stage 2. A bill recorded this way has completed Stage 1 — its general principles were agreed — so it is not a rejection, and it did not run out of time, so it is not a dissolution. One bill: the Creative Scotland Bill, 18 June 2008.'
 WHERE code = 'fell_financial_resolution_not_agreed';
UPDATE ref_outcome SET definition = 'Fell for a reason none of the other values covers; note says what it was. No bill has fallen this way.'
 WHERE code = 'fell_other';
UPDATE ref_procedure SET definition = 'Stages compressed, often into a single day. Emergency Bills are kept in every figure rather than left out, and pull an average time down; procedure lets a reader set them aside.'
 WHERE code = 'emergency';
UPDATE ref_procedure SET definition = 'Handled under the procedure for a Statute Law Repeals Bill, which repeals enactments that are no longer of practical use.'
 WHERE code = 'statute_law_repeals';
UPDATE ref_procedure SET definition = 'Handled under the procedure for a Statute Law Revision Bill, which tidies the statute book without changing the law.'
 WHERE code = 'statute_law_revision';
UPDATE ref_source SET definition = 'The Scottish Parliament''s open data, at data.parliament.scot. No fact in this data rests on it.'
 WHERE code = 'api';
UPDATE ref_source SET definition = 'The bill as introduced, a marshalled list of amendments, or the Explanatory Notes; not the Parliament''s own pages for a bill. No fact in this data rests on it. The Explanatory Notes give an Act''s parliamentary passage, but they are written by government officials rather than by the Parliament''s, so they are not used for dates; see methodology note M8.'
 WHERE code = 'bill_document';
UPDATE ref_source SET definition = 'The Scottish Parliament''s own page for a bill or Act, live or as kept by the web archive. Definitive for dates other than Royal Assent. where_in_the_source gives the page''s address.'
 WHERE code = 'bill_page';
UPDATE ref_source SET definition = 'The Act as published by The National Archives. Definitive for the date of Royal Assent, which is one of the purposes of that site, and for an Act''s short title and its year-and-number, which are how that site identifies an Act; where_in_the_source gives the address of the Act''s page. Not used for the text of an Act.'
 WHERE code = 'legislation_gov_uk';
UPDATE ref_source SET definition = 'Entered by hand from knowledge or a source not otherwise listed; where_in_the_source says which.'
 WHERE code = 'manual';
UPDATE ref_source SET definition = 'The dataset compiled for Steven MacGregor, "Does government dominate the legislative process?" (PhD thesis, University of Stirling, 2021), maintained since to cover Sessions 6 and 7. Used for the dates of Stages 1 and 2 where no other source gives the date and nothing contradicts it; see methodology note M8.'
 WHERE code = 'phd';
UPDATE ref_source SET definition = 'SPICe''s fact sheet "Dates of recess, dissolution, parliamentary years and recalls of Parliament": when each session began and ended, when the Parliament was in recess or dissolved, and when it was recalled. One document covering every session; where_in_the_source gives its publication date and the page. A derived source, and maintained by hand — it carries at least one typographical error in its own tables — so it is read with the same care as any other fact sheet.'
 WHERE code = 'spice_factsheet_dates';
UPDATE ref_source SET definition = 'One of SPICe''s per-session legislation fact sheets: the list of bills introduced in a session and what happened to each. A derived source: the outcome and type coding is SPICe''s. where_in_the_source gives the session and the day the copy was retrieved.'
 WHERE code = 'spice_factsheet_legislation';
UPDATE ref_source SET definition = 'The UK Supreme Court''s own page for a case, or its judgment. Definitive for the date the Court ruled on a reference, such as one under section 33 of the Scotland Act 1998. where_in_the_source gives the address of the case page.'
 WHERE code = 'supreme_court';
UPDATE ref_stage SET definition = 'A stage after a reference to the Supreme Court or a section 35 order, at which the Parliament considers the bill again. A bill that has one did not end at its third stage.'
 WHERE code = 'reconsideration';
UPDATE ref_stage_1_rejection_route SET definition = 'The Parliament did not agree to the bill''s general principles, by agreeing to the motion of the convener of the lead committee, moved under Rule 9.14.18, that they not be agreed to. The rule lets the committee recommend this where, in its opinion, (a) the consultation or published material does not demonstrate a reasonable case for the policy objectives or that legislation is needed; (b) the Bill appears clearly outwith legislative competence and is unlikely to be brought within it by amendment at Stages 2 and 3; or (c) its drafting is too deficient to be put right by amendment. The motion does not state which; our view, where the grounds allow one, is in note. Cited as numbered and worded in the current Standing Orders, taken to be unchanged since 2006.'
 WHERE code = 'committee_motion_9_14_18';
UPDATE ref_stage_1_rejection_route SET definition = 'The Parliament did not agree to the bill''s general principles, by agreeing to the member in charge''s own motion after an amendment had turned it into one that did not agree to them. The motion passed and the general principles fell, so the fate of the motion and the fate of the bill point opposite ways. The amendment, who moved it and the reason the resolution gives are in note.'
 WHERE code = 'member_motion_amended_agreed';
UPDATE ref_stage_1_rejection_route SET definition = 'The Parliament did not agree to the bill''s general principles by some path other than those above; note says what happened and what its effect was. No bill has been rejected this way. The value exists so that a bill whose procedure nobody anticipated can be recorded truthfully; a second case of the same kind would be given a value of its own.'
 WHERE code = 'other_route';

-- The instructions, moved to the columns they are about; the rule, on every list's definition column; and two stale counts.
COMMENT ON COLUMN bill.assent_block_outcome IS 'What happened to the bill after it was stopped before Royal Assent: still blocked, withdrawn, reconsidered and passed, or reconsidered and fell. Allowed values are in ref_assent_block_outcome. Empty means the bill was never stopped, which is all but four bills. This cell, not enactment_status, is the lasting record that a bill was stopped: enactment_status says where the bill ended up and moves on when it does. See methodology note M5. reconsidered_fell has no bill: it is kept so the next case has somewhere to go, as the owner agreed on 2026-09-14. The error checker refuses reconsidered_passed or reconsidered_fell on a staging line with no Reconsideration Stage row.';
COMMENT ON COLUMN bill.assent_block_route IS 'How the bill was stopped before Royal Assent after it had passed: a section 33 reference to the Supreme Court, or a section 35 order by a UK Government minister. Allowed values are in ref_assent_block_route. Empty means the bill was never stopped, which is all but four bills. Kept even after the block is lifted, so a bill that was reconsidered and is now an Act still says how it was held up. See methodology note M5.';
COMMENT ON COLUMN bill.note IS 'Free text for anything irregular about this bill that a reader should see, carried from bill_candidate.bill_note at promotion. Where the reason a bill was blocked goes, and, for a bill rejected at Stage 1 by an unusual route, the amendment that did it or our view of which limb of Rule 9.14.18 applied. Not where a change of title goes: that is title_as_introduced and title_changed_at_stage, since db/107. Empty means nothing irregular has been recorded. Where the outcome is fell_other, the reason the bill fell goes here. Where the Stage 1 rejection route is other_route, what happened and what its effect was goes here; the error checker requires it.';
COMMENT ON COLUMN bill.source_ref IS 'The exact place within that source — which factsheet, which page. What goes here depends on the source: for the Parliament''s bill page, legislation.gov.uk or the Supreme Court, the address of the page; for a SPICe legislation fact sheet, the session and the day it was retrieved, e.g. "session 6, retrieved 2026-09-10"; for the SPICe dates fact sheet, its publication date and the page, e.g. "published 2 September 2026, p2"; for a source entered by hand (manual), what the source was. Retrieved fact sheets are kept in sources/factsheets/ in the repository. Published as where_in_the_source.';
COMMENT ON COLUMN bill.stage_1_rejection_route IS 'How the Parliament came to reject the bill''s general principles at Stage 1: the member in charge''s motion disagreed to; that motion amended to reject them and agreed to; or a committee motion under Rule 9.14.18 agreed to. Allowed values are in ref_stage_1_rejection_route. Filled for every bill whose outcome is rejected_stage_1 and for no other, and the database enforces both halves, so empty means only that the bill was not rejected at Stage 1. The 9.14.18 route is refused on anything but a Member''s Bill. Our coding against the Official Report; see methodology note M7. other_route is for a rejection by a path nobody anticipated. It is accepted at review only with the Presiding Officer''s announcement quoted in review_note and bill_note saying what happened and what its effect was, and the error checker requires both. It is not a place to leave things: a second case of the same kind earns its own value.';
COMMENT ON COLUMN bill_candidate.assent_block_outcome IS 'Proposed value for bill.assent_block_outcome: what happened to the bill after it was stopped before Royal Assent. Should be a code from ref_assent_block_outcome; nothing in this table enforces that, but bill.assent_block_outcome does. Empty means the bill was never stopped. Carried to the clean sheet at promotion. reconsidered_fell has no bill: it is kept so the next case has somewhere to go, as the owner agreed on 2026-09-14. The error checker refuses reconsidered_passed or reconsidered_fell on a staging line with no Reconsideration Stage row.';
COMMENT ON COLUMN bill_candidate.bill_note IS 'The note to carry onto bill.note at promotion: anything irregular about the bill that a reader of the published data should see. Not the same as review_note, which is the reviewer''s reasoning and stays on this sheet. Empty means there is nothing to carry. Where the outcome is fell_other, the reason the bill fell goes here. Where the Stage 1 rejection route is other_route, what happened and what its effect was goes here; the error checker requires it.';
COMMENT ON COLUMN bill_candidate.source_ref IS 'The exact place within that source — which factsheet, which page — so the line can be found again by hand. What goes here depends on the source: for the Parliament''s bill page, legislation.gov.uk or the Supreme Court, the address of the page; for a SPICe legislation fact sheet, the session and the day it was retrieved, e.g. "session 6, retrieved 2026-09-10"; for the SPICe dates fact sheet, its publication date and the page, e.g. "published 2 September 2026, p2"; for a source entered by hand (manual), what the source was. Retrieved fact sheets are kept in sources/factsheets/ in the repository. Published as where_in_the_source.';
COMMENT ON COLUMN bill_candidate.stage_1_rejection_route IS 'How the Parliament came to reject the bill''s general principles at Stage 1, read from the Official Report at review; no factsheet states it. Should be a code from ref_stage_1_rejection_route. Nothing in this table enforces that, but bill.stage_1_rejection_route does. The error checker requires it on every line whose outcome is rejected_stage_1 and refuses it on any other. The Presiding Officer''s announcement it rests on is quoted in review_note after "Result as recorded:", and becomes the provenance note''s value seen at promotion. other_route is for a rejection by a path nobody anticipated. It is accepted at review only with the Presiding Officer''s announcement quoted in review_note and bill_note saying what happened and what its effect was, and the error checker requires both. It is not a place to leave things: a second case of the same kind earns its own value.';
COMMENT ON COLUMN field_source.source_ref IS 'The exact place within that source. What goes here depends on the source: for the Parliament''s bill page, legislation.gov.uk or the Supreme Court, the address of the page; for a SPICe legislation fact sheet, the session and the day it was retrieved, e.g. "session 6, retrieved 2026-09-10"; for the SPICe dates fact sheet, its publication date and the page, e.g. "published 2 September 2026, p2"; for a source entered by hand (manual), what the source was. Retrieved fact sheets are kept in sources/factsheets/ in the repository. A fact resting on more than one bill page gets one line per page. Published as where_in_the_source.';
COMMENT ON COLUMN ref_assent_block_outcome.definition IS 'What the value means, in enough detail for a reader to judge whether it is the right one. Empty means nobody has written the definition yet. Written for a reader of the published data: it may name a published heading, but never a working column, a code, a file, a migration or the error checker, and it never tells anyone what to do. An instruction for whoever enters data goes in the description of the column it is about. See DECISIONS.md, 2026-09-18.';
COMMENT ON COLUMN ref_assent_block_route.definition IS 'What the value means, in enough detail for a reader to judge whether it is the right one. Empty means nobody has written the definition yet. Written for a reader of the published data: it may name a published heading, but never a working column, a code, a file, a migration or the error checker, and it never tells anyone what to do. An instruction for whoever enters data goes in the description of the column it is about. See DECISIONS.md, 2026-09-18.';
COMMENT ON COLUMN ref_bill_type.definition IS 'What this bill type means, in the Parliament''s terms. This is the text to show a reader who asks what a value means, and it is the reason the allowed values live in a table rather than as a bare list inside the schema. Written for a reader of the published data: it may name a published heading, but never a working column, a code, a file, a migration or the error checker, and it never tells anyone what to do. An instruction for whoever enters data goes in the description of the column it is about. See DECISIONS.md, 2026-09-18.';
COMMENT ON COLUMN ref_bill_type_stated.definition IS 'What this styling means, in the Parliament''s terms. This is the text to show a reader who asks what a value means, and it is the reason the allowed values live in a table rather than as a bare list inside the schema. Written for a reader of the published data: it may name a published heading, but never a working column, a code, a file, a migration or the error checker, and it never tells anyone what to do. An instruction for whoever enters data goes in the description of the column it is about. See DECISIONS.md, 2026-09-18.';
COMMENT ON COLUMN ref_enactment_status.definition IS 'What this status means, in the Parliament''s terms. This is the text to show a reader who asks what a value means, and it is the reason the allowed values live in a table rather than as a bare list inside the schema. Written for a reader of the published data: it may name a published heading, but never a working column, a code, a file, a migration or the error checker, and it never tells anyone what to do. An instruction for whoever enters data goes in the description of the column it is about. See DECISIONS.md, 2026-09-18.';
COMMENT ON COLUMN ref_outcome.definition IS 'What this outcome means, in the Parliament''s terms. This is the text to show a reader who asks what a value means, and it is the reason the allowed values live in a table rather than as a bare list inside the schema. Written for a reader of the published data: it may name a published heading, but never a working column, a code, a file, a migration or the error checker, and it never tells anyone what to do. An instruction for whoever enters data goes in the description of the column it is about. See DECISIONS.md, 2026-09-18.';
COMMENT ON COLUMN ref_party.definition IS 'What this party means, in the Parliament''s terms. This is the text to show a reader who asks what a value means, and it is the reason the allowed values live in a table rather than as a bare list inside the schema. Written for a reader of the published data: it may name a published heading, but never a working column, a code, a file, a migration or the error checker, and it never tells anyone what to do. An instruction for whoever enters data goes in the description of the column it is about. See DECISIONS.md, 2026-09-18.';
COMMENT ON COLUMN ref_procedure.definition IS 'What this procedure means, in the Parliament''s terms. This is the text to show a reader who asks what a value means, and it is the reason the allowed values live in a table rather than as a bare list inside the schema. Written for a reader of the published data: it may name a published heading, but never a working column, a code, a file, a migration or the error checker, and it never tells anyone what to do. An instruction for whoever enters data goes in the description of the column it is about. See DECISIONS.md, 2026-09-18.';
COMMENT ON COLUMN ref_source.definition IS 'What this kind of source means, in the Parliament''s terms. This is the text to show a reader who asks what a value means, and it is the reason the allowed values live in a table rather than as a bare list inside the schema. Written for a reader of the published data: it may name a published heading, but never a working column, a code, a file, a migration or the error checker, and it never tells anyone what to do. An instruction for whoever enters data goes in the description of the column it is about. See DECISIONS.md, 2026-09-18.';
COMMENT ON COLUMN ref_stage.definition IS 'What this stage means, in the Parliament''s terms. This is the text to show a reader who asks what a value means, and it is the reason the allowed values live in a table rather than as a bare list inside the schema. Written for a reader of the published data: it may name a published heading, but never a working column, a code, a file, a migration or the error checker, and it never tells anyone what to do. An instruction for whoever enters data goes in the description of the column it is about. See DECISIONS.md, 2026-09-18.';
COMMENT ON COLUMN ref_stage_1_rejection_route.definition IS 'What this route means, in the Parliament''s terms. This is the text to show a reader who asks what a value means, and it is the reason the allowed values live in a table rather than as a bare list inside the schema. Written for a reader of the published data: it may name a published heading, but never a working column, a code, a file, a migration or the error checker, and it never tells anyone what to do. An instruction for whoever enters data goes in the description of the column it is about. See DECISIONS.md, 2026-09-18.';
COMMENT ON COLUMN stage_event.source_ref IS 'The exact place within that source. What goes here depends on the source: for the Parliament''s bill page, legislation.gov.uk or the Supreme Court, the address of the page; for a SPICe legislation fact sheet, the session and the day it was retrieved, e.g. "session 6, retrieved 2026-09-10"; for the SPICe dates fact sheet, its publication date and the page, e.g. "published 2 September 2026, p2"; for a source entered by hand (manual), what the source was. Retrieved fact sheets are kept in sources/factsheets/ in the repository. Published as where_in_the_source.';

DO $$
DECLARE n integer; m text;
BEGIN
  -- Exactly the twenty-nine changed; no label, code or position moved.
  CREATE TEMP TABLE after_defs AS
  SELECT 'ref_assent_block_outcome' AS list, code, label, definition, sort_order FROM ref_assent_block_outcome
  UNION ALL
  SELECT 'ref_assent_block_route' AS list, code, label, definition, sort_order FROM ref_assent_block_route
  UNION ALL
  SELECT 'ref_bill_type' AS list, code, label, definition, sort_order FROM ref_bill_type
  UNION ALL
  SELECT 'ref_bill_type_stated' AS list, code, label, definition, sort_order FROM ref_bill_type_stated
  UNION ALL
  SELECT 'ref_enactment_status' AS list, code, label, definition, sort_order FROM ref_enactment_status
  UNION ALL
  SELECT 'ref_outcome' AS list, code, label, definition, sort_order FROM ref_outcome
  UNION ALL
  SELECT 'ref_party' AS list, code, label, definition, sort_order FROM ref_party
  UNION ALL
  SELECT 'ref_procedure' AS list, code, label, definition, sort_order FROM ref_procedure
  UNION ALL
  SELECT 'ref_source' AS list, code, label, definition, sort_order FROM ref_source
  UNION ALL
  SELECT 'ref_stage' AS list, code, label, definition, sort_order FROM ref_stage
  UNION ALL
  SELECT 'ref_stage_1_rejection_route' AS list, code, label, definition, sort_order FROM ref_stage_1_rejection_route;
  SELECT count(*) INTO n FROM after_defs a JOIN before_defs b USING (list, code)
   WHERE a.definition IS DISTINCT FROM b.definition;
  IF n <> 29 THEN RAISE EXCEPTION '% definitions changed, not 29.', n; END IF;
  SELECT count(*) INTO n FROM after_defs a FULL JOIN before_defs b USING (list, code)
   WHERE a.code IS NULL OR b.code IS NULL OR (a.label, a.sort_order) IS DISTINCT FROM (b.label, b.sort_order);
  IF n > 0 THEN RAISE EXCEPTION '% values added, removed, relabelled or moved.', n; END IF;
  SELECT count(*) INTO n FROM after_defs a JOIN before_defs b USING (list, code)
   WHERE a.list = 'ref_party' AND a.definition IS DISTINCT FROM b.definition;
  IF n > 0 THEN RAISE EXCEPTION 'The party list changed.'; END IF;

  -- On every published list: nothing empty, and nothing written to whoever enters data.
  SELECT string_agg(list||' '||code, ', ') INTO m FROM after_defs
   WHERE list <> 'ref_party' AND coalesce(btrim(definition), '') = '';
  IF m IS NOT NULL THEN RAISE EXCEPTION 'Empty: %', m; END IF;
  SELECT string_agg(list||' '||code, ', ') INTO m FROM after_defs
   WHERE list <> 'ref_party' AND (
         definition ~ '(bill|stage_event|session|field_source|bill_candidate|stage_candidate|ref_[a-z_]+)\.[a-z_]+'
      OR definition ~* 'source_ref|db/[0-9]|sources/|error checker|analysis_group|bill_type_stated|date_concluded|the owner'
      OR definition ~ '''[a-z_]+''' OR definition LIKE '%--%' OR definition LIKE '%`%');
  IF m IS NOT NULL THEN RAISE EXCEPTION 'Still written for whoever enters data: %', m; END IF;
  -- Every word with an underscore in a published definition is a published heading.
  SELECT string_agg(DISTINCT w, ', ') INTO m FROM (
    SELECT (regexp_matches(definition, '\m[a-z0-9]+(?:_[a-z0-9]+)+\M', 'g'))[1] AS w
      FROM after_defs WHERE list <> 'ref_party') x
   WHERE w <> ALL (ARRAY['about', 'act_number', 'applies_to', 'applies_to_file', 'applies_to_heading', 'bill_ended_here', 'bill_number', 'bill_passed', 'bill_type', 'bill_type_at_the_time', 'bill_type_grouped', 'bills', 'carried_scrutiny_from_bill_number', 'date_copy_taken', 'date_ended', 'date_fell_or_withdrawn', 'date_first_meeting', 'date_introduced', 'date_measured_from', 'date_measured_to', 'date_procedure_agreed', 'date_reached', 'date_royal_assent', 'date_session_ended', 'date_session_expected_to_end', 'date_source_read', 'date_stopped_before_assent', 'days', 'days_between_stages', 'enactment_status', 'file', 'first_stage', 'first_stage_ended', 'got_through', 'got_through_the_later_stage', 'heading', 'how_rejected_at_stage_1', 'how_stopped_before_assent', 'is_the_current_session', 'measured_from', 'measured_to', 'methodology_notes', 'new_value', 'note', 'old_value', 'order', 'outcome', 'outcome_after_being_stopped', 'procedure', 'reconsideration_ended', 'reconsideration_reached', 'rows', 'rows_added_since_last_copy', 'second_stage', 'second_stage_ended', 'session', 'sessions', 'source', 'sources', 'sp_bill_number', 'stage', 'stage_never_happened', 'stage_position', 'stages', 'text', 'third_stage', 'third_stage_ended', 'title', 'title_as_introduced', 'title_changed_at_stage', 'value', 'value_as_the_source_gave_it', 'what_changed', 'what_it_means', 'what_the_words_mean', 'where_in_the_source', 'why_there_is_no_date']);
  IF m IS NOT NULL THEN RAISE EXCEPTION 'Not a published heading: %', m; END IF;

  -- Every value a bill uses has a definition.
  SELECT string_agg(DISTINCT v, ', ') INTO m FROM (
    SELECT 'bill_type '||bill_type AS v FROM bill WHERE bill_type NOT IN (SELECT code FROM ref_bill_type WHERE coalesce(definition,'')<>'')
    UNION ALL SELECT 'stated '||bill_type_stated FROM bill WHERE bill_type_stated NOT IN (SELECT code FROM ref_bill_type_stated WHERE coalesce(definition,'')<>'')
    UNION ALL SELECT 'outcome '||outcome FROM bill WHERE outcome NOT IN (SELECT code FROM ref_outcome WHERE coalesce(definition,'')<>'')
    UNION ALL SELECT 'enactment '||enactment_status FROM bill WHERE enactment_status NOT IN (SELECT code FROM ref_enactment_status WHERE coalesce(definition,'')<>'')
    UNION ALL SELECT 'procedure '||procedure FROM bill WHERE procedure NOT IN (SELECT code FROM ref_procedure WHERE coalesce(definition,'')<>'')
    UNION ALL SELECT 'route '||stage_1_rejection_route FROM bill WHERE stage_1_rejection_route NOT IN (SELECT code FROM ref_stage_1_rejection_route WHERE coalesce(definition,'')<>'')
    UNION ALL SELECT 'block '||assent_block_route FROM bill WHERE assent_block_route NOT IN (SELECT code FROM ref_assent_block_route WHERE coalesce(definition,'')<>'')
    UNION ALL SELECT 'after '||assent_block_outcome FROM bill WHERE assent_block_outcome NOT IN (SELECT code FROM ref_assent_block_outcome WHERE coalesce(definition,'')<>'')
    UNION ALL SELECT 'stage '||stage FROM stage_event WHERE stage NOT IN (SELECT code FROM ref_stage WHERE coalesce(definition,'')<>'')
    UNION ALL SELECT 'source '||source FROM (SELECT source FROM bill UNION ALL SELECT source FROM stage_event UNION ALL SELECT source FROM field_source) s
      WHERE source NOT IN (SELECT code FROM ref_source WHERE coalesce(definition,'')<>'')) x;
  IF m IS NOT NULL THEN RAISE EXCEPTION 'Used with no definition: %', m; END IF;

  -- The corrected facts are true of the bills they describe.
  SELECT count(*) INTO n FROM bill WHERE assent_block_route = 's33_reference';
  IF n <> 3 THEN RAISE EXCEPTION '% section 33 bills, the definition says three.', n; END IF;
  SELECT count(*) INTO n FROM bill WHERE assent_block_route = 's33_reference' AND session_number = 5;
  IF n <> 3 THEN RAISE EXCEPTION 'Not all three section 33 bills are Session 5.'; END IF;
  SELECT count(*) INTO n FROM bill WHERE assent_block_route = 's33_reference'
     AND short_title = 'UK Withdrawal from the European Union (Legal Continuity) (Scotland) Bill' AND date_assent_blocked = '2018-12-13';
  IF n <> 1 THEN RAISE EXCEPTION 'The Legal Continuity Bill is not ruled on 13 December 2018.'; END IF;
  SELECT count(*) INTO n FROM bill WHERE assent_block_route = 's33_reference' AND date_assent_blocked = '2021-10-06';
  IF n <> 2 THEN RAISE EXCEPTION '% bills ruled on 6 October 2021, the definition says two.', n; END IF;
  SELECT count(*) INTO n FROM bill b WHERE b.assent_block_route = 's33_reference' AND EXISTS (
     SELECT 1 FROM field_source f WHERE f.entity = 'bill' AND f.entity_id = b.bill_id
        AND f.value_seen LIKE 'Following a reference under section 33%');
  IF n <> 3 THEN RAISE EXCEPTION 'The footnote is word for word in the sources for % bills, not three.', n; END IF;
  SELECT count(*) INTO n FROM (SELECT source, source_ref FROM bill UNION ALL SELECT source, source_ref FROM stage_event
     UNION ALL SELECT source, source_ref FROM field_source) s WHERE source = 'manual' AND coalesce(btrim(source_ref), '') = '';
  IF n > 0 THEN RAISE EXCEPTION '% manual lines do not say which source in where_in_the_source.', n; END IF;
  SELECT count(*) INTO n FROM bill WHERE assent_block_route IS NOT NULL;
  IF n <> 4 THEN RAISE EXCEPTION '% bills stopped, the descriptions say all but four are empty.', n; END IF;
  SELECT count(*) INTO n FROM bill WHERE outcome = 'fell_other' OR stage_1_rejection_route = 'other_route' OR assent_block_outcome = 'reconsidered_fell';
  IF n > 0 THEN RAISE EXCEPTION 'A bill uses a value its definition says no bill uses.'; END IF;
  SELECT count(*) INTO n FROM (SELECT source FROM bill UNION ALL SELECT source FROM stage_event UNION ALL SELECT source FROM field_source) s
   WHERE source IN ('api', 'bill_document');
  IF n > 0 THEN RAISE EXCEPTION 'A fact rests on a source its definition says nothing rests on.'; END IF;
  SELECT count(*) INTO n FROM bill WHERE bill_type = 'hybrid';
  IF n <> 1 THEN RAISE EXCEPTION '% Hybrid Bills, the definition says one.', n; END IF;
  SELECT count(*) INTO n FROM bill WHERE outcome = 'fell_financial_resolution_not_agreed';
  IF n <> 1 THEN RAISE EXCEPTION 'The financial resolution definition says one bill.'; END IF;
  SELECT count(*) INTO n FROM bill WHERE assent_block_outcome = 'reconsidered_passed';
  IF n <> 2 THEN RAISE EXCEPTION 'Reconsidered and passed says two bills.'; END IF;

  -- Nothing else in the database moved.
  SELECT count(*) INTO n FROM methodology_note; IF n <> 14 THEN RAISE EXCEPTION '% notes', n; END IF;
  SELECT count(*) INTO n FROM bill; IF n <> 470 THEN RAISE EXCEPTION '% bills', n; END IF;
  SELECT count(*) INTO n FROM stage_event; IF n <> 1291 THEN RAISE EXCEPTION '% stage records', n; END IF;
  SELECT count(*) INTO n FROM field_source; IF n <> 192 THEN RAISE EXCEPTION '% provenance notes', n; END IF;
  SELECT count(*) INTO n FROM v_candidate_problems; IF n <> 0 THEN RAISE EXCEPTION 'checker %', n; END IF;
  SELECT count(*) INTO n FROM v_stage_date_gaps; IF n <> 0 THEN RAISE EXCEPTION 'gaps %', n; END IF;

  RAISE NOTICE 'Twenty-nine definitions rewritten for a reader; % column descriptions changed; nothing else moved.', 22;
END $$;

COMMIT;
