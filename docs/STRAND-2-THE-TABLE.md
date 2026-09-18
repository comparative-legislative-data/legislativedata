# The table of every bill

For the owner. Written 18 September 2026. Strand 2, item 4 of
`docs/PHASE-2.md`: the write-up, before anything is drawn. Five questions at
the end. **Agreed by the owner the same day: yes to all five.** The words
are in `docs/wording/PUBLISHING.md`, part 8.

Already settled, and not asked again: the table is on the Data page, behind
the sign-in, as the place a reader arrives from a chart and as the house
style's test (17 September); a reader can go from a bill to its provenance
notes; where a cited address has gone, the page says so and names the kept
copy by title and date; a page for each bill waits; charts' switches are not
the table's, and anything more is the playground's.

## What happens, for one bill

A reader wants the Legal Continuity Bill. On the Data page they choose
Session 5 and type "continuity"; the table narrows to two lines, the Legal
Continuity Bill of 2018 and the Continuity Act of 2021, and says "Showing 2
of 470 bills."

Each line gives the bill's number, session, title, type, the day it was
introduced, its outcome, and the day it became an Act. The 2018 bill reads
*Passed*, with no Royal Assent date.

They open it. Everything the bills file holds about it is there, heading by
heading: Not enacted; stopped before assent on 13 December 2018, by a
section 33 reference to the Supreme Court; withdrawn after being blocked, on
10 March 2022; its note. Then its three stages, each with the day it ended and where that
date came from: Stages 1 and 2 from the PhD dataset, row 331; Stage 3 from
the Session 5 factsheet.

Then **where each fact came from**: the six provenance lines about this
bill. The stopping date, from the Supreme Court's case page, read on 17
September, with its address as a link. The withdrawal and the change to
Not enacted, from the Session 6 factsheet, with our note on why it lists
the bill again. The rewritten note, with what it said before.

Beside `outcome` and `enactment_status` sit the codes of the methodology
notes that bear on them, each a link into the notes section. The bill has
its own link, `/data#bill-305`, so it can be cited or shared.

## The table

**Seven columns**, from the bills file, in its order: `bill_number`,
`session`, `title`, `bill_type`, `date_introduced`, `outcome`,
`date_royal_assent`. These answer "which bill, when, and what happened",
which is what a reader scanning 470 lines needs. Everything else is one
click away, in the opened line. Titles run to 108 characters, so the title
column takes the width and wraps.

**One line per bill, all 470 on one page**, in bill number order. No pages to
click through: 470 lines is one scroll, and the browser's own find works on
all of them. About 1 MB of page, a tenth of that sent over the wire.

**A bill with a note** (ten have one) shows the word *note* after its title,
so the irregular ones can be seen without opening every line.

**On a phone**, the table keeps the number, title and outcome; the other
columns are in the opened line.

## How a reader narrows it

**Three dropdowns and a title search**: session (1 to 7), type (the five
types), outcome (the seven outcomes, in the copy's order), and a box for
words in the title. The lists come from the copy, so a new outcome appears
without anyone editing the page.

**Every choice is written into the page's address**
(`/data?session=5&title=continuity`), so a narrowed table can be bookmarked,
shared, or cited, and it works with JavaScript switched off. This is also
how a chart hands over its bills later: its "show me the bills" is an
address. What shapes a chart's address takes (a quarter, a stage reached)
is settled in each chart's write-up, not built now.

**A line above the table** always says how many are shown: "Showing 17 of
470 bills."

**Not built, named here as the playground's**: sorting by clicking a column,
choosing which columns show, narrowing by date range, and more than one
value per dropdown. Each is reasonable; each is a reader building their own
table, which this phase does not take on.

## From a bill to where it came from

The opened line has three parts, in this order.

1. **The bill.** Every heading of its line in the bills file, in the file's
   order, all 34, with an empty cell shown as a dash. Where a methodology
   note applies to a heading (from the notes' own "Applies to"), its code
   sits beside it as a link. The line's own source, place and date read
   last.
2. **Its stages.** One line per stage it reached, from the stages file: the
   stage's name, the day it ended, whether it got through, and its source
   and place. Where a stage has no date, the copy's own sentence saying why.
3. **Where each fact came from.** Its lines from the sources file (94 bills
   have at least one, eight at most): the heading it is about, the source,
   the place in the source, the day read, the source's own words where they
   differ from the cell, and our note. An address is a link. Where the copy
   records an address as gone, the line says so and names our kept copy
   and the day we kept it.

**Not in the opened line**: the days between stages, which are worked out,
and belong to the charts and the download; and the sessions' own sources,
which are not about a bill, and go in the download.

## New words a reader would see, in full

The Data page's opening sentence, replacing "The table of every bill, and
the whole dataset to download, are being built.":

> Every bill introduced in the Scottish Parliament since 1999, one line
> each. Open a bill to see everything recorded about it, and where each
> fact came from. The whole dataset, to download, is being built.

Above the dropdowns:

> Session · Type · Outcome · Title contains

The two actions, as text links:

> Show · Clear

The count, in its three forms:

> Showing all 470 bills.
>
> Showing 17 of 470 bills.
>
> No bill matches these choices. Clear them to see every bill.

In an opened bill, the three part headings:

> The bill
>
> Its stages
>
> Where each fact came from

A bill with no lines in the sources file (376 of them):

> Every fact about this bill is from the source named on its line.

An address that has gone (none today; 92 work, 14 are the old site's
archive and cannot be checked by a program):

> This address no longer works. We kept a copy of the page on [the day we
> kept it]: [the kept copy's name].

The bill's own link:

> Link to this bill

## What it cannot say

It shows the bills file as the copy holds it, and nothing worked out. It
does not say why a value is what it is beyond the provenance lines and the
notes. It shows no earlier version of a value: What has changed does that,
from the first refresh on. An address marked as working was working on the
day the copy was taken.

## The test, and the undo

Laid out in full with the build, before anything is deployed, as for items
2 and 3: `tools/check_data_pages.py` extended so that every line of the table
and every opened bill is compared with the copy, all 470; the dropdowns and
title search tried, including words a reader should not be able to slip
into the address; signed out, none of it shown; the undo, one rollback,
rehearsed. Its closure test written by the session that builds it, run by
another.

**The house style is judged on it**: once it is live, you read the deployed
table and say whether the style holds, and that is recorded (strand 2's
"finished when").

## Questions

1. **The seven columns**: number, session, title, type, introduced,
   outcome, Royal Assent. Agree, or say which to swap. **Recommend yes.**
2. **Column headings as the files name them** (`date_introduced`), not
   plain labels ("Introduced"). One name for one thing, whether a reader is
   on the page, in the CSV, or in a methodology note's "Applies to"; it
   reads as code, which is the cost. **Recommend the files' names.**
3. **Narrowing by session, type, outcome and title words**, written into
   the address, and nothing more. **Recommend yes.**
4. **A fifth reference section, "What each heading holds"**: every heading
   of every file with its one-line description, read from the copy, the
   same descriptions the download's codebook is generated from. Without it
   a reader on the page sees `sp_bill_number` or an empty cell and has
   nowhere to learn what it means; the table's headings would link to it.
   It adds to item 3, which is closed, so it is yours. **Recommend yes.**
5. **The words above.** Agree, or amend.

Once these are settled, a mock-up with the real rows comes next, before the
build: the table, one bill opened, and a phone's width.

## After the mock-up, 18 September

The owner read the first mock-up
(https://claude.ai/artifact/TtKMN9rdGhtjxzXgbZP845) and found the page would
overwhelm. A second version put a bill in a pop-up and the page in tabs. **The
owner: "Much better", and happy with the new layout.** Settled:

1. **A bill opens in a pop-up**, not beneath its line. It keeps its own
   address, `/data#bill-305`; its number, session and title stay at its top
   while it scrolls; on a phone it fills the screen. Closing it leaves the
   list where it was.
2. **The Data page is in tabs**: Bills · Methodology notes · Sources and
   terms of use · What each heading holds · What the words mean · What has
   changed. The date and the date statement sit above them; the credit lines
   and the footer below, under every tab. Every link into a section keeps its
   address and opens its tab.
3. **The date statement drops "See what has changed."**
   (`PUBLISHING.md`, part 2), on every page. The tab, and the footer's link
   on every page, do that job.
4. **The download goes at the top of the Data page**, above the tabs, so a
   reader finds it at once. Recorded for item 5.

**What this does to items 2 and 3, closed earlier the same day.** Their
reference sections become tabs, and the date statement changes, so their
check and closure tests change with the build:
- `tools/check_data_pages.py`: the sections become tabs; the link from the
  date statement is gone; each address lands in its tab; the printing rule
  below.
- Items 2 and 3's closure tests are amended where they name sections or the
  link, and run again, by another session, with item 4's.
- The rest stands: every line still read from the copy, the same words.

**Put to the owner, and settled the same evening:**
- **Printing prints the tab that is open**, and an open bill prints on its
  own. This replaces "printing the Data page opens every section", agreed
  for items 2 and 3, which with the table would print hundreds of pages.
  **Yes.**
- **Without JavaScript**: proposed that every tab show one after another
  and a bill open beneath its line. **Not taken.** The owner: readers have
  the download and can do what they want with it, so the site need not be
  made to work every way. Without JavaScript a reader gets what falls out
  of building it plainly (the tabs' contents one after another, since the
  page hides them only once JavaScript runs) and no bill opens; nothing is
  built for it.

