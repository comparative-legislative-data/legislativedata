# The site reads the copy

For the owner. Written 18 September 2026. Strand 2, item 1 of
`docs/PHASE-2.md`. Every part is laid out here, with four questions at the
end. **Not yet agreed; nothing is built.**

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
