#!/usr/bin/env python3
"""Check whether each cited address still gives its page.

Part of the refresh (strand 1, item 6; docs/STRAND-1-THE-REFRESH.md). Run on the
server by tools/refresh_copy.sh, before the copy is built. Reads the list of
kept pages, sources/kept-pages.csv, and writes one line per address for the
copy's cited_pages file: the address, its kept copy, the day it was kept, the
day it was checked, and whether it works.

An address works only if it returns the page on its own site. A dead
Parliament address does not say "not found": it forwards to the web archive's
browser check and reports success (found 18 September 2026). So an address
that ends anywhere else, or returns an error, or a "page not found" page, has
gone. The old site's archive cannot be read by a program, so its addresses are
"Not checked". Nothing here stops a refresh; the build decides what to refuse.

Polite: identifies itself, and leaves five seconds between two requests to the
same site, the crawl delay legislation.gov.uk asks for.

Usage:  python3 check_cited_addresses.py kept-pages.csv out.csv
"""
import csv, datetime, subprocess, sys, time
from urllib.parse import urlsplit

AGENT = 'legislativedata.org refresh (checking the addresses our provenance cites)'
DELAY = 5
NOT_CHECKABLE = {'webarchive.nrscotland.gov.uk'}


def check(url):
    r = subprocess.run(['curl', '-sL', '--max-time', '60', '-A', AGENT, '-o', '-',
                        '-w', '\n%{http_code} %{url_effective}', url], capture_output=True)
    body, _, tail = r.stdout.rpartition(b'\n')
    parts = tail.decode('utf-8', 'replace').split(' ', 1)
    if r.returncode != 0 or len(parts) != 2:
        return 'No'
    status, final = parts
    if status != '200' or urlsplit(final).hostname != urlsplit(url).hostname:
        return 'No'
    if b'page not found' in body[:20000].lower():
        return 'No'
    return 'Yes'


def main():
    manifest, out = sys.argv[1], sys.argv[2]
    with open(manifest, newline='') as f:
        rows = list(csv.DictReader(f))
    # The newest kept copy of each address.
    kept = {}
    for r in sorted(rows, key=lambda r: r['retrieved_on']):
        kept[r['address']] = r
    today = datetime.date.today().isoformat()
    last = {}
    results = []
    for url in sorted(kept):
        host = urlsplit(url).hostname
        if host in NOT_CHECKABLE:
            works = 'Not checked'
        else:
            wait = last.get(host, 0) + DELAY - time.time()
            if wait > 0:
                time.sleep(wait)
            works = check(url)
            last[host] = time.time()
        results.append({'address': url, 'kept_copy': kept[url]['kept_as'].split('/')[-1],
                        'date_kept': kept[url]['retrieved_on'],
                        'date_address_checked': today, 'address_works': works})
        print(f'{works:12} {url}', flush=True)
    with open(out, 'w', newline='') as f:
        w = csv.DictWriter(f, fieldnames=list(results[0]), lineterminator='\n')
        w.writeheader()
        w.writerows(results)
    counts = {k: sum(1 for r in results if r['address_works'] == k) for k in ('Yes', 'No', 'Not checked')}
    print(f"Checked {len(results)}: {counts['Yes']} work, {counts['No']} gone, "
          f"{counts['Not checked']} not checked.", flush=True)


if __name__ == '__main__':
    main()
