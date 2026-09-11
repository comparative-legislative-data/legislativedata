# Decisions

Settled decisions, newest first. A decision here is not reopened without a
reason recorded as a new entry. Each says what was decided, when, and why —
the why matters more than the what, because it is what tells a later session
whether changed circumstances actually undermine the decision.

---

## 2026-09-12 — What the PhD dataset covers, corrected by the owner

`db/041`, and corrections to `STATE.md` and the entry below.

**What was wrong.** Methodology note M2, written at `db/033`, said the dataset
"covers Sessions 1 to 6". The session then repeated it, and added that Session 7
would have no stage dates. Both were wrong, and the second was contradicted by
the file itself, which the session had already read.

**The owner's correction.** The published thesis covers Sessions 1 to 5. Data
collection continued after it, and the dataset now covers Sessions 6 and 7 as
well. The file supplied on 2026-09-11 holds 469 bills across all seven sessions,
the latest introduced on 9 September 2026. A bill has no Stage 1 or Stage 2
date in it only where it has not yet reached that stage: Session 7's single
bill, and five in Session 6.

**Why it matters beyond the wording.** M2 is published beside the figures, so it
is a claim about the evidence. It also sets what to expect when Sessions 3 to 7
are loaded: the dataset should supply Stage 1 and Stage 2 for every bill that
has reached those stages, and a missing date is a question about that bill, not
about the dataset's span.

---

## 2026-09-12 — Postico's login owns every tab

`db/040`. Five pivot tables — stage dates and durations per bill, total
durations, outcome by type, and the duration summary — belonged to the
administrator, so the owner could not open the very tables the stage dates
filled. All 26 tabs now belong to `legdata`. No data changed.

**The rule this repairs, which stands:** migrations run as the administrator,
and whatever they create belongs to it unless told otherwise. Any migration
that creates something sets its owner.

---

## 2026-09-11 — Sessions 3 to 7: the factsheet is the first source, the PhD dataset backfills the stage dates

Settled by the owner at the close of the session, for the sessions still to
load. It states the practice that Sessions 1 and 2 established, so that it is
not rediscovered each time.

- **The SPICe factsheet is the principal source, and the first one read.** It
  establishes which bills there were, what happened to each, and the dates it
  prints: introduction, passing and Royal Assent. A session is reconciled
  against the factsheet's own summary before anything else happens.
- **The owner's PhD dataset backfills the Stage 1 and Stage 2 dates**, which no
  factsheet gives. Its Stage 3 and Royal Assent dates are not loaded. **It is
  current, not limited to the thesis's own span**: the file supplied on
  2026-09-11 holds 469 bills across all seven sessions, the latest introduced on
  9 September 2026. A bill lacks stage dates in it only where it has not reached
  that stage: Session 7's single bill, introduced 9 September 2026, and five
  Session 6 bills still awaiting Stage 1. Methodology note M2 still describes
  the dataset as covering Sessions 1 to 6, which was written from the thesis's
  own scope at `db/033` and is to be corrected with the owner.
- **Where neither source says, the Official Report and the Parliament's bill
  pages fill it**: an outcome the factsheet does not give, the date of a Stage 1
  rejection, and where a bill that did not pass stopped. Sessions 1 and 2 needed
  all three.
- **Where two sources give the same thing**, the clean sheet takes the Official
  Report's, then the factsheet's, then the PhD dataset's, as settled earlier
  today. The other stays on the staging sheet as the check.
- **A disagreement between sources is recorded, not silently resolved.** The
  four introduction dates and eight Royal Assent dates where the dataset differs
  from the factsheet are listed for the owner, and the factsheet's remain on the
  clean sheet until the owner says otherwise.

**Checked before it is used at scale.** At the owner's request, the next session
tests this on what is already built before Session 3 is loaded: a few bills
traced cell by cell to a source, the order of precedence shown to have held, the
recorded disagreements shown to be visible, the rule tested against Session 3's
Hybrid Bill, and a statement of what it does not yet cover — the API, a revised
published record, and bills appearing in two factsheets. It was settled and
applied in a single day, which is the reason for testing it before four more
sessions rest on it.

---

## 2026-09-11 — Only a Private Bill may skip a stage, and a skipped stage is recorded as one that did not happen

Settled by the owner and built the same day: `db/039`.

**How it came up.** With the dates in, the Session 2 Robin Rigg Act showed two
dates still to find that do not exist. A Private Bill reintroduced after
falling does not repeat its earlier scrutiny, so that bill went straight to its
Final Stage. Recording that only in a note left the gaps list claiming work that
cannot be done.

**Decided.** A stage record can say the bill never had this stage. The owner
chose this over teaching the gaps list to expect less: the fact is then in the
data, where anything counting stages can see it, rather than in prose.

**Only Private Bills.** In the owner's words, that is the only exception the
Standing Orders make: no other kind of bill can skip a stage. So the clean sheet
refuses the mark on a Government, Member's, Committee or Hybrid Bill outright,
as it already refuses a Stage 2 on a Private Bill, and the error checker flags
it on the staging sheet before promotion.

**What it records.** No date, not completed, not where the bill ended, and a
note saying why; the clean sheet refuses any other shape. The gaps list stops
expecting a date for such a stage. M2 tells a reader that a stage that never
happened gives no duration, so the bill gives a time from introduction to
passing but no figure for that stage.

**Where it applies today.** One bill, the Session 2 Robin Rigg Act, from the
page the owner read. Every other bill in Sessions 1 and 2 was checked against
the same test, and none is in that position.

**Rehearsed, thrown away, then run.** Four mistakes were refused by the clean
sheet: a skipped stage on a Government Bill, one with a date, one without a
note, and one also marked completed. The same mistakes on the staging sheet
were flagged, not refused.

---

## 2026-09-11 — The PhD stage dates are loaded from the owner's own spreadsheet, after the owner checks sixteen bills

Settled by the owner, after typing two practice rows. **Changes the entry
below** for the bulk of the dates: they are not typed. Postico stays the way to
correct a single row. Nothing is built by this entry.

**How it came up.** The owner asked whether a sheet of their own, ingested by
the session, would be less error-prone and a quicker way to reuse the PhD
data, and supplied the raw dataset: `Billdates-September2026.xlsx`, one line
per bill for Sessions 1 to 7, with introduction, Stage 1 vote, Stage 2
completed, Stage 3 vote and Royal Assent.

**Matched, not yet loaded.** All 154 Session 1 and 2 bills pair one to one with
the staging lines: 133 on exact name and introduction date, 21 more whose names
differ only in wording, each confirmed by its dates. Stage 3 agrees with the
factsheet for every passed bill but one; 10 of the 11 Official Report Stage 1
dates agree, and the eleventh is blank in the dataset. The two practice rows
match it exactly.

**Settled:**
1. **The dataset is not published.** It sits in `sources/phd/` for the
   session's use, and spreadsheets there are ignored by the repository. What was
   used is recorded by name and fingerprint: sha256
   `a201a07a87b3fd91658855c05d6ac20b8ff91d22cbf34cefc1afdc17ef7eac01`.
2. **Only Stage 1 and Stage 2 are loaded.** Stage 3 stays the factsheet's. The
   dataset's Stage 3 and Royal Assent dates are not loaded as checks.
3. **Date read 2026-09-11 on every row, reference "PhD thesis dataset, row N"**,
   the row of the owner's spreadsheet.
4. **Every issue is settled before anything is loaded.** The owner checks:
   - the fifteen bills that neither passed nor were rejected at Stage 1: where
     each ended, and whether a Stage 1 date in the dataset is a completed stage
     or the day the bill ended;
   - the Session 2 Robin Rigg Act, which passed with no Preliminary or
     Consideration date, and the note that will say why.

   The other disagreements are listed for the owner too: 4 introduction dates,
   8 Royal Assent dates and a passing date that differ from the factsheet, and
   two slips in the dataset. They do not block the load, but the introduction
   and Royal Assent dates are already on the clean sheet. The checklist is
   `sources/phd/checks-before-loading-sessions-1-2.xlsx`, also not published.

**Built and loaded on 2026-09-11**, after the owner answered every question
below. `tools/phd_stage_dates.py` reads the dataset and the answers and writes
the rows; `tools/load_phd_stage_dates.sql` puts them on the stage-dates sheet,
refusing a title that does not match its line number, a row that clashes with
one already held from the same source, a date outside the bill's own dates, and
a line number that does not exist. All four were rehearsed and refused. 270
rows arrived, waiting for the owner's second read; the two practice rows typed
in Postico were skipped as identical. The figures are in the runbook.

The automatic ticks proposed earlier are not needed. The blank templates in
`sources/phd/` are not used by this route.

**Accepted and promoted the same day.** The owner read the rows and was
content. `db/038` admitted all 411, and both sessions were taken off the clean
sheet and put back with the dates, rehearsed once per session and thrown away
first. The clean sheet now holds 411 stage records against 154 bills, the error
checker is empty, and the only dates still to find are the Session 2 Robin Rigg
Act's two, which its note explains. The figures are in the runbook.

**Answered by the owner on 2026-09-11, with the source for each.** These are
the sixteen bills above. Each stage record below carries the page the owner
gave as its source, read on 2026-09-11. No date is recorded on a stage a bill
did not complete, because none of these ended on a decision of the Parliament.

| Line | Bill | Recorded | Source the owner gave |
|---|---|---|---|
| 64 | Family Homes and Homelessness (S1) | stopped at Stage 1, not completed | bill page, withdrawn |
| 141 | Fire Sprinklers in Residential Premises (S2) | stopped at Stage 1, not completed | bill page, withdrawn |
| 142 | Prohibition of Smoking in Regulated Areas (S2) | stopped at Stage 1, not completed | bill page, withdrawn |
| 143 | Prostitution Tolerance Zones (S2) | stopped at Stage 1, not completed | bill page, withdrawn |
| 65 | Tobacco Advertising and Promotion (S1) | stopped at Stage 1, not completed | bill page; withdrawn with no Stage 1 debate |
| 66 | Gaelic Language (S1) | Stage 1 completed 2003-03-06; stopped at Stage 2, not completed | Official Report, 6 March 2003: general principles agreed, no time scheduled for Stage 2 |
| 71 | Robin Rigg (S1) | Preliminary completed 2003-01-09, Consideration completed 2003-03-11; stopped at Final Stage | bill page; fell at dissolution |
| 63 | Education (Graduate Endowment and Student Support) (S1) | stopped at Stage 1, not completed | Official Report of the committee, meeting 2733: withdrawn during Stage 1 consideration, before the vote, and reintroduced redrafted |
| 73 | Stirling-Alloa-Kincardine (S1) | stopped at Preliminary Stage, not completed | bill page |
| 140 | Environmental Levy on Plastic Bags (S2) | stopped at Stage 1, not completed | archived bill page: withdrawn after the Stage 1 report, before the debate |
| 144 | Scottish Register of Tartans (S2) | stopped at Stage 1, not completed | archived bill page |
| 148 | Commissioner for Older People (S2) | stopped at Stage 1, not completed | archived bill page: no timetable for concluding Stage 1 was set |
| 150 | Education (School Meals etc) (S2) | stopped at Stage 1, not completed | archived bill page: partial scrutiny, no Stage 1 vote |
| 152 | Home Energy Efficiency Targets (S2) | stopped at Stage 1, not completed | archived bill page |
| 154 | Treatment of Drug Users (S2) | stopped at Stage 1, not completed | archived bill page |
| 124 | Robin Rigg Act (S2) | no Preliminary or Consideration Stage, with a note | archived bill page: a reintroduced Private Bill does not repeat its earlier scrutiny, so it went straight to the Final Stage vote; the Session 1 bill's Preliminary Stage was 9 January 2003 |

**What this establishes about the dataset.** For a bill that did not pass, the
dataset's "Stage 1 vote" column is not evidence that Stage 1 was completed: for
the four withdrawn bills it holds the day the bill was withdrawn, and for the
Tobacco Advertising Bill a date although there was no Stage 1 debate. So Stage 1
and Stage 2 dates are taken from the dataset for bills that passed, and for the
two cases the owner confirmed (lines 66 and 71). The exact links are on the
staging rows, which carry them as their source.

---

## 2026-09-11 — Stage dates are typed into Postico, not loaded from spreadsheets

Settled by the owner. `db/035`. **Replaces part 4 of the stage-dates decision**
for the owner's PhD dates: the spreadsheets in `sources/phd/` and the script to
load them. That script was the one unbuilt part of the decision, so the
stage-dates change is now built in full.

**How it came up.** Asked what the instructions for entering stage dates should
cover, the owner asked for them in Postico. The conflict with the agreed
spreadsheet route was put first, part by part, and the owner agreed.

**What changes:**
- The owner adds rows straight onto the stage-dates sheet in Postico, one per
  stage. The two blank spreadsheets are deleted, so there is one place to enter.
- **Where a bill ended** is a row for that stage, not completed, and marked as
  where it ended. The stage names allowed are the bill type's own: Stage 1, 2
  or 3, or Preliminary, Consideration or Final.
- **A stage completed on a date not known** is completed, with no date, and a
  note saying why. The spreadsheet's "not known" word goes.
- **Every row carries its own date read.** The owner's reason: sources and
  timescales will not be uniform.
- **The reference is "PhD thesis dataset".** One citation is enough.
- Rows still arrive `new`, and are accepted after the owner reads them a second
  time, recorded in a migration.
- **The practice rows are kept** if they are correct.

**The checks.** Rehearsed as Postico's user with thirteen planted mistakes, and
every one was caught. Refused on saving: a line number that does not exist, the
same stage from the same source twice, an impossible date. Flagged by the error
checker: a stage name wrong for the bill type or position, an empty tick, no
date read, a source not on the list, dates out of order, a date disagreeing
with the Official Report, a stage after where the bill ended.

**What is lost, and what replaces it:**
- **The title check.** The loader would have refused a line number that did not
  match its title. Instead, the sheet shows each row's bill title, filled in
  from the line number, so a wrong line shows as the wrong title.
- **A copy in the repository.** The rows live in the database and its nightly
  backup, and the admission migration records the second read. Accepted by the
  owner.

**Settled with it:**
- **The bill's title on the stage-dates sheet**, beside the line number, asked
  for by the owner to find rows. Filled in automatically when a row is saved,
  and refreshed when a title is corrected on the factsheet sheet. Never typed,
  not a fact under review, and not carried to the clean sheet. The sheet was
  rebuilt to put the column there, and was proved to have changed nothing else.
- **Dates typed with slashes are read day first.** The server read 05/01/2000
  as 1 May; it now reads 5 January. Dates are still shown as 2000-01-05, and
  the instructions say to type them that way.
- A row's last-changed time no longer moves when only its title is refreshed.
- **The stage's position fills itself in from its name** (`db/036`), asked for
  by the owner as a failsafe. Each stage name has one position whatever the
  kind of bill, so the name gives the number, and anything typed there is
  replaced. A real name on the wrong kind of bill, such as Stage 1 on a Private
  Bill, still gets its number, and the checker says it is the wrong name for
  that bill. A mistyped name gets no number, and the checker names it.
- **Postico's login is set to day-first dates** (`db/037`), asked for by the
  owner. It did not change what Postico shows: Postico formats dates itself,
  year first, and the owner is content with that. Dates are typed year first,
  which cannot be misread. The project's scripts were never affected.

---

## 2026-09-11 — Session 2 is promoted before the PhD loader is built

Decided by the owner. `db/034`. **A stated exception** to the rule, set the
same day, that a coding change is finished before any session it touches is
admitted or promoted. The rule stands.

**How it came up.** The owner had checked Session 2 and was content, and
proposed promoting it so the next session could open cleanly onto adding the
stage dates for both sessions. The conflict with the rule was put to the owner
before anything was done, and the owner chose to proceed.

**What is unfinished.** Only the script that loads the owner's PhD spreadsheets
(part 4 of the stage-dates decision). The stage-dates sheet, its checks, the
gaps list, and promotion and rollback from it are built, rehearsed and proved
(`db/033`).

**Why it is safe.** The unbuilt part reads a spreadsheet. It does not decide how
dates are held, checked or promoted, and nothing about Session 2 would be coded
differently once it exists. Session 2 goes onto the clean sheet in the state
Session 1 is already in: passing dates and Stage 1 rejection dates, and no
Stage 1 or 2 dates. Both sessions are taken off and put back when the dates are
added, which `db/033` proved changes nothing it should not.

**What this is not.** A precedent for leaving a decision's parts unbuilt. The
loader is the first task of the next session, and no date is entered until it
is built and rehearsed.

---

## 2026-09-11 — When two sources give the same stage date, the more primary goes onto the clean sheet

Settled by the owner. Built in `db/033` and `tools/promote_session.sql`.

**The question.** Found while laying out the build. The eleven Stage 1
rejections already carry a date from the Official Report, and the owner's PhD
spreadsheet will give one too, as a check. Both wait on the stage-dates
staging sheet. The clean sheet keeps one stage record per stage, with one
source. Which goes onto it when they agree?

**Decided: the Official Report.** In the owner's words, "That is the original
definitive source and we will use it." The PhD row stays on the staging sheet
as the evidence the check was made.

**As a standing order**, so the next overlap needs no new decision: the
Official Report, then a factsheet, then the PhD dataset. No order is settled
between any other sources (the API, bill documents, manual entry). Promotion
refuses to choose between them, and an order is settled when a first case
arrives.

**What makes it safe.** The error checker requires two rows for the same stage
to agree on the date, on whether it was completed, and on whether the bill
ended there, before either can be promoted. The order decides only which
citation the clean sheet shows.

---

## 2026-09-11 — The stage-dates sheet is built, and moving the dates changed nothing

`db/033`, `tools/take_copy.sql`, `tools/compare_with_copy.sql`, and changes to
the load, promotion and rollback scripts. Builds the next two entries, except
the script that loads the owner's PhD spreadsheet (part 4 of the nine parts).
That script is built and rehearsed before the owner enters any date.

**Proved as the owner proposed.** A copy of both sessions was taken, the dates
were moved, Session 1 was taken off and put back, and the whole was compared
with the copy cell by cell. No unexpected differences. The figures are in the
runbook.

**Settled while building, within what was agreed:**
- **A passed bill with no passing date is still a problem, not a gap.** Part 6
  makes a missing stage date a gap, and moves the existing checks to the new
  sheet. The existing checks included this one, and every factsheet prints a
  passing date, so its absence means a bad reading. Missing Stage 1 and 2
  dates are gaps.
- **The gaps list also shows a bill that did not pass with nothing recording
  where it ended.** Part 2 says such a bill means the source does not say how
  far it got. Listing it is what makes the fifteen in Sessions 1 and 2 visible
  as work to do.
- **A date on a stage not completed is allowed only where the bill ended
  there**, which is the Stage 1 rejection case in part 2. Otherwise it is
  flagged.
- **The list of stage names is given to Postico's user.** The error checker
  now reads it, and a checker belonging to that user cannot read a list the
  user is refused. That is one of the six Postico permission faults; five
  remain.
- **M2 cites the thesis:** Steven MacGregor, "Does government dominate the
  legislative process?" (PhD thesis, University of Stirling, 2021), as given
  by the owner.

---

## 2026-09-11 — Each clean tab has a staging sheet of the same shape

Settled by the owner. **Replaces the 2026-09-10 entry "A new variable stages in
one field-level table".** Nothing is built by this entry. Its first use is the
stage dates (next entry).

**The question.** Where the owner's Stage 1 and 2 dates should wait for review.
Two answers were put first:
- columns on the factsheet staging sheet;
- the catch-all sheet planned on 2026-09-10.

The owner objected to the catch-all sheet: a bill's dates would sit in two
places before promotion. Its passing date would be on its factsheet line, and
its Stage 1 and 2 dates somewhere else. The owner proposed thematic sheets
instead. The project will keep adding different kinds of data (MSPs, party
memberships, amendments), and one sheet taking all of it is not good practice.

**The pattern.** A tab is cut by what one row stands for, not by topic: one row
per bill, per stage a bill reached, per MSP, per spell in a party, per
amendment. The clean side was already built this way. The staging side now
follows it. Each clean tab gets a staging sheet of the same shape, and anything
waiting to go onto that tab waits there, whatever its source.

**Dates are not one theme.** A bill's introduction date is one per bill, so it
stays with the bill. A party membership's dates will belong with the
membership. Only stage dates need a tab of their own.

**What it means for the staging sheet we have.** It was checked column by
column. All but two of its 40 columns are one per bill: the same facts held as
printed, as tidied and where each came from, plus the review columns. The two
exceptions are the stage dates:
- `end_stage_3_date`, the passing date;
- `end_stage_1_date`, the date of the eleven Stage 1 rejections.

Both move to a stage-dates staging sheet as part of the stage-dates change. The
factsheet's printed date stays on its line, in `raw_date_final`, as the record
of what was printed. The existing sheet is not otherwise refactored.

**What it replaces:**
- **The catch-all sheet** for single facts about existing bills (2026-09-10) is
  not built.
- **The Stage 1 rejection route is no longer an exception** (the 2026-09-11
  route entry, point 5). It is one per bill, so the bills staging sheet is its
  home under the pattern.

**Why the pattern and not columns.** "Every clean tab has a staging sheet of
the same shape" is one rule to hold in mind. Adding columns to the factsheet
sheet for each new kind of fact makes a growing list of exceptions. The sheet
had already gained several columns the factsheet never states: the Stage 1
date, the route, the note for the bill, and the date the Official Report was
read.

**The cost:**
- One more tab.
- Checking one bill before promotion means looking at its line and its stage
  rows. A pivot table can put them side by side.

**Not settled here, and not needed yet:**
- Staging sheets for MSPs, party memberships and amendments are made when those
  pieces of work open, in this shape.
- Where a later one-per-bill fact is staged (procedure, member in charge) is
  decided when its piece of work opens, against this pattern.

**Proving the move changed nothing.** Proposed by the owner. Moving dates and
adding dates are two changes, so they are checked separately, and a difference
can only have one cause.
1. **Keep a copy first.** Before anything changes, copy Sessions 1 and 2 as
   they stand: the staging lines, and Session 1's bills, stage records and
   provenance notes.
2. **Build and move.** Build the stage-dates staging sheet and move the
   existing dates onto it. Check that every date that was in the two columns
   arrived, with its source and when it was read. Check nothing else on either
   session's staging lines changed.
3. **Put Session 1 back without PhD dates.** Take Session 1 off the clean sheet
   and put it back from the two staging sheets, rehearsed first, then for real.
4. **Compare with the copy, cell by cell.** That covers every bill, every
   provenance note, and every stage record: bill, stage, date, completed,
   where it ended, source, reference and date read. The expected difference is
   none, apart from the stage records' own identifiers and timestamps, which
   are reissued every time.
5. **Only then add the dates.** The PhD dates are loaded and Session 1 is put
   back again. That comparison should differ only by the added dates.

The error checker is empty at every step.

---

## 2026-09-11 — Stage 1 and Stage 2 completion dates, from the PhD. Settled in full; built next session

Raised by the owner at the end of a session, and **settled in full later the
same day**, including all nine parts of the list in `CLAUDE.md` (below).
**Not built.** Building it is the first task of the next session. Nothing that
touches Sessions 1 or 2 moves until it is built, rehearsed and checked.

**Why.** The key research interest is how long a bill takes from introduction
to the end of Stage 3. The clean sheet already holds introduction and Stage 3
dates. Only two dates are missing: the end of Stage 1 and the end of Stage 2.
Royal Assent and Reconsideration are secondary.

**Settled by the owner:**
- **Stage 1 ends on the date of the Stage 1 debate.**
- **Stage 2 ends at the meeting at which the last amendments were disposed
  of.** Every bill has one, amendments or not. With no amendments, the
  committee (or, for an emergency bill, the Parliament sitting as a committee)
  still meets and agrees each section, even if it takes two minutes. So Stage 2
  always has a date.
- **This settles D2** for Stages 1 and 2, which `STATE.md` had kept open since
  2026-09-10. Methodology note M2, which says those dates do not yet exist,
  is rewritten when this is built.
- **The source is the owner's PhD dataset**, which covers Sessions 1 to 6. It
  is already on the list of sources ("ground truth where it covers a case").
  It is added gradually, a session at a time, starting with Sessions 1 and 2.
- **Order of work:**
  1. Settle the open parts. Done on 2026-09-11.
  2. Build and rehearse.
  3. Move the existing dates, and prove the move changed nothing (the entry
     above, "Proving the move changed nothing").
  4. The owner loads the Session 1 and 2 dates.
  5. Session 1 is taken off and put back with them.
  6. Session 2 is reviewed and promoted.

**Already agreed in outline:**
- **Where the dates sit:** the clean sheet already has a record per stage
  (Stage 1 and 2, or Preliminary and Consideration for a Private Bill), so it
  needs nothing new.
- **Provenance:** each stage record carries its own source and reference, so
  no provenance notes are needed.
- **Supplying the dates:** the owner fills in a spreadsheet per session, in
  `sources/phd/`, keyed by staging line number.
- **Checks:** dates must run in order (introduced, Stage 1, Stage 2, Stage 3),
  every passed bill must have both, and a bill rejected at Stage 1 has no
  Stage 2. For the eleven Stage 1 rejections already dated from the Official
  Report, the PhD's date must agree, which checks one source against the other.
  (Amended in part 6 of the nine parts below: a missing date is listed as a
  gap rather than blocking promotion.)

**Open, for the owner:**
1. **Where the dates arrive.** Settled later the same day. They arrive on a
   stage-dates staging sheet: one row per bill per stage, holding every stage
   date whatever its source. The passing dates and Stage 1 rejection dates move
   there too. See "Each clean tab has a staging sheet of the same shape",
   above. The catch-all sheet recommended at first, and the owner's objection
   to it, are recorded there.
2. **Private and Hybrid Bills.** Settled later the same day by the owner: the
   Private Bill process maps onto the three stages of a public bill.
   - **Preliminary Stage** ends on the date of the Preliminary Stage debate,
     where the Parliament decides whether the bill goes on to Consideration
     Stage.
   - **Consideration Stage** ends at the committee meeting at which the last
     amendments were disposed of.
   - **Final Stage** already ends on the vote to pass (M2).

   **The evidence, to be quoted.** The Parliament's page "About Private
   Bills", https://www.parliament.scot/bills-and-laws/about-bills/about-private-bills,
   read on 2026-09-11. The page carries no date.
   - Preliminary: "The Parliament then debates the bill and decides whether it
     should go on to Consideration Stage, or be rejected."
   - Consideration: "The amendments are debated and decided on by the Private
     Bill committee. Only the committee members can vote on amendments at this
     stage."
   - Final: "MSPs then debate and vote on whether to pass the bill."

   **The same page also says:** "These stages are quite different from the
   stages of a Government Bill, and they have different names." That is
   consistent with how they are held. The stages keep their own names
   (`db/018`) and are compared by position, without claiming they are the same
   stage. Proposed: a reader is told both, the end points and that sentence.

   **The page describes today's procedure**, not that of 2003–2007, as with the
   Standing Orders in the 9.14.18 entry.

   **A Consideration Stage meeting even with no amendments.** The owner's
   understanding is that every Private Bill has one, as every public bill has a
   Stage 2 meeting. It is tested by the data rather than assumed. The checker
   requires both dates for every passed bill, so a passed Private Bill without a
   Consideration Stage date is flagged, not quietly accepted.

   **Hybrid Bills follow the same system**, settled by the owner. The evidence
   is the Parliament's page "About Hybrid Bills",
   https://www.parliament.scot/bills-and-laws/about-bills/about-hybrid-bills,
   read on 2026-09-11. It carries no date.
   - "Once a Hybrid Bill is introduced, it follows a 3-stage process. In most
     ways, these stages are the same as the stages of a Government Bill, but in
     other ways are like the stages of a Private Bill."
   - Stage 1: "The Parliament then debates the bill and decides whether it
     should proceed to Stage 2, or be rejected."
   - Stage 2: "The amendments are debated and decided on by the Hybrid Bill
     committee."
   - Stage 3: "There is a debate and vote on whether to pass the bill."

   Copies of both pages are in `sources/procedure/`.

   **Found while reading it: the database gives a Hybrid Bill the wrong stage
   names.** `db/018` gave Hybrid Bills the Private Bill names: Preliminary,
   Consideration and Final. The page calls them Stage 1, 2 and 3. So does the
   record of the only Hybrid Bill there has been, the Forth Crossing Bill.
   Both sources below were read on 2026-09-11.
   - **The Explanatory Notes to the Forth Crossing Act 2011**, table of
     proceedings (https://www.legislation.gov.uk/asp/2011/2/notes/division/7).
     Its rows are headed "STAGE 1", "STAGE 2" and "STAGE 3", with "Stage 1
     Debate and Parliamentary vote", 26 May 2010, and "Stage 3 Debate and
     Parliament vote", 15 December 2010.
   - **The Forth Crossing Bill Committee's page**
     (https://www.parliament.scot/chamber-and-committees/committees/current-and-previous-committees/session-3-forth-crossing-bill-committee).
     It lists "1st Report 2010: Stage 1 Report on the Forth Crossing Bill", 12
     May 2010, and "2nd Report 2010: Stage 2 Report on the Forth Crossing
     Bill", 3 November 2010.

   No Hybrid Bill is in the database yet, so no data is affected. `db/018`'s
   own principle is that stages are recorded under the names they really had,
   and these are the names the Forth Crossing Bill had. **Agreed by the
   owner:** it is corrected within the stage-dates change. Hybrid Bills would run
   Stage 1, 2 and 3, then Reconsideration. Every description, note and document
   that says otherwise is corrected with it (listed in `STATE.md`).
3. **Withdrawn and fallen bills.** Settled later the same day by the owner.
   The stage each had reached, and the dates of any stages completed before
   it, are recorded where the PhD says. They are entered as part of the
   owner's general input of dates, not backfilled as a separate exercise. The
   spreadsheets already have a column for the stage reached. Fifteen bills in
   Sessions 1 and 2 currently have no stage information at all.

   **The owner does not start entering dates** until everything is settled and
   the staging process has been shown to work: the move of the existing dates
   is proved to change nothing, as in the entry above.
4. **A stage completed on a date not known.** Settled later the same day by
   the owner: allowed, and held as a gap to be filled. It does not hold
   anything else up.
   - The stage record says completed, with its date empty, and a note saying
     why is required.
   - Every such gap is listed where it can be seen, but it does not stop the
     session being promoted. Where the list sits is part of the nine-part
     layout.
   - Duration figures leave that bill out of that stage only.

   The owner hopes there are none. Until now an empty date on a stage record
   was described as meaning "not completed", which the record's own completed
   column already says. That description changes with this.

**The nine parts, agreed by the owner on 2026-09-11.** Each part was laid out
with a proposal, and the owner resolved the three choices in them.

1. **What it records.** One row per stage a bill reached:
   - the bill, and the stage under its real name;
   - completed or not, and the date;
   - whether the bill ended there;
   - the source (`spice_factsheet`, `official_report` or `phd`, all already
     on the list), its reference and the date it was read;
   - a note.

   The end points are as settled above.
2. **Which bills, and what empty means.**
   - A passed bill has all three stages, completed.
   - A bill that ended early has the stage it stopped at, not completed and
     marked as where it ended. It also has any stages it completed before
     that.
   - A Stage 1 rejection keeps the date of the decision on its uncompleted
     Stage 1, as now.
   - Otherwise a date is empty only for a stage not completed, or for a stage
     completed on a date not known, which needs a note (open part 4 above).
   - A bill with no stage rows at all means the source does not say how far it
     got.
3. **Where it sits on the clean sheet.** The existing stage records tab, in the
   same shape. One new rule: a completed stage with no date must have a note.
   The Hybrid rows of the list of stage names become Stage 1, 2 and 3.
4. **How it arrives on the staging sheet.** A new stage-dates staging sheet, one
   row per bill per stage. Each row carries its bill's staging line number and
   its own review gate.
   - **Factsheet passing dates** go there when a session is loaded. The
     extractor is unchanged; `load_session.sql` sends the date to the new
     sheet.
   - **Official Report dates** found at review go there.
   - **The owner's PhD spreadsheet** is loaded by a rehearsed script that
     unfolds each line into rows. For a Private Bill, its Stage 1 and 2
     columns hold the Preliminary and Consideration Stage dates.
   - **"not known" is written in a date cell** for a stage completed on a date
     not known, so an empty cell always means not yet entered.
   - **The old columns come off.** `end_stage_1_date` and `end_stage_3_date`
     are removed from the factsheet staging sheet once their contents have
     moved.
   - **Admission is a second pass.** Rows arrive as `new`, the owner's own PhD
     dates included, and are admitted after the owner has read them. The
     admission is recorded in a migration, as `db/016` did. The owner's reason:
     mistakes can happen in data entry. Moved rows keep their line's review
     status.
5. **Promotion and provenance.** Promotion builds stage records from the new
   sheet's admitted rows, instead of from the two columns. Each record carries
   its own source, reference and date read, so no provenance notes are filed
   for stage dates.
6. **What the error checker requires.** Contradictions block promotion; gaps do
   not.
   - **The existing checks** on the two date columns move to read the new
     sheet.
   - **New checks:**
     - dates run in order, from introduction through each stage to Royal
       Assent;
     - stage names are right for the bill type;
     - nothing comes after the stage a bill ended at;
     - for the eleven Stage 1 rejections, the PhD's date agrees with the
       Official Report's.
   - **A missing date is a gap, not a problem.** This covers a passed bill
     without a stage date, and a stage completed on a date not known. Gaps are
     listed on a new pivot table of gaps to fill, and do not stop promotion.
     This amends the outline above: every passed bill should still have all its
     dates, but a missing one is listed rather than holding up the session.
     Without it Session 7, which the PhD does not cover, could never be
     promoted.
7. **What the note tells a reader.** M2 is rewritten to cover:
   - the three end points;
   - Private and Hybrid Bills, quoting the Parliament's pages, including "quite
     different";
   - the PhD as the source, a session at a time;
   - dates not known, which are left out of durations.

   Durations run between consecutive dated stages. So a missing Stage 2 date
   gives a Stage 1 to Stage 3 interval under its own label, not a Stage 2
   figure, and the note says so.
8. **Every bill already coded, rechecked.**
   - Session 1's 67 dates (62 passing, 5 Stage 1 rejections) and Session 2's
     72 (66 and 6) move, and the move is proved to change nothing (the entry
     above).
   - The eleven rejection dates are checked against the PhD.
   - The twelve Private Bills in Sessions 1 and 2 are checked for their stage
     names.
   - No Hybrid Bill is held yet.
9. **When.** All of it is built, rehearsed and checked before the owner enters
   any date and before Session 2 is admitted, in the order of work above.

**Also changed with it:**
- the descriptions listed in `STATE.md`;
- `HOW-THE-DATABASE-WORKS.md` and the runbook;
- the data dictionary, regenerated.

The two new tabs are given to Postico's user so the owner can open them. That
makes 26 tabs.

---

## 2026-09-11 — Provenance notes are rebuilt with their bill, not kept forever

`db/030`, `tools/rollback_promotion.sql`, `tools/promote_session.sql`. Decided
by the owner. **Amends D5 and reverses the append-only rule of `db/025`**,
which the 2026-09-10 entries "A description may not claim a rule the database
does not have" and "Our own rules are not facts of the world" had defended.

**The owner's position.** Provenance notes may change, provided the owner
clears the change. The owner is the judge of what is acceptable to claim as
academic quality, and treating these notes as permanent was completely
unnecessary.

**What happened.** For the second day running the rule got in the way, and
both times it was protecting our own work, not a source's words. On
2026-09-10 fixing a script's mistake meant suspending it (`db/027`). On
2026-09-11, re-promoting Session 1 to add routes would have left five
duplicate-looking outcome notes that could never be tidied. That was put to
the owner as though it were a constraint on them.

**What replaces it.** A provenance note is treated like a stage row:
- promotion writes it from the staging sheet, one note per fact, dated by the
  latest reading;
- taking the session off removes it;
- putting the session back writes it again.

**Clearance.** Approving that rehearsed procedure clears the notes it rebuilds,
since every note is shown before anything is saved. Any other change to a note,
by hand or in a migration, goes to the owner individually.

**What is given up.** The notes no longer hold a history of readings. The
source's own words stay on the staging sheet, which is never emptied. Nothing
yet records a second reading of a source that gives a *different* answer, and
no such revision has happened. How to record one is settled when the first
real case arrives, which is also recorded in `STATE.md`. `v_field_revisions`
stays, and will be empty until then.

**What stays.** A staging line's number is still its bill's number (`db/026`).
The rule was introduced to protect the notes, but it is still worth having:
line 17 is bill 17 in both directions, and nothing reaches the clean sheet
without a staging line behind it.

**Found while building it.** Rebuilding bill 17's note with the script as it
stood would have put back the instruction text `db/027` removed, because the
script appended the whole review note. It now writes the note without it.
Methodology note M5 told readers a blocked bill's earlier state "is recoverable
from field_source, which is append-only"; it now says the earlier state is in
the fact sheet lines held for every session.

---

## 2026-09-11 — A change to how data is coded is finished before anything moves on

Set by the owner, after the next entry was first recorded half done.

**What happened.** The 9.14.18 route was settled as a variable of its own and
then written up as "not yet built, and its home is not decided". A to-do list
went into `STATE.md`, and the recommendation was not to hold Session 2 for it.
Nothing would have stopped Session 2 being admitted and promoted without it. It
would have been finished only if a later session read the list and chose to do
it. That is the pattern that let `VARIABLES.md` contradict the database, and
left M7's "5 of 48 done" out of date. The cause was hurrying towards the next
question.

**The rule.** A methodology decision is not settled until every part of it is
settled, and it is not finished until every part is built:

- what it records and its values;
- which bills it applies to, and what an empty cell means;
- where it sits on the clean sheet;
- how it arrives on the staging sheet;
- how promotion carries it, and its provenance;
- what the error checker requires;
- what the methodology note tells a reader;
- every bill already coded under the old approach, rechecked;
- when it is built, relative to any session it touches.

Until then no session it touches is admitted or promoted, and no new question is
opened. "Not yet built" is not a state a decision may be left in. If the work
cannot be finished in the session, it becomes the first task of the next one,
stated as such at the top of `STATE.md`.

**Why.** Chaos comes from half-finished methodology, not from any single wrong
choice. The owner is the check on every research claim this project makes, and
cannot check a decision that exists in pieces across a review note, a to-do list
and an intention. This is not a race.

---

## 2026-09-11 — A Rule 9.14.18 motion is a Stage 1 vote reached by another route

`db/029` (the outcomes), `db/031` (the route's structure), `db/032` (the
routes recorded). Settled by the owner, from two Session 2 bills. **Built,
rehearsed and applied on 2026-09-11**; Session 1 was taken off and put back
to carry it.

**The cases.** The Provision of Rail Passenger Services (Scotland) Bill (9
November 2006) and the Civil Appeals (Scotland) Bill (20 December 2006) were
not defeated on the member's motion. The Presiding Officer's statement under
Rule 9.3.1 held each to be outwith competence. The lead committee lodged a
motion under Rule 9.14.18 that the Parliament does not agree to the general
principles, and the Parliament agreed.

**Outcome: rejected at Stage 1.** It was a vote on the general principles, and
the code's definition is "general principles not agreed to". A separate code
was considered and rejected. It would have said the bill ended some other way,
and it didn't.

**The route becomes a variable of its own.** The cases are rare, but they
matter to researchers. This entry was first written with the variable "not yet
built, and its home is not decided". That left the decision half made, and the
next entry exists because of it. Every part is now settled:

1. **What it records:** how the Stage 1 decision that ended a bill was reached.
   There are three values, held in a dropdown list:
   - *motion of the member in charge, disagreed to*;
   - *motion of the member in charge, amended to reject the general principles,
     agreed to as amended*;
   - *committee motion under Rule 9.14.18, agreed to*.

   "Member in charge" rather than "member's motion", so the first value also
   fits a Government Bill defeated at Stage 1. The third value's definition
   quotes the rule from the current Standing Orders, taken as unchanged since
   2006.

   **The second value was found by rechecking Session 1 (point 8), before
   anything was built.** The Proportional Representation (Local Government
   Elections) (Scotland) Bill, 6 February 2003, fitted neither of the first two
   values. Amendment S1M-3727.1, in Iain Smith's name, turned Tricia Marwick's
   Stage 1 motion into one that "does not agree to the general principles of
   this particular Bill" (65–54–2), and the motion as amended was agreed
   (65–53–3). The amendment's number, its mover and its stated reason go in the
   bill's note, not a variable: who moved it belongs to the later
   member-in-charge and party slice. The owner suspects the Parliament has since
   changed its handling of motions so this cannot recur; that has not been
   checked.
2. **Which bills:** only bills rejected at Stage 1, and every such bill must
   have a value; the error checker flags one without. An empty cell therefore
   means one thing only: the bill was not rejected at Stage 1.
3. **Where it sits:** on the bill, beside the outcome it qualifies. A bill has
   one Stage 1 decision, so nothing is lost, and an outcome-by-type table reads
   the bill's line. (The bill's Stage 1 record was considered first and
   rejected for that reason.)
4. **The limb, and the amendment:** our view of the limb goes in the bill's
   note, in a fixed form ("Rule 9.14.18: our view is limb (b)…"), followed by
   the grounds and the citation. For the amended route, the note records the
   amendment's number, its mover and the reason the resolution gives.
   The staging sheet gains a note column that promotion carries onto the bill.
   Without it the bill's note could never be filled, since the clean sheet is
   rebuilt from the staging sheet. That also blocked the rename dates and the
   s.33/s.35 mechanism, both already decided to go there.
5. **How it arrives:** a column on the staging sheet beside the Stage 1 date,
   from the same Official Report reading. This is a stated exception to the
   separate route for single facts (2026-09-10), and the exception is defined:
   facts about the decision that ended a bill, read at review. That separate
   route remains the home for procedure, member in charge and party.
   (Replaced later the same day: see "Each clean tab has a staging sheet of
   the same shape". The route is one per bill, so it is where it belongs.)
6. **Where it came from:** promotion files a provenance note for the route
   citing the Official Report, as it does for the outcome.
   - **What it quotes:** its value seen is the Presiding Officer's
     announcement, word for word ("For 65, Against 53, Abstentions 3. Motion,
     as amended, agreed to."), because those are the words that tell the
     routes apart. The review note carries it in the fixed form `Result as
     recorded: "…"`.
   - **Its date:** the staging sheet gains a date for when the Official Report
     was read, and promotion dates Official Report facts by it: the outcome,
     the Stage 1 date and the route. Previously they took the date the
     factsheet was read. That was harmless for Session 1, where both happened
     on 10 September, but would have dated all of Session 2's Official Report
     facts a day early. The checker requires the date whenever anything on a
     line came from the Official Report.
   - **An extra check:** the checker flags a 9.14.18 route on anything but a
     Member's Bill, and the clean sheet refuses one, since the rule covers only
     Member's Bills.
7. **Telling readers:** methodology note M7 gains a paragraph covering what
   each of the three routes means, that the limb is our view, and that the rule
   text is the current one.
8. **Session 1:** its five Stage 1 rejections were rechecked against the
   Official Report on 2026-09-11. Four were the member in charge's motion,
   disagreed to; one was the amended route above. None was a 9.14.18 motion.
9. **When:** all of it is built, rehearsed and checked before Session 2 is
   admitted. **In this order:**
   - take Session 1 off the clean sheet, following the runbook;
   - change the structure (`db/031`);
   - record the eleven routes (`db/032`);
   - put Session 1 back.

   Session 1 has to come off first because the clean sheet cannot be given the
   rule "every Stage 1 rejection has a route" while five bills without one are
   on it.

In total that is one dropdown list, one column on the bill, and three on the
staging sheet: the route, the note to carry onto the bill, and the date the
Official Report was read.

**Which limb is a note giving our view, not a formal value.** Neither motion
cites a limb. The Local Government and Transport Committee's recommendation of
24 October 2006 repeats the words of limb (b) without its letter, and the
Justice 2 convener's grounds in the chamber do the same. So the formal record is
"a motion under 9.14.18", and "(b)" is our reading of the grounds.

**The rule text comes from the current Standing Orders.** The 2006 edition is
not published online. The owner is confident the rule has not changed, and a
coding may rest on what we take the rule to have been at the time, provided it
is triangulated against the motion and the grounds given for it.

**Consequence for promotion.** A review note now carries commentary after its
citation. `promote_session.sql` takes the provenance note's value seen from the
words before the first link only, so that commentary can never land in a
provenance note. That is the bill 17 lesson, applied before rather than after.
(At the time a provenance note could not be edited afterwards. That changed at
`db/030`, later the same day, but the rule about commentary still holds.)

---

## 2026-09-11 — "Extracts clean" meant the counts matched, and that was not enough

`db/028`, `tools/extract_factsheet.py`, `tools/load_session.sql`, and the
guard in `tools/promote_session.sql`. Found loading Session 2, which the
handover said needed no parser work because it extracts 81 rows against a
stated 81.

**The count was right and the rows were not.** Session 2's title cells hold
three things Session 1's never do: an SP Bill number after the title (15
bills), an asp number in brackets (2), and in one case an introduced title
after the asp number. The extractor separated none of them. The error checker
would have caught the asp numbers and nothing else, so fifteen bills would have
reached the clean sheet with their number inside the title and none in the
column for it. Reconciling against a factsheet's own totals proves no line was
lost. It says nothing about what is inside a line, and the survey read the
documents' structure, which is why it missed an introduced title printed inside
a cell.

**The staging sheet gets a place for an introduced title after all.** Recorded
on 2026-09-10 as deliberately not built, on the grounds that Session 1 states
none. Session 2 states one, and the clean sheet already has the column, so
without a staging column promotion has nothing to carry into it. Rename dates
and block dates are still not built; nothing loaded so far states one.

**The checker now flags an SP Bill number or an introduced title left in a
title.** Tested by planting each in a staging line inside a transaction that
was thrown away. Both were caught.

**A matching title does not make a bill a double count.** The Prostitution
Tolerance Zones (Scotland) Bill was rejected at Stage 1 in Session 1, and a new
bill of the same name was introduced in Session 2. Promotion refused any line
whose title was already on the clean sheet, so it would have refused Session 2.
The guard now requires the same title **and** the same introduction date: a
bill counted in two factsheets keeps its introduction date, and a reintroduced
one does not. That makes them separate bills, as VARIABLES §6 always said.
**Known gap, not fixed here:** the guard cannot see the European Charter and
UNCRC Bills, whose titles change from Bill in Session 5 to Act in Session 6. It
has to be dealt with before Session 6 is promoted.

**Loading is a script with a rehearsal, like promotion.** Nothing recorded how
Session 1 was loaded. `load_session.sql` takes `-v session=` and `-v save=` with
no defaults, refuses a CSV whose columns are not exactly the extractor's
current ones, and refuses a session that already has staging lines. It numbers
the staging lines itself, one after the highest in use, rather than taking
numbers from the sequence. A thrown-away rehearsal would otherwise still use up
numbers, and a staging line's number becomes a bill's number (`db/026`).

**M3 no longer states a count of introduced titles.** It said "three cases
across seven sessions"; Session 2 made it four. The count was removed rather
than corrected, for the same reason row counts came out of the table
descriptions.

---

## 2026-09-10 — Our own rules are not facts of the world

`db/027`. One provenance note held an instruction to the promotion script in
the column meant for a citation. It was corrected by suspending the
append-only rule for the length of one transaction and putting it back.

**Why this is written down.** The correction is trivial; the reasoning that
delayed it is not. `field_source` was made append-only that same morning, on
an empty table, by us. When the first mistake landed in it an hour later, it
was reported to the owner as something that could not be fixed. It could. The
rule was treated as a property of the world rather than a choice made that
day, and the owner had to argue for five minutes to get a one-line change
made.

**The rule stands and is not weakened.** It exists so a published record
revised in 2030 cannot be silently overwritten, leaving no trace the
Parliament changed its mind. That is worth the cost it imposes.

**The test for a future case.** Is the row a record of what a source said, or
debris from our own tooling? A source's words stay, always, even when they
turn out to be wrong — that is the entire point. Our debris is cleaned up, in
a migration that says what it changed and why. The distinction is not fine and
does not need adjudicating each time.

**The general form, which matters more than this instance.** Every rule in
this database was written by this project, most of them this month. A rule
that makes the data trustworthy is worth defending; the same rule protecting
a typo made by our own script, on data nobody outside the project has seen, is
not. Say which of the two is in front of you before saying something cannot be
done.

---

## 2026-09-10 — Promotion is a rehearsed procedure with a written undo

`tools/promote_session.sql`, `tools/rollback_promotion.sql`,
`docs/PROMOTION-RUNBOOK.md`. Session 1 promoted: 73 bills, 67 stage rows, 6
provenance notes.

**Both scripts require `-v session=` and `-v save=` with no default for
either.** A run with `save=false` does the entire job, prints the result and
discards it. Eight checks run before anything is kept and any failure aborts
everything, whichever way `save` is set.

**Why the procedure is written down rather than remembered:** it gets run
seven times, by whoever is here, and the value is in knowing what to look at
rather than what to type. The runbook names the five tables to read and what
each should say.

**Reversibility was rehearsed, not assumed.** Session 1 was promoted, taken
back off, and promoted again. After the undo: no bills, no stage rows, staging
lines unstamped, provenance notes still present because they cannot be
deleted. After promoting again: the same 73 bills with the same numbers, still
6 notes rather than 12, each pointing at the right bill. A third run changed
nothing. This is what `db/026` was for and it is now demonstrated rather than
argued.

**A provenance note is the one thing that cannot be tidied up afterwards.**
Demonstrated the hard way on the first run: bill 17's note has the whole
reviewer's comment as its reference, including a sentence that was an
instruction to whoever wrote the script. The script now files a short
reference, so later sessions are clean; that row cannot be. Recorded because
the lesson is general — read the provenance table before saving, not after.

**Withdrawn and fallen bills get no stage rows.** Six Session 1 bills have a
concluding date on the bill and nothing else, because the factsheet does not
say what stage they had reached. That is a gap in the source, not in the
schema, and it is listed as open in `STATE.md`.

---

## 2026-09-10 — A bill's number is its staging line's number

`db/026`. `bill.bill_id` no longer comes from a sequence. Promotion supplies
it, and it is the `candidate_id` of the staging row the bill was promoted
from. A foreign key from `bill.bill_id` to `bill_candidate.candidate_id`
enforces it.

**Why:** promotion being cheap to redo is what made it safe to promote Session
1 before the other six sessions were even loaded. It was nearly true and not
quite. `bill_candidate` is permanent, `stage_event` rows go with their bill,
and a staging row's `promoted_bill_id` empties itself. `field_source` was the
exception: it records which bill a note is about by the bill's number, and
`db/025` made it append-only, so those rows cannot be corrected. Empty `bill`,
promote again, the numbers come back in a different order, and six notes point
silently at the wrong bill. Stopping the numbers moving removes the problem
rather than managing it.

**A second thing it buys.** A bill can no longer exist without a staging line
behind it. The gateway rule was previously a property of the promotion script
being written correctly; it is now a property of the database.

**What it costs.** Bill numbers are no longer an unbroken run — the four bills
appearing in two factsheets (M6) take the number of the first line promoted, so
four candidate numbers are never used. `bill_id` was always our own invented
identifier, never shown to a reader, so a gap in it means nothing.

**Tested, not assumed.** A bill with a number no staging line has is refused; a
bill taking a real staging line's number is accepted; a bill with no number
supplied is refused, since nothing hands them out any more. `bill` is still
empty.

**Stage dates need no note of their own.** Checked while doing this: the five
Session 1 Stage 1 dates that came from the Official Report do not need a
`field_source` row, because a stage row carries its own `source`, `source_ref`
and `observed_at`. So all six of Session 1's provenance notes are about `bill`
columns — one corrected title and five outcomes — and all six are now stable
across a re-promotion. A stage row's number is still reissued on re-promotion,
which matters only for a second, later observation of the same stage date.

---

## 2026-09-10 — A description may not claim a rule the database does not have

`db/025`. Found by the owner reading the descriptions back, which is the check
`db/024` was built to make possible, working as intended on its first outing.

**Seven descriptions stated a rule that did not exist.** Five staging columns
said "must be a value in ref_x". Nothing checks them, and nothing should:
`bill_candidate` is permissive on purpose so a bad parse lands as a row that can
be looked at. Those are reworded to say where the check really is — on `bill`,
which is true today and stays true whenever the promotion script is written.

**The sixth was different and is now real.** `field_source` said rows are only
ever added, never changed. That was a convention held by whoever was typing, and
**D5 is settled on it** — the reason a revised published record is visible rather
than silent is that the earlier observation cannot be overwritten. A settled
decision resting on a habit is not settled. A trigger now refuses an update and a
delete, and it was tested rather than assumed.

**The cost is stated rather than left to be discovered.** A row entered in error
cannot be tidied away; correcting one means a migration that drops the trigger,
makes the change and puts it back, so the correction is itself part of the
record. Same reasoning as `db/016` admitting candidates by migration.

**The seventh was the check being wrong, not the database.** `fell_here` was
reported as unenforced and was not — a partial unique index has always refused a
second one. `pg_constraint` does not list plain indexes. Recorded because the
same mistake would pass a second review the same way.

**Descriptions say what the data is before how it was derived.** The staging
ones were written from the extraction script's point of view — "the outcome we
propose", "converted to a real date" — which is the wrong way round for the
person reviewing a row at the gate. Both belong, in that order. Row counts came
out of table descriptions: "seven rows" is true until it is not, and nothing
announces the change.

## 2026-09-10 — `methodology_note` stays a table, and the future-proof columns stay

Both raised as candidates for removal on the grounds that the database felt
complicated for 73 rows, and both settled by the owner against that.

**`methodology_note` is not moved to markdown.** The argument for moving it was
that seven rows of text feed a website that does not exist yet, and a file would
do for now. The owner's answer, and it is the right one: multiple markdown files
will kill us in the end. `docs/VARIABLES.md` is the proof — it still defines
columns, and several of its definitions now contradict the database. The
original decision stands and this entry records that it was challenged and held.

**`party`, `procedure` and their two lists stay.** Neither is used by the first
slice, so both fail "build only what the current slice needs" as written. Kept
deliberately as future-proofing, on the owner's judgement that re-adding them
later costs a migration either way and carrying them costs nothing.

**What the complexity question was actually answered with.** Of fifteen tables,
three hold bills, two are the gateway, one is the published notes, and nine are
lists of permitted words four columns wide. Of 130 columns, roughly 25 are
distinct facts; the rest is that four-column shape nine times over, plus the
same bill held three ways in staging — as printed, as read, as admitted. Every
piece that is not future-proofing traces to a specific bill or a specific
factsheet behaviour that forced it.

## 2026-09-10 — What the factsheet survey settled: seven decisions from reading all seven

`db/019`-`db/023`. The survey is `docs/FACTSHEET-SURVEY.md`; this records what it
forced. Taken in one sitting, while `bill` was still empty and structural change
was still free, which was the whole reason the survey came before promotion.

**The finding underneath most of the others: passing a bill is not the end of it.**
`db/013` had encoded the opposite as a `CHECK` — if a bill passed, it could have
no concluding date, because its Stage 3 date was its ending. Four bills say
otherwise, and they are four different endings from one starting point. Three
were referred to the Supreme Court under section 33 and ruled partly outwith
competence on the same day, 6 October 2021: two were reconsidered and enacted,
one was withdrawn on 10 March 2022, four years after it passed. The fourth, the
Gender Recognition Reform Bill, was blocked by a section 35 order on 16 January
2023 and nothing has happened since.

**Stasis is not a state of its own.** The owner's reading, and it is right: the
bill has been blocked, and nothing has happened since, which is exactly what
`blocked` means. `enactment_status` records a bill's current state, not its
history; the history is in `field_source`, which is append-only for this reason.
So no new vocabulary — but `pending` had to be tightened, because it said
"including referral", under which a bill referred and ruled against was
describable both ways depending which clause you read.

**A blocked bill does not fall at dissolution.** This is why the Session 7
factsheet carries the Gender Recognition Reform Bill as one of its own bills, and
why that is not an error on SPICe's part. An unfinished bill falls; a passed bill
that has been blocked has nothing left to fall from.

**`date_assent_blocked` is the one addition not forced by a constraint.** Stated
plainly so it can be struck if it is judged speculative. Without it `blocked` is a
state with no time attached, in a project whose second research question is time.
It does not duplicate `date_royal_assent` or `date_concluded`, because the
intervention and the ending are different events, and it stays populated after a
block is lifted — which is how the bills that were blocked and recovered can be
found at all.

**Two title columns, not one with a caveat.** `short_title` is the title the bill
is known by at the latest point there is evidence for; `title_as_introduced` is
the title at introduction, null where no source states it — which is most rows.
This is the third instance of the same shape: `bill_type_stated` beside
`bill_type` (D4), stage names by bill type (D6), and now titles. VARIABLES §3.2
defined `short_title` as the introduced title and was false for 62 of 73 Session 1
rows; M3 existed to publish that. It now describes coverage instead of apologising
for one column meaning two things. Null never means unchanged.

**Hybrid Bills keep their type and gain a grouping.** The requirement was to be
able to include or exclude them later. Coding the Forth Crossing Bill as
'government' would put a false value in the type column and make exclusion the
hard case; `ref_bill_type.analysis_group` leaves the type true and makes the
choice a matter of picking a column at query time. **The Session 3 factsheet
already makes this grouping and does not say so** — it defines a type letter `H`,
applies it to that one bill, then prints a summary with no Hybrid column and
counts it under Executive. Its stated 45 Executive bills are 44 plus one Hybrid.

**That is also the limit of the reconciliation gate, found rather than argued.**
Both sides total 62, so the gate passes on a document that has silently agreed a
Hybrid Bill is an Executive Bill. An arithmetic check against a source's own
totals catches a dropped row and does not catch a coding decision. Worth knowing
before six more sessions are reconciled the same way.

**A bill belongs to the session it was first introduced in.** The only definition
that survives a bill being reconsidered two sessions later. It means our
per-session counts will not match the factsheets', which count a bill in every
session it was live: 473 rows in the seven stated totals, 474 rows to read, 470
distinct bills. Published as M6, because a researcher checking our total against
SPICe's needs to find the explanation in the data and not in a repository.

**`sp_bill_id` is unique within a session.** SP Bill numbers restart each
session; SP Bill 13 is in Sessions 2, 6 and 7. Storing a qualified string like
'S5-70' was rejected because it invents an identifier the Parliament does not use,
and every comparison against a source would have to undo it.

**Why a bill fell is our coding, and it is 5 of 48 done.** No factsheet ever says
why a bill fell. Rejection at Stage 1, defeat at the final vote and running out of
time at dissolution are all one heading. M7 publishes that the distinction is
ours, against the Official Report, and that it is mostly not yet made — so a
reader does not take the general code as a finding.

**What was deliberately not built.** `bill_candidate` gets no column for a stated
introduced title, a rename date or a block date: Sessions 4-7 state them and
Session 1 states none, so building now would be speculative. And the
session-window checks in `v_candidate_problems` compare a candidate's dates
against the session of the factsheet it was read from, which is the wrong session
for a carry-over row; Session 1 has none, so the limitation is written into the
view's own comment rather than fixed, and it must be handled before Session 5 is
loaded.

**Rename dates get no column.** Two bills in seven sessions state one; both go in
`bill.note`. Revisit at a third case.


## 2026-09-10 — Stage dates return to `stage_event`, under each bill type's own stage names. D6 settled

`db/018`. Reverses the stage-date half of `db/004` and the whole of `db/005`, and
settles D6, opened earlier the same day.

**The principle, in the owner's words:** record the appropriate nuance for each
type and normalise afterwards if we need to, rather than shoehorning different
kinds of bill procedure into a single class because that is neater.

**What that means here.** A bill's stages are recorded under the names those
stages actually have for that kind of bill — Stage 1, 2 and 3 for a public bill;
Preliminary, Consideration and Final Stage for a Private or Hybrid Bill — in
`stage_event`, one row per stage reached. `ref_bill_type_stage` records which
sequence belongs to which bill type, and a trigger enforces it: the database now
refuses to record a Stage 2 against a Private Bill, or a Preliminary Stage
against a Government Bill, or a valid stage name at the wrong position.
Comparison across types is done in a view, on `stage_order`, with the real stage
names carried through into the output so it is always visible what is being
compared with what.

**This is the same shape as `bill_type_stated` beside `bill_type`,** which is why
it is consistent rather than novel. D4 exists to stop the normalised value eating
the contemporaneous one. The identical argument applies to stages.

**Why reversing `db/004` is legitimate rather than a change of mind.** That
decision moved stage dates onto the bill row because "a bill becomes one line to
type, which is what a hand-build needs". The reason was about typing. Rows are
now extracted programmatically and the reviewer edits a staging row, so the cost
that justified collapsing the stages has largely gone — the promotion script fans
one candidate row out into several stage rows, which costs nothing because it is
a script. `db/003` had originally built the duration views on `stage_event` in
exactly this way; `db/018` substantially restores them.

**What did not move, and why.** `date_introduced` and `date_royal_assent` stay on
`bill`. Every bill type has both, under the same name, so no nuance is lost by
holding them as columns, and moving them would duplicate two fields that existing
constraints depend on. The distinction being served is that stage *names* differ
by bill type; introduction and Royal Assent do not. `date_concluded` stays for
the same reason — a bill being withdrawn is not a stage.

**`ref_stage.applies_to` was dropped.** It marked the three private stages
'private', which left Hybrid Bills unaccounted for, and its `CHECK` allowed only
public/private/both so it could not have said otherwise. It was also a second
answer to a question `ref_bill_type_stage` now answers properly, and two sources
of truth about which stages belong to which bills is how the wrong one gets used.

**Cost, stated honestly.** Nothing is populated. Five Stage 1 dates from the
Official Report and 62 passing dates is the whole of the stage data in existence,
and it sits in `bill_candidate`. This builds the shape that promotion writes
into, while `bill` is empty and the shape is free to change. Filling it is
expected to be gradual — from the PhD, from the Official Report, and from the
Parliament's API — which is the working assumption for this project generally
rather than a caveat about this decision.

## 2026-09-10 — `stage_event` is kept: Private Bills are the reason that was waiting to appear

`db/004` moved stage dates onto the bill row and left `stage_event` in place but
empty, with the instruction to drop it "unless a reason to keep it appears".
`db/017` drops the other empty table, `scratch_test`, and deliberately leaves
this one. This entry records the reason, so the instruction is answered rather
than quietly ignored.

**Private Bills do not have Stages 1, 2 and 3.** They have Preliminary,
Consideration and Final. Session 1 contains three of them — one passed, two
fell — and the one that passed currently has its Final Stage date sitting in a
column named `end_stage_3_date`. The column does not mean what its name says for
those rows. Later sessions have more.

Three columns on the bill row cannot express this. `stage_event` was built with
`stage_order` precisely so that a Private Bill's third stage could be compared
with a public bill's third stage without asserting that they are the same stage.
It also distinguishes a stage *reached* from a stage *completed*, which a bare
date column cannot: a bill sitting in Stage 2 at dissolution has no Stage 2 date
and that is not the same as never having got there.

**Why this matters now rather than later:** the second question in the first
slice is time taken to complete each stage. It is not a future concern that
Private Bills have different stages; it is a mis-description already present in
Session 1's data.

**Not resolved here.** Keeping the table is not a decision to use it. The
options — name the columns generically, record a stage vocabulary per bill type,
or populate `stage_event` after all — are open, and are recorded as **D6** in
`STATE.md`. Dropping the table would have quietly foreclosed the third option
and removed the artefact that best explains the problem.

## 2026-09-10 — A new variable stages in one field-level table, never as a new column on `bill_candidate`

**Replaced on 2026-09-11** by "Each clean tab has a staging sheet of the same
shape". Kept for its reasoning, which is partly carried forward: a staging
sheet's shape follows what arrives in it.

Settled in answer to "when I want to add procedure later, where does it go?"
Nothing is built for it yet; this records the shape so the first case does not
have to invent one under pressure.

**`bill_candidate` is not the staging table. It is the *factsheet* staging
table.** Its `raw_*` columns are the factsheet's own columns and its unique key,
`(session_number, raw_section, raw_title)`, is a factsheet address. Its shape
belongs to its source.

**So the split is by how a fact arrives, not by which variable it is.**

- *Arriving as whole bills* — another session's factsheet, later the API. That is
  row-shaped, and stages in a table shaped like that source.
- *Arriving one field at a time about bills that already exist* — `procedure`,
  member in charge, party. That stages in a single field-level table: which bill,
  which field, the proposed value, the source's own words, where it came from,
  when it was read, and the same `review_status` gate. Adding procedure means
  adding rows to it. Adding party later means adding rows to the same table.

**Why not a column on `bill_candidate`.** No factsheet states procedure. A column
there would sit empty across all ~473 rows and would make the table a less
honest record of what SPICe said — which is the job `DECISIONS.md` gives it when
it says the table is kept permanently as provenance.

**Why not a table per variable.** They would all carry the same handful of
columns and each would need its own near-identical promotion step.

**`bill` itself is where a column does get added,** and `procedure` is already
there, nullable and empty, waiting for evidence — which is what `db/010` set it
up to be. `field_source` is the admitted half of this and already exists; what is
missing is the candidate half in front of it.

## 2026-09-10 — The database is dumped into the backup path, and a restore is tested rather than assumed

`db/016` and the amended `/usr/local/sbin/legdata-backup`.

Between the 2026-09-09 clearance and today, **nothing backed up the database.**
The nightly job took `/etc` under the `system` tag and skipped its `data` tag
every night, because `/srv/legdata` no longer existed and the script treats that
absence as normal. PostgreSQL's own files were in scope for neither. The machine
was rebuildable and the data was not, for a project whose first principle is that
the database is the product. A day of hand-coding existed in one place.

**Why a dump into the existing path rather than new machinery:** retention,
verification, encryption and off-site transport to the storage box were all
already built and working. The only missing step was putting the data where they
could see it.

**A backup is not a backup until it has been restored.** Exit status zero proves
a script ran, not that anything can be recovered. The chain was tested end to
end — snapshot fetched back from the storage box, restored into a scratch
database, checked for the expected 73 candidates and that day's edits, scratch
database dropped. The restore procedure is written down in the server notes,
which moved out of this repository on 2026-09-11 and are at
`~/.claude/legdata-vps-notes.md`; it is worth nothing if it is only ever
reconstructed from memory during an emergency.

## 2026-09-10 — Admission to the gateway is recorded as a migration

`db/016` sets Session 1's 73 candidates to `accepted`, rather than that being
typed into a client.

**Why:** `review_status` is the gateway. If the record of what was admitted, and
on what basis, exists only in a database client's query history, then the single
column the architecture depends on is the one with no provenance of its own.
`db/010` set the precedent by carrying its own data fix.

The migration also refuses to admit anything while `v_candidate_problems` is
non-empty. "Work the list to empty before promoting" was an instruction in a
document; it is now a precondition that cannot drift away from the instruction.

## 2026-09-10 — `date_concluded` restored; Act titles accepted in `short_title`

Two questions raised by the Session 1 extraction, settled at the close of that
session. `db/013`.

**`date_concluded` returns to `bill`.** `db/004` dropped `date_outcome` on the
reasoning that for a bill that passed or was defeated the outcome date is the
Stage 3 date. That is true for the 62 Session 1 Acts and false for the other 11:
a bill that was withdrawn or fell has a date that is not a stage completion, and
it had nowhere to go. The new column is narrower than the one dropped — it holds
only that case, and a `CHECK` keeps it empty for a bill that passed, so it cannot
drift back into being a second, competing outcome date.

**`short_title` carries the Act title where a bill was enacted.** VARIABLES §3.2
defines it as the title as introduced, and for 62 of 73 Session 1 rows it is not.
Sourcing the introduced titles separately was rejected as disproportionate for
the first slice. Instead the divergence is published, as methodology note M3, and
`bill_candidate.title_kind` records which kind of title each row carried, so the
choice is visible per row rather than assumed.

**Why publish rather than fix:** a title, the styling of the bill type, and the
Session 4 `G*` marker are three instances of the same thing — a value that
differs between introduction and passage. The slice does not need any of them
resolved; it needs them not to be silent. VARIABLES §3.2 should be amended to
match.

## 2026-09-10 — Factsheet rows are extracted into staging and admitted by review

Amends, and does not reverse, the hand-entry decision below. Extraction writes to
`bill_candidate`; nothing reaches `bill` except by review and explicit promotion.

**Why:** the hand-entry decision gave three reasons. The first — that parsing
seven read-once documents costs more than reading them — is weakened: the
factsheets are Word-generated with a clean text layer, sessions 1-5 are ruled
tables and 6-7 a fixed prose grammar, and there are ~473 bills rather than a few
dozen. The second — that PDF extraction fails quietly — is answered here
specifically, because each factsheet prints its own outcome-by-type cross-tab,
so an extraction can be checked against the source's own arithmetic before
anyone reads a row. The third reason is untouched and is why this is an
amendment rather than a reversal: the factsheets are *derived*, the outcome
coding is SPICe's judgement, and reading it is how a divergence from the thesis
gets noticed. Under this decision the reading still happens, at the gateway, on
a populated row instead of an empty one.

**The gate has already earned itself.** Sessions 1 and 2 reconcile exactly.
Sessions 3, 4 and 5 come up short by 2, 14 and 6 rows, because pdfplumber
fragments tables that break across a page and a data row is consumed as a
header. None of it reached `bill`.

**Consequence:** `bill_candidate` is kept permanently, not cleaned out. It is the
provenance — `promoted_bill_id` ties every admitted bill to a page and to the
factsheet's verbatim words; it is how a reissued factsheet is diffed against what
was admitted; and it is the reference dataset automation is later measured
against. Rejected candidates stay, with `review_note` recording the judgement.

## 2026-09-10 — `procedure` is nullable; 'standard' is a finding, not a default

`bill.procedure` was `NOT NULL DEFAULT 'standard'`. Both dropped in `db/010`.

**Why:** no source consulted so far states procedure — the factsheets have no
such column. The default recorded four Budget Acts and the Mental Health (Public
Safety and Appeals) Act 1999 as standard procedure as a positive fact, on no
evidence. Null now means not known, and 'standard' is something established.
Same distinction `party` already draws between null and Independent.

## 2026-09-10 — The stated bill type is recorded alongside the normalised one

`bill.bill_type_stated` references a separate `ref_bill_type_stated`.

**Why:** researchers will want the Executive/Government split, and it is cheaper
to capture on the way past than to reconstruct. A separate lookup rather than
adding 'executive' to `ref_bill_type`, because a value in the research vocabulary
would appear in outcome-by-type cross-tabs and split the government series —
which is what D4 exists to prevent.

**It cannot be derived.** The changeover is not the 2007 renaming of the Scottish
Executive. The Session 4 factsheet marks bills `E`, `G` and `G*`, the last
footnoted 'Introduced as an Executive Bill (E)', for bills introduced in 2011 and
2012. Sessions 1-3 are `E` throughout, session 5 onward `G`. So the label follows
neither the session nor the introduction date, and has to be recorded as stated.
`bill_type_stated` means as introduced, so `G*` is 'executive'.

## 2026-09-10 — Methodology notes are data, not prose in the repository

`methodology_note` holds the text of each value judgement; the front end reads it
and shows it against the variables named in `applies_to`. The wording is seeded
by a migration, so it stays version-controlled.

**Why:** the two judgements in the first slice — counting Executive Bills as
Government Bills, and treating the date passed as Stage 3 completion — are both
defensible and both invisible in the numbers. A note kept only in the repository
drifts from what the site shows. `DECISIONS.md` records that a decision was taken
and why; `methodology_note` records what a reader of the data must be told. They
are different documents with different audiences.

## 2026-09-10 — The database is the product; sources are candidates

Nothing is written as fact by any process. Every source produces a candidate
that is checked before admission, whatever the source. Automation, when it
comes, proposes rather than writes.

**Why:** previous attempts let extraction write directly, so an unbounded
residue of edge cases sat on the critical path. Under a gateway, partial
automation is still useful and failed automation costs nothing.

## 2026-09-10 — First slice: outcome by bill type, and time per stage

Across all sessions. Nothing else — no member in charge, party, votes or text.

**Why:** the minimum most users want, buildable by hand in about a day, and
therefore usable as the reference dataset that later automation must reproduce.

## 2026-09-10 — Hand-build before automation

The first slice is entered by hand. Automation is attempted afterwards and is
accepted only if it reproduces the hand-built values.

**Why:** the failure mode is chain length — variable to source to assessment to
edge cases to gaps to reconciliation, with no checkpoint. Hand-building produces
both a ground truth and a written list of the real edge cases, which converts an
open-ended judgement problem into a pass/fail one.

## 2026-09-10 — PostgreSQL on the VPS, reached over SSH

Data lives on the VPS from the start, not locally. Postgres 17 listens on
loopback only; clients tunnel in over SSH.

**Why:** starting on the server avoids a migration later and means there is one
copy of the truth. Loopback plus tunnel keeps port 5432 off the public internet
and leaves the existing firewall untouched.

## 2026-09-10 — SSH forwarding relaxed, pinned to the database port

`AllowTcpForwarding local` with `PermitOpen 127.0.0.1:5432`, replacing
`AllowTcpForwarding no`. Original config kept as `.pre-db-tunnel.bak`.

**Why:** DBeaver needs a tunnel, and the alternative — exposing 5432 through the
firewall — means a public database, TLS to configure, and a rule that breaks
whenever the client IP changes. `PermitOpen` means the relaxation reaches
Postgres on loopback and nothing else.

## 2026-09-10 — D1 settled: outcome and enactment are separate variables

`outcome` records what Parliament did; `enactment_status` records whether the
bill became an Act.

**Why:** passing and becoming law are different events, and the gap between them
is of research interest — a bill can pass and be referred, or pass and be
blocked from assent. A single combined list makes those cases unfindable and
turns "how many bills passed?" into a sum over several values.

**Reversing it:** a combined view over the two columns, or a generated column.
No data would need re-entering.

## 2026-09-10 — D4 settled: bill type and procedure are separate variables

`bill_type` is who introduced it; `procedure` is how it was handled.

**Why:** an emergency bill is a government bill that compressed its stages. In a
single list it stops counting as a government bill. This matters directly for
slice 2, where emergency and budget bills complete in days and would otherwise
distort every duration average.

**Reversing it:** `coalesce(nullif(procedure,'standard'), bill_type)` gives the
combined list as a view.

## 2026-09-10 — Vocabularies as lookup tables, not Postgres enums

Each controlled vocabulary is a `ref_*` table with a readable text code, and
columns carry the code as a foreign key.

**Why:** values can be read, added and re-labelled in the grid without writing
DDL, each value carries its own definition, and `bill.bill_type` displays
'government' rather than an integer that needs a join to interpret. Postgres
enums require `ALTER TYPE` and cannot drop a value.

## 2026-09-10 — Postico 2 as the entry client

Chosen over DBeaver, which stages grid edits behind an explicit save and caused
changes to appear made when they had not been sent.

**Why:** it writes on leaving a row, which is the spreadsheet behaviour wanted,
and it is a desktop client rather than another service to run and secure. Both
data and DDL changes were verified reaching the VPS independently.

## 2026-09-10 — Stage end dates live on the bill row

`date_outcome` dropped. `end_stage_1_date`, `end_stage_2_date`,
`end_stage_3_date` and `reconsideration_stage` added to `bill`. The duration
views read from these rather than from `stage_event`.

**Why:** a bill becomes one line to type, which is what a hand-build needs. The
outcome date was redundant once the stage dates exist — for a bill that passed
or was defeated it is the Stage 3 date.

**Consequence:** `stage_event` is now unused. It is left in place but empty, and
should be dropped unless a reason to keep it appears. Anything needing more than
a date per stage — committee, votes, amendments — is a later slice and would
justify bringing it back.

## 2026-09-10 — Party as a lookup, null distinct from independent

`bill.party` references `ref_party` and is nullable.

**Why:** null and Independent mean different things. Null is "not applicable or
not known" — which covers law officer bills, where no member is attached.
Independent is a positive fact about a member who sits without a party. A single
text field would blur the two on entry.

## 2026-09-10 — First-slice data entered by hand from the SPICe factsheets

Not parsed programmatically. `ref_source` gains `spice_factsheet`; rows taken
from a factsheet record it as their source, with session and retrieval date in
`source_ref`.

**Why:** parsing seven documents that are each read once costs more than reading
them, and PDF extraction fails quietly — a shifted column, a footnote absorbed
into a cell. It would rebuild the long unchecked chain the project exists to
avoid. The factsheets are also *derived*: the outcome-by-type coding is SPICe's
judgement, and reading it surfaces where it differs from the thesis where a
parser would silently adopt it.

**Where automation does belong:** reconciling entered totals against the
factsheet's own stated counts. Session 6 states 82 bills, 62 Government, 20
Member's, 52 Acts, 4 withdrawn as at 6 March 2026. Cheap arithmetic checks that
catch a mistyped row without re-reading the PDF.

**Evidence for the caution:** the factsheet path serves soft 404s — HTTP 200
with an HTML error page for files that do not exist. A first automated sweep
"found" seven factsheets; five were error pages.

## 2026-09-10 — Provenance per field, and D5 settled with it

`field_source` records the source of an individual field where it differs from
the row-level source. Append-only, with `value_seen` holding the value in the
source's own words.

**Why:** one source per row is insufficient — a bill's outcome will come from a
factsheet while its dates come from the Official Report, and that is the normal
case rather than the exception. `docs/VARIABLES.md` originally argued for
row-level only; that was wrong and has been rewritten.

**This settles D5.** Because the table is append-only, a revised published
record produces a second observation rather than overwriting the first, so the
change is visible. `v_field_revisions` lists fields whose value has changed.

**Not required for the first batch.** The row-level source remains the default
and is enough while a whole row comes from one factsheet. `field_source` is
there for when that stops being true.
