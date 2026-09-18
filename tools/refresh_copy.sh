#!/bin/bash
# refresh_copy.sh: refresh the published copy, from this Mac, in one step.
#
# Sends the copy's build, its working, the address checker and the list of kept
# pages to the server in one bundle; there, checks every cited address, then
# takes the copy (tools/published_copy.sql), which compares it with the live
# one, lists what changed and keeps the copy before as `previous`. Prints the
# report. Leaves nothing in the server's /tmp. docs/STRAND-1-THE-REFRESH.md.
#
#   tools/refresh_copy.sh           a thrown-away run: build, check, report, keep nothing
#   tools/refresh_copy.sh --save    the refresh, at the owner's word
#
# For a rehearsal only: --addresses FILE uses an address check already made
# (the CSV check_cited_addresses.py writes) instead of checking again, and any
# -v name=value is passed to the build, for its planted faults.
#
# The undo is tools/put_back_previous.sql.

set -euo pipefail
cd "$(dirname "$0")/.."

SAVE=false
ADDRESSES=
EXTRA=
while [ $# -gt 0 ]; do
  case "$1" in
    --save) SAVE=true ;;
    --addresses) ADDRESSES=$2; shift ;;
    -v) EXTRA="$EXTRA -v $2"; shift ;;
    *) echo "Unknown: $1"; exit 1 ;;
  esac
  shift
done
CONNECT=~/.claude/legdata-vps
STAMP=refresh-$(date +%Y%m%d-%H%M%S)
BUNDLE=$(mktemp -d)/$STAMP.tgz

FILES="tools/published_copy.sql tools/check_cited_addresses.py workings sources/kept-pages.csv"
if [ -n "$ADDRESSES" ]; then
  mkdir -p "$(dirname "$BUNDLE")/given" && cp "$ADDRESSES" "$(dirname "$BUNDLE")/given/addresses.csv"
  COPYFILE_DISABLE=1 tar czf "$BUNDLE" --no-xattrs $FILES -C "$(dirname "$BUNDLE")/given" addresses.csv
else
  COPYFILE_DISABLE=1 tar czf "$BUNDLE" --no-xattrs $FILES
fi

"$CONNECT" --scp "$BUNDLE" "/tmp/$STAMP.tgz"
"$CONNECT" "set -euo pipefail
D=/tmp/$STAMP; trap 'rm -rf \$D /tmp/$STAMP.tgz' EXIT
mkdir -p \$D && tar xzf /tmp/$STAMP.tgz -C \$D && chmod -R a+rX \$D && cd \$D
echo '=== The cited addresses'
if [ -f addresses.csv ]; then echo 'Using the address check given (rehearsal).'
else python3 tools/check_cited_addresses.py sources/kept-pages.csv addresses.csv | tail -1; fi
grep ',No\$' addresses.csv || true
echo '=== The copy (save=$SAVE)'
sudo -u postgres psql -X -d published -v save=$SAVE -v addresses=\$D/addresses.csv $EXTRA -f tools/published_copy.sql 2>&1 \
  | grep -vE '^(CREATE|INSERT|DO|COMMENT|ALTER|GRANT|DROP|SELECT [0-9]|UPDATE|DELETE|IMPORT|BEGIN)'
"
rm -f "$BUNDLE"
