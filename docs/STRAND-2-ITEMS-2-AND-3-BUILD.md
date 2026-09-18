# Building strand 2, items 2 and 3: the test, the undo, and what was done

Written 18 September 2026, before anything was built. Items 2 and 3 of
`docs/PHASE-2.md`, strand 2, as agreed in `docs/STRAND-2-SHARED-PAGE-PARTS.md`
and `docs/STRAND-2-REFERENCE-SECTIONS.md`. Every word a reader sees is in
`docs/wording/PUBLISHING.md`, and the pages are compared with it.

No database changes. The site gains two pages, `/data` and `/insights`, and
every page gains the footer.

## Small choices the agreed documents did not make

Made while building, each the narrowest reading of what was agreed. **All six
agreed by the owner on 18 September 2026**, after reading the deployed pages.

1. **The order of the credit lines and the Terms of use blocks.** The copy's
   `terms` file has no column saying its order. The pages put each set of
   terms in the order of the first source it covers in `what_the_words_mean`'s
   list of sources, and our own last, because it covers no named source. That
   gives the agreed order: Scottish Parliament, legislation.gov.uk, Supreme
   Court, our own.
2. **Where a licence's name links.** Its name where the credit line uses it in
   full; otherwise the short form in its brackets. Ours reads "CC BY 4.0" in the
   credit line, so that is the link.
3. **The footer when the copy can't be read.** A page that is not a data page
   (home, privacy, apply, sign-in) still draws, with the independence sentence
   and no date, rather than a wrong date or a failed page.
4. **Where signing in returns to.** Only the Data or Insights page, with its
   section if the link had one. Any other return address is ignored and the
   reader lands on the home page, as today. That is stricter than "any address
   on this site", and is why nothing can be slipped into it.
5. **The added lines** name each file as the download will name it, "9 to
   days_between_stages", and give only the files that gained lines.
6. **Printing the Data page opens every section**, so what is folded prints.

## The test

### A. On the server, before anything goes live

A program, `tools/check_data_pages.py`, run on the machine against the staged
release and the live copy, as the site's own login. It signs nobody in and
touches no account: it stands in a made-up reader in the site's place for
"signed in". It prints each check as passed or failed.

1. **Signed out**, `/data`, `/data?x=1` and `/insights` each send the reader to
   the sign-in page and nothing else, and what comes back holds none of the
   page's words (no note title, no heading, no credit line).
2. **The sign-in page, on the way to a data page**, says "Sign in to see the
   data." above its form, and carries the return address through to the code
   page. Signing in with a return of `/data#M7` lands at `/data#M7`. A return
   of `//example.com`, `https://example.com`, `/admin` or `/data/../admin`
   lands on the home page.
3. **Signed in**, both pages answer, neither is kept by the browser, and the
   header reads "Data · Insights · Privacy".
4. **The date**, beside the Data page's heading and in the footer, is the
   copy's `about` date written out, and the date statement is `PUBLISHING.md`
   part 2 word for word.
5. **The credit lines** on the Data page are all four, from the copy, in the
   order above, followed by the two agreed sentences, compared with
   `PUBLISHING.md` part 3 word for word. Each licence link goes to the copy's
   `licence_link`.
6. **The footer**, on every page signed in and signed out, is part 1 word for
   word.
7. **Methodology notes**: fourteen notes, no more, each code, title, every
   paragraph and every "Applies to" heading as the copy has it.
8. **Terms of use**: the opening paragraphs word for word with part 4; four
   blocks, no more, each field as the copy has it; under "Covers", each source
   with its sentence from the copy.
9. **What the words mean**: 89 lines, no more, under 17 headings, each as the
   copy has it, in its order.
10. **What has changed**: today, "Nothing has changed since the data was first
    published." and "Added in the copy of 18 September 2026: no lines." Then
    drawn with invented lines, nothing written to the copy: a changed cell in
    bills, a changed cell in stages, a removed line, a line about a session,
    and an emptied cell, over two copies, newest first; and the added line
    with some, none, and the first copy.
11. **The Insights page** carries no date statement and no credit lines, and
    the agreed words.
12. **The copy made unreadable** (the site pointed at a workbook that doesn't
    exist): `/data` gives "The data can't be shown right now" with nothing
    half-drawn; home, privacy and sign-in still draw, with no date.
13. **Every link into a section** (`#M7`, `#terms-of-use`,
    `#what-has-changed`, `#what-the-words-mean`, `#methodology-notes`) has
    something on the page to land on, inside a section that can open.

### B. The deploy

`tools/deploy_site.sh --stage-only`, then A on the staged release, then the
deploy with the five usual lines (200, 200, 301, 308, 200).

### C. Over the internet, after the deploy

From this Mac: `/data` and `/insights` signed out send to the sign-in page with
none of the page's words; the home page carries the new footer; the privacy
check (`tools/check_privacy.sh`) passes.

### D. Signed in, in a browser

By the owner, or by me through the owner's Chrome with their permission.
Opening `/data#M7` opens M7; `#terms-of-use` and `#what-has-changed` open their
sections; the credit block's "Terms of use" link lands there. Dark, light, and
the print preview. Signing out, then Back, does not show the page again.

## The undo

`tools/deploy_site.sh --rollback`. About two seconds; nothing in either
database was changed, so nothing else needs putting back.

**Rehearsed**: after the deploy, roll back (the home page loses the new footer,
`/data` is a 404), then deploy again.

## Afterwards

Both closure tests written into `docs/CLOSURE-TESTS.md`, one per item, for
another session to run.

## What was done

**Part A, 18 September, on the staged release `2026-09-18T20-52-22Z`.**
`--stage-only` rehearsal: health and home page 200. The check then ran:

- **First run, 65 of 68.** The three failures were the check's fault, not the
  site's: it expected the return address written `next=%2Fdata`, and the site
  writes `next=/data`, which is the same address. The check was corrected.
- **Second run, all 68 pass.** The deliberately broken run (`BREAK=1`) also
  passed, which it must not: the phrase it changed wraps across two lines of
  `PUBLISHING.md`, so it changed nothing. It now changes two phrases that sit
  on one line each, and refuses to run if either is missing.
- **Third run: all 68 pass; `BREAK=1` fails at exactly 26 (the date
  statement) and 29 (the credit lines).** Nothing left in the server's `/tmp`.

**Parts B and C, and the undo, 18 September.**

- **Deployed as `2026-09-18T20-53-18Z`.** Steps 1 to 4 ran; step 5 was
  refused by the firewall, because the deploy was started too soon after the
  check's connection. The site had switched: checked over the internet, the
  home page carried the new footer, and `/data` and `/insights` sent a
  signed-out reader to the sign-in page with none of their words. Steps 5
  and 6 were then run by hand, as the script has them: 200, 200, 301, 308,
  200; releases cleared to three.
- **The undo, rehearsed.** `--rollback` went to `2026-09-18T17-39-56Z`,
  health and home page 200; `/data` gave 404 and the footer read "No data
  published yet" again.
- **Deployed again as `2026-09-18T20-54-13Z`.** Step 5 refused again, for
  the same reason; after a proper wait, steps 5 and 6 by hand: 200, 200, 301,
  308, 200; three releases kept.
- **On the live release**: `check_data_pages.py`, all 68 pass;
  `check_privacy.sh`, all 15 pass. Nothing left in the server's `/tmp`.

**The undo is now two rollbacks, not one.** The three releases kept are
`17-39-56Z` (the site before this build), `20-53-18Z` (this build, the first
time) and `20-54-13Z` (this build, live). One `--rollback` goes to
`20-53-18Z`, which is the same code; a second goes back to before the build.
The next deploy clears `17-39-56Z` away.

**Lesson for the runbook, not yet written into it:** the half-minute wait
applies after a rollback as well as after any other connection, and a deploy
started inside it switches and then fails at step 5, which leaves the site
switched and unchecked.
