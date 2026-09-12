-- db/054_session_3_dates_and_type_adjudicated.sql
--
-- The three dates where the SPICe Session 3 factsheet and the owner's PhD
-- dataset disagreed, and the one bill whose type the factsheet's own summary
-- counts differently from its own table. Put to the owner and settled on
-- 2026-09-12 against the source that owns each: legislation.gov.uk for Royal
-- Assent, the Parliament's own bill page for every other date and for what
-- kind of bill it was. See DECISIONS.md, 2026-09-12.
--
-- Two confirmed the dataset and one confirmed the factsheet. Every one carries
-- the citation, confirmed or corrected alike, so that a date somebody has
-- actually checked can be told from one nobody has looked at.
--
-- The factsheet's own printed words are untouched in the raw_ columns, which is
-- what keeps the disagreement visible without storing a losing value.
--
-- This only changes the staging sheet. Session 3 is not on the clean sheet.

\set ON_ERROR_STOP on
BEGIN;

CREATE TEMP TABLE adjudication (
  candidate_id integer, title_fragment text, field text, agreed text,
  source text, url text, verdict text) ON COMMIT DROP;

INSERT INTO adjudication VALUES
 (174, 'Double Jeopardy', 'date_royal_assent', '2011-04-27', 'legislation_gov_uk',
  'https://www.legislation.gov.uk/asp/2011/16/introduction', 'corrected'),
 (177, 'Forced Marriage', 'date_royal_assent', '2011-04-27', 'legislation_gov_uk',
  'https://www.legislation.gov.uk/asp/2011/15/introduction', 'corrected'),
 (168, 'Criminal Procedure (Legal Assistance', 'date_introduced', '2010-10-27', 'bill_page',
  'https://www.parliament.scot/bills-and-laws/bills/s3/criminal-procedure-legal-assistance-detention-and-appeals-scotland-bill',
  'confirmed'),
 (178, 'Forth Crossing', 'bill_type', 'hybrid', 'bill_page',
  'https://webarchive.nrscotland.gov.uk/public/+/archive2021.parliament.scot/parliamentarybusiness/Bills/22080.aspx',
  'confirmed');

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
-- 1. The two corrections. Both are Royal Assent dates the factsheet printed a
--    day late; both Acts say 27 April 2011 on legislation.gov.uk.
-- ---------------------------------------------------------------------------

UPDATE bill_candidate c
   SET date_royal_assent = a.agreed::date
  FROM adjudication a
 WHERE a.candidate_id = c.candidate_id
   AND a.field = 'date_royal_assent'
   AND c.date_royal_assent IS DISTINCT FROM a.agreed::date;

-- ---------------------------------------------------------------------------
-- 2. The asp number the factsheet leaves out
--
--    The factsheet prints every other Act's asp number inside its title and
--    prints none for this one, so the error checker reports an Act with no
--    number. legislation.gov.uk, the same page that settles its Royal Assent,
--    gives it as asp 15 of 2011.
-- ---------------------------------------------------------------------------

UPDATE bill_candidate
   SET asp_number = '2011 asp 15'
 WHERE candidate_id = 177 AND asp_number IS NULL;

UPDATE bill_candidate
   SET review_note = btrim(coalesce(review_note || E'\n', '')
       || 'Checked: asp_number = 2011 asp 15 (legislation_gov_uk, '
       || 'https://www.legislation.gov.uk/asp/2011/15/introduction, 2026-09-12)')
 WHERE candidate_id = 177
   AND coalesce(review_note, '') NOT LIKE '%Checked: asp_number = %';

-- ---------------------------------------------------------------------------
-- 3. The citation, on all four
-- ---------------------------------------------------------------------------

-- The fixed form the error checker looks for and promotion reads:
--   Checked: <column> = <value> (<source>, <address>, <date read>)
UPDATE bill_candidate c
   SET review_note = btrim(coalesce(c.review_note || E'\n', '') || a.line)
  FROM (SELECT candidate_id,
               string_agg('Checked: ' || field || ' = ' || agreed || ' (' || source
                          || ', ' || url || ', 2026-09-12)', E'\n'
                          ORDER BY field) AS line
          FROM adjudication GROUP BY candidate_id) a
 WHERE a.candidate_id = c.candidate_id;

-- ---------------------------------------------------------------------------
-- 4. Why the Forth Crossing Act needed a ruling at all
--
--    Its own row in the factsheet types it H, and the dataset calls it Hybrid,
--    so the two sources never disagreed. What disagrees is the factsheet's
--    summary page, which has no Hybrid column at all and counts the bill under
--    Executive: their Acts row of 42 is our 41 Executive plus this one, and
--    their column total of 45 is our 44 plus this one. Recorded because anyone
--    reconciling our counts against the factsheet's printed summary will hit it.
-- ---------------------------------------------------------------------------

UPDATE bill_candidate
   SET bill_note = btrim(coalesce(bill_note || ' ', '')
       || 'The factsheet''s summary page has no Hybrid column and counts this Act '
       || 'under Executive; its own table types it H. Reconciling our counts against '
       || 'that summary means adding hybrid to government.')
 WHERE candidate_id = 178
   AND coalesce(bill_note, '') NOT LIKE '%no Hybrid column%';

-- ---------------------------------------------------------------------------
-- 5. What should now be true
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM bill_candidate c JOIN adjudication a USING (candidate_id)
   WHERE (a.field = 'date_royal_assent' AND c.date_royal_assent IS DISTINCT FROM a.agreed::date)
      OR (a.field = 'date_introduced'   AND c.date_introduced   IS DISTINCT FROM a.agreed::date)
      OR (a.field = 'bill_type'         AND c.bill_type         IS DISTINCT FROM a.agreed);
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % line(s) do not hold the adjudicated value.', n;
  END IF;

  SELECT count(*) INTO n FROM bill_candidate c JOIN adjudication a USING (candidate_id)
   WHERE c.review_note NOT LIKE '%Checked: ' || a.field || ' = ' || a.agreed || ' (%';
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % line(s) do not carry their citation.', n;
  END IF;

  -- Every line the comparison flagged must now carry a citation for that column.
  SELECT count(*) INTO n FROM bill_candidate
   WHERE session_number = 3 AND review_note LIKE '%Differs: date_royal_assent%'
     AND review_note NOT LIKE '%Checked: date_royal_assent%';
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % flagged Royal Assent date(s) have no citation.', n;
  END IF;

  SELECT count(*) INTO n FROM bill_candidate
   WHERE session_number = 3 AND review_note LIKE '%Differs: date_introduced%'
     AND review_note NOT LIKE '%Checked: date_introduced%';
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % flagged introduction date(s) have no citation.', n;
  END IF;

  -- The checker is not empty: five fallen bills still need a reason from the
  -- Official Report, which is the owner's review and not this migration's work.
  -- Nothing else may be left in it.
  SELECT count(*) INTO n FROM v_candidate_problems
   WHERE problem <> 'outcome not proposed — needs a judgement';
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % problem(s) other than the fallen bills awaiting a reason.', n;
  END IF;

  RAISE NOTICE 'Session 3: three dates and one type adjudicated — two corrected, two confirmed.';
END $$;

COMMIT;
