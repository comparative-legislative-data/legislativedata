# Phase 1 — the style discussion, and what it starts from

Working document for Discussion 2 of Phase 1. The questions it has to answer are
in `docs/PHASE-1.md`; what gets settled goes to `DECISIONS.md`, and this file is
thrown away when the phase closes.

This is the record of what we looked at and what was read off it, so that
nothing here has to be derived twice.

## Where the starting point came from

The owner's own site, `essays.stevenmacgregor.uk`, looked at together on
15 September 2026. It is a side project of theirs — a workspace for developing a
piece of writing — and it is where "professional, not flashy" already exists in
a form values can be read off. A list of other people's sites was offered first
and rejected.

**The two projects share a starting point, not a dependency.** Both begin from
the same tokens; each is free to move; this site does not track changes made to
the other. Settled with the owner, 15 September.

## What is already there, and worth copying

**It is built on tokens, not on colours written into pages.** There is a
twelve-step warm neutral ramp, `--n1` to `--n12`, and a layer of names on top of
it that say what a thing is for rather than what colour it is: `--bg`,
`--surface`, `--raised`, `--border`, `--text`, `--text-muted`, `--text-strong`.
Nothing in the site refers to a hex value.

**Light mode redefines the twelve, and nothing else changes.** That is why
"dark by default, light as a setting" costs almost nothing here: the setting
switches one ramp for another and no page knows which mode it is in.

It also carries a `data-tone` attribute with warm, cool and plain variants of
the same ramp. Noted, not adopted; we have no need of three.

### The values, as observed on 15 September 2026

Dark, the default:

| Token | Value | Used for |
|---|---|---|
| `--bg` (`--n1`) | `#1a1816` | the page |
| `--surface` (`--n2`) | `#201e1b` | a panel on the page |
| `--raised` (`--n3`) | `#262320` | a card, a menu |
| `--border` (`--n5`) | `#37322d` | hairline rules |
| `--text-muted` (`--n8`) | `#8a8279` | metadata, helper lines |
| `--text` (`--n11`) | `#dfd9d1` | body text |
| `--text-strong` (`--n12`) | `#f4f0ea` | headings |

Light, the same ramp inverted and still warm: `#fdfcfb`, `#f8f7f5`, `#f2f0ec`,
`#e9e6e1`, `#ddd9d3`, `#c9c4bc`, `#a9a29a`, `#857e75`, `#6e6760`, `#57514b`,
`#3d3833`, `#241f1b`.

One accent, and only one: `#7ea8e8`, hover `#96b9ee`. It means "you can act
here" — links, the selected pill, the bar down the side of the important thing.
It is never decoration.

Corners: `3px` ordinary, `7px` for a menu. Spacing runs `.25 / .5 / .75 / 1rem`.
Type sizes are a short fixed set: 11, 12, 13, 14, 18 and 26px.

### Two typefaces doing two jobs

**IBM Plex Sans** for the machinery — navigation, labels, buttons, the small
grey metadata lines. **IBM Plex Serif** for the substance: on the essays site
the research question is set in serif at 18px and is instantly the most
important thing on the screen without being large or coloured.

Our equivalent is direct: sans for the site, serif for the bills.

### Devices worth taking

- **Hierarchy from colour and weight, not size.** Step labels are 11px uppercase
  in a mid grey. Actions are small underlined text links, not buttons.
- **Hairline rules between sections**, rather than a box around everything.
- **Empty states written as sentences**: "No parts yet. Most questions break
  into three or four."
- **A note saying what the screen does not do**, headed "What is not here yet."
  For a resource whose product is data with known gaps, this device is worth
  more to us than the colours are.

## What was settled

All of it is in `DECISIONS.md` under 15 September. In the order of the question
list in `PHASE-1.md`:

1. **Who the reader is, and the test.** Designed for someone who will cite it.
   Two questions every page must pass: could a reader see where this came from,
   when, and what we do not know, without asking us; and is anything here to
   impress rather than to inform.
2. **Type.** Plex Sans for the machinery, Plex Serif for the substance. 14px
   sans for navigation, labels, metadata and table cells; 17–18px serif for
   prose.
3. **Colour.** The accent means "you can act here" and never touches data. An
   outcome is a word, never a colour.
4. **Layout.** No left rail; one bar across the top. Prose in a reading column
   of about 700px; tables allowed out of it to full width.
5. **What this commits Phase 2 to.** Tables break the prose column. Charts get
   their own palette, never the accent, and export light even though the site is
   dark. Tested before Phase 2 by one page built locally and never deployed,
   carrying a real table of all the bills.
6. **The data date.** Footer of every page, and again beside the heading on any
   page showing data — because a footer date is cropped out of a screenshot.
7. **What the site is written with.** Caddy, gunicorn, Flask, Jinja, psycopg.
   No build step. **With the owner's condition:** "the stack does not support
   it" is never a reason to cut a feature.

Plus, from the same day: dark by default with light as a setting; colours as
named tokens; and a print stylesheet that prints dark on white.

## The state of the machine, 15 September 2026

Checked before the stack was chosen. Debian 13, Python 3.13.5, PostgreSQL 17
listening only to itself, fail2ban, unattended upgrades. **No Node and no web
server** — nothing was installed that favoured either option. 139GB free, 11GB
of memory.

## What this discussion did not settle

- The chart palette, which waits for Phase 2 and something to plot.
- The exact wording of any page. That is written when the page is built.
- Whether the interface ever needs a second accent. Nothing so far does.
