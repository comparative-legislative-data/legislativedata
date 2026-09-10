#!/usr/bin/env python3
"""Extract bill candidates from a SPICe legislation factsheet.

Produces CANDIDATES, not facts. Every row carries the factsheet's own words in
raw_* fields alongside the mapping this script proposes; the mapping is a claim
to be reviewed, not a result. See docs/DECISIONS.md.

Sessions 1-5 are ruled tables; sessions 6-7 are prose. This handles the table
form. Usage:  extract_factsheet.py <pdf> --session N [--csv out.csv]
"""
import argparse, csv, json, re, sys
import pdfplumber

MONTHS = {m.lower(): i for i, m in enumerate(
    ['January','February','March','April','May','June','July','August',
     'September','October','November','December'], 1)}
MONTHS.update({m[:3].lower(): i for m, i in list(MONTHS.items())})

TYPE_MAP = {'E': 'government', 'G': 'government', 'M': 'members',
            'C': 'committee', 'P': 'private', 'H': 'hybrid'}

# The label as styled at introduction. 'G*' is the Session 4 footnote
# 'Introduced as an Executive Bill (E)': introduced as Executive, passed as
# Government, so it is 'executive' here and the change goes in a note.
STATED_MAP = {'E': 'executive', 'G': 'government', 'G*': 'executive',
              'M': 'members', 'C': 'committee', 'P': 'private', 'H': 'hybrid'}


def clean(cell):
    """Collapse the newlines pdfplumber preserves inside a cell."""
    if cell is None:
        return None
    s = re.sub(r'\s+', ' ', cell.replace('\n', ' ')).strip()
    return s or None


def parse_date(text):
    """'6 October 1999' / '18 Nov 2009' -> ISO date. None if not parseable."""
    if not text:
        return None, 'empty'
    s = clean(text)
    m = re.match(r'^(\d{1,2})\s+([A-Za-z]+)\.?\s+(\d{4})$', s)
    if not m:
        return None, f'unparsed: {s!r}'
    day, mon, year = m.group(1), m.group(2).lower(), m.group(3)
    if mon not in MONTHS:
        return None, f'unknown month: {s!r}'
    return f'{year}-{MONTHS[mon]:02d}-{int(day):02d}', None


def split_title(raw):
    """Separate the asp number from an Act title.

    Titles embed it with inconsistent spacing: 'asp 5', 'asp3', 'asp11'.
    Returns (title_without_asp, asp_number_or_None).
    """
    s = clean(raw)
    if not s:
        return None, None
    m = re.search(r'\b(?:\((?P<p>asp\s*\d+)\)|(?P<b>asp\s*\d+))\s*$', s, re.I)
    if not m:
        return s, None
    asp = (m.group('p') or m.group('b'))
    asp = re.sub(r'asp\s*', 'asp ', asp, flags=re.I).strip()
    title = s[:m.start()].strip().rstrip('(').strip()
    ym = re.search(r'\b(1[89]|20)\d{2}\b', title)
    year = ym.group(0) if ym else None
    return title, (f'{year} {asp}' if year else asp)


def section_of(header):
    """Identify a table from its own header row, not from page position."""
    last = (clean(header[-1]) or '').lower()
    first = (clean(header[0]) or '').lower()
    if 'summary' in first or 'legislation' == first:
        return 'summary'
    if 'royal assent' in last:
        return 'acts'
    if 'withdrawn' in last:
        return 'withdrawn'
    if 'fell' in last or 'fallen' in last:
        return 'fallen'
    return None


SECTION_OUTCOME = {
    'acts':      ('passed',    'enacted'),
    'withdrawn': ('withdrawn', 'not_enacted'),
    'fallen':    (None,        'not_enacted'),   # see note below
}


def extract(path, session, dissolution=None):
    rows, summary, problems = [], [], []
    with pdfplumber.open(path) as pdf:
        for pi, page in enumerate(pdf.pages, start=1):
            for table in page.find_tables():
                data = table.extract()
                if not data:
                    continue
                kind = section_of(data[0])
                if kind is None:
                    problems.append(f'p{pi}: unrecognised table header '
                                    f'{[clean(c) for c in data[0]]}')
                    continue
                if kind == 'summary':
                    summary.append({'page': pi,
                                    'rows': [[clean(c) for c in r] for r in data]})
                    continue
                for r in data[1:]:
                    if not clean(r[0]) or clean(r[0]) == clean(data[0][0]):
                        continue  # blank or a repeated header
                    rows.append(build(r, kind, session, pi, path, dissolution,
                                      problems))
    return rows, summary, problems


def build(r, kind, session, page, path, dissolution, problems):
    raw_title = clean(r[0])
    raw_type = clean(r[1])
    raw_intro = clean(r[2])
    raw_by = clean(r[3])
    raw_final = clean(r[4]) if len(r) > 4 else None
    raw_assent = clean(r[5]) if len(r) > 5 else None

    notes = []
    title, asp = split_title(raw_title)
    code = (raw_type or '').upper().strip()
    bill_type = TYPE_MAP.get(code.rstrip('*'))
    stated = STATED_MAP.get(code)
    if bill_type is None and raw_type:
        notes.append(f'unmapped type code {raw_type!r}')
    if code.endswith('*') and stated == 'executive':
        notes.append('introduced as an Executive Bill; styled a Government '
                     'Bill by the time it passed')

    d_intro, e = parse_date(raw_intro)
    if e and e != 'empty':
        notes.append(f'date_introduced {e}')
    d_final, e = parse_date(raw_final)
    if e and e != 'empty':
        notes.append(f'final date {e}')
    d_assent, e = parse_date(raw_assent)
    if e and e != 'empty':
        notes.append(f'royal assent {e}')

    outcome, enactment = SECTION_OUTCOME[kind]
    if kind == 'fallen':
        # SPICe does not say WHY a bill fell. Only dissolution is inferable,
        # and only by date. Everything else is left for review.
        if dissolution and d_final == dissolution:
            outcome = 'fell_dissolution'
            notes.append('fell on the dissolution date; outcome inferred')
        else:
            notes.append('fell before dissolution; outcome needs review '
                         '(rejected_stage_1 / fell_other)')

    if kind == 'acts':
        title_kind = 'act'
        notes.append('title is the Act title, not the title as introduced')
    else:
        title_kind = 'bill'

    return {
        'session_number': session,
        'raw_title': raw_title,
        'raw_type': raw_type,
        'raw_date_introduced': raw_intro,
        'raw_introduced_by': raw_by,
        'raw_date_final': raw_final,
        'raw_date_royal_assent': raw_assent,
        'raw_section': kind,
        'short_title': title,
        'title_kind': title_kind,
        'bill_type': bill_type,
        'bill_type_stated': stated,
        'date_introduced': d_intro,
        'end_stage_3_date': d_final if kind == 'acts' else None,
        'date_concluded': None if kind == 'acts' else d_final,
        'date_royal_assent': d_assent,
        'asp_number': asp,
        # procedure is deliberately absent: no factsheet states it, and a
        # default of 'standard' would record budget and emergency bills as
        # standard on no evidence. See db/010.
        'outcome': outcome,
        'enactment_status': enactment,
        'src_file': path.split('/')[-1],
        'src_page': page,
        'parser_note': '; '.join(notes) or None,
    }


if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('pdf')
    ap.add_argument('--session', type=int, required=True)
    ap.add_argument('--dissolution', help='ISO date, to infer fell_dissolution')
    ap.add_argument('--csv')
    a = ap.parse_args()
    rows, summary, problems = extract(a.pdf, a.session, a.dissolution)
    if a.csv:
        with open(a.csv, 'w', newline='') as f:
            w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
            w.writeheader()
            w.writerows(rows)
    print(json.dumps({'rows': len(rows), 'problems': problems,
                      'summary': summary}, indent=1)[:2000])
