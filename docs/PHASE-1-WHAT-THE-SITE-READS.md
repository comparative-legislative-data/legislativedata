# What the site reads from

Prepared 2026-09-15, as the briefing for the second infrastructure discussion.
**This file dies with Phase 1.** Nothing here is a decision. It is the options,
what each costs, and what published practice actually does, so the decision can
be made against how the site will really use the data rather than against Phase
1 alone. That widening is the owner's instruction, 2026-09-15.

---

## 1. The question is not one question

The site has two quite different jobs, and most of the confusion in this area
comes from trying to give them one answer.

**The bills.** Readers only ever look at them. Nothing a reader does changes a
bill. They change only when we promote a session, which is a handful of times a
year. The whole database is 14 MB and the bills tab itself is 304 kB — this is a
small body of data by any standard, and that opens options that would be closed
if it were large.

**The accounts.** The site writes these as well as reading them: somebody
applies, you approve them, they change a password. It has to be immediate — a
password changed at 2pm cannot still be the old one at 2.05. It is tiny. It is
also the only part that is about real people.

Those two want different answers. This briefing gives them different answers.

---

## 2. One fear worth taking off the table first

The obvious worry is a reader landing on the site halfway through a session
being promoted and seeing a half-finished picture — some bills updated, some
not.

**It cannot happen, and this is checkable rather than assumed.** Promotion is
written as a single all-or-nothing action. Everyone looking at the data sees the
old version right up until the moment it finishes, and the new version from that
moment on. There is no in-between that anyone outside can see. If the promotion
is abandoned part way, nobody ever saw any of it.

So the risk in this area is not the one it looks like. The real one is in the
next section, and it is subtler.

---

## 3. The risk that is actually there

Say a researcher spends twenty minutes on the site on a Tuesday afternoon, and
that is the afternoon Session 8 is promoted.

Nothing they see is ever half-finished. But the page they opened at 2.10 was
built from the data as it stood before the promotion, and the page they click
through to at 2.20 is built from the data after it. A total in a paragraph and a
total in a table they reach two clicks later can disagree, with nothing on
either page admitting that the ground moved between them.

That is not corruption. It is worse in one specific way: it is undetectable. A
researcher who quotes the first figure and is checked against the second has no
way to find out why they differ, and neither do we.

**This is the thing to decide about.** Not safety — that was settled by the
floor and by putting the site on our own machine. Internal consistency across a
visit, and being able to say honestly when a figure was true.

---

## 4. The options

### A. The site reads the working data directly

The site is given its own way in that can look but not change anything — not a
single cell, not a single tab. That part is standard and is not in doubt.

- **For it:** nothing to keep in step, nothing extra to build, a promotion is
  live the instant it finishes.
- **Against it:** section 3 happens. A reader's visit can straddle a promotion.
- **Against it, second:** a reader running something heavy — and "build their
  own tables and charts" means readers will — is competing for the same machine
  as a session being loaded. At 14 MB this is not a real worry now. It becomes
  one if the data grows or the site gets used.
- **The date stamp:** awkward. The honest stamp is "as at the second you asked",
  which is true but is not something a researcher can cite or come back to.
- **Backup:** nothing extra. What is backed up now is what the site reads.
- **Undo:** take the way in away.

### B. The site reads a copy, taken when we choose

A second, separate database on the same machine. The site can reach that one and
cannot reach the working one at all. We refresh it deliberately — after a
promotion, when we are satisfied.

- **For it:** a reader's whole visit comes from one moment. Every figure on every
  page agrees with every other, because they all came from the same copy.
- **For it, second:** we choose when readers see a change. A promotion we are
  still checking is not live because it happened.
- **For it, third:** the date stamp becomes trivially honest. The copy knows
  when it was taken; every page can say so, and a researcher can cite it.
- **Against it:** a second thing to keep in step, and it can go stale without
  anybody noticing. That is the failure to design against — the fix is that the
  site shows the date on every page, which makes staleness visible to everyone
  including us.
- **Against it, second:** refreshing it becomes a step in the promotion runbook,
  with its own rehearsal and its own undo.
- **Backup:** nothing extra. The copy is rebuildable from the working data, so
  it does not need backing up.
- **Undo:** point the site back at the working data and delete the copy.

### C. A copy that keeps itself in step, continuously

The machinery exists and is well proven. It removes the staleness problem.

It also removes the main benefit — we would no longer choose when readers see a
change — while adding a moving part that has to be understood, monitored and
repaired when it stops. **Not recommended at this size**, and named here so the
comparison is not rigged rather than because it is a real contender.

### D. No database reading for bills at all

Because the bills change only on promotion, and because they are small, the
finished data could simply be written out as files when a session is promoted —
the downloads researchers get anyway, and the figures behind the charts. The
site would serve those.

- **For it:** the reader never touches any database. Fast, cheap, and the file
  is stamped when it is made.
- **For it, second:** the download and the chart are then provably the same
  data, because they are the same file.
- **Against it:** "build their own tables and charts" is harder to do well this
  way, and how much harder depends on what the style discussion decides those
  tools are.
- **Verdict:** a real option, and possibly the right one, but it cannot be
  settled before Phase 2 knows what those tools are. **Option B does not close
  it** — a copy is the natural thing to write the files from.

---

## 5. What published practice actually says

Stripped of jargon, it is two rules, and they are close to unanimous:

1. **The place where work happens is not the place readers read.** Whatever the
   mechanism, the working data and the published data are separated.
2. **The way in that a website uses can never be one that can change anything.**
   This holds under every option above, including A.

Worth saying plainly: **this project already invented rule 1.** The whole
discipline of Phase 0 is a staging sheet held apart from the clean sheet with a
gate between them, and nothing crossing except by review. A published copy is
the same staircase with one more step on it — clean sheet, gate, published — and
it is the step that has never been placed.

That is not an argument that B is right. It is an argument that B is the option
this project already knows how to explain, which is a real consideration here.

---

## 6. The accounts

Separate answer, and a much shorter one.

The accounts must be written the instant something changes, so no copy makes
sense for them. They live in their own place that the site reads and writes
directly, and they are never mixed in with the bills.

**They need to be backed up, and nothing backs them up today**, because they do
not exist yet. The nightly backup covers the working database. Whatever holds
the accounts has to be added to it on the day the first account exists, not
after. That is a thing to build in Phase 1, not a thing to notice in Phase 2.

---

## 7. What I would recommend

**B for the bills, and their own place for the accounts.**

The reasons, in the order they carry weight:

1. A researcher's visit comes from one moment, and every figure they see agrees
   with every other. Option A cannot promise that and the failure is silent.
2. The date stamp becomes honest and citable, which is what we have already said
   we vouch for — the data as it stands when it is accessed, stamped with the
   date it was taken.
3. We choose when readers see a change, which matches how everything else in
   this project already works.
4. It is the option that is one step from what the project already does, and the
   one the owner can already explain.
5. It does not close off D, which may well be better once Phase 2 knows what the
   reader's tools are.

**The cost, stated rather than discovered:** refreshing the copy becomes a step
in the promotion runbook, with a rehearsal and a written undo like every other
step. And every page carries the date of the copy it was built from — not as
decoration, but because that is what stops it going stale unnoticed.

---

## 8. What this needs from you

- **The answer for the bills:** A, B or D.
- **Whether the accounts get their own place**, kept apart from the bills.
- **Whether every page carrying the date of the data it was built from** is
  accepted now as a rule, since it is the thing that makes B safe rather than
  merely convenient.

Nothing gets built from this until it is settled, and nothing here is built yet.
