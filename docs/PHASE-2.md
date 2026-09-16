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

## This is a first draft, and it has not been checked

**Written 16 September by the session that opened the phase. The next session
checks it before any of its work starts**, by the owner's decision. A plan
marked by the session that wrote it is not checked.

What the check should ask:

- Is everything `STANDING.md` leaves for Phase 2 placed below, and placed where
  it can actually be answered?
- Does each piece of groundwork say what it must settle, not what the answer is?
  The drafting session had views; they belong in the briefings, as proposals.
- Is anything here building ahead of the groundwork, or taking on what `PLAN.md`
  says this phase must not?
- Does the order hold: would a later piece change what an earlier one settles?
- Does anything contradict `DECISIONS.md`, `STANDING.md` or the database?

The check's findings, and what the owner agreed of them, go in a second version
of this file. Then the groundwork opens.

---

## Settled when the phase opened, 16 September

- **Phase 2 publishes only to approved beta users.** So what access becomes
  after beta stays deferred, as `STANDING.md` has it, and what reopens it is
  unchanged: beta ending, or publishing to anyone who is not an approved beta
  user.
- **Four pieces of groundwork before anything is built**, in the order below.
  Each ends in a briefing with a proposal for every question, read by the owner,
  and each answer recorded in `DECISIONS.md` before the next piece opens.
- **Complete transparency about the data a figure uses and how it is
  calculated**, down to showing the query. The owner's words: "ideally showing
  our sql working".

**Not yet answered:** who runs the closing test. `PLAN.md` says a session that
did none of the work, from a second account. Whether that account is a test
account used by that session, or a real researcher the owner invites, is the
owner's to say. It must be answered before the closing test is written.

---

## Groundwork 1 — the published copy, and how it relates to the working one

**Why it is first.** On 15 September it was settled that the site reads a
separate copy holding only what is published, refreshed when we choose,
rebuildable and so not backed up. What that copy *is* was not settled. Every
later piece stands on it: a download is taken from it, and the query shown
beside a chart is written against it, so its layout is what a reader sees.

**The briefing must settle:**

1. **What crosses.** Bills and their stage dates, certainly. The provenance
   notes, the methodology notes, the lists of allowed values, our own
   record-keeping columns (`observed_at`, `created_at`, `source_ref`), our own
   bill numbers — each decided, not defaulted.
2. **Its layout.** A straight copy of the clean sheet's shape and codes, or a
   shape laid out for a reader: one line per bill with its stage dates across,
   readable labels in place of codes, or both. Groundwork 2's research feeds
   this question; the briefing may leave this one question open until that
   research is read, and say so.
3. **How it is refreshed.** Rebuilt whole or changed in place; all or nothing;
   who starts it and when; how it is proved to match the working one, cell by
   cell, which is the rule for moving data already; the written undo. It becomes
   a step in `PROMOTION-RUNBOOK.md` with its own rehearsal.
4. **What it holds that the working one does not.** The date it was taken,
   certainly, since every page carries it. Whether the figures behind each chart
   are worked out in advance and stored, or worked out when a page is opened.
5. **Which date a page carries.** The day the copy was taken, the day the data
   was last promoted, or the day each source was read. They differ.

**What holds already and must not be re-argued:** the site can never reach the
working one; nothing flows back from the published copy; it is not backed up and
is named in `NOT_BACKED_UP` in `deploy/legdata-backup` in the same change that
creates it.

**Picked up from `STANDING.md` here:** the site's way into the published copy
reads and never changes anything — recorded nowhere as a decision, so this
briefing proposes it as one. Heavy use competing with loading: the briefing says
whether the answer to question 4 changes it.

---

## Groundwork 2 — what goes with a download

**Research, and it looks outside the project.** The owner's instinct is that
good practice exists to lean on. This project's own habits are evidence about a
hand-built dataset, not about how researchers want to receive one.

**Where to look, named so it is not missed, not as a conclusion:** how the UK
Data Service and ICPSR expect a deposited dataset to arrive; codebook practice
(DDI); formats that carry a description alongside a plain table (W3C CSV on the
Web, Frictionless Data Package); citation metadata (DataCite); and how
comparable political-science datasets publish — the Comparative Agendas
Project, the Congressional Bills Project, ParlGov, V-Dem.

**The briefing must settle:**

1. **What the researchers the owner has in mind open a download in**, and so
   which formats. Excel, R, Stata, SPSS and plain CSV are the obvious
   candidates; which ones is for the research and the owner.
2. **What travels with the file.** The codebook, the methodology notes, the
   provenance notes, the date taken, a suggested citation, and anything good
   practice adds that this list does not.
3. **One file or several**, and how they are bundled.
4. **The licence.** The data is built partly from the Parliament's published
   material. What a reader may do with a download has to be stated, and on what
   grounds. Not assumed.
5. **What a reader is told** about accuracy at the time of access and no
   undertaking to serve a superseded version, which `PLAN.md` requires.

**Bound.** If good practice points at an outside service or account — a
permanent identifier, a repository deposit — it is put to the owner as a
question, not built around. `CLAUDE.md`: ask before adding.

---

## Groundwork 3 — every chart and table written out before it is drawn

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

**Checked on 16 September: every one can be built from what is held.** Every
bill has an introduction date, every completed stage its date, every Act its
Royal Assent date, every session its first meeting and, bar Session 7, its end.
The rule against adding a variable to make a chart possible does not bite.

**Each write-up says:** the question it answers; which bills are counted and
which are left out by default; the switches a reader gets; the calculation, as
the query that will actually run against the published copy, not a copy of it;
which methodology notes it rests on; and what it cannot say.

**The switches the owner has named:** leaving out bills of a given kind, such as
Hybrid Bills; and whether an average takes only bills that completed their
passage, or every bill that completed the stage in question even if it went no
further. Mean or median, or both, is for the write-up to propose.

**Known traps each write-up must resolve, not decided here:**

- Sessions ran four years and five, so a quarter is a quarter of that session's
  own length. Session 7 has no end date and live bills (M13).
- Private Bills have Preliminary, Consideration and Final Stages. Whether they
  sit in the four intervals, by stage order, or apart, is a decision.
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
  Hybrid is grouped with government by `analysis_group` (M4).
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

## Groundwork 4 — how the working is shown on a page

**Last, because it follows from the other three.**

**The briefing must settle:**

1. **Where the query and the data behind a figure are shown** — beside it,
   behind a link, as a download of that figure's own lines — and how a reader
   gets from a figure to the provenance of a single bill in it.
2. **How the query shown is guaranteed to be the one that ran.** One source for
   both, never a copy kept in step by hand.
3. **Files or a database for the site to read.** Left open on 15 September until
   a reader's tools were known; groundwork 2 knows them. `STANDING.md` names this
   as what reopens it.
4. **How the style is tested against a real table of every bill.** The house
   style decision said a page built locally and never deployed; nothing runs on
   the owner's Mac since 16 September, so it cannot be done as written. The
   briefing proposes how instead.

**Picked up from `STANDING.md` here, and only if a page needs them:** the second
accent and tones; the forms' filled buttons.

---

## Then: building

**Not planned yet, on purpose.** The second version of this file, written after
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
