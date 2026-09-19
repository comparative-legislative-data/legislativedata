# Building strand 2, item 4: the table of every bill

Written 19 September 2026, before anything was built. Item 4 of
`docs/PHASE-2.md`, strand 2, as agreed in `docs/STRAND-2-THE-TABLE.md` (with
"After the mock-up") and the mock-up at
https://claude.ai/artifact/TtKMN9rdGhtjxzXgbZP845. Every word a reader sees is
in `docs/wording/PUBLISHING.md`, parts 2 and 8, and the page is compared with
it.

No database changes. The Data page changes: it gains the table and a fifth
reference section, its sections become tabs, and its date statement loses
"See what has changed." That reopens items 2 and 3, whose check and closure
tests change with this build.

## Small choices the agreed documents did not make

Made while building, each the narrowest reading of what was agreed, for the
owner to agree or change after reading the deployed page.

1. **The narrowing is done by the site, not the browser.** Show sends the
   choices to the site in the page's address, and the site draws the page
   with only those bills; Clear goes back to `/data`. This is what makes an
   address like `/data?session=5&title=continuity` work when shared or
   bookmarked. It also works without JavaScript, as a side effect.
2. **A choice in the address that is not on its list is ignored**:
   `session=99` or `type=Nonsense` shows every bill, with the dropdown on
   "All", so the dropdowns and the count always agree with the table. Title
   words are matched ignoring capitals, with ’ and ' treated alike (a title
   in the copy has "Pupils’"), and only the first 100 characters are used.
3. **The dropdowns list only the values some bill has**, in the copy's
   order, as the mock-up did. Today that leaves out "Fell (other)", which no
   bill has; it will appear as soon as one does.
4. **Words on the page the mock-up had and part 8 does not**: "All" as each
   dropdown's first choice; "Bill 305 · Session 5" at the top of an opened
   bill, above its title; "Close" to close it.
5. **Signing in keeps the narrowing.** A signed-out reader sent
   `/data?session=5&title=continuity` returns there after signing in, the
   address rebuilt by the site from the checked choices, never copied from
   what was sent. A link into a section may now contain `_`, and run to 60
   characters, so `/data#words-bill_type` and `/data#h-bills-outcome` survive
   signing in too. They did not before.
6. **The order of "Where each fact came from"**: lines about the bill
   first, in the bills file's heading order, then lines about its stages, in
   stage order.
7. **Dates inside the table and an opened bill are written as the files
   hold them** (2018-12-13), as in the mock-up. The page's own date stays
   written out.
8. **Printing the Methodology notes tab prints each note open**, as
   printing the folded sections did before.
9. **The order of the files in What each heading holds** is the mock-up's:
   bills, stages, days_between_stages and sessions first, as the What has
   changed line names them, then the rest. Nothing settled the download's
   order; item 5 can take this one or say another, and this follows.

## The test

### A. On the server, before anything goes live

`tools/check_data_pages.py`, extended, run on the machine against the staged
release and the live copy, as the site's own login, exactly as for items 2
and 3. It signs nobody in and writes nothing. What it adds or changes:

**Items 2 and 3, amended**
1. The date statement is part 2 word for word, with no link after it.
2. The page opens with part 8's opening sentence, and part 6's "being built"
   sentence is gone.
3. **Six tabs**, in the agreed order, named as agreed: Bills · Methodology
   notes · Sources and terms of use · What each heading holds · What the
   words mean · What has changed. Each has its panel.
4. The reference sections' checks read each section from its tab, not its
   folded section; otherwise unchanged.
5. **Every link into a section lands inside its own tab**, not just
   somewhere after a section opens (the looseness found on 18 September):
   `#M1`, `#M7`, `#M14`, `#methodology-notes` in Methodology notes;
   `#terms-of-use`, `#sources-and-terms` in Sources; `#what-the-words-mean`,
   `#words-outcome` in What the words mean; `#what-has-changed` in What has
   changed; `#h-bills-outcome` in What each heading holds; `#bills` in Bills.
6. The credit lines sit after every tab, so they show under each.

**The table**
7. **All 470 lines, in bill number order**, each line's seven cells as the
   copy has them, with an empty cell empty; each line has its own address,
   `bill-N`.
8. The seven column headings are the files' names, in order, each linking
   to its entry in What each heading holds, which exists.
9. The word *note* after a title on exactly the ten bills that have one.
10. The count line, in part 8's three forms, word for word.
11. **Narrowing, compared with the copy worked out separately**: Session 5
    and "continuity" gives the two bills in the write-up; every session on
    its own, every type, every outcome; a combination; capitals and the
    curly apostrophe; a choice that matches nothing gives part 8's sentence
    and no lines.
12. **The dropdowns**: sessions, types and outcomes as the copy lists them,
    in its order, only those some bill has, each with "All" first; the
    chosen one shown as chosen, and the title box showing what was typed.
13. **Things a reader should not be able to slip in**: a title of
    `<script>` and quotes, shown as text and never obeyed; `session=abc`,
    `session=99`, `type=Nonsense`, an outcome with quotes in it, all
    ignored; a title 5,000 characters long; each gives a page, not an error.
14. Show and Clear as part 8 has them; Clear goes to `/data`.

**An opened bill, all 470**
15. Its three part headings, part 8 word for word.
16. **Every heading of its line, in the file's order, all 34**, each value
    as the copy has it, an empty cell as a dash; beside each heading, the
    codes of exactly the notes that apply to it, each linking to the note.
17. **Its stages**: one line per line of the stages file, in stage order,
    each field as the copy has it, and the copy's sentence where a stage has
    no date.
18. **Where each fact came from**: one entry per line of the sources file
    about that bill (94 bills have any, 177 lines about bills and 1 about a
    stage), each field as the copy has it, an address a link; the 376 with
    none give part 8's sentence.
19. **An address that has gone**, drawn with an invented one and nothing
    written to the copy: part 8's sentence, with the day and the kept copy's
    name; and not shown for an address that works or was not checked.
20. "Link to this bill", pointing at `#bill-N`.
21. Every opened bill sits where no reader sees it until it is opened
    (inside a `template`), so the page does not show 470 bills twice.

**What each heading holds**
22. Its heading and opening sentence, part 8 word for word.
23. **Every heading of every file**, 113 today, each with the description the
    copy stores on it, file by file in the mock-up's order, each file with
    its own description.

**Signed out, and signing in**
24. `/data?session=5&title=continuity` sends a signed-out reader to the
    sign-in page with none of the page's words, including no bill title.
25. Signing in with a return of `/data?session=5&title=continuity` lands
    there; with `/data#words-bill_type` lands there; with a return carrying
    anything else in the address (`/data?next=//example.com`,
    `/data?title=<b>`, `/data?session=5&admin=1`) lands at `/data` with only
    what checked out, or at the home page as before.

It also prints the page's size, sent and unsent, for the record.

### B. The deploy

`tools/deploy_site.sh --stage-only`, then A on the staged release. **Then
wait a full minute with no connection to the machine** (the firewall lesson
of 18 September), then the deploy, with the five usual lines (200, 200, 301,
308, 200) and the releases cleared to three: `20-53-18Z`, `20-54-13Z`, and
this one.

### C. Over the internet, after the deploy

From this Mac: `/data` and `/data?session=5` signed out send to the sign-in
page with none of the page's words; the privacy check
(`tools/check_privacy.sh`) passes. Then A again, on the live release.

### D. Signed in, in a browser

By me, through your Chrome with your permission, then by you. What to look
at:
- the table, and narrowing it: choose Session 5, type "continuity", Show;
  the address changes, the count says 2; Clear;
- open a bill: the pop-up, its address `/data#bill-305`, its head staying
  put while it scrolls; Close, and the list is where it was; Back closes it
  too;
- a code beside a heading in a bill, M7: the pop-up closes and the
  Methodology notes tab opens at M7;
- every tab, and `/data#terms-of-use`, `/data#what-has-changed` typed in;
- the footer's What has changed, from the home page;
- a phone's width: the table keeps number, title and outcome; the pop-up
  fills the screen;
- dark and light; print preview of a tab, and of an open bill;
- signing out, then Back, shows nothing.

## The undo

`tools/deploy_site.sh --rollback`: one step, back to `20-54-13Z`, the page
as items 2 and 3 left it. About two seconds; nothing in either database is
changed, so nothing else needs putting back.

**Rehearsed** after the deploy: roll back, and check that `/data` shows the
folded sections again and no table. Then **switch forward by hand, not by
deploying again**: point the site back at this release and restart, the
same two steps the rollback runs, and the five usual lines. A second deploy
would add a second copy of the same build, and the undo would become two
steps, as it did on 18 September. Afterwards the list of releases the undo
reads ends `20-54-13Z`, this one, so one rollback still goes back to before
the build.

## Afterwards

Item 4's closure test written into `docs/CLOSURE-TESTS.md`, and items 2 and
3's amended where they name sections or the link, for another session to run
all three. The owner reads the deployed table and says whether the house
style holds, and that is recorded (strand 2's "finished when").

## What was done

**Part A, 19 September, on the staged release `2026-09-19T06-15-01Z`.**

- **First run: every check passed**, but the numbering jumped from 102 to
  474. The check's own fault: its loop over the bills reused the name of its
  counter. Renamed; the site was not at fault.
- **Every check passing first time is not evidence**, so a second deliberate
  break was added. `BREAK=2` changes, in what the check expects and not in
  what the site shows, one bill's outcome, one stage's date, one source
  line's note, one heading's description, and part 8's "Link to this bill".
- **Second run: all 113 pass. `BREAK=1` fails at exactly 35 (the date
  statement) and 38 (the credit lines); `BREAK=2` at exactly 85 (the table),
  93 (the narrowing), 104 to 107 (the opened bills' headings, stages,
  sources, and link) and 112 (What each heading holds).**
- **The page's size**: 3,864,391 bytes as the browser builds it, 126,287
  sent. The write-up estimated about 1 MB. The difference is the 470 opened
  bills, each carried in the page until it is asked for.

**Parts B and C, and the undo, 19 September.**

- **Deployed as `2026-09-19T06-16-43Z`**: 200, 200, 301, 308, 200; releases
  cleared to three, `20-53-18Z`, `20-54-13Z` and this one. The deploy builds
  its own release rather than switching the staged one, so part A was run
  again on the live release: **all 113 pass**; the privacy check, **all 15
  pass**. Nothing left in the server's `/tmp`.
- **Over the internet, signed out**: `/data`, `/data?session=5&title=continuity`
  and `/insights` each go to the sign-in page, the narrowing carried in its
  return address, with none of the page's words.
- **The undo, rehearsed.** `--rollback` went to `20-54-13Z`; health and home
  page 200; the Data page, drawn for a made-up reader on the machine, had its
  four folded sections, "See what has changed.", and no tabs or table.
  Switched forward by hand to `06-16-43Z`: the tabs and table back, the link
  gone; 200, 200, 301, 308, 200. The list the undo reads ends `20-54-13Z`,
  `06-16-43Z`, so **one rollback still goes back to before this build.**

**Part D, by the owner, 19 September.** Screenshots of the table, all six
tabs, a note opened, dark and light, and an opened bill in both. All as
agreed. Two things raised:

- **Pages of 10, 100 or all?** Put to the owner: not recommended, since the
  dropdowns and title search are the volume control, pages would break the
  browser's own find, and the write-up agreed one scroll. Open.
- **The bar at the foot of the page could not be found on a long tab.** It
  was there, at the end of the page, below 470 bills. **The owner: it should
  stay in view, or we make it hard for people to find things.** Built the
  same morning: the footer stays at the foot of the screen on every page,
  keeping its own place at the end so it never covers the last lines, and
  printing where it falls. The check gained an item for it (now 114).
  Staged as `06-33-59Z`: all 114 pass; `BREAK=1` fails at 35 and 38,
  `BREAK=2` at 86, 94, 105 to 108 and 113. Deployed as `06-34-47Z`: 200,
  200, 301, 308, 200; releases kept `20-54-13Z`, `06-16-43Z`, `06-34-47Z`.
  On the live release: the page check, all 114 pass; the privacy check,
  all 15 pass; nothing left in `/tmp`.

**The undo is now two steps**: one rollback takes the footer back to the
end of the page; a second takes the table away. Rehearsed for the table,
above; the footer's is the same rollback.

Still to see by eye: Back closing a bill, a note code from inside a bill, a
phone's width, the print preview, and the footer staying in view.
