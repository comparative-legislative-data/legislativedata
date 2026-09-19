# Wording: the download

For the owner. Strand 2, item 5 of `docs/PHASE-2.md`. **Agreed by the owner on 19 September
2026, every part as drafted**, with the four questions answered below. A
download is built from this word for word; change the wording here first.
Every word a reader of the download will see is below, in full, except what
is generated from the copy, which is marked *[from the copy]* and shown with
today's values.

What is settled already, and not put again: one zip; CSV; dates as
year-month-day; the date alone, in the file name, readme and citation; the
readme giving each file's row count; the Comparative Agendas Project in one
sentence, no comparison; a codebook to the UK Data Service's minimum,
generated from the copy's own descriptions; the credit lines and the terms as
held in the copy; a link for asking for another format, which opens the
reader's own email; the privacy page saying so (`DECISIONS.md`,
17 and 18 September).

---

## Four questions, answered by the owner, 19 September

1. **Which files go in the zip: all twelve**, under the same names as on
   the site, plus the readme, the codebook, and the working as a plain text
   file of its own.
2. **Both dates**: the day the data was taken, which is also the day the
   zip was made, since the refresh builds both together; and the day it was
   downloaded, written into the readme by the site as it hands the zip
   over. It names nobody.
3. **The citation covers both the data and the site**: the data was taken
   from the site, and the site was created and is maintained by the owner.
4. **Format requests go to comparativelegislativedata@gmail.com**, the
   address the privacy page already gives.

---

## 1. The file's name

> legislativedata-2026-09-18.zip

Unzipped, everything is inside one folder of the same name, so a reader's
downloads folder does not fill with loose files.

## 2. At the top of the Data page, above the tabs

> Download the whole dataset
>
> Every file, with a readme and a codebook, as CSV in one zip. Data as at
> 18 September 2026.
>
> Download legislativedata-2026-09-18.zip (0.4 MB)
>
> Ask for another format

The size is worked out when the zip is built; 0.4 MB is a guess. "Ask for
another format" opens the reader's own email, addressed to
comparativelegislativedata@gmail.com, with the subject line:

> Another format for the legislativedata.org data

Part 8's opening sentence loses its last sentence, "The whole dataset, to
download, is being built.", and reads:

> Every bill introduced in the Scottish Parliament since 1999, one line
> each. Open a bill to see everything recorded about it, and where each
> fact came from.

## 3. The readme, `README.txt`

Plain text, in full. Row counts and each file's line are *[from the copy]*.

> legislativedata.org: bills of the Scottish Parliament
> Data as at 2026-09-18, the day this copy was taken and this zip made
> Downloaded on 2026-09-19
>
>
> SUGGESTED CITATION
>
> MacGregor, Steven (2026). Bills of the Scottish Parliament, data as at
> 2026-09-18 [dataset]. legislativedata.org, created and maintained by
> Steven MacGregor. https://legislativedata.org. Downloaded 2026-09-19.
>
>
> WHAT THIS IS
>
> Every bill introduced in the Scottish Parliament since 1999, one line
> each, with the day each of its stages ended, what the Parliament did with
> it, and where each fact came from.
>
> legislativedata.org is an independent research resource. It is not the
> Scottish Parliament's, and the Parliament has not endorsed it.
>
>
> THE DATA IS AS IT STOOD ON 2026-09-18
>
> The data is corrected and added to as sources are revised and more of
> them is read. Earlier versions are not kept, and none is offered. If your
> work needs a fixed version, keep this download: its date identifies it,
> and is the date to cite. What has changed since is listed in
> what_changed.csv in any later download, and under What has changed on the
> Data page.
>
>
> THE FILES
>
> Every file is CSV, in UTF-8, with a first line naming its headings. The
> numbers of lines below do not count that first line.
>
> bills.csv  470 lines
>   One line per bill introduced in the Scottish Parliament since 1999,
>   with the day each of its stages ended.
>
> stages.csv  1291 lines
>   One line per stage a bill reached, with everything recorded about it.
>
> days_between_stages.csv  1657 lines
>   Worked out from bills and stages: one line per gap between two dated
>   points in a bill's passage, and the calendar days it took. The working
>   is in workings.
>
> sessions.csv  7 lines
>   One line per session of the Parliament, with its first and last days.
>
> methodology_notes.csv  14 lines
>   The judgements made in coding the data, one note per line, in full.
>
> sources.csv  192 lines
>   One line per fact that names its own source, where that is not the
>   source of the rest of its line.
>
> what_the_words_mean.csv  89 lines
>   What each word in the other files means, one line per heading and word.
>
> what_changed.csv  0 lines
>   Every published value that differs from the copy before, one line per
>   cell.
>
> workings.csv  1 line
>   The working that produced each worked-out file, in full, as it ran when
>   this copy was taken.
>
> about.csv  12 lines
>   The day this copy was taken, and how many lines each file has.
>
> cited_pages.csv  106 lines
>   One line per web page the sources cite, with the copy we keep of it and
>   whether its address still worked when this copy was taken.
>
> terms.csv  4 lines
>   The terms each source's data is published under, and how to credit it.
>   A value whose source is listed under covers is under that line's terms;
>   everything else is our own work.
>
> codebook.txt
>   Every heading in every file, with what it holds and what an empty cell
>   under it means.
>
> working-days_between_stages.txt
>   The working in workings.csv, as plain text, the same text the site
>   shows.
>
>
> DATES, AND OPENING THE FILES IN A SPREADSHEET
>
> Dates are written year-month-day: 2003-03-20. A spreadsheet can change a
> date, or drop a leading zero, when it opens a CSV file directly. To keep
> every cell as written, import the file rather than open it, and set its
> date headings to text. The numbers of lines above are there to check the
> whole file arrived.
>
>
> SOURCES AND LICENCE
>
> Values from the Scottish Parliament: Contains information licensed under
> the Scottish Parliament Copyright Licence
>
> Values from legislation.gov.uk: Contains public sector information
> licensed under the Open Government Licence v3.0.
>
> Values from the Supreme Court: Contains public sector information licensed
> under the Open Government Licence v3.0.
>
> Everything else: Contains data from legislativedata.org, licensed under
> CC BY 4.0. Stage 1 and Stage 2 dates compiled for Steven MacGregor, 'Does
> government dominate the legislative process?' (PhD thesis, University of
> Stirling, 2021).
>
> This data is provided as it is, with no warranty. legislativedata.org is
> not responsible for what anyone does with it.
>
> What each source allows, and does not, is in terms.csv, in each source's
> own words, with a link to each licence. When you use the data, include
> the credit line for each source your use draws on.
>
>
> A RELATED DATASET
>
> The Comparative Agendas Project's Scottish Bills codes the topics of 161
> bills of the Scottish Parliament from 1999 to 2008:
> https://www.comparativeagendas.net/datasets_codebooks
>
>
> ANOTHER FORMAT
>
> To ask for the data in another format, write to
> comparativelegislativedata@gmail.com.

The four credit lines are *[from the copy]*, as the site's are, in the
`terms` file's order; the two sentences after them are part 3's and part 4's
agreed wording.

## 4. The codebook, `codebook.txt`

Generated from the copy's own descriptions, so only its opening and the shape
of an entry are wording. Every file in the readme's order, and every heading
in the file's order.

> legislativedata.org: codebook
> Data as at 2026-09-18
>
> Every heading in every file, with what it holds and what an empty cell
> under it means. The same descriptions are on the Data page, under What
> each heading holds.

Then, for each file, its name and line, and for each heading an entry like
this one *[from the copy]*:

> bills.outcome
>   What the Parliament did with the bill.
>   Type: text
>   Worked out or read: read from its source
>   Words it can hold (each explained in what_the_words_mean.csv):
>     Passed; Rejected at Stage 1; Rejected at Stage 3; Withdrawn; Fell at
>     dissolution; Fell (other); Fell: financial resolution not agreed;
>     In progress
>   Methodology notes that bear on it: M5, M7, M13

"Worked out" lines name the columns and the rule, as the days_between_stages
file's `days` does: "Worked out: date_measured_to minus date_measured_from,
in calendar days." Type is one of text, number, date, or yes or no.

## 5. The privacy page's added line

At the end of "If you only read the site", as a third paragraph:

> The link for asking for the data in another format opens your own email.
> The site sees nothing of it, and your message reaches us like any other
> email.

"Last changed" moves to the day it goes live.
