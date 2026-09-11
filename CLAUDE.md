# legislativedata

A research resource for data about the Scottish Parliament. The goal is that a
researcher can download the raw data, download variables built from it, see it
visualised, and build their own tables and charts on the site without leaving it.

## Read this first, every session

1. `docs/HOW-THE-DATABASE-WORKS.md` — how the pieces fit together, written for
   the owner in spreadsheet terms. Read it before explaining anything about the
   database, and keep it true as the database changes.
2. `docs/DATA-DICTIONARY.md` — what every table and column is, in plain English.
   The single source of truth for what the database holds. **Generated from the
   database itself** by `tools/make_data_dictionary.py`; never edit it by hand.
3. `docs/STATE.md` — where the project actually is. Read before doing anything.
4. `docs/DECISIONS.md` — what has been settled, and why. Do not reopen these.
5. `docs/VARIABLES.md` — the reasoning behind the variables. Superseded by the
   data dictionary for anything factual about the current schema.

## Opening a session

The owner orients from the top of `STATE.md`, not from a status report. Every
session opens the same way:

1. **Give the owner the top of `STATE.md`**: the progress table and what the
   last session did, in plain words.
2. **Say what the sanity check found**, in a line or two, even if nothing.
3. **Then the task under "Now".**

**The sanity check, done before the first reply.** This project has a history
of tasks half done and not carried over. Check:
- that the table's counts match the database;
- that everything the last session left open or unbuilt is in `STATE.md`: read
  the last commit message and the newest `DECISIONS.md` entries;
- that `tools/make_data_dictionary.py` produces no difference from the
  committed dictionary;
- that nothing is left uncommitted;
- anything in the docs, these instructions or the memory that contradicts the
  database or each other.

If something needs a clean, propose it; do not start it.

## Closing a session

Update `STATE.md` in its shape, and add any decision that was settled to
`DECISIONS.md`. That is the whole handover mechanism.

- **Above the line in `STATE.md` is for the owner**, and stays about a screen.
  Update the table, add one short entry for the session, cut older entries to
  a line each, and rewrite "Now".
- **If it grows, cut; do not append.** Working detail goes below the line.
- **Record the sanity check** below the line, replacing the last one.

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

## Explaining the database to the owner

The owner is a legislation researcher and the authority on bills. They are a
beginner at running a database, by their own description, and they work in
spreadsheets. Four attempts at explaining how the tables interact failed, in
one session, for the same reason every time: jargon and length.

- **No SQL vocabulary in an explanation.** Not INSERT, UPDATE, SELECT, JOIN,
  foreign key, cascade, trigger, constraint, cardinality, normalisation. If a
  word only makes sense to someone who has used a database, it is the wrong
  word. The glossary in `HOW-THE-DATABASE-WORKS.md` §5 exists so those words
  can be looked up, not so they can be used.
- **Reach for the spreadsheet.** Tab, column, dropdown list, pivot table,
  lookup, empty cell. This is not simplification; it is accurate, and it is
  the vocabulary the owner already reasons fluently in.
- **Trace one real bill, start to finish, in the order things happen.** Not
  three abstract mechanisms and then an example. A named bill, what happens to
  it, what the database does on its own at each point.
- **Short. Then stop.** Every failed attempt ran over 300 words. Do not
  pre-empt the follow-up by covering it in advance — answering the unasked
  question is what produced the wall of text each time. Let them ask.
- **No ASCII diagrams with boxes and arrows.** They were tried and did not
  land.
- Talk about bills and factsheets, not about tables. Table names are for when
  the owner is looking at Postico and needs to find the thing; they are not
  the subject of a sentence.

## Working rules

- **Bring the testing plan; do not wait to be asked for it.** The owner should
  not have to suggest rehearsing a change, checking the result, undoing it and
  doing it again. Anything that writes to the clean data gets a written
  procedure and a rehearsal before it is trusted, and the procedure says what
  to look at, not only what to type. See `docs/PROMOTION-RUNBOOK.md` for the
  shape.
- Ask before adding a source, a table, or a variable that the current slice does
  not require.
- **A change to how data is coded is finished before anything moves on.** It is
  not settled until every part is settled, and not finished until every part is
  built:
  - what it records and its values;
  - which bills it applies to, and what an empty cell means;
  - where it sits on the clean sheet;
  - how it arrives on the staging sheet;
  - how promotion carries it, and its provenance;
  - what the error checker requires;
  - what the methodology note tells a reader;
  - every bill already coded under the old approach, rechecked;
  - when it is built, relative to any session it touches.

  Lay all of those out with a proposal for each, and get agreement on all of
  them before building anything. Until the whole thing is built, rehearsed and
  checked, no session it touches is admitted or promoted, and no new question
  is opened. "Not yet built" is not a state a decision may be left in, and
  never recommend deferring part of one to unblock something else. If it cannot
  be finished in the session, it is the first task of the next, stated at the
  top of `STATE.md`. Half-finished methodology is where the chaos comes from.
  This is not a race. See `DECISIONS.md`, 2026-09-11.
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
  They live in `~/.claude/legdata-vps`, `~/.claude/legdata-db` and
  `~/.claude/legdata-vps-notes.md`.

## Infrastructure

VPS, database and backup arrangements are described in
`~/.claude/legdata-vps-notes.md`, outside this repository. Database connection
procedure is in `docs/STATE.md`.
