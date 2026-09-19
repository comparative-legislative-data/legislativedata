"""The Insights page with thought 2, the outcomes chart, checked on the machine
against a staged release, or the live one.

Strand 3, step 3: docs/STRAND-3-THOUGHT-2-PAGE-BUILD.md, "How it is tested".
Run as the site's own login, in the release's own environment, with the
write-up and the build note sent alongside:

    sudo -u legsite env PUBLISHED_CONNINFO="dbname=<a copy with the figures>" \\
        NO_FIGURES_CONNINFO="dbname=<a copy without them, or none>" \\
        /srv/site/releases/<release>/.venv/bin/python check_insights_page.py \\
        /srv/site/releases/<release> STRAND-3-THOUGHT-2.md STRAND-3-THOUGHT-2-PAGE-BUILD.md
    ... BREAK=1 ...   # must FAIL at the wording, the figures, the route to the
                      # bills, the CSV and the working, and nowhere else

It reads the copy exactly as the site does, and writes nothing anywhere. It
signs nobody in and never opens the accounts: "signed in" is a made-up reader
put in the site's place for the length of the run. It prints each check as
PASS or FAIL, and counts only.

What it cannot check is what a browser draws: the chart itself, in dark and
light, hovering and clicking. That is checked by eye on the live site, to the
list in the build note.
"""
import csv
import hashlib
import io
import os
import re
import sys
from html import unescape
from urllib.parse import parse_qs, urlsplit

REL, WRITEUP, BUILD = sys.argv[1:4]
sys.path.insert(0, REL)
os.chdir(REL)

import accounts  # noqa: E402
import published  # noqa: E402
from app import app, return_to  # noqa: E402

BREAK = os.environ.get("BREAK") == "1"
n = 0
failed = 0


def check(what, ok, detail=""):
    global n, failed
    n += 1
    print(f"{'PASS' if ok else 'FAIL'} {n:3}  {what}" + (f" ({detail})" if detail and not ok else ""))
    if not ok:
        failed += 1


def norm(t):
    return re.sub(r"\s+", " ", t).strip()


def blocks(html):
    html = re.sub(r"<script.*?</script>", "", html, flags=re.S)
    html = re.sub(r"</?(a|code|span|strong|em|b)\b[^>]*>", "", html)
    html = re.sub(r"<[^>]+>", "\n", html)
    return [norm(unescape(x)) for x in html.split("\n") if x.strip()]


def quoted(doc, start, end):
    """The quoted paragraphs between two headings of a document."""
    text = doc[doc.index(start):doc.index(end) if end else len(doc)]
    paras, cur = [], []
    for line in text.splitlines() + [""]:
        if line.startswith(">"):
            line = line[1:].strip()
            if line:
                cur.append(line)
                continue
        if cur:
            paras.append(norm(re.sub(r"^#+ ", "", " ".join(cur)).replace("**", "")))
            cur = []
    return paras


MARKER = "made-up-reader"
real_signed_in_as = accounts.signed_in_as
accounts.signed_in_as = lambda m: ("A made-up reader", False) if m == MARKER else None


def get(path, signed_in=True):
    c = app.test_client()
    if signed_in:
        c.set_cookie(key="signed_in", value=MARKER, domain="localhost")
    return c.get(path)


# ---- What the copy holds, read as the site reads it ---------------------------

with app.app_context():
    copy = published.insights()
    if copy is None:
        sys.exit("Refusing: the copy in PUBLISHED_CONNINFO has no chart's figures.")
    bills = {b["bill_number"]: b for b in published.reference()["bills"]}
rows = copy["outcomes"]
headings = copy["outcome_headings"]
date = copy["about"][0]["date_copy_taken"]
if BREAK:
    # One figure and one sentence, in what the check expects.
    rows = [dict(r) for r in rows]
    passed = next(r for r in rows if r["outcome"] == "Passed" and r["bills"] > 1)
    passed["bills"] += 1

writeup = open(WRITEUP).read()
build = open(BUILD).read()
if BREAK:
    writeup = writeup.replace("> Bill outcomes by session and type", "> Bill outcomes by type and session")

# ---- 1. Signed out --------------------------------------------------------------

for path in ("/insights", f"/insights/legislativedata-outcomes_by_session_and_type-{date.isoformat()}.csv"):
    r = get(path, signed_in=False)
    loc = r.headers.get("Location", "")
    check(f"signed out, {path[:40]} goes to the sign-in page, returning to /insights",
          r.status_code == 302 and urlsplit(loc).path == "/sign-in"
          and parse_qs(urlsplit(loc).query).get("next") == ["/insights"], f"{r.status_code} {loc}")
    check(f"signed out, {path[:40]} gives none of the chart", "Bill outcomes" not in r.get_data(as_text=True))

# ---- 2. The page's words, as agreed ------------------------------------------------

r = get("/insights")
html = r.get_data(as_text=True)
main = html[html.index("<main>"):html.index("</main>")]
text = blocks(main)
joined = " ".join(text)
check("the page answers", r.status_code == 200, r.status_code)
check("no copy of the page is kept by the browser", r.headers.get("Cache-Control") == "no-store")

page_words = quoted(build, "## E. The page's own wording", "## F.")
starting = lambda paras, start: next((p for p in paras if p.startswith(start)), None)
expected = [
    "Insights",
    f"Data as at {date.day} {date:%B %Y}",
    "Accurate as at that date. A record it was taken from may since have been corrected, and earlier versions are not kept.",
    starting(page_words, "Charts drawn"),
    "Explore the charts",
]
for w in expected:
    check(f"on the page, as agreed: {(w or '(missing from the build note)')[:60]}", w in text, w)
tab = re.findall(r'<a href="#outcomes" data-tab="outcomes"><span class="bt-name">([^<]+)</span>'
                 r'<span class="bt-what">([^<]+)</span></a>', main)
check("the one tab: Outcomes, How bills ended, by session and type",
      [f"{a} — {unescape(b)}" for a, b in tab] == [starting(page_words, "Outcomes")], tab)

public = quoted(writeup, "## The public wording, in full", None)
wanted = {
    "title": public[0],
    "line beneath": starting(public, "How every bill"),
    "hint": starting(public, "Hover over a bar"),
    "click": starting(public, "Click any figure"),
    "description": starting(public, "A bar chart of"),
    "rule": starting(public, "Every bill introduced in the Parliament"),
}
for what, w in wanted.items():
    check(f"the write-up's {what}, word for word", bool(w) and w in joined, w)
check("the title is the chart's heading", f'class="self">{public[0]}</a></h2>' in main, public[0])
items, cur = [], None
at = writeup.index("**The explanations**")
for ln in writeup[at:writeup.index("**Beneath**", at)].splitlines():
    if ln.startswith("> - "):
        cur = [ln[4:]]
        items.append(cur)
    elif ln.startswith(">") and cur is not None and ln[1:].strip():
        cur.append(ln[1:].strip())
    else:
        cur = None
explained = [norm(" ".join(i)) for i in items]
check("three explanations", len(explained) == 3, explained)
for w in explained:
    check(f"the explanation: {w[:50]}", w in text, w)
for w in ("The numbers in this chart", "Download these figures (CSV)", "Show the working"):
    check(f"beneath the chart: {w}", w in text)
for label, options in (("Outcomes", ["Passed or not", "Full breakdown"]),
                       ("Forth Crossing Bill", ["Counted as a government bill", "Shown as a Hybrid Bill"])):
    sel = re.search(r'<label class="filter"[^>]*>' + label + r"\s*<select id=\"([^\"]+)\">(.*?)</select>", main, re.S)
    check(f"the dropdown {label}, with its two choices in order, the first the default",
          sel and re.findall(r">([^<]+)</option>", sel.group(2)) == options
          and "selected" not in sel.group(2), sel and sel.group(2))

# The frame: sources named from the copy's terms, the date and the address.
terms_named = [t["terms_for"] for t in copy["terms"]]
foot = re.search(r'<p class="frame-foot">(.*?)</p>', main, re.S)
foot_text = [unescape(x) for x in re.findall(r"<span>(.*?)</span>", foot.group(1))] if foot else []
check("inside the frame: sources, date, address",
      foot_text == ["Sources: Scottish Parliament; legislation.gov.uk; legislativedata.org",
                    f"Data as at {date.day} {date:%B %Y}", "legislativedata.org/insights#outcomes-chart"],
      foot_text)
check("the Supreme Court is behind none of the chart's figures, and is not named",
      "Supreme Court" not in joined and "Supreme Court" not in copy["outcome_sources"])
credits = re.search(r'<section class="credits".*?</section>', main, re.S)
leads = re.findall(r"<p>([^:<]+):", credits.group(0)) if credits else []
check("the credit lines: the Scottish Parliament, legislation.gov.uk and ours, in that order",
      leads == ["Values from the Scottish Parliament", "Values from legislation.gov.uk", "Everything else"], leads)

# The notes it rests on, each linking to the note on the Data page.
chips = re.findall(r'<a class="chip-note" href="/data#(M\d+)" title="([^"]+)">(M\d+)</a>', main)
titles = {x["note"]: x["title"] for x in copy["notes"]}
check("rests on M1 M4 M5 M6 M7 M13, each linking to its note, titled",
      [c[0] for c in chips] == ["M1", "M4", "M5", "M6", "M7", "M13"]
      and all(c[0] == c[2] and unescape(c[1]) == titles[c[0]] for c in chips), chips)

# Names: every id on the page once, and no dropdown sharing a tab's name.
ids = re.findall(r'\bid="([^"]+)"', html)
check("every id on the page is used once", len(ids) == len(set(ids)),
      [i for i in set(ids) if ids.count(i) > 1])
tabs = re.findall(r'data-tab="([^"]+)"', main)
selects = re.findall(r'<select id="([^"]+)"', main)
check("one tab, Outcomes, and no dropdown named as a tab is", tabs == ["outcomes"]
      and not set(tabs) & set(selects), (tabs, selects))

# ---- 3. The figures the page hands the chart are the copy's -------------------------

data = __import__("json").loads(unescape(re.search(
    r'<script id="oc-data" type="application/json">(.*?)</script>', html, re.S).group(1)))
arr = {"Counted as a government bill": "grouped", "Shown as a Hybrid Bill": "onown"}
from_copy = [[r["outcomes_shown"], arr[r["forth_crossing_bill"]], r["session"], r["bill_type"], r["outcome"],
              r["bills_of_this_type"], r["bills"],
              None if r["percent_of_bills_of_this_type"] is None else int(r["percent_of_bills_of_this_type"]),
              r["of_which_became_acts"]] for r in rows]
check("the page hands the chart all 720 lines", len(data["rows"]) == 720, len(data["rows"]))
check("every figure the chart draws is the copy's, cell for cell", data["rows"] == from_copy,
      sum(a != b for a, b in zip(data["rows"], from_copy)))
check("the page hands the chart no bill numbers", all(len(r) == 9 for r in data["rows"]))
check("the sessions and their years",
      data["sessions"] == [["1", "1999–2003"], ["2", "2003–2007"], ["3", "2007–2011"], ["4", "2011–2016"],
                           ["5", "2016–2021"], ["6", "2021–2026"], ["7", "2026–, running"]], data["sessions"])
check("the types in the copy's order, Hybrid only when shown on its own",
      data["types"] == {"grouped": ["Government Bill", "Member's Bill", "Committee Bill", "Private Bill"],
                        "onown": ["Government Bill", "Member's Bill", "Committee Bill", "Private Bill",
                                  "Hybrid Bill"]}, data["types"])
check("the outcomes, Fell (other) left out as no bill has it",
      data["outcomes"] == {"Full breakdown": ["Passed", "Rejected at Stage 1", "Rejected at Stage 3", "Withdrawn",
                                              "Fell at dissolution", "Fell: financial resolution not agreed",
                                              "In progress"],
                           "Passed or not": ["Passed", "Not passed", "In progress"]}, data["outcomes"])

# Two figures the write-up names.
ix = {(r[0], r[1], r[2], r[3], r[4]): r for r in data["rows"]}
s5 = ix[("Passed or not", "grouped", "5", "Government Bill", "Passed")]
check("Session 5 · Government Bills: 63 introduced, 62 passed (98%), 61 Acts", s5[5:9] == [63, 62, 98, 61], s5)
s3 = [ix[("Full breakdown", sw, "3", "Government Bill", "Passed")][5] for sw in ("grouped", "onown")]
check("Session 3 · Government Bills: 45, or 44 with the Forth Crossing Bill on its own", s3 == [45, 44], s3)

# ---- 4. Every figure opens exactly its bills --------------------------------------------

def shown_on_data_page(path):
    r = get(path)
    if r.status_code != 200:
        return None, None, r.status_code
    page = r.get_data(as_text=True)
    table = page[page.find('<table class="bills">'):page.find("</table>", page.find('<table class="bills">'))]
    numbers = [int(x) for x in re.findall(r'<tr id="bill-(\d+)">', table)] if '<table class="bills">' in page else []
    line = re.search(r'<p class="count behind-line"><span class="behind-what">(.*?)</span> '
                     r'<a href="/data">Show all bills</a></p>', page)
    return numbers, unescape(line.group(1)) if line else None, 200


def address(r, outcome=True, acts=False):
    from urllib.parse import quote, urlencode
    pairs = [("figure", "outcomes_by_session_and_type"), ("outcomes_shown", r["outcomes_shown"]),
             ("forth_crossing_bill", r["forth_crossing_bill"]), ("session", r["session"]),
             ("bill_type", r["bill_type"])]
    pairs += [("outcome", r["outcome"])] if outcome else []
    pairs += [("became_acts", "Yes")] if acts else []
    return "/data?" + urlencode(pairs, quote_via=quote)


def label(r, what):
    s = r["session"] if r["session"] == "All sessions" else f"Session {r['session']}"
    t = {"Government Bill": "Government Bills", "Member's Bill": "Member's Bills",
         "Committee Bill": "Committee Bills", "Private Bill": "Private Bills",
         "Hybrid Bill": "Hybrid Bill"}[r["bill_type"]]
    out = f"{s} · {t} · {what}"
    if r["forth_crossing_bill"] == "Shown as a Hybrid Bill":
        out += " · Forth Crossing Bill shown as a Hybrid Bill"
    return out


listed = lambda r: sorted(int(x) for x in (r["bill_numbers"] or "").split(";") if x.strip())
wrong_outcome, wrong_total, wrong_acts, wrong_label, visited = [], [], [], [], 0
groups = {}
for r in rows:
    groups.setdefault((r["outcomes_shown"], r["forth_crossing_bill"], r["session"], r["bill_type"]), []).append(r)
    if r["bills"] == 0:
        continue
    numbers, line, code = shown_on_data_page(address(r))
    visited += 1
    if code != 200 or numbers != listed(r) or len(numbers) != r["bills"]:
        wrong_outcome.append((r["session"], r["bill_type"], r["outcome"], code, len(numbers or []), r["bills"]))
    n_ = r["bills"]
    if line != f"The {n_} bill{'' if n_ == 1 else 's'} behind: {label(r, r['outcome'])}":
        wrong_label.append(line)
    if r["outcome"] == "Passed" and r["of_which_became_acts"]:
        numbers, line, code = shown_on_data_page(address(r, acts=True))
        visited += 1
        want = [b for b in listed(r) if bills[b]["enactment_status"] == "Enacted"]
        if numbers != want or len(numbers) != r["of_which_became_acts"]:
            wrong_acts.append((r["session"], r["bill_type"], len(numbers or []), r["of_which_became_acts"]))
        a = r["of_which_became_acts"]
        if line != f"The {a} bill{'' if a == 1 else 's'} behind: {label(r, 'Passed and became Acts')}":
            wrong_label.append(line)
for key, lines in groups.items():
    r = lines[0]
    if r["bills_of_this_type"] == 0:
        continue
    numbers, line, code = shown_on_data_page(address(r, outcome=False))
    visited += 1
    want = sorted(b for x in lines for b in listed(x))
    if numbers != want or len(numbers) != r["bills_of_this_type"]:
        wrong_total.append((key, len(numbers or []), r["bills_of_this_type"]))
    bt = r["bills_of_this_type"]
    if line != f"The {bt} bill{'' if bt == 1 else 's'} behind: {label(r, 'Bills introduced')}":
        wrong_label.append(line)
check(f"every outcome figure opens exactly its bills ({visited} figures opened in all)", not wrong_outcome,
      wrong_outcome[:3])
check("every 'Bills' figure opens exactly the bills of its session and type", not wrong_total, wrong_total[:3])
check("every 'of which became Acts' opens exactly the Passed bills Enacted", not wrong_acts, wrong_acts[:3])
check("every figure's bills are named above the table in the agreed words", not wrong_label, wrong_label[:3])

# Figure addresses that are not a figure go to the whole table.
first = next(r for r in rows if r["bills"] > 0 and r["outcome"] != "Passed")
for what, path in [("an outcome no line has", address(first).replace("outcome=", "outcome=Nonsense")),
                   ("became Acts on a line that is not Passed", address(first, acts=True)),
                   ("a heading that is not the file's", address(first) + "&title=x"),
                   ("a figure file that is not a chart's", address(first).replace("outcomes_by_session_and_type", "bills"))]:
    r = get(path)
    check(f"a figure address with {what} goes to the whole table",
          r.status_code == 302 and r.headers.get("Location", "").endswith("/data"),
          f"{r.status_code} {r.headers.get('Location')}")
check("signing in keeps a figure's address", return_to(address(first)) == address(first),
      return_to(address(first)))

# ---- 5. The CSV --------------------------------------------------------------------------

name = f"legislativedata-outcomes_by_session_and_type-{date.isoformat()}.csv"
check("the page offers the CSV by the copy's date", f'href="/insights/{name}"' in main)
r = get(f"/insights/{name}")
body = r.get_data(as_text=True)
got = list(csv.reader(io.StringIO(body)))
check("the CSV is handed over as a file of that name, not kept by the browser",
      r.status_code == 200 and r.headers.get("Content-Disposition") == f'attachment; filename="{name}"'
      and r.headers.get("Cache-Control") == "no-store", (r.status_code, r.headers.get("Content-Disposition")))
check("its headings are the file's, then sources, date_copy_taken and chart_address",
      got and got[0] == headings + ["sources", "date_copy_taken", "chart_address"], got and got[0])
cellv = lambda v: "" if v is None else (v.isoformat() if hasattr(v, "isoformat") else str(v))
want = [[cellv(r[h]) for h in headings] + ["Scottish Parliament; legislation.gov.uk; legislativedata.org",
                                           date.isoformat(), "https://legislativedata.org/insights#outcomes-chart"]
        for r in rows]
check("it holds all 720 lines, cell for cell the copy's, in the working's order", got[1:] == want,
      (len(got) - 1, sum(a != b for a, b in zip(got[1:], want))))
r = get("/insights/legislativedata-outcomes_by_session_and_type-2000-01-01.csv")
check("a CSV name from another day goes back to the page", r.status_code == 302
      and r.headers.get("Location", "").endswith("/insights"))
check("any other name is not found", get("/insights/anything.csv").status_code == 404)

# ---- 6. The working shown is the working that ran ---------------------------------------

shown = re.search(r'<details class="working">\s*<summary>Show the working</summary>\s*<pre><code>(.*?)</code></pre>',
                  main, re.S)
working = copy["working"]
if BREAK:
    working = working.replace("Every bill is counted once", "Each bill is counted once")
check("the working shown is the copy's workings text, character for character",
      shown and unescape(shown.group(1)) == working)
check("and it is the agreed working in the write-up",
      shown and norm(unescape(shown.group(1))) == norm(re.search(r"```sql\n(.*?)```", writeup, re.S).group(1)))

# ---- 7. The site's own files ----------------------------------------------------------------

ech = open(os.path.join(REL, "static/js/echarts-6.1.0.min.js"), "rb").read()
check("ECharts is 6.1.0 as published, served from the machine",
      hashlib.sha256(ech).hexdigest() == "b66b25aeb4df84e33199dc21694014d336d222cbd9deb0e5a7c14bd6aa0d0fd0"
      and re.search(r'<script src="/static/js/echarts-6\.1\.0\.min\.js\?v=[0-9a-f]{10}"></script>', html))
check("its licence is beside it", os.path.exists(os.path.join(REL, "static/js/echarts-6.1.0.LICENSE.txt")))
check("nothing on the page is fetched from anywhere else",
      not re.search(r'(src|href)="https?://(?!legislativedata\.org)[^"]*\.(js|css)', html))
sheet = open(os.path.join(REL, "static/css/site.css")).read()
agreed = {"dark": "#e8aa2b #f780b8 #9a7ed9 #33ae85 #7d7a7a #cb711e #d8d5cb #9c96cf",
          "light": "#d77508 #a32189 #7967be #1a835e #484943 #925700 #8f8f8f #5f55a8"}
blocks_css = re.findall(r"(:root(?:\[data-mode=\"light\"\])?) \{\s*--o-passed:(.*?)\}", sheet, re.S)
got_pal = {("light" if "light" in sel else "dark"): " ".join(re.findall(r"#[0-9a-f]{6}", body_)[:8])
           for sel, body_ in blocks_css}
check("the outcome colours are the ones the palette check passed", got_pal == agreed, got_pal)
check("and the quarters' light colours", '--q1: #78bcae; --q2: #4a9f8c; --q3: #25806e; --q4: #135a4e;' in sheet)

# ---- 8. With a copy that has no chart's figures: the page as it was ----------------------------

no_figures = os.environ.get("NO_FIGURES_CONNINFO")
if no_figures:
    published.CONNINFO = no_figures
    r = get("/insights")
    m2 = r.get_data(as_text=True)
    m2 = m2[m2.index("<main>"):m2.index("</main>")]
    check("with no figures in the copy, the page is as before the charts",
          r.status_code == 200 and blocks(m2) == ["Insights", "Insights", "The charts are being built."], blocks(m2))
    r = get(f"/insights/{name}")
    check("and the CSV goes back to the page", r.status_code == 302)
    r = get(address(first))
    check("and a figure's address goes to the whole table", r.status_code == 302
          and r.headers.get("Location", "").endswith("/data"))
    published.CONNINFO = os.environ.get("PUBLISHED_CONNINFO", "dbname=published")
else:
    print("(no copy without figures given; section 8 not run)")

accounts.signed_in_as = real_signed_in_as
print(f"\n{n - failed} of {n} pass" + (f", {failed} FAIL" if failed else ""))
sys.exit(1 if failed else 0)
