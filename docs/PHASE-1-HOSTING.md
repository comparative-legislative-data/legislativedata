# Where the front end runs

Prepared 2026-09-15 for the first infrastructure discussion. **This file dies
with Phase 1.** The answer and the reasons go to `DECISIONS.md`; anything that
holds whatever session is running goes to `STANDING.md`. Nothing here is a
decision — it is the comparison the plan asks for before you make one.

## First, what is actually being hosted

Phase 1 builds a welcome page and a way in: somebody applies, you approve or
refuse them, they log in, see they are logged in as themselves, change their
password, log out. **No bill data appears on any page** — not a chart, not a
table, not a single figure. That is all Phase 2.

So the thing we are finding a home for is not a set of pages about bills. It is
a page that **remembers people**. That is the first time this project holds
anything about a real person, and it is the fact the comparison turns on.

It also means the bills are not in this question yet. The site does not need to
reach them until Phase 2.

## The floor, agreed today

The working database is never reachable from the public internet, whatever we
host the site on. Both options below are written to sit inside that.

---

## Option A — the machine we already rent

The bills already live on it. It runs Debian, PostgreSQL is set to answer only
to the machine itself, the firewall lets nothing in but the way we log in, and
it locks out anything hammering the door.

**What it costs.** Nothing more than now. The machine is paid for because the
bills are on it, so putting the site there adds £0 a month.

One thing worth knowing: Hetzner raised its prices in June 2026, by roughly two
and a half times on this class of machine. Existing arrangements were left
alone; new orders and **resizes** were not. So the machine is cheap while it
stays the size it is, and would reprice if we ever made it bigger.

**Who else we depend on.** Nobody new. Hetzner, who we already depend on.

**Where people's details sit.** On a machine we control, next to the bills,
behind the firewall we set, inside the backup that already runs nightly.

**What it would take to move.** Everything on it is ours and copyable. No part
of the site would be written in a form only one company can run. Moving means
renting another machine and putting the same things on it.

**What it costs us in work.** This is the real price, and it should be written
down now rather than discovered in March. We run it: security updates, the
certificate that makes the padlock appear, the web server in front of the site,
and the response when something stops at eleven at night. Automatic security
updates are already on, which covers the dullest part of it.

## Option B — a free tier

**It is not one new thing to depend on, it is two.** Free tiers are built to
hand out fixed pages very fast and very cheaply. A login is not a fixed page:
something has to run, and something has to remember who has an account. So the
site would need a provider for the pages *and* a provider for the accounts.

**What it costs.** Nothing, within limits, and the limits are generous for a
site this size. Cloudflare Pages: unlimited traffic, 500 rebuilds a month.
Netlify and Vercel: 100 GB of traffic a month, and Netlify charges around $55
for each further 100 GB. All three permit commercial use.

**Who else we depend on.** Two companies, on terms they write and can change,
with no contract and nobody to ring.

**Where people's details sit.** With one of those companies. `CLAUDE.md` says
real data about a real person does not leave the place it is held; this option
starts by moving it somewhere else, on the first day we have any.

**What the floor costs here.** The site is somewhere else, so when Phase 2
arrives it cannot see the bills. It would need a copy sent out to it, or a door
opened on our machine for it to knock at. Either is buildable. Neither is free,
and the door is the thing today's floor exists to avoid.

**What it would take to move.** The pages move easily. The accounts do not —
they would sit in whatever that provider's own store is, and getting them out
is on their terms.

**What it is genuinely better at.** It stays up without us. Nothing to patch,
nothing to renew, no night-time failures that are ours. That is not a small
thing and it is the honest case for it.

---

## A third, named so the comparison is not rigged

A small paid platform — Railway, Fly, Render — runs code and keeps accounts for
a few pounds a month, without us patching anything. It is the middle of the two.
It is not recommended here only because it adds a company and a bill to solve a
problem we do not have: we are already paying for a machine that can do this.

---

## What I would recommend, and why

**The machine we already rent.**

1. It adds nobody new to depend on, at the exact moment the project starts
   holding data about real people.
2. Those people's details stay where we control them and where the nightly
   backup already reaches.
3. It costs £0 more.
4. It keeps the Phase 2 door shut. Site and bills in one place means the bills
   never have to travel and no door has to be opened for them.

**The price of choosing it, stated plainly:** we become responsible for keeping
a web server patched, certificates renewed, and the site up. If that is a job
you do not want the project to own, that is a real reason to choose otherwise,
and it is the only strong one.

## What I cannot answer and you can

What the machine actually costs a month. It is not written down anywhere in the
project, and it should be. Everything above holds whatever the figure is — the
site adds nothing to it either way — but the figure belongs in the record.

## Sources

- [Hetzner cloud server price increases in 2026 — Northflank](https://northflank.com/blog/hetzner-cloud-server-price-increases)
- [Hetzner Cloud Pricing After the April 2026 Increase — bitdoze](https://www.bitdoze.com/hetzner-cloud-cost-optimized-plans/)
- [Cloudflare Pages Pricing 2026: Free Tier Limits](https://dev.to/nayankyada/cloudflare-pages-pricing-2026-free-tier-limits-workers-costs-when-to-upgrade-2ono)
- [Vercel vs Netlify vs Cloudflare Pages 2026 — CoderFile](https://coderfile.io/blog/vercel-vs-netlify-vs-cloudflare-2026)
