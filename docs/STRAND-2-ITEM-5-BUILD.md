# Building strand 2, item 5: the zip

Written 19 September 2026, before anything is built. **Not yet agreed.**
Item 5 of `docs/PHASE-2.md`, strand 2. Every word a reader sees is in
`docs/wording/DOWNLOAD.md`, agreed the same day, and the zip and the page
are compared with it.

No database changes. The Data page gains the download box and loses "is
being built"; the privacy page gains its line; the site gains one address,
the zip's. Item 6, the refresh building the zip, comes after this and is
not part of it.

## How it works, in the order things happen

1. **The zip is made from the copy, once**, not each time someone asks for
   it. A small program reads the copy through the site's own login, which
   can only read, and writes the fifteen files into
   `legislativedata-2026-09-18.zip`. The readme's "Downloaded on" line is
   left as a blank to fill.
2. **It is kept on the machine** in a folder of its own, `/srv/downloads`,
   outside the site's releases, so a deploy or a rollback never touches it.
   The site can read the folder and not write to it. It is not backed up:
   it can be remade from the copy at any time, as the copy can from the
   working data, and it holds nothing about anyone.
3. **The Data page shows the download box** only when there is a zip whose
   date is the copy's date. The size on the link is the file's own.
4. **A signed-in reader asks for it.** The site fills in the readme's
   "Downloaded on" line with the day in the UK and hands the zip over.
   Nothing else in it changes; nothing in it names the reader, and two
   readers on the same day get exactly the same file.
5. **A signed-out visitor** asking for the zip's address goes to the
   sign-in page, and from there to the Data page.

The program that makes the zip and the part of the site that hands it over
are one piece of code, so the readme and codebook have one definition.

## Small choices the agreed documents did not make

For the owner to agree or change before building.

1. **The zip's address**: `/download/legislativedata-2026-09-18.zip`, the
   same as its name. An older date's name, from a link someone kept, goes
   to the Data page, where the current one is; a name that was never a zip
   gives "not found".
2. **If there is no zip for the copy's date**, the download box is left
   off the Data page, and the zip's address says "The data can't be shown
   right now. Please try again later." (part 6's words), rather than new
   wording. It happens only if a refresh takes a new copy before item 6
   teaches it to make the zip. No refresh is planned until item 6 is built.
3. **The CSV files**: a comma between cells; a new line as Windows writes
   it, the standard for CSV; UTF-8 with no marker at the start, since the
   marker helps Excel and confuses R and Python; quotation marks only where
   a cell needs them; an empty cell is empty. Lines in the order the site
   shows them: bills by number, stages by bill and stage, the rest by their
   own first columns. All 192 lines of sources, not only the 178 about a
   bill that the site shows.
4. **The codebook's "Worked out or read" line.** On the four data files'
   headings only; the other eight files are about the data, not the data.
   In bills, stages and sessions: "Read from its source". In
   days_between_stages, every heading: "Worked out from bills and stages;
   the working is in workings", with the rule added where the heading's own
   description gives one, as `days`'s does.
5. **The codebook's "Type"**: number, date or text as the copy stores it,
   and "yes or no" for the seven headings whose description begins "Yes"
   (got_through, bill_passed and the like).
6. **The codebook's "Words it can hold"**: every line of
   what_the_words_mean under that heading's name, as the site's What the
   words mean does, in its order. Left out for a heading with none.
7. **The size on the link** to one decimal place of a megabyte.
8. **The day on "Downloaded on"** is the day in the UK when the zip is
   handed over.

## The test

### A. On the machine, before anything goes live

`tools/check_data_pages.py`, extended, run as the site's own login against
the staged release and a zip made into a scratch folder, exactly as for
item 4. It signs nobody in and writes nothing. The two deliberate breaks
stay, and a third is added.

**The Data page**
1. The download box is `DOWNLOAD.md` part 2, word for word, with the copy's
   date and the file's size.
2. The link goes to the zip's address; "Ask for another format" opens an
   email to comparativelegislativedata@gmail.com with the agreed subject.
3. Part 8's opening sentence without "is being built".
4. With no zip for the copy's date: no box, and the rest of the page as
   before.

**The zip, as handed to a made-up reader**
5. Signed out, the zip's address goes to the sign-in page and gives none of
   the file. Signed in, it is a zip, offered as a download under its name,
   and not kept by the browser.
6. One folder, holding exactly the fifteen files named in the readme.
7. **Each of the twelve CSV files against the copy, asked afresh**: the
   same headings in the same order, the same number of lines, and every
   cell as the copy has it, dates year-month-day, an empty cell empty.
8. Every file reads as UTF-8, with no marker; a title with a curly
   apostrophe survives.
9. **The readme is part 3 word for word**, with the copy's date, today's
   date in the UK, each file's count and line from the copy, and the credit
   lines from the terms file.
10. **The codebook**: its opening is part 4's; one entry for each of the
    113 headings, in the readme's order of files; each description, type,
    set of words and set of notes as the copy has them; the worked-out
    lines as in small choice 4.
11. The working's text file is the working in workings, character for
    character.
12. **Two made-up readers, the same day, get the same file, byte for
    byte**, and nothing in any file, or in what the site sends with it,
    carries either reader's name, email or marker.
13. The zip handed over differs from the zip on the machine only in the
    "Downloaded on" line.
14. **Made again from the copy, the zip is the same byte for byte**, so
    the one on the machine is shown to be the copy's and nothing else.
15. An older date's name goes to the Data page; a made-up name, not found;
    with no zip, part 6's words.

**The breaks**
- `BREAK=1` and `BREAK=2` as now, each failing at exactly its items.
- `BREAK=3`: one cell of one file and one word of the readme changed in
  what the check expects. It must fail at exactly items 7 and 9.

**The privacy page**: `tools/check_privacy.sh` against the new wording,
all pass; its own break fails where it should.

### B. The deploy

The zip made and put in `/srv/downloads`. `tools/deploy_site.sh
--stage-only`, then A on the staged release. **A full minute with no
connection to the machine**, then the deploy: the five usual lines (200,
200, 301, 308, 200), and the releases cleared to three: `06-16-43Z`,
`06-34-47Z`, and this one.

### C. Over the internet, after the deploy

From this Mac: the zip's address signed out goes to the sign-in page with
none of the file; `/data` signed out as before; the privacy check passes
**after the zip has been served**, as settled. Then A again on the live
release.

### D. Signed in, in a browser

By me first, through your Chrome with your permission, then by you:
- the download box at the top of the Data page, above the tabs, in dark
  and light and at a phone's width;
- download it: the name, and it opens to one folder of fifteen files;
- the readme read through, with today's date on "Downloaded on";
- bills.csv opened in a spreadsheet, imported as the readme says: 470
  lines, the dates as written;
- "Ask for another format" opens your email with the address and subject;
- the privacy page's new line, and its "Last changed" date.

## The undo

`tools/deploy_site.sh --rollback`: one step, back to `06-34-47Z`, the Data
page as item 4 left it, and the privacy page as before. The zip stays in
`/srv/downloads`, handed to nobody, and can be left or removed. Nothing in
either database changes.

**Rehearsed** after the deploy, as for item 4: roll back, check the Data
page has no download box and the zip's address is not found; then switch
forward by hand, not by deploying again, so one rollback still goes back to
before this build.

## Afterwards

Item 5's closure test written into `docs/CLOSURE-TESTS.md` for another
session to run, with items 2 to 4's where the download changes them (the
opening sentence, and the check's numbering). Then item 6: the refresh
makes the zip from each new copy before it goes live, rehearsed with its
undo.

**Known now, for item 6**: the copy is named by its day, so two refreshes
on one day would give two different zips the same name. Item 6 says what
happens then.

## Size

One session to build, check and deploy, then the owner's part D. The
closure test is written the same session and run by another.
