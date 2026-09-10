# The VPS — access and rebuild notes

Written 2026-09-09, when the legislative-data project was cleared. **Nothing about
that project is in this file.** No passwords or key material here either — only
where things are and what each one does.

## Getting in

- `~/.claude/legdata-vps` — the connector script. Holds the address, port, username
  and key path; nothing else on this Mac knows them. **If this file is lost, access
  to the machine is lost.**
  - `~/.claude/legdata-vps "whoami"` — run a command as `ldadmin`
  - `~/.claude/legdata-vps --root "whoami"` — as root, needs `LD_PW_FILE` set
  - `~/.claude/legdata-vps --scp local/file /remote/path` — no `remote:` prefix
- `~/.ssh/legdata_ed25519` — the key it uses, with its own known-hosts file
  alongside. Login is by key only; passwords are refused.

## The machine

Hetzner VPS, Debian 13, 148 GB disk. One login account, `ldadmin`, with sudo that
needs no password.

**Protection in place:** firewall allowing SSH only and rate-limiting it, `fail2ban`,
automatic security updates, and SSH hardening in
`/etc/ssh/sshd_config.d/60-hardening.conf`.

**Amended 2026-09-10.** `AllowTcpForwarding no` became `AllowTcpForwarding local`
with `PermitOpen 127.0.0.1:5432`, so the database can be reached over an SSH tunnel
and nothing else can. Original saved as `60-hardening.conf.pre-db-tunnel.bak`.
PostgreSQL 17 is installed and listens on loopback only; port 5432 is not open in
the firewall and must not be.

**The SSH rate limit bites you, not only attackers.** About a dozen connections in
quick succession produces `Connection refused` for roughly 15 seconds. Batch work
into few connections rather than one per command.

## The backup

- `/usr/local/sbin/legdata-backup` — the script. Snapshots, prunes, then runs
  `restic check --read-data-subset=5%`
- `/root/.legdata-backup.env` — settings, **including the restic repository
  password. This is the single point of failure: lose it and the backups cannot be
  read, even with the storage box in hand.**
- `/root/.ssh/legdata_backup_ed25519` — the key the server uses to reach the box
- `legdata-backup.service` / `legdata-backup.timer` — nightly, scheduled 02:30 UTC
  with up to 30 minutes of jitter, `Persistent=true` so a missed run catches up

Destination is a **Hetzner Storage Box** over SFTP, sub-account `u546808-sub1`,
using `restic`, 1.0 TB. **This box is shared with other projects** — anything done
to this repository must not touch theirs. Retention: 14 daily, 8 weekly, 12 monthly,
10 yearly, applied with `--group-by host,tags`.

Two tags existed: `system` for `/etc`, every run; `data` for `/srv/legdata`, only
when that directory existed. **`/srv/legdata` is gone and the `data` snapshots were
forgotten on 2026-09-09.** The `system` snapshots remain, so the machine stays
rebuildable.

**One known defect, never fixed.** The service runs with no `HOME` or
`XDG_CACHE_HOME`, so restic keeps no cache and re-reads every file in scope on every
run. Harmless at ~2 MiB of `/etc`.

## State after the 2026-09-09 clearance

`/srv/legdata` deleted. `/opt/legdata` deleted. `data`-tagged snapshots forgotten and
pruned. Machine, access, hardening, backup plumbing and `/etc` snapshots all intact.

## Other infrastructure seen in prior attempts

Recovered 2026-09-09 from local file-history snapshots before those were deleted, and
corrected against `~/.ssh/config` and the owner. **Infrastructure only** — no project
design, schema or code is recorded here.

**The box this file describes is the data box** — `77.90.2.83`, hostname
`legislativedata-SP`, 3 vCPU / 11 GB / 148 GB. The 148 GB matches. The snapshots name
its provider as **HostBRR, not Hetzner**; Hetzner was the *backup* provider (the
Storage Box). Treat "Hetzner VPS" above as an error.

**`5.83.150.18` was never part of this project.** The snapshots show it in a
comparison table, with NovaCloud named as its provider. That table was weighing
candidates against a machine the owner already ran for other work — `~/.ssh/config`
has it as `irelandstats-vps` and `annotatedgames-vps`. **NovaCloud has nothing to do
with this project.** Do not treat that box, or that provider, as this project's to
decommission.

**`107.173.45.55`** — described in the snapshots as an archive box built 2026-08-16,
hardened, empty, 2 TB. `~/.ssh/config` has this address as `passiveincome`, so it is a
machine used for other work too. Unverified whether this project ever really occupied
it; check before assuming either way.

A fourth machine is referred to as having "left this project altogether", with the
owner repurposing it. Not identified further.

**Domains and services:**

- `legislativedata.org` — held by the owner before this project and used by it for
  sending. Not released as far as these snapshots show.
- `mylegislativedata.org` — proposed, then rejected as unsecured. Probably never
  registered; do not assume it is owned.
- `healthchecks.io` — heartbeat monitoring, free tier.
- Resend (`api.resend.com`) — outbound email. An account and API key existed.
- `comparativelegislativedata@gmail.com` — the alerts inbox for the above.

**SSH material for the old estate still exists** in `~/.ssh` (keys named
`legislativedata_*`, matching `known_hosts_legislativedata_*`, and `legislativedata-*`
Host blocks in `~/.ssh/config`). Left in place deliberately: some of those addresses
serve the owner's other projects.
