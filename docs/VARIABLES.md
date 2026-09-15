# Variables — why they are shaped as they are

This file holds the reasoning behind the variables: why the data is cut up the
way it is, how time is measured, and which questions are still parked. It holds
nothing factual about the schema.

Three documents divide that work between them, and it is worth being clear which
is which:

- **`DATA-DICTIONARY.md`** says what every table and column *is*. It is
  generated from the database, so it cannot drift.
- **The methodology notes** — M1 to M13, held in the database and published
  beside the data — tell a reader what a judgement *was*. They do not explain
  how it was arrived at; that was settled on 15 September.
- **This file** says *why* the variables have the shape they do, and
  **`DECISIONS.md`** records each decision on the day it was taken, with its
  reasoning and, for several, how it could be reversed.

So when a question is settled it moves out of here and into `DECISIONS.md`. What
stays here is the reasoning a later session needs in order to know why the data
was managed this way — particularly when presentation begins, and again when
ingestion resumes.

## 1. What the first slice had to answer

1. Outcome by bill type, all sessions.
2. Time taken to complete each stage, by bill type and session. The main
   interest is introduction to the end of Stage 3.

Settled on 10 September. Everything built in the first slice exists to serve
those two questions, and the shape of the data is only defensible in their
light.

## 2. How time is measured

**Calendar days, not sitting days.** Recess makes calendar days misleading, and
the Parliament's own rules count some minimum intervals in sitting days, so
sitting days are in one sense the truer measure. They need a calendar of when
the Parliament sat, which is its own body of work and is not built. Calendar
days need nothing beyond the dates already held.

The decision is therefore: **report calendar days now, and add sitting days
later as an alternative measure once a calendar exists**, rather than delay the
first slice for it. Every duration this resource publishes today is calendar
days, and a chart should say so. This is the reason it is safe to build those
charts before the calendar exists — and the reason that adding the calendar
later changes nothing already recorded, because no duration is stored.

**No derived measure is stored.** Outcome by bill type is a cross-tab of the
bill data; every duration is arithmetic over the stage dates. Both are worked
out when asked for, never written down as a number. A stored figure would have
to be rebuilt every time a date was corrected, and a correction is a normal
event here rather than an exceptional one — the Parliament revises published
records, and this project has already found fact sheets out of date on Acts made
since. What is stored is the dates; what is published is worked out from them.
Anything the presentation layer shows follows that rule.

**The points at which a stage is treated as complete** are in methodology note
M2, which settled it. What is worth keeping here is the reason the question was
hard: for Stage 1 the candidates were the lead committee's report, the chamber
debate, and the decision on the general principles, and they give materially
different durations. The test applied was that whatever is chosen has to hold
across all seven sessions and every bill type, which is what ruled out the
committee report.

**The financial resolution is not recorded as a stage, and that is still open.**
It sits between Stages 1 and 2, and a bill that needs one cannot proceed past
Stage 1 until it is agreed, so it can hold a bill up and may explain Stage 1 to
Stage 2 intervals that otherwise look anomalous. It was left out of the first
slice deliberately, on the ground that the slice should build only what its two
questions require. **Revisit it if the Stage 1 to Stage 2 figures turn out not
to be explainable without it** — which is a thing the presentation work is
likely to be the first to notice. Note that a bill *falling* for want of a
financial resolution is a separate matter and is already recorded, as one of the
ways a bill can end.

## 3. Why the variables are separated as they are

Each of these was settled, and `DECISIONS.md` carries the full entry including
how it could be undone. The short reason is given here because the separations
are what a reader of a chart is most likely to question.

**Who introduced a bill and how it was handled are two variables.** An Emergency
Bill is a Government Bill that compressed its stages. Folded into one list it
stops counting as a government bill. This matters directly for durations:
emergency and budget bills complete in days and would otherwise distort every
average. They are to be flagged and reported separately, not excluded. Settled
10 September; see also M10, which tells a reader that how a bill was handled is
recorded only where a source says so.

**Passing a bill and the bill becoming an Act are two variables.** They are
different events, and the gap between them is itself of research interest: a
bill can pass and be referred to the Supreme Court, or pass and be stopped from
receiving assent. Combining them would make those bills unfindable and would
turn "how many bills passed?" into a sum over several values. Settled
10 September; see M5.

**A stage carries its position as well as its name.** Private Bills do not use
the Stage 1, 2 and 3 sequence — they have a Preliminary, a Consideration and a
Final Stage, and the Parliament itself says these are quite different stages
with different names. Recording where a stage sits in its own bill type's
sequence is what allows a Private Bill to be compared with a public bill without
claiming the stages are the same thing. Any cross-type comparison rests on this
and should say that it does.

## 4. Edge cases

Written down before the hand-build so that the build could confirm or dismiss
them, and so that any later extraction can be measured against them. That second
purpose is still live: automation has not been built, and when it is, this is
part of what judges it.

**Settled during the first slice.**

- *No source states why a bill fell.* Every outcome value is our coding from
  what happened at the last stage, not read from a field. This was the slice's
  main piece of judgement. M7.
- *Titles change during passage.* Two titles are recorded, and the title at
  introduction is usually not known. M3.
- *Bills reintroduced in a later session* are two bills and are counted as two,
  but a reintroduced Private Bill may not repeat its earlier scrutiny, which
  changes how long it appears to have taken. M6 and M9.
- *Private Bills* have their own stages, which are recorded under their own
  names and compared by position. M2. They are brought by promoters rather than
  members, which is one of the reasons no member is attached to a bill — see
  below.
- *Reconsideration Stage* breaks the assumption that Stage 3 is the end. It is
  recorded as a stage in its own right.
- *Hybrid Bills.* The open question was which session first made the type
  possible. Only one has ever been introduced, in Session 3. M4.
- *Executive Bills before 2007* are counted as one type with Government Bills,
  with the contemporaneous styling kept separately. M1.
- *Session 7 is absent from the API,* which covers Sessions 1 to 6, and from its
  own fact sheet's first page. Its session dates come from the SPICe recess and
  dissolution factsheet, which is where all seven sessions' dates come from, and
  its last day is empty because the session is still running.

**Standing, and not yet tested.**

- **The Parliament's API returns truncated and duplicated records.** Found when
  the API was surveyed, and never relied on since: the first slice was built
  from the fact sheets, the Official Report and the PhD dataset. Any extraction
  that goes back to the API has to handle both, and should not assume a record
  count is a bill count.
- **No member is attached to any bill yet.** There is a party column, settled on
  10 September with the rule that an empty cell means not applicable or not
  known and that independent is a real value rather than an empty one, but it is
  empty for every bill: the first slice's two questions do not need it, so it
  was not filled. Two things will bite when it is. Bills introduced by a Law
  Officer carry no member at all, and Private Bills are brought by a promoter
  rather than a member, so for both of them the empty cell is the right answer
  and not a gap to be chased.

## 5. Provenance

Where a fact came from is recorded at two levels: a source on each row, for the
common case where a whole row came from one document, and a per-field record
where an individual field came from somewhere else. The reason for the second is
that one source per row was never going to be enough — a bill's outcome comes
from a fact sheet while its dates come from the Official Report, and that is the
normal case, not the exception.

**The notes are rebuilt with their bill, not kept forever.** They were
append-only at first, on the argument that a revised published record should
produce a second observation rather than overwrite the first. That was reversed
by the owner on 11 September: twice in two days the rule got in the way, and
both times it was protecting our own work rather than a source's words. What a
source actually said is kept on the staging sheets, which are never emptied, so
nothing is lost by rebuilding a note. See `DECISIONS.md`, 11 September.

One consequence is still open and is recorded here because it will arrive during
ingestion rather than presentation: **nothing yet records a second reading of a
source that gives a different answer.** No such revision has happened. How to
record one is settled when the first real case arrives.
