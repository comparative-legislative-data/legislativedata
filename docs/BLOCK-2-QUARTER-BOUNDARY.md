# A bill introduced on the day a quarter begins

For the owner. Written 18 September 2026. Block 2, item 2 of
`docs/PHASE-2-CHARTS-BUILD.md`. **Agreed on 17 September:** a bill introduced
on the day a quarter begins counts in that quarter, the later one. This
settles every part of doing it, before anything is built.

## How a quarter is worked out today

In the mock-up of thought 5, a bill's place in its session is a fraction:
the days from the session's first meeting to the bill's introduction, divided
by the days from that first meeting to the session's last day (for Session 7,
the day it is expected to end, M14). Under a quarter of the way through is the
first quarter, and so on. In a spreadsheet it is `=INT(4 * place) + 1`, with a
bill on the last day itself put in the fourth.

A bill exactly on a boundary already goes in the later quarter. So the rule as
agreed is what the mock-up does. Nothing about it changes.

## The one thing to decide: what "the day" means

**A quarter usually begins partway through a day.** Session 1 ran 1,419 days,
so its second quarter begins 354¾ days in, during 30 April 2000. Of the 21
places where a quarter begins, in all seven sessions, only three fall exactly
at the start of a day (the third quarter of Sessions 2, 4 and 5). The other 18
begin partway through one.

So a bill introduced on 30 April 2000 could go either way:

- **A. The later quarter only from the first whole day inside it.** The bill
  on 30 April 2000 is in the first quarter, because the day began before the
  quarter did. This is the spreadsheet formula above, and what the mock-up
  does. A reader can check any bill with a date and a calculator.
- **B. The later quarter from the day it begins, even partway through.** The
  bill on 30 April 2000 is in the second quarter. A reader would need the rule
  explained to check it, since the formula needs rounding up at the boundary
  instead of down.

**Proposed: A.** It is the plain arithmetic, so the figures can be checked by
anyone who downloads the dates. It also meets the agreed rule: a bill on the
day a quarter begins, where that day starts at the boundary, counts in the
later quarter.

**Either way, no bill moves.** No bill falls on any of the 21 days. The nearest
is the Tied Pubs (Scotland) Bill, a day before Session 5's fourth quarter, and
it sits in the third quarter under both readings. No bill falls on a session's
first or last day either.

## The nine parts

**1. What it records, and its values.** A rule, not a value. A bill is in
quarter 1, 2, 3 or 4. At or past a boundary is the later quarter, by whole
days (option A); the last day is the fourth.

**2. Which bills it applies to, and what an empty cell means.** All 470. Every
bill has a date introduced, and every session has a first meeting and a last
day, real or expected, so no bill is without a quarter. There is no empty cell.

**3. Where it sits on the clean sheet.** Nowhere. Nothing is stored. The
quarter is worked out when the published copy is taken, like every chart's
figures (agreed 17 September).

**4. How it arrives on the staging sheet.** It doesn't.

**5. How promotion carries it, and its provenance.** Promotion doesn't touch
it, and no provenance line is written, because no fact about a bill changes.
Its record is an entry in `DECISIONS.md`.

**6. What the error checker requires.** Nothing new now. When thought 5 is
built, its calculation checks that every bill is in exactly one quarter and
that they add up to 470. That goes in thought 5's own checklist.

**7. What the methodology notes tell a reader.** No note changes now. There is
no note on how quarters are worked out, and none can be written yet: notes
name the published headings, and the copy has no quarter heading until thought
5 is built. Writing a note now would describe something a reader cannot see.
Proposed instead: settle the sentence now, and put it into thought 5's note
when that is written. Draft, for you in full:

> A bill's place in its session is the number of days from the session's first
> meeting to the day the bill was introduced, divided by the number of days
> from that first meeting to the session's last day. Each quarter is a quarter
> of that span. A quarter begins at the first whole day inside it, so a bill
> introduced on the day a quarter begins counts in that quarter, and a bill
> introduced on the session's last day counts in the fourth. No bill has yet
> fallen on the day a quarter begins.

M14 is unchanged. Its line that Session 7's quarters are an estimate already
covers the fact that Session 7's boundaries move if its expected last day does.

**8. Every bill already coded under the old approach, rechecked.** Nothing is
coded. The check that stands in for it is the one above: under either option,
no bill's quarter differs from the mock-up's.

**9. When it is built.** Today. No change to the database. The rule is
written where thought 5's calculation will read it:

1. `docs/PHASE-2-CALCULATIONS.md`, chart 5: "needs a rule" becomes the rule,
   with the draft sentence.
2. `docs/PHASE-2-MOCKUP-CALCULATIONS.md`: the calculation's comment "proposed,
   not agreed" becomes "agreed", naming option A.
3. `docs/PHASE-2-CHARTS-BUILD.md`, block 2: marked done.
4. `DECISIONS.md`: one entry.
5. A short closure test for another session: the three documents say the
   rule; the check in "Either way, no bill moves" repeated, with the same
   answer.

**The undo** is the same edits reversed. Nothing else depends on them yet.

## What I need from you

- **A or B**, for a bill on the day a quarter begins partway through.
  Proposed: A.
- **The draft sentence**, as it stands or changed.
- Anything in the nine parts you'd change.
