"""The Data and Insights pages, checked on the machine against a staged release.

Strand 2, items 2 and 3 (docs/STRAND-2-ITEMS-2-AND-3-BUILD.md, part A), and
item 4, the table of every bill, which put the Data page in tabs
(docs/STRAND-2-ITEM-4-BUILD.md, part A). Run
as the site's own login, in the release's own environment, with the agreed
wording sent alongside:

    sudo -u legsite /srv/site/releases/<release>/.venv/bin/python \\
        check_data_pages.py /srv/site/releases/<release> PUBLISHING.md
    ... BREAK=1 ...   # must FAIL at the date statement and the credit lines
    ... BREAK=2 ...   # must FAIL at the table, its narrowing, the opened bills,
                      # the link to a bill, and What each heading holds

It reads the live copy exactly as the site does, and writes nothing anywhere.
It signs nobody in and never opens the accounts: "signed in" is a made-up
reader put in the site's place for the length of the run, and signing in is
checked with the site's own code-checking replaced by one that accepts a
made-up code. It prints each check as PASS or FAIL, and counts and yes/no
answers only.
"""
import copy as copying
import datetime
import gzip
import os
import re
import sys
from html import unescape
from urllib.parse import parse_qs, urlsplit

REL, WORDING = sys.argv[1], sys.argv[2]
sys.path.insert(0, REL)
os.chdir(REL)

import accounts  # noqa: E402
import published  # noqa: E402
from app import app, day  # noqa: E402
from markupsafe import escape  # noqa: E402

n = 0
failed = 0


def check(what, ok, detail=""):
    global n, failed
    n += 1
    print(f"{'PASS' if ok else 'FAIL'} {n:2}  {what}" + (f" ({detail})" if detail and not ok else ""))
    if not ok:
        failed += 1


# ---- The agreed wording, from PUBLISHING.md -----------------------------------

wording = open(WORDING).read()
if os.environ.get("BREAK") == "1":
    # One word in the date statement and one in the credit lines. Refuses if
    # either is not found, so a break that changes nothing cannot pass.
    for was, now in [("Accurate as at that date", "Correct as at that date"),
                     ("Values from the Supreme Court", "Values from the UK Supreme Court")]:
        if was not in wording:
            sys.exit(f"Refusing: BREAK could not find {was!r} to change.")
        wording = wording.replace(was, now)
if os.environ.get("BREAK") == "2":
    # One phrase of part 8, and below, one value in each file the table and
    # its opened bills are compared with. Must FAIL at the link to a bill, the
    # table, the narrowing, the opened bills' headings, stages and sources,
    # and What each heading holds.
    was, now = "> Link to this bill", "> Link to the bill"
    if was not in wording:
        sys.exit(f"Refusing: BREAK could not find {was!r} to change.")
    wording = wording.replace(was, now)


def part(number):
    """The quoted paragraphs of one numbered part, joined line by line."""
    body = re.split(r"^## ", wording, flags=re.M)
    text = next(b for b in body if b.startswith(f"{number}. "))
    paras, cur = [], []
    for line in text.splitlines() + [""]:
        if line.startswith(">"):
            line = line[1:].strip()
            if line:
                cur.append(line)
                continue
        if cur:
            paras.append(" ".join(cur))
            cur = []
    return [norm(re.sub(r"^#+ ", "", p).replace("**", "")) for p in paras]


def norm(t):
    return re.sub(r"\s+", " ", t).strip()


# ---- Pages as a reader's text -------------------------------------------------

def blocks(html):
    """The page's text, one block per paragraph, heading, list item, cell."""
    html = re.sub(r"<script.*?</script>", "", html, flags=re.S)
    html = re.sub(r"</?(a|code|span|strong|em)\b[^>]*>", "", html)
    html = re.sub(r"<[^>]+>", "\n", html)
    return [norm(unescape(x)) for x in html.split("\n") if x.strip()]


def between(html, start, end):
    i = html.find(start)
    if i < 0:
        return ""
    j = html.find(end, i)
    return html[i:j if j >= 0 else len(html)]


def section(html, ident):
    """One tab of the Data page, from its opening to the next one's."""
    i = html.find(f'<section class="panel" id="{ident}">')
    if i < 0:
        return ""
    j = html.find('<section class="panel"', i + 1)
    k = html.find('<section class="credits"', i + 1)
    ends = [x for x in (j, k) if x > 0]
    return html[i:min(ends) if ends else len(html)]


# ---- The copy, as the site reads it -------------------------------------------

with app.app_context():
    copy = published.reference()
real_reference_first = published.reference
if os.environ.get("BREAK") == "2":
    # What the check expects, changed; what the site shows, not.
    copy = copying.deepcopy(copy)
    copy["bills"][0]["outcome"] = "Withdrawn"
    copy["stages"][0]["date_ended"] = copy["stages"][0]["date_ended"] + datetime.timedelta(days=1)
    next(f for f in copy["sources"] if f["note"])["note"] += " (changed)"
    copy["files"][0]["what_it_holds"] += " (changed)"
when = day(copy["about"][0]["date_copy_taken"])
copy_date = copy["about"][0]["date_copy_taken"]

MARKER = "made-up-reader"
real_signed_in_as = accounts.signed_in_as
accounts.signed_in_as = lambda m: ("A made-up reader", False) if m == MARKER else None

client = app.test_client()


def get(path, signed_in=False):
    c = app.test_client()
    if signed_in:
        c.set_cookie(key="signed_in", value=MARKER, domain="localhost")
    return c.get(path)


# ---- 1. Signed out --------------------------------------------------------------

page_words = [copy["notes"][0]["title"], "Methodology notes", "Sources and licence",
              "Contains information licensed", "The charts are being built",
              "Accurate as at that date", "Showing", "What each heading holds",
              next(b["title"] for b in copy["bills"] if b["bill_number"] == 305), "Legal Continuity"]
for path, target in [("/data", "/data"), ("/data?x=1", "/data"), ("/insights", "/insights"),
                     ("/data?session=5&title=continuity", "/data?session=5&title=continuity")]:
    r = get(path)
    body = r.get_data(as_text=True)
    loc = r.headers.get("Location", "")
    sent = parse_qs(urlsplit(loc).query).get("next", [""])[0]
    check(f"signed out, {path} goes to the sign-in page and nowhere else, returning to {target}",
          r.status_code == 302 and urlsplit(loc).path == "/sign-in" and sent == target,
          f"{r.status_code} {loc}")
    check(f"signed out, {path} gives none of the page's words",
          not any(w in body for w in page_words))

# ---- 2. The sign-in page on the way, and where signing in returns to --------------

r = get("/sign-in?next=/data")
body = r.get_data(as_text=True)
check("the sign-in page on the way to Data says the agreed sentence, once",
      body.count("<p>Sign in to see the data.</p>") == 1 and "Sign in to see the data." in part(6))
check("the sign-in page carries the return address",
      'name="next" id="next" value="/data"' in body)
check("the sign-in page with no return says nothing of the data",
      "Sign in to see the data." not in get("/sign-in").get_data(as_text=True))

real_new_code, real_sign_in = accounts.new_code, accounts.sign_in
accounts.new_code = lambda email: None           # no code made, no email sent
accounts.sign_in = lambda email, code: MARKER if code == "123456" else None
r = client.post("/sign-in", data={"email": "someone@example.com", "next": "/data#M7"})
check("sending for a code carries the return address to the code page",
      'name="next" value="/data#M7"' in r.get_data(as_text=True))
for sent, lands in [("/data#M7", "/data#M7"), ("/insights", "/insights"),
                    ("/data#terms-of-use", "/data#terms-of-use"),
                    ("//example.com", "/"), ("https://example.com", "/"),
                    ("/admin", "/"), ("/data/../admin", "/"), ("/data#<b>", "/"), ("", "/"),
                    ("/data?session=5&title=continuity", "/data?session=5&title=continuity"),
                    ("/data#words-bill_type", "/data#words-bill_type"),
                    ("/data?session=5&title=continuity#bill-305",
                     "/data?session=5&title=continuity#bill-305"),
                    ("/data?next=//example.com", "/data"), ("/data?title=<b>", "/data"),
                    ("/data?session=5&admin=1", "/data?session=5"),
                    ("/insights?session=5", "/insights")]:
    r = client.post("/sign-in/code", data={"email": "someone@example.com", "code": "123456",
                                           "next": sent})
    check(f"signing in with a return of {sent or '(none)'} lands at {lands}",
          r.status_code == 303 and r.headers["Location"] == lands, r.headers.get("Location"))
r = client.post("/sign-in/code", data={"email": "someone@example.com", "code": "999999",
                                       "next": "/data#M7"})
check("a wrong code keeps the return address on the page it gives back",
      r.status_code == 400 and 'name="next" value="/data#M7"' in r.get_data(as_text=True))
accounts.new_code, accounts.sign_in = real_new_code, real_sign_in

# ---- 3. Signed in ------------------------------------------------------------------

data = get("/data", signed_in=True)
html = data.get_data(as_text=True)
ins = get("/insights", signed_in=True)
ins_html = ins.get_data(as_text=True)
check("signed in, both pages answer", data.status_code == 200 and ins.status_code == 200,
      f"{data.status_code} {ins.status_code}")
check("neither page is kept by the browser",
      data.headers.get("Cache-Control") == "no-store" and ins.headers.get("Cache-Control") == "no-store")
check("the header reads Data · Insights · Privacy, on both",
      all('<a href="/data">Data</a> · <a href="/insights">Insights</a> · <a href="/privacy">Privacy</a> · Signed in as'
          in h for h in (html, ins_html)))
check("signed out, no page's header has Data or Insights",
      all('href="/data">Data<' not in get(p).get_data(as_text=True) for p in ("/", "/privacy", "/sign-in")))

# ---- 4. The date and the date statement ------------------------------------------------

p2 = [x.replace("18 September 2026", when) for x in part(2)]
got = blocks(between(html, '<div class="page-head">', '<nav class="tabs"'))
check(f"beside the heading: Data as at {when}, from the copy", p2[0] in got, got)
check("the date statement is part 2, word for word", p2[1] in got, got)
check("the date statement has no link after it (changed with the table)",
      "See what has changed" not in html)
p8 = part(8)
check("the Data page opens with part 8's sentence, word for word, and part 6's is gone",
      p8[0] in blocks(html) and p8[0].startswith("Every bill introduced")
      and "are being built." not in html)

# ---- 5. The credit lines -------------------------------------------------------------

p3 = part(3)
credits = blocks(between(html, '<section class="credits"', "</section>"))
check("the credit lines are part 3, word for word, in its order, no more and no less",
      credits == p3, f"page {len(credits)} blocks, agreed {len(p3)}")
check("all four sets of terms are credited", len(copy["terms"]) == 4 and
      sum(1 for b in credits if b.startswith("Values from") or b.startswith("Everything else")) == 4)
links_ok = all(f'<a href="{t["licence_link"]}">' in between(html, '<section class="credits"', "</section>")
               for t in copy["terms"])
check("each licence in the credit lines links to the copy's link for it", links_ok)
check("the Terms of use link goes to its section",
      '<a href="/data#terms-of-use">Terms of use</a>' in html and 'id="terms-of-use"' in html)

# ---- 6. The footer, everywhere ---------------------------------------------------------

p1 = [x.replace("18 September 2026", when) for x in part(1)]
foot_ok = True
for path, signed in [("/", False), ("/privacy", False), ("/apply", False), ("/sign-in", False),
                     ("/", True), ("/data", True), ("/insights", True)]:
    foot = blocks(between(get(path, signed).get_data(as_text=True), "<footer", "</footer>"))
    foot = [b for b in foot if b not in ("Light mode", "Dark mode")]
    if foot != p1:
        foot_ok = False
        print(f"      {path}: {foot}")
check("the footer is part 1, word for word, on every page, signed in and out", foot_ok)
css = open(os.path.join(REL, "static/css/site.css")).read()
foot_rule = re.search(r"\n\.foot \{(.*?)\}", css, flags=re.S).group(1)
check("the footer stays in view at the foot of the screen, and prints where it falls",
      "position: sticky;" in foot_rule and "bottom: 0;" in foot_rule
      and ".foot { position: static;" in between(css, "@media print", "\n}\n"))
check("the footer's What has changed links to it",
      '<a href="/data#what-has-changed">What has changed</a>' in get("/").get_data(as_text=True))

# ---- 7. Methodology notes ---------------------------------------------------------------

sec = section(html, "methodology-notes")
check("Methodology notes: its heading and intro are part 7's",
      blocks(sec)[:2] == [part(7)[0], part(7)[4]], blocks(sec)[:2])
on_page = re.findall(r'<details class="note" id="([^"]+)">', sec)
check(f"Methodology notes: {len(copy['notes'])} notes, no more, in order",
      on_page == [x["note"] for x in copy["notes"]] and len(on_page) == 14, on_page)
bad = []
for note in copy["notes"]:
    block = between(sec, f'<details class="note" id="{note["note"]}">', "</details>")
    paras = [p.strip() for p in re.split(r"\n\s*\n", note["text"]) if p.strip()]
    got_paras = re.findall(r"<p>(.*?)</p>", between(block, 'class="prose note-text"', "</div>"), flags=re.S)
    heads = [h.strip() for h in note["applies_to"].split(",")]
    if (f'<span class="note-code">{escape(note["note"])}</span>' not in block
            or f'<span class="note-title">{escape(note["title"])}</span>' not in block
            or got_paras != [str(escape(p)) for p in paras]
            or re.findall(r"<code>(.*?)</code>", between(block, 'class="applies"', "</p>")) != [str(escape(h)) for h in heads]):
        bad.append(note["note"])
check("Methodology notes: every code, title, paragraph and heading as the copy has it", not bad, bad)

# ---- 8. Sources and terms of use ----------------------------------------------------------

sec = section(html, "sources-and-terms")
p4 = part(4)
got = blocks(sec)
check("Terms of use: the section heading, then part 4's heading and opening, word for word",
      got[:4] == [part(7)[1]] + p4[:3], got[:4])
check("Terms of use: four blocks, no more", sec.count('<div class="terms-block">') == len(copy["terms"]) == 4)
meaning = {w["value"]: w["what_it_means"] for w in copy["words"] if w["heading"] == "source"}
bad = []
for t in copy["terms"]:
    block = between(sec, f'<h4>{escape(t["terms_for"])}</h4>', "</div>")
    b = blocks(block)
    names = [x.strip() for x in t["covers"].split(";")]
    want = [t["terms_for"], "Covers:"]
    want += [f"{x} — {meaning[x]}" for x in names] if all(x in meaning for x in names) else [t["covers"]]
    want += [f"Licence: {t['licence']}", f"Credit line: {t['credit_line']}",
             f"What it does not allow, in its own words: {t['restrictions']}"]
    if t["date_terms_read"]:
        shown = re.sub(r"^https?://(www\.)?", "", t["terms_page"]).rstrip("/")
        want.append(f"Terms read on {day(t['date_terms_read'])}, at {shown}.")
    if b != [norm(x) for x in want] or f'<a href="{t["licence_link"]}">' not in block:
        bad.append(t["terms_for"])
        print("      want:", want, "\n      got: ", b)
check("Terms of use: every block as the copy has it, each source with its sentence", not bad, bad)
sp = [x for x in p4 if x.startswith("Terms read on")][0]
check("Terms of use: the Scottish Parliament's block matches part 4's example",
      sp.replace("18 September 2026", day(copy["terms"][0]["date_terms_read"])) in got)
order = [x.group(1) for x in re.finditer(r"<h4>(.*?)</h4>", sec)]
check("Terms of use: in the agreed order, our own last",
      order == ["Scottish Parliament", "legislation.gov.uk", "Supreme Court", "legislativedata.org"], order)

# ---- 9. What the words mean ---------------------------------------------------------------

sec = section(html, "what-the-words-mean")
check("What the words mean: its heading and intro are part 7's",
      blocks(sec)[:2] == [part(7)[2], part(7)[5]], blocks(sec)[:2])
pairs = re.findall(r"<dt>(.*?)</dt><dd>(.*?)</dd>", sec, flags=re.S)
heads = re.findall(r'<h3 class="word-heading"[^>]*><code>(.*?)</code></h3>', sec)
want_pairs = [(str(escape(w["value"])), str(escape(w["what_it_means"]))) for w in copy["words"]]
check(f"What the words mean: {len(copy['words'])} lines, no more, each as the copy has it, in its order",
      pairs == want_pairs and len(pairs) == 89, f"{len(pairs)} on the page")
check("What the words mean: 17 headings, no more",
      heads == sorted(set(w["heading"] for w in copy["words"])) and len(heads) == 17, len(heads))

# ---- 10. What has changed --------------------------------------------------------------------

sec = section(html, "what-has-changed")
got = blocks(sec)
check("What has changed: its heading and intro are part 7's", got[:2] == [part(7)[3], part(7)[6]], got[:2])
if not copy["changed"]:
    check("What has changed, today: nothing, in the agreed words",
          got[2] == part(7)[7] and "<table" not in sec, got[2:])
    check(f"What has changed, today: Added in the copy of {when}: no lines.",
          got[3:] == [part(7)[9].replace("18 September 2026", when)], got[3:])

# Invented lines, drawn and never written anywhere.
day1, day2 = copy_date, copy_date + datetime.timedelta(days=7)
invented = [
    dict(date_copy_taken=day1, file="bills", bill_number=101, stage=None, which_line=None,
         heading="outcome", old_value="fell_dissolution", new_value="rejected_stage_1"),
    dict(date_copy_taken=day2, file="stages", bill_number=202, stage="Stage 3", which_line=None,
         heading="date_stage_ended", old_value="2021-03-01", new_value="2021-03-02"),
    dict(date_copy_taken=day2, file="bills", bill_number=303, stage=None, which_line=None,
         heading="(line removed)", old_value="An Invented Bill", new_value=None),
    dict(date_copy_taken=day2, file="sessions", bill_number=None, stage=None, which_line="7",
         heading="date_session_expected_to_end", old_value="2031-05-01", new_value="2031-05-08"),
    dict(date_copy_taken=day1, file="bills", bill_number=404, stage=None, which_line=None,
         heading="note", old_value="An invented note & <b>tag</b>", new_value=None),
]
invented.sort(key=lambda c: (-c["date_copy_taken"].toordinal(), c["file"], c["bill_number"] or 0))
real_reference = published.reference


def drawn_with(changed=None, added=None):
    fake = copying.deepcopy(copy)
    if changed is not None:
        fake["changed"] = changed
    if added is not None:
        for a in fake["about"]:
            a["rows_added_since_last_copy"] = added.get(a["file"])
    published.reference = lambda: fake
    try:
        return section(get("/data", signed_in=True).get_data(as_text=True), "what-has-changed")
    finally:
        published.reference = real_reference


sec = drawn_with(changed=invented)
rows = re.findall(r"<tr>(.*?)</tr>", between(sec, "<tbody>", "</tbody>"), flags=re.S)
cells = [[unescape(c) for c in re.findall(r"<td>(.*?)</td>", r, flags=re.S)] for r in rows]
want = [[day(c["date_copy_taken"]), "" if c["bill_number"] is None else str(c["bill_number"]),
         c["stage"] or c["which_line"] or "", c["heading"], c["old_value"] or "", c["new_value"] or ""]
        for c in invented]
check("What has changed, invented: five lines of every kind, newest copy first, each as given",
      cells == want and cells[0][0] == day(day2) and cells[-1][0] == day(day1), cells)
check("What has changed, invented: a removed line shows (line removed)", any(c[3] == "(line removed)" for c in cells))
check("What has changed, invented: a line's own words are shown, not obeyed",
      "&lt;b&gt;tag&lt;/b&gt;" in sec and "<b>tag</b>" not in sec)
check("What has changed, invented: the nothing-changed sentence is gone", part(7)[7] not in blocks(sec))

zero = {f: 0 for f in ("bills", "stages", "days_between_stages", "sessions", "methodology_notes",
                       "sources", "what_the_words_mean", "workings", "terms")}
some = dict(zero, bills=3, stages=9)
got = blocks(drawn_with(added=some))[-1]
check("Added lines, some: part 7's example, word for word", got == part(7)[8].replace("18 September 2026", when), got)
got = blocks(drawn_with(added=dict(zero, bills=1, days_between_stages=4)))[-1]
check("Added lines, one and a worked-out file: 1 line to bills, 4 to days_between_stages",
      got == f"Added in the copy of {when}: 1 line to bills, 4 to days_between_stages.", got)
got = blocks(drawn_with(added=zero))[-1]
check("Added lines, none: part 7's words", got == part(7)[9].replace("18 September 2026", when), got)
got = blocks(drawn_with(added={}))[-1]
check("Added lines, the first copy: part 7's words", got == part(7)[10], got)

# ---- 11. The Insights page ---------------------------------------------------------------------

main = between(ins_html, "<main>", "</main>")
check("Insights: part 6's words, and no date statement or credit lines",
      blocks(main) == ["Insights", "Insights", "The charts are being built."]
      and "Accurate as at" not in main and "Sources and licence" not in main, blocks(main))

# ---- 12. The copy made unreadable -------------------------------------------------------------------

published.CONNINFO = "dbname=no_such_workbook"
r = get("/data", signed_in=True)
main = between(r.get_data(as_text=True), "<main>", "</main>")
p6 = part(6)
check("unreadable: the Data page says it can't be shown, in part 6's words, and nothing else",
      r.status_code == 503 and blocks(main) == ["Data", p6[2], p6[3]], (r.status_code, blocks(main)))
fine = True
for path in ("/", "/privacy", "/sign-in"):
    r = get(path)
    foot = blocks(between(r.get_data(as_text=True), "<footer", "</footer>"))
    if r.status_code != 200 or foot[0] != part(1)[1] or any("Data as at" in b for b in foot):
        fine = False
check("unreadable: home, privacy and sign-in still draw, with no date and the independence sentence", fine)
published.CONNINFO = os.environ.get("PUBLISHED_CONNINFO", "dbname=published")
check("readable again: the Data page is back", get("/data", signed_in=True).status_code == 200)

# ---- 13. The tabs, and every link into one landing inside it ----------------------------------------

TABS = [("bills", "Bills"), ("methodology-notes", "Methodology notes"),
        ("sources-and-terms", "Sources and terms of use"),
        ("what-each-heading-holds", "What each heading holds"),
        ("what-the-words-mean", "What the words mean"), ("what-has-changed", "What has changed")]
nav = between(html, '<nav class="tabs"', "</nav>")
check("six tabs, in the agreed order, named as agreed",
      re.findall(r'<a href="#([^"]+)" data-tab="[^"]+">([^<]+)</a>', nav) == TABS,
      re.findall(r'<a href="#([^"]+)"', nav))
check("each tab has its panel, and there are no others",
      re.findall(r'<section class="panel" id="([^"]+)">', html) == [t for t, _ in TABS])
check("the tab names are part 7's headings and part 8's",
      all(name in part(7) + part(8) for t, name in TABS if t != "bills"))
for target, tab in [("M1", "methodology-notes"), ("M7", "methodology-notes"),
                    ("M14", "methodology-notes"), ("methodology-notes", "methodology-notes"),
                    ("terms-of-use", "sources-and-terms"), ("sources-and-terms", "sources-and-terms"),
                    ("what-the-words-mean", "what-the-words-mean"),
                    ("words-outcome", "what-the-words-mean"),
                    ("what-has-changed", "what-has-changed"),
                    ("h-bills-outcome", "what-each-heading-holds"), ("bills", "bills")]:
    check(f"#{target} lands inside the {tab} tab", f'id="{target}"' in section(html, tab)
          and html.count(f'id="{target}"') == 1)
credit_at = html.find('<section class="credits"')
check("the credit lines come after every tab, so they show under each",
      credit_at > max(html.find(f'<section class="panel" id="{t}">') for t, _ in TABS))

# ---- 14. The table of every bill -------------------------------------------------------------------------

COLUMNS = ["bill_number", "session", "title", "bill_type", "date_introduced", "outcome",
           "date_royal_assent"]
bills = copy["bills"]
total = len(bills)


def cell(v):
    if v is None or v == "":
        return None
    return v.isoformat() if hasattr(v, "isoformat") else str(v)


def table_rows(page):
    """(bill number, [seven cells as a reader reads them], has the note mark)."""
    out = []
    for num, row in re.findall(r'<tr id="bill-(\d+)">(.*?)</tr>', between(page, '<table class="bills">', "</table>"), flags=re.S):
        cells = re.findall(r'<td class="c-[a-z_]+">(.*?)</td>', row, flags=re.S)
        mark = '<span class="has-note">note</span>' in row
        cells = [norm(unescape(re.sub(r"<[^>]+>", "", c.replace('<span class="has-note">note</span>', "")))) for c in cells]
        out.append((int(num), cells, mark))
    return out


def want_row(b):
    return (b["bill_number"], [norm(cell(b[c]) or "") for c in COLUMNS], bool(b["note"]))


sec = section(html, "bills")
got = table_rows(sec)
check(f"the table: all {total} lines, in bill number order, each line's seven cells as the copy has them",
      got == [want_row(b) for b in bills] and total == 470,
      f"{len(got)} lines; first differing: {next((g for g, w in zip(got, map(want_row, bills)) if g != w), None)}")
check("the table: each line opens its bill, at its own address",
      all(f'<a class="open-bill" href="#bill-{b["bill_number"]}">' in sec for b in bills))
heads = re.findall(r'<th scope="col" class="c-([a-z_]+)"><a href="#h-bills-([a-z_]+)">([a-z_]+)</a></th>', sec)
check("the table: the seven headings are the file's names, in order, each linking to its entry",
      [h[2] for h in heads] == COLUMNS and all(a == b == c for a, b, c in heads)
      and all(f'id="h-bills-{c}"' in html for c in COLUMNS), heads)
check("the table: the note mark on exactly the ten bills with a note",
      sum(1 for g in got if g[2]) == 10 == sum(1 for b in bills if b["note"]))
check("the count, all: part 8's words", f"Showing all {total} bills." in blocks(sec)
      and part(8)[3].replace("470", str(total)) == f"Showing all {total} bills.")
check("above the dropdowns: part 8's four names, and Show and Clear",
      [x for x in blocks(between(sec, '<form class="narrow"', "</form>")) if x in
       ("Session", "Type", "Outcome", "Title contains", "Show", "Clear")]
      == ["Session", "Type", "Outcome", "Title contains", "Show", "Clear"]
      and part(8)[1] == "Session · Type · Outcome · Title contains" and part(8)[2] == "Show · Clear"
      and '<a href="/data">Clear</a>' in sec)


def fold(t):
    return (t or "").lower().replace("’", "'")


def expect(session=None, btype=None, outcome=None, title=None):
    return [b["bill_number"] for b in bills
            if (session is None or b["session"] == session) and (btype is None or b["bill_type"] == btype)
            and (outcome is None or b["outcome"] == outcome) and (title is None or fold(title) in fold(b["title"]))]


def narrowed_page(query):
    r = get("/data?" + query, signed_in=True)
    return r, r.get_data(as_text=True)


r, page = narrowed_page("session=5&title=continuity")
nums = [g[0] for g in table_rows(page)]
check("narrowing: Session 5 and \"continuity\" gives the write-up's two bills",
      nums == expect(5, title="continuity") and len(nums) == 2
      and any("Legal Continuity" in b["title"] for b in bills if b["bill_number"] in nums),
      [b["title"] for b in bills if b["bill_number"] in nums])
check("narrowing: the count, some, is part 8's words",
      f"Showing 2 of {total} bills." in blocks(page) and part(8)[4] == "Showing 17 of 470 bills.")

sessions = sorted({b["session"] for b in bills})
words_in = lambda h, col: [w["value"] for w in copy["words"] if w["heading"] == h
                           and any(b[col] == w["value"] for b in bills)]
types, outcomes = words_in("bill_type", "bill_type"), words_in("outcome", "outcome")
bad = []
for q, want in ([(f"session={x}", expect(session=x)) for x in sessions]
                + [(f"type={t}", expect(btype=t)) for t in types]
                + [(f"outcome={o}", expect(outcome=o)) for o in outcomes]
                + [("session=1&type=Member%27s%20Bill&outcome=Passed", expect(1, "Member's Bill", "Passed")),
                   ("title=SCOTLAND", expect(title="scotland")),
                   ("title=pupils%27", expect(title="pupils'"))]):
    r, page = narrowed_page(q)
    if r.status_code != 200 or [g[0] for g in table_rows(page)] != want or not want:
        bad.append((q, r.status_code))
    elif f"Showing {len(want)} of {total} bills." not in blocks(page) and len(want) != total:
        bad.append((q, "count"))
check(f"narrowing: each of {len(sessions)} sessions, {len(types)} types, {len(outcomes)} outcomes, a "
      "combination, capitals and the curly apostrophe, as the copy worked out separately", not bad, bad)
check("narrowing: the curly apostrophe is matched by the straight one",
      len(expect(title="pupils'")) >= 1)

r, page = narrowed_page("title=no%20such%20bill%20anywhere")
check("narrowing: nothing matching gives part 8's sentence and no table",
      part(8)[5] in blocks(page) and '<table class="bills">' not in page)

drop = between(html, '<select id="f-session"', "</select>")
opts = lambda sel: re.findall(r'<option value="([^"]*)"', sel)
check("dropdowns: sessions, types and outcomes as the copy lists them, only those some bill has, All first",
      opts(drop) == [""] + [str(x) for x in sessions]
      and opts(between(html, '<select id="f-type"', "</select>")) == [""] + [str(escape(t)) for t in types]
      and opts(between(html, '<select id="f-outcome"', "</select>")) == [""] + [str(escape(o)) for o in outcomes]
      and all(f'<option value="">All</option>' in between(html, f'<select id="f-{k}"', "</select>")
              for k in ("session", "type", "outcome")),
      (opts(drop), types, outcomes))
r, page = narrowed_page("session=5&outcome=Withdrawn&title=bill")
check("dropdowns: the chosen ones shown as chosen, and the words typed in the box",
      '<option value="5" selected>' in page and '<option value="Withdrawn" selected>' in page
      and 'name="title" type="text" autocomplete="off" maxlength="100" value="bill"' in page)

hostile = [("title=%3Cscript%3Ealert(1)%3C/script%3E%22%27", 200),
           ("session=abc", 302), ("session=99", 302), ("type=Nonsense", 302),
           ("outcome=%22%3E%3Cb%3E", 302), ("title=" + "x" * 5000, 302),
           ("session=5&session=6", 302), ("sort=title", 302)]
bad = []
for q, code in hostile:
    r = get("/data?" + q, signed_in=True)
    page = r.get_data(as_text=True)
    if r.status_code != code:
        bad.append((q[:40], r.status_code))
        continue
    if code == 302:
        r2 = get(r.headers["Location"], signed_in=True)
        if r2.status_code != 200 or len(r.headers["Location"]) > 200:
            bad.append((q[:40], "then", r2.status_code, r.headers["Location"][:60]))
    elif "<script>alert" in page or "&lt;script&gt;alert(1)&lt;/script&gt;&#34;&#39;" not in page:
        bad.append((q[:40], "not shown as text"))
check("things slipped into the address: shown as text, never obeyed; anything unused sent on to "
      "the address that says what is shown; never an error", not bad, bad)
r = get("/data?session=99", signed_in=True)
check("an unknown choice is ignored: session=99 goes to /data", r.headers.get("Location") == "/data")
r = get("/data?title=" + "a" * 5000, signed_in=True)
check("a title is cut to 100 characters", r.headers.get("Location") == "/data?title=" + "a" * 100)

# ---- 15. Every bill, opened --------------------------------------------------------------------------------

templates = dict(re.findall(r'<template id="open-bill-(\d+)"(.*?)</template>', html, flags=re.S))
check(f"opened bills: one for each of the {total}, out of sight until opened",
      sorted(map(int, templates)) == [b["bill_number"] for b in bills]
      and html.count("<h3>The bill</h3>") == total
      and html.count("<h3>The bill</h3>") == len(re.findall(r"<template[^>]*>\s*<h3>The bill</h3>", html)))
check("opened bills: the three part headings are part 8's", part(8)[6:9] ==
      ["The bill", "Its stages", "Where each fact came from"])

bill_headings = [f["heading"] for f in sorted((f for f in copy["files"] if f["file"] == "bills"),
                                              key=lambda f: f["position"])]
notes_for = {}
for note in copy["notes"]:
    for h in note["applies_to"].split(","):
        notes_for.setdefault(h.strip(), []).append(note["note"])
stages_of, facts_of = {}, {}
for st in copy["stages"]:
    stages_of.setdefault(st["bill_number"], []).append(st)
for f in copy["sources"]:
    facts_of.setdefault(f["bill_number"], []).append(f)


def shown(v):
    """A value as the page should show it: text, or an address as a link."""
    if v is None:
        return "—"
    e = str(escape(v))
    return f'<a href="{e}">{e}</a>' if re.match(r"https?://", v) else e


problems = {"head": [], "fields": [], "stages": [], "facts": [], "link": []}
for b in bills:
    num = b["bill_number"]
    t = templates[str(num)]
    if (f'data-eyebrow="Bill {num} · Session {b["session"]}"' not in t
            or f'data-title="{escape(b["title"])}"' not in t):
        problems["head"].append(num)
    # The bill, heading by heading.
    pairs = re.findall(r'<dt><a class="heading-link" href="#h-bills-([a-z_0-9]+)">([a-z_0-9]+)</a>(.*?)</dt>'
                       r'(?:<dd class="empty">(—)</dd>|<dd>(.*?)</dd>)', t, flags=re.S)
    want = []
    for h in bill_headings:
        v = cell(b[h])
        want.append((h, h, notes_for.get(f"bills.{h}", []), "—" if v is None else "", "" if v is None else shown(v)))
    got_pairs = [(a, bb, re.findall(r'<a href="#(M\d+)">', codes), e, d) for a, bb, codes, e, d in pairs]
    if got_pairs != want or len(pairs) != 34:
        problems["fields"].append(num)
    # Its stages.
    rows = re.findall(r"<tr><td>(.*?)</td></tr>", between(t, '<table class="sub">', "</table>"), flags=re.S)
    want_rows = []
    for st in stages_of.get(num, []):
        asides = [f"{h}: {st[h]}" for h in ("stage_never_happened", "bill_ended_here") if st[h]]
        asides += [st[h] for h in ("why_there_is_no_date", "note") if st[h]]
        first = str(escape(st["stage"])) + (('<span class="aside">' + "<br>".join(str(escape(a)) for a in asides) + "</span>") if asides else "")
        want_rows.append("</td><td>".join([first, cell(st["date_ended"]) or "—", str(escape(cell(st["got_through"]) or "—")),
                                           str(escape(cell(st["source"]) or "—")), shown(cell(st["where_in_the_source"])),
                                           cell(st["date_source_read"]) or "—"]))
    if rows != want_rows:
        problems["stages"].append(num)
    # Where each fact came from.
    items = re.findall(r"<li>(.*?)</li>", between(t, '<ul class="facts">', "</ul>"), flags=re.S)
    mine = facts_of.get(num, [])
    if not mine:
        if part(8)[9] not in blocks(t) or items:
            problems["facts"].append(num)
    else:
        ok = len(items) == len(mine)
        for f in mine:
            head = f'{escape(f["applies_to_file"])}.{escape(f["applies_to_heading"])}' + (f' · {escape(f["stage"])}' if f["stage"] else "")
            line = f'<p>{escape(f["source"])} · {shown(cell(f["where_in_the_source"]))} · <span class="quiet">read {cell(f["date_source_read"]) or "—"}</span></p>'
            match = [i for i in items if f'<span class="fact-head">{head}</span>' in i and line in i
                     and (not f["value_as_the_source_gave_it"] or f"<blockquote>{escape(f['value_as_the_source_gave_it'])}</blockquote>" in i)
                     and (not f["note"] or f"<p>{escape(f['note'])}</p>" in i)]
            ok = ok and bool(match)
        if not ok or "This address no longer works" in t:
            problems["facts"].append(num)
    if f'<a href="#bill-{num}">Link to this bill</a>' not in t:
        problems["link"].append(num)
check("opened bills: the eyebrow and title of each", not problems["head"], problems["head"][:10])
check("opened bills: every heading of its line, all 34, in the file's order, each value as the copy "
      "has it, a dash for an empty cell, and exactly the notes that bear on it", not problems["fields"],
      problems["fields"][:10])
check(f"opened bills: every stage, {len(copy['stages'])} in all, each field as the copy has it",
      not problems["stages"] and sum(len(v) for v in stages_of.values()) == len(copy["stages"]),
      problems["stages"][:10])
check(f"opened bills: every line about a bill in the sources file ({len(copy['sources'])} lines, "
      f"{len(facts_of)} bills), each field as the copy has it; part 8's sentence for the "
      f"{total - len(facts_of)} with none", not problems["facts"], problems["facts"][:10])
check("opened bills: part 8's Link to this bill, to its own address", not problems["link"]
      and part(8)[11] == "Link to this bill")

# An address that has gone, drawn with an invented one, nothing written to the copy.
used = next(f for f in copy["sources"] if f["where_in_the_source"] in {c["address"] for c in copy["cited"]})
fake = copying.deepcopy(copy)
for c in fake["cited"]:
    if c["address"] == used["where_in_the_source"]:
        c["address_works"], c["kept_copy"], c["date_kept"] = "No", "An invented kept copy", copy_date
published.reference = lambda: fake
try:
    page = get("/data", signed_in=True).get_data(as_text=True)
finally:
    published.reference = real_reference_first
gone_t = dict(re.findall(r'<template id="open-bill-(\d+)"(.*?)</template>', page, flags=re.S))[str(used["bill_number"])]
sentence = part(8)[10].replace("[the day we kept it]", day(copy_date)).replace("[the kept copy's name]", "An invented kept copy")
check("an address that has gone: part 8's sentence, with the day and the kept copy's name",
      sentence in blocks(gone_t) and page.count("This address no longer works") ==
      sum(1 for f in copy["sources"] if f["where_in_the_source"] == used["where_in_the_source"]),
      (sentence, [b for b in blocks(gone_t) if "no longer" in b]))
check("an address that works, or was not checked, gets no such sentence",
      "This address no longer works" not in html)

# ---- 16. What each heading holds ------------------------------------------------------------------------------

sec = section(html, "what-each-heading-holds")
check("What each heading holds: its heading and sentence are part 8's",
      blocks(sec)[:2] == part(8)[12:14], blocks(sec)[:2])
ORDER = ["bills", "stages", "days_between_stages", "sessions", "methodology_notes", "sources",
         "what_the_words_mean", "what_changed", "workings", "about", "cited_pages", "terms"]
files_on_page = re.findall(r'<h3 id="file-([a-z_]+)">', sec)
check("What each heading holds: every file, in the mock-up's order", files_on_page == ORDER
      and set(ORDER) == {f["file"] for f in copy["files"]}, files_on_page)
pairs = re.findall(r'<dt id="h-([a-z_]+)-([a-z_0-9]+)"><code>([a-z_0-9]+)</code></dt><dd>(.*?)</dd>', sec, flags=re.S)
want = [(f["file"], f["heading"], f["heading"], str(escape(f["what_it_holds"])))
        for name in ORDER for f in sorted((x for x in copy["files"] if x["file"] == name), key=lambda x: x["position"])]
check(f"What each heading holds: all {len(want)} headings, each with the description the copy stores on it",
      pairs == want and len(want) == 113 and all(f["what_it_holds"] for f in copy["files"]),
      f"{len(pairs)} on the page")
check("What each heading holds: each file with its own description",
      all(f'<p class="file-desc">{escape(f["file_holds"])}</p>' in sec for f in copy["files"]))

# ---- 17. The size of the page -----------------------------------------------------------------------------------

raw = html.encode()
print(f"      the Data page: {len(raw):,} bytes, {len(gzip.compress(raw)):,} sent compressed")

accounts.signed_in_as = real_signed_in_as
print("---")
print(f"All {n} pass" if not failed else f"NOT PASSED: {failed} of {n} failed")
sys.exit(1 if failed else 0)
