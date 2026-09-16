"""The site's way into the accounts database, and nothing else.

The site runs as the machine account `legsite` and connects as the database
login of the same name, over the machine's own socket, with no password: the
two names matching is the whole of the authentication, so there is no secret to
hold. That login can open the accounts and cannot open the working database.
See docs/ACCOUNTS-RUNBOOK.md.

One connection per request that needs one, closed when the request ends. At
this size that costs a few milliseconds, and it means no connection is ever
held open between visitors. Each read stands alone and each write is its own
transaction, committed when its block ends, so nothing read earlier in a
request can leave a later write waiting to be committed.

Personal data: nothing read through here is logged, and no error message
includes a row.
"""
import hashlib
import hmac
import os
import secrets

import psycopg
from flask import g

# "dbname=accounts" with no host is the machine's own socket, and with no user
# is the login named after the machine account the site runs as.
CONNINFO = os.environ.get("ACCOUNTS_CONNINFO", "dbname=accounts")


def connection():
    """The accounts connection for this request, opened the first time it is asked for."""
    if "accounts" not in g:
        g.accounts = psycopg.connect(CONNINFO, connect_timeout=5, autocommit=True)
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


class Unavailable(Exception):
    """The accounts could not take the write. Carries no detail, on purpose:
    PostgreSQL's own messages can quote the row, and the row is a person."""


def apply(email, name, title, position):
    """Add an application, or do nothing if the address has already applied.

    The caller cannot tell which happened, and neither can the person applying.
    Deciding what to show them from this would let anyone use the form to find
    out whether an address has an account. Settled 2026-09-16.

    Raises Unavailable, with nothing from the database attached, if the write
    fails for any reason.
    """
    try:
        conn = connection()
        with conn.transaction():
            conn.execute(
                "INSERT INTO person (email, name, title, position) "
                "VALUES (%s, %s, %s, %s) ON CONFLICT (email) DO NOTHING",
                (email, name, title, position),
            )
    except psycopg.Error:
        raise Unavailable() from None


# ---- Signing in ---------------------------------------------------------------
#
# Settled by the owner 2026-09-16, docs/PHASE-1-SIGN-IN.md. A code is six digits,
# works once, within 15 minutes, and stops after five wrong tries. It is kept as
# a scramble made with a key held on the machine outside the database, so that
# reading the database does not let anyone work a code out. A signed-in device
# holds a long random marker; the database keeps a scramble of it and nothing
# else about the device.

KEY_FILE = os.environ.get("LEGSITE_CODE_KEY_FILE", "/var/lib/legislativedata/code-key")
CODE_TRIES = 5
DEVICE_DAYS = 30

_key = None


def _code_key():
    global _key
    if _key is None:
        with open(KEY_FILE) as f:
            _key = bytes.fromhex(f.read().strip())
        if len(_key) < 32:
            _key = None
            raise RuntimeError("the code key is too short")
    return _key


def key_readable():
    try:
        _code_key()
        return True
    except (OSError, ValueError, RuntimeError):
        return False


def code_hash(person_id, code):
    """The scramble of a code as it is kept. Tied to the person, so the same six
    digits sent to two people are kept differently. The machine's command for
    the owner's code makes it the same way (deploy/legdata-owner-code)."""
    return hmac.new(_code_key(), f"{person_id}:{code}".encode(), hashlib.sha256).hexdigest()


def marker_hash(marker):
    # The marker is 256 random bits, so a plain scramble is enough: there is
    # nothing to work backwards from.
    return hashlib.sha256(marker.encode()).hexdigest()


def _tidy_up(conn):
    """Codes that have run out or had their five tries, and devices past their
    30 days, go. Done whenever anyone tries a code, rather than on a timer."""
    conn.execute(f"DELETE FROM sign_in_code WHERE expires_at <= now() OR failed_attempts >= {CODE_TRIES}")
    conn.execute("DELETE FROM signed_in_device WHERE expires_at <= now()")


def sign_in(email, code):
    """A new device marker if the code works for that address, otherwise None.

    None says nothing about why: no such address, not approved, wrong code,
    run out, used, or out of tries all look the same to the caller. A wrong
    code counts as a try against every live code that person has.

    Raises Unavailable if the accounts or the key cannot be reached.
    """
    try:
        conn = connection()
        with conn.transaction():
            _tidy_up(conn)
            row = conn.execute(
                "SELECT person_id FROM person WHERE email = %s AND state = 'approved'",
                (email,)).fetchone()
            if row is None:
                return None
            person_id = row[0]
            codes = conn.execute(
                "SELECT sign_in_code_id, code_hash FROM sign_in_code "
                "WHERE person_id = %s AND used_at IS NULL AND expires_at > now() "
                "AND failed_attempts < %s FOR UPDATE",
                (person_id, CODE_TRIES)).fetchall()
            wanted = code_hash(person_id, code)
            match = [cid for cid, h in codes if hmac.compare_digest(h, wanted)]
            if not match:
                conn.execute(
                    "UPDATE sign_in_code SET failed_attempts = failed_attempts + 1 "
                    "WHERE person_id = %s", (person_id,))
                return None
            # Used, so gone. A code that is not there cannot work again.
            conn.execute("DELETE FROM sign_in_code WHERE sign_in_code_id = %s", (match[0],))
            marker = secrets.token_urlsafe(32)
            conn.execute(
                "INSERT INTO signed_in_device (person_id, marker_hash, expires_at) "
                f"VALUES (%s, %s, now() + interval '{DEVICE_DAYS} days')",
                (person_id, marker_hash(marker)))
            return marker
    except (psycopg.Error, OSError, ValueError, RuntimeError):
        raise Unavailable() from None


def signed_in_as(marker):
    """(name, is_owner) for a device that is signed in, or None. Also None if the
    accounts cannot be reached: a page still shows, signed out."""
    if not marker:
        return None
    try:
        row = connection().execute(
            "SELECT p.name, p.is_owner FROM signed_in_device d "
            "JOIN person p USING (person_id) "
            "WHERE d.marker_hash = %s AND d.expires_at > now() AND p.state = 'approved'",
            (marker_hash(marker),)).fetchone()
        return row
    except psycopg.Error:
        return None


def sign_out(marker):
    """This device's marker goes, and nothing else."""
    if not marker:
        return
    try:
        conn = connection()
        with conn.transaction():
            conn.execute("DELETE FROM signed_in_device WHERE marker_hash = %s",
                         (marker_hash(marker),))
    except psycopg.Error:
        raise Unavailable() from None
