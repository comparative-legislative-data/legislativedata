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
built at `/opt/legdata/venv` on the VPS; the VPS copy cannot run the comparison
at step 6, which needs a spreadsheet library it does not have).

    python tools/extract_factsheet.py sources/factsheets/spice-legislation-session-2_retrieved-2026-09-10.pdf \
        --session 2 --csv s2.csv

**Nothing else is given to it, and nothing else may be.** The reader takes the
document and the session number. Until `db/051` it also took `--dissolution`,
and used it to decide that a fallen bill had run out of time — a date it could
not see, typed each run and recorded nowhere, which made the coding of seven
bills impossible to reproduce from the fact sheet. That comparison is now made
at step 4 below, against the day on the session tab. If a future change to this
reader asks for anything but the PDF and the session number, that is the same
mistake again.

The row count it prints must equal the factsheet's own total. If it does not,
stop: that is the table-fragmentation fault, not something to review away.

**2. Rehearse the load.**

    ~/.claude/legdata-vps --scp tools/load_session.sql /tmp/load_session.sql
    ~/.claude/legdata-vps --scp s2.csv /tmp/s2.csv
    ~/.claude/legdata-vps 'sudo -u postgres psql -d legdata -v session=2 -v save=false -f /tmp/load_session.sql < /tmp/s2.csv'

**3. Look at the six tables it prints.**

- **Lines by factsheet table and type letter.** Every cell must equal the
  factsheet's summary table, and `unrecognised` must be 0.
- **Passing dates put on the stage-dates sheet.** One per Act: Final Stage
  for a Private Bill, Stage 3 for every other kind. The total must equal the
  Acts row of the summary.
- **Bills the factsheet says fell.** One row per fallen bill, with the day it
  concluded, the day its session ended, and what the loader proposed. A bill
  that concluded on the session's last day reads `fell_dissolution`; every other
  fallen bill reads `(empty - your judgement)` and waits for the Official
  Report. The fallen total must equal the summary's. If the session's last day
  is blank, the session tab has no end date and nothing can be proposed — which
  is correct for Session 7 and a fault for any other.
- **Taken out of a title.** Every SP Bill number should sit beside a bill
  that is not an Act, and none should still be in the title.
- **Problems.** This is the review list. For Session 2 it was six fallen
  bills needing an outcome from the Official Report, and nothing else.
- **Staging line numbers.** They should follow straight on from the last
  session loaded.

**4. The one reason a bill fell that we work out ourselves.** The loader
proposes `fell_dissolution` where the bill concluded on the day its session
ended, taking that day from the session tab, and leaves every other fallen bill
empty. It is a proposal to review like any other, and it runs after the check
that the reader's rows arrived unchanged, so what the reader gave and what we
added are never confused. Since `db/049` the checker requires every bill coded
this way to have concluded on that day, and since `db/051` it also requires the
session's last day to exist; promotion then refuses to write such a bill without
its provenance note.

**5. Save.** The same command with `save=true`. Refused if the session is
already loaded.

**The session is now on the staging sheet, and it is not ready to be reviewed.**
Steps 6, 7 and 8 all write onto the lines the owner will read, and all three
must be done before the review, not after it. A review of a line that has not
been compared, or of a fallen bill nobody has looked up, is a review of half the
evidence.

---

## After the load, and before the review

Four checks. Each one adds to what the owner sees on the line, and each is the
session's work, not the owner's: the session brings the evidence, the owner
rules on what it means.

None of this was written down until 2026-09-14, and Sessions 6 and 7 were
loaded and announced as ready for review without any of it. It survived
Sessions 1 to 5 because the comparison broke or produced a disagreement every
single time, so nobody had to remember it. See `DECISIONS.md`.

**6. Compare the session against the owner's PhD dataset.**

    python tools/compare_sources.py --session 6 --sql cmp6.sql

It compares the two dates a bill's own line holds — introduction and Royal
Assent — and what kind of bill it was. It does not compare stage dates; those
are checked when the dates go on, because the stage-dates sheet holds one row
per source and the checker already requires two rows for the same stage to
agree.

It writes SQL to be read before it is run. **Do not run it until every line is
either paired or knowingly unpaired**, because an unpaired line is stamped as
compared anyway — a fault in the tool, known since `db/044` and first seen on
real data in Session 6.

Read its report and settle three things:

- **Lines with no partner because the two sources name the bill differently.**
  The dataset numbers Budget Acts within the session where the factsheet does
  not, and small wording differences are common. Confirm each by the dates the
  two sources share, then add it to `MANUAL_PAIRS` in
  `tools/phd_stage_dates.py`, factsheet line first, dataset row second, and run
  the comparison again.
- **Lines with no partner because the bill has been compared already.** A bill
  appearing in a second factsheet has its row in the dataset under the session
  it was introduced in. Check that it is there and that the introduction dates
  agree; then having no partner here is correct.
- **Where the two sources disagree.** Each goes to the source that owns the
  fact: legislation.gov.uk for Royal Assent and an Act's title and number, the
  Parliament's own page for the bill for everything else (`db/067`). The
  difference is written onto the line, and the checker will not let the session
  be promoted until a `Checked: <column> = <value> (source, address, date read)`
  citation sits beside it.

Every line must end up stamped. The checker refuses to let an unstamped line be
accepted.

**7. Read the Official Report for every bill the factsheet says fell.**

The factsheet's word "fallen" covers two different things, and the difference is
one of the answers this database exists to give: a bill the Parliament voted
down, and a bill that simply ran out of time. The factsheet does not distinguish
them. Nothing else will either, if this step is skipped.

Three of Session 5's seven fallen bills turned out to have lost a division on
their own Stage 1 motion. They were rejections, not timings-out.

- **Every fallen bill is looked up, including the ones the loader proposed as
  `fell_dissolution` at step 4.** That proposal rests only on the bill having
  concluded on the day the session ended, which is necessary and not sufficient.
  Session 5's other four were confirmed by finding that each bill's last
  recorded activity was a committee date months earlier and that nothing was
  decided on the final day.
- **A bill voted down at Stage 1** is recorded as `rejected_stage_1` with the
  route it took — the member in charge's motion disagreed to, that motion
  amended so that it did not agree to the general principles and agreed to as
  amended, or a committee motion under Rule 9.14.18, which only a Member's Bill
  can take. The route names the motion and its mover, and quotes the Presiding
  Officer: `Result as recorded: "For 39, Against 61, Abstentions 18. Motion
  disagreed to."` The Official Report is cited with the date it was read
  (`db/031`, `db/032`, `db/058`).
- **The bill's page is not good enough on its own** where the Parliament
  decided something. `db/067` sets the order: the Official Report where the
  Parliament decided, the bill page where it did not. Session 5's division
  figures were available on the bill pages and the Official Report was read
  anyway, because the rule says so.

**8. Read legislation.gov.uk for every bill the fact sheet leaves awaiting
Royal Assent.**

A fact sheet states where a bill had got to on the day it was compiled, and
nothing after that. Seven of Session 6's bills sat in its "Bills awaiting Royal
Assent" table having become Acts four months before the sheet was read, and
nothing in the database could see it: the comparison says nothing about a cell
one source leaves empty, and the error checker only asked for a citation where a
date contradicted the sheet. Both were changed at `db/090`. See methodology
note M12.

- **Every line in that table is looked up, whatever it says**, and the answer is
  written on the line whether or not it changed anything. The checker will not
  let the line be admitted without a
  `Checked: enactment_status = <value> (legislation_gov_uk, <address>, <date read>)`
  citation. A check that only speaks when it finds something is not a check.
- **Where the Act has since been made**, four values come off legislation.gov.uk
  — the date of Royal Assent, the Act's number, the Act's title and `enacted` in
  place of `pending` — and each carries its own citation, so promotion writes a
  provenance note per fact. `raw_title` keeps the fact sheet's own printing of
  the bill's title, and the line's own source stays the fact sheet, because that
  is still where the line came from.
- **A bill stopped before Royal Assent is a different thing** — referred to the
  Supreme Court, or subject to a section 35 order. That is M5's case, not M12's.
  It is looked up on the same schedule and the citation still written; the
  answer is normally that no Act has been made.
- **The lists of Acts by year** at `https://www.legislation.gov.uk/asp/<year>`
  answer a negative in one read, which is what a bill with no Act needs.

**9. Settle what is left on the error checker's list.**

Open `v_candidate_problems` and work down it. Everything on it is either
answered from a source, or it is a question for the owner — but the session
finds out which before asking. What has come up so far:

- a bill introduced before its session began, which is the same bill appearing a
  second time and must be pointed at the bill already on the clean sheet;
- an Act whose title or number the factsheet printed short, or printed wrongly,
  settled at legislation.gov.uk;
- a bill stopped before Royal Assent, which must say how it was stopped and what
  followed;
- a stage date out of order, which is a fault to be found and not reviewed away.

**The list is empty, or every item on it has an answer with its source, before
the owner is told the session is ready.**

---

## When the stage dates go on

**Before the owner's review, not after.** Settled 2026-09-15: the owner reads a
session once, with its stage dates already on the staging sheet. Sessions 1 to 4
were reviewed first and had their dates added afterwards; Session 5 was done this
way and it is now the rule.

The order for a session is therefore: load it (steps 1 to 5), the four checks
that come before the review (steps 6 to 9), the stage dates, the owner's review,
then promotion.

The loader refuses a whole session if any bill that did not pass has nothing on
the stage-dates sheet saying where it stopped, so that work comes first — see
Session 5's entry below, where six bills had to be settled before it would run.

## Typing stage dates into Postico

Your PhD dates go straight onto the stage-dates sheet, `stage_candidate`, one
row per stage. Nothing you type reaches the clean sheet until you have read it
a second time and it is accepted.

**Before you start.** After any change to the database, disconnect Postico and
connect again, so it shows the sheet as it now is.

**1. Find what is missing.** Open `v_stage_date_gaps`. Each row is one missing
date: the line number (`candidate_id`), the bill, and the stage. A bill that
appears in two factsheets is not asked twice: its earlier stages are on the
bill already, and only what this appearance adds is listed.

One row on that list has no stage against it: a bill recorded as an emergency
bill with nothing saying when the Parliament agreed to treat it as one. That is
not a stage date and there is no row to add for it on the stage-dates sheet —
the date goes in `date_procedure_agreed` on the bill's own line.

**2. Add a row.** Open `stage_candidate` and add a row with the + button at the
bottom, or ⇧⌘N. Fill in:

| Column | What to type | Example |
|---|---|---|
| `candidate_id` | the line number | `1` |
| `stage` | `stage_1` or `stage_2`; for a Private Bill, `preliminary` or `consideration` | `stage_1` |
| `stage_order` | nothing: it fills itself in from the stage name | |
| `date_completed` | the date, year first, as Postico shows dates | `2000-01-20` |
| `completed` | true | |
| `fell_here` | false | |
| `source` | `phd` | |
| `source_ref` | `PhD thesis dataset` | |
| `observed_at` | the date you read it, year first | `2026-09-11` |
| `note` | empty, unless something is irregular | |

Leave every other column as Postico shows it in the new row, whether that is
DEFAULT or NULL. The database fills in the row number, the title, the stage's
position, `review_status` (`new`) and the times. The one to be careful with is
the row number, `stage_candidate_id`: it must stay DEFAULT. A row sent with it
empty (NULL) is refused, with a message naming that column.

**3. Save** with ⌘S. The bill's title appears beside the line number, and the
position beside the stage name (⌘R reloads the view if they do not show). If
the title is not the bill you meant, the line number is wrong: correct it and
save again.

**Two other kinds of row:**
- **Where a bill that did not pass ended.** The stage it ended at, `completed`
  false, `fell_here` true. `date_completed` is the date of the decision that
  ended it if there was one, such as a Stage 1 vote, and otherwise empty. Any
  stage it completed before that gets its own row, as above.
- **A stage completed on a date you cannot find.** `completed` true,
  `date_completed` empty, and `note` saying why.

**4. Check.** Open `v_candidate_problems`. Empty means nothing is wrong. A
problem with one of your rows names the stage, the source and the row number.
Some mistakes are refused when you save instead: a line number that does not
exist, the same stage entered twice from your dataset, an impossible date.

Then tell the session. It runs `tools/check_stage_entry.sql`, which lists each
row waiting for review beside its bill's own dates and when it reached the
server, and reports back.

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
cell reads 0. Both are written up in `STANDING.md` under "Reconciliation figures,
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
(`STATE.md`, "Detail for the later work"). Until that is fixed, have them printed instead. Open
`v_stage_date_gaps` too, which Postico can open: it lists the stage dates the
session was promoted without. This is the first sight of the session
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

**A session that added to an earlier session's bill comes off in two steps, and
the script tells you so.** Where a line named a bill already on the clean sheet
in `continues_bill_id`, that bill belongs to the earlier session and there is no
copy of what its cells were before, deliberately. So it comes off too, and the
earlier session has to be promoted again to put it back — `rollback_promotion.sql`
prints which session and how many lines, and stops there, because promotion is a
separate rehearsal with its own things to look at. Until you have run it, the
counts will be **lower than they started**, and that is not a fault. Rehearsed on
2026-09-14 against a Session 6 fixture: taking Session 6 off gave 388 bills, 1068
stage records and 108 provenance notes; promoting Session 5 again returned 389,
1071 and 112, and every cell of the bill. Sessions 6 and 7 are the first with
such lines, four of them.

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

## Session 2, 11 September

The owner checked Session 2's lines and was content. `db/034` admitted its 81
lines and 72 stage dates, before the loader for the PhD spreadsheets is built,
as a recorded exception (`DECISIONS.md`). A safety copy was taken first
(`/var/tmp/legdata-before-034_2026-09-11.dump`). Admission and promotion were
rehearsed together and thrown away, then run without saving, then saved, and
the result checked against the factsheet's summary each time.

- 81 bills: 53 government, 18 Member's, 9 private, 1 committee; 66 passed, 5
  withdrawn, 10 fallen (4 at dissolution, 6 rejected at Stage 1). Every cell
  matches page 8.
- 72 stage records: 57 Stage 3 and 9 Final Stage from the factsheet, 6 Stage 1
  from the Official Report.
- 12 provenance notes, an outcome and a route for each rejection, and 2 notes
  for readers on the 9.14.18 bills.
- The whole clean sheet: 154 bills, 139 stage records, 23 notes. The error
  checker empty, 271 gaps.

## The stage-dates sheet shows titles, 11 September

`db/035`, for typing your dates into Postico. Rehearsed and thrown away, then
run for real. A safety copy of the database was taken first
(`/var/tmp/legdata-before-035_2026-09-11.dump`), and a copy of the sheets inside
it, kept as `copy_before_phd_dates` for the comparison once your dates are in.

- The sheet was rebuilt with the title beside the line number. Compared with
  the copy cell by cell: no unexpected differences, and the one new column
  listed.
- All 139 rows show their line's title. The error checker is empty, and the
  gaps list holds 271, as before.
- A fresh connection as Postico's user reads 05/01/2000 as 5 January.

Tested in rehearsal rather than assumed:
- Session 1, taken off and put back from the rebuilt sheet, matched the copy;
- a row typed with no title got one, a title typed by hand was replaced, and a
  corrected line number brought the right title;
- a title corrected on the factsheet sheet reached its stage rows, without
  changing their last-changed time;
- a planted wrong stage name was still caught.

## The stage's position fills itself in, 11 September

`db/036`, asked for by you as a failsafe. Rehearsed and thrown away, then run
for real after a safety copy (`/var/tmp/legdata-before-036_2026-09-11.dump`).

- All 139 rows were saved again under the new rule and came back identical,
  last-changed time included. Compared with `copy_before_phd_dates`: no
  unexpected differences.
- Every position matches its stage name. The error checker is empty, and the
  gaps list holds 271.

Tested in rehearsal rather than assumed:
- a position left out, sent empty, or typed wrong was filled in from the name;
- a Private Bill's Preliminary and Consideration Stages got 1 and 2;
- Stage 1 on a Private Bill got 1, and the checker said it was the wrong name;
- a mistyped stage name got no position, the checker named it, and correcting
  the name brought the position;
- a new row sent with DEFAULT in every column left alone was accepted, and one
  sent with the row number empty was refused.

## Postico can open every pivot table, 12 September

`db/040`. Five pivot tables belonged to the administrator rather than to your
login, so they would not open: the stage dates and durations per bill, the
totals, outcome by type, and the duration summary. All 26 tabs now belong to
`legdata`. No data changed. Rehearsed and thrown away first, then run after a
safety copy (`/var/tmp/legdata-before-040_2026-09-12.dump`).

`db/041` corrects methodology note M2, which said your dataset covers Sessions
1 to 6. It now says the published thesis covers Sessions 1 to 5 and that
collection continued into Sessions 6 and 7, and that a bill has no Stage 1 or
Stage 2 date only where it has not yet reached that stage.

## A stage that did not happen, 11 September

`db/039`, after the Robin Rigg Act showed two dates to find that do not exist.
Rehearsed and thrown away first; a safety copy and a copy of the sheets were
taken before the real run (`/var/tmp/legdata-before-039_2026-09-11.dump`).

- **The Robin Rigg Act now has three records**: its Preliminary and
  Consideration Stages marked as stages that did not happen, with your note,
  and its Final Stage dated 26 June 2003 as before.
- **The gaps list is empty**, and so is the error checker.
- **413 stage records** against 154 bills. Every bill that passed in Sessions 1
  and 2 — 62 and 66 — now has a record for every stage.
- **Compared with the copy taken beforehand**: only those 2 rows, the 2 stage
  records they became, and the new column on both sheets.

Tested in rehearsal rather than assumed. The clean sheet refused a skipped stage
on a Government Bill, one with a date, one with no note, and one also marked
completed. The staging sheet took the same rows and the error checker named
each fault, which is the intended difference between the two sides.

## Both sessions back on the clean sheet with the dates, 11 September

`db/038` recorded your acceptance of all 411 stage-dates rows, and each session
was taken off and put back. Rehearsed twice and thrown away first, once per
session; a safety copy was taken before the real run
(`/var/tmp/legdata-before-038_2026-09-11.dump`).

- **411 stage records** on the clean sheet, where there were 139: 256 from your
  dataset, 128 passing dates from the factsheets, 14 from the Official Report
  and 13 from the Parliament's bill pages.
- **154 bills, 23 provenance notes, the error checker empty**, and two dates
  still to find, both on the Session 2 Robin Rigg Act.
- **62 of Session 1's 73 bills and 65 of Session 2's 81** have all three stages
  dated. The rest are bills that did not pass.
- **Compared with the copy taken before the dates**: the only differences are
  the 272 rows added to the stage-dates sheet, the 272 stage records they
  became, the title column added by `db/035`, and the note on the Robin Rigg
  Act. Everything else differs only in record numbers and times written.

## Your PhD stage dates loaded, 11 September

`tools/phd_stage_dates.py` read your dataset and your answers about the bills
that did not pass, and `tools/load_phd_stage_dates.sql` put the result on the
stage-dates sheet. Nothing reached the clean sheet. A safety copy of the
database was taken first (`/var/tmp/legdata-before-phd-dates_2026-09-11.dump`).

- **All 154 bills matched your dataset one to one**, 18 of them named in the
  reader because the wording differs. Four introduction dates differ from the
  factsheet's, and were printed rather than used.
- **270 rows loaded**, all waiting for your review: 254 from your dataset for
  the bills that passed, 13 from the Parliament's bill pages and 3 from the
  Official Report for the bills that did not.
- **Your two practice rows were recognised and skipped**, because they say
  exactly what your dataset says.
- **The Robin Rigg Act (line 124)** carries your note about reintroduced
  Private Bills.
- **127 of the 128 bills that passed now have all three stage dates.** The one
  without is that Robin Rigg Act, and its two missing dates are the whole of
  the gaps list.
- **The error checker is empty.**

Tested in rehearsal and thrown away first. Each of these was refused, naming
the reason: a title that did not match its line number, a date that clashed
with a row already held from the same source, a date before the bill was
introduced, and a line number that does not exist.

## Postico's dates, 11 September

`db/037`, asked for by you, set Postico's login to show dates day first. After
reconnecting, Postico still showed them year first, so Postico formats dates
itself and does not take the server's form. You are content with year first.

**Type dates year first**, as Postico shows them. How Postico reads a date
typed with slashes has not been tested, and a year-first date cannot be
misread.

The project's scripts log in as the administrator and were never affected.
Tested before it was made, with planted mistakes thrown away afterwards: the
error checker and the gaps list found the same either way. To undo it takes
one line, given in `db/037`.

## Why a bill fell, moved out of the reader, 12 September

`db/051` and `db/052`, then Sessions 1 and 2 taken off the clean sheet and put
back on, so the seven bills that ran out of time gained the provenance note they
had never had. Safety copies first: `/var/tmp/legdata-before-051_2026-09-12.dump`
on the server, and `copy_before_051` inside the database, compared afterwards
and dropped.

**Rehearsed twice and thrown away before any of it was kept**, each rehearsal
being the migration plus one session off and back on, compared cell by cell
against a copy taken before all of it:

- **Session 1: 21 differences, every one intended.** 18 notes rewritten on the
  fallen staging lines, and 3 new provenance notes.
- **Session 2: 22 differences, every one intended.** The same 18, and 4 new
  notes.
- Everything else differed only in record numbers and times written.

**The migration proves its own claim rather than asserting it.** It takes the
old reader's answer off the seven lines, applies the new rule in its place, and
stops unless the same seven come back. They did: lines 66, 71, 73, 148, 150,
152 and 154.

**Four refusals, proved and thrown away.**

- A bill coded as having fallen at dissolution whose concluding date is moved by
  one day: caught, naming both dates.
- A fallen bill left with an empty outcome: caught, "outcome not proposed —
  needs a judgement", and promotion will not run while the checker has anything.
- A bill coded that way in a session with no last day recorded, which is Session
  7: caught. This is the hole `db/051` closed; the old rule went quiet there.
- Promotion with the session's date provenance removed, so the note could not be
  written: refused, "3 bill(s) coded as having fallen at dissolution without the
  note saying it is our coding". Nothing was written.

**The real run.** 25 differences against the copy taken before all of it — the
18 rewritten notes and the 7 new provenance notes — and nothing else. 154 bills,
413 stage records, 56 provenance notes, error checker empty, gaps list empty.

**And the thing this was for.** Both fact sheets read again with nothing
supplied but the PDF and the session number now match the staging sheet in all
154 rows, none differing. All five ruled-table sessions give byte-identical
output on the Mac and on the VPS.

## Session 3, 13 September

The owner checked Session 3's lines across 12 and 13 September and was content.
`db/057` admitted its 62 lines and 62 stage dates, and the session was promoted.
Safety copies first: `/var/tmp/legdata-before-057_2026-09-13.dump` on the server
and `copy_before_057` inside the database, compared afterwards and dropped.

**The rehearsal is what earned its keep.** `db/055` had recorded five Session 3
outcomes from the Official Report with the address of the report on the
stage-dates row and nowhere else, and promotion writes a bill's citation from
the line. It refused on the three Stage 1 rejections; the Budget (Scotland)
(No. 2) and Creative Scotland Bills would have been written with the reference
empty and nothing would have said so. `db/058` put the address on all five lines,
read out of each bill's own stage row rather than retyped, and gave the error
checker the rule that asks for it. See `DECISIONS.md`, 2026-09-13.

- 62 bills: 44 government, 1 hybrid, 13 Member's, 2 private, 2 committee; 53
  passed, 2 withdrawn, 7 fallen (2 at dissolution, 3 rejected at Stage 1, 1
  rejected at Stage 3, 1 for want of a financial resolution). Reconciled against
  page 8 on `analysis_group`, which counts the hybrid bill under Executive as
  the fact sheet does: 42/7/2/2 Acts, 0/2/0/0 withdrawn, 3/4/0/0 fallen,
  45/13/2/2 in all.
- 62 stage records: 51 Stage 3 and 2 Final Stage from the legislation fact
  sheet, 5 from the Official Report, 4 from the Parliament's bill pages.
- 15 provenance notes: 5 outcomes and 3 Stage 1 routes from the Official Report,
  2 outcomes for the bills coded as having fallen at dissolution, and 5 cells
  checked at review against the source that owns them.
- The whole clean sheet: 216 bills, 475 stage records, 71 provenance notes. The
  error checker empty, 108 gaps.
- Compared with the copy: 62 bills, 62 stage records and 15 notes added, the 62
  lines and 62 stage rows stamped, five review notes gaining their address.
  Nothing else moved.

Tested in rehearsal rather than assumed: taking the address off a line again
makes the checker name it and the admission refuse; an anchor that is not on the
line refuses rather than writing in the wrong place; and on the real database,
running `db/058` a second time refuses rather than appending a second address.

## Session 3's stage dates, 13 September

`tools/phd_stage_dates.py --sessions 3` and `tools/load_phd_stage_dates.sql`.
Safety copies first: `/var/tmp/legdata-before-s3-dates_2026-09-13.dump` and
`copy_before_s3_dates`, compared afterwards and dropped.

The reader knew Sessions 1 and 2 only. It now takes `--sessions`, and works to a
rule stated in terms of what happened to the bill: one that reached Stage 3,
whether it passed there or was rejected there, completed the two stages before
it; one that ended before Stage 3 has the stage it ended at recorded from the
source that says so, and nothing is written for it. Session 3 is the first
session where that distinction does any work, because of the Budget (Scotland)
(No. 2) Bill.

- 108 rows loaded, all waiting for review: 52 Stage 1, 52 Stage 2, and
  Preliminary and Consideration for the two Private Bills. Exactly the gaps
  list, which is now empty.
- Compared with the copy: 108 rows added, and nothing else at all. The clean
  sheet is untouched until they are accepted.
- Sessions 1 and 2 give byte-identical output from the reader before and after.

Tested in rehearsal and thrown away first. Each of these was refused, naming the
reason: a dataset date disagreeing with a date already held from another source
(the Autism Bill's Stage 1 put back to 17 January); a dataset date for a stage
nothing says the bill completed, on a bill that never reached Stage 3; and a
session for which no reading date is recorded.

## Session 3 back on with its dates, 13 September

`db/059` recorded the owner's acceptance of the 108 rows, and Session 3 was
taken off the clean sheet and put back. Rehearsed as one sequence and thrown
away first; a safety copy was taken before the real run
(`/var/tmp/legdata-before-059_2026-09-13.dump`), and a copy of the sheets inside
it, compared afterwards and dropped.

- Taking it off removed exactly what promotion had written: 62 bills, 62 stage
  records, 15 provenance notes. Putting it back gave 62 bills, 170 stage records
  and the same 15 notes.
- **583 stage records** on the clean sheet, where there were 475. Session 3's
  170 are 52 Stage 1 and 52 Stage 2 from the dataset, 2 Preliminary and 2
  Consideration from the dataset, 51 Stage 3 and 2 Final Stage from the
  legislation fact sheet, 5 from the Official Report and 4 from the bill pages.
- **216 bills, 71 provenance notes, the error checker empty, the gaps list
  empty.** 54 of Session 3's 62 bills have all three stages dated; the other 8
  did not get that far.
- **Compared with the copy taken beforehand**: 324 differences, being the 108
  rows accepted and the 108 stage records they became. Everything else differed
  only in record numbers and times written.

Tested in rehearsal rather than assumed: `db/059` refuses a row waiting for
review that is not from the dataset, and putting the session back refuses while
any one stage date is still unreviewed.

## Session 6's endings and stage dates, 15 September

`db/095`, then `tools/phd_stage_dates.py --sessions 6` and
`tools/load_phd_stage_dates.sql`. Safety copies first:
`/var/tmp/legdata-before-s6-dates_2026-09-15.dump` and `copy_before_s6_dates`,
compared afterwards and dropped.

**Fourteen bills had to be settled before the reader would run at all**, the
same refusal Session 5 met with six. `db/095` recorded where each ended: five
rejected at Stage 1 and two at Stage 3 from the Official Report already quoted
on their lines by `db/092`, and seven from the Parliament's page for the bill —
the three that ran out of time and the four that were withdrawn. Only the four
withdrawn bills needed reading; all four pages say the same thing in the same
words, "This Bill was withdrawn at Stage 1 of the process to determine if it
should become an Act", with "Stage 2 has not been reached yet" below it, and each
gives the same withdrawal date the fact sheet already put on the line. Two of the
three that ran out of time had completed Stage 1, so `db/095` carries those two
dates as well, from the pages that state them, and the owner's dataset gives the
same two dates independently. Sixteen rows in all, rehearsed inside a
transaction that was thrown away before they were kept.

**The reader had to be taught about a second appearance.** It refused Session 6
over three lines — the UK Withdrawal (Legal Continuity) Bill and the two bills
reconsidered and passed — saying each had no row in the dataset. It had not: a
bill that appears in two fact sheets has its dates under the session it was
introduced in, and its first two stages belong to the line it continues, which is
what `db/086` settled for the gaps list. The reader now writes nothing for such a
line, having first checked that the bill it continues really does hold those two
stages on the clean sheet, so a line is never excused into a gap. Sessions 1 to 5
give byte-identical output from the reader before and after the change, 693 lines.

**The loader's last check had to be made precise, and was refusing for the wrong
reason.** It required the error checker to be empty after loading. That held
while nothing was ever left standing in it, and stopped holding when Session 7's
line began waiting on Session 6's promotion — a wait, not a fault. It would have
kept Session 6's dates out over a line that has nothing to do with them. The
check now compares the checker's findings before and after and requires that the
load caused none of them, problem by problem rather than by counting. Proved both
ways before it was used: it passed the real CSV, and refused the same CSV with
one bill's Stage 2 date moved to before its own Stage 1.

- 136 rows loaded, all waiting for review: 68 Stage 1 and 68 Stage 2. Exactly
  the gaps list, which now holds only Session 7's two.
- Session 6 now holds 223 stage rows: 136 from the dataset, 71 passing and
  reconsideration dates from the legislation fact sheet, 9 from the Parliament's
  bill pages and 7 from the Official Report. All 223 are waiting for review.
- Compared with the copy: 136 rows added, no cell changed anywhere, nothing
  removed. The clean sheet is untouched at 389 bills, 1071 stage records and 112
  provenance notes.
- The error checker finds one problem, line 474's, which stood before this work
  and waits on Session 6 being promoted.

**Two things to know about running it.** The connector rate-limits about a dozen
connections in quick succession, and the reader makes two per run, so a loop of
runs fails in a way that looks like a bug in the change being tested. And piping
the loader's output through `head` kills it before it commits: the run reports
every check passing and saves nothing.

**What this does not check.** Nothing has compared Session 6's stage dates
against the Parliament's bill pages — 83 pages, and its own piece of work, as
Session 5 left it. A stage date that is wrong but still in order passes the
error checker.

## Session 5's stage dates, 14 September

`tools/phd_stage_dates.py --sessions 5` and `tools/load_phd_stage_dates.sql`.
Safety copies first: `/var/tmp/legdata-before-s5-dates_2026-09-14.dump` and
`copy_before_s5_dates`, compared afterwards and dropped.

**Two things had to be built before the reader would run at all**, and both are
refusals working as intended rather than obstacles to get round.

- Six bills that did not pass had nothing on the stage-dates sheet saying where
  they ended, and the reader refuses a session containing such a bill. It would
  have refused all 87 lines for those six. `db/075` recorded them from the
  Parliament's bill pages.
- The Domestic Abuse (Protection) Act has no row in the dataset at all, and the
  reader refuses to write anything unless every line pairs one to one. Its two
  dates came from its own bill page in the same migration, and the line is now
  named in `NOT_IN_DATASET` — which excuses it from the pairing, and is itself
  checked against what the sheet holds.

**The rehearsal refused, and was right to.** The dataset dates the Civil
Partnership (Scotland) Act 2020's Stage 2 at 11 February 2020 and its Stage 1 at
19 May 2020. The error checker has refused a stage dated before the stage before
it since the sheet was built. The bill page gives Stage 2 as 11 June 2020 — the
day right, the month wrong — and agrees with the dataset on Stage 1 and with the
fact sheet on introduction, Stage 3 and Royal Assent. `db/076` settled it at the
bill page before the working file was corrected, so the record that the two
sources disagreed survives the correction. Nothing was saved by the refused run,
and the reader then produced 153 rows rather than 154, because a stage held from
a source that outranks the dataset is compared rather than written.

- 153 rows loaded, all waiting for review: 72 Stage 1, 72 Stage 2, and
  Preliminary and Consideration for the five Private Bills. Exactly the gaps
  list, which is now empty.
- Session 5 now holds 243 stage rows: 153 from the dataset, 78 passing dates
  from the legislation fact sheet, 9 from the Parliament's bill pages and 3 from
  the Official Report.
- Compared with the copy: 154 rows added — the reader's 153 and `db/076`'s one —
  no cell changed anywhere, nothing removed. The clean sheet is untouched at 302
  bills until they are accepted.
- Sessions 1 to 4 give byte-identical output from the reader before and after the
  change to it.

Tested in rehearsal and thrown away first. Each of these was refused, naming the
reason: a line whose title does not match its number; a line from another
session; a bill that passed, given an ending; a line that already says where it
ended; a line holding a stage the bill never reached; a Stage 2 date outside the
bill's own life, in either direction; a line absent from the dataset that is not
named; and a named line the sheet holds no dates for.

**What this does not check.** The error checker found the Civil Partnership date
because the dates were in an impossible order. A stage date that is wrong but
still in order passes it. Nothing has compared Session 5's stage dates against
the Parliament's bill pages — 87 pages, and its own piece of work.

## Session 4's stage dates, 13 September

Recorded here on 14 September, having been missed at the time: the gap the
sanity check had been reporting for several sessions. `db/068` admitted the 158
rows loaded on 13 September by `tools/phd_stage_dates.py --sessions 4` and
`tools/load_phd_stage_dates.sql` — 74 Stage 1 and 74 Stage 2 for the public
bills that reached Stage 3, and Preliminary and Consideration for the five
Private Bills. Session 4 was then taken off the clean sheet and put back with
them, as Sessions 1 to 3 were. The migration's own account is fuller than this
line; what was missing was any entry at all.

## Session 5 admitted and promoted, 14 September

`db/077` admitted the 87 lines and all 243 stage dates, and
`tools/promote_session.sql` carried them onto the clean sheet. Safety copies
first: `/var/tmp/legdata-before-s5-promotion_2026-09-14.dump`, and
`copy_before_s5_promotion` and `copy_after_s5_promotion`, both dropped after the
comparison below.

**The first session promoted with its Stage 1 and Stage 2 dates already on it.**
Sessions 1 to 4 each went onto the clean sheet without them, and each had to be
taken off and put back when they arrived. Session 5's were loaded before the
review, so it goes on once and there is nothing to come back for.

- The clean sheet went from 302 bills, 828 stage records and 86 provenance notes
  to 389, 1071 and 105.
- The totals reconcile with the fact sheet's own summary in every cell: 63
  government, 16 Member's, 5 private, 3 committee; 78 passed — 75 Acts and the 3
  stopped from Royal Assent — 2 withdrawn, 3 rejected at Stage 1 and 4 fallen at
  dissolution.
- The 243 stage records are 73 Stage 3 and 5 Final Stage from the legislation
  fact sheet, 72 Stage 1 and 71 Stage 2 and 5 Preliminary and 5 Consideration
  from the owner's dataset, 9 from the Parliament's bill pages and 3 from the
  Official Report. No accepted date went uncarried: no two sources gave the same
  stage of the same bill.
- Error checker empty, gaps list empty.

**Taken off and put back, to prove the recovery path rather than assume it.**
Taking it off left 302 bills, 828 stage records and 86 notes, with the staging
lines unstamped and still accepted; putting it back gave 389, 1071 and 105
again. Compared cell by cell against a copy taken before it was taken off:
**no unexpected differences.** The only cells that moved are the ones the
comparison expects to — the numbers of the stage records and provenance notes,
which are reissued, and the times things were written and stamped.

**How Session 5 reads as finished data.** The three bills stopped from Royal
Assent have a duration to the end of Stage 3 and none to Royal Assent, which is
right, and they are the only three bills on the clean sheet in that position.
The government stage-3-to-assent row counts 60 bills against 62 at Stage 3, and
the Member's 7 against 8, which is those same three. The Coronavirus (Scotland)
Act 2020 took one day from introduction to the end of Stage 3 and the Budget
Acts 27 and 28, at the short end; the Pow of Inchaffray Drainage Commission Bill
took 636, at the long end. The duration view holds the 78 bills that passed and
not the 9 that did not, as it does for every session.

**What this does not check**, unchanged from the stage-dates entry above:
nothing has compared Session 5's stage dates against the Parliament's bill
pages. That is 87 pages and its own piece of work, and the owner has settled
that the dataset is taken as it is for now.

---

## Sessions 5 and 4 off and back on to mend eight notes, 14 September

The first time a session was taken off and put back to correct nothing on the
staging sheet. The staging lines were right; the step that copies a note onto the
clean sheet was not, and it had left eight notes ending with the words "Read at"
and nothing after them. See `DECISIONS.md`, 2026-09-14, and `db/079`.

**What was done, in order.**

1. A read-only preview first, before anything was touched: of the twenty-four
   lines whose outcome came from the Official Report, the mended step changes
   exactly eight, each by eight characters, and all twenty-four still yield an
   address for the note's reference.
2. A copy taken with `tools/take_copy.sql`.
3. `tools/promote_session.sql` mended, to cut "Read at" together with the address
   it introduces.
4. **Session 5 rehearsed alone** — taken off, put back, the whole thing thrown
   away, compared against the copy. Three cells differed, the three notes.
5. **Session 4 rehearsed alone**, the same way. Five cells differed.
6. Only then run for real, Session 5 and then Session 4, and compared again.
   **Eight cells differed and nothing else.** Bills 389, stage records 1071 and
   provenance notes 106 throughout.
7. `db/079` rehearsed and run, and the copy dropped.

**Why the two sessions were rehearsed separately.** Both scripts make temporary
tables that last until the transaction ends, so neither can run twice inside one
rehearsal. Two rehearsals also make the expected answer sharper: three cells and
five, which together are the eight the real run must show.

**What to watch if this is done again.** The comparison counts the numbers given
to stage records and notes, and the times things were written, as expected
differences — they always move. Everything else is the answer. A session taken
off and put back gives its stage records new numbers, so anything that had
remembered an old one would be pointing at nothing; nothing does, and the
comparison matches stage records by their bill and position for that reason.

## Sessions 7, 6 and 5 off and back on to date a ruling, 17 September

The Legal Continuity Bill, bill 305, had no date for when it was stopped, because
the fact sheet's footnote gives none. The owner settled that a missing date is
added with its provenance. `db/105` put the Supreme Court's judgment date on its
Session 5 line with a "Checked:" citation, and gave the date in the note on both
its lines. See `DECISIONS.md`, 17 September.

**A fault in promotion was found first, by reading it.** The step that credits a
blocked bill's date to the fact sheet's footnote ran whenever there was a date
and a footnote, and before the "Checked:" step, so it would have credited this
date to a fact sheet that does not print it. It now leaves a checked date to the
"Checked:" step.

**How it was run: as one change that saves only on the rehearsed answer.** Three
sessions had to come off in order (7, then 6, then 5) and go back on in the
reverse order, and a failure half way would have left the clean sheet short.
So the copy, `db/105`, the three undos, the three promotions and the comparison
all ran inside one transaction, with the tools' working tables dropped between
runs (the standing method, as in `CLOSURE-TESTS.md`). Rehearsed twice and thrown
away. The real run was the same bundle ending in a check that the differences
were exactly the fourteen rehearsed, the counts right, and the checker and gaps
list empty; only then was the copy dropped and the change saved.

**The fourteen differences.** Bill 305: the date and the note. Line 305: the
date, note, review note and review time. Line 412: note, review note and review
time. A new provenance note for the date, credited to the Supreme Court. Bill
305's note provenance: its text and date. **And bills 303 and 304's note
provenance, expected:** putting a session back rewrites each note row from the
tool, which drops the sentence `db/101` had added by hand recording its own
correction. `db/101`'s closure test expected exactly that. The correction is
still recorded in `db/101` and `DECISIONS.md`.

**What to watch if this is done again.** The rollback of Session 6 takes Session
5 with it and says so; the rollback of Session 7 leaves Session 6 alone, because
Session 7 changed nothing on its bill. Counts with all three off: 302 bills, 828
stage records, 87 provenance notes.

## Sessions 2, 4, 7, 6 and 5 off and back on to record title changes, 17 September

`db/107` added the stage at which a bill's title changed, filled it on four
lines in Sessions 2, 4 and 6, and gave the Session 4 Buildings Act its earlier
title. The same method as `db/105` the same day: copy, migration, the undos and
promotions (2 off and on, 4 off and on, then 7, 6 and 5 off and 5, 6 and 7 on),
and the comparison, in one transaction, saving only if the differences were
exactly the eleven rehearsed. Promotion carries the new cell and checks it
field by field. A new column shows in the comparison as "column only now" and
is not counted among the differences; the four new cells were checked
separately.
