# legislativedata

A research resource for data about the Scottish Parliament. The goal is that a
researcher can download the raw data, download variables built from it, see it
visualised, and build their own tables and charts on the site without leaving it.

The arc is in `docs/PLAN.md`. Where we are in it is in `docs/STATE.md`.

## Read this first, every session

1. `docs/PLAN.md` — the phases, in order, and what each must deliver before the
   next opens. Read it before proposing any work, so the work is in the phase.
2. `docs/STATE.md` — where the project actually is. Read before doing anything.
3. `docs/DECISIONS.md` — what has been settled, and why. Do not reopen these.
   It opens with a generated contents page; read that rather than the file.
4. `docs/STANDING.md` — what holds whatever session is running: the owner's
   settled positions, what has been verified rather than assumed, and what was
   deliberately left undone with what would reopen it. Read it before proposing
   anything that sounds like a gap.
5. `docs/HOW-THE-DATABASE-WORKS.md` — how the pieces fit together, written for
   the owner in spreadsheet terms. Read it before explaining anything about the
   database, and keep it true as the database changes.
6. `docs/DATA-DICTIONARY.md` — what every table and column is, in plain English.
   The single source of truth for what the database holds. **Generated from the
   database itself** by `tools/make_data_dictionary.py`; never edit it by hand.

Looked up when needed, not read every session: `docs/VARIABLES.md` for the
reasoning behind the variables, `docs/PROMOTION-RUNBOOK.md` for loading and
promoting, `docs/CLOSURE-TESTS.md` for how a piece of work is closed.

## Opening a session

The owner orients from the top of `STATE.md`, not from a status report. Every
session opens the same way:

1. **Give the owner the top of `STATE.md`**: the progress table and what the
   last session did, in plain words.
2. **Say what the sanity check found**, in a line or two, even if nothing.
3. **Then the task under "Now".**

**The sanity check, done before the first reply.** This project has a history of
tasks half done and not carried over. The check asks one question — what would
be embarrassing to discover later — and what is on it changes as the work
changes. Items join it when a new kind of thing can go wrong, and leave it when
they stop being live. A check that has passed unchanged for a month is not
evidence of health; it is an item nobody reads.

Always:
- that everything the last session left open or unbuilt is in `STATE.md`: read
  the last commit message and the newest `DECISIONS.md` entries;
- that nothing is left uncommitted, and nothing left unpushed;
- that `tools/make_decisions_index.py` produces no difference from the committed
  contents block at the top of `DECISIONS.md`;
- anything in the docs, these instructions or the memory that contradicts the
  database, the plan, or each other.
- that every item under "Now" in `STATE.md` traces to an item in the open
  phase's build plan (for Phase 2, `docs/PHASE-2.md`, "The build plan"). If
  not, raise it before any work starts. A narrower plan standing in for the
  phase's own is how 17 September went wrong;
- that every database on the machine is sorted into a backup theme: the working
  database, or named in `ACCOUNTS_DATABASES` or `NOT_BACKED_UP` in
  `deploy/legdata-backup`. An unsorted one is kept ten years with the bills,
  which for a database about people breaks what the privacy page says.

While there is data:
- that the table's counts match the database;
- that `tools/make_data_dictionary.py` produces no difference from the committed
  dictionary.

If something needs a clean, propose it; do not start it.

## Closing a session

Update `STATE.md` in its shape, and add any decision that was settled to
`DECISIONS.md`. That is the whole handover mechanism.

- **Above the line in `STATE.md` is for the owner**, and stays about a screen.
  Update the table, add one short entry for the session, cut older entries to
  a line each, and rewrite "Now".
- **If it grows, cut; do not append.** Working detail goes below the line.
- **Record the sanity check** below the line, replacing the last one.
- **Push.** A session ends with the commits pushed, unless there is a reason not
  to, which is said out loud. The database is backed up nightly on the server;
  the migrations, tools and docs exist only on this machine until they are
  pushed, so an unpushed session is the one part of the work with no copy of it
  anywhere. Do not wait to be asked.
- **Then say whether it is safe to close**, and say it on the strength of
  checking rather than of remembering. Always: nothing uncommitted, nothing
  unpushed, `STATE.md` saying what is actually true, and anything the project
  runs still running. When the session touched data: the data dictionary
  regenerating identical to the committed file, the error checker and the gaps
  list read, the figures matching what `STATE.md` now says, and no working copy
  left inside the database. If something is not right, say what and leave it to
  the owner.

## How this project works

**The data is the product.** Not the pipeline, not the API, and not the site.
The site is how a researcher reaches the data and it has to be good, but it does
not become the point, and this stays true through every phase. The Scottish
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

**Build only what the current phase needs.** No speculative schema, no tables
for variables not yet defined, no speculative screens, no extraction for sources
not yet needed. The phase is finished, then the next one is opened.

**Published data changes.** The Parliament states that historical records may be
revised, and they have been. Nothing is ever "loaded once and done"; a session
being closed does not make its data final.

**Provenance reaches the reader.** Every figure published has a route back to
what said so, and to the decisions made in handling it. Our decisions do not
need to be correct; they need to be transparent enough that a user can accept
them or take the data and do something different.

## Explaining things to the owner

The owner is a legislation researcher and the authority on bills. They are a
beginner at running a database, by their own description, and they work in
spreadsheets. Four attempts at explaining how the tables interact failed, in
one session, for the same reason every time: jargon and length. The same rules
hold for explaining how the site runs, which has a jargon problem of its own.

- **No SQL vocabulary in an explanation.** Not INSERT, UPDATE, SELECT, JOIN,
  foreign key, cascade, trigger, constraint, cardinality, normalisation. If a
  word only makes sense to someone who has used a database, it is the wrong
  word. The glossary at the end of `HOW-THE-DATABASE-WORKS.md` exists so those words
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
- **The terminal is not a review surface.** Anything document-length goes in a
  file, with one line saying where it is. Verbatim in the conversation is for
  short public-facing wording only.

## Working rules

- **Bring the testing plan; do not wait to be asked for it.** The owner should
  not have to suggest rehearsing a change, checking the result, undoing it and
  doing it again. Anything that changes something other people depend on gets a
  written procedure and a rehearsal before it is trusted, and the procedure says
  what to look at, not only what to type. See `docs/PROMOTION-RUNBOOK.md` for
  the shape. A deploy is the site's version of a promotion and gets the same
  treatment, including the written undo.
- **Ask before adding.** A source, a table or a variable the current phase does
  not require; and equally a dependency, a service, or an account with somebody
  else.
- **Stop and look at the whole after a couple of changes.** Twenty-three schema
  changes were made on 2026-09-10, each individually justified, and the result
  was a database its owner could no longer explain. A good reason for one change
  is not evidence that the whole still makes sense, and this is not about
  schemas — it holds for any run of changes to how the thing is built.

## When the session touches data

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
- Record provenance for anything admitted: what said so, and when it was seen.
- Where the PhD coded a value, it is the check on a derivation — not the source
  of the schema.

## Credentials, and data about people

- **Nothing that unlocks anything goes in this repository.** Host detail,
  connection strings, keys, certificates, session secrets, anything a third
  party issues. They live in `~/.claude/legdata-vps`, `~/.claude/legdata-db`
  and `~/.claude/legdata-vps-notes.md`.
- **Real data about a real person does not leave the place it is held.** Once
  there are accounts, this project holds data about people for the first time.
  It goes in no commit message, no document, no test fixture and not into this
  conversation. Where an example is needed, invent one.

## Infrastructure

VPS, database and backup arrangements are described in
`~/.claude/legdata-vps-notes.md`, outside this repository. Database connection
procedure is in `docs/STATE.md`.
