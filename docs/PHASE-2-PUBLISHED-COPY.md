# The published copy: its files, its headings, and the notes rewritten in them

For the owner. Written 17 September 2026. **Nothing here is built.** This is
block 1 of `docs/PHASE-2-CHARTS-BUILD.md`, point 2 of the eight: the headings
are chosen, and the methodology notes rewritten in those headings, before any
chart calculation is written. Both are proposals; nothing changes until you
agree them.

What the copy is and what crosses into it was settled on 17 September
(`DECISIONS.md`). This does not reopen any of that. It fills in the one thing
that decision left as "a starting point": the actual headings.

---

## The short version

**Nine files.** Three hold the data, one holds the sessions, and five explain
it: the notes, the sources, what the words mean, what changed, and when the copy
was taken.

**Every cell holds words, not codes.** Where the working database says
`fell_dissolution`, the published copy says `Fell at dissolution`. That is what
makes the ninth file — what the words mean — the reader's dictionary rather than
a decoder ring.

**Thirteen of the fourteen notes change.** Almost all of the changes are the
same change: a note says "kept beside it" or "recorded separately", and the
published version names the heading, so a reader with the file open can find the
thing the note is about. M6 does not change. M10 changes twice, once for this
and once for the cut already agreed in block 2, and both are done together here
rather than leaving the note half-rewritten.

**One thing I found that is bigger than the check said.** `STATE.md` records
four lists of allowed values that still name database columns. It is nine
entries across seven lists. §7 sets out what I think should happen, and it is
new work, so it is yours to agree or refuse.

---

## 1. The nine files

| File | One line per | Rows today |
|---|---|---|
| `bills` | bill | 470 |
| `stages` | stage a bill reached | 1291 |
| `days_between_stages` | gap between two dated points | 1657 |
| `sessions` | session | 7 |
| `methodology_notes` | note | 14 |
| `sources` | fact that names its own source | 192 |
| `what_the_words_mean` | heading and value | about 90 |
| `what_changed` | cell whose published value changed | 0 at the first copy |
| `about` | file, plus the date the copy was taken | 9 |

The last two are the two things the copy holds that the working database does
not, as settled.

---

## 2. `bills` — one line per bill

| Heading | What it holds |
|---|---|
| `bill_number` | Our number for the bill. Ours, never the Parliament's. |
| `sp_bill_number` | The Parliament's number within its session. Empty where none is known. |
| `session` | The session the bill was introduced in. |
| `title` | The title the bill is known by: the Act's title where it became an Act, otherwise the title it ended with. |
| `title_as_introduced` | The title it was introduced under, where a source states it. Empty never means the title did not change. |
| `title_changed_at_stage` | The stage at which the title changed. |
| `bill_type` | Government, Member's, Committee, Private or Hybrid Bill. |
| `bill_type_at_the_time` | Executive Bill or Government Bill, as it was styled then. |
| `bill_type_grouped` | The type used when types are grouped for counting, which puts the one Hybrid Bill with the government bills. |
| `procedure` | How the bill was handled under the Parliament's rules. Empty means not known, never standard. |
| `date_procedure_agreed` | The day the Parliament agreed to handle it that way. |
| `date_introduced` | The day it was introduced. |
| `first_stage` | The name of its first stage: Stage 1, or Preliminary Stage for a Private Bill. |
| `first_stage_ended` | The day that stage ended. |
| `second_stage` | Stage 2, or Consideration Stage. |
| `second_stage_ended` | The day that stage ended. |
| `third_stage` | Stage 3, or Final Stage. |
| `third_stage_ended` | The day that stage ended. |
| `reconsideration_reached` | The day the bill reached Reconsideration Stage, for the two bills that had one. |
| `reconsideration_ended` | The day that stage ended. |
| `outcome` | What the Parliament did with the bill. |
| `how_rejected_at_stage_1` | Which of the three routes rejected its general principles. Filled only for a bill rejected at Stage 1. |
| `enactment_status` | Whether it became an Act: Enacted, Not enacted, Pending, Blocked. |
| `date_royal_assent` | The day it became an Act. |
| `act_number` | The Act's number, such as 2016 asp 8. |
| `date_fell_or_withdrawn` | The day it stopped being a live bill without becoming an Act. Empty for an Act and for a live bill. |
| `date_stopped_before_assent` | The day it was stopped from being sent for Royal Assent. |
| `how_stopped_before_assent` | A section 33 reference to the Supreme Court, or a section 35 order. |
| `outcome_after_being_stopped` | What happened next: still stopped, withdrawn, reconsidered and passed, reconsidered and fell. |
| `carried_scrutiny_from_bill_number` | The earlier bill whose scrutiny this bill carried. One bill has it. |
| `note` | Anything irregular about this bill a reader should see. |
| `source` | Where this line's facts came from. |
| `where_in_the_source` | Which fact sheet, which page. |
| `date_source_read` | The day we read it. |

**Three headings, settled by the owner on 17 September.** All three as
proposed. What settled each is recorded here so none is reopened at the first
chart.

- **`third_stage`, not `final_stage`.** The working database calls it the final
  stage. But a Private Bill's third stage is actually named Final Stage, so a
  column headed `final_stage` with the word "Final Stage" in some cells and
  "Stage 3" in others reads as though the two were the same thing. `third_stage`
  says where it comes in the sequence, which is the only claim M2 makes.
  `stage_3` was considered and refused: it would be wrong for the 24 Private
  Bills, whose third stage is not Stage 3.
- **`enactment_status`.** The one heading that is our vocabulary rather than the
  Parliament's, kept because it fits all four values. `became_an_act` was
  considered and refused: it reads as a yes-or-no question that "Blocked" and
  "Pending" do not answer. `act_status` was refused for saying "the Act's
  status" about bills that never became Acts. The dictionary file defines it.
- **`bill_type_grouped` is carried.** Both columns are published, so a
  researcher can count either way and say which they used, and the bill's own
  type still reads Hybrid Bill. Leaving the grouping to the reader was
  considered and refused: someone counting government bills gets one fewer
  unless they have read M4 first.

**None of the three changes a single cell.** Every value stays exactly as the
Parliament names it; these are the words at the top of three columns.

---

## 3. `stages` — one line per stage a bill reached

| Heading | What it holds |
|---|---|
| `bill_number` | Which bill. |
| `title` | Its title, so this file reads on its own. |
| `session` | Its session. |
| `stage` | The stage's real name for this kind of bill. |
| `stage_position` | Where it comes in that bill type's sequence: 1, 2, 3, or 4 for Reconsideration. |
| `date_reached` | The day the bill reached the stage, where a source states it. Two rows have it. |
| `date_ended` | The day the stage ended. |
| `got_through` | Yes if the bill got through this stage. |
| `bill_ended_here` | Yes on the stage where the bill ended. |
| `stage_never_happened` | Yes where the bill never had this stage because its procedure skipped it. |
| `note` | Whatever a source records beyond what the row says. |
| `why_there_is_no_date` | The one sentence, the same words every time, on a stage where the bill stopped without the Parliament deciding anything. |
| `source` | Where this stage date came from. |
| `where_in_the_source` | The exact place within it. |
| `date_source_read` | The day we read it. |

**The stage record numbers do not cross**, as settled: they are reissued every
time a session is put back. A stage is identified here by its bill and its name.

---

## 4. `days_between_stages` — one line per gap

| Heading | What it holds |
|---|---|
| `bill_number` | Which bill. |
| `title` | Its title. |
| `session` | Its session. |
| `bill_type` | Its type. |
| `procedure` | How it was handled, where known. |
| `outcome` | What the Parliament did with it. |
| `measured_from` | The dated point the gap starts at: introduction, or a stage. |
| `date_measured_from` | That day. |
| `measured_to` | The dated point it ends at: a stage, or Royal Assent. |
| `date_measured_to` | That day. |
| `days` | Calendar days between the two. |
| `got_through_the_later_stage` | Yes if the bill got through the stage at the end of this gap. |
| `bill_passed` | Yes if the bill went on to pass. |

`measured_from` and `measured_to` rather than `from_stage` and `to_stage`,
because introduction and Royal Assent are not stages, and M2 is careful about
that.

---

## 5. `sessions`, and the four files that explain the data

**`sessions`:** `session`, `date_first_meeting`, `date_session_ended`,
`date_session_expected_to_end`, `is_the_current_session`, `note`.

**`methodology_notes`:** `note` (M1, M2 and so on), `title`, `text`,
`applies_to`. `applies_to` is the list of headings the note bears on, and in the
published copy it names published headings. That is how the site shows the right
note against the right column.

**It is translated when the copy is taken, not changed in the working
database.** The working database's own list has to go on naming its own columns,
because that is what the data dictionary uses to show each note against the
column it bears on, and the owner is the check on every claim this project
makes. So one mapping of working column to published heading is written, and it
does two jobs: it builds the copy, and it translates this list. Two lists, one
mapping, nothing to keep in step by hand.

**`sources`:** `applies_to_file`, `bill_number`, `stage`, `session`,
`applies_to_heading`, `source`, `where_in_the_source`,
`value_as_the_source_gave_it`, `date_source_read`, `note`. One line per fact
that names its own source — 192 today: 177 about a bill, 14 about a session and
one about a stage.

**`what_the_words_mean`:** `heading`, `value`, `what_it_means`, `order`. One
line per heading-and-value pair. The stage names appear three times over,
because three headings hold them; that is deliberate, so a reader who has a
heading in front of them never has to work out which list it draws on.

**`what_changed`:** `date_copy_taken`, `file`, `bill_number`, `stage`,
`heading`, `old_value`, `new_value`. Cell by cell, as settled. Additions are a
count and go in `about`, so a large slice does not swell it.

**`about`:** `date_copy_taken`, `file`, `rows`, `rows_added_since_last_copy`.

---

## 6. The notes, rewritten

Each is given in full: as it reads in the database today, then as proposed.
Where the whole note is unchanged but for one or two sentences, the changed
sentences are marked **bold** in the proposed version so you can find them
without reading it twice.

M6 is not changed. It is about how bills are counted, not about any heading, and
naming one in it would add words without adding anything.

The full texts are in the companion file, `docs/PHASE-2-PUBLISHED-NOTES.md`,
because they run to about six thousand words and do not belong in the middle of
a list of headings.

---

## 7. The definitions of the allowed values

`STATE.md` says four lists still name database columns. Having read all eleven,
it is **nine entries across seven lists**:

| List | Entry | What it says |
|---|---|---|
| Bill type | Government Bill | "recorded separately in `bill.bill_type_stated`" |
| Bill type | Hybrid Bill | "see `analysis_group`" |
| Bill type at the time | Executive Bill | "Recorded as `bill_type` = government" |
| Outcome | Fell (other) | "record it in `note`" |
| Party | Other | "name it in `bill.note`" |
| Source | SPICe legislation factsheet | "put the session and retrieval date in `source_ref`" |
| Stage 1 rejection route | amended to reject | "are in `bill.note`" |
| Stage 1 rejection route | Rule 9.14.18 | "our view ... is in `bill.note`" |
| Stage 1 rejection route | some other route | "the staging line's review note and `bill.note`" |
| Stopped before assent | section 33 reference | "kept word for word as the provenance of `enactment_status`" |
| Stopped after being blocked | withdrawn, reconsidered and passed | "Its `enactment_status` is ..." |

**Why it happened, and it is not carelessness.** These definitions do two jobs
at once. They tell whoever is entering data where to put something, and they
tell a reader what a word means. The first job needs the column name; the second
cannot use it.

**Proposed: split the two jobs rather than strip the definitions.** The
definition becomes the reader's, in readers' words, and is what
`what_the_words_mean` publishes. The instruction to whoever is entering data
moves to the column's own description, which is where the data dictionary
already looks and where no reader ever goes. Nothing is lost, one copy of each
thing, and the dictionary keeps refusing to run if a description goes missing.

**This is new work and it is a change to what a note says**, so it gets the full
checklist before anything is built. I have not written it. Say whether you want
it, and I will bring the checklist.

---

## 8. What happens after you agree these

Not part of this proposal; here so the shape is visible.

1. **The migration that rewrites the notes and the definitions** in the working
   database, with its `COMMENT`s, rehearsed inside a rollback first, read back
   word for word afterwards.
2. **The written procedure for taking the copy**, with its undo, in the shape of
   `PROMOTION-RUNBOOK.md`: what to run, what to look at, and what tells you it
   went wrong.
3. **The rehearsal**, which builds the copy beside nothing and compares it cell
   by cell against the working database — every bill, every stage, every gap. It
   is the same discipline as proving a move before adding, and it is the point of
   the exercise, not a formality.
4. **The check that the site can only read it**, proved the way its inability to
   open the working database was proved.
5. **A closure test**, written by this session and run by another.

---

## 9. Sizing

The headings and the notes are this session. The migration, the procedure, the
rehearsal and the cell-by-cell check are a session of their own, and the closure
test is written with them and run by the session after. Three sessions to the
end of block 1, if the definitions in §7 come with it; two if they do not.
