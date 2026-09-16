# Your account, your way in, signing in and out — for the owner to settle

The next build step, put before it is built. It covers your own account, your
way in that doesn't need email, and the parts of signing in that way in needs:
the page where a code is typed, being signed in, and signing out. **Sending a
code by email comes after, as its own step.** Where you agree with a
recommendation, "yes" is enough.

This file goes when Phase 1 closes, like the other `PHASE-1-` files.

---

## 1. Your account's details — needs something from you, not in the conversation

Your account is made on the machine, not applied for. It needs your email
address, name, title and position.

**These are not in the private notes.** The 15 September decision said your
address "lives in the private notes"; it isn't there. The notes hold one
address, and that's the old alerts inbox. **Please add the four details to
`~/.claude/legdata-vps-notes.md` yourself**, under a heading such as "The
owner's account". I'll read them from there and they never go into this
conversation, a commit or a document.

## 2. Your way in without email

**Recommended: the machine makes the code instead of emailing it, and you type
it on the same page everyone else uses.**

When you need to get in without email, a session runs one command on the
machine. It makes a code for your account (it can make one for no other
account) and shows it. The code works once, within 15 minutes, on the ordinary
"enter your code" page, together with your address.

Why this way: there is nothing on the site that only you can use, so there is no
back door to find. It is the same code, the same page and the same checks as
everyone else's. The only difference is how the code reaches you.

What it costs: the code appears in the conversation. It dies after 15 minutes
or one use, and does nothing without your address.

## 3. What a code looks like, and guessing

**Recommended: six digits. Five wrong tries and that code stops working.**

Six digits is what people are used to typing from an email. Guessing one in five
tries is a one-in-200,000 chance. Stopping someone asking for code after code,
to get more tries, belongs with the email step, and will be put to you then.

## 4. One new thing on the machine: a key for scrambling codes

**Recommended: yes.** The database description promises that "reading this
database does not let anyone sign in". With six digits, that is only true if the
scramble uses a key kept outside the database: without one, a code could be
worked out from the database in under a second.

The key is a file on the machine that only the site can read. It is not in this
repository and not in the backup. If it is lost, the only effect is that codes
issued in the last 15 minutes stop working: a new key is made, and nobody has to
do anything.

## 5. Being signed in

**Recommended:**

- Signing in puts a marker in the browser, the "marker on the device" settled on
  15 September. It is the only cookie the site sets, and only on signing in. It
  lasts 30 days, can't be read by the page's scripts, and is only sent over
  https.
- While signed in, the top bar shows who you are and a way to sign out.
- Signing out removes this device's marker and nothing else. Signing out
  everywhere stays parked, as settled on 15 September.
- Nothing about what you look at while signed in is recorded, as settled.

## 6. What is live after this step

**Recommended:** the "enter your code" page and signing out go live, which is
enough for your way in. **The "send me a code" page stays off until email is
built**, and nothing links to signing in until then.

This is **the first point you can test on the live site**: have a session make
you a code, sign in, see your name in the top bar, sign out. The admin screen
follows, and then the apply page gets switched on.

## 7. The sentence left over from the apply page

The page after applying says "If that address has applied before, nothing has
changed". Since a refused application is deleted, someone refused who applies
again does make a new application.

**Proposed:** "If that address is already waiting for a decision or has an
account, nothing has changed and you do not need to apply again."

---

## The wording, in full

### Send me a code — built, but off until email

> ACCOUNTS
>
> # Sign in
>
> There are no passwords. Enter your email address and a code will be sent to
> it. The code works once, within 15 minutes.
>
> **Email address**
>
> [Send me a code]

### Enter your code

> ACCOUNTS
>
> # Enter your code
>
> If that address has an account, a code has been sent to it. It works once,
> within 15 minutes.
>
> **Email address**
>
> **Code**
> Six digits.
>
> [Sign in]
>
> If nothing has arrived, check your junk folder.

### When a code doesn't work

Shown above the form. The same words whether the address has no account, the
code is wrong, it has run out, it has been used, or it has had five wrong tries,
so that the page gives nothing away.

> That code didn't work. Codes work once, within 15 minutes, and stop after five
> wrong tries.

### The top bar, while signed in

> Signed in as [name] · Sign out

### After signing out

> # Signed out
>
> You are signed out on this device. Anywhere else you are signed in stays
> signed in.
