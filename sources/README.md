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
