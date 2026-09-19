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


def reference(figure=None):
    """Everything the Data page shows, its table, its reference sections and
    its credit lines, read in one go, so that a refresh landing part way
    through cannot give a page half of one copy and half of the next. In the
    copy's own words; the
    only ordering added here is the order a reader meets them in.

    With a figure, (outcomes_shown, forth_crossing_bill, session, bill_type),
    also the outcomes chart's lines for it, each outcome with its bills, for
    the table to show the bills behind a figure. None for them where the copy
    has no such figures.

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
            lines = None
            if figure:
                cur.execute("SELECT to_regclass('live.outcomes_by_session_and_type') IS NOT NULL")
                if cur.fetchone()[0]:
                    cur.execute("""SELECT outcome, bills, bill_numbers
                                     FROM live.outcomes_by_session_and_type
                                    WHERE outcomes_shown = %s AND forth_crossing_bill = %s
                                      AND session = %s AND bill_type = %s""", figure)
                    lines = [dict(zip(("outcome", "bills", "bill_numbers"), r)) for r in cur.fetchall()]
    except psycopg.Error as e:
        raise Unreadable() from e
    if not about:
        raise Unreadable()
    return {"about": about, "notes": notes, "terms": terms, "words": words,
            "changed": changed, "bills": bills, "stages": stages, "sources": sources,
            "cited": cited, "files": files, "figure_lines": lines}


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


# ---- The Insights page ----------------------------------------------------------
#
# Strand 3, thought 2: docs/STRAND-3-THOUGHT-2.md, and the small choices made in
# building its page, docs/STRAND-3-THOUGHT-2-PAGE-BUILD.md. The page draws what
# the copy worked out, and works nothing out itself.

# The file of the outcomes chart's figures, in the order its working gives
# them: each choice, each session and then all sessions, each type and each
# outcome in the copy's own order, Not passed after Passed and In progress
# last.
OUTCOMES_IN_ORDER = """
    SELECT f.*
      FROM live.outcomes_by_session_and_type f
      LEFT JOIN live.what_the_words_mean ty
        ON ty.value = f.bill_type
       AND ty.heading = CASE WHEN f.forth_crossing_bill = 'Shown as a Hybrid Bill'
                             THEN 'bill_type' ELSE 'bill_type_grouped' END
      LEFT JOIN live.what_the_words_mean o
        ON o.value = f.outcome AND o.heading = 'outcome'
     ORDER BY f.outcomes_shown, f.forth_crossing_bill,
              f.session = 'All sessions', f.session, ty."order",
              CASE f.outcome WHEN 'Not passed' THEN 2 WHEN 'In progress' THEN 9 ELSE o."order" END"""

# The headings of the bills file the outcomes chart counts by. The chart's
# sources are the sources of these, and of every bill's own line.
OUTCOMES_HEADINGS = ("bill_number", "session", "bill_type", "bill_type_grouped",
                     "outcome", "enactment_status")


def insights():
    """Everything the Insights page shows, read in one go as reference() is.
    None where the live copy has no chart's figures yet, so that the page is
    what it was before the charts.

    Raises Unreadable if any of it cannot be read."""
    try:
        conn = connection()
        with conn.transaction(), conn.cursor() as cur:
            cur.execute("SET TRANSACTION ISOLATION LEVEL REPEATABLE READ")
            cur.execute("SELECT to_regclass('live.outcomes_by_session_and_type') IS NOT NULL")
            if not cur.fetchone()[0]:
                return None
            about = _rows(cur, "SELECT * FROM live.about")
            notes = _rows(cur, "SELECT note, title FROM live.methodology_notes "
                               "ORDER BY substring(note FROM 2)::int, note")
            terms = _rows(cur, "SELECT * FROM live.terms")
            words = _rows(cur, 'SELECT * FROM live.what_the_words_mean '
                               'ORDER BY heading, "order", value')
            sessions = _rows(cur, "SELECT * FROM live.sessions ORDER BY session")
            workings = _rows(cur, "SELECT * FROM live.workings "
                                  "WHERE file = 'outcomes_by_session_and_type'")
            outcomes = _rows(cur, OUTCOMES_IN_ORDER)
            cur.execute("""SELECT DISTINCT source FROM live.bills WHERE source IS NOT NULL
                           UNION
                           SELECT DISTINCT source FROM live.sources
                            WHERE applies_to_file = 'bills' AND applies_to_heading = ANY(%s)""",
                        (list(OUTCOMES_HEADINGS),))
            outcome_sources = {r[0] for r in cur.fetchall()}
            cols = _rows(cur, "SELECT a.attname AS heading FROM pg_attribute a "
                              "WHERE a.attrelid = 'live.outcomes_by_session_and_type'::regclass "
                              "AND a.attnum > 0 AND NOT a.attisdropped ORDER BY a.attnum")
    except psycopg.Error as e:
        raise Unreadable() from e
    if not about or len(workings) != 1:
        raise Unreadable()
    return {"about": about, "notes": notes, "terms": terms, "words": words,
            "sessions": sessions, "working": workings[0]["working"], "outcomes": outcomes,
            "outcome_sources": outcome_sources,
            "outcome_headings": [c["heading"] for c in cols]}

