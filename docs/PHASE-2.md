# Phase 2 — the data, published

The detailed plan for Phase 2. `PLAN.md` is the arc and says what the phase
delivers, what it must not do and how it closes; none of that is restated here.
This is the working detail: the order, what each piece must settle, and what
turned out not to work.

**This file is destroyed when the phase closes**, by the sweep `PLAN.md`
describes, run by a session that did none of the phase's work.

**It is for whoever runs the session, not for the owner.** The owner orients
from `STATE.md`. Nothing here is a progress report.

---

## Where this plan is: second draft, not yet reviewed by the owner

- **16 September, first draft**, by the session that opened the phase.
- **16 September, checked** by a session that wrote none of it. The findings
  are `docs/PHASE-2-CHECK.md`, numbered.
- **16 September, second draft**, by the checking session. Every finding is
  written in below **as a proposal**, marked *(check n)*, so the owner can find
  each and accept or strike it. Nothing marked is decided.
- **16 September, the research commission written**, by the same session:
  `docs/PHASE-2-RESEARCH-COMMISSION.md`.

**What happens next, by the owner's direction:**

1. **All three pieces of research go ahead** (owner, 16 September, later the
   same day).
2. One normal session runs each piece, one that wrote neither this plan nor the
   commission.
3. A further session brings the reports' conclusions into a third draft of this
   plan, still as proposals, and adds any gaps it finds.
4. The owner reviews that draft, the commission and the reports together. The
   plan is finalised, and the decisions go into `DECISIONS.md`. Then the
   groundwork opens.

---

## Settled when the phase opened, 16 September

- **Phase 2 publishes only to approved beta users.** So what access becomes
  after beta stays deferred, as `STANDING.md` has it, and what reopens it is
  unchanged: beta ending, or publishing to anyone who is not an approved beta
  user.
- **Groundwork before anything is built.** Settled as four pieces in a set
  order; this draft proposes the download research leave the groundwork and go
  ahead of it as R1, and files-or-a-database move into groundwork 1 *(check 1)*.
  Each piece ends in a briefing with a
  proposal for every question, read by the owner, and each answer recorded in
  `DECISIONS.md` before the next piece opens.
- **Complete transparency about the data a figure uses and how it is
  calculated**, down to showing the query. The owner's words: "ideally showing
  our sql working".

**Not yet answered:**

- **Who runs the closing test.** `PLAN.md` says a session that did none of the
  work, from a second account. Whether that account is a test account used by
  that session, or a real researcher the owner invites, is the owner's to say.
  Needed before the closing test is written.
- **Whether the charts matching the owner's own figures is a condition of
  closing the phase** *(check 5)*. `STANDING.md`, 12 September: the dataset is
  proved at the end, by whether the charts and tables built from all seven
  sessions match what the owner built by hand from the PhD dataset. Phase 2 is
  when those charts first exist.

---

## Before the plan is finalised: external research

**Proposed, not agreed.** The owner decides which pieces happen. The questions,
where to look, how to work and what each report looks like are in
`docs/PHASE-2-RESEARCH-COMMISSION.md`, and only there; this is the list.

- **R1 — how a research dataset is handed to a researcher.** The first draft's
  groundwork 2, moved ahead of everything *(check 1)*, because the published
  copy's shape and files-or-a-database both wait on it, and it waits on nothing.
  It asks whether worked-out days travel with the dates *(check 2)*, and names
  places to look, not formats *(check 8)*.
- **R2 — the licence.** What the sources' own terms permit for a dataset built
  from them, and what comparable datasets use. If the terms leave it unclear,
  the report drafts the question for the owner to put to the publisher.
- **R3 — how others show the working behind a figure.** Feeds groundwork 3, and
  bears on files or a database, decided in groundwork 1.

**Can a session run them?** Mostly. What cannot be done by a session: reading
paywalled articles; reading a site that blocks automated reading without the
owner's permission to use their browser; and knowing which formats the owner's
researchers use, which is the owner's knowledge. Outside help is likely only for
the licence, and only if the terms do not settle it.

**Not proposed: research on charting legislative time.** The owner is the
authority on the literature about how long legislation takes and on how it is
measured. The chart write-ups in groundwork 2 put their proposals to the owner
directly. Say if that is wrong.

---

## Groundwork 1 — the published copy, and how it relates to the working one

**Why it is first.** On 15 September it was settled that the site reads a
separate copy holding only what is published, refreshed when we choose,
rebuildable and so not backed up. What that copy *is* was not settled. Every
later piece stands on it: a download is taken from it, and the calculation
shown beside a chart runs against it.

**It opens once R1 and R3 are read** *(check 1)*.

**The briefing must settle:**

1. **Files or a database for the site to read** *(check 1)*. Left open on
   15 September until a reader's tools were known; R1 finds them. Decided first,
   because most of what follows differs between the two.
2. **What crosses.** Bills and their stage dates, certainly. The provenance
   notes, the methodology notes, the lists of allowed values, our own
   record-keeping columns (`observed_at`, `created_at`, `source_ref`), our own
   bill numbers — each decided, not defaulted.
3. **Whether the calculations already built cross** *(check 2)*. The working
   database already works out the days between each stage, the time from
   introduction to final stage, averages by session and type, and outcomes by
   type, with the owner's 13 September ruling on counting time built in. The
   briefing says whether these cross, and whether a chart's calculation is built
   on them. Writing one again beside the original makes two versions of the same
   arithmetic, free to drift apart.
4. **Its layout.** A straight copy of the clean sheet's shape and codes, or a
   shape laid out for a reader: one line per bill with its stage dates across,
   readable labels in place of codes, or both. Settled from R1.
5. **How it is refreshed.** Rebuilt whole or changed in place; all or nothing;
   who starts it and when; how it is proved to match the working one, cell by
   cell, which is the rule for moving data already; the written undo. It becomes
   a step in `PROMOTION-RUNBOOK.md` with its own rehearsal.
6. **What it holds that the working one does not.** The date it was taken,
   certainly, since every page carries it. Whether the figures behind each chart
   are worked out in advance and stored, or worked out when a page is opened.
   **Starts from the 15 September rule** that no duration is stored and every one
   is worked out when asked for *(check 2)*, and says whether that rule holds for
   the published copy as it does for the working one.
7. **Which date a page carries.** Three decisions of 15 September already speak
   of "the date it was taken"; the briefing starts from those words *(check 10)*.
   What is still open is which date that is: the day the copy was taken, the day
   the data was last promoted, or the day each source was read. They differ.

**What holds already and must not be re-argued:** the site can never reach the
working one; nothing flows back from the published copy; it is not backed up,
and if it is a database it is named in `NOT_BACKED_UP` in `deploy/legdata-backup`
in the same change that creates it.

**Picked up from `STANDING.md` here:** the site's way into the published copy
reads and never changes anything — recorded nowhere as a decision, so this
briefing proposes it as one. Heavy use competing with loading: the briefing says
whether the answers to questions 1 and 6 change it.

---

## Groundwork 2 — every chart and table written out before it is drawn

**The owner's list, 16 September.** The screenshots on the owner's desktop from
15 September are for inspiration only; they are the same dashboard `PLAN.md`
uses as its warning.

1. **Outcomes by session by type** — numbers, percentages, averages.
2. **Time to pass by session by type**, in four intervals: introduction to the
   end of Stage 1, end of Stage 1 to end of Stage 2, end of Stage 2 to end of
   Stage 3, Stage 3 to Royal Assent.
3. **The quickest bills** — name, type, session.
4. **The slowest bills** — name, type, session.
5. **Bills introduced in each quarter of a session, and whether that has
   changed over time.** Prompted by the criticism that the Scottish Government
   has been introducing its bills later and later in a session.

**Checked on 16 September, twice: every one can be built from what is held.**
Every bill has an introduction date, every completed stage its date, every Act
its Royal Assent date, every session its first meeting and, bar Session 7, its
end. The rule against adding a variable to make a chart possible does not bite.

**Each write-up says:** the question it answers; which bills are counted and
which are left out by default; the switches a reader gets; the calculation, as
it will actually run against the published copy, not a copy of it; which
methodology notes it rests on; what it cannot say; and **where the owner has
built the same figure by hand, which figure, so the two can be compared**
*(check 5)*.

**The switches.** The two the owner named: leaving out bills of a given kind,
such as Hybrid Bills; and whether an average takes **every bill that reached
that stage, or only the bills that completed their passage** — M2's words, and
the owner's ruling of 13 September *(check 3)*. "Reached" means the Parliament
took the decision that ends the stage, whichever way it went; a bill rejected at
Stage 1 is in. Mean or median, or both, is for the write-up to propose.

**No other switch, unless a methodology note requires it** *(check 9)*, such as
M9's two ways of measuring the Robin Rigg Act. Any further switch a write-up
thinks useful is named in it as belonging to the playground, and not built.
`PLAN.md`: this phase does not take on tools for readers to build their own
tables and charts.

**Known traps each write-up must resolve, not decided here:**

- Sessions ran four years and five, so a quarter is a quarter of that session's
  own length. Session 7 has no end date and a live bill (M13).
- Private Bills have Preliminary, Consideration and Final Stages. **How they are
  compared is settled by M2**: by their position in the sequence *(check 4)*.
  What is left is whether a chart shows them with the public bills or on their
  own.
- The reintroduced Robin Rigg bill (M9): counted from its own introduction or
  the earlier bill's, and the chart says which.
- Four bills were stopped before Royal Assent (M5). For the two later enacted,
  Stage 3 to Royal Assent includes the Supreme Court and Reconsideration Stage.
  The other two, one withdrawn and one still blocked, passed and have no Royal
  Assent at all.
- Session 5's last day is 4 May 2021, not in March like the sessions before
  it. A quarter measured to a session's last day is measured to that date.
- Procedure is known for 5 bills of 470 (M10), so the quickest list cannot
  reliably separate emergency bills. The chart says so rather than implying it.
- A bill belongs to the session it was introduced in (M6); counts by session
  follow from that.
- Calendar days, not sitting days (`STANDING.md`); Stage 2 ends at the meeting
  disposing of the last amendments (M2); Government includes Executive (M1);
  Hybrid is grouped with government (M4), and a chart says whether it grouped.
- **The financial resolution** *(check 6)*. It was left out as a stage, with
  the trigger that reopens it stated: Stage 1 to Stage 2 figures that cannot be
  explained without it (`STANDING.md`). Chart 2 is the first thing to produce
  those figures. Its write-up names the trigger, so an odd figure is recognised
  as one rather than explained away.
- Ties in a top-ten list.

**What holds already, from 15 September:** an outcome is a word, never a colour,
and the accent never touches data ("Colour means one thing"); the data date sits
at the top of any page showing data, inside the crop of a screenshot ("Prose
runs narrow"); and every page passes the two questions ("Who the site is
designed for"). The screenshots' green bars and success rates are what the first
of those rules exists to avoid.

**Picked up from `STANDING.md` here:** the colours of charts, which wait for the
first chart.

---

## Groundwork 3 — how the working is shown on a page

**Last, because it follows from the others.** Opens once R3 is read.

**The briefing must settle:**

1. **Where the calculation and the data behind a figure are shown** — beside it,
   behind a link, as a download of that figure's own lines — and how a reader
   gets from a figure to the provenance of a single bill in it.
2. **How the calculation shown is guaranteed to be the one that ran.** One
   source for both, never a copy kept in step by hand.
3. **What the date means, in words a reader sees**, on a chart as well as a
   download *(check 10)*. `PLAN.md` requires it for both. Public wording, so it
   goes to the owner in full.
4. **How the style is tested against a real table of every bill.** The house
   style decision said a page built locally and never deployed. **Two limits the
   briefing works within** *(check 10)*: nothing runs on the owner's Mac; and a
   deployed page with every bill on it is data on the site, so either it sits
   behind something only the owner can see, or it waits until the rules for
   publishing are settled.

**Picked up from `STANDING.md` here, and only if a page needs them:** the second
accent and tones; the forms' filled buttons.

---

## Before anything is published: the methodology notes

*(check 7)* **Proposed: no note is published with an open question against it.**
Each chart names the notes it rests on, so a note's faults become public with
the first chart. Settled before the build, each change of wording put to the
owner in full:

- **M5 dates the Legal Continuity Bill's ruling wrongly.** It says three bills
  were ruled against on 6 October 2021. That is right for the UNCRC and European
  Charter Bills; the Legal Continuity reference was decided on 13 December 2018
  (*[2018] UKSC 64*). The bills are recorded correctly; the note overreaches.
  For the owner to confirm before anything changes.
- **M5's two sentences that have drifted** (`STATE.md`, "Waiting for you").
- **Whether the other notes are cut the way M12 was.**
- **The Robin Rigg Act's note**, which names both missing stages and dates one.
- **Whether Session 5's four bills that ran out of time** carry the note
  Session 6's three do.

---

## Then: building

**Not planned yet, on purpose.** The final version of this file, written after
the groundwork closes, plans the build. The obvious shape — the published copy
and its refresh step, then downloads, then tables and charts — is a guess until
the groundwork has settled what each is.

Anything built gets the working rules: a written procedure, a rehearsal and an
undo for the published copy's refresh and for every deploy, checks run on the
machine against a staged release, never on the owner's Mac.

---

## What is not a prerequisite, and is worth saying

From "Waiting for you" in `STATE.md`: nothing tells anyone when the nightly
backup fails. Not a condition of any groundwork, but Phase 2 is when researchers
start depending on the resource. How to record a published record being revised
may arrive during the phase; if it does, it is settled then, as `STANDING.md`
says, and not ahead of time.
