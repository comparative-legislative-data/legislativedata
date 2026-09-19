# Building strand 2, item 6: the refresh makes the zip

Written 19 September 2026, before anything is built. **For the owner's
agreement.**

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
