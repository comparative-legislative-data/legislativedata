#!/usr/bin/env python3
"""Read bill candidates from a SPICe legislation fact sheet written as prose.

Sessions 6 and 7 are not tables. Each bill is a title followed by a few
sentences, and everything the ruled tables put in columns -- the type, who
introduced it, the dates -- is inside a sentence. This reads those sentences.
tools/extract_factsheet.py reads the ruled tables of Sessions 1 to 5, and both
write the same CSV, so the loader has one contract to match.

Produces CANDIDATES, not facts, exactly as the table reader does: the fact
sheet's own words travel with every row, and the mapping is a claim to be
reviewed. See docs/DECISIONS.md.

HOW IT READS, AND WHY IT IS NOT LINE BY LINE. A title can wrap across printed
lines, and so can a sentence: the rename sentence does, in both places it
appears. A reader that works line by line does not merely miss such a sentence,
it swallows it into the next bill's title without saying so. So the pages are
reflowed into one stream with the running footers taken out, and the stream is
then walked from the beginning with a list of shapes -- headings and sentences.
Whatever lies between two recognised shapes is a title, and a title is only a
title if a sentence saying a bill was introduced follows it immediately.

NOTHING MAY BE LEFT OVER. Every character of the body has to be inside a shape
this reader knows or inside a title, and --strict (the default) stops if any is
not. That is the check that the grammar in docs/FACTSHEET-SURVEY.md is still
complete, and it is what would catch SPICe printing something new.

Usage:  read_prose_factsheet.py <pdf> --session N [--csv out.csv]
"""
import argparse, csv, json, re, sys
import pdfplumber

DATE = r'\d{1,2} [A-Z][a-z]+ \d{4}'
MONTHS = {m.lower(): i for i, m in enumerate(
    ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August',
     'September', 'October', 'November', 'December'], 1)}

# The prose names the type in words. Only these two occur in Sessions 6 and 7;
# an unknown one stops the read rather than being guessed at.
TYPE_MAP = {'Government': ('government', 'government'),
            'Member’s': ('members', 'members'),
            "Member's": ('members', 'members'),
            'Committee': ('committee', 'committee'),
            'Private': ('private', 'private'),
            'Hybrid': ('hybrid', 'hybrid')}

# A heading names a section. The asterisk on Session 6's "Bills awaiting Royal
# Assent*" belongs to the starred note further down the page, not to a bill.
HEADINGS = [
    (re.compile(r'Bills currently in progress\*?'),            'in_progress'),
    (re.compile(r'Bills awaiting Royal Assent\*?'),            'awaiting_assent'),
    (re.compile(r'Bills which have fallen\*?'),                'fallen'),
    (re.compile(r'Bills which have been withdrawn\*?'),        'withdrawn'),
    (re.compile(r'Session (?P<from>\d+) bills which have been withdrawn '
                r'during Session (?P<during>\d+)'),            'withdrawn_from_earlier_session'),
    (re.compile(r'Acts of the Scottish Parliament\*?'),        'acts'),
]

# The sentences. Every one of these is in docs/FACTSHEET-SURVEY.md §1, and the
# survey and this list are checked against each other by reading both documents
# with nothing left over.
SENTENCES = [
    ('introduced', re.compile(
        r'(?P<type>Government|Member’s|Member\'s|Committee|Private|Hybrid) Bill '
        r'introduced on (?P<date>' + DATE + r') by (?P<who>[^.]+?) MSP\.')),
    ('passed',     re.compile(r'Passed on (?P<date>' + DATE + r')\.')),
    ('fell',       re.compile(r'Fell on (?P<date>' + DATE + r')\.')),
    ('withdrawn',  re.compile(r'Withdrawn on (?P<date>' + DATE + r')\.')),
    ('assent',     re.compile(r'Received Royal Assent on (?P<date>' + DATE + r')\.')),
    ('reconsideration_agreed', re.compile(
        r'Reconsideration stage agreed on (?P<date>' + DATE + r')\.')),
    ('reconsideration_ended', re.compile(
        r'The Bill was approved and ended Reconsideration Stage on '
        r'(?P<date>' + DATE + r')\.')),
    ('renamed', re.compile(
        r'Introduced as the (?P<old>.+?) and renamed on (?P<date>' + DATE +
        r') to the (?P<new>.+?)\.(?= |$)')),
    ('procedure', re.compile(
        r'Motion agreed to treat as (?P<procedure>Emergency) Bill on '
        r'(?P<date>' + DATE + r')\.')),
    ('section_35_note', re.compile(
        r'\*On (?P<date>' + DATE + r') the UK Government intervened to block '
        r'Scottish Parliament legislation \(under powers contained in s\.35 of '
        r'the Scotland Act 1998\) on the grounds that they believed it would '
        r'have a negative impact on UK law\.')),
    ('section_empty', re.compile(
        r'No bills have (?:fallen|been withdrawn|become Acts) in '
        r'Session \d+\.')),
    ('excluded_note', re.compile(
        r'The following bill was introduced during Session (?P<from>\d+) of the '
        r'Scottish Parliament and has subsequently been withdrawn during '
        r'Session (?P<during>\d+)\. Please note this bill is not included in '
        r'Summary of Legislation totals below\.')),
]

# What the fact sheet's own section says about a bill, before anything is read
# off the sentences. The same table as the ruled-table reader's, with the two
# sections only a prose fact sheet has.
SECTION_OUTCOME = {
    'acts':             ('passed',      'enacted'),
    'withdrawn':        ('withdrawn',   'not_enacted'),
    'fallen':           (None,          'not_enacted'),
    'awaiting_assent':  ('passed',      'pending'),
    'in_progress':      ('in_progress', 'pending'),
    # A bill of an earlier session, printed in a section of its own and left
    # out of this session's totals. It is a further appearance of a bill
    # already on the clean sheet, and saying so is review's business, not the
    # reader's: the reader reports which section it was printed in.
    'withdrawn_from_earlier_session': ('withdrawn', 'not_enacted'),
}


def parse_date(text):
    """'5 October 2023' -> '2023-10-05'."""
    m = re.match(r'^(\d{1,2}) ([A-Z][a-z]+) (\d{4})$', text.strip())
    if not m or m.group(2).lower() not in MONTHS:
        raise ValueError(f'not a date this reader knows: {text!r}')
    return f'{m.group(3)}-{MONTHS[m.group(2).lower()]:02d}-{int(m.group(1)):02d}'


def body_text(path):
    """The fact sheet's body, reflowed, with each piece's page remembered.

    Returns (text, page_of, line_starts, line_ends, summary). The reflowed text
    is what the shapes are matched against, because a title or a sentence can
    wrap across printed lines. Where each printed line began and ended is kept
    as well, because a heading is a line of its own and must be recognised as
    one: the cover page describes the sections in a sentence -- "bills which
    have received Royal Assent and become Acts of the Scottish Parliament" --
    and those words are not a heading.

    Everything before the first section heading is the cover; everything from
    the summary table onwards is the summary and the note about SPICe, which
    are not bills. Both are dropped here, and the summary is kept separately
    for the reconciliation.
    """
    parts, pages, starts, ends, summary = [], [], set(), set(), []
    at, in_summary = 0, False
    with pdfplumber.open(path) as pdf:
        for pi, page in enumerate(pdf.pages, start=1):
            for line in (page.extract_text() or '').split('\n'):
                line = line.strip()
                if not line:
                    continue
                # The running footer, e.g. 'Scottish Parliament legislation:
                # Session 6 7'. It is not part of any sentence.
                if re.match(r'^Scottish Parliament legislation: Session \d+ \d+$', line):
                    continue
                if line == 'Summary of legislation':
                    in_summary = True
                    continue
                if line == 'About SPICe':
                    # Everything after this is about SPICe, not about bills.
                    return ''.join(parts), pages, starts, ends, summary
                if in_summary:
                    summary.append(line)
                    continue
                starts.add(at)
                parts.append(line + ' ')
                pages.extend([pi] * (len(line) + 1))
                at += len(line)
                ends.add(at)
                at += 1
    return ''.join(parts), pages, starts, ends, summary


def heading_at(text, pos, starts, ends):
    """The section a heading printed on its own line at pos names, or None.

    A heading is a whole printed line and nothing else. The words of one can
    appear inside a sentence -- the cover page's description of the sections
    contains three of them -- and this is what tells the two apart.
    """
    if pos not in starts:
        return None
    for pattern, section in HEADINGS:
        m = pattern.match(text, pos)
        if m and m.end() in ends:
            return m, section
    return None


def cover_end(text, starts, ends):
    """Where the cover ends: the first line that is a section heading."""
    for pos in sorted(starts):
        if heading_at(text, pos, starts, ends):
            return pos
    raise ValueError('no section heading found: this is not a prose fact sheet')


def walk(text, pages, starts, ends):
    """Every heading, sentence and title in the body, in the order printed.

    Each piece knows where it started, so a title can be given the page it was
    printed on and anything unrecognised can be reported with its own words.
    """
    pos, out = cover_end(text, starts, ends), []
    while pos < len(text):
        if text[pos] == ' ':
            pos += 1
            continue
        hit = None
        head = heading_at(text, pos, starts, ends)
        if head:
            hit = (head[0], ('heading', {'section': head[1]}))
        for name, pattern in SENTENCES:
            m = pattern.match(text, pos)
            if m and (hit is None or m.end() > hit[0].end()):
                hit = (m, ('sentence', dict(m.groupdict(), kind=name)))
        if hit:
            m, (piece, data) = hit
            out.append({'piece': piece, 'text': m.group(0), 'at': pos,
                        'page': pages[pos], **data})
            pos = m.end()
            continue
        # Not a shape this reader knows, so it is a title -- but only if the
        # next thing is a sentence saying a bill was introduced. The text up to
        # that sentence is the title, however many printed lines it took.
        nxt = SENTENCES[0][1].search(text, pos)
        if nxt is None:
            out.append({'piece': 'unread', 'text': text[pos:].strip(),
                        'at': pos, 'page': pages[pos]})
            break
        title = text[pos:nxt.start()].strip()
        out.append({'piece': 'title', 'text': title, 'at': pos,
                    'page': pages[pos]})
        pos = nxt.start()
    return out


def entries(pieces):
    """Group the pieces into one entry per bill, under the heading it sits in.

    A note printed after a bill belongs to that bill: the fact sheets put the
    s.35 note directly after the bill it concerns and do not number it. A note
    printed before any bill in its section belongs to the section, which is how
    the excluded-section note arrives.
    """
    out, section, current, section_notes = [], None, None, []
    for p in pieces:
        if p['piece'] == 'heading':
            section, current = p['section'], None
            section_notes = []
        elif p['piece'] == 'title':
            current = {'section': section, 'title': p['text'], 'page': p['page'],
                       'sentences': [], 'section_notes': list(section_notes)}
            out.append(current)
        elif p['piece'] == 'sentence':
            if current is None:
                section_notes.append(p)
            else:
                current['sentences'].append(p)
        elif p['piece'] == 'unread':
            out.append({'section': section, 'unread': p['text'], 'page': p['page']})
    return out


def mend_title(s):
    """Repair what the printing did to a title, without touching raw_title.

    Session 6 prints two Act titles with the word 'Bill' left in from the title
    the bill carried before it passed -- 'Agriculture and Rural Communities
    (Scotland) Bill Act 2024 (asp 11)'. That is mended, and said in
    parser_note. A bracket opened and never closed is said and not mended,
    because where the missing one goes is a guess: the fact sheet prints
    'Scottish Parliament (Recall of Members Bill (SP Bill 55)' inside the
    rename sentence. The fact sheet's own words stay in raw_title either way.
    """
    notes = []
    mended = re.sub(r'\bBill Act\b', 'Act', s)
    if mended != s:
        notes.append("the fact sheet prints 'Bill Act' in the title, and the "
                     "word Bill is taken out")
    if mended.count('(') != mended.count(')'):
        notes.append('a bracket in this title is opened and never closed in '
                     'the fact sheet, and is left as printed')
    return mended, notes


def split_asp(s):
    """Separate the asp number from an Act title: 'Act 2024 (asp 10)'."""
    m = re.search(r'\s*\((?P<asp>asp\s*\d+)\)\s*$', s, re.I)
    if not m:
        return s, None
    asp = re.sub(r'asp\s*', 'asp ', m.group('asp'), flags=re.I).strip()
    title = s[:m.start()].strip()
    ym = re.search(r'\b(1[89]|20)\d{2}\b', title)
    return title, (f'{ym.group(0)} {asp}' if ym else asp)


def split_sp_bill(s):
    """Separate the SP Bill number from a title: '... Bill (SP Bill 73)'.

    Session 6 prints one of them '(SP 70)', with the word Bill missing, and
    that one is the European Charter Bill -- whose number 70 is the number it
    carried in Session 5, and which collides with Session 6's own SP Bill 70,
    the Ecocide Bill. Both forms are read, and the short form is said in
    parser_note, because the number is the identifier a reader would use to
    look the bill up and the two bills are not the same bill.
    """
    m = re.search(r'\s*\(SP (?:Bill )?(?P<n>\d+)\)\s*$', s)
    if not m:
        return s, None, []
    notes = []
    if 'SP Bill' not in m.group(0):
        notes.append(f"the fact sheet prints the number as '(SP {m.group('n')})' "
                     f"rather than '(SP Bill {m.group('n')})'")
    return s[:m.start()].strip(), m.group('n'), notes


def build(entry, session, path):
    """One staging line from one entry, in the CSV both readers write."""
    notes = []
    section = entry['section']
    by_kind = {}
    for s in entry['sentences']:
        by_kind.setdefault(s['kind'], []).append(s)
    intro = by_kind['introduced'][0]

    raw_title = entry['title']
    mended, n = mend_title(raw_title)
    notes.extend(n)
    rest, sp_bill, n = split_sp_bill(mended)
    notes.extend(n)
    title, asp = split_asp(rest)

    type_word = intro['type']
    if type_word not in TYPE_MAP:
        raise ValueError(f'a bill type this reader does not know: {type_word!r}')
    bill_type, stated = TYPE_MAP[type_word]

    # The title as introduced, where the fact sheet states one. The rename
    # sentence carries a date as well, and nothing in the schema holds a date
    # of renaming (docs/FACTSHEET-SURVEY.md §8), so the sentence's own words
    # are kept in parser_note below, as they are for every sentence.
    introduced_title = None
    if 'renamed' in by_kind:
        old, _, n = split_sp_bill(by_kind['renamed'][0]['old'])
        notes.extend(n)
        introduced_title = old
        notes.append('the fact sheet states the title as introduced and the '
                     'day the bill was renamed; nothing holds a date of '
                     'renaming, so it is in these words only')

    d_passed = parse_date(by_kind['passed'][0]['date']) if 'passed' in by_kind else None
    d_fell = parse_date(by_kind['fell'][0]['date']) if 'fell' in by_kind else None
    d_withdrawn = parse_date(by_kind['withdrawn'][0]['date']) if 'withdrawn' in by_kind else None
    d_assent = parse_date(by_kind['assent'][0]['date']) if 'assent' in by_kind else None

    outcome, enactment = SECTION_OUTCOME[section]
    if section == 'fallen':
        # SPICe says which bills fell and never why. The outcome is left for
        # review, and load_session.sql proposes fell_dissolution for a bill
        # that concluded on the day its session ended -- a comparison this
        # reader cannot make, because it sees one PDF and nothing else. See
        # db/051 and methodology note M7.
        notes.append('the fact sheet says the bill fell and not why; '
                     'outcome left for review')

    # The concluding date is the day the bill ended, and only a bill that
    # ended has one. A bill that passed has not ended: passing is not
    # concluding (db/020, methodology note M5).
    date_concluded = d_fell or d_withdrawn

    raw_footnote, d_blocked = None, None
    if 'section_35_note' in by_kind:
        note = by_kind['section_35_note'][0]
        raw_footnote = note['text']
        d_blocked = parse_date(note['date'])
        enactment = 'blocked'
        notes.append('the note printed under this bill says the UK Government '
                     'blocked it under section 35, so blocked, not pending; '
                     'which route and what followed are for review')

    procedure, d_procedure = None, None
    if 'procedure' in by_kind:
        p = by_kind['procedure'][0]
        procedure = p['procedure'].lower()
        d_procedure = parse_date(p['date'])
        notes.append('the fact sheet states how the bill was handled under the '
                     "Parliament's rules; see methodology note M10")

    if 'reconsideration_agreed' in by_kind or 'reconsideration_ended' in by_kind:
        notes.append('the fact sheet gives this bill a Reconsideration Stage, '
                     'with the day it was agreed and the day it ended; those '
                     'dates are in these words only and are not on the '
                     'stage-dates sheet')

    if section == 'withdrawn_from_earlier_session':
        notes.append('printed in a section of its own, as a bill of an earlier '
                     'session withdrawn during this one, and left out of this '
                     "fact sheet's own totals")

    if section == 'acts':
        if asp is None:
            title_kind = 'bill'
            notes.append('printed under Acts of the Scottish Parliament, but '
                         'the fact sheet prints the title the bill had and no '
                         'asp number, so both are empty and wait for review')
        else:
            title_kind = 'act'
            notes.append('title is the Act title, not the title as introduced')
    else:
        title_kind = 'bill'

    for n in entry.get('section_notes', []):
        notes.append(f'the section this bill is printed in says: "{n["text"]}"')

    words = ' '.join(s['text'] for s in entry['sentences'])
    notes.append(f'the fact sheet\'s words: "{words}"')

    return {
        'session_number': session,
        'raw_title': raw_title,
        'raw_type': f'{type_word} Bill',
        'raw_date_introduced': intro['date'],
        'raw_introduced_by': f"{intro['who']} MSP",
        'raw_date_final': (by_kind['withdrawn'][0]['date'] if d_withdrawn else
                           by_kind['fell'][0]['date'] if d_fell else
                           by_kind['passed'][0]['date'] if d_passed else None),
        'raw_date_royal_assent': by_kind['assent'][0]['date'] if d_assent else None,
        'raw_section': section,
        'sp_bill_id': sp_bill,
        'short_title': title,
        'title_as_introduced': introduced_title,
        'title_kind': title_kind,
        'bill_type': bill_type,
        'bill_type_stated': stated,
        'date_introduced': parse_date(intro['date']),
        'end_stage_3_date': d_passed,
        'date_concluded': date_concluded,
        'date_royal_assent': d_assent,
        'asp_number': asp,
        'outcome': outcome,
        'enactment_status': enactment,
        'date_assent_blocked': d_blocked,
        'raw_footnote': raw_footnote,
        'procedure': procedure,
        'date_procedure_agreed': d_procedure,
        'src_file': path.split('/')[-1],
        'src_page': entry['page'],
        'parser_note': '; '.join(notes) or None,
    }


def read(path, session):
    text, pages, starts, ends, summary = body_text(path)
    pieces = walk(text, pages, starts, ends)
    problems = []

    # Nothing may be left over. Every character of the body is inside a shape
    # this reader knows or inside a title, and this proves it by putting the
    # pieces back together and comparing them with the body they came from.
    rebuilt = ' '.join(p['text'] for p in pieces)
    if re.sub(r'\s+', ' ', rebuilt).strip() != re.sub(r'\s+', ' ', text[cover_end(text, starts, ends):]).strip():
        problems.append('the pieces do not put the document back together')
    for p in pieces:
        if p['piece'] == 'unread':
            problems.append(f'p{p["page"]}: nothing this reader knows: {p["text"][:200]!r}')

    rows = []
    for e in entries(pieces):
        if 'unread' in e:
            continue
        rows.append(build(e, session, path))
    for r in rows:
        if r['session_number'] != session:
            problems.append(f'{r["short_title"]!r} is not Session {session}')
    return rows, summary, problems


if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('pdf')
    ap.add_argument('--session', type=int, required=True)
    ap.add_argument('--csv')
    ap.add_argument('--strict', action=argparse.BooleanOptionalAction, default=True,
                    help='stop if anything in the document was not read (default)')
    a = ap.parse_args()
    rows, summary, problems = read(a.pdf, a.session)
    if problems and a.strict:
        print(json.dumps({'rows': len(rows), 'problems': problems}, indent=1))
        sys.exit(2)
    if a.csv:
        with open(a.csv, 'w', newline='') as f:
            w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
            w.writeheader()
            w.writerows(rows)
    print(json.dumps({'rows': len(rows), 'problems': problems,
                      'by_section': {s: sum(1 for r in rows if r['raw_section'] == s)
                                     for s in sorted({r['raw_section'] for r in rows})},
                      'summary': summary}, indent=1))
