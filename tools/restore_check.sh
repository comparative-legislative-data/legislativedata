#!/bin/bash
# Restores the newest copy of each theme from the storage box, checks what came
# back, then removes every trace of the restore, including on failure. Proves the
# backup can be read back from off the machine, which a job that exits cleanly
# does not prove.
#
# Since 2026-09-16 the backup is separated by theme (deploy/legdata-backup), so
# the bills come from the newest `data` copy and the accounts from the newest
# `accounts` copy, each on its own. The `system` copy is listed, not restored.
#
# Run as root on the machine:  bash restore_check.sh
# Prints counts only. The practice line is true only during a rehearsal that put
# the invented practice person in; otherwise it says false, which is correct.
# See docs/ACCOUNTS-RUNBOOK.md.
set -euo pipefail
set -a; source /root/.legdata-backup.env; set +a
R=/tmp/restore-check
cleanup() {
  runuser -u postgres -- psql -X -q -d postgres -c "DROP DATABASE IF EXISTS accounts_restore_check" -c "DROP DATABASE IF EXISTS legdata_restore_check" || true
  rm -rf "$R"
}
trap cleanup EXIT
rm -rf "$R"
newest() { restic snapshots --tag "$1" --json --latest 1 | python3 -c 'import json,sys; print(json.load(sys.stdin)[-1]["short_id"])'; }
SYS=$(newest system); DATA=$(newest data); ACC=$(newest accounts)
echo "copies restored from the storage box: system $SYS (listed), data $DATA, accounts $ACC"
echo "-- the system copy holds the machine's settings and our scripts:"
restic ls "$SYS" | grep -cE '^/etc/caddy/Caddyfile$|^/usr/local/sbin/legdata-backup$'
restic restore "$DATA" --target "$R/data" --include /srv/legdata/postgres >/dev/null
restic restore "$ACC" --target "$R/accounts" --include /srv/legdata-accounts/postgres >/dev/null
chown -R postgres:postgres "$R"
D="$R/data/srv/legdata/postgres"
A="$R/accounts/srv/legdata-accounts/postgres"
echo "-- data copy:"; ls "$D"
echo "-- accounts copy:"; ls "$A"
echo "-- each copy is only its own theme (both should say 0):"
ls "$D" | grep -c '^accounts\.dump$' || true
ls "$A" | grep -c '^legdata\.dump$' || true
echo "-- the site's login is in the accounts copy's saved logins:"
grep -c 'CREATE ROLE legsite' "$A/globals.sql"
runuser -u postgres -- createdb accounts_restore_check
runuser -u postgres -- createdb legdata_restore_check
runuser -u postgres -- pg_restore --exit-on-error -d accounts_restore_check "$A/accounts.dump"
runuser -u postgres -- pg_restore --exit-on-error -d legdata_restore_check "$D/legdata.dump"
echo "-- accounts, restored: the practice person, and counts"
runuser -u postgres -- psql -X -At -d accounts_restore_check -c "
  SELECT 'practice person present and approved (rehearsal only): ' || (count(*) = 1)
    FROM person WHERE email = 'practice.applicant@example.org' AND state = 'approved' AND NOT is_owner;
  SELECT 'people: ' || count(*) || ', of whom approved ' || count(*) FILTER (WHERE state = 'approved') FROM person;
  SELECT 'site login can still read it: ' || has_table_privilege('legsite', 'person', 'SELECT');
  SELECT 'site login cannot make an owner: ' || NOT has_column_privilege('legsite', 'person', 'is_owner', 'UPDATE');
  SELECT 'descriptions on columns: ' || count(*) FILTER (WHERE col_description(attrelid, attnum) IS NOT NULL) || ' of ' || count(*)
    FROM pg_attribute WHERE attrelid IN ('person'::regclass, 'sign_in_code'::regclass, 'signed_in_device'::regclass) AND attnum > 0 AND NOT attisdropped;"
echo "-- working database, restored:"
runuser -u postgres -- psql -X -At -d legdata_restore_check -c "
  SELECT 'bills ' || (SELECT count(*) FROM bill) || ', stages ' || (SELECT count(*) FROM stage_event)
      || ', provenance ' || (SELECT count(*) FROM field_source) || ', notes ' || (SELECT count(*) FROM methodology_note)
      || ', lines ' || (SELECT count(*) FROM bill_candidate)
      || ', checker ' || (SELECT count(*) FROM v_candidate_problems) || ', gaps ' || (SELECT count(*) FROM v_stage_date_gaps);"
echo "-- manifests in the copies:"
cat "$D/manifest.txt" "$A/manifest.txt"
