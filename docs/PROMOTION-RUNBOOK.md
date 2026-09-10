# Promotion runbook

How to move one session's bills from your staging sheet onto the clean sheet.

Promotion is the only step in this project that changes the clean sheet, so it
has a written procedure. Follow it in order. It takes a few minutes.

Read `docs/HOW-THE-DATABASE-WORKS.md` first if the words "staging sheet" and
"clean sheet" are not familiar.

---

## What promotion does

For every staging line you have marked **accepted**:

1. A bill appears on the clean sheet, taking its number from the staging line
   — line 17 becomes bill 17, always.
2. One row is filed for each stage that bill actually reached, under the right
   stage name for its kind of bill.
3. A provenance note is filed for any single fact that did not come from the
   line's own source.
4. Your staging line is stamped with the bill number and the date.

Your staging sheet is otherwise untouched, and stays untouched forever. That
is what makes all of this safe to undo.

---

## Before you start

- The session must have no outstanding problems. Open `v_candidate_problems`:
  it must show nothing for this session. The script refuses to run otherwise.
- Every line in the session must be either accepted or rejected. No line still
  sitting at `new`. The script refuses to run otherwise.
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
from, field by field; every bill that passed has a final stage row and every
bill rejected at its first stage has a first stage row; every stage date
matches its line; no bill ends at two different stages; no provenance note
filed twice.

---

## Step 2 — Look at what it produced

The run prints five tables. Look at each.

- **Totals by type** and **totals by outcome.** Compare them against the
  factsheet's own summary table. For Session 1 that is 51 government, 16
  Member's, 3 private, 3 committee; and 62 passed, 3 withdrawn, 8 fallen —
  where "fallen" is the 3 that fell at dissolution plus the 5 rejected at
  Stage 1.
- **Stage rows written.** One per bill that reached a stage. Session 1: 62
  final-stage rows and 5 first-stage rows, 67 in all.
- **Provenance notes written.** Session 1: six.
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
`v_stage_duration_summary` in Postico. This is the first sight of the session
as finished data rather than as staged lines, and it is where an error that
survived every automated check tends to become obvious — a duration in the
thousands of days, a bill type with no bills.

---

## If it is wrong: taking it back off

    ~/.claude/legdata-vps --scp tools/rollback_promotion.sql /tmp/rollback_promotion.sql
    ~/.claude/legdata-vps 'sudo -u postgres psql -d legdata -v session=1 -v save=false -f /tmp/rollback_promotion.sql'

Same idea: `save=false` shows you what it would remove and changes nothing,
`save=true` removes it. The bills go, their stage rows go with them, and your
staging lines lose their stamps. You can then fix whatever was wrong and
promote again.

**One thing does not come off: the provenance notes.** They can never be
deleted — that is deliberate, and it is what stops a revised published record
being quietly overwritten. They are harmless: a bill keeps its number across a
re-promotion, so the notes still point at the right bill, and promotion will
not file a second copy of a note it has already made.

So read the provenance table in step 2 properly, before saving. Not because a
mistake is unfixable — one made by our own tooling can be corrected in a
migration, as `db/027` did — but because it is the one table where fixing
something takes a migration rather than a keystroke.

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

Correcting it meant suspending the append-only rule for one transaction. That
is available and it is not a big deal, but it is for our own mistakes only: a
source's words stay in the record even when they turn out to be wrong, because
that is what the table is for. See `DECISIONS.md`, "Our own rules are not
facts of the world".
