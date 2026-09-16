#!/bin/bash
# Restores the newest data snapshot from the storage box into two scratch
# databases, checks what came back, then removes every trace of the restore,
# including on failure. Proves the backup can be read back from off the machine,
# which a job that exits cleanly does not prove.
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
SNAP=$(restic snapshots --tag data --json --latest 1 | python3 -c 'import json,sys; print(json.load(sys.stdin)[-1]["short_id"])')
echo "snapshot restored from the storage box: $SNAP"
restic restore "$SNAP" --target "$R" --include /srv/legdata/postgres >/dev/null
chown -R postgres:postgres "$R"
D="$R/srv/legdata/postgres"
ls "$D"
echo "-- the site's login is in the saved logins:"
grep -c 'CREATE ROLE legsite' "$D/globals.sql"
runuser -u postgres -- createdb accounts_restore_check
runuser -u postgres -- createdb legdata_restore_check
runuser -u postgres -- pg_restore --exit-on-error -d accounts_restore_check "$D/accounts.dump"
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
echo "-- manifest in the snapshot:"
cat "$D/manifest.txt"
