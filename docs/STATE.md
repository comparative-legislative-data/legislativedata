# State

Updated: 2026-09-10

## Where we are

Session 1 is extracted, reconciled, fully coded and loaded into staging — 73
candidate rows, zero outstanding problems, none yet admitted to `bill`. The gateway is built: extraction proposes, review
admits. Nothing has been promoted, so `bill` is still empty.

The immediate work is the owner's: review the 73 rows. Both questions that were
blocking promotion are settled — see below.

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
  `timezone=UTC`, listening on localhost only. Reached over an SSH tunnel.
- Schema `db/001`-`db/007`: six `ref_*` vocabularies, seven sessions with dates
  still null, stage end dates on `bill`, party, per-field provenance.
- Postico 2 verified writing to the VPS, data and DDL.
- **`db/008` `bill_candidate`** — the staging table. Permissive by design: no
  foreign keys, almost nothing `NOT NULL`, so a bad parse lands as a row you can
  look at rather than as an import error. Strictness lives at promotion.
- **`db/009` `v_candidate_problems`** — one row per problem with a candidate.
  Work it to empty before promoting; anything left would be refused by `bill`.
- **`db/010`** — `procedure` nullable, default dropped.
- **`db/011` `methodology_note`** — seeded with M1 and M2.
- **`db/012` `bill_type_stated`** and `ref_bill_type_stated`.
- **`db/013`** — `date_concluded` on `bill`, and methodology note M3.
- **`db/014`** — `end_stage_1_date` on `bill_candidate`.
- **Session 1 fully coded.** 73 candidates, zero problems, all still
  `review_status = 'new'` and awaiting the owner's review.
- **`tools/extract_factsheet.py`** — the ruled-table format, sessions 1-5.
- **Session 1 loaded: 73 candidates, all `review_status = 'new'`.** Reconciled
  cell by cell against the factsheet's own cross-tab — 50/8/1/3 Acts,
  1/2/0/0 withdrawn, 0/6/2/0 fallen. `v_candidate_problems` is empty.

## Next

1. **Owner reviews the 73 Session 1 candidates** in Postico. Edit the typed
   columns, leave `raw_*` alone, set `review_status` to `accepted`.

       SELECT candidate_id, short_title, bill_type, bill_type_stated, outcome,
              enactment_status, date_introduced, end_stage_1_date,
              end_stage_3_date, date_concluded, date_royal_assent,
              raw_type, raw_introduced_by, parser_note, review_note
       FROM bill_candidate WHERE session_number = 1
       ORDER BY raw_section, short_title;

   All 73 rows are coded and `v_candidate_problems` is empty. The five bills
   SPICe listed as fallen without saying why were resolved from the Official
   Report — all five were rejected at Stage 1, not fallen at dissolution — and
   each carries its OR citation in `review_note`, to become a `field_source`
   row at promotion. The reconciliation against SPICe is unaffected: a bill
   rejected at Stage 1 is still a bill that fell, so their 8/3 split holds.

2. **Next session: pick up the owner's review comments**, then write the
   promotion script. Unblocked; both decisions are settled.
3. **Next session: load Session 2 into staging.** It already extracts clean —
   81 rows against a stated 81 — so it is the one remaining session that needs
   no parser work first.
4. **Fix table fragmentation for sessions 3, 4 and 5.** They extract short by
   2, 14 and 6 rows against their own stated totals. pdfplumber fragments tables
   that break across a page, so a data row is consumed as a header. Sessions 1
   and 2 reconcile exactly. Symptoms to fix by: `Clackmann- anshire Council`
   (unrejoined line-break hyphen) and a truncated `Trustees of`.
5. **Write the prose parser for sessions 6 and 7.** Different format entirely:
   `{Title} (SP Bill {n})` / `{Type} Bill introduced on {date} by {name} MSP.` /
   `Passed on {date}.`, with section headings carrying outcome and enactment.
6. Fill in the seven `session` rows. Session 1 is stated on page 1 of its own
   factsheet: **12 May 1999 - 31 March 2003**.
7. Then, and only then: front end, extraction from the API.

One staging table for all seven sessions, not one per session — the natural key
carries `session_number`, and cross-session questions (the `E`/`G`/`G*`
changeover) would otherwise need seven-way unions. Load one session at a time,
each gated on reconciliation.

## Settled at the close of this session

- **`date_concluded` is back on `bill`** (`db/013`), holding the withdrawn/fell
  date only. A `CHECK` keeps it null for a bill that passed, whose conclusion is
  `end_stage_3_date`. All 11 Session 1 candidates that need it have it.
- **Act titles are accepted in `short_title`**, published as methodology note M3.
  `bill_candidate.title_kind` records which rows carry an Act title and which a
  bill title.

Promotion is no longer blocked on a decision.

## Open, not yet decided

- **D2** — which date marks the completion of a stage. Still open, but narrower
  than it was. Five Session 1 bills now carry an `end_stage_1_date`, taken as the
  date of the decision that rejected them at Stage 1. That does not settle D2:
  for a bill *rejected* at Stage 1 the committee report, the chamber debate and
  the decision collapse onto one event, so all three candidate definitions agree.
  The question is still live for a bill that *passed* Stage 1, where they differ
  by weeks. D2 does not affect Stage 3 at all — the decision to pass a bill is
  the completion of Stage 3, which is what methodology note M2 says.
- **D3** — calendar days or sitting days. Does not block.

**D1, D4 and D5 are settled** — see `DECISIONS.md`.

See `VARIABLES.md` for the detail behind each. Note that VARIABLES §3.2 still
describes `procedure` as non-null and `date_outcome` as present; both have
changed. It needs a pass.

## Parked for phase 2

- **Splitting the introducer field** into person, body and capacity. One column
  currently holds four different things: a person; a person and a committee; a
  person and an office (`Colin Boyd Lord Advocate`); and an organisation
  (`Trustees of the National Galleries of Scotland`). Smaller than it looks —
  116 distinct strings across sessions 1-5, of which 93 are plain personal
  names and only 23 compound. From Session 3 SPICe uses a comma, so most split
  mechanically; the early undelimited ones are a short by-hand job.
  `raw_introduced_by` holds everything verbatim, so nothing is lost by waiting.
- **An MSP table with time-varying party affiliation**, from the API. The join
  is a temporal one: `msp_party_period(msp_id, party, valid_from, valid_to)`
  with a `daterange` and an `EXCLUDE USING gist` constraint so no member can
  hold two parties on one day, joined with `p.period @> b.date_introduced`.
  The identity problem, not the join, is the work. `bill_introducer` — bill,
  person, body, capacity — is both the split above and the link the join needs.
  Joining on `date_introduced` rather than `end_stage_3_date` is a judgement
  and would need its own methodology note.

## Connecting to the database

The server listens on `127.0.0.1` only; it is reached over an SSH tunnel.
Connection detail is in `~/.claude/legdata-db` (not in this repo).

DBeaver: on the **Main** tab, host `127.0.0.1`, port `5432`, database and
credentials from that file. On the **SSH** tab, enable the tunnel, host and user
from `~/.claude/legdata-vps`, authentication by public key using
`~/.ssh/legdata_ed25519`.

From a shell:

    ssh -N -L 15432:127.0.0.1:5432 -i ~/.ssh/legdata_ed25519 ldadmin@<vps>
    psql -h 127.0.0.1 -p 15432 -U legdata -d legdata
