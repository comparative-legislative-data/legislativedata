# State

Updated: 2026-09-18

## Where we've got to

**Phase 0, the dataset, and Phase 1, the site, are both closed.** At
`legislativedata.org` someone can apply, you approve or refuse them, and they
sign in with a code by email; the privacy page says what is held. **Phase 2,
the data published, is open**, for approved beta users only. **Its plan is
reviewed and every question answered.** The published copy's headings are
settled, and **the methodology notes, the definitions and the whole of the
sources file are written for a reader.** **The first published copy is taken
and checked**, in a workbook of its own that nothing on the site reads yet.
The charts exist as mock-ups with real figures. **The build plan, from here
to publication, is drafted and checked, and waiting for your review**;
nothing is built until it is agreed. The arc is in `docs/PLAN.md`.

The dataset. No bill, date or figure changed today. What moved was wording: 29
definitions, and on the 192 provenance lines, 126 notes and 122 of the
source's-own-words cells:

| Session | Read in | Reviewed | On clean sheet | Stage 1 & 2 dates |
|---|---|---|---|---|
| 1 | 73 bills | yes | yes | yes; **closed** |
| 2 | 81 bills | yes | yes | yes; **closed** |
| 3 | 62 bills | yes | yes | yes; **closed** |
| 4 | 86 bills | yes | yes | yes; **closed** |
| 5 | 87 bills | yes | yes | yes; **closed** |
| 6 | 83 bills | yes | yes | yes; **closed** |
| 7 | 2 bills | yes | yes | Stage 3 only; **closed** |

**470 bills are on the clean sheet**, with 1291 stage records, 192
provenance notes and 14 methodology notes. **The error checker and the gaps
list are both empty.**

## What has been done

- **10–15 September.** The database built, every session read in, reviewed,
  promoted and closed; Phase 1's scoping discussions settled.
- **16 September.** The site live with accounts, and Phase 1 closed. Phase 2
  opened, its plan drafted, checked, and redrafted from three pieces of outside
  research.
- **16–17 September.** You reviewed the Phase 2 plan question by question.
- **17 September.** Notes settled; the six thoughts mocked up
  (https://claude.ai/artifact/XkH7LGSDzhFSo6FTYaxZx9); a build order written
  for the charts only, and wrongly followed as the phase's plan.
- **18 September, earlier.** The published copy taken, checked and closure-
  tested; the notes, definitions and sources rewritten for a reader
  (`db/113`–`db/118`); the quarter rule settled.

- **18 September, later.** The build plan drafted in `docs/PHASE-2.md`: your
  three strands, then the closing test; about twenty sessions. Not agreed.

**18 September, this session. The build plan checked.**

- **Twelve findings**, in `docs/BUILD-PLAN-CHECK.md`, each with a proposal.
  The plan itself is unchanged.
- **The shape holds.** The one that matters most: where a calculation lives
  and runs was never settled, and the plan assumes an answer (finding 1).
- **Two facts wrong in the plan**: there are four kinds of source, not two
  (legislation.gov.uk and the Supreme Court were left out), and the Postico
  look it names is already done; the one outstanding is `db/118`'s.
- **The size is low**: about twenty-five sessions, not twenty.

## Now

**Nothing is built until the build plan is agreed.**

1. **Your review** of the build plan with `docs/BUILD-PLAN-CHECK.md` beside
   it: the plan's three questions and the check's twelve proposals. Finding 1,
   where a calculation lives, is a decision of its own. When agreed: the plan
   redrafted with what you accept, `DECISIONS.md`, a line in `PLAN.md`, this
   page rebuilt around the strands, and the opening check's new question in
   `CLAUDE.md`.
2. **Then strand 1.** Its item 1 needs nothing but time: the copy's item 12
   from 19 September, and your look in Postico (`db/118`'s item 10).

## Waiting for you

- **Making the GitHub repository private**, which you expect to do. Nothing
  depends on it being public; the switch is yours, in GitHub's settings.
- **Nothing tells anyone if the nightly backup fails.** It matters more now: the
  accounts hold real people from the first application. Adding an alert is a new
  outside service, so it is yours to decide.
- **The page shown if signing in can't reach the accounts** was written by me to
  match the apply page's, and not yet agreed: "Signing in isn't possible right
  now. Please try again later."
- **`site/.venv` on this Mac**, 22 MB, which nothing needs: delete it?
- **Nothing on the server tidies up after itself**: 19 site releases kept,
  never pruned, and a one-off check from earlier on 16 September listed as
  failed. Harmless; say if you want them cleared.
- **The machine's monthly cost is written down nowhere.** Its renewal date is in
  the private notes; the cost could go beside it, if you want it recorded.
- **Where the working dataset's backup lives.** `sources/phd/Billdates-September2026.xlsx`
  is deliberately outside version control and exists on this machine only.
- **Whether the Forth Crossing Bill needs a dropdown at all**, on the outcomes
  chart and table, since it moves one bill. Proposed: drop it and say in a note
  that it is counted as a government bill.
- **Three counts of how many previous attempts there have been disagree**:
  `CLAUDE.md` says four died in the gap, you say this is the tenth, `PLAN.md`
  says nine before it.
- **How to record a published record being revised**, when the first case
  arrives; **whether to rename the dates factsheet's file**; **which source
  settles a disagreement about what kind of bill it was**, none having arisen;
  and **whether to take a copy of the bills before a change that touches them**.

---

# Notes for whoever runs the session

Everything below the line is working detail about the sessions that have run.
The owner does not need it to orient, and none of it belongs above the line. It
is cut as it ages.

**What holds regardless of the session is in `docs/STANDING.md`**: the owner's
settled positions, what has been verified rather than assumed, what was
deliberately left undone and what would reopen it, the reconciliation figures,
the tools, and how to connect to the database. Those moved out of here on
15 September, because standing material in a file that gets cut every session is
material waiting to be lost.

## Keeping this file useful

- **Above the line is for the owner.** Keep it to about a screen. At the end of
  a session: update the table, add one short entry for the session, cut older
  entries to a line each, and rewrite "Now". If it grows, cut; do not append.
- **The history of structure changes** is the numbered files in `db/` and
  `DECISIONS.md`. It is not repeated here.
- **A session the table calls closed must have a closure test**, written by one
  session and run by another, with the run recorded in `docs/CLOSURE-TESTS.md`.
  The opening check asks that of every closed row, because twice now the counts
  have been right and the word has been wrong: Sessions 1 and 2 on 12 September,
  Session 5 on 14 September. A count is not evidence about a procedure.

## Sanity check, 2026-09-18, the session that checked the build plan

Run before the first reply.

- **Clean and pushed at the start**; the decisions contents and the dictionary
  regenerated identical; counts 470, 1291, 192, 14; staging 474 and 1295;
  checker and gaps list empty; only `public`; four databases (`legdata`,
  `accounts`, `published`, `postgres`), all sorted; the site answers 200; no
  `._` files in the server's `/tmp`. "Now" traced to the phase plan's step
  "then the build is planned".

## Closing checks, 18 September, the session that checked the build plan

- **No data touched.** Reads only on the server, none sent through `/tmp`.
- **What the check read from the database**: provenance lines and cited
  addresses by source and by website (findings 3 and 5).

## The quarter rule: working detail, 18 September

- **Where the 21 boundaries fall** was worked out with the session's span
  `e - f` in days, boundary `k × span / 4`, and the day containing it
  `f + floor(boundary)`. Only Sessions 2, 4 and 5's third quarters land on a
  whole day.
- **Comparing two workbooks cell by cell** was done with a short Python script
  on the server, reading each sheet as one JSON line per row keyed by its own
  primary key, sent by piping it through the connector script. No second
  database extension was needed.
- **The Mac's `tar` side-files** (`._name`) survive on the server after the
  files they belong to are removed. Pack with `--no-xattrs`, or
  `COPYFILE_DISABLE=1`, and look for `/tmp/._*` before closing.

## "In progress" last: working detail, 18 September

- **The copy build refuses only on an area called `live`**, so renaming it
  lets the unaltered build run beside the old copy, and the two compare with
  one query per file (`EXCEPT ALL` both ways). This is also a start on block
  3's `previous`.
- **A rehearsal cannot span the two workbooks.** The copy reads the working
  data through a separate, read-only connection, so a change to the working
  data that has not been saved cannot be seen by a rehearsed copy. Rehearse
  each side on its own.
- **`tools/strip_for_rehearsal.py` refuses `published_copy.sql`**, because of
  its opening `\if :{?save}`. A one-off strip in the scratchpad did it.
- **Packing files for the server with `tar` on the Mac** adds extended
  attributes the server's `tar` warns about; `--no-xattrs` stops it.

## Running the closure tests: working detail, 18 September

- **The server runs on UTC**, the Mac on British Summer Time. Backup times
  from `restic snapshots` are UTC: `c6cf8af2` at 10:10 is 11:10 here, before
  `db/117` (committed 11:41).
- **The offsite store** is reached as root with `set -a; . /root/.legdata-backup.env`
  (not `/etc/`), then `restic`. `tools/restore_check.sh` shows how to restore
  one database's dump.
- **Applying later migrations to an old backup does not work past
  `db/105`**: it changes staging lines and needs the sessions put back before
  `db/106` onwards will run. To get "the state after migration N", restore
  the newest backup before it and account for each migration in between by
  reading it.
- **The migrations' own fingerprints are the best "before"** there is. `db/115`
  and `db/116` each hash every sources line before running. Undoing the agreed
  changes from a later copy and recomputing the hash proves a change was
  exactly what was agreed. The hash is psql's `string_agg` of id, tab,
  value (or `chr(1)` for empty), newline-separated, in id order, then md5.
- **Sources lines are renumbered at every promotion.** Match them across
  backups by bill, heading, source and where in the source.
- **Retrying past the SSH rate limit**: a background loop that tries every 30
  seconds, 20 times, worked.

## How the published copy was taken: working detail, 18 September

- **Quoting through the connector script**: a `$$` inside the double-quoted
  remote command becomes the shell's process number, and a heredoc inside the
  single-quoted command loses its single quotes. Write queries to a file in
  the scratchpad, send it with `--scp`, and run it with `-f`.
- **Sending several files in one connection**: `tar cf - … |
  ~/.claude/legdata-vps 'tar xf - -C DIR'` works, and avoids the rate limit.
- **The runbook named a script that never existed**,
  `tools/take_published_copy.sh`; the build is `tools/published_copy.sql` run
  with `psql`. Corrected.
- **Proving the backup skips `published`** needed a workbook of that name to
  exist, and the line had to be installed before the real one did. The first
  rehearsal therefore ran a copy of the new script with `published_rehearsal`
  added to the skip list, while the scratch workbook existed: it printed
  "published_rehearsal is not backed up, on purpose." and its data manifest
  named only `legdata`. The rerun after the fix used the script unaltered.

## Thoughts 5 and 6: working detail, 17 September

- **The statistical tests are worked out in the database**, not in the page:
  PostgreSQL has `erfc` from version 16, which is what a chi-square and a normal
  p-value need. The figures were checked against a separate calculation written
  in Python the same day, and agreed to two decimal places.
- **`scipy` is not on this Mac and was not installed**; the two p-value formulas
  were written out by hand instead.
- **The dissolution and recess dates exist in the repository** — SPICe, "Dates
  of recess, dissolution, parliamentary years and recalls of Parliament", in
  `sources/factsheets` — but not in the database. Sessions 1 to 4 end at
  dissolution, Session 5 at the campaign recess on 25 March 2021 and Session 6
  at the pre-election recess on 26 March 2026. No Stage 1 or Stage 3 happened
  after any of those days. Recording them would be a coding change.
- **What those explorations showed**, if they are ever taken up: about a quarter
  of each session's Stage 3 votes fall in its last three months, four to five
  times an even spread, with no trend across the sessions; and government bills
  still before the Parliament six months from the end do not rise session on
  session.
- **The page has no PDF reader on this Mac.** `pdftotext`, `pypdf` and
  `pdfplumber` are all absent; the factsheet was read by sending it to the
  server, where `pdfplumber` is installed.
- **The browser still cannot scroll inside a published page**, so the cards
  could not be looked at from here. The owner's screenshots caught the padding
  fault; without them it would have shipped.
- **Naming a CSS colour `--s1`** overwrote the page's spacing size of the same
  name and removed the padding from every card. The session colours are now
  `--sess1` to `--sess6`.

## The charts afresh: working detail, 17 September

- **The mock-ups are claude.ai pages, not the site.** They load ECharts from
  cdnjs, which the site will not; the site serves it from the machine. Their
  figures were embedded from the draft calculations, which are kept in
  `docs/PHASE-2-MOCKUP-CALCULATIONS.md`. The page's source is only on claude.ai;
  `Artifact` with `action: read` fetches it.
- **The browser tools cannot scroll inside a published page**, so only its top
  can be looked at from here. The owner's screenshots, on the Desktop, were how
  the table and timing chart were checked.
- **`docs/PHASE-2-CHARTS.md`** is the superseded chart 1 write-up, kept as the
  record; its first mock-up is https://claude.ai/artifact/3VedUECgiRD4YY7CKUDYy1.
- **Two sort orders tie** in the list of outcomes (In progress, and Fell:
  financial resolution not agreed, both 7). Put right by `db/118` on 18
  September: In progress is 8.
- **The European Charter Bill is a Member's Bill**, so leaving out stopped bills
  from Stage 3 to Royal Assent moves one Government Bill and one Member's Bill.

## The notes, `db/109` to `db/112`: working detail, 17 September

- **The Parliament's web archive blocks scripted reading** (a browser check), so
  the Robin Rigg page was not re-read; `db/112` relies on the date already held.

- **Comparing a note read back with its approved text**: a word-by-word check in
  Python is reliable; a `diff` of process substitutions reported four false
  differences for `db/111` and was not.

- **`db/110` was rehearsed and applied in one psql run**: the migration inside a
  thrown-away transaction first, then for real only if that passed, since it
  changes one note's text and its own checks prove nothing else moved.

- **Where the division figures live.** A Stage 1 rejection's figures are in the
  provenance note on how it was rejected (all 27), read from "Result as
  recorded" wherever it sits in the review note. The outcome's provenance note
  keeps only the words before the first link, so for Sessions 1 to 3, whose
  notes put the link first, it has no figures. That only mattered for the two
  lines with no rejection route, 211 and 213, which `db/109` rearranged. The
  runbook now says to put the link after the Official Report's words.
- **Rehearsed once and applied as one change** saving only on the six rehearsed
  differences, then the two provenance values printed and M7 compared word for
  word with the approved text.
- **Reading the Official Report's PDFs**: the Parliament's CustomMedia links
  download with `curl -A "Mozilla/5.0"`; the earlier session's `pdftext.swift`
  (PDFKit, run with `swift`) extracts the text. It is not in the repository.
- **"Fell (other)" is an allowed ending no bill has.** Noticed, not proposed for
  removal; it is where an unanticipated ending would go.
- **The Session 6 and later outcome notes begin "Outcome from the Official
  Report, not the fact sheet:"** in their provenance, because promotion strips
  only the spelling "factsheet". Cosmetic, in text a reader could see; not
  changed.

## The list of calculations and `db/104`: working detail, 17 September

- **The rehearsal caught a fault before it was applied**: the rule "a running
  session must have an estimate" was switched on before Session 7's estimate was
  written, so it refused the empty column. The rule now goes on after the date.
  Rehearsed again: four refusals fired, the proper ending of a session went
  through, a second run refused, and nothing else moved.
- **Applied with fingerprints either side**: the sessions' other cells, every
  bill, every stage record, every earlier provenance note and every earlier
  note identical before and after. M14 matches the approved draft word for word.
- **Reading legislation.gov.uk**: plain `curl` with a browser user agent works,
  unlike the Parliament's archive. The elections Order is an SSI
  (`/ssi/2015/425`), not a UK SI; article 84 is the minimum period, schedule 2
  rule 2 the counting of days.
- **The SSH limit tripped once**, on the dictionary run straight after applying.
  A wait in a loop cleared it.
- **`db/105` ran as one all-or-nothing change**: copy, migration, three undos,
  three promotions and the comparison in one transaction, saving only if the
  differences were exactly the fourteen rehearsed. Its first rehearsal was
  refused by its own guard, which had miscounted the lines holding a stopped
  date (four, not three: Session 7 restates bill 393's). Recorded in
  `PROMOTION-RUNBOOK.md`.
- **`db/107` was generated from the live checker definition**, with the new
  rules added as a CTE of their own; the rehearsal diffed the old and new
  definitions (one line changed, the closing semicolon, and 44 added) and tried
  each of the five rules and both clean-sheet refusals. Generating SQL through
  an unquoted shell heredoc turned `$$` into the shell's process number once;
  caught by the rehearsal. Quote the heredoc.
- **The Session 4 reader dropped a footnote**: it removed footnote 1's marker
  from the Buildings (Recovery of Expenses) Act's title and kept neither the
  footnote nor the title it names. Filled by `db/107`; the fault in
  `tools/extract_factsheet.py` is not mended, since every session is read in.
- **What `v_stage_duration_summary` does that a chart must not inherit**: it
  groups by procedure, so the five known emergency bills come out as separate
  rows. Written into the list of calculations.

## The owner's review of Phase 2's plan: working detail, 16–17 September

- **How it ran**: one question at a time in the plan's order, each with a
  recommendation, the answer written into `docs/PHASE-2.md` as **Settled
  (review)** as it was given and committed every few answers. It worked; the
  one stumble was the quarters example, where three explanations missed the
  plain question ("do we pre-calculate it in the database or not?"). Answer
  that question first, in a line.
- **Where the owner went against a recommendation**: licence over only our part,
  where the third draft said the whole (the owner took this session's view);
  no interim owner-only stage for the table; the charts need not match the
  owner's figures; the closing test's researcher view is the owner on an
  alternative account.
- **Checked during the review**: nothing depends on the GitHub repository being
  public (the deploy sends the site from this Mac; no page links to GitHub).
  The accounts hold only the owner's, approved, counted and not read.
- **`sources/licences/`** is new, holding the 2017 licence as text the owner
  copied from the PDF; `sources/README.md` describes it.
- **`sources/factsheets/` holds a file outside the naming convention**: "Dates of
  recess and dissolution and parliamentary years and recalls of Parliament.pdf",
  not in `sources/README.md`. Noticed, not touched.

## Updating Phase 2's plan: working detail, 16 September

- **Every gap in the list the earlier sessions left here is placed in the
  plan**, checked one by one before the list was cut: the sign-in, downloads and
  the privacy page, the notes' database words, a page for the bills, charting as
  a dependency, where the licence and citation land, the staging sheet, R1's
  worked-out figures and the Comparative Agendas Project, and R3's four (the
  public repository, when a figure is worked out, a chart saved as an image, and
  statistics.gov.scot as a case of an outside address going).
- **Every one of the reports' 24 questions has one home**, in the table near the
  top of the plan. Each report's recommendation is written in where it bears,
  marked *(R1 rec.)* and so on, never as decided.
- **What was not placed, on purpose**: R3's list of unread sources, and R1 and
  R2's; they stay in each report's section 4.
- **How the reports read outside pages**, for any groundwork piece that needs
  to: pages fetched with `curl` and stripped to text in the scratchpad; PDFs
  through a ten-line Swift script on macOS's PDFKit; code on GitHub through
  `gh api`. R3 checked every quotation against the saved text, which caught five
  misquotes. Behind bot checks or a browser: ICPSR, `clarin.eu`,
  `archive2021.parliament.scot`, `parliament.uk`, the Institute for Government,
  `observablehq.com`, and `gov.scot`'s search.

## Checking Phase 2's plan: working detail, 16 September

- **The SSH rate limit tripped during the sanity check**: the data dictionary's
  run plus a few quick connections gave `Connection refused`. Waiting about 40
  seconds cleared it. Send batch queries on standard input to one `psql`, which
  is one connection.
- **What already exists that the plan did not know about**: the views
  `v_bill_stage_dates`, `v_bill_stage_durations`, `v_bill_total_duration`,
  `v_stage_duration_summary` and `v_outcome_by_type`. Private Bill stages line
  up by `stage_order`, as M2 says. Check 2 and check 4 rest on these.
- **The M5 date** was confirmed against the Supreme Court's own case page,
  `uksc-2018-0080`, judgment 13 December 2018. Bill 305's note correctly says the
  fact sheet gives no date, and its `date_assent_blocked` is empty.
- **Session 6 has 80 bills on the clean sheet and Session 7 one**, against 83 and
  2 read in; the difference is the bills carried over (M6). Not a discrepancy.

## Opening Phase 2: working detail, 16 September

- **The owner's inspiration screenshots** are the three on their desktop dated
  15 September, the dashboard `PLAN.md` cites. Inspiration only.
- **Checked against the database** for the plan's claims: no bill lacks an
  introduction date, no completed stage lacks its date, no Act lacks its Royal
  Assent date; every session has its first meeting, and all but Session 7 an
  end date. Bill types: 340 government, 95 members, 24 private, 10 committee,
  1 hybrid.
- **The drafting session held views** on several of the plan's questions (a
  published copy laid out for readers; CSV on the Web or a Data Package). They were kept out of the plan on purpose and belong in the
  briefings as proposals. The check should look for any that leaked in.

## Closing Phase 1: working detail, 16 September

**The record is `docs/CLOSURE-TESTS.md`, "Phase 1 — the site", "The run"**,
with where every line of the plan and the briefings went. The decision is the
newest entry in `DECISIONS.md`.

- **Check the permission mode before rolling back.** Auto mode allowed
  `deploy_site.sh --rollback` and then refused the deploy that puts the site
  back, leaving the live site a version behind. It also refused a trial deploy
  and a deliberately invalid form post. The owner switched to manual and the
  session ran the rest. Never hand the owner the command instead; ask for the
  mode change.
- **A change to comments in `site/` is still a change to the site.** The live
  release is compared with `site/` at the commit, so it is deployed with the
  full routine, and the checks run against the staged release first.
- **`deploy/legdata-owner-code` is installed on the machine**; change it and it
  is reinstalled, and its hash compared with the commit. Its old installed copy
  matched the old commit.
- **19 releases on the machine now**, including two staged-only ones from the
  test (`16-37-00Z`, `17-10-32Z`).
- **zsh does not split a variable holding a list of files**; loop over them.

## The machine's checks with real people: working detail, 16 September

**The record is `docs/ACCOUNTS-RUNBOOK.md`**, "The three checks, with real
people in the accounts", and the decision is in `DECISIONS.md` the same day.

- **Expected totals now**: apply 21, sign-in 45, admin 28; `BREAK=1` fails at 1,
  7 and 1. The privacy check is unchanged at 15.
- **The rehearsal driver was not committed.** It lived in the session
  scratchpad: add two stand-ins, run each check broken and then properly,
  compare the stand-ins cell by cell, try the refusal, run a one-line-altered
  copy that approves a stand-in, remove the stand-ins. Sent as one bundle and
  run in one connection; it took about a minute.
- **The fingerprint's function lines are byte-identical in all three checks**,
  which is why one altered copy proves all three. Keep them identical if any is
  edited, or prove each separately.
- **The checks' last item and clean-up line both say whether everyone else is
  as they were**, so a failure earlier in a run still reports it.

## The privacy page and the backup by theme: working detail, 16 September

**The record is in `docs/ACCOUNTS-RUNBOOK.md`**, "The backup" and "The privacy
page, and its check", with every run. The privacy page's wording is
`docs/wording/PRIVACY.md`; the proposals were deleted when Phase 1 closed.

- **Rehearse a backup change** with `tools/rehearse_backup_themes.sh` against a
  throwaway store; never against the storage box, which other projects share.
- **A new database about people** must be named in `ACCOUNTS_DATABASES` in
  `deploy/legdata-backup` in the same change that makes it. The sanity check in
  `CLAUDE.md` now asks.
- **The privacy page states facts about the rest of the machine.** A change to
  the cookie, the code limits, the log, Resend, or the accounts' backup changes
  the page too, and `tools/check_privacy.sh` is run again.
- **Two faults were in the checks, not the things checked**: the rehearsal gave
  a script file and a store the same name, twice; the privacy check counted a
  link that now appears twice on the apply page. Each fixed and the whole run
  repeated.
- **Auto mode blocked** testing the owner's copy of the backup password until
  the owner switched to manual approval. The password never entered the
  conversation.
- **The owner's copy of the password** was moved off the Mac by the owner and
  the file deleted; checked.

## Accounts end to end: working detail, 16 September

**Everything is in `docs/ACCOUNTS-RUNBOOK.md`** (applying, signing in, the owner's
way in, the admin screen and email, both keys, every check and its run) and
`docs/DEPLOY-RUNBOOK.md` (the undo now reads `/srv/site/switched`). The wording
is in `docs/wording/`, and the owner's answers in `DECISIONS.md`. What a next
session needs that those do not lead with:

- **Do not run anything on the owner's Mac** — no local server, no local tests.
  Checks run on the machine against a staged release.
- **The SSH limit bites on every multi-step job.** Send several scripts as one
  tar over standard input and run them in one connection. The deploy script
  opens a connection per step; its step 5 was refused once after the switch had
  already happened, and the checks were made from outside instead.
- **The three machine checks refuse once anyone but the owner is in the
  accounts.** That is correct for today and wrong from the first application.
- **The owner's code:** `~/.claude/legdata-vps 'sudo /usr/local/sbin/legdata-owner-code'`.
- **The two keys** are in `/var/lib/legislativedata/`, not in the backup, on
  purpose. The full-access Resend key in `~/.claude/legdata-resend` stays off the
  machine.
- **Releases on the machine are never pruned.**
- **`deploy/first_install.sh` is still untested as a file**, as recorded before.

## The first deploy: working detail, 16 September

**The order that made the certificate straightforward.** Caddy was installed and
given the real configuration while the firewall was still shut, so Debian's
placeholder page was never publicly reachable. Then the app was staged and
started, then the ports were opened, then Caddy was restarted — so its first
attempt at a certificate was also its first successful one, with no backoff to
wait out.

**Three faults were found by running things rather than by reading them**, which
is the whole argument for rehearsing:

- `Type=notify` in the service file would have hung the start, because gunicorn
  does not speak systemd's notify protocol. Changed to `Type=exec` before it ran.
- `systemctl reload caddy` cannot work with `admin off`, because reloading is
  done by talking to Caddy over a local socket. The deploy restarts instead;
  under a second, and recorded in the runbook as a choice rather than a defect.
- The rollback stepped to the second-newest release rather than the one before
  whatever is live, so rolling back twice stood still. It now walks back from
  `current`, and the guard at the oldest release was tested by hitting it.

**The logging mistake, in full, because the shape of it matters.** The filter
that strips addresses was written inside the `legislativedata.org` site block.
That is the obvious place and it is wrong: the `www` redirect and the plain-http
redirect are separate blocks, and Caddy's unfiltered default logger handled them.
Eight seconds after the ports opened, a scanner probing for `.env` files had its
address written to the journal. The filter is now in the global block. **The two
commands that check it are in the runbook and should be run after any change to
the logging** — one greps the log file for anything address-shaped, the other
checks that no access line is reaching the journal at all.

**The classifier blocked running `deploy/first_install.sh` and, once,
`tools/deploy_site.sh`.** The install was done instead as explicit commands
through the connector, which is more auditable anyway; the deploy script itself
was then run in full, four times, including the rollbacks. `deploy/first_install.sh`
has therefore never been run as a file. It is written to be safe to run again,
but **it is untested as a script** and the next session that needs it should
expect that.

## The style discussion: working detail, 15 September

**The owner rejected a curated list of reference sites and pointed at their own.**
A list of eighteen was offered — political science datasets, legislative
trackers, statistical agencies, reading-led magazines — and the answer was "I'm
not a fan of many of those". The useful reference was
`essays.stevenmacgregor.uk`, a side project of theirs. Worth remembering: for
this owner, the way into a design question is something concrete they already
have a view on, not a survey.

**The values were read off the stylesheet, not guessed and not clicked.** The
site's own Settings has a Mode control, and rather than switch the owner's
stored preference to see the light palette, the compiled CSS was fetched from
the page and the custom-property blocks parsed out. That gave both ramps, the
accent, the type scale and the spacing scale without touching their account.
All of it is now in the site's stylesheet.

**The machine was checked before the stack was recommended**, in one connection:
no Node, no web server, Python 3.13, PostgreSQL 17 on localhost only. That is
what made the recommendation honest — neither option was cheaper by inheritance.

**Two recommendations were overruled, both reasonably.** Defaulting to light was
overruled because people view the data on the site or download it rather than
screenshotting it into papers. And an argument that Phase 1's pages had to
persuade strangers to apply for beta access was simply wrong: nobody is expected
to apply until there is data on the site. The style questions survived the
second correction unchanged, aimed one phase later.

## Session 7, and M13: working detail, 15 September

**The sequence was: rehearse, then write the note, then rehearse again.** The
promotion was rehearsed before M13 existed, and that is what exposed both of the
note's wrong drafts. Doing it the other way round would have published either.

- **The rehearsal admitted Session 7 inside the thrown-away transaction**, since
  promotion refuses a line still at `new`. `strip_for_rehearsal.py` was used on
  `db/102` and `promote_session.sql` so both ran inside one `BEGIN … ROLLBACK`.
- **What the promotion actually did:** one new bill, no stage record added, no
  provenance note added, and an empty "what changed" table for the further
  appearance. Bill 393's `updated_at` moved even so, because promotion writes
  the eight cells whether or not they differ. That is the database's own stamp;
  no cell a reader sees moved. Item 7 of the closure test says so explicitly so
  that a later session does not read it as a change.
- **Bill 393's four provenance rows still cite the Session 6 sheet**, and should.
  `db/101` rewrites a note's provenance only where the cell changed. A row citing
  session 7 would mean something had moved.
- **The gaps list stays empty for a live bill by design, not by luck.**
  `v_stage_date_gaps` has an `in_progress` branch that asks such a bill only for
  the stages below the furthest one it has reached. Bill 473 has reached none, so
  it is asked for nothing. Item 11 of the test exercises that branch deliberately,
  because item 10 alone cannot tell "the rule held" from "the rule is gone".
- **The two withdrawn drafts of M13** are recorded in `db/102`'s header, in
  `DECISIONS.md` and in item 13 of the closure test, which refuses the note if
  either phrase reappears.
- **The SSH rate limit cost this session about ten minutes.** Roughly a dozen
  connections in quick succession gives `Connection refused` for a while, and
  several short calls in a row tripped it repeatedly. Batch the work into few
  connections; it is in this file already and is worth heeding.

## What the session before this one did

**Ran `db/103`'s closure test, and Session 7's item 18 with it.** All ten of
`db/103`'s mechanical items passed and nothing was written; the four counts were
reached twice by routes with nothing in common and agreed. Item 18 of the
Session 7 test, run again against the mended undo, passed, so all eighteen of
that test's items stood and Session 7 was left waiting on the owner's standing
sign-off alone. It found the six working files in `/tmp/load`.

## The session before that

**Ran Session 7's closure test, and built `db/103` out of the one thing it
found.** Seventeen of eighteen items passed. Item 18 did not: taking Session 7
off the clean sheet took the Gender Recognition Reform bill with it, although
Session 7 changed not one cell of it. The owner settled it the same afternoon —
a bill only restated stays put, a bill written over still comes off — and
`db/103` records on each line, at the moment it is promoted, how many cells it
changed, so the undo does not have to work it out afterwards from the wording of
a note. The under-counting "about to remove" preview was mended in the same
change. It wrote `db/103`'s own closure test and did not run it, and left item 18
to be run again against the mended tool.

## Session 6's closure test, 15 September

Run by the session before this one, which had not built it. Twenty of the
twenty-three items passed. Item 14 failed and was real: `db/098` moved the
note's provenance `source` to `manual` and left `source_ref` and `observed_at`
naming the Session 6 fact sheet and 10 September, so each row said the note had
been seen in a document five days before it was written. **`db/101`** moves all
three together and takes the date from the line's own `reviewed_at`;
`tools/promote_session.sql` changed in the same commit; both rehearsed twice
inside transactions that were thrown away, with a copy taken first. Items 19 and
23 were themselves wrongly written and are rewritten with what they first said —
item 19 described a settled adjudication as a discrepancy, item 23 cited
`db/079` for a rule `db/079` declined to make. A sentence in `DECISIONS.md` that
contradicted the database was corrected at the same time: 23 May 2021 is ten
days into Session 6, not between dissolution and the new Parliament. The date
itself was never in doubt.


## Session 6's dates and endings, 15 September

Compared Session 6 against the owner's dataset, found seven bills that had become
Acts four months earlier, fixed the three blind spots that hid it, read all ten
fallen bills at the Official Report, then recorded where each of the fourteen
bills that did not pass stopped (`db/095`), loaded all 136 of the owner's stage
dates, and corrected Ecocide and Freedom of Information Reform to read the same
(`db/096`). It wrote the tests for all of it and, rightly, did not run them.

## The tests on Session 6’s week, 15 September

**Ran the five closure tests on `db/089` to `db/096`, the two tools and the
comparison report.** Thirty-eight items: thirty-five mechanical, three for the
owner. **All thirty-five mechanical items pass.** Nothing was written to
anything; every fixture ran inside a transaction that was rolled back, and the
three counts, the checker and the gaps list were the same before and after.

**Then two of the three owner's items came back the same day.** The Stage 3
distinction was confirmed and needed no build (`DECISIONS.md`). M12 was read
whole and judged too long for what it says, and **`db/097` cuts it from 290
words to 95** and retitles it *A fact sheet is a snapshot*. It was rehearsed
inside a thrown-away transaction and read back before it was applied; it changes
one row of one text table, touches no bill, line, stage record or provenance
note, and leaves `applies_to` and the runbook procedure alone. M5's wording is
the one item still open, and it is noted rather than settled.

How each kind of item was run, since the method matters more than the result:

- **The view rewrites** (`db/088` → `db/090` → `db/094`) were rebuilt side by
  side under other names inside one thrown-away transaction, read back out of
  the database with `pg_get_viewdef`, and diffed as text. Three replaced lines
  from `db/088` to `db/090` and one from `db/090` to `db/094`, no hunk that
  deletes without replacing, so no check was lost. This is the check that the
  error checker did not quietly get weaker while it was being widened.
- **`db/095`'s twelve refusals** were exercised by splitting the migration into
  its temp table and its `DO` block, then running the block once per deliberate
  fault. Nine of the twelve fire only after the "already hold a stage row" check,
  so those runs delete Session 6's stage rows inside the same thrown-away
  transaction first. A control run with the rows deleted and nothing else altered
  passes, which is what stops the whole exercise proving only that the block
  refuses everything.
- **The two tools query the database over their own connection**, so a rolled-back
  transaction is invisible to them. Both fixtures instead send the mutation, the
  tool's own query and `SELECT 1/0` as three `-c` arguments to one
  `psql --single-transaction`, so the tool sees the altered database and the
  error rolls the whole thing back. That is how the reader was shown bill 303
  missing a stage, and the comparison report shown line 395 without its Royal
  Assent date. Worth keeping: it is the only way to test a tool against a state
  the database must not be left in.
- **The loader** was tested through `strip_for_rehearsal.py`, wrapped in a
  transaction that deletes Session 6's dataset rows first — otherwise an altered
  row is caught by the "did not arrive as the CSV had them" check and never
  reaches the rule being tested.
- **Twenty-seven pages were read again**: eleven Acts at legislation.gov.uk,
  seven Official Report meetings, and nine of the Parliament's bill pages. Every
  one still says what the database says it says.

**Two items could not be run as written, and one number is out of date.**

- `db/093`'s item 1 expects the checker to find two problems. It finds one:
  `db/094` settled line 412 later the same day. The check behind the number still
  holds — emptying line 412's two cells brings its complaint straight back.
- The snapshot test's preamble expects 22 problems throughout. It finds one,
  for the same reason: steps 7 and 8 of the runbook ran after the test was
  written. What the item actually asks — that nothing in the test moves the
  counts — held.
- **Two items wait on the promotion of Session 6**, which cannot happen before
  the owner's review. Both were dress-rehearsed instead, inside a thrown-away
  transaction with the review stood in for by marking the rows accepted: bill 305
  comes out `passed`, `not_enacted`, `withdrawn`, concluded 10 March 2022, with
  a provenance note reading *"It read 'still_blocked' and now reads
  'withdrawn'."*; bills 303 and 304 come out `reconsidered_passed` and `enacted`.
  The seven Acts' four citations each arrive as provenance notes with the full
  value in `value_seen`, bracketed titles intact. **All of that must be watched
  again at the real promotion**; a rehearsal with a stood-in review is not the
  test, and `CLOSURE-TESTS.md` says so at both items.

**One small discrepancy, no data affected.** The workbook's own Corrections note
for row 395 and row 462 is dated 14 September 2026; `STATE.md` had described
those corrections under 15 September. The workbook's date is the one to trust.

## M5 and M12, as a reader sees them today

Kept here so the questions above can be weighed without opening the database.
M5 is unchanged and its wording is still open; M12 was cut on 15 September.

**M5 — Passing a bill is not the same as the bill being finished.**

> A bill that is passed by the Parliament does not automatically become an Act.
> It must be submitted for Royal Assent, and that submission can be prevented in
> two ways: the Law Officers may refer the bill to the Supreme Court under
> section 33 of the Scotland Act 1998, and the Supreme Court may rule that some
> of it is outwith the Parliament's legislative competence; or a Secretary of
> State may make an order under section 35 prohibiting submission. This resource
> therefore records what the Parliament did (bill.outcome) separately from
> whether the bill became an Act (bill.enactment_status), and a count of bills
> passed will not equal a count of Acts. Four bills are affected. Three were
> referred under section 33 and ruled against on 6 October 2021: the UNCRC
> (Incorporation) and European Charter of Local Self-Government (Incorporation)
> Bills were subsequently taken through Reconsideration Stage and enacted, and
> the UK Withdrawal from the European Union (Legal Continuity) Bill was withdrawn
> on 10 March 2022, nearly four years after it passed. The fourth, the Gender
> Recognition Reform (Scotland) Bill, was blocked by a section 35 order on
> 16 January 2023, and no further step has been taken. A bill in that position
> does not fall at the end of a session in the way an unfinished bill does; it
> remains a live bill, and the Parliament's own fact sheets carry it forward into
> the next session. The status 'blocked' covers both mechanisms and covers a bill
> left in that state indefinitely; which mechanism applied is recorded in
> bill.note, and the date in bill.date_assent_blocked. Because enactment_status
> records a bill's current state rather than its history, a bill that was blocked
> and later enacted shows as enacted; the earlier state is kept in the fact sheet
> lines this resource holds for every session, where the bill appears as each
> fact sheet printed it at the time, and the date of the block stays in
> bill.date_assent_blocked. A bill's recorded state is the one given by the
> latest fact sheet that has been read in, not by the latest fact sheet that
> exists. So a bill stopped in one session's fact sheet stays recorded as blocked
> here until the fact sheet saying what happened to it next has itself been read
> in, and the account above of what became of these four bills runs ahead of the
> data until that has happened.

The two sentences that have drifted are "which mechanism applied is recorded in
bill.note" — since `db/084` it is also a cell of its own — and "A bill's recorded
state is the one given by the latest fact sheet that has been read in", which
M12 now qualifies for bills left awaiting Royal Assent.

**M12 — A fact sheet is a snapshot.** As cut by `db/097`, 15 September, and as
a reader sees it now.

> A fact sheet says where each bill had got to on the day it was compiled, not
> where it stands now. Seven bills the Session 6 sheet leaves awaiting Royal
> Assent had become Acts four months before we read it.
>
> So every bill a fact sheet leaves awaiting Royal Assent is checked at
> legislation.gov.uk before it is admitted, and the answer recorded either way —
> including where no Act has been made, as for the four bills M5 covers. Where
> the Act was made, its date of Royal Assent, its number and its title come from
> legislation.gov.uk and say so, with the day each was read. The rest of the
> bill's line still comes from the fact sheet.

The 290-word version it replaces is in this file as committed at `ccac41c`.

## Session 6's dates and endings, in detail

**`db/095`: where all fourteen of Session 6's bills that did not pass stopped.**
Ten were already read — `db/092` had the Official Report for the seven that were
decided and the bill pages for the three that ran out of time — but none of the
ten had a stage row, because `db/092` deliberately left that to the stage dates.
The four withdrawn bills were read for the first time, at the Parliament's page
for each, and all four say the same thing in the same words: withdrawn at Stage
1, having not completed it, on the day the fact sheet already gives. Two of the
three that ran out of time had completed Stage 1, and `db/095` carries those two
dates from the pages that state them; the owner's dataset gives the same two
independently. Sixteen rows, rehearsed inside a thrown-away transaction first,
every refusal exercised.

**Two tools had to change before the dates would load**, and both refusals were
the tools working rather than obstacles. The reader did not know about a bill's
second appearance and refused three lines as missing from the dataset; it now
writes nothing for such a line, having checked that the bill it continues really
holds the two stages in question. The loader required the error checker to be
empty afterwards, which stopped being a statement about the load the moment
something was left standing in the checker that nothing could answer yet; it now
requires that the load caused nothing, problem by problem. Both changes are in
`DECISIONS.md`. Sessions 1 to 5 give byte-identical output from the reader either
side, 693 lines, and the loader was proved to still refuse a bad load before it
was used on a real one.

**136 stage rows loaded**, 68 Stage 1 and 68 Stage 2, over 68 bills — exactly the
gaps list, which now holds only Session 7's two. Safety copies taken first and
compared afterwards, then dropped.

**`db/096`: the one thing this session got wrong.** `db/095` described Ecocide
and Freedom of Information Reform as different cases, on the strength of two
meetings listed under Ecocide's Stage 2 heading. Those are the lead committee's
meetings; further down the same page the Parliament says a date for Stage 2
consideration was never set and no Marshalled List was produced. The owner
caught it and ruled that both bills completed Stage 1 and no more. The dates
were already right and unchanged; two notes were wrong and are corrected.

**What this session did not do, and should not:** run its own checks. The nine
items on `db/095`, `db/096` and the two tools are written in `CLOSURE-TESTS.md`
for a session that built none of it.

## The comparison against the dataset, in detail

**Step 6 of the runbook, run for the first time since it was written down.**
Six hand-pairings confirmed on the dates the two sources share and added to
`MANUAL_PAIRS`; four unpaired lines confirmed as second appearances, each with
its dataset row under the session it was introduced in. All 85 lines of Sessions
6 and 7 now carry the comparison stamp. `db/089` settles the five cells the two
sources disagree on. The working dataset is corrected for the two cells where it
was the one wrong: before
`072184df1fd4fbc15ae9e66ca51f9e287de6bc9b3b8f4d8342f6cae4e79ac1d2`, after
`31b20b9cda180418ee78a62fcab6e30e076f1885c27d12ec62a6dea75324d69b`, exactly two
cells differing on the data sheet and the stage dates for Sessions 1 to 5
byte-identical either side.

**Then the finding that stopped the session.** Seven Session 6 lines sit in the
fact sheet's awaiting-assent table while the dataset gives a Royal Assent date
for each; legislation.gov.uk confirms all seven became Acts in May 2026. Three
separate mechanisms should have caught it and none did. Put to the owner with
the evidence, and nothing built until all eight parts were agreed.

**`db/090` changed the rules and moved no data.** The error checker went from 22
problems to 34, the twelve new ones being every line in an awaiting-assent table
that nobody had looked up. **`db/091` looked all twelve up and cleared them**,
leaving the same 22 that steps 7 and 8 exist to clear. Both rehearsed inside a
thrown-away transaction first, and the rehearsal caught a fault — in the test,
not the data: line 390 carries five citations, not four, because `db/089` had
already given it one.

**`tools/compare_sources.py` now reports a cell one source fills and the other
leaves empty**, and writes nothing for it. Re-run afterwards, Session 6 gives 80
of 83 paired, zero one-sided cells and zero differences.

**What this session did not do, and should not:** run its own checks. The
fourteen items on `db/089`, `db/090`, `db/091` and the two tools are written in
`CLOSURE-TESTS.md` for a session that built none of it. Nor did it certify the
runbook's steps 6 to 8 against Sessions 1 to 5 — the owner ruled on 15 September
that this is not needed.


**Step 7, the Official Report for all ten of Session 6's fallen bills.** The
fact sheet's one word covers three things. Five were rejected at Stage 1, every
one on the member in charge's own motion being disagreed to; two were rejected
at Stage 3 having completed Stages 1 and 2 — the Assisted Dying and Recall of
Members bills, only the second and third `rejected_stage_3` in the database; and
three ran out of time, the loader's proposal checked and standing, nothing
having been decided on 8 April 2026 or capable of being. `db/092`. For the
Disabled Children bill a secondary summary gave division figures the Official
Report does not record, which is what `db/067` exists for.

**Step 9, all fifteen.** `db/094` settled the last of them on your ruling: the UK
Withdrawal (Legal Continuity) Bill says the Parliament passed it, that it never
became an Act, and that what followed the block was the withdrawal of 10 March
2022. The rule that a passed bill with no Royal Assent date must read as blocked
or awaiting one now also accepts a line that says what followed. Two things in
M5 have drifted and were deliberately left for you; they are in the list below.

**Step 9, thirteen of the fifteen first.** `db/093`: how the Gender
Recognition Reform Bill was stopped, in both fact sheets; the European Charter
and UNCRC bills recorded as stopped and then reconsidered and passed; the
European Charter Act's title and number and the Dog Theft Act's year settled at
legislation.gov.uk; and three second appearances pointed at the bills they
continue. The error checker is at two.

## Stage dates: working detail

- **Built in `db/033`:** the stage-dates staging sheet (`stage_candidate`), the
  checks in `v_candidate_problems`, the gaps list (`v_stage_date_gaps`), the
  clean sheet's rule that an undated completed stage has a note, the Hybrid
  correction, descriptions, and M2. The load, promotion and rollback scripts
  read the new sheet. See `DECISIONS.md`, 2026-09-11, for what was settled
  while building.
- **Built in `db/035`: typed entry.** The owner types rows in Postico, one per
  stage; there is no loader and no spreadsheet (`DECISIONS.md`, 2026-09-11,
  "Stage dates are typed into Postico"). The sheet shows each row's title,
  filled in by a trigger and refreshed from `bill_candidate`; `stage_order`
  is filled in from the stage name (`db/036`); slashed dates are read day
  first by the server. `db/037` sets day first for Postico's login, which
  Postico's display ignores. Scripts run as the administrator and are not
  affected. The owner's steps are in the runbook. A new row must reach the server
  with `stage_candidate_id` as DEFAULT; sent as NULL it is refused.
- **What a PhD row holds:** source `phd`, reference `PhD thesis dataset`, its
  own date read. A stage where a bill ended is not completed and `fell_here`,
  dated by the decision if there was one. A stage completed on a date not known
  has no date and a note.
- **Checking what was typed:** `tools/check_stage_entry.sql` lists every row
  waiting for review beside its bill's dates, when it reached the server, and
  the checker's findings. Run it after each of the owner's sittings.
- **The eleven Stage 1 rejections** already have the Official Report's date.
  The owner's PhD row for each is a second row, and the checker flags any
  disagreement.
- **The comparison after the dates:** `copy_before_phd_dates`, inside the
  database, was taken before `db/035` and before any PhD date. Sessions 1 and 2
  put back with the dates should differ from it only by the dates added. It
  lacks the title column, which the comparison lists and does not count.
- **The two blank spreadsheets** are still in `sources/phd/`, unused, until the
  owner clears their deletion.
- **The fifteen bills with nothing recording where they ended:** Session 1 has
  3 withdrawn and 3 fell at dissolution; Session 2 has 5 withdrawn and 4 fell
  at dissolution.
- **Private Bills in Sessions 1 and 2:** twelve. Session 1 has 3 (1 passed, 2
  fell at dissolution); Session 2 has 9, all passed. The owner's understanding
  that every one has a Consideration Stage meeting is tested by the gaps list.
- **Session 2 is promoted** (`db/034`, then the runbook), before the loader is
  built: a recorded exception (`DECISIONS.md`, 2026-09-11). When the PhD dates
  are added, both sessions come off and go back on.

## Detail for the later work

1. **Postico's permissions: fixed on 2026-09-12 (`db/040`).** All 26 tabs now
   belong to `legdata`, the login Postico uses, and every pivot table opens.
   - The cause, which is still a live rule: migrations run as the administrator
     (`postgres`), and whatever they create belongs to it unless told
     otherwise. **Any migration that creates something must set its owner**, as
     `db/031`, `db/033` and `db/035` do. `db/040` had to repair five made
     before that rule was followed.
2. **Sessions 3–5 read in full on 2026-09-12.** They reconcile in every cell:
   62, 86, and 84 of Session 5's 87. What is left is recorded above the line.
   - **The two Acts whose factsheet prints an asp number with no year before it
     are settled (`db/062`, 2026-09-13).** "Higher Education Governance
     (Scotland) Act (asp 15)", Session 4, is 2016 asp 15; "Period Products (Free
     Provision) (Scotland) Act (asp 1)", Session 5, is 2021 asp 1, both from
     legislation.gov.uk. The checker now refuses an Act whose number does not
     begin with a four-digit year; it used to compare the year only where one
     was printed, so a number with none passed unlooked-at. Both lines are
     settled and on the clean sheet; Session 5's title was mended again by
     `db/078`, which made it carry its year.
   - Session 5's three bills awaiting Royal Assent were the missing 3, and are
     recorded as blocked (`DECISIONS.md`, 2026-09-14).
   - `Clackmann- anshire Council`, a Session 2 promoter broken by a line break,
     is still on that session's staging sheet. The repair is applied to the
     title we propose, not to the factsheet's own words, so it does not reach
     this cell. Nothing in this slice uses it and it is not on the clean sheet.
     Correct it when Session 2 next comes off for another reason, or when who
     introduced a bill becomes a variable.
3. ~~**Carry-over rows, before Session 6 is loaded.**~~ **Done 2026-09-14**
   (`db/081`, `db/082`). The session-window checks now ask about the session the
   *bill* belongs to, not the factsheet the row was read off; the two that could
   not sensibly be asked of a continuing row — passed after the session ended,
   concluded after the session ended — are asked only of a row that is a bill in
   its own right. Every one of the eleven later-session events has a home, nine
   of them already having had one (`DECISIONS.md`, 2026-09-13).
   - `bill_candidate` has no column for a block date. A title change records
     its stage since `db/107`, and its date is that stage's date.
     Sessions 4–7 state them, and nothing loaded so far needs one.
   - **The comparison tool's fault still exists** — an unpaired line is still
     stamped as compared — and still has no instance to see it on. Its
     hand-pairing gate was removed on 2026-09-13.
4. ~~**The double-count guard, before Session 6 is promoted.**~~ **Done
   2026-09-14** (`db/081`, `db/082`, `tools/promote_session.sql`). The guard was
   never the only net it needed to be: it matches on title and introduction date,
   and the UNCRC Bill is listed as an Act in Session 6. The rule that catches a
   carried-over row whatever its title does is that a row introduced before its
   own factsheet's session began must name the bill it continues. The old guard
   stays as a second net, now asked only of rows claiming to be bills of their
   own. **Note the docs were wrong by one:** they said the guard was blind to the
   European Charter and UNCRC Bills; the European Charter's Session 6 row still
   carries its *Bill* title, so the guard sees it.
5. **The prose parser for Sessions 6 and 7.** The grammar is in
   `FACTSHEET-SURVEY.md` §1, and was tested against both documents on
   2026-09-14: every sentence matches a known shape and nothing is left over,
   83 entries in Session 6 and 2 in Session 7. Empty sections are sentences
   ("No bills have fallen in Session 7."), not empty tables.
   - **§1's list of shapes is incomplete.** It does not contain `Motion agreed
     to treat as Emergency Bill on {date}.` (five times, Session 6) or the
     excluded section's own note. Read the documents, not the list.
   - **The reader must work on reflowed text, not on printed lines.** The rename
     sentence wraps across two lines in both places it appears, and a line-by-
     line matcher does not merely miss it — it swallows it into the next bill's
     title without complaining. The test that catches this is requiring every
     sentence in the document to match a shape.
   - **Sections carry their own asterisked notes, inline.** The section 35 block
     on the Gender Recognition Reform Bill is a paragraph sitting directly after
     the bill it concerns, in both documents. Session 6 puts the asterisk on the
     section heading and Session 7 puts it nowhere. Position attaches it, not
     the marker — unlike Sessions 4 and 5, which number their footnotes and put
     them at the foot of the page.
   - **"(SP 70)" is a Session 5 number.** Session 6 has its own SP Bill 70, the
     Ecocide Bill. Reading the European Charter's number as a Session 6 number
     collides with a different bill.
   - **Four titles are printed wrongly**, to be mended in the title we propose
     and never in the factsheet's own words: "Agriculture and Rural Communities
     (Scotland) **Bill** Act 2024 (asp 11)"; "Housing (Scotland) **Bill** Act
     2025 (asp 13)"; "Scottish Parliament (Recall of Members **Bill** (SP Bill
     55)", a bracket never closed, inside the rename sentence only; and the
     European Charter's "(SP 70)". `mend_title` handles none of them yet.
   - **The Acts section holds one entry that is not an Act title.** The European
     Charter's entry prints its Bill title and no asp number, so a reader that
     stamps `title_kind` = act on everything in that section is stamping it on a
     Bill title.
   - **Session 7 has a section Sessions 1 to 6 do not**, "Bills currently in
     progress", holding one bill with only an introduction date. `ref_outcome`
     already has `in_progress` for it.
6. **The seven `session` rows: done on 2026-09-12 (`db/048`).** All seven carry
   a first meeting; all but Session 7, which is running, carry a last day. The
   source is SPICe's dates factsheet, agreeing to the day with the Parliament's
   API and with each legislation factsheet's own page 1.
   - The session-window checks are awake from that point. Until 2026-09-14 they
     compared a line's dates against the session of the factsheet it was read
     from, which is wrong for a carry-over row; they now ask about the session
     the bill belongs to (item 3 above). Rehearsed on 2026-09-14 on a Session 6
     line built by hand: the rule fires when the row does not say which bill it
     is, and is silent when it does. Sessions 1 to 5 hold no row that fires it,
     before the change or after.
7. **`docs/VARIABLES.md`.** Everything factual is in the data dictionary; what
   remains is reasoning, and it is out of date:
   - §3.2 describes `procedure` as non-null and `date_outcome` as present, and
     defines `short_title` as "title as introduced" (wrong since `db/021`);
   - it does not mention `date_concluded`, `bill_type_stated`, `title_kind`,
     `title_as_introduced`, `date_assent_blocked`, `stage_1_rejection_route`
     or the stage-dates sheet;
   - §4.1 needs `analysis_group`, and §4.5 needs `ref_bill_type_stage`;
   - §5 lists D1, D4 and D5 as open and never mentions D6, and §6 is answered
     by M6;
   - §7 still describes provenance as append-only (`db/030`).

One staging table serves all seven sessions, not one per session. The natural
key carries `session_number`, and cross-session questions would otherwise need
seven-way unions. Load one session at a time, each gated on reconciliation.
