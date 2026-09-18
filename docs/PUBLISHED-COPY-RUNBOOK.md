# Taking the published copy

For the owner. Written 18 September 2026. **A proposal: nothing here is built.**
This is block 1 of `docs/PHASE-2-CHARTS-BUILD.md`. What the copy holds, its
nine files and every heading were settled on 17 and 18 September
(`docs/PHASE-2-PUBLISHED-COPY.md`) and are not reopened here. This says how the
copy gets made, how we know it is right, and how it is undone.

**In block 1 nobody reads the copy.** The site does not open it until the first
chart, in block 4. Putting a new copy live over an old one, keeping the old one
for the undo, and the list of what changed all belong to the refresh, block 3.
Block 1 makes the copy once and proves it.

---

## 1. Five things for you to decide

### 1. It is a workbook of its own, called `published`

Settled on 15 September: three databases, the working one, the published one
and the accounts. This names the second `published`. Inside it, the nine files
sit in one area called `live`. Block 3 adds a second area, `previous`, for the
undo.

**Not backed up**, as settled, since it can be rebuilt from the working one in
seconds. So the backup script's list of databases it deliberately skips gains
`published`. That is a change to a script the server runs every night, so it is
rehearsed with the backup's own rehearsal tool before it is trusted. Without it,
the sanity check would find a database in no backup theme, and the nightly
backup would keep it for ten years.

### 2. The copy is built inside the working workbook first, then moved across whole

The build runs in a separate area of the working workbook, `copy_build`, and is
checked there against the working data. Only once every check passes is it
moved across to `published`. Then the working area is removed.

**Why:** the check needs the working cells and the published cells side by side,
and in one workbook that is a lookup. Across two workbooks it needs a
connector between them, which is an add-on to the database and would be a new
dependency. Moving the finished area across is one step, done with the tool the
backup already uses.

**The cost:** for a few seconds during a build, the working workbook holds a
second area. The closing check already asks that no working copy is left
inside it, and the script removes the area whether the build passes or fails.

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
can open the nine files and look at them as a spreadsheet before any page shows
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

One script, `tools/take_published_copy.sh`, run by a session from this Mac. No
step by hand.

1. **Refuse to start** unless the error checker and the gaps list are empty,
   nothing is waiting on the staging sheet unreviewed, and no `copy_build` area
   is left over from a previous run.
2. **Build.** In the working workbook, make the `copy_build` area and write the
   nine files into it from the clean sheet, the session dates, the notes, the
   provenance lines and the lists of allowed values. Words in the cells, not
   codes. Yes or No where a heading asks a yes-or-no question. Dates as
   year-month-day. An empty cell stays empty.
3. **The mapping.** One list says which working column each published heading
   comes from. The build uses it to make the files and to translate each
   note's `applies_to` into published headings, as settled. It is the only
   place that pairing is written down.
4. **Check** (§3). If anything fails, remove the area, report what failed, and
   stop. Nothing has reached `published`.
5. **Move it across.** Copy the `copy_build` area into `published` as `live`,
   with its descriptions, and give Postico's login read permission.
6. **Check again on the far side.** The same row counts, and a fingerprint of
   every file, in both places.
7. **Remove the working area**, and confirm the working workbook is as it was
   before: the same fingerprint of the clean sheet.

The `about` file records the day the copy was taken and each file's row count.
`what_changed` has headings and no rows, because this is the first copy.

---

## 3. What the check proves

Each is a count or a yes-or-no, and each must come out as stated.

| # | The check | Must be |
|---|---|---|
| 1 | Rows in each file against the working database: bills 470, stages 1291, days between stages 1657, sessions 7, notes 14, sources 192 | equal |
| 2 | Every cell, turned back through `what_the_words_mean`, against the working cell | no difference |
| 3 | Every cell under a heading whose values are words from a list appears in `what_the_words_mean` for that heading | no word missing |
| 4 | No cell holds a stored code (`fell_dissolution`, `stage_3`, `still_blocked`) | none |
| 5 | Every heading a note's `applies_to` names exists in the copy | all exist |
| 6 | Every heading a note's text names exists in the copy (the check `db/113`'s closure test ran against the agreed list, now run against the real files) | all exist |
| 7 | Nothing that must not cross has crossed: no party, no staging line, no stage record number, no created or changed time, no column the mapping does not name | none |
| 8 | Every file and heading has a description | all described |
| 9 | Each source line's `applies_to_heading` exists in the file it names, and its `bill_number` is a bill in `bills` | all exist |
| 10 | The days between stages equal what the working calculation gives, gap by gap | no difference |

**What the check does not prove.** Whether the headings and wording are right:
you agreed those. Whether the working database is right: that is what the
closure tests are for. That a page shows the copy correctly: nothing reads it
yet.

---

## 4. Rehearsal

Before the real run, in this order:

1. **The build and check inside a transaction that is thrown away**, in the
   working workbook. Look at: each check's result; one bill traced through all
   nine files by hand. I suggest the Legal Continuity Bill, which touches the
   most headings: a section 33 reference, withdrawal, a rewritten note, and
   provenance lines from two fact sheets. Then confirm the working workbook is
   unchanged and no `copy_build` area is left.
2. **A deliberate fault**, to prove the check catches it: the same rehearsal
   with one cell altered after the build (one bill's outcome), and the check
   must fail on that cell and name it. A check that has never been seen to fail
   is not evidence of anything.
3. **The move across, into a scratch workbook** (`published_rehearsal`), then
   removed. Look at: the fingerprints match, the descriptions came across, and
   Postico's login can read and cannot write.
4. **The backup script's change**, rehearsed with `tools/rehearse_backup_themes.sh`:
   `published` is listed as not backed up, and the working workbook and the
   accounts still are.

---

## 5. The undo

**In block 1 the undo is removing the `published` workbook**, since nothing
reads it: one step, no data lost, because the working workbook is where
everything lives. The backup script's change is undone by reverting that one
line. Written in full in the procedure, and rehearsed as the last step of the
rehearsal: make `published_rehearsal`, remove it, and confirm the sanity check
finds nothing unsorted.

The undo that matters, putting the previous copy back after a bad refresh, is
block 3's.

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

Block 1 is roughly a session and a half. This session writes the mapping and
the build and check scripts. The next runs the rehearsal, makes the real copy,
and shows it to you in Postico. A different session then runs the closure test.
The one outside change is the backup script's line.
