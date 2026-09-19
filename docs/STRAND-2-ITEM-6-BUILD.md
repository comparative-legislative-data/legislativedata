# Building strand 2, item 6: the refresh makes the zip

Written 19 September 2026, before anything is built. **Agreed by the owner
the same day, as written** ("proceed"). Built, rehearsed and deployed the same
day; what was done is at the end.

Item 6 of `docs/PHASE-2.md`, strand 2: "The refresh builds the zip, from the
new copy, before it goes live. Rehearsed again with its undo." It also
settles what item 5 left open: two refreshes on one day.

No database changes and no new wording a reader sees. What changes is the
refresh (`tools/refresh_copy.sh` and `tools/published_copy.sql`), its undo,
and one line in `site/download.py` so it can read a copy that is not yet
live.

## The problem, in one bill

Say bill 305 gains a date and we refresh. Today the refresh takes the new
copy and puts it live in one go. The zip is made by hand afterwards. Between
the two the Data page has no zip for the new copy, so the download box
vanishes. If the zip then failed to make, it would stay vanished. The plan
says the zip is made *before* the copy goes live, so there is never a
moment without it.

## How it would work, in the order things happen

1. **The new copy is built as now**, with every check it has today, but
   kept to one side, served to nobody, instead of going live straight away.
2. **The zip is made from it**, by the site's own login, the same program
   as item 5, into `/srv/downloads` under the new copy's date. The old
   copy's zip is untouched, and it is still the one readers get.
3. **The zip is checked**: it opens, it has fifteen files, `bills.csv` has
   as many lines as the new copy's bills, and the readme has its two blanks
   for the day downloaded.
4. **Only then does the new copy go live**, and the old one becomes the
   copy before, as now. From that moment the Data page offers the new zip.
5. **The zip is made again from the live copy and compared byte for byte**
   with the one made in step 2. That proves the zip is of the copy readers
   are now shown.
6. **Zips older than the copy before are removed.** Two are kept: live's
   and the copy before's.

If anything fails at steps 1 to 3, the copy on one side and its zip are
thrown away, and nothing a reader sees has changed.

## Small choices

1. **Two refreshes on one day: the second refuses.** The date names the
   copy, the zip, and each line of what changed, so a second copy the same
   day would give two different things one name. To correct a refresh the
   same day, undo it first. The live copy is then yesterday's (or older), so
   a new refresh is allowed.
2. **The undo puts the old zip back in use as well.** It already puts the
   copy before back live. Because that copy's zip is kept (step 6 above),
   the download box comes back with it, with no remaking. The undone copy's
   zip is removed, so nothing is left that nobody is served.
3. **The undo becomes one command**, `tools/refresh_copy.sh --undo`, which
   does both halves. Today it is a database step run by hand, and it cannot
   remove a file.
4. **The site's login may read the copy on one side**, for step 2 only. The
   site's pages read only the live copy, as now. The check that its login
   "reads the copy only" still holds, since the copy on one side is the
   copy. It loses that permission when the copy goes live or is thrown
   away.
5. **A thrown-away run** (the default, without `--save`) goes as far as
   step 3, into a scratch folder, and then throws both away. So a practice
   refresh tests the zip too.

## The test, and what to look at

Rehearsed on a **scratch copy of the published database**, with a scratch
folder standing in for `/srv/downloads`, so the live copy, the live zip and
the site are not touched at all:

1. A thrown-away run: the report, the zip made and checked, then nothing
   kept: the scratch database and folder as before, compared by fingerprint.
2. A kept refresh: the new copy live in the scratch, its zip beside the old
   one, the byte-for-byte comparison passing, older zips gone.
3. A second refresh the same day: refused, nothing changed.
4. The undo: the old copy live again, its zip the one kept, the undone
   zip gone. A second undo refuses.
5. A refresh again after the undo: allowed, and goes through.
6. A planted failure at the zip (a zip missing its blanks): the refresh
   stops before step 4, and the scratch copy and folder are as before.

Then the scratch database and folder are removed, and the live copy, zip
and site fingerprinted to show nothing moved. **No real refresh is run**: that
waits for new data, at your word, as now.

The closure test is written by this session and run by another; it becomes
part of strand 2's closure test (item 7).

## Size

One session: the build, the rehearsal, and the test written.

## What was done, 19 September

**Built.** `tools/published_copy.sql` now sets the copy aside as `next` and
refuses to build over one already there; `tools/switch_copy.sql` (new) puts
`next` live, refusing a copy not dated today or dated the same as the live
one; `tools/refresh_on_server.sh` (new) runs the steps in order on the machine
and removes what a failed run made; `tools/refresh_copy.sh` sends it all and
gains `--undo`. `site/download.py` reads either copy and gains `--check`. The
undo is a look without `--save`, as every other step is: `--undo --save` does
it. For rehearsals only: `--database`, `--downloads`, `--site` and
`--plant-zip-fault`, all refused against `published`.

**Rehearsed** on a scratch copy of `published`, with a scratch folder holding
the live zip and a made-up older one, and the staged release
`2026-09-19T10-37-43Z`. The address check was made from the live copy's
`cited_pages`, with today's date. Each step read by fingerprint (the dump of
`live`, `previous` and `next`, lines sorted: the dump's order differs between
two databases holding the same lines, so an unsorted one is not a fingerprint).

1. Thrown away: "Zip checked", "Nothing kept"; afterwards the scratch copy
   identical to the real one (`7afcaf840501`), no `next`, folder unchanged.
2. Kept: copy dated 2026-09-19 live, the old one as `previous`; the zip
   checked before and after the switch; the made-up 2026-09-10 zip removed.
3. Second refresh the same day: refused before anything was built;
   fingerprint unchanged.
4. Undo, a look: nothing changed, and it said which zip would go. Undo: the
   2026-09-18 copy live, the 2026-09-19 zip removed, the old zip checked
   against the copy put back. A second undo refused.
5. A refresh after the undo went through, and gave the same fingerprint as
   step 2's: the copy is the same when taken twice.
6. A spoiled zip, with `--save`: "ZIP WRONG" twice (the blanks, and not the
   zip this copy makes), next removed, fingerprint and folder as before. **The
   first try failed for another reason**: the planting ran as the wrong login
   and could not write the file. The run still stopped and cleaned up, but it
   was not the check that stopped it, so the planting was mended and step 6
   run again.

Then the scratch database and folder removed, and the real copy checked
untouched: fingerprint `7afcaf840501` before and after, `live` dated
2026-09-18, no `next`, the zip's SHA-256 still `42a2716c…811cf0`, four
databases, nothing in the server's `/tmp`.

**Not rehearsed**: the undo's branch that remakes a missing zip, and the
refusal to put a zip over one already there. Both are in the closure test,
part A item 4, for the session that runs it.

**Checked and deployed.** The staged release: all 133 of the page check
pass, and `BREAK=3` fails at exactly 122 and 124. Deployed as
`2026-09-19T10-55-09Z`: 200, 200, 301, 308, 200. The undo is
`tools/deploy_site.sh --rollback`, to `08-22-31Z`, whose only difference is
the old `download.py`, which no page uses.

**No real refresh was run.** The next one, at the owner's word, will be the
first to make its own zip.

## The gap fixed, 19 September

Item 6's test found one gap. The refresh records the zip as its own only
after it has copied it into the downloads folder and compared the copy. If
that comparison failed, the zip stayed in the folder, served to nobody, and
a second try that day would refuse until someone removed it by hand. The
owner chose to fix it before item 6 closes (`DECISIONS.md`, 19 September).
The fix was made by a session that did not run item 6's test.

**The fix, one line moved.** In `tools/refresh_on_server.sh`,
`put_in_downloads` now records the zip as the run's own after it refuses a
file already there, and before it copies the zip. So a failure from the
copy on removes that zip, and the clean-up still never removes a file this
run did not put there. Nothing changes on the machine: the script travels
in the refresh's bundle each time it runs, so there is nothing to deploy.

**Rehearsed** on a scratch copy of `published` (`published_rehearsal`) and
a scratch folder seeded with the live zip and a made-up 2026-09-10 one,
using an address check from `live.cited_pages` with today's date (106
addresses: 92 working, 14 not checked). For the failure itself, a copy of
the bundle's files on this Mac had its comparison pointed at `/dev/null`;
the real script was not touched. Each fingerprint was taken as item 6's
run gives it.

1. **The planted failure, kept refresh:** the zip was made and checked,
   then "cmp: EOF on /dev/null", then "Nothing kept: next removed, and
   legislativedata-2026-09-19.zip". Afterwards the fingerprint was
   `7afcaf840501` as before, with no `next`, and the folder held the same
   two files with the same SHA-256s.
2. **A made-up file named for today's zip already there, real script:**
   "Refusing: … is already there", then "Nothing kept: next removed", with
   no zip named. The made-up file was untouched (SHA-256 `152e3ebd6425`,
   the same as its contents made again) and the fingerprint was unchanged.
3. **A kept refresh, real script:** it went through, with "Zip checked"
   twice, and removed the 2026-09-10 zip. The fingerprint was
   `f605ffe5c4e4` and the zip `91bcb1e4…`, both the same as in item 6's
   run.
4. **The undo, real script:** the 2026-09-18 copy was live again,
   today's zip removed, and the old zip checked. The fingerprint was
   `5b61bbb9a3c6`, the same as in item 6's run.
5. **The planted failure again, after the undo:** the same as 1, with the
   fingerprint still `5b61bbb9a3c6` and the folder unchanged.

Then the scratch database, the folder and the planted copy were removed.
`published` was untouched: fingerprint `7afcaf840501`, `live` dated
2026-09-18, the one zip `42a2716c…`, four databases, and nothing in the
server's `/tmp`.

**Not rehearsed:** a disk that really fails at that moment, which cannot
be caused on purpose. **Checked** in strand 2's closure test, items 2 and
3, by another session.
