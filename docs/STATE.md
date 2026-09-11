# State

Updated: 2026-09-11, fourth session that day

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
| 1 | 73 bills | yes | yes | ready to type in; practice first |
| 2 | 81 bills | yes | yes | ready to type in; practice first |
| 3–5 | reader misses rows | no | no | no |
| 6–7 | needs a prose reader | no | no | no |

For Sessions 1 and 2 we can answer question 1, and the time from introduction
to passing. Time per stage waits for the Stage 1 and 2 dates.

## What has been done

- **10 September.** Built the database, surveyed all seven factsheets, and put
  Session 1 on the clean sheet.
- **11 September, first session.** Read Session 2 in, recorded how each Stage 1
  rejection came about, and set the rule that a coding change is finished
  before anything moves on.
- **11 September, second session.** Settled stage dates in full, and that each
  clean tab gets a staging sheet of the same shape.

- **11 September, third session.** Built the stage-dates sheet, proved moving
  the dates changed nothing, and put Session 2 on the clean sheet.

**11 September, fourth session.**
- **You type your dates straight into Postico**, not into spreadsheets. That
  finishes the stage-dates change: nothing in it is left unbuilt.
- **The stage-dates sheet shows each bill's title** beside its line number,
  and the stage's number fills itself in from its name. Both proved to have
  changed nothing else.
- **Dates are typed year first**, as Postico shows them.
- **Tidied:** leftover files off the server, and the server's details out of
  the repository. The dictionary tool now cleans up after itself.

## Now: your second read of the stage dates

**Your dates are in, waiting for you.** 270 rows were loaded from your own
spreadsheet and from your answers about the bills that did not pass, and
nothing has reached the clean sheet.

1. **You read them in Postico**, on `stage_candidate`. 272 rows are marked
   `new`: 256 from your dataset, 13 from the Parliament's bill pages and 3 from
   the Official Report. Each carries the page it came from.
2. **They are accepted**, recorded in a migration, as Session 1 and 2's lines
   were.
3. **Sessions 1 and 2 are taken off and put back** with the dates, and compared
   with the copy taken today. They should differ only by the dates added.

127 of the 128 bills that passed now have all three stage dates. The other is
the Session 2 Robin Rigg Act, which went straight to its Final Stage, and its
two missing dates are the whole of the gaps list.

## After that, in order

1. Fix Postico's permissions: five pivot tables it cannot open.
2. Sessions 3–5: the reader misses 2, 14 and 6 rows.
3. Bills carried over between sessions: before Session 5 is loaded.
4. The double-count guard: before Session 6 is promoted.
5. A prose reader for Sessions 6 and 7.
6. Each session's start and end dates.
7. Bring `docs/VARIABLES.md` up to date.
8. Then, and only then: the website, and reading from the Parliament's API.

## Waiting for your decision, and not blocking anything

- **The thesis year in M2.** 2021, as you gave it; the copy on the server is
  headed "final for submission – 25 February 2022".
- **Calendar days or sitting days** for durations.
- **Whether to keep the date a bill's Royal Assent was blocked.** Four bills;
  nothing forces it.
- **Whether the section 33 / 35 distinction becomes a variable.** Four bills;
  revisit at a fifth.
- **Whether a title's kind may be inferred from the Royal Assent date.** Before
  Session 4.
- **How to record a published record being revised.** When the first case
  arrives.
- **Not checked:** whether a Stage 1 motion can still be amended into a
  rejection.
- **Sending the work to GitHub.** Nothing from the last nine commits has been
  sent. The server's details leave the public copy only once it is.
- **Deleting the two blank spreadsheets** in `sources/phd/`. A permission check
  stopped the session doing it.
- **Whether to undo `db/037`.** It did not change what Postico shows.
- **Your two practice rows** for the Abolition of Feudal Tenure Bill match your
  spreadsheet exactly. They stay, and the loader will skip that bill's dates.

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

## Sanity check, 2026-09-11, fourth session

- **At opening, all matched:**
  - 154 bills, 139 stage records, 23 notes;
  - 139 stage-dates rows, all accepted and stamped (128 factsheet, 11 Official
    Report), and both sessions' 154 lines accepted and promoted;
  - the error checker empty, 271 gaps, 26 tabs, `bill_candidate` 38 columns;
  - the data dictionary regenerated with no difference;
  - nothing uncommitted, and both PhD spreadsheets blank.
- **Found:** 24 loose files in the VPS's `/tmp`. The last sweep removed
  folders, not files. 22 were this project's rehearsal leftovers; 2 were from
  the previous attempt (an API fetch list and a file manifest). All deleted,
  with the owner's agreement. The dictionary tool left its query there on every
  run; it now removes it.
- **Found:** the server's address and login name were in `STATE.md`, and the
  whole `legdatavps/` folder (connector and notes) had been tracked in the
  public repository since the first commit. Both are already on GitHub. No
  password or key was in them, and login is by key only. Taken out of
  `STATE.md`, and the folder is no longer tracked and is ignored. The private
  copies in `~/.claude/` are identical. The repository's history still holds
  them; rewriting it was not proposed.
- **Found:** the last nine commits were never pushed.
- **Found:** the server read 05/01/2000 as 1 May (`DateStyle` ISO, MDY). Now
  ISO, DMY for the whole database (`db/035`).
- **After `db/035`:**
  - 139 stage-dates rows, each showing its line's title, numbering at 154;
  - the error checker empty and 271 gaps, as before;
  - a fresh connection as Postico's user reads 05/01/2000 as 5 January;
  - 26 tabs; `stage_candidate` has 19 columns.
- **After `db/036`:** all 139 rows saved again came back identical; every
  position matches its stage name; compared with `copy_before_phd_dates`,
  nothing unexpected; the checker empty, 271 gaps; the data dictionary
  regenerated from the database.
- **After `db/037`:** set for Postico's login, but Postico still shows dates
  year first after reconnecting, so it formats dates itself. How Postico reads
  a date typed with slashes is not tested; the runbook says to type year first.
  The scripts see the database's own form, unchanged.
- **Looking at the whole:** five migrations this day since `db/032`. `db/035`
  to `db/037` add one display column, four automatic rules and two date
  settings, and no tab.
  The owner's picture of the database is unchanged: a sheet to type on, the
  checker, the gaps list.
- **Still true from the third session:** while a copy schema exists, any
  question put to the catalogue must name `public`. `copy_before_phd_dates`
  exists.
- **Still to see:** the Session 2 Robin Rigg and Stirling-Alloa-Kincardine
  Private Bills were reintroduced after dissolution and passed within weeks.
  They may not have gone through every stage again. If so they will show as
  gaps, and need a note, not a date.

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

1. **Postico's permissions.**
   - Postico connects as `legdata`, which has no administrator rights.
   - It cannot read five pivot tables: `v_bill_stage_dates`,
     `v_bill_stage_durations`, `v_bill_total_duration`, `v_outcome_by_type`
     and `v_stage_duration_summary`. (`ref_bill_type_stage` was given to it in
     `db/033`, because the error checker needed it.)
   - The cause: migrations run as the administrator (`postgres`), and whatever
     they create belongs to it unless told otherwise. **Any migration that
     creates something must set its owner**, as `db/031` and `db/033` do.
   - Until it is fixed, have those tables printed for the owner when the
     runbook points to them.
2. **Sessions 3–5 extract short** by 2, 14 and 6 rows against their own stated
   totals.
   - The cause: pdfplumber fragments tables that break across a page, so a
     data row is consumed as a header.
   - Symptoms to fix by: `Clackmann- anshire Council` (an unrejoined
     line-break hyphen) and a truncated `Trustees of`.
   - Session 4 prints a footnote marker inside a year ("Act 20141 (asp 13)").
   - Two Acts have no year before the asp number: "Higher Education Governance
     (Scotland) Act (asp 15)" (Session 4) and "Period Products (Free Provision)
     (Scotland) Act (asp 1)" (Session 5). The extractor then gives an asp
     number with no year, and the checker's year check does not notice.
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
6. **The seven `session` rows.**
   - Sessions 1–5 state their dates on page 1 of their factsheets
     (`FACTSHEET-SURVEY.md` §7). Sessions 6 and 7 do not, and need another
     source.
   - Filling them wakes the session-window checks, so item 3 comes first.
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

- **Six safety copies of the whole database** are on the VPS:
  `/var/tmp/legdata-before-030_2026-09-11.dump`, `-033_`, `-034_`, `-035_`,
  `-036_` and `legdata-before-phd-dates_2026-09-11.dump`.
  Delete them once a nightly backup taken after 2026-09-11 has been confirmed.
- **`copy_before_phd_dates`** is held inside the database for the comparison
  after the PhD dates. Drop it once that comparison is done.
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
