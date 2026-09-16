#!/usr/bin/env bash
#
# The apply page, checked on the machine against the real accounts database,
# with an invented person who is deleted afterwards. Run as root on the machine:
#
#   sudo bash /tmp/check_apply.sh /srv/site/releases/<release>
#   sudo BREAK=1 bash /tmp/check_apply.sh /srv/site/releases/<release>   # must FAIL at item 1
#
# It starts the release twice, as the site's own login, on ports nothing points
# at: once able to reach the accounts, once pointed at a database that does not
# exist. The live site is not touched.
#
# The accounts hold real people, and it does not mind who else is in them. It
# refuses to start if one of its invented people is already there, looks only at
# them, and deletes exactly them and stops both copies whether it passes or
# fails. Everyone else is fingerprinted before and after (who they are, their
# state, when it was decided), and it passes only if nothing about them changed;
# it prints yes or no, never a row. Someone real applying during the few seconds
# it runs would fail it, which is the safe way round.
# docs/wording/APPLY.md says what the page must do; docs/ACCOUNTS-RUNBOOK.md
# says how it was run.

set -uo pipefail

REL="${1:?say which release, e.g. /srv/site/releases/2026-09-16T12-34-06Z}"
BREAK="${BREAK:-0}"
PRACTICE="practice.person@example.org"
OTHER="other.practice@example.org"
MINE="'$PRACTICE', '$OTHER'"
WORK=/tmp/apply-check
GOOD=8002
BROKEN=8003
n=0; failed=0

sql() { sudo -u postgres psql -X -d accounts -At -c "$1"; }
pass() { n=$((n+1)); echo "PASS $n  $1"; }
fail() { n=$((n+1)); echo "FAIL $n  $1"; failed=1; exit 1; }
expect() { if [ "$2" = "$3" ]; then pass "$1"; else fail "$1 (got '$2', wanted '$3')"; fi; }

# The check's own invented people, and a fingerprint of everyone else.
mine() { sql "select count(*) from person where email in ($MINE)"; }
fingerprint() { sql "select md5(coalesce(string_agg(person_id || ':' || email || ':' || state || ':' || coalesce(decided_at::text, '') || ':' || is_owner, ',' order by person_id), '')) from person where email not in ($MINE)"; }
untouched() { [ "$(fingerprint)" = "$BEFORE" ] && echo yes || echo no; }

cleanup() {
  for port in $GOOD $BROKEN; do
    [ -f "$WORK/$port.pid" ] && kill "$(cat "$WORK/$port.pid")" 2>/dev/null
  done
  sleep 1
  sql "delete from person where email in ($MINE)" >/dev/null
  left=$(mine); others=$(untouched)
  rm -rf "$WORK"
  echo "---"
  echo "cleaned up: both copies stopped, invented people deleted; left: $left; everyone else as they were: $others"
  if [ "$failed" = 0 ] && [ "$left" = 0 ] && [ "$others" = yes ]; then echo "All $n pass"; else echo "NOT PASSED"; fi
}

[ -d "$REL" ] || { echo "Refusing: $REL is not a release on this machine."; exit 2; }
[ "$(mine)" = 0 ] || { echo "Refusing: an invented person from this check is already in the accounts."; exit 2; }
BEFORE=$(fingerprint)

trap cleanup EXIT
failed=1   # until the last item passes
mkdir -p "$WORK" && chown legsite:legsite "$WORK"

start() {  # port, conninfo
  # From inside the release: the site's login cannot read whatever folder this
  # was started from, and gunicorn refuses to start there.
  cd "$REL" && sudo -u legsite env PYTHONDONTWRITEBYTECODE=1 ACCOUNTS_CONNINFO="$2" \
    "$REL/.venv/bin/gunicorn" --chdir "$REL" --bind "127.0.0.1:$1" --workers 1 \
    --pid "$WORK/$1.pid" --error-logfile "$WORK/$1.log" --daemon app:app
}
start $GOOD "dbname=accounts"
start $BROKEN "dbname=accounts_does_not_exist"
sleep 3

G="http://127.0.0.1:$GOOD"
code() { curl -sS -o /dev/null -w '%{http_code}' "$@"; }
post() { curl -sS -o "$WORK/body" -w '%{http_code} %{redirect_url}' -X POST "$@"; }

expect "the form is there"                "$(code $G/apply)" "$([ "$BREAK" = 1 ] && echo 404 || echo 200)"

r=$(post $G/apply --data-urlencode email= --data-urlencode name= --data-urlencode position=)
expect "an empty form is refused"         "$r" "400 "
expect "  and nothing is kept"            "$(mine):$(untouched)" "0:yes"

r=$(post $G/apply --data-urlencode email=not-an-address --data-urlencode name=Pat --data-urlencode position=Invented)
expect "a bad address is refused"         "$r" "400 "
expect "  saying why"                     "$(grep -c "look like an email address" $WORK/body)" 1
expect "  and nothing is kept"            "$(mine):$(untouched)" "0:yes"

r=$(post $G/apply --data-urlencode email=$PRACTICE --data-urlencode name=Pat --data-urlencode position=Invented --data-urlencode homepage=http://spam.example)
expect "the hidden field thanks a bot"    "$r" "303 $G/apply/received"
expect "  and nothing is kept"            "$(mine):$(untouched)" "0:yes"

r=$(post $G/apply --data-urlencode "email=  Practice.Person@Example.ORG " --data-urlencode "name=  Pat   Practice " --data-urlencode title= --data-urlencode "position=An invented position")
expect "a good application is taken"      "$r" "303 $G/apply/received"
expect "  and kept, once"                 "$(mine)" 1
expect "  lower case, tidied, no title, waiting" \
  "$(sql "select count(*) from person where email = '$PRACTICE' and name = 'Pat Practice' and title is null and position = 'An invented position' and state = 'applied' and decided_at is null and not is_owner")" 1
expect "  and nobody else changed"          "$(untouched)" yes

r=$(post $G/apply --data-urlencode email=$PRACTICE --data-urlencode "name=Someone Else" --data-urlencode "position=Something else")
expect "applying again looks the same"    "$r" "303 $G/apply/received"
expect "  and changes nothing"            "$(sql "select count(*) || ':' || bool_and(name = 'Pat Practice') from person where email in ($MINE)")" "1:true"

expect "the received page is there"       "$(code $G/apply/received)" 200
expect "no cookie is set"                 "$(curl -sS -D - -o /dev/null -X POST $G/apply --data-urlencode email=$PRACTICE --data-urlencode name=Pat --data-urlencode position=Invented | grep -ci '^set-cookie')" 0

r=$(post http://127.0.0.1:$BROKEN/apply --data-urlencode email=$OTHER --data-urlencode name=Pat --data-urlencode position=Invented)
expect "no accounts: says so"             "$r" "503 "
expect "  in the settled words"           "$(grep -c "Nothing you entered has been kept." $WORK/body)" 1
expect "  and nothing is kept"            "$(sql "select count(*) from person where email = '$OTHER'"):$(untouched)" "0:yes"

expect "neither log names the applicant" \
  "$(cat $WORK/$GOOD.log $WORK/$BROKEN.log | grep -cE 'Pat|[Pp]ractice|example\.org')" 0

expect "everyone else in the accounts is as they were" "$(untouched)" yes

failed=0
