#!/usr/bin/env python3
"""Generate docs/DATA-DICTIONARY.md from the live database.

The database is the source of truth. Every description in the generated document
is a COMMENT stored on the table or column itself, which is also what Postico
shows beside the column. Nothing here is written by hand, so the document cannot
drift from the database the way a separately-maintained one does.

To change a description, change the COMMENT in a migration and re-run this.

It describes three databases: the working one, the accounts (from
2026-09-16), and the published copy (from 2026-09-18). For the accounts and
the copy it reads the descriptions and never a row.

Usage:  python3 tools/make_data_dictionary.py
"""
import datetime, pathlib, subprocess, sys, time

ROOT = pathlib.Path(__file__).resolve().parent.parent
CONNECT = pathlib.Path.home() / '.claude' / 'legdata-vps'
QUERY = ROOT / 'tools' / 'data_dictionary.sql'
OUT = ROOT / 'docs' / 'DATA-DICTIONARY.md'

# Reading order: what the data is, then how it got there, then the lists of
# allowed values. Alphabetical order would put ref_bill_type before bill.
ORDER = ['session', 'bill', 'stage_event', 'bill_candidate', 'stage_candidate',
         'field_source', 'methodology_note']

GROUPS = [
    ('The data', ['session', 'bill', 'stage_event']),
    ('Getting data in', ['bill_candidate', 'stage_candidate', 'field_source']),
    ('Published alongside the data', ['methodology_note', 'source_terms']),
    ('Lists of allowed values', None),   # None means "everything else"
]


def connect(args, **kw):
    # The server refuses connections for a while after a few in quick
    # succession, and ssh then exits 255. Wait and try again.
    for attempt in range(8):
        r = subprocess.run([str(CONNECT)] + args, capture_output=True, **kw)
        if r.returncode != 255:
            break
        time.sleep(15)
    r.check_returncode()
    return r


def run_query(database, notes, schema='public'):
    connect(['--scp', str(QUERY), '/tmp/data_dictionary.sql'])
    # Removes its copy of the query from the server whether or not it ran, and
    # still fails if it did not.
    r = connect(
        [f'sudo -u postgres psql -d {database} -v notes={notes} -v schema={schema} -At '
         '-f /tmp/data_dictionary.sql; '
         's=$?; rm -f /tmp/data_dictionary.sql; exit $s'], text=True)
    return r.stdout.splitlines()


def parse(lines):
    tables, notes = {}, []
    for line in lines:
        if not line or '|' not in line:
            continue
        if line.startswith('M|'):
            _, code, title, applies = (line.split('|', 3) + [''] * 3)[:4]
            notes.append({'code': code, 'title': title, 'applies': applies})
            continue
        kind, table, col, dtype, required, fk, desc = (line.split('|', 6) + [''] * 6)[:7]
        if kind == 'T':
            tables.setdefault(table, {'desc': desc, 'cols': []})['desc'] = desc
        elif kind == 'C':
            tables.setdefault(table, {'desc': '', 'cols': []})['cols'].append(
                {'name': col, 'type': dtype, 'required': required,
                 'fk': fk, 'desc': desc})
    return tables, notes


def tidy_type(t):
    return {'timestamp with time zone': 'timestamp',
            'character varying': 'text',
            'integer': 'number',
            'boolean': 'true/false',
            'text[]': 'list of text'}.get(t, t)


ACCOUNTS_DB = 'accounts'
ACCOUNTS_ORDER = ['person', 'sign_in_code', 'signed_in_device']

PUBLISHED_DB = 'published'
NUMBER_WORDS = {12: 'twelve', 13: 'thirteen', 14: 'fourteen', 15: 'fifteen',
                16: 'sixteen', 17: 'seventeen', 18: 'eighteen'}
PUBLISHED_SCHEMA = 'live'
# The order of the files in tools/published_copy.sql's mapping.
PUBLISHED_ORDER = ['bills', 'stages', 'days_between_stages', 'sessions',
                   'methodology_notes', 'sources', 'what_the_words_mean',
                   'what_changed', 'workings', 'about', 'cited_pages', 'terms',
                   'outcomes_by_session_and_type']


def render_table(out, name, t):
    out += [f'### `{name}`', '', t['desc'] or '_No description._', '',
            '| Column | Type | Required | Points at | What it holds |',
            '|---|---|---|---|---|']
    for c in t['cols']:
        fk = f"`{c['fk']}`" if c['fk'] else ''
        req = 'yes' if c['required'] else ''
        desc = c['desc'].replace('|', '\\|') or '_No description._'
        out.append(f"| `{c['name']}` | {tidy_type(c['type'])} | {req} "
                   f"| {fk} | {desc} |")
    out.append('')


def render_file(out, name, t):
    # The published copy's files have no required columns and point at
    # nothing, so those two headings are left off.
    out += [f'### `{name}`', '', t['desc'] or '_No description._', '',
            '| Heading | Type | What it holds |',
            '|---|---|---|']
    for c in t['cols']:
        desc = c['desc'].replace('|', '\\|') or '_No description._'
        out.append(f"| `{c['name']}` | {tidy_type(c['type'])} | {desc} |")
    out.append('')


def render(tables, notes, accounts, published):
    today = datetime.date.today().isoformat()
    out = [
        '# Data dictionary',
        '',
        f'Generated from the live database on {today} by '
        '`tools/make_data_dictionary.py`. **Do not edit this file.**',
        '',
        'Every description below is stored on the table or column itself, inside',
        'the database, which is also what Postico shows beside the column. To',
        'change one, change the `COMMENT` in a migration and run the script again.',
        'That way this document cannot drift away from what the database actually',
        'does — which is what happened to the document this replaces.',
        '',
        '## How the tables fit together',
        '',
        '```',
        'session ──< bill ──< stage_event',
        '',
        'bill_candidate ····> bill        via promoted_bill_id',
        'stage_candidate ···> stage_event via promoted_stage_event_id',
        '',
        'methodology_note                 stands alone',
        'field_source                     stands alone',
        '',
        'ref_* tables                     each holds the allowed values',
        '                                 for one column',
        '```',
        '',
        '- `session` has seven rows, one per parliament.',
        '- `bill` is one row per bill. This is the live, checked data.',
        '- `stage_event` is one row per stage a bill reached.',
        '- `bill_candidate` is one row per line read off a factsheet, waiting to '
        'be checked. When a row is promoted, `promoted_bill_id` records which '
        '`bill` row it became.',
        '- `stage_candidate` is one row per stage of a bill, per source, waiting '
        'to be checked. Each row belongs to a `bill_candidate` line, and becomes '
        'a `stage_event` row when promoted.',
        '- The `ref_` tables are lists of allowed values. `bill.bill_type` can '
        'only hold a code that appears in `ref_bill_type`, and the database '
        'refuses anything else.',
        '',
        '**Required** means the column cannot be left empty. **Points at** means '
        'the value must exist in that other table.',
        '',
    ]

    if notes:
        out += [
            '## The methodology notes',
            '',
            'What each note is called, and which columns it bears on. The notes '
            'themselves are held in the database and published beside the data; '
            'their wording is deliberately not copied here, because a second '
            'copy is a second thing to keep true. Read one in Postico, in '
            '`methodology_note`, or wherever the data is published.',
            '',
            '| Note | What it says | Applies to |',
            '|---|---|---|',
        ]
        for n in notes:
            applies = ', '.join(f'`{a}`' for a in n['applies'].split(', ') if a)
            out.append(f"| **{n['code']}** | {n['title'].replace('|', chr(92) + '|')} "
                       f"| {applies} |")
        out.append('')

    named = [t for _, ts in GROUPS if ts for t in ts]
    rest = sorted(t for t in tables if t not in named)

    for heading, wanted in GROUPS:
        names = wanted if wanted else rest
        names = [n for n in names if n in tables]
        if not names:
            continue
        out += [f'## {heading}', '']
        for name in names:
            render_table(out, name, tables[name])

    out += [
        '---',
        '',
        '# The accounts',
        '',
        f'A separate database, `{ACCOUNTS_DB}`, holding the people who have applied to '
        'use the site, their sign-in codes and their signed-in devices. Nothing '
        'in it is about a bill, and nothing in the working database above is '
        'about a person. The website can open this database and cannot open the '
        'working one.',
        '',
        'What follows describes its columns and never its contents: this script '
        'reads only the descriptions stored on it, not a single row. Real data '
        'about a real person goes in no document.',
        '',
        '```',
        'person ──< sign_in_code',
        'person ──< signed_in_device',
        '```',
        '',
        '- Deleting a `person` deletes their codes and devices with it.',
        '',
    ]
    names = [n for n in ACCOUNTS_ORDER if n in accounts]
    names += sorted(n for n in accounts if n not in ACCOUNTS_ORDER)
    for name in names:
        render_table(out, name, accounts[name])

    out += [
        '---',
        '',
        '# The published copy',
        '',
        f'A separate database, `{PUBLISHED_DB}`, holding the copy of the data a '
        'reader sees, taken from the working database at one moment by '
        f'`tools/published_copy.sql`. Its {NUMBER_WORDS.get(len(published), len(published))} files are in the area '
        f'`{PUBLISHED_SCHEMA}`. Words stand in the cells where the working '
        'database holds codes; `what_the_words_mean` says what each word means.',
        '',
        'The descriptions below are the ones a reader is given, stored on each '
        'file and heading in the copy. This script reads them and never a row.',
        '',
    ]
    names = [n for n in PUBLISHED_ORDER if n in published]
    names += sorted(n for n in published if n not in PUBLISHED_ORDER)
    for name in names:
        render_file(out, name, published[name])
    return '\n'.join(out) + '\n'


def undescribed(tables, where):
    missing = [f'{where}{name}.{c["name"]}'
               for name, t in sorted(tables.items())
               for c in t['cols'] if not c['desc']]
    missing += [f'{where}{name} (the table itself)'
                for name, t in sorted(tables.items()) if not t['desc']]
    return missing


def main():
    if not CONNECT.exists():
        sys.exit(f'connector script not found at {CONNECT}')
    tables, notes = parse(run_query('legdata', 'true'))
    if not tables:
        sys.exit('no tables returned — is the query working?')
    accounts, _ = parse(run_query(ACCOUNTS_DB, 'false'))
    if not accounts:
        sys.exit(f'no tables returned from {ACCOUNTS_DB} — is the query working?')
    published, _ = parse(run_query(PUBLISHED_DB, 'false', PUBLISHED_SCHEMA))
    if not published:
        sys.exit(f'no files returned from {PUBLISHED_DB} — is the copy there?')

    # A column with no description is how the last document rotted: something
    # gets added and nobody writes down what it is. Refuse to generate rather
    # than quietly publish a gap.
    missing = (undescribed(tables, '') + undescribed(accounts, f'{ACCOUNTS_DB}: ')
               + undescribed(published, f'{PUBLISHED_DB}: '))
    if missing:
        print('Not generated. These have no description in the database:',
              file=sys.stderr)
        for m in missing:
            print(f'  {m}', file=sys.stderr)
        print('\nAdd a COMMENT ON for each in a migration, apply it, '
              'then run this again.', file=sys.stderr)
        sys.exit(1)

    OUT.write_text(render(tables, notes, accounts, published))
    cols = sum(len(t['cols']) for t in tables.values())
    acols = sum(len(t['cols']) for t in accounts.values())
    pcols = sum(len(t['cols']) for t in published.values())
    print(f'wrote {OUT.relative_to(ROOT)}: {len(tables)} tables, {cols} columns, '
          f'all described; {len(notes)} methodology notes indexed; '
          f'accounts: {len(accounts)} tables, {acols} columns, all described; '
          f'published: {len(published)} files, {pcols} headings, all described')


if __name__ == '__main__':
    main()
