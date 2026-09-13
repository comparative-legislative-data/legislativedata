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

## Session 3

Written 2026-09-13 by the session that reviewed it and coded the nine bills that
did not pass. **Not run. Not marked.**

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
M7 the only one that mentions a financial resolution. Their lengths, which
should not have moved since `db/055`: M1 358, M2 3661, M3 1088, M4 971, M5 1940,
M6 1605, M7 4361, M8 2673. A length that has moved means somebody edited a note;
find out who and why before marking anything.

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

**19. The four Stage 1 dates the dataset also gives.** Four rows: Autism
12 January 2011, Creative Scotland 18 June 2008, End of Life Assistance
1 December 2010, Protection of Workers 22 December 2010. **Every one must say
`official_report`.** If any says `phd`, the dataset's date has been carried in
place of the Official Report's and this item fails.

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

**The worked-out columns that must differ, and only these** — eight cells across
seven bills:

- `outcome` on five bills, none of which the fact sheet explains: Autism, Budget
  (Scotland) (No.2), Creative Scotland, End of Life Assistance, Protection of
  Workers.
- `date_royal_assent` on two, corrected against legislation.gov.uk: Double
  Jeopardy and Forced Marriage etc.
- `asp_number` on one, which the fact sheet omits: Forced Marriage etc.

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
   expect for Session 3.
2. **The five bills read in the Official Report.** For each, the quotation on
   the line and the ending recorded against it: Autism, End of Life Assistance
   and Protection of Workers rejected at Stage 1 on the member's own motion;
   Budget (Scotland) (No.2) rejected at Stage 3 on the Presiding Officer's
   casting vote; Creative Scotland fallen for want of a financial resolution
   with its general principles agreed.
3. **The four endings you established from the Parliament's bill pages** — the
   two withdrawn bills and the two that fell at dissolution — checked against
   the clean sheet rather than against the note of them, including that none
   carries a date.
4. **The Forth Crossing Act as a Hybrid Bill**, and that M4 says what you want
   said to a reader who is comparing our 44 government bills against the fact
   sheet's 45.
5. **The three adjudicated dates and the asp number**, and that the corrections
   are the ones you intended.
6. **The ten names corrected in the dataset**, checked against the workbook's
   Corrections sheet.
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
   claim you are content to publish.
9. **That you can explain how this database works** from the documents alone,
   without help. The standing requirement, put again because Session 3 added an
   ending that behaves unlike the others.

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
2026-09-13, after the Autism Stage 1 date. Nothing on the clean sheet moved on
either occasion. `tools/phd_stage_dates.py` gives byte-identical output from
every version of the file — checked across the first three on 2026-09-12 and
across the last change on 2026-09-13 — so the 256 Stage 1 and Stage 2 dates
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
