# Every calculation the charts and the table need

For the owner, 17 September 2026. It answers the question left open in the
review: whether our charts are always worked out in the database, with the page
only drawing them. Every figure below was checked against the database today.
Nothing was changed.

**In short:** the database already works out five things. Four are used as they
stand. The fifth, the averages, doesn't fit chart 2 and needs rewriting.
**Five calculations are new**, and one more depends on what chart 2's write-up decides.
None of the numbers needs the page to do any arithmetic.

The name in brackets is where to find each one in Postico.

---

## What the database already works out

1. **Each bill's stage dates on one line**: introduction, the end of each stage,
   Reconsideration where there was one, Royal Assent, and the day it ended if it
   didn't pass. *(v_bill_stage_dates)*
2. **The days between each stage and the one before it, bill by bill.** Each
   period says whether the bill got through that stage and whether it went on to
   pass, so a figure can take either set of bills. That makes 1,657 periods. A
   bill rejected at Stage 1 has a real period to its rejection. The Robin Rigg
   Act has a single period, 42 days from introduction to Final Stage, because it
   skipped the two stages between. *(v_bill_stage_durations)*
3. **Each bill's days from introduction to its final stage**, 407 bills, and
   **from its final stage to Royal Assent**, 402 bills. For the UNCRC and
   European Charter Acts the second figure runs through the Supreme Court and
   Reconsideration Stage. *(v_bill_total_duration)*
4. **How many bills ended each way**, by session and type. It keeps Hybrid Bills
   apart and can fold them in with government bills. *(v_outcome_by_type)*
5. **The averages of item 2**, by session and type: mean, median, shortest and
   longest. *(v_stage_duration_summary)* It doesn't serve chart 2 as it stands,
   for three reasons:
   - It splits off the five bills known to be emergency bills, so Session 6's
     government bills at Stage 1 come out as two figures, 55 bills and 5.
   - It has no version for bills that passed. It says how many passed, but
     doesn't average them separately.
   - It keeps the Forth Crossing Bill on its own, with no way to fold it in or
     leave it out.

---

## Chart 1 — outcomes by session by type

- **Numbers:** item 4, added up by session, type and outcome. Item 4 also splits
  by procedure and by whether a bill became an Act, so the adding up is a small
  **new** calculation.
- **Percentages: new.** Each outcome as a share of that session's bills of that
  type.
- **Averages: not needed** (the owner, 17 September). Chart 1 is numbers and
  percentages.
- **The Hybrid switch** comes from item 4, which already carries both groupings.
- **Session 7 has one bill, in progress**, so its percentages are shares of one
  bill. The write-up says whether it's shown.

## Chart 2 — time to pass, in four intervals

- **Introduction to Stage 1, Stage 1 to Stage 2, and Stage 2 to Stage 3** come
  from item 2.
- **Stage 3 to Royal Assent** comes from item 3. Item 2 splits it in two for
  the UNCRC and European Charter Acts, but item 3 doesn't.
- **The averages under both switches: new.** That means mean and median, by
  session and type, both for every bill that reached the stage and for only the
  bills that passed, with the Forth Crossing Bill folded in or left out. It
  replaces item 5 rather than sitting beside it: two ways of averaging the same
  periods is the drift the review ruled out.
- **Rounding is part of the calculation.** Item 5 rounds the mean to whole days
  and leaves the median free to end in a half.
- **The Robin Rigg Act counted from the earlier bill's introduction**, as M9
  allows, isn't worked out anywhere. It is **new, only if the write-up chooses
  it**. Measured from its own introduction, the Act adds nothing to the first
  three intervals.
- **Session 7 has nothing to show**: its one bill hasn't completed a stage.

## Charts 3 and 4 — the quickest and the slowest bills

- **Each bill's time comes from item 3.** The write-up says whether that means
  to the final stage or to Royal Assent, and whether only bills that passed are
  counted.
- **The ranking, and what happens at a tie: new.** Among bills that passed,
  timed to the final stage, the quickest ten end cleanly: two bills at 6 days,
  then the next at 8. A quickest twenty would end in a nine-way tie of Budget
  Acts at 20 days. The slowest twelve are all different.
- **Emergency bills.** Five are marked as emergency bills and the rest aren't
  known. The Coronavirus (Scotland) Act 2020, at 1 day, is unmarked (M10).

## Chart 5 — bills introduced in each quarter of a session

- **Which quarter of its session each bill was introduced in: new.** It uses the
  session's first meeting and last day, which the database holds. Sessions ran
  from 1,413 to 1,818 days, so a quarter is between 353 and 455 days. No bill
  was introduced outside its session.
- **Counts and percentages by session and quarter: new.** The write-up says
  whether it's broken down by type too.
- **Two rules the calculation needs:**
  - **A bill introduced on the day a quarter changes** needs a rule for which
    quarter it goes in.
  - **Session 7 has no last day.** Settled by the owner, 17 September: it is
    measured to an estimated last day, explained upfront. What that involves is
    at the end of this file.
- **Whether the pattern has changed over time** is read off the chart. A trend
  line would be another calculation, and isn't proposed.

## The table of every bill

- **One line per bill with its stage dates across** is item 1.
- **Words in place of codes** are looked up from the lists of allowed values. No
  calculation.
- **Which worked-out columns it carries** is the write-up's choice: the days
  from item 3, and a bill's quarter from chart 5, are the obvious candidates.
- **Going from a figure to the bills in it** means every new calculation above
  has to give the bills it counted as well as its number. That is part of
  building each one, not a separate calculation.

---

## What this means for the open question

**Every number a reader could quote from these five charts and the table either
exists in the database already or is on the list above.** That covers counts,
percentages, means, medians, rounding, rankings and quarters. The page would do
only drawing and layout.

**Recommended: settle it as yes.** Our charts are always worked out in the
database, and the page only draws them.

**The new calculations, in one place:**

| New calculation | For | Needed when |
|---|---|---|
| Outcome counts added up, with percentages | Chart 1 | Always |
| Averages under both switches (replaces item 5) | Chart 2 | Always |
| Ranking, with a rule for ties | Charts 3 and 4 | Always |
| Each bill's session quarter | Chart 5, the table | Always |
| Counts and percentages by quarter | Chart 5 | Always |
| The Robin Rigg Act from the earlier introduction | Chart 2 | Only if the write-up chooses it |

---

## Session 7's estimated last day: the proposal, every part

The owner decided on 17 September that chart 5 measures Session 7 to an
estimated last day, explained upfront. That adds a new fact to the database, so
under the rule for coding changes every part below is agreed before anything is
built.

**The date: 1 April 2031.** Worked out from the law as it stands:

- **The election.** The next poll is due on the first Thursday in May, five
  years after the last one, which is 1 May 2031 (Scotland Act 1998, section
  2(2)).
- **Dissolution.** The Parliament is dissolved at the start of the "minimum
  period" ending on polling day (section 2(3)). That period is 20 days (the
  Scottish Parliament (Elections etc.) Order 2015, article 84, cut from 28 by
  the 2025 amending Order). Weekends, Good Friday, Easter Monday and Scottish
  bank holidays don't count (the election rules, schedule 2, rule 2).
- **The check.** Counted the same way from the 2026 election, the rule gives
  8 April 2026, which is Session 6's recorded last day.
- **What would move it.** A poll moved by proclamation (up to four weeks
  earlier or eight weeks later), an early election, a clash with a UK general
  election, or a change to the rules.

**The nine parts, each with a proposal:**

1. **What it records.** One date: the day a running session is expected to
   end. For Session 7, 1 April 2031.
2. **Which sessions it applies to, and what empty means.** Only the running
   session, which must have one. A session that has ended has none: empty means
   the session is over and its real last day is recorded. When Session 7 ends,
   its real last day goes in and the estimate comes out, in the same change.
3. **Where it sits.** A cell of its own on the session's row, beside the real
   last day, and never in that cell. The real last day is treated as fact: a
   bill that fell at dissolution is checked against it, and promotion writes
   provenance from it. An estimate there would be checked as if it were fact,
   and "empty means still running" would stop being true.
4. **How it arrives.** Sessions have no staging sheet. Their dates were written
   by a numbered change to the database (`db/048`), and this one is the same,
   rehearsed and thrown away before it is applied.
5. **Provenance.** A provenance note on the cell, citing legislation.gov.uk
   (already on the list of sources): the section of the Act, the article of the
   Order and the counting rule, read 17 September 2026. Copies of the three
   pages are kept in `sources/`, as settled for cited sources.
6. **What the database checks.** It refuses an estimate on a session that has
   ended, a running session without one, and an estimate earlier than the
   session's first meeting.
7. **What a reader is told.** A new methodology note, M14, and one sentence at
   the top of chart 5. Both drafts are below, in full.
8. **Everything already recorded, rechecked.** Nothing already recorded uses
   it. The error checker, the gaps list, loading and promotion read only the
   real last day and don't change. No bill is touched. This is checked after
   building, with all counts the same before and after.
9. **When it is built.** This session, once parts 1 to 8 and both wordings are
   agreed, before the write-ups begin. The data dictionary is regenerated in the
   same piece of work.

**Draft methodology note, M14. For the owner, in full.**

> **Session 7 is measured to the day it is expected to end**
>
> Session 7 has not ended, so its last day is not yet known. To divide it into
> quarters we use the day it is expected to end: 1 April 2031.
>
> The next election is due on 1 May 2031, the first Thursday in May five years
> after the last (Scotland Act 1998, section 2). The Parliament is dissolved at
> the start of the 20 days that end on polling day, not counting weekends and
> public holidays, and 1 April 2031 is the last day before that. Counted the same way, the rule gives Session
> 6's actual last day, 8 April 2026.
>
> The date can move: the poll can be brought forward or put back by
> proclamation, or an early election held. Until the session ends, its quarters
> are an estimate, and its later quarters hold only the bills introduced so far.
> When it ends, its real last day replaces the estimate and its figures are
> worked out again.

**Draft sentence at the top of chart 5. For the owner, in full.**

> Session 7 is still running. Its quarters are measured to 1 April 2031, the day
> it is expected to end, and it counts only the bills introduced so far.
