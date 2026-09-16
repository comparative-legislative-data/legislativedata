"""legislativedata.org — the site.

Flask, Jinja, gunicorn behind Caddy. No build step. Settled 2026-09-15.

Phase 1 puts no data on any page, so this app reads no database. When the
published database exists, the data date in the footer comes from it and from
nowhere else; until then the footer says there is no published data, which is
true. See DECISIONS.md, 2026-09-15, "Every page carries the date of the data it
was built from".
"""
import os

from flask import Flask, render_template

app = Flask(__name__)

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
    """What the deploy checks against. Says nothing about the data."""
    return "ok\n", 200, {"Content-Type": "text/plain; charset=utf-8"}


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=int(os.environ.get("PORT", 8000)), debug=True)
