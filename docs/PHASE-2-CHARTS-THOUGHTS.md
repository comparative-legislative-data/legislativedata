# The charts, afresh: the owner's thoughts

The owner's thoughts on what the charts and figures are trying to show, taken
down one at a time as given, 17 September 2026. Not responded to yet: once all
are in, they are turned into something coherent together, in a second pass.

---

1. **Headline figures first.** High-level figures from the dataset for users,
   not charted or graphed: the total number of bills, the number of sessions
   covered, and so on. What they cover is agreed in the second pass.

2. **Outcomes, as a chart like the screenshots.** Sessions along the bottom.
   For each session, a bar for each type of bill, each bar stacked by outcome.
   Figures on the bars, because some parts will be extremely small.

3. **Outcomes, as a table like the screenshots.** The reader can show all bills
   or pick a type. Columns: session; its duration; bills introduced; passed;
   fallen or expired; a success rate; and the average number of bills
   introduced per year.

4. **How long bills take, as a chart like the screenshots.** Sessions along the
   bottom, the average time up the side. The reader chooses at two levels: the
   type of bill, including all; and the stretch measured: introduction to
   Stage 3, introduction to the end of Stage 1, end of Stage 1 to end of
   Stage 2, end of Stage 2 to end of Stage 3, and, as an extra, end of Stage 3
   to Royal Assent.

5. **Whether bills are introduced early or late in a session.** Show how
   front-loaded or back-loaded the introduction of bills is. The owner asks for
   creativity here. Three screenshots from the owner's other project, on the
   Desktop, 17 September 15.09, for inspiration only. They show government
   bills in Sessions 1 to 6:
   - **A line per session**: the share of the session's bills introduced so
     far against the share of the session gone, beside a straight diagonal for
     a steady rate. A curve below the diagonal means bills came late.
   - **A table of marks**: the share of bills introduced by a quarter, half and
     three-quarters of the way through each session, and how far through the
     session half the bills had been introduced.
   - **A bar per session split into its four quarters**, each labelled with the
     share of the session's bills introduced in it.

6. **The longest and shortest bills, as lists like the screenshots.** The
   screenshot of 15 September, 16.33.06, shows two lists of ten side by side,
   each bill with its number, type, title, session, dates and days taken, and a
   filter by type.

7. **What the screenshots show, and what comes next.** They show what good
   formatting, presentation and colour can do. None of it is gimmicky, and it
   gives a window into the data that sterile banks of statistics never can.
   Thoughts 1 to 6 are the starting charts and tables; more may follow. Two
   things to consider: **(a) what calculations the database needs to add**, and
   **(b) how to get the presentation looking the way the owner wants.**

**All seven thoughts are in**, 17 September.

**The step back, after the seven.** Two things are going on. **The downloads**
need to be very boring, in a good way: accurate, complete, with provenance. **The
charts and tables** cannot lose sight of that, but can try to make the data come
alive. Doing both at once is one of the things that sets the site apart.

---

## Noted for the second pass

Not the owner's words. Things to raise when the thoughts are brought together,
so they are not lost.

- **Thought 2 and the colour rule.** A bar stacked by outcome needs each outcome
  told apart, and the house style of 15 September says an outcome is a word,
  never a colour.
- **Thought 3's columns.** What "fallen or expired" takes in, given that
  rejected, withdrawn and fell at dissolution are recorded apart (M7), and
  where a bill passed but not an Act sits (M5). What "success" means, and
  whether that word is used: `PHASE-2.md` names the screenshots' success rates
  as something the 15 September rules were meant to avoid. How duration and
  per year are measured, and Session 7, which is still running.
- **Thoughts 2, 3 and 4 and the switches.** A reader picking a type, or a
  stretch, goes beyond the two switches settled on 17 September.
- **Thought 4's average.** Mean or median. And the settled switch between every
  bill that reached a stage and only the bills that passed: kept, and where it
  sits.
- **Thought 5, already settled in part**: Session 7 measured to 1 April 2031
  (M14, and its approved sentence), and a rule still needed for a bill
  introduced on the day a quarter changes. The screenshots' inequality score
  and labels such as "front-loaded" are judgements a reader would need
  explained; whether any appear is for the second pass. Whether it covers
  government bills only, or every type.
- **Thought 6.** Timed to the final stage or to Royal Assent, and bills that
  passed only. Ties: the quickest ten end cleanly, a longer list ends in a tie
  of Budget Acts. The quickest cannot be separated into emergency bills (M10).
  The screenshot names each bill's sponsor, which crossing to the published
  copy excludes: introducers' names sit only on the staging sheet, which both
  source licences keep out.
- **Thought 7 and what is settled.** Colour, readers choosing what they see, and
  charts that respond when hovered all touch decisions already recorded: an
  outcome is never a colour and the accent never touches data (15 September);
  two switches only; charts drawn on the machine as fixed images, nothing drawn
  in the reader's browser (both 17 September). A charting library in the
  browser would be an addition, asked for by name.
- **Thought 4's known traps**, already listed in `PHASE-2.md`: Private Bills'
  stages compared by position (M2); the Robin Rigg Act (M9); Stage 3 to Royal
  Assent running through the Supreme Court for two Acts (M5); Session 7 with
  nothing yet to measure (M13); and the financial resolution, which an odd
  Stage 1 to Stage 2 figure would reopen.

---

## Mock-ups

- **Thought 2, outcomes stacked by type**, 17 September: a private page at
  https://claude.ai/artifact/XkH7LGSDzhFSo6FTYaxZx9. Real figures, Apache
  ECharts 6.1.0, a first attempt at the outcome palette, and the Forth Crossing
  dropdown. For the owner's correction; not agreed.
  - **The owner's asks on it**, 17 September, built into the same page: a
    dropdown grouping every ending other than passed as "Not passed", with the
    full breakdown a choice; a line saying what hovering shows; and every session
    together, shown as a second panel on its own scale. The groupings and totals
    are worked out in the database by a draft calculation, which adds up to 470
    in every version.
  - **Accepted by the owner as the starting point for this chart**, 17
    September, to be iterated later. Open for then: "Passed" includes two bills
    that did not become Acts (M5), which the hover does not yet say; and whether
    the all-sessions panel invites comparing bar heights with the sessions.
- **Thought 3, the outcomes table**, 17 September, on the same page beneath the
  chart. The owner's answers first: "Not passed" grouped or broken out, as on
  the chart; "Passed" throughout, no "success rate", every percentage a share of
  the bills introduced, as on the chart; Session 7 shown, its length and bills a
  year to the day the figures are worked out, marked "so far". Filters: type of
  bill, outcomes, the Forth Crossing Bill. Columns: session, length, bills
  introduced, the outcomes, bills a year, and an all-sessions row. Figures from a
  draft calculation, adding up to 470. For the owner's correction; not agreed.
