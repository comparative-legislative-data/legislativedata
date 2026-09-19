# Taking the published copy

For the owner. Written 18 September 2026. **The five decisions in §1 were
agreed by the owner the same day**, point 2 in the form the owner proposed: a
connector that can only read. **Built, and the first copy taken, the same
day**; see §7.
This is block 1 of `docs/PHASE-2-CHARTS-BUILD.md`. What the copy holds, its
nine files and every heading were settled on 17 and 18 September
(`docs/PHASE-2-PUBLISHED-COPY.md`) and are not reopened here. This says how the
copy gets made, how we know it is right, and how it is undone.

**In block 1 nobody reads the copy.** The site does not open it until the first
chart, in block 4. Putting a new copy live over an old one, keeping the old one
for the undo, and the list of what changed all belong to the refresh, block 3.
Block 1 makes the copy once and proves it.

---

## 1. The five decisions

### 1. It is a workbook of its own, called `published`

Settled on 15 September: three databases, the working one, the published one
and the accounts. This names the second `published`. Inside it, the files
sit in one area called `live`. Block 3 adds a second area, `previous`, for the
undo.

**Not backed up**, as settled, since it can be rebuilt from the working one in
seconds. So the backup script's list of databases it deliberately skips gains
`published`. That is a change to a script the server runs every night, so it is
rehearsed with the backup's own rehearsal tool before it is trusted. Without it,
the sanity check would find a database in no backup theme, and the nightly
backup would keep it for ten years.

### 2. The copy is built inside `published`, reading the working data through a connector that can only read

**The owner's proposal, agreed.** The build runs inside `published`. It reads
the working data through a connector that logs in to the working workbook as
`copy_reader`, a login that can read and do nothing else. So nothing done while
a copy is taken can change the working data. A mistake in the build script
cannot touch it at all, where before it would only have been unlikely.

- **What `copy_reader` can see** is only what crosses: the clean sheet, the
  stages, the sessions, the notes, the provenance lines, the lists of allowed
  values and the calculation of days between stages. It cannot see the staging
  sheets at all, so they cannot cross by accident.
- **Its password** is made at random when it is set up, and held only in the
  connector's own settings inside `published`. It is not in this repository or
  in the private notes. If it is ever lost, it is simply made again.
- **The guard.** `published` is the workbook the site will read. If the site's
  login could use the connector, it could reach the working data through it,
  which undoes the decision of 15 September. So only the build uses the
  connector; the connected tables sit in an area of their own, `from_working`,
  that no other login can open; and in block 4, the check that proves the site
  can only read also proves it cannot use the connector.
- **Nothing is installed.** The connector (`postgres_fdw`) comes with
  PostgreSQL and is already on the machine, switched off. The machine's login
  rules already allow it. Checked 18 September.

**It stays a snapshot.** The connector is used only while a copy is built.
Pages read the copy, so a promotion or a migration in the working workbook
still cannot change what a reader sees until the next refresh.

**One thing this also makes simpler.** The whole build, check and put-live runs
as one all-or-nothing action inside `published`. If any check fails, nothing is
left behind: no half-built area, and nothing to tidy.

### 3. The check does not trust the build

The build turns codes into words. If the check simply ran the same translation
again, it would agree with the build even if both were wrong. So the check goes
the other way. **It takes every cell of the copy, turns it back into what the
working database holds, using the copy's own `what_the_words_mean` file, and
compares the result with the working database, cell by cell.**

That proves the thing a researcher actually relies on: that the copy, read with
its own dictionary, says exactly what the working database says. The full list
of checks is in §3.

### 4. You can open it in Postico

Postico's login gets permission to read `published`, and nothing more, so you
can open the files and look at them as a spreadsheet before any page shows
them. The site's own login gets read permission in block 4, proved by a check
at that point, as settled.

### 5. The copy describes itself, and the data dictionary shows it

Every file and every heading in `published` carries its description. It is the
"What it holds" wording already agreed in `PHASE-2-PUBLISHED-COPY.md`, stored
in the copy the way the working database stores its own. That is where the
download's codebook will be generated from, as settled.
`tools/make_data_dictionary.py` gains a third part for the published copy, as it
has one for the accounts, and refuses to run if a heading has no description.
That way you can check the copy's descriptions the same way you check the
working ones.

---

## 2. What happens, in order

One script, `tools/published_copy.sql`, sent to the machine and run there by a
session. No step by hand. Steps 2 to 6 are one all-or-nothing action: if anything fails,
none of it happened.

1. **Refuse to start** unless the error checker and the gaps list are empty.
   Both are read through the connector.
2. **Build.** In `published`, make a `copy_build` area and write the thirteen files
   into it, reading through the connector from the clean sheet, the session
   dates, the notes, the provenance lines and the lists of allowed values. Words
   in the cells, not codes. Yes or No where a heading asks a yes-or-no question.
   Dates as year-month-day. An empty cell stays empty. **A worked-out file**
   (`days_between_stages`, and from 19 September the outcomes chart's
   `outcomes_by_session_and_type`) is not read from the working data: its
   working, a text in `workings/`, is run on the copy's own files, and the
   text is kept in the copy's `workings` file. A chart's figures are left out
   of the zip, which says so (`docs/STRAND-3-THOUGHT-2-FIGURES-BUILD.md`). So the script
   is run from the folder holding `tools/` and `workings/`. Settled
   18 September; `docs/STRAND-1-DAYS-BETWEEN-STAGES.md`. **The `terms`
   file** is read from the working database's record of each source's terms,
   four lines, with each line's `covers` worked out from whose terms each kind
   of source comes under. Added by `db/119`; `docs/STRAND-1-SOURCE-TERMS.md`.
3. **The mapping.** One list says which working column each published heading
   comes from. The build uses it to make the files and to translate each
   note's `applies_to` into published headings, as settled. It is the only
   place that pairing is written down.
4. **Check** (§3), against the working data read through the connector.
5. **Set it aside, then put it live.** `copy_build` becomes `next`, served
   to nobody; since 19 September (strand 2, item 6) the refresh makes the
   zip from `next` and checks it, and only then does `tools/switch_copy.sql`
   make `next` into `live`, the copy it replaces becoming `previous`; the one
   before that goes. Since 18 September the same script is the refresh
   (strand 1, item 6): run by `tools/refresh_copy.sh`, which checks every
   cited address first, and it lists what changed against the copy it
   replaces. `docs/STRAND-2-ITEM-6-BUILD.md` for the zip. `docs/STRAND-1-THE-REFRESH.md`; the step is in
   `PROMOTION-RUNBOOK.md`, "After promotion: refreshing the published copy".
6. **Give Postico's login read permission** on `live`, and nothing on
   `from_working`.
7. **Confirm the working workbook is as it was**: the same fingerprint of the
   clean sheet before and after. It cannot have changed, and the check proves it.

The `about` file records the day the copy was taken and each file's row count.
`what_changed` has headings and no rows, because this is the first copy.

**Set up once, before the first copy**: the `published` workbook; the
`copy_reader` login and what it may read; the connector and its `from_working`
area; and the backup script's line. A migration each side, with the usual
descriptions, rehearsed like any other.

---

## 3. What the check proves

Each is a count or a yes-or-no, and each must come out as stated.

| # | The check | Must be |
|---|---|---|
| 1 | Rows in each file against the working database: bills 470, stages 1291, sessions 7, notes 14, sources 192, terms 4 | equal |
| 2 | Every cell, turned back through `what_the_words_mean`, against the working cell | no difference |
| 3 | Every cell under a heading whose values are words from a list appears in `what_the_words_mean` for that heading | no word missing |
| 4 | No cell holds a stored code (`fell_dissolution`, `stage_3`, `still_blocked`) | none |
| 5 | Every heading a note's `applies_to` names exists in the copy | all exist |
| 6 | Every heading a note's text names exists in the copy (the check `db/113`'s closure test ran against the agreed list, now run against the real files) | all exist |
| 7 | Nothing that must not cross has crossed: no party, no staging line, no stage record number, no created or changed time, no column the mapping does not name | none |
| 8 | Every file and heading has a description | all described |
| 9 | Each source line's `applies_to_heading` exists in the file it names, and its `bill_number` is a bill in `bills` | all exist |
| 10 | The days between stages against the copy's own `bills` and `stages`, never against a sum in the working database: every cell but `days` is its bill's or its dated points'; `days` is the later date less the earlier and not below nought; every dated point ends exactly one gap but each bill's first, which ends none; and the text kept in `workings`, run again, gives exactly the file | no difference |
| 12 | Every address the working data cites is in `cited_pages` once, with a kept copy, checked that day, and Yes, No or Not checked | all there |
| 13 | What changed: every earlier line carried across unaltered; every line that differs from the copy before has a line, and no line is listed that doesn't differ; the lines added in `about` equal those found only in the new copy | no difference |
| 11 | No source's data without its terms: every source name used in `bills`, `stages` or `sources`, and every kind of source in the working list, is covered by exactly one line of `terms`; and each line's `covers` is exactly the kinds of source under it | none uncovered |

**What the check does not prove.** Whether the headings and wording are right:
you agreed those. Whether the working database is right: that is what the
closure tests are for. That a page shows the copy correctly: nothing reads it
yet.

---

## 4. Rehearsal

Before the real run, in this order:

1. **The set-up, into a scratch workbook** (`published_rehearsal`), with a
   scratch login in place of `copy_reader`. Look at: the connector reads the
   clean sheet; `copy_reader` cannot write to the working workbook and cannot
   see the staging sheets; Postico's login cannot open `from_working`.
2. **The build and check there, thrown away at the end.** Look at: each check's
   result; one bill traced through all nine files by hand. I suggest the Legal
   Continuity Bill, which touches the most headings: a section 33 reference,
   withdrawal, a rewritten note, and provenance lines from two fact sheets.
3. **A deliberate fault**, to prove the check catches it: the same run with one
   cell altered after the build (one bill's outcome, `-v fault=on`; or one
   gap's days, `-v fault_days=on`; or one credit line, `-v fault_terms=on`;
   or the Supreme Court taken out of its terms' covers, `-v fault_cover=on`).
   The check must fail on
   that cell and name it, and nothing may be left in the scratch workbook. A
   check that has never been seen to fail is not evidence of anything.
4. **The undo** (§5), on the scratch workbook and login. Then confirm the
   sanity check finds no database unsorted and no login left over.
5. **The backup script's change**, rehearsed with
   `tools/rehearse_backup_themes.sh`: `published` is listed as not backed up,
   and the working workbook and the accounts still are.

---

## 5. The undo

**In block 1 the undo is removing the `published` workbook and the
`copy_reader` login**, since nothing reads either: no data lost, because the
working workbook is where everything lives. The backup script's change is undone
by reverting that one line. Rehearsed as step 4 of the rehearsal.

The undo that matters, putting the previous copy back after a bad refresh, is
`tools/refresh_copy.sh --undo --save`, which runs `tools/put_back_previous.sql`
and puts the copy's zip back with it; in `PROMOTION-RUNBOOK.md`.

---

## 6. Before a reader sees any of it, not in block 1

Recorded so none of it is forgotten, and none of it built early:

- **The record of each source's terms** (licence, credit line, restrictions,
  link). Settled on 17 September: no source's data is published until it is
  written down. Needed before block 4, and how it is held is put to you then.
- **The site's read-only login**, proved by a check, in block 4.
- **The refresh**, with `previous`, `what_changed` and the undo, in block 3.
- **The download** and its codebook, generated from the descriptions in §1.5.

---

## 7. Size

**Where it stands, 18 September, end of the day.** Done: the rehearsal as
written in §4, with the Legal Continuity Bill traced through every file
against the working data; the backup line rehearsed and installed, the old
script kept on the machine as `legdata-backup.pre-published.bak`; the real
set-up; the real copy, its check finding nothing; the data dictionary's part
for the copy; the closure test, written and unrun. Left: the owner looking at
it in Postico, and the closure test run by another session.

**A fault in the backup rehearsal, found and mended.** Its check E ran the
installed backup against the real store when it could not redirect it, with
the rehearsal's restored copy of the accounts still open, and the day's
offsite data copy held it. A normal run of the nightly job straight after
replaced that copy and removed it; the tool now refuses rather than runs, and
drops its restored copies as soon as it has counted them. Lesson for any
rehearsal of the backup: never let a scratch workbook exist while a real run
could happen.

Block 1 is roughly a session and a half. This session writes the set-up, the
mapping and the build and check scripts. The next runs the rehearsal, makes the
real copy, and shows it to you in Postico. A different session then runs the
closure test. The outside changes are the backup script's line and one new
login, `copy_reader`.
