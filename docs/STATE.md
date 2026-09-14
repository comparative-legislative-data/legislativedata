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
| 5 | read in full | no | no | no |
| 6–7 | needs a prose reader | no | no | no |

**302 bills are now on the clean sheet**, what happened to each of them, and
the time from introduction to every stage the Parliament decided, with every
cell traceable to what said so. No bill on it is missing a stage date. Four of
the seven sessions are finished and closed; the first piece of work is now
about two-thirds done by bills.

## What has been done

- **10–12 September.** Database built, all seven factsheets surveyed, Sessions 1
  and 2 on the clean sheet and closed, your own dates loaded for all 154 bills,
  and Session 3's 62 bills read in.
- **13 September.** Session 3 promoted and closed. How time is counted settled
  and built. Session 4's 86 bills read in, admitted, promoted with your 158
  Stage 1 and Stage 2 dates, and its closure test written by a session that did
  none of its work.
- **14 September, earlier.** Session 4's closure test run by a third session.
  Twenty-five of twenty-seven mechanical items matched; the two that did not were
  faults in the prediction, and answering one of them led to both divisions being
  published beside the Transplantation and Proportional Representation Bills.

**14 September, this session. Session 4 closed on all nine of your sign-offs.**
- **Six were confirmations**, each given against the rows read back out of the
  database: the reconciliation, the five bills read in the Official Report, the
  Transplantation note in full, the two endings, the four adjudicated cells and
  the eight names paired by hand.
- **Three changed something.** You settled that your working dataset is corrected
  whenever it is found wrong — the thesis file being separate and frozen — so the
  National Galleries date was corrected in it, from 26 to 25 June 2015, and all
  three closure tests now carry the new fingerprint. The test asked for a
  sign-off on the wrong methodology note and is corrected. And the documents
  themselves had two faults, both fixed before you read them: the explainer never
  said where the note a reader sees lives, and M7 still said the coding of why a
  bill fell had been done for three sessions (`db/070`).
- **Nothing else moved.** 302 bills, 828 stage records, 86 provenance notes, the
  error checker and gaps list both empty.

## Now: Session 5

The next session to load. One thing is due before it, and only one: **what we
record for a bill that has passed and has no Royal Assent yet.** Session 5's
fact sheet has a fourth table of them, three bills. That is a coding question, so
it is settled and built in full before Session 5 is admitted — what it records,
which bills it applies to, where it sits on the clean sheet, how it reaches the
staging sheet, how promotion carries it, what the error checker requires, and
what the methodology note tells a reader. Nothing else about Session 5 starts
until it is finished.

The carry-over question and the double-count guard are **not** due here. Both are
before Session 6, and nothing in Session 5 trips them — checked rather than
assumed when Session 4 closed.

## After that, in order

1. **Your write-up on what the charts present**, and the options they offer —
   the second of the two questions you separated, the first being what the
   database calculates, which is settled. Nothing is built on it yet, and nothing
   waits on it: it was added to this list on 13 September and Session 4 was
   loaded, promoted and closed past it. It is yours to do when you want it done.
2. Bills carried over between sessions: **before Session 6 is loaded**, not
   Session 5 — nothing in Sessions 4 or 5 trips the checks. Same four bills as
   the double-count guard below, so the two are one job.
3. The double-count guard: before Session 6 is promoted.
4. A prose reader for Sessions 6 and 7.
5. Bring `docs/VARIABLES.md` up to date.
6. **A layer of vote data**, decided on 14 September to be its own piece of work
   rather than something improvised. The division figures now published beside
   two bills are prose and cannot be counted; the figures recorded against all
   nineteen Stage 1 rejections are the obvious starting point, but the scope —
   which divisions, and how a member's vote is held — is not opened yet.
7. Then, and only then: the website, and reading from the Parliament's API.

## Waiting for your decision, and not blocking anything

- **Whether to keep the date a bill's Royal Assent was blocked.** Four bills;
  nothing forces it.
- **Whether the section 33 / 35 distinction becomes a variable.** Four bills;
  revisit at a fifth.
- **What we record for a bill that has passed and has no Royal Assent yet.**
  Session 5's factsheet has a fourth table of them, three bills. The reader
  knows the table and leaves it alone. Before Session 5.
- **Where the working dataset's backup lives.** `sources/phd/Billdates-September2026.xlsx`
  is deliberately outside version control, and it is now a file this project
  corrects rather than only reads. It exists on this machine and nowhere else.
  Nothing forces a decision, but the next correction makes it worse.
- **How to record a published record being revised.** When the first case
  arrives.
- **Whether to rename the dates factsheet's file** to match the others'
  convention. It arrived as "Dates of recess and dissolution and parliamentary
  years and recalls of Parliament.pdf", with a double space in it. Nothing
  depends on the name — the database cites the document and page, not the file.
- **Which source settles a disagreement about what kind of bill it was.** The
  comparison now catches one; none has ever arisen. The Parliament's own bill
  page is the obvious answer and is deliberately not assumed.

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
## Sanity check, 2026-09-14, second session of the day

**At opening, everything matched.** 302 bills on the clean sheet — 73, 81, 62 and
86 — 828 stage records, 86 provenance notes, 19 Stage 1 rejections, the error
checker empty, the gaps list empty, the data dictionary regenerating identical to
the committed file at 17 tables and 160 columns, `HOW-THE-DATABASE-WORKS.md`
already saying 302 and 86, nothing uncommitted and nothing unpushed. The first
attempt to regenerate the dictionary failed on `Connection refused`: the SSH rate
limit, not a fault, and it succeeded on the retry.

**One thing carried over and still not blocking anything.** `db/066` has the same
filename as `db/063`, `session_4_review.sql`, although one is the review and the
other the admission. Recorded for the fifth time; nothing depends on it.

**The reconciliation, asked for and checked in full.** All four sessions match
their fact sheets in every one of the forty-eight cells and every margin — pages
7, 8, 8 and 9. Session 3 matches on the grouped reading, its stated Executive 45
being our government 44 plus the one Hybrid Bill, which is M4.

**What this session did. Session 4's Part B was marked, and Session 4 is closed.**
All nine sign-offs were given on the rows read back out of the database. Six were
confirmations. Three changed something, and the three are why Part B exists.

**Item 7 settled a rule, not just a cell.** The working dataset is corrected
whenever it is found wrong; the thesis file is separate and frozen. So Session 3's
handling is the rule and Session 4 follows it.

- The National Galleries introduction date, Dates row 294, **26 June 2015
  corrected to 25 June 2015**, with the Corrections sheet carrying the change,
  its reason and what it was checked against.
- Fingerprint `a9596ecf…57ed8b94` → **`6614b3a1871367284c452ff8564b213532c1ec786f344acb7d350131c135420f`**.
- **Checked against a copy taken before the change**: exactly one cell differs on
  the data sheet, and seventeen on the Corrections sheet, being the new note, its
  header row and its one entry. Neither sheet changed shape.
- **`tools/phd_stage_dates.py` gives byte-identical output before and after**,
  checksum `47fe0846…be1b3384` across all four sessions, so none of the 522 stage
  dates the clean sheet holds from the dataset is affected. Its own report of the
  disagreement is gone.
- **`tools/compare_sources.py` now pairs all 73, 81, 62 and 86 lines with zero
  differences in every session.** The SQL it writes was read and not run; the
  database was already right.
- The new fingerprint is recorded beside the old in all three tests that carry it
  — Sessions 1 and 2's item 19, Session 3's item 22, Session 4's item 24 — and
  nothing else is reopened.

**Item 8 was asking about the wrong note.** It sought a sign-off on M4, the
Hybrid Bill note, where the styling change is M1. The test is corrected and the
correction marked in it rather than made silently. The split itself stands: 15
bills styled Executive at introduction, 16 June 2011 to 27 June 2012, and 52
styled Government, 3 October 2012 to 28 January 2016 — a clean break with no
overlap, against 67 counted as government throughout.

**Item 9 found two faults in the documents, both fixed before they were read.**

- `HOW-THE-DATABASE-WORKS.md` never said where the note a reader sees lives on
  the clean sheet — the cell `db/069` had just published two divisions into. A
  paragraph was added to "The clean sheet", in the owner's own vocabulary.
- **M7 still said the coding of why a bill fell had been done for Sessions 1, 2
  and 3.** Session 4 made it four, on 13 September. `db/070` corrects two
  sentences and nothing else.

**Tested rather than assumed.**

- **`db/070` was rehearsed in a transaction that was thrown away, and the
  rehearsal refused it.** Its own check asserted M7 would change by 8 characters;
  the change is 2 — "1, 2 and 3." becomes "1, 2, 3 and 4." at +3, and "three"
  becomes "four" at −1. The arithmetic was wrong, not the database. Corrected,
  rehearsed again, then run for real. The reason is written into the file.
- **`db/070` refuses to run at all** if any bill still carries the general fallen
  code, if a fifth session has appeared on the clean sheet, if Session 4 is not
  at 86 bills, or if more than one bill fell for want of a financial resolution —
  because "four" and "one bill" would then be the wrong numbers too.
- After it: exactly one note changed, by exactly two characters; M7 kept
  everything it had including what `db/069` added; eight notes, 302 bills, error
  checker and gaps list both empty.
- The workbook edit was made against a copy taken first, and the copy compared
  cell by cell on both sheets, not sampled.

**After the session.** 302 bills, 828 stage records, 86 provenance notes, error
checker empty, gaps list empty, M7 5001 → 5003 characters, the other seven notes
unmoved, the data dictionary regenerating identical to the committed file.

**Corrected after the close, on the owner's challenge.** "Now" was rewritten to
the charts write-up because it stood at number 1 of "After that, in order". That
was an inference and not a decision: the item was added on 13 September and
Session 4 was read in, promoted and closed past it, so the list was never being
worked in order. Session 5 is the next piece of work, and the only thing due
before it is the three bills passed with no Royal Assent yet. The write-up is
back on the list, with a line saying nothing waits on it.

**Found and not acted on.** `sources/phd/Billdates-September2026.xlsx` is not in
version control — `sources/phd/*.xlsx` is deliberately ignored — so the working
dataset exists only on this machine, and now that it is a file this project
corrects, it has no copy anywhere. The pre-change copy this session took was in a
scratch directory and will not survive. On the waiting list above.

## The owner's standing positions, so they are not re-argued

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
