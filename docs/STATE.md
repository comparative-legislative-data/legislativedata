# State

Updated: 2026-09-12

## Where we've got to

The first piece of work, across all seven sessions:

1. **What happened to each bill**, by bill type.
2. **How long each stage took**, by bill type and session. The main interest is
   introduction to the end of Stage 3.

Each session goes through the same steps. Its factsheet is read onto the
staging sheets, you review it, and it is copied onto the clean sheet. Stage 1
and 2 dates are added from your PhD.

| Session | Read in | Reviewed | On clean sheet | Stage 1 & 2 dates |
|---|---|---|---|---|
| 1 | 73 bills | yes | yes | yes; not closed |
| 2 | 81 bills | yes | yes | yes; not closed |
| 3–5 | reads in full | no | no | no |
| 6–7 | needs a prose reader | no | no | no |

For Sessions 1 and 2 we can answer question 1, and the time from introduction
to passing. Time per stage waits for the Stage 1 and 2 dates.

## What has been done

- **10 September.** Built the database, surveyed all seven factsheets, and put
  Session 1 on the clean sheet.
- **11 September.** Read Session 2 in and put it on the clean sheet; recorded
  how each Stage 1 rejection came about; settled stage dates in full, and
  loaded your own dates for all 154 bills.
- **12 September, earlier.** Fixed the reader, which was losing whole rows where
  a table runs over a page, so Sessions 3, 4 and 5 now read in full. Settled the
  thirteen dates where your sheet and the factsheet disagreed; five were wrong
  and are corrected, all thirteen carry your citation. Named each source for
  what it is, and made the comparison between sources a gate every session must
  pass. Corrected your working dataset's nine cells, after which the two sources
  agree completely for both sessions.

**12 September, this session. The day each session ended is now in the data.**
- **The closure test for Sessions 1 and 2 was run.** All sixteen mechanical
  checks matched, and all five outside the script. Your seven sign-offs are
  still to come — see "Now".
- **It found one real fault, in the checking, not the data.** Taking a session
  off and putting it back gives identical data, but the tool that checks that
  said otherwise: it followed a note by the stage record's number, and those are
  reissued. Fixed, and proved to still catch four planted changes.
- **The day each session ended was deciding how seven bills are coded, from a
  command line, recorded nowhere.** All seven sessions now carry their dates,
  from the SPICe dates factsheet you supplied, agreeing to the day with the
  Parliament's API and with each legislation factsheet. The checker now requires
  a bill said to have run out of time to have concluded on that day. What a
  reader is told changed with it: M7 states the dates it reasons from, and M8
  now says that your dataset and the factsheets are independent and agree.

## Now: the final checks, and they are not this session's to make

This session did the work above, so it does not mark it. **Your decision, and
the same rule that produced the closure test.** The next session's first task,
before anything about Session 3:

1. **Re-run `tools/closure_check_sessions_1_2.sql`** against the expected
   answers in `docs/CLOSURE-TESTS.md`, which were corrected for the renamed
   source and the thirteen new provenance notes. This session re-ran them and
   they matched; that is not the same as being checked.
2. **Re-run items 17 to 21**, which are outside the script.
3. **Put the eight sign-offs to the owner**, one at a time. The first was given
   on 12 September: the counts of what happened to each bill are as expected.
   Seven remain.
4. **Then the conversation about how much confidence the clean sheet has
   earned**, which the owner asked for and which nothing should pre-empt.

Sessions 1 and 2 are **not closed** until that has happened, and Session 3 is
not started.

## Only after all of that: Session 3

Not started, and not to be started. Session 3 reads in full and reconciles in
every cell, and its three expected differences with the dataset are named in
`DECISIONS.md`, 2026-09-12.

## After that, in order

1. Bills carried over between sessions: before Session 5 is loaded.
2. The double-count guard: before Session 6 is promoted.
3. A prose reader for Sessions 6 and 7.
4. Each session's start and end dates.
5. Bring `docs/VARIABLES.md` up to date.
6. Then, and only then: the website, and reading from the Parliament's API.

## Waiting for your decision, and not blocking anything

- **Whether to keep the date a bill's Royal Assent was blocked.** Four bills;
  nothing forces it.
- **Whether the section 33 / 35 distinction becomes a variable.** Four bills;
  revisit at a fifth.
- **Whether a title's kind may be inferred from the Royal Assent date**, and
  with it the year for the two Acts whose factsheet prints an asp number with
  no year before it. Before Session 4.
- **What we record for a bill that has passed and has no Royal Assent yet.**
  Session 5's factsheet has a fourth table of them, three bills. The reader
  knows the table and leaves it alone. Before Session 5.
- **How to record a published record being revised.** When the first case
  arrives.
- **Whether to rename the dates factsheet's file** to match the others'
  convention. It arrived as "Dates of recess and dissolution and parliamentary
  years and recalls of Parliament.pdf", with a double space in it. Nothing
  depends on the name — the database cites the document and page, not the file.
- **Which source settles a disagreement about what kind of bill it was.** The
  comparison now catches one; none has ever arisen. The Parliament's own bill
  page is the obvious answer and is deliberately not assumed.

---

# Notes for whoever runs the session

Everything below the line is working detail. The owner does not need it to
orient, and none of it belongs above the line.

## Keeping this file useful

- **Above the line is for the owner.** Keep it to about a screen. At the end of
  a session: update the table, add one short entry for the session, cut older
  entries to a line each, and rewrite "Now". If it grows, cut; do not append.
- **The history of structure changes** is the numbered files in `db/` and
  `DECISIONS.md`. It is not repeated here.

## Sanity check, 2026-09-12 (second session of the day)

**At opening, everything matched**: 154 bills, 413 stage records, 36 provenance
notes, all 413 stage-date rows accepted and carried, the error checker empty, no
gaps, 26 tabs, 46 migrations numbered without a gap, the data dictionary
regenerating with no difference, nothing uncommitted or unpushed.

**Found at opening:** `/var/tmp` on the server held four pre-migration dumps
from earlier the same day (`042`, `044`, `045`, `046`). The previous session's
sweep looked in `/tmp` only. They were kept, not deleted: the nightly backup ran
clean at 02:59 but *before* those migrations, so nothing offsite yet covered
them. Tonight's run at 02:41 is the first that will. A fifth was added before
this session's work (`legdata-before-047_2026-09-12.dump`). **All five can go
once tonight's backup has run clean** — the same condition the owner agreed on
11 September.

**At close:**
- 154 bills, 413 stage records, **49 provenance notes** (36 + the 13 session
  dates), 413 stage-date rows all accepted and carried, checker empty, no gaps,
  26 tabs, 50 migrations numbered without a gap, 8 notes for readers, 4
  rejection routes, 9 sources.
- All seven sessions carry a first meeting; six carry a last day, Session 7
  being the one still running.
- The data dictionary regenerates unchanged: 17 tables, 159 columns, every one
  described. All 26 tabs belong to `legdata`, so Postico can open the session
  tab, the checker and the provenance notes.
- The mechanical half of the closure test was re-run after the work and matches
  its corrected expectations. **It has not been marked**: this session did the
  work, so the next one checks it.
- The repository is clean and level with GitHub.

**Rehearsed and thrown away before each real run, and the refusals proved as
well as the successes:**
- The comparison tool's fix: Session 1 off and back on now reports no unexpected
  difference, and four planted changes — a note's source altered, a note moved
  between stages, a stage date moved by a day, a note deleted — were all caught.
  The first run of that plant set a value that was already there, which looked
  like a miss and was not; worth knowing that a plant must be shown to have
  changed something.
- The four migrations, together, against a copy taken beforehand: 705
  differences, every one intended. 436 renamed source cells, 13 new provenance
  notes, and 256 stage-date rows the comparison cannot follow because its key
  includes the source name. **Those 256 were checked separately**, matched by
  line and position: nothing changed but the name. The session tab is not
  covered by `take_copy.sql` at all and was compared by hand.
- Neither `db/047` nor `db/048` can be applied twice. A bill wrongly coded as
  having fallen at dissolution is caught, naming both dates.

**Looking at the whole, after four migrations this day (`db/047`–`db/050`):**
no new tab, 26 as before, and no new variable about a bill. What changed that
the owner would see: the session tab, which was seven empty rows, now has dates;
one column on it is renamed to say what it holds; there are two SPICe sources
where there was one, plus the new dates factsheet; one more thing the error
checker refuses; and two of the eight notes a reader is given say more than they
did. The picture stays what it was — a sheet to type on, the checker, the gaps
list.

**A limitation restated, because it is now awake.** The session-window checks
were dormant while the session tab had no dates and are live from `db/048`. They
compare a line's dates against the session of the *factsheet* it was read from,
which is wrong for a bill carried between sessions. Sessions 1 and 2 have no
such bill and nothing fires. Reading the view, the failure is a false alarm and
not a false pass — the checks only look for dates outside the window, so a
carry-over row is flagged and stops the session rather than passing quietly.
**That is read, not rehearsed.** Rehearse it before Session 5 is loaded.

## The owner's standing positions, so they are not re-argued

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
- **The owner does not run database steps.** The session runs them and reports
  the results against what they should say. Step-by-step instructions are for
  what the owner does do: filling in spreadsheets, and reviewing in Postico.

**Before explaining anything about the database**, read
`docs/HOW-THE-DATABASE-WORKS.md` and the rules in `CLAUDE.md`. **Before
changing the clean data**, read `docs/PROMOTION-RUNBOOK.md`, and bring the
rehearsal, the check and the undo without being asked.

## Stage dates: working detail

- **Built in `db/033`:** the stage-dates staging sheet (`stage_candidate`), the
  checks in `v_candidate_problems`, the gaps list (`v_stage_date_gaps`), the
  clean sheet's rule that an undated completed stage has a note, the Hybrid
  correction, descriptions, and M2. The load, promotion and rollback scripts
  read the new sheet. See `DECISIONS.md`, 2026-09-11, for what was settled
  while building.
- **Built in `db/035`: typed entry.** The owner types rows in Postico, one per
  stage; there is no loader and no spreadsheet (`DECISIONS.md`, 2026-09-11,
  "Stage dates are typed into Postico"). The sheet shows each row's title,
  filled in by a trigger and refreshed from `bill_candidate`; `stage_order`
  is filled in from the stage name (`db/036`); slashed dates are read day
  first by the server. `db/037` sets day first for Postico's login, which
  Postico's display ignores. Scripts run as the administrator and are not
  affected. The owner's steps are in the runbook. A new row must reach the server
  with `stage_candidate_id` as DEFAULT; sent as NULL it is refused.
- **What a PhD row holds:** source `phd`, reference `PhD thesis dataset`, its
  own date read. A stage where a bill ended is not completed and `fell_here`,
  dated by the decision if there was one. A stage completed on a date not known
  has no date and a note.
- **Checking what was typed:** `tools/check_stage_entry.sql` lists every row
  waiting for review beside its bill's dates, when it reached the server, and
  the checker's findings. Run it after each of the owner's sittings.
- **The eleven Stage 1 rejections** already have the Official Report's date.
  The owner's PhD row for each is a second row, and the checker flags any
  disagreement.
- **The comparison after the dates:** `copy_before_phd_dates`, inside the
  database, was taken before `db/035` and before any PhD date. Sessions 1 and 2
  put back with the dates should differ from it only by the dates added. It
  lacks the title column, which the comparison lists and does not count.
- **The two blank spreadsheets** are still in `sources/phd/`, unused, until the
  owner clears their deletion.
- **The fifteen bills with nothing recording where they ended:** Session 1 has
  3 withdrawn and 3 fell at dissolution; Session 2 has 5 withdrawn and 4 fell
  at dissolution.
- **Private Bills in Sessions 1 and 2:** twelve. Session 1 has 3 (1 passed, 2
  fell at dissolution); Session 2 has 9, all passed. The owner's understanding
  that every one has a Consideration Stage meeting is tested by the gaps list.
- **Session 2 is promoted** (`db/034`, then the runbook), before the loader is
  built: a recorded exception (`DECISIONS.md`, 2026-09-11). When the PhD dates
  are added, both sessions come off and go back on.

## Detail for the later work

1. **Postico's permissions: fixed on 2026-09-12 (`db/040`).** All 26 tabs now
   belong to `legdata`, the login Postico uses, and every pivot table opens.
   - The cause, which is still a live rule: migrations run as the administrator
     (`postgres`), and whatever they create belongs to it unless told
     otherwise. **Any migration that creates something must set its owner**, as
     `db/031`, `db/033` and `db/035` do. `db/040` had to repair five made
     before that rule was followed.
2. **Sessions 3–5 read in full on 2026-09-12.** They reconcile in every cell:
   62, 86, and 84 of Session 5's 87. What is left is recorded above the line.
   - The two Acts whose factsheet prints an asp number with no year before it
     ("Higher Education Governance (Scotland) Act (asp 15)", Session 4, and
     "Period Products (Free Provision) (Scotland) Act (asp 1)", Session 5) now
     say so in their parser note. The checker's year check still does not
     notice, and settling the year settles that too. Before Session 4.
   - Session 5's three bills awaiting Royal Assent are the missing 3. Before
     Session 5.
   - `Clackmann- anshire Council`, a Session 2 promoter broken by a line break,
     is still on that session's staging sheet. The repair is applied to the
     title we propose, not to the factsheet's own words, so it does not reach
     this cell. Nothing in this slice uses it and it is not on the clean sheet.
     Correct it when Session 2 next comes off for another reason, or when who
     introduced a bill becomes a variable.
3. **Carry-over rows, before Session 5 is loaded.**
   - The session-window checks compare a line's dates against the session of
     the *factsheet* it was read from, which is wrong for a carry-over row.
   - `bill_candidate` has no column for a rename date or a block date.
     Sessions 4–7 state them.
4. **The double-count guard, before Session 6 is promoted.** Promotion treats
   two staging lines as one bill only when title and introduction date both
   match. The European Charter and UNCRC Bills are "Bill" in Session 5 and
   "Act" in Session 6, so the guard cannot see them.
5. **The prose parser for Sessions 6 and 7.** The grammar is in
   `FACTSHEET-SURVEY.md` §1. Empty sections are sentences ("No bills have
   fallen in Session 7."), not empty tables.
6. **The seven `session` rows: done on 2026-09-12 (`db/048`).** All seven carry
   a first meeting; all but Session 7, which is running, carry a last day. The
   source is SPICe's dates factsheet, agreeing to the day with the Parliament's
   API and with each legislation factsheet's own page 1.
   - The session-window checks are awake from that point and fire on nothing in
     Sessions 1 and 2. Item 3 is therefore still outstanding, and still bites
     before Session 5: those checks compare a line's dates against the session
     of the factsheet it was read from, which is wrong for a carry-over row.
     **The failure is a false alarm, not a false pass** — the checks read only
     for dates outside the window, so a carry-over row is flagged and stops the
     session rather than passing silently. That has been read in the view, not
     rehearsed; rehearse it before Session 5 is loaded.
7. **`docs/VARIABLES.md`.** Everything factual is in the data dictionary; what
   remains is reasoning, and it is out of date:
   - §3.2 describes `procedure` as non-null and `date_outcome` as present, and
     defines `short_title` as "title as introduced" (wrong since `db/021`);
   - it does not mention `date_concluded`, `bill_type_stated`, `title_kind`,
     `title_as_introduced`, `date_assent_blocked`, `stage_1_rejection_route`
     or the stage-dates sheet;
   - §4.1 needs `analysis_group`, and §4.5 needs `ref_bill_type_stage`;
   - §5 lists D1, D4 and D5 as open and never mentions D6, and §6 is answered
     by M6;
   - §7 still describes provenance as append-only (`db/030`).

One staging table serves all seven sessions, not one per session. The natural
key carries `session_number`, and cross-session questions would otherwise need
seven-way unions. Load one session at a time, each gated on reconciliation.

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
- **Sessions 5 and 6** carry bills also counted in another session's totals.
  The factsheet totals are right for the factsheet and wrong for a count of
  distinct bills; see M6.
- **Session 7.** Its grand total cell reads 0 where every margin reads 2. Trust
  the margins; the extracted table grid confirms that is the document.

A reconciliation proves no line was lost. It says nothing about what is inside
a line: Session 2 reconciled exactly while fifteen titles still carried their
SP Bill number.

**When charting:** a chart of outcome by bill type must say whether it grouped
on `bill_type` or `analysis_group`. They differ for the Forth Crossing Bill (44
or 45 government bills in Session 3). That is methodology note M4, which the
website has to surface.

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
  refuses to run if anything lacks a description.
- **`docs/PROMOTION-RUNBOOK.md`** is the procedure for loading and promoting,
  with a record of each run.
- **`docs/FACTSHEET-SURVEY.md`** is the survey of all seven factsheets.

## Housekeeping, small and known

- **Four safety copies are on the VPS**: `/var/tmp/legdata-before-042_2026-09-12.dump`,
  and `-044_`, `-045_`, `-046_`, one before each change to data or rules.
  Delete them once a nightly backup taken after 2026-09-12 has been confirmed.
  The backup timer next fires 02:41 UTC. The nine from 10 and 11 September were deleted
  on 2026-09-12 the same way. `copy_before_042` inside the database was compared
  and dropped.
- **No copy of the sheets is held inside the database.** `copy_before_phd_dates`
  was dropped once its comparison was done. Take a fresh one with
  `tools/take_copy.sql` before the next change to data already held.
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

**The SSH rate limit bites you, not only attackers.** About a dozen connections
in quick succession gives `Connection refused` for roughly 15 seconds. Batch
work into few connections.
