# The refresh

For the owner. Written 18 September 2026. Strand 1, item 6 of
`docs/PHASE-2.md`. Every part is laid out here, with four questions at the
end.

**Agreed by the owner the same day: yes to all four. Built and rehearsed the
same day**; the copy now has twelve files. The closure test is written and
unrun. The record is at the end.

What is already settled (the review of the plan, 17 September): the copy is
refreshed only when data is added or changes, at your word, by a session,
never automatically. It is rebuilt whole beside the live copy and goes live
only if every check passes; otherwise readers keep the old copy. The old copy
is kept, served to nobody, so the undo is one step. A changed value is listed
with its old and new value; additions are a count. The size of the list and
of the kept copy is reported each time. One script, no step by hand.

## What happens, for one bill

Say a later session finds the Official Report dates the Legal Continuity
Bill's Stage 3 a day later than we have it, and the corrected date is promoted
onto the clean sheet. You say "refresh the copy". A session runs one script:

1. **It checks every cited address.** All 106, from the server, a few seconds
   apart. Each one either still works, has gone, or can't be checked (the 14
   on the old site's archive). Each must have a kept copy; if a new address
   has none, the refresh stops and says which.
2. **It builds a new copy beside the live one**, with every check the copy
   already has: every cell against the working data, the days between stages
   worked out again from the kept working, and every source covered by terms.
3. **It compares the new copy with the live one, cell by cell.** The bill's
   `third_stage_ended` has moved by a day, and so have two lines of the days
   between stages. Each changed cell becomes a line in `what_changed`, with
   the old and new value. A bill added would be counted, not listed.
4. **Only if every check passes**, the live copy becomes `previous`, the new
   copy becomes `live`, and the copy before `previous` is dropped. It reports
   what changed, how many lines were added, and the size of the list and of
   `previous`.

If anything fails, nothing moves and readers keep the old copy.

**The undo** is one step: `previous` goes back to being `live`, and the bad
copy is dropped.

## Every part of the change

**1. One script, from this Mac.** `tools/refresh_copy.sh` sends the copy's
build, the working and the list of kept pages to the server in one bundle,
runs the address check and then the build there, and prints the report. The
copy's build (`tools/published_copy.sql`) stays one script for the first copy
and every refresh: it no longer refuses when `live` exists.

**2. The address check.** An address "works" if it returns the page on its own
site. Checked today: a dead Parliament address doesn't say "not found"; it
forwards to the web archive's browser check and reports success. So an
address that ends up anywhere else counts as gone. An address that has gone
does **not** stop the refresh: the data is still right, and the kept copy is
there. It is reported, and it reaches the reader (question 1).

**3. What changed, and what it holds.** `what_changed` keeps every earlier
refresh's lines and adds this one's, each dated. Cells are matched by what the
line is about: a bill by its number, a stage by its bill and stage, a session
by its number, a note by its code, and so on. `about` and `what_changed`
itself are not compared. Two gaps in what was settled:
- **a line whose bill number and stage don't say which line it is** (a
  session, a note, a word's meaning, a set of terms) needs one more heading
  (question 2);
- **a line removed**, which was not settled. A bill that disappears should be
  visible to a researcher who had it (question 3).

**4. `previous`.** Served to nobody: the site's login is never given it.
Postico can open it. Only one is kept.

**5. The checks the refresh adds**, on top of the copy's eleven:
- every cited address has a kept copy (`sources/kept-pages.csv`);
- `what_changed`'s earlier lines are carried across unaltered;
- every changed cell is listed once, and nothing unchanged is;
- the count of added lines in `about` equals the lines found only in the new
  copy.

**6. The rehearsal, before first use**, in this order:
- **A thrown-away run** with today's data: it must find no changes.
- **Planted changes**, inside a thrown-away run: one cell altered, one line
  removed and one added in the live copy before comparing. The list must show
  exactly the altered cell and the removed line, and count one addition.
- **A real refresh, then the undo, then a real refresh again.** Each time,
  `live` compared cell by cell with what it should be.
- **A refresh that must fail**, with a planted fault: readers' copy untouched.

**7. The papers.** A step in `PROMOTION-RUNBOOK.md`, "Refreshing the published
copy", with what to look at and the undo; `PUBLISHED-COPY-RUNBOOK.md`'s block
3 pointed at it; `HOW-THE-DATABASE-WORKS.md` traced with the one bill above;
the dictionary regenerated. A closure test, run by another session.

**8. When, and how big.** Two sessions, as the plan says: one to build and
rehearse, one for the real first refresh and its undo. Possibly one if the
rehearsal goes cleanly.

## Four questions

**1. Should the copy say which addresses have gone?** The agreed rule is that
where an address has gone, the page names the kept copy. For a page to know
that, the copy has to hold it. **Proposed:** a twelfth file, `cited_pages`,
one line per address: the address, the kept copy's name and the day it was
kept, the day the address was last checked, and whether it works (Yes, No,
or Not checked). Remade at every refresh.

**2. One more heading in `what_changed`.** Today it has the bill and the stage
to say which line changed. For a session, a note, a word or a set of terms,
that isn't enough. **Proposed:** a heading `which_line`, described as *"For a
line that isn't about a bill, what it is about: the session's number, the
note's code, the heading and word, or whose terms. Empty where bill_number and
stage say it."*

**3. A removed line.** **Proposed:** listed in `what_changed`, one line each,
with `heading` reading *"(line removed)"* and both values empty. A bill that
was split in two, or found to be a duplicate, then shows up for anyone who had
it.

**4. Does a changed working count as a change?** If the working behind the
days between stages is rewritten, its text in `workings` changes. **Proposed:**
yes, listed like any cell, with the old and new text in full, so a reader
knows the figure was worked out differently.

## What was done, 18 September

- **Built**: `tools/refresh_copy.sh` (the one step, from this Mac),
  `tools/check_cited_addresses.py` (run on the server), the copy's build
  extended (`cited_pages`, `which_line`, the comparison, checks 12 and 13,
  `previous`), and `tools/put_back_previous.sql` (the undo). The step is in
  `PROMOTION-RUNBOOK.md`, "After promotion: refreshing the published copy".
- **Wording written at the build**, beyond what was agreed, for the owner:
  the `cited_pages` file and its five headings; `which_line` widened to cover
  a gap between two stages, a source line and a working, since a bill number
  and stage don't pin those down either; `heading` gains "(line removed)
  where the whole line has gone".
- **The address check**: 92 work, 0 gone, 14 not checked. A made-up
  Parliament address and a made-up legislation.gov.uk address each came back
  "No"; a real one "Yes". It takes about twelve minutes, five seconds between
  two requests to one site.
- **Rehearsed**, in order: a thrown-away refresh with today's data, which found
  no changes; planted changes in a thrown-away run (a title altered, a stage
  line added to the old copy, a session taken out of it), which listed exactly
  the title with both values and the removed line, and counted one session
  added; a saved refresh with a planted fault, refused with 13 problems, every
  live file unchanged by fingerprint; a real refresh with the full address
  check; the undo, thrown away and then for real, after which `live` matched
  the copy before file for file and a second undo refused; a real refresh
  again, matching the first file for file, with `previous` the copy before.
- **Found and mended on the way**: psql doesn't fill a variable into its own
  `\copy`, so the address check is read with the database's `COPY`; a
  variable in the comparison shared a column's name.
