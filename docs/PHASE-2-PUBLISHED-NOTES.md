# The fourteen methodology notes, rewritten in the published headings

For the owner, 17 September 2026. The companion to
`docs/PHASE-2-PUBLISHED-COPY.md`, which proposes the headings these notes are
rewritten in. **Nothing here is built.** Each note is given as it reads in the
database today, then as proposed, with the changed sentences in **bold**.

**What the change is, in one line.** A note that says "kept beside it" or
"recorded separately" now names the heading, so a reader with the file open can
find the thing the note is about. That is the whole of it for most of them.

**M6 is not changed.** It is about how bills are counted, not about a heading.

**M10 changes twice**, once for this and once for the cut already agreed in
block 2 of `PHASE-2-CHARTS-BUILD.md`. Both are done here, because half a
rewritten note is not a state to leave one in.

**If a heading changes when you read the other file**, only the sentences naming
it change here, and I reissue those notes rather than all fourteen.

Each note also carries a list of which headings it bears on — what the site uses
to show the right note against the right column. Today those lists name database
columns. The proposed list is given under each note.

---

## M1 — Executive Bills and Government Bills are counted as one type

### As it reads today

> Bills introduced by the Scottish Government were formally styled Executive
> Bills for part of the Parliament's history. This resource records both as
> "government", so that a count of government legislation is continuous across
> all sessions. The label used at the time, Executive or Government, is kept
> beside it, so a table can be split or filtered by it.

### Proposed

> Bills introduced by the Scottish Government were formally styled Executive
> Bills for part of the Parliament's history. **This resource records both as
> Government Bills, under `bill_type`, so that a count of government legislation
> is continuous across all sessions. The label used at the time — Executive Bill
> or Government Bill — is kept beside it in `bill_type_at_the_time`, so a table
> can be split or filtered by it.**

Two words change beyond the headings. "government" becomes "Government Bills",
because the cells now hold words rather than codes, and there is no longer a
lower-case `government` anywhere for a reader to see.

**Applies to:** `bill_type`, `bill_type_at_the_time`.

---

## M2 — A stage is completed on the date of the decision that ended it

### As it reads today

> Every stage is dated at the same point for every bill. Stage 1 ends on the day
> the Parliament decides whether to agree to the bill's general principles.
> Stage 2 ends at the meeting at which the last amendments are disposed of;
> every bill at Stage 2 has one, because even when no amendments are lodged the
> committee, or for an emergency bill the whole Parliament, still meets to agree
> to each section. Stage 3 ends on the day the Parliament votes on whether to
> pass the bill.
>
> A Private Bill's Preliminary, Consideration and Final Stages are recorded
> under those names and dated at the equivalent points: the decision whether it
> should proceed, the meeting at which the last amendments are disposed of, and
> the vote to pass. They are different stages from a public bill's, and are
> compared with them only by their place in the sequence. The one Hybrid Bill
> went through Stages 1, 2 and 3 and is dated as a public bill is.
>
> A stage the Parliament decided against, such as general principles not agreed
> to at Stage 1, carries the date of that decision. A stage at which a bill
> stopped without any decision, because it was withdrawn or was still at that
> stage when the session ended, has no date, and a note on it says so in the
> same words every time.
>
> Time is counted between these dated points, from introduction to Royal Assent.
> A stage that ended in a decision counts whatever the decision was, so a bill
> rejected at Stage 1 has a real time to Stage 1. Every period also records
> whether the bill got through that stage and whether it went on to pass, so a
> figure can cover every bill that reached a stage or only those that passed,
> and a chart says which. Where a stage has no date, time is counted across it,
> from the stage before to the stage after, and never shown as that stage's own.
>
> Where each date comes from is in M8. A Private Bill that did not repeat stages
> an earlier bill completed is in M9.

### Proposed

> Every stage is dated at the same point for every bill. Stage 1 ends on the day
> the Parliament decides whether to agree to the bill's general principles.
> Stage 2 ends at the meeting at which the last amendments are disposed of;
> every bill at Stage 2 has one, because even when no amendments are lodged the
> committee, or for an emergency bill the whole Parliament, still meets to agree
> to each section. Stage 3 ends on the day the Parliament votes on whether to
> pass the bill. **That day is `date_ended`.**
>
> A Private Bill's Preliminary, Consideration and Final Stages are recorded
> under those names and dated at the equivalent points: the decision whether it
> should proceed, the meeting at which the last amendments are disposed of, and
> the vote to pass. **They are different stages from a public bill's, and are
> compared with them only by their place in the sequence, which is
> `stage_position`.** The one Hybrid Bill went through Stages 1, 2 and 3 and is
> dated as a public bill is.
>
> A stage the Parliament decided against, such as general principles not agreed
> to at Stage 1, carries the date of that decision. **A stage at which a bill
> stopped without any decision, because it was withdrawn or was still at that
> stage when the session ended, has no date, and `why_there_is_no_date` says so
> in the same words every time.**
>
> **Time is counted between these dated points, from introduction to Royal
> Assent, in `days_between_stages`.** A stage that ended in a decision counts
> whatever the decision was, so a bill rejected at Stage 1 has a real time to
> Stage 1. **Every period also records whether the bill got through that stage,
> in `got_through_the_later_stage`, and whether it went on to pass, in
> `bill_passed`, so a figure can cover every bill that reached a stage or only
> those that passed, and a chart says which.** Where a stage has no date, time is
> counted across it, from the stage before to the stage after, and never shown as
> that stage's own.
>
> Where each date comes from is in M8. A Private Bill that did not repeat stages
> an earlier bill completed is in M9.

**Applies to:** `stage`, `stage_position`, `date_ended`, `got_through`,
`why_there_is_no_date`, `note`, `source`, `days`,
`got_through_the_later_stage`, `bill_passed`.

---

## M3 — A bill's title can change while it is before the Parliament

### As it reads today

> A bill's short title can be changed by amendment while the bill is before the
> Parliament, and a bill that becomes an Act takes the Act's title. We record
> the title a bill ended with, which is the Act's title where there is one, and,
> where a source states it, the title it was introduced under and the stage at
> which the title changed.
>
> An amendment to a bill's title is taken at the end of a stage, once the rest
> of the bill has been amended, so that it is made once. The date of the change
> is therefore the date that stage ended.
>
> Four bills are recorded with an earlier title: the Scottish Commission for
> Human Rights Act 2006, introduced as the Scottish Commissioner for Human
> Rights Bill and changed at Stage 3; the Buildings (Recovery of Expenses)
> (Scotland) Act 2014, introduced as the Defective and Dangerous Buildings
> (Recovery of Expenses) (Scotland) Bill and changed at Stage 2; the Care Reform
> (Scotland) Act 2025, introduced as the National Care Service (Scotland) Bill
> and changed at Stage 2; and the Scottish Parliament (Recall of Members) Bill,
> introduced as the Scottish Parliament (Recall and Removal of Members) Bill and
> changed at Stage 3.
>
> For every other bill no earlier title is recorded. That means none is known,
> not that the title never changed.

### Proposed

> A bill's short title can be changed by amendment while the bill is before the
> Parliament, and a bill that becomes an Act takes the Act's title. **`title`
> holds the title a bill ended with, which is the Act's title where there is one.
> Where a source states them, `title_as_introduced` holds the title it was
> introduced under and `title_changed_at_stage` the stage at which the title
> changed.**
>
> An amendment to a bill's title is taken at the end of a stage, once the rest
> of the bill has been amended, so that it is made once. **The date of the change
> is therefore the date that stage ended, which is on the bill's stage row and
> not repeated beside the title.**
>
> Four bills are recorded with an earlier title: the Scottish Commission for
> Human Rights Act 2006, introduced as the Scottish Commissioner for Human
> Rights Bill and changed at Stage 3; the Buildings (Recovery of Expenses)
> (Scotland) Act 2014, introduced as the Defective and Dangerous Buildings
> (Recovery of Expenses) (Scotland) Bill and changed at Stage 2; the Care Reform
> (Scotland) Act 2025, introduced as the National Care Service (Scotland) Bill
> and changed at Stage 2; and the Scottish Parliament (Recall of Members) Bill,
> introduced as the Scottish Parliament (Recall and Removal of Members) Bill and
> changed at Stage 3.
>
> **For every other bill `title_as_introduced` is empty. That means no earlier
> title is known, not that the title never changed.**

**Applies to:** `title`, `title_as_introduced`, `title_changed_at_stage`.

---

## M4 — Hybrid Bills are recorded as Hybrid Bills and counted as government bills

### As it reads today

> A Hybrid Bill is a bill of a public character that affects particular private
> interests. Only one has ever been introduced in the Scottish Parliament: the
> Forth Crossing Bill of Session 3, which became the Forth Crossing Act 2011. It
> is recorded here as a Hybrid Bill, which is what it was. Where bill types are
> grouped for counting, it is grouped with government bills, because it was
> introduced by the Scottish Government; both are held, so a count can use that
> grouping, or the bill's own type, which keeps it separate. Either is
> available, and a table or chart published from this resource should state
> which it used, because the two differ. The Parliament's own Session 3 fact
> sheet makes the same grouping without saying so: it defines a type letter H,
> applies it to that one bill, and then prints a summary table with no Hybrid
> column, counting the bill under Executive. Its stated total of 45 Executive
> bills is 44 Executive bills and one Hybrid Bill.

### Proposed

> A Hybrid Bill is a bill of a public character that affects particular private
> interests. Only one has ever been introduced in the Scottish Parliament: the
> Forth Crossing Bill of Session 3, which became the Forth Crossing Act 2011.
> **It is recorded under `bill_type` as a Hybrid Bill, which is what it was.
> Where bill types are grouped for counting, it is grouped with government bills,
> because it was introduced by the Scottish Government, and `bill_type_grouped`
> holds that grouping. Both are published, so a count can use either, and a table
> or chart published from this resource should state which it used, because the
> two differ.** The Parliament's own Session 3 fact sheet makes the same grouping
> without saying so: it defines a type letter H, applies it to that one bill, and
> then prints a summary table with no Hybrid column, counting the bill under
> Executive. Its stated total of 45 Executive bills is 44 Executive bills and one
> Hybrid Bill.

**Applies to:** `bill_type`, `bill_type_grouped`.

---

## M5 — Passing a bill is not the same as the bill being finished

### As it reads today

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
> Self-Government (Incorporation) (Scotland) Bill were referred under section 33,
> and the Supreme Court ruled on 6 October 2021; both were reconsidered, passed
> again and became Acts. The Gender Recognition Reform (Scotland) Bill was
> stopped by a section 35 order on 16 January 2023, and remains stopped.
>
> A stopped bill does not fall when its session ends: it stays live, and later
> fact sheets carry it forward. For each of the four we record how it was
> stopped, when, and what happened next. A bill stopped and later enacted is
> recorded as enacted, and keeps the date it was stopped.

### Proposed

> A bill the Parliament has passed becomes an Act only when it receives Royal
> Assent, and it can be stopped before it is submitted: by a reference to the
> Supreme Court under section 33 of the Scotland Act 1998, or by an order of a
> UK Government minister under section 35. **So `outcome`, what the Parliament
> did with a bill, is separate from `enactment_status`, whether it became an Act,
> and a count of bills passed is not a count of Acts.**
>
> Four bills have been stopped. The UK Withdrawal from the European Union (Legal
> Continuity) (Scotland) Bill was referred under section 33; the Supreme Court
> ruled on 13 December 2018, and the bill was withdrawn on 10 March 2022. The
> UNCRC (Incorporation) (Scotland) Bill and the European Charter of Local
> Self-Government (Incorporation) (Scotland) Bill were referred under section 33,
> and the Supreme Court ruled on 6 October 2021; both were reconsidered, passed
> again and became Acts. The Gender Recognition Reform (Scotland) Bill was
> stopped by a section 35 order on 16 January 2023, and remains stopped.
>
> A stopped bill does not fall when its session ends: it stays live, and later
> fact sheets carry it forward. **For each of the four,
> `how_stopped_before_assent` records how, `date_stopped_before_assent` when, and
> `outcome_after_being_stopped` what happened next. A bill stopped and later
> enacted has `enactment_status` Enacted, and keeps
> `date_stopped_before_assent`.**

**Applies to:** `outcome`, `enactment_status`, `date_stopped_before_assent`,
`date_fell_or_withdrawn`, `how_stopped_before_assent`,
`outcome_after_being_stopped`.

---

## M6 — A bill belongs to the session in which it was first introduced

**Not changed.** Its text stands as it is.

**Applies to:** `session`.

---

## M7 — Why a bill fell is our coding, not the fact sheets'

### As it reads today

> The Parliament's legislation fact sheets list every bill that did not pass,
> other than those withdrawn, under one heading, "Bills which have fallen", and
> do not say why. The reasons are different events: the Parliament refusing a
> bill's general principles at Stage 1, the Parliament defeating it at the final
> vote, and a bill still waiting for its next stage when the session ended. This
> resource records which happened. That is our coding, not the fact sheets'.
> Every bill that fell is coded, and each names the source its coding rests on.
>
> A bill is recorded as rejected at Stage 1 or at Stage 3 where the Official
> Report records the Parliament deciding against it, and the figures of the
> division are recorded with it. A bill is recorded as having fallen at
> dissolution where it ended on the day its session ended, taken from SPICe's
> fact sheet of recess and dissolution dates. Such a bill may have completed a
> stage or two first, but the Parliament took no decision against it.
>
> A bill rejected at Stage 1 was rejected in one of three ways. Usually the
> Parliament disagreed to the member in charge's motion that its general
> principles be agreed to. Or that motion was amended so as not to agree to
> them, and then agreed to as amended: the motion carried and the bill fell, and
> both divisions are given in the bill's note, since either alone would mislead.
> Or, for a Member's Bill only, the Parliament agreed to the lead committee's
> motion under Rule 9.14.18 that the general principles not be agreed to. The
> rule allows this where, in the committee's opinion, the case for the bill or
> for legislating at all has not been shown, the bill is clearly outwith
> legislative competence, or its drafting cannot be put right by amendment. The
> motion does not say which; where the committee's grounds allow a view, the
> bill's note gives ours. The rule is read as worded in the current Standing
> Orders, and taken to be unchanged since 2006.
>
> A bill can also fall for want of a financial resolution, which under Rule 9.12
> a bill charging public funds needs before Stage 2. The Parliament agreed the
> general principles of the Creative Scotland Bill on 18 June 2008 and did not
> agree its financial resolution the same afternoon. It is recorded as having
> fallen for that reason, and not as rejected. The Parliament's bill page says it
> fell at Stage 1; this resource follows the Official Report of that day.
>
> Division figures given beside a bill are text, not data, and cannot be
> counted. A structured record of how members voted is not yet part of this
> resource, and when it is added it supersedes them.

### Proposed

> The Parliament's legislation fact sheets list every bill that did not pass,
> other than those withdrawn, under one heading, "Bills which have fallen", and
> do not say why. The reasons are different events: the Parliament refusing a
> bill's general principles at Stage 1, the Parliament defeating it at the final
> vote, and a bill still waiting for its next stage when the session ended.
> **`outcome` records which happened. That is our coding, not the fact sheets'.
> Every bill that fell is coded, and the `sources` file names the source each
> coding rests on.**
>
> A bill is recorded as rejected at Stage 1 or at Stage 3 where the Official
> Report records the Parliament deciding against it, and the figures of the
> division are recorded with it. A bill is recorded as having fallen at
> dissolution where it ended on the day its session ended, taken from SPICe's
> fact sheet of recess and dissolution dates. Such a bill may have completed a
> stage or two first, but the Parliament took no decision against it.
>
> **A bill rejected at Stage 1 was rejected in one of three ways, and
> `how_rejected_at_stage_1` says which.** Usually the Parliament disagreed to the
> member in charge's motion that its general principles be agreed to. **Or that
> motion was amended so as not to agree to them, and then agreed to as amended:
> the motion carried and the bill fell, and both divisions are given in the
> bill's `note`, since either alone would mislead.** Or, for a Member's Bill only,
> the Parliament agreed to the lead committee's motion under Rule 9.14.18 that
> the general principles not be agreed to. The rule allows this where, in the
> committee's opinion, the case for the bill or for legislating at all has not
> been shown, the bill is clearly outwith legislative competence, or its drafting
> cannot be put right by amendment. **The motion does not say which; where the
> committee's grounds allow a view, the bill's `note` gives ours.** The rule is
> read as worded in the current Standing Orders, and taken to be unchanged since
> 2006.
>
> A bill can also fall for want of a financial resolution, which under Rule 9.12
> a bill charging public funds needs before Stage 2. The Parliament agreed the
> general principles of the Creative Scotland Bill on 18 June 2008 and did not
> agree its financial resolution the same afternoon. It is recorded as having
> fallen for that reason, and not as rejected. The Parliament's bill page says it
> fell at Stage 1; this resource follows the Official Report of that day.
>
> Division figures given beside a bill are text, not data, and cannot be
> counted. A structured record of how members voted is not yet part of this
> resource, and when it is added it supersedes them.

**Applies to:** `outcome`, `how_rejected_at_stage_1`, `note`.

---

## M8 — Where each date comes from, and which source wins when two disagree

### As it reads today

> Each bill starts from the Scottish Parliament's legislation fact sheets,
> compiled by SPICe, which give its type, when it was introduced, what happened
> to it and, for an Act, the date of Royal Assent. They are a derived source and
> have been found wrong, so where another source owns a fact, that source is
> used:
>
> - for an Act's date of Royal Assent, its number and its title,
>   legislation.gov.uk;
> - for other dates about a bill, the Parliament's own bill pages and the
>   Official Report, which is also the source for how a bill was rejected;
> - for the dates of Stages 1 and 2, the dataset compiled for Steven MacGregor,
>   "Does government dominate the legislative process?" (PhD thesis, University
>   of Stirling, 2021), maintained since to cover Sessions 6 and 7, used where no
>   source above gives the date and nothing contradicts it;
> - for when each session began and ended, SPICe's fact sheet of recess and
>   dissolution dates;
> - for the date the Supreme Court ruled on a reference, the Court's own case
>   page.
>
> The Explanatory Notes published with an Act give its parliamentary passage,
> but are not used, because they are written by government officials rather than
> by the Parliament's.
>
> When a session is added, its dates and bill types are compared with the thesis
> dataset. Where the two disagree, the difference is settled against the source
> that owns the fact, and the value then names that source. Nothing is settled
> silently or averaged. No disagreement about a bill's type has arisen, so which
> source would settle one has not been decided.
>
> A value that names its own source has been checked against it, and says which
> page and the day it was read. That includes every value where the sources
> disagreed, and every bill a fact sheet left awaiting Royal Assent (M12). Every
> other value stands on the fact sheet and has not been checked individually.
> Agreeing with the thesis dataset, which was compiled independently, is weaker
> evidence than checking the Act itself and stronger than one source alone.

### Proposed

Unchanged but for the last paragraph.

> [ ... the first four paragraphs and the list stand exactly as above ... ]
>
> **A value that names its own source has been checked against it. The `sources`
> file holds those: one line per fact, with the source, where in it, the value in
> the source's own words, and `date_source_read`, the day we looked. That
> includes every value where the sources disagreed, and every bill a fact sheet
> left awaiting Royal Assent (M12).** Every other value stands on the fact sheet
> and has not been checked individually. Agreeing with the thesis dataset, which
> was compiled independently, is weaker evidence than checking the Act itself and
> stronger than one source alone.

**Applies to:** `date_royal_assent`, `date_introduced`, `date_ended`, `source`,
`date_source_read`.

---

## M9 — A reintroduced bill is a second bill, and may not have repeated its scrutiny

### As it reads today

> Where a bill falls and another is introduced in a later session to do the same
> job, this resource records two bills and counts two, because two bills were
> introduced. Methodology note M6 gives the rule. One consequence needs saying
> separately, because it affects how long a bill appears to have taken rather
> than how many bills there were.
>
> Under Private Bill procedure a reintroduced bill does not repeat the scrutiny
> the earlier bill completed. The Robin Rigg Offshore Wind Farm (Navigation and
> Fishing) (Scotland) Bill was introduced on 27 June 2002, completed its
> Preliminary Stage on 9 January 2003 and its Consideration Stage on 11 March
> 2003, and fell at the end of Session 1 without reaching its Final Stage. It was
> reintroduced on 15 May 2003, went straight to the Final Stage vote, and passed
> on 26 June 2003.
>
> So the Act's Preliminary and Consideration Stages are recorded as stages that
> never happened, with a note on each saying where they did happen, and its
> journey from introduction to Final Stage reads 42 days. The next shortest
> Private Bill took 132 days and the median of the 22 that passed is 274.
> Measured from the first introduction, the same business took 364 days. Neither
> figure is wrong; they measure different things.
>
> The Act records which bill it carried its scrutiny from, so a chart of how long
> bills took can be built either way. Any such chart carries this note and says
> which it used. One bill is affected.

### Proposed

> Where a bill falls and another is introduced in a later session to do the same
> job, this resource records two bills and counts two, because two bills were
> introduced. Methodology note M6 gives the rule. One consequence needs saying
> separately, because it affects how long a bill appears to have taken rather
> than how many bills there were.
>
> Under Private Bill procedure a reintroduced bill does not repeat the scrutiny
> the earlier bill completed. The Robin Rigg Offshore Wind Farm (Navigation and
> Fishing) (Scotland) Bill was introduced on 27 June 2002, completed its
> Preliminary Stage on 9 January 2003 and its Consideration Stage on 11 March
> 2003, and fell at the end of Session 1 without reaching its Final Stage. It was
> reintroduced on 15 May 2003, went straight to the Final Stage vote, and passed
> on 26 June 2003.
>
> **So the Act's Preliminary and Consideration Stages carry
> `stage_never_happened`, with a `note` on each saying where they did happen, and
> its journey from introduction to Final Stage reads 42 days.** The next shortest
> Private Bill took 132 days and the median of the 22 that passed is 274.
> Measured from the first introduction, the same business took 364 days. Neither
> figure is wrong; they measure different things.
>
> **`carried_scrutiny_from_bill_number` records which bill it carried its
> scrutiny from, so a chart of how long bills took can be built either way.** Any
> such chart carries this note and says which it used. One bill is affected.

**Applies to:** `carried_scrutiny_from_bill_number`, `stage_never_happened`,
`session`.

---

## M10 — How a bill was handled is recorded only where a source says so

Two changes: the headings, and the cut agreed in block 2.

### As it reads today

> The Parliament handles some bills differently from most: an emergency bill
> takes its three stages in days rather than months, a Budget Bill runs to a
> timetable of its own, and consolidation bills have their own procedure. This
> resource records that where a source states it, and leaves it empty everywhere
> else.
>
> An empty cell therefore means we have not been told. It does not mean the bill
> went through the standard procedure. Filling the column in with "standard"
> wherever nothing else was stated would have recorded every budget and
> emergency bill as a standard one, on no evidence, and that has been refused
> since the column was made.
>
> What is stated, and by whom: the Session 6 and Session 7 fact sheets print a
> sentence of the form "Motion agreed to treat as Emergency Bill on 22 June 2021"
> against a bill handled as an emergency bill, and no fact sheet for Sessions 1
> to 5 mentions procedure at all. So the column is filled for five bills, all of
> them in Session 6, and empty for every other bill in the resource. The date the
> Parliament agreed to treat the bill that way is recorded beside it, and is
> empty for a procedure that needed no such decision.
>
> Sessions 1 to 5 certainly contained emergency bills, and filling them in means
> reading a source that states procedure — the Official Report, or the
> Parliament's own pages for each bill. That is expected but not yet done. Until
> it is, a count of emergency bills is a count of the ones Session 6 happens to
> name, and a chart that groups bills by procedure is a chart of five bills and a
> very large "not known". Any chart drawn on this column carries this note.

### Proposed

> The Parliament handles some bills differently from most: an emergency bill
> takes its three stages in days rather than months, a Budget Bill runs to a
> timetable of its own, and consolidation bills have their own procedure.
> **`procedure` records that where a source states it, and is empty everywhere
> else.**
>
> **An empty cell therefore means we have not been told. It does not mean the
> bill went through the standard procedure.**
>
> What is stated, and by whom: the Session 6 and Session 7 fact sheets print a
> sentence of the form "Motion agreed to treat as Emergency Bill on 22 June 2021"
> against a bill handled as an emergency bill, and no fact sheet for Sessions 1
> to 5 mentions procedure at all. **So `procedure` is filled for five bills, all
> of them in Session 6, and empty for every other bill in the resource.
> `date_procedure_agreed` holds the day the Parliament agreed to treat the bill
> that way, and is empty for a procedure that needed no such decision.**
>
> Sessions 1 to 5 certainly contained emergency bills, and filling them in means
> reading a source that states procedure — the Official Report, or the
> Parliament's own pages for each bill. That is expected but not yet done. Until
> it is, a count of emergency bills is a count of the ones Session 6 happens to
> name, and a chart that groups bills by procedure is a chart of five bills and a
> very large "not known". **Any chart drawn on `procedure` carries this note.**

**The cut**, agreed in block 2: the third sentence of the second paragraph,
"Filling the column in with 'standard' … since the column was made." It is the
note telling a reader how our own rule came about, which no other note does, and
it names the column. The two sentences that say what an empty cell means stay,
because they are the thing a reader needs.

**Applies to:** `procedure`, `date_procedure_agreed`.

---

## M11 — A stage record holds the day a stage ended, and sometimes the day it was reached

### As it reads today

> M2 says that a stage is completed on the date of the decision that ended it,
> and that is the date almost every stage record in this resource holds. It is
> the only date the fact sheets state for Stages 1, 2 and 3.
>
> One stage is different. A bill that has passed and been stopped before Royal
> Assent can be taken back by the Parliament for a Reconsideration Stage, and the
> Session 6 fact sheet prints two days for it: the day the Parliament agreed to
> reconsider the bill, and the day it approved the bill and the stage ended. Both
> are decisions of the Parliament and both are dated, so both are recorded: the
> first as the day the stage was reached, the second as the day it ended.
>
> Where a stage has no day reached, no source has told us when the bill reached
> it. It does not mean the stage was reached and ended on the same day, and it is
> never worked out from the stage before: a stage record says what a source
> stated and nothing else. At the time of writing two stage records carry it,
> both Reconsideration Stage records, and both are bills of Session 5
> reconsidered in Session 6 — the UNCRC (Incorporation) Bill and the European
> Charter of Local Self-Government (Incorporation) Bill.
>
> So a duration built from stage records is a duration between days the stages
> ended, for every stage but this one. Anything that measures how long a
> Reconsideration Stage took should say which two dates it used, because only
> that stage has the choice.

### Proposed

> M2 says that a stage is completed on the date of the decision that ended it,
> and that is the date almost every stage row in this resource holds. It is the
> only date the fact sheets state for Stages 1, 2 and 3.
>
> One stage is different. A bill that has passed and been stopped before Royal
> Assent can be taken back by the Parliament for a Reconsideration Stage, and the
> Session 6 fact sheet prints two days for it: the day the Parliament agreed to
> reconsider the bill, and the day it approved the bill and the stage ended.
> **Both are decisions of the Parliament and both are dated, so both are
> recorded: the first as `date_reached`, the second as `date_ended`.**
>
> **Where `date_reached` is empty, no source has told us when the bill reached the
> stage.** It does not mean the stage was reached and ended on the same day, and
> it is never worked out from the stage before: a stage row says what a source
> stated and nothing else. **At the time of writing two rows carry it**, both
> Reconsideration Stage rows, and both are bills of Session 5 reconsidered in
> Session 6 — the UNCRC (Incorporation) Bill and the European Charter of Local
> Self-Government (Incorporation) Bill.
>
> **So a length of time built from these rows is a length between days the stages
> ended, for every stage but this one.** Anything that measures how long a
> Reconsideration Stage took should say which two dates it used, because only
> that stage has the choice.

"Stage record" becomes "stage row" throughout, because the published copy has no
stage record numbers and a reader is looking at a row of a spreadsheet.
"Duration" becomes "length of time", which is the same change the other notes
already made.

**Applies to:** `date_reached`, `date_ended`.

---

## M12 — A fact sheet is a snapshot

### As it reads today

> A fact sheet says where each bill had got to on the day it was compiled, not
> where it stands now. Seven bills the Session 6 sheet leaves awaiting Royal
> Assent had become Acts four months before we read it.
>
> So every bill a fact sheet leaves awaiting Royal Assent is checked at
> legislation.gov.uk before it is admitted, and the answer recorded either way —
> including where no Act has been made, as for the four bills M5 covers. Where
> the Act was made, its date of Royal Assent, its number and its title come from
> legislation.gov.uk and say so, with the day each was read. The rest of the
> bill's line still comes from the fact sheet.

### Proposed

> A fact sheet says where each bill had got to on the day it was compiled, not
> where it stands now. Seven bills the Session 6 sheet leaves awaiting Royal
> Assent had become Acts four months before we read it.
>
> So every bill a fact sheet leaves awaiting Royal Assent is checked at
> legislation.gov.uk before it is admitted, and the answer recorded either way —
> including where no Act has been made, as for the four bills M5 covers. **Where
> the Act was made, its `date_royal_assent`, its `act_number` and its `title` come
> from legislation.gov.uk, and the `sources` file says so with the day each was
> read.** The rest of the bill's line still comes from the fact sheet.

**Applies to:** `date_royal_assent`, `act_number`, `title`, `enactment_status`.

---

## M13 — A bill still before the Parliament is counted, and has no ending

### As it reads today

> A fact sheet lists bills still before the Parliament alongside those that have
> finished. Such a bill is recorded here with its outcome given as in progress,
> and with nothing recorded about an Act, because neither is yet known — which is
> not the same as a bill whose ending we could not find. It is counted as a bill
> of its session like any other.
>
> Time is measured for it as for any other bill, between the stages it has
> completed; the stage it is at gives no figure until it ends. Which bills a
> figure about time covers is decided when the figure is drawn, as M2 says.
>
> Where a chart shows timescales by session, a session whose bills have not yet
> completed a stage is shown blank, and this note is given against it. Blank
> means there is nothing yet to measure. It does not mean nought days.

### Proposed

> A fact sheet lists bills still before the Parliament alongside those that have
> finished. **Such a bill has `outcome` given as In progress, and nothing
> recorded about an Act, because neither is yet known** — which is not the same as
> a bill whose ending we could not find. It is counted as a bill of its session
> like any other.
>
> Time is measured for it as for any other bill, between the stages it has
> completed; the stage it is at gives no figure until it ends. Which bills a
> figure about time covers is decided when the figure is drawn, as M2 says.
>
> Where a chart shows timescales by session, a session whose bills have not yet
> completed a stage is shown blank, and this note is given against it. Blank
> means there is nothing yet to measure. It does not mean nought days.

**Applies to:** `outcome`, `enactment_status`, `date_introduced`, `date_ended`.

---

## M14 — Session 7 is measured to the day it is expected to end

### As it reads today

> Session 7 has not ended, so its last day is not yet known. To divide it into
> quarters we use the day it is expected to end: 1 April 2031.
>
> The next election is due on 1 May 2031, the first Thursday in May five years
> after the last (Scotland Act 1998, section 2). The Parliament is dissolved at
> the start of the 20 days that end on polling day, not counting weekends and
> public holidays, and 1 April 2031 is the last day before that. Counted the same
> way, the rule gives Session 6's actual last day, 8 April 2026.
>
> The date can move: the poll can be brought forward or put back by proclamation,
> or an early election held. Until the session ends, its quarters are an
> estimate, and its later quarters hold only the bills introduced so far. When it
> ends, its real last day replaces the estimate and its figures are worked out
> again.

### Proposed

> Session 7 has not ended, so its last day is not yet known. **To divide it into
> quarters we use `date_session_expected_to_end`: 1 April 2031.**
>
> The next election is due on 1 May 2031, the first Thursday in May five years
> after the last (Scotland Act 1998, section 2). The Parliament is dissolved at
> the start of the 20 days that end on polling day, not counting weekends and
> public holidays, and 1 April 2031 is the last day before that. Counted the same
> way, the rule gives Session 6's actual last day, 8 April 2026.
>
> The date can move: the poll can be brought forward or put back by proclamation,
> or an early election held. Until the session ends, its quarters are an
> estimate, and its later quarters hold only the bills introduced so far. **When
> it ends, its real last day goes into `date_session_ended`,
> `date_session_expected_to_end` is emptied, and its figures are worked out
> again.**

The last sentence gains a fact it did not have: which of the two dates ends up
holding what. That is the rule the database already enforces, and a reader who
sees both headings will ask.

**Applies to:** `date_session_expected_to_end`, `date_session_ended`.
