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

    Titles embed it with inconsistent spacing: 'asp 5', 'asp3', 'asp11', and
    from Session 2 onward sometimes in brackets: 'Act 2007 (asp 9)'.
    Returns (title_without_asp, asp_number_or_None).
    """
    s = clean(raw)
    if not s:
        return None, None
    # No \b in front of the bracket: there is no word boundary between a space
    # and '(', so the bracketed form never matched and stayed in the title.
    m = re.search(r'(?:\((?P<p>asp\s*\d+)\)|\b(?P<b>asp\s*\d+))\s*$', s, re.I)
    if not m:
        return s, None
    asp = (m.group('p') or m.group('b'))
    asp = re.sub(r'asp\s*', 'asp ', asp, flags=re.I).strip()
    title = s[:m.start()].strip().rstrip('(').strip()
    ym = re.search(r'\b(1[89]|20)\d{2}\b', title)
    year = ym.group(0) if ym else None
    return title, (f'{year} {asp}' if year else asp)


def mend_title(s):
    r"""Repair what the printing did to a title, without touching raw_title.

    Two things the factsheets do: break a word across a line with a hyphen, so
    'Asbestos-\nrelated' reads as 'Asbestos- related'; and print a footnote
    marker hard against the year, so 'Act 2014' with footnote 1 reads as
    'Act 20141'. Both change what the title is and what year the asp number
    carries. The factsheet's own words are kept in raw_title.
    """
    if not s:
        return s, []
    notes = []
    mended = re.sub(r'(?<=\w)-\s+(?=\w)', '-', s)
    if mended != s:
        notes.append('a word broken across a line was rejoined')
    # A year is four digits. Five or more beginning 19 or 20 is a year with a
    # footnote marker printed against it.
    def strip_marker(m):
        notes.append(f'a footnote marker was removed from the year {m.group(1)}')
        return m.group(1)
    mended = re.sub(r'\b((?:1[89]|20)\d{2})\d+\b', strip_marker, mended)
    # Session 5 prints the marker against the word 'Bill' instead, so
    # '... (Scotland) Bill' with footnote 1 reads as '... (Scotland) Bill1'.
    # One or two digits only, and only where they run straight on from 'Bill':
    # 'SP Bill 70' has a space and is left alone.
    def strip_bill_marker(m):
        notes.append('a footnote marker was removed from the word Bill')
        return m.group(1)
    mended = re.sub(r'\b(Bill)\d{1,2}\b', strip_bill_marker, mended)
    return mended, notes


def footnote_marker(raw_title):
    """The footnote number printed against 'Bill' in the title as printed.

    Read off raw_title, before mend_title takes it out, so the row can be
    joined to the footnote at the foot of its page. None where the factsheet
    prints no marker.
    """
    if not raw_title:
        return None
    m = re.search(r'\bBill(\d{1,2})\b', re.sub(r'\s+', ' ', raw_title))
    return int(m.group(1)) if m else None


def page_footnotes(page, tables):
    """The footnotes printed below the tables on a page, by their number.

    Session 5 puts the reason a bill cannot be submitted for Royal Assent in a
    footnote, so the row alone does not say what happened to the bill. The
    region below the last table is read, and a line that begins with one or two
    digits and then a capital starts a new footnote; a continuation line
    beginning '1998 by the' or '2021 that some' does not, because a year is
    four digits. The reference line SPICe prints at the foot is dropped.
    """
    if not tables:
        return {}
    bottom = max(t.bbox[3] for t in tables)
    if bottom >= page.bbox[3]:
        return {}
    region = page.crop((page.bbox[0], bottom, page.bbox[2], page.bbox[3]))
    text = region.extract_text() or ''
    out, num, buf = {}, None, []
    for line in text.split('\n'):
        line = line.strip()
        if not line or re.match(r'^Reference:', line):
            continue
        m = re.match(r'^(\d{1,2})\s+(?=[A-Z])(.*)$', line)
        if m:
            if num is not None:
                out[num] = ' '.join(buf).strip()
            num, buf = int(m.group(1)), [m.group(2)]
        elif num is not None:
            buf.append(line)
    if num is not None:
        out[num] = ' '.join(buf).strip()
    return out


def split_introduced(s):
    """Separate a stated introduced title from the rest of the title cell.

    Session 2 prints one inside the cell, after the asp number: 'Scottish
    Commission for Human Rights Act 2006 asp 16 Introduced as: Scottish
    Commissioner for Human Rights Bill'.
    Returns (rest_of_cell, introduced_title_or_None).
    """
    if not s:
        return s, None
    m = re.search(r'\s*\bIntroduced as:?\s*(?P<t>.+)$', s, re.I)
    if not m:
        return s, None
    return s[:m.start()].strip(), m.group('t').strip()


def split_sp_bill(s):
    """Separate the SP Bill number from a bill title: '... Bill SP Bill 43'.

    Sessions 2-5 give one only for bills that did not become Acts. The number
    restarts each session, so it identifies a bill only within its session
    (db/019). Returns (title_without_number, number_or_None).
    """
    if not s:
        return s, None
    m = re.search(r'\s*\(?\bSP\s*Bill\s*(?P<n>\d+)\)?\s*$', s, re.I)
    if not m:
        return s, None
    return s[:m.start()].strip(), m.group('n')


def section_of(header):
    """Identify a table from its own header row, not from page position.

    The factsheets print the summary table with its first cell blank in some
    sessions, so 'Legislation' is looked for anywhere in the header, not only
    in the first cell.
    """
    cells = [(clean(c) or '').lower() for c in header]
    first = cells[0] if cells else ''
    last = next((c for c in reversed(cells) if c), '')
    if 'summary' in first or any(c == 'legislation' for c in cells):
        return 'summary'
    if 'royal assent' in last:
        return 'acts'
    if 'withdrawn' in last:
        return 'withdrawn'
    if 'fell' in last or 'fallen' in last:
        return 'fallen'
    if 'passed' in last and 'title' in first:
        # Session 5 onwards: bills passed and not yet given Royal Assent. The
        # heading says 'awaiting'; the footnote against each row says whether
        # the bill is in fact stopped. Extracted since 2026-09-14.
        return 'awaiting_assent'
    return None


SECTION_OUTCOME = {
    'acts':            ('passed',    'enacted'),
    'withdrawn':       ('withdrawn', 'not_enacted'),
    'fallen':          (None,        'not_enacted'),   # see note below
    # A bill in this table has been passed and has not received Royal Assent.
    # 'pending' is what the table's own heading says; where the bill's footnote
    # says it cannot be submitted for Royal Assent, that is a block and build()
    # proposes 'blocked' instead. Both are read off the page; neither is
    # guessed. See methodology note M5.
    'awaiting_assent': ('passed',    'pending'),
}

# The words SPICe uses in the footnote when a bill has been stopped. Matched on
# the footnote's own text, not inferred from the table it sits under.
BLOCKED_PHRASE = re.compile(r'cannot be submitted for Royal Assent', re.I)
BLOCKED_DATE = re.compile(r'has ruled on (?P<d>\d{1,2} \w+ \d{4})\b', re.I)
ORDER_DATE = re.compile(r'order .{0,40}? on (?P<d>\d{1,2} \w+ \d{4})\b', re.I)


def column_bounds(table):
    """The x positions of a table's column edges, as pdfplumber found them."""
    xs = sorted({round(c[0], 1) for r in table.rows for c in r.cells if c} |
                {round(c[2], 1) for r in table.rows for c in r.cells if c})
    out = []
    for x in xs:
        if not out or x - out[-1] >= 3:
            out.append(x)
    return out


def is_legend(data):
    """The key on page 1: a two-column table of type letters and their names."""
    return len(data[0]) <= 2 and (clean(data[0][0]) or '') in TYPE_MAP


def starts_a_row(cells):
    """A bill's row always states its type letter in the second column.

    A row without one is the tail of a row split across a page boundary, or a
    cell that wrapped past the foot of a page. It belongs to the row above.
    """
    return len(cells) > 1 and (cells[1] or '').upper().rstrip('*') in TYPE_MAP


def recut(page, tables, cols):
    """Re-read a run of tables as one grid, on the columns given.

    pdfplumber breaks a ruled table wherever the factsheet stops drawing cell
    borders, and a row whose borders are missing is lost between the pieces --
    the Session 4 'Interests of Members' Act was lost this way. Re-reading the
    whole run on one set of columns, cutting at every rule, gets it back. Where
    that cuts a row in two, starts_a_row joins it up again.
    """
    top = tables[0].bbox[1]
    bottom = max(t.bbox[3] for t in tables)
    region = page.crop((page.bbox[0], top - 1, page.bbox[2], bottom + 1))
    return region.extract_table({'vertical_strategy': 'explicit',
                                 'explicit_vertical_lines': cols,
                                 'horizontal_strategy': 'lines'})


def extract(path, session):
    staged, summary, problems = [], [], []
    notes_by_page = {}
    kind, cols = None, None
    with pdfplumber.open(path) as pdf:
        for pi, page in enumerate(pdf.pages, start=1):
            tables = page.find_tables()
            notes_by_page[pi] = page_footnotes(page, tables)
            i = 0
            while i < len(tables):
                data = tables[i].extract()
                if not data or is_legend(data):
                    i += 1
                    continue
                header = section_of(data[0])
                # A table with no header of its own is not a table: it is the
                # rest of the one before it, on this page or the page before.
                j = i + 1
                while j < len(tables):
                    nxt = tables[j].extract()
                    if not nxt or is_legend(nxt) or section_of(nxt[0]) is not None:
                        break
                    j += 1
                if header is not None:
                    kind = header
                    cols = column_bounds(tables[i])
                if cols and (j > i + 1 or header is None):
                    joined = recut(page, tables[i:j], cols)
                    if joined:
                        data = joined
                body = data[1:] if header is not None else data
                i = j

                if kind is None:
                    problems.append(f'p{pi}: unrecognised table header '
                                    f'{[clean(c) for c in data[0]]}')
                    continue
                if kind == 'summary':
                    summary.append({'page': pi,
                                    'rows': [[clean(c) for c in r] for r in data]})
                    continue
                for r in body:
                    cells = [clean(c) for c in r]
                    if not any(cells):
                        continue
                    if header is not None and clean(r[0]) == clean(data[0][0]):
                        continue  # a header repeated inside the table
                    if starts_a_row(cells):
                        staged.append({'cells': cells, 'kind': kind, 'page': pi,
                                       'rejoined': False})
                    elif staged and staged[-1]['kind'] == kind:
                        prev = staged[-1]['cells']
                        for ci, c in enumerate(cells):
                            if not c or ci >= len(prev):
                                continue
                            prev[ci] = f'{prev[ci]} {c}'.strip() if prev[ci] else c
                        staged[-1]['rejoined'] = True
                    else:
                        problems.append(f'p{pi}: a row with no type letter and '
                                        f'nothing to join it to: {cells}')
    rows = []
    for st in staged:
        row = build(st['cells'], st['kind'], session, st['page'], path,
                    problems, notes_by_page.get(st['page'], {}))
        if st['rejoined']:
            note = 'read from a row the factsheet split across a page'
            row['parser_note'] = (f"{row['parser_note']}; {note}"
                                  if row['parser_note'] else note)
        rows.append(row)
    return rows, summary, problems


def build(r, kind, session, page, path, problems, footnotes=None):
    raw_title = clean(r[0])
    raw_type = clean(r[1])
    raw_intro = clean(r[2])
    raw_by = clean(r[3])
    raw_final = clean(r[4]) if len(r) > 4 else None
    raw_assent = clean(r[5]) if len(r) > 5 else None

    notes = []
    # Peeled off the end of the cell in reverse order of how it is printed:
    # title, asp number, then an introduced title or an SP Bill number.
    mended, mend_notes = mend_title(raw_title)
    notes.extend(mend_notes)
    rest, introduced = split_introduced(mended)
    rest, sp_bill = split_sp_bill(rest)
    title, asp = split_title(rest)
    if introduced:
        notes.append('the factsheet states the title as introduced')
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
    raw_footnote, d_blocked = None, None
    marker = footnote_marker(raw_title)
    if kind == 'awaiting_assent':
        # The table says the bill has been passed and has no Royal Assent. Why
        # not is in the footnote, and without it the row cannot be told apart
        # from a bill simply waiting its turn. See methodology note M5.
        if marker is None:
            notes.append('no footnote marker against the title, so nothing on '
                         'the page says why Royal Assent has not been given; '
                         'proposed as pending for review')
        else:
            raw_footnote = (footnotes or {}).get(marker)
            if raw_footnote is None:
                problems.append(f'p{page}: {title!r} carries footnote marker '
                                f'{marker}, and no footnote {marker} was found '
                                f'on the page')
                notes.append(f'footnote marker {marker} against the title, and '
                             f'no footnote {marker} on the page')
            elif BLOCKED_PHRASE.search(raw_footnote):
                enactment = 'blocked'
                m = BLOCKED_DATE.search(raw_footnote) or ORDER_DATE.search(raw_footnote)
                if m:
                    d_blocked, e = parse_date(m.group('d'))
                    if e and e != 'empty':
                        notes.append(f'date the bill was stopped {e}')
                else:
                    notes.append('the footnote gives no date for when the bill '
                                 'was stopped, so date_assent_blocked is empty')
                notes.append('the footnote says the bill cannot be submitted '
                             'for Royal Assent, so blocked, not pending')
            else:
                notes.append('a footnote against the title does not say the '
                             'bill cannot be submitted for Royal Assent; '
                             'proposed as pending for review')
    if kind == 'fallen':
        # SPICe says which bills fell and never why. This reader reports what
        # the factsheet says and nothing more, so the outcome is left empty for
        # review. Until 2026-09-12 it proposed fell_dissolution here, by
        # comparing the bill's final date against a dissolution date handed to
        # it on the command line -- a date this reader cannot see, recorded
        # nowhere, and so a coding that could not be reproduced from the PDF
        # alone. The comparison now happens on the staging sheet, where the
        # session's last day is recorded with its own source. See db/051,
        # DECISIONS.md 2026-09-12, and methodology note M7.
        notes.append('the factsheet says the bill fell and not why; '
                     'outcome left for review')

    if kind == 'acts':
        title_kind = 'act'
        notes.append('title is the Act title, not the title as introduced')
        if asp and not asp[0].isdigit():
            notes.append('the factsheet prints no year before the asp number')
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
        'sp_bill_id': sp_bill,
        'short_title': title,
        'title_as_introduced': introduced,
        'title_kind': title_kind,
        'bill_type': bill_type,
        'bill_type_stated': stated,
        'date_introduced': d_intro,
        # A bill in the awaiting table has passed, so its last date is the
        # date it passed, exactly as for an Act -- and it has not concluded,
        # because nothing has ended it.
        'end_stage_3_date': d_final if kind in ('acts', 'awaiting_assent') else None,
        'date_concluded': None if kind in ('acts', 'awaiting_assent') else d_final,
        'date_royal_assent': d_assent,
        'asp_number': asp,
        # procedure is deliberately absent: no factsheet states it, and a
        # default of 'standard' would record budget and emergency bills as
        # standard on no evidence. See db/010.
        'outcome': outcome,
        'enactment_status': enactment,
        'date_assent_blocked': d_blocked,
        'raw_footnote': raw_footnote,
        # Always empty here. The ruled-table fact sheets, Sessions 1 to 5, do
        # not state how a bill was handled under the Parliament's rules; only
        # the prose fact sheets do, in a sentence of their own. The columns are
        # emitted so that both readers write the same CSV and the loader has
        # one contract to match. See db/087 and methodology note M10.
        'procedure': None,
        'date_procedure_agreed': None,
        'src_file': path.split('/')[-1],
        'src_page': page,
        'parser_note': '; '.join(notes) or None,
    }


if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('pdf')
    ap.add_argument('--session', type=int, required=True)
    ap.add_argument('--csv')
    a = ap.parse_args()
    rows, summary, problems = extract(a.pdf, a.session)
    if a.csv:
        with open(a.csv, 'w', newline='') as f:
            w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
            w.writeheader()
            w.writerows(rows)
    print(json.dumps({'rows': len(rows), 'problems': problems,
                      'summary': summary}, indent=1)[:2000])
