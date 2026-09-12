-- db/043_sessions_1_and_2_dates_adjudicated.sql
--
-- The thirteen dates where the SPICe factsheet and the owner's PhD dataset
-- disagreed, put to the owner and settled on 2026-09-12 against the source that
-- owns each one: legislation.gov.uk for Royal Assent, the Parliament's own bill
-- page for every other date. See DECISIONS.md, 2026-09-12.
--
-- Eight confirmed the factsheet and five did not; all five were Royal Assent.
-- Every one of the thirteen carries the citation, confirmed or corrected alike,
-- so that a date anyone has actually checked can be told from one nobody has.
--
-- The factsheet's own printed words are untouched in the raw_ columns, which is
-- what keeps the disagreement visible without storing a losing value.
--
-- This only changes the staging sheets. Sessions 1 and 2 come off the clean
-- sheet and go back on afterwards, through the runbook.

\set ON_ERROR_STOP on
BEGIN;

CREATE TEMP TABLE adjudication (
  candidate_id integer, title_fragment text, field text, agreed date,
  source text, url text, verdict text) ON COMMIT DROP;

INSERT INTO adjudication VALUES
 (3, 'Adults with Incapacity', 'date_royal_assent', DATE '2000-05-09', 'legislation_gov_uk',
  'https://www.legislation.gov.uk/asp/2000/4/introduction', 'confirmed'),
 (59, 'Transport (Scotland) Act 2001', 'date_royal_assent', DATE '2001-01-25', 'legislation_gov_uk',
  'https://www.legislation.gov.uk/asp/2001/2/introduction', 'confirmed'),
 (40, 'Protection from Abuse', 'date_royal_assent', DATE '2001-11-06', 'legislation_gov_uk',
  'https://www.legislation.gov.uk/asp/2001/14/introduction', 'corrected'),
 (49, 'School Education (Amendment)', 'date_royal_assent', DATE '2002-01-22', 'legislation_gov_uk',
  'https://www.legislation.gov.uk/asp/2002/2/introduction', 'corrected'),
 (51, 'Scottish Local Government (Elections)', 'date_royal_assent', DATE '2002-01-22', 'legislation_gov_uk',
  'https://www.legislation.gov.uk/asp/2002/1/introduction', 'corrected'),
 (134, 'Tourist Boards', 'date_royal_assent', DATE '2006-11-30', 'legislation_gov_uk',
  'https://www.legislation.gov.uk/asp/2006/15/introduction', 'confirmed'),
 (136, 'Transport and Works', 'date_royal_assent', DATE '2007-03-14', 'legislation_gov_uk',
  'https://www.legislation.gov.uk/asp/2007/8/introduction', 'corrected'),
 (123, 'Rights of Relatives to Damages', 'date_royal_assent', DATE '2007-04-26', 'legislation_gov_uk',
  'https://www.legislation.gov.uk/asp/2007/18/pdfs/asp_20070018_en.pdf', 'corrected'),
 (29, 'International Criminal Court', 'date_introduced', DATE '2001-04-04', 'bill_page',
  'https://www.parliament.scot/bills-and-laws/bills/s1/international-criminal-court-scotland-bill', 'confirmed'),
 (62, 'Water Industry', 'date_introduced', DATE '2001-09-26', 'bill_page',
  'https://www.parliament.scot/bills-and-laws/bills/s1/water-industry-scotland-bill', 'confirmed'),
 (71, 'Robin Rigg', 'date_introduced', DATE '2002-06-27', 'bill_page',
  'https://www.parliament.scot/bills-and-laws/bills/s1/robin-rigg-offshore-wind-farm-navigation-and-fishing-scotland-bill-session-1', 'confirmed'),
 (129, 'Senior Judiciary', 'date_introduced', DATE '2006-06-15', 'bill_page',
  'https://www.parliament.scot/bills-and-laws/bills/s2/senior-judiciary-vacancies-and-incapacity-scotland-bill', 'confirmed');

-- A mistyped line number must fail here, not write to the wrong bill.
DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM adjudication a
    JOIN bill_candidate c USING (candidate_id)
   WHERE c.short_title NOT ILIKE '%' || a.title_fragment || '%';
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % adjudication row(s) name a line whose title does not match.', n;
  END IF;
  SELECT count(*) INTO n FROM adjudication a
   WHERE NOT EXISTS (SELECT 1 FROM bill_candidate c WHERE c.candidate_id = a.candidate_id);
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % adjudication row(s) name a line that does not exist.', n;
  END IF;
END $$;

-- ---------------------------------------------------------------------------
-- 1. The five corrections
-- ---------------------------------------------------------------------------

UPDATE bill_candidate c
   SET date_royal_assent = a.agreed
  FROM adjudication a
 WHERE a.candidate_id = c.candidate_id
   AND a.field = 'date_royal_assent'
   AND c.date_royal_assent IS DISTINCT FROM a.agreed;

UPDATE bill_candidate c
   SET date_introduced = a.agreed
  FROM adjudication a
 WHERE a.candidate_id = c.candidate_id
   AND a.field = 'date_introduced'
   AND c.date_introduced IS DISTINCT FROM a.agreed;

-- ---------------------------------------------------------------------------
-- 2. The citation, on all thirteen
-- ---------------------------------------------------------------------------

-- The fixed form the error checker looks for and promotion reads:
--   Checked: <column> = <date> (<source>, <address>, <date read>)
UPDATE bill_candidate c
   SET review_note = btrim(coalesce(c.review_note || E'\n', '') || a.line)
  FROM (SELECT candidate_id,
               string_agg('Checked: ' || field || ' = ' || agreed || ' (' || source
                          || ', ' || url || ', 2026-09-12)', E'\n'
                          ORDER BY field) AS line
          FROM adjudication GROUP BY candidate_id) a
 WHERE a.candidate_id = c.candidate_id;

-- The Adults with Incapacity passing date is a stage record, not a cell on the
-- bill's line, so its citation goes on the stage-dates sheet. The factsheet's
-- 29 March 2000 was confirmed against the Parliament's bill page.
UPDATE stage_candidate t
   SET review_note = btrim(coalesce(t.review_note || E'\n', '')
       || 'Checked: date_completed = 2000-03-29 (bill_page, '
       || 'https://www.parliament.scot/bills-and-laws/bills/s1/adults-with-incapacity-scotland-bill, 2026-09-12)')
 WHERE t.candidate_id = 3 AND t.stage = 'stage_3'
   AND t.date_completed = DATE '2000-03-29';

-- ---------------------------------------------------------------------------
-- 3. What should now be true
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM bill_candidate c JOIN adjudication a USING (candidate_id)
   WHERE (a.field = 'date_royal_assent' AND c.date_royal_assent IS DISTINCT FROM a.agreed)
      OR (a.field = 'date_introduced'   AND c.date_introduced   IS DISTINCT FROM a.agreed);
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % line(s) do not hold the adjudicated date.', n;
  END IF;

  SELECT count(*) INTO n FROM bill_candidate c JOIN adjudication a USING (candidate_id)
   WHERE c.review_note NOT LIKE '%Checked: ' || a.field || ' = ' || a.agreed || ' (%';
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % line(s) do not carry their citation.', n;
  END IF;

  SELECT count(*) INTO n FROM stage_candidate
   WHERE candidate_id = 3 AND stage = 'stage_3'
     AND review_note LIKE '%Checked: date_completed = 2000-03-29 (bill_page,%';
  IF n <> 1 THEN
    RAISE EXCEPTION 'Refusing: the Adults with Incapacity passing date has no citation.';
  END IF;

  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: the error checker is not empty (% problem(s)).', n;
  END IF;
  RAISE NOTICE 'Thirteen dates adjudicated: five corrected, eight confirmed. Checker empty.';
END $$;

COMMIT;
