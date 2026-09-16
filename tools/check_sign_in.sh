#!/usr/bin/env bash
#
# Signing in and out, checked on the machine against the real accounts, with
# invented people at example.org, and then the owner's own way in. Run as root:
#
#   ~/.claude/legdata-vps 'cat > /tmp/check_sign_in.sh && sudo bash /tmp/check_sign_in.sh /srv/site/releases/<release>' < tools/check_sign_in.sh
#   ... sudo BREAK=1 bash /tmp/check_sign_in.sh ...   # must FAIL at item 7
#
# BREAK=1 sends a code one digit out where the right one belongs, to show the
# check can fail.
#
# It starts the release as the site's own login on a port nothing points at. The
# live site is not touched. It refuses to start unless the only person in the
# accounts is the owner (or nobody) and the owner has no codes and no signed-in
# devices. It prints counts and yes/no answers only: never the owner's address,
# and never a code. It deletes the invented people, and every code and device
# it made for the owner, and stops its copy, whether it passes or fails.

set -uo pipefail

REL="${1:?say which release}"
BREAK="${BREAK:-0}"
P1="practice.signin@example.org"
P2="practice.waiting@example.org"
WORK=/tmp/sign-in-check
PORT=8002
S="http://127.0.0.1:$PORT"
n=0; failed=0

sql() { sudo -u postgres psql -X -d accounts -At -c "$1"; }
pass() { n=$((n+1)); echo "PASS $n  $1"; }
fail() { n=$((n+1)); echo "FAIL $n  $1"; failed=1; exit 1; }
expect() { if [ "$2" = "$3" ]; then pass "$1"; else fail "$1 (got '$2', wanted '$3')"; fi; }

others() { sql "select count(*) from person where not is_owner"; }
owner_codes() { sql "select count(*) from sign_in_code c join person p using (person_id) where p.is_owner"; }
owner_devices() { sql "select count(*) from signed_in_device d join person p using (person_id) where p.is_owner"; }

# A code for an invented person, made the way the site checks it.
make_code() {  # email, code, [expired]
  local pid hash
  pid=$(sql "select person_id from person where email = '$1'")
  hash=$(python3 -c "import hmac,hashlib,sys; k=bytes.fromhex(open('/var/lib/legislativedata/code-key').read().strip()); print(hmac.new(k, f'{sys.argv[1]}:{sys.argv[2]}'.encode(), hashlib.sha256).hexdigest())" "$pid" "$2")
  if [ "${3:-}" = expired ]; then
    sql "insert into sign_in_code (person_id, code_hash, created_at, expires_at) values ($pid, '$hash', now() - interval '20 minutes', now() - interval '5 minutes')" >/dev/null
  else
    sql "insert into sign_in_code (person_id, code_hash, expires_at) values ($pid, '$hash', now() + interval '15 minutes')" >/dev/null
  fi
}

try_code() {  # email, code -> "status location", headers in $WORK/h, body in $WORK/body
  curl -sS -D "$WORK/h" -o "$WORK/body" -w '%{http_code} %{redirect_url}' -X POST "$S/sign-in/code" \
    --data-urlencode "email=$1" --data-urlencode "code=$2"
}
marker() { grep -i '^set-cookie: signed_in=' "$WORK/h" | sed -E 's/^[^=]+=([^;]*).*/\1/' | tr -d '\r'; }
generic() { grep -c "That code didn't work. Codes work once, within 15 minutes, and stop after five wrong tries." "$WORK/body"; }

cleanup() {
  [ -f "$WORK/pid" ] && kill "$(cat "$WORK/pid")" 2>/dev/null
  sleep 1
  sql "delete from person where email in ('$P1', '$P2')" >/dev/null
  sql "delete from sign_in_code where person_id in (select person_id from person where is_owner)" >/dev/null
  sql "delete from signed_in_device where person_id in (select person_id from person where is_owner)" >/dev/null
  left="$(others) others, $(owner_codes) owner codes, $(owner_devices) owner devices"
  rm -rf "$WORK"
  echo "---"
  echo "cleaned up: copy stopped, invented people deleted; left: $left"
  if [ "$failed" = 0 ] && [ "$left" = "0 others, 0 owner codes, 0 owner devices" ]; then echo "All $n pass"; else echo "NOT PASSED"; fi
}

[ -d "$REL" ] || { echo "Refusing: $REL is not a release on this machine."; exit 2; }
[ "$(others)" = 0 ] || { echo "Refusing: the accounts hold people other than the owner."; exit 2; }
[ "$(owner_codes)" = 0 ] && [ "$(owner_devices)" = 0 ] || { echo "Refusing: the owner has a live code or a signed-in device. Sign out first."; exit 2; }

trap cleanup EXIT
failed=1
mkdir -p "$WORK" && chown legsite:legsite "$WORK"

cd "$REL" && sudo -u legsite env PYTHONDONTWRITEBYTECODE=1 \
  "$REL/.venv/bin/gunicorn" --chdir "$REL" --bind "127.0.0.1:$PORT" --workers 1 \
  --pid "$WORK/pid" --error-logfile "$WORK/log" --daemon app:app
cd /
sleep 3

sql "insert into person (email, name, position, state, decided_at) values ('$P1', 'Pat Practice', 'An invented position', 'approved', now())" >/dev/null
sql "insert into person (email, name, position) values ('$P2', 'Wendy Waiting', 'An invented position')" >/dev/null

code() { curl -sS -o /dev/null -w '%{http_code}' "$@"; }

expect "health: accounts and key both readable" "$(code $S/health)" 200
expect "the code page is there"                  "$(code $S/sign-in/code)" 200
expect "the send-me-a-code page is off"          "$(code $S/sign-in)" 404

make_code $P1 314159
expect "a wrong code is refused"                 "$(try_code $P1 314158 | cut -d' ' -f1)" 400
expect "  in the settled words"                  "$(generic)" 1
expect "  and counts as a try"                   "$(sql "select failed_attempts from sign_in_code c join person p using (person_id) where p.email = '$P1'")" 1

if [ "$BREAK" = 1 ]; then right=314150; else right=314159; fi
expect "the right code signs in"                 "$(try_code $P1 $right)" "303 $S/"
M=$(marker)
expect "  with a marker"                         "$([ ${#M} -ge 40 ] && echo yes)" yes
expect "  that scripts can't read, sent only over https, kept from other sites, 30 days" \
  "$(grep -i '^set-cookie: signed_in=' $WORK/h | grep -i 'httponly' | grep -i 'secure' | grep -i 'samesite=lax' | grep -ci 'max-age=2592000')" 1
expect "  and the code is gone"                  "$(sql "select count(*) from sign_in_code c join person p using (person_id) where p.email = '$P1'")" 0
expect "  and one device is kept, as a scramble" "$(sql "select count(*) from signed_in_device d join person p using (person_id) where p.email = '$P1' and d.marker_hash <> '$M'")" 1
expect "the top bar shows who is signed in"      "$(curl -sS -H "Cookie: signed_in=$M" $S/ | grep -c 'Signed in as Pat Practice')" 1

expect "a used code does not work again"         "$(try_code $P1 314159 | cut -d' ' -f1)" 400
expect "a malformed code is refused"             "$(try_code $P1 31x159 | cut -d' ' -f1)" 400
expect "  in the same words"                     "$(generic)" 1
expect "an unknown address is refused"           "$(try_code nobody@example.org 314159 | cut -d' ' -f1)" 400
expect "  in the same words"                     "$(generic)" 1

make_code $P2 271828
expect "someone not yet approved cannot sign in" "$(try_code $P2 271828 | cut -d' ' -f1)" 400
expect "  in the same words"                     "$(generic)" 1

make_code $P1 161803
for i in 1 2 3 4 5; do try_code $P1 000000 >/dev/null; done
expect "after five wrong tries the right code fails" "$(try_code $P1 161803 | cut -d' ' -f1)" 400
expect "  in the same words"                     "$(generic)" 1

make_code $P1 141421 expired
expect "a code past its 15 minutes fails"        "$(try_code $P1 141421 | cut -d' ' -f1)" 400

r=$(curl -sS -D "$WORK/h" -o /dev/null -w '%{http_code} %{redirect_url}' -X POST -H "Cookie: signed_in=$M" $S/sign-out)
expect "signing out"                             "$r" "303 $S/signed-out"
expect "  clears the cookie"                     "$(grep -i '^set-cookie: signed_in=' $WORK/h | grep -ciE 'max-age=0|expires=thu, 01 jan 1970')" 1
expect "  and the device is gone"                "$(sql "select count(*) from signed_in_device d join person p using (person_id) where p.email = '$P1'")" 0
expect "the old marker no longer signs in"       "$(curl -sS -H "Cookie: signed_in=$M" $S/ | grep -c 'Signed in as')" 0
expect "the signed-out page says so"             "$(curl -sS $S/signed-out | grep -c 'You are signed out on this device.')" 1

if [ "$(sql "select count(*) from person where is_owner")" = 1 ]; then
  OE=$(sql "select email from person where is_owner")
  out=$(/usr/local/sbin/legdata-owner-code)
  C=$(printf '%s\n' "$out" | sed -nE 's/^Code: ([0-9]{6})$/\1/p')
  expect "the owner's command makes a code"      "$(owner_codes):${#C}" "1:6"
  out=$(/usr/local/sbin/legdata-owner-code)
  C=$(printf '%s\n' "$out" | sed -nE 's/^Code: ([0-9]{6})$/\1/p')
  expect "  and a second replaces the first"     "$(owner_codes)" 1
  expect "  and it names neither address nor person" "$(printf '%s\n' "$out" | grep -ciF -e "$OE" -e '@')" 0
  expect "the owner's code signs in, on the ordinary page" "$(try_code "$OE" "$C")" "303 $S/"
  OM=$(marker)
  expect "  and the owner is signed in"          "$(owner_devices):$(curl -sS -H "Cookie: signed_in=$OM" $S/ | grep -c 'Signed in as')" "1:1"
  expect "  and signs out"                       "$(curl -sS -o /dev/null -w '%{http_code}' -X POST -H "Cookie: signed_in=$OM" $S/sign-out):$(owner_devices)" "303:0"
  expect "the log names nobody"                  "$(grep -ciE -e 'example\.org' -e 'Practice' -e 'Waiting' $WORK/log):$(grep -ciF "$OE" $WORK/log)" "0:0"
else
  echo "(no owner's account yet: the owner's own way in is not checked)"
  expect "the log names nobody"                  "$(grep -ciE -e 'example\.org' -e 'Practice' -e 'Waiting' $WORK/log)" 0
fi

failed=0
