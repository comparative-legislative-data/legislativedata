# Standing

What holds regardless of which session is running: positions that have been
settled and are not to be re-argued, what has actually been verified rather than
assumed, what was deliberately left undone, the tools, and how to connect.

This is not a summary of the decisions. `DECISIONS.md` is the record, and it now
carries a contents page at its top. Nothing here restates an entry there; where
a thing is settled, this file says so in a line and points at the day it was
settled.

It exists because all of this used to live below the line in `STATE.md`, a file
whose whole discipline is "if it grows, cut". Standing material in a file that
gets cut every session is material waiting to be lost.

## What was deliberately left undone, and why

- **What access becomes after beta.** Whether a download stays behind a sign-in
  once beta ends, or the resource opens to anyone, is not answered and does not
  need to be. Nothing is built either way — Phase 1 puts no data on a page, so
  there is no download to put behind anything, and it is better answered with a
  working site and some researchers using it than in the abstract. Deferred by
  the owner 2026-09-15 and taken out of what closes Phase 1. **What reopens it,
  and it is not optional:** beta ending, and Phase 2 publishing to anyone who is
  not an approved beta user.

Written down because the expensive mistake is not doing a thing twice — it is
doing it again without knowing it was considered, weighed and parked. Each says
what would reopen it.

- **Time is counted in calendar days, not sitting days.** Recess makes calendar
  days misleading and the Parliament's rules count some intervals in sitting
  days, so sitting days are in one sense truer. They need a calendar of when the
  Parliament sat, which is its own body of work. No duration is stored, so
  adding the measure later changes nothing already recorded. Settled
  15 September. *What would reopen it:* the calendar existing, or a figure that
  cannot be read honestly in calendar days.

- **The financial resolution is not recorded as a stage.** It sits between
  Stages 1 and 2 and can hold a bill up, so it may explain Stage 1 to Stage 2
  intervals that look anomalous. Left out because the first slice's two
  questions did not require it. *What would reopen it:* Stage 1 to Stage 2
  figures that cannot be explained without it. A bill *falling* for want of one
  is a separate thing and is already recorded.

- **No member is attached to any bill.** There is a party column, settled on
  10 September with the rule that empty means not applicable or not known and
  that independent is a real value; it is empty for all 470 bills because the
  first slice's questions do not need a member. Two things bite when it is
  filled: bills introduced by a Law Officer carry no member at all, and Private
  Bills are brought by a promoter, so for both the empty cell is the right
  answer and not a gap to chase. *What would reopen it:* the slice that adds the
  member in charge, named in `PLAN.md` as the first candidate.

- **How a bill was handled is filled for 5 bills of 470.** Only the Session 6
  and 7 fact sheets state procedure, and only for emergency bills. This is a
  backfill candidate and has always been one — not a hole in the first slice. It
  needs a source that has not been agreed. M10 tells a reader the cell is filled
  only where a source says so. *What would reopen it:* agreeing that source.

- **Three columns are thin on purpose.** The Parliament's bill number, 66 of
  470, because Session 1's fact sheet gives none and Sessions 2 to 5 give them
  only for bills that did not become Acts. The title at introduction, 3 of 470,
  because the fact sheets state it only where they noted a change. The day a
  bill reached a stage, 2 of 1291, because no fact sheet states it and it is
  never inferred from the stage before. None is needed by the first slice's
  questions. *What would reopen any of them:* a source that carries it, or a
  published figure that needs it.

- **The Parliament's API returns truncated and duplicated records.** Found when
  the API was surveyed and never relied on since; the first slice was built from
  the fact sheets, the Official Report and the PhD dataset. Any extraction that
  goes back to the API has to handle both, and must not assume a record count is
  a bill count. *What would reopen it:* any work that reads the API.

- **Nothing records a second reading of a source that gives a different
  answer.** Provenance notes are rebuilt with their bill rather than kept
  forever, by the owner's decision of 11 September, so no history of readings is
  held. No such revision has happened yet. *What would reopen it:* the first
  real case, at which point how to record one is settled.

**Left for Phase 2, carried here when Phase 1 closed on 16 September.** None of
these is decided. The owner's position is that no decision about Phase 2 is made
at the end of Phase 1; the session that opens Phase 2 takes them up.

- **The test of the style against a real table of all the bills.** The house
  style decision of 15 September promises one page carrying every bill, "built
  locally and never deployed", before Phase 2. Since 16 September nothing runs on
  the owner's Mac, so it cannot be done as written. *What reopens it:* opening
  Phase 2, which has to say how it is done instead.
- **The colours of charts.** Not settled; waits for something to plot. The
  accent never touches data, so a chart palette never reuses it. *What reopens
  it:* the first chart.
- **Publishing the bills as files rather than a database the site reads.** Left
  open on 15 September (`DECISIONS.md`, "Three databases"), because it depends on
  what a reader's tools are. *What reopens it:* Phase 2 settling those tools.
- **The site's way into the published copy reads and never changes anything.**
  The briefing the three databases were decided from said this holds under every
  option, but no decision records it. *What reopens it:* building the published
  copy.
- **Heavy use of the site competes with loading data.** The site, the published
  copy and the working database share one machine, so a reader running something
  heavy and a session being loaded compete for it. At 14 MB of data it is not a
  real worry. *What reopens it:* the data growing, or the site being used.
- **A second accent, and the warm, cool and plain tones.** The essays site
  offers three tones of the same ramp; noted and not adopted. Nothing so far
  needs a second accent either. *What reopens either:* a page that needs it.
- **Buttons.** The house style says actions are small underlined text links
  rather than buttons, but the forms' submit buttons are filled buttons. Nothing
  records whether that is deliberate. The owner read every page on
  16 September and said it looks as settled. *What reopens it:* the style being
  looked at again.

**Left undone about the backup, carried here from its proposal:**

- **The backup has never been restored anywhere but on the machine.** Every
  restore check runs on the machine itself, where the backup's password is. The
  owner's copy of the password has been proved to open the backup, but getting
  the data back after losing the machine has not been rehearsed. *What reopens
  it:* the owner wanting that proved, or the machine being lost.

## The owner's standing positions, so they are not re-argued

- **The working database is never reachable from the public internet.** A floor,
  not a preference, and it constrains every infrastructure answer taken after
  it. Settled 2026-09-15; see `DECISIONS.md` for why it was taken before the
  hosting question rather than alongside it.

- **Nothing secret is held about a user, and nothing is held about what they
  read.** There are no passwords: signing in is a code by email, 15 minutes, one
  use, and a device stays signed in 30 days. Held: email, name, title, position,
  which state the application is in and when; a refused application is deleted
  once the person is told (2026-09-16). The web server log holds nothing about a
  visitor (2026-09-16).
  Never: a password, or any record of what a signed-in researcher looked at.
  Settled 2026-09-15.

- **Every page showing data carries the date of the data it was built from.**
  Settled 2026-09-15. Maximum transparency, and it is also what makes a stale
  published copy visible to everyone including us.

- **Three databases, and the site sees only one of them.** The working one
  (staging sheet, clean sheet, notes, provenance), a published one holding only
  what is published, and the accounts. Settled 2026-09-15. What holds whatever
  session is running: the site can never reach the working one; the published
  one is refreshed when we choose, not when a promotion happens; the working one
  and the accounts are backed up off-site and the published one is not, being
  rebuildable. Refreshing the published copy becomes a step in promotion, with
  its own rehearsal and written undo (the decision's own "what this costs").

- **The site runs on the machine the database is already on.** Settled
  2026-09-15. Two things follow and hold whatever session is running: no part of
  the site is written in a form only one company can run, because that is what
  keeps the undo cheap; and running the machine is ours — updates, certificate,
  web server, and the response when something stops.

- **The dataset is taken as it is, for now.** The error checker catches a stage
  date in an impossible order, as it did for the Civil Partnership Act, but not
  one that is wrong and still in order; checking Session 5's against the
  Parliament's bill pages is 87 pages. The owner's judgement, 14 September, is
  that the error rate is likely very low and tolerable until there is a
  methodology for the check, and that nothing waits on it. Do not propose it
  again unasked. What would reopen it: a methodology for checking, or errors
  turning up often enough to say the rate is not what was assumed.

- **The structure** is accepted as the price of academic-quality transparency.
  `ref_party` and `ref_procedure` have no data behind them, and are deliberate
  future-proofing. What does not relax: the owner can fully understand it.
- **A change to how data is coded is finished before anything moves on.** See
  `CLAUDE.md`, working rules. "Not yet built" is not a state a decision may be
  left in. This is not a race.
- **The owner judges what is acceptable to claim as academic quality.** The
  project's own rules are choices, not requirements of rigour. When one makes
  a simple thing awkward, propose relaxing it rather than designing around it.
- **Provenance notes may change, provided the owner clears the change.**
  Approving a rehearsed promotion clears the notes it rebuilds. Any other
  change to a note goes to the owner individually.
- **The dataset is proved at the end, not session by session.** The test that
  counts is whether the charts and tables built from all seven sessions match
  what the owner built by hand off the PhD. A closure test proves that a
  document's words reached the clean sheet unaltered and are traceable; it is
  not evidence the data is right. See `DECISIONS.md`, 2026-09-12.
- **A closure test inherits and is not re-argued.** It covers its own session
  and the corrections made for it, and says which of its items an outside change
  can move. Do not re-run a settled session's test for the sake of it.
- **The owner does not run database steps.** The session runs them and reports
  the results against what they should say. Step-by-step instructions are for
  what the owner does do: filling in spreadsheets, and reviewing in Postico.

**Before explaining anything about the database**, read
`docs/HOW-THE-DATABASE-WORKS.md` and the rules in `CLAUDE.md`. **Before
changing the clean data**, read `docs/PROMOTION-RUNBOOK.md`, and bring the
rehearsal, the check and the undo without being asked.

## What has been verified, not merely assumed

**2026-09-10:**
- The extractor gives byte-identical output on the Mac and on the VPS.
- The Session 1 load matches a fresh extraction in all 73 rows and every raw
  column, and every date re-parses.
- Session 1 reconciles in all twelve cells of its summary, plus both margins.
- Promotion is reversible: promoted, taken off and promoted again gave the same
  73 bills with the same numbers.
- The backup restores: fetched back from the storage box, restored into a
  scratch database, checked and dropped.

**2026-09-11:**
- **The extractor changes left Session 1 untouched** in every column.
  Session 2 changed only where intended, and Sessions 3–5 have nothing left
  over in their titles.
- **The Session 2 load is faithful.** A CSV in the old format and a wrong
  session number were both refused, and no line numbers were used up by
  rehearsals.
- **The new title checks work.** An SP Bill number and an introduced title,
  planted in a thrown-away rehearsal, were both caught.
- **All eleven Official Report citations were read** against the Parliament's
  page: motion, vote figures and date.
- **The provenance and route change** was rehearsed twice, and the real run
  matched.
  - The old notes came back identical.
  - The rules refuse a route on a passed bill, a Stage 1 rejection without a
    route, and a 9.14.18 route on a Government Bill.
- **Postico's user can read** the new list and the checker.
- **The stage-dates move changed nothing** (`db/033`), rehearsed twice and then
  run for real, with the figures in the runbook:
  - all 139 dates arrived unchanged, and nothing else on either session's
    staging lines changed;
  - Session 1 off and on matched the copy cell by cell;
  - eight planted mistakes were caught, an undated completed stage without a
    note was refused, the Official Report won over an agreeing PhD date, and
    an unreviewed stage date stopped promotion;
  - Session 2 reloaded from a fresh extraction gave its 66 passing dates
    identically;
  - Postico's user can read the new sheet, the gaps list, the checker and the
    list of stage names.
- **Session 2 matches its factsheet on the clean sheet** (`db/034`), rehearsed
  and then run for real: 53/18/9/1 by type; 66 passed, 5 withdrawn, 4 fell at
  dissolution, 6 rejected at Stage 1; 72 stage records; 12 notes.

**2026-09-12:**
- **The reader changes left Sessions 1 and 2 untouched**, byte for byte, so
  nothing on the clean sheet is affected. Sessions 3 and 4 reconcile in every
  cell of their own summary tables; Session 5 in every cell but its three bills
  awaiting Royal Assent. All five give identical output on the Mac and the VPS.
- **The Session 4 Interests of Members Act** was never in any extraction before
  today: the factsheet draws that row with no cell borders and the table finder
  lost it between the two pieces.
- **The order of precedence works**, tested on planted rows and thrown away.
  A disagreement is flagged by the checker from both sides; two agreeing rows
  promote the factsheet's and leave the PhD row marked not carried; a source
  with no settled place in the order makes promotion refuse and write nothing.
- **The order had never been exercised by the real data.** No stage of any bill
  has two rows, so nothing had ever competed for a place on the clean sheet.
- **All 62 of Session 3's factsheet bills pair one to one** with the PhD
  dataset's 62 Session 3 bills, on name or on introduction date.

**2026-09-13 is missing from this list.** Sessions 3 and 4 were promoted and
Session 4's dates loaded that day, and what was checked is in the runbook's log
and in the migrations, but nothing was written here. A later session should
bring it across; nothing depends on it.

**2026-09-14:**
- **Session 5's admission refuses in eight ways**, each provoked one at a time
  in a transaction that was thrown away, each naming its reason: a stage date
  from an uncovered source; a line with no outcome; a line never compared
  against the other sources; a date before its bill was introduced; a date after
  its bill ended; a stage dated before the stage before it; a dateless row that
  is not a bill ending where it stopped; a seventh such row when there are six;
  a line already marked promoted; and a line left at `held`, which is not swept
  into `accepted` and makes the count refuse.
- **A guard behind another guard is not tested.** Three of those refusals were
  reached only after the error checker had already refused the same breakage a
  step earlier. Run on their own against the broken row, one of them did not
  fire: the out-of-bill check measured a last stage date against itself on a
  bill that had not ended. That is the hole `db/077` closes.
- **Promotion is reversible with the dates on it.** Session 5 promoted, taken
  off — 302 bills, 828 stage records, 86 notes, staging lines unstamped and
  still accepted — and promoted again: 389, 1071 and 105, matching a copy taken
  before it came off cell by cell, with no unexpected differences.
- **Session 5 reconciles with its factsheet on the clean sheet**: 63/16/5/3 by
  type; 78 passed, 2 withdrawn, 3 rejected at Stage 1, 4 fell at dissolution;
  243 stage records; 19 notes. It is the first reconciliation that has to add
  two of the factsheet's tables — 75 Acts and 3 awaiting Royal Assent — to reach
  our `passed`.
- **The three bills stopped from Royal Assent behave as intended in the
  charts**: a duration to the end of Stage 3 and none to Royal Assent, and they
  are exactly the difference between the stage-3 and stage-3-to-assent counts,
  60 against 62 for government and 7 against 8 for Member's.

**2026-09-16:**
- **The website's login cannot open the working database.** Tried as the site's
  own machine account, and refused. The working database's own login still
  opens it.
- **The website's login cannot make anyone the owner or change an email**, and
  the check that says so was shown to fail when given those permissions.
- **The accounts are in the backup and come back from the storage box**: an
  invented practice person was restored from snapshot `c927a990`, approved, with
  the site's permissions intact; the working database restored beside it with
  every count matching.
- **The backup is separated by theme, and the accounts are kept five weeks.**
  Rehearsed against a throwaway store with 210 back-dated copies: the oldest
  accounts copy left was 17.6 days, and the system and data copies kept were
  exactly those the earlier rule keeps. A version putting the accounts in with
  the data was caught. Installed, run, and each theme restored from the storage
  box on its own. No data copy on the storage box holds the accounts.
- **The backup's password has a copy off the machine**, held by the owner, and
  proved to open the backup; the same test refused a wrong password.
- **The privacy page is live and true to the machine**: `tools/check_privacy.sh`
  15 of 15 against the live release, shown failing on a page that did not exist
  and on one changed word. The owner read it on the live site, 16 September.
- **Accounts work end to end on the live site**, tested by the owner by hand:
  apply, see it on the admin screen, approve (the email arrives with no code),
  ask for a code by email, sign in, a non-owner cannot see the admin screen,
  refuse (the email arrives, the application goes), delete an account (a code
  asked for afterwards is not sent), sign out. Before that, on the machine:
  apply 19/19, sign-in 44/44, admin 27/27, each check first made to fail.
- **The apply, sign-in and admin checks run with other people in the accounts,
  and prove they left them alone.** Rehearsed with two invented stand-ins, one
  waiting and one approved and signed in: apply 21/21, sign-in 45/45, admin
  28/28, the stand-ins unchanged in every cell. A copy altered to approve a
  stand-in failed on the check that everyone else is as they were.

## Reconciliation figures, per session

The gate compares our count against each factsheet's own summary table.

- **Session 1.** 51 Executive, 16 Member's, 3 Private, 3 Committee; 62 Acts, 3
  withdrawn, 8 fallen. The summary's column order is Executive, Member's,
  **Private, Committee**.
- **Session 2.** Page 8: Executive 53, Member's 18, Private 9, Committee 1;
  Acts 66 (53/3/9/1), withdrawn 5 (all Member's), fallen 10 (all Member's:
  4 at dissolution, 6 rejected at Stage 1). Same column order as Session 1.
- **Session 3.** Its summary has no Hybrid column and counts the Forth Crossing
  Bill under Executive. Its stated Executive 45 is our government 44 plus
  hybrid 1. Reconcile on `analysis_group`, not on `bill_type`.
- **Session 4.** Page 9: Government 67, Member's 13, Private 5, Committee 1;
  Acts 79 (67/6/5/1), withdrawn 1 (Member's), fallen 6 (all Member's: 5 rejected
  at Stage 1, 1 at dissolution). Its column heading is **Government**, not
  Executive: the Parliament's own styling changed inside this session. No Hybrid
  Bill, so `bill_type` and `analysis_group` give the same table.
- **Session 5.** Government 63, Member's 16, Private 5, Committee 3; Acts 75,
  awaiting Royal Assent 3, withdrawn 2, fallen 7 (all Member's: 3 rejected at
  Stage 1, 4 at dissolution). It is the first factsheet with a fourth table,
  "Bills awaiting Royal Assent", and the first where a reconciliation has to add
  two tables to reach our `passed`: 75 Acts plus those 3. No Hybrid Bill, so
  `bill_type` and `analysis_group` give the same table.
- **Session 6.** Read out of the factsheet on 2026-09-14, entry by entry, not
  taken from its summary. 83 entries are printed; 82 are counted in its own
  totals, the Legal Continuity Bill being in an excluded section that says so in
  its own words. Counted: awaiting Royal Assent 6 Government and 2 Member's;
  fallen 10, all Member's; withdrawn 1 Government and 3 Member's; Acts 55
  Government and 5 Member's. Column totals 62 Government and 20 Member's, 82.
  **Its printed summary has two cells wrong and its margins right**: awaiting
  Royal Assent reads 5 and 3, and Acts reads 56 and 4. The two errors cancel.
  Settled on 2026-09-14: reconcile every cell and write the disagreement down
  with the bills named. There are no Committee, Private or Hybrid Bills in
  Session 6 or 7, so `bill_type` and `analysis_group` give the same table.
- **Sessions 5 and 6** carry bills also counted in another session's totals.
  The factsheet totals are right for the factsheet and wrong for a count of
  distinct bills; see M6. This has not bitten yet: Session 5 reconciles against
  its own factsheet, and the double count appears only when Session 6 is loaded
  beside it.
- **Session 7.** Its grand total cell reads 0 where every margin reads 2. Trust
  the margins; the extracted table grid confirms that is the document.

A reconciliation proves no line was lost. It says nothing about what is inside
a line: Session 2 reconciled exactly while fifteen titles still carried their
SP Bill number.

**When charting:** a chart of outcome by bill type must say whether it grouped
on `bill_type` or `analysis_group`. They differ for the Forth Crossing Bill (44
or 45 government bills in Session 3). That is methodology note M4, which the
website has to surface.

## Tools

- **`tools/load_session.sql`** puts a session's extracted CSV on the staging
  sheets: its lines, and its passing dates on the stage-dates sheet.
- **`tools/promote_session.sql`** copies a session to the clean sheet, and
  **`tools/rollback_promotion.sql`** takes it off again.
  - All three take `-v session=` and `-v save=`, with no default for either.
  - `save=false` does the whole job and throws it away.
- **`tools/take_copy.sql`** and **`tools/compare_with_copy.sql`** copy the
  staging and clean sheets inside the database before a change, and compare
  cell by cell after. Both take `-v copy=`.
- **`tools/strip_for_rehearsal.py`** prepares migrations and scripts to be
  dress-rehearsed together inside one transaction that is thrown away.
- **`tools/check_stage_entry.sql`** reports on the stage dates the owner has
  typed in: every row waiting for review, beside its bill, and the checker's
  findings. Changes nothing.
- **`tools/extract_factsheet.py`** reads the ruled-table factsheets (Sessions
  1–5). Its pinned environment is in `tools/requirements.txt`.
- **`tools/make_data_dictionary.py`** regenerates `docs/DATA-DICTIONARY.md`, and
  refuses to run if anything lacks a description. Since 2026-09-16 it describes
  the accounts database too, reading its descriptions and never a row.
- **`tools/restore_check.sh`** fetches the newest copy of each backup theme from
  the storage box, restores the data and the accounts each from its own copy
  into scratch databases, prints counts, and cleans up after itself. Procedure
  in `docs/ACCOUNTS-RUNBOOK.md`.
- **`deploy/legdata-backup`** is the copy of record of the nightly backup
  script, separated by theme since 2026-09-16: system, data, accounts. It takes
  no arguments; whatever it is passed, it runs the whole job.
- **`tools/rehearse_backup_themes.sh`** rehearses a change to the backup against
  a throwaway store on the machine, before it is installed.
- **`docs/PROMOTION-RUNBOOK.md`** is the procedure for loading and promoting,
  with a record of each run.
- **`docs/FACTSHEET-SURVEY.md`** is the survey of all seven factsheets.

## Housekeeping, small and known

- **Fourteen safety copies are on the VPS**, one before each change to data or
  rules: six from 12 September (`-042_`, `-044_`, `-045_`, `-046_`, `-047_`,
  `-051_`), five from 13 September (`-057_`, `-059_`, `-060_`, `-065_`, `-068_`
  and `-s3-dates_`), and two from 14 September (`-s5-dates_` and
  `-s5-promotion_`). **The eleven from 12 and 13 September can now be deleted**:
  the nightly backup ran clean at 02:53 on 14 September, which is after all of
  them. The two from 14 September are not yet covered; the next run covers them.
  Proposed, not done — it is the owner's to say.
- **No copy of the sheets is held inside the database.**
  `copy_before_s5_promotion` and `copy_after_s5_promotion` were compared and
  dropped on 14 September. Take a fresh one with `tools/take_copy.sql` before
  the next change to data already held.
- **`db/066` has the same filename as `db/063`**, `session_4_review.sql`,
  although one is the review and the other the admission. Recorded here so the
  sanity check stops rediscovering it: it is a gap in the record, not in the
  data, and renaming an applied migration is not obviously worth doing. If it is
  ever tidied, it is `db/066` that should change.
- **`db/037` stays, doing nothing.** It sets day-first dates for Postico's
  login, and Postico formats dates itself, so nothing changed on screen. The
  owner judged it harmless. One line in the migration undoes it if wanted.
- **The two blank PhD spreadsheets are deleted.** Dates come from the owner's
  own dataset through `tools/phd_stage_dates.py`; the templates were never used.
- **The backup service runs with no `HOME` or `XDG_CACHE_HOME`**, so restic
  keeps no cache and re-reads everything in scope every night. That is harmless
  at this size, but will not stay so. One `Environment=` line in the unit file
  fixes it.
- **The Justice 2 Committee's own record** of its decision on the Civil Appeals
  (Scotland) Bill has not been found. Our view of the limb rests on the chamber
  debate. Nothing waits on it. The older committee pages redirect to the
  National Records of Scotland web archive, which blocks automated access.
- **Asking whether a rule exists means reading three catalogues.**
  `pg_constraint` does not list plain indexes; read `pg_indexes` and
  `pg_trigger` too. While a copy schema exists, filter every catalogue
  question to the `public` schema.
- **The extraction environment on the Mac** is a throwaway virtual environment
  built from `tools/requirements.txt` in the session scratchpad. The VPS copy at
  `/opt/legdata/venv` is the standing one.

## Connecting to the database

**Postico** (the entry client) is configured already. It opens its own tunnel
inside the application, on a port it picks per connection. There is no shared
listener, and nothing outside Postico can use it. (An old version of this file
described a shared tunnel on port 15432. It does not exist.)

**From a shell, or for any scripted work,** go through the connector script.
It holds the address, port, user and key, and keeps its own known-hosts file.
It is not in this repository.

    ~/.claude/legdata-vps 'whoami'
    ~/.claude/legdata-vps 'sudo -u postgres psql -d legdata -c "SELECT ..."'
    ~/.claude/legdata-vps --scp local/file /remote/path

The login account has passwordless sudo, and `sudo -u postgres psql` connects by peer
authentication, so no database password is stored on the Mac. Migrations are
applied this way.

**Dress-rehearsing a sequence of migrations and scripts:**
1. Strip each file's own `BEGIN;`, `COMMIT;` and closing `\if :save … \endif`
   block: `python3 tools/strip_for_rehearsal.py OUTDIR FILE…`.
2. Include them in order inside one `BEGIN … ROLLBACK`, with `\set session N`.
3. A script that makes temporary tables can run only once per rehearsal; test
   a second run in a separate rehearsal.

That is how `db/030`–`db/033` and the Session 1 re-promotions were rehearsed.
Send the files as one bundle (`COPYFILE_DISABLE=1 tar czf …`), which keeps to
one connection.

**Do not use `legislativedata-vps` or `legislativedata-data` in
`~/.ssh/config`.** They are leftovers from the old estate and point at machines that are not this
project's. Which machine is, is in the private notes outside this repository.

**The SSH rate limit bites you, not only attackers.** The firewall refuses a
seventh connection inside 30 seconds (`ufw limit`), with `Connection refused`
until the window passes. An upload followed at once by a command is two. Batch
work into few connections. Measured 2026-09-16; the "about a dozen" written here
before was generous.

**The accounts database** is reached the same way, as
`sudo -u postgres psql -d accounts`. Its rows are real people: look at counts,
never at rows, and never bring a row into the conversation. The website's own
login is `sudo -u legsite psql -d accounts`, and is what to use to check what
the site can and cannot do.
