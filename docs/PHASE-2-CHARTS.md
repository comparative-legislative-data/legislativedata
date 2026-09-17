# The write-ups: every chart and the table, before anything is drawn

For the owner. Each chart, and the table of every bill, is written out here and
agreed before it is built (`PHASE-2.md`, groundwork 3). A write-up says the
question it answers, which bills it counts, what it shows and how, its switches,
its calculation, the notes it rests on, and what it cannot say. Public wording
is given in full. Nothing is built until the owner agrees.

Every figure here was worked out in the database on 17 September 2026. Nothing
was changed.

---

## Chart 1 — Bill outcomes by session and type

**Draft, 17 September. Not yet agreed.**

### What needs your answer

Each has a proposal. A yes to all of them settles the chart.

1. **What is drawn.** A grid of small bar charts: the types of bill down the
   side, the outcomes along the top, and in each square one bar per session,
   as a **percentage**, with the number of bills printed at its end. Numbers
   and percentages both go in the table beneath.
2. **What "outcome" means.** What the Parliament last did with the bill. The
   table adds a column for **whether it became an Act**, not drawn.
3. **The switch.** The Forth Crossing Bill counted as a government bill, or
   shown as a Hybrid Bill on a row of its own. Counted as government by default.
4. **Session 7 is shown**, with one sentence saying it is still running.
5. **An "All types" row**, after the four types, in the chart and the table.
6. **A type with no bills in a session** says "none introduced", never 0%.
7. **Percentages are whole numbers, and halves go up**, so a row can add to 99
   or 101. The table says so.
8. **The order of the outcomes**, and a tie in the list of outcomes put right
   (below).
9. **No switch for Executive and Government Bills.** It is named as the
   playground's.
10. **The public wording**, in full below.
11. **Where the rule sentence sits.** This write-up put it beneath the title.
    The decision of 17 September on showing the working puts it after the
    figure. **Proposed:** after the figure, as decided. Found in building the
    mock-up.

**A mock-up with today's figures**, for seeing the chart rather than imagining
it: a private page at https://claude.ai/artifact/3VedUECgiRD4YY7CKUDYy1. It sets
the proposed grid beside two alternatives (the grid drawing counts, and the
divided bar the colour rule rules out), works the Forth Crossing switch, and
carries the table and wording. It is not the site, and is not kept in the
repository.

### The question it answers

How did the bills introduced in each session end, and does that differ by who
introduced them?

### Which bills

**All 470.** Each is counted once, in the session it was introduced in (M6).
None is left out by default. A bill that fell and was introduced again counts
twice, once in each session, because two bills were introduced (M6).

Two bills the Parliament passed did not become Acts. The UK Withdrawal from the
European Union (Legal Continuity) (Scotland) Bill (Session 5) was withdrawn
after the Supreme Court's ruling. It is counted as **Passed**, not Withdrawn.
The outcome records what the Parliament did, and the Parliament passed it. What
happened after that is recorded separately (M5), and shows in "Became an Act".
The Gender Recognition Reform (Scotland) Bill (Session 6) is still stopped. The UNCRC and European Charter Bills passed twice. Each is counted once,
in Session 5, as Passed and an Act (M5).

### What the chart shows, and how it is drawn

**The outcomes, in this order:** Passed; Rejected at Stage 1; Rejected at
Stage 3; Withdrawn; Fell at dissolution; Fell: financial resolution not agreed;
In progress. "Fell (other)" is on the list of outcomes but no bill has it, so it
is left out of the chart and the table until one does.

**Why a grid and not one bar per session divided by outcome.** A divided bar
needs a colour for each outcome, and the house style settled on 15 September
that an outcome is a word, never a colour. In the grid, each outcome is a word
at the top of its column and each type a word at the side. Every bar is one
neutral colour from the house ramp, never the accent. That answers "the colours
of charts" for this chart only.

**Why percentages are drawn.** Government Bills run up to 67 a session and
Committee Bills up to 3, so counts on one scale make most squares unreadable. A
percentage puts every square on the same 0 to 100 scale. **The trap:** a
percentage of three Committee Bills is not a rate. The number printed at the
end of each bar says how many bills it is. **The alternative** is to draw counts,
each square on its own scale. That reads worse and invites comparing bars that
are not to scale.

**A type with no bills.** Session 6 had no Committee or Private Bills, and
Session 7 so far has only a government bill. An empty square would look like
0%, so the square says "none introduced".

### The table beneath

One row per session and type, with the "All types" row last in each session.
Columns: Session; Type; Bills; then each outcome as a number and a percentage,
with **Became an Act** beside Passed. Each number leads to the bills it counts,
in the table of every bill. How it leads there is for that table's write-up.

The CSV beneath the chart has one line per session, type and outcome: the
number, the percentage, the sources and the date.

### The switch

**The Forth Crossing Bill: counted as a government bill (default), or shown as a
Hybrid Bill.** M4 says any chart must say which it used. Shown on its own,
Session 3's Government Bills are 44, not 45, and a Hybrid row appears with one
bill that passed. **Leaving it out** is not offered. It would give the same
Government row as showing it on its own.

No other kind of bill can be left out. Emergency and Budget Bills cannot be
picked out by how they were handled, because that is known for 5 bills of 470
(M10).

**Named as the playground's, not built:** splitting Government Bills into those
styled Executive and those styled Government (M1), and an all-sessions total
for each type.

### The notes it rests on

M1, M4, M5, M6, M7, M12 (a bill a fact sheet leaves awaiting Royal Assent is
checked at legislation.gov.uk, which bears on "Became an Act"), and M13. Not M9: it concerns how long a reintroduced bill
took, not how many there were.

### What it cannot say

- **Anything per year.** Sessions ran four or five years, so compare
  percentages between sessions, not counts.
- **Why a bill ended the way it did**, beyond the coding M7 describes. The
  figures of a division are text on the bill, not data.
- **Anything about bills that were never introduced**, such as a Member's Bill
  proposal that did not get enough support.
- **Emergency, Budget or consolidation bills apart from the rest** (M10).
- **Session 7's shape.** Its figures change with every bill introduced.

### How you might sanity-check it

- **Each session's "All types" figure** should equal the fact sheet's total for
  Sessions 1 to 5, be two lower for Session 6, and be one lower for Session 7
  (M6).
- **Session 3's Government Bills, 45 by default**, should equal the Session 3
  fact sheet's 45 Executive Bills, which counts the Hybrid Bill in (M4).

### The public wording, in full

**Title**

> Bill outcomes by session and type

**The rule, after the figure (point 11).** Default:

> Every bill introduced in the Parliament, counted once in the session it was
> introduced in, by how its passage ended (M6, M7, M13). Percentages are shares
> of that session's bills of that type, rounded to whole numbers. Government
> Bills include Executive Bills (M1) and the one Hybrid Bill (M4). Not every bill
> the Parliament passed became an Act (M5, M12).

With the switch on, the third sentence reads:

> Government Bills include Executive Bills (M1); the one Hybrid Bill is shown on
> its own (M4).

**Beside Session 7, and at the top of the table:**

> Session 7 is still running, so its figures count only the bills introduced so
> far.

**Under the table:**

> Percentages are rounded, so a row may not add to 100.

**The switch, as a reader sees it:**

> Forth Crossing Bill: counted as a government bill | shown as a Hybrid Bill

**The image's one-sentence description, for a reader who cannot see it:**

> A grid of bar charts giving, for each type of bill and each outcome, the
> percentage of the bills introduced in each session of the Scottish Parliament
> that ended that way.

### The figures today, default switch

Worked out by the calculation below, 17 September 2026. The "All types" rows add
up to 470.

| Session | Type | Bills | Passed | Became an Act | Rejected at Stage 1 | Rejected at Stage 3 | Withdrawn | Fell at dissolution | Fell: financial resolution not agreed | In progress |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Government | 51 | 50 (98%) | 50 (98%) | 0 | 0 | 1 (2%) | 0 | 0 | 0 |
| 1 | Member's | 16 | 8 (50%) | 8 (50%) | 5 (31%) | 0 | 2 (13%) | 1 (6%) | 0 | 0 |
| 1 | Committee | 3 | 3 (100%) | 3 (100%) | 0 | 0 | 0 | 0 | 0 | 0 |
| 1 | Private | 3 | 1 (33%) | 1 (33%) | 0 | 0 | 0 | 2 (67%) | 0 | 0 |
| 1 | All types | 73 | 62 (85%) | 62 (85%) | 5 (7%) | 0 | 3 (4%) | 3 (4%) | 0 | 0 |
| 2 | Government | 53 | 53 (100%) | 53 (100%) | 0 | 0 | 0 | 0 | 0 | 0 |
| 2 | Member's | 18 | 3 (17%) | 3 (17%) | 6 (33%) | 0 | 5 (28%) | 4 (22%) | 0 | 0 |
| 2 | Committee | 1 | 1 (100%) | 1 (100%) | 0 | 0 | 0 | 0 | 0 | 0 |
| 2 | Private | 9 | 9 (100%) | 9 (100%) | 0 | 0 | 0 | 0 | 0 | 0 |
| 2 | All types | 81 | 66 (81%) | 66 (81%) | 6 (7%) | 0 | 5 (6%) | 4 (5%) | 0 | 0 |
| 3 | Government | 45 | 42 (93%) | 42 (93%) | 0 | 1 (2%) | 0 | 1 (2%) | 1 (2%) | 0 |
| 3 | Member's | 13 | 7 (54%) | 7 (54%) | 3 (23%) | 0 | 2 (15%) | 1 (8%) | 0 | 0 |
| 3 | Committee | 2 | 2 (100%) | 2 (100%) | 0 | 0 | 0 | 0 | 0 | 0 |
| 3 | Private | 2 | 2 (100%) | 2 (100%) | 0 | 0 | 0 | 0 | 0 | 0 |
| 3 | All types | 62 | 53 (85%) | 53 (85%) | 3 (5%) | 1 (2%) | 2 (3%) | 2 (3%) | 1 (2%) | 0 |
| 4 | Government | 67 | 67 (100%) | 67 (100%) | 0 | 0 | 0 | 0 | 0 | 0 |
| 4 | Member's | 13 | 6 (46%) | 6 (46%) | 5 (38%) | 0 | 1 (8%) | 1 (8%) | 0 | 0 |
| 4 | Committee | 1 | 1 (100%) | 1 (100%) | 0 | 0 | 0 | 0 | 0 | 0 |
| 4 | Private | 5 | 5 (100%) | 5 (100%) | 0 | 0 | 0 | 0 | 0 | 0 |
| 4 | All types | 86 | 79 (92%) | 79 (92%) | 5 (6%) | 0 | 1 (1%) | 1 (1%) | 0 | 0 |
| 5 | Government | 63 | 62 (98%) | 61 (97%) | 0 | 0 | 1 (2%) | 0 | 0 | 0 |
| 5 | Member's | 16 | 8 (50%) | 8 (50%) | 3 (19%) | 0 | 1 (6%) | 4 (25%) | 0 | 0 |
| 5 | Committee | 3 | 3 (100%) | 3 (100%) | 0 | 0 | 0 | 0 | 0 | 0 |
| 5 | Private | 5 | 5 (100%) | 5 (100%) | 0 | 0 | 0 | 0 | 0 | 0 |
| 5 | All types | 87 | 78 (90%) | 77 (89%) | 3 (3%) | 0 | 2 (2%) | 4 (5%) | 0 | 0 |
| 6 | Government | 61 | 60 (98%) | 59 (97%) | 0 | 0 | 1 (2%) | 0 | 0 | 0 |
| 6 | Member's | 19 | 6 (32%) | 6 (32%) | 5 (26%) | 2 (11%) | 3 (16%) | 3 (16%) | 0 | 0 |
| 6 | Committee | 0 | none introduced | | | | | | | |
| 6 | Private | 0 | none introduced | | | | | | | |
| 6 | All types | 80 | 66 (83%) | 65 (81%) | 5 (6%) | 2 (3%) | 4 (5%) | 3 (4%) | 0 | 0 |
| 7 | Government | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 (100%) |
| 7 | Member's | 0 | none introduced | | | | | | | |
| 7 | Committee | 0 | none introduced | | | | | | | |
| 7 | Private | 0 | none introduced | | | | | | | |
| 7 | All types | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 (100%) |

Rows that add to 99 or 101: Session 2 All types, Session 3 Government, Session 6
Member's and Session 6 All types.

### For the build

**The tie in the list of outcomes.** "In progress" and "Fell: financial
resolution not agreed" both have 7 as their place in the list, so the order the
chart takes them in is not fixed. **Proposed:** Fell: financial resolution not
agreed 6, Fell (other) 7, In progress 8. It is one numbered change to the
database, with a closure test for another session. It is built with chart 1's
calculation, or before it if you prefer.

**The calculation.** This is the draft that gave the figures above. It uses the
working database's names. The published copy's names are not yet chosen, so it
is rewritten in them when that copy is built, and must give the same 245 lines.
It is built on the existing outcome count (`v_outcome_by_type`), as settled.
Going from a number to its bills needs a version that gives one line per bill.
That is part of the build.

```sql
-- Chart 1: how bills ended, by session and type.
-- One line per session, type and outcome, with a line for every
-- combination, so a nought is a nought and not a missing line.
-- The switch: analysis_group counts the Hybrid Bill as a government bill;
-- bill_type in its place shows it on its own.
with counted as (
    select session_number, analysis_group as type, outcome, enactment_status, bills
    from v_outcome_by_type
    union all
    select session_number, 'all', outcome, enactment_status, bills
    from v_outcome_by_type
),
types as (
    select distinct type from counted
),
outcomes as (
    select code, label, sort_order from ref_outcome
    where code in (select outcome from bill)
),
grid as (
    select s.session_number, t.type, o.code as outcome, o.sort_order
    from session s cross join types t cross join outcomes o
),
bills_of_type as (
    select session_number, type, sum(bills) as bills
    from counted group by session_number, type
)
select g.session_number,
       g.type,
       g.outcome,
       coalesce(bt.bills, 0) as bills_of_type,
       coalesce(sum(c.bills), 0) as bills,
       round(100.0 * coalesce(sum(c.bills), 0) / nullif(bt.bills, 0)) as percent,
       case when g.outcome = 'passed'
            then coalesce(sum(c.bills) filter (where c.enactment_status = 'enacted'), 0)
       end as became_an_act,
       case when g.outcome = 'passed'
            then round(100.0 * coalesce(sum(c.bills) filter (where c.enactment_status = 'enacted'), 0) / nullif(bt.bills, 0))
       end as became_an_act_percent
from grid g
left join counted c
       on c.session_number = g.session_number and c.type = g.type and c.outcome = g.outcome
left join bills_of_type bt
       on bt.session_number = g.session_number and bt.type = g.type
group by g.session_number, g.type, g.outcome, g.sort_order, bt.bills
order by g.session_number, g.type, g.sort_order, g.outcome;
```
