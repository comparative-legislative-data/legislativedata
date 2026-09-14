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
| 5 | 87 bills | checks clean; **yours to do** | no | loaded; yours to read |
| 6–7 | needs a prose reader | no | no | no |

**302 bills are still on the clean sheet** and nothing on it moved today.
Session 5's 87 lines and all 243 of its stage dates are on the staging sheet,
with nothing the error checker objects to and nothing left on the gaps list.
Four of the seven sessions are finished and closed.

## What has been done

- **10–13 September.** Database built, all seven factsheets surveyed, Sessions 1
  to 3 promoted and closed, your dates loaded, how time is counted settled, and
  Session 4 read in, admitted and promoted.
- **14 September, earlier.** Session 4 closed on all nine of your sign-offs;
  what we record for a bill that has passed and has no Royal Assent yet, settled
  and built; Session 5 read in and reviewed; then all 162 rows the gaps list was
  waiting for filled — 153 from your dataset, 9 from the Parliament's bill pages
  — with six bills that did not pass given the stage they stopped at, the
  Domestic Abuse Act's two dates taken from its own bill page, and a month typed
  wrong in your dataset caught by the rehearsal and corrected.

**14 September, this session. Last session's three pieces of work marked, and
nothing changed.**

- **All three pass.** The six endings, the Domestic Abuse Act's two dates and
  the Civil Partnership Act's Stage 2 were checked against the Parliament's
  pages directly rather than against what the migrations said about them. Every
  quotation is word for word, and every surrounding date the pages give agrees
  with what was already on the line.
- **Session 5's 153 dates were rebuilt from your corrected dataset** and compared
  against the 153 now in the database: same rows, no cell different anywhere.
  Your working file's fingerprint before the correction matches what was
  recorded, and row 360 now reads 11 June.
- **The reader gives byte-identical output for Sessions 1 to 4** before and
  after the change — 134, 141, 109 and 159 rows — and all three ways its new
  check can refuse fire, naming the line each time.
- **One line in the record, not a job.** The reader's new check looks for
  Stages 1 and 2 on a bill absent from your dataset but not Stage 3. It does not
  bite: a missing Stage 3 shows on the gaps list anyway.

## Now: your review of Session 5, then promotion

Nothing is owed before it and nothing is half-built. The 87 lines and their 243
stage rows are waiting in Postico as `new`, with every machine check clean: the
error checker empty, the gaps list empty, all 87 lines compared against your
dataset, and the work that put the dates there marked by a session that did not
do it.

One thing, and it is yours: **read them, and mark each accepted.** Promotion
refuses to run while anything is still `new`. The steps are in
`PROMOTION-RUNBOOK.md`.

**Six to look at first**, because they are where judgement was used rather than
a document copied:

- the three rejections at Stage 1 — lines 306, 309 and 310;
- the Solicitors Bill's introduction date, line 380, which moves a year against
  what the fact sheet printed;
- the Civil Partnership Act's Stage 2, line 329, where your dataset and the
  Parliament's page disagreed by a month;
- the Domestic Abuse Act's Stage 1 and Stage 2, line 339, the only bill whose
  dates come from a bill page rather than your dataset.

Then promotion, which is rehearsed and undone before it is trusted, as always.

## After that, in order

1. **Your write-up on what the charts present**, and the options they offer. It
   is yours to do when you want it done; nothing waits on it.
2. Bills carried over between sessions: **before Session 6 is loaded**. Same four
   bills as the double-count guard, so the two are one job.
3. The double-count guard: before Session 6 is promoted.
4. A prose reader for Sessions 6 and 7.
5. Bring `docs/VARIABLES.md` up to date.
6. **A layer of vote data**, its own piece of work. Scope not opened.
7. Then, and only then: the website, and reading from the Parliament's API.

## Waiting for your decision, and not blocking anything

- **Whether the section 33 / 35 distinction becomes a variable.** Four bills;
  revisit at a fifth.
- **Where the working dataset's backup lives.** `sources/phd/Billdates-September2026.xlsx`
  is deliberately outside version control and was corrected again today. It
  exists on this machine and nowhere else. Nothing forces a decision, but each
  correction makes it worse.
- **How to record a published record being revised.** When the first case
  arrives.
- **Whether to rename the dates factsheet's file** to match the others'.
- **Which source settles a disagreement about what kind of bill it was.** None
  has ever arisen.
**Answered by use on 14 September, and off this list:** whether to keep the date
a bill's Royal Assent was blocked, which is kept because M5 depends on it; and
the Fair Rents page contradicting itself on the day the bill fell, which is moot
now that the bill carries no date for where it ended.

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

## Sanity check, 2026-09-14, sixth session of the day

**At opening, everything matched.** 302 bills on the clean sheet — 73, 81, 62 and
86 — 828 stage records, 86 provenance notes, 8 methodology notes with M5 at 2331
characters, 389 staging lines and 1071 staging stage rows of which Session 5 has
243, all still `new`. Error checker empty, gaps list empty, data dictionary
regenerating identical to the committed file at 17 tables and 162 columns,
nothing uncommitted and nothing unpushed.

**Two things carried over, neither blocking anything.** `db/066` has the same
filename as `db/063`, `session_4_review.sql`, although one is the review and the
other the admission; recorded for the ninth time. And the runbook's log of what
happened records Sessions 1, 2, 3 and 5's stage dates but not Session 4's, which
were loaded on 13 September. Both are gaps in the record, not in the data.

## What this session did

**Marked the three pieces of work `db/075`, `db/076` and the change to
`tools/phd_stage_dates.py`, which the session before this one built and left
unmarked. Nothing was changed by the marking.** All three pass.

**The sources were read, not the migrations' account of them.** All eight bill
pages `db/075` and `db/076` cite were fetched and read here. Every quotation in
the two migrations appears on its page word for word, including the two
withdrawn bills, 313 and 314, whose pages read "fell on 19 September 2019" and
"fell on 22 December 2020" with "Stage 2 has not been reached yet" below —
the migration's claim that all six pages say the same thing in the same words
holds. The Fair Rents page does contradict itself, 4 May in its status line and
5 May below, exactly as recorded; no date sits on a row of that kind, so nothing
turns on it. For the two dated claims, every surrounding date the page gives
agrees with what the fact sheet had already put on the line: the Domestic Abuse
Act at introduction 2 October 2020, Stage 3 17 March 2021, Royal Assent 5 May
2021; the Civil Partnership Act at introduction 30 September 2019, Stage 1
19 May 2020, Stage 3 23 June 2020, Royal Assent 28 July 2020.

**The rows are in the database as described.** The six carry stage_1, not
completed, fell here, no date, cited to their own bill pages at 2026-09-14. Line
339 carries Stage 1 at 28 January 2021 and Stage 2 at 23 February 2021 from its
bill page, with Stage 3 still from the fact sheet. Line 329 carries Stage 2 at
11 June 2020 from its bill page, with Stage 1 from the dataset and Stage 3 from
the fact sheet.

**Session 5's 153 dates rebuilt and compared cell by cell.** The reader was run
again against the corrected working file and its 153 rows compared against the
153 the database holds from the dataset for Session 5: the same 153 line-and-
stage pairs, and no difference in any date, completed flag, fell-here flag,
source or citation. The file's fingerprint is 072184df…, and the Corrections
sheet records 4110d58f… as the fingerprint before the change, which is what was
recorded at the time.

**The reader's change does not disturb what was already loaded.** The version
before the change and the version after were both run against Sessions 1, 2, 3
and 4 and their output compared byte for byte: identical, at 134, 141, 109 and
159 rows. Its new refusals were each provoked rather than assumed, by driving
`match()` with the real staging lines and dataset and then breaking one thing at
a time: line 339 not named as absent is refused as having no row in the dataset;
named as absent with nothing held for it from another source is refused by name;
named as absent with only Stage 1 held is refused by name, and the message says
which stage is short.

**One weakness found, and it does not bite.** The new check looks for Stages 1
and 2 on a line named as absent from the dataset, but not Stage 3, so a future
absent bill whose fact sheet gave no Stage 3 date could be excused into a gap
there. It cannot pass unnoticed: `v_stage_date_gaps` expects all three stages of
a bill that passed, so the gap would show on the gaps list. Recorded rather than
built, there being one line named and its Stage 3 present.

**Not marked by this session.** Nothing was built here, so nothing is waiting to
be marked.

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
- **Sessions 5 and 6** carry bills also counted in another session's totals.
  The factsheet totals are right for the factsheet and wrong for a count of
  distinct bills; see M6.
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

- **Six safety copies are on the VPS**: `/var/tmp/legdata-before-042_2026-09-12.dump`,
  and `-044_`, `-045_`, `-046_`, `-047_`, `-051_`, one before each change to data
  or rules. Delete them once a nightly backup taken after 2026-09-12 has been
  confirmed. The last backup ran clean at 02:59 on 12 September, which is
  *before* all of them; the timer next fires 02:41 UTC on 13 September, and that
  is the first run that covers them. The nine from 10 and 11 September were
  deleted on 2026-09-12 the same way. `copy_before_042` and `copy_before_051`
  inside the database were compared and dropped.
- **No copy of the sheets is held inside the database.** `copy_before_051` was
  dropped once its comparison was done. Take a fresh one with
  `tools/take_copy.sql` before the next change to data already held.
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
