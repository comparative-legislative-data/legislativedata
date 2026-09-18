# The page parts every data page shares

For the owner. Written 18 September 2026, and reworked the same evening when
the site became two pages, Data and Insights (DECISIONS.md, 2026-09-18).
Strand 2, item 2 of `docs/PHASE-2.md`. Every part is laid out here, with four
questions at the end. **Not yet agreed.**

Already settled, and not asked again: two pages, Data and Insights, linked in
the header, both behind the sign-in; every data page tested signed out as
well as signed in; the date beside a data page's heading in muted type, and
in the footer; the wording of the footer, the date statement and the credit
lines (`docs/wording/PUBLISHING.md`); dark by default, light as a setting,
printing dark on white; each chart names the notes it rests on.

## What happens, for one bill

Say a beta user is sent a link to note M7, on why the Legal Continuity Bill
is coded as it is. They aren't signed in.

1. They get the sign-in page, and nothing of the note. They sign in with
   their code and land on the Data page, opened at M7.
2. The header shows Data and Insights beside Privacy.
3. Beside the Data page's heading: "Data as at 18 September 2026", read from
   the live copy, and under it the agreed date statement, linking to the
   "What has changed" section further down.
4. At the foot of the page, one credit line for each set of terms the page's
   content uses, then the agreed "provided as it is" sentence.
5. The footer: "Data as at 18 September 2026 · What has changed", and the
   independence sentence.
6. In light mode, or printed, it reads the same.
7. If the site cannot read the copy at that moment, they get a plain "can't
   be shown right now" page, and never a half-drawn one.

After a refresh, every date changes on the next page load, with nothing
restarted.

## Every part

1. **Header links.** "Data · Insights" before "Privacy", signed in only.
2. **The sign-in wall.** One rule in the site's code that both pages go
   through. Signed out: the sign-in page, then back to where they were going.
   The way back only ever leads to an address on this site.
3. **The date and the date statement**, read from the live copy's `about`
   file, written out as "18 September 2026".
4. **The credit lines**, built from the copy's `terms` file in its order,
   our own line always last. Which lines is worked out from the copy, for
   everything the page can show, so the credit doesn't change as a reader
   narrows the table.
5. **The footer**, switched from "No data published yet" to the agreed
   wording, on every page, signed in or not.
6. **When the copy can't be read**: a page in the same shape as the agreed
   "Signing in isn't possible right now".
7. **Neither page is kept by the browser**, as the admin pages already
   aren't, so pressing Back after signing out on a shared computer doesn't
   show them again.
8. **Dark and light, and print**: every part checked in each.

## New words a reader would see, in full

**Signed out, above the sign-in form, when they were going to Data or
Insights:**

> Sign in to see the data.

**When the copy can't be read:**

> DATA
>
> # The data can't be shown right now
>
> Please try again later.

**The Data page, above its sections, until the table exists:**

> DATA
>
> # Data
>
> The table of every bill, and the whole dataset to download, are being
> built.

**The Insights page, until the first chart exists.** It shows no data, so it
carries no date and no credit lines:

> INSIGHTS
>
> # Insights
>
> The charts are being built.

**One agreed sentence that has to change**, because there is no longer a
Sources page. At the end of the credit lines, on both pages:

> Was: What each source allows, and does not, is on the Sources page.
>
> Now: What each source allows, and does not, is under Terms of use, on the
> Data page.

"Terms of use" links to that section. The section itself is the agreed part
4 of `PUBLISHING.md`, unchanged, in the Data page's Sources section.

## The four questions

1. **Build items 2 and 3 together, and put them live in one deploy?**
   **Recommend yes.** Item 3's four sections are the first data the Data
   page shows, so they are what these parts are tested on, and the date
   statement's link to "What has changed" has something to land on. Each
   item keeps its own closure test.
2. **The notes a page rests on move out of this item.** The notes are now on
   the Data page itself. How the table points to the notes behind each
   column is for the table's write-up (item 4), and each chart's notes are
   strand 3's. **Recommend:** agreed as moved.
3. **Signed out**, as above: links hidden, the sign-in page with "Sign in to
   see the data.", and back to where they were going after the code.
   **Recommend yes.**
4. **The words above**, including the changed sentence. Agree, or amend.

## Not in this item

- The home page's "Nothing is published here yet" stays. It is public
  wording, and a signed-out visitor still sees no data. It is looked at when
  the table goes live.
- No chart parts: the date inside a chart's frame is strand 3's.

## The test, and the undo

Laid out in full with the build, before anything is deployed. In outline:
both pages and every section link tried signed out (the sign-in page, and
none of the page's words in what comes back) and signed in; each piece of
wording compared with `PUBLISHING.md` and the words above; the copy made
unreadable on the rehearsal port, to see the "can't be shown" page; dark,
light and print looked at; the privacy check run after. Signed-in pages are
tested on the live site, by you, or by me through your Chrome with your
permission. The undo is the deploy runbook's rollback. No database change is
needed.
