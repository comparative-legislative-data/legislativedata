-- db/074_session_5_three_dates_adjudicated.sql
--
-- The three cells where Session 5's fact sheet and the owner's dataset give
-- different dates. The comparison found them when the session was loaded on
-- 2026-09-14; each was then read at the source that owns the value, and the
-- owner settled all three the same day. This is db/043 and db/054 again, in the
-- same "Checked:" form db/042 established, and there is nothing new in it.
--
-- Two go the dataset's way and one goes the fact sheet's, which is the usual
-- split: neither source is the authority, and each cell is settled where the
-- value is published.
--
--   Line 315, Age of Criminal Responsibility (Scotland) Act 2019. Royal Assent.
--     Fact sheet 11 June 2019, dataset 12 June 2019. legislation.gov.uk: "The
--     Bill for this Act of the Scottish Parliament was passed by the Parliament
--     on 7th May 2019 and received Royal Assent on 11th June 2019". The line
--     already holds 11 June and does not move; what changes is that somebody
--     has now looked, which is what the citation records.
--
--   Line 349, Heat Networks (Scotland) Act 2021. Royal Assent. Fact sheet
--     30 March 2021, dataset 20 March 2021. legislation.gov.uk: "The Bill for
--     this Act of the Scottish Parliament was passed by the Parliament on 23rd
--     February 2021 and received Royal Assent on 30th March 2021". The line
--     already holds 30 March and does not move.
--
--   Line 380, Solicitors in the Supreme Courts of Scotland (Amendment) Act
--     2021. Introduction. Fact sheet 26 September 2020, dataset 26 September
--     2019. The Parliament's page for the bill: "The Bill was introduced on
--     26 September 2019". The fact sheet is a year out, and this is the cell
--     that moves. The date is not a detail here: the bill's own committee was
--     established on 31 October 2019 and reported at Preliminary Stage in
--     January 2020, neither of which is possible if the bill was introduced in
--     September 2020.
--
-- The owner's working dataset is corrected separately, under the rule settled
-- on 2026-09-14: the file is put right whenever it is found wrong, and the
-- Corrections sheet carries the change. The database is settled first, so the
-- record of the disagreement survives the file being changed.
--
-- This only changes the staging sheet. Session 5 is not on the clean sheet.

\set ON_ERROR_STOP on
BEGIN;

CREATE TEMP TABLE adjudication (
  candidate_id integer, title_fragment text, field text, agreed date,
  source text, url text, note text
) ON COMMIT DROP;

INSERT INTO adjudication VALUES

 (315, 'Age of Criminal Responsibility', 'date_royal_assent', DATE '2019-06-11',
  'legislation_gov_uk',
  'https://www.legislation.gov.uk/asp/2019/7/introduction',
  'The dataset gives 12 June 2019. legislation.gov.uk, which publishes the Act, states: '
  || '"The Bill for this Act of the Scottish Parliament was passed by the Parliament on 7th '
  || 'May 2019 and received Royal Assent on 11th June 2019". The factsheet agrees and the '
  || 'line does not move.'),

 (349, 'Heat Networks', 'date_royal_assent', DATE '2021-03-30',
  'legislation_gov_uk',
  'https://www.legislation.gov.uk/asp/2021/9/enacted',
  'The dataset gives 20 March 2021. legislation.gov.uk, which publishes the Act, states: '
  || '"The Bill for this Act of the Scottish Parliament was passed by the Parliament on 23rd '
  || 'February 2021 and received Royal Assent on 30th March 2021". The factsheet agrees and '
  || 'the line does not move.'),

 (380, 'Solicitors in the Supreme Courts', 'date_introduced', DATE '2019-09-26',
  'bill_page',
  'https://www.parliament.scot/bills-and-laws/bills/s5/solicitors-in-the-supreme-courts-of-scotland-amendment-bill',
  'The factsheet prints 26 September 2020 and is a year out. The Parliament''s own page for '
  || 'the bill states: "The Bill was introduced on 26 September 2019", which the dataset '
  || 'agrees with. The bill''s committee was established on 31 October 2019 and reported at '
  || 'Preliminary Stage in January 2020, neither of which is possible on the factsheet''s '
  || 'date. This line moves to 2019-09-26.');

-- A mistyped line number must fail here, not write to the wrong bill. Each line
-- must already carry the "Differs:" note the comparison wrote, or this is
-- adjudicating something nobody found.
DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM adjudication a JOIN bill_candidate c USING (candidate_id)
   WHERE c.short_title NOT ILIKE '%' || a.title_fragment || '%';
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % row(s) name a line whose title does not match.', n;
  END IF;

  SELECT count(*) INTO n FROM adjudication a JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number <> 5;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % row(s) name a line that is not in Session 5.', n;
  END IF;

  SELECT count(*) INTO n FROM adjudication a JOIN bill_candidate c USING (candidate_id)
   WHERE coalesce(c.review_note, '') !~ ('Differs: ' || a.field || ' = ');
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % line(s) carry no recorded difference in that column.', n;
  END IF;

  SELECT count(*) INTO n FROM adjudication a JOIN bill_candidate c USING (candidate_id)
   WHERE coalesce(c.review_note, '') ~ ('Checked: ' || a.field || ' = ');
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % line(s) have already been adjudicated in that column.', n;
  END IF;
END $$;

UPDATE bill_candidate c
   SET date_royal_assent = CASE WHEN a.field = 'date_royal_assent'
                                THEN a.agreed ELSE c.date_royal_assent END,
       date_introduced   = CASE WHEN a.field = 'date_introduced'
                                THEN a.agreed ELSE c.date_introduced END,
       review_note       = btrim(coalesce(c.review_note || E'\n', '')
                           || 'Checked: ' || a.field || ' = ' || a.agreed
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
  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n <> 0 THEN
    RAISE EXCEPTION 'The error checker still finds % problem(s).', n;
  END IF;

  SELECT count(*) INTO n FROM bill_candidate
   WHERE candidate_id = 380 AND date_introduced = DATE '2019-09-26';
  IF n <> 1 THEN RAISE EXCEPTION 'Line 380 does not hold 2019-09-26.'; END IF;

  SELECT count(*) INTO n FROM bill_candidate
   WHERE session_number = 5 AND sources_compared_at IS NULL;
  IF n <> 0 THEN RAISE EXCEPTION '% Session 5 line(s) are still uncompared.', n; END IF;

  SELECT count(*) INTO n FROM bill;
  IF n <> 302 THEN RAISE EXCEPTION '% bills on the clean sheet, expected 302.', n; END IF;

  RAISE NOTICE 'Three cells adjudicated, error checker empty, 302 bills untouched.';
END $$;

COMMIT;
