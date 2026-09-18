# The record of each source's terms

For the owner. Written 18 September 2026. Strand 1, item 3 of
`docs/PHASE-2.md`. Every part of the change is laid out here, with four
questions at the end.

**Agreed by the owner the same day**: Manual under the Scottish Parliament's
terms, and yes to questions 2 to 4; no to keeping the Parliament's copyright
page. **Built the same day** (`db/119`), the copy retaken. The closure test is
written and unrun. The record is at the end.

## The problem, for one bill

The UK Withdrawal from the European Union (Legal Continuity) (Scotland) Bill
(bill 305) is one line in the published bills file, with three lines in the
stages file. Its facts come from four kinds of source:

- the line itself, and its Stage 3, from the SPICe legislation factsheet;
- Stages 1 and 2 from the PhD dataset;
- the day it was stopped before Royal Assent from the Supreme Court's case page;
- its note, rewritten by us when Session 6 was reviewed ("Manual").

The factsheet and the PhD dataset come under the Scottish Parliament's
licence. The Supreme Court date comes under the Open Government Licence, with
the Court's own condition added. The note's words are ours, but its recorded
source is "Manual", and which terms that falls under is question 1. A reader
who takes this bill has to credit at least two sources, and today nothing in
the copy tells them so.

## What changes

**In the working database, one new tab and one new column.**

- **A new tab of four lines**, one per set of terms: the Scottish Parliament,
  legislation.gov.uk, the Supreme Court, and our own work. Each line says the
  licence, a link to it, the credit line the source asks for, the source's
  restrictions in its own words, the page where the terms are published, the
  day we read them, and the name of our kept copy of that page.
- **The list of kinds of source gets one column**: whose terms that kind
  comes under. It's a dropdown of the four, and it must be filled. That
  column makes "the statements follow each value's recorded source" work
  without anyone keeping a list of columns.

| Kind of source | Whose terms |
|---|---|
| SPICe legislation factsheet, SPICe dates factsheet, Official Report, Parliament's bill page, Parliament API, Bill document | Scottish Parliament |
| PhD dataset | Scottish Parliament (settled 17 September) |
| legislation.gov.uk | legislation.gov.uk |
| Supreme Court | Supreme Court |
| Manual | **question 1** |

**Our own work doesn't need a kind of source.** Anything that has no
recorded source is ours: our coding, our bill numbers, the notes, and the
worked-out figures. The rule a reader is given is: *everything is under CC BY
4.0, except a value whose source is one of the others, which stays under that
source's terms.* No list of columns is needed.

**In the published copy, an eleventh file, `terms`**, with four lines
matching the tab. Its `covers` cell lists the source names a reader sees in
the `source` columns, so a reader holding "Supreme Court" can find its line.
`about` gets a line for it.

## The four lines, in full

Every cell is shown here as a reader would get it. The credit lines and
restrictions for the three outside sources are their own words, copied, not
ours. Each page was read today.

**Scottish Parliament**
- covers: SPICe legislation factsheet; SPICe dates factsheet; Official Report;
  Parliament's bill page; Parliament API; Bill document; PhD dataset
  (plus Manual, if question 1 says so)
- licence: Scottish Parliament Copyright Licence
- licence link: https://www.parliament.scot/about/copyright
- credit line: *Contains information licensed under the Scottish Parliament
  Copyright Licence*
- restrictions: *This licence does not grant you any right to use the
  information in a way that suggests any official status or that the SPCB
  endorses you or your use of the information. This licence does not allow
  you to use published material provided in any format in connection with
  party political purposes or in connection with advertising endorsement.*
  (The broader of its two bans, as settled on 17 September.)
- terms page: https://www.parliament.scot/about/copyright (the licence and
  the terms are on one page)
- date terms read: 2026-09-18

**legislation.gov.uk**
- covers: legislation.gov.uk
- licence: Open Government Licence v3.0
- licence link: https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/
- credit line: *Contains public sector information licensed under the Open
  Government Licence v3.0.* (question 2)
- restrictions: *This licence does not grant you any right to use the
  Information in a way that suggests any official status or that the
  Information Provider and/or Licensor endorse you or your use of the
  Information.*
- terms page: https://www.legislation.gov.uk/help ("All content is available
  under the Open Government Licence v3.0 except where otherwise stated")
- date terms read: 2026-09-18

**Supreme Court**
- covers: Supreme Court
- licence: Open Government Licence v3.0
- licence link: as above
- credit line: *Contains public sector information licensed under the Open
  Government Licence v3.0.* The Court names no credit line of its own, so the
  licence's own line applies.
- restrictions: the licence's non-endorsement sentence, as above, and the
  Court's own condition: *provided it is reproduced accurately and not in a
  misleading context.*
- terms page: https://www.supremecourt.uk/about/terms-and-conditions
- date terms read: 2026-09-18

**Our own work**
- covers: everything without a source named above: our coding, our bill
  numbers, the notes, and the worked-out figures
- licence: Creative Commons Attribution 4.0 International (CC BY 4.0)
- licence link: https://creativecommons.org/licenses/by/4.0/
- credit line: **question 3**
- restrictions: none
- date terms read: empty

## Every part of the change

**1. What it records, and what empty means.** One line per set of terms.
Every cell is filled except `terms page` and `date terms read` for our own
work. In the list of
kinds of source, the new column is never empty.

**2. Which bills it applies to.** All of them, through the source recorded on
each fact. No bill's data changes.

**3. How it arrives.** Typed in once, by a numbered change to the database
(`db/119`), like the other dropdown lists. It doesn't come through the
staging sheet: it's about sources, not bills.

**4. How it reaches the copy, and the copy's check.** The copy's build brings
the four lines across, with the source names in `covers` worked out from the
new column. The check does two new things:
- compares every cell of `terms` with the working tab, as it does for every
  other file;
- **refuses to build if any source name used in `bills`, `stages` or
  `sources` isn't covered by exactly one line.** That is what makes "no
  source's data is published until its terms are written down" a rule the
  machine enforces rather than a promise.

A rehearsal plants both faults: a kind of source with no terms, and a changed
credit line. The build has to name each one.

**5. The kept copies.** The Supreme Court's terms were read today and are kept
in `sources/licences/`, as agreed. **Proposed:** keep today's Scottish
Parliament copyright page and the Open Government Licence there too, so each
line's kept copy is from the day it was read. The existing 2017 copy stays as
the record it is. The kept-copy file name is held in the working tab only;
how kept copies reach a reader is item 4's question.

**6. The error checker and the methodology notes.** Nothing new for the
checker: the column is required, and the copy's check does the rest. No
methodology note, because the terms are not about how bills are coded. The
statements a reader sees are item 5.

**7. What is rechecked.** Every one of the ten kinds of source gets its terms.
Every source name in today's copy (seven are in use) is covered. The other ten
files are retaken and compared cell by cell with today's: they must be
identical except for `about`, which gains one line.

**8. Descriptions** (public wording, for question 4):
- the file: *"The terms each source's data is published under, and how to
  credit it. A value whose source is listed under covers is under that line's
  terms; everything else is our own work."*
- `terms_for`: *"Whose terms these are."*
- `covers`: *"The source names, as the source headings give them, that these
  terms cover."*
- `licence`: *"The licence the data is under."*
- `licence_link`: *"Where the licence is published."*
- `credit_line`: *"The words to use when crediting this source, as the source
  gives them."*
- `restrictions`: *"What the source does not allow, in its own words."*
- `terms_page`: *"The page where the source publishes its terms. Empty for
  our own work."*
- `date_terms_read`: *"The day we read those terms. Empty for our own work."*

**9. The undo.** A matching undo file removes the tab and the column; the
copy is retaken without `terms`. Nothing on the site reads the copy yet.

**10. The papers.** The copy's runbook, `HOW-THE-DATABASE-WORKS.md` and
`STATE.md` are updated, and the data dictionary is regenerated. This session
writes a closure test and a different session runs it.

**11. When.** The next session, or this one if there is time once you've
answered. One change to the database, and one retake of the copy.

## Four questions

**1. Whose terms is "Manual" under?** Five facts rest on it. One is the
Criminal Procedure (Amendment) Act's title, corrected where the factsheet
misprinted it. One is a bill's introduction date, from your own record,
because the Parliament's page for it can't be read. Three are notes we
rewrote at Session 6's review. **Proposed: the Scottish Parliament.** The
first two are Parliament facts, and crediting the Parliament for words we
wrote costs nothing. Putting our licence on a Parliament fact is the thing
ruled out on 17 September.

**2. legislation.gov.uk's credit line.** Its own contributors page suggests
*"Crown © and database right material re-used under the Open Government
Licence"*, but only for UK law that came from the EU. It gives nothing for
Acts of the Scottish Parliament. The licence says that where the provider
gives no line, you use the licence's own. **Proposed: the licence's own
line**, as above.

**3. The credit line for our own work.** This is public wording, and the
suggested citation belongs with the download in strand 2. **Proposed**, for
now: *"Contains data from legislativedata.org, licensed under CC BY 4.0.
Stage 1 and Stage 2 dates compiled for Steven MacGregor, 'Does government
dominate the legislative process?' (PhD thesis, University of Stirling,
2021)."* The second sentence is the thesis credit settled on 17 September.

**4. The descriptions in part 8, and the file name `terms`.** As drafted?

Also yes or no: **keep the Parliament's page and the licence** (part 5).

## What was done, 18 September

- **`db/119`** adds the four lines and the column, with a description on
  each; the copy's connector and Postico can read them. Rehearsed inside a
  thrown-away transaction, with its undo; a second run and a second undo each
  refuse. Then applied.
- **Three choices made at the build**, none changing what was agreed:
  - the fourth line's name is "legislativedata.org", which says whose it is
    to a reader holding the file on its own;
  - the Supreme Court's restriction quotes the Court's whole sentence
    ("You may use and re-use Crown copyright material from this website …
    provided it is reproduced accurately and not in a misleading context"),
    because the fragment shown above cut its words;
  - no kept-copy column, since only the Supreme Court's terms are kept.
- **The copy**: the build gains the `terms` file and check 11. Rehearsed
  with the live copy set aside: a changed credit line, the Supreme Court taken
  out of its covers, a wrong day and a wrong outcome were each refused and
  named, and a clean run passed. Then taken, and compared with the old copy
  cell by cell: the ten existing files identical, line for line and in order,
  and their descriptions unchanged; `about` differs only by the new file's
  line and its own count. The old copy was then dropped.
- **Not kept**: today's Parliament copyright page and the Open Government
  Licence text, as the owner said.
