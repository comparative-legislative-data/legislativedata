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


class Unreadable(Exception):
    """The copy could not be read. A data page says so, and draws nothing else."""


def date_copy_taken():
    """The day the live copy was taken, for the footer of every page; None if it
    cannot be read, so that a page which shows no data still draws."""
    try:
        with connection().cursor() as cur:
            cur.execute("SELECT max(date_copy_taken) FROM live.about")
            return cur.fetchone()[0]
    except psycopg.Error:
        return None


def _rows(cur, sql):
    cur.execute(sql)
    names = [c.name for c in cur.description]
    return [dict(zip(names, row)) for row in cur.fetchall()]


def reference():
    """Everything the Data page shows, its table, its reference sections and
    its credit lines, read in one go, so that a refresh landing part way
    through cannot give a page half of one copy and half of the next. In the
    copy's own words; the
    only ordering added here is the order a reader meets them in.

    Raises Unreadable if any of it cannot be read."""
    try:
        conn = connection()
        with conn.transaction(), conn.cursor() as cur:
            cur.execute("SET TRANSACTION ISOLATION LEVEL REPEATABLE READ")
            about = _rows(cur, "SELECT * FROM live.about")
            notes = _rows(cur, "SELECT * FROM live.methodology_notes "
                               "ORDER BY substring(note FROM 2)::int, note")
            terms = _rows(cur, "SELECT * FROM live.terms")
            words = _rows(cur, 'SELECT * FROM live.what_the_words_mean '
                               'ORDER BY heading, "order", value')
            changed = _rows(cur, "SELECT * FROM live.what_changed "
                                 "ORDER BY date_copy_taken DESC, file, bill_number, "
                                 "stage, which_line, heading")
            bills = _rows(cur, "SELECT * FROM live.bills ORDER BY bill_number")
            stages = _rows(cur, "SELECT * FROM live.stages "
                                "ORDER BY bill_number, stage_position, stage")
            sources = _rows(cur, "SELECT * FROM live.sources WHERE bill_number IS NOT NULL")
            cited = _rows(cur, "SELECT * FROM live.cited_pages")
            files = _rows(cur, FILES_AND_HEADINGS)
    except psycopg.Error as e:
        raise Unreadable() from e
    if not about:
        raise Unreadable()
    return {"about": about, "notes": notes, "terms": terms, "words": words,
            "changed": changed, "bills": bills, "stages": stages, "sources": sources,
            "cited": cited, "files": files}


# Every heading of every file in the copy, in the file's own order, with the
# description the copy stores on it; and each file's own description. The same
# descriptions the download's codebook is made from.
FILES_AND_HEADINGS = """
    SELECT c.relname AS file, obj_description(c.oid, 'pg_class') AS file_holds,
           a.attnum AS position, a.attname AS heading,
           col_description(c.oid, a.attnum) AS what_it_holds
      FROM pg_class c
      JOIN pg_namespace n ON n.oid = c.relnamespace
      JOIN pg_attribute a ON a.attrelid = c.oid AND a.attnum > 0 AND NOT a.attisdropped
     WHERE n.nspname = 'live' AND c.relkind IN ('r', 'v')
     ORDER BY c.relname, a.attnum"""
