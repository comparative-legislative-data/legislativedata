# Thought 2, the outcomes chart: the write-up

For the owner, 19 September 2026. Strand 3, step 2 of `docs/STRAND-3-PLAN.md`.
**A draft; nothing here is agreed** except the three points marked settled.
It follows the mock-up (https://claude.ai/artifact/XMz3FuH4zQnmNSwfM9WQVq,
the Outcomes tab), which is what you judged; this says in words what the
mock-up does, so the build has something to be checked against.

**Public wording is given in full** in the last section. Everything else is
a proposal with a reason.

---

## The three points left open on 17 September: settled today

1. **"Passed" and "became an Act".** Where they differ, the hover adds a line
   under Passed, and the table of numbers has an "of which became Acts"
   column. It happens for Government Bills in Session 5 (the Legal Continuity
   Bill) and Session 6 (the Gender Recognition Reform Bill), and so for all
   sessions together. Agreed.
2. **The all-sessions panel is kept**, on its own scale: "having its own
   scale solves the problem." The mock-up also heads it "All sessions
   together, on its own scale"; **kept unless you say otherwise.**
3. **The Forth Crossing Bill's dropdown is kept.** Agreed.

## The question it answers

How did the bills introduced in each session end, and does that differ by
who introduced them?

## Which bills it counts

- **All 470**, each once, in the session it was introduced in (M6). None is
  left out by any choice.
- **A bill that fell and was introduced again counts twice**, once in each
  session, because two bills were introduced (M6).
- **Session 7 is shown**, with the one bill introduced so far, In progress
  (M13), and a line saying the session is running.
- **The Forth Crossing Bill** is counted as a Government Bill unless the
  reader chooses to show it as a Hybrid Bill (M4). Either way the chart says
  which.
- **The two bills that passed and did not become Acts** are counted as
  Passed, because the outcome records what the Parliament did. Point 1 above
  is how the reader learns of them (M5).
- **The UNCRC and European Charter Bills**, which passed twice, count once
  each, in Session 5, as Passed and Acts (M5).
- **An outcome no bill has**, "Fell (other)" today, is left out until a bill
  has it.

## What the reader sees and chooses

All as on the mock-up.

- **Two dropdowns.** Outcomes: "Passed or not" (the default) or "Full
  breakdown". Forth Crossing Bill: "Counted as a government bill" (the
  default) or "Shown as a Hybrid Bill".
- **The chart.** For each session, a bar for each type of bill, stacked by
  outcome, with the count on each part big enough to hold it and the bills
  introduced above each bar, "–" where none were. A second panel, all
  sessions together, on its own scale. A legend, a colour to each outcome.
- **Hovering a bar**: the session and type, the bills introduced, and each
  outcome with its count and share; "None introduced" where there were
  none; and point 1's line where it applies.
- **Clicking any part of a bar, or any figure in the table of numbers**,
  opens the bills it counts, in the table of every bill.
- **Beneath**, in the frame's order: the description; the rule; the notes it
  rests on; the explanations; the table of numbers, folded; the CSV; the
  working, folded.
- **Dark and light**, redrawn when the setting changes.

**Nothing from the mock-up is left out.**

## The working

**Written in the published copy's own column names**, so a reader can run it
unchanged on the files they download. It works out every figure for every
choice, 720 lines, and lists each figure's bills by `bill_number`.

**Checked today against the live copy, read only:** its 720 lines match the
mock-up's figures in every cell (bills of the type, bills, share); every
figure's list of bills holds exactly as many bills as its count; every
arrangement adds to 470.

```sql
-- Bill outcomes by session and type: the figures behind the outcomes chart.
-- Every bill is counted once, in the session it was introduced in (M6), by how
-- its passage ended (M7). The Forth Crossing Bill is counted as a government
-- bill, from bill_type_grouped, or shown as a Hybrid Bill, from bill_type (M4).
-- Outcomes are shown in full, or as Passed, Not passed and In progress, where
-- Not passed is every ending other than those two. An outcome no bill has is
-- left out. Each figure lists the bills it counts, by bill_number.
WITH counted AS (
  SELECT 'Counted as a government bill' AS forth_crossing_bill,
         bill_type_grouped AS bill_type, session::text AS session,
         outcome, enactment_status, bill_number
    FROM bills
  UNION ALL
  SELECT 'Shown as a Hybrid Bill', bill_type, session::text,
         outcome, enactment_status, bill_number
    FROM bills
),
every_session AS (
  SELECT * FROM counted
  UNION ALL
  SELECT forth_crossing_bill, bill_type, 'All sessions',
         outcome, enactment_status, bill_number
    FROM counted
),
shown AS (
  SELECT 'Full breakdown' AS outcomes_shown, e.*, outcome AS shown_as
    FROM every_session e
  UNION ALL
  SELECT 'Passed or not', e.*,
         CASE WHEN outcome IN ('Passed', 'In progress') THEN outcome
              ELSE 'Not passed' END
    FROM every_session e
),
-- Every combination is given a line, so a nought is a nought and not a gap.
grid AS (
  SELECT v.outcomes_shown, t.forth_crossing_bill, t.bill_type, s.session,
         v.shown_as
    FROM (SELECT DISTINCT outcomes_shown, shown_as FROM shown) v
   CROSS JOIN (SELECT DISTINCT forth_crossing_bill, bill_type FROM counted) t
   CROSS JOIN (SELECT session::text AS session FROM sessions
               UNION ALL SELECT 'All sessions') s
),
of_this_type AS (
  SELECT forth_crossing_bill, bill_type, session, count(*) AS bills
    FROM every_session
   GROUP BY forth_crossing_bill, bill_type, session
),
figures AS (
  SELECT g.outcomes_shown, g.forth_crossing_bill, g.session, g.bill_type,
         g.shown_as AS outcome,
         coalesce(t.bills, 0) AS bills_of_this_type,
         count(s.bill_number) AS bills,
         round(100.0 * count(s.bill_number) / nullif(t.bills, 0)) AS percent_of_bills_of_this_type,
         CASE WHEN g.shown_as = 'Passed'
              THEN count(s.bill_number) FILTER (WHERE s.enactment_status = 'Enacted')
         END AS of_which_became_acts,
         string_agg(s.bill_number::text, '; ' ORDER BY s.bill_number) AS bill_numbers
    FROM grid g
    LEFT JOIN shown s
      ON s.outcomes_shown = g.outcomes_shown AND s.forth_crossing_bill = g.forth_crossing_bill
     AND s.bill_type = g.bill_type AND s.session = g.session AND s.shown_as = g.shown_as
    LEFT JOIN of_this_type t
      ON t.forth_crossing_bill = g.forth_crossing_bill AND t.bill_type = g.bill_type
     AND t.session = g.session
   GROUP BY g.outcomes_shown, g.forth_crossing_bill, g.session, g.bill_type, g.shown_as, t.bills
)
SELECT f.*
  FROM figures f
  LEFT JOIN what_the_words_mean ty
    ON ty.value = f.bill_type
   AND ty.heading = CASE WHEN f.forth_crossing_bill = 'Shown as a Hybrid Bill'
                         THEN 'bill_type' ELSE 'bill_type_grouped' END
  LEFT JOIN what_the_words_mean o
    ON o.value = f.outcome AND o.heading = 'outcome'
 ORDER BY f.outcomes_shown, f.forth_crossing_bill,
          f.session = 'All sessions', f.session, ty."order",
          CASE f.outcome WHEN 'Not passed' THEN 2 WHEN 'In progress' THEN 9 ELSE o."order" END;
```

**Shares are rounded to whole numbers, halves up**, so a row can add to 99
or 101; a share that rounds to nothing is shown as "<1%".

## How it is carried: five proposals

Each follows what strand 1 settled for the days between stages.

1. **A worked-out file in the copy, `outcomes_by_session_and_type`**, made
   by the refresh from the working above, with its text kept in `workings`
   and a line in `about`. The page reads it; nothing is worked out on the
   page.
2. **The copy's check is extended** to refuse a copy where any arrangement
   fails to add to the bills in the copy, where a figure's list of bills
   does not hold as many bills as its count, or where a bill appears in two
   outcomes of one arrangement.
3. **The CSV beneath the chart is that file**, all 720 lines, with three
   headings added for the reader: the sources, the date and the chart's
   address. **The working joins the zip as text; the figures do not**, as
   settled on 17 September.
4. **The route to the bills** is the file's `bill_numbers`: clicking a
   figure opens the table of every bill showing those bills, with the
   figure named above.
5. **Descriptions for the file and each heading**, as every file in the
   copy has, in the last section.

## The notes it rests on

M1, M4, M5, M6, M7, M13, as on the mock-up. Each links to the note on the
Data page.

## What it cannot say

- **How sessions compare in size.** Sessions ran four years and five, so a
  longer session has more bills without being busier. Thought 3's table
  gives bills a year for that.
- **Why a bill ended the way it did**, beyond the coding M7 describes.
- **Anything about bills never introduced**, such as a Member's Bill
  proposal that did not get enough support.
- **Emergency, Budget or consolidation bills apart from the rest.** How a
  bill was handled is known for 5 bills of 470 (M10).
- **Session 7's shape.** Its figures change with every bill introduced.

## How you might sanity-check it

- **Each session's bills, all types together**, against the factsheet's
  total: equal for Sessions 1 to 5, two lower for Session 6, one lower for
  Session 7 (M6).
- **Session 3's Government Bills, 45 by default**, against the Session 3
  factsheet's 45 Executive Bills, which counts the Hybrid Bill in (M4); 44
  with the Forth Crossing Bill shown on its own.

---

## The public wording, in full

**For your correction.** Everything a reader sees, in the order they see it.

**Title**

> Bill outcomes by session and type

**The line beneath**

> How every bill introduced in each session ended, by who introduced it.
> Each bar is one type of bill; its parts are the outcomes.

**The dropdowns**

> Outcomes: Passed or not | Full breakdown
>
> Forth Crossing Bill: Counted as a government bill | Shown as a Hybrid Bill

**Above the chart**

> **Hover over a bar** to see how many of those bills ended each way, and
> what share they were. The right-hand panel counts every session together,
> on its own scale.
>
> Click any figure to see the bills behind it.

**Inside the chart.** The legend, each outcome by name; the sessions as
"Session 1" and "1999–2003"; the types as "Govt", "Member", "Cttee",
"Private" (and "Hybrid"); the axes "Bills" and "Bills, own scale"; above
the second panel, "All sessions together, on its own scale", and beneath
it, "All sessions" and "1999 to date".

**Inside the frame, beneath the chart**

> Sources: the Scottish Parliament's bill factsheets and Official Report;
> legislation.gov.uk · Data as at 18 September 2026 ·
> legislativedata.org/insights#outcomes-chart

*Proposed change:* the sources line is taken from the copy, naming each
source whose terms the chart's figures draw on, as the `terms` file names
it: "Sources: Scottish Parliament; legislation.gov.uk;
legislativedata.org". The credit lines, in full, sit with the page's other
credit lines, as on the Data page. **Checked against the sources file,
19 September:** every bill's line is from the SPICe legislation
factsheet; the facts this chart uses that came from elsewhere are 31
outcomes from the Official Report, 17 from the SPICe dates factsheet, one
type from the Parliament's bill page (all Scottish Parliament), and 7
enactment statuses from legislation.gov.uk. The Supreme Court is behind
none of them. legislativedata.org is named for our coding and the
worked-out figures.

**Hovering a bar**, for example:

> Session 5 · Government Bills
> 63 bills introduced
> Passed 62 (98%)
> 61 became Acts; 1 passed and was stopped before Royal Assent (M5)
> Not passed 1 (2%)

and for a type with none: "None introduced".

**The bills behind a figure**, above the table of every bill:

> The 62 bills behind: Session 5 · Government Bills · Passed

**Description**

> A bar chart of the bills introduced in each session of the Scottish
> Parliament, one bar for each type of bill, divided by how each bill
> ended, with every session together in a second panel.

**The rule**

> Every bill introduced in the Parliament, counted once in the session it
> was introduced in, by how its passage ended.

> Rests on M1 M4 M5 M6 M7 M13

**The explanations**

> - Session 7 is still running, so its figures count only the bills
>   introduced so far.
> - "Passed" counts two bills that passed and did not become Acts (M5);
>   hovering says how many of those passed became Acts, and so does the
>   table of numbers.

*Proposed addition*, since the default groups the types:

> - The Forth Crossing Bill, a Hybrid Bill, is counted as a government bill
>   unless you choose to show it on its own (M4).

**Beneath**

> The numbers in this chart
>
> Download these figures (CSV)
>
> Show the working

**The file's descriptions**, for "What each heading holds" and the zip:

- `outcomes_by_session_and_type`: *"Worked out from bills: the figures
  behind the outcomes chart on the Insights page, one line for each choice
  of outcomes and of the Forth Crossing Bill, each session and all
  sessions, each type of bill and each outcome. The working is in
  workings."*
- `outcomes_shown`: *"Full breakdown, every outcome a bill has; or Passed
  or not, where Not passed is every ending other than Passed and In
  progress."*
- `forth_crossing_bill`: *"Counted as a government bill, types taken from
  bill_type_grouped; or Shown as a Hybrid Bill, types taken from bill_type.
  See methodology note M4."*
- `session`: *"The session the bills were introduced in, or All sessions."*
- `bill_type`: *"The type of bill, as bill_type_grouped or bill_type name
  it."*
- `outcome`: *"How the bills' passage ended, as outcome names it, or Not
  passed."*
- `bills_of_this_type`: *"Worked out: the bills of this type introduced in
  this session."*
- `bills`: *"Worked out: how many of them ended this way."*
- `percent_of_bills_of_this_type`: *"Worked out: bills as a percentage of
  bills_of_this_type, rounded to a whole number, halves up. Empty where no
  bill of this type was introduced."*
- `of_which_became_acts`: *"Worked out, on the Passed line only: how many
  of the bills that passed have enactment_status Enacted. Empty on every
  other line. See methodology note M5."*
- `bill_numbers`: *"The bills counted, by bill_number, separated by
  semicolons. Empty where there are none."*
