# Variables — first slice

Status: **proposed, awaiting review.** Nothing here is settled. The open
decisions in §5 need answering first, because the hand-build encodes whatever
is decided and changing it afterwards means re-entering data.

## 1. What the slice has to answer

1. Outcome by bill type, all sessions.
2. Time taken to complete each stage, by bill type and session.

Everything below exists to serve those two questions and nothing else. No
derived measure is stored: outcome-by-type is a cross-tab of §3.2, and every
duration is arithmetic over §3.3.

## 2. Shape

Three tables. `session` is a lookup, `bill` is one row per bill, `stage_event`
is one row per stage reached per bill.

    session ──< bill ──< stage_event

## 3. The variables

### 3.1 session

| Variable | Type | Definition | Notes |
|---|---|---|---|
| `session_number` | int, PK | 1–7 | |
| `date_first_meeting` | date | First meeting of the Parliament in that session | |
| `date_dissolution` | date | Dissolution before the next election | Null for the current session |
| `is_current` | bool | | Derivable, but stored so the current session is unambiguous while `date_dissolution` is null |

Session 7 is not published on the API. It is entered by hand — one row.

### 3.2 bill

| Variable | Type | Definition | Notes |
|---|---|---|---|
| `bill_id` | serial, PK | Our identifier | Ours, not the Parliament's |
| `sp_bill_id` | text, unique, null | The Parliament's identifier where one exists | Nullable on purpose; not every bill will have one we can trust |
| `session_number` | int, FK | Session in which the bill was introduced | See §6 on bills spanning sessions |
| `short_title` | text | Title as introduced | See §6 on titles changing during passage |
| `bill_type` | enum | **Who introduced it** — see §4.1 | |
| `procedure` | enum | **How it was handled** — see §4.2 | Separate from type; a Government Bill can take Emergency procedure |
| `date_introduced` | date | Date of introduction | |
| `outcome` | enum | What Parliament did with it — see §4.3 | |
| `date_outcome` | date | Date the outcome was determined | Same as the Stage 3 decision for a bill that passed or was defeated there |
| `enactment_status` | enum | Whether it became an Act — see §4.4 | Deliberately separate from `outcome` |
| `date_royal_assent` | date, null | | |
| `asp_number` | text, null | e.g. `2016 asp 8` | |
| `source` | text | Where this row's facts came from | See §7 |
| `source_ref` | text | Citable reference within that source | |
| `observed_at` | date | When the source was read | Matters because published data is revised |
| `note` | text, null | Free text for anything irregular | The edge-case record, written while building |

### 3.3 stage_event

One row per stage a bill actually reached. A bill that fell at Stage 1 has two
rows (Introduction, Stage 1), not five.

| Variable | Type | Definition | Notes |
|---|---|---|---|
| `stage_event_id` | serial, PK | | |
| `bill_id` | int, FK | | |
| `stage` | enum | See §4.5 | |
| `stage_order` | int | Position in the bill's own sequence | Lets Private Bills, with different stage names, be compared with public bills |
| `date_completed` | date, null | Date the stage was completed — see decision D2 | Null if reached but not completed |
| `completed` | bool | Whether the stage was completed | |
| `fell_here` | bool | Whether the bill ended at this stage | Exactly one true row per concluded bill that did not pass |
| `source`, `source_ref`, `observed_at`, `note` | | As §3.2 | |

**Durations are computed, never stored.** Introduction → Stage 1, Stage 1 →
Stage 2, Stage 2 → Stage 3, Introduction → passed, passed → Royal Assent.

## 4. Proposed vocabularies

These are the slice. Getting them wrong is the only way the slice can be wrong.

### 4.1 `bill_type` — who introduced it

`government`, `members`, `committee`, `private`, `hybrid`

Government Bills were called **Executive Bills** before 2007. Proposal: one
value, `government`, with the contemporary label reconstructable from the
session. Flag if you would rather keep them distinct.

Hybrid Bills arrived with a later rule change; the first session in which the
value is possible needs confirming.

### 4.2 `procedure` — how it was handled

`standard`, `emergency`, `budget`, `consolidation`, `statute_law_repeals`,
`statute_law_revision`

Kept apart from type because these are procedures under standing orders, not
categories of sponsor. An Emergency Bill is a Government Bill that compressed
its stages, and without the separation it either disappears into `government`
or wrongly leaves it.

This matters directly for slice 2: emergency and budget bills complete in days
and will otherwise distort every duration average. They should be flagged and
reported separately, not excluded.

### 4.3 `outcome` — what Parliament did

| Value | Meaning |
|---|---|
| `passed` | Passed at Stage 3 |
| `rejected_stage_1` | General principles not agreed to |
| `rejected_stage_3` | Defeated at the final vote |
| `withdrawn` | Withdrawn by the member in charge |
| `fell_dissolution` | Not concluded when the session ended |
| `fell_other` | Fell for another reason — record it in `note` |
| `in_progress` | Still before Parliament |

### 4.4 `enactment_status` — whether it became an Act

`enacted`, `not_enacted`, `pending`, `blocked`

Separate from `outcome` because passing and becoming law are not the same
event, and the gap between them is itself of research interest. A bill can pass
and be referred to the Supreme Court; a bill can pass and be prevented from
receiving assent. Collapsing the two would make those bills unfindable.

### 4.5 `stage`

Public bills: `introduction`, `stage_1`, `stage_2`, `stage_3`,
`reconsideration`, `royal_assent`

Private bills: `introduction`, `preliminary`, `consideration`, `final`,
`royal_assent`

Private Bills do not use the Stage 1/2/3 sequence, which is why `stage_order`
exists — it is what makes a cross-type duration comparison possible without
pretending the names match.

Open: whether the **financial resolution** is recorded as an event. It sits
between Stages 1 and 2 and can hold a bill up, so it may explain durations that
otherwise look anomalous. Proposal: not in this slice; revisit if the Stage 1 →
Stage 2 figures turn out to be unexplainable without it.

## 5. Open decisions

**D1 — Is the outcome/enactment split right?** §4.3 and §4.4 propose two
variables. The alternative is a single outcome list with values like
`passed_not_enacted`. Two is more faithful; one is easier to cross-tab. This is
the central decision in the slice.

**D2 — What date completes a stage?** For Stage 1 the candidates are the lead
committee's report, the chamber debate, or the decision on the general
principles. They give materially different durations. Proposal: **the date of
the formal decision that completed the stage**, because it is the only anchor
that exists for every stage and every bill type. Whatever is chosen has to hold
across all seven sessions.

**D3 — Calendar days or sitting days?** Recess makes calendar days misleading,
and standing orders count some minimum intervals in sitting days. Calendar days
need nothing extra; sitting days need a parliamentary calendar, which is its
own slice. Proposal: store dates only, report calendar days now, and add
sitting days later as a computed alternative once a calendar table exists.

**D4 — Type and procedure as separate variables?** §4.1 and §4.2. Separating
them is more accurate and makes both slices harder to read at a glance.

**D5 — How are revisions recorded?** Published data changes. The minimum here
is `observed_at` on every row. The fuller version keeps superseded values so
that a change is visible rather than silent. Proposal: `observed_at` now,
append-only history before any automation runs, since automation is what will
generate revisions at volume.

## 6. Edge cases to expect

Recorded now so the hand-build can confirm or dismiss them, and so extraction is
later measured against them.

- **Session 7 absent from the API.** Entered by hand.
- **No outcome field exists.** Every outcome value in §4.3 is derived from what
  happened at the last stage, not read from a field. This is the slice's main
  piece of judgement.
- **Law officer bills carry no member.** Does not affect this slice, which has
  no member variable — but it will affect the next one.
- **Truncated and duplicated records** in API responses.
- **Titles change during passage.** `short_title` is the title as introduced;
  decide whether the title at passage is also needed.
- **Bills reintroduced in a later session** are separate bills here, related
  only by note until there is a reason for a formal link.
- **Private Bills** have their own stages, promoters rather than members, and
  will not fit assumptions built from public bills.
- **Reconsideration Stage** breaks the assumption that Stage 3 is the end.

## 7. Provenance

Row-level, not cell-level: `source`, `source_ref`, `observed_at`, `note`.
Cell-level provenance is the right answer for contested fields and the wrong
answer for a day of typing. Where a single value in a row came from somewhere
else, that goes in `note` until there is enough of it to justify the heavier
structure.

`source` values in this slice are expected to be: `api`, `official_report`,
`bill_document`, `phd`, `manual`.
