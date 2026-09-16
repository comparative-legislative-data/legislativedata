# The page saying what is held — for the owner to settle

Five questions, each with a recommendation, then the page in full.

Every statement on the page was checked against the site's code, the web
server's settings, the backup job and Resend's own pages on 16 September, not
taken from the decisions. Where they differed, the page follows the machine, and
the difference is below.

This file goes when Phase 1 closes, like the other `PHASE-1-` files.

---

## 1. Backups keep a deleted account for ten years

**Found while checking.** The nightly backup keeps 14 daily, 8 weekly, 12
monthly and 10 yearly copies. Since 16 September the accounts are in the same
copy as the bills, so they are kept the same way. Someone who is refused, or
whose account you delete, is gone from the site at once and stays in the backup
for up to ten years.

The backup is encrypted, and nobody can read it without the key. But the page
cannot say "deleted" and leave that out. Today the backup holds your account and
nobody else's. From the first application, it holds other people.

**Recommended: back up the accounts separately, and keep them for about five
weeks.** That means 14 daily copies and 4 weekly ones. The bills keep their ten
years. The page can then say a deleted account is gone from the backups within
five weeks.

What it costs:
- a change to the backup job, rehearsed and restore-checked like the first one;
- an accounts mistake noticed more than five weeks later cannot be undone from
  the backup. With a handful of accounts, the person can apply again.

The copies already taken since 16 September hold only your account. They can be
left to age out, or have the accounts taken out of them. I'd take them out, so
the five weeks is true from the day the page goes up.

The other way: keep the backup as it is, and have the page say ten years.

## 2. Does the page say who runs the site?

**Recommended: yes, by name.** Someone asking what is held about them needs to
know who holds it, and a privacy page is expected to say. Your name is yours to
publish. At the moment no page on the site names anyone.

## 3. The other companies: by name, or by what they do?

**Recommended: Resend by name, and the other two by what they do.** Naming
Resend is already settled. The company the machine is rented from, and the one
the backup is stored with, are named only in the private notes, on purpose. The
page can describe them without naming them: a rented machine, and a second
company storing a backup it cannot read.

Cloudflare is left off. It runs the domain name, but no visitor's traffic
passes through it.

## 4. Rights, and where to complain

**Recommended: one sentence each.** Anyone can ask what is held about them, have
it corrected, or have it deleted, all at the deletion address. If they are
unhappy with the answer, they can complain to the Information Commissioner's
Office. You know this ground better than I do; say if it wants more or less.

## 5. Where the page sits

**Recommended:** at `legislativedata.org/privacy`, the address people look for.
A link, "What this site holds", goes in the footer of every page. One sentence
is added to the bottom of the apply page's "What this form keeps": "All of what
the site holds is on [What this site holds]."

---

## What I'll do unless you say otherwise

- **The page says when it last changed**, and the date is updated when it does.
- **Tidying up is described the way the site actually does it.** Old codes and
  expired sign-ins are not removed on a timer. They are removed the next time
  anyone asks for or tries a code. They stop working on time either way. The
  page says "no longer works" and "is removed", and does not promise when the
  removal happens.
- **Light mode is mentioned.** The choice is kept in the reader's own browser and
  never sent to the site. Without that sentence, "one cookie" reads as if nothing
  else is stored.
- **Testing:** the page is checked on the machine against a staged release
  before it is switched live. The check confirms the link is on every page, and
  that the cookie's name and lifetime on the page match what signing in
  actually sets. Then you read it on the live site.

## Checked, and true as the page says it

- **Nothing about a reader.** The web server's log holds the page, the time and
  the result. No address, no browser and no headers, including the cookie. The
  site loads nothing from anywhere else: the fonts are on the machine, and there
  are no outside scripts.
- **One cookie**, `signed_in`, set only on signing in. It lasts 30 days, scripts
  cannot read it, and it is sent only over https. Signing out removes it and the
  site's record of it.
- **What a signed-in device holds**: a scramble of the marker, when it signed in,
  and when it expires. Nothing else.
- **Codes**: six digits, work once, last 15 minutes, stop after five wrong tries,
  and at most three an hour. Each is held only as a scramble, and its record is
  kept for an hour.
- **Resend** keeps email content and logs for 30 days on every plan short of
  Enterprise, and stores them in the United States. It relies on the standard
  contract clauses and the UK addendum. Its own GDPR page, read 16 September.
- **Deleting a person** removes their codes and devices with them. The database
  does this itself.

---

## The page, in full

Answers 2 and 1 are shown as brackets. Everything else is as it would appear.

> ABOUT THIS SITE
>
> # What this site holds about you
>
> As little as it can work with. This page is all of it.
>
> legislativedata.org is run by [NAME].
>
> ## If you only read the site
>
> Nothing. There are no analytics and no cookies, and your IP address and
> browser are not recorded. The site's log records which pages were asked for
> and when, and nothing about who asked.
>
> If you switch to light mode, that choice is kept in your own browser and is
> never sent to the site.
>
> ## If you apply for an account
>
> - Your email address, name, title and position, and the date you applied.
> - Whether your application was approved, and when.
>
> These are seen only by the person who decides on applications. An approved
> application is kept while you have an account. A refused one is deleted once
> you have been told.
>
> ## If you sign in
>
> - **A sign-in code.** It works once, for 15 minutes, and is held only in a
>   scrambled form that cannot be used to sign in. Its record is kept for an
>   hour, so that no address is sent more than three codes an hour, and is then
>   removed.
> - **One cookie, called `signed_in`**, set only when you sign in. It keeps that
>   device signed in for 30 days and does nothing else.
> - **For each device you are signed in on**, when you signed in and when that
>   ends. Not the device's address, its browser or where it is.
>
> Signing out removes the cookie and the site's record of that device. Nothing
> is recorded about what you look at while signed in.
>
> ## Backups
>
> Everything above is copied each night into a backup, encrypted and stored
> with a second company that cannot read it. Anything deleted from the site is
> gone from the backups within [five weeks].
>
> ## Who else sees it
>
> **Resend** sends the site's emails: your sign-in codes and the decision on
> your application. It sees your email address and keeps a copy of each email
> for 30 days, in the United States.
>
> The site runs on a rented machine. The company it is rented from runs the
> machine and is given nothing about you.
>
> No one else. The site uses no advertising, analytics, or fonts or scripts
> from anywhere else.
>
> ## Seeing, correcting or deleting what is held
>
> Write to comparativelegislativedata@gmail.com to ask what is held about you,
> to have it corrected, or to have it deleted. Deleting an account removes your
> details, codes and signed-in devices together. That address is an ordinary
> Gmail account, so your message is held by Google like any other email.
>
> If you are unhappy with how your details have been handled, you can complain
> to the Information Commissioner's Office at ico.org.uk.
>
> *Last changed [date it goes live].*
