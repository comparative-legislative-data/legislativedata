# The source's own words

18 September 2026. The `sources` file has a heading, `value_as_the_source_gave_it`,
that promises the source's own words, and M8 tells a reader it holds "the value
in the source's own words". Of the 192 lines, 38 do that. The rest don't. This
file shows every line by group first, and then makes a proposal. **Agreed by
the owner on 18 September and built as `db/116`**, with the promotion script
changed to match. The tables at the end show the lines as they were before.

| Group | Lines | What the heading holds |
|---|---|---|
| 1 | 91 | **Our value, repeated.** Exactly what the cell already says, in our format: `2021-03-30`, `stage_3`, `enacted`, `emergency`, `hybrid`. |
| 2 | 31 | **Our account of an Official Report decision**, sometimes quoting the Official Report. Seven start with a working phrase that should have been cut. |
| 3 | 38 | **The source's own words**, as promised: the fact sheets' footnotes, the Presiding Officer's announcements, titles as the Session 6 fact sheet printed them. |
| 4 | 32 | **Empty.** Our coding, or a later fact sheet's change, where no single wording carries it. |

---

## Group 1: our value, repeated, 91 lines

Every one of these is the same as the cell it is about. Nobody recorded what the
source printed; the reviewer recorded what they made of it, which is the value
the cell holds. For titles and Act numbers the two may well be the same words,
but for dates, codes and stages they cannot be: legislation.gov.uk does not print
`2021-03-30`, and no bill page says `stage_3`. 78 come from three places in the
promotion script: a value checked at review (the "Checked:" line on the staging
sheet), a procedure read off the Session 6 and 7 fact sheets, and the corrected
title. The other 13 are the sessions' first and last days, which were entered
by a migration and no script rewrites.

## Group 2: the Official Report outcomes, 31 lines

What these hold is our account: what happened, on which day, and on whose
motion. Some then quote the Official Report ("Result as recorded: ..."). The 14
from Sessions 1 to 3 quote nothing. The account is useful. It is just not the
source's words, and nothing marks where our words stop and the Official
Report's begin, apart from the quotation marks.

**A fault, separate from the question.** All seven from Session 6 begin
"Outcome from the Official Report, not the fact sheet:". That is the review
note's opening phrase, which promotion is meant to cut. It looks for
"factsheet", and Session 6's reviews spelled it "fact sheet". Whatever is
decided below, the phrase goes and the script accepts both spellings.

## Group 3: the source's own words, 38 lines

Fine as they are: nine fact sheet footnotes on the bills stopped before Royal
Assent, 27 Presiding Officer's announcements on how a bill was rejected at
Stage 1, and the two titles as the Session 6 fact sheet printed them.

## Group 4: empty, 32 lines

Fine as they are, and consistent with what the column description says an empty
cell means.

---

## Proposal

**1. Group 1: empty the 91.** A value that only repeats the cell tells a reader
nothing, and it claims to be the source's words when it is not. The rule would
be: *the source's own words, where they say something the cell does not; empty
where the cell already says it, or where no one wording carries it.* A reader
loses nothing: the source, where in it, and the day we read it all stay on the
line. The alternative, going back to 91 pages to copy what each printed, costs
a session of reading for words that would say the same thing as the cell.

**2. Group 2: split each one.** The heading keeps only what the Official Report
printed: each quoted passage, word for word, in order. Our account moves to the
line's `note`, where our words belong. The 14 with no quotation end up with an
empty heading and the account in the note. The alternative is to leave them
alone and have the heading's definition say that, for an Official Report
outcome, it holds our account with the source quoted. That is less work, but
the heading would then mean two things.

**3. The seven prefixes go, in either case.**

### The whole of it, as the checklist asks

- **What it records**: the source's own words where they add to the cell;
  otherwise empty.
- **Which lines, and what empty means**: all 192. Empty means the cell already
  says it, or the fact is our coding.
- **Where it sits on the clean sheet**: unchanged; the same column.
- **How it arrives on staging**: unchanged. The "Checked:" lines and the
  Official Report review notes stay as they are.
- **How promotion carries it**: the script stops copying the checked value, the
  procedure and the corrected title into this column. For an Official Report
  outcome it writes the quoted passages here and the account in the note, and it
  cuts the opening phrase whichever way "fact sheet" is spelled.
- **What the error checker requires**: nothing new. It asks nothing of this
  column now.
- **What the methodology note tells a reader**: M8's sentence is already true
  once this is done, so no change. The column's own description is rewritten to
  the rule above.
- **Every line already coded**: all 192 are rewritten at once by the migration,
  and the same rebuild rehearsal as `db/115` proves the script writes the same.
- **When it is built**: now, before the published copy.

**One side effect.** `v_field_revisions`, the list of facts whose recorded value
has changed between readings, counts different values in this column. Emptying
group 1 means it can't see a change there. It is empty today, and this column
has been replaced, not added to, since `db/098`, so the list already can't do
its job. Recorded here, not opened.

---

## Every line, by group

### Group 1 rows: the cell's value repeated

| Heading | Source | Lines | What it holds, e.g. |
|---|---|---|---|
| asp_number | legislation_gov_uk | 11 | 2011 asp 15, 2016 asp 15, 2021 asp 1 |
| bill_type | bill_page | 1 | hybrid |
| date_assent_blocked | supreme_court | 1 | 2018-12-13 |
| date_completed | bill_page | 1 | 2000-03-29 |
| date_first_meeting | spice_factsheet_dates | 7 | 1999-05-12, 2003-05-07, 2007-05-09 |
| date_introduced | bill_page | 7 | 2001-04-04, 2001-09-26, 2002-06-27 |
| date_introduced | manual | 1 | 2015-06-25 |
| date_procedure_agreed | spice_factsheet_legislation | 5 | 2021-06-22, 2022-10-04, 2024-05-15 |
| date_royal_assent | legislation_gov_uk | 22 | 2000-05-09, 2001-01-25, 2001-11-06 |
| date_session_end | spice_factsheet_dates | 6 | 2003-03-31, 2007-04-02, 2011-03-22 |
| enactment_status | legislation_gov_uk | 7 | enacted |
| procedure | spice_factsheet_legislation | 5 | emergency |
| short_title | legislation_gov_uk | 12 | Building Safety Levy (Scotland) Act 2026, Children (Care, Care Experience and Services Planning) (Scotland) Act 2026, Coronavirus (Discretionary Compensation for Self-isolation) (Scotland) Act 2022 |
| short_title | manual | 1 | Criminal Procedure (Amendment) (Scotland) Act 2002 |
| title_changed_at_stage | bill_page | 2 | stage_2, stage_3 |
| title_changed_at_stage | spice_factsheet_legislation | 2 | stage_2, stage_3 |

### Group 2 rows: the Official Report outcomes

| Session | Bill | What it holds |
|---|---|---|
| 1 | Organic Farming Targets (Scotland) Bill | general principles not agreed to at Stage 1, 6 February 2003. |
| 1 | Proportional Representation (Local Government Elections) (Scotland) Bill | general principles not agreed to at Stage 1, 6 February 2003. |
| 1 | Prostitution Tolerance Zones (Scotland) Bill | general principles not agreed to at Stage 1, 27 February 2003. |
| 1 | Public Appointments (Parliamentary Approval) (Scotland) Bill | general principles not agreed to at Stage 1, 7 February 2002. |
| 1 | School Meals (Scotland) Bill | general principles not agreed to at Stage 1, 20 June 2002. |
| 2 | Abolition of NHS Prescription Charges (Scotland) Bill | general principles not agreed to at Stage 1, 25 January 2006. |
| 2 | Cairngorms National Park Boundary Bill | general principles not agreed to at Stage 1, 21 March 2007. |
| 2 | Civil Appeals (Scotland) Bill | general principles not agreed to at Stage 1, 20 December 2006. |
| 2 | Council Tax Abolition and Service Tax Introduction (Scotland) Bill | general principles not agreed to at Stage 1, 1 February 2006. |
| 2 | Health Board Elections (Scotland) Bill | general principles not agreed to at Stage 1, 31 January 2007. |
| 2 | Provision of Rail Passenger Services (Scotland) Bill | general principles not agreed to at Stage 1, 9 November 2006. |
| 3 | Autism (Scotland) Bill | general principles not agreed to at Stage 1, 12 January 2011. |
| 3 | Budget (Scotland) (No.2) Bill | the bill was rejected at Stage 3, 28 January 2009, on the motion S3M-3299 in the name of John Swinney that it be passed. Result as recorded: "For 64, Against 64, Abstentions 0. It is a well-established convention here and elsewhere that Presiding Officers cast in favour of the status quo. As the passing of the bill would result in a change to the present position with regard to the budget, and as I advised all business managers, I cast my vote against the motion. Motion disagreed to." The Presiding Officer then: "The Budget (Scotland) (No 2) Bill therefore falls." |
| 3 | Creative Scotland Bill | the bill fell on 18 June 2008 because the financial resolution was not agreed. Its general principles were agreed the same day, on motion S3M-2028 in the name of Linda Fabiani: "Motion agreed to. That the Parliament agrees to the general principles of the Creative Scotland Bill." The financial resolution, motion S3M-1776 in the name of John Swinney, was then put. Result as recorded: "For 49, Against 68, Abstentions 0. Motion disagreed to." The Presiding Officer then: "Standing orders are quite clear; the Creative Scotland Bill therefore falls." |
| 3 | End of Life Assistance (Scotland) Bill | general principles not agreed to at Stage 1, 1 December 2010. |
| 3 | Protection of Workers (Scotland) Bill | general principles not agreed to at Stage 1, 22 December 2010. |
| 4 | Alcohol (Licensing, Public Health and Criminal Justice) (Scotland) Bill | general principles not agreed to at Stage 1, 4 February 2016. Route: the member's motion, S4M-14673 in the name of Richard Simpson, disagreed to at Decision Time. Result as recorded: "For 36, Against 59, Abstentions 12. Motion disagreed to." |
| 4 | Assisted Suicide (Scotland) Bill | general principles not agreed to at Stage 1, 27 May 2015. Route: the member's motion, S4M-13258 in the name of Patrick Harvie, disagreed to. Result as recorded: "For 36, Against 82, Abstentions 0. Motion disagreed to." |
| 4 | Criminal Verdicts (Scotland) Bill | general principles not agreed to at Stage 1, 25 February 2016. Route: the member's motion, S4M-15429, disagreed to. Result as recorded: "For 28, Against 80, Abstentions 0. Motion disagreed to." |
| 4 | Pentland Hills Regional Park Boundary Bill | general principles not agreed to at Stage 1, 26 January 2016. Route: the member's motion, S4M-15130 in the name of Christine Grahame, disagreed to. Result as recorded: "For 8, Against 105, Abstentions 0. Motion disagreed to." |
| 4 | Transplantation (Authorisation of Removal of Organs etc.) (Scotland) Bill | general principles not agreed to at Stage 1, 9 February 2016. Route: the member's own motion, S4M-15128 in the name of Anne McTaggart, amended into one that does not agree to the general principles and then agreed to as amended, so the motion carried and the bill fell. The amendment was S4M-15128.1 in the name of Maureen Watt. The Presiding Officer put it as: "The first question is, that amendment S4M-15128.1, in the name of Maureen Watt, which seeks to amend motion S4M-15128, in the name of Anne McTaggart, on the Transplantation (Authorisation of Removal of Organs etc) (Scotland) Bill, be agreed to." Result as recorded: "For 59, Against 56, Abstentions 0. Amendment agreed to." Then on the motion as amended: "For 65, Against 48, Abstentions 2. Motion, as amended, agreed to." The amendment's own wording is not printed on this page. |
| 5 | Culpable Homicide (Scotland) Bill | general principles not agreed to at Stage 1, 21 January 2021. Route: the member's motion, S5M-23917 in the name of Claire Baker, disagreed to. Result as recorded: "For 26, Against 89, Abstentions 0. Motion disagreed to." |
| 5 | Post-mortem Examinations (Defence Time Limit) (Scotland) Bill | general principles not agreed to at Stage 1, 26 January 2021. Route: the member's motion, S5M-23803 in the name of Gil Paterson, disagreed to. Result as recorded: "For 26, Against 90, Abstentions 1. Motion disagreed to." |
| 5 | Restricted Roads (20 mph Speed Limit) (Scotland) Bill | general principles not agreed to at Stage 1, 13 June 2019. Route: the member's motion, S5M-17660 in the name of Mark Ruskell, disagreed to. Result as recorded: "For 26, Against 83, Abstentions 4. Motion disagreed to." The Presiding Officer's announcement on this page does not name the motion; the number and the member are from the Parliament's own bill page for the bill, which gives motion S5M-17660, lodged by Mark Ruskell on 11 June 2019: "That the Parliament agrees to the general principles of the Restricted Roads (20 mph Speed Limit) (Scotland) Bill." |
| 6 | Assisted Dying for Terminally Ill Adults (Scotland) Bill | Outcome from the Official Report, not the fact sheet: the bill was rejected at Stage 3, 17 March 2026, on the motion S6M-21005 in the name of Liam McArthur that it be passed. Result as recorded: "For 57, Against 69, Abstentions 1. Motion disagreed to." The Presiding Officer then: "The Assisted Dying for Terminally Ill Adults (Scotland) Bill falls." The bill had completed Stage 1 on 13 May 2025 and Stage 2 on 25 November 2025. |
| 6 | Disabled Children and Young People (Transitions to Adulthood) (Scotland) Bill | Outcome from the Official Report, not the fact sheet: general principles not agreed to at Stage 1, 23 November 2023. Route: the member's motion, S6M-11381 in the name of Pam Duncan-Glancy, disagreed to. Result as recorded: "For 19, Against 90, Abstentions 0. Motion disagreed to." |
| 6 | Prostitution (Offences and Support) (Scotland) Bill | Outcome from the Official Report, not the fact sheet: general principles not agreed to at Stage 1, 3 February 2026. Route: the member's motion, S6M-20627 in the name of Ash Regan, disagreed to. Result as recorded: "For 54, Against 64, Abstentions 0. Motion disagreed to." |
| 6 | Right to Addiction Recovery (Scotland) Bill | Outcome from the Official Report, not the fact sheet: general principles not agreed to at Stage 1, 9 October 2025. Route: the member's motion, S6M-19128 in the name of Douglas Ross, disagreed to. Result as recorded: "For 52, Against 63, Abstentions 0. Motion disagreed to." |
| 6 | Scottish Employment Injuries Advisory Council Bill | Outcome from the Official Report, not the fact sheet: general principles not agreed to at Stage 1, 18 April 2024. Route: the member's motion, S6M-12882 in the name of Mark Griffin, disagreed to. Result as recorded: "For 20, Against 95, Abstentions 0. Motion disagreed to." |
| 6 | Scottish Parliament (Recall of Members) Bill | Outcome from the Official Report, not the fact sheet: the bill was rejected at Stage 3, 24 February 2026, on the motion S6M-20904 in the name of Graham Simpson that it be passed. Result as recorded: "For 30, Against 66, Abstentions 27. Motion disagreed to." The Presiding Officer then: "the Scottish Parliament (Recall of Members) Bill is therefore not passed." The bill was renamed during its Stage 3 proceedings the same day, from the Scottish Parliament (Recall and Removal of Members) Bill; the title it was introduced under is on this line, and the Official Report of that day lists the Stage 3 business under the old title and the decision under the new. |
| 6 | Wellbeing and Sustainable Development (Scotland) Bill | Outcome from the Official Report, not the fact sheet: general principles not agreed to at Stage 1, 22 January 2026. Route: the member's motion, S6M-20414 in the name of Sarah Boyack, disagreed to. Result as recorded: "For 25, Against 91, Abstentions 0. Motion disagreed to." |

### Group 3 rows: the source's own words

| Heading | Source | Lines | e.g. |
|---|---|---|---|
| assent_block_outcome | spice_factsheet_legislation | 1 | *On 16 January 2023 the UK Government intervened to block Scottish Parliament legislation (under powers contained in s.3… |
| assent_block_route | spice_factsheet_legislation | 4 | Following a reference under section 33 of the Scotland Act 1998 by the Attorney General and the Advocate General for Sco… |
| date_assent_blocked | spice_factsheet_legislation | 3 | Following a reference under section 33 of the Scotland Act 1998 by the Attorney General and the Advocate General for Sco… |
| enactment_status | spice_factsheet_legislation | 1 | *On 16 January 2023 the UK Government intervened to block Scottish Parliament legislation (under powers contained in s.3… |
| short_title | spice_factsheet_legislation | 2 | European Charter of Local Self-Government (Incorporation) (Scotland) Bill (SP 70) |
| stage_1_rejection_route | official_report | 27 | For 39, Against 61, Abstentions 18. Motion disagreed to. |

### Group 4 rows: empty

| Heading | Source | Lines |
|---|---|---|
| asp_number | spice_factsheet_legislation | 2 |
| assent_block_outcome | spice_factsheet_legislation | 3 |
| date_concluded | spice_factsheet_legislation | 1 |
| date_royal_assent | spice_factsheet_legislation | 2 |
| date_session_end_expected | legislation_gov_uk | 1 |
| enactment_status | spice_factsheet_legislation | 3 |
| note | manual | 3 |
| outcome | spice_factsheet_dates | 17 |
