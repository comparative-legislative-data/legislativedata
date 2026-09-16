# The page saying what is held — for the owner to settle

The owner's answers, 16 September, then two small points left, then the page in
full.

Every statement on the page was checked against the site's code, the web
server's settings, the backup job and Resend's own pages on 16 September, not
taken from the decisions. Where they differed, the page follows the machine.

This file goes when Phase 1 closes, like the other `PHASE-1-` files.

---

## Settled by the owner, 16 September

1. **Backups.** Agreed, and widened: the backup is to be separated by theme.
   That is its own proposal, `docs/PHASE-1-BACKUP-THEMES.md`, **settled and built
   the same day**, so "five weeks" is now true.
2. **Who runs the site:** named as Dr Steven MacGregor, owner and administrator.
   The contact stays `comparativelegislativedata@gmail.com`.
3. **The other companies:** Resend by name. The machine's host and the backup's
   storage are described by what they do, not named.
4. **Rights and complaints:** agreed, and easy to reach, from the header.
5. **Where it sits:** a link in the header of every page, not only the footer.

**One thing this changes.** The 16 September sign-in decision says the owner's
own details go into no commit or document, the repository being public. Your
name on a public page has to be written into the page, and so into the
repository. It is your choice to publish it. The decision entry will record the
exception, so the next session doesn't take it out.

## Two small points left — both settled as recommended, 16 September

### A. One page, or two?

**Recommended: one page**, with rights and complaints as its last section, easy
to find. A person asking "what do you hold, and what can I do about it" wants
both answers in one place. A second page would say little that the first
doesn't lead into.

### B. What the header link says

**Recommended: "Privacy"**, at `legislativedata.org/privacy`. It's the word
people look for. "Your data" was considered and rejected: on a site whose whole
subject is data, it reads as a researcher's downloads.

The header would read "Privacy · Sign in · Apply for an account", or, signed in,
"Privacy · Signed in as [name] · Sign out". One sentence is added to the bottom
of the apply page's "What this form keeps": "Everything the site holds, and your
rights, are on the Privacy page."

---

## What I'll do unless you say otherwise

- **The page says when it last changed**, and the date is updated when it does.
- **Tidying up is described the way the site actually does it.** Old codes and
  expired sign-ins are not removed on a timer. They are removed the next time
  anyone asks for or tries a code. They stop working on time either way. So the
  page says "no longer works" and "is removed", and does not promise when the
  removal happens.
- **Light mode is mentioned.** The choice is kept in the reader's own browser and
  never sent to the site. Without that sentence, "one cookie" reads as if nothing
  else is stored.
- **Cloudflare is left off.** It runs the domain name, but no visitor's traffic
  passes through it.
- **Testing:** checked on the machine against a staged release before it is
  switched live. The check confirms the link is in the header of every page,
  signed in and not, and that the cookie's name and lifetime on the page match
  what signing in actually sets. Then you read it on the live site.

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
  contract clauses and the UK addendum. From its own GDPR page, read 16
  September.
- **Deleting a person** removes their codes and devices with them. The database
  does this itself.
- **The backup's five weeks**: true since the backup was separated by theme on
  16 September. The oldest accounts copy left in the rehearsal was 17.6 days.

---

## The page, in full

> PRIVACY
>
> # What this site holds about you
>
> As little as it can work with. This page is all of it.
>
> legislativedata.org is run by Dr Steven MacGregor, who decides on applications
> and is the only person who sees the details given in them.
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
> An approved application is kept while you have an account. A refused one is
> deleted once you have been told.
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
> The accounts are copied each night into a backup of their own, encrypted and
> stored with a second company that cannot read it. Anything deleted from the
> site is gone from the backups within five weeks.
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
> No one else. The site uses no advertising, no analytics, and no fonts or
> scripts from anywhere else.
>
> ## Your rights, and complaints
>
> Write to comparativelegislativedata@gmail.com to ask for a copy of what is
> held about you, to have it corrected, or to have it deleted. Deleting an
> account removes your details, codes and signed-in devices together. That
> address is an ordinary Gmail account, so your message is held by Google like
> any other email.
>
> If you are unhappy with how your details have been handled, you can complain
> to the Information Commissioner's Office at ico.org.uk.
>
> *Last changed [the date it goes live].*
