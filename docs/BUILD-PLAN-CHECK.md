# The build plan, checked

For the owner, to read beside `PHASE-2.md`, "The build plan". 18 September
2026, by a session that did not write the plan. It was checked against
`PLAN.md`, every Phase 2 paper, `DECISIONS.md` from 16 September on,
`STANDING.md`, the published copy's closure test, and the database itself.
**Nothing in the plan has been changed.** Each finding comes with a proposal
that you can accept or strike.

**In short:** the shape holds. Every settled item has a home except those in
findings 6 and 9, and nothing is in the wrong strand except the part of strand
2 moved in finding 1. Two things are wrong as facts (findings 3 and 7). One
thing the plan treats as decided never was (finding 1), and it's the most
important. The size is low (finding 12).

---

## 1. Where a calculation lives, and where it runs, was never settled

**What the plan says.** Strand 2, item 5: the days between stages becomes "the
single file the refresh runs", and strand 3's calculations follow that
pattern.

**What is true.** Today the days between stages are worked out inside the
working data, by calculations built in `db/060` and `db/102`. The copy takes
the results over as they stand. Two settled rules pull different ways. On 17
September: a calculation a chart needs is "added in the same place" as the
existing ones, meaning the working data. Also on 17 September: a write-up's
calculation is written "as it will actually run against the published copy",
and the closing test re-runs every figure "from the calculation a reader
downloads". A reader has only the published files and the published
headings. `PHASE-2-MOCKUP-CALCULATIONS.md` says outright that this is "not yet
settled for the build". The plan picks an answer without saying it has.

**It is also in the wrong strand.** The days between stages is already a
published figure. The refresh in strand 1 has to re-run every figure (settled
17 September), but strand 1, item 5 doesn't list that check. As the plan
stands, strand 1 builds the refresh around today's calculation, and strand 2
then changes that calculation underneath it.

**Proposed.**
- **Put it to you as a decision of its own**, before the refresh is built. My
  recommendation: each calculation is one file that runs against the published
  copy's own files, under their published headings. The text a reader sees
  then runs on what a reader has. Any calculation in the working data that
  feeds nothing else is retired in the same change.
- **Move it into strand 1, before item 5.** It is a move, so it is proved the
  usual way: rebuild the days between stages from the new file and compare
  them cell by cell with today's 1657 lines before anything else changes.
- **Add "every figure re-run from its calculation" to item 5's checks.**

## 2. Strand 1, item 5 is also missing the zip's place

Settled on 17 September: the refresh's checks include "the download rebuilt
from the new copy". The plan puts that in strand 2, item 5. That is right, but
strand 1's "finished when" should then say the refresh is finished only for
the copy. **Proposed:** one line in strand 1 saying that the download and chart
checks are added to the refresh when those things exist. The plan already says
this in "The refresh grows with the strands", but the finished-when line
doesn't.

## 3. There are four kinds of source today, not two

**What the plan says.** Strand 1, item 2: "two kinds of source today: the
Parliament's, and our own work".

**What the database holds.** The provenance notes cite legislation.gov.uk on
53 lines (28 addresses), and the Supreme Court on 1. legislation.gov.uk
publishes under the Open Government Licence, which is The National Archives'
and not the Parliament's (R2). The Supreme Court was added as a source on 17
September, after R2 was written, and nobody has read its terms. "Two kinds,
not three" in `DECISIONS.md` was about the PhD dataset counting as the
Parliament's. It was never about the whole list.

**Proposed.** Item 2 records four: the Scottish Parliament, legislation.gov.uk,
the Supreme Court, and our own work. The Supreme Court's terms are read and
kept in `sources/licences/` as part of item 2.

## 4. The record of each source's terms is bigger than the plan sizes it

The site can read only the copy. So the record of terms has to cross into the
copy, or the sources page and the zip have nothing to be built from. That
changes the copy's shape: a new file or new headings, their descriptions, the
copy's own check, the data dictionary, and your rider that what crosses is
decided again for each addition. If the record is new in the working data too,
it is a new table, and that is an addition you agree first. Either way it
falls under the rule that a change to how data is coded is laid out whole and
agreed before anything is built.

**Proposed.** Item 2 is brought to you with every part laid out, as the
`db/104` change was. It counts as one to two sessions on its own, not a share
of "one to two" with the wording.

## 5. Three of the cited pages can't be fetched by a session

The 70 pages without a kept copy are right: 30 Official Report addresses, 28
on legislation.gov.uk (29 references, one with no address), and 11 bill
pages. But three of the bill pages are on the old site's archive
(`webarchive.nrscotland.gov.uk`), which sits behind a browser check that
scripted reading cannot pass (R2, §4). That affects two things: keeping those
three pages, and the refresh checking every cited address.

**Proposed.** Item 3 asks your permission to read those three through your
browser, as was done for the 2017 licence. Item 5's address check reports an
address it cannot check as "not checked", and never fails a refresh or passes
one because of it.

## 6. Strand 2 has no pages for what every data page points to

Settled, and missing from strand 2:
- **the sources page**, which is built from the record of terms (17 September,
  the licence);
- **the list of what changed**, which a page links to for a reader arriving by
  a shared link (17 September, showing the working);
- **the methodology notes**, which every page names and a reader has to be
  able to open;
- **what the words mean**, the definitions, which the table's cells use.

The shared page parts in item 2 name the notes and credit the sources, but
there is no page for either to link to.

**Proposed.** A new item in strand 2 between items 2 and 3: the reference
pages (notes, sources, definitions, what changed), each read from the copy.
The table then links into them.

## 7. Strand 1, item 1 names the wrong item

"Item 10 is the owner's look in Postico." In the copy's closure test, item 10
is the days check, and it passed. Your look is item 15, and you gave it on 18
September. The look that is still outstanding is item 10 of the "In progress"
test (`db/118`). **Proposed:** "the copy's item 12, from 19 September, and
`db/118`'s item 10, your look in Postico."

## 8. Two "finished when" lines can't be tested for what was settled

Strand 2's line ("sign in, go through the bills, download the lot, a signed-out
visitor sees none of it") is true of a site that breaks half of what was
settled. Strand 3's line names six things out of about a dozen. The closing
test is written from these lines, so whatever they leave out, it will leave
out too.

**Proposed.** Each line becomes a checklist of what was settled:
- **Strand 2:** the codebook generated from the copy's descriptions; no name
  or account in the zip's address or files, with the privacy check run
  afterwards; the sources credited, and the date and the date statement, on
  every data page; the link to the list of changes; the format-request link,
  with its line on the privacy page; the readme's row counts. And the house
  style test, which has no pass mark as written. Proposed pass mark: you read
  the deployed table and say whether the style holds, and it is recorded.
- **Strand 3, for each chart:** the rule in one sentence; the notes; the
  sources; the date inside the frame and inside a saved image; the
  one-sentence description; a table beneath with every number the chart
  shows; the CSV beneath (numbers, sources, date, the page's address); the
  calculation folded away, and the check that it matches the one that ran;
  every figure reaching its bills; and the palette check recorded once.

## 9. Where a chart's figures and calculation go

Settled: the zip carries "the calculations as text", and the closing test
re-runs each figure "from the calculation a reader downloads". Strand 3 stores
each chart's figures in the copy and shows the calculation on the page. It
doesn't say that the calculation joins the zip, or that each chart's figures
change the copy's shape (a new file, its descriptions, the copy's check).

**Proposed.** Each chart's calculation is added to the zip when the chart is
built. Its figures are a file in the copy with descriptions, like the days
between stages. Whether those figures go in the zip too is yours to say. My
recommendation is no: the CSV beneath each chart already does that job.

## 10. Two of the three questions answer themselves under the plan's own rule

The plan's rule is that a strand doesn't open until every item in the one
before is built, and that a session's work comes only from the open strand.
- **Question 2** (are the kept pages a precondition for strand 2?) is already
  answered yes, because they are in strand 1. The real question is whether
  they belong there. **Proposed:** ask it that way. I'd keep them in strand 1,
  for the plan's own reason.
- **Question 1** (do the chart write-ups wait for strand 3?) is also answered
  already. What is worth asking is only your exception, that you can iterate a
  mock-up whenever you choose. **Proposed:** keep the question just to
  confirm that.
- **Question 3** (chart numbering) stands.

## 11. Things that need placing, or have gone stale

- **`STANDING.md`, "Publishing the bills as files rather than a database the
  site reads"**, says it reopens when the copy is built. The copy was built on
  18 September as a workbook of its own, by your decision. Proposed: the entry
  is closed when the plan is agreed, pointing to that decision.
- **From "Waiting for you":** the Forth Crossing Bill's dropdown goes in strand
  3, with the write-ups for thoughts 2 and 3. The sign-in-unavailable wording
  goes in strand 1, item 4, with the other public wording. The unpruned site
  releases go with strand 2's first deploy, since each deploy adds one.
- **"Block 3" and "block 4"** in `PUBLISHED-COPY-RUNBOOK.md` and
  `CLOSURE-TESTS.md` are the old order's numbers. Proposed: when the plan is
  agreed, each gets a one-line pointer to its strand item. They are not
  rewritten.

## 12. The size is low

"About twenty" leaves out findings 1, 4 and 6: roughly one session each. It
also leaves out the owner-reading sessions for the readme and the wording.
Strand 3's eight to twelve works only if each session runs the previous
chart's closure test and then builds the next chart. That fits the rules, but
the plan should say so, because otherwise six charts with a test each come to
at least twelve on their own.

**Proposed:** strand 1, six to eight; strand 2, six to eight; strand 3, ten to
twelve, with the chaining written in; the closing test, one or two. **About
twenty-five in all.**
