# Decisions

Settled decisions, newest first. A decision here is not reopened without a
reason recorded as a new entry. Each says what was decided, when, and why —
the why matters more than the what, because it is what tells a later session
whether changed circumstances actually undermine the decision.

---

## 2026-09-11 — Stage 1 and Stage 2 completion dates, from the PhD. Partly settled: three parts open

Raised by the owner at the end of the session. **Not built, and nothing is built
until the three open parts below are settled**, under the rule recorded the
same day. It is the first task of the next session.

**Why.** The key research interest is how long a bill takes from introduction
to the end of Stage 3. The clean sheet already holds introduction and Stage 3
dates. Only two dates are missing: the end of Stage 1 and the end of Stage 2.
Royal Assent and Reconsideration are secondary.

**Settled by the owner:**
- **Stage 1 ends on the date of the Stage 1 debate.**
- **Stage 2 ends at the meeting at which the last amendments were disposed
  of.** Every bill has one, amendments or not. With no amendments, the
  committee (or, for an emergency bill, the Parliament sitting as a committee)
  still meets and agrees each section, even if it takes two minutes. So Stage 2
  always has a date.
- **This settles D2** for Stages 1 and 2, which `STATE.md` had kept open since
  2026-09-10. Methodology note M2, which says those dates do not yet exist,
  is rewritten when this is built.
- **The source is the owner's PhD dataset**, which covers Sessions 1 to 6. It
  is already on the list of sources ("ground truth where it covers a case").
  It is added gradually, a session at a time, starting with Sessions 1 and 2.
- **Order of work:** settle the open parts; build and rehearse; the owner loads
  the Session 1 and 2 dates; Session 1 is taken off and put back with them;
  then Session 2 is reviewed and promoted.

**Already agreed in outline:**
- **Where the dates sit:** the clean sheet already has a record per stage
  (Stage 1 and 2, or Preliminary and Consideration for a Private Bill), so it
  needs nothing new.
- **Provenance:** each stage record carries its own source and reference, so
  no provenance notes are needed.
- **Supplying the dates:** the owner fills in a spreadsheet per session, in
  `sources/phd/`, keyed by staging line number.
- **Checks:** dates must run in order (introduced, Stage 1, Stage 2, Stage 3),
  every passed bill must have both, and a bill rejected at Stage 1 has no
  Stage 2. For the eleven Stage 1 rejections already dated from the Official
  Report, the PhD's date must agree, which checks one source against the other.

**Open, for the owner:**
1. **Where the dates arrive.** Either (a) columns on the staging sheet, with
   columns for where each line's dates came from, or (b) a separate sheet of
   single facts, one row per date: which bill, which stage, the date, the
   source reference, when it was read. Recommended: (b). It is the home already
   agreed on 2026-09-10 for facts arriving about bills we already have; it
   copes with a date from a different source; and procedure, member in charge
   and party can use the same sheet later.
2. **Private and Hybrid Bills.** Do the Preliminary and Consideration Stages
   follow the same two definitions?
3. **Withdrawn and fallen bills.** Should the stage a bill had reached be
   recorded, where the PhD says? Six Session 1 bills currently have no stage
   information at all.

---

## 2026-09-11 — Provenance notes are rebuilt with their bill, not kept forever

`db/030`, `tools/rollback_promotion.sql`, `tools/promote_session.sql`. Decided
by the owner. **Amends D5 and reverses the append-only rule of `db/025`**,
which the 2026-09-10 entries "A description may not claim a rule the database
does not have" and "Our own rules are not facts of the world" had defended.

**The owner's position.** Provenance notes may change, provided the owner
clears the change. The owner is the judge of what is acceptable to claim as
academic quality, and treating these notes as permanent was completely
unnecessary.

**What happened.** For the second day running the rule got in the way, and
both times it was protecting our own work, not a source's words. On
2026-09-10 fixing a script's mistake meant suspending it (`db/027`). On
2026-09-11, re-promoting Session 1 to add routes would have left five
duplicate-looking outcome notes that could never be tidied. That was put to
the owner as though it were a constraint on them.

**What replaces it.** A provenance note is treated like a stage row:
- promotion writes it from the staging sheet, one note per fact, dated by the
  latest reading;
- taking the session off removes it;
- putting the session back writes it again.

**Clearance.** Approving that rehearsed procedure clears the notes it rebuilds,
since every note is shown before anything is saved. Any other change to a note,
by hand or in a migration, goes to the owner individually.

**What is given up.** The notes no longer hold a history of readings. The
source's own words stay on the staging sheet, which is never emptied. Nothing
yet records a second reading of a source that gives a *different* answer, and
no such revision has happened. How to record one is settled when the first
real case arrives, which is also recorded in `STATE.md`. `v_field_revisions`
stays, and will be empty until then.

**What stays.** A staging line's number is still its bill's number (`db/026`).
The rule was introduced to protect the notes, but it is still worth having:
line 17 is bill 17 in both directions, and nothing reaches the clean sheet
without a staging line behind it.

**Found while building it.** Rebuilding bill 17's note with the script as it
stood would have put back the instruction text `db/027` removed, because the
script appended the whole review note. It now writes the note without it.
Methodology note M5 told readers a blocked bill's earlier state "is recoverable
from field_source, which is append-only"; it now says the earlier state is in
the fact sheet lines held for every session.

---

## 2026-09-11 — A change to how data is coded is finished before anything moves on

Set by the owner, after the next entry was first recorded half done.

**What happened.** The 9.14.18 route was settled as a variable of its own and
then written up as "not yet built, and its home is not decided". A to-do list
went into `STATE.md`, and the recommendation was not to hold Session 2 for it.
Nothing would have stopped Session 2 being admitted and promoted without it. It
would have been finished only if a later session read the list and chose to do
it. That is the pattern that let `VARIABLES.md` contradict the database, and
left M7's "5 of 48 done" out of date. The cause was hurrying towards the next
question.

**The rule.** A methodology decision is not settled until every part of it is
settled, and it is not finished until every part is built:

- what it records and its values;
- which bills it applies to, and what an empty cell means;
- where it sits on the clean sheet;
- how it arrives on the staging sheet;
- how promotion carries it, and its provenance;
- what the error checker requires;
- what the methodology note tells a reader;
- every bill already coded under the old approach, rechecked;
- when it is built, relative to any session it touches.

Until then no session it touches is admitted or promoted, and no new question is
opened. "Not yet built" is not a state a decision may be left in. If the work
cannot be finished in the session, it becomes the first task of the next one,
stated as such at the top of `STATE.md`.

**Why.** Chaos comes from half-finished methodology, not from any single wrong
choice. The owner is the check on every research claim this project makes, and
cannot check a decision that exists in pieces across a review note, a to-do list
and an intention. This is not a race.

---

## 2026-09-11 — A Rule 9.14.18 motion is a Stage 1 vote reached by another route

`db/029` (the outcomes), `db/031` (the route's structure), `db/032` (the
routes recorded). Settled by the owner, from two Session 2 bills. **Built,
rehearsed and applied on 2026-09-11**; Session 1 was taken off and put back
to carry it.

**The cases.** The Provision of Rail Passenger Services (Scotland) Bill (9
November 2006) and the Civil Appeals (Scotland) Bill (20 December 2006) were
not defeated on the member's motion. The Presiding Officer's statement under
Rule 9.3.1 held each to be outwith competence. The lead committee lodged a
motion under Rule 9.14.18 that the Parliament does not agree to the general
principles, and the Parliament agreed.

**Outcome: rejected at Stage 1.** It was a vote on the general principles, and
the code's definition is "general principles not agreed to". A separate code
was considered and rejected. It would have said the bill ended some other way,
and it didn't.

**The route becomes a variable of its own.** The cases are rare, but they
matter to researchers. This entry was first written with the variable "not yet
built, and its home is not decided". That left the decision half made, and the
next entry exists because of it. Every part is now settled:

1. **What it records:** how the Stage 1 decision that ended a bill was reached.
   There are three values, held in a dropdown list:
   - *motion of the member in charge, disagreed to*;
   - *motion of the member in charge, amended to reject the general principles,
     agreed to as amended*;
   - *committee motion under Rule 9.14.18, agreed to*.

   "Member in charge" rather than "member's motion", so the first value also
   fits a Government Bill defeated at Stage 1. The third value's definition
   quotes the rule from the current Standing Orders, taken as unchanged since
   2006.

   **The second value was found by rechecking Session 1 (point 8), before
   anything was built.** The Proportional Representation (Local Government
   Elections) (Scotland) Bill, 6 February 2003, fitted neither of the first two
   values. Amendment S1M-3727.1, in Iain Smith's name, turned Tricia Marwick's
   Stage 1 motion into one that "does not agree to the general principles of
   this particular Bill" (65–54–2), and the motion as amended was agreed
   (65–53–3). The amendment's number, its mover and its stated reason go in the
   bill's note, not a variable: who moved it belongs to the later
   member-in-charge and party slice. The owner suspects the Parliament has since
   changed its handling of motions so this cannot recur; that has not been
   checked.
2. **Which bills:** only bills rejected at Stage 1, and every such bill must
   have a value; the error checker flags one without. An empty cell therefore
   means one thing only: the bill was not rejected at Stage 1.
3. **Where it sits:** on the bill, beside the outcome it qualifies. A bill has
   one Stage 1 decision, so nothing is lost, and an outcome-by-type table reads
   the bill's line. (The bill's Stage 1 record was considered first and
   rejected for that reason.)
4. **The limb, and the amendment:** our view of the limb goes in the bill's
   note, in a fixed form ("Rule 9.14.18: our view is limb (b)…"), followed by
   the grounds and the citation. For the amended route, the note records the
   amendment's number, its mover and the reason the resolution gives.
   The staging sheet gains a note column that promotion carries onto the bill.
   Without it the bill's note could never be filled, since the clean sheet is
   rebuilt from the staging sheet. That also blocked the rename dates and the
   s.33/s.35 mechanism, both already decided to go there.
5. **How it arrives:** a column on the staging sheet beside the Stage 1 date,
   from the same Official Report reading. This is a stated exception to the
   separate route for single facts (2026-09-10), and the exception is defined:
   facts about the decision that ended a bill, read at review. That separate
   route remains the home for procedure, member in charge and party.
6. **Where it came from:** promotion files a provenance note for the route
   citing the Official Report, as it does for the outcome.
   - **What it quotes:** its value seen is the Presiding Officer's
     announcement, word for word ("For 65, Against 53, Abstentions 3. Motion,
     as amended, agreed to."), because those are the words that tell the
     routes apart. The review note carries it in the fixed form `Result as
     recorded: "…"`.
   - **Its date:** the staging sheet gains a date for when the Official Report
     was read, and promotion dates Official Report facts by it: the outcome,
     the Stage 1 date and the route. Previously they took the date the
     factsheet was read. That was harmless for Session 1, where both happened
     on 10 September, but would have dated all of Session 2's Official Report
     facts a day early. The checker requires the date whenever anything on a
     line came from the Official Report.
   - **An extra check:** the checker flags a 9.14.18 route on anything but a
     Member's Bill, and the clean sheet refuses one, since the rule covers only
     Member's Bills.
7. **Telling readers:** methodology note M7 gains a paragraph covering what
   each of the three routes means, that the limb is our view, and that the rule
   text is the current one.
8. **Session 1:** its five Stage 1 rejections were rechecked against the
   Official Report on 2026-09-11. Four were the member in charge's motion,
   disagreed to; one was the amended route above. None was a 9.14.18 motion.
9. **When:** all of it is built, rehearsed and checked before Session 2 is
   admitted. **In this order:**
   - take Session 1 off the clean sheet, following the runbook;
   - change the structure (`db/031`);
   - record the eleven routes (`db/032`);
   - put Session 1 back.

   Session 1 has to come off first because the clean sheet cannot be given the
   rule "every Stage 1 rejection has a route" while five bills without one are
   on it.

In total that is one dropdown list, one column on the bill, and three on the
staging sheet: the route, the note to carry onto the bill, and the date the
Official Report was read.

**Which limb is a note giving our view, not a formal value.** Neither motion
cites a limb. The Local Government and Transport Committee's recommendation of
24 October 2006 repeats the words of limb (b) without its letter, and the
Justice 2 convener's grounds in the chamber do the same. So the formal record is
"a motion under 9.14.18", and "(b)" is our reading of the grounds.

**The rule text comes from the current Standing Orders.** The 2006 edition is
not published online. The owner is confident the rule has not changed, and a
coding may rest on what we take the rule to have been at the time, provided it
is triangulated against the motion and the grounds given for it.

**Consequence for promotion.** A review note now carries commentary after its
citation. `promote_session.sql` takes the provenance note's value seen from the
words before the first link only, so that commentary can never land in a
provenance note. That is the bill 17 lesson, applied before rather than after.
(At the time a provenance note could not be edited afterwards. That changed at
`db/030`, later the same day, but the rule about commentary still holds.)

---

## 2026-09-11 — "Extracts clean" meant the counts matched, and that was not enough

`db/028`, `tools/extract_factsheet.py`, `tools/load_session.sql`, and the
guard in `tools/promote_session.sql`. Found loading Session 2, which the
handover said needed no parser work because it extracts 81 rows against a
stated 81.

**The count was right and the rows were not.** Session 2's title cells hold
three things Session 1's never do: an SP Bill number after the title (15
bills), an asp number in brackets (2), and in one case an introduced title
after the asp number. The extractor separated none of them. The error checker
would have caught the asp numbers and nothing else, so fifteen bills would have
reached the clean sheet with their number inside the title and none in the
column for it. Reconciling against a factsheet's own totals proves no line was
lost. It says nothing about what is inside a line, and the survey read the
documents' structure, which is why it missed an introduced title printed inside
a cell.

**The staging sheet gets a place for an introduced title after all.** Recorded
on 2026-09-10 as deliberately not built, on the grounds that Session 1 states
none. Session 2 states one, and the clean sheet already has the column, so
without a staging column promotion has nothing to carry into it. Rename dates
and block dates are still not built; nothing loaded so far states one.

**The checker now flags an SP Bill number or an introduced title left in a
title.** Tested by planting each in a staging line inside a transaction that
was thrown away. Both were caught.

**A matching title does not make a bill a double count.** The Prostitution
Tolerance Zones (Scotland) Bill was rejected at Stage 1 in Session 1, and a new
bill of the same name was introduced in Session 2. Promotion refused any line
whose title was already on the clean sheet, so it would have refused Session 2.
The guard now requires the same title **and** the same introduction date: a
bill counted in two factsheets keeps its introduction date, and a reintroduced
one does not. That makes them separate bills, as VARIABLES §6 always said.
**Known gap, not fixed here:** the guard cannot see the European Charter and
UNCRC Bills, whose titles change from Bill in Session 5 to Act in Session 6. It
has to be dealt with before Session 6 is promoted.

**Loading is a script with a rehearsal, like promotion.** Nothing recorded how
Session 1 was loaded. `load_session.sql` takes `-v session=` and `-v save=` with
no defaults, refuses a CSV whose columns are not exactly the extractor's
current ones, and refuses a session that already has staging lines. It numbers
the staging lines itself, one after the highest in use, rather than taking
numbers from the sequence. A thrown-away rehearsal would otherwise still use up
numbers, and a staging line's number becomes a bill's number (`db/026`).

**M3 no longer states a count of introduced titles.** It said "three cases
across seven sessions"; Session 2 made it four. The count was removed rather
than corrected, for the same reason row counts came out of the table
descriptions.

---

## 2026-09-10 — Our own rules are not facts of the world

`db/027`. One provenance note held an instruction to the promotion script in
the column meant for a citation. It was corrected by suspending the
append-only rule for the length of one transaction and putting it back.

**Why this is written down.** The correction is trivial; the reasoning that
delayed it is not. `field_source` was made append-only that same morning, on
an empty table, by us. When the first mistake landed in it an hour later, it
was reported to the owner as something that could not be fixed. It could. The
rule was treated as a property of the world rather than a choice made that
day, and the owner had to argue for five minutes to get a one-line change
made.

**The rule stands and is not weakened.** It exists so a published record
revised in 2030 cannot be silently overwritten, leaving no trace the
Parliament changed its mind. That is worth the cost it imposes.

**The test for a future case.** Is the row a record of what a source said, or
debris from our own tooling? A source's words stay, always, even when they
turn out to be wrong — that is the entire point. Our debris is cleaned up, in
a migration that says what it changed and why. The distinction is not fine and
does not need adjudicating each time.

**The general form, which matters more than this instance.** Every rule in
this database was written by this project, most of them this month. A rule
that makes the data trustworthy is worth defending; the same rule protecting
a typo made by our own script, on data nobody outside the project has seen, is
not. Say which of the two is in front of you before saying something cannot be
done.

---

## 2026-09-10 — Promotion is a rehearsed procedure with a written undo

`tools/promote_session.sql`, `tools/rollback_promotion.sql`,
`docs/PROMOTION-RUNBOOK.md`. Session 1 promoted: 73 bills, 67 stage rows, 6
provenance notes.

**Both scripts require `-v session=` and `-v save=` with no default for
either.** A run with `save=false` does the entire job, prints the result and
discards it. Eight checks run before anything is kept and any failure aborts
everything, whichever way `save` is set.

**Why the procedure is written down rather than remembered:** it gets run
seven times, by whoever is here, and the value is in knowing what to look at
rather than what to type. The runbook names the five tables to read and what
each should say.

**Reversibility was rehearsed, not assumed.** Session 1 was promoted, taken
back off, and promoted again. After the undo: no bills, no stage rows, staging
lines unstamped, provenance notes still present because they cannot be
deleted. After promoting again: the same 73 bills with the same numbers, still
6 notes rather than 12, each pointing at the right bill. A third run changed
nothing. This is what `db/026` was for and it is now demonstrated rather than
argued.

**A provenance note is the one thing that cannot be tidied up afterwards.**
Demonstrated the hard way on the first run: bill 17's note has the whole
reviewer's comment as its reference, including a sentence that was an
instruction to whoever wrote the script. The script now files a short
reference, so later sessions are clean; that row cannot be. Recorded because
the lesson is general — read the provenance table before saving, not after.

**Withdrawn and fallen bills get no stage rows.** Six Session 1 bills have a
concluding date on the bill and nothing else, because the factsheet does not
say what stage they had reached. That is a gap in the source, not in the
schema, and it is listed as open in `STATE.md`.

---

## 2026-09-10 — A bill's number is its staging line's number

`db/026`. `bill.bill_id` no longer comes from a sequence. Promotion supplies
it, and it is the `candidate_id` of the staging row the bill was promoted
from. A foreign key from `bill.bill_id` to `bill_candidate.candidate_id`
enforces it.

**Why:** promotion being cheap to redo is what made it safe to promote Session
1 before the other six sessions were even loaded. It was nearly true and not
quite. `bill_candidate` is permanent, `stage_event` rows go with their bill,
and a staging row's `promoted_bill_id` empties itself. `field_source` was the
exception: it records which bill a note is about by the bill's number, and
`db/025` made it append-only, so those rows cannot be corrected. Empty `bill`,
promote again, the numbers come back in a different order, and six notes point
silently at the wrong bill. Stopping the numbers moving removes the problem
rather than managing it.

**A second thing it buys.** A bill can no longer exist without a staging line
behind it. The gateway rule was previously a property of the promotion script
being written correctly; it is now a property of the database.

**What it costs.** Bill numbers are no longer an unbroken run — the four bills
appearing in two factsheets (M6) take the number of the first line promoted, so
four candidate numbers are never used. `bill_id` was always our own invented
identifier, never shown to a reader, so a gap in it means nothing.

**Tested, not assumed.** A bill with a number no staging line has is refused; a
bill taking a real staging line's number is accepted; a bill with no number
supplied is refused, since nothing hands them out any more. `bill` is still
empty.

**Stage dates need no note of their own.** Checked while doing this: the five
Session 1 Stage 1 dates that came from the Official Report do not need a
`field_source` row, because a stage row carries its own `source`, `source_ref`
and `observed_at`. So all six of Session 1's provenance notes are about `bill`
columns — one corrected title and five outcomes — and all six are now stable
across a re-promotion. A stage row's number is still reissued on re-promotion,
which matters only for a second, later observation of the same stage date.

---

## 2026-09-10 — A description may not claim a rule the database does not have

`db/025`. Found by the owner reading the descriptions back, which is the check
`db/024` was built to make possible, working as intended on its first outing.

**Seven descriptions stated a rule that did not exist.** Five staging columns
said "must be a value in ref_x". Nothing checks them, and nothing should:
`bill_candidate` is permissive on purpose so a bad parse lands as a row that can
be looked at. Those are reworded to say where the check really is — on `bill`,
which is true today and stays true whenever the promotion script is written.

**The sixth was different and is now real.** `field_source` said rows are only
ever added, never changed. That was a convention held by whoever was typing, and
**D5 is settled on it** — the reason a revised published record is visible rather
than silent is that the earlier observation cannot be overwritten. A settled
decision resting on a habit is not settled. A trigger now refuses an update and a
delete, and it was tested rather than assumed.

**The cost is stated rather than left to be discovered.** A row entered in error
cannot be tidied away; correcting one means a migration that drops the trigger,
makes the change and puts it back, so the correction is itself part of the
record. Same reasoning as `db/016` admitting candidates by migration.

**The seventh was the check being wrong, not the database.** `fell_here` was
reported as unenforced and was not — a partial unique index has always refused a
second one. `pg_constraint` does not list plain indexes. Recorded because the
same mistake would pass a second review the same way.

**Descriptions say what the data is before how it was derived.** The staging
ones were written from the extraction script's point of view — "the outcome we
propose", "converted to a real date" — which is the wrong way round for the
person reviewing a row at the gate. Both belong, in that order. Row counts came
out of table descriptions: "seven rows" is true until it is not, and nothing
announces the change.

## 2026-09-10 — `methodology_note` stays a table, and the future-proof columns stay

Both raised as candidates for removal on the grounds that the database felt
complicated for 73 rows, and both settled by the owner against that.

**`methodology_note` is not moved to markdown.** The argument for moving it was
that seven rows of text feed a website that does not exist yet, and a file would
do for now. The owner's answer, and it is the right one: multiple markdown files
will kill us in the end. `docs/VARIABLES.md` is the proof — it still defines
columns, and several of its definitions now contradict the database. The
original decision stands and this entry records that it was challenged and held.

**`party`, `procedure` and their two lists stay.** Neither is used by the first
slice, so both fail "build only what the current slice needs" as written. Kept
deliberately as future-proofing, on the owner's judgement that re-adding them
later costs a migration either way and carrying them costs nothing.

**What the complexity question was actually answered with.** Of fifteen tables,
three hold bills, two are the gateway, one is the published notes, and nine are
lists of permitted words four columns wide. Of 130 columns, roughly 25 are
distinct facts; the rest is that four-column shape nine times over, plus the
same bill held three ways in staging — as printed, as read, as admitted. Every
piece that is not future-proofing traces to a specific bill or a specific
factsheet behaviour that forced it.

## 2026-09-10 — What the factsheet survey settled: seven decisions from reading all seven

`db/019`-`db/023`. The survey is `docs/FACTSHEET-SURVEY.md`; this records what it
forced. Taken in one sitting, while `bill` was still empty and structural change
was still free, which was the whole reason the survey came before promotion.

**The finding underneath most of the others: passing a bill is not the end of it.**
`db/013` had encoded the opposite as a `CHECK` — if a bill passed, it could have
no concluding date, because its Stage 3 date was its ending. Four bills say
otherwise, and they are four different endings from one starting point. Three
were referred to the Supreme Court under section 33 and ruled partly outwith
competence on the same day, 6 October 2021: two were reconsidered and enacted,
one was withdrawn on 10 March 2022, four years after it passed. The fourth, the
Gender Recognition Reform Bill, was blocked by a section 35 order on 16 January
2023 and nothing has happened since.

**Stasis is not a state of its own.** The owner's reading, and it is right: the
bill has been blocked, and nothing has happened since, which is exactly what
`blocked` means. `enactment_status` records a bill's current state, not its
history; the history is in `field_source`, which is append-only for this reason.
So no new vocabulary — but `pending` had to be tightened, because it said
"including referral", under which a bill referred and ruled against was
describable both ways depending which clause you read.

**A blocked bill does not fall at dissolution.** This is why the Session 7
factsheet carries the Gender Recognition Reform Bill as one of its own bills, and
why that is not an error on SPICe's part. An unfinished bill falls; a passed bill
that has been blocked has nothing left to fall from.

**`date_assent_blocked` is the one addition not forced by a constraint.** Stated
plainly so it can be struck if it is judged speculative. Without it `blocked` is a
state with no time attached, in a project whose second research question is time.
It does not duplicate `date_royal_assent` or `date_concluded`, because the
intervention and the ending are different events, and it stays populated after a
block is lifted — which is how the bills that were blocked and recovered can be
found at all.

**Two title columns, not one with a caveat.** `short_title` is the title the bill
is known by at the latest point there is evidence for; `title_as_introduced` is
the title at introduction, null where no source states it — which is most rows.
This is the third instance of the same shape: `bill_type_stated` beside
`bill_type` (D4), stage names by bill type (D6), and now titles. VARIABLES §3.2
defined `short_title` as the introduced title and was false for 62 of 73 Session 1
rows; M3 existed to publish that. It now describes coverage instead of apologising
for one column meaning two things. Null never means unchanged.

**Hybrid Bills keep their type and gain a grouping.** The requirement was to be
able to include or exclude them later. Coding the Forth Crossing Bill as
'government' would put a false value in the type column and make exclusion the
hard case; `ref_bill_type.analysis_group` leaves the type true and makes the
choice a matter of picking a column at query time. **The Session 3 factsheet
already makes this grouping and does not say so** — it defines a type letter `H`,
applies it to that one bill, then prints a summary with no Hybrid column and
counts it under Executive. Its stated 45 Executive bills are 44 plus one Hybrid.

**That is also the limit of the reconciliation gate, found rather than argued.**
Both sides total 62, so the gate passes on a document that has silently agreed a
Hybrid Bill is an Executive Bill. An arithmetic check against a source's own
totals catches a dropped row and does not catch a coding decision. Worth knowing
before six more sessions are reconciled the same way.

**A bill belongs to the session it was first introduced in.** The only definition
that survives a bill being reconsidered two sessions later. It means our
per-session counts will not match the factsheets', which count a bill in every
session it was live: 473 rows in the seven stated totals, 474 rows to read, 470
distinct bills. Published as M6, because a researcher checking our total against
SPICe's needs to find the explanation in the data and not in a repository.

**`sp_bill_id` is unique within a session.** SP Bill numbers restart each
session; SP Bill 13 is in Sessions 2, 6 and 7. Storing a qualified string like
'S5-70' was rejected because it invents an identifier the Parliament does not use,
and every comparison against a source would have to undo it.

**Why a bill fell is our coding, and it is 5 of 48 done.** No factsheet ever says
why a bill fell. Rejection at Stage 1, defeat at the final vote and running out of
time at dissolution are all one heading. M7 publishes that the distinction is
ours, against the Official Report, and that it is mostly not yet made — so a
reader does not take the general code as a finding.

**What was deliberately not built.** `bill_candidate` gets no column for a stated
introduced title, a rename date or a block date: Sessions 4-7 state them and
Session 1 states none, so building now would be speculative. And the
session-window checks in `v_candidate_problems` compare a candidate's dates
against the session of the factsheet it was read from, which is the wrong session
for a carry-over row; Session 1 has none, so the limitation is written into the
view's own comment rather than fixed, and it must be handled before Session 5 is
loaded.

**Rename dates get no column.** Two bills in seven sessions state one; both go in
`bill.note`. Revisit at a third case.


## 2026-09-10 — Stage dates return to `stage_event`, under each bill type's own stage names. D6 settled

`db/018`. Reverses the stage-date half of `db/004` and the whole of `db/005`, and
settles D6, opened earlier the same day.

**The principle, in the owner's words:** record the appropriate nuance for each
type and normalise afterwards if we need to, rather than shoehorning different
kinds of bill procedure into a single class because that is neater.

**What that means here.** A bill's stages are recorded under the names those
stages actually have for that kind of bill — Stage 1, 2 and 3 for a public bill;
Preliminary, Consideration and Final Stage for a Private or Hybrid Bill — in
`stage_event`, one row per stage reached. `ref_bill_type_stage` records which
sequence belongs to which bill type, and a trigger enforces it: the database now
refuses to record a Stage 2 against a Private Bill, or a Preliminary Stage
against a Government Bill, or a valid stage name at the wrong position.
Comparison across types is done in a view, on `stage_order`, with the real stage
names carried through into the output so it is always visible what is being
compared with what.

**This is the same shape as `bill_type_stated` beside `bill_type`,** which is why
it is consistent rather than novel. D4 exists to stop the normalised value eating
the contemporaneous one. The identical argument applies to stages.

**Why reversing `db/004` is legitimate rather than a change of mind.** That
decision moved stage dates onto the bill row because "a bill becomes one line to
type, which is what a hand-build needs". The reason was about typing. Rows are
now extracted programmatically and the reviewer edits a staging row, so the cost
that justified collapsing the stages has largely gone — the promotion script fans
one candidate row out into several stage rows, which costs nothing because it is
a script. `db/003` had originally built the duration views on `stage_event` in
exactly this way; `db/018` substantially restores them.

**What did not move, and why.** `date_introduced` and `date_royal_assent` stay on
`bill`. Every bill type has both, under the same name, so no nuance is lost by
holding them as columns, and moving them would duplicate two fields that existing
constraints depend on. The distinction being served is that stage *names* differ
by bill type; introduction and Royal Assent do not. `date_concluded` stays for
the same reason — a bill being withdrawn is not a stage.

**`ref_stage.applies_to` was dropped.** It marked the three private stages
'private', which left Hybrid Bills unaccounted for, and its `CHECK` allowed only
public/private/both so it could not have said otherwise. It was also a second
answer to a question `ref_bill_type_stage` now answers properly, and two sources
of truth about which stages belong to which bills is how the wrong one gets used.

**Cost, stated honestly.** Nothing is populated. Five Stage 1 dates from the
Official Report and 62 passing dates is the whole of the stage data in existence,
and it sits in `bill_candidate`. This builds the shape that promotion writes
into, while `bill` is empty and the shape is free to change. Filling it is
expected to be gradual — from the PhD, from the Official Report, and from the
Parliament's API — which is the working assumption for this project generally
rather than a caveat about this decision.

## 2026-09-10 — `stage_event` is kept: Private Bills are the reason that was waiting to appear

`db/004` moved stage dates onto the bill row and left `stage_event` in place but
empty, with the instruction to drop it "unless a reason to keep it appears".
`db/017` drops the other empty table, `scratch_test`, and deliberately leaves
this one. This entry records the reason, so the instruction is answered rather
than quietly ignored.

**Private Bills do not have Stages 1, 2 and 3.** They have Preliminary,
Consideration and Final. Session 1 contains three of them — one passed, two
fell — and the one that passed currently has its Final Stage date sitting in a
column named `end_stage_3_date`. The column does not mean what its name says for
those rows. Later sessions have more.

Three columns on the bill row cannot express this. `stage_event` was built with
`stage_order` precisely so that a Private Bill's third stage could be compared
with a public bill's third stage without asserting that they are the same stage.
It also distinguishes a stage *reached* from a stage *completed*, which a bare
date column cannot: a bill sitting in Stage 2 at dissolution has no Stage 2 date
and that is not the same as never having got there.

**Why this matters now rather than later:** the second question in the first
slice is time taken to complete each stage. It is not a future concern that
Private Bills have different stages; it is a mis-description already present in
Session 1's data.

**Not resolved here.** Keeping the table is not a decision to use it. The
options — name the columns generically, record a stage vocabulary per bill type,
or populate `stage_event` after all — are open, and are recorded as **D6** in
`STATE.md`. Dropping the table would have quietly foreclosed the third option
and removed the artefact that best explains the problem.

## 2026-09-10 — A new variable stages in one field-level table, never as a new column on `bill_candidate`

Settled in answer to "when I want to add procedure later, where does it go?"
Nothing is built for it yet; this records the shape so the first case does not
have to invent one under pressure.

**`bill_candidate` is not the staging table. It is the *factsheet* staging
table.** Its `raw_*` columns are the factsheet's own columns and its unique key,
`(session_number, raw_section, raw_title)`, is a factsheet address. Its shape
belongs to its source.

**So the split is by how a fact arrives, not by which variable it is.**

- *Arriving as whole bills* — another session's factsheet, later the API. That is
  row-shaped, and stages in a table shaped like that source.
- *Arriving one field at a time about bills that already exist* — `procedure`,
  member in charge, party. That stages in a single field-level table: which bill,
  which field, the proposed value, the source's own words, where it came from,
  when it was read, and the same `review_status` gate. Adding procedure means
  adding rows to it. Adding party later means adding rows to the same table.

**Why not a column on `bill_candidate`.** No factsheet states procedure. A column
there would sit empty across all ~473 rows and would make the table a less
honest record of what SPICe said — which is the job `DECISIONS.md` gives it when
it says the table is kept permanently as provenance.

**Why not a table per variable.** They would all carry the same handful of
columns and each would need its own near-identical promotion step.

**`bill` itself is where a column does get added,** and `procedure` is already
there, nullable and empty, waiting for evidence — which is what `db/010` set it
up to be. `field_source` is the admitted half of this and already exists; what is
missing is the candidate half in front of it.

## 2026-09-10 — The database is dumped into the backup path, and a restore is tested rather than assumed

`db/016` and the amended `/usr/local/sbin/legdata-backup`.

Between the 2026-09-09 clearance and today, **nothing backed up the database.**
The nightly job took `/etc` under the `system` tag and skipped its `data` tag
every night, because `/srv/legdata` no longer existed and the script treats that
absence as normal. PostgreSQL's own files were in scope for neither. The machine
was rebuildable and the data was not, for a project whose first principle is that
the database is the product. A day of hand-coding existed in one place.

**Why a dump into the existing path rather than new machinery:** retention,
verification, encryption and off-site transport to the storage box were all
already built and working. The only missing step was putting the data where they
could see it.

**A backup is not a backup until it has been restored.** Exit status zero proves
a script ran, not that anything can be recovered. The chain was tested end to
end — snapshot fetched back from the storage box, restored into a scratch
database, checked for the expected 73 candidates and that day's edits, scratch
database dropped. The restore procedure is written down in
`legdatavps/legdata-vps-notes.md`; it is worth nothing if it is only ever
reconstructed from memory during an emergency.

## 2026-09-10 — Admission to the gateway is recorded as a migration

`db/016` sets Session 1's 73 candidates to `accepted`, rather than that being
typed into a client.

**Why:** `review_status` is the gateway. If the record of what was admitted, and
on what basis, exists only in a database client's query history, then the single
column the architecture depends on is the one with no provenance of its own.
`db/010` set the precedent by carrying its own data fix.

The migration also refuses to admit anything while `v_candidate_problems` is
non-empty. "Work the list to empty before promoting" was an instruction in a
document; it is now a precondition that cannot drift away from the instruction.

## 2026-09-10 — `date_concluded` restored; Act titles accepted in `short_title`

Two questions raised by the Session 1 extraction, settled at the close of that
session. `db/013`.

**`date_concluded` returns to `bill`.** `db/004` dropped `date_outcome` on the
reasoning that for a bill that passed or was defeated the outcome date is the
Stage 3 date. That is true for the 62 Session 1 Acts and false for the other 11:
a bill that was withdrawn or fell has a date that is not a stage completion, and
it had nowhere to go. The new column is narrower than the one dropped — it holds
only that case, and a `CHECK` keeps it empty for a bill that passed, so it cannot
drift back into being a second, competing outcome date.

**`short_title` carries the Act title where a bill was enacted.** VARIABLES §3.2
defines it as the title as introduced, and for 62 of 73 Session 1 rows it is not.
Sourcing the introduced titles separately was rejected as disproportionate for
the first slice. Instead the divergence is published, as methodology note M3, and
`bill_candidate.title_kind` records which kind of title each row carried, so the
choice is visible per row rather than assumed.

**Why publish rather than fix:** a title, the styling of the bill type, and the
Session 4 `G*` marker are three instances of the same thing — a value that
differs between introduction and passage. The slice does not need any of them
resolved; it needs them not to be silent. VARIABLES §3.2 should be amended to
match.

## 2026-09-10 — Factsheet rows are extracted into staging and admitted by review

Amends, and does not reverse, the hand-entry decision below. Extraction writes to
`bill_candidate`; nothing reaches `bill` except by review and explicit promotion.

**Why:** the hand-entry decision gave three reasons. The first — that parsing
seven read-once documents costs more than reading them — is weakened: the
factsheets are Word-generated with a clean text layer, sessions 1-5 are ruled
tables and 6-7 a fixed prose grammar, and there are ~473 bills rather than a few
dozen. The second — that PDF extraction fails quietly — is answered here
specifically, because each factsheet prints its own outcome-by-type cross-tab,
so an extraction can be checked against the source's own arithmetic before
anyone reads a row. The third reason is untouched and is why this is an
amendment rather than a reversal: the factsheets are *derived*, the outcome
coding is SPICe's judgement, and reading it is how a divergence from the thesis
gets noticed. Under this decision the reading still happens, at the gateway, on
a populated row instead of an empty one.

**The gate has already earned itself.** Sessions 1 and 2 reconcile exactly.
Sessions 3, 4 and 5 come up short by 2, 14 and 6 rows, because pdfplumber
fragments tables that break across a page and a data row is consumed as a
header. None of it reached `bill`.

**Consequence:** `bill_candidate` is kept permanently, not cleaned out. It is the
provenance — `promoted_bill_id` ties every admitted bill to a page and to the
factsheet's verbatim words; it is how a reissued factsheet is diffed against what
was admitted; and it is the reference dataset automation is later measured
against. Rejected candidates stay, with `review_note` recording the judgement.

## 2026-09-10 — `procedure` is nullable; 'standard' is a finding, not a default

`bill.procedure` was `NOT NULL DEFAULT 'standard'`. Both dropped in `db/010`.

**Why:** no source consulted so far states procedure — the factsheets have no
such column. The default recorded four Budget Acts and the Mental Health (Public
Safety and Appeals) Act 1999 as standard procedure as a positive fact, on no
evidence. Null now means not known, and 'standard' is something established.
Same distinction `party` already draws between null and Independent.

## 2026-09-10 — The stated bill type is recorded alongside the normalised one

`bill.bill_type_stated` references a separate `ref_bill_type_stated`.

**Why:** researchers will want the Executive/Government split, and it is cheaper
to capture on the way past than to reconstruct. A separate lookup rather than
adding 'executive' to `ref_bill_type`, because a value in the research vocabulary
would appear in outcome-by-type cross-tabs and split the government series —
which is what D4 exists to prevent.

**It cannot be derived.** The changeover is not the 2007 renaming of the Scottish
Executive. The Session 4 factsheet marks bills `E`, `G` and `G*`, the last
footnoted 'Introduced as an Executive Bill (E)', for bills introduced in 2011 and
2012. Sessions 1-3 are `E` throughout, session 5 onward `G`. So the label follows
neither the session nor the introduction date, and has to be recorded as stated.
`bill_type_stated` means as introduced, so `G*` is 'executive'.

## 2026-09-10 — Methodology notes are data, not prose in the repository

`methodology_note` holds the text of each value judgement; the front end reads it
and shows it against the variables named in `applies_to`. The wording is seeded
by a migration, so it stays version-controlled.

**Why:** the two judgements in the first slice — counting Executive Bills as
Government Bills, and treating the date passed as Stage 3 completion — are both
defensible and both invisible in the numbers. A note kept only in the repository
drifts from what the site shows. `DECISIONS.md` records that a decision was taken
and why; `methodology_note` records what a reader of the data must be told. They
are different documents with different audiences.

## 2026-09-10 — The database is the product; sources are candidates

Nothing is written as fact by any process. Every source produces a candidate
that is checked before admission, whatever the source. Automation, when it
comes, proposes rather than writes.

**Why:** previous attempts let extraction write directly, so an unbounded
residue of edge cases sat on the critical path. Under a gateway, partial
automation is still useful and failed automation costs nothing.

## 2026-09-10 — First slice: outcome by bill type, and time per stage

Across all sessions. Nothing else — no member in charge, party, votes or text.

**Why:** the minimum most users want, buildable by hand in about a day, and
therefore usable as the reference dataset that later automation must reproduce.

## 2026-09-10 — Hand-build before automation

The first slice is entered by hand. Automation is attempted afterwards and is
accepted only if it reproduces the hand-built values.

**Why:** the failure mode is chain length — variable to source to assessment to
edge cases to gaps to reconciliation, with no checkpoint. Hand-building produces
both a ground truth and a written list of the real edge cases, which converts an
open-ended judgement problem into a pass/fail one.

## 2026-09-10 — PostgreSQL on the VPS, reached over SSH

Data lives on the VPS from the start, not locally. Postgres 17 listens on
loopback only; clients tunnel in over SSH.

**Why:** starting on the server avoids a migration later and means there is one
copy of the truth. Loopback plus tunnel keeps port 5432 off the public internet
and leaves the existing firewall untouched.

## 2026-09-10 — SSH forwarding relaxed, pinned to the database port

`AllowTcpForwarding local` with `PermitOpen 127.0.0.1:5432`, replacing
`AllowTcpForwarding no`. Original config kept as `.pre-db-tunnel.bak`.

**Why:** DBeaver needs a tunnel, and the alternative — exposing 5432 through the
firewall — means a public database, TLS to configure, and a rule that breaks
whenever the client IP changes. `PermitOpen` means the relaxation reaches
Postgres on loopback and nothing else.

## 2026-09-10 — D1 settled: outcome and enactment are separate variables

`outcome` records what Parliament did; `enactment_status` records whether the
bill became an Act.

**Why:** passing and becoming law are different events, and the gap between them
is of research interest — a bill can pass and be referred, or pass and be
blocked from assent. A single combined list makes those cases unfindable and
turns "how many bills passed?" into a sum over several values.

**Reversing it:** a combined view over the two columns, or a generated column.
No data would need re-entering.

## 2026-09-10 — D4 settled: bill type and procedure are separate variables

`bill_type` is who introduced it; `procedure` is how it was handled.

**Why:** an emergency bill is a government bill that compressed its stages. In a
single list it stops counting as a government bill. This matters directly for
slice 2, where emergency and budget bills complete in days and would otherwise
distort every duration average.

**Reversing it:** `coalesce(nullif(procedure,'standard'), bill_type)` gives the
combined list as a view.

## 2026-09-10 — Vocabularies as lookup tables, not Postgres enums

Each controlled vocabulary is a `ref_*` table with a readable text code, and
columns carry the code as a foreign key.

**Why:** values can be read, added and re-labelled in the grid without writing
DDL, each value carries its own definition, and `bill.bill_type` displays
'government' rather than an integer that needs a join to interpret. Postgres
enums require `ALTER TYPE` and cannot drop a value.

## 2026-09-10 — Postico 2 as the entry client

Chosen over DBeaver, which stages grid edits behind an explicit save and caused
changes to appear made when they had not been sent.

**Why:** it writes on leaving a row, which is the spreadsheet behaviour wanted,
and it is a desktop client rather than another service to run and secure. Both
data and DDL changes were verified reaching the VPS independently.

## 2026-09-10 — Stage end dates live on the bill row

`date_outcome` dropped. `end_stage_1_date`, `end_stage_2_date`,
`end_stage_3_date` and `reconsideration_stage` added to `bill`. The duration
views read from these rather than from `stage_event`.

**Why:** a bill becomes one line to type, which is what a hand-build needs. The
outcome date was redundant once the stage dates exist — for a bill that passed
or was defeated it is the Stage 3 date.

**Consequence:** `stage_event` is now unused. It is left in place but empty, and
should be dropped unless a reason to keep it appears. Anything needing more than
a date per stage — committee, votes, amendments — is a later slice and would
justify bringing it back.

## 2026-09-10 — Party as a lookup, null distinct from independent

`bill.party` references `ref_party` and is nullable.

**Why:** null and Independent mean different things. Null is "not applicable or
not known" — which covers law officer bills, where no member is attached.
Independent is a positive fact about a member who sits without a party. A single
text field would blur the two on entry.

## 2026-09-10 — First-slice data entered by hand from the SPICe factsheets

Not parsed programmatically. `ref_source` gains `spice_factsheet`; rows taken
from a factsheet record it as their source, with session and retrieval date in
`source_ref`.

**Why:** parsing seven documents that are each read once costs more than reading
them, and PDF extraction fails quietly — a shifted column, a footnote absorbed
into a cell. It would rebuild the long unchecked chain the project exists to
avoid. The factsheets are also *derived*: the outcome-by-type coding is SPICe's
judgement, and reading it surfaces where it differs from the thesis where a
parser would silently adopt it.

**Where automation does belong:** reconciling entered totals against the
factsheet's own stated counts. Session 6 states 82 bills, 62 Government, 20
Member's, 52 Acts, 4 withdrawn as at 6 March 2026. Cheap arithmetic checks that
catch a mistyped row without re-reading the PDF.

**Evidence for the caution:** the factsheet path serves soft 404s — HTTP 200
with an HTML error page for files that do not exist. A first automated sweep
"found" seven factsheets; five were error pages.

## 2026-09-10 — Provenance per field, and D5 settled with it

`field_source` records the source of an individual field where it differs from
the row-level source. Append-only, with `value_seen` holding the value in the
source's own words.

**Why:** one source per row is insufficient — a bill's outcome will come from a
factsheet while its dates come from the Official Report, and that is the normal
case rather than the exception. `docs/VARIABLES.md` originally argued for
row-level only; that was wrong and has been rewritten.

**This settles D5.** Because the table is append-only, a revised published
record produces a second observation rather than overwriting the first, so the
change is visible. `v_field_revisions` lists fields whose value has changed.

**Not required for the first batch.** The row-level source remains the default
and is enough while a whole row comes from one factsheet. `field_source` is
there for when that stops being true.
