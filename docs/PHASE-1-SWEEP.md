# Closing Phase 1: what happens to the plan and the briefing files

For the owner to settle. Three questions, each with a recommendation. Where you
agree, "yes" is enough. This file goes once the sweep is done; the record of
where every line went is kept with the test run in `CLOSURE-TESTS.md`.

The rule, from `PLAN.md`: every line goes to a permanent home or goes, and
nothing is deleted until it has been checked as present in its new home.

---

## 1. The phase plan itself

Almost all of `PHASE-1.md` is already recorded elsewhere: every decision in
`DECISIONS.md`, the positions in `STANDING.md`, the deploy and accounts in their
runbooks, and what the phase delivers and must not do in `PLAN.md`.

**Three things are not, and need a home before it goes:**

- **Refreshing the published copy becomes a step in promotion**, with its own
  rehearsal and undo. It is recorded as a cost of the three-databases decision,
  but not where Phase 2 will look. → One line in `PLAN.md`, under Phase 2.
- **Chart colours were not settled**, deliberately; they wait for Phase 2 and
  something to plot. → `STANDING.md`, under what was deliberately left undone.
- **Publishing the bills as files instead of a database** was left open, and is
  reopened when Phase 2 settles what a reader's tools are. → The same place.

The line saying the machine's renewal date is "still to record" is out of date:
it is recorded in the private notes. It goes.

**Recommended:** those three moved, then `PHASE-1.md` deleted.

## 2. The test page that can't be built as promised

The house-style decision of 15 September promises a test before Phase 2: one
page carrying a real table of all the bills, "built locally and never deployed",
to see whether the style can hold a dense table.

Since 16 September nothing runs on this Mac, so it can't be built that way. The
test is still worth doing.

**Recommended:** it becomes the first thing Phase 2 builds, on the live site, at
an address only your account can open, as the admin screen is. Nobody else sees
a figure, so nothing is published. Recorded as a new decision amending the old
one, and the old entry left as it is.

## 3. The eight briefing files

**Four were what a decision was made from, and can go.**

- **Hosting**, **what the site reads** and **the backup by theme**: the decisions
  and their reasons are in `DECISIONS.md`, and how the backup runs is in the
  accounts runbook. One comment in a tool is re-pointed to the runbook.
- **Style**: the colours, type and spacing read off your essays site are now
  in the site's stylesheet. Each value is checked there before the file goes,
  and the two places that point at the file are re-pointed to the stylesheet.

**Four hold the wording you settled for every page and email**, word for word:
applying, signing in, the admin screen and emails, and the privacy page. The
site's code names them as the source of its wording, and the privacy check
compares the live page against the privacy file. Without that file the page
would only be checked against itself.

- **A (recommended). Keep the wording, drop the rest.** Four permanent files in
  a `docs/wording/` folder, one per page or set of emails. Each holds only the
  words as settled and the dates they were settled or amended. The questions,
  options and recommendations go, after each of your answers is checked as
  present in `DECISIONS.md`. The references in the site's code are updated, which
  changes the site, so it is deployed with its rehearsal, the privacy check is
  run again, broken and then properly, and the live site is checked against the
  commit again.
- **B. Keep the four files as they are**, only taking out the line saying they
  go when Phase 1 closes. Nothing on the site changes. The cost is four
  permanent files named after a closed phase, most of each being proposals
  rather than wording.
