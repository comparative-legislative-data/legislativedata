# The notes on the sources file

18 September 2026. The `sources` file publishes one line per fact that names its
own source, 192 of them, and each carries a `note`. The notes were written for
whoever runs the database, and some name working columns and codes a reader of
the published copy never sees. This is every note, grouped by its wording, with
what is wrong with it and what is proposed. Nothing has been changed.

**25 wordings over 192 lines.** 100 lines are fine as they stand, 77 of them
empty. The other 92 fall into five groups, A to E.

---

## A. "Checked at review", 67 lines

**Now:** Checked at review against the source that owns this value. The
factsheet's own printed words are kept in the raw_ columns of bill_candidate.

**What is wrong.** The second sentence points at a staging column that is not
published, so a reader is sent to a place they cannot go. Also, the line's own
`value_as_the_source_gave_it` does not hold the fact sheet's words: it holds the
value from the source that was checked, such as legislation.gov.uk. The 67 are
Royal Assent dates (22), titles (12), Act numbers (11), introduction dates (8),
enactment status (7), the stage the title changed at (4), bill type (1), a
completion date (1) and a date a bill was blocked (1).

**Proposed:** Checked at review against the source named on this line, which
is the one that settles this fact. Where the fact sheet printed it differently,
this line's value is the one used.

---

## B. Fell at dissolution, 17 lines over six wordings

The six differ only in the date and the session. One example:

**Now:** Our coding, not the factsheet's: the legislation factsheet says the bill
fell and not why. Coded as having fallen at dissolution because it concluded on
2021-05-04, the day Session 5 ended. That day is session.date_session_end, from
the source cited here. See methodology note M7.

**What is wrong.** `session.date_session_end` is a working name. The published
heading is `date_session_ended`, in the `sessions` file.

**Proposed** (the same change in all six): Our coding, not the fact sheet's:
the legislation fact sheet says the bill fell, and not why. Coded as having
fallen at dissolution because it concluded on 2021-05-04, the day Session 5
ended. That day is date_session_ended in the sessions file, from the source
cited here. See methodology note M7.

"factsheet" also becomes "fact sheet", which is how the notes and definitions
now spell it.

---

## C. Read off the Session 6 fact sheet, codes, 6 lines

Four wordings quote a stored code rather than what a reader sees in the cell:

| Lines | Heading | Now reads | Proposed |
|---|---|---|---|
| 2 | `enactment_status` | It read 'blocked' and now reads 'enacted'. | It read 'Blocked' and now reads 'Enacted'. |
| 1 | `enactment_status` | It read 'blocked' and now reads 'not_enacted'. | It read 'Blocked' and now reads 'Not enacted'. |
| 2 | `outcome_after_being_stopped` | It read 'still_blocked' and now reads 'reconsidered_passed'. | It read 'Still blocked' and now reads 'Reconsidered and passed'. |
| 1 | `outcome_after_being_stopped` | It read 'still_blocked' and now reads 'withdrawn'. | It read 'Still blocked' and now reads 'Withdrawn after being blocked'. |

The rest of each note stays word for word. The seven others in this family quote
a title, a date or an Act number, which read the same in both, and are fine.

---

## D. The corrected title, 1 line

**Now:** Corrected at review. The factsheet's wording is kept verbatim in
bill_candidate.raw_title: Criminal Procedure (Amendment) Scotland Act 2002 asp 4

**What is wrong.** It names a staging column. The fact sheet's words are already
in the note, so the pointer can simply go.

**Proposed:** Corrected at review. The fact sheet printed it as: Criminal
Procedure (Amendment) Scotland Act 2002 asp 4

---

## E. Session 7's expected last day, 1 line

**Now:** ... Copies of the three pages are kept in sources/legislation/.

**What is wrong.** It names a folder in the repository. If you make the
repository private, which you expect to, no reader can follow it.

**Proposed:** drop that sentence. The three pages are already named on the line
itself, in `where_in_the_source`.

---

## Fine as they stand

- **77 empty.**
- **Compared against the Parliament's API**, the 13 session lines.
- **Read off the Session 6 fact sheet**, the seven that quote a title, date or
  Act number.
- **Rewritten when Session 6 was reviewed**, the three that quote the old and
  new bill notes in full.

---

## Found, and not opened

In group A, `value_as_the_source_gave_it` is often our coded value, not the
source's words: `enacted`, `stage_3`, `2021-03-30` where legislation.gov.uk
prints a date in words. That column is published, so it has the same working
name problem and a second one besides, since its heading promises the source's
own words. It is recorded here and not opened, so as not to start a second
question before this one is built.
