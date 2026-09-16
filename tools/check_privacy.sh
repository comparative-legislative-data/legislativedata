#!/usr/bin/env bash
#
# The privacy page, checked on the machine against a staged release. Run as
# root, in one connection, with the settled wording sent alongside:
#
#   sudo bash check_privacy.sh /srv/site/releases/<release> /tmp/<dir>/PHASE-1-WHAT-IS-HELD.md
#   ... sudo BREAK=1 bash check_privacy.sh ...   # must FAIL at item 2
#
# It starts the release as the site's own login on a port nothing points at, and
# checks:
#   - every block of the settled wording is on the page, and nothing else is;
#   - the Privacy link is in the header of every page, signed in and not;
#   - the apply page points to it;
#   - what the page says about the cookie and codes matches the site's own code;
#   - the page loads nothing from anywhere else.
# BREAK=1 changes one word of the wording ("five weeks" to "four weeks") before
# checking, so the comparison is seen to fail.
#
# To see the header signed in, it adds one invented person at a Resend test
# address, with a device marker of its own, and deletes exactly that person
# afterwards, pass or fail. It does not mind who else is in the accounts, and
# prints counts and yes/no answers only. The live site is not touched.

set -uo pipefail

REL="${1:?say which release}"
WORDING="${2:?give the path to PHASE-1-WHAT-IS-HELD.md}"
BREAK="${BREAK:-0}"
INVENTED="delivered+privacy-check@resend.dev"
WORK=/tmp/privacy-check
PORT=8004
U="http://127.0.0.1:$PORT"
n=0; failed=0

sql() { sudo -u postgres psql -X -d accounts -At -c "$1"; }
pass() { n=$((n+1)); echo "PASS $n  $1"; }
fail() { n=$((n+1)); echo "FAIL $n  $1"; failed=1; exit 1; }
expect() { if [ "$2" = "$3" ]; then pass "$1"; else fail "$1 (got '$2', wanted '$3')"; fi; }

cleanup() {
  [ -f "$WORK/$PORT.pid" ] && kill "$(cat "$WORK/$PORT.pid")" 2>/dev/null
  sleep 1
  sql "delete from person where email = '$INVENTED'" >/dev/null
  left=$(sql "select count(*) from person where email = '$INVENTED'")
  rm -rf "$WORK"
  echo "---"
  echo "cleaned up: the copy stopped, the invented person deleted; left: $left"
  if [ "$failed" = 0 ] && [ "$left" = 0 ]; then echo "All $n pass"; else echo "NOT PASSED"; fi
}

[ -d "$REL" ] || { echo "Refusing: $REL is not a release on this machine."; exit 2; }
[ -f "$WORDING" ] || { echo "Refusing: no wording file at $WORDING."; exit 2; }
[ "$(sql "select count(*) from person where email = '$INVENTED'")" = 0 ] || { echo "Refusing: the invented person is already there."; exit 2; }

trap cleanup EXIT
failed=1
mkdir -p "$WORK" && chown legsite:legsite "$WORK"
cp "$WORDING" "$WORK/wording.md"
[ "$BREAK" = 1 ] && sed -i 's/within five weeks/within four weeks/' "$WORK/wording.md"

cd "$REL" && sudo -u legsite env PYTHONDONTWRITEBYTECODE=1 \
  "$REL/.venv/bin/gunicorn" --chdir "$REL" --bind "127.0.0.1:$PORT" --workers 1 \
  --pid "$WORK/$PORT.pid" --error-logfile "$WORK/$PORT.log" --daemon app:app
cd /
sleep 3

code() { curl -sS -o /dev/null -w '%{http_code}' "$@"; }

expect "the page is there" "$(code $U/privacy)" 200
curl -sS $U/privacy > "$WORK/page.html"

# The wording, block by block: each heading, paragraph and list item in the
# settled file must be on the page, and each on the page must be in the file.
python3 - "$WORK/wording.md" "$WORK/page.html" > "$WORK/compare.txt" <<'PY'
import html, re, sys
doc = open(sys.argv[1]).read()
quoted = doc.split("## The page, in full", 1)[1]
lines = [l[1:].lstrip(" ") if l.startswith(">") else None for l in quoted.splitlines()]
blocks, cur = [], []
for l in lines + [""]:
    if not l:
        if cur: blocks.append(cur); cur = []
    elif l.startswith("- ") and cur:
        blocks.append(cur); cur = [l]
    else:
        cur.append(l)
def norm(t):
    t = re.sub(r"\s+", " ", t).strip()
    return t.lower()
want = []
for b in blocks:
    t = " ".join(x.strip() for x in b)
    t = re.sub(r"^(#+|-) ", "", t)
    t = t.replace("**", "").replace(chr(96), "")
    t = t.replace("[the date it goes live]", "16 September 2026")
    t = t.strip("*")
    if t: want.append(norm(t))
page = open(sys.argv[2]).read()
main = page.split("<main>", 1)[1].split("</main>", 1)[0]
main = re.sub(r"\{#.*?#\}", "", main, flags=re.S)
main = re.sub(r"</?(strong|code|a|em)\b[^>]*>", "", main)
main = re.sub(r"<[^>]+>", "\n", main)
got = [norm(html.unescape(x)) for x in main.split("\n") if x.strip()]
missing = [w for w in want if w not in got]
extra = [g for g in got if g not in want]
print(f"   {len(want) - len(missing)} of {len(want)} blocks of the wording on the page; {len(extra)} on the page not in the wording")
for m in missing: print("   missing: " + m[:90])
for e in extra: print("   extra:   " + e[:90])
print("VERDICT " + ("same" if want and not missing and not extra else "different"))
PY
grep -v '^VERDICT' "$WORK/compare.txt"
expect "the page is the settled wording, no more and no less" "$(sed -n 's/^VERDICT //p' "$WORK/compare.txt")" same

LINK='<a href="/privacy">Privacy</a>'
for path in / /apply /sign-in /sign-in/code /privacy; do
  expect "Privacy in the header of $path, not signed in" "$(curl -sS $U$path | grep -c "$LINK · <a href=\"/sign-in\">Sign in</a>")" 1
done

sql "insert into person (email, name, position, state, decided_at) values ('$INVENTED', 'Pat Privacy', 'An invented position', 'approved', now())" >/dev/null
M=$(python3 -c 'import secrets; print(secrets.token_urlsafe(32))')
sql "insert into signed_in_device (person_id, marker_hash, expires_at) select person_id, encode(sha256('$M'::bytea), 'hex'), now() + interval '1 hour' from person where email = '$INVENTED'" >/dev/null
for path in / /privacy; do
  expect "Privacy in the header of $path, signed in" "$(curl -sS -H "Cookie: signed_in=$M" $U$path | grep -c "$LINK · Signed in as Pat Privacy")" 1
done

expect "the apply page points to it" \
  "$(curl -sS $U/apply | grep -c 'Everything the site holds, and your rights, are on the <a href="/privacy">Privacy</a> page.')" 1

# What the page says, against what the code does.
expect "the cookie's name is the one the site sets" \
  "$(grep -c '^DEVICE_COOKIE = "signed_in"$' $REL/app.py):$(grep -c 'called <code>signed_in</code>' $WORK/page.html)" "1:1"
expect "a device stays signed in 30 days, as the site sets it" \
  "$(grep -c '^DEVICE_DAYS = 30$' $REL/accounts.py):$(grep -c 'max_age=accounts.DEVICE_DAYS' $REL/app.py):$(grep -c 'signed in for 30 days' $WORK/page.html)" "1:1:1"
expect "a code lasts 15 minutes, three an hour, record kept an hour" \
  "$(grep -c "interval '15 minutes'" $REL/accounts.py):$(grep -c '^CODES_AN_HOUR = 3$' $REL/accounts.py):$(grep -c "created_at <= now() - interval '1 hour'" $REL/accounts.py)" "1:1:1"
expect "the page loads nothing from anywhere else" \
  "$(grep -cE '(src|href)="(https?:)?//' $WORK/page.html | tr -d ' '):$(grep -c 'https://ico.org.uk/make-a-complaint/' $WORK/page.html)" "1:1"

expect "the copy's log names nobody" "$(grep -cE 'resend\.dev|Pat Privacy' $WORK/$PORT.log)" 0

failed=0
