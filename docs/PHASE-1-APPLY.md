# The apply page — for the owner to settle

Six questions, each with a recommendation, then the wording in full. Where you
agree with a recommendation, "yes" is enough. Nothing is built until all six are
settled.

This file goes when Phase 1 closes, like the other `PHASE-1-` files.

---

## 1. Does applying send an email?

**Recommended: no.** Nothing is sent when someone applies. The first email they
get is the decision.

Why: nobody has proved the address is theirs at that point. If applying sent an
email, anyone could type a stranger's address into the form and use the site to
send them mail. The decision email doesn't have that problem, because you
choose to send it.

## 2. What someone sees if they apply twice

**Recommended: exactly the same page as the first time**, and nothing changes in
the accounts. This covers an address that has already applied, been approved or
been refused.

Why: if the page said "this address has already applied", anyone could use the
form to find out whether a given person has an account.

## 3. Are you told when an application arrives?

**Recommended: not by email, for now.** The admin screen shows how many are
waiting, and you look. Revisit it if applications sit unread.

Why: an email to you means the site can send email before anything else needs
it, and makes every application something that has to be sent through Resend.

## 4. How long an application is kept

This is new: it was not settled on 15 September, and the form has to say it.

- **Waiting, or approved:** for as long as the account exists, until you delete
  it. Nothing to decide here.
- **Refused — recommended: deleted when you refuse it**, straight after the
  refusal email is sent. The alternative is keeping it until you delete it by
  hand.

Why deleting it: it's the least we can hold, and a refused application has no
further use. What it costs: if the same person applies again, you won't see that
you refused them before. It also means no row stays in the refused state. The
column's description would say that, which is a small change, made with the
admin screen.

## 5. How does someone ask for their data to be deleted?

**This one needs an answer from you, not a yes.** The form has to give an
address to write to. There are two ways to do it:

- **An address at `legislativedata.org` that forwards to you.** Cloudflare
  already holds the name and can forward mail free of charge, so no new company
  is involved. It is still a new thing to set up, so it's yours to say.
- **An address you already have.** It would appear on a public page.

## 6. When the page goes live

**Recommended: built and tested now, but switched off on the live site until
the admin screen exists.** Otherwise someone could apply and wait with nobody
able to see the application.

---

## What I'll do unless you say otherwise

- **No cookie, no captcha, and nothing recorded about the visitor.** Against
  junk submitted by bots, there's a hidden field people never see and bots tend
  to fill in. A form filled in that way gets the thank-you page and nothing is
  kept. Captchas are a third party, and limiting by address would mean recording
  addresses, which you ruled out on 16 September.
- **Title is optional and free text**, not a list.
- **Length limits:** email 254 characters, name 200, title 50, position 300.
- **The welcome page's line** "Accounts, and the way to apply for one" comes out
  when the page goes live, and a link to apply goes in the top bar.
- **Testing** uses an invented person on the live accounts, the way the backup
  test did, deleted afterwards. The test checks that the site refuses each
  wrong entry, and that a second application from the same address changes
  nothing.

## Found while writing this

`STANDING.md` and `PLAN.md` still say "web server logs for 14 days". Since 16
September the log holds nothing about a visitor, and it is kept by size, not
days. The form's "what we keep" must not repeat the old line. I'll correct both
when this is settled.

---

## The wording, in full

Square brackets are the answers to questions 4 and 5.

### The apply page

> ACCOUNTS
>
> # Apply for an account
>
> legislativedata.org is in preparation, and accounts are for its beta.
>
> Nothing is published yet. When it is, it will be available to people with an
> account while the site is in beta.
>
> Every application is read and decided by hand. You will be emailed either way.
>
> **Email address**
> Where your sign-in codes will be sent. There are no passwords.
>
> **Name**
>
> **Title** (optional)
> For example, Dr or Professor.
>
> **Position**
> Your post and institution, or how you would describe what you do.
>
> [Apply]
>
> WHAT THIS FORM KEEPS
>
> - Your email address, name, title and position, and the date you applied.
> - Whether your application was approved, and when.
> - Nothing else: not your IP address, not your browser, and nothing about your
>   visit.
> - [An approved application is kept while you have an account. A refused one
>   is deleted once you have been told.] To have yours deleted, write to
>   [address].
> - Emails from the site, including the decision on your application, are sent
>   through Resend, which therefore sees your email address.

**One sentence makes a promise**: "When it is, it will be available to people
with an account while the site is in beta." You deferred what access becomes
after beta, and this says nothing about after. It does promise that beta
accounts get the data. Cut it if that's more than you want to say yet.

### After applying

> # Application received
>
> Thank you. Your application will be read by hand, and you will be emailed at
> that address when it has been decided.
>
> If that address has applied before, nothing has changed and you do not need
> to apply again.

### When something is wrong with the form

Shown above the form, with everything the person typed still filled in.

> - Enter your email address.
> - That doesn't look like an email address.
> - Enter your name.
> - Enter your position.
> - [Field] must be under [n] characters.

### When the accounts can't be reached

> # Applications can't be taken right now
>
> Nothing you entered has been kept. Please try again later.
