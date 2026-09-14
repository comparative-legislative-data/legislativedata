# Closure tests

A session's data is not finished because the session that loaded it says so.

**The procedure**, settled with the owner on 2026-09-12 after a session declared
Sessions 1 and 2 finished against a test it had set itself, and moved on:

1. The session that proposes an ingest is finished **writes the test**. It does
   not run it and does not mark it.
2. **A different session runs it**, and reports every answer against the
   expected one.
3. Every item is one of two kinds: **mechanically checkable**, where the answer
   is a count or a yes/no out of the database and nobody has to form a view; or
   **the owner's sign-off**. Nothing in between. If an item needs someone to
   judge whether something is good enough, it is a sign-off.
4. Each expected answer **says where the expectation comes from**. An expected
   answer taken from the database it is testing proves nothing.
5. Each test says **what it does not check**, so nobody reads a pass as more
   than it is.
6. **A test inherits, and is not re-argued.** Settled by the owner on
   2026-09-12, when Sessions 1 and 2 closed. A session's test covers that
   session: what it brought in, and the corrections and adjudications made for
   it. What an earlier session's test already settled is not put again, unless
   something has actually changed — and the test says which of its items an
   outside change can move, so a later session can tell. For Sessions 1 and 2
   that is item 19, the dataset's fingerprint: correcting the dataset for a
   later session moves it, and only that item is then checked again.

There is no universal test. Each ingest gets its own, newest first below.

---

## Carried-over bills, and the blocked-bill record

Written 2026-09-14 by the session that built the change, which may therefore not
run it. Every item below asks about a rule that session added, and a session may
not mark the check on a rule it added itself (`DECISIONS.md`, 2026-09-14).

This is not a session ingest. It is a change to how data is coded, made before
Session 6 is loaded, and it touches five bills. It is here because it added
rules, and rules need marking by somebody else.

**The change, in one line:** a fact sheet row that is a further appearance of a
bill already on the clean sheet now lands on that bill instead of making a
second one; a bill stopped before Royal Assent now records how and what
followed; and the Robin Rigg Act now says whose scrutiny it carried. See
`DECISIONS.md`, 2026-09-14, and `db/080`–`db/085`.

**All items are mechanical.** Nothing here needs the owner's judgement, because
nothing here is new data: the section 33 route is read from a footnote already
on the staging sheet word for word, and the Robin Rigg dates are already on the
clean sheet. What the owner has already agreed is the design, and that agreement
is recorded in `DECISIONS.md`.

**Where the expectations come from.** Items 1–4 from the Session 5 and Session 6
fact sheets and the Session 1 bill's own stage records, all quoted in
`DECISIONS.md`. Items 5–12 from the migrations' stated intent, checked against
behaviour rather than against the migrations' account of themselves. Item 13
from the figures read out of the database on 2026-09-14 and recorded in M9.

### Part A — the values

1. **Exactly three bills carry the blocked record**, and they are bills 303, 304
   and 305. Each has `assent_block_route` = `s33_reference` and
   `assent_block_outcome` = `still_blocked`, `outcome` = `passed` and
   `enactment_status` = `blocked`. Bills 303 and 304 have
   `date_assent_blocked` = 2021-10-06; bill 305 has none, because its footnote
   gives none.

2. **Each of those three carries the fact sheet's footnote as the provenance of
   `assent_block_route`**, word for word, cited to the Session 5 legislation
   fact sheet and read on 2026-09-10. Read the three notes out in full and
   confirm each begins "Following a reference under section 33 of the Scotland
   Act 1998 by the Attorney General and the Advocate General for Scotland" and
   ends in a full stop.

3. **Exactly one bill says whose scrutiny it carried**: bill 124, the Robin Rigg
   Act, pointing at bill 71. Bill 71 is a Session 1 bill introduced 27 June
   2002; bill 124 was introduced 15 May 2003.

4. **The Robin Rigg Act's two empty stage rows each name their own stage.** Read
   both in full. The Preliminary row ends "The Session 1 bill's Preliminary
   Stage was on 9 January 2003." and the Consideration row ends "The Session 1
   bill's Consideration Stage was on 11 March 2003." Both dates match bill 71's
   own stage records. No other stage row in the database is marked as a stage
   that never happened.

### Part B — the rules on the clean sheet bite

Each item plants the fault inside a transaction that is then thrown away, as
`db/062` and `db/078` proved theirs. Expected: every one is refused.

5. **`bill_block_cells_are_filled_together`.** Empty `assent_block_route` on
   bill 303 and leave `assent_block_outcome`; then the reverse.

6. **`bill_only_a_passed_bill_can_be_blocked`.** Put the block cells on a bill
   whose outcome is `fell_dissolution`.

7. **`bill_blocked_says_still_blocked`, both ways.** Set bill 303's
   `enactment_status` to `enacted` while it still says `still_blocked`; then set
   `assent_block_outcome` to `withdrawn` while `enactment_status` is `blocked`.

8. **`bill_reconsidered_and_passed_is_enacted`.** Set bill 303 to
   `reconsidered_passed` without making it enacted.

9. **`bill_not_reintroduced_from_itself`.** Point bill 124 at bill 124.

### Part C — the rules on the staging sheet bite

Each plants the fault on a staging line inside a transaction that is thrown
away, and reads `v_candidate_problems`. Expected: each names the fault, and the
checker is empty again afterwards.

10. **A line introduced before its own fact sheet's session began, and not
    saying which bill it is.** The message must name `continues_bill_id`. Then
    set `continues_bill_id` and confirm the complaint goes, and that "passed
    after the session ended" and "concluded after the session ended" do not
    fire on a line that carries dates outside its fact sheet's session.

11. **A line continuing a bill that is not there, a bill introduced on a
    different day, and a bill of the same or a later session.** Three separate
    faults, three separate messages.

12. **The block cells on a staging line**: one filled and one empty; a value not
    in its list; `blocked` with nothing saying what followed; `still_blocked`
    with an enactment status that is not `blocked`; `withdrawn` with no
    concluding date; a Reconsideration Stage row with no cell saying it was
    reconsidered, and a cell saying so with no row; and a stage marked as never
    having happened on a line that names no earlier bill.

### Part D — promotion and rollback

13. **A further appearance updates and does not insert.** Plant one Session 6
    staging line for the European Charter Bill with `continues_bill_id` = 303,
    a Reconsideration Stage row, and a Stage 3 row restating the Session 6 fact
    sheet's "Passed on 23 May 2021". Promote Session 6. Expected: the bill count
    does not move; bill 303 gains the Reconsideration Stage; **its Stage 3 stays
    23 March 2021**, because a further appearance never overwrites a stage that
    is already there; the line is stamped with 303; and each changed cell
    carries a note naming the Session 6 fact sheet, while `assent_block_route`
    still carries the Session 5 footnote.

14. **Rollback restores it exactly.** Take Session 6 off. Expected: bill 303
    comes off with it, the script says to promote Session 5 again, and after
    promoting Session 5 the bill is identical to what it was before item 13 —
    every cell, and its three stage records. Compare cell by cell, not by count.

15. **Taking a session off in the wrong order is refused, and says which.** With
    Session 6 on the clean sheet, try to take Session 5 off. Expected: refused,
    naming Session 6. Then try to take Session 1 off with Session 2 on the clean
    sheet. Expected: refused, naming Session 2.

### Part E — nothing else moved

16. **The counts.** 389 bills, 1071 stage records, 112 provenance notes. The
    error checker and the gaps list are both empty. Provenance was 106 before
    this change and 112 after, the six being the two block cells on each of the
    three bills.

17. **Sessions 1 to 5 are as they were**, apart from the five cells this change
    filled. Take a copy of `bill` and `stage_event` before the change from the
    commit before `db/080`, and compare row by row.

18. **M6 and M9 read as written.** Read both out in full. M6 gives the test —
    did the first bill end? — both answers, and the arithmetic: 474 rows, 473
    counted, 470 distinct bills, and 73, 81, 62, 86, 87, 80, 1 per session
    against the fact sheets' 73, 81, 62, 86, 87, 82, 2. M9 gives 42, 132, 274
    and 364 days. Check the four figures in M9 against the database, and the
    per-session figures in M6 against the fact sheets.

### What this test does not check

- **Anything about Session 6's actual contents.** No Session 6 row has been
  read in. Item 13's staging line is a fixture built by hand from the fact
  sheet's printed words, and its Act title and number are invented, because
  reading them off legislation.gov.uk is part of loading Session 6.
- **That the European Charter Bill's Act title and number are what we will
  record.** The Session 6 fact sheet prints neither: it lists the bill in its
  Acts table under the bill's own title with an SP number. They are to be read
  from legislation.gov.uk when Session 6 is loaded, as the Period Products and
  Higher Education Acts' were.
- **That `s35_order` works on a real bill.** No bill in the database was stopped
  by a section 35 order. The Gender Recognition Reform Bill is a Session 6 bill
  and is not loaded.
- **That `reconsidered_fell` works on a real bill.** No bill has ever done it.
- **Whether the design is right.** That is the owner's, and was agreed on
  2026-09-14 before any of it was built.

---

## Session 5

Written 2026-09-14 by a session that did none of Session 5's work: it did not
read the fact sheet in, did not build the review, did not admit it and did not
promote it.

**Part A run on 2026-09-14** by a further session, which did none of Session 5's
work and did not write this test. **Twenty-eight of the thirty items answered as
expected. The two that did not are the two this test predicted would not**: item
9, the Period Products Act's title, and item 15, M7 a session out of date. Both
were put right by `db/078` on the owner's decision the same day, and items 1, 5,
9, 14, 15 and 26 were re-run against the expectations written above — the
movements are marked **[moved by db/078]** where they occur. Nothing else in the
run changed by a single cell.

**One prediction resolved, and it was prose and not data.** Item 24's three
shortest roads read 1, 9 and 22 days, which are the fact sheet's own dates. The
session that promoted Session 5 had reported 1, 27 and 28. No bill's Stage 3
date on the clean sheet is wrong.

**Item 31 was added after that run** — it is the check on the rule `db/078`
itself added, which the session that added it was not allowed to mark. **It was
run on 2026-09-14 by a third session**, which added nothing to the database, and
**all four of its parts answered as expected**.

**Item 32 was added by that same third session.** While the owner was reading
Session 5's three Official Report notes for sign-off 2, eight notes across
Sessions 4 and 5 turned out to end mid-sentence. `db/079` mended them and added
the rule; item 32 asks that rule from outside. **It was run on 2026-09-14 by a
fourth session**, which added nothing to the database and did not write it, and
**all six of its parts answered as expected**.

**Part A is thirty-two items, and all thirty-two are answered as expected.**

**Part B is complete.** All nine sign-offs were given by the owner on 2026-09-14,
and are recorded below on the day they were given and nowhere else.

**Session 5 is closed**, on 2026-09-14, on the whole of Part A and the whole of
Part B. No item of this test is outstanding.

**Session 5 was already on the clean sheet when this was written, and had been
marked closed by the session that promoted it.** That is the thing the procedure
at the top of this file exists to prevent, and it is the second time it has
happened — Sessions 1 and 2 on 12 September were the first. The mark was wrong
and has been taken off; `STATE.md` now reads `next: closure test` for Session 5,
as it did for Session 4 between promotion and marking.

**What that costs, and what takes its place.** Sessions 3 and 4 had their tests
written while the session was still off the clean sheet, so an expected answer
could not have been copied out of the data even by accident. That protection is
not available here. In its place, every expected answer below says where it comes
from, and the sources are these, none of them the database:

- **a fresh extraction of the Session 5 fact sheet**, run on 2026-09-14 from
  `sources/factsheets/spice-legislation-session-5_retrieved-2026-09-10.pdf` with
  nothing supplied to the reader but the PDF and the session number;
- **the owner's dataset**, read directly out of the workbook — row counts, which
  bills carry which stage dates, and the file's own fingerprint;
- **`db/071` to `db/077` and the decisions they record**, which is where the
  review's codings, adjudications and agreed wordings live;
- **Session 4's closed test**, for anything covering the whole clean sheet that
  Session 5 does not move.

Where a figure could only have come from the database, the expected answer says
so and is not dressed up as a prediction. There are two: the lengths of the six
methodology notes Session 5 leaves alone, which are quoted from Session 4's test,
and nothing else.

**When to run it.** Now. Session 5 is on the clean sheet with its Stage 1 and
Stage 2 dates on it, which is the state these answers describe.

### What writing this test turned up — three things, all settled on 2026-09-14

**All three were put to the owner when Part A was reported, and all three were
agreed and built the same day.** What follows is as it was written, because it
is the account of what the test was for; each is marked with what was decided.

None is a matter of opinion about the data; each is a place where Session 5 was
handled differently from Session 4 under a rule that has not changed. **They are
put to the owner rather than fixed by the session that found them**, and the
items they affect are marked below, so that a failure is read as the known thing
and not as a discovery.

**1. The Period Products Act's title has no year in it, and its number does.**
The fact sheet prints the title as "Period Products (Free Provision) (Scotland)
Act (asp 1)", with no year anywhere in it. `db/073` settled the number at
legislation.gov.uk as `2021 asp 1` and left the title as the fact sheet printed
it. Session 4's equivalent was settled both ways: the Higher Education Governance
Act had **two** cells corrected, the number and the title, and Session 4's item 5
lists both, because the title is the half a reader sees. So on the same fault,
one session corrected the title and the next did not. `db/073`'s own note already
quotes legislation.gov.uk giving "Period Products (Free Provision) (Scotland) Act
2021", so the value is not in doubt and nothing needs to be looked up.

**Settled: the title carries its year.** `db/078` made the correction on the
staging sheet with its citation, and Session 5 was taken off the clean sheet and
put back so the title and its provenance note arrived by the same route as every
other admitted fact. It also added the rule that would have caught it: the error
checker now asks an Act's title for its year as it already asked the number.
**Item 14 moves too, which this paragraph did not foresee.**

**If the owner agrees the title should carry its year, items 1, 5, 9 and 26 move
together**: provenance notes 105 becomes 106, item 5 gains a `short_title` /
`legislation_gov_uk` row taking that pairing from 1 to 2, item 9's
`acts_whose_title_has_no_year` becomes 0, and item 26 gains a tenth cell that
must differ from a fresh reading. Nothing else is affected. **If the owner
decides the fact sheet's title stands**, item 9's expected answer becomes 1 with
a reason recorded here, and Session 4's handling is the one that needs revisiting
— not this one.

**2. M7 says the coding of why a bill fell has been done for four sessions.**
Five have now been coded: Session 5's seven fallen bills were split into three
rejected at Stage 1 and four out of time on 14 September. This is exactly what
`db/070` had to fix at Session 4's closure, when M7 still said three. A published
note saying less than the data holds is the fault `db/072` was written to prevent
in M5, in the same week. Item 15 expects M7 to say Sessions 1 to 5 and is
predicted to fail until a migration puts it right. **Settled: `db/078` put it
right, in the two sentences db/070 had to change at Session 4's closure.**

**3. The explainer contradicts itself on how many provenance notes there are.**
`docs/HOW-THE-DATABASE-WORKS.md` §3 says "The tab holds 86 notes in all: 72 about
bills, 13 about the sessions' own dates, and 1 about a stage", and §4 of the same
document says ninety-one, counting Session 5's nineteen. The second is current
and the first is a session behind: 105 in all, 91 about bills. **Part B item 9
cannot be put to the owner until that is fixed**, because it asks them to explain
the database from that document. **Settled: both passages were corrected on
2026-09-14, after the title correction moved the figures again — 106 in all, 92
about bills (22, 20, 15, 15 and 20 by session), 13 about the sessions' own dates
and 1 about a stage, every figure read back out of the database. Part B item 9
can now be put.**

**The one item an outside change can move** is item 27, the dataset's
fingerprint. Nothing else here is reopened by later work, and the three things
above are not outside changes: they are this session's own business.

### Part A — mechanical

Run `tools/closure_check_session_5.sql`. It reads only and changes nothing.
Compare each numbered result against the expected answer.

**1. Counts.** bills 389, stage_records 1071, provenance_notes 105,
checker_problems 0, gaps 0, staging_lines 389, stage_date_rows 1071.
**[Read exactly that. Moved by db/078: provenance_notes 106.]**

- **389** is 302 plus 87. The 87 is the Session 5 fact sheet's own summary total,
  and the fresh extraction produces exactly 87 lines from the PDF.
- **1071** is 828 plus Session 5's 243, and the 243 is a derivation to be checked
  rather than a number to be accepted: 78 bills passed — 75 Acts plus the 3 the
  fact sheet lists as awaiting Royal Assent — and each has three stages, which is
  234; the 3 rejected at Stage 1 have one each, which is 3; the 6 that ended
  where they stopped have one each, which is 6. 234 + 3 + 6 = 243. Every figure
  in that sentence is off the fact sheet.
- **The same 1071** for stage_date_rows. Every accepted stage-date row is carried
  to exactly one stage record, so with the whole of Session 5 promoted the two
  counts are equal. They are not equal at any point when a session is half on.
- **105** is 86 plus 19, and the 19 is derived from what
  `tools/promote_session.sql` writes a note for, against what Session 5's review
  actually settled: 3 outcomes read in the Official Report and 3 Stage 1
  rejection routes from the same pages (`db/073`); 4 bills coded as having fallen
  at dissolution, whose note is the rule and not a quotation; 3 notes on
  `enactment_status`, one per blocked bill, carrying the fact sheet's footnote as
  the words that were seen; 2 on `date_assent_blocked`, because only two of the
  three footnotes give a date; and 4 cells checked at review — two Royal Assent
  dates at legislation.gov.uk, one introduction date at the Parliament's bill
  page, and the Period Products Act's number (`db/073`, `db/074`).
  3 + 3 + 4 + 3 + 2 + 4 = 19. **This is one of the two places the title question
  bites:** correcting the title makes it 20 and the total 106.
- **0 and 0 are the rule**, for the session and for everything before it.

**2. Every staging line reviewed, admitted, on the clean sheet and compared.**
Session 1: 73 accepted, 73 promoted, 73 compared. Session 2: 81, 81, 81.
Session 3: 62, 62, 62. Session 4: 86, 86, 86. Session 5: 87, 87, 87. No other
review status appears in any session. From the fact sheets' own totals and the
rule that nothing reaches the clean sheet unaccepted.

**3. Every stage-date row.** Session 1: 200 accepted, 200 carried. Session 2:
213, 213. Session 3: 170, 170. Session 4: 245, 245. Session 5: 243, 243. No
other status. Sessions 1 to 4 are from their own tests; Session 5's 243 is item
1's derivation.

**4. A recorded difference with no adjudication.** 0. Session 5 recorded three —
two Royal Assent dates and the Solicitors Bill's introduction date — and all
three were settled on 14 September, each with a `Checked:` line beside the
`Differs:` line (`db/074`).

**5. What has been checked against the source that owns it.**

| Field | Source | Cells |
|---|---|---|
| `asp_number` | `legislation_gov_uk` | 3 |
| `bill_type` | `bill_page` | 1 |
| `date_assent_blocked` | `spice_factsheet_legislation` | 2 |
| `date_completed` | `bill_page` | 1 |
| `date_first_meeting` | `spice_factsheet_dates` | 7 |
| `date_introduced` | `bill_page` | 6 |
| `date_introduced` | `manual` | 1 |
| `date_royal_assent` | `legislation_gov_uk` | 13 |
| `date_session_end` | `spice_factsheet_dates` | 6 |
| `enactment_status` | `spice_factsheet_legislation` | 3 |
| `outcome` | `official_report` | 24 |
| `outcome` | `spice_factsheet_dates` | 14 |
| `short_title` | `legislation_gov_uk` | 1 **[db/078: 2]** |
| `short_title` | `manual` | 1 |
| `stage_1_rejection_route` | `official_report` | 22 |

That is Session 4's table with Session 5's nineteen added, and it sums to 105.
**Two of the pairings are new to the database**: a bill's `enactment_status` cited
to the legislation fact sheet, and `date_assent_blocked` to the same. Both exist
because the fact that stopped these bills is printed in a footnote rather than in
the row, so the only place the source's own words can live is a provenance note.
**If the title is corrected, `short_title` / `legislation_gov_uk` becomes 2.**

**The nineteen Session 5 cells are then listed in full.** Nineteen rows, not
eighteen and not twenty. **[Read nineteen. Moved by db/078 to twenty, the
twentieth being the Period Products Act's title.]** Two of the blocked bills carry the same footnote twice
over — once against the status and once against the date — which is not
duplication: they are provenance for two different cells. The UK Withdrawal Bill
has the status note only, its footnote giving no date. Every one of the nineteen was read on
2026-09-14.

**6. Reconciliation.** Our counts must match the fact sheet's own summary in
every cell and both margins. These figures are from the fresh extraction of the
Session 5 fact sheet, not out of the database:

| Session 5 | Government | Member's | Private | Committee | Total |
|---|---|---|---|---|---|
| Acts of the Scottish Parliament | 60 | 7 | 5 | 3 | 75 |
| Bills awaiting Royal Assent | 2 | 1 | 0 | 0 | 3 |
| Bills withdrawn | 1 | 1 | 0 | 0 | 2 |
| Bills fallen | 0 | 7 | 0 | 0 | 7 |
| **Total** | **63** | **16** | **5** | **3** | **87** |

The script's rows are `acts`, `awaiting_assent`, `withdrawn` and `fallen`, and
its `government_or_hybrid` column answers the fact sheet's "Government".
**This is the first reconciliation with four rows**, and the first in which our
`passed` is two of the fact sheet's tables added together: 75 Acts plus 3
awaiting. A three-row answer means the fourth table has not been read.

**On `bill_type` alone**: government 63, members 16, private 5, committee 3 —
**identical to the table above**, because Session 5 has no Hybrid Bill. A hybrid
appearing here means the reader has typed something `H` that the fact sheet does
not.

**7. Outcomes.** passed and enacted 75; passed and blocked 3; rejected at Stage 1
3, not enacted; withdrawn 2, not enacted; fell at dissolution 4, not enacted.

The fact sheet gives the row totals only — 75 Acts, 3 awaiting Royal Assent, 2
withdrawn, 7 fallen. Splitting the 7 into 3 + 4 is ours, methodology note M7:
three from the Official Report of the day, four from the day the session ended.
**No Session 5 bill was rejected at Stage 3, none fell for want of a financial
resolution, and none is recorded as pending**; those three values should not
appear. `pending` in particular is the value the fact sheet's own table heading
proposes and the footnotes refuse: see `DECISIONS.md`, 2026-09-14.

**8. Required cells.** Every column 0.

The second line is the cells the fact sheet does not fill: **no_sp_bill_number
75**, has_a_procedure 0, has_a_title_as_introduced 0. The Session 5 fact sheet
prints an SP Bill number for the twelve bills that did not become Acts — the
nine that did not pass and the three stopped before Royal Assent — and for none
of the 75 Acts, which the fresh extraction confirms cell by cell. A smaller
number here means a bill number has been invented.

**9. Every Session 5 Act.** 75 enacted, 0 without an asp number, 0 without an
assent date, 0 where the asp number's year disagrees with the assent year. The
75 is the fact sheet's own Acts total, and the three blocked bills are correctly
not among them: they have no number and no assent date, and they are not
`enacted`.

**And 0 Acts anywhere on the clean sheet whose number has no year** — the check
`db/062` added, which Session 5's Period Products Act was the first to trip.

**`acts_whose_title_has_no_year` — expected 0, and predicted to read 1.**
**[Read 1, and the one Act it named was the Period Products Act, as predicted.
No second name appeared. The owner settled the title question on 2026-09-14 and
`db/078` corrected it; re-run, this reads 0 and names nothing.]** This is
the title question above. The one Act it names should be the Period Products
(Free Provision) (Scotland) Act. **If a second name appears, that is not the
known thing** and is to be reported as its own finding: it would mean an Act
title has lost its year somewhere other than where the fact sheet printed it
short.

**10. Stage records per bill.** passed 3 stages × 78; rejected at Stage 1 1 × 3;
withdrawn 1 × 2; fell at dissolution 1 × 4. This is item 1's derivation seen per
bill, and the two must agree. The three blocked bills are inside the 78: being
stopped before Royal Assent takes nothing off a bill's stages.

**11. Where every Session 5 stage date came from.** `phd` 153 (all dated),
`spice_factsheet_legislation` 78 (all dated), `official_report` 3 (all dated),
`bill_page` 9 (6 undated), and nothing recorded as a stage that never happened.

- **78** is the passing date of every bill that passed, off the fact sheet: 73
  Stage 3 dates and 5 Final Stage dates.
- **153** is the owner's dataset, counted in the workbook rather than in the
  database: of its 86 Session 5 rows, 80 carry a Stage 1 date and 77 a Stage 2
  date. The three with a Stage 1 date and no Stage 2 date are the three bills
  rejected at Stage 1, whose date the Official Report already holds, so nothing
  is written for them; the six with no Stage 1 date at all are the six that
  ended where they stopped. That leaves 77 Stage 1 dates and 77 Stage 2 dates,
  less the Civil Partnership Act's Stage 2, which the bill page holds because the
  dataset had the month wrong (`db/076`): 77 + 76 = 153.
- **9** is the six undated endings, the Domestic Abuse Act's Stage 1 and Stage 2,
  and the Civil Partnership Act's Stage 2 — every one from the Parliament's own
  bill pages (`db/075`, `db/076`).
- **3** is the Stage 1 each rejected bill was rejected at.

**By position**, which is where the derivation is actually checked: `phd` 77 at
position 1 and 76 at position 2; `spice_factsheet_legislation` 78 at position 3;
`official_report` 3 at position 1; `bill_page` 7 at position 1 and 2 at position
2. Nothing at position 4: Session 5 has no Reconsideration stage, the two bills
that had one having had it in Session 6.

Across the whole clean sheet: `phd` 675, `spice_factsheet_legislation` 338,
`official_report` 29 (3 undated), `bill_page` 29 (26 undated), 2 recorded as
stages that never happened. Those four add to 1071, which is item 1's total.

**12. Two accepted rows for the same stage.** 0, in every session, and the
listing that follows returns nothing. Session 5's three Stage 1 dates come from
the Official Report, and **the dataset's dates for the same three bills agree
with it to the day** — Restricted Roads 13 June 2019, Culpable Homicide 21
January 2021, Post-mortem Examinations 26 January 2021, read in the workbook
before this test was written. The Civil Partnership Act's Stage 2 is the same
shape: the bill page holds it, the dataset now agrees since the correction, and
nothing should be written twice. A second row means the loader wrote the
dataset's date over a more primary source even though the two agree.

**13. How each Stage 1 rejection came about.** `member_motion_disagreed` 18
bills, 0 with a note for readers; `member_motion_amended_agreed` 2 bills, 2 with
notes; `committee_motion_9_14_18` 2 bills, 2 with notes. `other_route` should not
appear. The 18 is Sessions 1 to 4's 15 plus Session 5's 3, none of which needs a
reader's note: all three went the ordinary way.

The listing gives the three bills and the day each ended. Every one must have
`date_concluded` equal to its Stage 1 date and the source `official_report`:

| Bill | Route | Ended |
|---|---|---|
| Restricted Roads (20 mph Speed Limit) | `member_motion_disagreed` | 13 June 2019 |
| Culpable Homicide | `member_motion_disagreed` | 21 January 2021 |
| Post-mortem Examinations (Defence Time Limit) | `member_motion_disagreed` | 26 January 2021 |

**14. Every source on the list has a definition.** Nine sources, all true. Stage
records as item 11. `bill_rows` is `spice_factsheet_legislation` 389 and every
other source 0 — a bill's own line always comes from a legislation fact sheet.
Cells: `bill_page` 8, `legislation_gov_uk` 17, `manual` 2, `official_report` 46,
`spice_factsheet_dates` 27, `spice_factsheet_legislation` 5; `api`,
`bill_document` and `phd` 0. Those six add to 105, which is item 1.
**[moved by db/078: `legislation_gov_uk` 18, and the six add to 106. This test
did not name item 14 among the items the title question moves, and it does move
it — the same arithmetic as item 5, one row further down.]**

**`spice_factsheet_legislation` holding cells at all is new**, and it is the
footnotes: five cells, being the three blocked bills' status and the two dates.
Before Session 5 a legislation fact sheet was the source of whole lines and never
of a single cell.

**15. The notes a reader is given.** M1 to M8, eight of them, none empty.

Six are expected unchanged from Session 4's closed test, and those six figures
are quoted from it rather than derived: M1 358, M2 5140, M3 1088, M4 971, M6
1605, M8 2673. A length that has moved means somebody edited a note; find out who
and why before marking anything.

**M5 and M7 are the two Session 5 moves**, and neither is checked by its length:

- **M5** was 1940 at Session 4's test and `db/072` added two sentences to it, so
  that a reader is told the account of what became of the four blocked bills runs
  ahead of the data until Session 6's fact sheet is read in. Expected:
  `m5_counts_the_four_blocked_bills` true and `m5_says_it_runs_ahead_of_the_data`
  true.
- **M7** must say the coding of why a bill fell has been done for Sessions 1 to
  5. Expected: `m7_says_five_sessions_are_coded` true and `m7_still_says_four`
  false. **Predicted to fail on both**, which is the second of the three things
  above. **[Failed on both, as predicted, at 5003 characters. The owner agreed
  the correction on 2026-09-14 and `db/078` made it: two sentences, "Sessions 1,
  2, 3 and 4" to "1, 2, 3, 4 and 5" and "the first four sessions" to "the first
  five", M7 three characters longer at 5006. Re-run, both read as expected. The
  other seven notes did not move.]** Read the note in full: what matters is not the phrase the check looks
  for but whether a reader is told five sessions or four.

**16. Notes on the Session 5 staging lines.** 3 with a note for readers, 85 the
reader remarked on, and **at least 7 with a review note**.

- **3 notes for readers** are the three blocked bills, and nothing else: the
  three rejections took the ordinary route, which needs no explaining to a
  reader.
- **7 review notes** are lines 306, 309, 310 and 360 from `db/073` and the three
  adjudicated lines from `db/074`. **If it reads 10**, the three blocked bills
  carry one from review as well, which is likely and unobjectionable — read them
  and say so. Any other number, or a note on a line not in that list, is
  something to read out before marking.
- **85, not 87.** The two lines the reader said nothing about are the two
  withdrawn bills, the Children and Young People (Information Sharing) Bill and
  the Liability for NHS Charges Bill: neither became an Act, so there was no Act
  title to remark on, and neither fell unexplained. Session 4's single silent
  line was the same shape.

The reader's own remarks, and how many lines carry each, from the fresh
extraction:

| The reader said | Lines |
|---|---|
| title is the Act title, not the title as introduced | 72 |
| the factsheet says the bill fell and not why; outcome left for review | 6 |
| a footnote marker was removed from the word Bill; the footnote says the bill cannot be submitted… | 2 |
| title is the Act title, not the title as introduced; read from a row the factsheet split across a page | 2 |
| a footnote marker was removed from the word Bill; the footnote gives no date… | 1 |
| the factsheet says the bill fell and not why; outcome left for review; read from a row the factsheet split… | 1 |
| title is the Act title, not the title as introduced; the factsheet prints no year before the asp number | 1 |

The script truncates each to 76 characters, so the three longest collapse to
their openings; the counts are what to compare. **The three footnote remarks are
the reader deciding `blocked` rather than `pending` from the footnote's own
words**, which is the judgement `DECISIONS.md` records for 14 September, made by
the reader and not by a person.

**17. Where the Parliament changed what it called its own bills.** Government
bills by session and by how the type was styled at the time: Session 1
`executive` 51; Session 2 `executive` 53; Session 3 `executive` 44; Session 4
`executive` 15 and `government` 52; **Session 5 `government` 63 and no
`executive` at all.**

Session 4 is where the styling changed inside a session. Session 5 is the first
session with no Executive Bill in it, and the fresh extraction confirms why:
every one of its 63 government bills is typed plainly `G`, with no `G*` footnote
anywhere in the document. An `executive` count above 0 here means the reader has
carried Session 4's footnote forward.

**18. Every bill that did not pass says where it ended.** 0.

The listing shows the nine Session 5 bills that did not pass. Three name Stage 1,
dated from the Official Report, each date equal to the bill's `date_concluded` as
item 13 sets out. The other six are undated and cite the bill page, because none
of them ended on a decision of the Parliament: each stopped at Stage 1 without
completing it, and there was no vote to date. See `DECISIONS.md`, 2026-09-14.

**19. Every stage date held for a Session 5 bill that did not pass.** Nine rows,
one per bill, every one at stage_order 1, `completed` false, `fell_here` true.

The three rejections are dated as item 13 and **every one must say
`official_report`**. If any says `phd`, the dataset's date has been carried in
place of the Official Report's and this item fails — even though all three agree
to the day, because what is being checked is that the load left the more primary
source in place. The six endings are undated and say `bill_page`.

**20. The three bills that passed and were stopped before Royal Assent.** The
first bills on the clean sheet that have not finished.

| Bill | Passed | Blocked on | Note characters |
|---|---|---|---|
| UK Withdrawal from the European Union (Legal Continuity) | 21 March 2018 | empty | 385 |
| European Charter of Local Self-Government (Incorporation) | 23 March 2021 | 6 October 2021 | 357 |
| United Nations Convention on the Rights of the Child (Incorporation) | 16 March 2021 | 6 October 2021 | 357 |

Each must read `outcome` passed, `enactment_status` blocked, no Royal Assent
date and no asp number. **The empty cell against the UK Withdrawal Bill is the
fact sheet's own silence**, not a gap: its footnote gives no date for the ruling,
and the note says so in words.

The character counts are of the wording the owner agreed on 14 September, quoted
in `DECISIONS.md`, counted from that text and not from the database. **A small
difference means the words typed at review are not the words agreed** — which is
worth knowing either way, so read the note out beside the decision rather than
waving the number through or assuming the note is wrong.

The phrase checks are of facts and not of wordings, for the reason Session 4's
item 20 had to be rewritten: `opens_with_the_fact`, `names_the_mechanism`,
`names_who_referred_it` and `says_what_was_ruled` true on all three;
`gives_the_ruling_date` true on the two the fact sheet dates and false on the UK
Withdrawal Bill; `says_the_fact_sheet_gives_no_date` the other way round — false,
false, true.

**Each of the three has 3 stage records and 3 periods counted**, its Stage 3
dated and no fourth period, because there is no Royal Assent to count to. Their
Stage 3 dates are the passing dates above. This is the difference between a bill
that was stopped and a bill that is missing a date: the stages are complete and
the period after them does not exist.

**21. A bill that passed, has no Royal Assent date and does not say why.** 0, and
0 blocked bills with nothing said to a reader.

**This is the hole `db/071` found and closed**, and it is worth stating plainly
because it was open for every session before this one: a bill could have been
recorded as passed, given no Royal Assent date, left as not enacted with nothing
on the line saying why, and the error checker would have admitted it. The rule is
now worded about the Royal Assent date rather than about enactment. A non-zero
answer means it is open again.

**22. A Private Bill's stages are recorded under a Private Bill's names.**

| Bill type | 1 | 2 | 3 |
|---|---|---|---|
| committee | stage_1 3 | stage_2 3 | stage_3 3 |
| government | stage_1 63 | stage_2 62 | stage_3 62 |
| members | stage_1 16 | stage_2 8 | stage_3 8 |
| private | preliminary 5 | consideration 5 | final 5 |

Government's 63 at position 1 is the 62 that passed plus the withdrawn Children
and Young People Bill; members' 16 is the 8 that passed, the 3 rejected, the 1
withdrawn and the 4 out of time. `stage_1` appearing against `private` means the
loader has used the public names, and the comparison of a Private Bill's
Consideration Stage with an ordinary bill's Stage 2 then rests on a claim the
database is supposed to refuse.

**23. `db/077`'s guards, derived again rather than re-run.** A migration's own
provocations are the writer's account of itself; these are the same rules asked
of the clean sheet from outside. All four counts 0.

- **`stage_dates_before_introduction` 0** and
  **`stage_dates_after_the_bill_or_its_session_ended` 0**. The second is the
  guard that did not bite when `db/077` was written: its ceiling was the bill's
  own last stage date where the bill had neither a Royal Assent date nor a date
  it concluded, which on the three blocked bills is the date being checked, so a
  Stage 3 dated any year at all passed it. The ceiling is now the day the bill
  ended, and where it has not ended, the day the session ended — which is what
  the query above measures against. See `DECISIONS.md`, 2026-09-14.
- **`stages_out_of_order` 0.** This is the check that caught the Civil
  Partnership Act's Stage 2 being typed three months before its Stage 1
  (`db/076`), so it has bitten once for real.
- **`session_5_stage_dates_from_another_source` 0.** The four sources Session 5's
  review covered are the legislation fact sheet, the dataset, the Official Report
  and the bill page. Anything else on a Session 5 stage record was not reviewed.
- **The dateless listing is exactly six bills**, each at Stage 1: Disabled
  Children and Young People (Transitions to Adulthood), Fair Rents, Travelling
  Funfairs (Licensing), Welfare of Dogs, Children and Young People (Information
  Sharing) and Liability for NHS Charges. Seven means a date has been lost; five
  means one has been invented.

**24. Every period counted for Session 5.**

| Counted to | Periods |
|---|---|
| introduction → stage_1 | 76 |
| introduction → preliminary | 5 |
| stage_1 → stage_2 | 73 |
| preliminary → consideration | 5 |
| stage_2 → stage_3 | 73 |
| consideration → final | 5 |
| stage_3 → royal_assent | 70 |
| final → royal_assent | 5 |

312 in all. The 76 at the first row is the 73 public bills that passed plus the 3
rejected at Stage 1; the 70 at `stage_3 → royal_assent` is those 73 less the
three blocked, and that gap of three is the whole point of item 20. The six
undated endings count nothing, which is item 29.

**The shortest and longest roads from introduction to the end of Stage 3**, both
predicted from the fact sheet's own introduction and passing dates:

| | Days |
|---|---|
| Coronavirus (Scotland) Act 2020 | 1 |
| Coronavirus (Scotland) (No.2) Act 2020 | 9 |
| UK Withdrawal from the European Union (Legal Continuity) | 22 |
| Planning (Scotland) Act 2019 | 563 |
| Period Products (Free Provision) (Scotland) Act | 581 |
| Pow of Inchaffray Drainage Commission (Scotland) Act 2018 | 636 |

**Read the second and third rows carefully.** The session that promoted Session 5
reported the three shortest as 1, 27 and 28 days, the last two being Budget Acts.
The fact sheet's own dates make them 1, 9 and 22: the Coronavirus (No.2) Act was
introduced on 11 May 2020 and passed on 20 May, and the UK Withdrawal (Legal
Continuity) Bill on 27 February and 21 March 2018. If the answer here is 1, 9 and
22, the clean sheet agrees with the fact sheet and the earlier account was loose
prose. **If it is 1, 27 and 28, then two bills' Stage 3 dates on the clean sheet
are not the fact sheet's**, and that is a finding about the data rather than
about the prose.

### Then, outside the script

**25. The data dictionary is still true.**
`python3 tools/make_data_dictionary.py` produces no difference from the committed
file, at 17 tables and 162 columns. Session 5 added two columns to the staging
sheet in `db/071` — `date_assent_blocked` and `raw_footnote` — so the committed
dictionary must already describe both; if it does not, the script refuses to run
and the dictionary has to be committed with the migration that made them.

**26. The reader still reproduces what was loaded.** Extract the Session 5 fact
sheet afresh and compare against the staging lines' raw columns: 87 rows,
0 differing.

    extract_factsheet.py <pdf> --session 5 --csv out.csv

**Nothing may be supplied to the reader but the PDF and the session number.**
That is what this item is for.

**The worked-out columns that must differ, and only these** — nine cells across
nine bills. **[Read exactly nine, then exactly ten after `db/078`, the tenth
being the `short_title` this item already names below. 87 rows both times, every
one pairing, and no column that must not differ did.]**

- `outcome` on all seven bills the fact sheet's Fallen table holds, because since
  `db/051` the reader decides none of them: Culpable Homicide, Post-mortem
  Examinations (Defence Time Limit) and Restricted Roads (20 mph Speed Limit),
  read in the Official Report; Disabled Children and Young People (Transitions to
  Adulthood), Fair Rents, Travelling Funfairs (Licensing) and Welfare of Dogs,
  worked out from the day the session ended.
- `date_introduced` on one, corrected against the Parliament's bill page:
  Solicitors in the Supreme Courts of Scotland (Amendment), 26 September 2019
  where the fact sheet prints 2020.
- `asp_number` on one, which the fact sheet prints with no year: Period Products
  (Free Provision). **A tenth cell, `short_title` on the same bill, if the owner
  settles the title question.**

`outcome` must **not** differ on the two withdrawn bills. The reader reads the
Withdrawn table and codes them itself.

`enactment_status` and `date_assent_blocked` must **not** differ on the three
blocked bills. The reader produces both from the footnotes since `db/071`, and a
difference here means the review typed by hand what the reader already gives.

`date_royal_assent` must **not** differ on the Age of Criminal Responsibility Act
or the Heat Networks Act. Both disagreements were with the dataset, not with the
fact sheet, and the fact sheet's dates are what stand; a difference here means
the wrong source won.

`bill_type` must **not** differ, on any of the 87. The reader produces no
`stage_1_rejection_route`, `bill_note` or `official_report_read_on` at all, so
those are not comparisons.

**Also check the dissolution rule afresh**, as every session since the first
does: of the seven fallen bills in the fresh reading, exactly the four concluding
on Session 5's last day of **4 May 2021** are the four coded `fell_dissolution`,
none over and none missing. That is what makes those four differences a rule
being applied rather than a coding nobody can reproduce.

**27. The dataset's fingerprint** is sha256
`072184df1fd4fbc15ae9e66ca51f9e287de6bc9b3b8f4d8342f6cae4e79ac1d2`, computed
from `sources/phd/Billdates-September2026.xlsx` on 2026-09-14.

It was `6614b3a1…c135420f` when Session 4 closed, and Session 5 moved it twice
under the rule the owner settled that day: first the two Royal Assent dates the
fact sheet was right about, then the Civil Partnership Act's Stage 2 month, which
the error checker caught because the dates were in an impossible order. The
Corrections sheet carries all three, each with what it was checked against.

The ten Session 5 names paired by hand in `tools/phd_stage_dates.py` are not
corrections and do not move the fingerprint: the four Budget Acts, which the
dataset numbers within the session for a third session running, and six wording
slips. Every pair agrees on both dates the two sources share. **One Session 5
line has no dataset row at all** — the Domestic Abuse (Protection) (Scotland) Act
2021 — which is why 87 lines pair with 86 rows, and it is named in
`NOT_IN_DATASET` with the bill page that holds its two dates instead.

**This is the one item a later session can move.** Adjudicating a disagreement
for Session 6 or beyond corrects the file and the fingerprint changes with it.
Record the new one beside the old; nothing else about Session 5 is reopened by it.

**28. Promotion is still reversible.** **[Done on 2026-09-14 by the session
that ran this test, which had done none of Session 5's work. Off: 0 bills, 0
stage rows, no stamps on the staging lines, 302 bills left. Back on: 389, 1071,
105. Compared cell by cell against a copy taken first, the only differences were
record numbers and the times things were written. Thrown away; nothing left
behind. Done a second time for real when `db/078` corrected the title, which is
how that correction reached the clean sheet.]** Take Session 5 off and put it back inside a
transaction that is thrown away, and the result is identical. The procedure is in
`docs/PROMOTION-RUNBOOK.md`. The session that promoted Session 5 did this and
saved it, which is not the same as a session that did none of the work doing it:
Session 5 is the first session whose promotion writes provenance for a blocked
bill, and the first to go on with its Stage 1 and Stage 2 dates already there, so
there are two things in it that have never been undone by anyone else.

**29. Every period is counted, or has a stated reason.**
**[Ran clean: 1377 counted, 27 with no day recorded — 21 from Sessions 1 to 4
and Session 5's six undated endings — and, beside them, the 2 stages of the
reintroduced Robin Rigg Bill that never happened, which item 11 already counts.
So 29 stages are uncounted in all under two stated reasons, and the 27 this item
names is the first of the two. Worth saying plainly because the number alone
reads as a discrepancy and is not one.]**
`tools/duration_coverage.sql` runs clean: **1377 counted**, and 27 not counted —
21 from Sessions 1 to 4, as Session 4's test settled, and 6 from Session 5, being
the six undated endings. No third category; the script stops if one appears.

1377 is Session 4's 1065 plus Session 5's 312, which is item 24's table. **Note
what is not in the 27**: the three blocked bills contribute no uncounted period
at all, because the script only adds a Royal Assent point for a bill that was
enacted. A blocked bill is not a bill missing a period; it is a bill whose next
period does not exist.

**30. The repository is clean** and level with GitHub, and the migrations are
numbered without a gap. `db/063` and `db/066` share a filename, which is known
and accepted; see `STATE.md`, housekeeping.

**31. The rule `db/078` added, derived again rather than re-run.** **Written on
2026-09-14 by the session that added it, and deliberately not run by it.** The
migration proves its own rule by taking a year off a title, reading the checker
and putting it back; that is the writer's account of itself, and item 23 is here
because such an account is not a check. Ask the clean sheet and the staging
sheets the rule again, from outside:

- **Every line recorded as having become an Act has a title ending in a four-digit
  year.** Expected 335 of 335 on the staging sheets and 389 bills unaffected —
  335 being the enacted lines across Sessions 1 to 5, counted before the rule
  was added, when 334 of them already satisfied it.
- **No line that did not become an Act has one.** Expected 0 of 54: the 51
  recorded as not enacted and the 3 stopped before Royal Assent, whose titles
  end in "Bill". This is the half that matters, because a rule that asked every
  line for a year would quietly be wrong about every bill that never became an
  Act.
- **The rule is about enactment and not about the number.** A line with an
  `asp_number` and no enactment is not what it keys on; there are none, and
  there should be none.
- **And the checker still reports nothing at all.** Expected 0.

If any of those is not what is found, `db/078` is the migration to read first.

**Run on 2026-09-14** by a further session, which added nothing to the database
and did not write this item. **All four parts answer as expected.**

- **Every enacted line's title ends in a four-digit year: 335 of 335**, on the
  staging sheets and on the clean sheet alike, with no line of either failing.
- **No line that is not an Act has a year: 0 of 54**, and the 54 split 51 not
  enacted and 3 blocked, which is the split the item predicted.
- **No line carries an `asp_number` without being recorded as enacted**, and
  none of the 335 enacted lines is missing one, on either sheet.
- **The error checker reports nothing at all**, and the gaps list with it.

The rule was asked of the sheets and not of the migration, and `db/078` was not
read while asking it.

**32. The rule `db/079` added, asked of the notes rather than of the migration.**
**Written on 2026-09-14 by the session that added it, and deliberately not run
by it**, for the reason item 31 gives. Eight provenance notes ended with the
words "Read at" and then stopped, because the step that files a note cuts it at
the first address and that phrase existed only to introduce the address. The
step is mended, the eight were rewritten by taking Sessions 5 and 4 off the
clean sheet and putting them back, and the database now refuses a note that ends
that way. Ask the notes:

- **No note's words end in "Read at."** Expected 0 of 106, the 106 being item 1's
  figure.
- **The eight that did now end where their sentence ends**, in a closing
  quotation mark or a full stop: five in Session 4 and three in Session 5, all of
  them outcomes cited to the Official Report. The eight and the five-and-three
  split were counted off the staging sheets before anything was moved, and the
  two rehearsals moved three cells and five cells respectively.
- **The address was never part of the words and is not lost.** All **24** notes
  recording an outcome read in the Official Report still carry an address as
  their reference — the 24 is item 5's table — and each still carries the day it
  was read.
- **Sessions 1 to 3 are untouched.** Their **16** outcome notes never had an
  address to cut, because their review notes were worded differently, and none
  contains the phrase at all. 16 is 24 less the eight.
- **The rule binds a writer other than promotion.** It sits on the note itself
  and not in the staging checker, because the staging sheets were never wrong:
  their review notes carry the full sentence, address and all. So a change made
  by hand that ends a note in "Read at" must be refused too, and the check is
  worth making that way round rather than through promotion.
- **And the checker still reports nothing at all.** Expected 0.

If any of those is not what is found, `db/079` is the migration to read first.

**Run on 2026-09-14** by a further session, which added nothing to the database
and did not write this item. **All six parts answer as expected.**

- **No note's words end in "Read at": 0 of 106.**
- **The twenty-four outcome notes cited to the Official Report end where their
  sentence ends**, every one of them, in a closing quotation mark or a full
  stop. The eight are there: five in Session 4 and three in Session 5. Six of
  them end in a quoted "Motion disagreed to."; the Restricted Roads Bill's ends
  in the quoted title of the motion, and the Transplantation Bill's in the words
  "not printed on this page."
- **The address was never part of the words and is not lost.** All 24 carry an
  address beginning `https://` as the note's reference, and all 24 carry the day
  it was read.
- **Sessions 1 to 3 are untouched: 16 notes**, five, six and five, and not one
  of the 24 contains the phrase "Read at" anywhere at all any more.
- **The rule binds a writer other than promotion.** Asked twice inside a
  transaction that was then rolled back: adding " Read at" to the end of an
  existing note by hand was refused, and so was a new note written from nothing
  whose words ended that way. Nothing was left behind.
- **The error checker reports nothing at all**, and the gaps list with it.

The rule was asked of the notes and not of the migration, and `db/079` was not
read while asking it.

### Part B — the owner's sign-off

None of these is for anyone else to answer. A sign-off is recorded here on the
day it is given, and nowhere else.

**All nine given on 2026-09-14**, in one session, each against the rows and the
text read back out of the database rather than out of a note about them. Two of
the nine changed something: sign-off 2 turned up eight provenance notes ending
mid-sentence, mended by `db/079`, and sign-off 9 found the explainer silent about
the rule that mend added, which was written into it before the document was read.

**Part B is complete, and so is Part A**: item 32 was run on 2026-09-14 by a
session that did not write it, and answered as expected. **Session 5 is closed.**

1. **What happened to each bill.** The counts in items 6 and 7 are what you
   expect for Session 5: the reconciliation against the fact sheet's summary in
   every cell and both margins, including its fourth table for the first time,
   and the split of its seven fallen bills into three rejected at Stage 1 and
   four that ran out of time.
   **Given on 2026-09-14**, against the reconciliation read back out of the clean
   sheet and set beside the fresh extraction's table cell by cell, and against the
   seven fallen bills listed by name under each heading.
2. **The three bills read in the Official Report.** For each, the quotation on
   the line and the ending recorded against it. You found all three on the
   Parliament's bill pages, which print the divisions and name two of the three
   motions; the citation is the Official Report because that is where the
   Parliament decided, and the Restricted Roads motion's number and mover are
   from the bill page with the line saying so. The sign-off is on the record as
   it was read.
   **Given on 2026-09-14**, with all three notes handed over in full rather than
   summarised. **Reading them in full is what found the fault `db/079` mended**:
   each ended with the words "Read at" and nothing after them. The sign-off was
   given on the text as it then stood, and the eight characters removed since are
   the dangling phrase and nothing else — the quotation, the ending recorded and
   the citation are the same words the owner read.
3. **The three bills stopped from Royal Assent.** The words a reader sees against
   each, read in full off the clean sheet rather than out of the decision that
   agreed them, and that `blocked` rather than `pending` is still what you want —
   the table's heading says awaiting, the footnotes say cannot be submitted, and
   we followed the footnotes. Also that recording them as Session 5's fact sheet
   leaves them, with what happened next left to Session 6, is right.
   **Given on 2026-09-14**, against the three notes read in full off the clean
   sheet with the fact sheet's own footnote set beside each, against the
   definitions of `blocked` and `pending` as `ref_enactment_status` states them,
   and against M5's own statement that its account of what became of these bills
   runs ahead of the data. The UK Withdrawal Bill's missing block date was read as
   part of it: the fact sheet gives no date for its ruling, the line says so, and
   that is why these three carry five provenance notes and not six.
4. **The six bills that ended where they stopped**, checked against the clean
   sheet rather than against the note of them: each at Stage 1, not completed,
   marked where the bill ended, and undated because there was no decision to
   date.
   **Given on 2026-09-14**, against all six read off the clean sheet: one stage
   row each, Stage 1, not completed, marked as where the bill ended, undated, and
   each carrying the sentence the clean sheet writes for itself. Read with them:
   the two withdrawn and the four out of time, their introduction and conclusion
   dates, and that all four of the latter concluded on 4 May 2021, which
   `session.date_session_end` gives as the day Session 5 ended and which is the
   whole basis of the coding.
5. **The three adjudicated dates and the Act number the fact sheet printed
   short**: the two Royal Assents settled the fact sheet's way against
   legislation.gov.uk, the Solicitors Bill's introduction settled at 26 September
   2019 against the fact sheet's 2020, and the Period Products Act's number at
   2021 asp 1 — each with its source, its place in that source, the value in the
   source's own words and the day it was read.
   **And the question this test turned up: whether that Act's title should carry
   its year too**, as Session 4's Higher Education Governance Act's did. Item 9
   is written expecting yes. **The owner said yes on 2026-09-14, so this
   sign-off is now on four cells and not three, the fourth being
   `short_title` = Period Products (Free Provision) (Scotland) Act 2021, from
   legislation.gov.uk, read that day.**
   **Given on 2026-09-14**, all four cells together: each read back off the clean
   sheet with its source, its place in that source, the source's own words and the
   day it was read, and with the `Differs:` and `Checked:` lines from the staging
   line beside it. The Solicitors Bill is the one of the four that moved the line;
   the two Royal Assents did not, and the Period Products number and title were
   both absent from the fact sheet rather than disputed.
6. **The ten names paired by hand**, checked against the fact sheet and your
   dataset side by side, and **the one bill your dataset does not have** — the
   Domestic Abuse (Protection) (Scotland) Act 2021, whose Stage 1 and Stage 2
   come from its own bill page instead, with the introduction, Stage 3 and Royal
   Assent dates on that page agreeing with what the fact sheet already put on the
   line.
   **Given on 2026-09-14**, against the ten pairs listed with the fact sheet's
   wording beside the dataset's, and against the Domestic Abuse (Protection) Act
   read off the clean sheet stage by stage: Stage 1 and Stage 2 cited to the bill
   page with the page's own words, and introduction, Stage 3 and Royal Assent
   agreeing with what the fact sheet had already put on the line — the agreement
   `db/075` refuses the two new dates without.
7. **The Civil Partnership Act's Stage 2 month**, settled at the bill page at 11
   June 2020 where the dataset had 11 February, and the dataset corrected after
   the database, so that the record the two sources disagreed survives the file
   being put right.
   **Given on 2026-09-14**, against the bill page's own sentence, the four stage
   dates as the clean sheet now holds them, the staging row that still carries the
   whole account of the disagreement, and the file's Corrections sheet, which
   records the fingerprint the file had before each change so the chain back to
   the untouched thesis dataset is unbroken.

8. **M5 and M7 read in full**, as a reader will see them: M5 saying that its
   account of what became of the four blocked bills runs ahead of the data, and
   M7 saying which sessions the coding of why a bill fell has been done for.
   **M7 was a session out of date and no longer is** — see item 15. Read it as
   it now stands.
   **Given on 2026-09-14**, both read in full as a reader will see them, not
   summarised. M7 was read at 5006 characters, saying Sessions 1, 2, 3, 4 and 5.
   M5 was read with its closing sentence, which tells a reader outright that its
   account of what became of the four blocked bills runs ahead of the data.

9. **That you can explain how this database works** from the documents alone,
   without help. The standing requirement, put again because Session 5 is the
   first session that puts an unfinished bill on the clean sheet. **`docs/HOW-THE-DATABASE-WORKS.md` was wrong about its own
   contents when this was written**, §3 saying 86 notes and §4 ninety-one. Both
   were corrected on 2026-09-14 and it now says 106 and 92. It is ready to be
   read.
   **Given on 2026-09-14.** The figures corrected that day were re-checked
   against the database first and still stood at 106 and 92; nothing that day
   changed how many notes there are. One sentence was added to the explainer
   before it was read, saying that the notes tab now refuses a note whose words
   end "Read at" — `db/079`'s rule, which the document would otherwise have been
   silent about.


### Part C — what this test does not check

- **Whether Session 5's stage dates are right.** The 153 from the dataset rest on
  the dataset alone, and nothing has compared them against the Parliament's bill
  pages — 87 pages, and its own piece of work. The owner's judgement on 14
  September is that the error rate is likely very low and tolerable until there
  is a methodology for the check. The error checker catches a date in an
  impossible order, as it did for the Civil Partnership Act, and not one that is
  wrong and still in order.
- **Whether the 75 Royal Assent dates and 87 introduction dates nobody has
  checked are right.** Two Royal Assents and one introduction date were checked
  because the two sources disagreed; the rest agree between fact sheet and
  dataset, which is corroboration and not verification. M8 says which a reader
  has.
- **Whether the Official Report was read correctly beyond the words quoted.**
  Nobody has read the surrounding debate for any of the three rejections.
- **What became of the three blocked bills.** Two were reconsidered and enacted
  in Session 6 and one was withdrawn there. None of that is in the database, by
  decision, until Session 6's fact sheet has been read in; M5 says so in words,
  and passing this test says nothing about it.
- **Whether the section 33 and section 35 distinction should be a variable.**
  Four bills now sit under `blocked` by two different mechanisms. On the waiting
  list, to be revisited at a fifth.
- **Bills carried over between sessions.** Four bills appear in two fact sheets,
  and the double-count guard cannot see two of them — the European Charter and
  UNCRC Bills, which are "Bill" here and "Act" in Session 6. Nothing in Session 5
  trips it, so this test does not exercise it and passing says nothing about it.
- **The ceiling in item 23 as it will behave on a carried-over bill.** It will
  refuse one, correctly for everything on the clean sheet now and wrongly for
  Session 6. That is part of the carried-over-bills job `STATE.md` puts before
  Session 6 is loaded.
- **Anything about Sessions 6 and 7**, including the prose reader.

---

## Session 4

Written 2026-09-13 by a session that did none of Session 4's work: it did not
read the fact sheet in, did not build the review, and did not admit it.

**Run on 2026-09-14** by a third session, which had done none of Session 4's
work either. Twenty-five of the twenty-seven mechanical items matched their
predictions exactly. Two did not, and both turned out to be faults in the
prediction rather than in the data: item 26's arithmetic missed a period, and
item 20 looked for a form of words the note never had. Both expected answers are
corrected below, each marked and reasoned, so that what a later reader compares
against is the corrected figure and not the original guess.

**Part B is marked. All nine sign-offs were given on 2026-09-14**, in one
session, each against the rows read back out of the database rather than out of
a note about them. Three of the nine changed something. Item 7 settled that the
working dataset is corrected whenever it is found wrong, so the National
Galleries introduction date was corrected in the file and item 24 carries the new
fingerprint. Item 8 named M4 where it meant M1, and the test is corrected. Item 9
found the explainer silent on the note a reader sees and M7 a session out of
date, and both were put right before the document was read. **Session 4 is
closed.**

**Reopened on 2026-09-14, and closed again unchanged.** Five of Session 4's
provenance notes ended mid-sentence, with the words "Read at" and nothing after
them, and the fault was in the step that files a note rather than in anything
Session 4 read or typed. Session 4 was taken off the clean sheet and put back so
the five were rewritten by the ordinary route; see `db/079`. **No answer of this
test moves.** Item 5 counts the notes cited to the Official Report and says what
each is cited to, not how its words end, and its 21 is unchanged; the cells item
5 lists in full are the other four, none of them affected. The comparison against
a copy taken beforehand found those five cells and no others. This is marked here
only so that a later reader who compares the wording is not puzzled.

Session 4 was deliberately still off the clean sheet when this was written. So
every expected answer below is a prediction made from page 9 of the Session 4
fact sheet, the owner's dataset and the rules — not a description of a database
anyone has looked at. That is the whole point of the order the owner set: the
next session writes the test, a third runs it, and no session marks its own
work at either step. See `DECISIONS.md`, 2026-09-13.

**When to run it.** When Session 4 is on the clean sheet *and* its Stage 1 and
Stage 2 dates are loaded. Before that the counts are of a session half admitted
and the expected answers do not apply.

### Before Session 4 can be promoted at all — both done, 2026-09-13

Writing this test turned up two things Session 4's review did not settle.
Neither was a matter of opinion, and both had to be done before promotion, not
before the test is run. **Both were done on 2026-09-13, in `db/067` and in
`READ_ON`, and this section is kept as it was written with the answers added,
so that a reader can see the test's N was filled in from the sources and not
from the database.**

**First, two bills did not say where they ended.** The error checker was empty and the
gaps list held 160, of which 158 are Stage 1 and Stage 2 dates the load
supplies. **The other two were these:**

| Line | Bill | Ending | Concluded |
|---|---|---|---|
| 296 | Inquiries into Deaths (Scotland) Bill | withdrawn | 24 September 2015 |
| 300 | Footway Parking and Double Parking (Scotland) Bill | fell at dissolution | 23 March 2016 |

Neither has a stage record of any kind. This is the same job `db/056` did for
Session 3's four — two withdrawn bills and two that fell at dissolution, each
established by the owner from the Parliament's own bill page and recorded as an
undated stage row. It was not put on Session 4's review list, and it is the
first task of whichever session promotes Session 4.

**The Footway Parking Bill is not the same shape as Session 3's four.** The
owner's dataset gives it a Stage 1 vote on **1 March 2016**, three weeks before
the session ended — so the bill completed Stage 1 and was somewhere beyond it at
dissolution, where Session 3's two dissolution bills had no Stage 1 date at all.
The dataset is not a source for where a bill ended, and `tools/phd_stage_dates.py`
refuses on exactly this: *"ended before Stage 3, and the dataset dates stage 1
2016-03-01 — a stage nothing on the stage-dates sheet says it completed."* What
that bill's stages were has to come from the source that says so.

**This is why item 1 below carried an N.** Whether those two bills produce two
stage records or three or four was not predictable from the fact sheet, the
dataset or the rules — it turns on what the sources say, which is the owner's to
establish. **The session that records them writes the number into this test,
before promotion.** It is not for the marking session to work out, and a test
whose expected answer is derived after the fact is worth nothing.

**N is 3, settled on 2026-09-13 and recorded in `db/067`.** The Inquiries into
Deaths Bill produces one row and the Footway Parking Bill two:

| Bill | Stage | Date | Ends here | Source |
|---|---|---|---|---|
| Inquiries into Deaths | Stage 1 | none | yes | the bill page |
| Footway Parking | Stage 1 | 1 March 2016 | no, completed | Official Report, 1 March 2016 |
| Footway Parking | Stage 2 | none | yes | Official Report, 1 March 2016 |

The Inquiries into Deaths Bill was withdrawn by Patricia Ferguson on 24 September
2015, in writing to the Parliament's clerk and announced the same day in the
chamber, before the Parliament had debated or decided its general principles. The
Justice Committee had reported on it at Stage 1, but the stage was never
completed, so there is no date — Session 3's two withdrawn bills exactly.

The Footway Parking Bill's general principles **were** agreed, on 1 March 2016:
motion S4M-15759 in Sandra White's name, put at Decision Time and agreed to
without a division. So Stage 1 was completed, on the day the dataset gives, and
the bill stopped at Stage 2, undated. That is Session 1's Gaelic Language Bill
again, already on the clean sheet in this shape, so it is not a new question.

The Parliament's current bill page for the Footway Parking Bill says *"The Bill
fell at Stage 1 on 23 March 2016"*, which read literally contradicts the Official
Report. It is the site's coarse label — the bill got no further than Stage 1 —
and the Official Report is what records the decision. That is the order this
project already uses, and the owner settled it on 2026-09-13.

**Second, `tools/phd_stage_dates.py` had no reading date for Session 4.** `READ_ON`
held 1, 2 and 3, and the script refuses to run without one — deliberately, so
that a date supplied on the command line is not a date recorded nowhere. **Added
on 2026-09-13 as 2026-09-13**, the day the dataset was read for Session 4's
bills. With `db/067` applied the script runs and writes 158 stage rows, which is
what item 11 predicts.

**The one item an outside change can move** is item 24, the dataset's
fingerprint. Nothing else here is reopened by later work.

**What this test does not put again.** Sessions 1, 2 and 3 and their corrections
are settled. Where an answer below covers the whole database it is because
Session 4 moves it, and the earlier sessions' part of it is taken from their own
tests rather than re-derived.

### Part A — mechanical

Run `tools/closure_check_session_4.sql`. It reads only and changes nothing.
Compare each numbered result against the expected answer.

**1. Counts.** bills 302, stage_records 828, provenance_notes 86,
checker_problems 0, gaps 0, staging_lines 302, stage_date_rows 828.

- **302** is 216 plus the Session 4 fact sheet's own total of 86.
- **828** is 583 plus Session 4's 245, and the 245 should be checked as
  a derivation: 74 public Acts × 3 stages = 222; 5 Private Acts × 3 stages = 15;
  the 5 bills rejected at Stage 1 have one each = 5; the two endings above have
  3 between them. 222 + 15 + 5 + 3 = 245. The 3 is the N of the section above,
  settled in `db/067`.
- **The same 828** for stage_date_rows, and that is not a coincidence: every
  accepted stage-date row is carried to exactly one stage record, so once
  Session 4's 84 loaded rows are promoted the two counts are equal. They are 667
  and 583 today because Session 4's 84 are on the staging sheet and not yet
  carried.
- **Of Session 4's 245, 87 are already on the staging sheet** — 74 Stage 3
  dates and 5 Final Stage dates off the fact sheet, 5 Stage 1 dates read in
  the Official Report, and the 3 endings of `db/067` — and **158 arrive with the
  dataset**, being 79 bills ×
  two stages. The 79 is every bill that reached Stage 3; the dataset holds a
  Stage 2 date for exactly those 79 of its 86 Session 4 rows, which was counted
  in the dataset itself rather than in the database.
- **86** is 71 plus 15: 5 outcomes read in the Official Report, 5 Stage 1 routes
  from the same, 1 bill coded as having fallen at dissolution, and 4 cells
  checked at review — the Higher Education Governance Act's title and its
  number at legislation.gov.uk, the Land Reform Act's Royal Assent at the same,
  and the National Galleries Act's introduction date from the owner's own record.
- **0 and 0 are the rule.** The 160 gaps standing on 13 September are 158 dates
  this load supplies and the two endings above; a gap left after both is a
  question about a bill.

**2. Every staging line reviewed, admitted, on the clean sheet and compared.**
Session 1: 73 accepted, 73 promoted, 73 compared. Session 2: 81, 81, 81.
Session 3: 62, 62, 62. Session 4: 86, 86, 86. No other review status appears.
From the fact sheets' totals and the rule that nothing reaches the clean sheet
unaccepted.

**3. Every stage-date row.** Session 1: 200 accepted, 200 carried. Session 2:
213, 213. Session 3: 170, 170. Session 4: 245, 245. No other status.

**4. A recorded difference with no adjudication.** 0. Session 4 recorded two —
the Land Reform Act's Royal Assent and the National Galleries Act's introduction
date — and both were settled on 13 September, each with a `Checked:` line beside
the `Differs:` line.

**5. What has been checked against the source that owns it.**

| Field | Source | Cells |
|---|---|---|
| `asp_number` | `legislation_gov_uk` | 2 |
| `bill_type` | `bill_page` | 1 |
| `date_completed` | `bill_page` | 1 |
| `date_first_meeting` | `spice_factsheet_dates` | 7 |
| `date_introduced` | `bill_page` | 5 |
| `date_introduced` | `manual` | 1 |
| `date_royal_assent` | `legislation_gov_uk` | 11 |
| `date_session_end` | `spice_factsheet_dates` | 6 |
| `outcome` | `official_report` | 21 |
| `outcome` | `spice_factsheet_dates` | 10 |
| `short_title` | `legislation_gov_uk` | 1 |
| `short_title` | `manual` | 1 |
| `stage_1_rejection_route` | `official_report` | 19 |

Sessions 1 to 3 account for 71 of these, and the table above is theirs with
Session 4's fifteen added. Two of the rows are new pairings the database has not
held before: a title settled at legislation.gov.uk, and an introduction date
whose source is `manual`.

**The four Session 4 cells are then listed in full.** Expected:

| Bill | Cell | Source | Value seen |
|---|---|---|---|
| Higher Education Governance | `asp_number` | `legislation_gov_uk` | 2016 asp 15 |
| Higher Education Governance | `short_title` | `legislation_gov_uk` | Higher Education Governance (Scotland) Act 2016 |
| Land Reform | `date_royal_assent` | `legislation_gov_uk` | 2016-04-22 |
| National Galleries of Scotland | `date_introduced` | `manual` | 2015-06-25 |

All four read on 2026-09-13. **Four rows and not three**: the Higher Education
Governance Act's title contains a bracket, and reading a bracketed value out of
a citation is what `db/063` had to fix twice. Three rows here means promotion's
pattern has stopped at the first `(` again and one citation was silently not
seen; two citations collapsed into one means the greediness fault is back. See
`DECISIONS.md`, 2026-09-13.

**6. Reconciliation.** Our counts must match the fact sheet's own summary table
in every cell and both margins. These figures are read off page 9 of the Session
4 fact sheet, not out of the database:

| Session 4 | Government | Member's | Private | Committee | Total |
|---|---|---|---|---|---|
| Acts of the Scottish Parliament | 67 | 6 | 5 | 1 | 79 |
| Bills withdrawn | 0 | 1 | 0 | 0 | 1 |
| Bills fallen | 0 | 6 | 0 | 0 | 6 |
| **Total** | **67** | **13** | **5** | **1** | **86** |

The script's rows are `acts`, `fallen` and `withdrawn`, and its
`government_or_hybrid` column answers the fact sheet's "Government".

**On `bill_type` alone**: government 67, members 13, private 5, committee 1 —
**identical to the table above**, because Session 4 has no Hybrid Bill. Session 3
is the only session where the two readings differ, and its own test explains why.
A Hybrid Bill appearing here means the reader has typed something H that the
fact sheet does not.

**7. Outcomes.** 79 passed and enacted; 5 rejected at Stage 1; 1 withdrawn;
1 fell at dissolution. Every non-passing bill is `not_enacted`.

The fact sheet gives the row totals only — 79 Acts, 1 withdrawn, 6 fallen.
Splitting the 6 into 5 + 1 is ours, methodology note M7: five from the Official
Report of the day, one from the day the session ended. **No Session 4 bill was
rejected at Stage 3, none fell for want of a financial resolution, and none is
still live**; those three values should not appear.

**8. Required cells.** Every column 0.

The second line is the cells the fact sheet does not fill, and they are empty on
purpose: **no_sp_bill_number 79**, has_a_procedure 0, has_a_title_as_introduced 0.
The Session 4 fact sheet prints an SP Bill number only for the seven bills that
did not become Acts, which is why 79 of the 86 have none; a smaller number here
means a bill number has been invented.

**9. Every Session 4 Act.** 79 enacted, 0 without an asp number, 0 without an
assent date, 0 where the asp number's year disagrees with the assent year. 79 is
the fact sheet's own Acts total.

**And 0 Acts anywhere on the clean sheet whose number has no year.** This is the
check `db/062` added after the Session 4 fact sheet turned out to print two Act
titles with no year in them, and the number short with it. A non-zero answer
means one got past the checker, and the title is the half that matters: it is
what the site displays.

**10. Stage records per bill.** passed 3 stages × 79; rejected at Stage 1
1 × 5; the withdrawn Inquiries into Deaths Bill 1, and the Footway Parking Bill
2. This is item 1's derivation seen per bill; the two must agree.

**11. Where every Session 4 stage date came from.** `phd` 158 (all dated),
`spice_factsheet_legislation` 79 (all dated), `official_report` 7 (1 undated),
`bill_page` 1 (undated), and nothing recorded as a stage that never happened.

- **158** is 79 bills × two stages, the 79 being every bill that reached Stage 3
  — which in Session 4 is every bill that passed, there being none rejected
  there. Counted in the dataset itself: of its 86 Session 4 rows, 85 carry a
  Stage 1 date and 79 a Stage 2 date. The six with a Stage 1 date and no Stage 2
  date are the five the Official Report already dates and the Footway Parking
  Bill, and nothing is written for any of them — the rule Sessions 1 and 2 set.
  The one row with no Stage 1 date at all is the withdrawn Inquiries into Deaths
  Bill.
- **79** is 74 passing dates and 5 Final Stage dates, off the fact sheet.
- **7** is the five Stage 1 decisions read in the Official Report, plus the
  Footway Parking Bill's two rows from `db/067` — its Stage 1, dated 1 March
  2016, and its undated Stage 2.
- **1** is the Inquiries into Deaths Bill's undated Stage 1, from the bill page.

Across the whole clean sheet: `phd` 522, `spice_factsheet_legislation` 260,
`official_report` 26 (3 undated), `bill_page` 20 (all undated), 2 recorded
as stages that never happened. Those four add to 828, which is item 1's total.

**12. Two accepted rows for the same stage.** 0, in every session, and the
listing that follows it returns nothing. Session 4's five Stage 1 dates come from
the Official Report, and **the dataset's five dates for the same bills agree with
it to the day** — Assisted Suicide 27 May 2015, Pentland Hills 26 January 2016,
Alcohol 4 February 2016, Transplantation 9 February 2016, Criminal Verdicts
25 February 2016, all checked in the dataset before this test was written. So
nothing should produce a second row, and a second row means the loader wrote the
dataset's date over the Official Report's even though the two agree.

**13. How each Stage 1 rejection came about.** `member_motion_disagreed` 15
bills, 0 with a note; `member_motion_amended_agreed` 2 bills, 2 with notes;
`committee_motion_9_14_18` 2 bills, 2 with notes. `other_route` should not
appear. 15 is Sessions 1 to 3's 11 plus Session 4's 4, none of which needs a
reader's note because all four went the ordinary way. The 2 is Session 2's one
plus the Transplantation Bill, which is item 20.

The listing that follows gives the five bills and the day each ended. Every one
must have `date_concluded` equal to its Stage 1 date and the source
`official_report`:

| Bill | Route | Ended |
|---|---|---|
| Assisted Suicide | `member_motion_disagreed` | 27 May 2015 |
| Pentland Hills Regional Park Boundary | `member_motion_disagreed` | 26 January 2016 |
| Alcohol (Licensing, Public Health and Criminal Justice) | `member_motion_disagreed` | 4 February 2016 |
| Transplantation (Authorisation of Removal of Organs etc.) | `member_motion_amended_agreed` | 9 February 2016 |
| Criminal Verdicts | `member_motion_disagreed` | 25 February 2016 |

**14. Every source on the list has a definition.** Nine sources, all true. Stage
records as item 11. `bill_rows` is `spice_factsheet_legislation` 302 and every
other source 0 — a bill's own line always comes from a legislation fact sheet.
Cells: `bill_page` 7, `legislation_gov_uk` 14, `manual` 2, `official_report` 40,
`spice_factsheet_dates` 23; `api`, `bill_document`, `phd` and
`spice_factsheet_legislation` 0. Those five add to 86, which is item 1.

**15. The notes a reader is given.** M1 to M8, eight of them, none empty. Their
lengths: M1 358, M2 5140, M3 1088, M4 971, M5 1940, M6 1605, M7 **5001** and
M8 2673. A length that has moved means somebody edited a note; find out who and
why before marking anything.

**M7 was 4361 when this test was written, and moved on 2026-09-14**, after the
test was run and before Session 4 was closed. `db/069` added a paragraph saying
that where a division decided how a bill was rejected its figures are given in
the note, and that a structured record of how members voted is not yet part of
this resource. That is the only edit; the other seven are as predicted. See
`DECISIONS.md`, 2026-09-14. **Session 4 brings no ending and no rejection route the
notes do not already cover**, so nothing here should have needed to move — which
is itself the check.

**16. Notes on the Session 4 staging lines.** 8 with a review note, 1 with a note
for readers, 85 the reader remarked on. The one reader's note is the
Transplantation Bill's, which is item 20. This item is also a prompt to read what
is written there before signing anything off.

The reader's own remarks, and how many lines carry each:

| The reader said | Lines |
|---|---|
| title is the Act title, not the title as introduced | 72 |
| the fact sheet says the bill fell and not why; outcome left for review | 6 |
| introduced as an Executive Bill; styled a Government Bill by the time it passed; … | 5 |
| a footnote marker was removed from the year 2014; title is the Act title, not the title as introduced | 1 |
| title is the Act title, not the title as introduced; the fact sheet prints no year before the asp number | 1 |

85, not 86. **The one line the reader said nothing about is the Inquiries into
Deaths Bill**, and that is the shape it should be: it is the only bill of the 86
that neither became an Act nor fell, so the reader had no Act title to remark on
and no unexplained ending to leave for review. It is also one of the two bills
that do not yet say where they ended. The six "fell and not why" lines are
exactly the fact sheet's Fallen table, which is item 7; the 72 are the Acts whose
title on the line is the Act's and not the bill's as introduced.

**17. Where the Parliament changed what it called its own bills.** Government
bills by session and by how the type was styled at the time: Session 1
`executive` 51; Session 2 `executive` 53; Session 3 `executive` 44; Session 4
`executive` 15 **and `government` 52**.

**Session 4 is the first session in which any bill is styled `government`, and
the first in which the styling changes inside the session.** Everything before it
is Executive throughout. This is what `bill_type_stated` exists for and what M4
explains: `bill_type` stays `government` for all 67 so that a count of government
bills runs continuously across the changeover, and the contemporaneous styling is
kept rather than lost. A Session 4 answer of 67 `executive` and 0 `government`
means the styling has been flattened.

The listing that follows gives the five bills the fact sheet footnotes as
"Introduced as an Executive Bill (E)" — introduced as Executive, passed as
Government — every one `G*` in the fact sheet's own type column and `executive`
here:

| Bill | Introduced |
|---|---|
| Social Care (Self-directed Support) (Scotland) Act 2013 | 29 February 2012 |
| Local Government Finance (Unoccupied Properties etc.) (Scotland) Act 2012 | 26 March 2012 |
| Scottish Civil Justice Council and Criminal Legal Assistance Act 2013 | 2 May 2012 |
| Freedom of Information (Amendment) (Scotland) Act 2013 | 30 May 2012 |
| Water Resources (Scotland) Act 2013 | 27 June 2012 |

The other ten `executive` bills are typed plainly `E` and carry no footnote. The
two labels overlap in time rather than changing on a day — the last plain `E` was
introduced on 22 March 2012, after the first `G*` on 29 February — so do not
expect a clean boundary, and do not go looking for one.

**18. Every bill that did not pass says where it ended.** 0. **This is the item
the two endings above have to be recorded for**, and it will read 2 if they are
not.

The listing that follows shows the seven Session 4 bills that did not pass. Five
name Stage 1, dated from the Official Report, each date equal to the bill's
`date_concluded` as item 13 sets out. The other two are undated, because neither
ended on a decision of the Parliament: the Inquiries into Deaths Bill names
**Stage 1**, which it never completed, and the Footway Parking Bill names
**Stage 2**, which it never reached.

**19. Every stage date held for a Session 4 bill that did not pass.** Five rows
for the five rejected at Stage 1, each at stage_order 1, `completed` false,
`fell_here` true, dated as item 13, and **every one of the five must say
`official_report`**. If any says `phd`, the dataset's date has been carried in
place of the Official Report's and this item fails — even though all five agree
to the day, because what is being checked is that the load left the more primary
source in place.

Then the three rows the two endings add. **The Footway Parking Bill is the one to
look at**: the dataset dates its Stage 1 at 1 March 2016 and, until `db/067`,
nothing else on the sheet dated that stage. Its Stage 1 must read `completed`
true, `fell_here` false, dated 2016-03-01, and **`official_report`, not `phd`** —
the dataset agrees to the day, and this checks that the load left the more
primary source in place. Its Stage 2 and the Inquiries into Deaths Bill's Stage 1
are both undated, `completed` false, `fell_here` true.

**20. The Transplantation Bill's motion as amended, kept in full.** One row.
characters **1448**, and all four of `keeps_the_resolution`,
`names_the_amendment`, `gives_the_amendment_division` and
`gives_the_motion_division` true.

**Corrected on 2026-09-14, after the test was run.** As written, this item
expected 1376 characters and a `quotes_the_division` that looked in the note for
the Official Report's own phrase, "as amended, agreed to". It came back false,
and the note had never contained that phrase: it says the same thing the other
way round, "agreed to as amended". So the check tested a wording rather than a
fact, and it was the only one of the twenty-seven to fail.

Answering it turned up something real, though. The division figures were in the
database — they are recorded against every one of the nineteen Stage 1
rejections, in the Official Report's own words — but not in the text a reader
sees. **The owner settled on 2026-09-14 that both divisions are published**, and
`db/069` put them on the two bills rejected by this route, which took this note
from 1376 characters to 1448. The check now looks for the two divisions
themselves, which are facts read from the Official Report rather than a form of
words, so it cannot fail again for the same reason. See `DECISIONS.md`,
2026-09-14.

The member in charge's own motion S4M-15128 was amended by S4M-15128.1 into a
motion that did not agree to the general principles, and then agreed to as
amended on 9 February 2016. The resolution is the whole difference between this
route and the ordinary one — the Parliament declined the general principles *and*
resolved what should happen instead — so it is published beside the bill, quoted
and not summarised. A shorter note means the quotation has been trimmed; a note
that no longer mentions a soft opt-out means it has been paraphrased. See
`DECISIONS.md`, 2026-09-13, and `db/064`.

**21. A Private Bill's stages are recorded under a Private Bill's names.**

| Bill type | 1 | 2 | 3 |
|---|---|---|---|
| government | stage_1 67 | stage_2 67 | stage_3 67 |
| committee | stage_1 1 | stage_2 1 | stage_3 1 |
| members | stage_1 13 | stage_2 7 | stage_3 6 |
| private | preliminary 5 | consideration 5 | final 5 |

The members' 13 at position 1 is 6 bills that passed, 5 rejected at Stage 1, and
the two endings of `db/067`; the 7 at position 2 is the 6 that passed plus the
Footway Parking Bill's undated Stage 2. **Session 4 has five Private Bills, more
than any session so far**, and a Private Bill's stages are Preliminary,
Consideration and Final — never Stage 1, 2 and 3. `stage_1` appearing against
`private` means the loader has used the public names, and the comparison of a
Private Bill's Consideration Stage with an ordinary bill's Stage 2 then rests on
a claim the database is supposed to refuse.

### Then, outside the script

**22. The data dictionary is still true.**
`python3 tools/make_data_dictionary.py` produces no difference from the committed
file beyond its own date line. Session 4 should need no new column; if it has one,
the script refuses to run unless it carries a `COMMENT`, and the dictionary then
differs and must be committed with the migration that made it.

**23. The reader still reproduces what was loaded.** Extract the Session 4 fact
sheet afresh and compare against the staging lines' raw columns: 86 rows,
0 differing.

    extract_factsheet.py <pdf> --session 4 --csv out.csv

**Nothing may be supplied to the reader but the PDF and the session number.**
That is what this item is for.

**The worked-out columns that must differ, and only these** — nine cells across
eight bills:

- `outcome` on all six bills the fact sheet's Fallen table holds, because since
  `db/051` the reader decides none of them. Five read in the Official Report:
  Alcohol (Licensing, Public Health and Criminal Justice), Assisted Suicide,
  Criminal Verdicts, Pentland Hills Regional Park Boundary, Transplantation
  (Authorisation of Removal of Organs etc.). One worked out after the reading
  from the day the session ended: Footway Parking and Double Parking.
- `date_royal_assent` on one, corrected against legislation.gov.uk: Land Reform.
- `short_title` and `asp_number` on one, which the fact sheet prints with no year
  in the title and so no year in the number: Higher Education Governance.

`outcome` must **not** differ on the Inquiries into Deaths Bill. The reader reads
the Withdrawn table and codes it itself.

`date_introduced` must **not** differ on the National Galleries of Scotland Act.
That disagreement was with the dataset, not with the fact sheet, and the fact
sheet's 25 June 2015 is what stands; a difference here means the wrong source won.

`bill_type` must **not** differ, on any of the 86. The reader produces no
`stage_1_rejection_route`, `bill_note` or `official_report_read_on` at all, so
those are not comparisons.

**Also check the dissolution rule afresh**, as Sessions 1, 2 and 3 do: of the six
fallen bills in the fresh reading, exactly the one concluding on Session 4's last
day of **23 March 2016** is the one coded `fell_dissolution`, none over and none
missing. That is what makes the sixth difference a rule being applied rather than
a coding nobody can reproduce.

This session did not run this. The list above is a prediction from what was
changed after the load; a difference that is not on it is something to
investigate, not to wave through.

**24. The dataset's fingerprint** is sha256
`a9596ecf997f186b0dd9d069642560f65120ab7ca97d0a2387863d0157ed8b94` — **unchanged
from Session 3's item 22, and Session 4 did not move it.** Both of Session 4's
disagreements were settled without editing the workbook: the Land Reform Act's
Royal Assent because the dataset was right and the fact sheet wrong, and the
National Galleries Act's introduction date because the fact sheet was right, which
is recorded on the staging line with source `manual` rather than by correcting the
file. The eight Session 4 names that differ from the fact sheet's are paired by
hand in `tools/phd_stage_dates.py` — the four Budget Acts, which the dataset
numbers within the session, and four wording slips — not corrected either.

**This is the one item a later session can move.** Adjudicating a disagreement for
Session 5 or beyond corrects the file and the fingerprint changes with it. Record
the new one beside the old; nothing else about Session 4 is reopened by it.

**Moved once since this was written, by Part B item 7 rather than by a later
session.** On 2026-09-14 the owner ruled that the working file is corrected
whenever it is found to be wrong, the original dataset behind the 2021 thesis
being held separately for posterity, and the National Galleries introduction date
was corrected in it from 26 to 25 June 2015. The fingerprint is now
`6614b3a1871367284c452ff8564b213532c1ec786f344acb7d350131c135420f`; it was
`a9596ecf…57ed8b94` when this test was marked. The eight paired names are still
paired and not corrected, and the Land Reform Act's Royal Assent still stands as
the dataset always had it. Checked against a copy taken before the change:
exactly one cell differs on the data sheet -- D294 -- and seventeen on the
Corrections sheet, being the new note, its header row and its one entry.
`tools/phd_stage_dates.py` gives byte-identical output from the file before and
after, checksum `47fe0846…be1b3384`, so none of the 522 stage dates the clean
sheet holds from the dataset is affected, and `tools/compare_sources.py` now
finds all 73, 81, 62 and 86 lines paired with no difference in any of the four
sessions. Item 24 passes on the new fingerprint; no other item is reopened.

**25. Promotion is still reversible.** Take Session 4 off and put it back inside a
transaction that is thrown away, and the result is identical. The procedure is in
`docs/PROMOTION-RUNBOOK.md`. Session 4 is the largest session yet at 86 bills, the
first with five Private Bills in it, and the first whose promotion writes a
provenance note for a bracketed value, so this is not a formality.

**26. Every period is counted, or has a stated reason.** `tools/duration_coverage.sql`
runs clean: **1065 counted**, and not counted 21 plus whatever points the two
endings add — 19 of the 21 being stages that never reached their terminal point
and 2 stages that never happened, all of them from Sessions 1 to 3. No third
category; the script stops if one appears.

**Corrected on 2026-09-14, after the test was run: 1065, not 1064.** As written,
this item said 1064 is 743 plus Session 4's 321 — 79 bills passed, each counted
at four points (introduction to the first stage, then each stage to the next,
then the last stage to Royal Assent) = 316, and 5 bills rejected at Stage 1
counted from introduction to that decision = 5. **Session 4 has six non-passing
bills with a dated Stage 1, not five.** The Footway Parking Bill completed Stage
1 on 1 March 2016, three weeks before the session ended, so introduction to that
stage is a real period of 286 days and is counted. That is the very thing the
session before this one established, and the derivation was written without it.
Session 4's figure is 322 and the total 1065; Sessions 1 to 3's 743 is unmoved.
The per-stage table should read:

| Counted to | Periods |
|---|---|
| introduction → stage_1 | 266 |
| introduction → preliminary | 17 |
| introduction → final | 1 |
| stage_1 → stage_2 | 244 |
| preliminary → consideration | 17 |
| stage_2 → stage_3 | 244 |
| consideration → final | 16 |
| stage_3 → royal_assent | 243 |
| final → royal_assent | 17 |

**27. The repository is clean** and level with GitHub, and the migrations are
numbered without a gap.

### Part B — the owner's sign-off

None of these is for anyone else to answer. A sign-off is recorded here on the
day it is given, and nowhere else.

1. **What happened to each bill.** The counts in items 6 and 7 are what you
   expect for Session 4: the reconciliation against page 9 of the fact sheet in
   every cell and both margins, and the split of its six fallen bills into five
   rejected at Stage 1 and one that ran out of time. **Given 2026-09-14**, on
   the twelve cells and both margins read back beside page 9, and on the six
   named bills split five rejected at Stage 1 -- Assisted Suicide, Pentland
   Hills, Alcohol, Transplantation and Criminal Verdicts -- and one out of time
   at dissolution, the Footway Parking and Double Parking Bill.
2. **The five bills read in the Official Report.** For each, the quotation on the
   line and the ending recorded against it: Alcohol, Assisted Suicide, Criminal
   Verdicts and Pentland Hills rejected at Stage 1 on the member's own motion put
   and disagreed to; Transplantation rejected on that motion amended and agreed
   to. You predicted the fifth from the shape of the record before it was read;
   the sign-off is on the record as it was found, not on the prediction.
   **Given 2026-09-14**, on the five lines read out in the source's own words
   beside the ending recorded against each, including that the Criminal Verdicts
   motion is the one of the five the page names no member for, and that the
   Transplantation line's route quotes the division on the amendment, being what
   the route records, with both divisions on the line recording the outcome.
3. **The Transplantation Bill's motion as amended, read in full** as it will be
   published beside the bill, and that quoting the resolution — a soft opt-out
   system, a consultation, legislation next session if appropriate — is what you
   want a reader to see beside a bill counted as rejected at Stage 1.
   **Given 2026-09-14**, on the published note read out in full as it stands
   after `db/069`, with both divisions in it and the motion as amended quoted
   entire.
4. **The two endings you establish** for the Inquiries into Deaths Bill and the
   Footway Parking and Double Parking Bill, checked against the clean sheet
   rather than against the note of them, including whether the Footway Parking
   Bill's Stage 1 of 1 March 2016 is recorded and from what.
   **Given 2026-09-14**, on both endings read off the clean sheet: the Inquiries
   into Deaths Bill withdrawn on 24 September 2015 with one stage row, undated,
   marked where the bill ended; and the Footway Parking Bill's Stage 1 recorded
   as completed on 1 March 2016 from the Official Report of that day, ending at
   an undated Stage 2, against the Parliament's current bill page labelling it
   fallen at Stage 1.
5. **The two adjudicated dates and the two cells the fact sheet prints short**,
   and that the corrections are the ones you intended: the Land Reform Act's
   Royal Assent settled your dataset's way against legislation.gov.uk; the
   National Galleries Act's introduction date settled the fact sheet's way on
   your own record; and the Higher Education Governance Act's title and number,
   which the fact sheet prints with no year, taken from legislation.gov.uk — each
   with its source, its place in that source, the value in the source's own words
   and the day it was read, and the fact sheet's printed words left untouched
   beside them. **Given 2026-09-14**, on all four cells read out beside the fact
   sheet's own printed words: the Land Reform Act's Royal Assent of 22 April 2016
   against the fact sheet's 22 March; the National Galleries Act's introduction
   of 25 June 2015 against the dataset's 26 June; and the Higher Education
   Governance Act's title and number given their year, which the fact sheet
   prints without.
6. **The eight names paired by hand**, checked against the fact sheet and your
   dataset side by side: the four Budget Acts, which your dataset numbers within
   the session where the fact sheet gives the Act's short title, and the four
   wording slips. Every one agrees on both dates the two sources share.
   **Given 2026-09-14**, on the eight pairs read out side by side with the dates
   each shares -- the four Budget Acts and the four slips, Freedom of Information,
   Inquiries into Fatal Accidents, Land and Buildings Transaction Tax and
   Pentland Hills, the last sharing only its introduction date, having never
   become an Act.
7. **Whether the National Galleries introduction date should be corrected in your
   workbook.** Session 3's equivalent — the Autism Bill's Stage 1 date — was
   corrected in the file and the fingerprint moved with it. This one was settled
   on the staging line instead and the file left alone, so the dataset still says
   26 June 2015 where the database says 25 June. Either is defensible; they should
   not be decided differently by accident. Your call, and item 24 moves if you
   correct it. **Given 2026-09-14: corrected.** The owner ruled that this file is
   the live working copy and is corrected whenever it is found to be wrong, the
   original dataset behind the 2021 thesis being held separately for posterity.
   So Session 3's handling is the rule and Session 4 now follows it. The cell was
   changed from 26 to 25 June 2015, the Corrections sheet carries the change with
   its reason and what it was checked against, and item 24 carries the new
   fingerprint.
8. **The Parliament's own styling changing inside Session 4**: 15 government
   bills recorded as introduced when they were styled Executive Bills and 52 as
   Government Bills, against 67 counted as government throughout — and that M1
   says what you want said to a reader who notices. (**This item named M4 when it
   was written, which is the Hybrid Bill note and the wrong one; the note that
   covers the styling change is M1. Corrected on 2026-09-14 while the item was
   being marked, and the correction put to the owner rather than made silently.**)
   **Given 2026-09-14**, on the split read off the clean sheet -- 15 styled
   Executive, introduced between 16 June 2011 and 27 June 2012, and 52 styled
   Government, between 3 October 2012 and 28 January 2016, a clean break with no
   overlap -- and on M1's wording read out in full.
9. **That you can explain how this database works** from the documents alone,
   without help. The standing requirement, put again because Session 4 is the
   largest session so far and the first whose bills carry two different
   contemporaneous labels. Check `docs/HOW-THE-DATABASE-WORKS.md` is current
   before reading it: its counts still say 216 bills and 71 provenance notes, and
   the session that promotes Session 4 has to bring them to 302 and 86.
   **Given 2026-09-14.** The document was checked first and found level with the
   database at 302 and 86, but with one thing missing and one thing wrong, both
   put right before it was read: it never said where the note a reader sees lives
   on the clean sheet, which is where the two published divisions went, and M7
   still said the coding of why a bill fell had been done for three sessions when
   Session 4 made it four (`db/070`).

### Part C — what this test does not check

- **Whether the Session 4 dates nobody has checked are right.** 78 of the 79
  Royal Assent dates and 85 of the 86 introduction dates have never been checked
  against legislation.gov.uk or the Parliament's pages. The dataset agrees with
  every one of them, which is corroboration and not verification; M8 says which a
  reader has.
- **Whether the 158 Stage 1 and Stage 2 dates are right.** They rest on the
  dataset alone, and nothing has been compared against them.
- **Whether the Official Report was read correctly beyond the words quoted.**
  Nobody has read the surrounding debate for any of the five.
- **The wording of the amendment that defeated the Transplantation Bill.**
  S4M-15128.1 is named but not printed; the page the division was read on gives
  the question the Presiding Officer put and the two results, and not the
  amendment's own text.
- **Whether the Official Report and the bill page are right** about the two
  endings. The Footway Parking Bill in particular is recorded against the
  Official Report and *against* the current bill page's own label, which says it
  fell at Stage 1; the reasoning is in the section above, and a reader who thinks
  the label means what it says would code that bill differently.
- **Bills carried over between sessions.** Four bills appear in two fact sheets,
  and the double-count guard is not built. Nothing in Session 4 trips it —
  `STATE.md` has it due before Session 6 is loaded — so this test does not
  exercise it, and passing says nothing about it. No Session 4 bill appears in
  the Session 5 fact sheet under the same title, the Footway Parking Bill
  included, which was checked rather than assumed.
- **Anything about Sessions 5 to 7**, including the prose reader and the three
  bills Session 5's fact sheet lists as passed with no Royal Assent yet.

---

## Session 3

Written 2026-09-13 by the session that reviewed it and coded the nine bills that
did not pass.

**Run on 2026-09-13** by a session that did none of the work it tests: it did
not promote Session 3, did not load or admit the stage dates, and did not make
the change at `db/060`. **All twenty-four mechanical items pass.** Twenty-one
matched the expected answer as written. Three did not, and in all three the
data was right and the expected answer was wrong; each is corrected below with
the reason beside it, and the corrections are the only change made to this
test.

- **Item 15**, M2's length. Written against `db/055` as 3661; `db/060` amended
  M2 deliberately and it is 4347. The prediction went stale.
- **Item 19**, the Stage 1 dates of bills that did not pass. Five rows, not
  four. The fifth is the Budget (Scotland) (No.2) Bill's Stage 1 from the
  dataset, which this test's own item 11 predicts. The four the Official Report
  dates all say `official_report`, which is what the item checks.
- **Item 21**, the reader. 62 rows and not one of the fact sheet's own words
  differs, with nothing supplied but the PDF and the session number. Ten
  worked-out cells differ, not eight: the two extra are the bills that fell at
  dissolution, which `db/051` stopped the reader deciding. Applying the
  dissolution rule afresh to that reading returns exactly those two, none over
  and none missing.

Item 23 was rehearsed inside a transaction that was thrown away: 62 bills, 170
stage records and 15 provenance notes off, the same back on, and no unexpected
difference anywhere on either sheet. The working copy was compared and dropped.

`tools/duration_coverage.sql` was run in the same session and passes: of 764
points where a period could be counted, 743 are counted, 19 have no day because
the stage never reached its terminal point, and 2 did not happen. No third
category.

**Part B is marked. All nine sign-offs were given on 2026-09-13**, across two
sessions of that day: 1, 2, 3 and 7 in the first, and 4, 5, 6, 8 and 9 in the
second. Each is recorded against its own item with what it was given on.

**Session 3 is therefore closed.**

**When to run it.** When Session 3 is on the clean sheet *and* its Stage 1 and
Stage 2 dates are loaded. Closure means the session is finished, and Session 3
is not finished until its dates are in; run before that and the counts are of a
session half admitted.

**What that means for the two pieces of work still to come.** Promotion and the
stage-date load have not happened yet, so every expected answer below about them
is a prediction made from the fact sheet, the dataset and the rules — not a
description of a database anyone has looked at. That is deliberate. It makes
this test the independent check on the session that extends
`tools/phd_stage_dates.py` and runs the promotion, neither of which wrote it.

**The one item an outside change can move** is item 22, the dataset's
fingerprint. Nothing else here is reopened by later work.

**What this test does not put again.** Sessions 1 and 2 and their corrections
are settled; where an answer below covers the whole database it is because
Session 3 moves it, and the Sessions 1 and 2 part of it is taken from their own
test rather than re-derived.

### Part A — mechanical

Run `tools/closure_check_session_3.sql`. It reads only and changes nothing.
Compare each numbered result against the expected answer.

**1. Counts.** bills 216, stage_records 583, provenance_notes 71,
checker_problems 0, gaps 0, staging_lines 216, stage_date_rows 583.

- 216 is 154 plus the Session 3 fact sheet's own total of 62.
- 583 is 413 plus Session 3's 170, and the 170 should be checked as a
  derivation: 53 bills passed × 3 stages = 159; the Budget (Scotland) (No.2)
  Bill was rejected at Stage 3, so it has all three = 3; the Creative Scotland
  Bill completed Stage 1 and then fell = 1; the 3 rejected at Stage 1, the 2
  withdrawn and the 2 that fell at dissolution have one each = 7.
  159 + 3 + 1 + 7 = 170.
- 71 is 56 plus 15: 5 outcomes read from the Official Report, 3 Stage 1 routes
  from the same, 2 bills coded as having fallen at dissolution, and 5 cells
  checked at review against the source that owns them — two Royal Assent dates
  and one asp number at legislation.gov.uk, one introduction date and one bill
  type at the Parliament's bill pages.
- 0 and 0 are the rule. The 108 gaps that stood open on 13 September are the
  Stage 1 and Stage 2 dates this load supplies; a gap left after it is a
  question about a bill.

**2. Every staging line reviewed, admitted, on the clean sheet and compared.**
Session 1: 73 accepted, 73 promoted, 73 compared. Session 2: 81, 81, 81.
Session 3: 62, 62, 62. No other review status appears. From the fact sheets'
totals and the rule that nothing reaches the clean sheet unaccepted.

**3. Every stage-date row.** Session 1: 200 accepted, 200 carried. Session 2:
213, 213. Session 3: 170, 170. No other status. Session 3's 170 is item 1's
derivation: 62 rows already on the sheet, plus the 108 this load adds.

**4. A recorded difference with no adjudication.** 0. Session 3 recorded three
and all three were settled on 12 September.

**5. What has been checked against the source that owns it.**

| Field | Source | Cells |
|---|---|---|
| `asp_number` | `legislation_gov_uk` | 1 |
| `bill_type` | `bill_page` | 1 |
| `date_completed` | `bill_page` | 1 |
| `date_first_meeting` | `spice_factsheet_dates` | 7 |
| `date_introduced` | `bill_page` | 5 |
| `date_royal_assent` | `legislation_gov_uk` | 10 |
| `date_session_end` | `spice_factsheet_dates` | 6 |
| `outcome` | `official_report` | 16 |
| `outcome` | `spice_factsheet_dates` | 9 |
| `short_title` | `manual` | 1 |
| `stage_1_rejection_route` | `official_report` | 14 |

Sessions 1 and 2 account for 56 of these. Session 3 adds fifteen: the Forced
Marriage etc. Act's asp number, which its fact sheet omits; the Forth Crossing
Act's type; the Criminal Procedure Act's introduction date; the Double Jeopardy
and Forced Marriage etc. Acts' Royal Assent dates; five outcomes from the
Official Report; two from the dates fact sheet, being the bills coded as having
fallen at dissolution; and three Stage 1 routes.

**6. Reconciliation.** Our counts must match the fact sheet's own summary table
in every cell and both margins. These figures are read off page 8 of the Session
3 fact sheet, not out of the database:

| Session 3 | Executive | Member's | Private | Committee | Total |
|---|---|---|---|---|---|
| Acts | 42 | 7 | 2 | 2 | 53 |
| Withdrawn | 0 | 2 | 0 | 0 | 2 |
| Fallen | 3 | 4 | 0 | 0 | 7 |
| **Total** | **45** | **13** | **2** | **2** | **62** |

The script's rows are `acts`, `fallen` and `withdrawn`, and its
`government_or_hybrid` column answers the fact sheet's "Executive".

**On `bill_type` alone**: government 44, hybrid 1, members 13, private 2,
committee 2. This is where Session 3 differs from every session before it. The
fact sheet's summary has no Hybrid column and counts the Forth Crossing Act
under Executive, so its 45 is our 44 plus 1, and its Acts row of 42 is our 41
plus 1. That is methodology note M4, and it is why the reconciliation is done on
`analysis_group`.

**7. Outcomes.** 53 passed and enacted; 3 rejected at Stage 1; 1 rejected at
Stage 3; 2 withdrawn; 2 fell at dissolution; 1 fell because its financial
resolution was not agreed. Every non-passing bill is `not_enacted`.

The fact sheet gives the row totals only — 53 Acts, 2 withdrawn, 7 fallen.
Splitting the 7 into 3 + 1 + 2 + 1 is ours, methodology note M7: five from the
Official Report of the day, two from the day the session ended.

**8. Required cells.** Every column 0.

**9. Every Session 3 Act.** 53 enacted, 0 without an asp number, 0 without an
assent date, 0 where the asp number's year disagrees with the assent year. 53 is
the fact sheet's own Acts total.

**10. Stage records per bill.** passed 3 stages × 53; rejected at Stage 3
3 × 1; rejected at Stage 1 1 × 3; withdrawn 1 × 2; fell at dissolution 1 × 2;
fell for want of a financial resolution 1 × 1. This is item 1's derivation seen
per bill; the two must agree.

**11. Where every Session 3 stage date came from.** `phd` 108 (all dated),
`spice_factsheet_legislation` 53 (all dated), `official_report` 5 (all dated),
`bill_page` 4 (all undated), and nothing recorded as a stage that never
happened.

- **108** is 54 bills × Stage 1 and Stage 2. The 54 is the 53 that passed plus
  the Budget (Scotland) (No.2) Bill, which reached Stage 3. Counted in the
  dataset itself rather than in the database: of its 62 Session 3 rows, 58 carry
  a Stage 1 date and 54 a Stage 2 date. The four with a Stage 1 date and no
  Stage 2 date are bills the Official Report already dates, and nothing is
  written for them — the rule Sessions 1 and 2 set.
- **53** is each Act's passing date, off the fact sheet.
- **5** is the four Stage 1 decisions and the one Stage 3 decision read in the
  Official Report.
- **4** is the bills whose ending the owner established from the Parliament's
  bill pages. None is dated, because none ended on a decision of the Parliament.

Across the whole clean sheet: `phd` 364, `spice_factsheet_legislation` 181,
`official_report` 19 (2 undated), `bill_page` 19 (all undated), 2 recorded as
stages that never happened.

**12. Two accepted rows for the same stage.** 0, in every session, and the
listing that follows it returns nothing. A non-zero answer for Session 3 means
the loader wrote a second Stage 1 row for one of the four bills the Official
Report already dates. That is not automatically wrong — the precedence rule
exists for it, and since the Autism correction all four agree to the day — but
item 19 then has to say `official_report` for every one of them, and the
duplicate rows want an explanation.

**13. How each Stage 1 rejection came about.** `member_motion_disagreed` 11
bills, 0 with a note; `member_motion_amended_agreed` 1 bill, 1 with a note;
`committee_motion_9_14_18` 2 bills, 2 with notes. `other_route` should not
appear. 11 is Sessions 1 and 2's 8 plus Session 3's 3, all three of which went
the ordinary way and so add no reader's note.

**14. Every source on the list has a definition.** Nine sources, all true. Stage
records as item 11. `bill_rows` is `spice_factsheet_legislation` 216 and every
other source 0 — a bill's own line always comes from a legislation fact sheet.
Cells: `bill_page` 7, `legislation_gov_uk` 11, `official_report` 30,
`spice_factsheet_dates` 22, `manual` 1; `api`, `bill_document`, `phd` and
`spice_factsheet_legislation` 0.

**15. The notes a reader is given.** M1 to M8, eight of them, none empty, and
M7 the only one that mentions a financial resolution. Their lengths: M1 358,
M2 4347, M3 1088, M4 971, M5 1940, M6 1605, M7 4361, M8 2673. A length that has
moved means somebody edited a note; find out who and why before marking
anything.

**Corrected on 2026-09-13 by the session that ran this test.** The figures were
written against `db/055` and M2 was given as 3661. `db/060` then amended M2
deliberately, to say that a stage is counted where the Parliament took the
decision that ends it whatever it decided, and the test was not brought forward
with it. M2 is 4347 characters and the other seven have not moved. The check
itself stands: a length that moves still means a note was edited.

**Corrected again on 2026-09-13, later the same day.** `db/061` amended M2 a
second time, to say what the general note on a stage row is and what an empty
detail note means. M2 is 5140 characters and the other seven have not moved.

**M7 moved on 2026-09-14**, after Session 3 was closed: `db/069` added a
paragraph about the division figures now published beside a bill rejected at
Stage 1 by an unusual route. M7 is 5001 characters and the other six are as
above. Nothing about Session 3's own data is reopened by it.

**16. Notes on the Session 3 staging lines.** 9 with a review note, 1 with a
note for readers, 60 the reader remarked on. The one reader's note is the Forth
Crossing Act's. This item is also a prompt to read what is written there before
signing anything off.

**17. The bill that did not end at a stage.** One row: the Creative Scotland
Bill, `fell_financial_resolution_not_agreed`, concluded 18 June 2008, 1 stage
record, 1 completed stage, **0 stages it fell at**. The zero is the whole point
of the new ending: the Parliament agreed the bill's general principles, and it
fell afterwards on a vote that is not part of any stage.

**18. Every bill that did not pass says where it ended.** 0.

The listing that follows shows the nine Session 3 bills that did not pass. Eight
name a stage; the Creative Scotland Bill's stage columns are empty, which is
item 17. Of the eight, four are dated — Autism `stage_1` 12 January 2011, End of
Life Assistance `stage_1` 1 December 2010, Protection of Workers `stage_1` 22
December 2010, Budget (No.2) `stage_3` 28 January 2009, every one
`official_report` — and four are undated: the two withdrawn bills and the two
that fell at dissolution, none of which ended on a decision of the Parliament.

**19. The Stage 1 dates held for a Session 3 bill that did not pass.** Five
rows. Four are the ones the Official Report dates, and **every one of those four
must say `official_report`**: Autism 12 January 2011, Creative Scotland
18 June 2008, End of Life Assistance 1 December 2010, Protection of Workers
22 December 2010. If any says `phd`, the dataset's date has been carried in
place of the Official Report's and this item fails.

The fifth is the Budget (Scotland) (No.2) Bill, Stage 1 on 14 January 2009, and
it must say `phd`. The Official Report gives that bill its Stage 3, not its
Stage 1; its Stage 1 and Stage 2 come from the dataset like every other bill
that reached Stage 3.

**Corrected on 2026-09-13 by the session that ran this test.** The item was
written expecting four rows and the query it is written against returns every
Session 3 bill that did not pass and has a dated Stage 1, which is five. The
fifth was predicted by this test's own item 11 — the 108 dates are 54 bills'
worth, being the 53 that passed plus the Budget Bill — and the omission was in
the expected answer, not in what was loaded.

It mattered for one of them, and no longer does. The dataset dated the Autism
Bill's Stage 1 at 17 January 2011 against the Official Report's 12 January; the
owner settled it on 13 September and the dataset is corrected. All four now
agree with the Official Report to the day, so this item is checking that the
load left the more primary source in place, not adjudicating anything.

### Then, outside the script

**20. The data dictionary is still true.**
`python3 tools/make_data_dictionary.py` produces no difference from the
committed file beyond its own date line.

**21. The reader still reproduces what was loaded.** Extract the Session 3 fact
sheet afresh and compare against the staging lines' raw columns: 62 rows, 0
differing.

    extract_factsheet.py <pdf> --session 3 --csv out.csv

**Nothing may be supplied to the reader but the PDF and the session number.**
That is what this item is for.

**The worked-out columns that must differ, and only these** — ten cells across
nine bills:

- `outcome` on all seven bills the fact sheet's Fallen table holds, because
  since `db/051` the reader decides none of them. Five the fact sheet does not
  explain, and which were read in the Official Report: Autism, Budget (Scotland)
  (No.2), Creative Scotland, End of Life Assistance, Protection of Workers. Two
  that ran out of time, which are worked out after the reading from the day the
  session ended: Commissioner for Victims and Witnesses, and Long Leases.
- `date_royal_assent` on two, corrected against legislation.gov.uk: Double
  Jeopardy and Forced Marriage etc.
- `asp_number` on one, which the fact sheet omits: Forced Marriage etc.

`outcome` must **not** differ on the two withdrawn bills. The reader reads the
Withdrawn table and codes them itself.

**Also check the dissolution rule afresh**, as Sessions 1 and 2's item 18 does:
of the seven fallen bills in the fresh reading, exactly those concluding on
Session 3's last day of 22 March 2011 are the ones coded `fell_dissolution`,
none over and none missing. That is what makes the two extra differences a
rule being applied rather than a coding nobody can reproduce.

**Corrected on 2026-09-13 by the session that ran this test.** The item was
written listing eight cells across seven bills, from what was changed after the
load, and missed the two bills that fell at dissolution: `db/051` took that
decision away from the reader precisely so that it would be reproducible from
the session's last day, so their outcomes were always going to differ from a
fresh reading. Sessions 1 and 2's test records the same behaviour for all
eighteen of their fallen bills. The omission was in the expected answer.

`bill_type` must **not** differ. The fact sheet's own table types the Forth
Crossing Act H, and the owner's reading of the bill page agreed with it; only
the summary page disagrees, and the reader does not read the summary page. The
reader produces no `stage_1_rejection_route`, `bill_note` or
`official_report_read_on` at all, so those are not comparisons.

This session did not run this. The list above is a prediction from what was
changed after the load; a difference that is not on it is something to
investigate, not to wave through.

**22. The dataset's fingerprint** is sha256
`a9596ecf997f186b0dd9d069642560f65120ab7ca97d0a2387863d0157ed8b94`, recorded in
`DECISIONS.md`, 2026-09-13, after the Autism Stage 1 date. It was
`e04dc540…c38ea75` when this test was first drafted, and moved the same day.
**This is the one item a later session can move.** Adjudicating a disagreement
for Session 4 or beyond corrects the file and the fingerprint changes with it.
Record the new one beside the old; nothing else about Session 3 is reopened by
it.

**Moved on 2026-09-14**, after the National Galleries introduction date was
corrected while Session 4's Part B was marked, to
`6614b3a1871367284c452ff8564b213532c1ec786f344acb7d350131c135420f`.
`tools/phd_stage_dates.py` gives byte-identical output from the file before and
after, so Session 3's stage dates are untouched. Item 22 passes on the new
fingerprint; no other item about Session 3 is reopened.

**23. Promotion is still reversible.** Take Session 3 off and put it back inside
a transaction that is thrown away, and the result is identical. The procedure is
in `docs/PROMOTION-RUNBOOK.md`. Session 3 is the first session promoted with a
Hybrid Bill in it and the first with two of the endings, so this is not a
formality.

**24. The repository is clean** and level with GitHub, and the migrations are
numbered without a gap.

### Part B — the owner's sign-off

None of these is for anyone else to answer. A sign-off is recorded here on the
day it is given, and nowhere else.

1. **What happened to each bill.** The counts in items 6 and 7 are what you
   expect for Session 3. **Given 2026-09-13**, on the reconciliation against
   page 8 of the fact sheet: every cell and both margins are the fact sheet's
   own, and the two places we hold more than it does are the Forth Crossing
   Bill's type, which it files under Executive, and the split of its seven
   fallen bills by why they fell. Neither disagrees with it.
2. **The five bills read in the Official Report.** For each, the quotation on
   the line and the ending recorded against it: Autism, End of Life Assistance
   and Protection of Workers rejected at Stage 1 on the member's own motion;
   Budget (Scotland) (No.2) rejected at Stage 3 on the Presiding Officer's
   casting vote; Creative Scotland fallen for want of a financial resolution
   with its general principles agreed. **Given 2026-09-13**, on the five lines
   read out in the source's own words beside the ending recorded against each,
   including that the Creative Scotland Bill's Stage 1 is completed and no stage
   is marked as where the bill ended, there being none to put it on.
3. **The four endings you established from the Parliament's bill pages** — the
   two withdrawn bills and the two that fell at dissolution — checked against
   the clean sheet rather than against the note of them, including that none
   carries a date. **Given 2026-09-13**, on the four endings read off the clean
   sheet, on the day each bill stopped being live being recorded while the Stage
   1 row carries no date, and on all nineteen rows of that kind across the three
   sessions after `db/061` gave them one general note and kept nine detail notes.
4. **The Forth Crossing Act as a Hybrid Bill**, and that M4 says what you want
   said to a reader who is comparing our 44 government bills against the fact
   sheet's 45. **Given 2026-09-13**, on M4 read in full beside the clean sheet's
   row for the bill — recorded as a Hybrid Bill, and passed — and beside the
   Session 3 counts it has to reconcile: 44 government, 13 members', 2 committee,
   2 private and 1 Hybrid, against the fact sheet's stated 45 Executive.
5. **The three adjudicated dates and the asp number**, and that the corrections
   are the ones you intended. **Given 2026-09-13**, on the four cells read off
   the clean sheet beside what the fact sheet printed and what the dataset said:
   two Royal Assent dates settled the dataset's way against legislation.gov.uk,
   one introduction date settled the fact sheet's way against the Parliament's
   bill page, and the asp number the fact sheet omits taken from the same page
   that settles its Royal Assent — each with its source, its place in that
   source, the value in the source's own words and the day it was read, and the
   fact sheet's printed words left untouched beside them.
6. **The ten names corrected in the dataset**, checked against the workbook's
   Corrections sheet. **Given 2026-09-13**, on the ten read off the Corrections
   sheet as was and now — six slips against the Act's own title and the four
   Budget Acts renamed by year — and on all ten of the corrected spellings being
   found on the clean sheet, none missing.
7. **The Autism (Scotland) Bill's Stage 1 date.** The dataset said 17 January
   2011; the Official Report of 12 January 2011 records the motion disagreed to,
   and the fact sheet gives 12 January as the day the bill fell.
   **Given 2026-09-13**: the dataset needed correcting, and it is corrected to
   12 January. It had to be settled before the stage dates were loaded rather
   than at the end, because the loader's behaviour turns on it. What is left for
   the marking session is item 22, the new fingerprint.
8. **M7 as it now stands**, read in full: that it tells a reader what you want
   told about a bill falling for want of a financial resolution, and that saying
   the Parliament's own page is wrong about the Creative Scotland Bill is a
   claim you are content to publish. **Given 2026-09-13**, on M7 read in full,
   including that last claim.

   **And a point of semantics the owner raised, recorded because it will be
   asked again.** If a bill's general principles are agreed and it then cannot
   proceed for want of a financial resolution, at what stage did it fall —
   Stage 1, or a no-man's land between the stages? The owner's answer: arguably
   either, and it does not matter much provided the unusual nature of it is
   caught, which it is. It is caught by the data rather than by the argument:
   the Creative Scotland Bill has one stage row, Stage 1, completed and dated
   from the Official Report, and no stage at all is marked as where the bill
   ended. It is the only bill of 216 that ends that way. The ending is recorded
   on the bill and not pinned to a stage, so the no-man's land is represented as
   no-man's land. M7 does not say so in terms, and the owner did not require it
   to.
9. **That you can explain how this database works** from the documents alone,
   without help. The standing requirement, put again because Session 3 added an
   ending that behaves unlike the others. **Given 2026-09-13**, on
   `docs/HOW-THE-DATABASE-WORKS.md` read cold after it was brought up to date.
   It was six things out of date, because it had not been touched since
   11 September while Session 3 and nine migrations landed: the list of endings
   and the reader's notes were each a row short; the note on a stage row was
   still described as one note in three places; a bill ending with no stage
   marked was not described at all, which is the very thing this item was put
   again for; every session's dates were described as still to come when
   `db/048` had filled them; and the provenance counts at promotion stopped at
   Session 2. All six were corrected before the owner read it. Nothing in the
   database changed.

### Part C — what this test does not check

- **Whether the Session 3 dates nobody has checked are right.** 51 of the 53
  Royal Assent dates and 61 of the 62 introduction dates have never been checked
  against legislation.gov.uk or the Parliament's pages. The dataset agrees with
  every one of them, which is corroboration and not verification; M8 says which
  a reader has.
- **Whether the 108 Stage 1 and Stage 2 dates are right.** They rest on the
  dataset alone, and nothing has been compared against them.
- **Whether the Official Report was read correctly beyond the words quoted.**
  The five quotations were taken from pages cropped into halves, because reading
  those two-column PDFs whole interleaves them into nonsense. Nobody has read
  the surrounding debate.
- **Whether the Parliament's bill pages are right** about the four endings, or
  whether the web archive's copy is the page as it stood.
- **The comparison tool's known gap.** A bill it cannot pair is still recorded
  as compared. Session 3 has none unpaired, so nothing here rests on it, and it
  is not fixed.
- **Anything about Sessions 4 to 7**, including carry-over rows, the
  double-count guard and the prose reader, none of which Session 3 exercises.

---

## Sessions 1 and 2

Written 2026-09-12 by the session that loaded and corrected them.

**Run first on 2026-09-12, by the following session.** All sixteen mechanical
items matched, and items 17, 19, 20 and 21 passed. **Item 18 failed**, on seven
bills: the fact sheet reader could not reproduce the coding of a bill that fell
at dissolution without being handed the session's last day, which was recorded
nowhere. `db/051` and `db/052` moved that comparison onto the staging sheet, and
the expected answers below are corrected for it — items 1, 5, 14 and 18.

**Run again on 2026-09-12** by a session that made none of that change, which is
what marks it. **All twenty-one items pass.** Item 18 now passes as written,
with nothing supplied to the reader but the PDF and the session number: all 154
lines pair, and no raw column differs. Three worked-out columns do, each
accounted for and each carrying its own provenance — the outcome of all
eighteen fallen bills, which the reader no longer decides; five Royal Assent
dates checked against legislation.gov.uk; and one short title corrected at
review. Applying the dissolution rule afresh to that extraction and the session
tab returns exactly the seven bills coded that way, none over and none missing.
Item 20 was rehearsed for both sessions inside a transaction that was thrown
away: no unexpected differences either time.

**`db/053` was applied after the test was marked**, during sign-off 7, and the
mark stands. It changed the wording of M4, M7 and M8 and nothing else: eight
notes before and after, none empty, no column, no value and no bill's coding.
Item 15 tests the count and that none is empty, and neither moved. The only
figures affected anywhere are the word counts quoted at item 7 of Part B.

### Part A — mechanical

Run `tools/closure_check_sessions_1_2.sql`. It reads only and changes nothing.
Compare each numbered result against the expected answer.

**1. Counts.** bills 154, stage_records 413, provenance_notes 56,
checker_problems 0, gaps 0, staging_lines 154, stage_date_rows 413.

- 154 is the two factsheets' own totals, 73 and 81.
- 413 is derived and should be checked as a derivation, not taken on trust:
  128 bills passed × 3 stages = 384; of the 26 that did not pass, 24 have one
  stage each, the Gaelic Language Bill has two (Stage 1 completed, stopped at
  Stage 2) and the Session 1 Robin Rigg Bill has three (Preliminary and
  Consideration completed, stopped at Final) = 29. 384 + 29 = 413.
- 56 is 11 outcomes + 11 rejection routes + 1 title corrected at review + 13
  dates checked against the source that owns them + the 13 session dates loaded
  by `db/048` + the 7 bills coded as having fallen at dissolution, which gained
  a note each at `db/051`. It was 36 before the session dates and 49 before
  those seven; a session date is a fact about a session rather than about a
  bill, and carries its provenance like any other.
- 0 and 0 are the rule: a session cannot be promoted while the checker has
  anything, and a gap is a completed stage with no date and no explanation.

**2. Every staging line reviewed, admitted, on the clean sheet and compared.**
Session 1: 73 accepted, 73 promoted, 73 compared. Session 2: 81, 81, 81. No
other review status appears. From the factsheets' totals and the rule that
nothing reaches the clean sheet unaccepted (`db/044` for compared).

**3. Every stage-date row.** 413 accepted, 413 carried. No other status.

**4. A recorded difference with no adjudication.** 0. The rule is `db/044`: a
difference the comparison found is a problem until the owner has settled it.

**5. What has been checked against the source that owns it.**

| Field | Source | Cells |
|---|---|---|
| `date_completed` | `bill_page` | 1 |
| `date_first_meeting` | `spice_factsheet_dates` | 7 |
| `date_introduced` | `bill_page` | 4 |
| `date_royal_assent` | `legislation_gov_uk` | 8 |
| `date_session_end` | `spice_factsheet_dates` | 6 |
| `outcome` | `official_report` | 11 |
| `outcome` | `spice_factsheet_dates` | 7 |
| `short_title` | `manual` | 1 |
| `stage_1_rejection_route` | `official_report` | 11 |

The thirteen adjudicated dates are the owner's of 2026-09-12; the eleven
outcomes and routes are the Stage 1 rejections; the title is the one corrected
at review (`DECISIONS.md`, 2026-09-10). The thirteen session dates are `db/048`:
seven first meetings and six session ends, Session 7 having no end because it is
still running. The seven outcomes against the dates fact sheet are `db/051`: the
bills coded as having run out of time at dissolution, each note citing the same
document, page and reading date as its session's last day, because that is what
the coding rests on.

**6. Reconciliation.** Our counts must match each factsheet's own summary table
in every cell and both margins. These figures are read off the factsheets, not
out of the database — Session 1 page 7, Session 2 page 8:

| Session 1 | Executive | Member's | Private | Committee | Total |
|---|---|---|---|---|---|
| Acts | 50 | 8 | 1 | 3 | 62 |
| Withdrawn | 1 | 2 | 0 | 0 | 3 |
| Fallen | 0 | 6 | 2 | 0 | 8 |
| **Total** | **51** | **16** | **3** | **3** | **73** |

| Session 2 | Executive | Member's | Private | Committee | Total |
|---|---|---|---|---|---|
| Acts | 53 | 3 | 9 | 1 | 66 |
| Withdrawn | 0 | 5 | 0 | 0 | 5 |
| Fallen | 0 | 10 | 0 | 0 | 10 |
| **Total** | **53** | **18** | **9** | **1** | **81** |

The script's `government_or_hybrid` column answers the factsheets' "Executive",
which is methodology note M1. Neither session has a Hybrid Bill, so for these
two the distinction does not bite; from Session 3 it does.

**7. Outcomes.** Session 1: 62 passed and enacted, 3 withdrawn, 5 rejected at
Stage 1, 3 fell at dissolution. Session 2: 66, 5, 6, 4. Every non-passing bill
is `not_enacted`.

The factsheets give the row totals (62/3/8 and 66/5/10). Splitting "fallen" into
rejected-at-Stage-1 and fell-at-dissolution is ours, not the factsheets' —
methodology note M7 — and rests on the Official Report for the eleven
rejections. 5 + 6 = 11 rejections, and 3 + 4 = 7 fell at dissolution.

**8. Required cells.** Every column 0. Nothing the database demands is empty,
and every bill has an introduction date.

**9. Every Act.** 128 enacted, 0 without an asp number, 0 without an assent
date, 0 where the asp number's year disagrees with the assent year. 128 is
62 + 66 from the factsheets.

**10. Stage records per bill.** passed 3 stages × 128; rejected at Stage 1
1 stage × 11; withdrawn 1 stage × 8; fell at dissolution 1 stage × 5, 2 × 1,
3 × 1. The two- and three-stage cases are the Gaelic Language Bill and the
Session 1 Robin Rigg Bill; both are in `DECISIONS.md`, 2026-09-11.

**11. Where every stage date came from.** `phd` 256 (all dated),
`spice_factsheet_legislation` 128 (all dated) — called `spice_factsheet` until
`db/047` — `official_report` 14 (2 undated), `bill_page` 15 (all undated),
and 2 recorded as stages that never happened, both on the Session 2 Robin Rigg
Act. 256 is 128 bills that passed × Stage 1 and Stage 2. 128 is their passing
date. The undated rows are stages a bill stopped at where no decision of the
Parliament ended it.

**12. Two accepted rows for the same stage.** 0. Nothing has ever competed, so
the order of precedence has never had a case to decide in the real data —
`DECISIONS.md`, 2026-09-12. It was proved on planted rows and thrown away.

**13. How each Stage 1 rejection came about.** `member_motion_disagreed` 8 bills,
0 with a note; `member_motion_amended_agreed` 1 bill, 1 with a note;
`committee_motion_9_14_18` 2 bills, 2 with notes. The single amended-motion case
is the Proportional Representation (Local Government Elections) (Scotland) Bill.
`other_route` should not appear at all.

**14. Every source on the list has a definition.** Nine sources since `db/047`,
`has_a_definition` true for all. `api`, `bill_document`, `manual` and
`spice_factsheet_dates` carry no stage records — `bill_document` holds nothing by
design since `db/042` and its own description says so, and the dates factsheet
says when sessions began and ended, which is not a stage of a bill. The dates
fact sheet's cells are 20: the 13 session dates, and the 7 outcomes that rest on
them (`db/051`). It was 13 before that.

**15. The notes a reader is given.** M1 to M8, eight of them, none empty.

**16. Notes on the staging lines.** No expected figure. This is a prompt to look
at what is written there before signing anything off.

### Then, outside the script

**17. The data dictionary is still true.** `python3 tools/make_data_dictionary.py`
produces no difference from the committed file beyond its own date line.

**18. The reader still reproduces what was loaded.** Extract both factsheets
afresh and compare against the staging lines' raw columns: 154 rows, 0
differing. This is the check that the reader changes of 2026-09-12 left these
two sessions untouched.

**Nothing may be supplied to the reader but the PDF and the session number.**
That is the point of the item, and it is what it failed on when it was first
run: the reader took the session's last day as a command-line setting and used
it to code seven bills, so the answer depended on what had been typed rather
than on the fact sheet. `db/051` took that setting away. A run that needs
anything else typed is a failure of this item, whatever it produces.

    extract_factsheet.py <pdf> --session N --csv out.csv

**19. The dataset's fingerprint** matches the one recorded in `DECISIONS.md`,
2026-09-12, for the corrected working copy. **This is the one item a later
session can move.** Adjudicating a disagreement for Session 3 or beyond may
correct the dataset file, and the fingerprint changes when it does. Re-check
this item then, and record the new fingerprint beside the old; nothing else
about Sessions 1 and 2 is reopened by it.

**Moved twice since the mark, and re-checked both times.**
`c0d386c1…c688999` when this test was marked on 2026-09-12; then
`e04dc540…c38ea75` later that day, after Session 3's ten names and the Criminal
Procedure date; now
`a9596ecf997f186b0dd9d069642560f65120ab7ca97d0a2387863d0157ed8b94`, on
2026-09-13, after the Autism Stage 1 date; and now
`6614b3a1871367284c452ff8564b213532c1ec786f344acb7d350131c135420f`, on
2026-09-14, after the National Galleries introduction date. Nothing on the clean
sheet moved on any occasion. `tools/phd_stage_dates.py` gives byte-identical output from
every version of the file — checked across the first three on 2026-09-12, across
the fourth on 2026-09-13 and across the fifth on 2026-09-14 — so the 256 Stage 1
and Stage 2 dates
Sessions 1 and 2 hold are untouched. Item 19 passes; no other item is reopened.

**20. Promotion is still reversible.** Take a session off and put it back inside
a transaction that is thrown away, and the result is identical. The procedure is
in `docs/PROMOTION-RUNBOOK.md`.

**21. The repository is clean** and level with GitHub, and the migrations are
numbered without a gap.

### Part B — the owner's sign-off

None of these is for anyone else to answer. A sign-off is recorded here on the
day it is given, and nowhere else.

1. **What happened to each bill.** The counts in items 6 and 7 are what you
   expect for both sessions. **Given 2026-09-12.**
2. **The eleven Stage 1 rejections**: the route recorded for each, and the three
   notes a reader will see. Three, not four: eight rejections went the usual way
   and carry no note, one went by an amended motion and two by a committee
   motion under Rule 9.14.18. The fourth note a reader sees in these two
   sessions belongs to the Session 2 Robin Rigg Act, which passed, and is item
   4's business. **Given 2026-09-12.**
3. **The sixteen bills where you established where each ended**, as recorded in
   `DECISIONS.md`, 2026-09-11. Checked against the clean sheet, not against the
   note of it: it matches your answers in every cell. **Given 2026-09-12.**
4. **The Session 2 Robin Rigg Act's** Preliminary and Consideration Stages,
   recorded as stages that never happened. Both halves put and both content:
   that "never happened" is the right record rather than an empty cell, and
   that a reintroduced Private Bill carries its earlier scrutiny forward rather
   than repeating it. **Given 2026-09-12.**
5. **The thirteen adjudicated dates**, and that the five corrections are the
   ones you intended. Eight confirmations left standing and five corrections
   kept, all five Royal Assent dates against legislation.gov.uk.
   **Given 2026-09-12.**
6. **The nine corrections** on the Corrections sheet of the working dataset.
   Checked against the workbook itself: all nine recorded with what each was
   checked against, and the Dates sheet holds the corrected value in every one.
   **Given 2026-09-12.**
7. **M1 to M8**: that they tell a reader what you want told, and claim nothing
   you would not defend. Read in full, not in summary, and five changes came
   back: M4, M7 and M8, built as `db/053`. **Given 2026-09-12, on the corrected
   wording.** The word counts in item 15 move with it — M7 612 to 563, M8 542
   to 468, M4 160 to 161 — and nothing else about any note changes.
8. **That you can explain how this database works** from the documents alone,
   without help. This is the project's standing requirement, not a courtesy.
   **Given 2026-09-12**, on the documents as they stand, with nobody prompting.

**All eight given. Sessions 1 and 2 are closed**, 2026-09-12.

### Part C — what this test does not check

- **Whether the dates nobody has checked are right.** 120 of the 128 Royal
  Assent dates, and 150 of the 154 introduction dates, have never been checked
  against legislation.gov.uk or the Parliament's pages. That is the agreed
  position, not a defect: the factsheet is definitive unless checked, and M8
  says so to a reader. A pass here is not evidence those dates are right.
  **Corrected on 2026-09-12:** this bullet used to say those dates "rest on the
  factsheet alone", which was wrong. The PhD dataset was compiled from the
  ground up and is independent of the factsheets, and since the corrections of
  that day the two agree on every introduction date and every Royal Assent date
  in both sessions. That is corroboration, not verification, and M8 now says
  which of the two a reader has.
- **Whether the Stage 1 and Stage 2 dates are right.** 256 stage records rest on
  the PhD dataset alone. Nothing has been compared against them.
- ~~**That "fell at dissolution" can be re-derived.**~~ **No longer a limit, as
  of 2026-09-12.** It read: seven bills are coded that way because their
  concluding date matched the dissolution date, but no dissolution date is
  recorded anywhere in the database, so the coding cannot be checked from the
  data as it stands. `db/048` put every session's last day in, with its source,
  and `db/049` made the checker require a bill coded as having fallen at
  dissolution to have concluded on that day. All seven do. The converse is
  deliberately not required: a bill can be rejected at Stage 1 on the final
  sitting day, so that direction stays a proposal a person reviews.
  **Finished on 2026-09-12 by `db/051`**, which moved that proposal out of the
  fact sheet reader and onto the staging sheet. Until then the coding could be
  checked against the data but not re-derived from the fact sheet, because the
  reader was handed the date from outside. It now is, and each of the seven
  bills carries a note giving the rule and the source of its session's last
  day.
- **`procedure`, `party`, `sp_bill_id` and `title_as_introduced`.** Empty or
  sparse by decision, not by omission: no factsheet states procedure (`db/010`),
  party is future-proofing, Session 1's factsheet prints no bill numbers, and a
  stated introduced title is given for only one bill in these two sessions.
- **Anything about Sessions 3 to 7**, including the comparison tool, which has
  never run against a real load.
