#!/usr/bin/env bash
#
# The apply page, checked on the machine against the real accounts database,
# with an invented person who is deleted afterwards. Run as root on the machine:
#
#   sudo bash /tmp/check_apply.sh /srv/site/releases/<release>
#   sudo OPEN=0 bash /tmp/check_apply.sh /srv/site/releases/<release>   # must FAIL
#
# It starts the release twice, as the site's own login, on ports nothing points
# at: once able to reach the accounts, once pointed at a database that does not
# exist. The live site is not touched.
#
# The accounts hold real people. This refuses to start unless nobody but the
# owner is in them, prints counts and yes/no answers about the invented person only, and
# deletes that person and stops both copies whether it passes or fails.
# docs/PHASE-1-APPLY.md says what the page must do; docs/ACCOUNTS-RUNBOOK.md
# says how it was run.

set -uo pipefail

REL="${1:?say which release, e.g. /srv/site/releases/2026-09-16T12-34-06Z}"
OPEN="${OPEN:-1}"
PRACTICE="practice.person@example.org"
WORK=/tmp/apply-check
GOOD=8002
BROKEN=8003
n=0; failed=0

sql() { sudo -u postgres psql -X -d accounts -At -c "$1"; }
pass() { n=$((n+1)); echo "PASS $n  $1"; }
fail() { n=$((n+1)); echo "FAIL $n  $1"; failed=1; exit 1; }
expect() { if [ "$2" = "$3" ]; then pass "$1"; else fail "$1 (got '$2', wanted '$3')"; fi; }

# People other than the owner. The owner's account is left alone throughout.
people() { sql "select count(*) from person where not is_owner"; }

cleanup() {
  for port in $GOOD $BROKEN; do
    [ -f "$WORK/$port.pid" ] && kill "$(cat "$WORK/$port.pid")" 2>/dev/null
  done
  sleep 1
  sql "delete from person where email in ('$PRACTICE', 'other.practice@example.org')" >/dev/null
  left=$(people)
  rm -rf "$WORK"
  echo "---"
  echo "cleaned up: both copies stopped, practice person deleted, people left: $left"
  if [ "$failed" = 0 ] && [ "$left" = 0 ]; then echo "All $n pass"; else echo "NOT PASSED"; fi
}

[ -d "$REL" ] || { echo "Refusing: $REL is not a release on this machine."; exit 2; }
before=$(people)
[ "$before" = 0 ] || { echo "Refusing: the accounts hold $before people besides the owner. This check runs only when there are none."; exit 2; }

trap cleanup EXIT
failed=1   # until the last item passes
mkdir -p "$WORK" && chown legsite:legsite "$WORK"

start() {  # port, conninfo
  # From inside the release: the site's login cannot read whatever folder this
  # was started from, and gunicorn refuses to start there.
  cd "$REL" && sudo -u legsite env PYTHONDONTWRITEBYTECODE=1 LEGSITE_APPLY_OPEN="$OPEN" ACCOUNTS_CONNINFO="$2" \
    "$REL/.venv/bin/gunicorn" --chdir "$REL" --bind "127.0.0.1:$1" --workers 1 \
    --pid "$WORK/$1.pid" --error-logfile "$WORK/$1.log" --daemon app:app
}
start $GOOD "dbname=accounts"
start $BROKEN "dbname=accounts_does_not_exist"
sleep 3

G="http://127.0.0.1:$GOOD"
code() { curl -sS -o /dev/null -w '%{http_code}' "$@"; }
post() { curl -sS -o "$WORK/body" -w '%{http_code} %{redirect_url}' -X POST "$@"; }

expect "the form is there"                "$(code $G/apply)" 200

r=$(post $G/apply --data-urlencode email= --data-urlencode name= --data-urlencode position=)
expect "an empty form is refused"         "$r" "400 "
expect "  and nothing is kept"            "$(people)" 0

r=$(post $G/apply --data-urlencode email=not-an-address --data-urlencode name=Pat --data-urlencode position=Invented)
expect "a bad address is refused"         "$r" "400 "
expect "  saying why"                     "$(grep -c "look like an email address" $WORK/body)" 1
expect "  and nothing is kept"            "$(people)" 0

r=$(post $G/apply --data-urlencode email=$PRACTICE --data-urlencode name=Pat --data-urlencode position=Invented --data-urlencode homepage=http://spam.example)
expect "the hidden field thanks a bot"    "$r" "303 $G/apply/received"
expect "  and nothing is kept"            "$(people)" 0

r=$(post $G/apply --data-urlencode "email=  Practice.Person@Example.ORG " --data-urlencode "name=  Pat   Practice " --data-urlencode title= --data-urlencode "position=An invented position")
expect "a good application is taken"      "$r" "303 $G/apply/received"
expect "  and kept, once"                 "$(people)" 1
expect "  lower case, tidied, no title, waiting" \
  "$(sql "select count(*) from person where email = '$PRACTICE' and name = 'Pat Practice' and title is null and position = 'An invented position' and state = 'applied' and decided_at is null and not is_owner")" 1

r=$(post $G/apply --data-urlencode email=$PRACTICE --data-urlencode "name=Someone Else" --data-urlencode "position=Something else")
expect "applying again looks the same"    "$r" "303 $G/apply/received"
expect "  and changes nothing"            "$(sql "select count(*) || ':' || bool_and(name = 'Pat Practice') from person where not is_owner")" "1:true"

expect "the received page is there"       "$(code $G/apply/received)" 200
expect "no cookie is set"                 "$(curl -sS -D - -o /dev/null -X POST $G/apply --data-urlencode email=$PRACTICE --data-urlencode name=Pat --data-urlencode position=Invented | grep -ci '^set-cookie')" 0

r=$(post http://127.0.0.1:$BROKEN/apply --data-urlencode email=other.practice@example.org --data-urlencode name=Pat --data-urlencode position=Invented)
expect "no accounts: says so"             "$r" "503 "
expect "  in the settled words"           "$(grep -c "Nothing you entered has been kept." $WORK/body)" 1
expect "  and nothing is kept"            "$(sql "select count(*) from person where email = 'other.practice@example.org'")" 0

expect "neither log names the applicant" \
  "$(cat $WORK/$GOOD.log $WORK/$BROKEN.log | grep -cE 'Pat|[Pp]ractice|example\.org')" 0

expect "the live site's apply page is off" "$(code http://127.0.0.1:8000/apply)" 404

failed=0
