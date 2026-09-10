# State

Updated: 2026-09-10

## Where we are

Project restarted 2026-09-09 after previous attempts were cleared. The repo holds
the PhD, VPS notes, and this scaffolding. No project data exists yet.

The first slice is agreed. Its variables are proposed in `VARIABLES.md` and are
**awaiting review** — the open decisions in that document need settling before
any data is entered, because the hand-build will encode whatever is decided.

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

## Next

1. Settle the open decisions in `VARIABLES.md`.
2. Create the schema for exactly those variables.
3. Hand-build the two slices, recording edge cases as they are hit.
4. Then, and only then: entry system, front end, extraction.

## Open, not yet decided

- The outcome vocabulary, and whether outcome and enactment are separate.
- Which date marks the completion of a stage.
- Whether durations are calendar days or sitting days.
- How type and procedure (emergency, budget, consolidation) are separated.
- How revisions to already-admitted data are recorded.

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
