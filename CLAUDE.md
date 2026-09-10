# legislativedata

A research resource for data about the Scottish Parliament. The goal is that a
researcher can download the raw data, download variables built from it, see it
visualised, and build their own tables and charts on the site without leaving it.

## Read this first, every session

1. `docs/STATE.md` — where the project actually is. Read before doing anything.
2. `docs/DECISIONS.md` — what has been settled, and why. Do not reopen these.
3. `docs/VARIABLES.md` — the variables in and around the current slice.

At the end of a session, update `STATE.md`, and add any decision that was
settled to `DECISIONS.md`. That is the whole handover mechanism.

## How this project works

**The database is the product.** Not the pipeline, not the API. The Scottish
Parliament's data looks programmatic and turns out not to be; four previous
attempts died inside that gap. The chain of variable → source → assessment →
edge case → gap → reconciliation is too long to hold in one piece, and anything
that tries to hold all of it at once implodes.

So the project is built out of short chains with a checkpoint at the end of each.

**Everything enters through a gateway.** Nothing is written as fact by any
process. A source — the API, an Official Report, a PDF, the PhD, a person's
knowledge — produces a *candidate*. The candidate is checked and admitted, or
not. This holds regardless of where the data came from, and it is why "build it
by hand" and "automate it" are the same architecture with a dial on it.

**Hand-build precedes automation, and is not a stopgap.** Building a slice by
hand produces the reference dataset and the list of real edge cases. Automation
is then judged by whether it reproduces that answer. If it cannot, it does not
ship.

**Build only what the current slice needs.** No speculative schema, no tables
for variables not yet defined, no extraction for sources not yet needed. The
slice is finished, then the next one is opened.

**Published data changes.** The Parliament states that historical records may be
revised, and they have been. Nothing is ever "loaded once and done"; a session
being closed does not make its data final.

## Working rules

- Ask before adding a source, a table, or a variable that the current slice does
  not require.
- Record provenance for anything admitted: what said so, and when it was seen.
- Where the PhD coded a value, it is the check on a derivation — not the source
  of the schema.
- Do not put host detail, credentials or connection strings in this repository.
  They live in `~/.claude/legdata-vps` and `~/.claude/legdata-db`.

## Infrastructure

VPS, database and backup arrangements are described in
`legdatavps/legdata-vps-notes.md`. Database connection procedure is in
`docs/STATE.md`.
