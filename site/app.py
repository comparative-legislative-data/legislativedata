"""legislativedata.org — the site.

Flask, Jinja, gunicorn behind Caddy. No build step. Settled 2026-09-15.

It reads the accounts database (from 2026-09-16) and no other. Phase 1 puts no
data on any page, so it reads nothing about bills. When the published database
exists, the data date in the footer comes from it and from nowhere else; until
then the footer says there is no published data, which is true. See
DECISIONS.md, 2026-09-15, "Every page carries the date of the data it was built
from".
"""
import os
import re

from flask import Flask, abort, g, redirect, render_template, request, url_for

import accounts

app = Flask(__name__)
app.teardown_appcontext(accounts.close)

# Nothing the site takes in is anywhere near this. A form is a few hundred bytes.
app.config["MAX_CONTENT_LENGTH"] = 16 * 1024

SITE_NAME = "legislativedata.org"

# One place. When the published database exists this is read from it per
# request, and this constant goes. Nothing else in the site knows the date.
NO_DATA_YET = "No data published yet"

# The apply page is built and tested but stays off on the live site until the
# owner has an admin screen to see applications on. Settled 2026-09-16. Only
# the machine turns it on; when the admin screen is live this switch is taken
# out, not flipped.
APPLY_OPEN = os.environ.get("LEGSITE_APPLY_OPEN") == "1"

# The page that emails a code. Built with the rest of signing in, but off until
# the site can send email, which is its own step. Settled 2026-09-16.
SEND_CODES_OPEN = os.environ.get("LEGSITE_SEND_CODES_OPEN") == "1"

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


@app.context_processor
def shell():
    """Everything base.html needs, so no page has to pass it."""
    return {
        "site_name": SITE_NAME,
        "data_date_line": NO_DATA_YET,
        "apply_open": APPLY_OPEN,
        "signed_in_name": g.signed_in[0] if g.get("signed_in") else None,
    }


@app.route("/")
def welcome():
    return render_template("welcome.html")


@app.route("/health")
def health():
    """What the deploy checks against.

    Healthy means the site is running, can read the accounts, and can read the
    key codes are scrambled with, because without any of those nobody can apply
    or sign in. Says nothing about the data or about anyone in the accounts.
    """
    if not accounts.reachable():
        return "accounts unreachable\n", 503, {"Content-Type": "text/plain; charset=utf-8"}
    if not accounts.key_readable():
        return "code key unreadable\n", 503, {"Content-Type": "text/plain; charset=utf-8"}
    return "ok\n", 200, {"Content-Type": "text/plain; charset=utf-8"}


# ---- Applying for an account ------------------------------------------------
#
# Wording, behaviour and limits are docs/PHASE-1-APPLY.md, settled by the owner
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
    if not APPLY_OPEN:
        abort(404)
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
    if not APPLY_OPEN:
        abort(404)
    return render_template("apply_received.html")


# ---- Signing in and out ---------------------------------------------------------
#
# Wording and behaviour are docs/PHASE-1-SIGN-IN.md, settled by the owner on
# 2026-09-16. A code reaches a person by email, or, for the owner only, from a
# command on the machine; either way it is typed here, so there is no way in
# that only one person can use.

CODE_SHAPE = re.compile(r"^[0-9]{6}$")


@app.route("/sign-in")
def sign_in():
    if not SEND_CODES_OPEN:
        abort(404)
    return render_template("sign_in.html")


@app.route("/sign-in/code", methods=["GET", "POST"])
def sign_in_code():
    if request.method == "GET":
        return render_template("sign_in_code.html", email="", failed=False)

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
        return render_template("sign_in_code.html", email=email, failed=True), 400

    response = redirect(url_for("welcome"), code=303)
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


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=int(os.environ.get("PORT", 8000)), debug=True)
