#!/usr/bin/env python3
"""Keep a copy of every outside page the provenance cites.

Strand 1, item 4 of docs/PHASE-2.md. Reads every web address cited in the
working database (bill, stage_event and field_source source_ref), and for each
one not already in sources/kept-pages.csv fetches it and saves it, byte for
byte as served, under sources/, following sources/README.md's naming. Each copy
is listed in sources/kept-pages.csv with its address, file, day retrieved and
fingerprint. Nothing is ever overwritten: a page fetched again later is a new
file under a new date.

It refuses to keep what is not the page: an error status, the archive's
"verifying your browser" screen, a PDF address that did not return a PDF, or a
parliament.scot "page not found" served with status 200 (sources/README.md,
"That path serves soft 404s"). Those are reported, not saved.

The old site's archive (webarchive.nrscotland.gov.uk) blocks scripted reading;
its pages are reported as needing a browser and are saved by hand, with the
owner's permission, then listed with --add.

Polite: identifies itself, and waits five seconds between requests, the
crawl delay legislation.gov.uk asks for.

Usage:
  python3 tools/keep_cited_pages.py --list          what is cited, and what is kept
  python3 tools/keep_cited_pages.py --fetch         fetch what is not yet kept
  python3 tools/keep_cited_pages.py --add URL FILE  list a copy saved by hand
"""
import argparse, csv, datetime, hashlib, pathlib, re, subprocess, sys, time

ROOT = pathlib.Path(__file__).resolve().parent.parent
SOURCES = ROOT / 'sources'
MANIFEST = SOURCES / 'kept-pages.csv'
CONNECT = pathlib.Path.home() / '.claude' / 'legdata-vps'
AGENT = 'legislativedata.org research (keeping the pages our provenance cites)'
DELAY = 5
FIELDS = ['address', 'kept_as', 'retrieved_on', 'content_type', 'bytes', 'sha256']

QUERY = r"""
SELECT DISTINCT u FROM (
  SELECT (regexp_matches(source_ref, 'https?://[^ ;,)]+', 'g'))[1] AS u FROM field_source
  UNION ALL SELECT (regexp_matches(source_ref, 'https?://[^ ;,)]+', 'g'))[1] FROM stage_event
  UNION ALL SELECT (regexp_matches(source_ref, 'https?://[^ ;,)]+', 'g'))[1] FROM bill) x
ORDER BY 1;
"""


def cited():
    r = subprocess.run([str(CONNECT), "sudo -u postgres psql -d legdata -At"],
                       input=QUERY, capture_output=True, text=True)
    if r.returncode != 0:
        sys.exit('Could not read the cited addresses: ' + r.stderr.strip())
    return [line for line in r.stdout.splitlines() if line.strip()]


def manifest():
    if not MANIFEST.exists():
        return []
    with MANIFEST.open(newline='') as f:
        return list(csv.DictReader(f))


def write_manifest(rows):
    rows = sorted(rows, key=lambda r: (r['address'], r['retrieved_on']))
    with MANIFEST.open('w', newline='') as f:
        w = csv.DictWriter(f, fieldnames=FIELDS, lineterminator='\n')
        w.writeheader()
        w.writerows(rows)


def slug(s):
    return re.sub(r'-+', '-', re.sub(r'[^a-z0-9]+', '-', s.lower())).strip('-')


def place(url, today, is_pdf):
    """Where a page is kept: its folder, and a name from its address."""
    ext = 'pdf' if is_pdf else 'html'
    m = re.match(r'https?://([^/]+)(/[^?#]*)?(\?[^#]*)?', url)
    host, path, query = m.group(1), m.group(2) or '', m.group(3) or ''
    if 'webarchive.nrscotland.gov.uk' in host:
        n = re.search(r'Bills/(\d+)\.aspx', url)
        return 'bill-pages', f'parliament-archive2021-bill-{n.group(1)}_retrieved-{today}.{ext}'
    if host == 'www.legislation.gov.uk':
        return 'legislation', f'legislation-{slug(path)}_retrieved-{today}.{ext}'
    if host == 'www.supremecourt.uk':
        return 'judgments', f'supremecourt-{slug(path)}_retrieved-{today}.{ext}'
    if host == 'www.parliament.scot' and '/bills-and-laws/bills/' in path:
        return 'bill-pages', f'parliament-bill-{slug(path.split("/bills-and-laws/bills/")[1])}_retrieved-{today}.{ext}'
    if host == 'www.parliament.scot' and 'OfficialReport' in path:
        n = re.search(r'meetingId=(\d+)', query)
        return 'official-report', f'parliament-official-report-meeting-{n.group(1)}_retrieved-{today}.{ext}'
    if host == 'www.parliament.scot' and '/official-report/' in path:
        day = re.search(r'meeting-of-parliament-([0-9-]+)', path).group(1)
        n = re.search(r'meeting=(\d+)', query)
        return 'official-report', f'parliament-official-report-{day}-meeting-{n.group(1)}_retrieved-{today}.{ext}'
    raise ValueError(f'No place for {url}: add a rule before keeping it.')


def fetch(url):
    # curl, not Python's own fetching, which on this Mac cannot verify the
    # sites' certificates. Follows redirects; fails on an error status.
    r = subprocess.run(['curl', '-sSL', '--fail', '--max-time', '60', '-A', AGENT,
                        '-w', '\n%{content_type}', url], capture_output=True)
    if r.returncode != 0:
        raise OSError(r.stderr.decode('utf-8', 'replace').strip())
    body, _, ctype = r.stdout.rpartition(b'\n')
    return 200, ctype.decode(), body


def refuse(url, ctype, body):
    """Why this is not the page, or None if it is."""
    head = body[:4000].decode('utf-8', 'replace').lower()
    if 'verifying your browser' in head or 'access denied' in head:
        return 'a browser check, not the page'
    wants_pdf = url.lower().endswith('.pdf') or 'OfficialReport?' in url
    if wants_pdf and not body.startswith(b'%PDF'):
        return f'expected a PDF, got {ctype}'
    if not wants_pdf and 'html' not in ctype:
        return f'expected a web page, got {ctype}'
    text = body.decode('utf-8', 'replace').lower()
    if not wants_pdf and ('page not found' in text[:20000] or '<title>404' in text):
        return 'a "page not found" served as a page'
    if len(body) < 5000:
        return f'only {len(body)} bytes'
    return None


def main():
    ap = argparse.ArgumentParser()
    g = ap.add_mutually_exclusive_group(required=True)
    g.add_argument('--list', action='store_true')
    g.add_argument('--fetch', action='store_true')
    g.add_argument('--add', nargs=2, metavar=('URL', 'FILE'))
    a = ap.parse_args()

    rows = manifest()
    kept = {r['address'] for r in rows}

    if a.add:
        url, file = a.add
        p = pathlib.Path(file).resolve()
        rel = p.relative_to(SOURCES)
        body = p.read_bytes()
        rows.append({'address': url, 'kept_as': str(rel),
                     'retrieved_on': re.search(r'_retrieved-(\d{4}-\d\d-\d\d)', p.name).group(1),
                     'content_type': 'application/pdf' if body.startswith(b'%PDF') else 'text/html',
                     'bytes': len(body), 'sha256': hashlib.sha256(body).hexdigest()})
        write_manifest(rows)
        print(f'listed {rel}')
        return

    urls = cited()
    todo = [u for u in urls if u not in kept]
    browser = [u for u in todo if 'webarchive.nrscotland.gov.uk' in u]
    todo = [u for u in todo if u not in browser]
    print(f'{len(urls)} addresses cited; {len(urls) - len(todo) - len(browser)} kept; '
          f'{len(todo)} to fetch; {len(browser)} need a browser.')
    if a.list:
        for u in todo:
            print('  to fetch  ', u)
        for u in browser:
            print('  browser   ', u)
        return

    today = datetime.date.today().isoformat()
    refused = []
    for i, url in enumerate(todo):
        if i:
            time.sleep(DELAY)
        try:
            status, ctype, body = fetch(url)
        except OSError as e:
            refused.append((url, str(e)))
            print(f'REFUSED {url}: {e}', flush=True)
            continue
        why = refuse(url, ctype, body)
        if why:
            refused.append((url, why))
            print(f'REFUSED {url}: {why}', flush=True)
            continue
        folder, name = place(url, today, body.startswith(b'%PDF'))
        target = SOURCES / folder / name
        if target.exists():
            refused.append((url, f'{target.name} already exists'))
            print(f'REFUSED {url}: {target.name} already exists', flush=True)
            continue
        target.parent.mkdir(exist_ok=True)
        target.write_bytes(body)
        rows.append({'address': url, 'kept_as': f'{folder}/{name}', 'retrieved_on': today,
                     'content_type': ctype, 'bytes': len(body),
                     'sha256': hashlib.sha256(body).hexdigest()})
        write_manifest(rows)
        print(f'kept {folder}/{name} ({len(body)} bytes)', flush=True)

    print(f'\nDone: {len(todo) - len(refused)} kept, {len(refused)} refused, '
          f'{len(browser)} need a browser.')
    for url, why in refused:
        print(f'  refused  {url}: {why}')


if __name__ == '__main__':
    main()
