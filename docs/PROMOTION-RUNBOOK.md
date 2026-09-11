# Promotion runbook

How to move one session's bills from your staging sheet onto the clean sheet.

Promotion is the only step in this project that changes the clean sheet, so it
has a written procedure. Follow it in order. It takes a few minutes.

Read `docs/HOW-THE-DATABASE-WORKS.md` first if the words "staging sheet" and
"clean sheet" are not familiar.

---

## Before promotion: putting a session on the staging sheet

This writes only to the staging sheet, and the lines arrive as `new`, waiting
for review. Same pattern as promotion: rehearse, look, then save.

**1. Extract.** Use the pinned environment (`tools/requirements.txt`; one is
built at `/opt/legdata/venv` on the VPS). Give the dissolution date from
`FACTSHEET-SURVEY.md` §7, or no fallen bill can be read as falling at
dissolution:

    python tools/extract_factsheet.py sources/factsheets/spice-legislation-session-2_retrieved-2026-09-10.pdf \
        --session 2 --dissolution 2007-04-02 --csv s2.csv

The row count it prints must equal the factsheet's own total. If it does not,
stop: that is the table-fragmentation fault, not something to review away.

**2. Rehearse the load.**

    ~/.claude/legdata-vps --scp tools/load_session.sql /tmp/load_session.sql
    ~/.claude/legdata-vps --scp s2.csv /tmp/s2.csv
    ~/.claude/legdata-vps 'sudo -u postgres psql -d legdata -v session=2 -v save=false -f /tmp/load_session.sql < /tmp/s2.csv'

**3. Look at the five tables it prints.**

- **Lines by factsheet table and type letter.** Every cell must equal the
  factsheet's summary table, and `unrecognised` must be 0.
- **Passing dates put on the stage-dates sheet.** One per Act: Final Stage
  for a Private Bill, Stage 3 for every other kind. The total must equal the
  Acts row of the summary.
- **Taken out of a title.** Every SP Bill number should sit beside a bill
  that is not an Act, and none should still be in the title.
- **Problems.** This is the review list. For Session 2 it was six fallen
  bills needing an outcome from the Official Report, and nothing else.
- **Staging line numbers.** They should follow straight on from the last
  session loaded.

**4. Save.** The same command with `save=true`. Refused if the session is
already loaded.

---

## What promotion does

For every staging line you have marked **accepted**:

1. A bill appears on the clean sheet, taking its number from the staging line
   — line 17 becomes bill 17, always.
2. A stage record is filed for each of that bill's accepted rows on the
   stage-dates sheet, one per stage, under the right stage name for its kind
   of bill. Where two sources give the same stage, the Official Report's is
   filed first, then the factsheet's, then the PhD's; the other stays on the
   stage-dates sheet as the check.
3. A provenance note is filed for any single fact that did not come from the
   line's own source. Stage dates need none: each stage record carries its
   own source.
4. Your staging line, and each stage-dates row that was filed, is stamped
   with what it became and the date.

Your staging sheets are otherwise untouched, and stay untouched forever. That
is what makes all of this safe to undo.

---

## Before you start

- The session must have no outstanding problems. Open `v_candidate_problems`:
  it must show nothing for this session. The script refuses to run otherwise.
- Every line in the session must be either accepted or rejected. No line still
  sitting at `new`. The script refuses to run otherwise.
- The same goes for the session's rows on the stage-dates sheet, your own PhD
  dates included.
- Missing dates do not stop promotion. `v_stage_date_gaps` lists them; look at
  it so you know what the session is being promoted without.
- Have the factsheet's own summary table to hand. You will compare against it.

You do **not** need a special backup and you do **not** need a practice
database. The nightly backup exists, the restore has been tested, and step 1
below cannot change anything.

---

## Step 1 — Run it without saving

    ~/.claude/legdata-vps --scp tools/promote_session.sql /tmp/promote_session.sql
    ~/.claude/legdata-vps 'sudo -u postgres psql -d legdata -v session=1 -v save=false -f /tmp/promote_session.sql'

`save=false` means the database does the whole job, shows you the result, and
then throws it away. Nothing is kept. You can do this as many times as you
like.

**What you should see at the end:** `All checks passed.` If any check fails
the run stops and nothing is written, whichever way `save` is set.

The checks are: every accepted line became a bill; the number of bills equals
the number of accepted lines; every bill says the same as the line it came
from, field by field; every bill's stage records are exactly the stage-dates
rows filed for it, field by field, and each of those rows is stamped; every
bill that passed has a final stage record; no bill ends at two different
stages; no provenance note filed twice.

---

## Step 2 — Look at what it produced

The run prints these tables. Look at each.

- **Totals by type** and **totals by outcome.** Compare them against the
  factsheet's own summary table. For Session 1 that is 51 government, 16
  Member's, 3 private, 3 committee; and 62 passed, 3 withdrawn, 8 fallen —
  where "fallen" is the 3 that fell at dissolution plus the 5 rejected at
  Stage 1.
- **Stage rows written**, by stage and source. Before any PhD date was added,
  Session 1 had 62 final-stage rows from the factsheet and 5 first-stage rows
  from the Official Report, 67 in all.
- **Accepted stage dates not carried.** Where two sources gave the same stage,
  the one left on the stage-dates sheet, and which source was filed instead.
  The error checker has already made sure the two agree.
- **Bills rejected at Stage 1.** Each must show a route. Any note shown
  beside one is what a reader will see.
- **Provenance notes written.** Session 1: eleven — the corrected title of
  bill 17, five outcomes and five routes to rejection. Read them properly:
  approving the save is what clears them.
- **Row counts.** The totals across the whole clean sheet, not just this
  session.

Two sessions cannot be reconciled against their printed summary as it stands —
Session 3 counts its Hybrid Bill under Executive, and Session 7's grand total
cell reads 0. Both are written up in `STATE.md` under "Reconciliation figures,
per session". Check those against the corrected figures there, not the page.

---

## Step 3 — Run it for real

    ~/.claude/legdata-vps 'sudo -u postgres psql -d legdata -v session=1 -v save=true -f /tmp/promote_session.sql'

Identical, except `save=true`. It runs the same checks again before saving.

---

## Step 4 — Look at the pivot tables

Open `v_outcome_by_type`, `v_bill_stage_dates`, `v_bill_total_duration` and
`v_stage_duration_summary` in Postico. **Postico cannot currently open these
four:** they belong to the administrator and Postico's user has no permission
(`STATE.md`, housekeeping). Until that is fixed, have them printed instead. This is the first sight of the session
as finished data rather than as staged lines, and it is where an error that
survived every automated check tends to become obvious — a duration in the
thousands of days, a bill type with no bills.

---

## If it is wrong: taking it back off

    ~/.claude/legdata-vps --scp tools/rollback_promotion.sql /tmp/rollback_promotion.sql
    ~/.claude/legdata-vps 'sudo -u postgres psql -d legdata -v session=1 -v save=false -f /tmp/rollback_promotion.sql'

Same idea: `save=false` shows you what it would remove and changes nothing,
`save=true` removes it. The bills go, with their stage rows and their
provenance notes, and your staging lines lose their stamps. Fix whatever was
wrong on the staging sheet and promote again: all three are written afresh.
(Until 11 September the provenance notes could not be removed; see
`DECISIONS.md`, "Provenance notes are rebuilt with their bill".)

---

## What happened the first time this was run

Session 1, 10 September 2026. Run without saving, checked, saved, then
deliberately taken back off and promoted again, to prove the recovery path
works rather than assume it.

- 73 bills, 67 stage rows, 6 provenance notes.
- After taking it back off: 0 bills, 0 stage rows, 6 provenance notes, staging
  lines unstamped.
- After promoting again: 73 bills, 67 stage rows, still 6 provenance notes —
  not 12 — and all six still pointing at the right bills.
- Running promotion a third time changed nothing.

One thing was got wrong. The provenance note for bill 17's corrected title
had the reviewer's whole comment as its reference, including a sentence that
was an instruction to whoever wrote this script. The script was changed to
file a short reference instead, and the row itself was corrected by `db/027`.

Correcting it meant suspending the append-only rule for one transaction. See
`DECISIONS.md`, "Our own rules are not facts of the world". That rule has since
been removed.

## What happened on 11 September

Session 1 was taken off and put back, to add how each of its five Stage 1
rejections came about. Before it, a safety copy of the whole database was
taken (`/var/tmp/legdata-before-030_2026-09-11.dump` on the VPS), and the full
sequence was dress-rehearsed twice in a transaction that was thrown away.

- Taking it off removed 73 bills, 67 stage rows and, for the first time, its 6
  provenance notes.
- `db/031` and `db/032` added the route and recorded it for all eleven Stage 1
  rejections in Sessions 1 and 2.
- Putting it back gave the same 73 bills and 67 stage rows, and 11 notes: bill
  17's title note exactly as before, the five outcome notes worded as before
  and dated 11 September (the latest reading), and five new route notes.

Two things were caught in rehearsal, not afterwards. The error checker could
not read the new dropdown list, because a migration creates things as the
administrator, so `db/031` now sets the list's owner. And rebuilding bill 17's
note would have put back the instruction text `db/027` removed, because the
script appended the whole review note. It no longer does.

## Checking a change cell by cell

For any change to data already held, take a copy before and compare after.
Send both scripts to `/tmp` with `--scp` as above.

    ~/.claude/legdata-vps 'sudo -u postgres psql -d legdata -v copy=copy_before_033 -f /tmp/take_copy.sql'
    (the change)
    ~/.claude/legdata-vps 'sudo -u postgres psql -d legdata -v copy=copy_before_033 -f /tmp/compare_with_copy.sql'

The copy sits inside the database where Postico does not show it. The
comparison matches stage records and provenance notes by what they are about,
not by their own numbers, and ends with a verdict. Record numbers and the
times things were written always differ when a session is taken off and put
back, and are counted as expected. Columns added or removed are listed for you
to judge against the change. Drop the copy once the change is confirmed.

## What happened later on 11 September: the stage-dates sheet

`db/033` moved every stage date onto the new stage-dates sheet, and Session 1
was taken off and put back from it. The whole sequence was rehearsed in a
transaction that was thrown away, twice. Before the real run a safety copy of
the database was taken (`/var/tmp/legdata-before-033_2026-09-11.dump`), and a
copy of both sessions inside it (`copy_before_033`).

- 139 dates moved: 62 and 66 passing dates, 5 and 6 Stage 1 rejections. Every
  one arrived unchanged, with its source, when it was read, and its line's
  review status.
- Compared with the copy, nothing else changed but the two old date columns
  coming off the factsheet sheet.
- Taking Session 1 off removed 73 bills, 67 stage records and 11 notes, and
  putting it back gave the same. Compared cell by cell with the copy: no
  unexpected differences. Only record numbers and times written differed.
- The error checker was empty throughout. The gaps list held 271.

Tested in rehearsal rather than assumed:
- eight planted mistakes on the stage-dates sheet were each caught;
- the clean sheet refused a completed stage with no date and no note;
- a PhD date agreeing with the Official Report left the Official Report's on
  the clean sheet, and the PhD row unstamped;
- promotion refused a session holding an unreviewed stage date;
- Session 2, loaded again from a fresh extraction, gave its 66 passing dates
  identically.
