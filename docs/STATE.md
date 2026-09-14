# State

Updated: 2026-09-14

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
| 5 | 87 bills | yes | yes | yes; **next: closure test** |
| 6–7 | needs a prose reader | no | no | no |

**389 bills are now on the clean sheet**, with 1071 stage records and 105
provenance notes. Four of the seven sessions are finished and closed. Session 5
is on the clean sheet and **not closed**: its closure test had not been written,
and is written now for another session to run. The staging sheets hold nothing
still waiting: every line of every session loaded is accepted and promoted.

## What has been done

- **10–13 September.** Database built, all seven factsheets surveyed, Sessions 1
  to 4 read in, admitted and promoted, your dates loaded for Sessions 1 to 4,
  and how time is counted settled.
- **14 September, earlier.** Session 4 closed; what we record for a bill that
  passed and has no Royal Assent yet, settled and built; Session 5 read in and
  reviewed, its 243 stage dates loaded, its rejections, endings and disputed
  dates settled and marked; the dataset taken as it is for now, by your decision.
- **14 September, later.** Session 5 admitted and promoted on your sign-off:
  `db/077` took its 87 lines and 243 stage dates, promotion carried them, and the
  totals reconcile with the fact sheet's own summary in every cell. It went on
  once rather than coming off for your dates later, was taken off and put back to
  prove that path, and one check that had never bitten was found and mended.

**14 September, this session. Session 5 was marked closed without a closure
test. It is not closed, and the test is now written.**

- **The mark was wrong, and you caught it.** A session's data is closed when one
  session writes its test and a different one runs it. Session 5's test had never
  been written; the session that promoted it wrote "closed" into the table itself,
  which is what the procedure exists to stop. Sessions 1 and 2 on 12 September
  were the first time that happened, and this is the second.
- **Session 5's test is written and deliberately not run.** `docs/CLOSURE-TESTS.md`
  and `tools/closure_check_session_5.sql`: thirty mechanical items and nine
  sign-offs for you. Every expected answer comes from a fresh reading of the fact
  sheet, from your dataset read straight out of the workbook, or from the
  migrations — none from the database it tests. A later session runs it.
- **Writing it turned up three things, and none is fixed.** Your call on each.
  The Period Products Act's number was given its year and **its title was not**,
  where Session 4's equivalent Act had both put right. M7 still tells a reader
  that four sessions have been coded for why a bill fell, where five now are.
  And `HOW-THE-DATABASE-WORKS.md` contradicts itself on how many provenance notes
  there are, 86 in one place and 91 in another, where the answer is 105.

## Now: Session 5's closure test, then Sessions 6 and 7

1. **A session that did not write the test runs it**, reports every answer
   against its expected one, and brings you the nine sign-offs. Two items are
   predicted to fail, both named above.
2. **The three things above**, settled with you and built. Two are corrections to
   things a reader sees, so they are not housekeeping.
3. **Then Sessions 6 and 7**, with two jobs in front of them. **Bills carried
   over between sessions**, before Session 6 is loaded: four bills appear in two
   factsheets, the double-count guard is the same four, and the mended check in
   `db/077` would refuse a carried-over bill's later stages — one job, not three.
   And **a prose reader**, because those two factsheets are sentences, not tables.

**Yours whenever you want it, and nothing waits on it:** your write-up on what
the charts present and the options they offer.

## After that, in order

1. Bring `docs/VARIABLES.md` up to date.
2. **A layer of vote data**, its own piece of work. Scope not opened.
3. Then, and only then: the website, and reading from the Parliament's API.

## Waiting for your decision, and not blocking anything

- **Whether the section 33 / 35 distinction becomes a variable.** Four bills;
  revisit at a fifth.
- **Where the working dataset's backup lives.** `sources/phd/Billdates-September2026.xlsx`
  is deliberately outside version control. It exists on this machine and nowhere
  else. Nothing forces a decision, but each correction makes it worse.
- **How to record a published record being revised.** When the first case
  arrives.
- **Whether to rename the dates factsheet's file** to match the others'.
- **Which source settles a disagreement about what kind of bill it was.** None
  has ever arisen.

**Settled on 14 September, and not on this list:** whether to check the stage
dates against the Parliament's bill pages. **The dataset is taken as it is for
now** — the error rate is likely to be very low and tolerable until there is a
methodology for checking it, and nothing waits on it. It may be come back to.

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

## Sanity check, 2026-09-14, eighth session of the day

**At opening, every figure matched and one thing did not.** 389 bills — 73, 81,
62, 86, 87 — 1071 stage records, 105 provenance notes, 8 methodology notes with
M5 at 2331 characters, 389 staging lines and 1071 staging stage rows, every one
accepted and promoted with none left `new`. Error checker empty, gaps list empty,
data dictionary regenerating identical at 17 tables and 162 columns, nothing
uncommitted and nothing unpushed.

**What did not match: the table said Session 5 was closed, and it was not.**
No closure test had been written for it and none had been run. The table's
Session 5 row went straight from "yours to do" to "closed" in one commit, by the
session that admitted and promoted it — where Session 4 moved in three steps and
three sessions. `tools/` holds closure checks for Sessions 1–2, 3 and 4 and held
none for 5, and `CLOSURE-TESTS.md` had no Session 5 section. **The owner found
it, not the sanity check**, which had accepted the table and reported it back.
Nothing in `DECISIONS.md` retires the procedure.

**The carried-over item from the last session is dealt with.** `db/077` said at
its head that whether it is right is for a session that did not write it, and
that was recorded below the line and not in "Now", so it was owed and invisible.
It is now inside Session 5's closure test, item 23, which derives its guards from
the rules again rather than re-running the migration's own provocations.

**At closing.** Nothing in the data changed: this session wrote a test and no
migration. 389 bills, 1071 stage records, 105 provenance notes, error checker
empty, gaps list empty, data dictionary regenerating identical, no copy schema in
the database, nothing uncommitted and nothing unpushed.

## What this session did

**Session 5's closure test is written, and deliberately not run.**
`docs/CLOSURE-TESTS.md` gains a Session 5 section — thirty mechanical items, nine
sign-offs for the owner, and what the test does not check — and
`tools/closure_check_session_5.sql` is the mechanical half. The script was
checked for syntax against the database with its output discarded, so no expected
answer was set by looking at an answer.

**Where every expected answer comes from.** Sessions 3 and 4 had their tests
written while the session was still off the clean sheet, which made copying an
answer out of the data impossible. Session 5 was already on, so that protection
was gone and something had to take its place: a fresh extraction of the Session 5
fact sheet, the owner's workbook read directly with openpyxl, `db/071`–`db/077`
and the decisions they record, and Session 4's closed test for anything Session 5
does not move. Two figures could only have come from the database — six
methodology note lengths quoted from Session 4's test — and the test says so.

**The derivations that matter**, each checkable without the database:
- **243 stage records** = 78 bills passed × 3 stages + 3 rejected × 1 + 6 that
  ended where they stopped × 1.
- **19 provenance notes** = 3 outcomes and 3 rejection routes from the Official
  Report + 4 dissolution codings + 3 blocked statuses + 2 blocked dates + 4 cells
  checked at review.
- **153 dataset stage dates** = the workbook's 86 Session 5 rows hold 80 Stage 1
  and 77 Stage 2 dates; the three rejections' Stage 1 dates are not written
  because the Official Report holds them, the six endings have none, and the
  Civil Partnership Act's Stage 2 comes from the bill page. 77 + 76 = 153.
- **312 periods** for Session 5, which is 1377 across the clean sheet.

**Three things writing it turned up, all put to the owner and none fixed.**
1. The Period Products Act's `asp_number` was given its year at legislation.gov.uk
   and its `short_title` was not, where Session 4's Higher Education Governance
   Act had both corrected. Item 9 expects 0 Acts with a yearless title and is
   predicted to read 1. If it is corrected, items 1, 5, 9 and 26 move together.
2. M7 still says the coding of why a bill fell has been done for Sessions 1 to 4.
   Five are now coded. `db/070` had to make the same correction at Session 4's
   closure.
3. `HOW-THE-DATABASE-WORKS.md` §3 says the provenance tab holds 86 notes and §4
   of the same document says ninety-one. It is 105, of which 91 are about bills.
   Part B item 9 asks the owner to explain the database from that document, so it
   cannot be put until this is fixed.

**One prediction that is worth watching.** Item 24 predicts the three shortest
roads from introduction to the end of Stage 3 as 1, 9 and 22 days, from the fact
sheet's own dates. The session that promoted Session 5 reported 1, 27 and 28. If
the run gives 1, 27 and 28, two bills' Stage 3 dates on the clean sheet are not
the fact sheet's.

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
     was printed, so a number with none passed unlooked-at. Session 4's line is
     on the review list; Session 5's arrives with that session.
   - Session 5's three bills awaiting Royal Assent are the missing 3. Before
     Session 5.
   - `Clackmann- anshire Council`, a Session 2 promoter broken by a line break,
     is still on that session's staging sheet. The repair is applied to the
     title we propose, not to the factsheet's own words, so it does not reach
     this cell. Nothing in this slice uses it and it is not on the clean sheet.
     Correct it when Session 2 next comes off for another reason, or when who
     introduced a bill becomes a variable.
3. **Carry-over rows, before Session 6 is loaded** — not Session 5, which is
   what this said until 2026-09-13. Every row of Sessions 4 and 5 was checked:
   none has an introduction, passing or concluding date outside its own session,
   so nothing fires until Session 6's factsheet arrives. All four cross-factsheet
   bills have their second appearance in Session 6 or 7.
   - The session-window checks compare a line's dates against the session of
     the *factsheet* it was read from. The staging sheet has one session cell and
     it means which factsheet the row was read off, not which session the bill
     belongs to; three checks use the first where they need the second.
   - **What the later-session events need, settled 2026-09-13.** Nine of the
     eleven already have a place: Royal Assent, a bill's concluding date and the
     blocked date all sit on the bill and carry no session, and Reconsideration
     is already the fourth stage for every bill type. The tenth and eleventh are
     the same event twice — "Reconsideration stage agreed on" — kept as the
     factsheet's sentence on the stage's detail note. If that ever becomes a date
     cell it takes "Motion agreed to treat as Emergency Bill on …" with it.
   - `bill_candidate` has no column for a rename date or a block date.
     Sessions 4–7 state them.
   - **The comparison's hand-pairing list was gated to Sessions 1 and 2** by one
     line in `tools/compare_sources.py`, although the list is keyed by staging
     line and needs no gate. Removed 2026-09-13. Before that, no hand pairing
     could take effect for any later session, which is why Session 3 showed ten
     unpaired bills. Session 3 now pairs all 62 with no difference, Session 4 all
     86, so nothing is stamped as compared without being compared. **The tool
     fault behind that note still exists** — an unpaired line is still stamped —
     and now has no instance to see it on.
4. **The double-count guard, before Session 6 is promoted.** Promotion treats
   two staging lines as one bill only when title and introduction date both
   match. The European Charter and UNCRC Bills are "Bill" in Session 5 and
   "Act" in Session 6, so the guard cannot see them.
5. **The prose parser for Sessions 6 and 7.** The grammar is in
   `FACTSHEET-SURVEY.md` §1. Empty sections are sentences ("No bills have
   fallen in Session 7."), not empty tables.
6. **The seven `session` rows: done on 2026-09-12 (`db/048`).** All seven carry
   a first meeting; all but Session 7, which is running, carry a last day. The
   source is SPICe's dates factsheet, agreeing to the day with the Parliament's
   API and with each legislation factsheet's own page 1.
   - The session-window checks are awake from that point and fire on nothing in
     Sessions 1 and 2. Item 3 is therefore still outstanding, and still bites
     before Session 5: those checks compare a line's dates against the session
     of the factsheet it was read from, which is wrong for a carry-over row.
     **The failure is a false alarm, not a false pass** — the checks read only
     for dates outside the window, so a carry-over row is flagged and stops the
     session rather than passing silently. That has been read in the view, not
     rehearsed; rehearse it before Session 5 is loaded.
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
