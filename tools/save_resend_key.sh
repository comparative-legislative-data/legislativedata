#!/usr/bin/env bash
#
# Asks for the sending-only Resend key, checks it with Resend, and saves it to
# ~/.claude/legdata-resend-send for deploy/install_email_key.sh to put on the
# machine. The key is never shown on screen and never written anywhere else.
#
# Run it in the Terminal app (not inside Claude Code), from the top of the
# repository:
#
#     tools/save_resend_key.sh

set -uo pipefail

DEST="$HOME/.claude/legdata-resend-send"

echo
echo "Paste the new Resend key and press Return."
echo "Nothing will appear as you paste; that is on purpose."
printf "Key: "
IFS= read -rs KEY
echo
KEY="$(printf '%s' "$KEY" | tr -d '[:space:]')"

if [[ ! "$KEY" =~ ^re_[A-Za-z0-9_]+$ ]]; then
  echo
  echo "That doesn't look like a Resend key (they start with re_). Nothing saved."
  echo "Run this again and paste the whole key."
  exit 1
fi

echo "Checking it with Resend..."
# A key that can only send is refused when it asks for anything else. So asking
# for the list of domains tells us which kind of key this is, without sending
# any email.
ANSWER="$(curl -sS -H "Authorization: Bearer $KEY" https://api.resend.com/domains 2>&1)"

if printf '%s' "$ANSWER" | grep -q 'restricted_api_key'; then
  echo "Good: Resend recognises it, and it can only send."
elif printf '%s' "$ANSWER" | grep -q '"data"'; then
  echo
  echo "This key has FULL access. The site should only get one that can only send."
  echo "In Resend, make a new key with 'Sending access' for legislativedata.org,"
  echo "then run this again. Nothing saved."
  exit 1
else
  echo
  echo "Resend didn't accept this key. Check you copied all of it, then run this"
  echo "again. Nothing saved."
  exit 1
fi

if [ -f "$DEST" ]; then
  printf "A saved sending key is already there. Replace it? (y/n) "
  read -r yn
  [ "$yn" = "y" ] || { echo "Left as it was. Nothing saved."; exit 1; }
fi

( umask 077; printf 'RESEND_API_KEY=%s\n' "$KEY" > "$DEST" )
chmod 600 "$DEST"
unset KEY

echo
echo "Saved. Only your user account can read it."
echo "Tell Claude it's done."
