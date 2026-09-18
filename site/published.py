"""The site's way into the published copy, and nothing else.

The same login as the accounts, `legsite`, over the machine's own socket with
no password. In the published workbook it can read the live copy and nothing
more: not the copy kept as `previous`, not the connector to the working data,
and it cannot change a cell. Every transaction it starts there is read-only.
See db/published/002 and docs/STRAND-2-THE-SITE-READS-THE-COPY.md.

A refresh swaps a new copy in as `live` in one step, so the next page read
after it sees the new copy, with nothing restarted.

One connection per request that needs one, closed when the request ends, as
for the accounts.
"""
import os

import psycopg
from flask import g

CONNINFO = os.environ.get("PUBLISHED_CONNINFO", "dbname=published")


def connection():
    """The copy's connection for this request, opened the first time it is asked for."""
    if "published" not in g:
        g.published = psycopg.connect(CONNINFO, connect_timeout=5, autocommit=True)
    return g.published


def close(exc=None):
    conn = g.pop("published", None)
    if conn is not None:
        conn.close()


def reachable():
    """True if the site can open the live copy and read its about file."""
    try:
        with connection().cursor() as cur:
            cur.execute("SELECT count(*) FROM live.about")
            return cur.fetchone()[0] > 0
    except psycopg.Error:
        return False
