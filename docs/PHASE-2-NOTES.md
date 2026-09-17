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
3. **"The date in the date-blocked cell" isn't true of every bill.** The fact
   sheet gives no date for the Legal Continuity ruling, so that bill's cell is
   empty.
4. **The last two sentences no longer hold.** They say the four bills' story
   runs ahead of the data until later fact sheets are read in. Every session is
   now read in, and all four bills are recorded as they stand today.
5. **"The earlier state is kept in the fact sheet lines"** points a reader at
   the staging sheet, which was settled on 17 September as never published.
6. **Length.** The M12 rule of 15 September: a note says what the judgement is
   and what follows from it, not how we got there.

### Proposed (about 210 words)

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
> stopped, the date where a source gives one, and what happened next. A bill
> stopped and later enacted is recorded as enacted, and keeps the date it was
> stopped.

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
