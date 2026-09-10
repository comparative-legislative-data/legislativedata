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
| `spice-legislation-session-6_retrieved-2026-09-10.pdf` | 6 | 2026-09-10 | `0eb594742513...` |
| `spice-legislation-session-7_retrieved-2026-09-10.pdf` | 7 | 2026-09-10 | `9603141728195f...` |

Both from `parliament.scot/-/media/files/spice/factsheets/parliamentary-business/`.

Sessions 1–5 are being retrieved by the owner from the archive site. Add them
here under the same naming convention and update the table above.

**Session 6 was unlinked, not deleted.** On 2026-09-10 it had been removed from
the fact sheets index — Session 7 was posted that day — but had not reached the
archive. The file was still served at its old address. Sessions 1–5 are on the
archive site, which sits behind a Cloudflare challenge that scripted fetching
cannot pass.

**That path serves soft 404s.** A missing factsheet returns HTTP 200 with an
HTML error page, not a 404. Any check based on status code will report success
and store an error page. Verify `content_type` is `application/pdf`, or check
the file begins `%PDF`.
