-- 023_methodology_catch_up.sql
-- Notes only, no schema. Two judgements the survey exposed that are invisible in
-- the numbers, and one existing note pointing at columns that no longer exist.
--
-- The bar is that a reader who disagrees with a judgement can see what it was
-- and redo the work differently. A judgement recorded only in this repository
-- fails that bar, because the repository is not what the data is published with.

BEGIN;

-- ---------------------------------------------------------------------------
-- M2 pointed at bill.end_stage_1_date, bill.end_stage_2_date and
-- bill.end_stage_3_date. db/018 dropped all three and moved stage dates into
-- stage_event under each bill type's own stage names. The note's argument is
-- unaffected; the columns it attaches to, and the vocabulary it uses, are not.
UPDATE methodology_note SET
 body = 'A stage is treated as completed on the date of the decision that ended it. For the final stage — Stage 3 for a public bill, Final Stage for a Private or Hybrid Bill — that decision is the vote on whether to pass the bill, so the stage is completed on the date the bill was passed. Completion dates for the earlier stages are not yet recorded: which date marks their completion is still an open question, because the committee report, the chamber debate and the decision itself fall weeks apart and give materially different durations. Durations measured to the final stage are therefore stable; durations to the earlier stages do not yet exist. One case is settled: for a bill rejected at its first stage the committee report, the debate and the decision collapse onto a single day, so all three candidate definitions agree and the date is recorded.',
 applies_to = '{stage_event.date_completed,stage_event.completed}'
 WHERE code = 'M2';

-- ---------------------------------------------------------------------------
INSERT INTO methodology_note (code, title, body, applies_to, sort_order) VALUES
('M6',
 'A bill belongs to the session in which it was first introduced',
 'Most bills are introduced, disposed of, and finished within one session. Four are not, and for those a choice has to be made about which session they belong to. This resource assigns a bill to the session in which it was first introduced, and holds that assignment however long the bill takes and whatever happens to it afterwards. The consequence is that our per-session counts do not match the Parliament''s fact sheets, which count a bill in every session in which it was live. The UNCRC (Incorporation) and European Charter of Local Self-Government (Incorporation) Bills were introduced and passed in Session 5, reconsidered and enacted in Session 6, and are counted in both sessions'' fact sheets; here they are Session 5 bills. The Gender Recognition Reform Bill was introduced and passed in Session 6, was blocked by a section 35 order, and appears in the Session 6 and Session 7 fact sheets; here it is a Session 6 bill. The UK Withdrawal from the European Union (Legal Continuity) Bill was introduced and passed in Session 5 and withdrawn in Session 6; the Session 6 fact sheet gives it a section of its own and explicitly excludes it from that session''s totals. Adding up the seven fact sheets'' own stated totals gives 473; there are 470 distinct bills, and 474 rows to read, because one bill appears in a fact sheet without being counted in it. The alternative rule — counting a bill in each session it was live — was rejected because it makes a bill''s session ambiguous, makes the total number of bills depend on how they are summed, and would double-count three bills in any all-session figure.',
 '{bill.session_number}', 6),
('M7',
 'Why a bill fell is our coding, not the fact sheets''',
 'The SPICe fact sheets group unsuccessful bills under a single heading, "bills which have fallen", and never say why any individual bill fell. The reasons differ and matter: a bill whose general principles the Parliament refused at Stage 1 was defeated, a bill defeated at the final vote was defeated at a different point and after far more scrutiny, and a bill that simply ran out of time at dissolution was never voted on at all. Treating those as one category would make a large share of unsuccessful bills look like decisions when many are the calendar running out. This resource therefore distinguishes them in bill.outcome, and each distinction is a coding decision made by us against the Official Report, not a value read from the fact sheet. Where a bill''s outcome has been coded this way, the citation is recorded against it. There are 48 fallen bills across the seven sessions. This work is incomplete: at the time of writing it has been done for the five fallen bills of Session 1, all of which were rejected at Stage 1 rather than lost at dissolution — which is itself an indication that the fact sheet''s single heading conceals a real distinction. Until the remainder is done, a count of bills by outcome will show fallen bills under a general code, and that should not be read as a finding that they ran out of time.',
 '{bill.outcome}', 7);

COMMIT;
