# The four reference sections of the Data page

For the owner. Written 18 September 2026. Strand 2, item 3 of
`docs/PHASE-2.md`, built and put live together with item 2
(`docs/STRAND-2-SHARED-PAGE-PARTS.md`). Every part is laid out here, with
four questions at the end. **Not yet agreed.**

Already settled, and not asked again: four sections at the foot of the Data
page, folded away, each with its own link (18 September); each read from the
live copy; the Terms of use wording (`docs/wording/PUBLISHING.md`, part 4);
"What has changed" carries forward every change from every refresh, so it
grows (strand 1, the refresh).

## What happens, for one bill

A reader looking at the Legal Continuity Bill wants to know why its outcome
reads as it does. They follow a link to M7. The Data page opens with the
methodology notes section unfolded at M7, "Why a bill fell is our coding, not
the factsheets'", in full, with the headings it applies to beneath it. The
other thirteen notes are there as titles, each opening on a click.

If a refresh later corrects the bill's third-stage date, "What has changed"
gains a line: the day of that copy, the bill, the heading, what it said and
what it says now. The date statement at the top of the page links straight
there.

## The four sections, in this order

Each is a heading that opens and closes. Each opens on its own when a link
points into it. Nothing in them is typed into the site: every line is read
from the copy when the page is asked for, so a refresh changes them with no
one editing a page.

1. **Methodology notes.** All fourteen, M1 to M14, each its code and title,
   opening to the note in full and "Applies to:" with the headings from the
   copy's `applies_to`. Each note has its own link (…/data#M7), which is
   what a chart will point to later. About 20,000 characters in all.
2. **Sources and terms of use.** The agreed Terms of use, word for word: the
   opening paragraph, then one block per set of terms. Under each block's
   "Covers", each source it covers, with the copy's own sentence saying what
   that source is (the ten `source` lines of `what_the_words_mean`). Its
   Terms of use heading is where every credit block's last sentence links.
3. **What the words mean.** All 89 lines, under their 17 headings, each word
   with its meaning, in the copy's order. This repeats the ten source
   sentences, so that this section is the whole of the file.
4. **What has changed.** Every line of `what_changed`, newest copy first: the
   day, the bill number, the stage or line it's about, the heading, what it
   said, and what it says now. A removed line shows as "(line removed)", as
   the copy records it. Today it is empty. Underneath, how many lines this
   copy added, from `about`, where the copy records it.

**Credit lines on the Data page**: all four sets of terms, since the page
carries the whole dataset.

## New words a reader would see, in full

Section headings:

> Methodology notes
>
> Sources and terms of use
>
> What the words mean
>
> What has changed

Under "Methodology notes":

> The judgements made in coding the data, each in full, with the headings it
> applies to.

Under "What the words mean":

> What each word in the data's fixed lists means, under the heading it
> appears in.

Under "What has changed":

> Every published value a refresh has changed, newest first, with what it
> said before and what it says now. A line added is counted, not listed.

When nothing has changed:

> Nothing has changed since the data was first published.

The added lines, when a copy added some:

> Added in the copy of 18 September 2026: 3 lines to bills, 9 to stages.

When the copy is the first (its `about` has no added counts):

> This is the first copy of the data.

One block of Sources and terms of use, as it would read. The block itself is
agreed; what is new is each source's line under "Covers":

> ### Scottish Parliament
>
> **Covers:**
>
> Parliament API — The Scottish Parliament's open data, at
> data.parliament.scot. No fact in this data rests on it.
>
> SPICe legislation factsheet — One of SPICe's per-session legislation
> factsheets: …
>
> (and so on, for each source it covers)
>
> **Licence:** Scottish Parliament Copyright Licence
>
> **Credit line:** …
>
> **What it does not allow, in its own words:** …
>
> **Terms read on** 18 September 2026, at parliament.scot/about/copyright.

## The four questions

1. **Notes folded one by one.** Recommend: the section opens to fourteen
   titles, and each note opens on its own. The alternative is all fourteen
   in full, about eight screens.
2. **Each source's sentence under its terms**, as above, rather than the
   bare list of names the agreed block has now. Recommend yes: a name like
   "Manual" means nothing without it, and the sentence is already in the
   copy.
3. **"What the words mean" keeps the ten source lines**, repeating them from
   the Sources section, so the section is the whole file. Recommend yes.
4. **The words above.** Agree, or amend.

## Not in this item

- **The pages we kept of every cited source** (`cited_pages`, 106 lines).
  They belong with the route from a bill to its provenance, which is the
  table's write-up (item 4).
- **Provenance notes** (`sources`, 192 lines): also the table's, bill by
  bill.
- **The workings**: in the zip (item 5), and with each chart in strand 3.

## The test, and the undo

The same deploy and test as item 2. This item's own checks are mechanical:
every line of `methodology_notes`, `terms`, `what_the_words_mean` and
`what_changed` appears on the page, word for word, compared by a program
against the copy, and nothing appears that the copy doesn't hold. "What has
changed" is empty today, and a thrown-away refresh never reaches the site,
so how it draws a line is checked by drawing the section, on the server, with
invented lines of every kind (a changed cell, a removed line, a line about a
session); nothing is written to the copy. Each link (#M7, #terms-of-use,
#what-has-changed) opens its section. Then you read the page. The undo is the
deploy runbook's rollback.
