-- db/083_what_the_notes_tell_a_reader_about_carried_over_bills.sql
--
-- M6 is rewritten and M9 is added. Both are text a reader sees, and both were
-- agreed with the owner on 2026-09-14.
--
-- -------------------------------------------------------------------------
-- M6.
--
-- M6 already stated the rule -- a bill belongs to the session it was first
-- introduced in -- and the arithmetic that follows from it. What it did not
-- state was the test a reader could apply themselves, or the other thing that
-- happens across a session boundary, which is a different thing counted a
-- different way. A reader who knows only the rule cannot tell whether the
-- Robin Rigg Bill was one bill or two, and the answer is two.
--
-- So the note now gives the test -- did the first bill end? -- and both
-- answers, with the per-session figures beside the fact sheets' own so that
-- the difference is visible rather than implied.
--
-- The owner's instruction for the site, in their words: "when we come to chart
-- bill volumes we include a note which explains our handling of carry over
-- Bills (ie they are counted in their original session). That way people are
-- (a) aware of their existence and (b) understand our methodology, whether
-- they agree with it or not." M6 is that note, and the last sentence of it
-- says so.
--
-- -------------------------------------------------------------------------
-- M9.
--
-- The new note. A reintroduced Private Bill does not repeat the scrutiny the
-- earlier bill completed, so the Robin Rigg Act's journey from introduction to
-- Final Stage reads 42 days where the business took 364. That is recorded in
-- prose on the bill and on both of its empty stage rows, and prose cannot
-- reach a chart. M9 is what a chart of how long bills took carries, as M4 is
-- carried on a chart of outcome by type.
--
-- No figure in M9 is quoted from memory. 42 and 364 are the two date
-- differences, 132 is the next shortest Private Bill (the William Simpson's
-- Home (Transfer of Property etc.) Act 2007), and 274 is the median of the 22
-- Private Bills that passed. All four were read out of the database on
-- 2026-09-14.

\set ON_ERROR_STOP on
BEGIN;

UPDATE methodology_note SET body =
'Most bills are introduced, disposed of and finished inside one session. A few are not, and there are two quite different ways that happens. The test that tells them apart is whether the first bill ended.'
  || E'\n\n' ||
  'WHERE THE BILL DID NOT END there is one bill and two fact sheet rows. The bill was still live when the session closed, so the next session''s fact sheet lists it again. This resource assigns such a bill to the session in which it was first introduced, and holds that assignment however long the bill takes and whatever happens to it afterwards; its later events are recorded on the same bill, so what we hold is the whole of its life rather than the part of it that fell inside one session. Four bills do this. The United Nations Convention on the Rights of the Child (Incorporation) and European Charter of Local Self-Government (Incorporation) Bills were introduced and passed in Session 5, stopped before Royal Assent, reconsidered and enacted in Session 6, and are counted in both sessions'' fact sheets; here they are Session 5 bills. The Gender Recognition Reform Bill was introduced and passed in Session 6, was stopped by a section 35 order, and appears in the Session 6 and Session 7 fact sheets; here it is a Session 6 bill. The UK Withdrawal from the European Union (Legal Continuity) Bill was introduced and passed in Session 5 and withdrawn in Session 6; the Session 6 fact sheet gives it a section of its own and says in terms that it is not included in that session''s totals.'
  || E'\n\n' ||
  'WHERE THE BILL DID END — it fell, or was withdrawn, or was rejected — and something was introduced afterwards, there are two bills, and they are counted as two, each in the session it was introduced in. Six pairs of bills do this. One of them, the Robin Rigg Offshore Wind Farm (Navigation and Fishing) Bill, fell at the end of Session 1 and was reintroduced in Session 2, and a reintroduced Private Bill does not repeat the scrutiny the earlier bill completed. That does not change the count: two bills were introduced and two are counted. It does change how long the second bill appears to have taken, and methodology note M9 is about that.'
  || E'\n\n' ||
  'THE ARITHMETIC. The seven fact sheets print 474 rows between them, of which 473 are counted in their own summary totals: the Legal Continuity Bill is printed in Session 6 and excluded from its totals. Four of the 474 are second appearances of a bill counted already, so there are 470 distinct bills. Per session we count 73, 81, 62, 86, 87, 80 and 1, against the fact sheets'' own 73, 81, 62, 86, 87, 82 and 2. Sessions 6 and 7 are lower for the reason given above, and nothing else differs.'
  || E'\n\n' ||
  'THE ALTERNATIVE was to count a bill in each session in which it was live, as the fact sheets do. It was rejected because it makes a bill''s session ambiguous, makes the total number of bills depend on how they are summed, and double-counts three bills in any all-session figure. Any chart of how many bills there were carries this note, so that a reader can see what the rule did and disagree with it if they wish.'
WHERE code = 'M6';

INSERT INTO methodology_note (code, title, body, applies_to, sort_order) VALUES
 ('M9',
  'A reintroduced bill is a second bill, and may not have repeated its scrutiny',
  'Where a bill falls and another is introduced in a later session to do the same job, this resource records two bills and counts two, because two bills were introduced. Methodology note M6 gives the rule. One consequence needs saying separately, because it affects how long a bill appears to have taken rather than how many bills there were.'
    || E'\n\n' ||
    'Under Private Bill procedure a reintroduced bill does not repeat the scrutiny the earlier bill completed. The Robin Rigg Offshore Wind Farm (Navigation and Fishing) (Scotland) Bill was introduced on 27 June 2002, completed its Preliminary Stage on 9 January 2003 and its Consideration Stage on 11 March 2003, and fell at the end of Session 1 without reaching its Final Stage. It was reintroduced on 15 May 2003, went straight to the Final Stage vote, and passed on 26 June 2003.'
    || E'\n\n' ||
    'So the Act''s Preliminary and Consideration Stages are recorded as stages that never happened, with a note on each saying where they did happen, and its journey from introduction to Final Stage reads 42 days. The next shortest Private Bill took 132 days and the median of the 22 that passed is 274. Measured from the first introduction, the same business took 364 days. Neither figure is wrong; they measure different things.'
    || E'\n\n' ||
    'The Act records which bill it carried its scrutiny from, so a chart of how long bills took can be built either way. Any such chart carries this note and says which it used. One bill is affected.',
  '{bill.reintroduced_from_bill_id,stage_event.did_not_happen,bill.session_number}',
  9);

-- M5 is the note the two new cells belong to -- it is the one that says
-- passing a bill is not the same as the bill being finished -- so it has to
-- list them, or the site has no way to put the note beside the value.
UPDATE methodology_note
   SET applies_to = applies_to || '{bill.assent_block_route,bill.assent_block_outcome}'
 WHERE code = 'M5'
   AND NOT applies_to @> '{bill.assent_block_route}';

-- Read back, so that a migration cannot claim to have written text it did not.
DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM methodology_note WHERE code = 'M9';
  IF n <> 1 THEN RAISE EXCEPTION 'M9 was not written.'; END IF;
  SELECT count(*) INTO n FROM methodology_note
   WHERE code = 'M6' AND body LIKE '%473 are counted in their own summary totals%'
     AND body LIKE '%73, 81, 62, 86, 87, 80 and 1%';
  IF n <> 1 THEN RAISE EXCEPTION 'M6 does not carry the new arithmetic.'; END IF;
  SELECT count(*) INTO n FROM methodology_note
   WHERE code IN ('M6','M9') AND (body LIKE '%  %' OR body LIKE '% ' || E'\n' || '%');
  IF n > 0 THEN RAISE EXCEPTION '% note(s) have stray spacing from the way this migration joins its paragraphs.', n; END IF;
  SELECT count(*) INTO n FROM methodology_note
   WHERE code = 'M9' AND body LIKE '%42 days%' AND body LIKE '%364 days%'
     AND body LIKE '%132 days%' AND body LIKE '%274%';
  IF n <> 1 THEN RAISE EXCEPTION 'M9 does not carry all four figures.'; END IF;
  SELECT count(*) INTO n FROM methodology_note
   WHERE code = 'M5' AND applies_to @> '{bill.assent_block_route,bill.assent_block_outcome}';
  IF n <> 1 THEN RAISE EXCEPTION 'M5 does not list the two new cells.'; END IF;
END $$;

COMMIT;
