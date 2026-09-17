# Every calculation the charts and the table need

For the owner, 17 September 2026. It answers the question left open in the
review: whether our charts are always worked out in the database, with the page
only drawing them. Every figure below was checked against the database today.
Nothing was changed.

**In short:** the database already works out five things. Four are used as they
stand. The fifth, the averages, doesn't fit chart 2 and needs rewriting.
**Five calculations are new**, and two more depend on what the write-ups decide.
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
- **Averages: not clear yet what is averaged.** An average across the seven
  sessions? Something else? Yours to say, and new once it's known.
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
  - **Session 7 has no last day.** Either it's left out, or it uses the day the
    session is due to end, which the database doesn't hold. That would be a new
    fact, so it's yours to add or not.
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
| Chart 1's averages | Chart 1 | Once you've said what is averaged |
| The Robin Rigg Act from the earlier introduction | Chart 2 | Only if the write-up chooses it |
