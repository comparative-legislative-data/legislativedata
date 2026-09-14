-- db/089_session_6_three_dates_and_two_titles_adjudicated.sql
--
-- The five cells where Session 6's fact sheet and the owner's dataset give
-- different values. Three are dates the comparison found when the six
-- hand-pairings were added to MANUAL_PAIRS on 2026-09-14; two are Act titles,
-- which the comparison does not compare and which surfaced instead as lines it
-- could not pair. Each was then read at the source that owns the value. This is
-- db/043, db/054 and db/074 again, in the same "Checked:" form db/042
-- established, and there is nothing new in it.
--
-- Two dates go the dataset's way and one goes the fact sheet's; of the titles,
-- one goes each way. That is the usual split: neither source is the authority,
-- and each cell is settled where the value is published (db/067).
--
--   Line 390, Building Safety Levy (Scotland) Bill. Introduction. Fact sheet
--     5 June 2025, dataset 9 June 2025. The Parliament's page for the bill:
--     "The Bill was introduced on 5 June 2025". The line already holds 5 June
--     and does not move; what changes is that somebody has now looked, which is
--     what the citation records.
--
--   Line 424, Carer's Allowance Supplement (Scotland) Act 2021. Royal Assent.
--     Fact sheet 16 November 2021, dataset 15 November 2021.
--     legislation.gov.uk: "The Bill for this Act of the Scottish Parliament was
--     passed by the Parliament on 7th October 2021 and received Royal Assent on
--     15th November 2021". The fact sheet is a day out and this cell moves.
--
--   Line 465, Transvaginal Mesh Removal (Cost Reimbursement) (Scotland) Act
--     2022. Royal Assent. Fact sheet 4 March 2022, dataset 3 March 2022.
--     legislation.gov.uk: "The Bill for this Act of the Scottish Parliament was
--     passed by the Parliament on 25th January 2022 and received Royal Assent
--     on 3rd March 2022". The fact sheet is a day out and this cell moves.
--
--   Line 432, the Coronavirus self-isolation Act 2022. Title. The dataset calls
--     it "Discretionary Payments for Self-Isolation" and the fact sheet
--     "Discretionary Compensation for Self-Isolation". The Act is 2022 asp 2
--     and is called "Coronavirus (Discretionary Compensation for
--     Self-isolation) (Scotland) Act 2022": the fact sheet has the right word
--     and the dataset's "Payments" is a slip. The only thing that moves is the
--     capital I, which legislation.gov.uk does not print, and which is the one
--     part of this the owner may want to rule the other way.
--
--   Line 453, the Non-Domestic Rates Act 2026. Title. The fact sheet prints
--     "Non-Domestic Rates for Unoccupied Properties (Scotland) Act 2026". The
--     Act is 2026 asp 1 and is called "Non-Domestic Rates (Liability for
--     Unoccupied Properties) (Scotland) Act 2026". The fact sheet has dropped
--     "(Liability", which db/063 and db/078 settled the same way for two other
--     Acts the fact sheets printed short. This cell moves. The number already
--     on the line, 2026 asp 1, agrees with the Act.
--
-- The dates the two sources share agree on both hand-paired titles, which is
-- what confirmed the pairing: line 432 and dataset row 395 both give 15
-- November 2021 and 23 March 2022, and line 453 and dataset row 467 both give
-- 24 November 2025 and 7 January 2026.
--
-- The owner's working dataset is corrected separately, under the rule settled
-- on 2026-09-14: the file is put right whenever it is found wrong, and the
-- Corrections sheet carries the change. The database is settled first, so the
-- record of the disagreement survives the file being changed.
--
-- This only changes the staging sheet. Session 6 is not on the clean sheet.
-- It must be run after tools/compare_sources.py's SQL for Session 6, which is
-- what writes the "Differs:" notes the guards below insist on.

\set ON_ERROR_STOP on
BEGIN;

CREATE TEMP TABLE adjudication (
  candidate_id integer, title_fragment text, field text,
  agreed_date date, agreed_text text, found_by_comparison boolean,
  source text, url text, note text
) ON COMMIT DROP;

INSERT INTO adjudication VALUES

 (390, 'Building Safety Levy', 'date_introduced', DATE '2025-06-05', NULL, true,
  'bill_page',
  'https://www.parliament.scot/bills-and-laws/bills/s6/building-safety-levy-scotland-bill',
  'The dataset gives 9 June 2025. The Parliament''s own page for the bill states: '
  || '"The Bill was introduced on 5 June 2025". The fact sheet agrees and the line does '
  || 'not move.'),

 (424, 'Carer', 'date_royal_assent', DATE '2021-11-15', NULL, true,
  'legislation_gov_uk',
  'https://www.legislation.gov.uk/asp/2021/20/introduction/enacted',
  'The fact sheet prints 16 November 2021 and is a day out. legislation.gov.uk, which '
  || 'publishes the Act, states: "The Bill for this Act of the Scottish Parliament was '
  || 'passed by the Parliament on 7th October 2021 and received Royal Assent on 15th '
  || 'November 2021". The owner''s dataset agrees with it. This line moves to 2021-11-15.'),

 (465, 'Transvaginal Mesh Removal', 'date_royal_assent', DATE '2022-03-03', NULL, true,
  'legislation_gov_uk',
  'https://www.legislation.gov.uk/asp/2022/1/enacted',
  'The fact sheet prints 4 March 2022 and is a day out. legislation.gov.uk, which '
  || 'publishes the Act, states: "The Bill for this Act of the Scottish Parliament was '
  || 'passed by the Parliament on 25th January 2022 and received Royal Assent on 3rd '
  || 'March 2022". The owner''s dataset agrees with it. This line moves to 2022-03-03.'),

 (432, 'Discretionary Compensation', 'short_title', NULL,
  'Coronavirus (Discretionary Compensation for Self-isolation) (Scotland) Act 2022', false,
  'legislation_gov_uk',
  'https://www.legislation.gov.uk/asp/2022/2/contents/enacted',
  'The dataset calls this Act "Discretionary Payments for Self-Isolation", which is why '
  || 'the two sources would not pair. legislation.gov.uk gives "Coronavirus (Discretionary '
  || 'Compensation for Self-isolation) (Scotland) Act 2022" at 2022 asp 2: the fact sheet '
  || 'has the right word and the dataset is wrong. What moves is only the capital I, which '
  || 'the Act itself does not carry. The fact sheet''s own printing is kept in raw_title.'),

 (453, 'Unoccupied Properties', 'short_title', NULL,
  'Non-Domestic Rates (Liability for Unoccupied Properties) (Scotland) Act 2026', false,
  'legislation_gov_uk',
  'https://www.legislation.gov.uk/asp/2026/1/introduction/enacted',
  'The fact sheet prints "Non-Domestic Rates for Unoccupied Properties (Scotland) Act '
  || '2026" and has dropped a word. legislation.gov.uk gives "Non-Domestic Rates '
  || '(Liability for Unoccupied Properties) (Scotland) Act 2026" at 2026 asp 1, which the '
  || 'owner''s dataset agrees with. This is db/063 and db/078 again, an Act whose title a '
  || 'fact sheet printed short. This line moves; the number 2026 asp 1 already on it '
  || 'agrees with the Act.');

-- A mistyped line number must fail here, not write to the wrong bill. A cell the
-- comparison found must already carry the "Differs:" note it wrote, or this is
-- adjudicating something nobody found; a cell the comparison does not compare
-- must not carry one, or the note has been missed.
DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM adjudication a JOIN bill_candidate c USING (candidate_id)
   WHERE c.short_title NOT ILIKE '%' || a.title_fragment || '%';
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % row(s) name a line whose title does not match.', n;
  END IF;

  SELECT count(*) INTO n FROM adjudication a JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number <> 6;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % row(s) name a line that is not in Session 6.', n;
  END IF;

  SELECT count(*) INTO n FROM adjudication a JOIN bill_candidate c USING (candidate_id)
   WHERE a.found_by_comparison
     AND coalesce(c.review_note, '') !~ ('Differs: ' || a.field || ' = ');
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % line(s) carry no recorded difference in that column.', n;
  END IF;

  SELECT count(*) INTO n FROM adjudication a JOIN bill_candidate c USING (candidate_id)
   WHERE NOT a.found_by_comparison
     AND coalesce(c.review_note, '') ~ ('Differs: ' || a.field || ' = ');
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % line(s) record a difference the comparison cannot find.', n;
  END IF;

  SELECT count(*) INTO n FROM adjudication a JOIN bill_candidate c USING (candidate_id)
   WHERE coalesce(c.review_note, '') ~ ('Checked: ' || a.field || ' = ');
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % line(s) have already been adjudicated in that column.', n;
  END IF;

  SELECT count(*) INTO n FROM adjudication
   WHERE (agreed_date IS NULL) = (agreed_text IS NULL);
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % row(s) give neither a date nor a text, or both.', n;
  END IF;
END $$;

UPDATE bill_candidate c
   SET date_royal_assent = CASE WHEN a.field = 'date_royal_assent'
                                THEN a.agreed_date ELSE c.date_royal_assent END,
       date_introduced   = CASE WHEN a.field = 'date_introduced'
                                THEN a.agreed_date ELSE c.date_introduced END,
       short_title       = CASE WHEN a.field = 'short_title'
                                THEN a.agreed_text ELSE c.short_title END,
       review_note       = btrim(coalesce(c.review_note || E'\n', '')
                           || 'Checked: ' || a.field || ' = '
                           || coalesce(a.agreed_date::text, a.agreed_text)
                           || ' (' || a.source || ', ' || a.url || ', 2026-09-14)'
                           || E'\n' || a.note)
  FROM adjudication a
 WHERE a.candidate_id = c.candidate_id;

-- ---------------------------------------------------------------------------
-- What this leaves
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM bill_candidate
   WHERE candidate_id = 424 AND date_royal_assent = DATE '2021-11-15';
  IF n <> 1 THEN RAISE EXCEPTION 'Line 424 does not hold 2021-11-15.'; END IF;

  SELECT count(*) INTO n FROM bill_candidate
   WHERE candidate_id = 465 AND date_royal_assent = DATE '2022-03-03';
  IF n <> 1 THEN RAISE EXCEPTION 'Line 465 does not hold 2022-03-03.'; END IF;

  SELECT count(*) INTO n FROM bill_candidate
   WHERE candidate_id = 390 AND date_introduced = DATE '2025-06-05';
  IF n <> 1 THEN RAISE EXCEPTION 'Line 390 does not hold 2025-06-05.'; END IF;

  SELECT count(*) INTO n FROM bill_candidate
   WHERE candidate_id = 453
     AND short_title = 'Non-Domestic Rates (Liability for Unoccupied Properties) (Scotland) Act 2026';
  IF n <> 1 THEN RAISE EXCEPTION 'Line 453 does not hold the Act''s title.'; END IF;

  SELECT count(*) INTO n FROM bill_candidate
   WHERE candidate_id = 432
     AND short_title = 'Coronavirus (Discretionary Compensation for Self-isolation) (Scotland) Act 2022';
  IF n <> 1 THEN RAISE EXCEPTION 'Line 432 does not hold the Act''s title.'; END IF;

  -- Every line of both sessions carries the comparison stamp. This is the step
  -- that was missed when Sessions 6 and 7 were announced as ready for review.
  SELECT count(*) INTO n FROM bill_candidate
   WHERE session_number IN (6, 7) AND sources_compared_at IS NULL;
  IF n <> 0 THEN RAISE EXCEPTION '% line(s) of Sessions 6 and 7 are still uncompared.', n; END IF;

  -- Nothing here adjudicates a difference away without a citation.
  SELECT count(*) INTO n FROM v_candidate_problems
   WHERE problem LIKE '%has not been adjudicated%';
  IF n <> 0 THEN RAISE EXCEPTION '% unadjudicated difference(s) remain.', n; END IF;

  -- The clean sheet is not touched by any of this.
  SELECT count(*) INTO n FROM bill;
  IF n <> 389 THEN RAISE EXCEPTION '% bills on the clean sheet, expected 389.', n; END IF;

  SELECT count(*) INTO n FROM v_candidate_problems;
  RAISE NOTICE 'Five cells adjudicated, 389 bills untouched, % problem(s) left for steps 7 and 8.', n;
END $$;

COMMIT;
