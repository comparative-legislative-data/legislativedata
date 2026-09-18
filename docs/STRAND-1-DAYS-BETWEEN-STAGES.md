# The days between stages move into the published copy

For the owner. Written 18 September 2026. Strand 1, item 2 of
`docs/PHASE-2.md`. Every part of the change is laid out here, with three
questions at the end.

**Agreed by the owner the same day: yes to all three. Built the same day**,
the copy retaken. The closure test is written and unrun. The record is at the
end.

## What happens today, for one bill

The Smoking, Health and Social Care Bill has four lines in the published
days-between-stages file: 133 days from introduction to the end of Stage 1,
47 to the end of Stage 2, 16 to the end of Stage 3, and 36 to Royal Assent.

Those four numbers are worked out in the working database, using its own
names for things, and the copy just copies the answers across. A reader gets
the answers and the dates, but the working is written in names they never
see, so they can't run it.

## What changes

The working is rewritten in the reader's own headings, and the copy runs it on
its own `bills` and `stages` files. For the Smoking bill, it takes the bill's
line in `bills` (introduced 16 December 2004, Royal Assent 5 August 2005) and
its three lines in `stages` (the day each stage ended). It puts the five days
in order and counts the days between each pair. The result is the same four
lines.

**This has already been tried**, reading only, on the live copy: all 1657
lines came out identical to today's, in the same order. Nothing was changed.

## The working, in full

A reader will see this text. Please read the three lines of explanation at
the top as wording, not only as code.

```sql
-- The days between stages, worked out from bills and stages.
-- For each bill, its dated points are put in order: the day it was introduced,
-- the day each stage ended, and the day of Royal Assent. Each line is the gap
-- from one point to the next, counted in calendar days. A stage with no date
-- is left out, so the gap runs across it to the next dated point. See M2.
WITH points AS (
  SELECT bill_number, 0 AS position, 'Introduction' AS point,
         date_introduced AS on_date, 'Yes' AS got_through
    FROM bills WHERE date_introduced IS NOT NULL
  UNION ALL
  SELECT bill_number, stage_position, stage, date_ended, got_through
    FROM stages WHERE date_ended IS NOT NULL
  UNION ALL
  SELECT bill_number, 9, 'Royal Assent', date_royal_assent, 'Yes'
    FROM bills WHERE date_royal_assent IS NOT NULL
),
gaps AS (
  SELECT bill_number, position,
         LAG(point)   OVER (PARTITION BY bill_number ORDER BY position) AS measured_from,
         LAG(on_date) OVER (PARTITION BY bill_number ORDER BY position) AS date_measured_from,
         point AS measured_to, on_date AS date_measured_to, got_through
    FROM points
)
SELECT b.bill_number, b.title, b.session, b.bill_type, b.procedure, b.outcome,
       g.measured_from, g.date_measured_from, g.measured_to, g.date_measured_to,
       g.date_measured_to - g.date_measured_from AS days,
       g.got_through AS got_through_the_later_stage,
       CASE WHEN b.outcome = 'Passed' THEN 'Yes'
            WHEN b.outcome IS NOT NULL THEN 'No' END AS bill_passed
  FROM gaps g JOIN bills b ON b.bill_number = g.bill_number
 WHERE g.date_measured_from IS NOT NULL
 ORDER BY b.bill_number, g.position;
```

The version that was tried said "No" where a bill has no outcome. This one
leaves the cell empty, as today's does. No bill has an empty outcome, so the
1657 lines are the same either way.

## Every part of the change

**1. What a reader gets.** The same file: the same 13 headings, the same 1657
lines. The methodology notes don't change, and M2 is still the rule. The only
difference is the wording of two descriptions (question 2) and a new place
where the working is kept (question 1).

**2. Where the working lives.** It's one text file in this repository,
`workings/days_between_stages.sql`. When the copy is taken, it builds `bills`
and `stages` first and then runs this file on them. The working database is no
longer involved in working out the figure.

**3. The copy's own check.** Today the copy checks this file line by line
against the working database's own sum. That would leave two versions of the
arithmetic, which was ruled out. Instead the copy checks:
- every cell except `days` against the bill's line in `bills`, or the stage's
  line in `stages`;
- that `days` is the later day minus the earlier, and never below nought;
- that every dated point of every bill appears exactly once as the end of a
  gap, except each bill's first point, which only ever starts one. This is the
  question the 13 September coverage check asked ("counted, or a stated
  reason"), asked of the published file;
- that running the kept text again gives exactly the file. That proves the
  text a reader sees is the text that ran.

The rehearsal changes one `days` cell on purpose, and the check must name it.

**4. The proof.** The live copy is set aside, not dropped. The new copy is
taken, and every file is compared cell by cell with the old one. The only
differences allowed are the ones this change makes (parts 1 and 2). Only then
is the old copy dropped.

**5. The undo.** Put the build script back as it was and take the copy again,
the same way "In progress" was done on 18 September. Nothing on the site reads
the copy yet, so no reader sees it happen.

**6. What still uses the working database's own sum afterwards.** Nothing
published. Two things still use it: the averages by session and type, which
strand 3 replaces for thought 4, and the 13 September coverage check, whose
question moves into the copy's check (part 3). **Proposed:** the old sum stays
until strand 3 replaces the averages, then both go, with your agreement. The
list in `STATE.md` is updated to say so.

**7. The papers.** The copy's runbook, `HOW-THE-DATABASE-WORKS.md` and
`STATE.md` get updated, and the data dictionary is regenerated. This session
writes a closure test and a different session runs it.

**8. When.** This session, if you agree. It takes one retake of the copy.

## Three questions

**1. Should the copy keep the text it ran?** **Proposed: yes**, as a tenth
file in the copy called `workings`, with one line per worked-out file: the
file's name and the working in full. The site shows that text beside a figure
and the zip carries it, so what a reader sees is always what ran and can't
drift from a copy of it somewhere else. It is new, so it needs a description,
and it adds a line to `about`:
- file: *"The working that produced each worked-out file, in full, as it ran
  when this copy was taken."*
- `file`: *"The worked-out file."*
- `working`: *"The working, as text a reader can run on the other files."*

**2. The descriptions.** Settled in your review of the plan: a worked-out column says it is
worked out, from which columns, and by what rule. Today's descriptions don't.
Proposed, in full:
- the file: *"Worked out from bills and stages: one line per gap between two
  dated points in a bill's passage, and the calendar days it took. The working
  is in workings."*
- `days`: *"Worked out: date_measured_to minus date_measured_from, in calendar
  days."*

The other eleven headings are copied across, not worked out, and stay as they
are.

**3. What a reader runs it in.** The working is plain enough to run in
PostgreSQL, which is what the copy uses, and it avoids anything peculiar to
it. Which program a reader is told to use, and how, belongs with the zip in
strand 2. **Proposed:** settle it there. Proving it in a second program
(DuckDB, which reads CSV files directly) would mean installing it, so I'll ask
before doing that when we get there.

## What was done, 18 September

1. **Built.** `workings/days_between_stages.sql` holds the working above.
   `tools/published_copy.sql` runs it on the copy's own `bills` and `stages`,
   keeps the text in `workings`, and checks the file against the copy's own
   files (part 3). The connector no longer brings in the old sum.
2. **Rehearsed**, with the live copy set aside under another name: the build
   passed its check and was thrown away; one bill's outcome altered was
   caught, naming the bill and its four gaps; one gap made a day longer was
   caught, "days 71, the dates give 70"; nothing was left behind, and putting
   the old copy back worked.
3. **Taken for real** and compared with the old copy, cell by cell: all eight
   shared files identical, the days in the same order. The only differences
   were the agreed ones: the `workings` file, the two descriptions, and
   `about`'s extra line. The kept text is the file exactly, less its final
   line ending, which psql drops. Then the old copy was dropped.
4. **Papers**: the copy's runbook, `HOW-THE-DATABASE-WORKS.md`, the data
   dictionary (ten files), `DECISIONS.md`, and the closure test in
   `CLOSURE-TESTS.md`.
