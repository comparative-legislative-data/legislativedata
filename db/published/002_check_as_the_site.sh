#!/bin/bash
# db/published/002_check_as_the_site: what the website's login can and cannot
# do with the published copy, tried as the site itself.
#
# Run on the server as the site's own machine account:
#
#   sudo -u legsite bash 002_check_as_the_site.sh
#
# Each item prints PASS or FAIL, and the script ends with an error if anything
# failed. Nothing is written anywhere: every "cannot" is an attempt that must be
# refused, and each refusal is matched on its reason, so a refusal for some
# other reason does not count as a pass. Reads counts only, never a row.
#
# To prove each "cannot" can fail, 002_plant_faults.sql gives the site each
# permission it must not have; this script must then report FAIL on items 4 to
# 10 and the rehearsal takes the permissions away again.

set -u
[ "$(id -un)" = legsite ] || { echo "Refusing: run this as legsite, not $(id -un)."; exit 2; }

cd /
failed=()
n=0
check() {  # check <item text> <PASS if this is true>
  n=$((n + 1))
  if [ "$2" = yes ]; then echo "PASS $n: $1"; else echo "FAIL $n: $1"; failed+=("$n"); fi
}
q() { psql -X -At -d "$1" -c "$2" 2>&1; }
refused_for() {  # refused_for <reason pattern> <database> <sql>
  local out
  out=$(q "$2" "$3")
  if [ $? -ne 0 ] && grep -q -E "$1" <<<"$out"; then echo yes; else echo no; fi
}

# 1. It can read every file of the live copy.
files=$(q published "SELECT count(*) FROM live.about")
reads=yes
for f in bills stages days_between_stages sessions methodology_notes sources \
         what_the_words_mean what_changed workings terms cited_pages about; do
  q published "SELECT count(*) FROM live.$f" | grep -q -E '^[0-9]+$' || reads=no
done
check "the site reads all twelve files of live" "$([ "$files" = 12 ] && echo $reads || echo no)"

# 2. What it starts there is read-only.
check "every transaction it starts in the copy is read-only" \
  "$([ "$(q published 'SHOW default_transaction_read_only')" = on ] && echo yes || echo no)"

# 3. Asked plainly, a change is refused by the read-only lock.
check "a change to live is refused as read-only" \
  "$(refused_for 'read-only transaction' published "INSERT INTO live.about SELECT * FROM live.about LIMIT 0")"

# 4. Asked for read-write, a change is still refused, by the permission.
check "a change to live is refused on permission, even read-write" \
  "$(refused_for 'permission denied for table' published "BEGIN; SET TRANSACTION READ WRITE; INSERT INTO live.about SELECT * FROM live.about LIMIT 0; ROLLBACK")"

# 5-7. It cannot open the copy kept as previous, the connector's tables, or public.
for s in previous from_working public; do
  check "the site cannot open $s" \
    "$(refused_for "permission denied for schema $s" published "SELECT 1 FROM $s.about LIMIT 0")"
done

# 8. It cannot use the connector, nor see what it logs in with.
check "the site cannot use the connector or see its password" \
  "$([ "$(q published "SELECT has_server_privilege('working', 'USAGE')")" = f ] \
     && [ "$(q published "SELECT count(*) FROM pg_user_mappings WHERE umoptions IS NOT NULL")" = 0 ] \
     && echo yes || echo no)"

# 9. It cannot make anything in the workbook, not even a scratch table.
check "the site cannot make a table in the copy" \
  "$(refused_for 'permission denied to create temporary tables' published "BEGIN; SET TRANSACTION READ WRITE; CREATE TEMP TABLE site_check (x int); ROLLBACK")"

# 10. It cannot open the working database.
check "the site cannot open the working database" \
  "$(refused_for 'permission denied for database' legdata "SELECT 1")"

# 11. It still reads the accounts, as before.
check "the site still reads the accounts" \
  "$([ "$(q accounts 'SELECT count(*) FROM (SELECT 1 FROM person LIMIT 0) x')" = 0 ] && echo yes || echo no)"

if [ ${#failed[@]} -gt 0 ]; then
  echo "FAILED: item(s) ${failed[*]}."
  exit 1
fi
[ "$n" = 11 ] || { echo "FAILED: $n items ran, not 11."; exit 1; }
echo "All 11 pass."
