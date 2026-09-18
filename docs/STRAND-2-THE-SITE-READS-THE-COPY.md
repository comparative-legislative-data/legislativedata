# The site reads the copy

For the owner. Written 18 September 2026. Strand 2, item 1 of
`docs/PHASE-2.md`. Every part is laid out here, with four questions at the
end. **Agreed by the owner the same day: yes to all four.**

Already settled (the review of the plan, 17 September): the site reads the
published copy and never the working data; its login to the copy only reads,
and a check proves it, as its inability to open the working data was proved
on 16 September. This is a deploy, with the deploy runbook's rehearsal and
written undo, and it clears out the old site releases.

## What a reader sees

**Nothing, yet.** This item gives the site a way into the copy and proves what
that way can and cannot reach. The first thing a reader sees from the copy is
the date at the foot of every page, and the agreed wording says that changes
"once the first data page is live", which is item 2 onwards. So the deploy
changes no page.

## What happens, for one bill

Today a signed-in reader can see nothing about the Legal Continuity Bill. After
this item, the site can look the bill up in the live copy, as it stands in
`live.bills`, and nowhere else. It still cannot reach the working data's
clean sheet or staging sheet, nor the copy kept as `previous`, nor change a
single cell of the copy. When a refresh puts a new copy live, the site reads
the new one from its next page, with nothing restarted.

## Every part of the change

1. **The site's login.** The site already logs in as `legsite`, for the
   accounts. The same login is given read access to the copy: it may connect
   to `published`, open `live`, and read its files. It gets nothing in
   `previous`, `from_working` or `public`, and cannot use the connector to the
   working data. No new login, no password: it connects over the machine's own
   socket as it does for the accounts.
2. **Where the permission is given.** A new step, `db/published/002`, gives it
   for the copy that is live today, with its own undo and its own check at the
   end. And the refresh (`tools/published_copy.sql`) gives it to each new copy
   as it goes live, beside the permission Postico's login already gets there.
3. **The copy kept as `previous` is closed to the site.** Found while laying
   this out: a permission follows a copy when it is renamed, so when a refresh
   turns `live` into `previous`, whoever could read `live` can still read
   `previous`. Postico's login can read `previous` today. The refresh will
   take the site's permission off `previous` at the moment it is renamed. The
   undo (`tools/put_back_previous.sql`) turns `previous` back into `live`, so
   it gives the permission back there, and is rehearsed again.
4. **The check, run as the site.** Like `db/accounts/001_check_as_the_site.sql`,
   run as `legsite`, refusing to run as anyone else. It proves: it can read
   every file in `live`; it cannot write to any of them; it cannot open
   `previous`, `from_working` or `public`; it cannot use the connector; it
   cannot connect to the working database. Each "cannot" is shown to fail when
   the permission is given in a thrown-away rehearsal, so it is known to
   catch it.
5. **The site's code.** A new file beside `site/accounts.py`, the site's one
   way into the copy, read-only, one connection per page that needs one,
   closed at the end. Nothing uses it yet but the health check.
6. **The health check.** Today the deploy refuses to go live unless the site
   can read the accounts and its two keys. It would also refuse unless the
   site can read the copy's `about` file.
7. **The deploy.** `tools/deploy_site.sh --stage-only` first (a rehearsal on
   the spare port, the live site untouched), then the deploy, with the five
   usual checks. The undo is `tools/deploy_site.sh --rollback`, which puts
   back today's site, and `db/published/002`'s undo takes the site's
   permission away again. Rehearsed in that order, then done
   again for real.
8. **Clearing the old releases.** Nineteen are on the machine, 416 MB, one per
   deploy since 9 September. The rule is written into `DEPLOY-RUNBOOK.md`
   first, then applied: see question 3.
9. **The records.** `DEPLOY-RUNBOOK.md` and `ACCOUNTS-RUNBOOK.md` say the site
   reads the copy; `HOW-THE-DATABASE-WORKS.md` says so in its own terms;
   `STANDING.md` gains "the site's login cannot reach the working data or
   `previous`" as verified; the dictionary is regenerated.
10. **Its closure test**, written by this item's session and run by another.

## Four questions

1. **Should the deploy refuse to go live if the site can't read the copy?**
   Recommended: yes. Until a data page exists nobody would notice it failing,
   which is exactly when a check is worth having.
2. **Should Postico's login also be closed off from `previous`?** It can read
   it today. Nothing is wrong with you seeing it, and it is how you would look
   at the old copy before an undo. Recommended: leave it open, and say so in
   `STANDING.md`.
3. **How many old releases to keep.** Recommended: the live one and the two
   before it that were actually live, so the undo reaches two deploys back.
   Every release that was only staged, or failed its rehearsal, goes. From
   nineteen to three.
4. **Should the site start reading the copy before a page needs it?** This
   item deploys a way in that nothing uses but the health check. The
   alternative is to fold it into item 2, the page parts every data page
   shares, so the first deploy also shows the date. Recommended: keep it on
   its own, as the plan has it. It is the permission change, and it should be
   tested on its own.

## The rehearsal, and what each step should show

Everything here is undone in a step or two, so it is rehearsed on the real
workbook and the real site, in this order, each step read before the next.

1. **Apply `db/published/002`.** It ends: "The site can read the twelve files
   of live, change none, and open nothing else here."
2. **The check as the site.** "All 11 pass."
3. **Plant the faults** (`002_plant_faults.sql`, `fault=on`) and check again:
   items 1 to 3 and 11 pass, **4 to 10 fail**, one for each fault. Take them
   away (`fault=off`) and check: all 11 pass.
4. **The refresh, thrown away**, with today's address check given, so the
   Parliament's site isn't read again: no problems, nothing changed, and no
   error from the new line that checks the site reads the new copy and not
   `previous`. **The undo, thrown away**: no error from its matching check.
   The copy's fingerprint the same before and after.
5. **Undo `db/published/002`** and check as the site: items 1 and 11 differ
   (1 fails, 11 passes). **Stage the new site** (`--stage-only`): the
   rehearsal must **fail**, "published copy unreachable", and remove the
   release, with the live site untouched. This is question 1's answer at work.
6. **Apply `db/published/002` again**, check as the site: all 11 pass. Stage
   again: the rehearsal passes.
7. **Deploy.** The five usual lines (200, 200, 301, 308, 200), then step 6
   clears the releases to three.
8. **Roll back**: back to 16 September's release, health and apex 200. **Deploy
   again**: the five lines again; three releases kept.
9. **Leave nothing**: nothing of this in the server's `/tmp`.

**The undo, for real:** `tools/deploy_site.sh --rollback`, then
`db/published/002_undo.sql`. In that order, because the site after this
deploy reports itself unhealthy without the copy.

## What was done, 18 September

**Built, rehearsed and deployed the same evening.** Every step as above, with
three things that went differently, all put right:

- **Step 4 first failed**, on a fault in the new check: it looked the copy's
  files up by name, and PostgreSQL may try the name on its own system tables
  before narrowing to the copy's, which fails. Both the refresh and the undo
  refused and kept nothing (the fingerprint unchanged). The check now looks
  them up by number, as `002` does, and step 4 passed.
- **Step 5's check differed from the prediction here**: with its permission
  taken away, the site cannot open the published workbook at all, so items 1
  to 9 fail, not item 1 alone; 10 and 11 pass. Right, but not what was
  written.
- **The server's firewall refused connections twice** (six in 30 seconds):
  once cutting off a staging, once the release-clearing step. Nothing was
  switched either time; the files a cut-off staging left in `/tmp` were
  removed. Clearing now runs inside step 5's connection, so a deploy opens no
  more connections than before.

Live: release `2026-09-18T17-39-56Z`. Kept: that, `2026-09-18T17-38-41Z` and
`2026-09-16T17-11-22Z`; nineteen releases went to three, 416 MB to 67 MB.
Rolled back to 16 September's and deployed again, all checks right. The
closure test is at the top of `docs/CLOSURE-TESTS.md`, unrun.
