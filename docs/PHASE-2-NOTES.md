# The methodology notes with open questions, one at a time

For the owner. No note is published with an open question against it
(`DECISIONS.md`, 17 September). Each note below is shown as it reads in the
database today, with what is wrong with it and a proposed wording, in full.
Nothing changes until the owner agrees.

**One rule for every rewrite:** the proposed wording names no database columns.
The notes are to be rewritten in readers' words when the published layout is
built (settled 17 September), so a rewrite that still says `bill.note` would
have to be done twice.

---

## M5 — Passing a bill is not the same as the bill being finished

**Done, 17 September.** The owner approved the proposed wording and the
meaning of "Blocked"; both applied as `db/106`, read back from the database and
matching word for word. The bill's missing date was added first (`db/105`).

### As it reads today (470 words)

> A bill that is passed by the Parliament does not automatically become an Act.
> It must be submitted for Royal Assent, and that submission can be prevented in
> two ways: the Law Officers may refer the bill to the Supreme Court under
> section 33 of the Scotland Act 1998, and the Supreme Court may rule that some
> of it is outwith the Parliament's legislative competence; or a Secretary of
> State may make an order under section 35 prohibiting submission. This resource
> therefore records what the Parliament did (bill.outcome) separately from
> whether the bill became an Act (bill.enactment_status), and a count of bills
> passed will not equal a count of Acts. Four bills are affected. Three were
> referred under section 33 and ruled against on 6 October 2021: the UNCRC
> (Incorporation) and European Charter of Local Self-Government (Incorporation)
> Bills were subsequently taken through Reconsideration Stage and enacted, and
> the UK Withdrawal from the European Union (Legal Continuity) Bill was withdrawn
> on 10 March 2022, nearly four years after it passed. The fourth, the Gender
> Recognition Reform (Scotland) Bill, was blocked by a section 35 order on
> 16 January 2023, and no further step has been taken. A bill in that position
> does not fall at the end of a session in the way an unfinished bill does; it
> remains a live bill, and the Parliament's own fact sheets carry it forward into
> the next session. The status 'blocked' covers both mechanisms and covers a bill
> left in that state indefinitely; which mechanism applied is recorded in
> bill.note, and the date in bill.date_assent_blocked. Because enactment_status
> records a bill's current state rather than its history, a bill that was blocked
> and later enacted shows as enacted; the earlier state is kept in the fact sheet
> lines this resource holds for every session, where the bill appears as each
> fact sheet printed it at the time, and the date of the block stays in
> bill.date_assent_blocked. A bill's recorded state is the one given by the
> latest fact sheet that has been read in, not by the latest fact sheet that
> exists. So a bill stopped in one session's fact sheet stays recorded as blocked
> here until the fact sheet saying what happened to it next has itself been read
> in, and the account above of what became of these four bills runs ahead of the
> data until that has happened.

### What is wrong with it

1. **The Legal Continuity Bill's ruling is misdated.** The note puts all three
   section 33 rulings on 6 October 2021. The Legal Continuity reference was
   decided on 13 December 2018 (*[2018] UKSC 64*, confirmed on the Supreme
   Court's own case page). The bills themselves are recorded correctly.
2. **How a bill was stopped is no longer only in the bill's note.** Since
   14 September it has a cell of its own, and so does what happened next.
3. **"The date in the date-blocked cell" wasn't true of every bill.** The fact
   sheet gives no date for the Legal Continuity ruling, so that bill's cell was
   empty. **Fixed in the data on 17 September** (`db/105`): the bill now has
   the Supreme Court's judgment date, 13 December 2018, credited to the Court's
   own page. All four stopped bills have their date.
4. **The last two sentences no longer hold.** They say the four bills' story
   runs ahead of the data until later fact sheets are read in. Every session is
   now read in, and all four bills are recorded as they stand today.
5. **"The earlier state is kept in the fact sheet lines"** points a reader at
   the staging sheet, which was settled on 17 September as never published.
6. **Length.** The M12 rule of 15 September: a note says what the judgement is
   and what follows from it, not how we got there.

### Proposed (228 words), revised after the date was added

**Title unchanged:** Passing a bill is not the same as the bill being finished

> A bill the Parliament has passed becomes an Act only when it receives Royal
> Assent, and it can be stopped before it is submitted: by a reference to the
> Supreme Court under section 33 of the Scotland Act 1998, or by an order of a
> UK Government minister under section 35. So what the Parliament did with a
> bill is recorded separately from whether it became an Act, and a count of
> bills passed is not a count of Acts.
>
> Four bills have been stopped. The UK Withdrawal from the European Union (Legal
> Continuity) (Scotland) Bill was referred under section 33; the Supreme Court
> ruled on 13 December 2018, and the bill was withdrawn on 10 March 2022. The
> UNCRC (Incorporation) (Scotland) Bill and the European Charter of Local
> Self-Government (Incorporation) (Scotland) Bill were referred under section
> 33, and the Supreme Court ruled on 6 October 2021; both were reconsidered,
> passed again and became Acts. The Gender Recognition Reform (Scotland) Bill
> was stopped by a section 35 order on 16 January 2023, and remains stopped.
>
> A stopped bill does not fall when its session ends: it stays live, and later
> fact sheets carry it forward. For each of the four we record how it was
> stopped, when, and what happened next. A bill stopped and later enacted is
> recorded as enacted, and keeps the date it was stopped.

### The same fault in the meaning of "Blocked"

What a reader sees when they look up the status "Blocked" repeats fault 2 and
names columns. It is published with the codes, so it is corrected with M5.

**As it reads today:**

> Passed, but prevented from being submitted for Royal Assent — by a Supreme
> Court ruling on a section 33 reference, or by an order under section 35 of the
> Scotland Act 1998. Which mechanism applied is recorded in bill.note, and the
> date in bill.date_assent_blocked. A bill can remain in this state
> indefinitely: see methodology note M5.

**Proposed:**

> Passed, but stopped from being submitted for Royal Assent, by a Supreme Court
> ruling on a section 33 reference or by an order under section 35 of the
> Scotland Act 1998, and neither enacted nor withdrawn since. A bill can stay in
> this state indefinitely. See methodology note M5.

---

## The other twelve notes: where each stands

Checked 17 September against the M12 rule (a note says what the judgement is,
not how we got there) and against the database. Word counts are today's.

| Note | Words | Where it stands | What is wrong |
|---|---|---|---|
| **M3** Two titles | 192 | **Wrong about the data** | Says a known rename's date is in the bill's note. Three bills have a known earlier title and none has a date in its note. The Session 4–7 fact sheets print rename dates; nothing records them. By the rule of 17 September, a missing date is added, then the note corrected. Also names columns and says "the first slice". |
| **M2** When a stage is completed | 947 | **Out of date, and long** | Says a session whose Stage 1 and 2 dates are not yet added has none; every session has them now. Says those dates come from the PhD dataset; 37 come from the Parliament's bill pages and 33 from the Official Report. Explains database mechanics (general and detail notes) a reader does not need. |
| **M7** Why a bill fell | 877 | **Out of date, and long** | Says the coding is done for Sessions 1 to 5 only; Session 6 is done and Session 7 has no fallen bill. Says uncoded sessions show a general code; no bill has one. "One bill in the first five sessions" fell for want of a financial resolution; still one, in six. A paragraph on how Sessions 1 and 2 were worked out. |
| **M8** Where each date comes from | 468 | **Out of date** | Says only dates where sources disagreed were checked; every bill a fact sheet left awaiting Royal Assent has since been checked too, and checked dates are recorded whether they agreed or not. Says the sources agree "throughout Sessions 1 and 2"; every session is compared now. Its list of sources misses the SPICe dates fact sheet, the Supreme Court and legislation.gov.uk for the session dates. |
| **M6** A bill's session | 612 | **Correct, and long** | Every count checked: 474 rows, 470 bills, 73, 81, 62, 86, 87, 80 and 1. "Six pairs of bills" were reintroduced can't be checked from the data, which links only Robin Rigg. |
| **M13** A bill still before the Parliament | 186 | **One sentence will go wrong** | "It has not yet completed a stage" is true of today's one live bill, not of every live bill. |
| **M1** Executive and Government | 53 | Correct | Names a column. |
| **M4** Hybrid Bills | 161 | Correct | 44 government and 1 hybrid in Session 3, as it says. Names columns. |
| **M9** A reintroduced bill | 251 | Correct | 42 days, 132, 274 across 22 Private Bills, and 364 days, all checked. |
| **M10** Procedure | 296 | Correct | Five bills, all in Session 6, as it says. |
| **M11** The day a stage was reached | 257 | Correct | Two records, as it says. Names columns. |
| **M14** Session 7's expected end | 158 | Correct | Approved today. |

**Names columns** matters because the notes are rewritten in readers' words when
the published layout is built (settled 17 September); those are small edits,
and can be done together.

---

## M3: every title change the fact sheets state

The full text of all seven fact sheets was searched on 17 September for
"introduced as", "renamed", "formerly" and similar, not only the earlier survey.
Four title changes, and no others. "Introduced as an Executive Bill" (the type
styling M1 covers) and a Bill's title becoming an Act's title on Royal Assent
are different things and are left out.

| Bill | Session | Introduced as | Date the fact sheet gives | Which day that is | Recorded now |
|---|---|---|---|---|---|
| Scottish Commission for Human Rights Act 2006 | 2 | Scottish Commissioner for Human Rights Bill | None (printed in the title cell) | — | Earlier title yes; no date |
| Buildings (Recovery of Expenses) (Scotland) Act 2014 | 4 | Defective and Dangerous Buildings (Recovery of Expenses) (Scotland) Bill | None (footnote 1) | — | **Nothing**: the reader removed the footnote marker and did not keep the footnote |
| Care Reform (Scotland) Act 2025 | 6 | National Care Service (Scotland) Bill | Renamed 4 March 2025 | The day its Stage 2 ended | Earlier title yes; date only in the reading notes |
| Scottish Parliament (Recall of Members) Bill | 6 | Scottish Parliament (Recall and Removal of Members) Bill | Renamed 24 February 2026 | The day of its Stage 3, when it was rejected | Earlier title yes; date only in the reading notes |

All four are the same kind of change: the bill's short title changed while it
was before the Parliament, and kept its SP Bill number. They differ only in how
much the fact sheet says. The two dated renames fall on the day of a stage, which
suggests the date is when the amendment changing the title was agreed; the
Official Report would say for all four.

### What the owner found, 17 September

**Buildings (Recovery of Expenses) (Scotland) Act 2014.** The Parliament's archived
bill page, https://webarchive.nrscotland.gov.uk/public/+/archive2021.parliament.scot/parliamentarybusiness/Bills/69042.aspx:

> The Bill was introduced in the Parliament as the Defective and Dangerous
> Buildings (Recovery of Expenses) (Scotland) Bill. After stage 2 consideration
> of the Bill, the short title of the Bill was changed to the Buildings (Recovery
> of Expenses) (Scotland) Bill to reflect amendments made to the Bill at Stage 2.

**Stage 2. No date given.** The bill's Stage 2 ended on 4 June 2014.

**Scottish Commission for Human Rights Act 2006.** The Parliament's archived bill
page, https://webarchive.nrscotland.gov.uk/public/+/archive2021.parliament.scot/parliamentarybusiness/Bills/25125.aspx:

> The Bill as introduced, and the Bill as amended at Stage 2, sought to
> establish a Commissioner for human rights. At Stage 2 the Executive brought
> forward amendments to change the Commissioner to a Commission but these were
> unsuccessful. However, similar amendments were laid at Stage 3, this time
> successfully.

**Stage 3. No date given.** The bill's Stage 3 was on 2 November 2006.

**Still needed:** the two Session 6 bills' stage and source (the fact sheet gives
their dates), and a decision on where the date comes from for these two.

### Settled with the owner, 17 September

- **Same bill** throughout, as now. Record the **original title**, the **final
  title**, and **the stage at which the title changed**.
- **The date is that stage's date**, already recorded. The owner: amendments to
  a bill's title are always taken at the end of a stage, so that they are done
  once. So the date is not stored a second time, and M3 says why.
- The two Session 6 fact sheet dates fall on those stage dates, which confirms
  both.

### The change, every part, for the owner to agree

1. **What it records.** For a bill whose title changed while it was before the
   Parliament, the stage at which it changed: a stage name from the list the
   stages already use (Stage 2, Stage 3, and the Private Bill names). One cell,
   one change; the original and final titles are the cells already there.
2. **Which bills, and what empty means.** Filled wherever an original title is
   recorded, which after this change is four bills. Empty means no change of
   title is known. A bill renamed twice (none is) would hold the stage of the
   last change, with the earlier one in its note.
3. **Where it sits.** A cell on the bill, beside the original title. The date a
   reader sees is worked out from the stage when the published copy is taken,
   never typed in.
4. **How it arrives.** The same cell on the staging line, filled at review, with
   a "Checked:" citation that promotion turns into the provenance note, as the
   Legal Continuity Bill's date did. The Buildings Act's line also gains its
   original title and the footnote's words, which the reader of the Session 4
   fact sheet dropped.
5. **Provenance.** Human Rights and Buildings Acts: the Parliament's archived
   bill pages the owner read, dated 17 September. Care Reform and Recall bills:
   the Session 6 fact sheet, whose rename date is that stage's date.
6. **What the checker requires.** A stage the bill's own type has; a stage the
   bill has a dated record for, so there is a date; filled only where an
   original title is recorded; and **an original title with no stage is
   refused**, so a future case cannot arrive half-recorded. The clean sheet
   refuses a stage not on the list, and a stage without an original title.
7. **What a reader is told.** M3 rewritten, draft below in full; and the
   description of the bill's note, which today says a rename date goes there,
   corrected.
8. **Every bill already coded, rechecked.** All seven fact sheets were searched
   in full for title changes today: four, all covered. Lines 127, 231, 406 and
   423 change, and nothing else. The Session 4 reader's dropped footnote is
   recorded as a known fault in it; every session is already read in, so it
   will not run on these fact sheets again.
9. **When.** This session, once agreed: one change to the staging sheet and the
   tools, rehearsed; then Sessions 2 and 4 off and on, and Sessions 7, 6 and 5
   off and on (Session 6's bills need 7 off first and bring 5 with them), as one
   change that saves only on the rehearsed differences. A closure test for
   another session.

### Draft M3, in full

**Title:** A bill's title can change while it is before the Parliament

> A bill's short title can be changed by amendment while the bill is before the
> Parliament, and a bill that becomes an Act takes the Act's title. We record the
> title a bill ended with, which is the Act's title where there is one, and,
> where a source states it, the title it was introduced under and the stage at
> which the title changed.
>
> An amendment to a bill's title is taken at the end of a stage, once the rest
> of the bill has been amended, so that it is made once. The date of the change
> is therefore the date that stage ended.
>
> Four bills are recorded with an earlier title: the Scottish Commission for
> Human Rights Act 2006, introduced as the Scottish Commissioner for Human Rights
> Bill and changed at Stage 3; the Buildings (Recovery of Expenses) (Scotland)
> Act 2014, introduced as the Defective and Dangerous Buildings (Recovery of
> Expenses) (Scotland) Bill and changed at Stage 2; the Care Reform (Scotland)
> Act 2025, introduced as the National Care Service (Scotland) Bill and changed
> at Stage 2; and the Scottish Parliament (Recall of Members) Bill, introduced as
> the Scottish Parliament (Recall and Removal of Members) Bill and changed at
> Stage 3.
>
> For every other bill no earlier title is recorded. That means none is known,
> not that the title never changed.
