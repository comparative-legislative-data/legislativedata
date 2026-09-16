"""The site's way into the accounts database, and nothing else.

The site runs as the machine account `legsite` and connects as the database
login of the same name, over the machine's own socket, with no password: the
two names matching is the whole of the authentication, so there is no secret to
hold. That login can open the accounts and cannot open the working database.
See docs/ACCOUNTS-RUNBOOK.md.

One connection per request that needs one, closed when the request ends. At
this size that costs a few milliseconds, and it means no connection is ever
held open between visitors.

Personal data: nothing read through here is logged, and no error message
includes a row.
"""
import os

import psycopg
from flask import g

# "dbname=accounts" with no host is the machine's own socket, and with no user
# is the login named after the machine account the site runs as.
CONNINFO = os.environ.get("ACCOUNTS_CONNINFO", "dbname=accounts")


def connection():
    """The accounts connection for this request, opened the first time it is asked for."""
    if "accounts" not in g:
        g.accounts = psycopg.connect(CONNINFO, connect_timeout=5)
    return g.accounts


def close(exc=None):
    conn = g.pop("accounts", None)
    if conn is not None:
        conn.close()


def reachable():
    """True if the site can open the accounts and read the person tab.

    Asks for no row at all, so it proves the permission without reading
    anything about anybody.
    """
    try:
        with connection().cursor() as cur:
            cur.execute("SELECT 1 FROM person LIMIT 0")
        return True
    except psycopg.Error:
        return False
