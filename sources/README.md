# Sources

Retrieved copies of source documents, kept because published records change and
because a figure in this project must be traceable to the exact document it came
from — not to a URL whose contents have since moved on.

## Convention

    <publisher>-<what-it-is>-<scope>_retrieved-<YYYY-MM-DD>.<ext>

The retrieval date is part of the filename, not metadata, so that two copies of
a revised document sit side by side and sort correctly. Never overwrite a
retrieved file: fetch again under a new date and keep both.

Each entry below records where it came from, when, and anything odd about it.

## factsheets/

SPICe factsheets on primary legislation, one per parliamentary session. These
are the best available source for the first slice, because SPICe has already
made the outcome-by-type derivation that the API does not expose.

**They are derived documents.** SPICe made coding decisions to produce them, so
data taken from them is attributed to the factsheet, not recorded as our own.
The `bill.source` value for such rows should say so.

| File | Session | Retrieved | SHA-256 (first 16) |
|---|---|---|---|
| `spice-legislation-session-1_retrieved-2026-09-10.pdf` | 1 | 2026-09-10 | `5a2a94205aedc3c5` |
| `spice-legislation-session-2_retrieved-2026-09-10.pdf` | 2 | 2026-09-10 | `b49e60ce18688eb9` |
| `spice-legislation-session-3_retrieved-2026-09-10.pdf` | 3 | 2026-09-10 | `f740f34c2764d08e` |
| `spice-legislation-session-4_retrieved-2026-09-10.pdf` | 4 | 2026-09-10 | `2af392edcf2465b4` |
| `spice-legislation-session-5_retrieved-2026-09-10.pdf` | 5 | 2026-09-10 | `d50d7bf6e6bbb14f` |
| `spice-legislation-session-6_retrieved-2026-09-10.pdf` | 6 | 2026-09-10 | `0eb5947425132e4d` |
| `spice-legislation-session-7_retrieved-2026-09-10.pdf` | 7 | 2026-09-10 | `960314172819f504` |

All seven sessions are held. Sessions 6 and 7 were fetched from
`parliament.scot/-/media/files/spice/factsheets/parliamentary-business/`;
sessions 1-5 were downloaded by the owner from the archive site, which sits
behind a Cloudflare challenge that scripted fetching cannot pass.

**Session 3 arrived named `NEW_VERSION`.** The Parliament had reissued it. That
is the revision problem in the open, on the first day of collecting: the file
under a stable description is not stable. The retrieval date in the filename is
what makes a later reissue additive rather than an overwrite.

**Session 5 was downloaded twice.** The copies were byte-identical, so one was
removed.

**Session 6 was unlinked, not deleted.** On 2026-09-10 it had been removed from
the fact sheets index — Session 7 was posted that day — but had not reached the
archive. The file was still served at its old address. Sessions 1–5 are on the
archive site, which sits behind a Cloudflare challenge that scripted fetching
cannot pass.

## procedure/

The Parliament's own plain-English pages on how bills progress. They are quoted
as evidence for how stage completion is defined for each kind of bill
(`docs/DECISIONS.md`, "Stage 1 and Stage 2 completion dates, from the PhD").
Saved as the HTML the site served, scripts and all, so the words quoted can be
found in the file.

**They describe today's procedure,** not procedure at the time of a given bill,
and neither page carries a date of its own. That is why a copy is kept.

| File | Page | Retrieved | SHA-256 (first 16) |
|---|---|---|---|
| `parliament-about-private-bills_retrieved-2026-09-11.html` | parliament.scot/bills-and-laws/about-bills/about-private-bills | 2026-09-11 | `1079627057ad9fb1` |
| `parliament-about-hybrid-bills_retrieved-2026-09-11.html` | parliament.scot/bills-and-laws/about-bills/about-hybrid-bills | 2026-09-11 | `0f752e13a58af970` |

## licences/

The terms the sources were published under, kept because a licence page changes
like any other page, and what we pass on to a reader has to rest on what it
said.

| File | What | Retrieved | SHA-256 (first 16) |
|---|---|---|---|
| `spcb-licence-2017-archived_retrieved-2026-09-17.txt` | The Scottish Parliament Copyright Licence, 2017 | 2026-09-17 | `10ef8f0c5dcf712d` |

**The 2017 licence is text, not the PDF.** It sits at
`archive2021.parliament.scot/Fol/Scottish_Parliament_Licence_2017.pdf`, behind
the same Cloudflare challenge as Sessions 1–5's fact sheets. The owner opened it
in their browser and copied the text, which is this file, line breaks as the
copy gave them. It is the licence of the old site, where Sessions 1–5's fact
sheets are.

**It differs from today's licence** (`parliament.scot/about/copyright`, as
`docs/PHASE-2-RESEARCH-LICENCE.md` §2.1 quotes it) in two places only. Its
credit line reads "Contains information licenced under the Open Scottish
Parliament Licence V.2", against today's "…licensed under the Scottish
Parliament Copyright Licence", and its own title is not the name in that line.
And it carries only the narrower party-political and advertising ban, on
"downloadable files such as images and video footage"; today's copyright page
adds the broader "provided in any format". The 2017 policy page, if there was
one, was not seen. Settled 17 September: every Scottish Parliament value is
credited under today's licence, with today's broader ban passed on.

## factsheets/, continued

**That path serves soft 404s.** A missing factsheet returns HTTP 200 with an
HTML error page, not a 404. Any check based on status code will report success
and store an error page. Verify `content_type` is `application/pdf`, or check
the file begins `%PDF`.

## Every page the provenance cites: `kept-pages.csv`

Strand 1, item 4 of `docs/PHASE-2.md`, settled 17 September: every outside page
a provenance line or a stage date cites has a copy kept, so a reader can still
see what it said if the address dies or the page changes. **106 addresses on
18 September**, all kept. `kept-pages.csv` lists each one: the address as cited,
the file it is kept as, the day it was retrieved, what the site said it was,
its size, and its SHA-256. It is the list the refresh checks the addresses
against (item 6), so it is kept in one file rather than tables here.

`tools/keep_cited_pages.py` reads the cited addresses from the working
database, fetches any not yet listed, and refuses what is not the page: an
error, the archive's browser check, a PDF address that did not return a PDF, or
a "page not found" served as a page. `--list` shows what is cited and kept.

**The 14 pages on the old site's archive** (`webarchive.nrscotland.gov.uk`) sit
behind a browser check that scripted fetching cannot pass. They were read on 18
September through the owner's Chrome, with their permission, by fetching each
archived page from inside the archive's own tab, and saved byte for byte. What
is kept is the old site's page as the archive captured it, not the archive's
frame around it; the archive's capture date is not recorded.

## bill-pages/

The Parliament's own page for each bill whose dates or facts are cited from it:
30 on today's site, 14 from the old site's archive (`parliament-archive2021-bill-<id>`,
the old site's page number). Saved as the HTML served.

**One page's title is wrong on the Parliament's side.**
`parliament-bill-s1-tobacco-advertising-and-promotion-scotland-bill` is the
Tobacco Advertising and Promotion (Scotland) Bill, introduced 5 November 2001,
as its heading and body say; the title in the page's own `<title>` tag reads
"Tobacco and Primary Services Scotland Bill". Checked 18 September.

## official-report/

The Official Report of each meeting cited: 27 as the Parliament's web page for
the meeting (`parliament-official-report-<dd-mm-yyyy>-meeting-<id>`), and 6 as
the PDF the Parliament serves for older meetings
(`parliament-official-report-meeting-<id>`, 2000 to 2011). Each was opened and
its heading read against the date cited.

## legislation/

The law that sets when the Parliament's sessions end, kept because the expected
last day of a running session is worked out from it (`db/104`, methodology note
M14). Saved as the HTML legislation.gov.uk served, so the words relied on can be
found in the file. **Each page is the revised text as it stood on the day it
was retrieved**, amendments applied; a later amendment changes the page, not
this copy.

| File | Page | Retrieved | SHA-256 (first 16) |
|---|---|---|---|
| `legislation-scotland-act-1998-section-2_retrieved-2026-09-17.html` | Scotland Act 1998, s2, ordinary general elections | 2026-09-17 | `2820dccb71c32f52` |
| `legislation-scottish-parliament-elections-order-2015-article-84_retrieved-2026-09-17.html` | SSI 2015/425, art 84, the minimum period: 20 days since SSI 2025/313 | 2026-09-17 | `423f0e777d1b6a5c` |
| `legislation-scottish-parliament-elections-order-2015-schedule-2-rule-2_retrieved-2026-09-17.html` | SSI 2015/425, sch 2 rule 2, computation of time | 2026-09-17 | `5c4840abc297db1f` |

**The 28 Acts cited for Royal Assent, title and number** were added on 18
September (`legislation-asp-<year>-<number>-…`), listed in `kept-pages.csv`
rather than here. One is the Act's PDF, as cited.

## judgments/

The Supreme Court's own pages for cases a bill's record depends on, kept because
a date taken from one is cited in a provenance note (`db/105`). Saved as the HTML
the Court's site served.

| File | Page | Retrieved | SHA-256 (first 16) |
|---|---|---|---|
| `supremecourt-case-uksc-2018-0080_retrieved-2026-09-17.html` | supremecourt.uk/cases/uksc-2018-0080: the reference on the UK Withdrawal from the European Union (Legal Continuity) (Scotland) Bill. Judgment date 13 December 2018, [2018] UKSC 64; date of issue 17 April 2018 | 2026-09-17 | `70ec07558ec981ee` |
