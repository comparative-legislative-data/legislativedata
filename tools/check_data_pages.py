"""The Data and Insights pages, checked on the machine against a staged release.

Strand 2, items 2 and 3 (docs/STRAND-2-ITEMS-2-AND-3-BUILD.md, part A). Run
as the site's own login, in the release's own environment, with the agreed
wording sent alongside:

    sudo -u legsite /srv/site/releases/<release>/.venv/bin/python \\
        check_data_pages.py /srv/site/releases/<release> PUBLISHING.md
    ... BREAK=1 ...   # must FAIL at the date statement and the credit lines

It reads the live copy exactly as the site does, and writes nothing anywhere.
It signs nobody in and never opens the accounts: "signed in" is a made-up
reader put in the site's place for the length of the run, and signing in is
checked with the site's own code-checking replaced by one that accepts a
made-up code. It prints each check as PASS or FAIL, and counts and yes/no
answers only.
"""
import copy as copying
import datetime
import os
import re
import sys
from html import unescape

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
    """One reference section, from its opening to the next one's."""
    i = html.find(f'<details class="section" id="{ident}">')
    if i < 0:
        return ""
    j = html.find('<details class="section"', i + 1)
    k = html.find('<section class="credits"', i + 1)
    ends = [x for x in (j, k) if x > 0]
    return html[i:min(ends) if ends else len(html)]


# ---- The copy, as the site reads it -------------------------------------------

with app.app_context():
    copy = published.reference()
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
              "Accurate as at that date"]
for path in ("/data", "/data?x=1", "/insights"):
    r = get(path)
    body = r.get_data(as_text=True)
    target = path.split("?")[0]
    check(f"signed out, {path} goes to the sign-in page and nowhere else",
          r.status_code == 302 and r.headers["Location"] == f"/sign-in?next={target}",
          f"{r.status_code} {r.headers.get('Location')}")
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
                    ("/admin", "/"), ("/data/../admin", "/"), ("/data#<b>", "/"), ("", "/")]:
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
got = blocks(between(html, '<div class="page-head">', '<p class="standfirst">'))
check(f"beside the heading: Data as at {when}, from the copy", p2[0] in got, got)
check("the date statement is part 2, word for word", p2[1] in got, got)
check("the date statement links to What has changed",
      '<a href="#what-has-changed">See what has changed.</a>' in html)
check("the Data page's own words are part 6, word for word",
      "The table of every bill, and the whole dataset to download, are being built." in part(6)
      and "The table of every bill, and the whole dataset to download, are being built." in blocks(html))

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

# ---- 13. Every link into a section has somewhere to land -----------------------------------------------

for target in ("M7", "M1", "M14", "terms-of-use", "what-has-changed", "what-the-words-mean",
               "methodology-notes", "sources-and-terms"):
    at = html.find(f'id="{target}"')
    inside = html.rfind('<details class="section"', 0, at + 1)
    check(f"#{target} lands inside a section that opens", at >= 0 and inside >= 0)

accounts.signed_in_as = real_signed_in_as
print("---")
print(f"All {n} pass" if not failed else f"NOT PASSED: {failed} of {n} failed")
sys.exit(1 if failed else 0)
