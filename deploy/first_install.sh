#!/usr/bin/env bash
#
# The one-off. Puts the four new things on the machine and opens the two ports.
# Run once, from the Mac, from the top of the repository:
#
#     deploy/first_install.sh
#
# Then:  tools/deploy_site.sh
#
# It is safe to run again: every step checks before it acts. It is in the
# repository rather than being typed at the machine so that what is up there is
# always something that can be read down here.

set -euo pipefail
VPS="$HOME/.claude/legdata-vps"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Shipping the configuration files"
$VPS --scp "$ROOT/deploy/Caddyfile" /tmp/Caddyfile
$VPS --scp "$ROOT/deploy/legislativedata.service" /tmp/legislativedata.service

$VPS 'set -e

echo "== Caddy =="
if ! command -v caddy >/dev/null; then
  sudo DEBIAN_FRONTEND=noninteractive apt-get update -qq
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq caddy
fi
caddy version

echo "== the account the site runs as =="
# It owns nothing but its own files, cannot log in, and is not the account we
# connect with. The site reads no database, so it has no database access.
if ! getent passwd legsite >/dev/null; then
  sudo useradd --system --home-dir /srv/site --shell /usr/sbin/nologin legsite
fi
getent passwd legsite

echo "== where the releases live =="
sudo mkdir -p /srv/site/releases
sudo chown -R legsite:legsite /srv/site
ls -ld /srv/site /srv/site/releases

echo "== the front door =="
sudo cp /tmp/Caddyfile /etc/caddy/Caddyfile && rm -f /tmp/Caddyfile
sudo caddy validate --config /etc/caddy/Caddyfile 2>&1 | tail -2

echo "== what starts the site at boot =="
sudo cp /tmp/legislativedata.service /etc/systemd/system/legislativedata.service
rm -f /tmp/legislativedata.service
sudo systemctl daemon-reload
sudo systemctl enable legislativedata >/dev/null 2>&1
systemctl is-enabled legislativedata

echo "== the two ports =="
# 443 is what readers use. 80 stays open because that is where the certificate
# renewal check arrives, and because a reader who types the bare name arrives
# there and has to be sent on.
sudo ufw allow 80/tcp  comment "http (redirect, and certificate renewal)" >/dev/null
sudo ufw allow 443/tcp comment "https" >/dev/null
sudo ufw status | grep -E "^(80|443|22)/tcp " || sudo ufw status

echo "== restarting the front door =="
sudo systemctl restart caddy
sleep 3
systemctl is-active caddy
'

echo
echo "Installed. The site itself is not deployed yet — run:  tools/deploy_site.sh"
