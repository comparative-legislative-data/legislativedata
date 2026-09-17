-- db/109_m7_rewritten_and_two_votes_reach_their_provenance.sql
--
-- Settled by the owner on 2026-09-17, on the draft in docs/PHASE-2-NOTES.md
-- ("M7"), with the question under it answered and a second bill added.
--
-- M7 REWRITTEN. It said the coding of why a bill fell was done for Sessions 1 to
-- 5 (Session 6 is done too, and this was the third time the note lagged); that
-- uncoded sessions show a general code (no bill has one); that every ending is
-- coded against the Official Report (true of 31 bills; the 17 that ran out of
-- time rest on SPICe's dates of dissolution); that a bill which ran out of time
-- was never voted on (five had completed a stage); argued the single heading
-- the wrong way round; counted "one bill in the first five sessions"; explained
-- how Sessions 1 and 2 were worked out; and named columns. It now states the
-- rule rather than which sessions are done, so it cannot lag by that route
-- again: the error checker will not accept a fallen line that is not coded.
-- Kept, as settled on 2026-09-14: both divisions for a bill rejected by its own
-- amended motion, and that division figures are text until a record of how
-- members voted supersedes them.
--
-- TWO VOTES THAT NEVER REACHED THEIR PROVENANCE. M7 now says the figures of the
-- division are recorded with every rejection. Two Session 3 lines, read on
-- 2026-09-13, carry the Official Report's result in their review note, but
-- after the link. Promotion keeps only the words before the link as the value
-- seen (tools/promote_session.sql, "An outcome read out of the Official
-- Report"), so the result was cut, as it was designed to cut commentary:
--   * 211, Budget (Scotland) (No.2) Bill, rejected at Stage 3 on 28 January
--     2009: For 64, Against 64, the Presiding Officer's casting vote against.
--   * 213, Creative Scotland Bill, fell on 18 June 2008 when its financial
--     resolution was not agreed: For 49, Against 68. The owner added this one
--     on 2026-09-17: the same fault in the same session.
-- Both results were checked again against the Official Report's PDFs on
-- 2026-09-17 and match. Each note is rearranged so the Official Report's words
-- come before "Read at" and the link, and our own commentary after it, which is
-- how Sessions 4 to 6 were written. No word is added or lost, except "Read at",
-- and "WERE" in 213's note becomes "were". Each gains a line saying so, and its
-- review time moves to today, as db/105's did. official_report_read_on stays
-- 2026-09-13: that is when the words were read.
--
-- WHAT IS NOT CHANGED. Sixteen Stage 1 rejections in Sessions 1 to 3 have their
-- result after the link too. Their figures reach the provenance note on how
-- the bill was rejected, which is read from "Result as recorded" wherever it
-- sits, so every one is already recorded with its rejection.
--
-- The clean sheet changes when Session 3 is taken off and put back, which
-- follows this migration. No later line continues a Session 3 bill, and no
-- bill was reintroduced from one.

\set ON_ERROR_STOP on
BEGIN;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM methodology_note
   WHERE code = 'M7' AND body LIKE '%at the time of writing it has been done for Sessions 1, 2, 3, 4 and 5%';
  IF n <> 1 THEN RAISE EXCEPTION 'Refusing: M7 is not the wording this replaces.'; END IF;

  SELECT count(*) INTO n FROM bill_candidate
   WHERE (candidate_id, md5(review_note)) IN ((211, '16b39dfe359b207f08f70970aaea9c53'),
                                             (213, 'bf533f09f2473ef3c958072b7e0db5d4'));
  IF n <> 2 THEN RAISE EXCEPTION 'Refusing: lines 211 and 213 are not as they were read.'; END IF;

  SELECT count(*) INTO n FROM bill; IF n <> 470 THEN RAISE EXCEPTION 'Refusing: % bills', n; END IF;
  SELECT count(*) INTO n FROM field_source; IF n <> 192 THEN RAISE EXCEPTION 'Refusing: % provenance notes', n; END IF;
END $$;

CREATE TEMP TABLE before_lines ON COMMIT DROP AS
SELECT candidate_id, review_note FROM bill_candidate WHERE candidate_id IN (211, 213);
CREATE TEMP TABLE before_notes ON COMMIT DROP AS
SELECT code, title, body, applies_to, sort_order FROM methodology_note;

-- ---------------------------------------------------------------------------
-- 1. The two lines
-- ---------------------------------------------------------------------------

UPDATE bill_candidate
   SET review_note = 'Outcome from the Official Report, not the factsheet: the bill was rejected at Stage 3, 28 January 2009, on the motion S3M-3299 in the name of John Swinney that it be passed. Result as recorded: "For 64, Against 64, Abstentions 0. It is a well-established convention here and elsewhere that Presiding Officers cast in favour of the status quo. As the passing of the bill would result in a change to the present position with regard to the budget, and as I advised all business managers, I cast my vote against the motion. Motion disagreed to." The Presiding Officer then: "The Budget (Scotland) (No 2) Bill therefore falls." Read at https://www.parliament.scot/api/sitecore/CustomMedia/OfficialReport?meetingId=4843 The division was tied and the Presiding Officer''s casting vote decided it, against the motion and for the status quo.'
         || E'\n' || 'Rearranged on 2026-09-17 so the result as recorded comes before the link, which is where promotion stops reading the value seen; no word changed. The result was checked again against the Official Report on 2026-09-17. See db/109.',
       reviewed_at = now()
 WHERE candidate_id = 211;

UPDATE bill_candidate
   SET review_note = 'Outcome from the Official Report, not the factsheet: the bill fell on 18 June 2008 because the financial resolution was not agreed. Its general principles were agreed the same day, on motion S3M-2028 in the name of Linda Fabiani: "Motion agreed to. That the Parliament agrees to the general principles of the Creative Scotland Bill." The financial resolution, motion S3M-1776 in the name of John Swinney, was then put. Result as recorded: "For 49, Against 68, Abstentions 0. Motion disagreed to." The Presiding Officer then: "Standing orders are quite clear; the Creative Scotland Bill therefore falls." Read at https://www.parliament.scot/api/sitecore/CustomMedia/OfficialReport?meetingId=4805 The Parliament''s own bill page says the bill "fell at Stage 1", which this record contradicts: Stage 1 was completed.'
         || E'\n' || 'Rearranged on 2026-09-17 so the result as recorded comes before the link, which is where promotion stops reading the value seen; no word changed but "WERE", now "were". The result was checked again against the Official Report on 2026-09-17. See db/109.',
       reviewed_at = now()
 WHERE candidate_id = 213;

-- ---------------------------------------------------------------------------
-- 2. M7
-- ---------------------------------------------------------------------------

UPDATE methodology_note SET body = 'The Parliament''s legislation fact sheets list every bill that did not pass, other than those withdrawn, under one heading, "Bills which have fallen", and do not say why. The reasons are different events: the Parliament refusing a bill''s general principles at Stage 1, the Parliament defeating it at the final vote, and a bill still waiting for its next stage when the session ended. This resource records which happened. That is our coding, not the fact sheets''. Every bill that fell is coded, and each names the source its coding rests on.

A bill is recorded as rejected at Stage 1 or at Stage 3 where the Official Report records the Parliament deciding against it, and the figures of the division are recorded with it. A bill is recorded as having fallen at dissolution where it ended on the day its session ended, taken from SPICe''s fact sheet of recess and dissolution dates. Such a bill may have completed a stage or two first, but the Parliament took no decision against it.

A bill rejected at Stage 1 was rejected in one of three ways. Usually the Parliament disagreed to the member in charge''s motion that its general principles be agreed to. Or that motion was amended so as not to agree to them, and then agreed to as amended: the motion carried and the bill fell, and both divisions are given in the bill''s note, since either alone would mislead. Or, for a Member''s Bill only, the Parliament agreed to the lead committee''s motion under Rule 9.14.18 that the general principles not be agreed to. The rule allows this where, in the committee''s opinion, the case for the bill or for legislating at all has not been shown, the bill is clearly outwith legislative competence, or its drafting cannot be put right by amendment. The motion does not say which; where the committee''s grounds allow a view, the bill''s note gives ours. The rule is read as worded in the current Standing Orders, and taken to be unchanged since 2006.

A bill can also fall for want of a financial resolution, which under Rule 9.12 a bill charging public funds needs before Stage 2. The Parliament agreed the general principles of the Creative Scotland Bill on 18 June 2008 and did not agree its financial resolution the same afternoon. It is recorded as having fallen for that reason, and not as rejected. The Parliament''s bill page says it fell at Stage 1; this resource follows the Official Report of that day.

Division figures given beside a bill are text, not data, and cannot be counted. A structured record of how members voted is not yet part of this resource, and when it is added it supersedes them.'
 WHERE code = 'M7';

-- ---------------------------------------------------------------------------
-- 3. Proof
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer;
BEGIN
  -- The same words, in a different order: the first line of each new note,
  -- less "Read at", against the old note, ignoring case.
  SELECT count(*) INTO n FROM before_lines b JOIN bill_candidate c USING (candidate_id)
   WHERE (SELECT array_agg(w ORDER BY w) FROM unnest(regexp_split_to_array(lower(b.review_note), '\s+')) w)
         IS DISTINCT FROM
         (SELECT array_agg(w ORDER BY w) FROM unnest(regexp_split_to_array(
            lower(replace(split_part(c.review_note, E'\n', 1), ' Read at ', ' ')), '\s+')) w);
  IF n > 0 THEN RAISE EXCEPTION '% line(s) gained or lost a word.', n; END IF;

  -- What promotion will take as the value seen, by its own expression.
  SELECT count(*) INTO n FROM bill_candidate c
   WHERE c.candidate_id IN (211, 213)
     AND regexp_replace(regexp_replace(c.review_note, '^Outcome from the Official Report, not the factsheet:\s*', ''),
                        '\s*(Read at\s*)?https?://.*$', '')
         ~ 'Result as recorded: "For (64, Against 64|49, Against 68), Abstentions 0\.'
     AND regexp_replace(regexp_replace(c.review_note, '^Outcome from the Official Report, not the factsheet:\s*', ''),
                        '\s*(Read at\s*)?https?://.*$', '')
         !~ '(casting vote decided it|fell at Stage 1|Rearranged)';
  IF n <> 2 THEN RAISE EXCEPTION 'Promotion would not read the two results as intended.'; END IF;

  SELECT count(*) INTO n FROM methodology_note m JOIN before_notes b USING (code)
   WHERE (m.code <> 'M7' AND (m.title, m.body, m.applies_to, m.sort_order)
          IS DISTINCT FROM (b.title, b.body, b.applies_to, b.sort_order))
      OR (m.title, m.applies_to, m.sort_order) IS DISTINCT FROM (b.title, b.applies_to, b.sort_order);
  IF n > 0 THEN RAISE EXCEPTION '% note(s) changed beyond M7''s body.', n; END IF;

  SELECT count(*) INTO n FROM methodology_note WHERE code = 'M7' AND body ~ '[a-z_]+\.[a-z_]+';
  IF n > 0 THEN RAISE EXCEPTION 'M7 names a column.'; END IF;

  SELECT count(*) INTO n FROM v_candidate_problems; IF n <> 0 THEN RAISE EXCEPTION 'checker %', n; END IF;
  SELECT count(*) INTO n FROM methodology_note; IF n <> 14 THEN RAISE EXCEPTION '% notes', n; END IF;
  SELECT count(*) INTO n FROM bill; IF n <> 470 THEN RAISE EXCEPTION '% bills', n; END IF;
  SELECT count(*) INTO n FROM field_source; IF n <> 192 THEN RAISE EXCEPTION '% provenance notes', n; END IF;

  RAISE NOTICE 'M7 rewritten; lines 211 and 213 rearranged. The clean sheet is unchanged until Session 3 is put back.';
END $$;

COMMIT;
