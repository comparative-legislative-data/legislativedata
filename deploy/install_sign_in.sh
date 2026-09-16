#!/usr/bin/env bash
#
# Puts signing in's two machine-side pieces in place. Run from the Mac, from the
# top of the repository:
#
#     deploy/install_sign_in.sh
#
# 1. The key sign-in codes are scrambled with, at
#    /var/lib/legislativedata/code-key: readable by root and the site, nobody
#    else. Made once and never replaced by this script. Deliberately outside
#    every theme of the backup (system, data, accounts): if it is lost, codes
#    issued in the last 15 minutes stop working and a new one is made.
# 2. The owner's code command, /usr/local/sbin/legdata-owner-code, root only.
#
# Safe to run again. One connection, because of the SSH limit.

set -euo pipefail
VPS="$HOME/.claude/legdata-vps"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

$VPS 'set -e
cat > /tmp/legdata-owner-code
sudo install -d -m 750 -o root -g legsite /var/lib/legislativedata
if sudo test -f /var/lib/legislativedata/code-key; then
  echo "key: already there, left alone"
else
  sudo sh -c "umask 027; head -c 32 /dev/urandom | od -An -tx1 | tr -d \" \\n\" > /var/lib/legislativedata/code-key"
  echo "key: made"
fi
sudo chown root:legsite /var/lib/legislativedata/code-key
sudo chmod 640 /var/lib/legislativedata/code-key
echo "key length (hex characters, must be 64): $(sudo cat /var/lib/legislativedata/code-key | wc -c)"
sudo -u legsite test -r /var/lib/legislativedata/code-key && echo "the site can read it"
sudo -u nobody test -r /var/lib/legislativedata/code-key 2>/dev/null && echo "WRONG: others can read it" || echo "others cannot read it"
sudo install -m 700 -o root -g root /tmp/legdata-owner-code /usr/local/sbin/legdata-owner-code
rm -f /tmp/legdata-owner-code
echo "owner code command: installed"' < "$ROOT/deploy/legdata-owner-code"
