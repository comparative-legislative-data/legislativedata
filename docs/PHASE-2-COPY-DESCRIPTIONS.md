# The published copy: the wording still to agree

For the owner. Written 18 September 2026. The headings of `bills`, `stages` and
`days_between_stages` already have agreed descriptions
(`docs/PHASE-2-PUBLISHED-COPY.md` §2 to §4). The other six files were agreed as
lists of headings only. This is every description a reader will see that does
not exist yet, in full, as proposed. Each becomes the heading's description in
the copy, and from there the download's codebook.

---

## 1. One line for each file

| File | Proposed |
|---|---|
| `bills` | One line per bill introduced in the Scottish Parliament since 1999, with the day each of its stages ended. |
| `stages` | One line per stage a bill reached, with everything recorded about it. |
| `days_between_stages` | One line per gap between two dated points in a bill's passage, and the calendar days it took. |
| `sessions` | One line per session of the Parliament, with its first and last days. |
| `methodology_notes` | The judgements made in coding the data, one note per line, in full. |
| `sources` | One line per fact that names its own source, where that is not the source of the rest of its line. |
| `what_the_words_mean` | What each word in the other files means, one line per heading and word. |
| `what_changed` | Every published value that differs from the copy before, one line per cell. |
| `about` | The day this copy was taken, and how many lines each file has. |

---

## 2. `sessions`

| Heading | Proposed |
|---|---|
| `session` | The session's number: 1 for the Parliament elected in 1999, counting up. |
| `date_first_meeting` | The day the Parliament first met in this session. |
| `date_session_ended` | The session's last day. Empty for the session still running. |
| `date_session_expected_to_end` | For the session still running, the day it is expected to end, worked out from the law on when the next election is held. See M14. |
| `is_the_current_session` | Yes for the session running now. |
| `note` | Anything a reader needs to know about the session's dates that the dates do not say. |

## 3. `methodology_notes`

| Heading | Proposed |
|---|---|
| `note` | The note's code, M1, M2 and so on, which the other files use to refer to it. |
| `title` | What the note is about, in one line. |
| `text` | The note in full. |
| `applies_to` | The headings the note bears on, each written as the file and the heading, such as bills.outcome. |

**One choice made here, for you to agree:** `applies_to` writes each heading as
`file.heading`, because `outcome`, `source` and a few others appear in more than
one file. A note about a working column that feeds several headings names all
of them. For example, M2's "the day a stage ended" names `stages.date_ended`,
and also the four `bills` headings that show those days across and the two
`days_between_stages` headings measured from them.

## 4. `sources`

| Heading | Proposed |
|---|---|
| `applies_to_file` | The file holding the fact this line is about: bills, stages or sessions. |
| `bill_number` | The bill the fact is about. Empty for a fact about a session. |
| `stage` | For a fact about a stage, which stage. |
| `session` | The session the fact belongs to: the bill's session, or the session itself. |
| `applies_to_heading` | The heading the fact sits under, in that file. |
| `source` | Where this one fact came from. |
| `where_in_the_source` | The exact place within it: a page's address, or which fact sheet and page. |
| `value_as_the_source_gave_it` | The source's own words, where they say something the cell does not. Empty where the cell already says it, or where the fact is our coding. For an outcome read from the Official Report, the passages it printed, joined by " … ". |
| `date_source_read` | The day we read it. |
| `note` | What we did with the fact, in our words: how it was checked, or why it is coded as it is. |

**One choice made here:** `session` is filled on every line, not only the
fourteen about a session, so a reader can filter the file by session.

## 5. `what_the_words_mean`

| Heading | Proposed |
|---|---|
| `heading` | A heading whose cells hold a word from a fixed list. |
| `value` | One of the words that can appear under it. |
| `what_it_means` | What that word means. |
| `order` | Where the word comes in its list, for sorting. |

**Two choices made here:**

- **A heading that answers Yes or No is not listed.** Six headings hold Yes or
  No (`got_through`, `bill_ended_here`, `stage_never_happened`,
  `is_the_current_session`, `got_through_the_later_stage`, `bill_passed`); each
  one's description already says what Yes means.
- **A heading lists only the words it can hold.** `first_stage` lists Stage 1
  and Preliminary Stage, not all nine stage names. `measured_from` adds
  Introduction and `measured_to` adds Royal Assent. It comes to 89 lines.

## 6. `what_changed`

| Heading | Proposed |
|---|---|
| `date_copy_taken` | The day of the copy in which the value changed. |
| `file` | The file the cell is in. |
| `bill_number` | The bill whose line it is. |
| `stage` | For a cell in `stages`, which stage. |
| `heading` | The heading the cell is under. |
| `old_value` | What the cell said in the copy before. |
| `new_value` | What it says now. Empty if the cell is now empty. |

## 7. `about`

| Heading | Proposed |
|---|---|
| `date_copy_taken` | The day this copy of the data was taken. |
| `file` | Which file. |
| `rows` | How many lines it has. |
| `rows_added_since_last_copy` | How many lines were added since the copy before. Empty for the first copy. |

---

## 8. What "Government Bill" means under `bill_type_grouped`

`bill_type_grouped` holds four words, and three of them mean exactly what they
mean under `bill_type`, so they carry the same definitions word for word. The
fourth needs its own, because under this heading it includes the Hybrid Bill:

**Government Bill**, under `bill_type_grouped`: *Introduced by the Scottish
Government, counting the one Hybrid Bill, the Forth Crossing Bill of Session 3,
which the Scottish Government introduced. See methodology note M4.*
