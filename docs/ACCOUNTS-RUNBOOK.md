# Accounts runbook

How the accounts database was made, how it is checked, how it is backed up and
proved restorable, and how it is undone. For what each column holds, see the
last part of `docs/DATA-DICTIONARY.md`. For why it exists, `DECISIONS.md`,
2026-09-15, "Three databases" and "No passwords; what is held about a user, in
full".

**The rule that governs every step here:** its rows are real people. No row,
email or name from it goes into a commit, a document, a test or a conversation.
Every check below prints counts, or looks for the invented practice person, and
nothing else.

## What exists

- **The `accounts` database**, beside `legdata` on the same PostgreSQL. Three
  tabs: `person`, `sign_in_code`, `signed_in_device`. Made by
  `db/accounts/001_the_accounts.sql` on 2026-09-16.
- **The `legsite` login.** The website runs as the machine account `legsite`,
  and this is its database login of the same name. It has no password and works
  only from that machine account. It can open `accounts` and **cannot open
  `legdata`**: PostgreSQL's default of letting any login open any database was
  taken away from `legdata` by the same migration.
- **What `legsite` may do**, column by column: read everything; add a person
  (email, name, title, position, and nothing else); change a person's state and
  decision date; delete a person; add, change and remove codes and devices. It
  may not set `is_owner` or change an email, and it cannot make a tab of its own.
- **The backup** takes it every night. See below.
- **The site connects to it** from 16 September 2026, through `site/accounts.py`,
  as `legsite` over the local socket: `dbname=accounts` and nothing else, no
  password, no secret anywhere. Its health check asks the database for no row
  from `person` — which proves the permission without reading anyone — and says
  `503` if that fails. Proved inside the live service's own sandbox, where the
  same login was still refused the working database.

## Making it, and the rehearsal that came first

Files go to the machine and run from there. **Mind the SSH rate limit:** the
firewall refuses a seventh connection inside 30 seconds, so send files and run
them in as few connections as possible, and space them out.

    ~/.claude/legdata-vps --scp db/accounts/001_the_accounts.sql /tmp/accounts/001_the_accounts.sql
    # …and 001_undo.sql, 001_check_as_the_site.sql; chmod 644 them

**1. Rehearse under another name.**

    sudo -u postgres psql -X -d postgres -v accounts_db=accounts_rehearsal -f 001_the_accounts.sql

The last line before `COMMIT` must be the notice *"The accounts are made: three
tabs, every column described, empty…"*. If anything fails it stops and says why.

**2. Check it as the website.**

    sudo -u legsite psql -X -d legdata -c 'select 1'       # must be refused
    sudo -u legsite psql -X -d accounts_rehearsal -f 001_check_as_the_site.sql

The first must say *permission denied for database "legdata"*. The second must
print `PASS 1` to `PASS 11` and *All 11 pass*. The script refuses to run if
anyone other than the invented practice person is in the database.

**3. Prove the check can fail.** Give the site a permission it must not have,
run the check, and see it fail; then take the permission back.

    sudo -u postgres psql -d accounts_rehearsal -c 'grant update (is_owner, email) on person to legsite'
    # run the check: must print FAIL 2 and FAIL 3 and stop
    sudo -u postgres psql -d accounts_rehearsal -c 'revoke update (is_owner, email) on person from legsite'

**4. Undo the rehearsal, and compare.** Before step 1, record the list of
databases with who may open each, the list of logins, and the dataset's counts
(bills, stages, provenance notes, methodology notes, staging lines, error
checker, gaps list). Then:

    sudo -u postgres psql -X -d postgres -v accounts_db=accounts_rehearsal -f 001_undo.sql

and record the same three things again. The database and the login must be
gone and the counts identical. **One difference is expected:** `legdata`'s
list of who may open it goes from PostgreSQL's unwritten default to the same
thing written out (`{legdata=CTc/legdata,=Tc/legdata}`). It behaves identically.
Running the undo a second time must do no harm.

**5. For real**, with `accounts_db=accounts`, then step 2 against `accounts`
with `-v practice=keep`, which leaves the invented practice person in place,
approved, for the backup rehearsal.

### What happened on 2026-09-16

All five steps as above. The check script's first version failed because it
made a scratch tab and the site is not allowed to, which is correct; it was
rewritten to need none. Step 3 first showed that a wrong permission stopped the
check with an unrelated refusal rather than a clean FAIL, and item 2 was changed
so that only a refusal on permission counts as a pass. Then it failed cleanly
on items 2 and 3, refused when a second person was present, and passed 11 of 11
when put right. The undo was run twice. The real database passed 11 of 11.

## The backup

The copy of record of the script is `deploy/legdata-backup`. It is installed at
`/usr/local/sbin/legdata-backup`, root only, and run nightly at 02:30 UTC by
`legdata-backup.timer`. **It takes no arguments and runs the whole job whatever
it is passed.**

**Since 2026-09-16 it is separated by theme**, three snapshots a night, each
aged by its own rule. The owner's direction; `DECISIONS.md`, 2026-09-16, "The
backup is separated by theme".

| Tag | Holds | Kept |
|---|---|---|
| `system` | `/etc` and `/usr/local/sbin` | 14 daily, 8 weekly, 12 monthly, 10 yearly |
| `data` | `/srv/legdata/postgres/`: `legdata.dump`, `globals.sql`, `manifest.txt` | the same |
| `accounts` | `/srv/legdata-accounts/postgres/`: `accounts.dump`, `globals.sql`, `manifest.txt` | 14 daily, 4 weekly: nothing older than five weeks |

**Every database on the machine is backed up** unless named in `NOT_BACKED_UP`
at the top of the script (today only `postgres`, PostgreSQL's own empty one). A
database named in `ACCOUNTS_DATABASES` (today only `accounts`) goes to the
accounts theme; **anything else goes to the data theme**, and the job says so in
its log. A new database that holds people must be named in `ACCOUNTS_DATABASES`
in the same change that makes it, or it is kept ten years. The session sanity
check asks this. **When the published database is made, add its name to
`NOT_BACKED_UP`**, since it is rebuilt from the working one rather than restored.

Each `manifest.txt` carries counts for its own theme's databases: for the
accounts, how many people, how many approved, how many codes, how many devices.
Never a name. Each theme carries `globals.sql`, the logins, so either database
restores without the other theme.

**Left out of every theme, on purpose:** the site's code (the deploy rebuilds
it), Caddy's certificate, the logs, the two keys in `/var/lib/legislativedata/`,
and the backup's own password, of which the owner holds a proved copy.

**Nothing tells anyone if the backup fails.** A failed run shows only as a
failed unit on the machine (`systemctl status legdata-backup.service`). This is
recorded in `STATE.md` for the owner.

### Changing the script

1. Edit `deploy/legdata-backup` and commit it.
2. **Rehearse it** against a throwaway store: `tools/rehearse_backup_themes.sh`,
   sent with the new script in one tar and run as root with the script's path.
   It must end `== 0 failed`. It checks what each theme's copy holds, that each
   database restores alone, the ageing on back-dated copies, that a broken
   version is caught, and that the installed version still runs (the undo). If
   the change is to something it does not check, extend it first.
3. Send it to the machine, keep the old one, install:

       sudo cp -p /usr/local/sbin/legdata-backup /usr/local/sbin/legdata-backup.pre-<what>.bak
       sudo install -m 700 -o root -g root /tmp/<dir>/legdata-backup /usr/local/sbin/legdata-backup

4. Run the real job and look at what it did:

       sudo systemctl start legdata-backup.service
       systemctl show legdata-backup.service -p Result        # Result=success
       sudo journalctl -u legdata-backup.service --since -20min -o cat | grep -E 'legdata-backup:|saved|no errors'
       sudo cat /srv/legdata/postgres/manifest.txt /srv/legdata-accounts/postgres/manifest.txt

   Three `snapshot … saved` lines, `no errors were found`, no line saying a
   database is not sorted into a theme, and manifests whose counts match
   `STATE.md`.

5. **Restore from the storage box and check** — below. A job that exits cleanly
   is not evidence the backup can be read back.

**The undo** is putting the `.bak` back with the same `install` line, then
running step 4 again. Copies made under the version being undone are harmless;
they age out, or can be forgotten by tag.

**2026-09-16, the themes.** Rehearsed, 0 failed: the oldest accounts copy left
after ageing 210 back-dated copies was 17.6 days; the system and data copies
kept were exactly those today's rule keeps, 42 of 42; the broken version (the
accounts put in with the data) was caught four ways. Installed with
`legdata-backup.pre-themes.bak` kept, run by hand: snapshots `28a16463` system,
`be59a66c` data, `adc2c406` accounts, and the old `accounts.dump` removed from
`/srv/legdata/postgres/`. The restore check passed. Afterwards every data
snapshot on the storage box was listed and none holds `accounts.dump`: the one
that did (`c927a990`, the invented practice person only) was replaced as that
day's copy by the run, and pruned.

### The restore check

`tools/restore_check.sh`. Send it to the machine and run as root:

    sudo bash /tmp/<dir>/restore_check.sh

It fetches the newest copy of each theme from the storage box. It lists the
system copy's files, checking the Caddyfile and the backup script are there. It
restores the data copy into `legdata_restore_check` and the accounts copy into
`accounts_restore_check`, each from its own copy alone, and prints: that neither
copy holds the other theme's database; whether the site's login is among the
accounts copy's saved logins; the practice person (during a rehearsal only); how
many people and how many approved; that the site's permissions came back; how
many columns are described; the dataset's counts; and both manifests. It then
drops both scratch databases and deletes the restored files, **including when it
fails part way**. Afterwards, check that the list of databases is back to
`accounts, legdata, postgres, template0, template1` and that `/tmp/restore-check`
does not exist.

**2026-09-16, before the themes:** snapshot `c927a990`. The practice person
present and approved, one person, the site's login saved, its permissions
intact, 21 of 21 columns described; 470 bills, 1291 stages, 186 provenance
notes, 13 methodology notes, 474 staging lines, checker 0, gaps 0. Cleaned up.
The practice person was then deleted from the live database.

**2026-09-16, the themes:** system `28a16463` (both files present), data
`be59a66c`, accounts `adc2c406`; neither copy holds the other's database; the
site's login saved; one person, approved, the site's permissions intact, 21 of
21 columns described; 470 bills, 1291 stages, 186 provenance notes, 13 notes,
474 lines, checker 0, gaps 0. Cleaned up, databases list as it should be.

## The apply page, and its check

`site/app.py`, `/apply`. What it does and every word it says are
`docs/PHASE-1-APPLY.md`. It was off on the live site until the admin screen
existed, and the switch was then taken out.

**The check is `tools/check_apply.sh`**, run as root on the machine against a
staged release. It starts that release twice as `legsite`, on ports 8002 and
8003, once reaching the accounts and once pointed at a database that does not
exist, and sends applications with an invented person at `example.org`. It
refuses to start unless the accounts are empty, prints only counts and yes/no
answers about the invented person, and deletes them and stops both copies
whether it passes or fails.

Send it and run it **in one connection**, because of the SSH limit:

    ~/.claude/legdata-vps 'cat > /tmp/check_apply.sh && sudo bash /tmp/check_apply.sh /srv/site/releases/<release>' < tools/check_apply.sh

It must print `All 19 pass` and `people left: 0`. Run with `sudo BREAK=1 bash …`
it must fail at item 1, which shows it can fail.

**Once anyone real has applied, it refuses to run**, by design. It will need an
invented-person-only way of checking before then, or retiring.

**2026-09-16**, on `2026-09-16T12-47-30Z`. The first run meant to fail did fail,
but because the two copies never started: the site's login cannot read the
folder the script was started from. Fixed by starting from inside the release;
then it failed at item 1 with `404`, as it should. Then all 20 passed and the
accounts were empty afterwards.

## Signing in, and the owner's way in

What it does and every word it says are `docs/PHASE-1-SIGN-IN.md`. Live: the
page where a code is typed (`/sign-in/code`), signing out, and the signed-out
page, and `/sign-in`, which emails a code.

**The key.** `/var/lib/legislativedata/code-key`, 64 hex characters, `root:legsite`,
mode 640, in a folder only root and the site can open. Codes are kept as a
scramble made with it and the person's number. It is **not in the backup**, on
purpose: no theme of the backup takes `/var/lib/legislativedata/`. If it is lost, codes made
in the last 15 minutes stop working; make a new one by deleting the file and
running `deploy/install_sign_in.sh`, which makes a key only where there is none.
The site's health check says `503` if it cannot read the key, so a deploy
without one does not go live.

**The owner's account** was made on 2026-09-16 by `postgres`, with the SQL sent
on standard input so the details are not in the machine's record of commands:
`is_owner`, `approved`, decided the moment it was made. Its details are in the
accounts database and nowhere in this repository.

**The owner's way in:**

    ~/.claude/legdata-vps 'sudo /usr/local/sbin/legdata-owner-code'

prints a six-digit code and the time it stops working, and nothing about the
owner. The owner types it at `https://legislativedata.org/sign-in/code` with
their address. It replaces any code the owner already has; it can make a code
for the owner's account and no other; it refuses if there is no owner. Its copy
of record is `deploy/legdata-owner-code`, installed by `deploy/install_sign_in.sh`.

**Tidying.** Codes made more than an hour ago, and devices past 30 days, are
deleted whenever anyone asks for or tries a code, not on a timer. A used code is
marked used and its row stays for the hour, so that it is counted.

**The check is `tools/check_sign_in.sh`**, run as root against a staged release,
in one connection:

    ~/.claude/legdata-vps 'cat > /tmp/check_sign_in.sh && sudo bash /tmp/check_sign_in.sh /srv/site/releases/<release>' < tools/check_sign_in.sh

It uses invented people at Resend's test addresses and, if the owner's account
exists, the owner's own command and code. It refuses to start if anyone but the
owner is in the accounts, or the owner has a code still working. It prints counts and yes/no
answers only, never a code or the owner's address, and deletes everything it
made whether it passes or fails. With `BREAK=1` it must fail at item 7.

## The admin screen and email

What they do and every word they say are `docs/PHASE-1-ADMIN-AND-EMAIL.md`.

**The sending key.** `/var/lib/legislativedata/resend-key`, beside the code key,
`root:legsite`, mode 640, not in the backup. A Resend key with sending access
only, for `legislativedata.org`. Put there by `deploy/install_email_key.sh` from
`~/.claude/legdata-resend-send` on the Mac, over standard input, never printed;
running it again replaces the key, which is how one is rotated. The same script
checks, inside the live service's restrictions, that the site can reach Resend.
The full-access key in `~/.claude/legdata-resend` is not for the machine. The
site's health check says `503` if it cannot read the sending key.

**When an email fails** the site logs `email not sent` and the reason, never an
address:

    ~/.claude/legdata-vps 'sudo journalctl -u legislativedata --since today -o cat | grep "email not sent"'

**The description change**, `db/accounts/002_codes_are_counted_and_refusals_go.sql`:
rehearse with `-v end=ROLLBACK`, apply with `-v end=COMMIT`, undo with
`002_undo.sql`. It changes two descriptions and nothing else. Then regenerate the
data dictionary.

**The checks.** `tools/check_admin.sh`, run like the others, uses invented
people at Resend's test addresses (`delivered+...@resend.dev`, accepted and
delivered nowhere) and a second copy with a key Resend refuses, to show that a
failed email changes nothing. It signs the owner in on its own copies with a
marker it makes and removes. `tools/check_sign_in.sh` now also covers asking for
a code and the three-an-hour limit, and no longer refuses while the owner is
signed in somewhere; it refuses only while the owner has a code still working.
All three checks refuse to run once anyone but the owner is in the accounts.
**That is the day they need a different shape**, and it is close: the first real
application stops all three.

**2026-09-16**, on `2026-09-16T15-01-28Z`. Each check run with `BREAK=1` first
and failed where designed. Then apply 19 of 19 and sign-in 44 of 44. The admin
check failed at item 13, and the fault was the check's: the confirmation heading
also appears in the page's title, so it was found twice. Fixed to look at the
heading alone, the same fix made for the deletion page before it was reached;
then 27 of 27. Resend reported every test email delivered. `db/accounts/002`
applied, the data dictionary regenerated with those two descriptions and nothing
else changed, and deployed as `2026-09-16T15-02-54Z`: every page as expected from
outside, `/admin` "not found" to anyone but the owner, one person (the owner),
no codes, no devices, no errors, no address in the access log. The deploy's own
step 5 was refused by the SSH limit after the switch; its checks were made from
outside and in a later connection instead.

## The undo, once there are real people

`db/accounts/001_undo.sql` drops the database. **Once anyone real has applied,
that is not an undo, it is the deletion of their data**, and it is not run
without the owner saying so in terms. Recovering from a damaged accounts
database is a restore, as above, into `accounts` itself.
