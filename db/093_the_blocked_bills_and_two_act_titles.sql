-- db/093_the_blocked_bills_and_two_act_titles.sql
--
-- Step 9 of the runbook for Session 6, as far as it can go without a ruling.
-- The error checker had fifteen items after `db/092`. This answers thirteen of
-- them on five lines. The other two, both on the UK Withdrawal (Legal
-- Continuity) Bill and the Gender Recognition Reform Bill's Session 7 line, are
-- left standing and said out loud at the end of this file.
--
-- Nothing here is a new decision. The values come from lists the owner settled
-- on 2026-09-14 at `db/084` and `db/085`, from the fact sheet's own footnote
-- word for word, and from legislation.gov.uk.
--
-- THE GENDER RECOGNITION REFORM BILL, in both fact sheets (lines 393 and 474).
-- Recorded as blocked with nothing saying how. The Session 6 and Session 7 fact
-- sheets carry the same footnote against it, and `ref_assent_block_route` names
-- this bill and this route in its own definition: a section 35 order, which is
-- an executive decision and not a ruling on competence, which is why it is not
-- the same value as the section 33 references of Session 5. What followed is
-- `still_blocked`, checked at legislation.gov.uk on 2026-09-15 under M12: the
-- lists of Acts for 2023, 2024, 2025 and 2026 contain no Act of this name.
--
-- THE EUROPEAN CHARTER BILL (line 440) and THE UNCRC BILL (line 468). Both are
-- Session 5 bills stopped by a section 33 reference, taken back by the
-- Parliament for a Reconsideration Stage in Session 6, and passed. Each has a
-- Reconsideration Stage row already and says nothing about having been stopped,
-- which is what the checker is complaining about. `reconsidered_passed` is the
-- value `ref_assent_block_outcome` describes in its own definition as belonging
-- to exactly these two bills.
--
-- Line 440 also has its title, number and title kind settled from
-- legislation.gov.uk. The fact sheet prints it in the Acts table under the
-- bill's title with no year and no number, which `db/062` refuses; the Act is
-- the European Charter of Local Self-Government (Incorporation) (Scotland) Act
-- 2026, 2026 asp 11, Royal Assent 15 April 2026 — the date already on the line.
-- This is `db/063`, `db/073`, `db/078` and `db/089` again.
--
-- THE DOG THEFT ACT (line 438). The fact sheet prints "Dog Theft (Scotland) Act
-- 2025 (asp 2)" and the year is wrong in both cells: the Act is the Dog Theft
-- (Scotland) Act 2026, 2026 asp 2, passed 16 December 2025 and given Royal
-- Assent on 10 February 2026, which is the date already on the line. The
-- checker found it by the number's year not matching the year of Royal Assent —
-- the rule `db/062` added — and the title was wrong in the same way.
--
-- THE SECOND APPEARANCES. Lines 412, 440 and 468 are further appearances of
-- bills already on the clean sheet and are pointed at them: 305, 303 and 304.
-- Line 474 is a further appearance of line 393, which is not on the clean sheet
-- yet, so it cannot be pointed anywhere until Session 6 is promoted. That is
-- the ordinary order of things and not a fault; promotion checks only the
-- session being promoted, so it does not block Session 6.
--
-- This only changes the staging sheet. Sessions 6 and 7 are not on the clean
-- sheet.

\set ON_ERROR_STOP on
BEGIN;

CREATE TEMP TABLE settled (
  candidate_id integer, title_fragment text, session_expected integer,
  continues integer, route text, block_outcome text,
  act_title text, asp text, url text,
  bill_note text, note text
) ON COMMIT DROP;

INSERT INTO settled VALUES

 (393, 'Gender Recognition Reform', 6, NULL, 's35_order', 'still_blocked',
  NULL, NULL, 'https://www.legislation.gov.uk/asp/2026',
  'Not submitted for Royal Assent. On 16 January 2023 a Secretary of State made an order '
  || 'under section 35 of the Scotland Act 1998 prohibiting the Presiding Officer from '
  || 'submitting the bill for Royal Assent. The fact sheet''s footnote gives the reason in '
  || 'these words: "the UK Government intervened to block Scottish Parliament legislation '
  || '(under powers contained in s.35 of the Scotland Act 1998) on the grounds that they '
  || 'believed it would have a negative impact on UK law". No court was involved, and the '
  || 'bill has been neither reconsidered nor withdrawn since.',
  'How it was stopped, from the fact sheet''s own footnote against the row, kept word for '
  || 'word in raw_footnote: a section 35 order of 16 January 2023, which is the route '
  || 'ref_assent_block_route names for this bill. What followed is still_blocked, checked '
  || 'under M12 on 2026-09-15: the lists of Acts of the Scottish Parliament for 2023, 2024, '
  || '2025 and 2026 contain no Act of this name.'),

 (474, 'Gender Recognition Reform', 7, NULL, 's35_order', 'still_blocked',
  NULL, NULL, 'https://www.legislation.gov.uk/asp/2026',
  'Not submitted for Royal Assent. On 16 January 2023 a Secretary of State made an order '
  || 'under section 35 of the Scotland Act 1998 prohibiting the Presiding Officer from '
  || 'submitting the bill for Royal Assent. The fact sheet''s footnote gives the reason in '
  || 'these words: "the UK Government intervened to block Scottish Parliament legislation '
  || '(under powers contained in s.35 of the Scotland Act 1998) on the grounds that they '
  || 'believed it would have a negative impact on UK law". No court was involved, and the '
  || 'bill has been neither reconsidered nor withdrawn since.',
  'The same bill as line 393, printed again in the Session 7 fact sheet because a bill that '
  || 'has passed does not fall at dissolution the way an unfinished bill does. How it was '
  || 'stopped and what followed are recorded here as on that line. continues_bill_id is '
  || 'deliberately left empty: it must point at a bill on the clean sheet, and line 393 will '
  || 'not be one until Session 6 is promoted. It is set then, before Session 7 is promoted.'),

 (440, 'European Charter', 6, 303, 's33_reference', 'reconsidered_passed',
  'European Charter of Local Self-Government (Incorporation) (Scotland) Act 2026',
  '2026 asp 11', 'https://www.legislation.gov.uk/asp/2026/11/introduction/enacted',
  NULL,
  'A Session 5 bill stopped before Royal Assent by a section 33 reference, taken back by the '
  || 'Parliament for a Reconsideration Stage in Session 6 and passed: the Reconsideration '
  || 'Stage row on this line gives 4 February 2026 as the day the bill reached the stage and '
  || '3 March 2026 as the day it ended. The fact sheet prints the row in its Acts table under '
  || 'the bill''s title, with no year and no number, so both are settled from '
  || 'legislation.gov.uk: "The Bill for this Act of the Scottish Parliament was approved by '
  || 'the Parliament on 3rd March 2026 and received Royal Assent on 15th April 2026", at '
  || '2026 asp 11. The Royal Assent date already on the line agrees.'),

 (468, 'United Nations Convention', 6, 304, 's33_reference', 'reconsidered_passed',
  NULL, NULL, 'https://www.legislation.gov.uk/asp/2024',
  NULL,
  'A Session 5 bill stopped before Royal Assent by a section 33 reference, taken back by the '
  || 'Parliament for a Reconsideration Stage in Session 6 and passed: the Reconsideration '
  || 'Stage row on this line gives 14 September 2023 as the day the bill reached the stage '
  || 'and 7 December 2023 as the day it ended. The fact sheet already gives the Act''s title '
  || 'and number, 2024 asp 1, and legislation.gov.uk''s list of Acts for 2024 agrees. Read on '
  || '2026-09-15.'),

 (438, 'Dog Theft', 6, NULL, NULL, NULL,
  'Dog Theft (Scotland) Act 2026', '2026 asp 2',
  'https://www.legislation.gov.uk/asp/2026/2/introduction/enacted', NULL,
  'The fact sheet prints "Dog Theft (Scotland) Act 2025 (asp 2)" and the year is wrong in '
  || 'both cells. legislation.gov.uk: "The Bill for this Act of the Scottish Parliament was '
  || 'passed by the Parliament on 16th December 2025 and received Royal Assent on 10th '
  || 'February 2026", at 2026 asp 2. The Royal Assent date already on the line agrees, which '
  || 'is how the checker found it: the number''s year did not match the year of assent.'),

 (412, 'UK Withdrawal from the European Union (Legal Continuity)', 6, 305, NULL, NULL,
  NULL, NULL, NULL, NULL,
  'A further appearance of bill 305, the Session 5 bill of the same name, which is where this '
  || 'line''s facts belong. How the bill was stopped and what followed it are not settled on '
  || 'this line: see DECISIONS.md, 2026-09-15, and the note at the end of db/093.');

-- ---------------------------------------------------------------------------
-- Nothing is written to a line that is not the one meant
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM settled a JOIN bill_candidate c USING (candidate_id)
   WHERE c.short_title NOT ILIKE '%' || a.title_fragment || '%'
      OR c.session_number <> a.session_expected;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % row(s) name the wrong line.', n;
  END IF;

  -- A bill this line continues must already be on the clean sheet, and must be
  -- the same bill by name.
  SELECT count(*) INTO n FROM settled a JOIN bill b ON b.bill_id = a.continues
   WHERE a.continues IS NOT NULL
     AND b.short_title NOT ILIKE '%' || a.title_fragment || '%';
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % row(s) continue a bill of another name.', n;
  END IF;

  SELECT count(*) INTO n FROM settled a
   WHERE a.continues IS NOT NULL
     AND NOT EXISTS (SELECT 1 FROM bill b WHERE b.bill_id = a.continues);
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % row(s) continue a bill that is not on the clean sheet.', n;
  END IF;

  -- The two blocked-bill cells go together or not at all.
  SELECT count(*) INTO n FROM settled WHERE (route IS NULL) <> (block_outcome IS NULL);
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % row(s) fill one blocked-bill cell and not the other.', n;
  END IF;

  -- A title settled from legislation.gov.uk must cite the page it was read on.
  SELECT count(*) INTO n FROM settled
   WHERE (act_title IS NOT NULL OR asp IS NOT NULL) AND url IS NULL;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % row(s) settle a title or number with no address.', n;
  END IF;

  SELECT count(*) INTO n FROM settled a JOIN bill_candidate c USING (candidate_id)
   WHERE a.continues IS NOT NULL AND c.continues_bill_id IS NOT NULL;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % line(s) already continue a bill.', n;
  END IF;
END $$;

-- ---------------------------------------------------------------------------
-- What was settled
-- ---------------------------------------------------------------------------

UPDATE bill_candidate c
   SET continues_bill_id     = coalesce(a.continues, c.continues_bill_id),
       assent_block_route    = coalesce(a.route, c.assent_block_route),
       assent_block_outcome  = coalesce(a.block_outcome, c.assent_block_outcome),
       short_title           = coalesce(a.act_title, c.short_title),
       asp_number            = coalesce(a.asp, c.asp_number),
       title_kind            = CASE WHEN a.act_title IS NOT NULL THEN 'act'
                                    ELSE c.title_kind END,
       bill_note             = coalesce(a.bill_note, c.bill_note),
       review_note           = btrim(coalesce(c.review_note || E'\n', '')
                               || CASE WHEN a.act_title IS NULL THEN '' ELSE
                                    'Checked: short_title = ' || a.act_title
                                    || ' (legislation_gov_uk, ' || a.url || ', 2026-09-15)'
                                    || E'\n' END
                               || CASE WHEN a.asp IS NULL THEN '' ELSE
                                    'Checked: asp_number = ' || a.asp
                                    || ' (legislation_gov_uk, ' || a.url || ', 2026-09-15)'
                                    || E'\n' END
                               || a.note)
  FROM settled a
 WHERE a.candidate_id = c.candidate_id;

-- ---------------------------------------------------------------------------
-- What this leaves
-- ---------------------------------------------------------------------------
--
-- Two problems stand, and both are named in DECISIONS.md.
--
--   Line 412, twice over. The UK Withdrawal (Legal Continuity) Bill passed on
--   21 March 2018, was stopped before Royal Assent by the Supreme Court, and
--   was withdrawn on 10 March 2022. Three of the checker's rules cannot all be
--   satisfied at once for it, and which one gives is the owner's to settle.
--   Until then the line says only which bill it continues.
--
--   Line 474, once. It cannot point at line 393 until Session 6 is promoted.
--   This is sequencing, not a question.

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n <> 2 THEN
    RAISE EXCEPTION 'The error checker finds % problem(s), expected 2.', n;
  END IF;

  SELECT count(*) INTO n FROM v_candidate_problems WHERE candidate_id = 412;
  IF n <> 1 THEN RAISE EXCEPTION 'Line 412 has % problem(s), expected 1.', n; END IF;

  SELECT count(*) INTO n FROM v_candidate_problems WHERE candidate_id = 474;
  IF n <> 1 THEN RAISE EXCEPTION 'Line 474 has % problem(s), expected 1.', n; END IF;

  SELECT count(*) INTO n FROM bill_candidate
   WHERE candidate_id = 438 AND short_title = 'Dog Theft (Scotland) Act 2026'
     AND asp_number = '2026 asp 2';
  IF n <> 1 THEN RAISE EXCEPTION 'The Dog Theft Act is not settled.'; END IF;

  SELECT count(*) INTO n FROM bill_candidate
   WHERE candidate_id = 440 AND title_kind = 'act' AND asp_number = '2026 asp 11'
     AND short_title = 'European Charter of Local Self-Government (Incorporation) (Scotland) Act 2026';
  IF n <> 1 THEN RAISE EXCEPTION 'The European Charter Act is not settled.'; END IF;

  SELECT count(*) INTO n FROM bill_candidate
   WHERE assent_block_outcome = 'reconsidered_passed' AND candidate_id IN (440, 468);
  IF n <> 2 THEN RAISE EXCEPTION 'Only % of the two reconsidered bills say so.', n; END IF;

  SELECT count(*) INTO n FROM bill_candidate
   WHERE assent_block_route = 's35_order' AND candidate_id IN (393, 474)
     AND coalesce(btrim(bill_note), '') <> '';
  IF n <> 2 THEN RAISE EXCEPTION 'Only % of the two blocked lines say how.', n; END IF;

  -- The clean sheet is not touched by any of this.
  SELECT count(*) INTO n FROM bill;
  IF n <> 389 THEN RAISE EXCEPTION '% bills on the clean sheet, expected 389.', n; END IF;

  SELECT count(*) INTO n FROM field_source;
  IF n <> 112 THEN RAISE EXCEPTION '% provenance notes, expected 112.', n; END IF;

  RAISE NOTICE 'Thirteen answered on five lines. Two problems stand: line 412 needs a ruling, line 474 needs Session 6 promoted.';
END $$;

COMMIT;
