#!/usr/bin/env bash
#
# Puts the sending-only Resend key on the machine. Run from the Mac, from the
# top of the repository, once the owner has made the key and put it in
# ~/.claude/legdata-resend-send as RESEND_API_KEY=...:
#
#     deploy/install_email_key.sh
#
# The key travels on standard input and is never printed, here or there. It
# goes to /var/lib/legislativedata/resend-key, root:legsite, mode 640, beside the
# code key and like it outside the backup: a lost key is replaced in Resend.
# Replaces a key already there, so rotating one is running this again.
#
# Then checks, inside the live service's own restrictions, that the site can
# reach Resend at all. One connection, because of the SSH limit.

set -euo pipefail
VPS="$HOME/.claude/legdata-vps"
SRC="$HOME/.claude/legdata-resend-send"

[ -f "$SRC" ] || { echo "Refusing: $SRC is not there yet."; exit 2; }
KEY=$(sed -nE 's/^RESEND_API_KEY=(re_[A-Za-z0-9_]+)\s*$/\1/p' "$SRC")
[ -n "$KEY" ] || { echo "Refusing: $SRC does not hold RESEND_API_KEY=re_..."; exit 2; }

printf '%s' "$KEY" | $VPS 'set -e
sudo install -d -m 750 -o root -g legsite /var/lib/legislativedata
sudo sh -c "umask 027; cat > /var/lib/legislativedata/resend-key.new"
sudo chown root:legsite /var/lib/legislativedata/resend-key.new
sudo chmod 640 /var/lib/legislativedata/resend-key.new
sudo mv /var/lib/legislativedata/resend-key.new /var/lib/legislativedata/resend-key
echo "key starts as a Resend key: $(sudo head -c 3 /var/lib/legislativedata/resend-key | grep -c "^re_")"
sudo -u legsite test -r /var/lib/legislativedata/resend-key && echo "the site can read it"
sudo -u nobody test -r /var/lib/legislativedata/resend-key 2>/dev/null && echo "WRONG: others can read it" || echo "others cannot read it"
echo "reaching Resend from inside the live service restrictions:"
sudo systemd-run --quiet --wait --pipe -p User=legsite -p Group=legsite -p NoNewPrivileges=true \
  -p PrivateTmp=true -p PrivateDevices=true -p ProtectSystem=strict -p ProtectHome=true \
  -p RestrictAddressFamilies=AF_INET -p RestrictAddressFamilies=AF_UNIX -p RestrictNamespaces=true \
  -p MemoryDenyWriteExecute=true /usr/bin/python3 -c "
import urllib.request, urllib.error
try:
    urllib.request.urlopen(urllib.request.Request(\"https://api.resend.com/emails\", headers={\"User-Agent\": \"legislativedata.org\"}), timeout=10)
    print(\"  reached\")
except urllib.error.HTTPError as e:
    print(\"  reached (answered\", e.code, \"to a request with no key, as expected)\")
except Exception as e:
    print(\"  NOT reached:\", type(e).__name__, e)
"'
