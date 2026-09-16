# Wording: the top bar, the admin screen and the emails

Every word of the top bar, the admin screen and the three emails, as settled by
the owner on 16 September 2026. The site is built from this word for word.
**Change the wording here first**, with the date and who settled it, then the
site.

Why they work as they do is `DECISIONS.md`, 2026-09-16, "The admin screen, the
three emails, and everything switched on together". How they run and are
checked, and the sending key, is `ACCOUNTS-RUNBOOK.md`, "The admin screen and
email".

---

## The top bar

Not signed in:

> Privacy · Sign in · Apply for an account

Signed in, the owner:

> Privacy · Admin · Signed in as [name] · Sign out

Signed in, anyone else:

> Privacy · Signed in as [name] · Sign out

**Amended by the owner, 16 September**, with the privacy page: "Privacy" put
first in every version.

## The admin screen

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

## Confirming a refusal

> # Refuse this application?
>
> [Title Name], [address]
>
> They will be emailed that their application has not been approved, and it
> will be deleted. This cannot be undone.
>
> [Refuse] [Cancel]

## Confirming a deletion

> # Delete this account?
>
> [Title Name], [address]
>
> Their account, and every sign-in code and signed-in device attached to it,
> will be deleted. They will not be emailed. This cannot be undone.
>
> [Delete account] [Cancel]

## The emails

From `legislativedata.org <no-reply@legislativedata.org>`, replies to
`comparativelegislativedata@gmail.com`. Plain text.

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
