# Plan

What the phases are, in what order, and what each has to deliver before the next
opens. `STATE.md` says where we are in it. `DECISIONS.md` records what was
settled on the day it was settled. This document is the arc; it is not a task
list and it does not hold working detail.

## The vision

A research-grade resource for parliamentary data, with the Scottish Parliament
as the pilot because it is the one we know. A researcher should be able to
download the raw data, download the variables built from it, see it visualised,
and build their own tables and charts without leaving the site. In the long run
it takes in other legislatures.

This is a long project. It is the tenth attempt. The nine before it started from
the Parliament's APIs and died in the nuance; this one started from the fact
sheets and the PhD dataset, in short pieces with a checkpoint at the end of
each, and that is the property to keep. A phase should be small enough that a
bad phase costs a phase, and not the project.

## What makes it research grade

**Provenance reaches the reader.** Every figure we publish has a route back to
what said so, and to the decisions we made in handling it.

**Our decisions do not need to be correct. They need to be transparent** — clear
enough that a user can accept them, or take the underlying data and do something
different. This is the standard the whole resource is held to, and it decides
arguments about what may be published.

**What we vouch for is the data as it stands when it is accessed.** Every figure
and every download carries the date it was taken. We do not keep an archive of
superseded versions and do not undertake to serve one — the published record
itself gets revised, and a resource promising otherwise would be promising
something the Parliament does not. A user who needs a fixed version downloads it
and keeps it; the stamp is what makes their copy citable. The citation is
theirs.

A concrete case, from a dashboard we looked at for design ideas on 15 September.
Its headline chart of the longest passages had the Mental Health (Care and
Treatment) Bill at 1408 days, from an introduction on 12 May 1999 — the day the
Parliament first met. It was introduced on 16 September 2002 and passed on
20 March 2003: 185 days. A second bill on the same screen carried the same wrong
date. Nothing on the screen told a reader where the number came from or let them
notice it was impossible. That is the difference being built here, and it is why
provenance is designed into the first screen rather than added to a later one.

## How the plan is built

- **One phase at a time.** The candidates at the end are named so they are not
  forgotten, not so they can be started.
- **Each phase says four things:** what it delivers, when it may open, what it
  must not do, and how it closes. The third matters most — most of this
  project's near-misses have been scope creeping into a phase rather than a
  phase being wrong.
- **A phase closes on a written test, run by a session that did none of the work
  it tests, plus the owner's sign-off** that they can explain what was built.
  That is the shape that closed every session of Phase 0.
- **Build only what the current phase needs.** No speculative schema, no
  speculative screens, no sources the phase does not require.
- **Each phase gets its own detailed plan, and closing the phase destroys it.**
  Only what belongs in the decisions record, the standing positions, a runbook
  or this document survives. See below.


## The phase plan, and throwing it away

**Each phase gets its own detailed plan, and each phase plan is destroyed when
the phase closes.** This document is the arc and stays short. The working detail
of a phase — the order things get built in, what is being tried, what turned out
not to work — goes in a file of its own, `docs/PHASE-1.md` and so on, and that
file is deleted as part of closing the phase.

**It is for whoever runs the session, not for the owner.** The owner orients
from `STATE.md`. A phase plan that starts collecting status is a second
`STATE.md`, growing in a place where nobody is cutting it.

**Deleting it is safe, and that is the point.** The file stays in the
repository's history, so nothing is destroyed — it leaves the places people
actually read. This project's failures have been second copies rotting in plain
sight, not things lost.

**Closing a phase includes a sweep**, in which every line of the phase plan is
one of these:

- a decision that was settled → `DECISIONS.md`
- a position that holds whatever session is running, something verified rather
  than assumed, or something deliberately left undone and what would reopen it
  → `STANDING.md`
- how to run something, or how to undo it → the runbook for that thing
- what a table or column holds → a `COMMENT` in a migration, so it reaches the
  data dictionary
- a change to the arc itself → this document
- anything else → working detail, and it goes

The list is the mechanism. "Keep what is essential" decided at the end of a long
session is the instruction that let `STATE.md` reach 942 lines.

**Nothing is cut until it is proved present in its new home** — the rule already
used for moving data, and for the 261 lines that became `STANDING.md`.

**The sweep is run by a session that did none of the phase's work**, like the
closure test it forms part of. Whoever wrote the phase plan is the worst judge
of which of their own notes are essential.

---

## Phase 0 — the dataset

**Closed 15 September 2026.**

Bill outcomes and scrutiny periods across all seven sessions, built by hand from
the SPICe legislation fact sheets and the PhD dataset, through a gateway where
every candidate is checked before it is admitted. 470 bills, 1291 stage records,
186 provenance notes, 13 methodology notes. Filterable by session and bill type.
Every session read in, reviewed, promoted and closed, each closure test run by a
session that did none of the work it tested.

This is the proof of concept: a hybrid of the Parliament's published record and
the PhD data, complete and checked, answering two real research questions across
twenty-seven years.

## The dataset, while the site is built

**It stays as it is.** One bill is before the Parliament and nothing else is
moving. The data grows very slowly, and Phase 0 closed it complete to that
point. Keeping it current is not a phase and does not run alongside one; if
something does need to go in, it goes in the way Phase 0's data went in.

This is a choice rather than an oversight, and it is written down because a
phase-at-a-time plan implies it silently, and what a plan implies is what gets
argued about later.

## Phase 1 — the site

**Delivers.** A place for the data to live. The site exists, is reachable, and
has working accounts: somebody can apply, the owner can approve or refuse the
application, and the approved person can log in, see that they are logged in as
themselves, change their password, and log out. A welcome, and the account
working — that is the whole of what a logged-in person sees in this phase. The
infrastructure decisions are taken and written down. The style decisions are
taken and written down.

**Opens when.** Phase 0 is closed. It is.

**Must not.** Publish any data. No charts, no tables of bills, no downloads, no
figures of any kind — those are Phase 2 in their entirety, and a figure put on
a page in Phase 1 would be a figure published before the rules for publishing
one exist. It must also not take on tools for users to build things, and must
not take on new data. The temptation this phase has to survive is one chart on
the welcome page to make it look like something; the welcome page is a welcome.

**Closes when.** The owner can approve a beta application, log in, change a
password, and log out. The infrastructure and style decisions are recorded. A
written test has been run by a session that did none of the work, which also
sweeps and deletes `docs/PHASE-1.md`. The owner signs off that they can explain
what was built and how it runs.

**First work in the phase: two scoping discussions, before anything is built.**
Infrastructure, and style. Both take in views from outside this project rather
than settling either from within it.

**Style is a deep dive**, and may go as deep as it earns. The bound is on what
gets built, not on what gets decided: Phase 1 builds the pages above and nothing
else, whatever the deep dive settles.

**Infrastructure — the questions to settle.**

- **Whether the site reads the working database, or a published copy taken from
  it.** This one shapes the rest. The database we load sessions into is the one
  we promote on and roll back on. Whether a reader's page looks at that, or at a
  copy taken from it when we choose to take one, decides much of what follows.
- Whether the site and the database share a machine.
- What is held about a user, and why. Accounts mean personal data, which this
  project has not had before.
- What the beta gate becomes afterwards. During beta, access is by approval.
  This is meant to be a resource open to researchers, and whether a download
  stays behind a login once beta ends is not settled.
- The domain.

## Phase 2 — the data, published

**Delivers.** The current dataset, available and shown. Downloads of it, and our
own charts and tables built from it. And, for both, the route back: a download
carries its sources, and a chart says which coding decisions it rests on. Every
download and every chart carries the date it was taken, and the site says
plainly what that means — accuracy at the time of access, and no undertaking to
serve a superseded version.

**Opens when.** Phase 1 is closed.

**Must not.** Add a variable in order to make a chart possible. If a chart needs
data we do not hold — the sponsor of a bill, for instance — the chart waits for
the slice that brings it, and the slice is decided on its own merits. It must
also not take on tools for users to build their own tables and charts.

**Closes when.** A researcher who is not us can download the dataset and read a
chart, and in both cases find out where the numbers came from and what was
decided in handling them. A written test has been run by a session that did none
of the work, from a second account rather than the owner's, and that session
sweeps and deletes `docs/PHASE-2.md`. The owner signs off.

---

## Then: re-decide

**Both phases close before anything else opens.** At that point the order of
what follows is decided afresh, in the light of what building the site actually
taught us. The candidates below are not ranked.

## Candidate — the playground

Tools on the site for users to build their own tables and charts without leaving
it. Bounded, before it is built, by a defined set of questions a researcher would
actually ask — taken from real research rather than invented — instead of being
scoped as a general chart builder. "Build anything" is unbounded in the same way
the Parliament's APIs were.

## Candidate — a screen for entering new data

A way to put a bill's progress in without a session writing it. The owner's
screen, not a researcher's, and explicitly not a priority: one bill is live and
the data grows slowly enough that the need is years off rather than months. It
is named here so it is not reinvented, and so nothing built in the site makes it
hard to add later.

## Candidate — data expansion, in narrow slices

One thing at a time, each through the same gateway, each hand-built before any
automation is attempted. The first candidate slice is the member in charge of
each bill and their party at introduction: narrow, and it opens a great deal.
Beyond that there is a PhD's worth of data, and the Parliament's APIs, which are
large and full of nuance and were what killed the earlier attempts.

A slice earns its place by something on the site that needs it.

## Candidate — other legislatures

The Senedd, and beyond. Far out, and not to be designed for now. One cheap thing
is worth doing much sooner: a check of whether anything in the database
hard-codes the Scottish Parliament in a way that would be expensive to undo.
Half a day, write down the answer, then leave it until it matters.
