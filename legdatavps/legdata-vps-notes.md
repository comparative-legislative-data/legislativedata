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

## The extraction environment

`/opt/legdata`, owned by `ldadmin`. Added 2026-09-10.

- `/opt/legdata/repo` — a clone of the public GitHub repository. Pull it after
  anything is pushed, or the extractor on the box is running against old code
- `/opt/legdata/venv` — Python 3.13 virtual environment
- `/opt/legdata/requirements.txt` — a copy of `tools/requirements.txt` from the
  repo, so the environment can be rebuilt even if the clone is missing

Debian 13 marks its system Python `EXTERNALLY-MANAGED`, so a virtual environment
is required rather than preferred, and `python3.13-venv` has to be installed
before one can be created.

    cd /opt/legdata
    git -C repo pull --ff-only
    ./venv/bin/python repo/tools/extract_factsheet.py \
        repo/sources/factsheets/<file>.pdf --session N --csv /tmp/out.csv

In `/opt` rather than `/srv` deliberately: this is software that can be rebuilt
from the repository, and `/srv/legdata` is the directory the nightly backup
snapshots whole. A virtual environment there would push several MB of
reconstructible packages into every snapshot forever.

**Why the versions are pinned.** The reconciliation argument rests on the
extractor being deterministic — a factsheet has to produce the same rows every
time, or "the totals match SPICe's own cross-tab" means nothing. A change in how
`pdfminer` walks a ruled table would alter row counts silently. Verified on
2026-09-10: the Session 1 factsheet produced byte-for-byte identical output on
macOS/Python 3.12 and on this box under Debian/Python 3.13.

Before this existed the environment was undocumented, and it disappeared: on
2026-09-10 `pdfplumber` was not installed anywhere on the owner's Mac and
nothing in the repository recorded that the extractor needed it.

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

Two tags: `system` for `/etc`, every run; `data` for `/srv/legdata`, only when
that directory exists. `/srv/legdata` was deleted and its `data` snapshots
forgotten on 2026-09-09.

**Amended 2026-09-10, and this was a real gap rather than a tidy-up.** Between
the 2026-09-09 clearance and this date, nothing backed up the database. The
`data` snapshot was skipped every night because `/srv/legdata` did not exist,
and PostgreSQL's own files in `/var/lib/postgresql` were never in scope for
either tag. The machine was rebuildable from `/etc` and the data was not
recoverable at all — for a project whose stated product is the database.

The script now dumps the database into `/srv/legdata/postgres` before taking the
`data` snapshot, so the existing retention, verification and off-site transport
cover it without any new machinery:

- `legdata.dump` — the database, `pg_dump` custom format
- `globals.sql` — the roles, from `pg_dumpall --globals-only`. Without it a
  restore produces a database whose owner does not exist
- `manifest.txt` — row counts as at the moment of the dump, so a restore can be
  checked against what was really there rather than against an assumption

The dump is written under a temporary name and moved into place only after
`pg_restore --list` has proved it readable, so a half-finished dump cannot
overwrite a good one. Filenames carry no date: restic holds the history, and
dated files would pile up inside a directory that is snapshotted whole.

Previous version of the script kept as `legdata-backup.pre-pgdump.bak`.

**Verified end to end on 2026-09-10**, not merely observed to exit zero: the
snapshot was fetched back from the storage box, restored into a scratch
database, checked for the expected 73 candidates and that day's edits, and the
scratch database dropped.

### Restoring

Everything below runs as root on the VPS.

    set -a; source /root/.legdata-backup.env; set +a
    restic snapshots --tag data                 # pick one
    restic restore <id> --target /tmp/restore
    chown -R postgres:postgres /tmp/restore     # the dumps are root-only

    runuser -u postgres -- psql -f /tmp/restore/srv/legdata/postgres/globals.sql
    runuser -u postgres -- createdb legdata
    runuser -u postgres -- pg_restore -d legdata \
        /tmp/restore/srv/legdata/postgres/legdata.dump

Check the result against `manifest.txt` from the same snapshot before trusting
it, and delete `/tmp/restore` afterwards — it holds the whole database with no
password on it.

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
