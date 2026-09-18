# The page parts every data page shares

For the owner. Written 18 September 2026. Strand 2, item 2 of
`docs/PHASE-2.md`. Every part is laid out here, with five questions at the
end. **Not yet agreed.**

Already settled, and not asked again: two sections, Data and Insights, linked
in the header, both behind the sign-in (17 September); every data page tested
signed out as well as signed in (17 September); the date beside a data page's
heading in muted type, and in the footer (15 September); the wording of the
footer, the date statement and the credit lines, word for word
(`docs/wording/PUBLISHING.md`, 18 September); dark by default, light as a
setting, printing dark on white (15 September); each chart names the notes it
rests on (17 September).

## The problem

Nearly every part of this item only shows on a page that shows data. The
date, the date statement, the credit lines and the notes are all "on every
page showing data". Today there is no such page. The first ones come in
item 3, the four reference pages, and in item 4, the table of every bill.
The date statement and the footer also link to "what has changed", which is
one of item 3's pages.

Built on its own, item 2 would either link to pages that don't exist or be
tested on nothing. So the first question is how to sequence it.

## What happens, for one bill

Say a beta user is sent a link to the methodology note on how the Legal
Continuity Bill's outcome is coded. They aren't signed in.

1. They get the sign-in page, and nothing of the note. They sign in with
   their code and land on the note they asked for.
2. The header shows Data and Insights beside Privacy.
3. Beside the heading: "Data as at 18 September 2026", read from the live
   copy, and under it the agreed date statement, linking to what has changed.
4. At the bottom, one credit line for each set of terms that page's content
   uses, taken from the copy's `terms` file, then the agreed "provided as it
   is" sentence.
5. The footer: "Data as at 18 September 2026 · What has changed", and the
   independence sentence.
6. In light mode, or printed, it reads the same.
7. If the site cannot read the copy at that moment, they get a plain "can't
   be shown right now" page, and never a broken or half-drawn one.

After a refresh, every one of those dates changes on the next page load,
with nothing restarted.

## Every part

1. **Header links.** "Data · Insights" before "Privacy", signed in only.
2. **The sign-in wall.** One rule in the site's code that every data address
   goes through. Signed out: the sign-in page, then back to the page asked
   for. The way back only ever leads to an address on this site.
3. **The date and the date statement**, one piece every data page uses,
   read from the live copy's `about` file, written out as "18 September 2026".
4. **The credit lines**, one piece, built from the `terms` file in its
   order, with our own line always last.
5. **The notes a page rests on**, one piece: a page names the headings it
   shows, and the notes whose `applies_to` covers those headings are listed,
   each linking to its note. Worked out from the copy, so a note that starts
   applying to a heading shows up without anyone editing the page.
6. **The footer**, switched from "No data published yet" to the agreed
   wording, on every page, signed in or not.
7. **When the copy can't be read**: a page in the same shape as the agreed
   "Signing in isn't possible right now".
8. **Data pages aren't kept by the browser**, as the admin pages already
   aren't, so pressing Back after signing out on a shared computer doesn't
   show them again.
9. **Dark and light, and print**: every part checked in each.

## New words a reader would see, in full

**Signed-out, above the sign-in form, when they asked for a data page:**

> Sign in to see the data.

**When the copy can't be read:**

> DATA
>
> # The data can't be shown right now
>
> Please try again later.

**The notes line, above the credit lines:**

> ## Methodology notes this page rests on
>
> M5 Passing a bill is not the same as the bill being finished
>
> M7 Why a bill fell is our coding, not the factsheets'

(An example for the outcome heading. Each note is shown by its code and
title, as the copy holds them, linked to the note.)

**The Data and Insights pages, until the table and the charts exist:**

> DATA
>
> # Data
>
> The table of every bill, and the whole dataset to download, are being
> built.

> INSIGHTS
>
> # Insights
>
> The charts are being built.

## The five questions

1. **Sequencing.** I recommend building items 2 and 3 together and putting
   them live in one deploy. Each keeps its own layout and closure test. The
   reference pages are the first pages that show data, so they are what the
   parts are tested on, and "what has changed" exists by the time anything
   links to it. The other way is to deploy item 2 on its own, with the date,
   credits and notes built but shown on no page, and its links left out
   until item 3 adds them. That tests less.
2. **The notes part.** The reference pages don't rest on notes; the table
   of every bill is the first page that does. **Recommend:** agree its words
   now, build it with item 4, and test it on the table.
3. **Which credit lines a page shows.** **Recommend:** worked out from the
   copy for everything the page can show, not redone every time a reader
   narrows the table. The credit shouldn't change as a reader filters.
4. **Signed out.** **Recommend:** the Data and Insights links are hidden
   from signed-out visitors; someone following a link to a data page gets
   the sign-in page with "Sign in to see the data." above it, and is taken
   back there after the code.
5. **The words above.** Agree, or amend.

## Not in this item

- The home page's "Nothing is published here yet" stays. It is public
  wording, and a signed-out visitor still sees no data. It is looked at when
  the table goes live.
- No chart parts: the date inside a chart's frame is strand 3's.

## The test, and the undo

Laid out in full with the build, before anything is deployed. In outline:
every data address tried signed out (the sign-in page, and none of the
page's words in what comes back) and signed in; each page's words compared
with `PUBLISHING.md` and the words above; the copy made unreadable on the
rehearsal port, to see the "can't be shown" page; dark, light and print
looked at; the privacy check run after. Signed-in pages are tested on the
live site, by you, or by me through your Chrome with your permission. The
undo is the deploy runbook's rollback. No database change is needed.
