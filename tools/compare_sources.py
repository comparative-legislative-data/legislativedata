#!/usr/bin/env python3
"""Compare a session's staging lines against every other source that states the
same dates, and write down every difference before the session is reviewed.

Sessions 1 and 2 taught why this exists. Thirteen dates disagreed between the
SPICe factsheet and the owner's PhD dataset; the owner checked each against the
source that owns it, and the factsheet was wrong five times. That list of
thirteen was made by hand. From here it is made every time a session is loaded,
or the next disagreement is simply not noticed.

What it compares: the two dates a bill's own line holds, introduction and Royal
Assent. Stage dates are not compared here. The stage-dates sheet already holds
one row per source and the error checker already requires two rows for the same
stage to agree, which is the same gate by another route (DECISIONS.md,
2026-09-11). Using it for Stage 3 would mean loading the dataset's Stage 3
dates, which that entry deliberately excluded; that is the owner's to change.

What it writes, as SQL to be read before it is run:

  - every matched line stamped with the date its sources were compared, which
    the error checker requires before a line can be accepted (db/044);
  - on a line whose sources disagree, one
        Differs: <column> = <value> (<source>)
    in the review note, saying what the other source gives. The error checker
    then requires a matching "Checked: <column> = ..." citation before the
    session can be promoted, so a difference cannot be passed over in silence.

Nothing is written for a line with no row in the other source: it is reported,
and the stamp is still applied, because comparing against every source there is
and finding only one is a real comparison.

Usage:  python3 tools/compare_sources.py --session 3 --sql out.sql
"""
import argparse, csv, datetime, hashlib, pathlib, subprocess, sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from phd_stage_dates import tidy, TYPES, MANUAL_PAIRS, DEFAULT_XLSX, CONNECT

COMPARED_ON = datetime.date.today().isoformat()


def staging_lines(session):
    """The session's lines, with the two dates that live on the line itself."""
    query = ("\\copy (SELECT c.candidate_id, c.session_number, c.short_title, "
             "coalesce(c.title_as_introduced, ''), c.bill_type, c.date_introduced, "
             "c.date_royal_assent, c.outcome "
             f"FROM bill_candidate c WHERE c.session_number = {session} ORDER BY 1) "
             "TO STDOUT WITH (FORMAT csv)")
    r = subprocess.run([str(CONNECT), f'sudo -u postgres psql -d legdata -c "{query}"'],
                       check=True, capture_output=True, text=True)
    d = lambda s: datetime.date.fromisoformat(s) if s else None
    lines = {}
    for row in csv.reader(r.stdout.splitlines()):
        line, sess, title, as_introduced, bill_type, introduced, assent, outcome = row
        lines[int(line)] = dict(line=int(line), session=int(sess), short_title=title,
                                as_introduced=as_introduced, bill_type=bill_type,
                                date_introduced=d(introduced), date_royal_assent=d(assent),
                                outcome=outcome)
    return lines


def dataset_rows(path, session):
    """The PhD dataset's rows for one session."""
    import openpyxl
    ws = openpyxl.load_workbook(path, data_only=True)['Dates']
    d = lambda v: v.date() if isinstance(v, datetime.datetime) else None
    rows = []
    for i, r in enumerate(ws.iter_rows(min_row=2, values_only=True), 2):
        if all(v is None for v in r) or r[0] != session:
            continue
        rows.append(dict(xrow=i, session=r[0], type=r[1], name=r[2], introduced=d(r[3]),
                         s1=d(r[4]), s2=d(r[5]), s3=d(r[6]), assent=d(r[7]) if len(r) > 7 else None))
    return rows


def pair_up(lines, rows, session):
    """One dataset row per staging line, where there is one."""
    pairs, unmatched, taken = {}, [], set()
    if session in (1, 2):
        by_xrow = {r['xrow']: r for r in rows}
        for line, xrow in MANUAL_PAIRS.items():
            if line in lines and xrow in by_xrow:
                pairs[line], _ = by_xrow[xrow], taken.add(xrow)
    for r in rows:
        if r['xrow'] in taken:
            continue
        hits = [b for b in lines.values()
                if b['line'] not in pairs
                and tidy(r['name']) in (tidy(b['short_title']), tidy(b['as_introduced']))]
        if len(hits) > 1:
            hits = [b for b in hits if b['date_introduced'] == r['introduced']] or hits
        if len(hits) != 1:
            unmatched.append(f"dataset row {r['xrow']} {r['name']!r} matched {len(hits)} lines")
            continue
        pairs[hits[0]['line']] = r
        taken.add(r['xrow'])
    for line, b in sorted(lines.items()):
        if line not in pairs:
            unmatched.append(f"line {line} {b['short_title']!r} has no row in the dataset")
    return pairs, unmatched


def differences(lines, pairs):
    """Every date the two sources state differently."""
    out = []
    for line, b in sorted(lines.items()):
        r = pairs.get(line)
        if not r:
            continue
        for column, ours, theirs in (('date_introduced', b['date_introduced'], r['introduced']),
                                     ('date_royal_assent', b['date_royal_assent'], r['assent'])):
            if ours and theirs and ours != theirs:
                out.append(dict(line=line, short_title=b['short_title'], column=column,
                                ours=ours, theirs=theirs, source='phd', xrow=r['xrow']))
    return out


def sql_for(session, lines, diffs, fingerprint, path):
    q = lambda s: s.replace("'", "''")
    out = [f"""-- Written by tools/compare_sources.py on {COMPARED_ON}.
-- Session {session}: {len(lines)} staging lines compared against the PhD dataset
-- ({path.name}, sha256 {fingerprint}).
-- {len(diffs)} difference(s) found. Read this before running it.

\\set ON_ERROR_STOP on
BEGIN;

UPDATE bill_candidate SET sources_compared_at = DATE '{COMPARED_ON}'
 WHERE session_number = {session};
"""]
    for d in diffs:
        note = (f"Differs: {d['column']} = {d['theirs']} ({d['source']}); "
                f"this line gives {d['ours']}")
        out.append(f"""
-- line {d['line']}: {q(d['short_title'])}
--   this line {d['ours']}, dataset row {d['xrow']} {d['theirs']}
UPDATE bill_candidate
   SET review_note = btrim(coalesce(review_note || E'\\n', '') || '{q(note)}')
 WHERE candidate_id = {d['line']}
   AND coalesce(review_note, '') NOT LIKE '%Differs: {d['column']} = {d['theirs']} %';""")
    out.append(f"""

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM bill_candidate
   WHERE session_number = {session} AND sources_compared_at IS NULL;
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % line(s) are still unstamped.', n;
  END IF;
  RAISE NOTICE 'Session {session}: {len(lines)} lines compared, {len(diffs)} difference(s) to adjudicate.';
END $$;

COMMIT;
""")
    return '\n'.join(out)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--session', type=int, required=True)
    ap.add_argument('--xlsx', default=str(DEFAULT_XLSX))
    ap.add_argument('--sql')
    args = ap.parse_args()

    path = pathlib.Path(args.xlsx)
    fingerprint = hashlib.sha256(path.read_bytes()).hexdigest()
    print(f'read {path}')
    print(f'sha256 {fingerprint}')

    lines = staging_lines(args.session)
    if not lines:
        sys.exit(f'No staging lines for session {args.session}.')
    rows = dataset_rows(path, args.session)
    print(f'{len(lines)} staging lines, {len(rows)} dataset rows for Session {args.session}')

    pairs, unmatched = pair_up(lines, rows, args.session)
    print(f'{len(pairs)} of {len(lines)} lines paired with a dataset row')
    for u in unmatched:
        print(f'  unpaired: {u}')

    diffs = differences(lines, pairs)
    print(f'\n{len(diffs)} difference(s) between the two sources:')
    for d in diffs:
        print(f"  line {d['line']:>3} {d['short_title'][:44]:46s} {d['column']:18s} "
              f"this line {d['ours']}   dataset {d['theirs']}")

    if args.sql:
        pathlib.Path(args.sql).write_text(sql_for(args.session, lines, diffs, fingerprint, path))
        print(f'\nwrote {args.sql}')
    else:
        print('\nNothing written: pass --sql to write the stamps and the differences.')


if __name__ == '__main__':
    main()
