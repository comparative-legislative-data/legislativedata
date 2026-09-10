# Decisions

Settled decisions, newest first. A decision here is not reopened without a
reason recorded as a new entry. Each says what was decided, when, and why —
the why matters more than the what, because it is what tells a later session
whether changed circumstances actually undermine the decision.

---

## 2026-09-10 — The database is the product; sources are candidates

Nothing is written as fact by any process. Every source produces a candidate
that is checked before admission, whatever the source. Automation, when it
comes, proposes rather than writes.

**Why:** previous attempts let extraction write directly, so an unbounded
residue of edge cases sat on the critical path. Under a gateway, partial
automation is still useful and failed automation costs nothing.

## 2026-09-10 — First slice: outcome by bill type, and time per stage

Across all sessions. Nothing else — no member in charge, party, votes or text.

**Why:** the minimum most users want, buildable by hand in about a day, and
therefore usable as the reference dataset that later automation must reproduce.

## 2026-09-10 — Hand-build before automation

The first slice is entered by hand. Automation is attempted afterwards and is
accepted only if it reproduces the hand-built values.

**Why:** the failure mode is chain length — variable to source to assessment to
edge cases to gaps to reconciliation, with no checkpoint. Hand-building produces
both a ground truth and a written list of the real edge cases, which converts an
open-ended judgement problem into a pass/fail one.

## 2026-09-10 — PostgreSQL on the VPS, reached over SSH

Data lives on the VPS from the start, not locally. Postgres 17 listens on
loopback only; clients tunnel in over SSH.

**Why:** starting on the server avoids a migration later and means there is one
copy of the truth. Loopback plus tunnel keeps port 5432 off the public internet
and leaves the existing firewall untouched.

## 2026-09-10 — SSH forwarding relaxed, pinned to the database port

`AllowTcpForwarding local` with `PermitOpen 127.0.0.1:5432`, replacing
`AllowTcpForwarding no`. Original config kept as `.pre-db-tunnel.bak`.

**Why:** DBeaver needs a tunnel, and the alternative — exposing 5432 through the
firewall — means a public database, TLS to configure, and a rule that breaks
whenever the client IP changes. `PermitOpen` means the relaxation reaches
Postgres on loopback and nothing else.

## 2026-09-10 — D1 settled: outcome and enactment are separate variables

`outcome` records what Parliament did; `enactment_status` records whether the
bill became an Act.

**Why:** passing and becoming law are different events, and the gap between them
is of research interest — a bill can pass and be referred, or pass and be
blocked from assent. A single combined list makes those cases unfindable and
turns "how many bills passed?" into a sum over several values.

**Reversing it:** a combined view over the two columns, or a generated column.
No data would need re-entering.

## 2026-09-10 — D4 settled: bill type and procedure are separate variables

`bill_type` is who introduced it; `procedure` is how it was handled.

**Why:** an emergency bill is a government bill that compressed its stages. In a
single list it stops counting as a government bill. This matters directly for
slice 2, where emergency and budget bills complete in days and would otherwise
distort every duration average.

**Reversing it:** `coalesce(nullif(procedure,'standard'), bill_type)` gives the
combined list as a view.

## 2026-09-10 — Vocabularies as lookup tables, not Postgres enums

Each controlled vocabulary is a `ref_*` table with a readable text code, and
columns carry the code as a foreign key.

**Why:** values can be read, added and re-labelled in the grid without writing
DDL, each value carries its own definition, and `bill.bill_type` displays
'government' rather than an integer that needs a join to interpret. Postgres
enums require `ALTER TYPE` and cannot drop a value.

## 2026-09-10 — Postico 2 as the entry client

Chosen over DBeaver, which stages grid edits behind an explicit save and caused
changes to appear made when they had not been sent.

**Why:** it writes on leaving a row, which is the spreadsheet behaviour wanted,
and it is a desktop client rather than another service to run and secure. Both
data and DDL changes were verified reaching the VPS independently.
