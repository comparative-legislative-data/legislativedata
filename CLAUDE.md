# legislativedata

A research resource for data about the Scottish Parliament. The goal is that a
researcher can download the raw data, download variables built from it, see it
visualised, and build their own tables and charts on the site without leaving it.

## Read this first, every session

1. `docs/DATA-DICTIONARY.md` — what every table and column is, in plain English.
   The single source of truth for what the database holds. **Generated from the
   database itself** by `tools/make_data_dictionary.py`; never edit it by hand.
2. `docs/STATE.md` — where the project actually is. Read before doing anything.
3. `docs/DECISIONS.md` — what has been settled, and why. Do not reopen these.
4. `docs/VARIABLES.md` — the reasoning behind the variables. Superseded by the
   data dictionary for anything factual about the current schema.

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
- **Every new table and column carries a `COMMENT` in the same migration that
  creates it.** One sentence, plain English, saying what it holds and what empty
  means. `tools/make_data_dictionary.py` refuses to run if anything is missing
  one. This is not tidiness: the owner is the check on every research claim this
  project makes, and cannot be that check for a column nobody described.
- **Stop and look at the whole after a couple of migrations.** Twenty-three
  schema changes were made on 2026-09-10, each individually justified, and the
  result was a database its owner could no longer explain. A good reason for one
  change is not evidence that the whole still makes sense.
- Record provenance for anything admitted: what said so, and when it was seen.
- Where the PhD coded a value, it is the check on a derivation — not the source
  of the schema.
- Do not put host detail, credentials or connection strings in this repository.
  They live in `~/.claude/legdata-vps` and `~/.claude/legdata-db`.

## Infrastructure

VPS, database and backup arrangements are described in
`legdatavps/legdata-vps-notes.md`. Database connection procedure is in
`docs/STATE.md`.
