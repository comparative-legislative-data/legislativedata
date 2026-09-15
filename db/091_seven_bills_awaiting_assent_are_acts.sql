-- db/091_seven_bills_awaiting_assent_are_acts.sql
--
-- db/090 changed the rules; this applies them. Twelve staging lines sit in a
-- fact sheet's "Bills awaiting Royal Assent" table, and until now not one of
-- them had been looked up at legislation.gov.uk. Every one is looked up here,
-- and every one says what was found, whether or not it changed anything.
--
-- SEVEN MOVE. The Session 6 fact sheet, read on 2026-09-10, shows them as
-- passed and awaiting Royal Assent. All seven became Acts in May 2026, on
-- exactly the dates the owner's dataset holds, and each takes four values from
-- legislation.gov.uk: the date of Royal Assent, the Act's number, the Act's
-- title, and enacted in place of pending. Each of the four carries its own
-- citation, so promotion writes a provenance note per fact saying where it came
-- from and the day it was read. The line's own source stays the fact sheet,
-- because that is still where the line came from, and raw_title keeps the
-- fact sheet's own printing of the bill's title.
--
--   390  Building Safety Levy (Scotland) Act 2026                       asp 14
--   391  Children (Care, Care Experience and Services Planning)
--          (Scotland) Act 2026                                          asp 16
--   392  Crofting and Scottish Land Court Act 2026                      asp 17
--   394  Greyhound Racing (Offences) (Scotland) Act 2026                asp 15
--   395  Non-surgical Procedures and Functions of Medical Reviewers
--          (Scotland) Act 2026                                          asp 13
--   396  Restraint and Seclusion in Schools (Scotland) Act 2026         asp 19
--   397  Visitor Levy (Amendment) (Scotland) Act 2026                   asp 18
--
-- FIVE DO NOT, and say so. These are bills stopped before Royal Assent rather
-- than waiting for it — M5's case, not M12's — and the answer for all five is
-- that no Act of that name has been made. The lists of Acts of the Scottish
-- Parliament for 2023, 2024, 2025 and 2026 were all read on 2026-09-15.
--
--   393, 474  Gender Recognition Reform (Scotland) Bill, in the Session 6 and
--             Session 7 sheets. Subject to a section 35 order. No Act.
--   305       UK Withdrawal from the European Union (Legal Continuity)
--             (Scotland) Bill. No Act; the bill was withdrawn in Session 6.
--   303       European Charter of Local Self-Government (Incorporation)
--             (Scotland) Bill. An Act of that name was made — 2026 asp 11 —
--             but it belongs to the bill's second appearance, in Session 6,
--             not to this Session 5 line. By M6 a bill belongs to the session
--             it was first introduced in, and this line records what happened
--             to it in Session 5: it was stopped. The Act is carried by line
--             440. This line does not move.
--   304       United Nations Convention on the Rights of the Child
--             (Incorporation) (Scotland) Bill. The same, for 2024 asp 1,
--             carried by line 468.
--
-- Lines 303, 304 and 305 were accepted and promoted before this rule existed,
-- and Session 5 is closed. Nothing they hold changes, so nothing on the clean
-- sheet changes; what is added is the record that somebody looked. Their
-- provenance on the clean sheet is unchanged because no value is, and it would
-- be rewritten from these notes the next time Session 5 is put back on.
--
-- Session 7's other line, the Scottish Local Government Elections (Candidacy
-- Rights of Commonwealth Citizens) Bill, was introduced on 2026-09-09 and is
-- in progress, not awaiting assent. It was looked up on the same day and there
-- is no Act; the rule does not ask for a citation on it and none is written.

\set ON_ERROR_STOP on
BEGIN;

CREATE TEMP TABLE looked_up (
  candidate_id integer, title_fragment text, session_expected integer,
  was text, now_status text,
  assent date, asp text, act_title text,
  url text, note text
) ON COMMIT DROP;

INSERT INTO looked_up VALUES

 (390, 'Building Safety Levy', 6, 'pending', 'enacted',
  DATE '2026-05-13', '2026 asp 14', 'Building Safety Levy (Scotland) Act 2026',
  'https://www.legislation.gov.uk/asp/2026/14/introduction/enacted',
  'legislation.gov.uk: "The Bill for this Act of the Scottish Parliament was passed by the '
  || 'Parliament on 17th March 2026 and received Royal Assent on 13th May 2026". The fact '
  || 'sheet, read on 10 September 2026, still shows the bill as awaiting Royal Assent, and '
  || 'gives 17 March 2026 as the day it passed, which agrees. See methodology note M12.'),

 (391, 'Children (Care, Care Experience', 6, 'pending', 'enacted',
  DATE '2026-05-15', '2026 asp 16',
  'Children (Care, Care Experience and Services Planning) (Scotland) Act 2026',
  'https://www.legislation.gov.uk/asp/2026/16/introduction/enacted',
  'legislation.gov.uk: "The Bill for this Act of the Scottish Parliament was passed by the '
  || 'Parliament on 19th March 2026 and received Royal Assent on 15th May 2026". The fact '
  || 'sheet, read on 10 September 2026, still shows the bill as awaiting Royal Assent, and '
  || 'gives 19 March 2026 as the day it passed, which agrees. See methodology note M12.'),

 (392, 'Crofting and Scottish Land Court', 6, 'pending', 'enacted',
  DATE '2026-05-18', '2026 asp 17', 'Crofting and Scottish Land Court Act 2026',
  'https://www.legislation.gov.uk/asp/2026/17/introduction/enacted',
  'legislation.gov.uk: "The Bill for this Act of the Scottish Parliament was passed by the '
  || 'Parliament on 24th March 2026 and received Royal Assent on 18th May 2026". The fact '
  || 'sheet, read on 10 September 2026, still shows the bill as awaiting Royal Assent, and '
  || 'gives 24 March 2026 as the day it passed, which agrees. The Act carries no "(Scotland)" '
  || 'in its title, as the bill carried none. See methodology note M12.'),

 (394, 'Greyhound Racing', 6, 'pending', 'enacted',
  DATE '2026-05-14', '2026 asp 15', 'Greyhound Racing (Offences) (Scotland) Act 2026',
  'https://www.legislation.gov.uk/asp/2026/15/introduction/enacted',
  'legislation.gov.uk: "The Bill for this Act of the Scottish Parliament was passed by the '
  || 'Parliament on 18th March 2026 and received Royal Assent on 14th May 2026". The fact '
  || 'sheet, read on 10 September 2026, still shows the bill as awaiting Royal Assent, and '
  || 'gives 18 March 2026 as the day it passed, which agrees. See methodology note M12.'),

 (395, 'Non-surgical Procedures', 6, 'pending', 'enacted',
  DATE '2026-05-12', '2026 asp 13',
  'Non-surgical Procedures and Functions of Medical Reviewers (Scotland) Act 2026',
  'https://www.legislation.gov.uk/asp/2026/13/introduction/enacted',
  'legislation.gov.uk: "The Bill for this Act of the Scottish Parliament was passed by the '
  || 'Parliament on 17th March 2026 and received Royal Assent on 12th May 2026". The fact '
  || 'sheet, read on 10 September 2026, still shows the bill as awaiting Royal Assent, and '
  || 'gives 17 March 2026 as the day it passed, which agrees. See methodology note M12.'),

 (396, 'Restraint and Seclusion', 6, 'pending', 'enacted',
  DATE '2026-05-26', '2026 asp 19', 'Restraint and Seclusion in Schools (Scotland) Act 2026',
  'https://www.legislation.gov.uk/asp/2026/19/introduction/enacted',
  'legislation.gov.uk: "The Bill for this Act of the Scottish Parliament was passed by the '
  || 'Parliament on 24th March 2026 and received Royal Assent on 26th May 2026". The fact '
  || 'sheet, read on 10 September 2026, still shows the bill as awaiting Royal Assent, and '
  || 'gives 24 March 2026 as the day it passed, which agrees. See methodology note M12.'),

 (397, 'Visitor Levy', 6, 'pending', 'enacted',
  DATE '2026-05-21', '2026 asp 18', 'Visitor Levy (Amendment) (Scotland) Act 2026',
  'https://www.legislation.gov.uk/asp/2026/18/introduction/enacted',
  'legislation.gov.uk: "The Bill for this Act of the Scottish Parliament was passed by the '
  || 'Parliament on 24th March 2026 and received Royal Assent on 21st May 2026". The fact '
  || 'sheet, read on 10 September 2026, still shows the bill as awaiting Royal Assent, and '
  || 'gives 24 March 2026 as the day it passed, which agrees. See methodology note M12.'),

 (393, 'Gender Recognition Reform', 6, 'blocked', 'blocked',
  NULL, NULL, NULL,
  'https://www.legislation.gov.uk/asp/2026',
  'Looked up under M12, and nothing moves. The lists of Acts of the Scottish Parliament for '
  || '2023, 2024, 2025 and 2026 were read on 15 September 2026 and none contains an Act of '
  || 'this name. The bill was stopped by a section 35 order and remains stopped: this is '
  || 'M5''s case, not M12''s.'),

 (474, 'Gender Recognition Reform', 7, 'blocked', 'blocked',
  NULL, NULL, NULL,
  'https://www.legislation.gov.uk/asp/2026',
  'Looked up under M12, and nothing moves. The lists of Acts of the Scottish Parliament for '
  || '2023, 2024, 2025 and 2026 were read on 15 September 2026 and none contains an Act of '
  || 'this name. The bill was stopped by a section 35 order and remains stopped: this is '
  || 'M5''s case, not M12''s. This is the bill''s second appearance, in the Session 7 sheet.'),

 (303, 'European Charter', 5, 'blocked', 'blocked',
  NULL, NULL, NULL,
  'https://www.legislation.gov.uk/asp/2026',
  'Looked up under M12, and nothing moves. An Act of this name was made — the European '
  || 'Charter of Local Self-Government (Incorporation) (Scotland) Act 2026, 2026 asp 11, '
  || 'Royal Assent 15 April 2026 — but it belongs to the bill''s second appearance in '
  || 'Session 6, which carries it, and not to this line. By methodology note M6 a bill '
  || 'belongs to the session it was first introduced in, and what this line records is what '
  || 'happened to the bill in Session 5: it was stopped before Royal Assent. Read on 15 '
  || 'September 2026.'),

 (304, 'United Nations Convention', 5, 'blocked', 'blocked',
  NULL, NULL, NULL,
  'https://www.legislation.gov.uk/asp/2024',
  'Looked up under M12, and nothing moves. An Act of this name was made — the United '
  || 'Nations Convention on the Rights of the Child (Incorporation) (Scotland) Act 2024, '
  || '2024 asp 1 — but it belongs to the bill''s second appearance in Session 6, which '
  || 'carries it, and not to this line. By methodology note M6 a bill belongs to the session '
  || 'it was first introduced in, and what this line records is what happened to the bill in '
  || 'Session 5: it was stopped before Royal Assent. Read on 15 September 2026.'),

 (305, 'UK Withdrawal from the European Union (Legal Continuity)', 5, 'blocked', 'blocked',
  NULL, NULL, NULL,
  'https://www.legislation.gov.uk/asp/2026',
  'Looked up under M12, and nothing moves. The lists of Acts of the Scottish Parliament for '
  || '2023, 2024, 2025 and 2026 were read on 15 September 2026 and none contains an Act of '
  || 'this name. The bill never became an Act: it was stopped before Royal Assent in Session '
  || '5 and withdrawn in Session 6, which line 412 records.');

-- ---------------------------------------------------------------------------
-- Nothing is written to a line that is not the one meant
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM looked_up a JOIN bill_candidate c USING (candidate_id)
   WHERE c.short_title NOT ILIKE '%' || a.title_fragment || '%';
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % row(s) name a line whose title does not match.', n;
  END IF;

  SELECT count(*) INTO n FROM looked_up a JOIN bill_candidate c USING (candidate_id)
   WHERE c.session_number <> a.session_expected;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % row(s) name a line in the wrong session.', n;
  END IF;

  -- Every one of these must be a line a fact sheet left awaiting Royal Assent,
  -- holding the status this migration says it holds.
  SELECT count(*) INTO n FROM looked_up a JOIN bill_candidate c USING (candidate_id)
   WHERE c.raw_section <> 'awaiting_assent' OR c.enactment_status <> a.was;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % line(s) are not where this migration expects them.', n;
  END IF;

  -- A line that is to become an Act must not already hold Royal Assent values.
  SELECT count(*) INTO n FROM looked_up a JOIN bill_candidate c USING (candidate_id)
   WHERE a.now_status = 'enacted'
     AND (c.date_royal_assent IS NOT NULL OR c.asp_number IS NOT NULL);
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % line(s) already hold Royal Assent values.', n;
  END IF;

  SELECT count(*) INTO n FROM looked_up a JOIN bill_candidate c USING (candidate_id)
   WHERE coalesce(c.review_note, '') ~ 'Checked: enactment_status = ';
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % line(s) have already been looked up.', n;
  END IF;

  -- Every line the checker is complaining about must be in this list, or this
  -- migration does not clear what db/090 opened.
  SELECT count(*) INTO n FROM v_candidate_problems p
   WHERE p.problem LIKE 'the fact sheet leaves this bill awaiting Royal Assent%'
     AND p.candidate_id NOT IN (SELECT candidate_id FROM looked_up);
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % line(s) await a look-up that this migration does not do.', n;
  END IF;
END $$;

-- ---------------------------------------------------------------------------
-- What was found
-- ---------------------------------------------------------------------------

UPDATE bill_candidate c
   SET enactment_status  = a.now_status,
       date_royal_assent = coalesce(a.assent, c.date_royal_assent),
       asp_number        = coalesce(a.asp, c.asp_number),
       short_title       = coalesce(a.act_title, c.short_title),
       title_kind        = CASE WHEN a.act_title IS NOT NULL THEN 'act'
                                ELSE c.title_kind END,
       review_note       = btrim(coalesce(c.review_note || E'\n', '')
                           || 'Checked: enactment_status = ' || a.now_status
                           || ' (legislation_gov_uk, ' || a.url || ', 2026-09-15)'
                           || CASE WHEN a.assent IS NULL THEN '' ELSE
                                E'\n' || 'Checked: date_royal_assent = ' || a.assent
                                || ' (legislation_gov_uk, ' || a.url || ', 2026-09-15)'
                                || E'\n' || 'Checked: asp_number = ' || a.asp
                                || ' (legislation_gov_uk, ' || a.url || ', 2026-09-15)'
                                || E'\n' || 'Checked: short_title = ' || a.act_title
                                || ' (legislation_gov_uk, ' || a.url || ', 2026-09-15)'
                              END
                           || E'\n' || a.note)
  FROM looked_up a
 WHERE a.candidate_id = c.candidate_id;

-- ---------------------------------------------------------------------------
-- What this leaves
-- ---------------------------------------------------------------------------

DO $$
DECLARE n integer;
BEGIN
  -- Nobody is left unlooked-up.
  SELECT count(*) INTO n FROM v_candidate_problems
   WHERE problem LIKE 'the fact sheet leaves this bill awaiting Royal Assent%';
  IF n <> 0 THEN RAISE EXCEPTION '% line(s) still have no look-up.', n; END IF;

  -- The seven are Acts, with all four values and none missing.
  SELECT count(*) INTO n FROM bill_candidate
   WHERE candidate_id IN (390,391,392,394,395,396,397)
     AND enactment_status = 'enacted' AND title_kind = 'act'
     AND date_royal_assent IS NOT NULL AND asp_number IS NOT NULL
     AND short_title ~ '\d{4}$';
  IF n <> 7 THEN RAISE EXCEPTION 'Only % of the seven are complete Acts.', n; END IF;

  -- Each of them carries a citation for each of the four values taken from
  -- legislation.gov.uk, so promotion writes four notes. A line may carry more:
  -- line 390's introduction date was settled at db/089 and has its own.
  SELECT count(*) INTO n FROM bill_candidate
   WHERE candidate_id IN (390,391,392,394,395,396,397)
     AND review_note ~ 'Checked: enactment_status = enacted \(legislation_gov_uk, '
     AND review_note ~ 'Checked: date_royal_assent = \d{4}-\d{2}-\d{2} \(legislation_gov_uk, '
     AND review_note ~ 'Checked: asp_number = 2026 asp \d+ \(legislation_gov_uk, '
     AND review_note ~ 'Checked: short_title = .+ \(legislation_gov_uk, ';
  IF n <> 7 THEN RAISE EXCEPTION 'Only % of the seven carry all four citations.', n; END IF;

  -- The five that did not move did not move.
  SELECT count(*) INTO n FROM bill_candidate
   WHERE candidate_id IN (303,304,305,393,474)
     AND enactment_status = 'blocked' AND date_royal_assent IS NULL
     AND asp_number IS NULL AND title_kind = 'bill';
  IF n <> 5 THEN RAISE EXCEPTION 'Only % of the five are untouched.', n; END IF;

  -- The clean sheet is not touched by any of this. Session 5 is closed and its
  -- three lines gained a note, not a value.
  SELECT count(*) INTO n FROM bill;
  IF n <> 389 THEN RAISE EXCEPTION '% bills on the clean sheet, expected 389.', n; END IF;

  SELECT count(*) INTO n FROM stage_event;
  IF n <> 1071 THEN RAISE EXCEPTION '% stage records, expected 1071.', n; END IF;

  SELECT count(*) INTO n FROM field_source;
  IF n <> 112 THEN RAISE EXCEPTION '% provenance notes, expected 112.', n; END IF;

  SELECT count(*) INTO n FROM bill WHERE enactment_status = 'pending';
  IF n <> 0 THEN RAISE EXCEPTION '% bill(s) on the clean sheet are pending.', n; END IF;

  -- Back to the list that was there before db/090, which steps 7 and 8 clear.
  SELECT count(*) INTO n FROM v_candidate_problems;
  IF n <> 22 THEN
    RAISE EXCEPTION 'The error checker finds % problem(s), expected 22.', n;
  END IF;

  RAISE NOTICE 'Twelve bills looked up, seven are Acts, 389 bills untouched, 22 problem(s) left for steps 7 and 8.';
END $$;

COMMIT;
