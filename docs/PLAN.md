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

## Phase 1 — the site

**Delivers.** A place for the data to live. The site exists, is reachable, and
has working accounts: somebody can apply, the owner can approve or refuse the
application, and the approved person can log in and out. The infrastructure
decisions are taken and written down. The first stylistic decisions are taken
and written down.

**Opens when.** Phase 0 is closed. It is.

**Must not.** Publish any data. No charts, no tables of bills, no downloads, no
figures of any kind — those are Phase 2 in their entirety, and a figure put on
a page in Phase 1 would be a figure published before the rules for publishing
one exist. It must also not take on tools for users to build things, and must
not take on new data.

**Closes when.** The owner can approve a beta application, log in, and log out.
The infrastructure and style decisions are recorded. A written test has been run
by a session that did none of the work. The owner signs off that they can
explain what was built and how it runs.

**First work in the phase: scoping.** Infrastructure and styling, taking in
views from outside this project rather than settling both from within it. That
scoping comes before anything is built.

**Open questions, to settle in the Phase 1 discussion.**

- What the beta gate becomes afterwards. During beta, access is by approval.
  This is meant to be a resource open to researchers, and whether a download
  stays behind a login once beta ends is not settled.
- What is held about a user, and why. Accounts mean personal data, which this
  project has not had before.
- Whether the site and the database share a machine.
- The domain.

## Phase 2 — the data, published

**Delivers.** The current dataset, available and shown. Downloads of it, and our
own charts and tables built from it. And, for both, the route back: a download
carries its sources, and a chart says which coding decisions it rests on.

**Opens when.** Phase 1 is closed.

**Must not.** Add a variable in order to make a chart possible. If a chart needs
data we do not hold — the sponsor of a bill, for instance — the chart waits for
the slice that brings it, and the slice is decided on its own merits. It must
also not take on tools for users to build their own tables and charts.

**Closes when.** A researcher who is not us can download the dataset and read a
chart, and in both cases find out where the numbers came from and what was
decided in handling them. A written test has been run by a session that did none
of the work. The owner signs off.

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
