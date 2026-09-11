#!/usr/bin/env python3
"""Strip each script's own transaction, so a sequence of migrations and tool
scripts can be dress-rehearsed inside one BEGIN ... ROLLBACK.

Removes lines that are exactly BEGIN; or COMMIT;, and the closing
\\if :save ... \\endif block the tool scripts end with. Refuses to write a file
that would still commit, roll back or read :save, so a stripped copy can never
end the rehearsal's transaction early.

Usage:  python3 tools/strip_for_rehearsal.py OUTDIR FILE [FILE ...]

Each FILE is written to OUTDIR under its own name. Then, in a rehearsal file
run with psql:

    \\set ON_ERROR_STOP on
    \\set session 1
    BEGIN;
    \\i OUTDIR/033_stage_dates_staging_sheet.sql
    \\i OUTDIR/promote_session.sql
    ... look at the result ...
    ROLLBACK;

A script that makes temporary tables can run only once per rehearsal.
See docs/STATE.md, "Dress-rehearsing a sequence of migrations and scripts".
"""
import pathlib, sys


def strip(text):
    out, skipping = [], False
    for line in text.splitlines():
        s = line.strip()
        if s.startswith('\\if :save'):
            skipping = True
            continue
        if skipping:
            if s == '\\endif':
                skipping = False
            continue
        if s in ('BEGIN;', 'COMMIT;'):
            continue
        out.append(line)
    if skipping:
        raise ValueError('an \\if :save block is never closed')
    for line in out:
        s = line.strip()
        if s in ('BEGIN;', 'COMMIT;', 'ROLLBACK;') or ':save' in line:
            raise ValueError(f'still contains: {s}')
    return '\n'.join(out) + '\n'


def main():
    if len(sys.argv) < 3:
        sys.exit(__doc__)
    outdir = pathlib.Path(sys.argv[1])
    outdir.mkdir(parents=True, exist_ok=True)
    for name in sys.argv[2:]:
        src = pathlib.Path(name)
        try:
            text = strip(src.read_text())
        except ValueError as e:
            sys.exit(f'{src}: {e}; nothing written for it')
        (outdir / src.name).write_text(text)
        print(f'{src} -> {outdir / src.name}')


if __name__ == '__main__':
    main()
