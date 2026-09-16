#!/usr/bin/env bash
#
# The admin screen, and the emails it sends, checked on the machine against the
# real accounts with invented people at Resend's test addresses
# (delivered+...@resend.dev, which accept mail and deliver it nowhere). Run as
# root, in one connection:
#
#   ~/.claude/legdata-vps 'cat > /tmp/check_admin.sh && sudo bash /tmp/check_admin.sh /srv/site/releases/<release>' < tools/check_admin.sh
#   ... sudo BREAK=1 bash /tmp/check_admin.sh ...   # must FAIL at item 1
#
# It starts the release twice as the site's own login, on ports nothing points
# at: once with the real sending key, once with a key Resend will refuse, to see
# that nothing changes when an email cannot be sent. The live site is not
# touched. It signs the owner in on its copies by making a device marker of its
# own, and removes exactly that marker afterwards; the owner may be signed in
# elsewhere. It refuses to start unless the only person in the accounts is the
# owner. It prints counts and yes/no answers only, never the owner's address,
# and deletes the invented people and stops both copies whether it passes or
# fails.

set -uo pipefail

REL="${1:?say which release}"
BREAK="${BREAK:-0}"
A1="delivered+approve@resend.dev"
A2="delivered+refuse@resend.dev"
A3="delivered+unsent@resend.dev"
MEMBER="delivered+member@resend.dev"
WORK=/tmp/admin-check
GOOD=8002
BAD=8003
G="http://127.0.0.1:$GOOD"
B="http://127.0.0.1:$BAD"
n=0; failed=0

sql() { sudo -u postgres psql -X -d accounts -At -c "$1"; }
pass() { n=$((n+1)); echo "PASS $n  $1"; }
fail() { n=$((n+1)); echo "FAIL $n  $1"; failed=1; exit 1; }
expect() { if [ "$2" = "$3" ]; then pass "$1"; else fail "$1 (got '$2', wanted '$3')"; fi; }

others() { sql "select count(*) from person where not is_owner"; }
pid_of() { sql "select person_id from person where email = '$1'"; }
state_of() { sql "select coalesce((select state || ':' || (decided_at is not null) from person where email = '$1'), 'gone')"; }

# A signed-in device for someone, made the way the site makes one. Prints the marker.
device_for() {  # person_id
  local m
  m=$(python3 -c 'import secrets; print(secrets.token_urlsafe(32))')
  sql "insert into signed_in_device (person_id, marker_hash, expires_at) values ($1, encode(sha256('$m'::bytea), 'hex'), now() + interval '1 hour')" >/dev/null
  echo "$m"
}

cleanup() {
  for port in $GOOD $BAD; do [ -f "$WORK/$port.pid" ] && kill "$(cat "$WORK/$port.pid")" 2>/dev/null; done
  sleep 1
  sql "delete from person where email in ('$A1', '$A2', '$A3', '$MEMBER')" >/dev/null
  [ -n "${OWNER_M:-}" ] && sql "delete from signed_in_device where marker_hash = encode(sha256('$OWNER_M'::bytea), 'hex')" >/dev/null
  left="$(others) others, $( [ -n "${OWNER_M:-}" ] && sql "select count(*) from signed_in_device where marker_hash = encode(sha256('$OWNER_M'::bytea), 'hex')" || echo 0) check devices"
  rm -rf "$WORK"
  echo "---"
  echo "cleaned up: both copies stopped, invented people deleted, the check's own sign-in removed; left: $left"
  if [ "$failed" = 0 ] && [ "$left" = "0 others, 0 check devices" ]; then echo "All $n pass"; else echo "NOT PASSED"; fi
}

[ -d "$REL" ] || { echo "Refusing: $REL is not a release on this machine."; exit 2; }
[ "$(others)" = 0 ] || { echo "Refusing: the accounts hold people other than the owner."; exit 2; }
[ "$(sql "select count(*) from person where is_owner")" = 1 ] || { echo "Refusing: there is no owner's account."; exit 2; }

trap cleanup EXIT
failed=1
mkdir -p "$WORK" && chown legsite:legsite "$WORK"
printf 're_not_a_real_key' > "$WORK/bad-key" && chown legsite:legsite "$WORK/bad-key"

start() {  # port, extra env
  cd "$REL" && sudo -u legsite env PYTHONDONTWRITEBYTECODE=1 $2 \
    "$REL/.venv/bin/gunicorn" --chdir "$REL" --bind "127.0.0.1:$1" --workers 1 \
    --pid "$WORK/$1.pid" --error-logfile "$WORK/$1.log" --daemon app:app
  cd /
}
start $GOOD ""
start $BAD "LEGSITE_EMAIL_KEY_FILE=$WORK/bad-key"
sleep 3

OWNER_M=$(device_for "$(sql "select person_id from person where is_owner")")
sql "insert into person (email, name, position, state, decided_at) values ('$MEMBER', 'Mel Member', 'An invented position', 'approved', now())" >/dev/null
MEMBER_M=$(device_for "$(pid_of $MEMBER)")
O="Cookie: signed_in=$OWNER_M"
N="Cookie: signed_in=$MEMBER_M"

for who in "$A1:Ann Approve" "$A2:Rex Refuse" "$A3:Una Unsent"; do
  curl -sS -o /dev/null -X POST $G/apply --data-urlencode "email=${who%%:*}" \
    --data-urlencode "name=${who#*:}" --data-urlencode title=Dr --data-urlencode "position=An invented position"
done

code() { curl -sS -o /dev/null -w '%{http_code}' "$@"; }
post() { curl -sS -o /dev/null -w '%{http_code} %{redirect_url}' -X POST "$@"; }

expect "nobody signed in: no such page"          "$(code $G/admin)" "$([ "$BREAK" = 1 ] && echo 200 || echo 404)"
expect "someone else signed in: no such page"    "$(code -H "$N" $G/admin)" 404
expect "  and no Admin in their top bar"         "$(curl -sS -H "$N" $G/ | grep -c '>Admin</a>')" 0
expect "the owner sees the screen"               "$(code -H "$O" $G/admin)" 200
expect "  and it is not to be kept"              "$(curl -sS -D - -o /dev/null -H "$O" $G/admin | grep -ci '^cache-control: no-store')" 1
curl -sS -H "$O" $G/admin > "$WORK/admin"
expect "  three waiting, with their details"     "$(grep -cE 'Dr (Ann Approve|Rex Refuse|Una Unsent) — An invented position — delivered\+(approve|refuse|unsent)@resend\.dev — applied' $WORK/admin)" 3
expect "  the owner's own account, marked you"   "$(grep -c ' — you</p>' $WORK/admin)" 1

expect "someone else cannot approve"             "$(post -H "$N" $G/admin/approve/$(pid_of $A1)):$(state_of $A1)" "404 :applied:false"
expect "the owner approves"                      "$(post -H "$O" $G/admin/approve/$(pid_of $A1))" "303 $G/admin?done=approved"
expect "  and they are approved, with the date"  "$(state_of $A1)" "approved:true"
expect "  and the screen says so"                "$(curl -sS -H "$O" "$G/admin?done=approved" | grep -c 'Approved, and emailed.')" 1
expect "  and no email failure was logged"       "$(grep -c 'email not sent' $WORK/$GOOD.log)" 0

expect "refusing asks first"                     "$(curl -sS -H "$O" $G/admin/refuse/$(pid_of $A2) | grep -c '<h1>Refuse this application?</h1>'):$(state_of $A2)" "1:applied:false"
expect "the owner refuses"                       "$(post -H "$O" $G/admin/refuse/$(pid_of $A2))" "303 $G/admin?done=refused"
expect "  and the application is gone"           "$(state_of $A2)" "gone"

expect "approving when the email fails"          "$(post -H "$O" $B/admin/approve/$(pid_of $A3))" "303 $B/admin?done=unsent"
expect "  changes nothing"                       "$(state_of $A3)" "applied:false"
expect "refusing when the email fails"           "$(post -H "$O" $B/admin/refuse/$(pid_of $A3))" "303 $B/admin?done=unsent"
expect "  changes nothing"                       "$(state_of $A3)" "applied:false"
expect "  and the screen says so"                "$(curl -sS -H "$O" "$B/admin?done=unsent" | grep -c 'The email could not be sent, so nothing has changed. Try again later.')" 1
expect "  and both failures are logged, naming nobody" "$(grep -c 'email not sent' $WORK/$BAD.log):$(grep -cE 'resend\.dev|Una Unsent' $WORK/$BAD.log)" "2:0"

A1_M=$(device_for "$(pid_of $A1)")
expect "deleting asks first"                     "$(curl -sS -H "$O" $G/admin/delete/$(pid_of $A1) | grep -c '<h1>Delete this account?</h1>')" 1
OWNER_PID=$(sql "select person_id from person where is_owner")
expect "the owner's own account cannot be deleted" "$(code -H "$O" $G/admin/delete/$OWNER_PID):$(post -H "$O" $G/admin/delete/$OWNER_PID):$(sql "select count(*) from person where is_owner")" "404:404 :1"
expect "someone else cannot delete"              "$(post -H "$N" $G/admin/delete/$(pid_of $A1)):$(state_of $A1)" "404 :approved:true"
expect "the owner deletes an account"            "$(post -H "$O" $G/admin/delete/$(pid_of $A1))" "303 $G/admin?done=deleted"
expect "  and it is gone, with its devices"      "$(state_of $A1):$(sql "select count(*) from signed_in_device where marker_hash = encode(sha256('$A1_M'::bytea), 'hex')")" "gone:0"

expect "the logs name nobody"                    "$(cat $WORK/$GOOD.log $WORK/$BAD.log | grep -cE 'resend\.dev|Ann Approve|Rex Refuse|Una Unsent|Mel Member')" 0

failed=0
