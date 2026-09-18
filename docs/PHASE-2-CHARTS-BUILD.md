# How the mock-ups become real charts on the site

For the owner. Written 17 September 2026 as a proposal; **the owner agreed all
eight points the same day**, and this is now the plan the build follows.

The six mock-ups on https://claude.ai/artifact/XkH7LGSDzhFSo6FTYaxZx9 are
pictures with real figures, on a page that talks to nothing. This says what has
to exist for them to become pages on legislativedata.org, what the database has
to gain, in what order, and where one session hands over to the next.

The draft calculations behind the mock-ups are in
`docs/PHASE-2-MOCKUP-CALCULATIONS.md`; the open points on each chart are in
`docs/PHASE-2-CHARTS-THOUGHTS.md`.

**What is agreed here is the shape.** Three of the items below change how
something is coded or what a note says, and each still gets its own full
checklist, with every part proposed, before it is built.

---

## The short version

**One thing blocks all six: the published copy does not exist yet.** The site
cannot see the working database — settled 15 September and proved with a check
— so every chart page reads from a copy that has still to be built. Nothing
visible happens until it is there.

**Once it is there, the six charts are mostly the same job six times.** What
they share — the page furniture, the charting library on the machine, dark and
light, the route from a figure to the bills behind it — is built once, with the
first chart.

**The figures are not a lot of data.** Every figure, for every choice a reader
can make, across all six charts, comes to roughly three thousand lines. The
worry recorded on 17 September, that the choices might multiply past what can
sensibly be worked out in advance, does not bite.

---

## The site's shape, settled by the owner

**Two sections, with links in the header, both behind the sign-in.**

- **Data** — where a reader downloads the dataset, and reads the same data on
  screen as a table of every bill. The table opens the section; the downloads
  land on the same page when they are built, being a separate piece of work
  (`PHASE-2.md`, groundwork 2).
- **Insights** — our charts and tables. Each chart carries a file of its own
  figures to download, with its sources and date, as settled on 17 September.
  The full dataset stays on Data.

**The owner's reason for the name:** the charts and tables are what provides
insight into the raw data. Considered and rejected: "Charts", "Findings".

---

## The eight, as agreed

1. **The published copy is built first, before any chart.** To exactly what was
   settled on 17 September and no more. There is no version where a chart goes
   live first: the site is not permitted to open the working database, and that
   decision exists so nothing unpublished can reach a page.

2. **Its headings are chosen before any chart calculation is written**, and the
   methodology notes are rewritten in those headings at the same time. Both go
   to the owner: a list of headings, and every changed note in full. Otherwise
   six calculations get written twice.

3. **Every figure, for every choice, is worked out when the copy is taken**, and
   stored finished. Confirmed now that it has been sized: about three thousand
   lines in all — 720 for thought 2, 480 for thought 4, 670 for thought 5, 250
   for thought 6, a handful for thought 1. The sizing is recorded here so it is
   not re-asked at every chart.

4. **The table of every bill is built straight after the first chart**, as the
   opening of the Data section and the place a figure's "show me the bills"
   arrives. Not last: otherwise every chart before it ships with a promise it
   cannot keep. It is also where the house style is tested (settled
   17 September).

5. **The charting library is served from the machine**, pinned to one version,
   like the fonts, so a reader's browser contacts nobody else. About 1.1 MB.
   Done once, with the first chart; the deploy's written undo covers it.

6. **The mock-ups' palettes become the site's**, subject to one check. Three of
   them: the outcomes, the quarters (one colour light to dark, quarters being in
   order) and the sessions. The colour rule requires them to be readable with
   colour-blindness and in dark and light; that check has not been run, and the
   outcome palette is still described as a first attempt. **The check is run
   once**, anything failing it is adjusted and shown to the owner, and the
   result is recorded so charts two to six do not each reopen it.

7. **Three small items are cleared before the first chart.** Each still gets its
   own checklist before it is built.
   - **The tie in the order of outcomes.** "Fell: financial resolution not
     agreed" and "In progress" both sit at 7, so nothing fixes which comes first
     in a stacked bar or a table. **Agreed: "In progress" moves to the end,**
     being not an ending at all; the rest stay as they are.
   - **The quarter boundary rule.** A bill introduced on the day a quarter
     begins counts in that quarter, the later one. **Agreed.** No bill falls on
     a boundary today, so nothing moves. **Done 18 September**
     (`docs/BLOCK-2-QUARTER-BOUNDARY.md`): a quarter begins at the first whole
     day inside it; written in `docs/PHASE-2-CALCULATIONS.md`, chart 5.
   - **M9 and M10.** Both were checked correct on 17 September and left as they
     were. **Agreed: M9 is left alone; M10's account of how its own rule came
     about is cut, to match the notes rewritten that day**, with the new wording
     to the owner in full. Thoughts 4 and 6 both name these notes, and no note
     is published with an open question against it.

8. **The order of the six, and where sessions hand over.** Below.

---

## The one thing everything waits on

**The published copy**, settled on 17 September and not yet built. In the
owner's terms: a second workbook, holding only what is published, that the site
is allowed to open — where the working one, with its staging sheets and the
introducers' names, stays shut to it.

What it holds was settled: the bills with their stage dates across, the stages,
the days between them, the session dates, the methodology notes, the provenance
and each fact's source, and what every code means in words. Two things the
working database does not have: the day the copy was taken, and a list of what
changed since the last one.

It is its own piece of work, with a written procedure, a rehearsal and an undo,
and it is checked cell by cell against the working database before it goes
anywhere near the site. That check is the point of it, not a formality: it is
the same discipline as proving a move before adding.

---

## What every chart needs, built once

Built with the first chart, then reused.

1. **The page furniture.** The date the data was taken, inside the chart's own
   frame; a one-sentence description for a reader who cannot see it; the rule in
   plain English; the methodology notes it rests on; the sources; the figures as
   a table beneath; a file of those figures to download; and the calculation
   itself, folded away until asked for. All settled in groundwork 4. One
   template.
2. **The calculation shown is the calculation that ran.** Each figure's
   calculation lives in one file, the refresh runs it, the page shows that
   file's words, and a check proves the two identical at every refresh.
3. **The charting library on the machine**, pinned, served like the fonts.
4. **Dark and light.** The site is dark by default with light as a setting. The
   mock-ups follow the reader's computer instead, which is not the same thing.
   The charts are handed the site's setting and redrawn when it changes.
5. **The route from a figure to its bills** — the table of every bill, filtered.
   Every calculation hands back the bills it counted, not only the number.
6. **Behind the sign-in**, with the Data and Insights links in the header.
7. **The refresh.** Rebuild the copy, work out every figure, rebuild the files
   to download, check, put it live with the old copy kept for the undo. One
   script, no step by hand.

---

## The order, and where a session hands over

Each block ends with something finished and checked.

1. **The published copy**, its headings, and the notes rewritten in them. The
   site does not read it yet.
2. **The three small items** from point 7. Can run alongside 1.
3. **The refresh**, written down, rehearsed, with its undo.
4. **The first chart** — thought 2, the outcomes chart — with everything shared
   built under it, and the Data and Insights links added. The first page the
   owner can look at.
5. **The table of every bill**, opening the Data section.
6. **Thought 3, the outcomes table**, beneath thought 2 and sharing its figures.
7. **Thought 1, the headline figures.**
8. **Thought 4, how long bills take.**
9. **Thought 6, the quickest and slowest.**
10. **Thought 5, when in a session bills were introduced** — last, because it
    brings the most new machinery: each bill's place in its session, the
    quarters, and the two statistical tests. It should not also be the chart
    that debugs the page template.

**Why thought 2 leads:** it is the one already accepted as a starting point and
its figures are the simplest.

**Roughly ten sessions** for all six live, the first three or four producing
nothing visible.

---

## What was checked on 17 September, before this was written

- **The figures are small**, as point 3 records.
- **The statistical tests need nothing added.** They use a function the database
  already has; the machine runs PostgreSQL 17.11.
  (`PHASE-2-MOCKUP-CALCULATIONS.md` says that function arrived in PostgreSQL 16;
  it was 17. The machine is past both, so nothing changes.)
- **The outcome tie is real**, as point 7 records.
- **One line in `PHASE-2-CHARTS-THOUGHTS.md` was out of date**: under "Noted for
  the second pass" it said charts are drawn on the machine as fixed images,
  which was changed later the same day to charts drawn in the reader's browser.
  Corrected.
