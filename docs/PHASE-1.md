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

### Question 2 — what the site reads from — **SETTLED, 2026-09-15**

**The answer: three databases** — the working one, a published one taking only
what is published, and the accounts. All on the machine the site runs on. The
site reads the published one and cannot see the working one at all. Recorded in
`DECISIONS.md` under "Three databases: the working one, the published one, and
the accounts", which carries the reasons, the backup rule and the cost. The
briefing it was decided from is `docs/PHASE-1-WHAT-THE-SITE-READS.md`.

**Two things this puts into the phase as work, not as notes:**

1. **The accounts database must be in the nightly backup on the day the first
   real person has an account.** The backup dumps one database and will not pick
   up a new one by itself. Rehearsed like a promotion: back up, restore into a
   scratch copy, confirm the account is really there. This repeats a failure
   that has already happened once, on 2026-09-09.
2. **Refreshing the published copy becomes a step in the promotion runbook**,
   with its own rehearsal and written undo.

**Settled inside it, 2026-09-15:** every page showing data carries the date of
the data it was built from. Maximum transparency, the owner's reason. It is also
what makes a stale published copy visible, which is what this shape is most
exposed to. Recorded in `DECISIONS.md`.

**Deliberately not closed:** writing the published data out as files at
promotion time, so the site reads no database for bills at all. Cannot be
settled before the style discussion says what a reader's tools are.

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
- **The domain — SETTLED, 2026-09-15.** `legislativedata.org`, already held by
  the owner, already connected to Resend for sending, DNS managed through
  Cloudflare. To establish when the site is built, not now: whether traffic is
  proxied through Cloudflare or DNS only, because that decides what the web
  server actually sees and therefore what the logs contain.

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
- an approved person can ask for a code, receive it by email, and sign in;
- they can see that they are signed in as themselves;
- they can sign out on this device;
- a welcome page.

**Amended 2026-09-15**, when the owner settled that there are no passwords. The
list read "they can change their password", which no longer exists. Three things
were added to the phase by the same decision and are build items, not notes: a
short plain-English page saying exactly what is held about a user; a way for the
owner to delete an account and everything attached to it; and a way for the
owner to get in that does not depend on an email arriving, since with codes a
broken mailer locks everyone out including them.

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
