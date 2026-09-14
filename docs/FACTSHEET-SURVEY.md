# Survey of the seven SPICe factsheets

Read 2026-09-10, from the copies in `sources/factsheets/` retrieved that day.
This is a survey of **structure**, not content: sections, summary tables,
footnotes, marker letters, and anything implying a state or a field the schema
has no home for. Nothing here was parsed into rows.

The purpose is to see the edge cases while `bill` is still empty and structural
change is still free.

---

## 1. The documents are not one format, they are four

| Session | Published | Ref | Layout | Type letters | Sections |
|---|---|---|---|---|---|
| 1 | 10 Jan 2008 | FS4-04 | ruled table | C E M P | Acts, Withdrawn, Fallen |
| 2 | 10 Jan 2020 | FS4-16 | ruled table | C E M P | Acts, Withdrawn, Fallen |
| 3 | 28 Apr 2011 | FS4-31 | ruled table | C E M **H** P | Acts, Withdrawn, Fallen |
| 4 | 29 Apr 2016 | FS4-33 | ruled table | C E **G G\*** M H **RA** | Acts, Withdrawn, Fallen |
| 5 | 8 Oct 2021 | FS3-04 | ruled table | C G M H RA (**no E**) | **Awaiting RA**, Fallen, Withdrawn, Acts |
| 6 | 27 Apr 2026 | — | prose | none — type is in the sentence | Awaiting RA, Fallen, Withdrawn, **Session 5 withdrawn in S6**, Acts |
| 7 | 9 Sep 2026 | — | prose | none | **In progress**, Awaiting RA, Fallen, Withdrawn, Acts |

Structural consequences beyond the two parsers already planned:

- **Section order is not stable.** Sessions 1–4 put Acts first; 5–7 put them
  last. A parser must key on the heading, never on position.
- **Column headers differ.** "Title of Act" in 1, 2, 3, 5; "Name of Act" in 4.
- **Empty sections in Session 7 are sentences, not empty tables** — "No bills
  have fallen in Session 7." A parser must not read that as a bill.
- **`RA` is defined in Sessions 4 and 5 and never used.** A dead abbreviation.
- **The prose in Sessions 2, 3, 4 and 5 describing the sections is stale
  boilerplate.** All four say the document is divided into bills in progress,
  passed, Royal Assent, and withdrawn. None of the four has a "bills in
  progress" section, and all have a "fallen" section that the prose does not
  mention. Session 2 is additionally labelled "Parliamentary Business: **Current**
  Series" for a session that ended in 2007.

### The Session 6 / 7 prose grammar

**Corrected 2026-09-14**, by matching every sentence in both documents against
the list and requiring nothing to be left over. As first written this section
claimed sixteen shapes, listed nine, and called the list complete. It was
neither complete nor sixteen. What follows is every shape, and it has been
tested: 83 entries in Session 6 and 2 in Session 7, no sentence unmatched.

**Two of these wrap across printed lines** — the rename sentence in both places
it appears. A reader that matches line by line does not merely miss it; it
swallows it into the next bill's title in silence. Work on reflowed text.

**The reader that reads this grammar is `tools/read_prose_factsheet.py`**, built
2026-09-14. It works on reflowed text for the reason above, matches a heading
only as a complete printed line — the cover page describes the sections in a
sentence containing three of them — and requires every character of both bodies
to land in a heading, a sentence or a title. If SPICe prints a shape that is not
on this list, the reader stops rather than guess, and this list is what it stops
against.

    {Title} (SP Bill {n})
    {Type} Bill introduced on {date} by {name} MSP.
    Passed on {date}.
    Fell on {date}.
    Withdrawn on {date}.
    Received Royal Assent on {date}.
    Reconsideration stage agreed on {date}.
    The Bill was approved and ended Reconsideration Stage on {date}.
    Introduced as the {old title} (SP Bill {n}) and renamed on {date} to the
        {new title} (SP Bill {n}).
    Motion agreed to treat as Emergency Bill on {date}.
    No bills have fallen in Session {n}.
    No bills have been withdrawn in Session {n}.
    No bills have become Acts in Session {n}.
    The following bill was introduced during Session {n} of the Scottish
        Parliament and has subsequently been withdrawn during Session {m}.
        Please note this bill is not included in Summary of Legislation
        totals below.
    *On {date} the UK Government intervened to block Scottish Parliament
        legislation (under powers contained in s.35 of the Scotland Act 1998)
        on the grounds that they believed it would have a negative impact on
        UK law.

**"Motion agreed to treat as Emergency Bill" is the only place any factsheet
states a bill's procedure**, and it is why `bill.procedure` has values at all.
Five bills carry it, all in Session 6. See `db/087` and methodology note M10.

**The last two are notes, not facts about a bill.** The excluded-section note
governs what the summary counts, and the reconciliation has to obey it. The
starred note sits directly after the bill it concerns — Session 6 puts the
asterisk on the section heading, Session 7 puts it nowhere — so position
attaches it, not the marker. That is unlike Sessions 4 and 5, which number
their footnotes and print them at the foot of the page.

Only "Government Bill" and "Member's Bill" occur. There are no Committee,
Private or Hybrid Bills in Sessions 6 or 7.

---

## 2. The summary tables do not use the factsheets' own vocabulary

Every factsheet prints its own outcome-by-type cross-tab, and the reconciliation
gate depends on it. Three of them do not agree with the type letters in the
document above them.

### 2.1 Session 3 counts the only Hybrid Bill as Executive

Session 3 defines `H` for Hybrid Bill and applies it to exactly one row, the
Forth Crossing Act 2011. Its summary table has columns Executive, Member's,
Private, Committee — **no Hybrid column**. Counting the type letters gives
E 44, M 13, H 1, C 2, P 2. The summary says Executive **45**, Member's 13,
Private 2, Committee 2.

So the Hybrid Bill is folded into Executive. Both add to 62, which means the
reconciliation passes while silently agreeing that a Hybrid Bill is an Executive
Bill. **The gate would not have caught this.** It is the only Hybrid Bill in all
seven sessions.

### 2.2 Session 4 folds E, G and G\* into one Government column

Type letters give G 52, E 10, G\* 5 — the summary's Government column is 67.
That is precisely the merge `bill_type_stated` exists to undo (D4, `db/012`),
and it confirms the stated/normalised split rather than challenging it: SPICe's
own table has already thrown the distinction away.

The `*` footnote reads **"Introduced as an Executive Bill (E)"**, as expected.
The abbreviation list additionally dates the changeover: **"E Executive Bill
(changed to Government Bill from September 2012)"**. The five `G*` bills were
all introduced before September 2012 and passed after it, and the `E` bills were
introduced *and* passed before it. So the marker is not arbitrary — it means
introduced under one style and passed under the other, which is a second stated
type at passage that we do not record. Session 5 drops `E` from the
abbreviations entirely.

### 2.3 Session 7's summary table does not add up

Printed, verbatim:

    Legislation              Government  Member's  Private  Committee  Total
    Bills in progress                 1         0        0          0      1
    Bills being reconsidered          0         0        0          0      0
    Bills awaiting Royal Assent       1         0        0          0      1
    Bills fallen                      0         0        0          0      0
    Bills withdrawn                   0         0        0          0      0
    Acts of the Scottish Parliament   0         0        0          0      0
    Total                             2         0        0          0      0

The grand total cell says **0** where every margin says 2. Confirmed against the
extracted table grid, so it is the document and not the extraction.

**This is the first case where the source's own arithmetic is wrong**, and the
reconciliation gate as designed compares our count against that arithmetic. For
Session 7 the gate has to be told which cell to trust.

### 2.4 Summary row vocabulary is not fixed either

Sessions 1–4 have three rows (Acts, Withdrawn, Fallen). Session 5 adds "Bills in
progress" and "Bills awaiting Royal Assent". Sessions 6 and 7 add "Bills being
reconsidered". Any check that assumes a fixed row set breaks at Session 5.

---

## 3. Bills that appear in two factsheets

Four bills, and every one of them is a different mechanism.

| Bill | First appearance | Second appearance | Counted in |
|---|---|---|---|
| European Charter of Local Self-Government (Incorporation) | S5, awaiting RA | S6, Acts, via Reconsideration | both totals |
| UNCRC (Incorporation) | S5, awaiting RA | S6, Acts, via Reconsideration | both totals |
| UK Withdrawal from the EU (Legal Continuity) | S5, awaiting RA | S6, own section, withdrawn | S5 only — explicitly excluded from S6 |
| Gender Recognition Reform | S6, awaiting RA | S7, awaiting RA | **both totals** |

Session 6 states the first two in a footnote to its own total: *"Total includes
two Bills which were introduced in Session 5 and were reconsidered and approved
in Session 6."* And it gives the third its own section heading, **"Session 5
bills which have been withdrawn during Session 6"**, with the note *"this bill is
not included in Summary of Legislation totals below."*

Session 7 says nothing of the kind about the Gender Recognition Reform Bill. It
is introduced 2 March 2022 — Session 6 — and is nevertheless counted as one of
Session 7's two bills.

**Amended after review (2026-09-10).** That is not an error on SPICe's part, and
this section originally said it was. A bill blocked under section 35 and left
there is not an unfinished bill: it has been passed, and the Scottish Government
has neither sought reconsideration nor withdrawn it, so nothing has happened that
would end it. It does not fall at dissolution the way an unfinished bill does. It
was a live bill in Session 7, and SPICe counts it as one.

So the four are not one category. Three are a bill finishing its business late —
two by reconsideration, one by withdrawal — and their second appearance is a
genuine double-count. The fourth never stopped being live. It is still one bill
and still one row in `bill`, but the reason it appears twice is different, and
the difference is the finding.

### The arithmetic that follows

Summary totals: 73 + 81 + 62 + 86 + 87 + 82 + 2 = **473** factsheet rows in
totals. Add the Legal Continuity row that Session 6 prints but excludes: **474
rows to load into `bill_candidate`.** Subtract the three double-counts —
European Charter, UNCRC, Gender Recognition Reform — and there are **470
distinct bills** to promote into `bill`.

That is a checkable number, and it is the first time the difference between
"rows" and "bills" has had one.

### The two factsheets disagree about a date

Session 5 says the European Charter Bill passed on **23 March 2021**. Session 6
says it passed on **23 May 2021**. Same bill, same event, two SPICe documents,
two dates. Both were retrieved on the same day.

This is the revision problem arriving as a contradiction rather than as a
reissue, and it is the first thing `field_source` has actually been needed for.

---

## 4. What the factsheets do not say

### 4.1 "Fell" never says why

No factsheet distinguishes a bill defeated at a vote from one that ran out of
time. Every such bill sits under a heading that says only "fallen". The
`ref_outcome` vocabulary has `rejected_stage_1`, `rejected_stage_3`,
`fell_dissolution` and `fell_other`, and **none of them can be derived from the
factsheet.**

One of them can be derived from the factsheet *plus* the day the session ended,
which is a different document: a bill that concluded on that day ran out of
time. Since `db/051` that comparison is made on the staging sheet, against the
session tab, and not by the reader, which sees one PDF and nothing else. Every
other fallen bill still needs the Official Report.

Fallen bills by session: 8, 10, 7, 6, 7, 10, 0 — **48 bills**. That is the size
of the Official Report task, and Session 1's five were 10% of it.

Session 3 makes it unavoidable: three of its seven fallen bills are Executive
Bills, including the Budget (Scotland) (No.2) Bill, which fell on 28 January
2009 — defeated at the final vote, not lost at dissolution. Session 1 had no
fallen Executive Bills at all, so `rejected_stage_3` has never been exercised.

### 4.2 SP Bill numbers are absent for Acts, and are not unique

Sessions 2–7 carry SP Bill numbers; Session 1 carries none. In Sessions 2–5 they
appear **only on rows that are still Bills** — withdrawn, fallen, or awaiting
Royal Assent. No row in an "Acts of the Scottish Parliament" table in Sessions
1–5 carries one. Sessions 6 and 7 carry them on every bill.

**The numbers restart each session.** SP Bill 7 is in Sessions 2 and 3; SP Bill
13 in 2, 6 and 7; SP Bill 65 in 4, 5 and 6; SP Bills 70, 71 and 72 each in three
sessions. `bill.sp_bill_id` is `text UNIQUE` on the bare value and **will
collide** the moment a second session is promoted.

### 4.3 Titles change during passage, and SPICe says so

Three explicit instances, in the documents' own words:

- Session 4, footnote 1: *"Was introduced as the Defective and Dangerous
  Buildings (Recovery of Expenses) (Scotland) Bill"*.
- Session 6: *"Introduced as the National Care Service (Scotland) Bill (SP Bill
  17) and renamed on 4 March 2025 to the Care Reform (Scotland) Bill (SP Bill
  17)."*
- Session 6: *"Introduced as the Scottish Parliament (Recall and Removal of
  Members) Bill (SP Bill 55) and renamed on 24 February 2026 to the Scottish
  Parliament (Recall of Members) Bill (SP Bill 55)."*

**Amended 2026-09-11: there is a fourth, and this survey missed it.** Session 2
prints an introduced title inside the title cell itself, not as a footnote:
*"Scottish Commission for Human Rights Act 2006 asp 16 Introduced as: Scottish
Commissioner for Human Rights Bill"*. Found by extraction when Session 2 was
loaded. It is why `bill_candidate` gained `title_as_introduced` at `db/028`
after §9 recorded it as deliberately not built. The lesson for the counts in
this document: a structural read of a PDF misses what sits inside a cell.

The Session 6 form carries a **date of renaming**, which nothing in the schema
holds. Note also that the SP Bill number survives the rename — which is what
makes it the stable identifier the title is not.

### 4.4 Footnotes carry facts about people

Session 4, footnote 3: Margo MacDonald died on 4 April 2014; Patrick Harvie was
designated an additional member in charge under Rule 9.2A. Member in charge is a
later slice, but this is a row-level footnote with a fact in it, and it should be
captured verbatim now rather than re-read later.

Committee Bills in Sessions 1–5 put two facts in one cell — the member and the
committee, e.g. *"Karen Gillon / Education, Culture and Sport Committee"*. Also a
later slice; also worth keeping verbatim.

---

## 5. Reconsideration Stage is a real, dated, two-event stage

Two bills reached it, both in Session 6, and both print two dates:

    Reconsideration stage agreed on 4 February 2026.
    The Bill was approved and ended Reconsideration Stage on 3 March 2026.

`db/018` provides for the stage itself: `reconsideration` sits at `stage_order` 4
for every bill type in `ref_bill_type_stage`. **Amended 2026-09-14: this section
said both dates had a home, and only one did.** A stage record held the day the
stage ended and nothing else, and `completed` says whether a stage was finished,
not when it was reached. The day the Parliament agreed to reconsider the bill had
nowhere to go until `db/088` added `date_reached` beside `date_completed`. Both
dates are now recorded, for these two bills and for no others, and methodology
note M11 says so to a reader.

The full sequence for the UNCRC Bill is: introduced 1 Sep 2020 (Session 5),
passed 16 Mar 2021, s.33 reference, Supreme Court ruling 6 Oct 2021,
reconsideration agreed 14 Sep 2023, reconsideration ended 7 Dec 2023, Royal
Assent 16 Jan 2024. Seven events, four years, two sessions, two factsheets.

---

## 6. "Passed but not enacted" has two distinct mechanisms

- **Section 33** — reference to the Supreme Court by the law officers. Session 5
  has three, all ruled outwith competence on 6 October 2021, each with its own
  footnote saying *"The Bill cannot be submitted for Royal Assent in its
  unamended form."*
- **Section 35** — an order by the UK Government. One bill, Gender Recognition
  Reform, footnoted in Sessions 6 and 7: *"On 16 January 2023 the UK Government
  intervened to block Scottish Parliament legislation (under powers contained in
  s.35 of the Scotland Act 1998)."*

`ref_enactment_status` has `pending` ("including referral") and `blocked`
("passed but prevented from receiving assent"). Both cases fit `blocked`; the
vocabulary does not record which mechanism, and neither value has ever been used.

Note that the state is temporary for three of the four: European Charter and
UNCRC were reconsidered and enacted, and Legal Continuity was withdrawn. Only
Gender Recognition Reform is still blocked. So `enactment_status` is a value that
changes over time, which is what `field_source` being append-only is for.

---

## 7. Session date ranges, stated

For the seven `session` rows, from page 1 of each factsheet:

| Session | Stated range |
|---|---|
| 1 | 12 May 1999 – 31 March 2003 |
| 2 | 7 May 2003 – 2 April 2007 |
| 3 | 9 May 2007 – 22 March 2011 |
| 4 | 11 May 2011 – 23 March 2016 |
| 5 | 12 May 2016 – 4 May 2021 |
| 6 | not stated — "from the beginning of Session 6" |
| 7 | not stated — "from the beginning of Session 7" |

Sessions 6 and 7 stated no range here, and that is now answered elsewhere.
**Settled on 2026-09-12 (`db/048`): the session dates come from SPICe's factsheet
"Dates of recess, dissolution, parliamentary years and recalls of Parliament",
published 2 September 2026,** which states a start and an end for every session
including the two missing here. Session 6 ended **8 April 2026** and Session 7
began **14 May 2026**. That document agrees to the day with all five ranges in
the table above and with `data.parliament.scot/api/sessions`, which covers
Sessions 1 to 6 and knows nothing of Session 7.

The dates are held on the session rows, and the column is `date_session_end`,
not `date_dissolution`: the source puts Session 1's dissolution *period* at 1
April to 1 May 2003, beginning at midnight on 31 March, so the last day of the
session and the start of dissolution are different dates. The last day is what
this project holds, and it is the date every bill that ran out of time concluded
on. The dissolution period itself is not recorded; nothing needs it yet.

---

## 8. What this forces

Six things the survey found that the schema has no answer for. None is a large
change and all of them are free today.

1. **`bill.sp_bill_id UNIQUE` collides across sessions.** The value has to be
   session-qualified, or the uniqueness has to be `(session_number, sp_bill_id)`.
2. **A bill that passed and was later withdrawn is refused by a `CHECK`.**
   `bill_concluded_only_if_not_passed` says `date_concluded IS NULL OR outcome
   <> 'passed'`. The Legal Continuity Bill passed on 21 March 2018 and was
   withdrawn on 10 March 2022. The constraint was written for a world in which
   passing is the end.
3. **Nothing holds a date of renaming**, though Session 6 states two.
4. **Nothing distinguishes a s.33 reference from a s.35 order**, and nothing
   distinguishes "awaiting assent, nothing wrong" from "blocked".
5. **A bill's `session_number` is ambiguous** for the four bills in two
   factsheets, and Session 7 counts a Session 6 bill as its own.
6. **The reconciliation gate compares against a figure that is wrong in Session
   7 and misleading in Session 3.**

## 9. Settled, 2026-09-10

All six were settled in the session that produced this survey, along with two
things the survey did not have on its list. `db/019`-`db/023`, and the entry in
`DECISIONS.md` of the same date.

1. **`sp_bill_id`** is unique within a session, not across sessions. `db/019`.
2. **Passing does not conclude a bill.** The `CHECK` becomes a rule about
   enactment. `db/020`, with `date_assent_blocked` added so a block has a date,
   and methodology note **M5**.
3. **Two title columns**, `short_title` and `title_as_introduced`, the second
   null wherever no source states it. `db/021`, and M3 rewritten.
4. **`blocked` covers both s.33 and s.35**, with the mechanism in `bill.note`.
   The `pending` definition is tightened so the two cannot both describe the same
   bill. No new vocabulary — stasis is the absence of a further event, not a
   state of its own. `db/020`.
5. **A bill belongs to the session it was first introduced in.** `db/023`,
   methodology note **M6**, which also publishes the 473 / 470 / 474 arithmetic.
6. **The reconciliation figures are recorded per session** in §2 of this
   document, and in `STATE.md` against the load of each session. No schema.

And two the survey found on the way:

7. **Hybrid Bills** keep `bill_type = 'hybrid'` and gain
   `ref_bill_type.analysis_group`, which groups them to government. `db/022`,
   methodology note **M4**. The thing to watch is charting: a chart that groups
   must say which column it grouped on.
8. **Why a bill fell is our coding, not SPICe's**, and it is 5 of 48 done.
   Methodology note **M7**, `db/023`.

Two things are known and deliberately not built, because Session 1 needs
neither and building them now would be speculative:

- *(Amended 2026-09-11: the introduced title now has a column, `db/028`,
  because Session 2 states one. Rename and block dates still do not.)*
- **`bill_candidate` has no column for a stated introduced title, a rename date,
  or a block date.** Sessions 4, 5, 6 and 7 state them; Session 1 states none.
- **The session-window checks in `v_candidate_problems` compare a candidate's
  dates against the session of the factsheet it was read from**, which is the
  wrong session for a carry-over row. Session 1 has no carry-overs. This must be
  handled before Session 5 is loaded, and the limitation is written into the view
  itself at `db/020` so it cannot be forgotten silently.
