# State

Updated: 2026-09-13

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
| 3 | 62 bills | yes | yes | yes; **test passed, your sign-off left** |
| 4–5 | read in full | no | no | no |
| 6–7 | needs a prose reader | no | no | no |

Sessions 1 and 2 are finished: what happened to each bill, and the time from
introduction to passing, with every cell traceable to what said so. Session 3
now holds the same, its closure test has been run and passes, and what is left
is your sign-off on the nine things only you can answer.

## What has been done

- **10 September.** Database built, all seven factsheets surveyed, Session 1 on
  the clean sheet.
- **11 September.** Session 2 read in and on the clean sheet; stage dates
  settled and your own dates loaded for all 154 bills.
- **12 September.** The reader fixed; the thirteen disagreeing dates settled;
  Sessions 1 and 2 closed on the eighth sign-off after you found a real fault in
  what M8 said; Session 3's 62 bills read in and reconciled.
- **13 September, earlier.** Session 3 reviewed, the nine bills that did not
  pass coded from the Official Report and the Parliament's bill pages, and the
  session put on the clean sheet with your 108 Stage 1 and Stage 2 dates. How
  time is counted was settled and built: a period is counted to any stage the
  Parliament reached the end of and decided, whatever it decided. That moved
  Session 2's Members' Bill figure for introduction to the Stage 1 debate from
  342 days over 3 bills to 273 over 9. No recorded date moved.

**13 September, this session. Both tests run by a session that did none of the
work they test, and everything a machine can check passes.**
- **Session 3's closure test: all twenty-four mechanical checks pass.** Session
  3 reconciles against page 8 of its own fact sheet in every cell and both
  margins. All 53 Acts have their number, their assent and a year that agrees.
  Every bill that did not pass says where it ended, and the four the Official
  Report dates carry the Official Report's date and not your dataset's, which is
  what the Autism correction was for. Taking Session 3 off and putting it back
  inside a transaction that was thrown away gave the same 62 bills, 170 stage
  records and 15 provenance notes, with not one unexpected difference.
- **Three of the test's own predictions were wrong, and the data was right.**
  The length of M2, which last session deliberately rewrote and nobody carried
  forward; four Stage 1 dates predicted where there were always going to be
  five, the fifth being the Budget Bill's, from your dataset; and eight cells
  the reader must disagree with where there are ten, the two extra being the
  bills that fell at dissolution, which the reader stopped deciding in `db/051`
  precisely so the coding could be reproduced. Each was settled against
  something other than the database being tested, then corrected in the test
  with the reason beside it. Nothing in the database changed.
- **The coverage check passes.** Of 764 points where a period could be counted,
  743 are counted, 19 have no day because the stage never reached its terminal
  point, and 2 did not happen. No third category.
- **A rule recorded** for what a session marking a test may do about a
  prediction it can show is wrong, and what it may not. `DECISIONS.md`.

## Now: your nine sign-offs, and then Session 4

Everything a machine can check about Session 3 is checked and passes. What is
left is Part B of its closure test, which is yours and nobody else's:

1. What happened to each bill — the counts for Session 3.
2. The five bills read in the Official Report, quotation and ending.
3. The four endings you established from the Parliament's bill pages.
4. The Forth Crossing Bill as a Hybrid, and what M4 tells a reader.
5. The three adjudicated dates and the asp number.
6. The ten corrected names, against the workbook's Corrections sheet.
7. The Autism Bill's Stage 1 date.
8. M7 read in full.
9. That you can explain how this database works from the documents alone.

They are set out in `docs/CLOSURE-TESTS.md`, Part B. A sign-off is recorded
there on the day it is given. **Session 3 is not closed until they are given.**

**Then Session 4.**

**Left unbuilt on purpose, and not blocking anything.** When the comparison
could not pair ten bills it still recorded all 62 as compared. Nothing was
written wrongly — the tool that loads stage dates refuses outright on an
unpaired bill — but a bill that was never compared should not look compared.
Settle it when a bill turns up that your dataset genuinely does not cover, so
that both tools get the same answer at once.

## After that, in order

1. **Your write-up on what the charts present**, and the options they offer —
   the second of the two questions you separated, the first being what the
   database calculates, which is settled. Nothing is built on it yet.
2. Bills carried over between sessions: before Session 5 is loaded.
3. The double-count guard: before Session 6 is promoted.
4. A prose reader for Sessions 6 and 7.
5. Each session's start and end dates.
6. Bring `docs/VARIABLES.md` up to date.
7. Then, and only then: the website, and reading from the Parliament's API.

## Waiting for your decision, and not blocking anything

- **Whether to keep the date a bill's Royal Assent was blocked.** Four bills;
  nothing forces it.
- **Whether the section 33 / 35 distinction becomes a variable.** Four bills;
  revisit at a fifth.
- **Whether a title's kind may be inferred from the Royal Assent date**, and
  with it the year for the two Acts whose factsheet prints an asp number with
  no year before it. Before Session 4.
- **What we record for a bill that has passed and has no Royal Assent yet.**
  Session 5's factsheet has a fourth table of them, three bills. The reader
  knows the table and leaves it alone. Before Session 5.
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

## Sanity check, 2026-09-13 (fourth session of the day)

**At opening, everything matched and nothing needed a clean.** 216 bills, 583
stage records, 71 provenance notes, 8 ways a bill can end, 8 notes for readers,
60 migrations numbered without a gap, nothing uncommitted and nothing unpushed,
the data dictionary regenerating identical to the committed file. The error
checker and the gaps list were both empty. The figures are those the previous
session closed on.

**This session ran the two tests the previous one wrote and deliberately left
unrun.** It promoted nothing, loaded nothing and changed no data. The only
changes it made are to `docs/`.

**At close.**

- **All twenty-four mechanical items of Session 3's closure test pass.** Three
  expected answers were wrong and are corrected in the test with the reason
  beside each: item 15 (M2 3661 → 4347, overtaken by `db/060`), item 19 (four
  rows → five, the fifth being the Budget Bill's Stage 1 from the dataset, which
  item 11 already predicted) and item 21 (eight worked-out cells → ten, the two
  extra being the dissolution bills, which `db/051` stopped the reader
  deciding). Part B, the nine sign-offs, is not marked and is the owner's.
- **`tools/duration_coverage.sql` passes.** 764 points: 743 counted, 19 with no
  day recorded, 2 that did not happen. No third category, and the script's own
  guard confirmed it.
- **216 bills, 583 stage records, 71 provenance notes**, the error checker
  empty, the gaps list empty, 60 migrations without a gap, the data dictionary
  regenerating identical to the committed file, nothing uncommitted.
- **No working copy left in the database.** `copy_item23` was taken for item 23,
  compared and dropped, and no schema named `copy%` remains.

**How each of the three was settled, against something other than the database
being tested.** This matters: correcting a prediction to match a result nobody
can account for is how a test stops being a test.

- M2: `db/060` says in terms that it amended M2, and names the sentence it was
  anchored on. The other seven lengths have not moved.
- Item 19: item 11 of the same test derives the 108 dates as 54 bills × two
  stages, the 54 being the 53 that passed plus the Budget Bill. The fifth row is
  that bill, and the four the Official Report dates all say `official_report`.
- Item 21: the dissolution rule was applied afresh to a fresh reading of the
  fact sheet. Of its seven fallen bills exactly two concluded on Session 3's
  last day of 22 March 2011 — Commissioner for Victims and Witnesses, and Long
  Leases — which are exactly the two coded that way, none over and none missing.

**Tested rather than assumed.**

- The fact-sheet reader was given nothing but the PDF and the session number.
  All 62 lines pair and no raw column differs by a character.
- Item 23 was rehearsed inside a transaction that was thrown away: 62 bills, 170
  stage records and 15 provenance notes removed, leaving Sessions 1 and 2's own
  154, 413 and 56 exactly; the same three counts written back; and the cell-by-
  cell comparison reporting no unexpected difference on any of the five sheets.
- The dataset's fingerprint was recomputed from the file, not read from a note:
  `a9596ecf…57ed8b94`, matching `DECISIONS.md`.

**Not done, and not this session's to do.** The nine sign-offs in Part B. Until
they are given, Session 3 is not closed.

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
   - The two Acts whose factsheet prints an asp number with no year before it
     ("Higher Education Governance (Scotland) Act (asp 15)", Session 4, and
     "Period Products (Free Provision) (Scotland) Act (asp 1)", Session 5) now
     say so in their parser note. The checker's year check still does not
     notice, and settling the year settles that too. Before Session 4.
   - Session 5's three bills awaiting Royal Assent are the missing 3. Before
     Session 5.
   - `Clackmann- anshire Council`, a Session 2 promoter broken by a line break,
     is still on that session's staging sheet. The repair is applied to the
     title we propose, not to the factsheet's own words, so it does not reach
     this cell. Nothing in this slice uses it and it is not on the clean sheet.
     Correct it when Session 2 next comes off for another reason, or when who
     introduced a bill becomes a variable.
3. **Carry-over rows, before Session 5 is loaded.**
   - The session-window checks compare a line's dates against the session of
     the *factsheet* it was read from, which is wrong for a carry-over row.
   - `bill_candidate` has no column for a rename date or a block date.
     Sessions 4–7 state them.
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
