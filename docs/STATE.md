# State

Updated: 2026-09-10 (third session of the day)

## Where we are

Session 1 is extracted, reconciled, coded, loaded, **reviewed and accepted** —
73 candidates, zero outstanding problems, all `review_status = 'accepted'`.
Nothing has been promoted, so `bill` is still empty.

**All seven factsheets have now been surveyed** — `docs/FACTSHEET-SURVEY.md` —
and the seven schema decisions that came out of it are applied as `db/019`-`db/023`
and recorded in `DECISIONS.md`. That was the last piece of work that had to
happen while `bill` was empty. **The next piece of work is the promotion script.**

The survey changed more than expected. The largest finding was not on the list of
things to confirm: passing a bill is not the end of it, four bills prove it, and a
`CHECK` constraint said otherwise. Three other things the survey found that were
not being looked for: SPICe's Session 3 summary counts the only Hybrid Bill as an
Executive Bill and the reconciliation gate passes anyway; Session 7's summary
table does not add up; and four bills appear in two factsheets each, so the seven
stated totals sum to 473 while there are 470 distinct bills.

## The first slice

Two questions, across all sessions:

1. **Outcome by bill type.** What happened to each bill, grouped by what kind of
   bill it was.
2. **Time taken to complete each stage**, by bill type and session.

Chosen because they are the minimum most people want to know about bills, and
because they can be built by hand in about a day — which makes them a reference
dataset that later automation has to reproduce.

Deliberately not in this slice: member in charge, party, votes, amendments,
committee membership, the text of anything. Those are later slices.

## Done

- VPS live and hardened (see `legdatavps/legdata-vps-notes.md`).
- PostgreSQL 17.11 on the VPS. Database `legdata`, role `legdata`, UTF-8,
  `timezone=UTC`, listening on localhost only.
- Schema `db/001`-`db/023`.
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
- **`db/015`** — `v_candidate_problems` extended. It had not moved since `db/009`
  while three columns were added underneath it, so `end_stage_1_date`,
  `bill_type_stated` and the `date_concluded` rule were not being checked at all.
  Also added: section-versus-outcome agreement, `title_kind`, `asp_number` year
  against Royal Assent, and dates falling outside their own session (dormant
  until the `session` rows have dates). Session 1 passes all of them.
- **`db/016`** — Session 1 admitted. All 73 `accepted` with `reviewed_at` set,
  and one correction: candidate 17's `short_title` was `Criminal Procedure
  (Amendment) Scotland Act 2002`, which is how the factsheet prints it and not
  the title of the Act. `raw_title` keeps SPICe's wording. The migration refuses
  to admit anything while `v_candidate_problems` is non-empty.
- **`db/017`** — `scratch_test` dropped.
- **`db/018`** — stage dates moved off `bill` and back into `stage_event`, under
  each bill type's own stage names. `ref_bill_type_stage` says which sequence
  belongs to which type and a trigger enforces it, so a Private Bill cannot be
  given a Stage 2. `v_bill_stage_dates` pivots them back into columns and the
  duration views compare by position while keeping the real names visible.
  Settles D6.
- **`db/019`** — `sp_bill_id` unique within a session, not across sessions. SP
  Bill numbers restart each session; SP Bill 13 is in Sessions 2, 6 and 7.
- **`db/020`** — passing is not concluding. `bill_concluded_only_if_not_passed`
  becomes `bill_concluded_only_if_not_enacted`; `date_assent_blocked` added;
  `pending` and `blocked` definitions corrected; `v_candidate_problems` amended
  to match, and its session-window limitation written into its own comment.
  Methodology note M5.
- **`db/021`** — `title_as_introduced` added beside `short_title`, both defined.
  M3 rewritten from an apology into a statement about coverage.
- **`db/022`** — `ref_bill_type.analysis_group`, which groups hybrid to
  government and everything else to itself. `v_outcome_by_type` carries both
  columns. Methodology note M4.
- **`db/023`** — notes only. M2's `applies_to` pointed at three columns `db/018`
  dropped; M6 (session attribution and the 473/470/474 arithmetic) and M7 (why a
  bill fell is our coding, 5 of 48 done) added.
- **`docs/FACTSHEET-SURVEY.md`** — the survey of all seven factsheets: sections,
  summary tables, footnotes, marker letters, the prose grammar for Sessions 6-7,
  the cross-session bills, and the stated session date ranges.
- **`tools/extract_factsheet.py`** — the ruled-table format, sessions 1-5.
- **`tools/requirements.txt`** — pinned, with the full dependency tree.

### Verified on 2026-09-10, not merely assumed

- **The extractor is deterministic.** The Session 1 factsheet produced
  byte-for-byte identical output on macOS/Python 3.12 and on the VPS under
  Debian/Python 3.13. The reconciliation argument depends on this and it had
  never been tested.
- **The load is faithful to the extraction.** All 73 rows across all seven
  `raw_*` columns are identical to a fresh run of the extractor.
- **Every date re-parses.** Each date was re-derived independently from the
  verbatim `raw_*` string and compared with the typed column: 73 rows, three
  date fields, no discrepancy.
- **The reconciliation holds.** All twelve cells of the factsheet's own summary
  table on page 7, plus both margins — 51/16/3/3 by type, 62/3/8 by outcome.
  Note the column order in that table is Executive, Member's, **Private,
  Committee**; reading it in the other order invents a mismatch that is not
  there.
- **The backup restores.** Snapshot fetched back from the storage box, restored
  into a scratch database, checked, dropped.

## Next

The survey is done and its decisions are applied, so the reason for holding off
promotion has gone. Structural change is no longer free after this point; that is
the deliberate trade, and promotion is reversible, which is what makes it
affordable.

### Next session: promote Session 1

1. **Write the promotion script**, and promote Session 1. `bill_candidate` →
   `bill`, for `review_status = 'accepted'` rows, setting `promoted_bill_id` and
   `promoted_at`.

   It fans each candidate row out into `stage_event` rows under the right stage
   names for that bill's type (`db/018`) — which for Session 1 means a position-3
   row per bill that passed, named `stage_3` for a public bill and `final` for
   the one Private Bill, plus a position-1 row for each of the five bills
   rejected at their first stage. The trigger will refuse anything mismatched.

   It must also emit `field_source` rows for the six fields that did not come
   from the row's stated source:
   - candidate 17's corrected `short_title` (`source = manual`)
   - the five `end_stage_1_date` values and their outcomes, each of which
     carries its Official Report citation in `review_note` already
     (`source = official_report`)

   Session 1 needs nothing from `db/019`-`db/023`: it has no SP Bill numbers, no
   bill that passed and was later withdrawn, no stated introduced title, no
   Hybrid Bill and no carry-over. That is the point — those migrations are the
   shape the later sessions will be promoted into, built while it cost nothing.

   Promotion is reversible: `bill_candidate` is permanent and promotion is a
   script, so `bill` can be emptied and re-promoted if a later session forces a
   change.

2. **Load Session 2 into staging.** It already extracts clean — 81 rows against
   a stated 81 — so it needs no parser work first. Nine of its bills are Private
   Bills, the railway and tram cluster: the first real test of `db/018`. It is
   also the first session with SP Bill numbers, which it gives only to bills that
   did not become Acts.

### After that

3. **Fix table fragmentation for sessions 3, 4 and 5.** They extract short by
   2, 14 and 6 rows against their own stated totals. pdfplumber fragments tables
   that break across a page, so a data row is consumed as a header. Symptoms to
   fix by: `Clackmann- anshire Council` (unrejoined line-break hyphen) and a
   truncated `Trustees of`.
4. **Handle carry-over rows before Session 5 is loaded.** Two known problems,
   both written up in `FACTSHEET-SURVEY.md` §9 and in the `v_candidate_problems`
   comment at `db/020`:
   - The session-window checks compare a candidate's dates against the session of
     the *factsheet* it was read from. For a carry-over row that is the wrong
     session, and the checks will fire on rows that are correct.
   - `bill_candidate` has no column for a stated introduced title, a rename date
     or a block date. Sessions 4-7 state all three; Session 1 states none, which
     is why they were not built.
5. **Write the prose parser for sessions 6 and 7.** Different format entirely.
   The full grammar is in `FACTSHEET-SURVEY.md` §1 — nine line shapes, including
   two that nothing anticipated: the rename line, and the two-date Reconsideration
   Stage pair. Empty sections are sentences ("No bills have fallen in Session 7."),
   not empty tables.
6. **Fill in the seven `session` rows.** Sessions 1-5 state their own dates on
   page 1 of their factsheets and they are transcribed in `FACTSHEET-SURVEY.md`
   §7. **Sessions 6 and 7 do not state theirs** and need another source; Session
   6 contains a bill that fell on 8 April 2026, after its factsheet was published,
   so dissolution is not derivable from the rows either. Doing this wakes up the
   session-window checks added in `db/015`, which are inert until then — so item 4
   has to come first.
7. **`docs/VARIABLES.md` needs a pass, and it is now a bigger one.** §3.2 still
   describes `procedure` as non-null and `date_outcome` as present; both have
   changed. It does not mention `date_concluded`, `bill_type_stated`,
   `title_kind`, `title_as_introduced` or `date_assent_blocked`. §3.2's definition
   of `short_title` as "title as introduced" is the thing `db/021` split in two
   and is now simply wrong. §4.1 needs `analysis_group`. §5 lists D1, D4 and D5
   as open when they are settled, and D6 is settled without ever appearing there.
   §3.3 and §4.5 are accurate again after `db/018`; §4.5 needs
   `ref_bill_type_stage` added and its note that Private Bills have their own
   stages turned from an aside into the rule. §6, on bills spanning sessions, is
   now answered by M6 and should say so.
8. Then, and only then: front end, extraction from the API.

One staging table for all seven sessions, not one per session — the natural key
carries `session_number`, and cross-session questions (the `E`/`G`/`G*`
changeover) would otherwise need seven-way unions. Load one session at a time,
each gated on reconciliation.

### Reconciliation figures, per session

The gate compares our count against each factsheet's own summary table. Two of
the seven cannot be used as printed, and both are recorded here so the finding is
not made twice:

- **Session 3.** Its summary has no Hybrid column and counts the Forth Crossing
  Bill under Executive. Its stated Executive 45 is our government 44 + hybrid 1.
  Reconcile on `analysis_group`, not on `bill_type`.
- **Session 7.** Its grand total cell reads 0 where every margin reads 2. Trust
  the margins. Verified against the extracted table grid, so it is the document.
- **Sessions 5 and 6** carry bills also counted in another session's totals. The
  factsheet totals are right for the factsheet and wrong for a count of distinct
  bills; see M6.

### Watch when charting

A chart of outcome by bill type must state whether it grouped on `bill_type` or
`analysis_group`, because the two differ for the Forth Crossing Bill: Session 3
shows 45 government bills under one and 44 under the other. This is a methodology
note the front end has to surface (M4), not a comment in the charting code.

## Housekeeping, small and known

- **`scratch_test`** dropped in `db/017`. It was debris from verifying that
  Postico's grid edits reached the VPS.
- **`stage_event`** is now the home of stage dates again (`db/018`), and empty
  until promotion runs.
- **The backup service runs with no `HOME` or `XDG_CACHE_HOME`**, so restic keeps
  no cache and re-reads everything in scope every night. Harmless at this size —
  the whole repository is under a megabyte — but it will not stay harmless
  forever. One `Environment=` line in the unit file fixes it.

## Open, not yet decided

- **D2** — which date marks the completion of a stage. Still open, but narrower
  than it was. Five Session 1 bills carry an `end_stage_1_date`, taken as the
  date of the decision that rejected them at Stage 1. That does not settle D2:
  for a bill *rejected* at Stage 1 the committee report, the chamber debate and
  the decision collapse onto one event, so all three candidate definitions agree.
  `db/015` now checks that this is so, and it is. The question is still live for
  a bill that *passed* Stage 1, where they differ by weeks. D2 does not affect
  Stage 3 at all — the decision to pass a bill is the completion of Stage 3,
  which is what methodology note M2 says.
- **D3** — calendar days or sitting days. Does not block.
- **`date_assent_blocked` is the one thing added without a constraint forcing
  it.** Flagged here rather than buried: it holds the date a bill was blocked
  from assent, and it exists because `blocked` is otherwise a state with no time
  attached in a project whose second question is about time. Four bills use it.
  If it is judged speculative it can be dropped with no data loss today.
- **Whether the s.33 / s.35 distinction should be a variable rather than prose in
  `bill.note`.** Settled for now as prose, because the distinction is about who
  blocked the bill rather than about the bill's state. Four bills; revisit if a
  fifth appears or if the front end wants to filter on it.

**D1, D4, D5 and D6 are settled** — see `DECISIONS.md`, along with the seven
decisions the factsheet survey forced on the same day.

## Connecting to the database

**Correcting what this file used to say.** It described a shared SSH tunnel on
port 15432. That is not how anything actually connects, and following it wastes
time. Postico opens its **own** tunnel inside the application, on an ephemeral
local port it picks per connection; there is no shared listener, and nothing
outside Postico can use it.

**From Postico** (the entry client): as already configured. Nothing to change.

**From a shell, or for any scripted work:** go through the connector script,
which holds the address, port, user and key, and keeps its own known-hosts file.
It is not in this repository.

    ~/.claude/legdata-vps 'whoami'
    ~/.claude/legdata-vps 'sudo -u postgres psql -d legdata -c "SELECT ..."'
    ~/.claude/legdata-vps --scp local/file /remote/path

`ldadmin` has passwordless sudo, and `sudo -u postgres psql` connects by peer
authentication, so no database password is needed and none has to be stored on
the Mac. This is also how migrations are applied.

**Do not use the `legislativedata-vps` or `legislativedata-data` entries in
`~/.ssh/config`.** They are leftovers from the old estate; `legislativedata-vps`
points at `5.83.150.18`, a machine that was never part of this project, and it
will fail a host key check. The box is `77.90.2.83`, hostname
`legislativedata-SP`.

**The SSH rate limit bites you, not only attackers.** About a dozen connections
in quick succession produces `Connection refused` for roughly 15 seconds. Batch
work into few connections rather than one per command.
