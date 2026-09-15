# Phase 1 — the site

The detailed plan for Phase 1. `PLAN.md` is the arc and stays short; this is the
working detail — the order things get built in, what is being tried, and what
turned out not to work.

**This file is destroyed when the phase closes.** That is the point of it, and
it is why detail is allowed to be long here. Closing the phase includes a sweep,
run by a session that did none of the phase's work, in which every line below is
either moved to a permanent home or dropped. The homes are listed at the end.

**It is for whoever runs the session, not for the owner.** The owner orients
from `STATE.md`. A phase plan that starts collecting status is a second
`STATE.md`, growing in a place where nobody is cutting it. Nothing here is
written for the owner to read as a progress report.

---

## The order: infrastructure, then style

**Settled by the owner, 15 September.** The two scoping discussions are kept
separate and run in that order. Infrastructure closes before style opens.

The reason is that where the site runs and what it reads from decides what can
be built on it. Style settled first would be settled against an unknown, and
would then be re-argued the moment infrastructure moved under it.

**Open now:** the infrastructure discussion. Style has not opened.

---

## Discussion 1 — infrastructure

### How it runs

**It takes in views from outside this project.** That is the whole reason it is
a discussion rather than a decision made in a session. This project's habits
were built for a hand-made dataset of 470 bills; they are not evidence about how
to run a website.

**Guiding the owner is not the same as settling it from inside.** The owner has
said plainly that they are not an experienced database developer and want to be
guided on safe practice for the second question. That is what the session is
for: bring the options, what each costs, what each risks, and what published
practice actually does — in the vocabulary the owner reasons in — and then the
owner decides. The rule against answering from inside the project is a rule
against quietly adopting whatever is convenient. It is not a rule against
explaining.

**The two questions the owner has named come first, in this order:** where the
front end runs, then what the site reads from. The remainder follow. All of them
have to be settled before the phase closes.

**Host detail does not come into this repository.** The answers do; the
addresses, keys and account names live in the private notes outside it.

### Question 1 — where the front end runs — **SETTLED, 2026-09-15**

**The answer: the machine we already rent.** The site and the database share it.
Recorded in `DECISIONS.md` under "The front end runs on the machine we already
rent", which carries the reasons, the price of the choice and the undo. The
comparison it was decided from is `docs/PHASE-1-HOSTING.md`.

**What it settles for the rest of the phase:**

- `PLAN.md`'s question of whether the site and the database share a machine is
  answered. They do.
- The bills never have to travel and no door is opened for them from outside.
- No part of the site may be written in a form only one company can run. That
  is what keeps the undo cheap, and it is a constraint on the style discussion.

**What it puts on us, and what the phase must therefore build:** the running of
it — security updates (already automatic), the certificate, the web server in
front of the site, and the response when something stops. The deploy procedure
and its written undo are part of the phase, not an afterthought.

**Still to record:** the machine's renewal date. It is prepaid for a year, and
now that the site is on it too, one prepayment lapsing takes down the data and
the site together. Host and account detail stays outside this repository; the
date belongs in the private notes.

### Question 2 — what the site reads from

**The choice:** a reader's page looks at the working database directly, or the
data is copied somewhere the site reads and the working database is never
reachable from the site at all.

**Why this one leads.** The working database is the one sessions are loaded
into, promoted on and rolled back on. Phase 0's entire discipline is the staging
sheet held apart from the clean sheet, with a gate between them. A website
reading the same database is a third surface on it, and it has never been
placed.

**The floor is already fixed, and narrows this.** The owner settled on
2026-09-15, before the hosting question, that the working database is never
reachable from the public internet. That rules out one thing only. Whether the
site reads a copy or reads the working database itself, from inside the machine
it shares with it, is exactly what is still open.

**Question 1's answer changes the shape of this one**, and the briefing must be
written against the answer rather than against both options. The site is on the
same machine as the database. Nothing has to travel and no door has to be opened
for it, so this is no longer a question about exposure — the floor and the
hosting decision between them have dealt with that. What is left is a question
about *trust in a moment*: whether a reader's page should ever look at a
database that a session may be halfway through being promoted into.

**Two things the briefing must now take account of**, both of which post-date
the list below and neither of which answers the question:

- **Phase 1 puts no bill data on any page.** The bills are not read by the site
  until Phase 2. So there is a real option of settling the principle now and
  building nothing for it until Phase 2 needs it — and an argument against,
  which is that a principle with nothing built against it is the state
  `CLAUDE.md` warns about. The briefing should say which, and why.
- **Phase 1 does hold something the site must read and write: the accounts.**
  Those are not in the working database today and nothing has said where they
  go. Whether they sit in the same database as the bills, or a separate one, is
  part of this question and not a separate one — it is the same question asked
  about the only data Phase 1 actually has.

**This question gets a written briefing before the discussion, not during it.**
The owner asked to be guided, and a guide delivered mid-conversation is a guide
nobody can weigh. It goes in a file, with one line saying where it is, and it
covers:

- what each option actually means, in spreadsheet terms, traced through one real
  bill and one real session being loaded;
- what can go wrong in each, written as what a reader would see happen;
- what happens to the site *while* a session is being loaded, promoted or rolled
  back — the moment when the working database is least trustworthy;
- whether the site could ever show half-promoted data, and what stops it;
- what "the site can only read" means in practice, and how much protection it
  really is;
- if a copy is taken: what it costs to keep in step, how stale it can get, and
  how a reader would know;
- **which option makes the date stamp honest.** What we vouch for is the data as
  it stands when it is accessed, stamped with the date it was taken. That
  promise is easier to keep truthfully under one of these options than the
  other, and the briefing has to say which and why;
- what the nightly backup covers in each case;
- how each option would be undone.

What has to come out of it: the answer, the reasons, and the rule written down
plainly enough that it is not re-argued in six months.

### The remainder, still to settle before the phase closes

Named in `PLAN.md`, not named by the owner today as priorities, and not
optional.

- **What is held about a user, and why.** Accounts mean personal data, which
  this project has never held. `CLAUDE.md`'s rule already applies from the day
  the first account exists: real data about a real person goes in no commit
  message, no document, no test fixture and not into the conversation. Settling
  this question is settling how little we can get away with holding.
- **What the beta gate becomes afterwards.** During beta, access is by approval.
  This is meant to be open to researchers, and whether a download stays behind a
  login once beta ends is not settled.
- **The domain.**

### What closes the discussion

Every question above answered and written down in its permanent home — a
settled decision to `DECISIONS.md`, a position that holds whatever session is
running to `STANDING.md`, anything about how to run or undo something to a
runbook. Then style opens.

---

## Discussion 2 — style

**Not open.** It opens when the infrastructure discussion has closed.

It is a deep dive and may go as deep as it earns. **The bound is on what gets
built, not on what gets decided:** Phase 1 builds the pages named below and
nothing else, whatever the deep dive settles.

Its questions are written when it opens, not now. Writing them now would be
scoping it against infrastructure answers we do not have, which is the reason
the two were separated.

---

## What gets built, after both discussions

The whole of it, from `PLAN.md`:

- somebody can apply;
- the owner can approve or refuse an application;
- an approved person can log in;
- they can see that they are logged in as themselves;
- they can change their password;
- they can log out;
- a welcome page.

**Must not.** No data on any page. No charts, no tables of bills, no downloads,
no figures of any kind — all of that is Phase 2 in its entirety, and a figure
put on a page now would be a figure published before the rules for publishing
one exist. No tools for users to build things. No new data.

**The temptation this phase has to survive** is one chart on the welcome page to
make it look like something. The welcome page is a welcome.

---

## How the phase closes

1. The owner can approve a beta application, log in, change a password, and log
   out.
2. The infrastructure decisions are recorded.
3. The style decisions are recorded.
4. A written test has been run by a session that did none of the work.
5. That same session runs the sweep and deletes this file.
6. The owner signs off that they can explain what was built and how it runs.

**Anything that changes something other people depend on gets a written
procedure and a rehearsal before it is trusted.** A deploy is the site's version
of a promotion and gets the same treatment, including the written undo. See
`PROMOTION-RUNBOOK.md` for the shape; the site will need its own.

## The sweep — where each line of this file goes

Every line below the header is one of these, and nothing is cut until it is
proved present in its new home:

- a decision that was settled → `DECISIONS.md`
- a position that holds whatever session is running, something verified rather
  than assumed, or something deliberately left undone and what would reopen it
  → `STANDING.md`
- how to run something, or how to undo it → the runbook for that thing
- what a table or column holds → a `COMMENT` in a migration, so it reaches the
  data dictionary
- a change to the arc itself → `PLAN.md`
- anything else → working detail, and it goes

---

## What has been tried, and what did not work

Nothing yet. This is where a session records an approach that was taken and
abandoned, so the next session does not take it again. It is not a status log.
