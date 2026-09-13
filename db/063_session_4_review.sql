-- db/063_session_4_review.sql
--
-- Session 4's review, from the owner's eight answers of 2026-09-13. Every one
-- was then read in the source it names and the words quoted on the line.
-- See DECISIONS.md.
--
-- Five bills the factsheet says fell without saying why. All five were rejected
-- at Stage 1, and four of them in the ordinary way: the member in charge's
-- motion put and disagreed to. The fifth, the Transplantation Bill, is the
-- second case this database has of the other route -- the member's own motion
-- amended into one that does not agree to the general principles, and then
-- agreed to as amended, so the motion passed and the bill fell. The first was
-- in Session 3.
--
-- Two dates where the fact sheet and the owner's dataset disagreed. The Land
-- Reform Act's Royal Assent is 22 April 2016 on legislation.gov.uk, which is
-- the document of record for it, so the fact sheet's 22 March is wrong and the
-- dataset right. The National Galleries Act's introduction is 25 June 2015 on
-- the owner's own record, so the fact sheet is right and the dataset wrong by a
-- day; the Parliament's page for that bill redirects into the National Records
-- of Scotland web archive, which blocks reading, so it could not settle it.
--
-- One Act whose number carried no year, settled under db/062.
--
-- What is NOT recorded, said plainly rather than left to be discovered. The
-- Transplantation amendment's own wording is not printed on the Official Report
-- page for that day: the page gives the question the Presiding Officer put and
-- both results, and nothing more. The note quotes what is there and does not
-- reconstruct the rest. If the amendment's text is wanted for a reader it has
-- to come from the Business Bulletin or the bill's own page.
--
-- This only changes the staging sheet. Session 4 is not on the clean sheet.

\set ON_ERROR_STOP on
BEGIN;

CREATE TEMP TABLE before_counts ON COMMIT DROP AS
SELECT (SELECT count(*) FROM bill_candidate WHERE session_number = 4)        AS lines,
       (SELECT count(*) FROM bill_candidate
         WHERE session_number = 4 AND outcome IS NULL)                       AS without_an_outcome,
       (SELECT count(*) FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
         WHERE c.session_number = 4)                                         AS stage_rows,
       (SELECT count(*) FROM v_candidate_problems)                           AS problems,
       (SELECT count(*) FROM bill)                                           AS clean_bills;

DO $$
DECLARE b record;
BEGIN
  SELECT * INTO b FROM before_counts;
  IF b.lines <> 86 THEN RAISE EXCEPTION 'Refusing: expected 86 Session 4 lines, found %.', b.lines; END IF;
  IF b.without_an_outcome <> 5 THEN
    RAISE EXCEPTION 'Refusing: expected 5 lines with no outcome, found %.', b.without_an_outcome;
  END IF;
  IF b.problems <> 8 THEN
    RAISE EXCEPTION 'Refusing: expected 8 items on the review list, found %.', b.problems;
  END IF;
  RAISE NOTICE 'Before: 86 lines, % with no outcome, % stage rows, % problems.',
               b.without_an_outcome, b.stage_rows, b.problems;
END $$;

-- ---------------------------------------------------------------------------
-- 1. Why the five bills fell, and where each stopped
-- ---------------------------------------------------------------------------

CREATE TEMP TABLE coding (
    candidate_id integer, title_fragment text, outcome text, route text,
    decided_on date, stage text, completed boolean, url text, note text
) ON COMMIT DROP;

INSERT INTO coding VALUES
 (297, 'Alcohol (Licensing', 'rejected_stage_1', 'member_motion_disagreed',
  DATE '2016-02-04', 'stage_1', false,
  'https://www.parliament.scot/chamber-and-committees/official-report/search-what-was-said-in-parliament/meeting-of-parliament-04-02-2016?meeting=10353&iob=95300',
  'Outcome from the Official Report, not the factsheet: general principles not agreed to at '
  || 'Stage 1, 4 February 2016. Route: the member''s motion, S4M-14673 in the name of Richard '
  || 'Simpson, disagreed to at Decision Time. Result as recorded: "For 36, Against 59, '
  || 'Abstentions 12. Motion disagreed to."'),

 (298, 'Assisted Suicide', 'rejected_stage_1', 'member_motion_disagreed',
  DATE '2015-05-27', 'stage_1', false,
  'https://www.parliament.scot/chamber-and-committees/official-report/search-what-was-said-in-parliament/meeting-of-parliament-27-05-2015?meeting=9970&iob=91581',
  'Outcome from the Official Report, not the factsheet: general principles not agreed to at '
  || 'Stage 1, 27 May 2015. Route: the member''s motion, S4M-13258 in the name of Patrick '
  || 'Harvie, disagreed to. Result as recorded: "For 36, Against 82, Abstentions 0. '
  || 'Motion disagreed to."'),

 (299, 'Criminal Verdicts', 'rejected_stage_1', 'member_motion_disagreed',
  DATE '2016-02-25', 'stage_1', false,
  'https://www.parliament.scot/chamber-and-committees/official-report/search-what-was-said-in-parliament/meeting-of-parliament-25-02-2016?meeting=10386&iob=95620',
  'Outcome from the Official Report, not the factsheet: general principles not agreed to at '
  || 'Stage 1, 25 February 2016. Route: the member''s motion, S4M-15429, disagreed to. '
  || 'Result as recorded: "For 28, Against 80, Abstentions 0. Motion disagreed to."'),

 (301, 'Pentland Hills', 'rejected_stage_1', 'member_motion_disagreed',
  DATE '2016-01-26', 'stage_1', false,
  'https://www.parliament.scot/chamber-and-committees/official-report/search-what-was-said-in-parliament/meeting-of-parliament-26-01-2016?meeting=10333&iob=95047',
  'Outcome from the Official Report, not the factsheet: general principles not agreed to at '
  || 'Stage 1, 26 January 2016. Route: the member''s motion, S4M-15130 in the name of '
  || 'Christine Grahame, disagreed to. Result as recorded: "For 8, Against 105, Abstentions 0. '
  || 'Motion disagreed to."'),

 (302, 'Transplantation', 'rejected_stage_1', 'member_motion_amended_agreed',
  DATE '2016-02-09', 'stage_1', false,
  'https://www.parliament.scot/chamber-and-committees/official-report/search-what-was-said-in-parliament/meeting-of-parliament-09-02-2016?meeting=10362&iob=95337',
  'Outcome from the Official Report, not the factsheet: general principles not agreed to at '
  || 'Stage 1, 9 February 2016. Route: the member''s own motion, S4M-15128 in the name of Anne '
  || 'McTaggart, amended into one that does not agree to the general principles and then '
  || 'agreed to as amended, so the motion carried and the bill fell. The amendment was '
  || 'S4M-15128.1 in the name of Maureen Watt. The Presiding Officer put it as: "The first '
  || 'question is, that amendment S4M-15128.1, in the name of Maureen Watt, which seeks to '
  || 'amend motion S4M-15128, in the name of Anne McTaggart, on the Transplantation '
  || '(Authorisation of Removal of Organs etc) (Scotland) Bill, be agreed to." Result as '
  || 'recorded: "For 59, Against 56, Abstentions 0. Amendment agreed to." Then on the motion '
  || 'as amended: "For 65, Against 48, Abstentions 2. Motion, as amended, agreed to." The '
  || 'amendment''s own wording is not printed on this page.');

-- A mistyped line number must fail here, not write to the wrong bill.
DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM coding a JOIN bill_candidate c USING (candidate_id)
   WHERE c.short_title NOT ILIKE '%' || a.title_fragment || '%';
  IF n > 0 THEN RAISE EXCEPTION 'Refusing: % coding row(s) name a line whose title does not match.', n; END IF;
  SELECT count(*) INTO n FROM coding a JOIN bill_candidate c USING (candidate_id)
   WHERE c.outcome IS NOT NULL;
  IF n > 0 THEN RAISE EXCEPTION 'Refusing: % line(s) already hold an outcome.', n; END IF;
  SELECT count(*) INTO n FROM coding a JOIN bill_candidate c USING (candidate_id)
   WHERE c.date_concluded IS DISTINCT FROM a.decided_on;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % line(s) conclude on a day other than the one the Official Report gives.', n;
  END IF;
  SELECT count(*) INTO n FROM coding a JOIN bill_candidate c USING (candidate_id)
   WHERE c.bill_type <> 'members';
  IF n > 0 THEN RAISE EXCEPTION 'Refusing: % line(s) are not Member''s Bills.', n; END IF;
END $$;

UPDATE bill_candidate c
   SET outcome                 = a.outcome,
       stage_1_rejection_route = a.route,
       official_report_read_on = DATE '2026-09-13',
       -- The address goes on the LINE, not only on the stage-dates row. db/055
       -- put it on the stage row alone and db/058 had to repair it, because
       -- promotion writes a bill's citation from the line and would otherwise
       -- have written it empty with nothing saying so. It is taken from the
       -- same coding row that fills the stage row, so the two cannot differ.
       review_note             = btrim(coalesce(c.review_note || E'\n', '')
                                       || a.note || ' Read at ' || a.url)
  FROM coding a
 WHERE a.candidate_id = c.candidate_id;

-- The amended-into-the-negative route keeps its detail where a reader meets it,
-- as ref_stage_1_rejection_route requires.
UPDATE bill_candidate
   SET bill_note = btrim(coalesce(bill_note || E'\n', '')
       || 'Rejected at Stage 1 by the unusual route: the member in charge''s own motion, '
       || 'S4M-15128 in the name of Anne McTaggart, was amended by S4M-15128.1 in the name of '
       || 'Maureen Watt into a motion that did not agree to the bill''s general principles, and '
       || 'was then agreed to as amended on 9 February 2016. The motion carried and the bill '
       || 'fell, so the fate of the motion and the fate of the bill point opposite ways. The '
       || 'amendment''s own wording is not printed in the Official Report for that day.')
 WHERE candidate_id = 302;

INSERT INTO stage_candidate
       (candidate_id, stage, date_completed, completed, fell_here,
        source, source_ref, observed_at)
SELECT a.candidate_id, a.stage, a.decided_on, a.completed, NOT a.completed,
       'official_report', a.url, DATE '2026-09-13'
  FROM coding a;

-- ---------------------------------------------------------------------------
-- 2. The two dates the owner adjudicated, and the Act number db/062 asked for
--
--    The citation is the fixed form promotion reads to write the provenance
--    note: Checked: <column> = <value> (<source>, <address>, <date read>).
--    A confirmed value is cited as well as a corrected one -- what it records
--    is that somebody looked.
-- ---------------------------------------------------------------------------

UPDATE bill_candidate
   SET date_royal_assent = DATE '2016-04-22',
       review_note = btrim(coalesce(review_note || E'\n', '')
         || 'Checked: date_royal_assent = 2016-04-22 (legislation_gov_uk, '
         || 'https://www.legislation.gov.uk/asp/2016/18/introduction, 2026-09-13)' || E'\n'
         || 'The factsheet prints 22 March 2016 and is wrong; legislation.gov.uk is the '
         || 'document of record for Royal Assent and states "The Bill for this Act of the '
         || 'Scottish Parliament was passed by the Parliament on 16th March 2016 and received '
         || 'Royal Assent on 22nd April 2016". The owner''s dataset agrees with it.')
 WHERE candidate_id = 261;

UPDATE bill_candidate
   SET review_note = btrim(coalesce(review_note || E'\n', '')
         || 'Checked: date_introduced = 2015-06-25 (manual, '
         || 'the owner''s own record of this bill - the Parliament''s page for it redirects '
         || 'into the National Records of Scotland web archive which blocks reading, '
         || '2026-09-13)' || E'\n'
         || 'The factsheet''s 25 June 2015 stands and the owner''s dataset is a day out at '
         || '26 June.')
 WHERE candidate_id = 270;

UPDATE bill_candidate
   SET short_title = 'Higher Education Governance (Scotland) Act 2016',
       asp_number  = '2016 asp 15',
       review_note = btrim(coalesce(review_note || E'\n', '')
         || 'Checked: asp_number = 2016 asp 15 (legislation_gov_uk, '
         || 'https://www.legislation.gov.uk/asp/2016/15/contents, 2026-09-13)' || E'\n'
         || 'Checked: short_title = Higher Education Governance (Scotland) Act 2016 '
         || '(legislation_gov_uk, https://www.legislation.gov.uk/asp/2016/15/contents, '
         || '2026-09-13)' || E'\n'
         || 'The factsheet prints the title with no year in it and so the number with none '
         || 'either, uniquely among its Acts; both cells are settled here. See db/062 and '
         || 'DECISIONS.md, 2026-09-13.')
 WHERE candidate_id = 253;

-- ---------------------------------------------------------------------------
-- 3. What must be true afterwards.
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer; b record;
BEGIN
  SELECT * INTO b FROM before_counts;

  IF (SELECT count(*) FROM bill_candidate WHERE session_number = 4) <> 86 THEN
    RAISE EXCEPTION 'Check failed: Session 4 no longer has 86 lines.';
  END IF;
  SELECT count(*) INTO n FROM bill_candidate WHERE session_number = 4 AND outcome IS NULL;
  IF n <> 0 THEN RAISE EXCEPTION 'Check failed: % Session 4 line(s) still have no outcome.', n; END IF;

  SELECT count(*) INTO n FROM bill_candidate
   WHERE session_number = 4 AND outcome = 'rejected_stage_1';
  IF n <> 5 THEN RAISE EXCEPTION 'Check failed: expected 5 Stage 1 rejections, found %.', n; END IF;

  SELECT count(*) INTO n FROM bill_candidate
   WHERE session_number = 4 AND stage_1_rejection_route = 'member_motion_amended_agreed';
  IF n <> 1 THEN RAISE EXCEPTION 'Check failed: expected 1 amended-into-the-negative route, found %.', n; END IF;

  -- One stage row per bill that fell, each marked as where it fell.
  SELECT count(*) INTO n FROM stage_candidate t JOIN coding a USING (candidate_id)
   WHERE t.fell_here AND NOT t.completed AND t.date_completed = a.decided_on
     AND t.source = 'official_report';
  IF n <> 5 THEN RAISE EXCEPTION 'Check failed: expected 5 stage rows where a bill fell, found %.', n; END IF;

  -- The three adjudications landed on the right cells.
  SELECT count(*) INTO n FROM bill_candidate
   WHERE candidate_id = 261 AND date_royal_assent = DATE '2016-04-22';
  IF n <> 1 THEN RAISE EXCEPTION 'Check failed: the Land Reform Royal Assent date was not written.'; END IF;
  SELECT count(*) INTO n FROM bill_candidate
   WHERE candidate_id = 270 AND date_introduced = DATE '2015-06-25';
  IF n <> 1 THEN RAISE EXCEPTION 'Check failed: the National Galleries introduction date moved.'; END IF;
  SELECT count(*) INTO n FROM bill_candidate
   WHERE candidate_id = 253 AND asp_number = '2016 asp 15'
     AND short_title = 'Higher Education Governance (Scotland) Act 2016';
  IF n <> 1 THEN RAISE EXCEPTION 'Check failed: the Higher Education Governance title and number were not settled.'; END IF;

  -- Every citation on a Session 4 line is in the form promotion can read, and
  -- promotion will therefore write a provenance note for each. This is the
  -- check that catches a citation whose value contains a bracket.
  SELECT count(*) INTO n
    FROM bill_candidate c
   WHERE c.session_number = 4
     AND (length(coalesce(c.review_note, '')) - length(replace(coalesce(c.review_note, ''), 'Checked: ', '')))
         / length('Checked: ')
       <> (SELECT count(*) FROM regexp_matches(coalesce(c.review_note, ''),
             'Checked: ([a-z0-9_]+) = ([^\n]+?) \(([a-z_]+), ([^,]+), (\d{4}-\d{2}-\d{2})\)', 'g'));
  IF n > 0 THEN
    RAISE EXCEPTION 'Check failed: % line(s) carry a "Checked:" citation promotion cannot read.', n;
  END IF;

  -- The address on the line is the same one the stage row cites.
  SELECT count(*) INTO n FROM coding a
    JOIN bill_candidate c USING (candidate_id)
    JOIN stage_candidate t ON t.candidate_id = a.candidate_id
   WHERE t.source = 'official_report'
     AND (position(t.source_ref in coalesce(c.review_note, '')) = 0
          OR t.source_ref IS DISTINCT FROM a.url);
  IF n > 0 THEN
    RAISE EXCEPTION 'Check failed: % line(s) do not carry the address their stage row cites.', n;
  END IF;

  -- Nothing reached the clean sheet.
  IF (SELECT count(*) FROM bill) <> b.clean_bills THEN
    RAISE EXCEPTION 'Check failed: the clean sheet moved.';
  END IF;

  -- The review list is empty: every one of the eight is answered.
  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n <> 0 THEN
    RAISE EXCEPTION 'Check failed: the error checker still holds % item(s).', n;
  END IF;

  RAISE NOTICE 'After: 86 Session 4 lines, all with an outcome, 5 rejected at Stage 1, % stage rows, checker empty.',
               (SELECT count(*) FROM stage_candidate t JOIN bill_candidate c USING (candidate_id)
                 WHERE c.session_number = 4);
END $$;

COMMIT;
