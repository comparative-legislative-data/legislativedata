# Thought 2's page: the build, its test and its undo

For the owner, 19 September 2026. Strand 3, step 3, second half
(`docs/STRAND-3-PLAN.md`), built to the agreed write-up,
`docs/STRAND-3-THOUGHT-2.md`, and the whole-page mock-up
(https://claude.ai/artifact/XMz3FuH4zQnmNSwfM9WQVq). The figures are built
already (`docs/STRAND-3-THOUGHT-2-FIGURES-BUILD.md`).

**Not yet agreed.** The palette check comes first, then points A to F.
Nothing is built until all of it is agreed.

---

## The palette check

Run once, for all six charts, with the checker the dataviz guidance
provides: colour-blindness (red-green of both kinds, and blue-yellow),
dark and light, and each colour against the page behind it.

**What failed**, and the colours proposed to fix it, are on a copy of the
whole-page mock-up, with a switch between the approved and the adjusted
colours and a way to see either as a colour-blind reader would:
https://claude.ai/artifact/C92BifSandiEYXCyAL58pq

| Palette | Dark | Light |
|---|---|---|
| Outcomes, full breakdown | **fails**: Withdrawn and Rejected at Stage 1 alike to red-green colour-blindness | **fails**: Withdrawn and Fell at dissolution almost identical to red-green colour-blindness; Passed and In progress too pale against the page |
| Outcomes, passed or not | passes | passes once In progress is darkened; Not passed then made deeper to stay apart from it |
| Quarters (thought 5) | passes | **fails**: the first quarter too pale against the page |
| Sessions (thought 5) | passes | passes |

Two of the checker's tests are not applied: that every colour sits in a
middle band of lightness, and that none reads as grey. They are the
guidance's house style, and the greys here are deliberate: Fell at
dissolution and In progress are not decisions of the Parliament.

**The adjusted colours**, which pass every test that is applied:

| Outcome | Dark, now → proposed | Light, now → proposed |
|---|---|---|
| Passed | `#e6a532` → `#e8aa2b` | `#d9920b` → `#d77508` |
| Rejected at Stage 1 | `#d07aac` → `#f780b8` | `#b8558f` → `#a32189` |
| Rejected at Stage 3 | `#a184cc` → `#9a7ed9` | `#7a5aa6` → `#7967be` |
| Withdrawn | `#2fb08c` → `#33ae85` | `#0f8a6a` → `#1a835e` |
| Fell at dissolution | `#8a8279` → `#7d7a7a` | `#7c776f` → `#484943` |
| Fell: financial resolution not agreed | `#b8804a` → `#cb711e` | `#8b5a2b` → `#925700` |
| In progress | `#ddd4c8` → `#d8d5cb` | `#d9d0c4` → `#8f8f8f` |
| Not passed | unchanged, `#9c96cf` | `#6e6a96` → `#5f55a8` |

Quarters, light: `#a9d6cc #62b2a2 #2b8676 #135a4e` → `#78bcae #4a9f8c
#25806e #135a4e`.

**Worst pair after the change**, as the checker measures it (8 is its
target for colour-blindness, 15 for full colour vision): full breakdown,
dark 8.7 and 15.1; light 8.5 and 15.2.

**Proposed:** the adjusted colours become the site's chart colours, and
this section is the record, so charts three to six do not reopen it.

---

## A. The route from a figure to its bills

Clicking a part of a bar, or a figure in the table of numbers, goes to the
Data page's table of every bill, showing exactly the bills the figure
counts, taken from the figure's line in the copy. Above the table, in
place of the count:

> The 62 bills behind: Session 5 · Government Bills · Passed

with " · Forth Crossing Bill shown as a Hybrid Bill" added when that is the
choice, and a link, **Show all bills**. The address says which figure, so
it can be shared and bookmarked, and Back returns to the chart. A bill
opens from there as it does now.

Two figures in the table of numbers have no list of bills of their own in
the copy:
- **"Bills"**, the bills of a type introduced in a session: its bills are
  the lists of that session and type's outcomes, taken together.
- **"of which became Acts"**: the Passed line's bills, narrowed to those
  whose `enactment_status` is Enacted in the bills file.

**Proposed:** both open as above, labelled "… · Bills introduced" and
"… · Passed and became Acts". The mock-up opens both, so nothing is lost.

## B. The CSV

Beneath the chart, **Download these figures (CSV)** hands over the copy's
file, all 720 lines, with three headings added at the end: `sources`
(as the frame names them), `date_copy_taken`, and `chart_address`. Its
name: `legislativedata-outcomes_by_session_and_type-2026-09-19.csv`, the
date being the copy's. Behind the sign-in, like the zip.

## C. ECharts on the machine

Version **6.1.0**, the one the mock-ups use, served from the site's own
files as the fonts are, with its licence (Apache 2.0) beside it. Nothing
is fetched from anywhere else. Drawn as SVG, as on the mock-up.

## D. What the page shows until thoughts 1 and 3 are built

The headline figures (thought 1) and the outcomes table (thought 3) come
later. Until then: no "At a glance" box, one tab (Outcomes), and the
tab's line leaves out "and the table" until it is there. A tab appears
only once its charts are built (plan, A).

## E. The page's own wording, in full

**Proposed.** The mock-up's words, which were marked draft:

> INSIGHTS
>
> # Insights                                  Data as at 19 September 2026
>
> Accurate as at that date. A record it was taken from may since have been
> corrected, and earlier versions are not kept.
>
> Charts drawn from the same data as the Data page. Every figure opens to
> the bills behind it, and every chart shows the working that produced it.
>
> **Explore the charts**
>
> **Outcomes** — How bills ended, by session and type

"and tables" is added to the second paragraph with thought 3. The date line
and date statement are the Data page's own, agreed on 18 September. Beneath
the chart, **Sources and licence**, as on the Data page, with the lines for
the Scottish Parliament, legislation.gov.uk and our own: the terms the
chart's figures draw on.

The methodology notes each link to the note, opened, on the Data page,
with its title shown on hovering.

## F. The order it goes live in, and the undo

The site is deployed first. **The new site shows the chart only when the
copy holds its figures**, and otherwise the page as it is today. So:

1. **Deploy the site**, rehearsed on its own port first. Readers see no
   change: today's copy has no figures.
2. **Take the refresh**: a look, then `--save` at your word. The chart
   appears with the copy.

**The undo**, each step on its own: the refresh's undo puts the copy
before back, and the chart goes with it; the deploy's undo puts the
site before back.

## How it is tested before it is trusted

**Rehearsal, on a scratch copy** taken with the figures:
- the staged site draws the chart in dark and light, for all four
  choices, in the Outcomes tab, and every chart and dropdown has its own
  name (the plan's lesson from the blank chart);
- clicking every part of every bar and every figure in the table opens a
  list whose length is the figure; checked by a script against the file,
  not by eye;
- the CSV holds the file's 720 lines exactly, with the three headings;
- the working shown on the page is the copy's `workings` text, character
  for character;
- the page with today's copy, which has no figures, is the page as it is
  now;
- the checklist's thought 2 items, one by one.

**Live, after each step:** the same checks against the live site;
`002_check_as_the_site.sh` (thirteen files) and strand 2's checker.

**Then its closure test is written** for another session to run.
