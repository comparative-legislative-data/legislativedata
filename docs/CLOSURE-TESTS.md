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

## Session 4

Written 2026-09-13 by a session that did none of Session 4's work: it did not
read the fact sheet in, did not build the review, and did not admit it. **Not
yet run**, and not run by the session that wrote it.

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
lengths: M1 358, M2 5140, M3 1088, M4 971, M5 1940, M6 1605, M7 4361, M8 2673.
A length that has moved means somebody edited a note; find out who and why
before marking anything. **Session 4 brings no ending and no rejection route the
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
characters **1376**, and all three of `keeps_the_resolution`,
`names_the_amendment` and `quotes_the_division` true.

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

**25. Promotion is still reversible.** Take Session 4 off and put it back inside a
transaction that is thrown away, and the result is identical. The procedure is in
`docs/PROMOTION-RUNBOOK.md`. Session 4 is the largest session yet at 86 bills, the
first with five Private Bills in it, and the first whose promotion writes a
provenance note for a bracketed value, so this is not a formality.

**26. Every period is counted, or has a stated reason.** `tools/duration_coverage.sql`
runs clean: **1064 counted**, and not counted 21 plus whatever points the two
endings add — 19 of the 21 being stages that never reached their terminal point
and 2 stages that never happened, all of them from Sessions 1 to 3. No third
category; the script stops if one appears.

1064 is 743 plus Session 4's 321: 79 bills passed, each counted at four points
(introduction to the first stage, then each stage to the next, then the last stage
to Royal Assent) = 316, and 5 bills rejected at Stage 1 counted from introduction
to that decision = 5. The per-stage table should read:

| Counted to | Periods |
|---|---|
| introduction → stage_1 | 265 |
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
   rejected at Stage 1 and one that ran out of time.
2. **The five bills read in the Official Report.** For each, the quotation on the
   line and the ending recorded against it: Alcohol, Assisted Suicide, Criminal
   Verdicts and Pentland Hills rejected at Stage 1 on the member's own motion put
   and disagreed to; Transplantation rejected on that motion amended and agreed
   to. You predicted the fifth from the shape of the record before it was read;
   the sign-off is on the record as it was found, not on the prediction.
3. **The Transplantation Bill's motion as amended, read in full** as it will be
   published beside the bill, and that quoting the resolution — a soft opt-out
   system, a consultation, legislation next session if appropriate — is what you
   want a reader to see beside a bill counted as rejected at Stage 1.
4. **The two endings you establish** for the Inquiries into Deaths Bill and the
   Footway Parking and Double Parking Bill, checked against the clean sheet
   rather than against the note of them, including whether the Footway Parking
   Bill's Stage 1 of 1 March 2016 is recorded and from what.
5. **The two adjudicated dates and the two cells the fact sheet prints short**,
   and that the corrections are the ones you intended: the Land Reform Act's
   Royal Assent settled your dataset's way against legislation.gov.uk; the
   National Galleries Act's introduction date settled the fact sheet's way on
   your own record; and the Higher Education Governance Act's title and number,
   which the fact sheet prints with no year, taken from legislation.gov.uk — each
   with its source, its place in that source, the value in the source's own words
   and the day it was read, and the fact sheet's printed words left untouched
   beside them.
6. **The eight names paired by hand**, checked against the fact sheet and your
   dataset side by side: the four Budget Acts, which your dataset numbers within
   the session where the fact sheet gives the Act's short title, and the four
   wording slips. Every one agrees on both dates the two sources share.
7. **Whether the National Galleries introduction date should be corrected in your
   workbook.** Session 3's equivalent — the Autism Bill's Stage 1 date — was
   corrected in the file and the fingerprint moved with it. This one was settled
   on the staging line instead and the file left alone, so the dataset still says
   26 June 2015 where the database says 25 June. Either is defensible; they should
   not be decided differently by accident. Your call, and item 24 moves if you
   correct it.
8. **The Parliament's own styling changing inside Session 4**: 15 government
   bills recorded as introduced when they were styled Executive Bills and 52 as
   Government Bills, against 67 counted as government throughout — and that M4
   says what you want said to a reader who notices.
9. **That you can explain how this database works** from the documents alone,
   without help. The standing requirement, put again because Session 4 is the
   largest session so far and the first whose bills carry two different
   contemporaneous labels. Check `docs/HOW-THE-DATABASE-WORKS.md` is current
   before reading it: its counts still say 216 bills and 71 provenance notes, and
   the session that promotes Session 4 has to bring them to 302 and 86.

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
