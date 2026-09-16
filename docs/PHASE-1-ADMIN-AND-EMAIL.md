# The admin screen and email — for the owner to settle

What is left before you can test the whole thing on the live site: apply with
one address, approve or refuse it on the admin screen, get the email, and sign
in with a code sent by email. Where you agree with a recommendation, "yes" is
enough. The wording is at the end, in full.

This file goes when Phase 1 closes, like the other `PHASE-1-` files.

---

## What you will be able to test at the end

1. **Your own address:** press Sign in, enter your address, get a code by
   email, sign in, sign out.
2. **Applying and approving:** in a private browser window, apply with another
   address you hold. It appears on your admin screen. Approve it; the approval
   email arrives; sign in as that address with a code by email.
3. **Refusing:** apply again with an address, refuse it, get the refusal email,
   and see that it has gone from the admin screen.
4. **Deleting:** delete the account you approved in step 2.

---

## 1. The admin screen

**Recommended:**

- At `/admin`. Your account sees it; everyone else gets "not found", so it does
  not reveal that it exists. An "Admin" link in the top bar, for you only.
- **Waiting applications**, oldest first, each with name, title, position,
  address and the date applied, and two buttons: Approve and Refuse.
- **Accounts**: everyone approved, with the same details and the date approved,
  each with a Delete account button. Your own is listed without one.
- **Approve happens at once.** It can be undone by deleting the account.
- **Refuse and Delete ask you to confirm first**, on a page of their own,
  because neither can be undone.

## 2. Emails, and what happens if one can't be sent

**Recommended:**

- **Approving and refusing each send an email; deleting sends none.**
- **The email goes first.** If it cannot be sent, nothing changes and the
  admin screen says so. That way nobody is approved without being told, and no
  refused application is deleted before the person has been told, which is what
  you decided.
- The refusal email gives no reason. There is no box for one.

## 3. Who the emails come from

**Recommended:** from `legislativedata.org <no-reply@legislativedata.org>`,
with replies going to `comparativelegislativedata@gmail.com`, the address the
apply page already gives. Plain text only, with no tracking of whether an email
was opened or a link was clicked.

## 4. The key the site sends with — needs you to do one thing

The Resend key on this Mac has **full access**: it can manage the domain and
the account, not only send. The site should hold a key that can **only send,
and only from legislativedata.org**.

**Recommended:** in Resend, make a new key with "Sending access" for
`legislativedata.org`. Put it in a file on this Mac, `~/.claude/legdata-resend-send`,
in the same form as the existing one (`RESEND_API_KEY=...`). I copy it to the
machine without it appearing in the conversation, beside the code key in
`/var/lib/legislativedata/`, readable by the site and root only, and not in the
backup: a lost key is replaced in Resend in a minute.

The private notes said it would go in `/etc/legislativedata/env`. That was
written before the code key went in `/var/lib/legislativedata/`, and `/etc` is
in the backup. I'll correct the notes.

## 5. Asking for a code

**Recommended:**

- A code is emailed **only to an approved address**. For any other address
  nothing is sent, and the page is the same.
- **At most three codes an hour for one address.** After that nothing more is
  sent for the hour, and the page is still the same. With five tries a code,
  that is fifteen guesses an hour at most, and it stops the site being used to
  fill someone's inbox.
- To count them, a code's row is **kept for an hour after it was made**, not
  deleted the moment it is used or runs out. It still stops working at once.
  The description of that tab changes to say so. It is the only change to the
  accounts database in this step.

## 6. What switches on

**Recommended:** once all of this has passed its checks on the machine, the
apply page, the Sign in page and the admin screen go live together. The two
switches are **taken out, not flipped**, as settled. The top bar shows "Sign in"
and "Apply for an account" to everyone who is not signed in. The welcome page's
line "Accounts, and the way to apply for one" comes out.

**One thing to be sure of:** from then on anyone who finds the site can apply.
It is linked from nowhere else, and you decide every application.

## 7. What is held — nothing new

Nothing here adds to what is held about anyone. Two things the "what is held"
page will need to say when it is written, which is its own step: Resend keeps
its own record of emails sent, for a period Resend sets; and signing in sets one
cookie.

---

## The wording, in full

### The top bar

Not signed in:

> Sign in · Apply for an account

Signed in, you:

> Admin · Signed in as [name] · Sign out

Signed in, anyone else:

> Signed in as [name] · Sign out

### The admin screen

> ADMIN
>
> # Applications
>
> **Waiting**
>
> [Title Name] — [Position] — [address] — applied [16 September 2026]
> [Approve] [Refuse]
>
> *(when there are none)* No applications waiting.
>
> **Accounts**
>
> [Title Name] — [Position] — [address] — approved [16 September 2026]
> [Delete account]
>
> [Your own] — ... — approved [date] — you

Messages shown at the top after an action:

> Approved, and emailed.
>
> Refused, emailed, and deleted.
>
> Account deleted.
>
> The email could not be sent, so nothing has changed. Try again later.

### Confirming a refusal

> # Refuse this application?
>
> [Title Name], [address]
>
> They will be emailed that their application has not been approved, and it
> will be deleted. This cannot be undone.
>
> [Refuse] [Cancel]

### Confirming a deletion

> # Delete this account?
>
> [Title Name], [address]
>
> Their account, and every sign-in code and signed-in device attached to it,
> will be deleted. They will not be emailed. This cannot be undone.
>
> [Delete account] [Cancel]

### The code email

> **Subject:** Your sign-in code for legislativedata.org
>
> Your code is [123456].
>
> Enter it at https://legislativedata.org/sign-in/code. It works once, within
> 15 minutes.
>
> If you did not ask for this, you can ignore this email. Nobody can sign in
> without the code.

### The approval email

> **Subject:** Your application to legislativedata.org has been approved
>
> Your application for an account on legislativedata.org has been approved.
>
> To sign in, go to https://legislativedata.org/sign-in and enter this email
> address. A code will be sent to it.
>
> Nothing is published on the site yet.

### The refusal email

> **Subject:** Your application to legislativedata.org
>
> Your application for an account on legislativedata.org has not been approved,
> and it has been deleted from the site.
>
> If you have a question, reply to this email.
