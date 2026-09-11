# How the database works

Written for the owner, who works in spreadsheets. This is the orientation
document: what the pieces are and how they relate to each other. For what any
individual column holds, use `docs/DATA-DICTIONARY.md`.

Nothing here is about SQL. If you find yourself needing to know SQL to follow
it, that is a fault in this document.

## 1. Think of it as one workbook with 24 tabs

Postico lists 24 things side by side and they look equally important. They are
not. There are four kinds, and only one kind is data you look after.

| Kind | How many | Spreadsheet equivalent |
|---|---|---|
| Names beginning `ref_` | 10 | Dropdown lists |
| Names beginning `v_` | 8 | Pivot tables |
| The sheet you fill in | 1 | Your working sheet |
| The finished answer | 3 | The clean sheet you publish from |
| Context | 2 | Two small lookup sheets |

**The ten `ref_` tabs are dropdown lists.** They are not data about bills.
Each one is the list of values a particular column is allowed to hold, exactly
like restricting a cell to a list in a spreadsheet. `ref_outcome` is seven
words — passed, withdrawn, fell, and so on. `ref_stage` is nine stage names.
That is the entire content of the tab. You will almost never open them.

**The eight `v_` tabs are pivot tables.** They hold no data of their own. Each
is a saved arrangement that recalculates from the real sheets every time you
open it — outcome by bill type, stage durations, and so on. You cannot type
into them. If one were deleted, nothing would be lost but the arrangement.

**One tab is your working sheet: `bill_candidate`.** It holds every line read
off a factsheet, for every session loaded so far. `docs/STATE.md` says which.

**Three tabs are the finished answer:** `bill`, `stage_event`, `field_source`.
They fill up when promotion runs, one session at a time.

**Two are context:** `session` (seven rows, one per parliament) and
`methodology_note` (seven rows, the decisions a reader has to be told about).

## 2. Your sheet: `bill_candidate`

One row per line of a factsheet. Forty columns, which sounds like a lot until
you see that they come in four blocks.

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

The important thing about this sheet is that it is **deliberately permissive**.
None of the dropdown lists are enforced here. A column can be left empty. A
bad reading of a line lands as a row you can look at and correct, rather than
as an error that stops the whole import. All the strictness lives on the other
side of the gate.

## 3. Everything else, in relation to that sheet

### The dropdown lists (`ref_*`)

Block 2 columns are *meant* to hold values from these lists, but on your sheet
nothing forces it — that is the permissiveness above. On the clean sheet it is
forced, and a value not on the list is refused outright.

There are ten because there are ten columns that have a fixed set of answers:
who introduced the bill, what happened to it, whether it became an Act, which
stage, which party, which procedure, which kind of source, how the type was
styled at the time, which stages belong to which kind of bill, and how a bill
came to be rejected at Stage 1.

### The error checker (`v_candidate_problems`)

This is the one `v_` tab you will use regularly. It is the equivalent of a
column of `IF` formulas flagging rows that don't hold together — a rejection
date before an introduction date, an outcome that contradicts the section of
the factsheet the line sat in, an asp number whose year doesn't match the Royal
Assent date.

Open it and it is either empty or it lists the problems. Empty is the target.
Nothing can be promoted while a session still has problems listed.

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

### The stage dates (`stage_event`)

On your sheet, a bill's stage dates sit in columns: `end_stage_1_date`,
`end_stage_3_date`. On the clean side they are unfolded into one row per
stage the bill actually reached.

The reason is that bills don't all have the same stages. Most have Stage 1, 2
and 3; Private and Hybrid Bills have Preliminary, Consideration and Final
Stage. As columns you would need a column per stage name and most would be
empty. As rows, each bill has only the stages it really had, under their real
names, and the database refuses to file a Stage 2 against a Private Bill.

A bill that fell at Stage 1 has one row here, not three. A bill that passed
has a row for each stage it completed.

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

Two things about this tab. It records the value **as the source worded it**,
not as we tidied it. And it is **rebuilt with the bill**, like the stage rows:
promotion writes one note per fact, taking a session off removes them, and
putting it back writes them again. So a note is the latest reading of its
source. Approving a promotion clears the notes it writes; any other change to
a note needs your clearance.

### The two context tabs

`session` is seven rows, one per parliament, and is where each session's dates
will go. All seven date cells are still empty. Sessions 1 to 5 state their own
dates on page 1 of their factsheets; Sessions 6 and 7 state them nowhere we
have found.

`methodology_note` is seven rows of prose, each one a decision a reader of the
published figures has to be told about — why Executive and Government Bills are
counted as one thing, why a passed bill isn't necessarily an Act. These exist
to be shown on the front end beside the charts, not to be used in calculations.

## 4. What promotion does

Promotion is the one moving part that touches the clean sheet. For each row on
your sheet marked `accepted`:

- a row appears on the clean sheet, taking its bill number from the number of
  your staging line — line 17 becomes bill 17, always, however many times
  promotion is run;
- your row gets stamped with that number and the date, so you can get from one
  to the other and back in either direction;
- one stage row is filed for each stage that bill actually reached;
- a provenance note is filed for each fact that didn't come from the row's
  stated source — eleven of them, for Session 1.

Your sheet is never emptied and never altered beyond those two stamps. That is
what makes promotion safe to redo: the clean sheet can be wiped and rebuilt
from your sheet at any time, so a mistake in promotion costs a re-run, not
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
