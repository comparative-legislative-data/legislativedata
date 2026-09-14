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
| 5 | 87 bills | yes | yes | yes; **closed** |
| 6–7 | needs a prose reader | no | no | no |

**389 bills are now on the clean sheet**, with 1071 stage records and 112
provenance notes. **Five of the seven sessions are finished and closed.**
Nothing of Sessions 1 to 5 is outstanding, and every line of every session
loaded is accepted and promoted. **What is left of the first piece of work is
Sessions 6 and 7**, and the one job that had to come before them is now done.

## What has been done

- **10–13 September.** Database built, all seven factsheets surveyed, Sessions 1
  to 4 read in, admitted and promoted, your dates loaded, and how time is
  counted settled.
- **14 September, through the day.** Session 4 closed. Session 5 read in,
  reviewed, admitted and promoted on your sign-off, its totals reconciling with
  the factsheet in every cell; then its closure test written, run, and the two
  things it predicted would fail, mended. Eight provenance notes that ended
  mid-sentence found and mended. **Session 5 closed** on all thirty-two
  mechanical items and all nine of your sign-offs.

**14 September, this session. Carried-over bills, and what a blocked bill
records.**

- **The job that had to come before Session 6 is built, rehearsed and applied.**
  A factsheet row that is a further appearance of a bill already on the clean
  sheet now lands on that bill instead of making a second one. Four bills do
  that; three of them are Session 5 bills, and their second appearance is in
  Session 6.
- **A bill stopped before Royal Assent now records how and what followed.** You
  were right that "passed" alone loses it. Two new cells say which mechanism
  stopped it — a section 33 reference or a section 35 order, which is now a
  variable — and what came next: still blocked, withdrawn, reconsidered and
  passed, or reconsidered and fell. Once the European Charter Bill becomes an
  Act, those cells are the only thing that will still say it was ever stopped.
- **The Robin Rigg Act now says whose scrutiny it carried**, which you spotted.
  It is not a counting problem — two bills were introduced and two are counted —
  it is a duration one: its journey reads 42 days against a next-shortest
  Private Bill of 132, because eleven of its twelve months happened to the
  Session 1 bill. A chart can now be built either way and must say which. It is
  the only such bill; every recurring title was checked.
- **Two notes a reader sees.** M6 now gives the test anyone can apply — did the
  first bill end? — both answers, and our per-session figures beside the
  factsheets' own. It is the note every chart of bill volumes carries. M9 is
  new, and covers reintroduction. And one of the Robin Rigg Act's stage notes
  gave the wrong stage's date; mended.
- **Nothing else moved.** 389 bills and 1071 stage records, before and after.
  Provenance is 106 to 112, being the two new cells on each of three bills. The
  error checker and the gaps list are empty.

## Now: first, the test this session may not mark

The rules built this session were written by the session that built them, so it
may not be the one to mark them. **Eighteen items are written up in
`docs/CLOSURE-TESTS.md` and are the first task of the next session.** Nothing
of Session 6 is read until they are answered.

## Then: Sessions 6 and 7

**A prose reader**, because Sessions 6 and 7's factsheets are sentences, not
tables. That is now the only thing between here and Session 6.

Two things it will have to do that nothing else does: recognise "Withdrawn on
…", which appears only in Session 6's excluded section, and cope with the
European Charter Bill's number being printed "(SP 70)" rather than "(SP Bill
70)". Its Act title and number are printed nowhere in the factsheet and come
from legislation.gov.uk, as the Period Products and Higher Education Acts' did.

**Yours whenever you want it, and nothing waits on it:** your write-up on what
the charts present and the options they offer.

## After that, in order

1. Bring `docs/VARIABLES.md` up to date.
2. **A layer of vote data**, its own piece of work. Scope not opened.
3. Then, and only then: the website, and reading from the Parliament's API.

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
- **Which source settles a disagreement about what kind of bill it was.** None
  has ever arisen.

**Settled on 14 September, and no longer on this list:** whether to check the
stage dates against the Parliament's bill pages — the dataset is taken as it is
for now, and may be come back to; and whether the section 33 / 35 distinction
becomes a variable — it has.

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

## Sanity check, 2026-09-14, twelfth session of the day

**Everything matched and nothing contradicted anything.** 389 bills — 73, 81, 62,
86, 87 — 1071 stage records, 106 provenance notes; 389 staging lines, every one
accepted and promoted; error checker empty, gaps list empty, data dictionary
regenerating identical at 17 tables and 162 columns, nothing uncommitted and
nothing unpushed. `STATE.md`'s figures matched the database in every cell.

**Done in one connection where possible.** The dictionary regeneration hit the
server's rate limit after several short queries and went through 30 seconds
later; the batching rule below still holds.

## What the previous session did

Ran item 32 — the check on `db/079`'s rule, which the session that added it was
not allowed to make — writing nothing to the database in order to be able to.
All six parts answered as expected, and **Session 5 closed** on thirty-two of
thirty-two mechanical items and nine of nine sign-offs. Full detail in
`docs/CLOSURE-TESTS.md` and `DECISIONS.md`, 2026-09-14.

## What this session did

**Built the carried-over bills job**, which `STATE.md` put before Session 6 is
loaded, together with two things the owner raised while it was being agreed.
`DECISIONS.md`, 2026-09-14, carries the reasoning; this is what was run.

- `db/080` the two blocked-bill cells and their dropdown lists; `db/081` the
  further-appearance cell on the staging sheet and the carried-scrutiny cell on
  both; `db/082` the error checker rebuilt; `db/083` M6 rewritten and M9 added;
  `db/084` the values for four bills; `db/085` the four constraints, added last
  once the data satisfied them.
- `tools/promote_session.sql` split into two paths, and
  `tools/rollback_promotion.sql` taught to take a continued bill off with the
  session that added to it.
- Sessions 5 and 2 taken off the clean sheet and put back, so the new values
  arrived by the ordinary route with their provenance.

**Rehearsed before any of it was applied**, inside a transaction that was thrown
away: all six migrations, both re-promotions, and a Session 6 staging line built
by hand from the factsheet's printed words — promoted, rolled back, and bill 303
compared cell by cell against what it had been. It came back identical, and the
counts returned to 389 / 1071 / 112.

**Two things rehearsal changed**, both recorded in `DECISIONS.md`: the two
staging cells are plain numbers rather than links to the clean sheet, because a
link deadlocked the rollback; and the stamping check had to be asked only of the
lines that became bills.

**Nothing this session added was marked by it.** Eighteen items are in
`docs/CLOSURE-TESTS.md` for the next session, and they are its first task.

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
   `FACTSHEET-SURVEY.md` §1. Empty sections are sentences ("No bills have
   fallen in Session 7."), not empty tables.
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
