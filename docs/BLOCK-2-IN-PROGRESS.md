# "In progress" moves to the end of the outcomes list

For the owner. Written 18 September 2026. Block 2, item 1 of
`docs/PHASE-2-CHARTS-BUILD.md`. **Agreed on 17 September:** "In progress" goes
last, because it is not an ending, and every other outcome keeps its place.
What that meant was settled; this settles every part of doing it, before
anything is built.

**Agreed by the owner the same day: option A, no standing rule, no other
changes. Built the same day** (`db/118`, the copy retaken). The closure test
is written and unrun. The record is at the end.

## What is wrong today

Each outcome has a number saying where it comes in the list. Two of them share
7:

| Place | Outcome | Bills |
|---|---|---|
| 1 | Passed | 404 |
| 2 | Rejected at Stage 1 | 27 |
| 3 | Rejected at Stage 3 | 3 |
| 4 | Withdrawn | 17 |
| 5 | Fell at dissolution | 17 |
| 6 | Fell (other) | 0 |
| 7 | In progress | 1 |
| 7 | Fell: financial resolution not agreed | 1 |

So nothing decides whether the Creative Scotland Bill or Session 7's bill in
progress comes first in a chart or a table. **The published copy has the tie
too**: its `what_the_words_mean` file gives both an `order` of 7. This is the
only list of the twelve with a tie. I checked all of them.

## One thing to decide first: how the copy is retaken

**The script that takes the copy refuses if there is already one live.**
That was deliberate. Putting a new copy over an old one, keeping the old one
for the undo, and filling `what_changed` all belong to block 3, the refresh,
which isn't built yet. So "retake the copy" can be done two ways:

- **A. Drop the live copy and take it again, exactly as on 18 September.**
  Nothing reads the copy until block 4, so nobody sees it disappear. The script
  is proven, and the rebuild takes seconds. `what_changed` stays empty, as it
  is now. The undo is the same move in reverse: put the 7 back and retake.
- **B. Build the refresh first, and let this change be the first thing it
  carries.** `what_changed` would then say, from the start, that "In progress"
  moved from 7 to 8. But the change can't be finished until block 3 is, and
  that means building a change in the working data and then waiting on it.
  The rules don't allow that.

**Proposed: A.** It finishes inside one session. The refresh will get a
proper first test of its own in block 3 anyway. The first copy taken by the
refresh will be compared with this one, and this change will already be in
both.

## The nine parts

**1. What it records, and its values.** One number changes: "In progress" goes
from 7 to 8. Its name, its definition and whether it counts as an ending stay
as they are. So do all the other seven outcomes, including the order of the
two "Fell" outcomes. *(An earlier write-up, `docs/PHASE-2-CHARTS.md`, proposed
swapping those two as well. The 17 September agreement replaced it, and it is
not being done.)*

**2. Which bills it applies to, and what an empty cell means.** No bill
changes. No bill's outcome is touched, and one bill has this outcome: Session
7's. There is no new empty cell. Every outcome already has a place in the list.

**3. Where it sits on the clean sheet.** Unchanged. The number lives in the
list of outcomes, not on any bill.

**4. How it arrives on the staging sheet.** It doesn't. The staging sheet
uses the same list of outcomes, so it follows automatically.

**5. How promotion carries it, and its provenance.** Promotion doesn't touch
the list, so nothing changes there. No provenance line is written, because no
fact about a bill has changed. The change's own record is the numbered file
`db/118` and an entry in `DECISIONS.md`.

**6. What the error checker requires.** Nothing new. Proposed: **no standing
rule against ties.** There has only ever been one, and a rule would be a
structural change for the sake of it. Instead, `db/118` refuses to finish if
any outcome still shares a place, and the closure test checks all twelve lists
for ties, not only this one.

**7. What the methodology notes tell a reader.** Nothing. No note mentions
the order. The reader sees it only in the copy, as `order` in
`what_the_words_mean`, and that heading's description ("Where the word comes
in its list, for sorting.") is still true.

**8. Every bill already coded under the old approach, rechecked.** There is
nothing to recheck bill by bill. The check that stands in for it: the working
data is the same after `db/118` as before it, apart from that one number. A
fingerprint is taken of every bill, stage, provenance line, note and list
before the change, and compared afterwards, the way `db/115` and `db/116` did
it.

**9. When it is built.** Today, in this order:

1. Write `db/118`, rehearse it, and throw the rehearsal away.
2. Rehearse the retake in a scratch workbook: take the copy with the new
   order, and check it with the copy's own every-cell check.
3. Run `db/118` for real.
4. Drop the live copy and take it again (option A). Its own check must pass.
5. Look at the result, the way you did on 18 September in Postico: the eight
   outcome lines in `what_the_words_mean`, "In progress" at 8. Every other
   file should match the 18 September copy line for line. That is checked by
   comparing fingerprints of each file before and after.
6. Regenerate the data dictionary. It shouldn't change, since only a number
   in a list moved and the dictionary doesn't print the lists.
7. Write the closure test for another session to run.

**The undo**, written down before step 3: put 7 back, drop the copy, retake.
It is rehearsed as part of step 2.

Nothing is admitted or promoted, and no new question is opened, until step 7
is done.

## What I need from you

- **A or B** for the retake. Proposed: A.
- **No standing rule against ties**, only the refusal in `db/118` and the
  check in the closure test. Agree?
- Anything in the nine parts you'd change.

## What was done, 18 September

- **Rehearsed**, each inside a transaction that was thrown away: `db/118`
  ran; a second run was refused; the undo gave back exactly what had been
  there; a second undo was refused. Two deliberate faults (another outcome's
  definition altered, and another list altered) were each caught by
  `db/118`'s checks. The retake with the working data unchanged gave a copy
  identical to the live one in every file.
- **Done**: `db/118` ran, and its checks passed. The live copy was set aside
  as `taken_18_september`, and the unaltered build took a new copy, with its
  own check finding nothing. The two copies differ in one line: "In progress"
  under `outcome`, order 7 to 8. The old copy was dropped.
- **Afterwards**: 470 bills, 1291 stage records, 192 provenance notes and 14
  notes. The checker and the gaps list are empty, and the data dictionary is
  unchanged. `published` holds only `live`.
- **Where it differed from steps 2, 4 and 5 above.** Step 2 was rehearsed in
  the real `published` workbook, inside a thrown-away transaction, rather than
  in a scratch one. The working data could not be changed inside the same
  transaction, since it is a different workbook, so the rehearsal showed that
  the retake reproduces today's copy exactly, not the new order. The new order
  was proved by `db/118`'s own rehearsal. In step 4 the old copy was set aside
  rather than dropped first, so the comparison in step 5 was of every line,
  not of fingerprints, and the undo was one rename until it was dropped. Your
  look in Postico, step 5, is item 10 of the closure test.
