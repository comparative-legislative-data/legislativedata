#!/bin/bash
# Rehearses the backup separated by theme (deploy/legdata-backup) before it is
# installed, against a throwaway store in /tmp. Never touches the storage box,
# which other projects share, and never the live dump directories.
#
# Run as root on the machine, with the new script and this one sent together:
#   bash rehearse_backup_themes.sh /path/to/new/legdata-backup
#
# What it proves, each printed PASS or FAIL:
#   A. one run makes three copies, and each holds only its own theme;
#   B. each database copy restores on its own, and its counts match the live ones;
#   C. the five weeks is true, and the bills and system copies are aged exactly
#      as before, using copies back-dated over ten weeks;
#   D. the check in A can fail: a deliberately wrong version, putting the
#      accounts in with the data, is caught;
#   E. the undo works: the currently installed version still runs.
# Prints counts only, never a row. Removes everything it made, including on
# failure. See docs/ACCOUNTS-RUNBOOK.md, "The backup".
set -euo pipefail
NEW=${1:?give the path to the new legdata-backup}
OLD=/usr/local/sbin/legdata-backup
W=/tmp/themes-rehearsal
FAILS=0

cleanup() {
  runuser -u postgres -- psql -X -q -d postgres \
    -c "DROP DATABASE IF EXISTS legdata_themes_check" \
    -c "DROP DATABASE IF EXISTS accounts_themes_check" || true
  rm -rf "$W"
}
trap cleanup EXIT
cleanup
install -d -m 700 "$W"
export XDG_CACHE_HOME="$W/cache"
HOST=$(hostname)

pass() { echo "PASS  $*"; }
fail() { echo "FAIL  $*"; FAILS=$((FAILS+1)); }

# A throwaway store with a throwaway password, and its settings file.
new_store() {
  local name=$1
  { echo "RESTIC_REPOSITORY=$W/$name"; echo "RESTIC_PASSWORD=$(head -c 24 /dev/urandom | base64)"; } > "$W/$name.env"
  chmod 600 "$W/$name.env"
  ( set -a; source "$W/$name.env"; set +a; restic init -q >/dev/null )
}
in_store() { ( set -a; source "$W/$1.env"; set +a; shift; restic "$@" ); }

# A: what the latest copy of each theme holds. Returns non-zero if anything is wrong.
check_themes() {
  local store=$1 bad=0 files
  for t in system data accounts; do
    if [ -z "$(in_store "$store" snapshots --tag "$t" --latest 1 --json | python3 -c 'import json,sys; print(len(json.load(sys.stdin)) or "")')" ]; then
      echo "   no $t copy"; bad=1
    fi
  done
  files=$(in_store "$store" ls latest --tag data 2>/dev/null || true)
  grep -q '/legdata\.dump$'   <<<"$files" || { echo "   data copy lacks the bills"; bad=1; }
  grep -q '/globals\.sql$'    <<<"$files" || { echo "   data copy lacks the logins"; bad=1; }
  grep -q '/accounts\.dump$'  <<<"$files" && { echo "   data copy holds the accounts"; bad=1; }
  files=$(in_store "$store" ls latest --tag accounts 2>/dev/null || true)
  grep -q '/accounts\.dump$'  <<<"$files" || { echo "   accounts copy lacks the accounts"; bad=1; }
  grep -q '/globals\.sql$'    <<<"$files" || { echo "   accounts copy lacks the logins"; bad=1; }
  grep -q '/legdata\.dump$'   <<<"$files" && { echo "   accounts copy holds the bills"; bad=1; }
  files=$(in_store "$store" ls latest --tag system 2>/dev/null || true)
  grep -q '^/etc/caddy/Caddyfile$'              <<<"$files" || { echo "   system copy lacks /etc"; bad=1; }
  grep -q '^/usr/local/sbin/legdata-backup$'    <<<"$files" || { echo "   system copy lacks /usr/local/sbin"; bad=1; }
  grep -q '\.dump$'                             <<<"$files" && { echo "   system copy holds a database"; bad=1; }
  return $bad
}

echo "restic: $(restic version)"
echo

# ---------------------------------------------------------------- A
echo "== A. One run of the new version"
new_store main
LEGDATA_BACKUP_ENV="$W/main.env" LEGDATA_BACKUP_ROOT="$W/root" bash "$NEW" > "$W/run1.log" 2>&1 \
  && pass "the new version ran to the end" || { fail "the new version failed:"; tail -20 "$W/run1.log"; exit 1; }
grep 'legdata-backup:' "$W/run1.log" || true
in_store main snapshots --compact | sed 's/^/   /'
check_themes main && pass "three copies, each holding only its own theme" || fail "the copies are not as they should be"
echo "   data manifest:";     sed 's/^/      /' "$W/root/srv/legdata/postgres/manifest.txt"
echo "   accounts manifest:"; sed 's/^/      /' "$W/root/srv/legdata-accounts/postgres/manifest.txt"
echo

# ---------------------------------------------------------------- B
echo "== B. Each database copy restores on its own"
live_bills=$(runuser -u postgres -- psql -X -At -d legdata -c "SELECT (SELECT count(*) FROM bill)||' '||(SELECT count(*) FROM stage_event)||' '||(SELECT count(*) FROM field_source)||' '||(SELECT count(*) FROM methodology_note)||' '||(SELECT count(*) FROM bill_candidate)")
live_people=$(runuser -u postgres -- psql -X -At -d accounts -c "SELECT count(*)||' '||count(*) FILTER (WHERE state='approved') FROM person")
for t in data accounts; do
  in_store main restore latest --tag "$t" --target "$W/restore-$t" >/dev/null
done
chown -R postgres:postgres "$W/restore-data" "$W/restore-accounts"
chmod 755 "$W"
D="$W/restore-data$W/root/srv/legdata/postgres"
A="$W/restore-accounts$W/root/srv/legdata-accounts/postgres"
grep -q 'CREATE ROLE legdata' "$D/globals.sql" && grep -q 'CREATE ROLE legsite' "$A/globals.sql" \
  && pass "each copy carries the logins" || fail "a copy is missing the logins"
runuser -u postgres -- createdb legdata_themes_check
runuser -u postgres -- pg_restore --exit-on-error -d legdata_themes_check "$D/legdata.dump"
got_bills=$(runuser -u postgres -- psql -X -At -d legdata_themes_check -c "SELECT (SELECT count(*) FROM bill)||' '||(SELECT count(*) FROM stage_event)||' '||(SELECT count(*) FROM field_source)||' '||(SELECT count(*) FROM methodology_note)||' '||(SELECT count(*) FROM bill_candidate)")
echo "   bills, stages, provenance, notes, lines — live: $live_bills; restored: $got_bills"
[ "$live_bills" = "$got_bills" ] && pass "the bills came back whole, from the data copy alone" || fail "the bills did not come back the same"
runuser -u postgres -- createdb accounts_themes_check
runuser -u postgres -- pg_restore --exit-on-error -d accounts_themes_check "$A/accounts.dump"
got_people=$(runuser -u postgres -- psql -X -At -d accounts_themes_check -c "SELECT count(*)||' '||count(*) FILTER (WHERE state='approved') FROM person")
echo "   people, approved — live: $live_people; restored: $got_people"
[ "$live_people" = "$got_people" ] && pass "the accounts came back whole, from the accounts copy alone" || fail "the accounts did not come back the same"
chmod 700 "$W"
rm -rf "$W/restore-data" "$W/restore-accounts"
echo

# ---------------------------------------------------------------- C
echo "== C. Ageing: copies back-dated over ten weeks"
install -d -m 700 "$W/seed"; echo seed > "$W/seed/file"
for d in $(seq 1 70); do
  when=$(date -u -d "-$d days" '+%Y-%m-%d 02:40:00')
  for t in system data accounts; do
    in_store main backup -q --host "$HOST" --tag "$t" --time "$when" "$W/seed" >/dev/null
  done
done
echo "   210 back-dated copies added, one per theme per day"
# What the rule in force today would keep of the system and data copies.
in_store main forget --dry-run --json --group-by host,tags --tag system --tag data \
  --keep-daily 14 --keep-weekly 8 --keep-monthly 12 --keep-yearly 10 2>/dev/null \
  > "$W/predicted.json"

LEGDATA_BACKUP_ENV="$W/main.env" LEGDATA_BACKUP_ROOT="$W/root" bash "$NEW" > "$W/run2.log" 2>&1 \
  && pass "the new version ran again, ageing included" || { fail "the second run failed:"; tail -20 "$W/run2.log"; }
in_store main snapshots --json > "$W/after.json"

python3 - "$W/predicted.json" "$W/after.json" <<'PY' | tee "$W/ageing.txt"
import json, sys, datetime
now = datetime.datetime.now(datetime.timezone.utc)
def age(s):
    t = datetime.datetime.fromisoformat(s["time"][:19]).replace(tzinfo=datetime.timezone.utc)
    return (now - t).total_seconds() / 86400
# Today's copies are left out of the comparison: the second run replaces the
# first as today's copy, which is the rule working, not a change to it.
predicted = {s["id"] for g in json.load(open(sys.argv[1])) for s in g["keep"] if age(s) >= 0.9}
snaps = json.load(open(sys.argv[2]))
acc = [s for s in snaps if s.get("tags") == ["accounts"]]
oldest = max(age(s) for s in acc)
print(f"   accounts copies left: {len(acc)}, the oldest {oldest:.1f} days old")
print(("PASS" if oldest <= 35 else "FAIL") + "  no accounts copy older than five weeks")
print(("PASS" if len(acc) >= 14 else "FAIL") + "  at least the last 14 nights of accounts are kept")
# Every system and data copy that existed before the second run, i.e. all but
# its own two new ones, must be exactly what today's rule would have kept.
before = {s["id"] for s in snaps if s.get("tags") in (["system"], ["data"]) and age(s) >= 0.9}
print(f"   system and data copies older than today: {len(before)} kept; today's rule would keep {len(predicted)}")
print(("PASS" if before == predicted else "FAIL") + "  the bills and the system are aged exactly as before")
PY
FAILS=$((FAILS + $(grep -c '^FAIL' "$W/ageing.txt" || true)))
echo

# ---------------------------------------------------------------- D
echo "== D. The check can fail: accounts put in with the data"
sed 's/^ACCOUNTS_DATABASES="accounts"$/ACCOUNTS_DATABASES=""/' "$NEW" > "$W/broken-backup"
grep -q '^ACCOUNTS_DATABASES=""$' "$W/broken-backup" || { fail "could not make the broken version"; }
new_store broken
LEGDATA_BACKUP_ENV="$W/broken.env" LEGDATA_BACKUP_ROOT="$W/root-broken" bash "$W/broken-backup" > "$W/run-broken.log" 2>&1 || true
if check_themes broken; then fail "the broken version was NOT caught"; else pass "the broken version was caught, by the reasons above"; fi
echo

# ---------------------------------------------------------------- E
echo "== E. The undo: the version installed today still runs"
sed -e "s|^set -a; source /root/.legdata-backup.env; set +a$|set -a; source $W/old.env; set +a|" \
    -e "s|^DATA_DIR=/srv/legdata$|DATA_DIR=$W/root-old/srv/legdata|" "$OLD" > "$W/old-backup"
grep -q "source $W/old.env" "$W/old-backup" && grep -q "^DATA_DIR=$W/root-old" "$W/old-backup" \
  || { fail "could not point the installed version at the throwaway store"; }
new_store old
bash "$W/old-backup" > "$W/run-old.log" 2>&1 && pass "the installed version runs, so putting it back is an undo" \
  || { fail "the installed version failed:"; tail -20 "$W/run-old.log"; }
echo

echo "== $FAILS failed"
[ "$FAILS" -eq 0 ]
