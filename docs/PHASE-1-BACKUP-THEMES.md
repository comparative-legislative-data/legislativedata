# The backup, separated by theme — for the owner to settle

The owner's direction, 16 September: separate what is backed up by theme, even
at the cost of a more complicated backup. Their starting themes were the system,
the data, and the users. This is the proposal, then what was found on the
machine, then how it is built and tested.

**Settled by the owner and built, 16 September.** Questions 1 to 4 as
recommended; question 5 answered below. Question 4 turned out not to apply: the
first run replaced the only data copy that held the accounts, and it was pruned.
The record is `DECISIONS.md`, "The backup is separated by theme", and
`docs/ACCOUNTS-RUNBOOK.md`. This file goes when Phase 1 closes.

---

## Where it stands today

Every night the backup takes two copies. One is the machine's settings. The
other holds both databases together, the bills and the accounts, and is kept
for up to ten years. That second copy is the problem: the accounts can't be
kept a shorter time than the bills while they sit in the same copy.

**Nobody real is in the backup yet.** Only one copy holds the accounts, from
midday on 16 September, and the only person in it is the invented practice
applicant. Tonight's copy will be the first with your account in it.

## The proposal: three themes, each copied and aged on its own

| Theme | What it holds | Kept |
|---|---|---|
| **System** | What the machine needs to run: its settings, the web server's and the database's configuration, the scheduled jobs, and our own scripts on the machine | as now: up to ten years |
| **Data** | The working database of bills | as now: up to ten years |
| **Accounts** | The accounts database, and nothing else | 14 nightly copies and 4 weekly: nothing older than five weeks |

**Each database theme also carries the database logins**, so the bills or the
accounts can be restored on their own, without the other theme.

**"Any associated user info" is the accounts database alone.** I checked the
rest of the machine. The web server's log holds nothing about anyone. The
site's two keys, one for scrambling codes and one for sending email, aren't
about people and stay out of every backup, as settled. Resend's copy of each
email and the Gmail inbox are outside the machine.

**What stays out of every theme, deliberately:**
- the site's code, which is rebuilt from GitHub by the deploy;
- the web address's security certificate, which the web server fetches again by
  itself;
- the logs;
- the site's two keys;
- the password that opens the backup, which can't be kept inside the thing it
  opens.

## Five questions

### 1. One store with three labels, or three separate stores?

**Recommended: one store, three labels.** Each theme is its own copy with its own
label, and each label is aged by its own rule. Removing old accounts copies
touches only accounts copies. That is already how the system and data copies
work, every night since 10 September.

Three separate stores would each need their own password. The password is
already the one thing that, lost, makes the backup unreadable (question 5). Three
of them triples that.

What would change this: wanting someone to be able to open one theme and not
another.

### 2. Five weeks for the accounts

**Recommended: 14 nightly copies and 4 weekly.** A deleted account is gone from
the backups within five weeks, which is what the page will say.

Shorter is possible. The cost of short is that an accounts mistake noticed after
the last copy has gone can't be undone. With a handful of accounts, the person
can apply again.

### 3. A new database, not yet sorted into a theme

**Recommended: it goes into the data theme, and the session sanity check asks
that every database on the machine is named in a theme.** Nothing tells anyone
when the backup fails, so the job refusing an unsorted database would mean no
backup at all, silently. Putting it in data never loses anything. The risk is a
future database about people being kept ten years. The sanity check is what
catches that.

The published database, when it exists, is named as not backed up, as already
planned.

### 4. The copies taken before this is built

**Recommended: take the accounts out of any data copy that holds a real person
other than you. Leave them if you're the only one.** Today's copy holds only the
invented applicant, and tonight's will hold you. If anyone applies before this
is built, their details go into a copy that could be kept for months. Taking
them out changes old data copies, so it is rehearsed like everything else and
checked by a restore afterwards.

The alternative is to build this before anyone applies. That can't be promised,
because anyone can apply now.

### 5. Is there a copy of the backup's password anywhere but the machine?

**Answered, 16 September: there was not, and now there is.** The owner held the
storage box's login, which is a different password. The backup's own password
was copied to a file on the owner's Mac, never shown in the conversation, for
the owner to move somewhere safe. The copy was proved: it opens the backup, and
the same test refuses a wrong password.

What follows is the question as it was put.

**This one is a question, not a recommendation.** The password that opens the
backup is on the machine. The private notes call it the single point of
failure, and don't say whether a copy exists anywhere else. Every restore check
so far has run on the machine itself, where the password is.

If the machine were lost and there is no other copy, the backup couldn't be
opened by anyone. That would be true for all three themes. If you hold a copy,
say so and nothing changes. If not, keeping one somewhere safe that is yours is
the fix. It never goes in this repository or in the conversation.

---

## How it is built and tested

**The order.** The backup first, then the page, because the page's "five weeks"
isn't true until the backup is.

1. **Written** in `deploy/legdata-backup`, with the three themes. The version it
   replaces is kept on the machine as `legdata-backup.pre-themes.bak`.
2. **Rehearsed on the machine against a throwaway store** in `/tmp`, never the
   storage box, which other projects share. The rehearsal checks that:
   - the run makes three copies, labelled system, data and accounts;
   - the data copy contains no accounts, and the accounts copy no bills;
   - each database copy restores on its own into a scratch database, and its
     counts match;
   - **the five weeks is true.** Copies back-dated over three months are put
     into the throwaway store. The ageing rule is then asked what it would
     remove. No accounts copy older than five weeks may survive, and no data or
     system copy may go that doesn't go today;
   - **the check can fail.** A deliberately wrong version that puts the
     accounts into the data copy has to be caught.
3. **Installed, and run once by hand.** What to look at: the run succeeded;
   three new copies with the right labels; and the ageing rule, asked on the
   real store, removes nothing it wouldn't have removed yesterday.
4. **Restored from the storage box.** `tools/restore_check.sh` is changed to
   take each theme from its own copy, and run.
5. **Question 4, if it applies:** the accounts taken out of earlier data copies,
   then the restore check run again.
6. **The undo, rehearsed:** put the `.bak` back and run the job. The copies made
   under the new version are harmless, and can be removed by label.
7. **Written up:** the accounts runbook, the private notes, `STANDING.md`, and a
   decision entry.

**Timing.** The nightly run is around 02:30 UTC. None of this has to beat
tonight's run. The last data copy of September is kept a year, so the build
should be done well before 30 September. If anyone is in the accounts by then,
question 4 applies.

**Still open, and not part of this:** nothing tells anyone when the backup
fails. Three themes are three things that can fail silently. It stays with you,
as before.

---

## Working detail, for whoever builds it

- **Paths.** Today every dump goes to `/srv/legdata/postgres/`, and the data
  copy is a snapshot of `/srv/legdata`. The accounts dump moves to a directory
  outside `/srv/legdata`, snapshotted under the tag `accounts`. `globals.sql` is
  written to both. The manifest splits: data counts beside the data dump,
  accounts counts beside the accounts dump.
- **System** adds `/usr/local/sbin` to `/etc`.
- **Retention** stays `--group-by host,tags`. It becomes two calls: one for
  `system` and `data` with today's rule, and one for `accounts` with
  `--keep-daily 14 --keep-weekly 4`. A single call can't apply two rules.
- **Unsorted databases**: a list `ACCOUNTS_DATABASES="accounts"`. Anything not
  named there or in `NOT_BACKED_UP` goes to data. The existing refusal, if
  `legdata` is missing, stays.
- **The old accounts dump** in `/srv/legdata/postgres/` is removed by the first
  run, or it would be carried into every data copy. The script's existing
  "no longer exists" step has to be taught that it moved, not vanished.
- **Question 4's tool** is `restic rewrite --exclude /srv/legdata/postgres/accounts.dump`
  on data snapshots only, with `--dry-run` first. Whether it applies is read from
  each snapshot's manifest: counts only, `accounts person:`.
- **The SSH limit.** Send everything as one tar and run it in one connection.
- **The restic cache defect** (no `HOME` in the service) makes three snapshots
  re-read everything nightly. Still harmless at this size. Noted, not fixed
  here.
