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
| 6 | 83 bills, checks all done | **ready for you** | no | yes, all on |
| 7 | 2 bills, checks all done | not yet | no | Stage 3 only |

**389 bills are now on the clean sheet**, with 1071 stage records and 112
provenance notes. **Five of the seven sessions are finished and closed.**
Nothing of Sessions 1 to 5 is outstanding. **What is left of the first piece of
work is Sessions 6 and 7.** Both are on the staging sheet — 83 lines and 2 —
and **Session 6 is now ready for you**, its bills and all of its dates together.
Session 7 follows it.

## What has been done

- **10–14 September.** Database built, all seven fact sheets surveyed, Sessions
  1 to 5 read in, reviewed, admitted, promoted and **closed**, your dates
  loaded, how time is counted settled, and the jobs that had to come before
  Session 6 done: carried-over bills, blocked bills, the Robin Rigg Act, how a
  bill was handled, and the day a bill reached a stage.
- **14 September, later.** Both prose fact sheets read end to end, Sessions 6
  and 7 loaded onto the staging sheet — 83 lines and 2, numbers 390 to 474 — and
  the three steps between loading a session and your review written into the
  runbook, which had said nothing about them.

**15 September, earlier. Session 6 compared against your dataset, and the fact
sheet caught being out of date.** Five cells disagreed and all five were settled
at legislation.gov.uk or the Parliament's own page; your working file was
corrected for the two where it was the one wrong. Seven bills the fact sheet
leaves awaiting Royal Assent turned out to be Acts, four months before the sheet
was read, and the three blind spots that hid it are fixed (`db/090`, `db/091`,
M12). All ten of Session 6's fallen bills were read at the Official Report, where
the one word "fell" turned out to be three different things (`db/092`). The
error checker went from 22 problems to one.

**15 September, this session. Session 6's stage dates are on, and it is ready
for you.**

- **Where each of the fourteen bills that did not pass stopped is recorded**
  (`db/095`). Ten needed no new reading. **The four withdrawn bills were read at
  the Parliament's page for each**, and all four say the same thing: the bill was
  withdrawn at Stage 1, having not completed it, on the day the fact sheet
  already gives. Two of the three that ran out of time had completed Stage 1, and
  those two dates are recorded from the pages that state them — 5 and
  17 February 2026, which your dataset gives independently.
- **All 134 of your Stage 1 and Stage 2 dates are on** — 136 rows, over 68 bills.
  Session 6 now holds 223 stage rows in all, and every one of them is waiting for
  you. The gaps list is down to Session 7's two.
- **The loader refused twice and was right once.** It refused three bills as
  missing from your dataset: they are the three that appear in two fact sheets,
  and their Stage 1 and 2 are on the earlier line, not missing. The reader now
  knows that. It then refused the whole load because Session 7's line has a
  problem nothing can answer until Session 6 is promoted — a wait, not a fault.
  That check now asks whether the load itself broke anything, which is both
  narrower and stronger; it was proved to still refuse a bad load before it was
  used.
- Nothing touched the clean sheet: 389 bills, 1071 stage records, 112 provenance
  notes, compared cell by cell against a copy taken first.

## Now: Session 6 is yours

**83 lines and 223 stage rows, all waiting for you**, in one pass as you decided
on 15 September. Everything that comes between loading a session and your review
is done, and the error checker finds nothing at all on Session 6.

What you are looking at, and where it came from:

- **69 passed**, with the day each passed from the fact sheet and Stage 1 and
  Stage 2 from your dataset. **Three of the 69 appear in two fact sheets** — the
  two the Parliament took back and passed after reconsideration, and the one that
  passed, was stopped and was then withdrawn. Each of those three adds to the
  bill already on the clean sheet rather than making a second one, so its Stage 1
  and Stage 2 stay where they are, on its earlier line.
- **Fourteen did not pass**: five rejected at Stage 1 and two at Stage 3, each
  dated from the Official Report with the motion and the division quoted; three
  that ran out of time; and four withdrawn, each read at the Parliament's page
  for the bill.

Session 7's two lines follow, and its one outstanding problem answers itself once
Session 6 is on the clean sheet: the Gender Recognition Reform Bill's Session 7
line must point at the Session 6 line for the same bill, and cannot until there
is one.

**One question for you, and nothing waits on it.** Ecocide and Freedom of
Information Reform both completed Stage 1 and then fell at Stage 2. Ecocide's
committee met on it twice at Stage 2; Freedom of Information Reform's never met
on it at all, because its financial resolution came too late for Stage 2 to get
under way. Nothing in the data tells those two apart, and the column that could —
the day a bill reached a stage — is only ever filled where a source says so in
terms, which neither page does. Whether a committee meeting date should count as
saying so is yours to settle.

**Waiting for a session that built none of it:** the checks on `db/089` to
`db/095`, the comparison tool and the prose of M12 are written in
`CLOSURE-TESTS.md` and have not been run. Five tests, thirty-eight items,
thirty-three mechanical and five for you.

**Yours whenever you want it, and nothing waits on it:** your write-up on what
the charts present and the options they offer.

## After that, in order

1. Bring `docs/VARIABLES.md` up to date.
2. **Filling in how Sessions 1 to 5's bills were handled.** Expected, not begun.
   Their fact sheets do not mention procedure at all, so it needs a source we
   have not agreed — the Official Report, or the Parliament's page for each
   bill. Until then a count of emergency bills counts only the ones Session 6
   names, which is what M10 tells a reader.
3. **A layer of vote data**, its own piece of work. Scope not opened.
4. **Taking bill data from live sources as the next five years run.** Your
   words, 15 September: a fundamentally different thing from ingesting historic
   fact sheets, to be designed separately and not now. Nothing built this
   session presumes an answer to it; M12 is about sheets that are snapshots,
   which they will always be.
5. Then, and only then: the website, and reading from the Parliament's API.

## One small thing for you

The Robin Rigg Act's own note names both its missing stages and gives one date —
the Preliminary. It is incomplete rather than wrong, and mending it was not part
of what we agreed, so it is untouched. Say if you want the Consideration date in
it too, and it goes in next time Session 2 comes off.

## Waiting for your decision, and not blocking anything

- **Where the working dataset's backup lives.** `sources/phd/Billdates-September2026.xlsx`
  is deliberately outside version control. It exists on this machine and nowhere
  else. Nothing forces a decision, but each correction makes it worse.
- **How to record a published record being revised.** When the first case
  arrives.
- **Whether to rename the dates factsheet's file** to match the others'.
- **Whether a bill's note should be rewritten when the bill is reconsidered and
  passed.** Bills 303 and 304 carry a Session 5 note saying the bill could not
  be submitted for Royal Assent in its unamended form. Both are about to be
  recorded as reconsidered and passed, and the note is not carried or replaced
  when a later fact sheet adds to a bill — only seven cells are. The note stays
  true about Session 5, and a reader seeing it beside an Act of 2026 may not
  read it that way. Found 15 September.
- **Whether M5 should be reworded.** Two sentences have drifted. It says the
  mechanism that stopped a bill is recorded in the bill's note, where since
  `db/084` it is also a cell of its own; and it closes by saying a bill's
  recorded state comes from the latest fact sheet read in, which M12 now
  qualifies. Neither makes any data wrong. M5 is text a reader sees, so the full
  wording comes to you before anything is changed. Found 15 September.
- **Whether Session 5's four bills that ran out of time should carry the note
  Session 6's three now do**, recording that the loader's proposal was checked
  and what was read. Session 5's carry nothing; the check was recorded in its
  closure test instead. Nothing is wrong with the data either way. Found
  15 September.
- **Which source settles a disagreement about what kind of bill it was.** None
  has ever arisen.
- **Whether to take a copy of the bills before a change that touches them.**
  `tools/take_copy.sql` already exists. The cost is one more thing that can be
  left behind inside the database, which is why it is a question rather than a
  habit.

**Settled on 14 September, and no longer on this list:** whether to check the
stage dates against the Parliament's bill pages — the dataset is taken as it is
for now; whether the section 33 / 35 distinction becomes a variable — it has;
and whether to record how a bill was handled under the Parliament's rules — it
is recorded where a source says so, and empty everywhere else.

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

## Sanity check, 2026-09-15, closing

**Run at the end, on checking rather than on memory.** The clean sheet is
untouched by everything this session did: **389 bills, 1071 stage records, 112
provenance notes**, the same three figures the session opened with, and compared
cell by cell against a copy taken before the stage dates were loaded — 136 rows
added, no cell changed anywhere, nothing removed. The copy schema has been
dropped; only `public` is left on the server. The error checker finds **one**
problem, line 474's, which stood before this session and waits on Session 6 being
promoted. The gaps list holds **two** rows, both Session 7's: Session 6 is asked
nothing further. Session 6 holds **223 stage rows**, all waiting for review —
136 from the dataset, 71 from the legislation fact sheet, 9 from bill pages,
7 from the Official Report. The data dictionary regenerates identical to the
committed file. Nothing uncommitted, nothing unpushed.

**The opening check found nothing wrong.** The table's counts matched the
database, the last commit and the newest `DECISIONS.md` entries were carried into
`STATE.md`, the data dictionary regenerated identical, and the tree was clean.

**Two traps worth knowing, both met this session.** The connector rate-limits
about a dozen connections in quick succession and the stage-date reader makes two
per run, so a loop of test runs fails in a way that reads as a bug in whatever is
being tested. And piping the loader's output through `head` kills psql before it
commits: the run reports every check passing and saves nothing. Both are in the
runbook entry.

**Old working files are still in `/tmp` on the server** — `cols.sql`, `look.sql`,
`sanity.sql`, `reh.tgz`, `load.tgz`, `probe_full.sql` and the rest, from this
session and earlier ones. Nothing is inside the database and nothing depends on
them. The safety dump
`/var/tmp/legdata-before-s6-dates_2026-09-15.dump` is deliberate and kept.

## What the previous session did

Compared Session 6 against the owner's dataset, found seven bills the fact sheet
leaves awaiting Royal Assent that had become Acts four months earlier, fixed the
three blind spots that hid it, read all ten fallen bills at the Official Report,
and took the error checker from 22 problems to one.

## What this session did

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

**What this session did not do, and should not:** run its own checks. The nine
items on `db/095` and the two tools are written in `CLOSURE-TESTS.md` for a
session that built none of it.

## What the session before that did

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
