#!/usr/bin/env python3
"""Turn the owner's PhD dataset into stage-dates rows for one or more sessions.

The dataset is one line per bill: Session, Type, Name, Introduction date,
Stage 1 vote, Stage 2 completed, Stage 3 vote, Royal Assent. It is not in this
repository (DECISIONS.md, 2026-09-11); its name and fingerprint are recorded
there, and this script prints the fingerprint of the file it read.

What it writes, as a CSV for tools/load_phd_stage_dates.sql, turns on what
happened to the bill:

  - A bill that reached Stage 3 -- whether it passed there or was rejected
    there -- completed the two stages before it, so its first and second stage
    are written, completed, on the dataset's dates, under the names that bill
    type uses.
  - A bill that ended before Stage 3 has the stage it ended at recorded from
    the source that says so, not from the dataset: the Official Report where
    the Parliament decided, and the Parliament's own bill page where it did
    not. Nothing is written for it here. For Sessions 1 and 2 those answers are
    in ANSWERS below, which is how those sessions got them; from Session 3 on
    they are on the stage-dates sheet already, and this script checks that they
    are rather than assuming it.
  - For the Session 2 Robin Rigg Act: a note for the bill, not a stage row.

  Where a stage is already held from another source and the dataset also dates
  it, the dataset's date is not written -- the Official Report and the bill
  page come first -- but the two are compared, and a disagreement stops the
  run. That is what turned up the Autism Bill's Stage 1 date on 13 September.

Bills are matched to staging lines on session, tidied name and introduction
date. Pairs that differ in wording enough to need naming are listed in
MANUAL_PAIRS. The script refuses to write anything unless every bill in the
sessions asked for matches one to one.

Usage:  python3 tools/phd_stage_dates.py [XLSX] --sessions 3 --csv OUT.csv
"""
import argparse, csv, datetime, hashlib, pathlib, re, subprocess, sys, unicodedata

ROOT = pathlib.Path(__file__).resolve().parent.parent
CONNECT = pathlib.Path.home() / '.claude' / 'legdata-vps'
DEFAULT_XLSX = ROOT / 'sources' / 'phd' / 'Billdates-September2026.xlsx'
# When the dataset was read for each session's bills. Kept here rather than
# typed on the command line, for the reason the fact sheet reader takes nothing
# but the PDF and the session number: a date supplied each run is a date
# recorded nowhere. Session 3's is later because the dataset was corrected on
# 13 September (DECISIONS.md, the Autism Bill's Stage 1 date).
READ_ON = {1: '2026-09-11', 2: '2026-09-11', 3: '2026-09-13'}

# Staging line -> row of the dataset, where the names differ too much to match.
# Each was confirmed on 2026-09-11 by the dates the two sources share: the
# introduction, passing and Royal Assent dates all agree unless noted in
# DECISIONS.md. The factsheet's wording comes first, the dataset's second.
MANUAL_PAIRS = {
    2: 4,      # Abolition of Poindings and Warrant Sales Act 2001 / ... (Scotland) Act 2001
    5: 18,     # Bail, Judicial Appointments etc. / Bail and Judicial Appointments etc
    21: 23,    # Education (Graduate Endowment and Student Support) (Scotland) Act 2001 / ... (No.2) Act 2001
    23: 34,    # Erskine Bridge Tolls Act 2001 / Erskine Bridge Tolls (Scotland) Act 2001
    24: 10,    # Ethical Standards in Public Life etc. (Scotland) / without "etc."
    34: 65,    # Mental Health (Care & Treatment) / (Care and Treatment)
    53: 44,    # Scottish Public Services Ombudsman Act 2002 / ... (Scotland) Act 2002
    55: 12,    # Sea Fisheries (Shellfish) Amendment / (Shellfish) (Amendment)
    83: 155,   # Budget (Scotland) Act 2007 / Budget (Scotland) (No4) Act 2007
    94: 91,    # Edinburgh Tram (Line One) / (Line 1)
    95: 92,    # Edinburgh Tram (Line Two) / (Line 2)
    98: 95,    # Emergency Workers (Scotland) Act 2005 / "Government Workers", a slip in the dataset
    113: 113,  # Management of Offenders etc. (Scotland) / without "etc."
    116: 125,  # Planning etc. (Scotland) Act 2006 / Planning (Scotland) Act 2006
    131: 115,  # St Andrew's Bank Holiday (Scotland) Act 2007 / St Andrew's Day Bank Holiday ...
    148: 145,  # Commissioner for Older People / "Commisioner", a slip in the dataset
    150: 148,  # Education (School Meals etc) / (Schools Meals etc.)
    153: 152,  # Provision of Rail Passenger Services (Scotland) Bill / without (Scotland)
    # Session 4, confirmed on 2026-09-13 the same way: every pair below agrees
    # on both dates the two sources share, introduction and Royal Assent.
    # The four Budget Acts are the Session 2 pattern again (line 83 above): the
    # fact sheet gives the Act's short title, the dataset numbers them within
    # the session.
    227: 239,  # Budget (Scotland) Act 2013 / Budget (Scotland) (No.2) Act 2013
    228: 262,  # Budget (Scotland) Act 2014 / Budget (No.3) (Scotland) Act 2014
    229: 276,  # Budget (Scotland) Act 2015 / Budget (Scotland) (No.4) Act 2015
    230: 303,  # Budget (Scotland) Act 2016 / Budget (Scotland) (No.5) Act 2016
    249: 231,  # Freedom of Information (Amendment) (Scotland) / (Scotland) (Amendment)
    257: 280,  # Inquiries into Fatal Accidents and Sudden Deaths etc. / without "etc."
    260: 302,  # Land and Buildings Transaction Tax (Amendment) (Scotland) Act 2016 /
               # "(Amendment) Scotland)", a missing bracket in the dataset
    301: 284,  # Pentland Hills Regional Park Boundary Bill / "Boundaries"
}

# What the owner established on 2026-09-11 for the bills that did not pass, with
# the page each answer came from. DECISIONS.md holds the same table in words.
#   stopped_at: position in the bill type's sequence where the bill stopped
#   completed:  stages completed before that, as (position, date, source, ref)
PARLIAMENT = 'https://www.parliament.scot/bills-and-laws/bills/'
ARCHIVE = 'https://webarchive.nrscotland.gov.uk/public/+/'
ARCHIVE_BILL = ARCHIVE + 'archive2021.parliament.scot/parliamentarybusiness/Bills/'
# The note here is the DETAIL note: what a source records beyond what the row
# itself says. The general note -- 'The bill stopped at this stage without a
# decision, so no date is recorded.' -- is not written by anybody; the clean
# sheet works it out from the row. None means no extra detail was collected
# for that bill. See db/061.
ANSWERS = {
    63: dict(stopped_at=1, source='official_report',
             ref='https://www.parliament.scot/api/sitecore/CustomMedia/OfficialReport?meetingId=2733',
             note='Withdrawn during Stage 1 consideration, before the Stage 1 vote, and reintroduced in redrafted form.'),
    64: dict(stopped_at=1, source='bill_document',
             ref=PARLIAMENT + 's1/family-homes-and-homelessness-scotland-bill',
             note=None),
    65: dict(stopped_at=1, source='bill_document',
             ref=PARLIAMENT + 's1/tobacco-advertising-and-promotion-scotland-bill',
             note='No Stage 1 debate took place, so the dataset’s Stage 1 date is not a completed stage.'),
    66: dict(stopped_at=2, source='official_report',
             ref='https://www.parliament.scot/chamber-and-committees/official-report/search-what-was-said-in-parliament/meeting-of-parliament-06-03-2003?meeting=4434&iob=31842',
             note='The general principles were agreed at Stage 1 on 6 March 2003, but no Stage 2 '
                  'proceedings were scheduled for the bill, and it fell at the end of the session.',
             completed=[(1, datetime.date(2003, 3, 6), 'official_report',
                         'https://www.parliament.scot/chamber-and-committees/official-report/search-what-was-said-in-parliament/meeting-of-parliament-06-03-2003?meeting=4434&iob=31842',
                         None)]),
    71: dict(stopped_at=3, source='bill_document',
             ref=PARLIAMENT + 's1/robin-rigg-offshore-wind-farm-navigation-and-fishing-scotland-bill-session-1',
             note=None,
             completed=[(1, datetime.date(2003, 1, 9), 'phd', None, None),
                        (2, datetime.date(2003, 3, 11), 'phd', None, None)]),
    73: dict(stopped_at=1, source='bill_document',
             ref=PARLIAMENT + 's1/stirling-alloa-kincardine-railway-and-linked-improvements-bill-session-1',
             note=None),
    140: dict(stopped_at=1, source='bill_document',
              ref=ARCHIVE + 'http://archive2021.parliament.scot/parliamentarybusiness/Bills/25259.aspx',
              note='Withdrawn after the Stage 1 report and before the Stage 1 debate.'),
    141: dict(stopped_at=1, source='bill_document',
              ref=PARLIAMENT + 's2/fire-sprinklers-in-residential-premises-scotland-bill',
              note=None),
    142: dict(stopped_at=1, source='bill_document',
              ref=PARLIAMENT + 's2/prohibition-of-smoking-in-regulated-areas-scotland-bill',
              note=None),
    143: dict(stopped_at=1, source='bill_document',
              ref=PARLIAMENT + 's2/prostitution-tolerance-zones-scotland-bill',
              note=None),
    144: dict(stopped_at=1, source='bill_document', ref=ARCHIVE_BILL + '25122.aspx',
              note='Withdrawn before the Stage 1 debate.'),
    148: dict(stopped_at=1, source='bill_document', ref=ARCHIVE_BILL + '25503.aspx',
              note='No timetable for concluding Stage 1 was set.'),
    150: dict(stopped_at=1, source='bill_document', ref=ARCHIVE_BILL + '25277.aspx',
              note='Partial scrutiny was undertaken, with no Stage 1 vote.'),
    152: dict(stopped_at=1, source='bill_document', ref=ARCHIVE_BILL + '25312.aspx',
              note=None),
    154: dict(stopped_at=1, source='bill_document', ref=ARCHIVE_BILL + '25100.aspx',
              note=None),
}

# A bill that passed with no stage dates in the dataset: a note for the bill,
# not a stage row.
BILL_NOTES = {
    124: 'Reintroduced in Session 2 after falling at dissolution. A reintroduced Private Bill does not repeat its earlier scrutiny, so this bill went straight to the Final Stage vote and has no Preliminary or Consideration Stage of its own. The Session 1 bill’s Preliminary Stage was on 9 January 2003. Source: '
         + ARCHIVE + 'http://archive2021.parliament.scot/parliamentarybusiness/Bills/24953.aspx',
}

TYPES = {'Government': 'government', 'Members': 'members', 'Private': 'private',
         'Committee': 'committee', 'Hybrid': 'hybrid'}


def tidy(title):
    """A title reduced to what two sources should agree on."""
    if not title:
        return ''
    t = unicodedata.normalize('NFKC', title).lower()
    t = t.replace('’', "'").replace('‘', "'").replace('–', '-').replace('—', '-')
    t = re.sub(r'\s*-\s*', '-', t)
    t = re.sub(r'\b(act|bill)\b\s*\d{0,4}\)?\s*$', '', t.strip())
    t = t.replace('(scotland )', '(scotland)')
    t = re.sub(r'[^a-z0-9()\'-]+', ' ', t)
    return re.sub(r'\s+', ' ', t).strip()


def psql_csv(query):
    r = subprocess.run([str(CONNECT), f'sudo -u postgres psql -d legdata -c "{query}"'],
                       check=True, capture_output=True, text=True)
    return list(csv.reader(r.stdout.splitlines()))


def our_bills(sessions):
    """The named sessions from the staging sheet, and the stage names per type."""
    wanted = ', '.join(str(s) for s in sessions)
    rows = psql_csv(
        "\\copy (SELECT c.candidate_id, c.session_number, c.short_title, "
        "coalesce(c.title_as_introduced, ''), c.bill_type, c.date_introduced, c.outcome, "
        "coalesce(c.review_note, ''), "
        "(SELECT s.stage FROM ref_bill_type_stage s WHERE s.bill_type = c.bill_type AND s.stage_order = 1), "
        "(SELECT s.stage FROM ref_bill_type_stage s WHERE s.bill_type = c.bill_type AND s.stage_order = 2), "
        "(SELECT s.stage FROM ref_bill_type_stage s WHERE s.bill_type = c.bill_type AND s.stage_order = 3) "
        f"FROM bill_candidate c WHERE c.session_number IN ({wanted}) ORDER BY 1) TO STDOUT WITH (FORMAT csv)")
    bills = {}
    for row in rows:
        (line, session, short_title, as_introduced, bill_type, introduced, outcome,
         review_note, s1, s2, s3) = row
        bills[int(line)] = dict(line=int(line), session=int(session), short_title=short_title,
                                as_introduced=as_introduced, bill_type=bill_type,
                                introduced=datetime.date.fromisoformat(introduced) if introduced else None,
                                outcome=outcome, review_note=review_note,
                                stages={1: s1, 2: s2, 3: s3}, held={}, held_any=set(),
                                ended_at=None)
    # What the stage-dates sheet already holds for those lines: which stages it
    # has at all, which of them come from a source that outranks the dataset,
    # and the stage a bill ended at. All three are why a bill can need nothing
    # written for it here.
    for line, order, date, source, fell_here in psql_csv(
            "\\copy (SELECT s.candidate_id, s.stage_order, coalesce(s.date_completed::text, ''), "
            "s.source, s.fell_here FROM stage_candidate s JOIN bill_candidate c USING (candidate_id) "
            f"WHERE c.session_number IN ({wanted}) ORDER BY 1, 2) TO STDOUT WITH (FORMAT csv)"):
        b = bills.get(int(line))
        if b is None:
            continue
        b['held_any'].add(int(order))
        if source != 'phd':
            b['held'][int(order)] = (datetime.date.fromisoformat(date) if date else None, source)
        if fell_here == 't':
            b['ended_at'] = int(order)
    return bills


def dataset(path, sessions):
    import openpyxl
    ws = openpyxl.load_workbook(path, data_only=True)['Dates']
    d = lambda v: v.date() if isinstance(v, datetime.datetime) else None
    rows = []
    for i, r in enumerate(ws.iter_rows(min_row=2, values_only=True), 2):
        if all(v is None for v in r):
            continue
        if r[0] in sessions:
            rows.append(dict(xrow=i, session=r[0], type=r[1], name=r[2], introduced=d(r[3]),
                             s1=d(r[4]), s2=d(r[5]), s3=d(r[6])))
    return rows


def match(bills, phd):
    """One dataset row per staging line, or an explanation of why not."""
    pairs, problems, taken = {}, [], {}
    by_xrow = {p['xrow']: p for p in phd}
    for line, xrow in MANUAL_PAIRS.items():
        if line not in bills:
            continue                  # a pair for a session this run is not about
        if xrow not in by_xrow:
            problems.append(f'line {line}: named row {xrow} of the dataset is not a row of the sessions asked for')
            continue
        pairs[line], taken[xrow] = by_xrow[xrow], line
    for p in phd:
        if p['xrow'] in taken:
            continue
        hits = [b for b in bills.values()
                if b['session'] == p['session'] and b['line'] not in pairs
                and tidy(p['name']) in (tidy(b['short_title']), tidy(b['as_introduced']))]
        if len(hits) > 1:
            hits = [b for b in hits if b['introduced'] == p['introduced']] or hits
        if len(hits) != 1:
            problems.append(f"dataset row {p['xrow']} {p['name']!r} matched {len(hits)} staging lines")
            continue
        if TYPES.get(p['type']) != hits[0]['bill_type']:
            # A type disagreement is a research question, not a pairing failure:
            # tools/compare_sources.py records it and the owner adjudicates it.
            # Once the line carries that adjudication, the pairing stands and the
            # dates can be loaded; until then this refuses, because attaching one
            # bill's stage dates to another is the harm being guarded against.
            if 'Checked: bill_type = ' not in hits[0]['review_note']:
                problems.append(
                    f"dataset row {p['xrow']} {p['name']!r} is a {p['type']} bill, line "
                    f"{hits[0]['line']} is {hits[0]['bill_type']}. Run "
                    f"tools/compare_sources.py, and have the owner adjudicate it")
                continue
        pairs[hits[0]['line']], taken[p['xrow']] = p, hits[0]['line']
    for line in bills:
        if line not in pairs:
            problems.append(f"line {line} {bills[line]['short_title']!r} has no row in the dataset")
    return pairs, problems


def rows_for(bills, pairs):
    """The stage-dates rows, and the notes for bills, as the loader wants them."""
    out, problems = [], []

    def stage_row(b, position, date, completed, stopped_here, source, ref, note):
        out.append(dict(kind='stage', line=b['line'], short_title=b['short_title'],
                        stage=b['stages'][position], stage_order=position,
                        date_completed=date.isoformat() if date else '',
                        completed='true' if completed else 'false',
                        fell_here='true' if stopped_here else 'false',
                        source=source, source_ref=ref, observed_at=READ_ON[b['session']],
                        detail_note=note or ''))

    for line, b in sorted(bills.items()):
        p = pairs[line]
        phd_ref = f"PhD thesis dataset, row {p['xrow']}"
        if line in BILL_NOTES:
            out.append(dict(kind='bill_note', line=line, short_title=b['short_title'], stage='',
                            stage_order='', date_completed='', completed='', fell_here='',
                            source='bill_document', source_ref='',
                            observed_at=READ_ON[b['session']], detail_note=BILL_NOTES[line]))
            continue
        def disagreement(position, date):
            """The dataset dating a stage another source already dates.

            The other source is kept -- the Official Report and the bill page
            both outrank the dataset -- but a disagreement is not passed over
            in silence. The Autism Bill's Stage 1 was four days out and nothing
            else would have caught it.
            """
            held = b['held'].get(position)
            if held and date and held[0] and date != held[0]:
                problems.append(
                    f"line {line} {b['short_title']!r}: the dataset dates stage {position} "
                    f"{date}, and {held[1]} dates it {held[0]}. Settle it before loading")
            return held is not None

        # A bill that reached Stage 3, whether it passed there or was rejected
        # there, completed the two stages before it.
        if b['outcome'] in ('passed', 'rejected_stage_3'):
            for position, date in ((1, p['s1']), (2, p['s2'])):
                if disagreement(position, date):
                    continue
                if date is None:
                    problems.append(f"line {line} {b['short_title']!r} reached Stage 3 but the dataset has no stage {position} date")
                    continue
                if b['introduced'] and date < b['introduced']:
                    problems.append(f"line {line} {b['short_title']!r}: stage {position} dated {date}, before it was introduced on {b['introduced']}")
                stage_row(b, position, date, True, False, 'phd', phd_ref, None)
            continue

        # The bill ended before Stage 3. Where it ended is recorded from the
        # source that says so, never from the dataset; the dataset is only
        # checked against what is already held.
        for position, date in ((1, p['s1']), (2, p['s2'])):
            disagreement(position, date)
            # A date for a stage the sheet does not have at all, on a bill that
            # never reached Stage 3, says the two disagree about how far the
            # bill got. That is a question about the bill, not a date to load.
            if date and position not in b['held_any'] and line not in ANSWERS:
                problems.append(
                    f"line {line} {b['short_title']!r} ended before Stage 3, and the dataset "
                    f"dates stage {position} {date} -- a stage nothing on the stage-dates "
                    f"sheet says it completed. Settle it before loading")
        a = ANSWERS.get(line)
        if a:
            for position, date, source, ref, note in a.get('completed', []):
                stage_row(b, position, date, True, False, source, ref or phd_ref, note)
            stage_row(b, a['stopped_at'], None, False, True, a['source'], a['ref'], a['note'])
            continue
        if b['ended_at'] is None and not b['held']:
            problems.append(
                f"line {line} {b['short_title']!r} ended before Stage 3, and neither this "
                f"script nor the stage-dates sheet says where. Record it before loading")
    return out, problems


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('xlsx', nargs='?', default=str(DEFAULT_XLSX))
    ap.add_argument('--sessions', default='1,2',
                    help='which sessions to write, comma separated (default 1,2)')
    ap.add_argument('--csv', required=True)
    args = ap.parse_args()

    sessions = sorted({int(s) for s in args.sessions.split(',') if s.strip()})
    if not sessions:
        sys.exit('Refusing to run: no session named.')
    missing = [s for s in sessions if s not in READ_ON]
    if missing:
        sys.exit('Refusing to run: no reading date recorded in READ_ON for Session(s) '
                 + ', '.join(str(s) for s in missing) + '. Record when the dataset was read.')

    path = pathlib.Path(args.xlsx)
    print(f'read {path}')
    print(f'sha256 {hashlib.sha256(path.read_bytes()).hexdigest()}')

    bills, phd = our_bills(sessions), dataset(path, sessions)
    named = ', '.join(str(s) for s in sessions)
    print(f'{len(bills)} staging lines, {len(phd)} dataset rows for Session(s) {named}')
    pairs, problems = match(bills, phd)
    if problems:
        sys.exit('Refusing to write:\n  ' + '\n  '.join(problems))
    named_here = sum(1 for line in MANUAL_PAIRS if line in bills)
    print(f'every line matched one dataset row ({named_here} of them named in this script)')

    # A pair whose introduction dates disagree is not wrong in itself, but it is
    # the shape a wrong pairing would take, so it is always shown.
    for line, p in sorted(pairs.items()):
        if p['introduced'] != bills[line]['introduced']:
            print(f"  introduction dates differ: line {line} {bills[line]['short_title']!r} "
                  f"{bills[line]['introduced']} / dataset row {p['xrow']} {p['introduced']}")

    rows, problems = rows_for(bills, pairs)
    if problems:
        sys.exit('Refusing to write:\n  ' + '\n  '.join(problems))

    fields = ['kind', 'line', 'short_title', 'stage', 'stage_order', 'date_completed',
              'completed', 'fell_here', 'source', 'source_ref', 'observed_at', 'detail_note']
    with open(args.csv, 'w', newline='') as f:
        w = csv.DictWriter(f, fields)
        w.writeheader()
        w.writerows(rows)

    stages = [r for r in rows if r['kind'] == 'stage']
    print(f"wrote {args.csv}: {len(stages)} stage rows and {len(rows) - len(stages)} note(s)")
    for source in sorted({r['source'] for r in stages}):
        done = [r for r in stages if r['source'] == source]
        print(f"  {source}: {len(done)} rows, "
              f"{sum(1 for r in done if r['completed'] == 'true')} completed, "
              f"{sum(1 for r in done if r['fell_here'] == 'true')} where the bill stopped")


if __name__ == '__main__':
    main()
