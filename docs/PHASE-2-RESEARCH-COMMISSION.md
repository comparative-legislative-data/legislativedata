# Phase 2 — the research commission

Written 16 September by the session that checked and redrafted `docs/PHASE-2.md`.
**Not to be run until the owner has reviewed that draft and said which of R1, R2
and R3 go ahead**, and with what changes. Whatever the owner changes, change it
here first, so the session that runs a piece reads one version.

**Who runs it.** A fresh session for each piece, one that wrote neither the plan
nor this file. By the owner's decision of 16 September: the session that framed
the questions is the worst placed to answer them, for the same reason a session
does not mark its own work. The pieces are independent and may run in any order.

**Destroyed with `PHASE-2.md`** when the phase is swept, once what each report
found is placed.

---

## What every piece needs to know

**The resource.** `legislativedata.org`, a research resource about the Scottish
Parliament's bills, run by a legislation researcher whose PhD is on them. In
beta: only researchers the owner has approved can sign in. Nothing is published
on it yet; Phase 2 publishes the dataset, downloads of it, and a handful of
charts and tables.

**The dataset.** Every bill introduced in the Scottish Parliament since 1999:
470 bills, about 300 kB. For each bill: its session, title, type (Government,
Member's, Committee, Private, Hybrid), dates of introduction and of each stage
decided, how it ended, and Royal Assent where there was one. Beside that:
provenance notes saying what source gave a value and when it was read, and
thirteen methodology notes explaining judgements made in coding. It is built by
hand from the Parliament's legislation fact sheets (SPICe), the Official Report,
legislation.gov.uk, and the owner's own PhD dataset. **It holds no data about
people.**

**What is already settled, and constrains the answers** (`docs/PLAN.md`,
`docs/DECISIONS.md`):
- **Provenance reaches the reader.** Every figure has a route back to what said
  so, and to the decisions made in handling it. The decisions need not be right;
  they must be transparent enough for a reader to accept them or do otherwise.
- **We vouch for the data as it stands when it is accessed.** Every download and
  chart carries the date it was taken. No archive of old versions is kept, and
  none is promised: the Parliament itself revises its published record.
- **Everything runs on one rented machine** the project manages itself, and
  nothing is written in a form only one company can run.
- **No outside service or account is added without the owner's agreement.**

**How to work.**
1. **Look outside the project.** This project's own habits are evidence about a
   hand-built dataset, not about how researchers want to receive one. Do not go
   looking for what earlier sessions preferred.
2. **Go to the organisation's own words.** An archive's deposit guidance, a
   dataset's own codebook or download page, a publisher's own licence page. A
   blog summarising them is a lead, not a source.
3. **Cite every finding**: the page, its address, the day it was read, and the
   passage relied on, quoted where the wording matters.
4. **Say what could not be read.** Some sites block automated reading. Reading
   one through the owner's browser needs the owner's permission; ask, do not
   route around it. A paywalled article is noted and left.
5. **Contact nobody, sign up for nothing, download no dataset** beyond the
   documentation needed to read how it is published. Anything downloaded to read
   goes in the session scratchpad, never the repository.
6. **If practice points at an outside service or account** — a permanent
   identifier, a repository deposit, a hosted tool — report it as a question for
   the owner. Do not design around it.

**The report.** One file per piece, named below, written for the owner: plain
English, no database vocabulary, short sentences. The owner is a researcher and
the authority on the subject, and a beginner at running a database. In this
order:
1. **What was found, in a screen.** Facts only.
2. **The findings in full**, each sourced.
3. **Where practice disagrees**, and on what.
4. **What could not be found or read.**
5. **Questions only the owner can answer.**
6. **A recommendation**, labelled as one and kept apart from everything above,
   so the owner can read the findings without it.

Commit the report and push it. Update `docs/STATE.md` as `CLAUDE.md` describes.
The report settles nothing; the owner reads it, and the plan is finalised from
it.

---

## R1 — how a research dataset is handed to a researcher

**Report:** `docs/PHASE-2-RESEARCH-DOWNLOADS.md`

**Why.** What the published copy of the data looks like, and whether the site
reads files or a database, both wait on how researchers expect to receive a
dataset.

**Where to look.** These are places, not answers; the formats and standards are
for the research to find:
- how the UK Data Service and ICPSR expect a deposited dataset to arrive, and
  what they hand to the researchers who download one;
- codebook practice, and whatever standard archives use for describing a
  dataset's variables;
- citation practice for datasets;
- how comparable political-science datasets publish: the Comparative Agendas
  Project, the Congressional Bills Project, ParlGov, V-Dem. Any other dataset
  about legislatures or legislation found on the way is welcome, especially a
  UK or devolved one.

**What it must find out:**
1. **Formats.** Which file formats researchers are given, and why; what each is
   opened in. The owner knows which researchers they have in mind, so this
   reports what practice offers and leaves the fit to the owner.
2. **What travels with the file.** Codebook, methodology, provenance, the date
   taken, a suggested citation, a licence statement, and anything practice adds
   to that list.
3. **Whether worked-out figures travel as well as the raw values.** Here, the
   days between stages as well as the dates they are worked out from. How
   datasets that publish both, raw and derived, separate and label them.
4. **One file or several**, and how several are bundled and described.
5. **A dataset that changes.** How datasets that are revised say so, how they
   date or version what a researcher downloads, and how that sits beside a
   resource that promises no archive of old versions.

**Not in scope:** the licence (R2); how the working is shown on a web page (R3).

---

## R2 — the licence

**Report:** `docs/PHASE-2-RESEARCH-LICENCE.md`

**Why.** What a reader may do with a download has to be stated, and on what
grounds, not assumed. The dataset is built partly from other bodies' published
material, and their terms may constrain ours.

**What it must find out:**
1. **The terms each source is published under**, from each publisher's own
   statement: the Scottish Parliament's material, including the SPICe
   legislation fact sheets and the Official Report; and legislation.gov.uk.
   What each permits for a dataset derived from it, whether it may be
   redistributed, and what attribution it requires.
2. **Whether those terms settle the question**, or leave it unclear. Where they
   leave it unclear, say exactly what is unclear and draft the question the
   owner would put to the publisher. Do not resolve it by reading between the
   lines.
3. **Which licences comparable datasets use** (the ones in R1, and any other
   found), and any reason they give.
4. **What attaching a licence involves in practice**: where it is stated, what
   a download carries.

**The PhD dataset is the owner's**, and its terms are the owner's to state; the
report notes where it bears on the answer and goes no further.

**Say at the top of the report that it is not legal advice.**

---

## R3 — how others show the working behind a figure

**Report:** `docs/PHASE-2-RESEARCH-SHOWING-THE-WORKING.md`

**Why.** The owner wants complete transparency about the data a figure uses and
how it is calculated: "ideally showing our sql working". A later piece of
Phase 2 settles how that looks on a page; this finds out how others do it.

**Where to look.** Places, not answers: official statistics bodies and what
their codes of practice require of a published figure (the UK Statistics
Authority, the Office for National Statistics, the Scottish Government's
statistics); sites built around publishing charts with their data, such as Our
World in Data; data journalism that publishes its calculations; and any site
that shows the query or code behind a result beside the result.

**What it must find out:**
1. **Where the calculation and the data behind a figure are shown** — beside
   it, behind a link, as a download of that figure's own data — and what readers
   of each kind of site are expected to be able to read.
2. **How a reader gets from a figure to a single record in it**, and from that
   record to its source.
3. **How a site guarantees the calculation it shows is the one that ran**, rather
   than a copy kept in step by hand.
4. **Whether the answers depend on the data being held in files or in a
   database** behind the site, and how.
5. **How the date of the data is shown on a figure**, and what a reader is told
   it means.

**Not in scope:** what goes with a download (R1); the design of this site's
pages, which has its own house style already.
