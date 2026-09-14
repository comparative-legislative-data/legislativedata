# How the database works

Written for the owner, who works in spreadsheets. This is the orientation
document: what the pieces are and how they relate to each other. For what any
individual column holds, use `docs/DATA-DICTIONARY.md`.

Nothing here is about SQL. If you find yourself needing to know SQL to follow
it, that is a fault in this document.

## 1. Think of it as one workbook with 26 tabs

Postico lists 26 things side by side and they look equally important. They are
not. There are four kinds, and only one kind is data you look after.

| Kind | How many | Spreadsheet equivalent |
|---|---|---|
| Names beginning `ref_` | 10 | Dropdown lists |
| Names beginning `v_` | 9 | Pivot tables |
| The sheets you fill in | 2 | Your working sheets |
| The finished answer | 3 | The clean sheet you publish from |
| Context | 2 | Two small lookup sheets |

**The ten `ref_` tabs are dropdown lists.** They are not data about bills.
Each one is the list of values a particular column is allowed to hold, exactly
like restricting a cell to a list in a spreadsheet. `ref_outcome` is eight
words — passed, withdrawn, fell, and so on. `ref_stage` is nine stage names.
That is the entire content of the tab. You will almost never open them.

**The nine `v_` tabs are pivot tables.** They hold no data of their own. Each
is a saved arrangement that recalculates from the real sheets every time you
open it — outcome by bill type, stage durations, the dates still to find, and
so on. You cannot type into them. If one were deleted, nothing would be lost
but the arrangement.

**Two tabs are your working sheets.** `bill_candidate` holds every line read
off a factsheet, for every session loaded so far; `docs/STATE.md` says which.
`stage_candidate` holds every stage date waiting to go onto the clean sheet,
wherever it came from.

**Three tabs are the finished answer:** `bill`, `stage_event`, `field_source`.
They fill up when promotion runs, one session at a time.

**Two are context:** `session` (seven rows, one per parliament) and
`methodology_note` (eight rows, the decisions a reader has to be told about).

## 2. Your sheets

### The factsheet sheet: `bill_candidate`

One row per line of a factsheet. Thirty-eight columns, which sounds like a lot
until you see that they come in four blocks.

Lines arrive a whole session at a time, by a load that is rehearsed before it
is kept (`docs/PROMOTION-RUNBOOK.md`), and they arrive marked `new`.

**Block 1 — what the factsheet actually printed.** The eight columns beginning
`raw_`. Word for word, untouched, including the odd spacing and the asp number
run into the title. Nothing is ever cleaned up here. This block is the
photograph of the page.

**Block 2 — what we made of it.** `short_title`, `bill_type`,
`date_introduced`, `outcome`, and the rest. Same facts, tidied into usable
form: the asp number and the SP Bill number lifted out of the title into
their own columns, "6 October 1999" turned into a real date. Every column in this block has a counterpart in
Block 1 you can check it against.

**Block 3 — where it came from.** `source`, `source_ref`, `observed_at`,
`src_file`, `src_page`, `parser_note`. Which document, which page, and the date
we read it. `observed_at` matters more than it looks: the Parliament revises
published records, so "this is what page 7 said on 10 September 2026" is a
different claim from "this is true".

**Block 4 — the gate and the stamps.** `review_status` is the gate: `new`
until you look at it, then `accepted` or `rejected`. `review_note` is what you
decided and why. `promoted_bill_id` and `promoted_at` get stamped later, when
the row has been copied across into the clean sheet.

Three columns in this block are filled at review from the Official Report, not
read off the factsheet. For a bill rejected at Stage 1, `stage_1_rejection_route`
records how it was rejected. `official_report_read_on` is the date the Official
Report was read. `bill_note` is a note to carry onto the bill for a reader,
which is different from `review_note`: that one stays behind on your sheet.

A bill's stage dates are not on this sheet. They are on the next one.

### The stage-dates sheet: `stage_candidate`

One row per stage of a bill, per source. Take the Abolition of Feudal Tenure
(Scotland) Bill, line 1. Its row here says: line 1, Stage 3, completed, 3 May
2000, from the Session 1 factsheet, read on 10 September 2026.

Every stage date waits here before it goes onto the clean sheet:
- a passing date arrives when its session's factsheet is loaded;
- a Stage 1 rejection date read from the Official Report is added at review;
- your PhD dates are typed straight in, in Postico.

Each row shows its bill's title beside the line number. You never type it: it
fills itself in from the line number when the row is saved. If the title is not
the bill you meant, the line number is wrong. If a title is corrected on the
factsheet sheet, the rows here follow. It stays on this sheet and is not copied
to the clean sheet.

The stage's position, `stage_order`, fills itself in the same way, from the
stage name: 1 for Stage 1 or the Preliminary Stage, 2 for Stage 2 or the
Consideration Stage, and so on. So the name and the number can never disagree.

Each row has its own `review_status`, the same gate as the factsheet sheet, so
a date is accepted or rejected on its own. Your own dates arrive as `new` like
everything else, and you read them a second time before accepting them.

A bill can have two rows for the same stage from different sources. The error
checker insists they agree. The clean sheet then takes the Official Report's,
before the factsheet's, before your PhD's, and the other stays here as the
evidence it was checked.

A stage completed on a date nobody can find is a row that says completed, with
the date empty and a detail note saying why. That is a gap, not an error.

This sheet is permissive in the same way as the other. Neither sheet enforces
the dropdown lists. A cell can be left empty. A bad reading lands as a row you
can look at and correct, rather than as an error that stops the whole import.
All the strictness lives on the other side of the gate.

## 3. Everything else, in relation to those sheets

### The dropdown lists (`ref_*`)

Block 2 columns are *meant* to hold values from these lists, but on your sheets
nothing forces it — that is the permissiveness above. On the clean sheet it is
forced, and a value not on the list is refused outright.

There are ten because there are ten columns that have a fixed set of answers:
who introduced the bill, what happened to it, whether it became an Act, which
stage, which party, which procedure, which kind of source, how the type was
styled at the time, which stages belong to which kind of bill, and how a bill
came to be rejected at Stage 1.

### The error checker (`v_candidate_problems`)

This is the `v_` tab you will use most. It is the equivalent of a column of
`IF` formulas flagging rows that don't hold together, on both your sheets — an
outcome that contradicts the section of the factsheet the line sat in, an asp
number whose year doesn't match the Royal Assent date, a Stage 2 dated before
Stage 1, two sources giving different dates for the same stage. A problem on
the stage-dates sheet names the stage and the source it came from.

Open it and it is either empty or it lists the problems. Empty is the target.
Nothing can be promoted while a session still has problems listed.

### The gaps list (`v_stage_date_gaps`)

The stage dates still to find, one row per missing date: a passed bill without
its Stage 1 or Stage 2 date, a bill that ended early without the dates of the
stages before, a bill that didn't pass with nothing saying where it ended, and
a stage completed on a date not known, with its detail note.

Unlike the error checker, a gap does not stop a session being promoted. It is
the to-do list your PhD dates work through.

### The clean sheet (`bill`)

One row per bill, and the only way a row gets there is by being copied over
from your sheet after you marked it accepted. It cannot be typed into
directly.

It is a narrower sheet than yours. It has no `raw_` block — the photograph
stays behind on your sheet, permanently, which is what makes the whole thing
auditable. And it has no dates for individual stages, which is the next point.

For a bill rejected at Stage 1 it also says how. Usually that was on the member
in charge's own motion. It can also have been on that motion amended to reject
the bill, or on a committee motion under Rule 9.14.18. The clean sheet refuses a
Stage 1 rejection without one, and refuses one on any other bill.

Some bills carry a note written for a reader: one cell of plain English beside
the bill, saying what the outcome on its own cannot. Two have one about how they
were rejected — the Transplantation Bill of Session 4 and Session 1's
Proportional Representation Bill, both ended by the member's own motion being
turned into its opposite and then agreed to — and each gives the two votes the
Parliament took and quotes the motion it ended up agreeing to. The note comes
over with the bill from your sheet and is rewritten every time the session is
put on, so it is always the latest reading of its source. The figures in it are
sentences and not data: nothing can count or filter them, and M7 says so.

Nearly every bill that did not pass has one stage marked as where it ended. One
does not, and it is worth knowing about because on screen it looks like an
oversight. The Creative Scotland Bill won its Stage 1 vote and fell the same
afternoon, because the Parliament did not agree the money its costs required. So
its Stage 1 is recorded as completed, and no stage at all is marked as where the
bill ended: there is no stage to put it on. The ending sits on the bill instead.
It is the only bill of the 302 loaded so far that ends that way, and M7 is the
note that tells a reader why.

### The stage dates (`stage_event`)

One row per stage a bill actually reached, copied from an accepted row on your
stage-dates sheet.

The reason for rows rather than columns is that bills don't all have the same
stages. Most have Stage 1, 2 and 3, and so do Hybrid Bills; Private Bills have
Preliminary, Consideration and Final Stage. As columns you would need a column
per stage name and most would be empty. As rows, each bill has only the stages
it really had, under their real names, and the database refuses to file a
Stage 2 against a Private Bill.

A bill that fell at Stage 1 has one row here, not three. Each row says where
its date came from, so stage dates need no provenance notes. And the clean
sheet refuses a stage marked completed with no date unless a note says why —
the detail note, which is the next point.

A stage row carries two notes, and they do different jobs. The **general note**
is one sentence, the same words every time, on a stage where the bill stopped
without the Parliament deciding anything — withdrawn by the member in charge, or
still sitting there when the session ran out. It accounts for the empty date
cell. Nobody types it: the database writes it from the row itself, so it cannot
come out worded two ways. The **detail note** is the one you keep, and holds
whatever a source says beyond that. Empty means no extra detail has been
collected for that bill — not that none exists, and not that any was looked
for.

To see them back as columns — one line per bill, stages across the top — open
the pivot table `v_bill_stage_dates`. That is what it is for.

### The provenance notes (`field_source`)

Your sheet records where the *line* came from. This records where a single
*cell* came from, for the cases where one cell came from somewhere else.

Five Session 1 bills are the example. Their line came from the factsheet, but
the factsheet does not say why they fell. That came from the Official Report.
So the bill's row says "factsheet", and a small note beside the outcome says:
this one fact, from the Official Report, seen on this date, worded there as
this. A second note does the same for how each was rejected, quoting the
Presiding Officer's announcement.

The tab holds 86 notes in all: 72 about bills, 13 about the sessions' own
dates, and 1 about a stage. Only the bill ones are written by promotion, which
is why the promotion figure below is 72 and not 86.

Two things about this tab. It records the value **as the source worded it**,
not as we tidied it. And it is **rebuilt with the bill**, like the stage rows:
promotion writes one note per fact, taking a session off removes them, and
putting it back writes them again. So a note is the latest reading of its
source. Approving a promotion clears the notes it writes; any other change to
a note needs your clearance.

### The two context tabs

`session` is seven rows, one per parliament, holding each session's first
meeting and its last day. Every cell is filled in except Session 7's last day,
which is empty because that session is still running, not because nobody knows
it. Each date records where it was read. The last days matter beyond tidiness:
a bill is recorded as having run out of time when the day it ended is the day
its session ended, so that coding can be checked rather than taken on trust.

`methodology_note` is eight rows of prose, each one a decision a reader of the
published figures has to be told about — why Executive and Government Bills are
counted as one thing, why a passed bill isn't necessarily an Act, when a stage
counts as completed. These exist to be shown on the front end beside the
charts, not to be used in calculations.

## 4. What promotion does

Promotion is the one moving part that touches the clean sheet. For each row on
your factsheet sheet marked `accepted`:

- a row appears on the clean sheet, taking its bill number from the number of
  your staging line — line 17 becomes bill 17, always, however many times
  promotion is run;
- one stage row is filed for each stage that bill has an accepted date for on
  your stage-dates sheet, taking the Official Report's where two sources give
  the same stage;
- a provenance note is filed for each fact that didn't come from the row's
  stated source — seventy-two so far, being twenty-two for Session 1, twenty
  for Session 2 and fifteen each for Sessions 3 and 4. Most are an outcome or a
  Stage 1 rejection route read from the Official Report; the rest are a date, a
  bill's type, an asp number or a title settled against legislation.gov.uk or
  the Parliament's own bill page;
- your rows on both sheets are stamped with what they became and the date, so
  you can get from one to the other and back in either direction.

Your sheets are never emptied and never altered beyond those stamps. That is
what makes promotion safe to redo: the clean sheet can be wiped and rebuilt
from your sheets at any time, so a mistake in promotion costs a re-run, not
data.

Two things make that genuinely true rather than nearly true. Bill numbers come
from your staging lines, so rebuilding gives every bill its old number back,
and anything that refers to a bill by number keeps pointing at the right one.
And a bill cannot be put on the clean sheet at all unless there is a staging
line behind it, so nothing can get in except through the gate.

## 5. Words you will meet in Postico

Not to be used in explanations to the owner, but you will see them on screen.

- **Table** — a tab.
- **View** — a pivot table. Recalculates; holds nothing.
- **Row / record** — a row.
- **Column / field** — a column.
- **Primary key** — the column holding each row's own identifier.
- **Foreign key** — a column that must match a value on another tab. This is
  what makes the dropdown lists binding.
- **Constraint** — a rule the database refuses to break. "This can't be
  empty", "this date can't be before that one".
- **Trigger** — a rule that runs automatically when a row is added or changed.
- **Index** — a lookup aid for speed. Some also enforce uniqueness.
- **Migration** — a numbered file in `db/` that changed the structure. They run
  in order and the sequence is the history of the database.
- **NULL** — an empty cell. Not zero, not blank text: nothing recorded. The
  data dictionary says what empty means for every column, because it means
  different things in different places.
