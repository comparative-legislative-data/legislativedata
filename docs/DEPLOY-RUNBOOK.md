# Deploy runbook

How to put a change to the site in front of the public, how to check it landed,
and how to put it back if it did not.

A deploy is the site's version of a promotion, and it gets the same treatment.
The shape is the same one the promotion runbook uses: put the new thing
somewhere harmless, prove it works, and only then switch to it. Nothing here
switches anything until the new version has already answered a request.

Read `docs/PROMOTION-RUNBOOK.md` if that shape is not familiar. This file
assumes it.

---

## What is on the machine, and what each piece does

Four things, and it is worth being able to name them.

- **Caddy** is the front door. It is the only thing reachable from the internet.
  It holds the certificate, gets a new one before the old expires without being
  asked, sends plain `http` to `https`, sends `www` to the bare name, serves the
  stylesheet and the fonts itself, and hands everything else to the site.
- **gunicorn** runs the site. It listens only to this machine, on port 8000.
  Nothing outside can reach it; Caddy is the only thing that talks to it.
- **The site** is Flask and Jinja — the pages themselves.
- **systemd** starts gunicorn when the machine boots and restarts it if it dies.

**The site reads one database: the accounts**, since 16 September 2026. It
connects as its own login over the machine's socket, with no password, and that
login cannot open the working database. Phase 1 puts no data on any page, so it
reads nothing about bills; when it does, it reads the published copy and never
the working one. See `docs/ACCOUNTS-RUNBOOK.md`.

## Where things live

    /srv/site/releases/<when>/   one deployed version, with its own dependencies
    /srv/site/current            a pointer at whichever release is live
    /srv/site/switched           every release that has been live, oldest first
    /etc/caddy/Caddyfile         the front door's configuration
    /var/log/caddy/site.log      the access log
    /etc/systemd/system/legislativedata.service

**`current` is a pointer, and that is the whole undo.** `switched` is how the
undo knows where to point it. Going back a version is
moving the pointer and restarting, which takes about two seconds. Each release
carries its own copy of its dependencies, so going back takes those back too.

**Nothing is edited on the machine.** Every file up there came from this
repository and was put there by the deploy script. A change made directly on the
machine is a change nobody else can see, and the next deploy silently undoes it.

## A normal deploy

From the top of the repository:

    tools/deploy_site.sh

It does five things, and prints what it found at each. **Read step 3 before you
read anything else** — that is the rehearsal, and if it fails, nothing has been
switched and the live site is untouched.

1. **Packages** `site/` into one file.
2. **Ships** it, along with the Caddy configuration.
3. **Rehearses.** Unpacks the new version, builds its dependencies, starts it on
   port 8001 which nothing is pointed at, and asks it for the health check and
   the home page. Both must be `200`. Then it stops it again. **A failure here
   stops the deploy with the live site still on the old version**, and deletes
   the failed release so that nothing can later take it for a working one.
   **The health check is `200` only if the site can read the accounts.** A site
   that cannot is one nobody can apply or sign in to, so it does not go live.
4. **Switches.** Checks the Caddy configuration is valid, moves the pointer,
   restarts the site, restarts Caddy.
5. **Checks what a reader actually gets** — over `https`, from outside the app:
   the apex, the `www` redirect, the plain `http` redirect, and the stylesheet.

### What the five lines at step 5 should say

    app on this machine:   200
    https apex:            200
    https www (redirect):  301
    plain http (redirect): 308
    stylesheet:            200

Anything else is a failed deploy even if nothing errored. **A `200` on the apex
and a `404` on the stylesheet** means the pages are up and every one of them is
unstyled — which is the failure most likely to look fine in a terminal and be
obvious to everyone else.

### To rehearse without switching

    tools/deploy_site.sh --stage-only

Stages and rehearses, leaves the live site alone. Costs a few megabytes and
nothing else. Worth doing for any change you are unsure of.

## The undo

    tools/deploy_site.sh --rollback

Moves the pointer to the release that was live before this one, restarts, and
prints the health check and where the pointer now points. Roughly two seconds.

**It reads `/srv/site/switched`, not the list of folders.** Until 16 September
2026 it went to whichever folder sorted before the live one, which could be a
release that was only staged, or failed its rehearsal, and was never live. A
deploy adds to the list when it switches; a rollback does not, so rolling back
twice goes back two versions. If the list is missing, the rollback refuses
rather than guessing.

**Rehearsed on 16 September 2026.** Live was `12-29-55Z`; a staged-only
`12-27-43Z` sat between it and `07-31-17Z` in the folder list. The rollback went
to `07-31-17Z`, the one actually live before, with health and the apex both
`200`. A second rollback refused, nothing having been live before that, and
switched nothing. Then deployed again as `12-34-06Z`, all five checks as above.

**Rolling back past 16 September's 12:29 deploy puts back a site that reads no
database.** Its health check does not ask about the accounts, so a `200` from it
says less than a `200` from anything later.

    tools/deploy_site.sh --releases

Lists what is on the machine, which one is live, and the list of what has been.

**The undo only reaches as far as the releases still on the machine.** They are
not pruned automatically yet; when they are, the rule goes here first.

**What the undo does not cover:** a change to the Caddy configuration is copied
over at step 4 and the rollback does not put the old one back. If a deploy broke
the front door rather than the site, put `deploy/Caddyfile` back to the previous
commit and deploy again.

## When the site is down

In order, stopping when you find it.

    ~/.claude/legdata-vps 'systemctl status legislativedata --no-pager | head -20'
    ~/.claude/legdata-vps 'systemctl status caddy --no-pager | head -20'
    ~/.claude/legdata-vps 'sudo journalctl -u legislativedata -n 40 --no-pager'
    ~/.claude/legdata-vps 'sudo tail -20 /var/log/caddy/site.log'

- **The site is dead but Caddy is alive** — a reader gets a Caddy error page.
  Roll back.
- **Caddy is dead** — a reader gets nothing at all. `systemctl status caddy`
  says why; almost always a bad configuration file, which step 4 is meant to
  catch first.
- **Both alive and it still looks wrong** — it is the pages, not the machinery.
  Roll back, then look.

## What the log records, and what it must never record

`/var/log/caddy/site.log` holds the page, the time, how long it took and the
result. It holds no address, no browser string and no headers. Settled with the
owner on 16 September 2026: this project holds as little about a person as it
can, and an address is data about a person.

**The filter is defined once, globally, at the top of `deploy/Caddyfile`, and
that is not a tidiness point.** It was first written inside the main site's own
block, which looked right and was wrong: the `www` redirect and the plain-`http`
redirect are separate blocks, they were not covered, and within eight seconds of
the ports opening they had logged a real visitor's address to the system journal.
A filter that covers most of the ways in covers none of them.

**Check it after any change to the logging**, by making a request and then
looking for anything address-shaped:

    ~/.claude/legdata-vps 'sudo sed -E "s/\"host\": \"[^\"]*\"//" /var/log/caddy/site.log | grep -cE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"'
    ~/.claude/legdata-vps 'restart=$(systemctl show caddy -p ActiveEnterTimestamp --value); sudo journalctl -u caddy --since "$restart" | grep -c http.log.access'

The first must be `0`. **It leaves out the `host` field on purpose**: that is
the address a request was *aimed at*, and when something asks for this machine by
number rather than by name, it is this machine's own address. On 16 September
2026 the older form of this check counted 25 such lines and nothing else; all 25
were the machine's own address, and none a visitor's. The second must be `0` — anything above zero means access
logging is reaching the journal, which is not filtered.

## The certificate

Caddy gets it from Let's Encrypt and renews it about thirty days before it
expires, without being asked. There is no cron job and nothing to remember.

It needs two things to keep working, and both are ways this can fail silently:

- **`legislativedata.org` must keep pointing at this machine.** Renewal proves
  we control the name by answering a request on it.
- **Port 80 must stay open**, even though every reader is sent to `https`. That
  is the port the renewal check arrives on.

To see when the current one expires:

    ~/.claude/legdata-vps 'echo | openssl s_client -connect legislativedata.org:443 2>/dev/null | openssl x509 -noout -dates'

## Turning the Cloudflare proxy on, if that is ever wanted

Settled 2026-09-16: traffic comes straight to the machine, and Cloudflare holds
the DNS without proxying. What would reopen it is traffic we cannot absorb, or
someone attacking the site. It is one toggle, and these go with it:

1. Set Cloudflare's SSL mode to **Full (strict)** before flipping the toggle.
   Anything less lets the leg from Cloudflare to this machine fall back to
   unencrypted without telling anyone.
2. **Watch the first certificate renewal after the flip.** It works through the
   proxy, but it is the thing most likely to fail quietly.
3. Decide what the caching rule is. This site puts the date of the data on every
   page; a cached page shows a date that has stopped being true, silently, which
   is the one failure the whole transparency claim cannot survive.
4. The access log will show Cloudflare rather than the reader. We record no
   addresses, so nothing is lost — but Cloudflare will hold its own log of who
   visited, which the page saying what is held about a user would then have to
   mention.

## Things deliberately left as they are

- **The strict-transport promise is short — one day.** It tells browsers to
  refuse plain `http` for this name. That promise cannot be withdrawn early: a
  browser that has heard it honours it for the full period whatever we do
  afterwards. A year is the usual setting and a year is what it should end up
  at, but not until the site has been up and correct for long enough that we are
  not making a year-long promise about something a week old. Raising it is one
  line in `deploy/Caddyfile`.
- **Caddy is Debian's package, not Caddy's own.** Debian's is a version or two
  behind. Taking Caddy's own would mean adding a third-party software source to
  the machine, which is a dependency on somebody else and needs asking about.
  Debian's gets security updates through the automatic ones already running, and
  does everything the site needs.
- **Releases are not pruned.** Each is a few tens of megabytes. Worth a rule
  before it is worth a script.
- **Caddy is restarted, not reloaded.** `systemctl reload caddy` cannot work
  here, because reloading is done by talking to Caddy over a local socket and
  that socket is switched off. A restart costs well under a second of the site
  being unavailable and has no other downside at this size. Turning the socket
  back on to save that second would be trading a permanently open control
  channel for nothing anyone can measure.
