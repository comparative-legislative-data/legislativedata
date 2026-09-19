"""The zip: the whole published copy, to download.

Strand 2, item 5: docs/STRAND-2-ITEM-5-BUILD.md. Every word in it is agreed in
docs/wording/DOWNLOAD.md; the rest is read from the copy.

The zip is made once from the copy, by running this file on the machine as
the site's own login, which can only read the copy:

    sudo -u legsite /srv/site/current/.venv/bin/python download.py OUTDIR

and the refresh (tools/refresh_copy.sh, strand 2, item 6) makes it from the new
copy while that copy is still set aside as `next`, checks it, puts it in
/srv/downloads, and only then puts the copy live. The site never writes it. When a signed-in reader asks for it,
the site fills in the day it was downloaded and hands it over; nothing else in
it changes, and nothing in it names the reader.

Made twice from the same copy, the zip is the same byte for byte: every file
inside carries the copy's date, not the time it was made.
"""
import csv
import datetime
import io
import os
import re
import textwrap
import zipfile
from zoneinfo import ZoneInfo

import psycopg

DOWNLOAD_DIR = os.environ.get("DOWNLOAD_DIR", "/srv/downloads")

# The files, in the order the readme and the codebook give them: the four data
# files first, as What each heading holds does.
FILES = ("bills", "stages", "days_between_stages", "sessions", "methodology_notes",
         "sources", "what_the_words_mean", "what_changed", "workings", "about",
         "cited_pages", "terms")

# The data files, whose headings the codebook says are read or worked out.
READ_FROM_ITS_SOURCE = ("bills", "stages", "sessions")
WORKED_OUT = ("days_between_stages",)

# The order of each file's lines: as the site shows them where it shows them,
# otherwise by the file's own columns. Every file then falls back on all its
# columns, so the order never depends on how the copy happens to be stored.
ORDER = {
    "bills": "bill_number",
    "stages": "bill_number, stage_position, stage",
    "days_between_stages": "bill_number, date_measured_from, date_measured_to, measured_from, measured_to",
    "methodology_notes": "substring(note FROM 2)::int, note",
    "what_the_words_mean": 'heading, "order", value',
    "what_changed": "date_copy_taken DESC, file, bill_number, stage, which_line, heading",
}

# Where the day it was downloaded goes, until it is handed over. As long as a
# date, so the readme's lines wrap the same either way.
NOT_YET = "YYYY-MM-DD"

UK = ZoneInfo("Europe/London")
NAME = re.compile(r"legislativedata-(\d{4}-\d{2}-\d{2})\.zip")
WIDTH = 72


def name_for(date):
    return f"legislativedata-{date.isoformat()}.zip"


# ---- Reading the copy -----------------------------------------------------------------

HEADINGS = """
    SELECT c.relname AS file, obj_description(c.oid, 'pg_class') AS file_holds,
           a.attnum AS position, a.attname AS heading,
           col_description(c.oid, a.attnum) AS what_it_holds,
           format_type(a.atttypid, a.atttypmod) AS stored_as
      FROM pg_class c
      JOIN pg_namespace n ON n.oid = c.relnamespace
      JOIN pg_attribute a ON a.attrelid = c.oid AND a.attnum > 0 AND NOT a.attisdropped
     WHERE n.nspname = %s AND c.relkind IN ('r', 'v')
     ORDER BY c.relname, a.attnum"""


# Which copy is read: the live one, or the new one a refresh has set aside and
# not yet put live (strand 2, item 6).
COPIES = ("live", "next")


def read_copy(conn, copy="live"):
    """Every file of the copy, whole, and every heading's description, read in
    one go so a refresh landing part way through cannot mix two copies."""
    if copy not in COPIES:
        raise ValueError(f"no copy called {copy}")
    with conn.transaction(), conn.cursor() as cur:
        cur.execute("SET TRANSACTION ISOLATION LEVEL REPEATABLE READ")
        cur.execute(HEADINGS, (copy,))
        names = [c.name for c in cur.description]
        headings = [dict(zip(names, r)) for r in cur.fetchall()]
        files = {}
        for f in FILES:
            n = sum(1 for h in headings if h["file"] == f)
            if not n:
                raise ValueError(f"the copy has no file {f}")
            everything = ", ".join(str(i) for i in range(1, n + 1))
            order = f"{ORDER[f]}, {everything}" if f in ORDER else everything
            cur.execute(f"SELECT * FROM {copy}.{f} ORDER BY {order}")
            files[f] = ([c.name for c in cur.description], cur.fetchall())
    return {"files": files, "headings": headings}


def rows_of(copy, f):
    """One file's lines as dictionaries."""
    names, rows = copy["files"][f]
    return [dict(zip(names, r)) for r in rows]


# ---- The files inside -------------------------------------------------------------------

def cell(value):
    """A value as the file holds it: a date as 2018-12-13, an empty cell empty."""
    if value is None:
        return ""
    return value.isoformat() if hasattr(value, "isoformat") else str(value)


def as_csv(names, rows):
    """A comma between cells, a new line as Windows writes it, quotation marks
    only where a cell needs them, UTF-8 with no marker at the start."""
    out = io.StringIO(newline="")
    w = csv.writer(out, lineterminator="\r\n")
    w.writerow(names)
    for r in rows:
        w.writerow([cell(v) for v in r])
    return out.getvalue().encode("utf-8")


def text_file(lines):
    """A plain-text file: the lines joined as Windows writes them, UTF-8."""
    return ("\r\n".join(lines) + "\r\n").encode("utf-8")


def wrapped(text, indent=""):
    return textwrap.wrap(text, WIDTH, initial_indent=indent, subsequent_indent=indent,
                         break_long_words=False, break_on_hyphens=False) or [indent.rstrip()]


def paragraphs(*paras):
    """Paragraphs, each wrapped, a blank line between them."""
    out = []
    for p in paras:
        if out:
            out.append("")
        out += wrapped(p)
    return out


def lines_word(n):
    return f"{n} line" if n == 1 else f"{n} lines"


def working_files(copy):
    """The working behind each worked-out file, as plain text of its own."""
    return [(f"working-{w['file']}.txt", w["working"]) for w in rows_of(copy, "workings")]


def readme(copy, date, credits):
    """README.txt, docs/wording/DOWNLOAD.md part 3, with the copy's own counts
    and descriptions. The day it was downloaded is left as NOT_YET."""
    holds = {h["file"]: h["file_holds"] for h in copy["headings"]}
    d = date.isoformat()
    out = ["legislativedata.org: bills of the Scottish Parliament",
           f"Data as at {d}, the day this copy was taken and this zip made",
           f"Downloaded on {NOT_YET}", "", ""]

    def section(title, *paras):
        out.extend([title, ""] + paragraphs(*paras) + ["", ""])

    section("SUGGESTED CITATION",
            f"MacGregor, Steven ({date.year}). Bills of the Scottish Parliament, data as at "
            f"{d} [dataset]. legislativedata.org, created and maintained by Steven MacGregor. "
            f"https://legislativedata.org. Downloaded {NOT_YET}.")
    section("WHAT THIS IS",
            "Every bill introduced in the Scottish Parliament since 1999, one line each, with "
            "the day each of its stages ended, what the Parliament did with it, and where each "
            "fact came from.",
            "legislativedata.org is an independent research resource. It is not the Scottish "
            "Parliament's, and the Parliament has not endorsed it.")
    section(f"THE DATA IS AS IT STOOD ON {d}",
            "The data is corrected and added to as sources are revised and more of them is "
            "read. Earlier versions are not kept, and none is offered. If your work needs a "
            "fixed version, keep this download: its date identifies it, and is the date to "
            "cite. What has changed since is listed in what_changed.csv in any later download, "
            "and under What has changed on the Data page.")

    out += ["THE FILES", ""]
    out += paragraphs("Every file is CSV, in UTF-8, with a first line naming its headings. "
                      "The numbers of lines below do not count that first line.")
    for f in FILES:
        out += ["", f"{f}.csv  {lines_word(len(copy['files'][f][1]))}"]
        out += wrapped(holds[f], "  ")
    out += ["", "codebook.txt"]
    out += wrapped("Every heading in every file, with what it holds and what an empty cell "
                   "under it means.", "  ")
    for name, _ in working_files(copy):
        out += ["", name]
        out += wrapped("The working in workings.csv, as plain text, the same text the site "
                       "shows.", "  ")
    out += ["", ""]

    section("DATES, AND OPENING THE FILES IN A SPREADSHEET",
            "Dates are written year-month-day: 2003-03-20. A spreadsheet can change a date, or "
            "drop a leading zero, when it opens a CSV file directly. To keep every cell as "
            "written, import the file rather than open it, and set its date headings to text. "
            "The numbers of lines above are there to check the whole file arrived.")
    section("SOURCES AND LICENCE",
            *credits,
            "This data is provided as it is, with no warranty. legislativedata.org is not "
            "responsible for what anyone does with it.",
            "What each source allows, and does not, is in terms.csv, in each source's own words, "
            "with a link to each licence. When you use the data, include the credit line for "
            "each source your use draws on.")
    section("A RELATED DATASET",
            "The Comparative Agendas Project's Scottish Bills codes the topics of 161 bills of "
            "the Scottish Parliament from 1999 to 2008: "
            "https://www.comparativeagendas.net/datasets_codebooks")
    out += ["ANOTHER FORMAT", ""]
    out += paragraphs("To ask for the data in another format, write to "
                      "comparativelegislativedata@gmail.com.")
    return out


def kind(h):
    """Number, date or text as the copy stores it; yes or no where the
    heading's description says what Yes means."""
    if h["stored_as"] in ("integer", "bigint", "smallint", "numeric"):
        return "number"
    if h["stored_as"] == "date":
        return "date"
    if (h["what_it_holds"] or "").startswith("Yes"):
        return "yes or no"
    return "text"


def worked_out_or_read(h):
    """Small choice 4: said of the data files' headings only."""
    if h["file"] in READ_FROM_ITS_SOURCE:
        return "read from its source"
    if h["file"] in WORKED_OUT:
        rule = re.match(r"Worked out: (.*)", h["what_it_holds"] or "")
        if rule:
            return f"worked out from bills and stages: {rule.group(1)} The working is in workings."
        return "worked out from bills and stages; the working is in workings"
    return None


def codebook(copy, date):
    """codebook.txt, docs/wording/DOWNLOAD.md part 4: every heading of every
    file, from the copy's own descriptions."""
    words = {}
    for w in rows_of(copy, "what_the_words_mean"):
        words.setdefault(w["heading"], []).append(w["value"])
    notes = {}
    for n in rows_of(copy, "methodology_notes"):
        for h in (n["applies_to"] or "").split(","):
            if h.strip():
                notes.setdefault(h.strip(), []).append(n["note"])

    out = ["legislativedata.org: codebook", f"Data as at {date.isoformat()}", ""]
    out += paragraphs("Every heading in every file, with what it holds and what an empty cell "
                      "under it means. The same descriptions are on the Data page, under What "
                      "each heading holds.")
    for f in FILES:
        mine = sorted((h for h in copy["headings"] if h["file"] == f), key=lambda h: h["position"])
        out += ["", "", f"{f}.csv"] + wrapped(mine[0]["file_holds"])
        for h in mine:
            out += ["", f"{f}.{h['heading']}"]
            out += wrapped(h["what_it_holds"], "  ")
            out.append(f"  Type: {kind(h)}")
            how = worked_out_or_read(h)
            if how:
                out += wrapped(f"Worked out or read: {how}", "  ")
            if words.get(h["heading"]):
                out.append("  Words it can hold (each explained in what_the_words_mean.csv):")
                out += wrapped("; ".join(words[h["heading"]]), "    ")
            if notes.get(f"{f}.{h['heading']}"):
                out.append("  Methodology notes that bear on it: "
                           + ", ".join(notes[f"{f}.{h['heading']}"]))
    return out


# ---- The zip ----------------------------------------------------------------------------

def entry(folder, name, date):
    """One file's place in the zip, carrying the copy's date and nothing else
    that could differ between two makings."""
    info = zipfile.ZipInfo(f"{folder}/{name}", date_time=(date.year, date.month, date.day, 0, 0, 0))
    info.compress_type = zipfile.ZIP_DEFLATED
    info.create_system = 3
    info.external_attr = 0o100644 << 16
    return info


def contents(copy, date, credits):
    """The fifteen files, in the order the zip holds them."""
    out = [("README.txt", text_file(readme(copy, date, credits))),
           ("codebook.txt", text_file(codebook(copy, date)))]
    out += [(f"{f}.csv", as_csv(*copy["files"][f])) for f in FILES]
    out += [(name, text_file(text.splitlines())) for name, text in working_files(copy)]
    return out


def pack(folder, date, files):
    buf = io.BytesIO()
    with zipfile.ZipFile(buf, "w") as z:
        for name, data in files:
            z.writestr(entry(folder, name, date), data)
    return buf.getvalue()


def build(copy, credits):
    """The zip as kept on the machine: (its name, its bytes)."""
    dates = {a["date_copy_taken"] for a in rows_of(copy, "about")}
    if len(dates) != 1:
        raise ValueError(f"the copy's about file gives {len(dates)} dates")
    date = dates.pop()
    files = contents(copy, date, credits)
    if files[0][1].count(NOT_YET.encode()) != 2:
        raise ValueError("the readme does not have exactly two places for the day downloaded")
    name = name_for(date)
    return name, pack(name[:-4], date, files)


# ---- Handing it over --------------------------------------------------------------------

def kept(date):
    """The path of the zip kept for this copy's date, or None if there is none."""
    path = os.path.join(DOWNLOAD_DIR, name_for(date))
    return path if os.path.isfile(path) else None


def size_shown(path):
    """0.4 MB: one decimal place of a megabyte."""
    return f"{os.path.getsize(path) / 1_000_000:.1f} MB"


def today():
    return datetime.datetime.now(UK).date()


def handed_over(path, on):
    """The kept zip with the day it was downloaded filled in, and nothing else
    changed."""
    with zipfile.ZipFile(path) as z:
        infos = z.infolist()
        files = [(i.filename.split("/", 1)[1], z.read(i)) for i in infos]
    folder = infos[0].filename.split("/", 1)[0]
    date = datetime.date(*infos[0].date_time[:3])
    files = [(n, d.replace(NOT_YET.encode(), on.isoformat().encode()) if n == "README.txt" else d)
             for n, d in files]
    return pack(folder, date, files)


# ---- Making it, and checking it, on the machine ----------------------------------------

def made(copy_name):
    """The copy read through the site's own login, and the zip made from it."""
    from app import credit_lines  # the pages' own credit lines, in their order
    import published
    with psycopg.connect(published.CONNINFO, autocommit=True) as conn:
        copy = read_copy(conn, copy_name)
    credits = credit_lines(rows_of(copy, "terms"), rows_of(copy, "what_the_words_mean"))
    return copy, build(copy, credits)


def main(outdir, copy_name="live"):
    copy, (name, data) = made(copy_name)
    path = os.path.join(outdir, name)
    with open(path, "wb") as f:
        f.write(data)
    print(f"{path}: {len(data):,} bytes, {len(copy['headings'])} headings, "
          + ", ".join(f"{f} {len(copy['files'][f][1])}" for f in FILES))


def check(path, copy_name="live"):
    """The refresh's check of a zip before its copy goes live: it opens, it is
    named for the copy's date, it holds one folder of the fifteen files, the
    readme has its two blanks, every data file has a line for each of the
    copy's, and it is the zip this copy makes, byte for byte. Stops at the
    first thing wrong."""
    copy, (name, data) = made(copy_name)
    problems = []
    if os.path.basename(path) != name:
        problems.append(f"named {os.path.basename(path)}, but the copy makes {name}")
    with zipfile.ZipFile(path) as z:
        if z.testzip() is not None:
            problems.append("a file inside is damaged")
        entries = z.namelist()
        folders = {e.split("/", 1)[0] for e in entries}
        if folders != {name[:-4]}:
            problems.append(f"folders {sorted(folders)}, not one called {name[:-4]}")
        if len(entries) != 15:
            problems.append(f"{len(entries)} files, not fifteen")
        inside = {e.split("/", 1)[1]: e for e in entries}
        readme = z.read(inside["README.txt"]) if "README.txt" in inside else b""
        if readme.count(NOT_YET.encode()) != 2:
            problems.append("the readme does not have exactly two blanks for the day downloaded")
        for f in FILES:
            if f"{f}.csv" in inside:
                lines = len(list(csv.reader(io.StringIO(z.read(inside[f"{f}.csv"]).decode("utf-8"))))) - 1
                if lines != len(copy["files"][f][1]):
                    problems.append(f"{f}.csv has {lines} lines, the copy {len(copy['files'][f][1])}")
    with open(path, "rb") as f:
        if f.read() != data:
            problems.append("it is not the zip this copy makes, byte for byte")
    for p in problems:
        print(f"ZIP WRONG: {p}")
    if not problems:
        print(f"Zip checked: {name}, fifteen files, {len(copy['files']['bills'][1])} bills, "
              f"two blanks, the same as the copy makes.")
    return not problems


if __name__ == "__main__":
    import sys
    if sys.argv[1] == "--check":
        sys.exit(0 if check(sys.argv[2], *sys.argv[3:4]) else 1)
    main(sys.argv[1], *sys.argv[2:3])
