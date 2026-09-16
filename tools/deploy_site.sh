#!/usr/bin/env bash
#
# Deploy the site. Run from the Mac, from the top of the repository.
#
#   tools/deploy_site.sh              stage, rehearse, then switch
#   tools/deploy_site.sh --stage-only stage and rehearse, do not switch
#   tools/deploy_site.sh --rollback   put the previous release back
#   tools/deploy_site.sh --releases   list what is on the machine
#
# A deploy is the site's version of a promotion, so it has the same shape:
# put the new thing somewhere harmless, prove it works, and only then switch to
# it. Nothing is switched until the new release has answered on its own port.
# See docs/DEPLOY-RUNBOOK.md.

set -euo pipefail

VPS="$HOME/.claude/legdata-vps"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REHEARSAL_PORT=8001

say() { printf '\n\033[1m%s\033[0m\n' "$*"; }

case "${1:-deploy}" in

--releases)
  $VPS 'ls -1 /srv/site/releases | sort; echo "---"; echo "current -> $(readlink /srv/site/current)"'
  exit 0
  ;;

--rollback)
  say "Rolling back"
  $VPS 'set -e
    cd /srv/site
    cur=$(basename "$(readlink current)")
    # The one immediately before whatever is live now, so that rolling back
    # twice goes back two versions rather than standing still.
    prev=$(ls -1 releases | sort | awk -v c="$cur" "\$0 == c {exit} {p=\$0} END {print p}")
    if [ -z "$prev" ]; then
      echo "$cur is the oldest release on the machine. Nothing to roll back to."
      exit 1
    fi
    echo "current is $cur, going back to $prev"
    sudo ln -sfn "/srv/site/releases/$prev" /srv/site/current
    sudo systemctl restart legislativedata
    sleep 2
    curl -sS -o /dev/null -w "health after rollback: %{http_code}\n" http://127.0.0.1:8000/health
    curl -sS -o /dev/null -w "https apex after rollback: %{http_code}\n" https://legislativedata.org/
    echo "current -> $(readlink /srv/site/current)"'
  exit 0
  ;;

--stage-only) SWITCH=no ;;
deploy)       SWITCH=yes ;;
*) echo "unknown option: $1" >&2; exit 2 ;;
esac

REL="$(date -u +%Y-%m-%dT%H-%M-%SZ)"

say "1. Packaging site/ as release $REL"
TAR="$(mktemp -t legsite).tgz"
COPYFILE_DISABLE=1 tar czf "$TAR" --no-xattrs -C "$ROOT/site" \
  --exclude .venv --exclude __pycache__ --exclude '*.pyc' .
echo "   $(wc -c < "$TAR" | tr -d ' ') bytes"

say "2. Shipping it"
$VPS --scp "$TAR" "/tmp/site-$REL.tgz"
$VPS --scp "$ROOT/deploy/Caddyfile" /tmp/Caddyfile
rm -f "$TAR"

say "3. Unpacking, building its own environment, and rehearsing on port $REHEARSAL_PORT"
$VPS "set -e
  REL='$REL'
  sudo mkdir -p /srv/site/releases/\$REL
  sudo tar xzf /tmp/site-\$REL.tgz -C /srv/site/releases/\$REL
  rm -f /tmp/site-\$REL.tgz

  # Each release carries its own dependencies, so going back to an older one
  # takes its dependencies back with it.
  sudo python3 -m venv /srv/site/releases/\$REL/.venv
  sudo /srv/site/releases/\$REL/.venv/bin/pip install -q --upgrade pip
  sudo /srv/site/releases/\$REL/.venv/bin/pip install -q -r /srv/site/releases/\$REL/requirements.txt
  sudo chown -R legsite:legsite /srv/site/releases/\$REL

  # The rehearsal: start this release on a port nothing is pointed at, ask it
  # for a page, and stop it again. If this fails, nothing has been switched.
  cd /srv/site/releases/\$REL
  sudo -u legsite env PYTHONDONTWRITEBYTECODE=1 \\
    ./.venv/bin/gunicorn --bind 127.0.0.1:$REHEARSAL_PORT --workers 1 \\
    --pid /tmp/rehearse.pid --daemon app:app
  sleep 3
  ok=1
  for path in /health /; do
    code=\$(curl -sS -o /dev/null -w '%{http_code}' http://127.0.0.1:$REHEARSAL_PORT\$path || echo 000)
    echo \"   rehearsal \$path -> \$code\"
    [ \"\$code\" = 200 ] || ok=0
  done
  bytes=\$(curl -sS http://127.0.0.1:$REHEARSAL_PORT/ | wc -c | tr -d ' ')
  echo \"   rehearsal home page: \$bytes bytes\"
  sudo kill \$(cat /tmp/rehearse.pid) 2>/dev/null || true
  sudo rm -f /tmp/rehearse.pid
  [ \$ok = 1 ] || { echo 'REHEARSAL FAILED — nothing switched'; exit 1; }
  echo '   rehearsal passed'"

if [ "$SWITCH" = no ]; then
  say "Staged and rehearsed, not switched. Release $REL"
  echo "Switch it with:  tools/deploy_site.sh   (or leave it; it costs nothing)"
  exit 0
fi

say "4. Switching to $REL and restarting"
$VPS "set -e
  sudo cp /tmp/Caddyfile /etc/caddy/Caddyfile && rm -f /tmp/Caddyfile
  sudo caddy fmt --overwrite /etc/caddy/Caddyfile
  sudo caddy validate --config /etc/caddy/Caddyfile 2>&1 | tail -1
  sudo ln -sfn /srv/site/releases/$REL /srv/site/current
  sudo systemctl restart legislativedata
  sudo systemctl restart caddy
  sleep 2"

say "5. Checking the thing a reader actually gets"
$VPS 'set -e
  curl -sS -o /dev/null -w "   app on this machine:  %{http_code}\n" http://127.0.0.1:8000/health
  curl -sS -o /dev/null -w "   https apex:           %{http_code}\n" https://legislativedata.org/
  curl -sS -o /dev/null -w "   https www (redirect): %{http_code}\n" https://www.legislativedata.org/
  curl -sS -o /dev/null -w "   plain http (redirect):%{http_code}\n" http://legislativedata.org/
  curl -sS -o /dev/null -w "   stylesheet:           %{http_code}\n" https://legislativedata.org/static/css/site.css
  echo "   current -> $(readlink /srv/site/current)"
  echo "   releases kept: $(ls -1 /srv/site/releases | wc -l | tr -d " ")"'

say "Deployed: $REL"
echo "Undo:  tools/deploy_site.sh --rollback"
