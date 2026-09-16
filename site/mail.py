"""Sending the site's emails, through Resend, and nothing else.

Three emails, every word of them settled by the owner on 2026-09-16 in
docs/wording/ADMIN-AND-EMAIL.md: a sign-in code, an approval, a refusal. Plain
text, no tracking, from no-reply@legislativedata.org with replies going to the
address the apply page gives.

The key can only send, and only from legislativedata.org. It is a file on the
machine readable by the site and root, outside the repository and the backup.

Nothing here logs an address, a name or a code. A failure is logged as a
failure and nothing more, so that it can be seen on the machine.
"""
import json
import logging
import os
import urllib.error
import urllib.request

KEY_FILE = os.environ.get("LEGSITE_EMAIL_KEY_FILE", "/var/lib/legislativedata/resend-key")
API = "https://api.resend.com/emails"
FROM = "legislativedata.org <no-reply@legislativedata.org>"
REPLY_TO = "comparativelegislativedata@gmail.com"

log = logging.getLogger("gunicorn.error")


def _key():
    with open(KEY_FILE) as f:
        return f.read().strip()


def key_readable():
    try:
        return _key().startswith("re_")
    except OSError:
        return False


def _send(to, subject, text):
    """True if Resend accepted the email, False otherwise. Never raises."""
    body = json.dumps({"from": FROM, "to": [to], "reply_to": REPLY_TO,
                       "subject": subject, "text": text}).encode()
    try:
        request = urllib.request.Request(API, data=body, method="POST", headers={
            "Authorization": f"Bearer {_key()}",
            "Content-Type": "application/json",
            "User-Agent": "legislativedata.org",
        })
        with urllib.request.urlopen(request, timeout=10) as response:
            if 200 <= response.status < 300:
                return True
            log.warning("email not sent: Resend answered %s", response.status)
    except urllib.error.HTTPError as e:
        log.warning("email not sent: Resend answered %s", e.code)
    except (OSError, ValueError) as e:
        log.warning("email not sent: %s", type(e).__name__)
    return False


def send_code(to, code):
    return _send(to, "Your sign-in code for legislativedata.org", f"""\
Your code is {code}.

Enter it at https://legislativedata.org/sign-in/code. It works once, within 15 minutes.

If you did not ask for this, you can ignore this email. Nobody can sign in without the code.
""")


def send_approved(to):
    return _send(to, "Your application to legislativedata.org has been approved", """\
Your application for an account on legislativedata.org has been approved.

To sign in, go to https://legislativedata.org/sign-in and enter this email address. A code will be sent to it.

Nothing is published on the site yet.
""")


def send_refused(to):
    return _send(to, "Your application to legislativedata.org", """\
Your application for an account on legislativedata.org has not been approved, and it has been deleted from the site.

If you have a question, reply to this email.
""")
