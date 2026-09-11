# State

Updated: 2026-09-11 (end of session)

## Start here, next session

**The owner adds Stage 1 and Stage 2 dates for Sessions 1 and 2, from the PhD.
Nothing else is promoted until that is done.** In this order:

1. **Settle the stage-dates decision with the owner before anything is built.**
   It is in `DECISIONS.md`, "Stage 1 and Stage 2 completion dates, from the
   PhD". The definitions are settled; three parts are open:
   1. **Where the dates arrive:** columns on the staging sheet, or a separate
      sheet of single facts, one row per date. The separate sheet is
      recommended.
   2. **Private and Hybrid Bills:** whether the Preliminary and Consideration
      Stages follow the same definitions as Stages 1 and 2.
   3. **Withdrawn and fallen bills:** whether to record the stage a bill had
      reached, where the PhD says.

   Then lay out every other part against the nine-part list in `CLAUDE.md`,
   with a proposal for each, and agree them all before building. That includes
   the rewrite of methodology note M2, the checks, and one question already
   known: a stage record currently has nowhere to say "completed, date not
   known" (see "Open", below), and the PhD may not have every date.
2. **Build it, and dress-rehearse the whole sequence** in a transaction that is
   thrown away, as was done for `db/030`–`db/032`. Then run it for real, step by
   step, checking each against the rehearsal.
3. **Load the owner's dates** from `sources/phd/stage-dates-session-1.csv` and
   `sources/phd/stage-dates-session-2.csv`. One line per staging line, keyed by
   line number, with empty columns for the Stage 1 date, the Stage 2 date, the
   PhD reference, the stage reached if the bill did not pass, and a note. The
   Official Report Stage 1 dates of the eleven bills rejected at Stage 1 were
   left out on purpose, so the PhD checks them instead of copying them.
4. **Take Session 1 off and put it back with its dates**, through
   `docs/PROMOTION-RUNBOOK.md`.
5. **Session 2.** The owner reads its 81 staging lines (Postico,
   `bill_candidate`, session 2, lines 74–154). Then it is admitted by a
   migration, as `db/016` did for Session 1, and promoted through the runbook.
   Expected totals are under "Reconciliation figures".

**Settled, and to carry forward exactly:**
- **Stage 1** ends on the date of the Stage 1 debate.
- **Stage 2** ends at the meeting at which the last amendments were disposed
  of. Every bill has that meeting, amendments or not: the committee (or the
  Parliament, for an emergency bill) agrees each section even if it takes two
  minutes.
- **The PhD** covers Sessions 1–6. It is added a session at a time.

**Before explaining anything about the database, read
`docs/HOW-THE-DATABASE-WORKS.md` and the rules in `CLAUDE.md` under
"Explaining the database to the owner".** Four attempts at explaining how the
tables interact failed in one session; both documents exist so that is not
rediscovered a fifth time. Spreadsheet words, one named bill traced in order,
no SQL vocabulary, short, then stop.

**Before changing the clean data, read `docs/PROMOTION-RUNBOOK.md`.** The
owner should not have to ask for a rehearsal, a check and an undo; bring them.

**The owner's standing positions, recorded so they are not re-argued:**
- **The structure** is accepted as the price of academic-quality
  transparency. The two lookup lists with no data behind them (`ref_party`,
  `ref_procedure`) are deliberate future-proofing and stay. The requirement
  that does not relax is that the owner can fully understand it.
- **A change to how data is coded is finished before anything moves on**
  (2026-09-11, `CLAUDE.md` working rules). Every part is settled before
  building and every part is built before any session it touches moves.
  "Not yet built" is not a state a decision may be left in. This is not a race.
- **The owner is the judge of what is acceptable to claim as academic
  quality.** The project's own rules are choices, not requirements of rigour.
  When one makes a simple thing awkward, propose relaxing it rather than
  designing around it.
- **Provenance notes may change, provided the owner clears the change.**
  Approving a rehearsed promotion clears the notes it rebuilds. Any other
  change to a note goes to the owner individually.

## Where we are

**Session 1 is on the clean sheet:** 73 bills, 67 stage rows, 11 provenance
notes. It was taken off and put back on 2026-09-11 to add how each Stage 1
rejection came about.
- **Totals, as before:** 51 government, 16 Member's, 3 private, 3 committee;
  62 passed, 3 withdrawn, 3 fell at dissolution, 5 rejected at Stage 1.
- **The 11 notes:** bill 17's corrected title, five outcomes read from the
  Official Report, and five routes to rejection, each quoting the Presiding
  Officer's announcement.
- **The routes:** four were the member in charge's motion, disagreed to. The
  Proportional Representation (Local Government Elections) (Scotland) Bill was
  rejected on that motion amended, and carries a note saying so.

**Session 2 is on the staging sheet, not yet reviewed:** 81 lines, numbered
74–154, all `new`.
- **Reconciliation:** it matches its factsheet's summary cell for cell.
- **Titles:** 15 SP Bill numbers, 3 asp numbers and one introduced title are
  separated out.
- **Fallen bills:** all ten have an outcome. Four fell at dissolution, inferred
  from the date. Six were rejected at Stage 1, read from the Official Report
  (`db/029`), each with its route (`db/032`): four on the member in charge's
  motion, and two (Provision of Rail Passenger Services, Civil Appeals) on a
  committee motion under Rule 9.14.18, with our view of the limb, (b), in a
  note.
- **The error checker is empty.**

**The database as a whole, looked at on 2026-09-11.** Postico shows 24 tabs:
- 10 dropdown lists;
- 8 pivot tables;
- the staging sheet (40 columns, 154 lines);
- the three clean-sheet tabs: bills (23 columns), stage rows (13) and
  provenance notes (10);
- two context tabs: sessions, and methodology notes M1–M7.

Five structure changes were made on 2026-09-11 (`db/028`–`db/032`), each
rehearsed. Every addition traces to a named bill or factsheet behaviour. The
orientation document and the data dictionary match the database.

**All seven factsheets have been surveyed** — `docs/FACTSHEET-SURVEY.md`. It
missed one thing, found on 2026-09-11: Session 2 prints an introduced title
inside a title cell. A structural read of a PDF misses what sits inside a cell.

## The first slice

Two questions, across all sessions:

1. **Outcome by bill type.** What happened to each bill, grouped by what kind of
   bill it was.
2. **Time taken to complete each stage**, by bill type and session.

Chosen because they are the minimum most people want to know about bills, and
because they can be built by hand in about a day — which makes them a reference
dataset that later automation has to reproduce.

The owner's key interest for the second question is **introduction to the end
of Stage 3**. Royal Assent and Reconsideration are secondary.

Deliberately not in this slice: member in charge, party, votes, amendments,
committee membership, the text of anything. Those are later slices.

## Done

- VPS live and hardened (see `legdatavps/legdata-vps-notes.md`).
- PostgreSQL 17.11 on the VPS. Database `legdata`, role `legdata`, UTF-8,
  `timezone=UTC`, listening on localhost only.
- Schema `db/001`-`db/032`.
- Postico 2 verified writing to the VPS, data and DDL.
- **`db/008` `bill_candidate`** — the staging table. Permissive by design: no
  foreign keys, almost nothing `NOT NULL`, so a bad parse lands as a row you can
  look at rather than as an import error. Strictness lives at promotion.
- **`db/009` `v_candidate_problems`** — one row per problem with a candidate.
- **`db/010`** — `procedure` nullable, default dropped.
- **`db/011` `methodology_note`** — seeded with M1, M2, M3.
- **`db/012` `bill_type_stated`** and `ref_bill_type_stated`.
- **`db/013`** — `date_concluded` on `bill`, and methodology note M3.
- **`db/014`** — `end_stage_1_date` on `bill_candidate`.
- **`db/015`** — `v_candidate_problems` extended: section-versus-outcome
  agreement, `title_kind`, `asp_number` year against Royal Assent, and dates
  falling outside their own session (dormant until the `session` rows have
  dates).
- **`db/016`** — Session 1 admitted, with candidate 17's title corrected. The
  migration refuses to admit anything while `v_candidate_problems` is non-empty.
- **`db/017`** — `scratch_test` dropped.
- **`db/018`** — stage dates live in `stage_event`, under each bill type's own
  stage names. `ref_bill_type_stage` says which sequence belongs to which type
  and a trigger enforces it. Settles D6.
- **`db/019`** — `sp_bill_id` unique within a session, not across sessions.
- **`db/020`** — passing is not concluding; `date_assent_blocked`; methodology
  note M5.
- **`db/021`** — `title_as_introduced` beside `short_title`; M3 rewritten.
- **`db/022`** — `ref_bill_type.analysis_group`; methodology note M4.
- **`db/023`** — notes only: M2's `applies_to` corrected; M6 and M7 added.
- **`db/024`** — a plain-English description on every table and column.
- **`db/025`** — every description rewritten to say what the data *is* before
  how it was derived; `field_source` made append-only. **The append-only rule
  was removed at `db/030`.**
- **`db/026`** — a bill's number is its staging line's number, and a bill cannot
  exist without a staging line behind it. Introduced to protect append-only
  notes; kept after `db/030` because line 17 = bill 17 is worth having anyway.
- **`db/027`** — one provenance note's reference corrected, by suspending the
  append-only rule.
- **`db/028`** (2026-09-11) — `bill_candidate.title_as_introduced`; the checker
  flags an SP Bill number or an introduced title left inside a title; M3 no
  longer states a count.
- **`db/029`** (2026-09-11) — Session 2's six Stage 1 rejections coded from the
  Official Report, with citations. Admits nothing.
- **`db/030`** (2026-09-11) — provenance notes are rebuilt with their bill: the
  append-only rule removed, descriptions corrected, M5 corrected.
- **`db/031`** (2026-09-11) — the route to a Stage 1 rejection:
  `ref_stage_1_rejection_route` (three values), `bill.stage_1_rejection_route`
  with two rules (a route for every Stage 1 rejection and no other bill; 9.14.18
  only on a Member's Bill), three staging columns (`stage_1_rejection_route`,
  `bill_note`, `official_report_read_on`), the checker's matching requirements,
  and a paragraph in M7.
- **`db/032`** (2026-09-11) — the routes for all eleven Stage 1 rejections in
  Sessions 1 and 2, the Presiding Officer's announcement for each, and three
  notes for readers.
- **`docs/DATA-DICTIONARY.md`** and **`tools/make_data_dictionary.py`** — the
  single source of truth for what the database holds. Generated from the
  database, never edited by hand, and the generator refuses to run if anything
  lacks a description. Tables only; pivot tables are not in it.
- **`tools/promote_session.sql`** and **`tools/rollback_promotion.sql`** — the
  promotion script and its undo. Both take `-v session=` and `-v save=`, with
  no default for either. Promotion now also carries the route, the note for the
  bill and the introduced title; files one provenance note per fact, dated by
  when its source was read; and refuses a double count only on the same title
  **and** introduction date. The undo now removes the session's provenance
  notes too.
- **`tools/load_session.sql`** (2026-09-11) — loads one session's extracted
  CSV onto the staging sheet, with the same rehearse-then-save shape. Refuses
  a CSV in the wrong format, the wrong session, or a session already loaded.
  Numbers the staging lines itself, so rehearsals use no numbers up.
- **`tools/extract_factsheet.py`** — the ruled-table format, sessions 1-5. On
  2026-09-11 it learned to separate SP Bill numbers, bracketed asp numbers and
  a stated introduced title.
- **`docs/PROMOTION-RUNBOOK.md`** — the written procedure for loading and for
  promotion: rehearse, look at specific things, save. Records what happened
  each time it was run.
- **`docs/HOW-THE-DATABASE-WORKS.md`** — the orientation document, in
  spreadsheet terms. Keep it true as the database changes.
- **`docs/FACTSHEET-SURVEY.md`** — the survey of all seven factsheets.
- **`sources/phd/`** (2026-09-11) — the two spreadsheets for the owner's Stage
  1 and 2 dates.
- **`tools/requirements.txt`** — pinned, with the full dependency tree.

### Verified on 2026-09-10, not merely assumed

- **The extractor is deterministic.** The Session 1 factsheet produced
  byte-for-byte identical output on macOS/Python 3.12 and on the VPS under
  Debian/Python 3.13.
- **The load is faithful to the extraction.** All 73 rows across all seven
  `raw_*` columns are identical to a fresh run of the extractor.
- **Every date re-parses.** 73 rows, three date fields, no discrepancy.
- **The reconciliation holds.** All twelve cells of the Session 1 factsheet's
  summary table on page 7, plus both margins. The column order in that table is
  Executive, Member's, **Private, Committee**.
- **Promotion is reversible.** Promoted, taken off, promoted again; the same 73
  bills with the same numbers.
- **The backup restores.** Snapshot fetched back from the storage box, restored
  into a scratch database, checked, dropped.

### Verified on 2026-09-11, not merely assumed

- **The extractor changes leave Session 1 untouched.** A fresh extraction
  matches the previous one in every column of all 73 lines. Session 2 changed
  only in the intended places (18 titles, 3 asp numbers, 1 note), and Sessions
  3–5 now have nothing left over in their titles.
- **The Session 2 load is faithful.** Every CSV line arrived unchanged, dates
  included. A CSV in the old format and a wrong session number were both
  refused. No staging line numbers were used up by rehearsals.
- **The new checks catch what they are for.** An SP Bill number and an
  introduced title planted in a title, in a transaction thrown away, were both
  flagged.
- **Every Official Report citation was read against the Parliament's page:**
  the motion, the vote figures and the date, for all eleven Stage 1 rejections.
- **The provenance and route change was dress-rehearsed twice before the real
  run, and the real run matched.**
  - Counts: 73 bills, 67 stage rows, 11 notes.
  - The old notes' wording and references came back identical.
  - The rules refuse a route on a passed bill, a Stage 1 rejection with no
    route, and a 9.14.18 route on a Government Bill.
  - A provenance note can now be corrected.
  - Postico's user can read the new list and the checker.
- **Postico's user cannot read** `ref_bill_type_stage` or the five
  administrator-owned pivot tables ("permission denied").

## Next

### Now

See "Start here". Stage 1 and 2 dates for Sessions 1 and 2, then Session 2.

### After that

3. **Fix Postico's permissions.** Small, and it touches no data. Until it is
   done, the owner cannot open `ref_bill_type_stage` or the five pivot tables
   the runbook points to. The runbook says to have them printed meanwhile. The
   cause and the list are under "Housekeeping".
4. **Fix table fragmentation for sessions 3, 4 and 5.** They extract short by
   2, 14 and 6 rows against their own stated totals. pdfplumber fragments tables
   that break across a page, so a data row is consumed as a header. Symptoms to
   fix by: `Clackmann- anshire Council` (unrejoined line-break hyphen) and a
   truncated `Trustees of`. Also found on 2026-09-11: Session 4 prints a
   footnote marker inside a year ("Act 20141 (asp 13)"), and two Acts have no
   year before the asp number ("Higher Education Governance (Scotland) Act (asp
   15)", Session 4; "Period Products (Free Provision) (Scotland) Act (asp 1)",
   Session 5). The extractor then gives an asp number with no year, and the
   checker's year check does not notice a missing year.
5. **Handle carry-over rows before Session 5 is loaded.**
   - The session-window checks compare a candidate's dates against the session
     of the *factsheet* it was read from, which is the wrong session for a
     carry-over row (`v_candidate_problems` comment).
   - `bill_candidate` has no column for a rename date or a block date. Sessions
     4–7 state them. (An introduced title now has one, `db/028`.)
6. **Before Session 6 is promoted: the double-count guard.** Promotion treats
   two staging lines as the same bill only when title and introduction date
   both match. The European Charter and UNCRC Bills are "Bill" in Session 5 and
   "Act" in Session 6, so the guard cannot see them.
7. **Write the prose parser for sessions 6 and 7.** The full grammar is in
   `FACTSHEET-SURVEY.md` §1. Empty sections are sentences ("No bills have
   fallen in Session 7."), not empty tables.
8. **Fill in the seven `session` rows.** Sessions 1-5 state their dates on page
   1 of their factsheets (`FACTSHEET-SURVEY.md` §7). **Sessions 6 and 7 do not**
   and need another source. This wakes the session-window checks, so item 5
   comes first.
9. **`docs/VARIABLES.md` needs a pass.** Everything factual is in
   `docs/DATA-DICTIONARY.md`; what remains there is the reasoning, and it is
   out of date:
   - §3.2 still describes `procedure` as non-null and `date_outcome` as present.
   - It does not mention `date_concluded`, `bill_type_stated`, `title_kind`,
     `title_as_introduced`, `date_assent_blocked` or `stage_1_rejection_route`.
   - §3.2 defines `short_title` as "title as introduced", which `db/021` made
     wrong.
   - §4.1 needs `analysis_group`.
   - §5 lists D1, D4 and D5 as open, and never mentions D6.
   - §4.5 needs `ref_bill_type_stage`.
   - §6 is answered by M6.
   - §7 still describes provenance as append-only (`db/030`).
10. Then, and only then: front end, extraction from the API.

One staging table for all seven sessions, not one per session — the natural key
carries `session_number`, and cross-session questions (the `E`/`G`/`G*`
changeover) would otherwise need seven-way unions. Load one session at a time,
each gated on reconciliation.

### Reconciliation figures, per session

The gate compares our count against each factsheet's own summary table.

- **Session 1.** 51 Executive, 16 Member's, 3 Private, 3 Committee; 62 Acts, 3
  withdrawn, 8 fallen.
- **Session 2.** Reconciles exactly, page 8: Executive 53, Member's 18,
  Private 9, Committee 1; Acts 66 (53/3/9/1), withdrawn 5 (all Member's),
  fallen 10 (all Member's). Same column order as Session 1. Its 10 fallen are 4
  at dissolution and 6 rejected at Stage 1.
- **Session 3.** Its summary has no Hybrid column and counts the Forth Crossing
  Bill under Executive. Its stated Executive 45 is our government 44 + hybrid 1.
  Reconcile on `analysis_group`, not on `bill_type`.
- **Session 7.** Its grand total cell reads 0 where every margin reads 2. Trust
  the margins. Verified against the extracted table grid, so it is the document.
- **Sessions 5 and 6** carry bills also counted in another session's totals. The
  factsheet totals are right for the factsheet and wrong for a count of distinct
  bills; see M6.

A reconciliation proves no line was lost. It says nothing about what is inside a
line — Session 2 reconciled exactly while fifteen titles still carried their SP
Bill number.

### Watch when charting

A chart of outcome by bill type must state whether it grouped on `bill_type` or
`analysis_group`, because the two differ for the Forth Crossing Bill: Session 3
shows 45 government bills under one and 44 under the other. This is a methodology
note the front end has to surface (M4), not a comment in the charting code.

## Housekeeping, small and known

- **Postico cannot open six things.** Postico connects as `legdata`, which has
  no administrator rights. The dropdown list `ref_bill_type_stage` and five
  pivot tables (`v_bill_stage_dates`, `v_bill_stage_durations`,
  `v_bill_total_duration`, `v_outcome_by_type`, `v_stage_duration_summary`)
  belong to the administrator (`postgres`), and `legdata` cannot read them.
  The cause: migrations run as the administrator, and whatever they create
  belongs to it unless told otherwise. `db/031` sets its new list's owner for
  that reason, and **any future migration that creates something must do the
  same.** Fix is "Next", item 3.
- **A safety copy of the whole database** from just before `db/030` is on the
  VPS at `/var/tmp/legdata-before-030_2026-09-11.dump`. Delete it once a
  nightly backup taken after 2026-09-11 has been confirmed.
- **The backup service runs with no `HOME` or `XDG_CACHE_HOME`**, so restic keeps
  no cache and re-reads everything in scope every night. Harmless at this size,
  but it will not stay harmless forever. One `Environment=` line in the unit
  file fixes it.
- **The Justice 2 Committee's own record** of its decision on the Civil Appeals
  (Scotland) Bill has not been found. Our view of the limb rests on the chamber
  debate. Worth finding; nothing waits on it. The older committee pages redirect
  to the National Records of Scotland web archive, which blocks automated
  access, so it is probably a manual search.
- **Not checked:** the owner suspects the Parliament has since changed how
  motions are handled, so a Stage 1 motion can no longer be amended into a
  rejection.
- **Extraction environment on the Mac** is a throwaway virtual environment
  built from `tools/requirements.txt` in the session scratchpad. The VPS copy at
  `/opt/legdata/venv` is the standing one.

## Open, not yet decided

- **D2 — which date marks the completion of a stage.** Settled on 2026-09-11 for
  Stages 1 and 2 (see "Start here"), and not yet built. Stage 3 was already
  settled by M2: the decision to pass.
- **D3** — calendar days or sitting days. Does not block.
- **A stage completed on a date not yet known has nowhere to go.**
  `stage_event.date_completed` empty is described as "not completed", which
  closes off that case. It will arrive as soon as PhD dates are loaded, if any
  are missing. Settle as part of the stage-dates decision.
- **Withdrawn and fallen bills have no stage records.** Six Session 1 bills
  have a concluding date and nothing else, because the factsheet does not say
  which stage they had reached. Open part 3 of the stage-dates decision.
- **How to record a revision to a published record**, now that provenance notes
  hold only the latest reading (`db/030`). Nothing records a second reading of a
  source that gives a different answer. No revision has happened. Settle when the
  first real case arrives; `v_field_revisions` is empty until then.
- **`date_assent_blocked` is the one thing added without a constraint forcing
  it.** It exists because `blocked` is otherwise a state with no time attached.
  Four bills use it. If judged speculative, it can be dropped with no data loss
  today.
- **Whether the s.33 / s.35 distinction should be a variable rather than prose in
  `bill.note`.** Prose for now. Four bills; revisit if a fifth appears or the
  front end wants to filter on it. `bill.note` can now actually be filled,
  through `bill_candidate.bill_note` (`db/031`).
- **`title_kind` has nowhere to go at promotion.** All staging lines carry it;
  no bill does. Decide whether inferring it from the Royal Assent date is
  acceptable before Session 4.
- **Asking whether a rule exists means reading three catalogues, not one.**
  `pg_constraint` does not list plain indexes. Read `pg_indexes` and
  `pg_trigger` too.

**D1, D4 and D6 are settled, and D5 was amended on 2026-09-11** — see
`DECISIONS.md`.

## Connecting to the database

**Correcting what this file used to say.** It described a shared SSH tunnel on
port 15432. That is not how anything actually connects, and following it wastes
time. Postico opens its **own** tunnel inside the application, on an ephemeral
local port it picks per connection; there is no shared listener, and nothing
outside Postico can use it.

**From Postico** (the entry client): as already configured. Nothing to change.
It connects as `legdata`, which is not an administrator — see "Housekeeping".

**From a shell, or for any scripted work:** go through the connector script,
which holds the address, port, user and key, and keeps its own known-hosts file.
It is not in this repository.

    ~/.claude/legdata-vps 'whoami'
    ~/.claude/legdata-vps 'sudo -u postgres psql -d legdata -c "SELECT ..."'
    ~/.claude/legdata-vps --scp local/file /remote/path

`ldadmin` has passwordless sudo, and `sudo -u postgres psql` connects by peer
authentication, so no database password is needed and none has to be stored on
the Mac. This is also how migrations are applied.

**Dress-rehearsing a sequence of migrations and scripts.** Strip each file's own
`BEGIN;`, `COMMIT;` and closing `\if :save … \endif` block, include them in
order inside one `BEGIN … ROLLBACK`, and set `\set session N`. That is how
`db/030`–`db/032` and the Session 1 re-promotion were rehearsed end to end.

**Do not use the `legislativedata-vps` or `legislativedata-data` entries in
`~/.ssh/config`.** They are leftovers from the old estate; `legislativedata-vps`
points at `5.83.150.18`, a machine that was never part of this project, and it
will fail a host key check. The box is `77.90.2.83`, hostname
`legislativedata-SP`.

**The SSH rate limit bites you, not only attackers.** About a dozen connections
in quick succession produces `Connection refused` for roughly 15 seconds. Batch
work into few connections rather than one per command.
