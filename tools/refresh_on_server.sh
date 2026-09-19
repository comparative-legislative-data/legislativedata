#!/bin/bash
# refresh_on_server.sh: the refresh's steps on the machine, in order.
#
# Sent in the bundle by tools/refresh_copy.sh and run there, from the folder
# the bundle unpacks into; not run by hand. Strand 2, item 6:
# docs/STRAND-2-ITEM-6-BUILD.md.
#
#   refresh_on_server.sh MODE DATABASE DOWNLOADS [-v name=value ...]
#
# MODE is look (a thrown-away run), save (the refresh), undo-look or undo.
# DATABASE is `published`, or a scratch copy of it for a rehearsal; DOWNLOADS
# is /srv/downloads, or a scratch folder for a rehearsal. Any -v is passed to
# the build, for its planted faults, and makes the run build-only: the copy is
# built, checked and thrown away, and no zip is made.
#
# The refresh, in order:
#   1. the cited addresses checked;
#   2. the new copy built and set aside as `next`, served to nobody;
#   3. its zip made from `next` by the site's own login, and checked;
#   4. (save) the zip put in DOWNLOADS beside the live copy's, which is still
#      the one readers get; then `next` put live, the live copy kept as
#      `previous` (tools/switch_copy.sql);
#   5. (save) the kept zip checked against the live copy, byte for byte;
#   6. (save) zips other than live's and previous's removed.
# If anything fails before 4's switch, `next` and any zip put in DOWNLOADS are
# removed, and readers see nothing change. A thrown-away run stops after 3 and
# removes `next`.
#
# The undo puts `previous` back live (tools/put_back_previous.sql), removes the
# undone copy's zip, and makes the restored copy's zip only if it is missing.

set -euo pipefail
MODE=$1 DB=$2 DOWNLOADS=$3
shift 3
EXTRA="$*"
D=$(pwd)
SITE=${SITE:-/srv/site/current}  # a staged release instead, for a rehearsal
ZIPS=$D/zips
mkdir -p "$ZIPS" && sudo chown legsite "$ZIPS"

db() { sudo -u postgres psql -X -d "$DB" "$@"; }
date_of() {  # the day a copy was taken; nothing if there is no such copy
  if [ "$(db -At -c "SELECT to_regclass('$1.about') IS NOT NULL")" = t ]; then
    db -At -c "SELECT max(date_copy_taken) FROM $1.about"
  fi
}
zip_for() { echo "legislativedata-$1.zip"; }
# The zip program, as the site's own login, reading DATABASE.
as_site() { sudo -u legsite env PUBLISHED_CONNINFO="dbname=$DB" DOWNLOAD_DIR="$DOWNLOADS" \
              bash -c 'cd "$0" && exec .venv/bin/python download.py "$@"' "$SITE" "$@"; }
quiet() { grep -vE '^(CREATE|INSERT|DO|COMMENT|ALTER|GRANT|REVOKE|DROP|SELECT [0-9]|UPDATE|DELETE|IMPORT|BEGIN)'; }
put_in_downloads() {  # a zip made in ZIPS, into DOWNLOADS, never over one already there
  if [ -e "$DOWNLOADS/$1" ]; then echo "Refusing: $DOWNLOADS/$1 is already there."; return 1; fi
  INSTALLED=$1  # the run's own from here, so a failure from the copy on removes it
  sudo install -o root -g root -m 644 "$ZIPS/$1" "$DOWNLOADS/$1"
  cmp "$ZIPS/$1" "$DOWNLOADS/$1"
}

echo "=== Refresh: $MODE, in $DB, zips in $DOWNLOADS"

# ---- The undo ------------------------------------------------------------------------

if [ "$MODE" = undo-look ] || [ "$MODE" = undo ]; then
  UNDONE=$(date_of live) RESTORED=$(date_of previous)
  echo "Live copy $UNDONE; the copy before $RESTORED."
  if [ "$MODE" = undo-look ]; then
    db -v save=false -f tools/put_back_previous.sql 2>&1 | quiet
    echo "Would remove $(zip_for "$UNDONE"); $(zip_for "$RESTORED") is$( [ -e "$DOWNLOADS/$(zip_for "$RESTORED")" ] || echo ' not') there."
    exit 0
  fi
  db -v save=true -f tools/put_back_previous.sql 2>&1 | quiet
  sudo rm -f "$DOWNLOADS/$(zip_for "$UNDONE")"
  echo "Removed $(zip_for "$UNDONE")."
  if [ ! -e "$DOWNLOADS/$(zip_for "$RESTORED")" ]; then
    echo "$(zip_for "$RESTORED") was missing; made again from the copy put back."
    as_site "$ZIPS" live && as_site --check "$ZIPS/$(zip_for "$RESTORED")" live
    put_in_downloads "$(zip_for "$RESTORED")"
  fi
  as_site --check "$DOWNLOADS/$(zip_for "$RESTORED")" live
  echo '=== The zips kept'; ls -l "$DOWNLOADS"
  exit 0
fi

# ---- The refresh ---------------------------------------------------------------------

if [ "$MODE" = save ] && [ "$(date_of live)" = "$(db -At -c 'SELECT current_date')" ]; then
  echo "Refusing: the live copy was taken today. Undo it first (tools/refresh_copy.sh --undo --save)."
  exit 1
fi

echo '=== 1. The cited addresses'
if [ -f addresses.csv ]; then echo 'Using the address check given (rehearsal).'
else python3 tools/check_cited_addresses.py sources/kept-pages.csv addresses.csv | tail -1; fi
grep ',No$' addresses.csv || true

if [ -n "$EXTRA" ]; then
  echo '=== 2. The copy, with planted faults: built, checked and thrown away'
  db -v save=false -v addresses="$D/addresses.csv" $EXTRA -f tools/published_copy.sql 2>&1 | quiet
  exit 0
fi

echo '=== 2. The copy, set aside as next'
# From here, a failure takes away what this run made.
SWITCHED=false INSTALLED=
cleanup() {
  if [ "$SWITCHED" = false ]; then
    db -q -c 'DROP SCHEMA IF EXISTS next CASCADE' >/dev/null 2>&1 || true
    [ -n "$INSTALLED" ] && sudo rm -f "$DOWNLOADS/$INSTALLED"
    echo "Nothing kept: next removed${INSTALLED:+, and $INSTALLED}. Readers see what they saw before."
  fi
}
trap cleanup EXIT
db -v save=true -v addresses="$D/addresses.csv" -f tools/published_copy.sql 2>&1 | quiet
NEW=$(zip_for "$(date_of next)")

echo "=== 3. The zip, made from next and checked"
as_site "$ZIPS" next
if [ -n "${PLANT_ZIP_FAULT:-}" ]; then  # rehearsal only: a zip missing its blanks
  sudo -u legsite python3 - "$ZIPS/$NEW" <<'EOF'
import sys, zipfile
p = sys.argv[1]
with zipfile.ZipFile(p) as z:
    files = [(i, z.read(i)) for i in z.infolist()]
with zipfile.ZipFile(p, "w") as z:
    for i, d in files:
        z.writestr(i, d.replace(b"YYYY-MM-DD", b"2000-01-01") if i.filename.endswith("README.txt") else d)
EOF
  echo "FAULT PLANTED in $NEW: its readme's blanks filled."
fi
as_site --check "$ZIPS/$NEW" next

if [ "$MODE" = look ]; then
  echo '=== Thrown away: a look only. Nothing is live, nothing is in the downloads.'
  exit 0
fi

echo "=== 4. The zip beside the live one, then the copy live"
put_in_downloads "$NEW"
db -v save=true -f tools/switch_copy.sql 2>&1 | quiet
SWITCHED=true

echo "=== 5. The kept zip against the live copy"
if ! as_site --check "$DOWNLOADS/$NEW" live; then
  echo "THE ZIP DOES NOT MATCH THE LIVE COPY. Undo with tools/refresh_copy.sh --undo --save."
  exit 1
fi

echo "=== 6. The zips kept: live's and previous's"
KEEP="$(zip_for "$(date_of live)") $(zip_for "$(date_of previous)")"
for z in "$DOWNLOADS"/legislativedata-*.zip; do
  case " $KEEP " in *" $(basename "$z") "*) ;; *) sudo rm -f "$z"; echo "Removed $(basename "$z")." ;; esac
done
ls -l "$DOWNLOADS"
echo '=== Kept: the copy is live, and its zip is the one readers get.'
