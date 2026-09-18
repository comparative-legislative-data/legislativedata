# What the words mean: the definitions made fit to publish

Proposed 2026-09-18. Nothing here is built. It settles the item left open in §7
of `docs/PHASE-2-PUBLISHED-COPY.md`, and it comes before the published copy is
built, because the copy publishes these definitions as `what_the_words_mean`.

## The short version

Every value a reader meets in a dropdown has a definition, and the published
copy prints all of them. §7 counted nine that named database columns. Having
read every definition in full, the problem is wider and has a different shape:
**29 of the 58 definitions on the published lists cannot be published as they
stand**, and not only because they name columns.

- **Some are written to whoever enters data**, not to a reader: where to put
  the address, what the error checker will refuse, which migration renamed the
  value.
- **Two are wrong.** The section 33 definition says all three bills were ruled
  on on 6 October 2021, but the Legal Continuity Bill was ruled on on
  13 December 2018. It also says the fact sheet's footnote is kept against
  `enactment_status`, but since Session 6 was read it has been kept against how
  and when the bill was stopped.
- **One contradicts M8.** The thesis dataset's definition says "2022 thesis"
  (the year was settled as 2021 on 12 September and this one was missed) and
  "ground truth where it covers a case". M8, which you approved later, says it is
  used where no other source gives the date and nothing contradicts it.
- **Five are empty**, three of them on values that 129 bills use.

**The proposal is the one in §7, made into a rule.** A definition is written
for a reader. Like the notes, it may name a published heading. It never names a
working column, a code, a file, a migration or the error checker, and it never
tells anyone what to do. Where a definition carries an instruction, the
instruction moves into the description of the column it is about, which is
where Postico shows it to whoever is entering data. Nothing is lost, and there
is still one copy of each thing.

**No value, label or cell changes.** Only the wording of definitions, and the
descriptions of a few columns.

---

## 1. The rows

Every definition in the ten lists the copy publishes that needs changing. The
other 29 are fine as they stand. A value can appear under more than one heading
below. The party list is not published, because every bill's party is empty, so
it is left alone.

**Names a working column or a code (12)**

| List | Value | The words |
|---|---|---|
| Bill type | Government Bill | "recorded separately in bill.bill_type_stated" |
| Bill type | Hybrid Bill | "see analysis_group" |
| Bill type at the time | Executive Bill | "Recorded as bill_type = government." |
| Enactment status | Pending | "is 'blocked', not 'pending'" |
| Outcome | Fell (other) | "record it in note" |
| After being stopped | Withdrawn after being blocked | "enactment_status is not_enacted and date_concluded holds the day" |
| After being stopped | Reconsidered and passed | "enactment_status is enacted" |
| How stopped | Section 33 reference | "the provenance of enactment_status" (and wrong; see below) |
| Stage 1 rejection route | amended to reject | "are in bill.note" |
| Stage 1 rejection route | Rule 9.14.18 | "is in bill.note" |
| Source | Bill document | "which are bill_page" |
| Source | Manual | "say which in note" |

**Written to whoever enters data (11)**

| List | Value | The words |
|---|---|---|
| Source | Parliament's bill page | "Put the address ... in source_ref; a bill with more than one relevant page gets one row per page." |
| Source | Bill document | "Nothing uses this at 2026-09-12: the fifteen stage records that did were bill pages and moved to bill_page at db/042." |
| Source | SPICe legislation factsheet | "Put the session and retrieval date in source_ref ... The retrieved copy is in sources/factsheets/. Called spice_factsheet until db/047 ..." |
| Source | SPICe dates factsheet | "put the publication date and the page in source_ref ... The retrieved copy is in sources/factsheets/." |
| Source | legislation.gov.uk | "put the address of the Act's page in source_ref" |
| Source | Supreme Court | "Put the address of the case page in source_ref." |
| After being stopped | Reconsidered and fell | "the owner agreed to it on that basis on 2026-09-14; nothing in the database uses it, and the error checker will refuse it unless ..." |
| Stage 1 rejection route | some other route | "Usable only where ... quoted in the staging line's review note and bill.note ...; the error checker requires both." |
| Procedure | Emergency | "Flag rather than exclude: these distort duration averages." |
| Stage | Reconsideration Stage | "Breaks the assumption that Stage 3 is the end." |
| Outcome | Fell: financial resolution not agreed | "One case at 2026-09-13" |

**Wrong, contradicting a note, or telling the reader nothing (3)**

| List | Value | What is wrong |
|---|---|---|
| How stopped | Section 33 reference | "all ruled on by the Court on 6 October 2021": the Legal Continuity Bill was ruled on on 13 December 2018. "kept word for word as the provenance of enactment_status": since Session 6 was read, the footnote is kept against how and when the bill was stopped. |
| Source | PhD dataset | "Coded for the 2022 thesis": settled as 2021 on 12 September. "Ground truth where it covers a case": M8 says it is used where no other source gives the date. |
| Source | Parliament API | "data.parliament.scot." No fact rests on it. Not wrong, but the reader is told nothing. |

**Empty (5), on values bills use or could**

| List | Value | Bills using it |
|---|---|---|
| Bill type at the time | Member's Bill | 95 |
| Bill type at the time | Committee Bill | 10 |
| Bill type at the time | Private Bill | 24 |
| Procedure | Statute Law Repeals | 0 |
| Procedure | Statute Law Revision | 0 |

---

## 2. The proposed wording

Current wording first, then the proposed. This is published text, so it is
given whole.

### Bill type

**Government Bill.** *Now:* Introduced by the Scottish Government. Styled an
Executive Bill for part of the Parliament's history; the label used at the time
cannot be derived from the session or the date and is recorded separately in
bill.bill_type_stated. See methodology note M1.
*Proposed:* Introduced by the Scottish Government. Styled an Executive Bill for
part of the Parliament's history; the label used at the time cannot be worked
out from the session or the date, and is kept in bill_type_at_the_time. See
methodology note M1.

**Hybrid Bill.** *Now:* ... Counted as a government bill when types are grouped
— see analysis_group and methodology note M4.
*Proposed:* Introduced under the hybrid bill procedure: a bill of a public
character that affects particular private interests. One exists, the Forth
Crossing Bill of Session 3. Counted as a government bill when types are
grouped, in bill_type_grouped; see methodology note M4.

### Bill type at the time

**Executive Bill.** *Now:* Styled an Executive Bill when introduced. Recorded as
bill_type = government.
*Proposed:* Styled an Executive Bill when introduced. Its bill_type is
Government Bill; see methodology note M1.

**Member's Bill.** *Now:* empty. *Proposed:* Styled a Member's Bill when
introduced.

**Committee Bill.** *Now:* empty. *Proposed:* Styled a Committee Bill when
introduced.

**Private Bill.** *Now:* empty. *Proposed:* Styled a Private Bill when
introduced.

### Enactment status

**Pending.** *Now:* ... A bill referred to the Supreme Court or subject to a
section 35 order is 'blocked', not 'pending'.
*Proposed:* No Act yet, and nothing adverse recorded: a bill still before the
Parliament, or one that has passed and is awaiting Royal Assent. A bill referred
to the Supreme Court or subject to a section 35 order is Blocked, not Pending.

### Outcome

**Fell (other).** *Now:* Fell for another reason; record it in note.
*Proposed:* Fell for a reason none of the other values covers; note says what
it was. No bill has fallen this way.

**Fell: financial resolution not agreed.** *Now:* ... One case at 2026-09-13:
the Creative Scotland Bill, 18 June 2008.
*Proposed:* the same, ending "One bill: the Creative Scotland Bill, 18 June
2008." The two hyphens in "Stage 1 -- its general principles were agreed --"
become dashes.

### How the bill was stopped before Royal Assent

**Section 33 reference to the Supreme Court.** *Now:* A law officer referred the
bill ... and the Court ruled that some of its provisions were not. Three bills,
all in Session 5, all referred by the Attorney General and the Advocate General
for Scotland and all ruled on by the Court on 6 October 2021. The fact sheet's
own footnote for each is kept word for word as the provenance of
enactment_status.
*Proposed:* A law officer referred the bill to the Supreme Court under section
33 of the Scotland Act 1998, on the question whether it was within the
Parliament's legislative competence, and the Court ruled that some of its
provisions were not. Three bills, all in Session 5, all referred by the Attorney
General and the Advocate General for Scotland: the UK Withdrawal from the
European Union (Legal Continuity) (Scotland) Bill, ruled on on 13 December
2018, and two bills ruled on on 6 October 2021. The fact sheet's own footnote
for each is kept word for word in the sources file.

### What happened after it was stopped

**Withdrawn after being blocked.** *Now:* ... Its enactment_status is
not_enacted and date_concluded holds the day it was withdrawn. ...
*Proposed:* The bill was withdrawn after it was stopped, so it will not become
an Act. Its enactment_status is Not enacted, and date_fell_or_withdrawn holds
the day it was withdrawn. One bill: the UK Withdrawal from the European Union
(Legal Continuity) (Scotland) Bill, withdrawn on 10 March 2022, which the
Session 6 fact sheet prints in a section of its own and excludes from that
session's totals.

**Reconsidered and passed.** *Now:* ... Its enactment_status is enacted, and its
Reconsideration Stage row carries the date the stage ended. ...
*Proposed:* The Parliament reconsidered the bill under the Reconsideration
Stage, approved it, and it went on to Royal Assent. Its enactment_status is
Enacted, and its Reconsideration Stage line in the stages file carries the date
the stage ended. Two bills, both Session 5 bills reconsidered in Session 6.

**Reconsidered and fell.** *Now:* ... No bill has done this. The value exists
so that the next one has somewhere to go, and the owner agreed to it on that
basis on 2026-09-14; nothing in the database uses it, and the error checker will
refuse it unless the bill has a Reconsideration Stage row where it ended.
*Proposed:* The Parliament reconsidered the bill under the Reconsideration Stage
and did not approve it, so the bill fell there. No bill has done this. The value
exists so that the next one has somewhere to go.

### How it was rejected at Stage 1

**Amended to reject.** Only the last sentence changes. *Now:* The amendment, who
moved it and the reason the resolution gives are in bill.note.
*Proposed:* The amendment, who moved it and the reason the resolution gives are
in note.

**Rule 9.14.18.** Only one sentence changes. *Now:* ... our view, where the
grounds allow one, is in bill.note. *Proposed:* ... our view, where the grounds
allow one, is in note.

**Some other route.** *Now:* The Parliament did not agree to the bill's general
principles by some path other than those above. Usable only where the Presiding
Officer's announcement is quoted in the staging line's review note and bill.note
says what happened and what its effect was; the error checker requires both. It
exists so that a bill whose procedure nobody anticipated can be recorded
truthfully rather than stop a whole session, and it is not a place to leave
things: a second case of the same kind earns its own entry here.
*Proposed:* The Parliament did not agree to the bill's general principles by
some path other than those above; note says what happened and what its effect
was. No bill has been rejected this way. The value exists so that a bill whose
procedure nobody anticipated can be recorded truthfully; a second case of the
same kind would be given a value of its own.

### Procedure

**Emergency.** *Now:* Stages compressed, often into a single day. Flag rather
than exclude: these distort duration averages.
*Proposed:* Stages compressed, often into a single day. Emergency Bills are kept
in every figure rather than left out, and pull an average time down; procedure
lets a reader set them aside.

**Statute Law Repeals.** *Now:* empty. *Proposed:* Handled under the procedure
for a Statute Law Repeals Bill, which repeals enactments that are no longer of
practical use.

**Statute Law Revision.** *Now:* empty. *Proposed:* Handled under the procedure
for a Statute Law Revision Bill, which tidies the statute book without changing
the law.

These two are my wording of your field, and are the ones to check hardest.

### Stage

**Reconsideration Stage.** *Now:* After referral or a section 35 order. Breaks
the assumption that Stage 3 is the end.
*Proposed:* A stage after a reference to the Supreme Court or a section 35
order, at which the Parliament considers the bill again. A bill that has one did
not end at its third stage.

### Source

**Parliament API.** *Now:* data.parliament.scot.
*Proposed:* The Scottish Parliament's open data, at data.parliament.scot. No
fact in this data rests on it.

**PhD dataset.** *Now:* Coded for the 2022 thesis. Ground truth where it covers
a case.
*Proposed:* The dataset compiled for Steven MacGregor, "Does government dominate
the legislative process?" (PhD thesis, University of Stirling, 2021), maintained
since to cover Sessions 6 and 7. Used for the dates of Stages 1 and 2 where no
other source gives the date and nothing contradicts it; see methodology note M8.

**Manual.** *Now:* Entered by hand from knowledge or a source not otherwise
listed; say which in note.
*Proposed:* Entered by hand from knowledge or a source not otherwise listed;
where_in_the_source says which. *(The five lines that use it say which in
where_in_the_source, not in note, so the current wording is also wrong.)*

**Parliament's bill page.** *Now:* ... Definitive for dates other than Royal
Assent. Put the address of the particular page in source_ref; a bill with more
than one relevant page gets one row per page.
*Proposed:* The Scottish Parliament's own page for a bill or Act, live or as
kept by the web archive. Definitive for dates other than Royal Assent.
where_in_the_source gives the page's address.

**Bill document.** *Now:* Bill as introduced, marshalled list, explanatory
notes. Not the Parliament's bill pages, which are bill_page. Nothing uses this
at 2026-09-12: ... db/042. Explanatory Notes belong here ... so it is not
definitive.
*Proposed:* The bill as introduced, a marshalled list of amendments, or the
Explanatory Notes; not the Parliament's own pages for a bill. No fact in this
data rests on it. The Explanatory Notes give an Act's parliamentary passage, but
they are written by government officials rather than by the Parliament's, so
they are not used for dates; see methodology note M8.

**SPICe legislation factsheet.** *Now:* ... Put the session and retrieval date
in source_ref, e.g. "session 6, retrieved 2026-09-10". The retrieved copy is in
sources/factsheets/. Called spice_factsheet until db/047, ...
*Proposed:* One of SPICe's per-session legislation fact sheets: the list of
bills introduced in a session and what happened to each. A derived source: the
outcome and type coding is SPICe's. where_in_the_source gives the session and
the day the copy was retrieved.

**SPICe dates factsheet.** *Now:* ... so put the publication date and the page
in source_ref, e.g. "published 2 September 2026, p2". A derived source, and
hand-maintained -- ... The retrieved copy is in sources/factsheets/.
*Proposed:* SPICe's fact sheet "Dates of recess, dissolution, parliamentary
years and recalls of Parliament": when each session began and ended, when the
Parliament was in recess or dissolved, and when it was recalled. One document
covering every session; where_in_the_source gives its publication date and the
page. A derived source, and maintained by hand — it carries at least one
typographical error in its own tables — so it is read with the same care as any
other fact sheet.

**legislation.gov.uk.** *Proposed:* the same, with "put the address of the Act's
page in source_ref" becoming "where_in_the_source gives the address of the Act's
page".

**Supreme Court.** *Proposed:* the same, with "Put the address of the case page
in source_ref" becoming "where_in_the_source gives the address of the case
page".

---

## 3. Where the instructions go

Each is added to the description of the column it is about. These are not
published; they are what Postico shows beside the column.

- **The three "exact place within that source" columns** (on the bill, the
  stage, and the provenance line): what goes there for each kind of source —
  the page's address for a bill page, legislation.gov.uk or the Supreme Court,
  one line per page where a bill has several; "session 6, retrieved 2026-09-10"
  for a legislation fact sheet; "published 2 September 2026, p2" for the dates
  fact sheet; what the source was, for one entered by hand. Retrieved fact
  sheets are kept in `sources/factsheets/`.
- **The bill's note**: where the outcome is Fell (other), the reason goes here.
- **How it was rejected at Stage 1** (clean and staging sheets): Some other route
  is accepted only with the Presiding Officer's announcement quoted in the review
  note and the bill's note saying what happened; the checker requires both.
- **What happened after it was stopped**: the checker refuses Reconsidered and
  fell unless the bill has a Reconsideration Stage where it ended.
- **The history of renamed values** (bill_page at `db/042`, spice_factsheet at
  `db/047`) and the date you agreed Reconsidered and fell go nowhere new. They
  are already in the migrations and in `DECISIONS.md`.

And the description of the definition column itself, on every list, says the
rule: written for a reader; may name a published heading; never a working
column, a code or an instruction, which belong in the column's description.

---

## 4. The checklist

| | Proposed |
|---|---|
| **What it records, and its values** | No value added, removed or relabelled. 24 definitions reworded and 5 filled in, as in §2. |
| **Which bills, and what empty means** | No bill's cell changes. After it, no definition on a published list is empty, so an empty definition means a value added since and not yet described. |
| **Where it sits on the clean sheet** | Where it is now: the definition beside each value. The instructions move to the column descriptions in §3. |
| **How it arrives on the staging sheet** | It does not; definitions are not loaded. Whoever enters data reads the instructions in the column descriptions, beside the column they are filling. |
| **Promotion and provenance** | Promotion does not touch definitions. The migration and a `DECISIONS.md` entry record what changed and why. |
| **What the error checker requires** | Nothing new while entering data. The migration refuses itself if any published definition, after the change, names a working column, a code, a file or a migration, or is empty; the copy, when built, runs the same check before publishing. |
| **What the methodology notes say** | No note changes. The PhD dataset and the section 33 definitions are brought into line with M8 and the data. |
| **Every bill already coded** | Checked by the migration: every value a bill uses has a definition, and the two facts corrected (the 2018 ruling, and where the footnote is kept) are read back against the bills they describe. |
| **When** | Built next session, after you agree the wording: rehearsed inside a rollback, applied, read back word for word against this file, with a closure test written for another session to run. Then the published copy. No session is waiting to be admitted, so nothing else is held. |

---

## 5. What to answer

1. **The rule** in the short version: agree, or change it.
2. **The wording in §2**, and hardest the two Statute Law procedures and the
   PhD dataset's, which drops "ground truth".
3. **Unused values are published** with a definition saying nothing uses them
   (the API, Bill document, Fell (other), Reconsidered and fell, Some other
   route, and the procedures no bill has). Proposed yes: which values can appear
   is itself something a reader wants to know.
