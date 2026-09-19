#!/bin/bash
# refresh_copy.sh: refresh the published copy and its zip, from this Mac, in one step.
#
# Sends the copy's build, its working, the address checker, the list of kept
# pages and the steps to run to the server in one bundle; there,
# tools/refresh_on_server.sh checks every cited address, takes the copy
# (tools/published_copy.sql) and sets it aside, makes its zip and checks it,
# and only then puts both live (tools/switch_copy.sql). Prints the report.
# Leaves nothing in the server's /tmp. docs/STRAND-1-THE-REFRESH.md, and for
# the zip docs/STRAND-2-ITEM-6-BUILD.md.
#
#   tools/refresh_copy.sh                 a thrown-away run: build, check, make the zip, keep nothing
#   tools/refresh_copy.sh --save          the refresh, at the owner's word
#   tools/refresh_copy.sh --undo          a look at the undo, keeping nothing
#   tools/refresh_copy.sh --undo --save   the undo: the copy before, and its zip, back live
#
# A second refresh on the day of the live copy refuses: undo the first.
#
# For a rehearsal only: --addresses FILE uses an address check already made
# (the CSV check_cited_addresses.py writes) instead of checking again; any
# -v name=value is passed to the build, for its planted faults, and makes the
# run build-only; --database NAME and --downloads DIR stand a scratch copy of
# the published database and a scratch folder in for the real ones; and
# --plant-zip-fault spoils the zip before its check; --site DIR makes the zip
# with a staged release of the site instead of the live one.

set -euo pipefail
cd "$(dirname "$0")/.."

SAVE=false
UNDO=false
ADDRESSES=
EXTRA=
DATABASE=published
DOWNLOADS=/srv/downloads
PLANT=
SITE=
while [ $# -gt 0 ]; do
  case "$1" in
    --save) SAVE=true ;;
    --undo) UNDO=true ;;
    --addresses) ADDRESSES=$2; shift ;;
    -v) EXTRA="$EXTRA -v $2"; shift ;;
    --database) DATABASE=$2; shift ;;
    --downloads) DOWNLOADS=$2; shift ;;
    --plant-zip-fault) PLANT=1 ;;
    --site) SITE=$2; shift ;;
    *) echo "Unknown: $1"; exit 1 ;;
  esac
  shift
done
if [ -n "$EXTRA" ] && [ "$SAVE" = true ]; then
  echo "Refusing: planted faults are for a thrown-away run only."; exit 1
fi
if [ -n "$PLANT$SITE" ] && [ "$DATABASE" = published ]; then
  echo "Refusing: --plant-zip-fault and --site are for a scratch database only."; exit 1
fi
case "$UNDO$SAVE" in
  truetrue) MODE=undo ;; truefalse) MODE=undo-look ;; falsetrue) MODE=save ;; *) MODE=look ;;
esac
CONNECT=~/.claude/legdata-vps
STAMP=refresh-$(date +%Y%m%d-%H%M%S)
BUNDLE=$(mktemp -d)/$STAMP.tgz

FILES="tools/published_copy.sql tools/switch_copy.sql tools/put_back_previous.sql tools/refresh_on_server.sh
       tools/check_cited_addresses.py workings sources/kept-pages.csv"
if [ -n "$ADDRESSES" ]; then
  mkdir -p "$(dirname "$BUNDLE")/given" && cp "$ADDRESSES" "$(dirname "$BUNDLE")/given/addresses.csv"
  COPYFILE_DISABLE=1 tar czf "$BUNDLE" --no-xattrs $FILES -C "$(dirname "$BUNDLE")/given" addresses.csv
else
  COPYFILE_DISABLE=1 tar czf "$BUNDLE" --no-xattrs $FILES
fi

"$CONNECT" --scp "$BUNDLE" "/tmp/$STAMP.tgz"
"$CONNECT" "set -euo pipefail
D=/tmp/$STAMP; trap 'sudo rm -rf \$D /tmp/$STAMP.tgz' EXIT
mkdir -p \$D && tar xzf /tmp/$STAMP.tgz -C \$D && chmod -R a+rX \$D && cd \$D
SITE=$SITE PLANT_ZIP_FAULT=$PLANT bash tools/refresh_on_server.sh $MODE $DATABASE $DOWNLOADS $EXTRA
"
rm -f "$BUNDLE"
