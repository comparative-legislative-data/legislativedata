# State

Updated: 2026-09-15

## Where we've got to

The first piece of work, across all seven sessions:

1. **What happened to each bill**, by bill type.
2. **How long each stage took**, by bill type and session. The main interest is
   introduction to the end of Stage 3.

Each session goes through the same steps. Its factsheet is read onto the
staging sheets, you review it, and it is copied onto the clean sheet. Stage 1
and 2 dates are added from your PhD.

| Session | Read in | Reviewed | On clean sheet | Stage 1 & 2 dates |
|---|---|---|---|---|
| 1 | 73 bills | yes | yes | yes; **closed** |
| 2 | 81 bills | yes | yes | yes; **closed** |
| 3 | 62 bills | yes | yes | yes; **closed** |
| 4 | 86 bills | yes | yes | yes; **closed** |
| 5 | 87 bills | yes | yes | yes; **closed** |
| 6 | 83 bills | yes | yes | yes; **closed** |
| 7 | 2 bills | yes | yes | Stage 3 only; test run, one item open |

**470 bills are now on the clean sheet**, with 1291 stage records and 186
provenance notes. **The error checker and the gaps list are both empty.** All
seven sessions are read in, reviewed and promoted. Session 7's closure test has
now been run by a session that did none of its work: seventeen of its eighteen
items pass, and the one that does not is about how a session comes off the clean
sheet again, not about any figure on it.

## What has been done

- **10–14 September.** Database built, all seven fact sheets surveyed, Sessions
  1 to 5 read in, reviewed, admitted, promoted and **closed**, your dates
  loaded, how time is counted settled, the two prose fact sheets read end to
  end, and Sessions 6 and 7 loaded onto the staging sheet.
- **15 September, earlier.** Session 6 compared against your dataset, its ten
  fallen bills read at the Official Report, your 134 stage dates loaded, and the
  session put on the clean sheet. M12 cut from 290 words to 95. A bill's note
  became the eighth cell a second appearance carries (`db/098`). Session 6's
  closure test run by another session: one item failed and was right to, and
  `db/101` mended it — a note we wrote had been dated to a fact sheet five days
  before we wrote it. `db/101`'s own test then run by a third session and passed.
  Session 6 then closed on your four sign-offs, and Session 7 promoted: one new
  bill and the Gender Recognition Reform bill appearing a second time, which
  changed nothing. M13 written first, because Session 7 brought the first bill
  still before the Parliament — counted like any other, with no ending, and shown
  **blank, not nought** on a chart of timescales. Two drafts of M13 were wrong
  and were caught by rehearsing; both are named in `db/102` so they cannot come
  back.

**15 September, this session. Session 7's closure test run, and the one thing it
found.**

- **Seventeen of the eighteen items pass**, and nothing was written: the two
  items that build something were built inside transactions that were thrown
  away, and one inside a scratch copy that was dropped.
- **Bill 393 is untouched by Session 7, and that is now proved rather than
  asserted.** The safety copy taken before the promotion was restored and
  compared against the live database bill by bill and cell by cell. One bill
  appeared — the new one — and none vanished. Of the 469 bills already there,
  exactly one differs in any cell at all, and the only cell that differs is the
  database's own timestamp. Not one stage record and not one provenance note
  appeared, vanished or changed.
- **The gaps list is quiet for the right reason.** Given a Stage 2 invented for
  the live bill, it immediately asked for Stage 1 and nothing else.
- **Item 18 failed, and it is the item that is wrong, not the database.** Taking
  Session 7 off the clean sheet takes the Gender Recognition Reform bill off with
  it, because a later session's line points at it. That is what the tool has done
  since `db/081`, and it says so as it runs. Nothing is lost — putting Session 6
  back and then Session 7 restores every cell — but the item expected a narrower
  undo than the tool performs.

## Now: item 18, and one sign-off

**Two things to settle about taking a session off again, neither of them urgent
and neither about a figure on the clean sheet.**

1. **Item 18's expected answer is wrong and should be rewritten** to what the
   tool actually does, with the reason: a bill of an earlier session that a later
   line points at has no copy of what it was before, so it comes off and its own
   session is promoted again to put it back.
2. **Whether that is the behaviour you want.** The tool goes by whether a line
   points at an earlier bill, not by whether the line changed anything. Session
   7's second line changed no cell of bill 393, and bill 393 comes off anyway.
   Safe, and wider than it needs to be. Yours to say.

**And a plain defect found on the way, which needs no decision:** the tool's own
"about to remove" summary counts only the session being taken off. It said one
bill, no stage records and no notes, and then removed two bills, three stage
records and four notes. Anyone using that preview to decide whether to go ahead
is shown too small a number.

**Three of Session 7's four sign-offs are already given**, on 15 September: the
two lines, M13's wording, and that a timescale chart shows Session 7 blank.
**The fourth is the standing one, and it is outstanding:** that you can explain
how this database works from the documents alone, without help. Until it is
given, Session 7 stays open.

## After that, in order

1. Bring `docs/VARIABLES.md` up to date. It is the last document still
   describing the database as it was several sessions ago.
2. **Filling in how Sessions 1 to 5's bills were handled.** Expected, not begun.
   Their fact sheets do not mention procedure at all, so it needs a source we
   have not agreed. Until then a count of emergency bills counts only the five
   Session 6 names, which is what M10 tells a reader.
3. **A layer of vote data**, its own piece of work. Scope not opened.
4. **Taking bill data from live sources as the next five years run.** Your
   words, 15 September: a fundamentally different thing from ingesting historic
   fact sheets, to be designed separately and not now.
5. Then, and only then: the website, and reading from the Parliament's API.
   **This is where the choice M13 leaves open gets made**: which bills a figure
   about time covers — every bill with any terminal point, or only bills that
   completed every stage. The data carries both; nothing has to change to
   support either.

**Yours whenever you want it, and nothing waits on it:** your write-up on what
the charts present and the options they offer.

## Waiting for your decision, and not blocking anything

- **M5's wording.** Two sentences have drifted: it says the mechanism that
  stopped a bill is recorded in the bill's note, where since `db/084` it is also
  a cell of its own; and it closes by saying a bill's recorded state comes from
  the latest fact sheet read in, which M12 now qualifies. No data is wrong
  either way. Raised 15 September.
- **Whether the other eleven methodology notes should be cut the way M12 was.**
  M2 is 5,140 characters and M7 is 5,006, against M12's 631. They are what a
  reader of the published data sees, so this is yours. Raised 15 September.
- **Where the working dataset's backup lives.** `sources/phd/Billdates-September2026.xlsx`
  is deliberately outside version control. It exists on this machine and nowhere
  else. Each correction makes it worse.
- **Whether Session 5's four bills that ran out of time should carry the note
  Session 6's three now do**, recording that the loader's proposal was checked
  and what was read. Nothing is wrong with the data either way. Found
  15 September.
- **How to record a published record being revised.** When the first case
  arrives.
- **Whether to rename the dates factsheet's file** to match the others'.
- **Which source settles a disagreement about what kind of bill it was.** None
  has ever arisen.
- **Whether to take a copy of the bills before a change that touches them.**
  `tools/take_copy.sql` already exists. A full copy was taken before `db/102`
  and Session 7's promotion: `/var/tmp/legdata-before-db102-and-s7_2026-09-15.dump`.

**Settled on 15 September, and no longer on this list:** whether a bill's note
should be rewritten when the bill is reconsidered and passed — it is, and the
note is now the eighth cell a second appearance carries; the two Stage 3
rejections, which stay recorded as rejections rather than as bills that fell;
and how a bill still before the Parliament is recorded and charted (M13).

## One small thing for you

The Robin Rigg Act's own note names both its missing stages and gives one date —
the Preliminary. It is incomplete rather than wrong, and mending it was not part
of what we agreed, so it is untouched. Say if you want the Consideration date in
it too, and it goes in next time Session 2 comes off.

---

# Notes for whoever runs the session

Everything below the line is working detail. The owner does not need it to
orient, and none of it belongs above the line.

## Keeping this file useful

- **Above the line is for the owner.** Keep it to about a screen. At the end of
  a session: update the table, add one short entry for the session, cut older
  entries to a line each, and rewrite "Now". If it grows, cut; do not append.
- **The history of structure changes** is the numbered files in `db/` and
  `DECISIONS.md`. It is not repeated here.
- **A session the table calls closed must have a closure test**, written by one
  session and run by another, with the run recorded in `docs/CLOSURE-TESTS.md`.
  The opening check asks that of every closed row, because twice now the counts
  have been right and the word has been wrong: Sessions 1 and 2 on 12 September,
  Session 5 on 14 September. A count is not evidence about a procedure.

## Sanity check, 2026-09-15, the session that ran Session 7's closure test

**Run at the end, on checking rather than memory.** **470 bills, 1291 stage
records, 186 provenance notes, 13 methodology notes.** Per session: 73, 81, 62,
86, 87, 80, 1. **The error checker finds nothing and the gaps list holds
nothing.** The data dictionary regenerates identical to the committed file — 19
tables, 181 columns, all described. Only the `legdata` database on the server:
the scratch copy this session made for item 16 was dropped, checked by listing
the databases afterwards. Every working file this session put in `/tmp` and
`/var/tmp` on the server has been removed; the safety copies in `/var/tmp` are
untouched.

**The opening check found nothing wrong.** The table's counts matched the
database exactly, the last commit and the newest `DECISIONS.md` entry were
already carried into `STATE.md`, the data dictionary regenerated identical, and
the tree was clean and pushed.

**Nothing was written by the test.** Items 11 and 18 build something, and each
was built inside a transaction that was thrown away; the counts, the error
checker and the gaps list were identical before and after. Item 16 was done in a
scratch database that was dropped.

**What this session did not do.** It did not rewrite item 18, and it did not
touch `tools/rollback_promotion.sql`. Both are proposals at the top of this file
and are for the owner to settle, because the wider undo is a question about
method and the session that found it should not also decide it.

**Worth passing on: compare against the copy, not against a memory of it.**
Item 16 asks that nothing else on the clean sheet moved. The cheap version —
looking at which bills carry a recent timestamp — cannot answer it, because
Session 6 was promoted the same day and its bills carry the same date. Restoring
the safety copy into a scratch database, dumping the live one in beside it under
another name, and comparing the two row by row does answer it, and it is what
proved item 7 as well. The first attempt, which moved the tables through CSV
files, failed on a column count and was abandoned rather than patched.

## Session 7, and M13: working detail, 15 September

**The sequence was: rehearse, then write the note, then rehearse again.** The
promotion was rehearsed before M13 existed, and that is what exposed both of the
note's wrong drafts. Doing it the other way round would have published either.

- **The rehearsal admitted Session 7 inside the thrown-away transaction**, since
  promotion refuses a line still at `new`. `strip_for_rehearsal.py` was used on
  `db/102` and `promote_session.sql` so both ran inside one `BEGIN … ROLLBACK`.
- **What the promotion actually did:** one new bill, no stage record added, no
  provenance note added, and an empty "what changed" table for the further
  appearance. Bill 393's `updated_at` moved even so, because promotion writes
  the eight cells whether or not they differ. That is the database's own stamp;
  no cell a reader sees moved. Item 7 of the closure test says so explicitly so
  that a later session does not read it as a change.
- **Bill 393's four provenance rows still cite the Session 6 sheet**, and should.
  `db/101` rewrites a note's provenance only where the cell changed. A row citing
  session 7 would mean something had moved.
- **The gaps list stays empty for a live bill by design, not by luck.**
  `v_stage_date_gaps` has an `in_progress` branch that asks such a bill only for
  the stages below the furthest one it has reached. Bill 473 has reached none, so
  it is asked for nothing. Item 11 of the test exercises that branch deliberately,
  because item 10 alone cannot tell "the rule held" from "the rule is gone".
- **The two withdrawn drafts of M13** are recorded in `db/102`'s header, in
  `DECISIONS.md` and in item 13 of the closure test, which refuses the note if
  either phrase reappears.
- **The SSH rate limit cost this session about ten minutes.** Roughly a dozen
  connections in quick succession gives `Connection refused` for a while, and
  several short calls in a row tripped it repeatedly. Batch the work into few
  connections; it is in this file already and is worth heeding.

## What the session before this one did

**Closed Session 6 on the owner's four sign-offs, promoted Session 7, and wrote
M13** as `db/102`, because Session 7 brought the first bill this database has
ever held that has not finished. Two drafts of M13 were wrong and were withdrawn
before it was applied; `db/102` refuses the note if either phrase reappears. The
promotion added one bill, no stage record and no provenance note. It wrote
Session 7's closure test and did not run it.

## Session 6's closure test, 15 September

Run by the session before this one, which had not built it. Twenty of the
twenty-three items passed. Item 14 failed and was real: `db/098` moved the
note's provenance `source` to `manual` and left `source_ref` and `observed_at`
naming the Session 6 fact sheet and 10 September, so each row said the note had
been seen in a document five days before it was written. **`db/101`** moves all
three together and takes the date from the line's own `reviewed_at`;
`tools/promote_session.sql` changed in the same commit; both rehearsed twice
inside transactions that were thrown away, with a copy taken first. Items 19 and
23 were themselves wrongly written and are rewritten with what they first said —
item 19 described a settled adjudication as a discrepancy, item 23 cited
`db/079` for a rule `db/079` declined to make. A sentence in `DECISIONS.md` that
contradicted the database was corrected at the same time: 23 May 2021 is ten
days into Session 6, not between dissolution and the new Parliament. The date
itself was never in doubt.


## Session 6's dates and endings, 15 September

Compared Session 6 against the owner's dataset, found seven bills that had become
Acts four months earlier, fixed the three blind spots that hid it, read all ten
fallen bills at the Official Report, then recorded where each of the fourteen
bills that did not pass stopped (`db/095`), loaded all 136 of the owner's stage
dates, and corrected Ecocide and Freedom of Information Reform to read the same
(`db/096`). It wrote the tests for all of it and, rightly, did not run them.

## The tests on Session 6’s week, 15 September

**Ran the five closure tests on `db/089` to `db/096`, the two tools and the
comparison report.** Thirty-eight items: thirty-five mechanical, three for the
owner. **All thirty-five mechanical items pass.** Nothing was written to
anything; every fixture ran inside a transaction that was rolled back, and the
three counts, the checker and the gaps list were the same before and after.

**Then two of the three owner's items came back the same day.** The Stage 3
distinction was confirmed and needed no build (`DECISIONS.md`). M12 was read
whole and judged too long for what it says, and **`db/097` cuts it from 290
words to 95** and retitles it *A fact sheet is a snapshot*. It was rehearsed
inside a thrown-away transaction and read back before it was applied; it changes
one row of one text table, touches no bill, line, stage record or provenance
note, and leaves `applies_to` and the runbook procedure alone. M5's wording is
the one item still open, and it is noted rather than settled.

How each kind of item was run, since the method matters more than the result:

- **The view rewrites** (`db/088` → `db/090` → `db/094`) were rebuilt side by
  side under other names inside one thrown-away transaction, read back out of
  the database with `pg_get_viewdef`, and diffed as text. Three replaced lines
  from `db/088` to `db/090` and one from `db/090` to `db/094`, no hunk that
  deletes without replacing, so no check was lost. This is the check that the
  error checker did not quietly get weaker while it was being widened.
- **`db/095`'s twelve refusals** were exercised by splitting the migration into
  its temp table and its `DO` block, then running the block once per deliberate
  fault. Nine of the twelve fire only after the "already hold a stage row" check,
  so those runs delete Session 6's stage rows inside the same thrown-away
  transaction first. A control run with the rows deleted and nothing else altered
  passes, which is what stops the whole exercise proving only that the block
  refuses everything.
- **The two tools query the database over their own connection**, so a rolled-back
  transaction is invisible to them. Both fixtures instead send the mutation, the
  tool's own query and `SELECT 1/0` as three `-c` arguments to one
  `psql --single-transaction`, so the tool sees the altered database and the
  error rolls the whole thing back. That is how the reader was shown bill 303
  missing a stage, and the comparison report shown line 395 without its Royal
  Assent date. Worth keeping: it is the only way to test a tool against a state
  the database must not be left in.
- **The loader** was tested through `strip_for_rehearsal.py`, wrapped in a
  transaction that deletes Session 6's dataset rows first — otherwise an altered
  row is caught by the "did not arrive as the CSV had them" check and never
  reaches the rule being tested.
- **Twenty-seven pages were read again**: eleven Acts at legislation.gov.uk,
  seven Official Report meetings, and nine of the Parliament's bill pages. Every
  one still says what the database says it says.

**Two items could not be run as written, and one number is out of date.**

- `db/093`'s item 1 expects the checker to find two problems. It finds one:
  `db/094` settled line 412 later the same day. The check behind the number still
  holds — emptying line 412's two cells brings its complaint straight back.
- The snapshot test's preamble expects 22 problems throughout. It finds one,
  for the same reason: steps 7 and 8 of the runbook ran after the test was
  written. What the item actually asks — that nothing in the test moves the
  counts — held.
- **Two items wait on the promotion of Session 6**, which cannot happen before
  the owner's review. Both were dress-rehearsed instead, inside a thrown-away
  transaction with the review stood in for by marking the rows accepted: bill 305
  comes out `passed`, `not_enacted`, `withdrawn`, concluded 10 March 2022, with
  a provenance note reading *"It read 'still_blocked' and now reads
  'withdrawn'."*; bills 303 and 304 come out `reconsidered_passed` and `enacted`.
  The seven Acts' four citations each arrive as provenance notes with the full
  value in `value_seen`, bracketed titles intact. **All of that must be watched
  again at the real promotion**; a rehearsal with a stood-in review is not the
  test, and `CLOSURE-TESTS.md` says so at both items.

**One small discrepancy, no data affected.** The workbook's own Corrections note
for row 395 and row 462 is dated 14 September 2026; `STATE.md` had described
those corrections under 15 September. The workbook's date is the one to trust.

## M5 and M12, as a reader sees them today

Kept here so the questions above can be weighed without opening the database.
M5 is unchanged and its wording is still open; M12 was cut on 15 September.

**M5 — Passing a bill is not the same as the bill being finished.**

> A bill that is passed by the Parliament does not automatically become an Act.
> It must be submitted for Royal Assent, and that submission can be prevented in
> two ways: the Law Officers may refer the bill to the Supreme Court under
> section 33 of the Scotland Act 1998, and the Supreme Court may rule that some
> of it is outwith the Parliament's legislative competence; or a Secretary of
> State may make an order under section 35 prohibiting submission. This resource
> therefore records what the Parliament did (bill.outcome) separately from
> whether the bill became an Act (bill.enactment_status), and a count of bills
> passed will not equal a count of Acts. Four bills are affected. Three were
> referred under section 33 and ruled against on 6 October 2021: the UNCRC
> (Incorporation) and European Charter of Local Self-Government (Incorporation)
> Bills were subsequently taken through Reconsideration Stage and enacted, and
> the UK Withdrawal from the European Union (Legal Continuity) Bill was withdrawn
> on 10 March 2022, nearly four years after it passed. The fourth, the Gender
> Recognition Reform (Scotland) Bill, was blocked by a section 35 order on
> 16 January 2023, and no further step has been taken. A bill in that position
> does not fall at the end of a session in the way an unfinished bill does; it
> remains a live bill, and the Parliament's own fact sheets carry it forward into
> the next session. The status 'blocked' covers both mechanisms and covers a bill
> left in that state indefinitely; which mechanism applied is recorded in
> bill.note, and the date in bill.date_assent_blocked. Because enactment_status
> records a bill's current state rather than its history, a bill that was blocked
> and later enacted shows as enacted; the earlier state is kept in the fact sheet
> lines this resource holds for every session, where the bill appears as each
> fact sheet printed it at the time, and the date of the block stays in
> bill.date_assent_blocked. A bill's recorded state is the one given by the
> latest fact sheet that has been read in, not by the latest fact sheet that
> exists. So a bill stopped in one session's fact sheet stays recorded as blocked
> here until the fact sheet saying what happened to it next has itself been read
> in, and the account above of what became of these four bills runs ahead of the
> data until that has happened.

The two sentences that have drifted are "which mechanism applied is recorded in
bill.note" — since `db/084` it is also a cell of its own — and "A bill's recorded
state is the one given by the latest fact sheet that has been read in", which
M12 now qualifies for bills left awaiting Royal Assent.

**M12 — A fact sheet is a snapshot.** As cut by `db/097`, 15 September, and as
a reader sees it now.

> A fact sheet says where each bill had got to on the day it was compiled, not
> where it stands now. Seven bills the Session 6 sheet leaves awaiting Royal
> Assent had become Acts four months before we read it.
>
> So every bill a fact sheet leaves awaiting Royal Assent is checked at
> legislation.gov.uk before it is admitted, and the answer recorded either way —
> including where no Act has been made, as for the four bills M5 covers. Where
> the Act was made, its date of Royal Assent, its number and its title come from
> legislation.gov.uk and say so, with the day each was read. The rest of the
> bill's line still comes from the fact sheet.

The 290-word version it replaces is in this file as committed at `ccac41c`.

## Session 6's dates and endings, in detail

**`db/095`: where all fourteen of Session 6's bills that did not pass stopped.**
Ten were already read — `db/092` had the Official Report for the seven that were
decided and the bill pages for the three that ran out of time — but none of the
ten had a stage row, because `db/092` deliberately left that to the stage dates.
The four withdrawn bills were read for the first time, at the Parliament's page
for each, and all four say the same thing in the same words: withdrawn at Stage
1, having not completed it, on the day the fact sheet already gives. Two of the
three that ran out of time had completed Stage 1, and `db/095` carries those two
dates from the pages that state them; the owner's dataset gives the same two
independently. Sixteen rows, rehearsed inside a thrown-away transaction first,
every refusal exercised.

**Two tools had to change before the dates would load**, and both refusals were
the tools working rather than obstacles. The reader did not know about a bill's
second appearance and refused three lines as missing from the dataset; it now
writes nothing for such a line, having checked that the bill it continues really
holds the two stages in question. The loader required the error checker to be
empty afterwards, which stopped being a statement about the load the moment
something was left standing in the checker that nothing could answer yet; it now
requires that the load caused nothing, problem by problem. Both changes are in
`DECISIONS.md`. Sessions 1 to 5 give byte-identical output from the reader either
side, 693 lines, and the loader was proved to still refuse a bad load before it
was used on a real one.

**136 stage rows loaded**, 68 Stage 1 and 68 Stage 2, over 68 bills — exactly the
gaps list, which now holds only Session 7's two. Safety copies taken first and
compared afterwards, then dropped.

**`db/096`: the one thing this session got wrong.** `db/095` described Ecocide
and Freedom of Information Reform as different cases, on the strength of two
meetings listed under Ecocide's Stage 2 heading. Those are the lead committee's
meetings; further down the same page the Parliament says a date for Stage 2
consideration was never set and no Marshalled List was produced. The owner
caught it and ruled that both bills completed Stage 1 and no more. The dates
were already right and unchanged; two notes were wrong and are corrected.

**What this session did not do, and should not:** run its own checks. The nine
items on `db/095`, `db/096` and the two tools are written in `CLOSURE-TESTS.md`
for a session that built none of it.

## The comparison against the dataset, in detail

**Step 6 of the runbook, run for the first time since it was written down.**
Six hand-pairings confirmed on the dates the two sources share and added to
`MANUAL_PAIRS`; four unpaired lines confirmed as second appearances, each with
its dataset row under the session it was introduced in. All 85 lines of Sessions
6 and 7 now carry the comparison stamp. `db/089` settles the five cells the two
sources disagree on. The working dataset is corrected for the two cells where it
was the one wrong: before
`072184df1fd4fbc15ae9e66ca51f9e287de6bc9b3b8f4d8342f6cae4e79ac1d2`, after
`31b20b9cda180418ee78a62fcab6e30e076f1885c27d12ec62a6dea75324d69b`, exactly two
cells differing on the data sheet and the stage dates for Sessions 1 to 5
byte-identical either side.

**Then the finding that stopped the session.** Seven Session 6 lines sit in the
fact sheet's awaiting-assent table while the dataset gives a Royal Assent date
for each; legislation.gov.uk confirms all seven became Acts in May 2026. Three
separate mechanisms should have caught it and none did. Put to the owner with
the evidence, and nothing built until all eight parts were agreed.

**`db/090` changed the rules and moved no data.** The error checker went from 22
problems to 34, the twelve new ones being every line in an awaiting-assent table
that nobody had looked up. **`db/091` looked all twelve up and cleared them**,
leaving the same 22 that steps 7 and 8 exist to clear. Both rehearsed inside a
thrown-away transaction first, and the rehearsal caught a fault — in the test,
not the data: line 390 carries five citations, not four, because `db/089` had
already given it one.

**`tools/compare_sources.py` now reports a cell one source fills and the other
leaves empty**, and writes nothing for it. Re-run afterwards, Session 6 gives 80
of 83 paired, zero one-sided cells and zero differences.

**What this session did not do, and should not:** run its own checks. The
fourteen items on `db/089`, `db/090`, `db/091` and the two tools are written in
`CLOSURE-TESTS.md` for a session that built none of it. Nor did it certify the
runbook's steps 6 to 8 against Sessions 1 to 5 — the owner ruled on 15 September
that this is not needed.


**Step 7, the Official Report for all ten of Session 6's fallen bills.** The
fact sheet's one word covers three things. Five were rejected at Stage 1, every
one on the member in charge's own motion being disagreed to; two were rejected
at Stage 3 having completed Stages 1 and 2 — the Assisted Dying and Recall of
Members bills, only the second and third `rejected_stage_3` in the database; and
three ran out of time, the loader's proposal checked and standing, nothing
having been decided on 8 April 2026 or capable of being. `db/092`. For the
Disabled Children bill a secondary summary gave division figures the Official
Report does not record, which is what `db/067` exists for.

**Step 9, all fifteen.** `db/094` settled the last of them on your ruling: the UK
Withdrawal (Legal Continuity) Bill says the Parliament passed it, that it never
became an Act, and that what followed the block was the withdrawal of 10 March
2022. The rule that a passed bill with no Royal Assent date must read as blocked
or awaiting one now also accepts a line that says what followed. Two things in
M5 have drifted and were deliberately left for you; they are in the list below.

**Step 9, thirteen of the fifteen first.** `db/093`: how the Gender
Recognition Reform Bill was stopped, in both fact sheets; the European Charter
and UNCRC bills recorded as stopped and then reconsidered and passed; the
European Charter Act's title and number and the Dog Theft Act's year settled at
legislation.gov.uk; and three second appearances pointed at the bills they
continue. The error checker is at two.

## The owner's standing positions, so they are not re-argued

- **The dataset is taken as it is, for now.** The error checker catches a stage
  date in an impossible order, as it did for the Civil Partnership Act, but not
  one that is wrong and still in order; checking Session 5's against the
  Parliament's bill pages is 87 pages. The owner's judgement, 14 September, is
  that the error rate is likely very low and tolerable until there is a
  methodology for the check, and that nothing waits on it. Do not propose it
  again unasked. What would reopen it: a methodology for checking, or errors
  turning up often enough to say the rate is not what was assumed.

- **The structure** is accepted as the price of academic-quality transparency.
  `ref_party` and `ref_procedure` have no data behind them, and are deliberate
  future-proofing. What does not relax: the owner can fully understand it.
- **A change to how data is coded is finished before anything moves on.** See
  `CLAUDE.md`, working rules. "Not yet built" is not a state a decision may be
  left in. This is not a race.
- **The owner judges what is acceptable to claim as academic quality.** The
  project's own rules are choices, not requirements of rigour. When one makes
  a simple thing awkward, propose relaxing it rather than designing around it.
- **Provenance notes may change, provided the owner clears the change.**
  Approving a rehearsed promotion clears the notes it rebuilds. Any other
  change to a note goes to the owner individually.
- **The dataset is proved at the end, not session by session.** The test that
  counts is whether the charts and tables built from all seven sessions match
  what the owner built by hand off the PhD. A closure test proves that a
  document's words reached the clean sheet unaltered and are traceable; it is
  not evidence the data is right. See `DECISIONS.md`, 2026-09-12.
- **A closure test inherits and is not re-argued.** It covers its own session
  and the corrections made for it, and says which of its items an outside change
  can move. Do not re-run a settled session's test for the sake of it.
- **The owner does not run database steps.** The session runs them and reports
  the results against what they should say. Step-by-step instructions are for
  what the owner does do: filling in spreadsheets, and reviewing in Postico.

**Before explaining anything about the database**, read
`docs/HOW-THE-DATABASE-WORKS.md` and the rules in `CLAUDE.md`. **Before
changing the clean data**, read `docs/PROMOTION-RUNBOOK.md`, and bring the
rehearsal, the check and the undo without being asked.

## Stage dates: working detail

- **Built in `db/033`:** the stage-dates staging sheet (`stage_candidate`), the
  checks in `v_candidate_problems`, the gaps list (`v_stage_date_gaps`), the
  clean sheet's rule that an undated completed stage has a note, the Hybrid
  correction, descriptions, and M2. The load, promotion and rollback scripts
  read the new sheet. See `DECISIONS.md`, 2026-09-11, for what was settled
  while building.
- **Built in `db/035`: typed entry.** The owner types rows in Postico, one per
  stage; there is no loader and no spreadsheet (`DECISIONS.md`, 2026-09-11,
  "Stage dates are typed into Postico"). The sheet shows each row's title,
  filled in by a trigger and refreshed from `bill_candidate`; `stage_order`
  is filled in from the stage name (`db/036`); slashed dates are read day
  first by the server. `db/037` sets day first for Postico's login, which
  Postico's display ignores. Scripts run as the administrator and are not
  affected. The owner's steps are in the runbook. A new row must reach the server
  with `stage_candidate_id` as DEFAULT; sent as NULL it is refused.
- **What a PhD row holds:** source `phd`, reference `PhD thesis dataset`, its
  own date read. A stage where a bill ended is not completed and `fell_here`,
  dated by the decision if there was one. A stage completed on a date not known
  has no date and a note.
- **Checking what was typed:** `tools/check_stage_entry.sql` lists every row
  waiting for review beside its bill's dates, when it reached the server, and
  the checker's findings. Run it after each of the owner's sittings.
- **The eleven Stage 1 rejections** already have the Official Report's date.
  The owner's PhD row for each is a second row, and the checker flags any
  disagreement.
- **The comparison after the dates:** `copy_before_phd_dates`, inside the
  database, was taken before `db/035` and before any PhD date. Sessions 1 and 2
  put back with the dates should differ from it only by the dates added. It
  lacks the title column, which the comparison lists and does not count.
- **The two blank spreadsheets** are still in `sources/phd/`, unused, until the
  owner clears their deletion.
- **The fifteen bills with nothing recording where they ended:** Session 1 has
  3 withdrawn and 3 fell at dissolution; Session 2 has 5 withdrawn and 4 fell
  at dissolution.
- **Private Bills in Sessions 1 and 2:** twelve. Session 1 has 3 (1 passed, 2
  fell at dissolution); Session 2 has 9, all passed. The owner's understanding
  that every one has a Consideration Stage meeting is tested by the gaps list.
- **Session 2 is promoted** (`db/034`, then the runbook), before the loader is
  built: a recorded exception (`DECISIONS.md`, 2026-09-11). When the PhD dates
  are added, both sessions come off and go back on.

## Detail for the later work

1. **Postico's permissions: fixed on 2026-09-12 (`db/040`).** All 26 tabs now
   belong to `legdata`, the login Postico uses, and every pivot table opens.
   - The cause, which is still a live rule: migrations run as the administrator
     (`postgres`), and whatever they create belongs to it unless told
     otherwise. **Any migration that creates something must set its owner**, as
     `db/031`, `db/033` and `db/035` do. `db/040` had to repair five made
     before that rule was followed.
2. **Sessions 3–5 read in full on 2026-09-12.** They reconcile in every cell:
   62, 86, and 84 of Session 5's 87. What is left is recorded above the line.
   - **The two Acts whose factsheet prints an asp number with no year before it
     are settled (`db/062`, 2026-09-13).** "Higher Education Governance
     (Scotland) Act (asp 15)", Session 4, is 2016 asp 15; "Period Products (Free
     Provision) (Scotland) Act (asp 1)", Session 5, is 2021 asp 1, both from
     legislation.gov.uk. The checker now refuses an Act whose number does not
     begin with a four-digit year; it used to compare the year only where one
     was printed, so a number with none passed unlooked-at. Both lines are
     settled and on the clean sheet; Session 5's title was mended again by
     `db/078`, which made it carry its year.
   - Session 5's three bills awaiting Royal Assent were the missing 3, and are
     recorded as blocked (`DECISIONS.md`, 2026-09-14).
   - `Clackmann- anshire Council`, a Session 2 promoter broken by a line break,
     is still on that session's staging sheet. The repair is applied to the
     title we propose, not to the factsheet's own words, so it does not reach
     this cell. Nothing in this slice uses it and it is not on the clean sheet.
     Correct it when Session 2 next comes off for another reason, or when who
     introduced a bill becomes a variable.
3. ~~**Carry-over rows, before Session 6 is loaded.**~~ **Done 2026-09-14**
   (`db/081`, `db/082`). The session-window checks now ask about the session the
   *bill* belongs to, not the factsheet the row was read off; the two that could
   not sensibly be asked of a continuing row — passed after the session ended,
   concluded after the session ended — are asked only of a row that is a bill in
   its own right. Every one of the eleven later-session events has a home, nine
   of them already having had one (`DECISIONS.md`, 2026-09-13).
   - `bill_candidate` still has no column for a rename date or a block date.
     Sessions 4–7 state them, and nothing loaded so far needs one.
   - **The comparison tool's fault still exists** — an unpaired line is still
     stamped as compared — and still has no instance to see it on. Its
     hand-pairing gate was removed on 2026-09-13.
4. ~~**The double-count guard, before Session 6 is promoted.**~~ **Done
   2026-09-14** (`db/081`, `db/082`, `tools/promote_session.sql`). The guard was
   never the only net it needed to be: it matches on title and introduction date,
   and the UNCRC Bill is listed as an Act in Session 6. The rule that catches a
   carried-over row whatever its title does is that a row introduced before its
   own factsheet's session began must name the bill it continues. The old guard
   stays as a second net, now asked only of rows claiming to be bills of their
   own. **Note the docs were wrong by one:** they said the guard was blind to the
   European Charter and UNCRC Bills; the European Charter's Session 6 row still
   carries its *Bill* title, so the guard sees it.
5. **The prose parser for Sessions 6 and 7.** The grammar is in
   `FACTSHEET-SURVEY.md` §1, and was tested against both documents on
   2026-09-14: every sentence matches a known shape and nothing is left over,
   83 entries in Session 6 and 2 in Session 7. Empty sections are sentences
   ("No bills have fallen in Session 7."), not empty tables.
   - **§1's list of shapes is incomplete.** It does not contain `Motion agreed
     to treat as Emergency Bill on {date}.` (five times, Session 6) or the
     excluded section's own note. Read the documents, not the list.
   - **The reader must work on reflowed text, not on printed lines.** The rename
     sentence wraps across two lines in both places it appears, and a line-by-
     line matcher does not merely miss it — it swallows it into the next bill's
     title without complaining. The test that catches this is requiring every
     sentence in the document to match a shape.
   - **Sections carry their own asterisked notes, inline.** The section 35 block
     on the Gender Recognition Reform Bill is a paragraph sitting directly after
     the bill it concerns, in both documents. Session 6 puts the asterisk on the
     section heading and Session 7 puts it nowhere. Position attaches it, not
     the marker — unlike Sessions 4 and 5, which number their footnotes and put
     them at the foot of the page.
   - **"(SP 70)" is a Session 5 number.** Session 6 has its own SP Bill 70, the
     Ecocide Bill. Reading the European Charter's number as a Session 6 number
     collides with a different bill.
   - **Four titles are printed wrongly**, to be mended in the title we propose
     and never in the factsheet's own words: "Agriculture and Rural Communities
     (Scotland) **Bill** Act 2024 (asp 11)"; "Housing (Scotland) **Bill** Act
     2025 (asp 13)"; "Scottish Parliament (Recall of Members **Bill** (SP Bill
     55)", a bracket never closed, inside the rename sentence only; and the
     European Charter's "(SP 70)". `mend_title` handles none of them yet.
   - **The Acts section holds one entry that is not an Act title.** The European
     Charter's entry prints its Bill title and no asp number, so a reader that
     stamps `title_kind` = act on everything in that section is stamping it on a
     Bill title.
   - **Session 7 has a section Sessions 1 to 6 do not**, "Bills currently in
     progress", holding one bill with only an introduction date. `ref_outcome`
     already has `in_progress` for it.
6. **The seven `session` rows: done on 2026-09-12 (`db/048`).** All seven carry
   a first meeting; all but Session 7, which is running, carry a last day. The
   source is SPICe's dates factsheet, agreeing to the day with the Parliament's
   API and with each legislation factsheet's own page 1.
   - The session-window checks are awake from that point. Until 2026-09-14 they
     compared a line's dates against the session of the factsheet it was read
     from, which is wrong for a carry-over row; they now ask about the session
     the bill belongs to (item 3 above). Rehearsed on 2026-09-14 on a Session 6
     line built by hand: the rule fires when the row does not say which bill it
     is, and is silent when it does. Sessions 1 to 5 hold no row that fires it,
     before the change or after.
7. **`docs/VARIABLES.md`.** Everything factual is in the data dictionary; what
   remains is reasoning, and it is out of date:
   - §3.2 describes `procedure` as non-null and `date_outcome` as present, and
     defines `short_title` as "title as introduced" (wrong since `db/021`);
   - it does not mention `date_concluded`, `bill_type_stated`, `title_kind`,
     `title_as_introduced`, `date_assent_blocked`, `stage_1_rejection_route`
     or the stage-dates sheet;
   - §4.1 needs `analysis_group`, and §4.5 needs `ref_bill_type_stage`;
   - §5 lists D1, D4 and D5 as open and never mentions D6, and §6 is answered
     by M6;
   - §7 still describes provenance as append-only (`db/030`).

One staging table serves all seven sessions, not one per session. The natural
key carries `session_number`, and cross-session questions would otherwise need
seven-way unions. Load one session at a time, each gated on reconciliation.

## Reconciliation figures, per session

The gate compares our count against each factsheet's own summary table.

- **Session 1.** 51 Executive, 16 Member's, 3 Private, 3 Committee; 62 Acts, 3
  withdrawn, 8 fallen. The summary's column order is Executive, Member's,
  **Private, Committee**.
- **Session 2.** Page 8: Executive 53, Member's 18, Private 9, Committee 1;
  Acts 66 (53/3/9/1), withdrawn 5 (all Member's), fallen 10 (all Member's:
  4 at dissolution, 6 rejected at Stage 1). Same column order as Session 1.
- **Session 3.** Its summary has no Hybrid column and counts the Forth Crossing
  Bill under Executive. Its stated Executive 45 is our government 44 plus
  hybrid 1. Reconcile on `analysis_group`, not on `bill_type`.
- **Session 4.** Page 9: Government 67, Member's 13, Private 5, Committee 1;
  Acts 79 (67/6/5/1), withdrawn 1 (Member's), fallen 6 (all Member's: 5 rejected
  at Stage 1, 1 at dissolution). Its column heading is **Government**, not
  Executive: the Parliament's own styling changed inside this session. No Hybrid
  Bill, so `bill_type` and `analysis_group` give the same table.
- **Session 5.** Government 63, Member's 16, Private 5, Committee 3; Acts 75,
  awaiting Royal Assent 3, withdrawn 2, fallen 7 (all Member's: 3 rejected at
  Stage 1, 4 at dissolution). It is the first factsheet with a fourth table,
  "Bills awaiting Royal Assent", and the first where a reconciliation has to add
  two tables to reach our `passed`: 75 Acts plus those 3. No Hybrid Bill, so
  `bill_type` and `analysis_group` give the same table.
- **Session 6.** Read out of the factsheet on 2026-09-14, entry by entry, not
  taken from its summary. 83 entries are printed; 82 are counted in its own
  totals, the Legal Continuity Bill being in an excluded section that says so in
  its own words. Counted: awaiting Royal Assent 6 Government and 2 Member's;
  fallen 10, all Member's; withdrawn 1 Government and 3 Member's; Acts 55
  Government and 5 Member's. Column totals 62 Government and 20 Member's, 82.
  **Its printed summary has two cells wrong and its margins right**: awaiting
  Royal Assent reads 5 and 3, and Acts reads 56 and 4. The two errors cancel.
  Settled on 2026-09-14: reconcile every cell and write the disagreement down
  with the bills named. There are no Committee, Private or Hybrid Bills in
  Session 6 or 7, so `bill_type` and `analysis_group` give the same table.
- **Sessions 5 and 6** carry bills also counted in another session's totals.
  The factsheet totals are right for the factsheet and wrong for a count of
  distinct bills; see M6. This has not bitten yet: Session 5 reconciles against
  its own factsheet, and the double count appears only when Session 6 is loaded
  beside it.
- **Session 7.** Its grand total cell reads 0 where every margin reads 2. Trust
  the margins; the extracted table grid confirms that is the document.

A reconciliation proves no line was lost. It says nothing about what is inside
a line: Session 2 reconciled exactly while fifteen titles still carried their
SP Bill number.

**When charting:** a chart of outcome by bill type must say whether it grouped
on `bill_type` or `analysis_group`. They differ for the Forth Crossing Bill (44
or 45 government bills in Session 3). That is methodology note M4, which the
website has to surface.

## What has been verified, not merely assumed

**2026-09-10:**
- The extractor gives byte-identical output on the Mac and on the VPS.
- The Session 1 load matches a fresh extraction in all 73 rows and every raw
  column, and every date re-parses.
- Session 1 reconciles in all twelve cells of its summary, plus both margins.
- Promotion is reversible: promoted, taken off and promoted again gave the same
  73 bills with the same numbers.
- The backup restores: fetched back from the storage box, restored into a
  scratch database, checked and dropped.

**2026-09-11:**
- **The extractor changes left Session 1 untouched** in every column.
  Session 2 changed only where intended, and Sessions 3–5 have nothing left
  over in their titles.
- **The Session 2 load is faithful.** A CSV in the old format and a wrong
  session number were both refused, and no line numbers were used up by
  rehearsals.
- **The new title checks work.** An SP Bill number and an introduced title,
  planted in a thrown-away rehearsal, were both caught.
- **All eleven Official Report citations were read** against the Parliament's
  page: motion, vote figures and date.
- **The provenance and route change** was rehearsed twice, and the real run
  matched.
  - The old notes came back identical.
  - The rules refuse a route on a passed bill, a Stage 1 rejection without a
    route, and a 9.14.18 route on a Government Bill.
- **Postico's user can read** the new list and the checker.
- **The stage-dates move changed nothing** (`db/033`), rehearsed twice and then
  run for real, with the figures in the runbook:
  - all 139 dates arrived unchanged, and nothing else on either session's
    staging lines changed;
  - Session 1 off and on matched the copy cell by cell;
  - eight planted mistakes were caught, an undated completed stage without a
    note was refused, the Official Report won over an agreeing PhD date, and
    an unreviewed stage date stopped promotion;
  - Session 2 reloaded from a fresh extraction gave its 66 passing dates
    identically;
  - Postico's user can read the new sheet, the gaps list, the checker and the
    list of stage names.
- **Session 2 matches its factsheet on the clean sheet** (`db/034`), rehearsed
  and then run for real: 53/18/9/1 by type; 66 passed, 5 withdrawn, 4 fell at
  dissolution, 6 rejected at Stage 1; 72 stage records; 12 notes.

**2026-09-12:**
- **The reader changes left Sessions 1 and 2 untouched**, byte for byte, so
  nothing on the clean sheet is affected. Sessions 3 and 4 reconcile in every
  cell of their own summary tables; Session 5 in every cell but its three bills
  awaiting Royal Assent. All five give identical output on the Mac and the VPS.
- **The Session 4 Interests of Members Act** was never in any extraction before
  today: the factsheet draws that row with no cell borders and the table finder
  lost it between the two pieces.
- **The order of precedence works**, tested on planted rows and thrown away.
  A disagreement is flagged by the checker from both sides; two agreeing rows
  promote the factsheet's and leave the PhD row marked not carried; a source
  with no settled place in the order makes promotion refuse and write nothing.
- **The order had never been exercised by the real data.** No stage of any bill
  has two rows, so nothing had ever competed for a place on the clean sheet.
- **All 62 of Session 3's factsheet bills pair one to one** with the PhD
  dataset's 62 Session 3 bills, on name or on introduction date.

**2026-09-13 is missing from this list.** Sessions 3 and 4 were promoted and
Session 4's dates loaded that day, and what was checked is in the runbook's log
and in the migrations, but nothing was written here. A later session should
bring it across; nothing depends on it.

**2026-09-14:**
- **Session 5's admission refuses in eight ways**, each provoked one at a time
  in a transaction that was thrown away, each naming its reason: a stage date
  from an uncovered source; a line with no outcome; a line never compared
  against the other sources; a date before its bill was introduced; a date after
  its bill ended; a stage dated before the stage before it; a dateless row that
  is not a bill ending where it stopped; a seventh such row when there are six;
  a line already marked promoted; and a line left at `held`, which is not swept
  into `accepted` and makes the count refuse.
- **A guard behind another guard is not tested.** Three of those refusals were
  reached only after the error checker had already refused the same breakage a
  step earlier. Run on their own against the broken row, one of them did not
  fire: the out-of-bill check measured a last stage date against itself on a
  bill that had not ended. That is the hole `db/077` closes.
- **Promotion is reversible with the dates on it.** Session 5 promoted, taken
  off — 302 bills, 828 stage records, 86 notes, staging lines unstamped and
  still accepted — and promoted again: 389, 1071 and 105, matching a copy taken
  before it came off cell by cell, with no unexpected differences.
- **Session 5 reconciles with its factsheet on the clean sheet**: 63/16/5/3 by
  type; 78 passed, 2 withdrawn, 3 rejected at Stage 1, 4 fell at dissolution;
  243 stage records; 19 notes. It is the first reconciliation that has to add
  two of the factsheet's tables — 75 Acts and 3 awaiting Royal Assent — to reach
  our `passed`.
- **The three bills stopped from Royal Assent behave as intended in the
  charts**: a duration to the end of Stage 3 and none to Royal Assent, and they
  are exactly the difference between the stage-3 and stage-3-to-assent counts,
  60 against 62 for government and 7 against 8 for Member's.

## Tools

- **`tools/load_session.sql`** puts a session's extracted CSV on the staging
  sheets: its lines, and its passing dates on the stage-dates sheet.
- **`tools/promote_session.sql`** copies a session to the clean sheet, and
  **`tools/rollback_promotion.sql`** takes it off again.
  - All three take `-v session=` and `-v save=`, with no default for either.
  - `save=false` does the whole job and throws it away.
- **`tools/take_copy.sql`** and **`tools/compare_with_copy.sql`** copy the
  staging and clean sheets inside the database before a change, and compare
  cell by cell after. Both take `-v copy=`.
- **`tools/strip_for_rehearsal.py`** prepares migrations and scripts to be
  dress-rehearsed together inside one transaction that is thrown away.
- **`tools/check_stage_entry.sql`** reports on the stage dates the owner has
  typed in: every row waiting for review, beside its bill, and the checker's
  findings. Changes nothing.
- **`tools/extract_factsheet.py`** reads the ruled-table factsheets (Sessions
  1–5). Its pinned environment is in `tools/requirements.txt`.
- **`tools/make_data_dictionary.py`** regenerates `docs/DATA-DICTIONARY.md`, and
  refuses to run if anything lacks a description.
- **`docs/PROMOTION-RUNBOOK.md`** is the procedure for loading and promoting,
  with a record of each run.
- **`docs/FACTSHEET-SURVEY.md`** is the survey of all seven factsheets.

## Housekeeping, small and known

- **Fourteen safety copies are on the VPS**, one before each change to data or
  rules: six from 12 September (`-042_`, `-044_`, `-045_`, `-046_`, `-047_`,
  `-051_`), five from 13 September (`-057_`, `-059_`, `-060_`, `-065_`, `-068_`
  and `-s3-dates_`), and two from 14 September (`-s5-dates_` and
  `-s5-promotion_`). **The eleven from 12 and 13 September can now be deleted**:
  the nightly backup ran clean at 02:53 on 14 September, which is after all of
  them. The two from 14 September are not yet covered; the next run covers them.
  Proposed, not done — it is the owner's to say.
- **No copy of the sheets is held inside the database.**
  `copy_before_s5_promotion` and `copy_after_s5_promotion` were compared and
  dropped on 14 September. Take a fresh one with `tools/take_copy.sql` before
  the next change to data already held.
- **`db/066` has the same filename as `db/063`**, `session_4_review.sql`,
  although one is the review and the other the admission. Recorded here so the
  sanity check stops rediscovering it: it is a gap in the record, not in the
  data, and renaming an applied migration is not obviously worth doing. If it is
  ever tidied, it is `db/066` that should change.
- **`db/037` stays, doing nothing.** It sets day-first dates for Postico's
  login, and Postico formats dates itself, so nothing changed on screen. The
  owner judged it harmless. One line in the migration undoes it if wanted.
- **The two blank PhD spreadsheets are deleted.** Dates come from the owner's
  own dataset through `tools/phd_stage_dates.py`; the templates were never used.
- **The backup service runs with no `HOME` or `XDG_CACHE_HOME`**, so restic
  keeps no cache and re-reads everything in scope every night. That is harmless
  at this size, but will not stay so. One `Environment=` line in the unit file
  fixes it.
- **The Justice 2 Committee's own record** of its decision on the Civil Appeals
  (Scotland) Bill has not been found. Our view of the limb rests on the chamber
  debate. Nothing waits on it. The older committee pages redirect to the
  National Records of Scotland web archive, which blocks automated access.
- **Asking whether a rule exists means reading three catalogues.**
  `pg_constraint` does not list plain indexes; read `pg_indexes` and
  `pg_trigger` too. While a copy schema exists, filter every catalogue
  question to the `public` schema.
- **The extraction environment on the Mac** is a throwaway virtual environment
  built from `tools/requirements.txt` in the session scratchpad. The VPS copy at
  `/opt/legdata/venv` is the standing one.

## Connecting to the database

**Postico** (the entry client) is configured already. It opens its own tunnel
inside the application, on a port it picks per connection. There is no shared
listener, and nothing outside Postico can use it. (An old version of this file
described a shared tunnel on port 15432. It does not exist.)

**From a shell, or for any scripted work,** go through the connector script.
It holds the address, port, user and key, and keeps its own known-hosts file.
It is not in this repository.

    ~/.claude/legdata-vps 'whoami'
    ~/.claude/legdata-vps 'sudo -u postgres psql -d legdata -c "SELECT ..."'
    ~/.claude/legdata-vps --scp local/file /remote/path

The login account has passwordless sudo, and `sudo -u postgres psql` connects by peer
authentication, so no database password is stored on the Mac. Migrations are
applied this way.

**Dress-rehearsing a sequence of migrations and scripts:**
1. Strip each file's own `BEGIN;`, `COMMIT;` and closing `\if :save … \endif`
   block: `python3 tools/strip_for_rehearsal.py OUTDIR FILE…`.
2. Include them in order inside one `BEGIN … ROLLBACK`, with `\set session N`.
3. A script that makes temporary tables can run only once per rehearsal; test
   a second run in a separate rehearsal.

That is how `db/030`–`db/033` and the Session 1 re-promotions were rehearsed.
Send the files as one bundle (`COPYFILE_DISABLE=1 tar czf …`), which keeps to
one connection.

**Do not use `legislativedata-vps` or `legislativedata-data` in
`~/.ssh/config`.** They are leftovers from the old estate and point at machines that are not this
project's. Which machine is, is in the private notes outside this repository.

**The SSH rate limit bites you, not only attackers.** About a dozen connections
in quick succession gives `Connection refused` for roughly 15 seconds. Batch
work into few connections.
