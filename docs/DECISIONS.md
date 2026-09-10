# Decisions

Settled decisions, newest first. A decision here is not reopened without a
reason recorded as a new entry. Each says what was decided, when, and why —
the why matters more than the what, because it is what tells a later session
whether changed circumstances actually undermine the decision.

---

## 2026-09-10 — `date_concluded` restored; Act titles accepted in `short_title`

Two questions raised by the Session 1 extraction, settled at the close of that
session. `db/013`.

**`date_concluded` returns to `bill`.** `db/004` dropped `date_outcome` on the
reasoning that for a bill that passed or was defeated the outcome date is the
Stage 3 date. That is true for the 62 Session 1 Acts and false for the other 11:
a bill that was withdrawn or fell has a date that is not a stage completion, and
it had nowhere to go. The new column is narrower than the one dropped — it holds
only that case, and a `CHECK` keeps it empty for a bill that passed, so it cannot
drift back into being a second, competing outcome date.

**`short_title` carries the Act title where a bill was enacted.** VARIABLES §3.2
defines it as the title as introduced, and for 62 of 73 Session 1 rows it is not.
Sourcing the introduced titles separately was rejected as disproportionate for
the first slice. Instead the divergence is published, as methodology note M3, and
`bill_candidate.title_kind` records which kind of title each row carried, so the
choice is visible per row rather than assumed.

**Why publish rather than fix:** a title, the styling of the bill type, and the
Session 4 `G*` marker are three instances of the same thing — a value that
differs between introduction and passage. The slice does not need any of them
resolved; it needs them not to be silent. VARIABLES §3.2 should be amended to
match.

## 2026-09-10 — Factsheet rows are extracted into staging and admitted by review

Amends, and does not reverse, the hand-entry decision below. Extraction writes to
`bill_candidate`; nothing reaches `bill` except by review and explicit promotion.

**Why:** the hand-entry decision gave three reasons. The first — that parsing
seven read-once documents costs more than reading them — is weakened: the
factsheets are Word-generated with a clean text layer, sessions 1-5 are ruled
tables and 6-7 a fixed prose grammar, and there are ~473 bills rather than a few
dozen. The second — that PDF extraction fails quietly — is answered here
specifically, because each factsheet prints its own outcome-by-type cross-tab,
so an extraction can be checked against the source's own arithmetic before
anyone reads a row. The third reason is untouched and is why this is an
amendment rather than a reversal: the factsheets are *derived*, the outcome
coding is SPICe's judgement, and reading it is how a divergence from the thesis
gets noticed. Under this decision the reading still happens, at the gateway, on
a populated row instead of an empty one.

**The gate has already earned itself.** Sessions 1 and 2 reconcile exactly.
Sessions 3, 4 and 5 come up short by 2, 14 and 6 rows, because pdfplumber
fragments tables that break across a page and a data row is consumed as a
header. None of it reached `bill`.

**Consequence:** `bill_candidate` is kept permanently, not cleaned out. It is the
provenance — `promoted_bill_id` ties every admitted bill to a page and to the
factsheet's verbatim words; it is how a reissued factsheet is diffed against what
was admitted; and it is the reference dataset automation is later measured
against. Rejected candidates stay, with `review_note` recording the judgement.

## 2026-09-10 — `procedure` is nullable; 'standard' is a finding, not a default

`bill.procedure` was `NOT NULL DEFAULT 'standard'`. Both dropped in `db/010`.

**Why:** no source consulted so far states procedure — the factsheets have no
such column. The default recorded four Budget Acts and the Mental Health (Public
Safety and Appeals) Act 1999 as standard procedure as a positive fact, on no
evidence. Null now means not known, and 'standard' is something established.
Same distinction `party` already draws between null and Independent.

## 2026-09-10 — The stated bill type is recorded alongside the normalised one

`bill.bill_type_stated` references a separate `ref_bill_type_stated`.

**Why:** researchers will want the Executive/Government split, and it is cheaper
to capture on the way past than to reconstruct. A separate lookup rather than
adding 'executive' to `ref_bill_type`, because a value in the research vocabulary
would appear in outcome-by-type cross-tabs and split the government series —
which is what D4 exists to prevent.

**It cannot be derived.** The changeover is not the 2007 renaming of the Scottish
Executive. The Session 4 factsheet marks bills `E`, `G` and `G*`, the last
footnoted 'Introduced as an Executive Bill (E)', for bills introduced in 2011 and
2012. Sessions 1-3 are `E` throughout, session 5 onward `G`. So the label follows
neither the session nor the introduction date, and has to be recorded as stated.
`bill_type_stated` means as introduced, so `G*` is 'executive'.

## 2026-09-10 — Methodology notes are data, not prose in the repository

`methodology_note` holds the text of each value judgement; the front end reads it
and shows it against the variables named in `applies_to`. The wording is seeded
by a migration, so it stays version-controlled.

**Why:** the two judgements in the first slice — counting Executive Bills as
Government Bills, and treating the date passed as Stage 3 completion — are both
defensible and both invisible in the numbers. A note kept only in the repository
drifts from what the site shows. `DECISIONS.md` records that a decision was taken
and why; `methodology_note` records what a reader of the data must be told. They
are different documents with different audiences.

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

## 2026-09-10 — Stage end dates live on the bill row

`date_outcome` dropped. `end_stage_1_date`, `end_stage_2_date`,
`end_stage_3_date` and `reconsideration_stage` added to `bill`. The duration
views read from these rather than from `stage_event`.

**Why:** a bill becomes one line to type, which is what a hand-build needs. The
outcome date was redundant once the stage dates exist — for a bill that passed
or was defeated it is the Stage 3 date.

**Consequence:** `stage_event` is now unused. It is left in place but empty, and
should be dropped unless a reason to keep it appears. Anything needing more than
a date per stage — committee, votes, amendments — is a later slice and would
justify bringing it back.

## 2026-09-10 — Party as a lookup, null distinct from independent

`bill.party` references `ref_party` and is nullable.

**Why:** null and Independent mean different things. Null is "not applicable or
not known" — which covers law officer bills, where no member is attached.
Independent is a positive fact about a member who sits without a party. A single
text field would blur the two on entry.

## 2026-09-10 — First-slice data entered by hand from the SPICe factsheets

Not parsed programmatically. `ref_source` gains `spice_factsheet`; rows taken
from a factsheet record it as their source, with session and retrieval date in
`source_ref`.

**Why:** parsing seven documents that are each read once costs more than reading
them, and PDF extraction fails quietly — a shifted column, a footnote absorbed
into a cell. It would rebuild the long unchecked chain the project exists to
avoid. The factsheets are also *derived*: the outcome-by-type coding is SPICe's
judgement, and reading it surfaces where it differs from the thesis where a
parser would silently adopt it.

**Where automation does belong:** reconciling entered totals against the
factsheet's own stated counts. Session 6 states 82 bills, 62 Government, 20
Member's, 52 Acts, 4 withdrawn as at 6 March 2026. Cheap arithmetic checks that
catch a mistyped row without re-reading the PDF.

**Evidence for the caution:** the factsheet path serves soft 404s — HTTP 200
with an HTML error page for files that do not exist. A first automated sweep
"found" seven factsheets; five were error pages.

## 2026-09-10 — Provenance per field, and D5 settled with it

`field_source` records the source of an individual field where it differs from
the row-level source. Append-only, with `value_seen` holding the value in the
source's own words.

**Why:** one source per row is insufficient — a bill's outcome will come from a
factsheet while its dates come from the Official Report, and that is the normal
case rather than the exception. `docs/VARIABLES.md` originally argued for
row-level only; that was wrong and has been rewritten.

**This settles D5.** Because the table is append-only, a revised published
record produces a second observation rather than overwriting the first, so the
change is visible. `v_field_revisions` lists fields whose value has changed.

**Not required for the first batch.** The row-level source remains the default
and is enough while a whole row comes from one factsheet. `field_source` is
there for when that stops being true.
