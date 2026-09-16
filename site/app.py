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

from flask import Flask, render_template

import accounts

app = Flask(__name__)
app.teardown_appcontext(accounts.close)

SITE_NAME = "legislativedata.org"

# One place. When the published database exists this is read from it per
# request, and this constant goes. Nothing else in the site knows the date.
NO_DATA_YET = "No data published yet"


@app.context_processor
def shell():
    """Everything base.html needs, so no page has to pass it."""
    return {
        "site_name": SITE_NAME,
        "data_date_line": NO_DATA_YET,
    }


@app.route("/")
def welcome():
    return render_template("welcome.html")


@app.route("/health")
def health():
    """What the deploy checks against.

    Healthy means the site is running and can read the accounts, because a site
    that cannot is one nobody can apply to or sign in to. Says nothing about the
    data or about anyone in the accounts.
    """
    if not accounts.reachable():
        return "accounts unreachable\n", 503, {"Content-Type": "text/plain; charset=utf-8"}
    return "ok\n", 200, {"Content-Type": "text/plain; charset=utf-8"}


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=int(os.environ.get("PORT", 8000)), debug=True)
