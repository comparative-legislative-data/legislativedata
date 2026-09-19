# Thought 2's figures: the build, its test and its undo

For the owner, 19 September 2026. Strand 3, step 3, first half
(`docs/STRAND-3-PLAN.md`), built to the agreed write-up,
`docs/STRAND-3-THOUGHT-2.md`. The page is the second half, next session.

**Built and rehearsed the same day; A to E agreed by the owner.** Nothing is
live: the first copy with the figures is taken with the page (A). What was
done and found is at the end.

## What this session builds

The refresh learns to work out the outcomes chart's figures and keep them
in the copy, the way it already does for the days between stages.

1. **The working, as its own text**, `workings/outcomes_by_session_and_type.sql`:
   the agreed working, word for word.
2. **The copy's build runs it** after the files it reads (`bills`,
   `sessions`, `what_the_words_mean`), keeps the text in `workings` as its
   second line, and gives the new file and its ten headings the agreed
   descriptions. `about` counts it.
3. **The copy's check is extended**, against the copy's own `bills`, never
   the working database. It refuses a copy where:
   - for any choice of outcomes and of the Forth Crossing Bill, the
     sessions' figures do not add to every bill in `bills`, or "All
     sessions" does not;
   - a bill is missing from an arrangement, or in it twice;
   - a figure's list of bills does not hold as many bills as its count;
   - a bill listed under a figure is not of that figure's session, type or
     outcome in `bills`;
   - a share, a "bills of this type" or an "of which became Acts" is not
     what the listed bills give;
   - a session, type or outcome that some bill has is missing its line, or
     has two;
   - the kept text, run again, does not give exactly the file.
4. **What changes with it**, each small:
   - the zip is unchanged: the figures stay out of it, as settled. It gains
     the working as `working-outcomes_by_session_and_type.txt`, which the
     readme already lists in its usual words;
   - the site's permission check and the strand 2 test's checker expect
     thirteen files in the copy, not twelve. The zip still has twelve;
   - the Data page's "What each heading holds" lists the new file (point B
     below).

**No bill, date or figure changes. The working database is not touched.**

## Five points, agreed by the owner before building

**A. When it first goes live.** *Proposal:* this session builds and
rehearses it, but no live copy is taken with it until the page is deployed.
Otherwise the Data page would describe "the figures behind the outcomes
chart" for a day or more before the chart exists. The refresh is only run
from this Mac and only on your word, so holding it back is easy.

**B. Where the Data page lists it.** "What each heading holds" gives every
file in the copy. *Proposal:* last, after `terms`, because it is the
chart's file and is not in the zip.

**C. The zip's readme.** The zip's `about.csv` will count the figures'
lines, and `workings.csv` will hold their working, but the file itself is
not in the zip. *Proposal:* one sentence in the readme, after the working
files:

> The figures behind each chart on the Insights page are not in this
> download. Each is worked out from the files here by its working, and can
> be downloaded beneath its chart; about.csv counts their lines.

**D. The notes name the new headings.** Every note's `applies_to` lists
every heading it bears on. For the days between stages that already
includes `days_between_stages.outcome` and the like. *Proposal:* the same
for the new file. For example, M7 would then also list
`outcomes_by_session_and_type.outcome`. The Data page's notes show this.

**E. What has changed.** *Proposal:* the new file is compared at each
refresh like every other file, so a bill changing its outcome shows as
the figures that moved. On the first copy that carries it, the Data page
will say, in its agreed words: "Added in the copy of [day]: 720 to
outcomes_by_session_and_type."

## How it is tested

All on a **scratch copy of the published database** (`published_rehearsal`)
and a scratch download folder, as strand 2's zip was. The real copy, the
live site and the working database are not touched. The scratch database
and folder are made and removed inside the session, and none is left when
the session ends.

1. **A thrown-away run.** Look at: 720 lines in the new file; the check
   finds nothing; the zip is checked and still has twelve files and one
   more working; nothing is kept.
2. **Planted faults, each on its own thrown-away run.** Each must be
   refused, naming the line:
   - one bill moved from one outcome to another in a figure's list;
   - one count one higher than its list;
   - one bill listed twice in an arrangement;
   - one share altered;
   - one line removed.
3. **A kept refresh on the scratch copy.** Look at: the new file, its
   descriptions and its working in the new copy; `about` counting 720 added;
   the notes' `applies_to` as in D; the zip's readme with C's sentence; the
   strand 2 checker passing against it with thirteen files.
4. **Its figures against the mock-up**, cell by cell. All 720 lines must
   match the write-up's check of 19 September.
5. **The undo on the scratch copy** (`refresh_copy.sh --undo --save`).
   Look at: the copy before, and its zip, live again, twelve files.
6. **Then the scratch database and folder are removed**, and the real copy
   is checked unchanged: still the copy of 18 September, `live` and
   `previous` only.

## The undo

- **Before it goes live:** nothing live has changed, so the undo is the
  commit reverted.
- **Once a copy carrying it is live** (next session, with the page): the
  refresh's own undo, `refresh_copy.sh --undo --save`, puts the copy
  before, and its zip, back live. Then revert the commit so the next
  refresh does not rebuild it.

## Its closure test

Written by this build's second session, with the page, and run by another
session. It covers both halves.

---

## What was built, 19 September

- `workings/outcomes_by_session_and_type.sql`: the agreed working, taken
  from the write-up character for character.
- `tools/published_copy.sql`: the thirteenth file, its ten headings and
  their agreed descriptions; the working run after `what_the_words_mean`;
  `workings` holds two lines; the file compared at each refresh (E); check 10
  extended (part e) as listed above; five planted faults for rehearsal,
  `-v fault_move`, `fault_count`, `fault_twice`, `fault_share`, `fault_drop`.
  The headings' `feeds` give the notes' `applies_to` (D).
- `site/download.py`: the readme's sentence (C), **said only when the copy
  has a chart's figures** (found in rehearsal, below); the zip's own check
  counts the files it should hold instead of a fixed fifteen.
- `site/app.py`: the new file listed last in What each heading holds (B).
  The page already put a file it did not know last; the list now says so.
- `docs/wording/DOWNLOAD.md` part 3: the second working's entry and C's
  sentence, as agreed.
- `tools/check_data_pages.py` (strand 2's checker): expects thirteen files
  and 123 headings on the Data page, sixteen files in the zip, and each
  working's text file equal to its working.
- `db/published/002_check_as_the_site.sh`: expects thirteen files. The
  migration beside it, `002_the_site_reads_the_copy.sql`, is left as it ran.
- `tools/make_data_dictionary.py`: the new file's place, and the count of
  files in words from the copy. The dictionary regenerates identical.
- `tools/deploy_site.sh`: a stage-only deploy, or a failed rehearsal, now
  removes the `Caddyfile` it sent to the server's `/tmp`, which it had left
  there.

**One description changed that the write-up did not list**:
`what_changed.which_line` names what a line is about, and a chart's figure
is a new kind of line. Its wording is put to the owner (see `STATE.md`).

## How the rehearsal went

On `published_rehearsal`, a scratch copy of `published` made with
`pg_dump`, a scratch folder seeded with the live zip, an address check taken
from `live.cited_pages` with today's date, and a staged release of the site,
never switched to.

1. **Thrown away:** the check found nothing; 720 lines, 720 added; eight
   notes' `applies_to` gained the new headings (M1, M4, M5, M6, M7, M9, M12,
   M13); the zip checked, sixteen files; nothing kept. The first try failed
   on the zip's own check, which counted a fixed fifteen files: fixed.
2. **Planted faults, each refused and named:** moved (bill 304 missing
   from Passed and "should not be listed" under Withdrawn, 8 problems);
   count (adds to 471, 4); twice (5); share (3); drop (65).
3. **Kept, on the scratch copy:** the copy live with its zip, checked
   twice; strand 2's checker, run as the site against the staged release:
   **all 131 pass**, including the readme word for word with C's sentence.
4. **Against the mock-up:** all 720 lines, cell by cell (bills of the type,
   bills, share, became Acts from the mock-up's own list of passed bills
   that did not), **no difference**. Session 5 Government Bills: 62 of 63
   passed, 98%, 61 Acts. Session 3 Government Bills: 45, or 44 with the
   Forth Crossing Bill on its own.
5. **The undo** first failed: the copy of 18 September was put back, but
   its own zip no longer checked, because the new readme always said C's
   sentence and so no longer remade the old zip byte for byte. **Fixed** by
   saying the sentence only of a copy that has a chart's figures, which is
   also only then true. Then a kept refresh, the checker (131 pass) and the
   undo again: the 18 September copy live, its zip checked, fifteen files.
6. **Cleared away:** the scratch database, folders and three staged
   releases removed; six refresh bundles left in the server's `/tmp` by runs
   whose second connection the firewall refused, removed (see `STATE.md`);
   the `Caddyfile` staging had left, removed. `published` untouched: `live`
   18 September with twelve files, `previous`, no `next`, its zip
   `42a2716c…`; 470, 1291, 192, 14; checker and gaps list empty.

## For the session that takes it live

In one session, with the page: deploy the site; take the refresh
(`tools/refresh_copy.sh`, a look, then `--save` at the owner's word); then
run `002_check_as_the_site.sh` (thirteen files) and strand 2's checker
against the live release. The Data page will then say "Added in the copy of
[day]: 720 to outcomes_by_session_and_type." (E). Regenerate the data
dictionary: it gains the new file.
