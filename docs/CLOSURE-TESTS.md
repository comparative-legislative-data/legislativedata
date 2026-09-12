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

There is no universal test. Each ingest gets its own, newest first below.

---

## Sessions 1 and 2

Written 2026-09-12 by the session that loaded and corrected them. **Not run.**

### Part A — mechanical

Run `tools/closure_check_sessions_1_2.sql`. It reads only and changes nothing.
Compare each numbered result against the expected answer.

**1. Counts.** bills 154, stage_records 413, provenance_notes 49,
checker_problems 0, gaps 0, staging_lines 154, stage_date_rows 413.

- 154 is the two factsheets' own totals, 73 and 81.
- 413 is derived and should be checked as a derivation, not taken on trust:
  128 bills passed × 3 stages = 384; of the 26 that did not pass, 24 have one
  stage each, the Gaelic Language Bill has two (Stage 1 completed, stopped at
  Stage 2) and the Session 1 Robin Rigg Bill has three (Preliminary and
  Consideration completed, stopped at Final) = 29. 384 + 29 = 413.
- 49 is 11 outcomes + 11 rejection routes + 1 title corrected at review + 13
  dates checked against the source that owns them + the 13 session dates loaded
  by `db/048`. It was 36 until that migration; a session date is a fact about a
  session rather than about a bill, and carries its provenance like any other.
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
| `short_title` | `manual` | 1 |
| `stage_1_rejection_route` | `official_report` | 11 |

The thirteen adjudicated dates are the owner's of 2026-09-12; the eleven
outcomes and routes are the Stage 1 rejections; the title is the one corrected
at review (`DECISIONS.md`, 2026-09-10). The thirteen session dates are `db/048`:
seven first meetings and six session ends, Session 7 having no end because it is
still running.

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
says when sessions began and ended, which is not a stage of a bill.

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

**19. The dataset's fingerprint** matches the one recorded in `DECISIONS.md`,
2026-09-12, for the corrected working copy.

**20. Promotion is still reversible.** Take a session off and put it back inside
a transaction that is thrown away, and the result is identical. The procedure is
in `docs/PROMOTION-RUNBOOK.md`.

**21. The repository is clean** and level with GitHub, and the migrations are
numbered without a gap.

### Part B — the owner's sign-off

None of these is for anyone else to answer.

1. **What happened to each bill.** The counts in items 6 and 7 are what you
   expect for both sessions.
2. **The eleven Stage 1 rejections**: the route recorded for each, and the four
   notes a reader will see.
3. **The sixteen bills where you established where each ended**, as recorded in
   `DECISIONS.md`, 2026-09-11.
4. **The Session 2 Robin Rigg Act's** Preliminary and Consideration Stages,
   recorded as stages that never happened.
5. **The thirteen adjudicated dates**, and that the five corrections are the
   ones you intended.
6. **The nine corrections** on the Corrections sheet of the working dataset.
7. **M1 to M8**: that they tell a reader what you want told, and claim nothing
   you would not defend.
8. **That you can explain how this database works** from the documents alone,
   without help. This is the project's standing requirement, not a courtesy.

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
  sitting day, so that direction stays a proposal the reader makes and a person
  reviews.
- **`procedure`, `party`, `sp_bill_id` and `title_as_introduced`.** Empty or
  sparse by decision, not by omission: no factsheet states procedure (`db/010`),
  party is future-proofing, Session 1's factsheet prints no bill numbers, and a
  stated introduced title is given for only one bill in these two sessions.
- **Anything about Sessions 3 to 7**, including the comparison tool, which has
  never run against a real load.
