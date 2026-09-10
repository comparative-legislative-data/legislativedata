# State

Updated: 2026-09-10

## Where we are

Project restarted 2026-09-09 after previous attempts were cleared. The repo holds
the PhD, VPS notes, and this scaffolding. No project data exists yet.

The first slice is agreed and **its schema exists on the VPS**. D1 and D4 are
settled (see `DECISIONS.md`); D2, D3 and D5 remain open but do not block entry.
No bills have been entered yet.

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
- PostgreSQL 17.11 installed on the VPS. Database `legdata`, role `legdata`,
  UTF-8, `timezone=UTC`, listening on localhost only.
- SSH tunnelling enabled and pinned to port 5432; tunnel tested end to end from
  this Mac. Port 5432 is not open in the firewall.
- Schema applied: `db/001_first_slice.sql`, `db/002_vocabularies.sql`,
  `db/003_slice_views.sql`. Six `ref_*` vocabularies seeded, seven sessions
  created with dates left null.
- Both slice views smoke-tested against a temporary bill, then rolled back.
- Stage end dates moved onto `bill`; `date_outcome` dropped; `party` added
  (`db/004`, `db/005`). `stage_event` is now unused and should probably go.
- Postico 2 installed and verified writing to the VPS, data and DDL.

## Next

1. Owner enters the first slice by hand from the SPICe factsheets, recording
   `source = 'spice_factsheet'`. Factsheets 6 and 7 are in `sources/factsheets/`;
   1–5 the owner is retrieving. Do not offer to parse them — see `DECISIONS.md`.
2. Fill in the seven `session` rows — first meeting and dissolution dates.
3. **D2 is deliberately deferred.** The first batch of data does not include
   stage dates, so the definition can be settled later without re-entry. Do not
   press for it — the owner will pick it up when the dates go in. When it is
   settled, record it here and in `DECISIONS.md`, and consider adding
   `stage_1_report_date` so committee scrutiny time stays separately visible.
4. Reconcile entered totals against the counts each factsheet states.
5. Then, and only then: front end, extraction.

## Open, not yet decided

- **D2** — which date marks the completion of a stage. Deferred by choice; the
  first batch carries no stage dates. Candidates: committee report published,
  chamber debate, or the decision that ended the stage (proposed).
- **D3** — calendar days or sitting days. Does not block: dates are stored
  either way, and sitting days needs a parliamentary calendar of its own.
- **D5** — how revisions to already-admitted data are recorded. Does not block:
  `observed_at` is on every row; append-only history can come before automation.

See `VARIABLES.md` for the detail behind each.

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
