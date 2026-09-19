"""legislativedata.org — the site.

Flask, Jinja, gunicorn behind Caddy. No build step. Settled 2026-09-15.

It reads the accounts database (from 2026-09-16) and the published copy (from
2026-09-18), and never the working database. Every page's footer carries the
copy's date, and the date comes from the copy and from nowhere else. See
DECISIONS.md, 2026-09-15, "Every page carries the date of the data it was built
from". The data pages, and the words on them, are strand 2, items 2 and 3:
docs/STRAND-2-SHARED-PAGE-PARTS.md, docs/STRAND-2-REFERENCE-SECTIONS.md and
docs/wording/PUBLISHING.md.
"""
import datetime
import os
import re
from urllib.parse import parse_qs, quote, urlencode

from flask import Flask, Response, abort, g, redirect, render_template, request, url_for

import accounts
import download
import mail
import published

app = Flask(__name__)
app.teardown_appcontext(accounts.close)
app.teardown_appcontext(published.close)

# Nothing the site takes in is anywhere near this. A form is a few hundred bytes.
app.config["MAX_CONTENT_LENGTH"] = 16 * 1024

SITE_NAME = "legislativedata.org"

# The name of the one cookie the site sets, and only on signing in.
DEVICE_COOKIE = "signed_in"


@app.before_request
def who_is_this():
    """Signed in or not, for every page. A browser with no marker costs nothing;
    one with a marker is looked up. Nothing about the request is recorded."""
    g.signed_in = accounts.signed_in_as(request.cookies.get(DEVICE_COOKIE))


# Forms sent from other sites are not refused by checking where they came from.
# The site tells browsers never to pass on where a reader came from, and under
# that setting browsers send "null" for this site's own forms too, so such a
# check would refuse everyone or no one. What protects a signed-in person is the
# cookie itself: it is marked so that browsers do not send it with a form from
# another site, and every form here that matters needs it.


def copy_date():
    """The live copy's date, read once a request. None if the copy cannot be
    read: a page with no data on it then draws without a date, rather than
    with a wrong one or not at all."""
    if "copy_date" not in g:
        g.copy_date = published.date_copy_taken()
    return g.copy_date


@app.context_processor
def shell():
    """Everything base.html needs, so no page has to pass it."""
    return {
        "site_name": SITE_NAME,
        "copy_date": copy_date(),
        "signed_in_name": g.signed_in[0] if g.get("signed_in") else None,
        "is_owner": bool(g.get("signed_in") and g.signed_in[1]),
    }


@app.template_filter("day")
def day(when):
    """16 September 2026."""
    return f"{when.day} {when:%B %Y}"


@app.route("/")
def welcome():
    return render_template("welcome.html")


# What the site holds about a person, and their rights. Wording settled by the
# owner on 2026-09-16, docs/wording/PRIVACY.md. Reads nothing.
@app.route("/privacy")
def privacy():
    return render_template("privacy.html")


@app.route("/health")
def health():
    """What the deploy checks against.

    Healthy means the site is running, can read the accounts, and can read the
    key codes are scrambled with and the key emails are sent with, because
    without any of those nobody can apply, be told, or sign in; and can read
    the published copy, because without it there is no data to show (settled
    2026-09-18: a deploy refuses if it cannot). Says nothing about the data or
    about anyone in the accounts.
    """
    if not accounts.reachable():
        return "accounts unreachable\n", 503, {"Content-Type": "text/plain; charset=utf-8"}
    if not accounts.key_readable():
        return "code key unreadable\n", 503, {"Content-Type": "text/plain; charset=utf-8"}
    if not mail.key_readable():
        return "email key unreadable\n", 503, {"Content-Type": "text/plain; charset=utf-8"}
    if not published.reachable():
        return "published copy unreachable\n", 503, {"Content-Type": "text/plain; charset=utf-8"}
    return "ok\n", 200, {"Content-Type": "text/plain; charset=utf-8"}


# ---- Applying for an account ------------------------------------------------
#
# Wording, behaviour and limits are docs/wording/APPLY.md, settled by the owner
# on 2026-09-16. In short: no email is sent, no cookie is set, nothing about the
# visitor is recorded, and a second application from the same address looks
# exactly like the first and changes nothing.

# The same shape the database insists on, so a person is told here rather than
# refused there.
EMAIL_SHAPE = re.compile(r"^[^@\s]+@[^@\s]+\.[^@\s]+$")

# Field name, what the page calls it, and the length it must be under.
FIELDS = [
    ("email", "Email address", 254),
    ("name", "Name", 200),
    ("title", "Title", 50),
    ("position", "Position", 300),
]

# A field people never see and some bots fill in. If it has anything in it,
# the sender is shown the thank-you page and nothing is kept.
TRAP = "homepage"


def tidy(value):
    """Whitespace at the ends gone, and any run of it inside made one space."""
    return " ".join((value or "").split())


def check(form):
    """The tidied values, and the list of what is wrong with them, in page order."""
    values = {field: tidy(form.get(field)) for field, _, _ in FIELDS}
    values["email"] = values["email"].lower()
    problems = []
    if not values["email"]:
        problems.append("Enter your email address.")
    elif not EMAIL_SHAPE.match(values["email"]):
        problems.append("That doesn't look like an email address.")
    if not values["name"]:
        problems.append("Enter your name.")
    if not values["position"]:
        problems.append("Enter your position.")
    for field, called, under in FIELDS:
        if len(values[field]) >= under:
            problems.append(f"{called} must be under {under} characters.")
    return values, problems


@app.route("/apply", methods=["GET", "POST"])
def apply():
    if request.method == "GET":
        return render_template("apply.html", values={}, problems=[])

    if request.form.get(TRAP):
        return redirect(url_for("apply_received"), code=303)

    values, problems = check(request.form)
    if problems:
        return render_template("apply.html", values=values, problems=problems), 400

    try:
        accounts.apply(values["email"], values["name"], values["title"] or None,
                       values["position"])
    except accounts.Unavailable:
        return render_template("apply_unavailable.html"), 503

    # Sent on to a page of its own, so that reloading it cannot send the form
    # again. The page says the same thing whatever happened.
    return redirect(url_for("apply_received"), code=303)


@app.route("/apply/received")
def apply_received():
    return render_template("apply_received.html")


# ---- The data pages -----------------------------------------------------------
#
# Data and Insights, both behind the sign-in. Agreed 18 September 2026:
# docs/STRAND-2-SHARED-PAGE-PARTS.md and docs/STRAND-2-REFERENCE-SECTIONS.md.
# Every word on them is either in docs/wording/PUBLISHING.md or read from the
# live copy when the page is asked for, so a refresh changes them with no one
# editing a page.

DATA_PAGES = ("/data", "/insights")


def signed_out_to_sign_in():
    """The one rule both pages go through. Signed out, the reader is sent to
    the sign-in page and gets nothing of the page; the browser keeps the
    section they were going to, and the sign-in page carries it through."""
    if not g.get("signed_in"):
        going = return_to(request.full_path.rstrip("?")) or request.path
        return redirect(url_for("sign_in", next=going), code=302)
    return None


def credit_lead(terms_for):
    """The words before a credit line: "Values from the Scottish Parliament",
    "Values from legislation.gov.uk". A name that is a web address takes no
    "the". Settled wording: docs/wording/PUBLISHING.md, part 3."""
    return f"Values from {terms_for}" if "." in terms_for else f"Values from the {terms_for}"


def licence_link_text(term):
    """The part of a credit line that links to the licence: the licence's name
    where the line gives it in full, or else the short form in its brackets."""
    line, name = term["credit_line"], term["licence"]
    if name in line:
        return name
    short = re.search(r"\(([^)]+)\)\s*$", name)
    if short and short.group(1) in line:
        return short.group(1)
    return None


def split_link(line, part):
    """A line cut into (before, the linked part, after), for the template."""
    if not part:
        return (line, None, "")
    before, _, after = line.partition(part)
    return (before, part, after)


def shown_address(address):
    """https://www.parliament.scot/about/copyright as parliament.scot/about/copyright."""
    return re.sub(r"^https?://(www\.)?", "", address or "").rstrip("/")


def terms_in_order(terms, words):
    """The copy's terms, each with what the pages show of it, in the order
    of the first source each covers in the copy's list of sources, and our
    own, which covers no named source, last: the copy's terms file has no
    column for its order."""
    source_words = [w for w in words if w["heading"] == "source"]
    source_order = {w["value"]: i for i, w in enumerate(source_words)}
    source_meaning = {w["value"]: w["what_it_means"] for w in source_words}

    out = []
    for t in terms:
        names = [n.strip() for n in (t["covers"] or "").split(";") if n.strip()]
        named = [n for n in names if n in source_meaning]
        out.append({
            **t,
            "covers_sources": [(n, source_meaning[n]) for n in named] if named else None,
            "place": min(source_order[n] for n in named) if named else len(source_order),
            "lead": credit_lead(t["terms_for"]) if named else "Everything else",
            "credit_parts": split_link(t["credit_line"], licence_link_text(t)),
            "terms_page_shown": shown_address(t["terms_page"]),
        })
    out.sort(key=lambda t: (t["place"], t["terms_for"]))
    return out


def credit_lines(terms, words):
    """Part 3's credit lines as plain text, in the pages' order, for the
    download's readme."""
    return [f"{t['lead']}: {t['credit_line']}" for t in terms_in_order(terms, words)]


def reference_sections(copy):
    """The copy's files shaped for the Data page, and nothing added to them."""
    terms = terms_in_order(copy["terms"], copy["words"])

    notes = [{**n,
              "paragraphs": [p.strip() for p in re.split(r"\n\s*\n", n["text"]) if p.strip()],
              "headings": [h.strip() for h in (n["applies_to"] or "").split(",") if h.strip()]}
             for n in copy["notes"]]

    words = []
    for w in copy["words"]:
        if not words or words[-1]["heading"] != w["heading"]:
            words.append({"heading": w["heading"], "lines": []})
        words[-1]["lines"].append(w)

    return {"notes": notes, "terms": terms, "words": words,
            "changed": copy["changed"], "added": added_line(copy["about"])}


# The files in the order a reader meets them in the download; any other after.
FILE_ORDER = ("bills", "stages", "days_between_stages", "sessions")


def added_line(about):
    """How many lines this copy added, in the agreed words. The first copy
    records no counts at all."""
    when = day(about[0]["date_copy_taken"])
    counted = [a for a in about if a["rows_added_since_last_copy"] is not None]
    if not counted:
        return "This is the first copy of the data."
    added = sorted((a for a in counted if a["rows_added_since_last_copy"] > 0),
                   key=lambda a: (FILE_ORDER.index(a["file"]) if a["file"] in FILE_ORDER
                                  else len(FILE_ORDER), a["file"]))
    if not added:
        return f"Added in the copy of {when}: no lines."
    first, *rest = added
    n = first["rows_added_since_last_copy"]
    parts = [f"{n} line{'' if n == 1 else 's'} to {first['file']}"]
    parts += [f"{a['rows_added_since_last_copy']} to {a['file']}" for a in rest]
    return f"Added in the copy of {when}: {', '.join(parts)}."


# ---- The table of every bill -------------------------------------------------
#
# Strand 2, item 4: docs/STRAND-2-THE-TABLE.md, and the small choices made in
# building it, docs/STRAND-2-ITEM-4-BUILD.md. The narrowing is done here, from
# the page's address, so that a narrowed table can be shared, bookmarked and
# handed over by a chart as an address.

# The seven columns, as the bills file names them, in its order. The others
# are in the opened bill.
COLUMNS = ("bill_number", "session", "title", "bill_type", "date_introduced",
           "outcome", "date_royal_assent")

# The choices a reader can make, in the order the address gives them.
CHOICES = ("session", "type", "outcome", "title")

# Title words are matched on no more than this.
TITLE_LONGEST = 100

# The files in the order What each heading holds gives them: the mock-up's,
# the four data files first. Nothing has settled the download's order yet.
HEADINGS_ORDER = ("bills", "stages", "days_between_stages", "sessions", "methodology_notes",
                  "sources", "what_the_words_mean", "what_changed", "workings", "about",
                  "cited_pages", "terms")

# What may be typed into the title box and survive signing in: the characters
# titles are made of. Anything else in a return address is dropped.
TITLE_SHAPE = re.compile(r"[A-Za-z0-9 '’()&,.:-]{1,100}")


def fold(text):
    """Title words as they are compared: capitals and the curly apostrophe
    set aside."""
    return (text or "").lower().replace("’", "'")


def cell(value):
    """A value as the file holds it: a date as 2018-12-13, an empty cell as
    None."""
    if value is None or value == "":
        return None
    return value.isoformat() if hasattr(value, "isoformat") else str(value)


def choice_lists(copy):
    """What each dropdown offers: the copy's own words, in the copy's order,
    and only those some bill has."""
    def listed(heading, column):
        have = {b[column] for b in copy["bills"]}
        return [w["value"] for w in copy["words"] if w["heading"] == heading and w["value"] in have]
    return {
        "session": [str(x) for x in sorted({b["session"] for b in copy["bills"]})],
        "type": listed("bill_type", "bill_type"),
        "outcome": listed("outcome", "outcome"),
    }


def chosen(args, lists):
    """The reader's choices from the address. A choice not on its list is
    ignored, so the dropdowns, the count and the table always agree."""
    got = {}
    for key in ("session", "type", "outcome"):
        value = args.get(key, "")
        if value in lists[key]:
            got[key] = value
    title = tidy(args.get("title"))[:TITLE_LONGEST].strip()
    if title:
        got["title"] = title
    return got


def address(choices):
    """The page's address for these choices, in the one order."""
    query = urlencode([(k, choices[k]) for k in CHOICES if k in choices], quote_via=quote)
    return "/data" + ("?" + query if query else "")


def narrowed(bills, choices):
    column = {"session": "session", "type": "bill_type", "outcome": "outcome"}
    words = fold(choices.get("title"))
    return [b for b in bills
            if all(str(b[column[k]]) == choices[k] for k in column if k in choices)
            and (not words or words in fold(b["title"]))]


def count_line(shown, total):
    """Part 8's three forms."""
    if not shown:
        return "No bill matches these choices. Clear them to see every bill."
    if shown == total:
        return f"Showing all {total} bills."
    return f"Showing {shown} of {total} bills."


def opened_bills(copy):
    """Everything an opened bill shows, for every bill: its line, heading by
    heading, with the notes that bear on each; its stages; and where each
    fact came from."""
    notes_for = {}
    for n in copy["notes"]:
        for h in (n["applies_to"] or "").split(","):
            if h.strip():
                notes_for.setdefault(h.strip(), []).append(n["note"])

    positions = {(f["file"], f["heading"]): f["position"] for f in copy["files"]}
    bill_headings = sorted((f for f in copy["files"] if f["file"] == "bills"),
                           key=lambda f: f["position"])

    # Beneath a stage's name, what else its line says about it.
    stages = {}
    for st in copy["stages"]:
        asides = [f"{h}: {st[h]}" for h in ("stage_never_happened", "bill_ended_here") if st[h]]
        asides += [st[h] for h in ("why_there_is_no_date", "note") if st[h]]
        stages.setdefault(st["bill_number"], []).append({**st, "asides": asides})
    stage_place = {(st["bill_number"], st["stage"]): st["stage_position"] for st in copy["stages"]}

    cited = {c["address"]: c for c in copy["cited"]}
    facts = {}
    for f in copy["sources"]:
        where = f["where_in_the_source"]
        gone = cited.get(where)
        facts.setdefault(f["bill_number"], []).append({
            **f,
            "gone": gone if gone and gone["address_works"] == "No" else None,
            "order": (0 if f["applies_to_file"] == "bills" else 1,
                      stage_place.get((f["bill_number"], f["stage"]), 0),
                      positions.get((f["applies_to_file"], f["applies_to_heading"]), 0),
                      f["date_source_read"] or datetime.date.min),
        })

    opened = []
    for b in copy["bills"]:
        n = b["bill_number"]
        opened.append({
            "bill": b,
            "fields": [(h["heading"], cell(b[h["heading"]]),
                        notes_for.get(f"bills.{h['heading']}", [])) for h in bill_headings],
            "stages": stages.get(n, []),
            "facts": sorted(facts.get(n, []), key=lambda f: f["order"]),
        })
    return opened


def what_each_heading_holds(copy):
    """Every heading of every file, file by file, with the copy's own
    descriptions."""
    files = {}
    for f in copy["files"]:
        files.setdefault(f["file"], {"file": f["file"], "holds": f["file_holds"], "headings": []})
        files[f["file"]]["headings"].append(f)
    order = {name: i for i, name in enumerate(HEADINGS_ORDER)}
    return sorted(files.values(), key=lambda f: (order.get(f["file"], len(order)), f["file"]))


@app.route("/data")
def data():
    wall = signed_out_to_sign_in()
    if wall:
        return wall
    try:
        copy = published.reference()
    except published.Unreadable:
        return render_template("data_unavailable.html"), 503

    lists = choice_lists(copy)
    choices = chosen(request.args, lists)
    # An address with anything in it that was not used is sent on to the one
    # that says exactly what is shown.
    if request.args and request.args.to_dict(flat=False) != {k: [v] for k, v in choices.items()}:
        return redirect(address(choices), code=302)

    g.copy_date = copy["about"][0]["date_copy_taken"]
    sections = reference_sections(copy)
    # The download box, only when there is a zip made from this copy.
    zipped = download.kept(g.copy_date)
    offer = {"name": download.name_for(g.copy_date), "size": download.size_shown(zipped)} if zipped else None
    shown = narrowed(copy["bills"], choices)
    # The Data page carries the whole dataset, so it credits every set of terms.
    return render_template(
        "data.html", credits=sections["terms"], **sections,
        columns=COLUMNS, lists=lists, choices=choices, shown=shown,
        count=count_line(len(shown), len(copy["bills"])),
        opened=opened_bills(copy), heading_files=what_each_heading_holds(copy),
        cell=cell, offer=offer)


# ---- The zip -------------------------------------------------------------------
#
# Strand 2, item 5: docs/STRAND-2-ITEM-5-BUILD.md. The zip is made once from the
# copy and kept on the machine; the site only reads it, fills in the day it was
# downloaded, and hands it over.

@app.route("/download/<name>")
def zip_download(name):
    if not g.get("signed_in"):
        return redirect(url_for("sign_in", next="/data"), code=302)
    asked = download.NAME.fullmatch(name)
    if not asked:
        abort(404)
    date = copy_date()
    if date is None:
        return render_template("data_unavailable.html"), 503
    if asked.group(1) != date.isoformat():
        # A name kept from an older copy: the current one is on the Data page.
        return redirect(url_for("data"), code=302)
    zipped = download.kept(date)
    if not zipped:
        return render_template("data_unavailable.html"), 503
    return Response(download.handed_over(zipped, download.today()), mimetype="application/zip",
                    headers={"Content-Disposition": f'attachment; filename="{name}"'})


@app.route("/insights")
def insights():
    wall = signed_out_to_sign_in()
    if wall:
        return wall
    # No chart yet, so no data: no date statement and no credit lines.
    return render_template("insights.html")


# ---- Signing in and out ---------------------------------------------------------
#
# Wording and behaviour are docs/wording/SIGN-IN.md, settled by the owner on
# 2026-09-16. A code reaches a person by email, or, for the owner only, from a
# command on the machine; either way it is typed here, so there is no way in
# that only one person can use.

CODE_SHAPE = re.compile(r"^[0-9]{6}$")


# Where signing in may return a reader to: a data page, the section of it a
# link pointed into, and on the Data page the table's narrowing. Nothing else is
# accepted, so a link cannot use signing in to send anyone off this site, or
# anywhere on it but these two pages.
RETURN_SHAPE = re.compile(r"/(data|insights)(\?[^#]*)?(#[A-Za-z0-9_-]{1,60})?")


def return_to(value):
    """The return address if it is one of the allowed shapes, or None. The
    narrowing is rebuilt from what checks out, never copied from what was
    sent: a session is a number, a type, outcome or title the characters
    titles are made of, and any other part of the address is dropped."""
    m = RETURN_SHAPE.fullmatch(value or "")
    if not m:
        return None
    page, query, section = m.groups()
    kept = {}
    if page == "data" and query:
        for key, values in parse_qs(query[1:]).items():
            v = values[0] if len(values) == 1 else ""
            if key == "session" and re.fullmatch(r"[0-9]{1,2}", v):
                kept[key] = v
            elif key in ("type", "outcome", "title") and TITLE_SHAPE.fullmatch(v):
                kept[key] = v
    where = address(kept) if page == "data" else "/insights"
    return where + (section or "")


@app.route("/sign-in", methods=["GET", "POST"])
def sign_in():
    going_to = return_to(request.values.get("next"))
    if request.method == "GET":
        return render_template("sign_in.html", going_to=going_to)

    email = tidy(request.form.get("email")).lower()
    if EMAIL_SHAPE.match(email) and len(email) < 254:
        try:
            made = accounts.new_code(email)
        except accounts.Unavailable:
            return render_template("sign_in_unavailable.html"), 503
        if made is not None:
            code_id, code = made
            if not mail.send_code(email, code):
                accounts.forget_code(code_id)

    # The same page whether a code was sent, the address has no account, it has
    # had its three codes this hour, or the email failed: saying which would
    # tell anyone whether an address has an account. Shown straight from here,
    # not by sending the browser on with the address in the page's address,
    # which would put it in the access log.
    return render_template("sign_in_code.html", email=email, failed=False,
                           going_to=going_to)


@app.route("/sign-in/code", methods=["GET", "POST"])
def sign_in_code():
    going_to = return_to(request.values.get("next"))
    if request.method == "GET":
        return render_template("sign_in_code.html", email="", failed=False,
                               going_to=going_to)

    email = tidy(request.form.get("email")).lower()
    # People copy codes with spaces in them; nothing else is forgiven.
    code = "".join((request.form.get("code") or "").split())

    marker = None
    if EMAIL_SHAPE.match(email) and CODE_SHAPE.match(code):
        try:
            marker = accounts.sign_in(email, code)
        except accounts.Unavailable:
            return render_template("sign_in_unavailable.html"), 503
    if marker is None:
        return render_template("sign_in_code.html", email=email, failed=True,
                               going_to=going_to), 400

    response = redirect(going_to or url_for("welcome"), code=303)
    response.set_cookie(DEVICE_COOKIE, marker, max_age=accounts.DEVICE_DAYS * 24 * 3600,
                        secure=True, httponly=True, samesite="Lax", path="/")
    return response


@app.route("/sign-out", methods=["POST"])
def sign_out():
    try:
        accounts.sign_out(request.cookies.get(DEVICE_COOKIE))
    except accounts.Unavailable:
        return render_template("sign_in_unavailable.html"), 503
    response = redirect(url_for("signed_out"), code=303)
    response.delete_cookie(DEVICE_COOKIE, path="/", secure=True, httponly=True, samesite="Lax")
    return response


@app.route("/signed-out")
def signed_out():
    return render_template("signed_out.html")


# ---- The admin screen -------------------------------------------------------------
#
# The owner's account and no other. Anyone else, signed in or not, is told there
# is no such page. Every change is a form, and the marker cookie is not sent with
# forms from other sites, so no other site can make a change here. Wording and
# behaviour: docs/wording/ADMIN-AND-EMAIL.md, settled by the owner 2026-09-16.

DONE = {
    "approved": "Approved, and emailed.",
    "refused": "Refused, emailed, and deleted.",
    "deleted": "Account deleted.",
    "unsent": "The email could not be sent, so nothing has changed. Try again later.",
}


@app.after_request
def pages_behind_the_sign_in_are_not_kept(response):
    """The admin pages hold other people's details, and the data pages are for
    signed-in readers only: no browser or anything in between is to keep a
    copy, so Back after signing out on a shared computer shows nothing."""
    if request.path.startswith(("/admin", "/download/")) or request.path in DATA_PAGES:
        response.headers["Cache-Control"] = "no-store"
    return response


def owner_only():
    if not (g.get("signed_in") and g.signed_in[1]):
        abort(404)


@app.route("/admin")
def admin():
    owner_only()
    try:
        waiting, approved = accounts.people()
    except accounts.Unavailable:
        return render_template("sign_in_unavailable.html"), 503
    return render_template("admin.html", waiting=waiting, approved=approved,
                          done=DONE.get(request.args.get("done")))


@app.route("/admin/approve/<int:person_id>", methods=["POST"])
def admin_approve(person_id):
    owner_only()
    try:
        someone = accounts.person(person_id, "applied")
        if someone is None:
            return redirect(url_for("admin"), code=303)
        # The email first: if it cannot be sent, nobody is approved untold.
        if not mail.send_approved(someone["email"]):
            return redirect(url_for("admin", done="unsent"), code=303)
        accounts.approve(person_id)
    except accounts.Unavailable:
        return render_template("sign_in_unavailable.html"), 503
    return redirect(url_for("admin", done="approved"), code=303)


@app.route("/admin/refuse/<int:person_id>", methods=["GET", "POST"])
def admin_refuse(person_id):
    owner_only()
    try:
        someone = accounts.person(person_id, "applied")
        if someone is None:
            return redirect(url_for("admin"), code=303)
        if request.method == "GET":
            return render_template("admin_refuse.html", someone=someone)
        # The email first: an application is deleted only once they have been told.
        if not mail.send_refused(someone["email"]):
            return redirect(url_for("admin", done="unsent"), code=303)
        accounts.delete_application(person_id)
    except accounts.Unavailable:
        return render_template("sign_in_unavailable.html"), 503
    return redirect(url_for("admin", done="refused"), code=303)


@app.route("/admin/delete/<int:person_id>", methods=["GET", "POST"])
def admin_delete(person_id):
    owner_only()
    try:
        someone = accounts.person(person_id, "approved")
        if someone is None or someone["is_owner"]:
            abort(404)
        if request.method == "GET":
            return render_template("admin_delete.html", someone=someone)
        accounts.delete_account(person_id)
    except accounts.Unavailable:
        return render_template("sign_in_unavailable.html"), 503
    return redirect(url_for("admin", done="deleted"), code=303)


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=int(os.environ.get("PORT", 8000)), debug=True)
