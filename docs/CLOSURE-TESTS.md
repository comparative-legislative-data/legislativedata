# Closure tests

A session's data is not finished because the session that loaded it says so.

**The procedure**, settled with the owner on 2026-09-12 after a session declared
Sessions 1 and 2 finished against a test it had set itself, and moved on:

1. The session that proposes an ingest is finished **writes the test**. It does
   not run it and does not mark it.
2. **A different session runs it**, and reports every answer against the
   expected one.
3. Every item is one of two kinds: **mechanically checkable**, where the answer
   is a count or a yes/no out of the database and nobody has to form a view; or
   **the owner's sign-off**. Nothing in between. If an item needs someone to
   judge whether something is good enough, it is a sign-off.
4. Each expected answer **says where the expectation comes from**. An expected
   answer taken from the database it is testing proves nothing.
5. Each test says **what it does not check**, so nobody reads a pass as more
   than it is.
6. **A test inherits, and is not re-argued.** Settled by the owner on
   2026-09-12, when Sessions 1 and 2 closed. A session's test covers that
   session: what it brought in, and the corrections and adjudications made for
   it. What an earlier session's test already settled is not put again, unless
   something has actually changed — and the test says which of its items an
   outside change can move, so a later session can tell. For Sessions 1 and 2
   that is item 19, the dataset's fingerprint: correcting the dataset for a
   later session moves it, and only that item is then checked again.

There is no universal test. Each ingest gets its own, newest first below.

---

## The notes name the published headings

Written 2026-09-17 by the session that built `db/113`. **Part A run on
2026-09-18**, by a session that did none of that work. Part B waits on the owner.

### Part A — mechanical

1. **The thirteen notes are the approved wording, word for word.** M1, M2, M3,
   M4, M5, M7, M8, M9, M10, M11, M12, M13 and M14 match the "### Proposed"
   block for each in `docs/PHASE-2-PUBLISHED-NOTES.md`, with the backticks
   removed and the bold markers dropped. M8's proposed block gives only its last
   paragraph; the rest of M8 is unchanged, so build the expected text as the
   note's first four paragraphs and its list, then that paragraph.
   *Where from:* the file the owner approved on 17 September.
2. **M6 is untouched.** Its body is the text `db/110_m6_rewritten.sql` set.
   *Where from:* the migration in the repository, not the database.
3. **No note names a column of this database**, and none carries a backtick or a
   pair of asterisks. The published headings the notes do name are plain words.
4. **M10 lost one sentence and kept two.** It no longer contains "Filling the
   column in", and it still contains both "An empty cell therefore means we have
   not been told" and "It does not mean the bill went through the standard
   procedure".
   *Where from:* the cut agreed in block 2 of `docs/PHASE-2-CHARTS-BUILD.md`.
5. **Every heading a note names is on the agreed list.** Take every lower-case
   word with an underscore in any note body, and every one of them appears as a
   heading in §2 to §5 of `docs/PHASE-2-PUBLISHED-COPY.md`. This catches a
   heading misspelt inside a note, which nothing else would.
   *Where from:* the headings the owner settled on 17 September.
6. **No note's title, applies_to or position changed.** The data dictionary
   regenerates with no difference but its date, and its "Applies to" table still
   names this database's own columns rather than published headings.
   *Where from:* the committed `docs/DATA-DICTIONARY.md`.
7. **Nothing else moved.** 470 bills, 1291 stage records, 192 provenance notes,
   14 notes; the error checker and the gaps list empty; only the `public` schema,
   with no working copy in it.

### What this does not check

**That the published copy exists.** It does not. The notes now name headings of
files that have still to be built, and item 5 checks them against the agreed
list, not against anything real. When the copy is built, the same check runs
against the built files and means something stronger.

**That the wording is good.** The owner approved it before it was applied. What
this checks is that what went in is what was approved.

**Whether `applies_to` translates correctly** into published headings. The
mapping does not exist yet; it is built with the copy.

### Part B — the owner's sign-off

1. **Two changes were made after the approval and need a yes.**
   - **M2.** The approved line read "That day is `date_ended`", placed after the
     sentence about Stage 3, which could be read as though only Stage 3's day
     were that column. It went in as "Each of those days is date_ended on the
     bill's stage row."
   - **No markup.** The approved text showed headings in backticks. The database
     holds plain prose — "kept beside it in bill_type_at_the_time" — because a
     note has to read the same in a spreadsheet cell, in the download and on the
     page, and no note here has ever carried markup.

### The run, 2026-09-18, by a session that built none of it

**All seven items of Part A pass.** The notes were taken out of the database and
compared by script, paragraph by paragraph, with whitespace inside a paragraph
ignored and paragraph breaks and list items kept.

1. **All thirteen match** the "### Proposed" blocks once backticks and bold
   markers are dropped, M8 built from its first four paragraphs and list plus the
   proposed last paragraph. The same comparison against the "As it reads today"
   blocks fails for all thirteen, so a pass is not vacuous. The file's M2 block
   already carries "Each of those days is date_ended on the bill's stage row", so
   what is in the database is what the file shows; whether that wording is
   approved is Part B.
2. **M6 is the text `db/110` set**, character for character, and its last-changed
   time is 13:13 on 17 September, before `db/113`. The other thirteen share one
   time, 21:08.
3. **No backtick, no pair of asterisks, no `word.word` pair** once
   legislation.gov.uk is set aside, and no word with an underscore that is a
   column of this database without also being a published heading.
4. **M10**: "Filling the column in" gone; both kept sentences present.
5. **Twenty-five headings named across the notes, all on the agreed list.** 22
   are rows of the heading tables in §2 to §4; the other three are
   `days_between_stages`, the file's own name, and `date_session_ended` and
   `date_session_expected_to_end`, which §5 lists as the `sessions` file's
   headings in running text rather than a table.
6. **The dictionary regenerates with no difference but its date**, and every
   `applies_to` entry is still a real column of this database.
7. **470 bills, 1291 stage records, 192 provenance notes, 14 notes; checker and
   gaps list empty; `public` the only schema.**

Part B was put to the owner the same day.

---

## The Robin Rigg Act's note dates both stages

Written 2026-09-17 by the session that built `db/112` and took Session 2 off and
put it back. **Run on 2026-09-17**, by a session that did none of that work.

### Part A — mechanical

1. **The note is the approved text.** Bill 124's note, and line 124's, match the
   proposal in `docs/PHASE-2-NOTES.md` ("The Robin Rigg Act's note") exactly,
   including its curly apostrophe and its source link.
   *Where from:* the file the owner approved.
2. **The date agrees with what it rests on.** Bill 71's Consideration Stage is
   completed on 11 March 2003, and bill 124's Consideration Stage record is a
   stage that did not happen whose detail note gives 11 March 2003.
3. **Line 124** carries a review note citing `db/112`, and a review time of
   17 September 2026.
4. **Nothing else moved.** 470 bills, 1291 stage records, 192 provenance notes,
   14 notes; Session 2 has 81 bills; checker and gaps list empty; no copy schema;
   the dictionary regenerates with no difference but its date.
5. **Session 5's four bills that ran out of time are unchanged**: each has the
   short note on the stage it stopped at and no detail note.
   *Where from:* the owner's decision to leave them, 17 September.

### What this does not check

That 11 March 2003 is right: it was held before `db/112` and is not re-read here.
The archived page blocks scripted reading.

### Part B — the owner's sign-off

None. The wording was approved before it was applied.

### The run, 2026-09-17, by a session that built none of it

**All five items pass.** The note on bill 124 and on line 124 are identical to
each other and match the approved proposal in `docs/PHASE-2-NOTES.md` word for
word, curly apostrophe and archive link included. Bill 71's Consideration Stage
is completed 11 March 2003; bill 124's is a stage that did not happen whose
detail note gives 11 March 2003. Line 124's review note cites `db/112` and its
review time is 17 September 2026. Counts 470, 1291, 192 and 14, Session 2 at 81
bills, checker and gaps list empty, only the `public` schema, and the data
dictionary regenerated identical to the committed file. Session 5's four bills
that ran out of time — Disabled Children and Young People (Transitions to
Adulthood), Fair Rents, Travelling Funfairs (Licensing), Welfare of Dogs — each
carry the short note on the stage they stopped at and no detail note.

---

## M13's sentence, and the column names in M1, M4 and M11

Written 2026-09-17 by the session that built `db/111`. **Run on 2026-09-17**, by a
session that did none of that work.

### Part A — mechanical

1. **Each change is the approved change.** M13's second paragraph, and the
   changed sentences of M1, M4 and M11, match the proposals in
   `docs/PHASE-2-NOTES.md` word for word. Every other sentence of those four
   notes matches the "as it reads" text where the file quotes it.
   *Where from:* the file the owner approved.
2. **No note names a column.** No note's body, with "legislation.gov.uk"
   removed, contains a word with an underscore or a word.word pair.
3. **M13 kept what was settled.** It says "shown blank" and "nought days", and
   contains neither "the difference is the bills still before the Parliament"
   nor "never reached its final stage".
4. **What M13 now says is true of the calculations.** The view of days between
   stages has no condition on what happened to the bill, so a bill in progress
   with a completed, dated stage would have a period for it. Check the view's
   definition; with today's data bill 473 has none.
5. **Nothing else moved.** 14 notes, the other ten unchanged by `db/111`, and
   all titles unchanged; 470 bills, 192 provenance notes; checker empty; the
   dictionary regenerates with no difference but its date.

### Part B — the owner's sign-off

None. The changes were approved in full before they were applied.

### The run, 2026-09-17, by a session that built none of it

**All five items pass.** Each of the four approved sentences is in the note word
for word and the wording it replaced is gone: M13's second paragraph, M1's label
sentence, M4's Hybrid Bill sentence, and both of M11's. No note's body contains
a word with an underscore or a `word.word` pair once "legislation.gov.uk" is set
aside; the same test run against the four old wordings catches all of them, so
the answer is not vacuous. M13 says "shown blank" and "nought days" and contains
neither of the two sentences that were to go. The view of days between stages
(`v_bill_stage_durations`) has no condition on outcome — it takes introduction,
every dated stage and Royal Assent, and pairs consecutive points — so a bill in
progress with a completed dated stage would have a period; bill 473, the one
Session 7 bill, has none, because it has no stage record yet. M1, M4, M11 and
M13 share one last-changed time and no other note does, so `db/111` changed
those four and nothing else; 14 notes, titles unchanged, 470 bills, 192
provenance notes, checker empty, dictionary identical.

---

## M6 rewritten

Written 2026-09-17 by the session that built `db/110`. **Run on 2026-09-17**, by a
session that did none of that work.

### Part A — mechanical

1. **M6 is the approved text.** Its body matches the proposal in
   `docs/PHASE-2-NOTES.md` ("M6") word for word, ignoring line breaks and quote
   marks. Its title, the columns it applies to and its position unchanged; no
   other note changed by `db/110`.
   *Where from:* the file the owner approved.
2. **M6 names no column**, and gives no total of rows or bills and no count of
   reintroduced pairs.
3. **What M6 says is true of the data.** Exactly four staging lines are further
   listings of a bill already counted: two in Session 6 for Session 5 Acts that
   were stopped and reconsidered, one in Session 6 for the Legal Continuity Bill,
   withdrawn, and one in Session 7 for the Gender Recognition Reform Bill, still
   blocked. Each session's bills equal its staging lines less those listings.
4. **The differences from the fact sheets' own totals.** Read each fact sheet's
   printed total: Sessions 1 to 5 equal our count, Session 6 is two more, Session
   7 is one more.
   *Where from:* the fact sheets in `sources/factsheets/`, not this database.
5. **Nothing else moved.** 14 notes; 470 bills, 1291 stage records, 192
   provenance notes; the checker empty; the dictionary regenerates with no
   difference but its date.

### What this does not check

That the wording is good: the owner approved it. Which bills count as
reintroduced: M6 no longer says.

### Part B — the owner's sign-off

None. The text was approved in full before it was applied.

### The run, 2026-09-17, by a session that built none of it

**All five items pass.** M6's body matches the approved proposal word for word;
its title, columns and position are unchanged, and its last-changed time is
shared by no other note, so `db/110` changed M6 alone. M6 names no column and
gives no total of rows or bills and no count of reintroduced pairs — its numbers
are the four bills affected, which it then names, and the differences from the
fact sheets.

**What M6 says is true of the data.** Exactly four staging lines are further
listings of a bill already counted: lines 440 and 468 in Session 6 for the
European Charter and UNCRC Acts, Session 5 bills stopped and reconsidered; line
412 in Session 6 for the Legal Continuity Bill, withdrawn; and line 474 in
Session 7 for the Gender Recognition Reform Bill, still blocked. Each session's
bills equal its staging lines less those listings: Session 6, 83 less 3 is 80;
Session 7, 2 less 1 is 1; Sessions 1 to 5 equal.

**The differences from the fact sheets' own printed totals**, read from the
seven PDFs and not from the database: Session 1, 73; Session 2, 81; Session 3,
62; Session 4, 86; Session 5, 87 — all equal to our count. Session 6 prints 82,
two more. Session 7 prints 2, one more. Counts and dictionary as expected.

---

## M7 rewritten, and two Session 3 votes carried

Written 2026-09-17 by the session that built `db/109` and took Session 3 off and
put it back. **Run on 2026-09-17**, by a session that did none of that work.

### Part A — mechanical

1. **M7 is the approved text.** Its body matches the proposal in
   `docs/PHASE-2-NOTES.md` ("M7") word for word, ignoring line breaks and quote
   marks. Its title, the columns it applies to and its position unchanged; no
   other note changed by `db/109`.
   *Where from:* the file the owner approved.
2. **M7 names no column** and names no session as the extent of the coding.
3. **What M7 says is true of the data.** Every bill whose outcome is rejected at
   Stage 1, rejected at Stage 3, fell at dissolution or fell for want of a
   financial resolution has a provenance note on its outcome; the dissolution
   ones name SPICe's dates fact sheet and the rest the Official Report. Every
   fell-at-dissolution bill ended on its session's last day and no other bill
   did. No bill has the outcome "Fell (other)". Only Members' Bills were rejected
   by a Rule 9.14.18 motion.
   *Where from:* the rules M7 states, not the counts in the write-up.
4. **Every rejection carries its division.** Each of the 27 provenance notes on
   how a bill was rejected at Stage 1, and each of the three provenance notes on
   a Stage 3 rejection's outcome, contains "For" followed by a number.
   *Where from:* M7's second paragraph. Before `db/109` the Budget (Scotland)
   (No.2) Bill's did not.
5. **The two votes read as the Official Report does.** Bill 211's outcome note
   contains `For 64, Against 64, Abstentions 0` and bill 213's `For 49, Against
   68, Abstentions 0`; both are dated 13 September 2026 and cite the Official
   Report links for 28 January 2009 (meetingId=4843) and 18 June 2008
   (meetingId=4805). Neither contains "casting vote decided it", "fell at Stage
   1", "Rearranged" or a link. Open both reports and check the figures.
   *Where from:* the Official Report, not this database.
6. **Lines 211 and 213 kept our commentary.** Each review note has, after the
   link, the sentence that was ours: 211 "The division was tied and the
   Presiding Officer's casting vote decided it", 213 "The Parliament's own bill
   page says the bill "fell at Stage 1"". Each has a second line citing
   `db/109`, and a review time of 17 September. That no other word was added or
   lost was proved inside the migration against the old notes, which are not
   kept anywhere else; this item does not re-prove it.
7. **Nothing else moved.** 470 bills, 1291 stage records, 192 provenance notes,
   14 notes; Session 3 has 62 bills and 15 provenance notes; checker and gaps
   list empty; no copy schema; the dictionary regenerates with no difference
   but its date.

### What this does not check

That the new wording is good: the owner approved it. The sixteen Session 1 to 3
Stage 1 rejections whose outcome note has no figures: their figures are in the
note on how the bill was rejected, which item 4 checks.

### Part B — the owner's sign-off

None. The text was approved in full before it was applied.

### The run, 2026-09-17, by a session that built none of it

**All seven items pass.** M7's body matches the approved proposal word for word;
title, columns and position unchanged, and its last-changed time is shared by no
other note. M7 names no column and mentions no session at all, so it names none
as the extent of the coding.

**What M7 says is true of the data.** All 17 bills that fell at dissolution, all
27 rejected at Stage 1, all 3 rejected at Stage 3 and the one that fell for want
of a financial resolution carry a provenance note on their outcome; the
dissolution ones cite SPICe's dates fact sheet and every other cites the
Official Report. Every fell-at-dissolution bill ended on its session's last day
and no other bill did. No bill has the outcome "Fell (other)". Only Members'
Bills carry the Rule 9.14.18 route, two of them.

**Every rejection carries its division.** All 27 provenance notes on how a bill
was rejected at Stage 1 contain "For" and a number, and so do all three on a
Stage 3 rejection's outcome, bills 211, 398 and 406. The figures sit in the
value seen rather than the note.

**The two votes read as the Official Report does**, checked by opening both
reports rather than by trusting a summary of them. Bill 211: "For 64, Against
64, Abstentions 0", with the Presiding Officer's convention wording and "The
Budget (Scotland) (No 2) Bill therefore falls." Bill 213: "For 49, Against 68,
Abstentions 0. Motion disagreed to.", and "Standing orders are quite clear; the
Creative Scotland Bill therefore falls." Both notes are dated 13 September 2026
and cite meetingId 4843 and 4805; neither contains "casting vote decided it",
"fell at Stage 1", "Rearranged" or a link. Lines 211 and 213 keep our
commentary after the link, each with a second line citing `db/109` and a review
time of 17 September. Counts 470, 1291, 192 and 14; Session 3 at 62 bills;
checker and gaps empty; no copy schema; dictionary identical.

**A caution for whoever reads the Official Report next.** Fetching the 28
January 2009 report through a summarising tool returned "For 67, Against 61"
together with a tied vote and a casting vote cast both ways — three
contradictions in four lines. The figures here were taken from the report's own
text. Do not accept a summary of a division.

---

## M2 and M8 rewritten

Written 2026-09-17 by the session that built `db/108`. **Run on 2026-09-17**, by a
session that did none of that work.

### Part A — mechanical

1. **Both texts are the approved texts.** M2's and M8's bodies match the
   proposals in `docs/PHASE-2-NOTES.md` word for word, ignoring line breaks and
   quote marks; M8's five sources are each on a line of their own. Titles, the
   columns each applies to, and positions unchanged.
   *Where from:* the file the owner approved.
2. **The thesis is cited in full by exactly one note, M8**, and no note is left
   saying Stage 1 and 2 dates are missing for a session.
3. **What M8 says about checking is true of the data.** Every staging line read
   from an awaiting-assent table carries a "Checked: enactment_status = ..."
   citation; provenance notes naming SPICe's dates fact sheet and the Supreme
   Court exist.
4. **What M2 says about stages is true of the data.** No completed stage record
   lacks a date; every stage with no date and no decision carries the same
   general note wording; the one Hybrid Bill has Stage 1, 2 and 3 records; no
   Private Bill has a Stage 1, 2 or 3 record.
5. **Nothing else moved.** 14 notes, all but M2 and M8 unchanged by `db/108`;
   470 bills, 192 provenance notes; the checker empty; the dictionary
   regenerates with no difference but its date.

### Part B — the owner's sign-off

None. Both texts were approved in full before they were applied.

### The run, 2026-09-17, by a session that built none of it

**All five items pass.** M2's and M8's bodies match the approved proposals word
for word; M8's five sources are each on a line of their own; titles, columns and
positions unchanged, and the two share one last-changed time that no other note
has, so `db/108` changed those two alone. The thesis is cited in full by exactly
one note, M8, and no note says Stage 1 and 2 dates are missing for a session —
the same test catches the old wording, so the answer is not vacuous.

**What M8 says about checking is true of the data.** All 12 staging lines read
from an awaiting-assent table carry a "Checked: enactment_status = ..."
citation. Provenance notes citing SPICe's dates fact sheet (30) and the Supreme
Court (1) exist.

**What M2 says about stages is true of the data.** No completed stage record
lacks a date. All 34 stages with no date and no decision carry the same general
note, word for word. The one Hybrid Bill, the Forth Crossing Act, has Stage 1,
2 and 3 records. No Private Bill has a Stage 1, 2 or 3 record. Counts and
dictionary as expected.

---

## A change of title records its stage

Written 2026-09-17 by the session that built `db/107`, changed
`tools/promote_session.sql` and took Sessions 2, 4, 7, 6 and 5 off and put them
back. **Run on 2026-09-17**, by a session that did none of that work.

**What to expect before starting.** 470 bills, 1291 stage records, 192
provenance notes, 14 methodology notes; the error checker and gaps list empty;
no copy in the database.

**What this moves in earlier tests.** Any item that counts provenance notes, or
that reads M3 or the error checker's definition as text.

### Part A — mechanical

1. **Every title change the fact sheets state is recorded.** Search the text of
   all seven fact sheet PDFs in `sources/factsheets/` for "introduced as" and
   "renamed", setting aside "introduced as an Executive Bill" and the like.
   Expected: four bills, and exactly those four carry a title as introduced on
   the clean sheet: 127, 231, 406 and 423.
   *Where from:* the fact sheets, not the database.
2. **Each records the right stage, and the date follows.** 127 Stage 3, 231
   Stage 2, 406 Stage 3, 423 Stage 2; the date each stage ended is 2 November
   2006, 4 June 2014, 24 February 2026 and 4 March 2025.
   *Where from:* for 406 and 423, the rename dates the Session 6 fact sheet
   prints, which must equal those stage dates; for 127 and 231, the wording of
   the two archived bill pages quoted in `db/107`.
3. **Each has its provenance note.** Four, one per bill, for the stage: 127 and
   231 citing the archived bill pages, read 2026-09-17; 406 and 423 citing the
   Session 6 fact sheet.
4. **Line 231's footnote is the fact sheet's.** Its raw footnote matches the
   Session 4 fact sheet's footnote 1 word for word, and its title as introduced
   is the title that footnote names.
   *Where from:* the Session 4 PDF.
5. **The checker's rules work, and its old rules are unchanged.** Inside a
   thrown-away transaction, one at a time: empty 127's stage; give 231 a Private
   Bill stage; give a line with no earlier title a stage and a citation; give
   406 a stage it has no dated row for; remove 423's citation. Each gives its
   own problem, and the checker is empty again after each rollback. Then put a
   stage not on the list, and a stage on a bill with no earlier title, onto the
   clean sheet: both refused. Compare the checker's definition with `db/098`'s
   and `db/094`'s text as last written: nothing removed but the closing line.
6. **Promotion carries it.** Inside a thrown-away transaction, take Session 4
   off and put it back: bill 231's stage is there, and promotion's own
   field-by-field check passed.
7. **M3 is the approved text.** Title and body match the draft in
   `docs/PHASE-2-NOTES.md` word for word; it names no column; it applies to the
   short title, the title as introduced and the stage.
8. **Nothing else moved.** Take a copy, take Sessions 2, 4, 7, 6 and 5 off and
   put them back inside a thrown-away transaction, and compare: no unexpected
   differences at all. Counts as above; the dictionary regenerates with no
   difference but its date.

### Part B — the owner's sign-off

None. The owner found the two bill pages, agreed every part and the wording of
M3 before the build, and supplied the rule the dates rest on.

### What this test does not check

- **Titles changed without a fact sheet saying so.** M3 says an empty cell means
  none is known.
- **`tools/extract_factsheet.py`'s dropped footnote.** Not mended; every session
  is read in.

### The run, 2026-09-17, by a session that built none of it

**All eight items pass.** Before starting: 470, 1291, 192, 14; checker and gaps
empty; no copy in the database.

**Every title change the fact sheets state is recorded.** Searching all seven
PDFs for "introduced as" and "renamed", setting aside "introduced as an
Executive Bill" and the like, gives four bills and no more: the Scottish
Commission for Human Rights Act in Session 2, the Buildings (Recovery of
Expenses) Act in Session 4 by footnote, and the Scottish Parliament (Recall of
Members) Bill and Care Reform Act in Session 6. Exactly those four carry a title
as introduced on the clean sheet: 127, 231, 406 and 423.

**Each records the right stage, and the date follows.** 127 Stage 3 ended
2 November 2006; 231 Stage 2, 4 June 2014; 406 Stage 3, 24 February 2026; 423
Stage 2, 4 March 2025. The Session 6 fact sheet prints rename dates of 24
February 2026 and 4 March 2025, which are those two stage dates. Each has one
provenance note for the stage: 127 and 231 citing the archived bill pages, read
17 September 2026; 406 and 423 citing the Session 6 fact sheet. Line 231's raw
footnote matches the Session 4 fact sheet's footnote 1 word for word, and its
title as introduced is the title that footnote names.

**The checker's rules work.** In a thrown-away transaction, one at a time:
emptying line 127's stage gives "records a title as introduced, but not the
stage at which the title changed"; giving line 231 a Private Bill stage gives
both "not a stage a members bill has" and "no dated row for that stage"; giving
line 200, which has no earlier title, a stage and a citation gives "records no
title as introduced"; removing line 423's citation gives "carries no 'Checked:
title_changed_at_stage = ...' citation". On the clean sheet, a stage not on the
list and a stage on a bill with no earlier title were both refused, by the
foreign key and by `bill_title_change_needs_an_introduced_title`. The checker
was empty again after every rollback.

**One sub-check took three goes, and the first two were the tester's fault.**
"Give 406 a stage it has no dated row for" needs a stage 406 actually lacks, and
line 406 has dated rows for Stages 1, 2 and 3; `stage_1` and `stage_2` therefore
raised nothing. `reconsideration`, the one remaining stage a Members' Bill may
have, raised "says its title changed at reconsideration, but has no dated row
for that stage". Anyone running this again should pick the stage from the line's
own rows first.

**The checker's old rules are unchanged.** All 39 of the reader-facing messages
in `db/098`'s and `db/094`'s versions of the checker are still in its stored
definition. This shows nothing was removed; because the stored form splits
concatenated messages into separate pieces, it does not show that no rule's
condition was weakened, which the item does not ask.

**M3** matches the approved draft word for word, names no column, and applies to
the short title, the title as introduced and the stage.

**Promotion carries it.** In a thrown-away transaction, Session 4 came off —
bill 231 gone — and went back on, and bill 231's stage was there, with
promotion's own field-by-field check passing.

**Nothing else moved.** A copy taken, then Sessions 2 and 4 off and back and
Sessions 7, 6 and 5 off and back, then compared: **no unexpected differences at
all**, only the expected reissued numbers and times. All four title changes
survived. Counts 470, 1291, 192; checker and gaps empty; no copy schema after
the rollback; dictionary identical.

---

## M5, and what "Blocked" means

Written 2026-09-17 by the session that built `db/106`. **Run on 2026-09-17**, by a
session that did none of that work. Small, because the change is two pieces of
text; it is here so that no text a reader sees is changed on its author's word
alone.

**What to expect before starting.** 14 methodology notes; 470 bills, 1291 stage
records, 188 provenance notes; the error checker empty.

### Part A — mechanical

1. **M5's text is the approved text.** Its body matches the proposal in
   `docs/PHASE-2-NOTES.md` word for word, ignoring line breaks and the `> `
   quote marks, with its three paragraphs kept. Its title, the columns it
   applies to and its position are unchanged.
   *Where from:* the file the owner approved, not the migration.
2. **"Blocked" means the approved text.** The definition of `blocked` among the
   enactment statuses matches the proposal in the same file word for word; its
   label and position, and every other status, are unchanged.
3. **What the note states is what the data holds.** For each of the four bills
   it names, the stopped date, how it was stopped and what followed, read from
   the bills, agree with the note: 13 December 2018, section 33, withdrawn on
   10 March 2022; 6 October 2021 twice, section 33, reconsidered and passed;
   16 January 2023, section 35, still stopped.
   *Where from:* the note, compared against the database.
4. **No column names and no old date.** M5 contains nothing of the form
   `word.word` and no "ruled against on 6 October 2021"; no methodology note,
   and no meaning of a value, still says a mechanism "is recorded in bill.note".
5. **Nothing else moved.** Counts as above; the data dictionary regenerates with
   no difference but its date.

### Part B — the owner's sign-off

None. The owner approved both texts in full before they were applied.

### What this test does not check

- **The other notes.** Whether they are cut as M5 and M12 were is the next open
  question.

### The run, 2026-09-17, by a session that built none of it

**All five items pass.** M5's body matches the approved proposal word for word,
three paragraphs kept; its title, columns and position are unchanged, and its
last-changed time is shared by no other note. The meaning of "Blocked" matches
its proposal word for word, and its label and position are unchanged; the other
three statuses read exactly as the migrations that last set them wrote them —
`enacted` and `not_enacted` from `db/002`, `pending` from `db/088` — so nothing
else in that list moved.

**What the note states is what the data holds.** The Legal Continuity Bill:
stopped 13 December 2018, section 33, withdrawn 10 March 2022. The European
Charter and UNCRC Bills: both 6 October 2021, section 33, reconsidered and
passed, both now enacted. The Gender Recognition Reform Bill: 16 January 2023,
section 35, still blocked. M5 contains nothing of the form `word.word` and no
"ruled against on 6 October 2021"; no methodology note and no meaning of a value
says a mechanism "is recorded in bill.note". Counts and dictionary as expected.

**Noticed while checking, and not part of this test.** The rule against naming
columns was applied to the methodology notes. The definitions of the allowed
values, which the data dictionary says are also text to show a reader, still
name columns in four lists — `ref_source`, `ref_bill_type`, `ref_party` and
`ref_stage_1_rejection_route`. For the owner to decide whether that matters.

---

## The Legal Continuity Bill's ruling is dated

Written 2026-09-17 by the session that built `db/105`, mended
`tools/promote_session.sql` and took Sessions 7, 6 and 5 off and put them back.
**Run on 2026-09-17**, by a session that did none of that work.

The owner settled on 17 September that a missing date is added with its
provenance (`DECISIONS.md`). Bill 305 had no date for when it was stopped; it now
has the Supreme Court's judgment date. How it was run is in
`PROMOTION-RUNBOOK.md`, 17 September.

**What to expect before starting.** At the time of writing: 470 bills, 1291
stage records, 188 provenance notes, 14 methodology notes, an empty error
checker and an empty gaps list, and no copy left in the database.

**What this moves in earlier tests.** Session 6's test quotes bill 305's note as
it read before; the note now gives the ruling date. `db/101`'s test records line
412's review day as 15 September; it is now 17 September, and bill 305's note
provenance is dated to match. Those items are not run again: this test covers
the change.

### Part A — mechanical

1. **The date and where it came from.** Bill 305's stopped date is 13 December
   2018. Exactly one provenance note for it: source Supreme Court, reference
   `https://www.supremecourt.uk/cases/uksc-2018-0080`, read 2026-09-17, value
   2018-12-13.
   *Where from:* the kept page in `sources/judgments/`, read by the tester: its
   judgment date. Not the migration.

2. **The kept page is the page.** Its SHA-256 begins as `sources/README.md`
   records, and it contains "13 December 2018" and "[2018] UKSC 64".

3. **The other three stopped bills did not move.** Bills 303 and 304 read
   6 October 2021 and bill 393 reads 16 January 2023, each with a provenance
   note crediting the SPICe legislation fact sheet and quoting its footnote.
   *Where from:* the footnotes in the Session 5 and Session 6 fact sheet PDFs in
   `sources/factsheets/`.

4. **The mend is needed, and works.** Inside a transaction that is thrown away,
   with the tools' working tables dropped between runs: take Sessions 7, 6 and 5
   off, and promote Session 5 with `tools/promote_session.sql` as it stood
   before this change (`git show 760bb3d:tools/promote_session.sql`). Bill 305's
   date note is credited to the fact sheet, with the footnote that gives no
   date. Roll back, and do the same with the tool as it is now: credited to the
   Supreme Court.
   *Where from:* the fault as described in `db/105`. The first half is what
   stops the item passing on a tool that never had the fault.

5. **Nothing is left that the tools would not produce.** Inside a transaction
   that is thrown away: take a copy (`tools/take_copy.sql`), take Sessions 7, 6
   and 5 off and put them back, and compare (`tools/compare_with_copy.sql`).
   Expected: **no unexpected differences at all**.
   *Where from:* promotion writes everything from the staging lines, so a second
   pass over a correctly finished change changes nothing.

6. **No line or bill still says the date is not stated.** No bill note and no
   staging line's note contains "states no date for the ruling". Bill 305's note
   reads, in full: "Not submitted for Royal Assent. Following a reference under
   section 33 of the Scotland Act 1998 by the Attorney General and the Advocate
   General for Scotland, the Supreme Court ruled on 13 December 2018 that some
   provisions of the bill were outwith the Parliament's legislative competence,
   and it could not be submitted for Royal Assent in its unamended form. The
   bill was withdrawn on 10 March 2022."
   *Where from:* `db/105`, and the wording of bills 303 and 304's notes, which
   this mirrors.

7. **The source is on the list, and used once.** `supreme_court` is on the list
   of sources with a definition, and exactly one provenance note uses it.

8. **The counts, and the dictionary.** 470 bills, 1291 stage records, 188
   provenance notes; the error checker and gaps list empty; no copy schema. The
   data dictionary regenerates with no difference but its date.
   *Where from:* 187 notes before this change, from `STATE.md`'s figures after
   `db/104`, plus the one note added.

### Part B — the owner's sign-off

9. **Bill 305's note, as a reader sees it** (item 6's wording). The owner agreed
   the note would give the date; this is the wording it gives. **Signed off by
   the owner on 17 September**, when this wording was shown in full with M5's
   and the owner said to proceed.

### What this test does not check

- **M5**, which is corrected separately in its own wording.
- **Whether other cells have a date the fact sheets leave out** that another
  source gives. The owner's rule applies to them too; nothing has looked.

### The run, 2026-09-17, by a session that built none of it

**All eight mechanical items pass; item 9 was signed off by the owner on
17 September.**

**The date and where it came from.** Bill 305's stopped date is 13 December
2018, with exactly one provenance note for it: source Supreme Court, reference
the `uksc-2018-0080` case page, read 17 September 2026, value 2018-12-13. The
kept page's SHA-256 begins `70ec07558ec981ee` as `sources/README.md` records,
and it contains "13 December 2018" and "[2018] UKSC 64".

**The other three stopped bills did not move.** Bills 303 and 304 read 6 October
2021 and bill 393 reads 16 January 2023, each with a provenance note crediting
the SPICe legislation fact sheet and quoting its footnote. Read from the PDFs:
the Session 5 footnotes for 303 and 304 say "has ruled on 6 October 2021", and
the Session 6 asterisk footnote says "On 16 January 2023 the UK Government
intervened to block".

**The mend is needed, and works.** In a thrown-away transaction with the tools'
working tables dropped between runs: Sessions 7, 6 and 5 off, then Session 5
promoted with `tools/promote_session.sql` as it stood at `760bb3d` — bill 305's
date note came out credited to `spice_factsheet_legislation`, the Session 5 fact
sheet, whose footnote for this bill says only "has ruled", with no date. Rolled
back and promoted with the tool as it is now — credited to the Supreme Court,
the case page, 13 December 2018. The fault was real and the mend closes it.

**Nothing is left that the tools would not produce.** A copy taken, Sessions 7,
6 and 5 off and back, compared: **no unexpected differences at all.** With all
three off the counts were 302 bills and 828 stage records, as the runbook says,
and 89 provenance notes rather than its 87 — because `db/107` has since added
four notes, two of them on bills in Sessions 2 and 4, which stay while 5, 6 and
7 are off. The runbook's line is worth updating.

**No line or bill still says the date is not stated**, and bill 305's note reads
exactly the wording the test sets out. `supreme_court` is on the list of sources
with a definition and is used by exactly one note. Counts 470, 1291 and 192 —
188 at the time of writing plus `db/107`'s four; checker and gaps empty; no copy
schema; dictionary identical.

---

## Session 7's expected last day, and M14

Written 2026-09-17 by the session that proposed and built `db/104`. **Run on
2026-09-17**, by a session that did none of that work.

The owner settled on 17 September that chart 5 measures Session 7 to an
estimated last day, and approved all nine parts of the change with the wording
of M14 before anything was built (`docs/PHASE-2-CALCULATIONS.md`, last section;
`DECISIONS.md`, 17 September). `db/104` adds a cell to the session tab, fills
it for Session 7 with 1 April 2031, adds two refusals, one provenance note and
M14, and nothing else.

**What to expect before starting.** At the time of writing: 470 bills, 1291
stage records, 187 provenance notes, 14 methodology notes, an empty error
checker and an empty gaps list.

**What an outside change can move.** Item 2's date, if the law changes or the
poll is moved (the kept pages then no longer describe the live law, and the
item is run against a fresh copy); items 6 and 7's counts, when anything else
adds a provenance note or a methodology note; item 9's "nothing else reads the
cell", once chart 5's calculation is built.

### Part A — mechanical

1. **The cell exists and is described.** `session.date_session_end_expected`
   is a date column with a description, and `tools/make_data_dictionary.py`
   produces no difference from the committed dictionary apart from its date.
   *Where from:* `CLAUDE.md`'s rule that every new column carries a description
   in the migration that makes it.

2. **The date is right, worked out without the database.** From the three pages
   in `sources/legislation/` alone, and a calendar for Easter 2031 from outside
   this repository: the poll day under s2(2), then counting back the minimum
   period under article 84 and schedule 2 rule 2. Expected: poll 1 May 2031,
   Good Friday 11 April and Easter Monday 14 April left out, period beginning
   2 April, **last day 1 April 2031**. Then read Session 7's cell: it must say
   the same. *Where from:* the law, not the migration; the count is redone, not
   compared with the migration's arithmetic.

3. **The rule reproduces a real last day.** The same count from the poll of
   7 May 2026 gives 8 April 2026. Compare it with Session 6's last day in
   SPICe's dates fact sheet in `sources/factsheets/` (the parliamentary years
   table). *Where from:* SPICe, which `db/048` took Session 6's date from; not
   the database.

4. **Only Session 7 holds an estimate.** Sessions 1 to 6 have the cell empty
   and a last day; Session 7 has the estimate and no last day.
   *Where from:* part 2 of the approved proposal.

5. **The refusals work, and the proper route does not refuse.** Inside a
   transaction that is thrown away, each in its own savepoint:
   - an estimate put on Session 6: refused;
   - Session 7's estimate emptied: refused;
   - Session 7's estimate set to 1 May 2026, before its first meeting: refused;
   - a last day put on Session 7 with the estimate left in: refused;
   - **the control:** a last day put on Session 7 with the estimate emptied in
     the same change: accepted.
   Roll back, then confirm Session 7 reads as it did.
   *Where from:* parts 2 and 6 of the approved proposal. The control is what
   stops the item proving only that the tab refuses everything.

6. **The provenance note.** Exactly one note for the cell: Session 7, source
   legislation.gov.uk, read 2026-09-17, its reference naming s2 of the Act,
   article 84 with the 2025 amending Order, and schedule 2 rule 2, and its note
   saying the date is worked out and not stated. 187 provenance notes in all.
   *Where from:* part 5 of the approved proposal; 186 before, from `STATE.md`
   at the opening of 17 September.

7. **M14 is the approved wording, word for word.** Its title and body match the
   draft in `docs/PHASE-2-CALCULATIONS.md`, ignoring line breaks; it applies to
   `session.date_session_end_expected`; it is at position 14; there are 14
   notes; and M1 to M13 are unchanged since before `db/104` (their last-changed
   times are all earlier than 17 September 2026).
   *Where from:* the owner's approval of the draft, not the database.

8. **The kept pages are the pages.** Each of the three files'
   SHA-256 begins as `sources/README.md` records, and each contains the words
   relied on: "first Thursday in May in the fifth" (the Act), "20 days" (article
   84), and "Good Friday or Easter Monday" (rule 2).
   *Where from:* the README; the words from the law as quoted in `db/104`.

9. **Nothing else moved, and nothing else reads the cell.** 470 bills and 1291
   stage records; the error checker and the gaps list empty. No view in the
   database and no file in `tools/` or `site/` mentions
   `date_session_end_expected`. The session tab's first meetings, last days,
   running flags and notes are the values written in `db/048`'s file.
   *Where from:* `STATE.md`'s figures of 17 September, and `db/048`'s text.

### Part B — the owner's sign-off

None. The owner approved the nine parts and both wordings before the build, and
item 7 checks that what was built is what was approved.

### What this test does not check

- **Whether Session 7 will end on 1 April 2031.** It is an estimate; M14 says
  what would move it.
- **Chart 5's calculation**, which is not built. Nothing reads the cell yet.
- **Chart 5's opening sentence**, which is public wording for the build and
  lives nowhere in the database.

### The run, 2026-09-17, by a session that built none of it

**Eight items pass. Item 7 passes but for one clause that later work overtook.**

**The cell exists and is described**, a date column with a description, and the
data dictionary regenerates identical to the committed file.

**The date, worked out without the database.** From the three kept pages alone,
plus Easter 2031 computed outside this repository: the Scotland Act 1998 s2(2)
gives the poll as the first Thursday in May in the fifth calendar year following
2026, which is Thursday 1 May 2031. Article 84 makes the minimum period 20 days,
computed under schedule 2 rule 2, which disregards Saturdays, Sundays, Good
Friday and Easter Monday. Easter Sunday 2031 is 13 April, so Good Friday is
11 April and Easter Monday 14 April. Counting 20 countable days back from and
including 1 May 2031, the period begins Wednesday 2 April 2031, so the last day
is **Tuesday 1 April 2031**. Session 7's cell says 2031-04-01.

**The rule reproduces a real last day.** The same count from the poll of 7 May
2026 gives a period beginning 9 April 2026 and a last day of 8 April 2026.
SPICe's dates fact sheet gives Session 6, Parliamentary Year 5, as ending
8 April 2026.

**Only Session 7 holds an estimate.** Sessions 1 to 6 have the cell empty and a
last day; Session 7 has 2031-04-01 and no last day.

**The refusals work, and the control does not refuse.** In a thrown-away
transaction, each in its own savepoint: an estimate on Session 6, refused; the
estimate emptied, refused; an estimate of 1 May 2026, before Session 7's first
meeting, refused by the other constraint; a last day with the estimate left in,
refused. The control — a last day in and the estimate out in one change — was
accepted. Session 7 read as before after every rollback.

**The provenance note.** Exactly one note for the cell: Session 7,
legislation.gov.uk, read 17 September 2026, its reference naming s2 of the Act,
article 84 with the 2025 amending Order and schedule 2 rule 2, and its note
saying the date is worked out and not stated. 192 provenance notes in all, not
the 187 written here: `db/105` added one and `db/107` four, which this test
already flagged as movable.

**M14** matches the approved draft word for word, title and body, applies to
`session.date_session_end_expected`, sits at position 14, and there are 14
notes. **But its last clause can no longer pass as written:** M1 to M13 are not
unchanged since before `db/104`, because `db/106` to `db/111` rewrote ten of
them later the same day. The clause was overtaken by work that followed it, not
broken. What can still be checked, and holds: each of those migrations' notes
share one last-changed time and no others do, so each changed only the notes it
claimed.

**The kept pages are the pages.** All three SHA-256 values begin as
`sources/README.md` records — `2820dccb71c32f52`, `423f0e777d1b6a5c`,
`5c4840abc297db1f` — and each contains the words relied on: "first Thursday in
May in the fifth", "20 days", and "Good Friday or Easter Monday".

**Nothing else moved, and nothing else reads the cell.** 470 bills and 1291
stage records; checker and gaps empty. No view in the database and no file in
`tools/` or `site/` mentions `date_session_end_expected`.

---

## Phase 1 — the site

Written 2026-09-16 by a session that did Phase 1 work: it reshaped the machine's
apply, sign-in and admin checks. **It has not been run.** It is run by a session
that built nothing in Phase 1, and that same session then does the sweep in
Part C. The owner does Part B.

**What closes the phase**, from `PLAN.md`, "Phase 1 — the site", "Closes when",
and `PHASE-1.md`, "How the phase closes": the owner can approve a beta
application on the site, sign in with a code, and sign out; the infrastructure
and style decisions are recorded; a written test has been run by a session that
did none of the work; that session sweeps and deletes `docs/PHASE-1.md`; the
owner signs off that they can explain what was built and how it runs. This test
also checks what the phase **must not** do, from the same section: publish any
data, take on tools for users to build things, or take on new data.

**Its rows are real people.** From the first application onwards the accounts
hold data about people. Every item below looks at counts, yes/no answers, or
invented people. No row, email or name from the accounts comes into the
conversation, a document or a commit, including when an item fails.

**What to expect before starting.** At the time of writing: 470 bills, 1291
stage records, 186 provenance notes, 13 methodology notes, 474 staging lines,
an empty error checker and gaps list. The accounts hold the owner and nobody
else; **by the time this runs they may hold real people**, and nothing below
depends on how many. The live release was `2026-09-16T16-01-09Z`; site code last
changed in commit `1f4082c`.

**Mind the SSH limit**: a seventh connection inside 30 seconds is refused, and
retrying straight away keeps it refused. Send files and run them in one
connection, and after a refusal wait a full minute without trying.
`docs/STANDING.md`, "Connecting to the database".

**What an outside change can move.** A deploy moves items 3, 4 and 5 (which
release is live). An application moves nothing here except the owner's account
numbers in Part B. A backup run moves item 15's snapshot dates. Anything else
changing is a finding.

### Part A — mechanical

**The deploy and its undo, done for real.** Items 1–5 change which release is
live for under a minute. Do them first, so that every later item looks at the
release they leave live. Do them when the owner is not signing in.

1. **The site as a reader gets it.** From the Mac: `https://legislativedata.org/`
   `200`; `https://www.legislativedata.org/` `301` to the bare name;
   `http://legislativedata.org/` `308` to `https`; the stylesheet
   (`/static/css/site.css`) `200`. The certificate's end date is after today.
   *Where from:* `DEPLOY-RUNBOOK.md`, "What the five lines at step 5 should
   say"; `DECISIONS.md` 2026-09-16, "Traffic comes straight to the machine".

2. **What is live is what was committed.** `/srv/site/current` points at the
   last line of `/srv/site/switched`. Every file in that release, leaving out
   `.venv` and `__pycache__`, is identical to `site/` at the commit being tested,
   and neither has a file the other lacks.
   *Where from:* `DEPLOY-RUNBOOK.md`, "Nothing is edited on the machine".

3. **The undo works.** Note the line before last in `/srv/site/switched`. Run
   `tools/deploy_site.sh --rollback`. It must print `health after rollback: 200`,
   `https apex after rollback: 200`, and `current ->` that noted release.
   *Where from:* `DEPLOY-RUNBOOK.md`, "The undo".

4. **A deploy works, and puts it back.** Straight after item 3, run
   `tools/deploy_site.sh` from the commit being tested. Step 3 must show `200`
   for both health and home page; step 5 the five lines of item 1, with `200`
   for the app on this machine. `/srv/site/current` then points at the new
   release, which is the new last line of `/srv/site/switched`, and item 2 holds
   for it.
   *Where from:* `DEPLOY-RUNBOOK.md`, "A normal deploy".

5. **A staged release does not go live.** `tools/deploy_site.sh --stage-only`:
   its rehearsal shows `200` and `200`; afterwards `/srv/site/current` still
   points at item 4's release and `/srv/site/switched` has not grown.
   *Where from:* `DEPLOY-RUNBOOK.md`, "To rehearse without switching".

**The pages, and that none carries data.**

6. **The pages the phase delivers exist, and nothing else answers.** Not signed
   in: `/`, `/privacy`, `/apply`, `/apply/received`, `/sign-in`, `/sign-in/code`
   and `/signed-out` are `200`; `/admin` is `404`; `/health` is `200`.
   `/bills`, `/data`, `/download`, `/api` and `/charts` are `404`.
   *Where from:* `PLAN.md`, Phase 1 "Delivers": apply, approve or refuse on an
   admin screen only the owner sees, a code by email, signed in as themselves,
   sign out, a welcome; and the page saying what is held, added by
   `DECISIONS.md` 2026-09-15, "No passwords". The five `404`s are the "Must not".

7. **Every page says there is no data.** Each `200` page in item 6 except
   `/health` carries, in its footer, exactly `No data published yet`.
   *Where from:* `DECISIONS.md` 2026-09-15, "Every page carries the date of the
   data it was built from", with no data published in Phase 1 (`PLAN.md`).

8. **The site cannot read the bills.** On the machine:
   `sudo -u legsite psql -X -d legdata -c 'select 1'` is refused with
   `permission denied for database "legdata"`. The databases on the machine are
   exactly `accounts`, `legdata`, `postgres`, `template0`, `template1`: no
   published database exists yet. Under `/srv/site/current`, no file names
   `legdata` as a database to connect to.
   *Where from:* `DECISIONS.md` 2026-09-15, "Three databases" (the site never
   sees the working one) and `PLAN.md` Phase 1 "Must not" (no data, so nothing
   to publish from); `ACCOUNTS-RUNBOOK.md`, "When the published database is
   made".

9. **The working database cannot be reached from the internet.** From the Mac,
   a connection to `legislativedata.org` on port 5432 fails, and so does one on
   port 8000. On the machine, PostgreSQL listens on loopback only.
   *Where from:* `DECISIONS.md` 2026-09-15, "The working database is never
   reachable from the public internet"; `DEPLOY-RUNBOOK.md`, gunicorn "listens
   only to this machine".

**What is held about a person, and nothing more.**

10. **The accounts hold what was settled, and no more.** In `accounts`, the
    tables are exactly `person`, `sign_in_code`, `signed_in_device`. `person`'s
    columns are exactly `person_id`, `email`, `name`, `title`, `position`,
    `state`, `applied_at`, `decided_at`, `is_owner`. No column in any table has
    a name containing `password`, `ip`, `address`, `agent` or `page`. Read from
    the catalogue, never a row.
    *Where from:* `DECISIONS.md` 2026-09-15, "No passwords; what is held about a
    user, in full" (email, name, title, position, state and the dates; never a
    password or what anyone read).

11. **The site's login can do only what it should.** On `accounts`, as
    `postgres`: `has_column_privilege('legsite', 'person', 'is_owner', 'UPDATE')`
    and `has_column_privilege('legsite', 'person', 'email', 'UPDATE')` are both
    false; `has_database_privilege('legsite', 'legdata', 'CONNECT')` is false.
    *Where from:* `ACCOUNTS-RUNBOOK.md`, "What exists"; `DECISIONS.md` 2026-09-15,
    "The owner's account is the superuser" (set on the machine, not the site).

12. **A visitor is given no cookie and nothing about them is logged.** Not
    signed in, no page in item 6 sends a `Set-Cookie` header, and a `POST` to
    `/apply` with an invented address that fails the form sends none either.
    After those requests, the two commands in `DEPLOY-RUNBOOK.md`, "What the log
    records", both give `0`.
    *Where from:* `DECISIONS.md` 2026-09-16, "The site records nothing about a
    visitor"; "Applying for an account" (no cookie).

13. **The four checks pass on the live release, with whoever is in the
    accounts.** Run each against item 4's release as `ACCOUNTS-RUNBOOK.md`
    says, `BREAK=1` first:
    - `tools/check_apply.sh`: broken, FAIL at item 1; then `All 21 pass`.
    - `tools/check_sign_in.sh`: broken, FAIL at item 7; then `All 45 pass`.
      Refuses if the owner has a code still working: wait 15 minutes and rerun.
    - `tools/check_admin.sh`: broken, FAIL at item 1; then `All 28 pass`.
    - `tools/check_privacy.sh`, with `docs/PHASE-1-WHAT-IS-HELD.md`: broken,
      FAIL at item 2; then `All 15 pass`.

    Every clean-up line says nothing invented is left, and the first three say
    `everyone else as they were: yes`, broken runs included. Afterwards the
    number of people in the accounts is what it was before item 13.
    *Where from:* `ACCOUNTS-RUNBOOK.md`, each check's section, and "The three
    checks, with real people in the accounts". **These totals were set by the
    sessions that built the checks**, so a pass here says the checks still hold
    on the live site, not that they check the right things. That was the
    owner's hand test (`STANDING.md`, 2026-09-16), and is Part B's item B1 again.

**The backup, with people in it.**

14. **Every database is sorted into a backup theme.** Each database in item 8
    other than `template0` and `template1` is the working one, or named in
    `ACCOUNTS_DATABASES` or `NOT_BACKED_UP` in `deploy/legdata-backup`, and the
    installed `/usr/local/sbin/legdata-backup` is identical to that file.
    *Where from:* `DECISIONS.md` 2026-09-16, "The backup is separated by theme".

15. **The backup runs and comes back.** `legdata-backup.timer` is active; the
    last run's result is `success`; the newest `system`, `data` and `accounts`
    snapshots on the storage box are each from the last run. Then
    `tools/restore_check.sh`, as `ACCOUNTS-RUNBOOK.md`, "The restore check",
    says: neither copy holds the other's database; the site's login saved; its
    permissions intact; 21 of 21 accounts columns described; 470, 1291, 186, 13,
    474, checker 0, gaps 0; cleaned up, the databases as in item 8, and
    `/tmp/restore-check` gone.
    *Where from:* the same entry; `ACCOUNTS-RUNBOOK.md`, "The restore check".

**What is recorded.**

16. **The infrastructure decisions are recorded.** `DECISIONS.md`'s contents
    list each of these headings, word for word: "The working database is never
    reachable from the public internet"; "The front end runs on the machine we
    already rent"; "Three databases: the working one, the published one, and
    the accounts"; "No passwords; what is held about a user, in full"; "What
    access becomes after beta is deliberately deferred"; "The owner's account is
    the superuser, and applications are managed on the site"; "The site records
    nothing about a visitor"; "Traffic comes straight to the machine; Cloudflare
    holds the name only". And `tools/make_decisions_index.py` changes nothing.
    *Where from:* `PLAN.md`, Phase 1, "Infrastructure — settled 2026-09-15": the
    front end, what the site reads, what is held, the domain and its proxy
    question, and the beta gate deferred.

17. **The style decisions are recorded.** Each of `PHASE-1.md`'s seven style
    questions has its entry in `DECISIONS.md`'s contents: who the reader is —
    "Who the site is designed for, and the two questions a page must pass";
    type — "Prose runs narrow, tables run wide, and the data date sits inside
    the screenshot"; colour — "Colour means one thing, and an outcome is a word",
    with "The accent has a light value, because one value cannot serve both";
    the house style, layout and mode — "The house style comes from the owner's
    own site" and "Dark by default, and light as a setting from the outset";
    what it commits Phase 2 to, and where the data date sits — the "Prose runs
    narrow" entry; what the site is written with — "The site is written in
    Python, and what would make us change that".
    *Where from:* `PHASE-1.md`, "Discussion 2 — style", "What it has to answer",
    and "What closed it". **If an entry does not answer its question when read,
    that is a finding**, not a pass on the heading.

18. **What runs has a runbook with an undo.** `DEPLOY-RUNBOOK.md` has "A normal
    deploy", "The undo" and "When the site is down". `ACCOUNTS-RUNBOOK.md` has
    "The backup" with its undo, "The restore check", a section for each of the
    four checks, and "The undo, once there are real people".
    *Where from:* `PHASE-1.md`, "How the phase closes": anything other people
    depend on gets a written procedure, a rehearsal and a written undo.

19. **Every column is described, and the dictionary is current.**
    `tools/make_data_dictionary.py` runs, reports every column described in both
    databases, and changes nothing in `docs/DATA-DICTIONARY.md`.
    *Where from:* `CLAUDE.md`, "When the session touches data".

**Nothing new in the data.**

20. **The dataset is as Phase 0 left it.** 470 bills, 1291 stage records, 186
    provenance notes, 13 methodology notes, 474 staging lines; the error checker
    and the gaps list empty; no migration in `db/` other than `db/accounts/`
    added since Phase 0 closed on 15 September.
    *Where from:* `PLAN.md`, "Phase 0 — the dataset" and "The dataset, while the
    site is built"; Phase 1 "Must not" take on new data.

### Part B — the owner's sign-off

The runner sets these out and records the owner's answers. The runner does not
mark them.

- **B1. Approve, sign in, sign out, on the live site.** The owner approves a
  beta application on the admin screen, signs in with a code that arrives by
  email, sees their name at the top, and signs out. If no real application is
  waiting, the owner applies with a second address of their own, approves it,
  signs in with it, signs out, and deletes that account afterwards on the admin
  screen. The runner confirms by counts only that the number of people is back
  to what it was, and that the approval email and the code both arrived. *Where
  from:* `PLAN.md`, Phase 1 "Closes when".
- **B2. No data anywhere.** The owner reads every page in item 6, signed out and
  signed in, and says that no page carries a figure, a table, a chart or a
  download, and the welcome page is a welcome. *Where from:* `PLAN.md`, Phase 1
  "Must not".
- **B3. It looks as settled.** Dark by default, the light setting works and
  is remembered, and it reads as the house style. *Where from:* item 17's
  entries.
- **B4. The owner can explain it.** In the owner's own words and without the
  documents: where the site runs and what it reads; what is held about someone
  who applies, and when it is gone after they are deleted; how the owner gets
  in if email stops working; what is done when a deploy breaks the site; and
  what tells anyone if the nightly backup fails. Where the owner cannot, the
  documents are what failed, and it is recorded as that. *Where from:*
  `PLAN.md`, "A phase closes on … the owner's sign-off that they can explain
  what was built".

### Part C — the sweep

By the runner, after Part A, following `PLAN.md`, "The phase plan, and throwing
it away": every line of `docs/PHASE-1.md` goes to its home or goes, nothing is
cut until proved present in its new home, and the list of where each went is
recorded here with the run.

**Known before the sweep starts, so it is not discovered half way:**

- **The briefing files are not the phase plan.** Eight `docs/PHASE-1-*.md`
  files hold the settled wording and proposals: `-ADMIN-AND-EMAIL`, `-APPLY`,
  `-BACKUP-THEMES`, `-HOSTING`, `-SIGN-IN`, `-STYLE`, `-WHAT-IS-HELD`,
  `-WHAT-THE-SITE-READS`. The site's code, its templates, three tools, both
  runbooks and `DECISIONS.md` name them, and `tools/check_privacy.sh` reads
  `-WHAT-IS-HELD` as the wording of record. Some say they go when the phase
  closes. **Deleting them breaks those references**, so the sweep brings the
  owner a proposal for them before deleting any.
- **`PHASE-1.md` says the machine's renewal date is "still to record".** It is
  recorded, in the private notes, confirmed by the owner on 16 September. The
  line is stale, not open.
- **"Refreshing the published copy becomes a step in the promotion runbook"**
  is not in `PROMOTION-RUNBOOK.md`, because there is no published database. It
  belongs with Phase 2, and the sweep puts it where Phase 2 will find it.

### The run, 2026-09-16

**Run by a session that built nothing in Phase 1 and wrote no part of this
test.** No row, address or name from the accounts came into the conversation;
every look at them was a count or a yes/no.

**Part A: all twenty items pass.** Before starting, 470, 1291, 186, 13 and 474,
checker 0, gaps 0, one person in the accounts.

- **Items 1–5, done for real.** Live was `2026-09-16T16-01-09Z`, identical to
  `site/` at `968ce1e`, 23 files. Rolled back to `15-02-54Z`, health and apex
  `200`. Deployed again as `2026-09-16T16-28-17Z`: rehearsal `200` and `200`,
  then `200, 200, 301, 308, 200`; identical to the commit, the last of 8 lines
  in `switched`. `--stage-only` staged `16-37-00Z`, rehearsal `200` and `200`;
  `current` and `switched` unchanged. Certificate to 15 December 2026.
- **The site was on `15-02-54Z`, without the privacy page, from about 16:26 to
  16:28**, because auto mode's permission check refused the deploy in item 4
  after allowing the rollback in item 3. The owner switched modes and the deploy
  was run by the session. Nobody applied in the gap. **Lesson for anyone running
  items 3 and 4:** check the permission mode allows a deploy before rolling
  back, not after.
- **Items 6, 7, 12.** Seven pages `200`, `/admin` and the five data addresses
  `404`, `/health` `200`; the footer reads `No data published yet` on all seven;
  no `Set-Cookie` on any, nor on a `POST` to `/apply` refused with `400`. Both
  log counts `0`.
- **Items 8–11.** The site's login refused on `legdata`; the databases exactly
  as listed; the one mention of `legdata` in the release is a comment naming the
  owner-code script. 5432 and 8000 unreachable from the Mac, loopback only on
  the machine. Three tables, nine columns in order, no forbidden column name;
  `f|f|f`.
- **Item 13**, against `16-28-17Z` in one connection: apply FAIL at 1 then 21 of
  21; sign-in FAIL at 7 then 45 of 45; admin FAIL at 1 then 28 of 28; privacy
  FAIL at 2 then 15 of 15. Every clean-up line `left: 0`, the first three
  `everyone else as they were: yes`, broken runs included. One person before and
  after; no test port left listening.
- **Items 14–15.** Installed backup script identical to `deploy/legdata-backup`;
  each database sorted. Timer active, last run `success` at 15:54; the newest
  copies are `28a16463`, `be59a66c`, `adc2c406`, all from that run. The restore
  check: neither copy holds the other's database, the site's login saved, 1
  person, permissions intact, 21 of 21 described, 470, 1291, 186, 13, 474, 0, 0;
  databases as listed and `/tmp/restore-check` gone afterwards.
- **Items 16, 18, 19, 20.** Every heading present and the index unchanged; every
  runbook section present. The dictionary regenerated identical, every column
  described in both databases, at the start of this session; nothing changed
  the structure of either database afterwards. No migration outside
  `db/accounts/` since `db/103`, 15 September 15:15.
- **Item 17 passes, with a note on the item.** All seven questions are answered
  on reading, but two point at the wrong entry: typefaces and sizes are in "The
  house style comes from the owner's own site", not "Prose runs narrow"; how a
  reader moves around ("No left rail") is in "Prose runs narrow", not the
  house-style entry.
- **Found, not asked for:** the house-style entry promises a test page "built
  locally and never deployed". The owner's rule since 16 September is that
  nothing runs on the Mac, so it cannot be built as written. Taken to the owner
  with the sweep.
- **A slip of the runner's**: one command meant to write a file on the Mac also
  opened a connection that could at most have copied the restore check into
  `/tmp` on the machine. It ran nothing; the next step removed it.

**Part B.**

- **B1: done.** The owner applied with a second address, approved it, signed in
  and out, and deleted it. Confirmed by counts: two people while it existed, one
  approved and not the owner; one, the owner, afterwards. No `email not sent` in
  the site's log from 16:40.
- **B2 and B3: done**, the owner's word: "all pages and text looks fine", and
  both to be marked done.
- **B4: declined by the owner.** `PLAN.md` makes it a condition of closing the
  phase; the phase closes without it, on the owner's decision.

**Part C, the sweep.** Proposal put to the owner first. The owner agreed to all
of it except anything settling Phase 2: "No decisions on phase 2 should be made
at the end of this phase — that is for a new session." Three agents read the
four briefings that were only to go, each reporting what no permanent home
held; the rest was read by the runner.

*`PHASE-1.md`, where each part went:*

- The order, infrastructure then style → `DECISIONS.md` 2026-09-15, "Infrastructure is settled before style".
- Where the front end runs, and the one-company rule → `DECISIONS.md` "The front end runs on the machine we already rent"; `STANDING.md` standing positions.
- The renewal date "still to record" → stale; in the private notes. Dropped.
- The three databases, the accounts in the backup from the first day → `DECISIONS.md` "Three databases"; `ACCOUNTS-RUNBOOK.md` "The backup".
- Refreshing the published copy as a promotion step → `DECISIONS.md` "Three databases", and now `STANDING.md`'s "Three databases" position.
- The data date → `DECISIONS.md` "Every page carries the date"; `STANDING.md`.
- Publishing the bills as files → `DECISIONS.md` "Three databases"; now `STANDING.md`, left for Phase 2.
- What is held about a user, the beta gate deferred, the domain and Cloudflare → `DECISIONS.md` 2026-09-15 and 16; `STANDING.md`; `PLAN.md` Phase 1.
- The seven style questions and their answers → `DECISIONS.md` (item 17).
- What style did not settle: chart colours and a second accent → `STANDING.md`, left for Phase 2. The wording of pages → written when built; now `docs/wording/`.
- What gets built, the must-not, the temptation, how the phase closes, the sweep's homes → `PLAN.md` Phase 1 and "The phase plan, and throwing it away".
- "What has been tried": empty. Status paragraphs: working detail, dropped.

*The briefings:*

- `-APPLY`, `-SIGN-IN`, `-ADMIN-AND-EMAIL`, `-WHAT-IS-HELD` → the wording, with its amendment dates, to `docs/wording/`. Every answer to their questions found in the four 2026-09-16 entries. The "Checked, and true" list → `ACCOUNTS-RUNBOOK.md` "The privacy page". Header wording and the apply page's last line moved to the pages they are on.
- `-HOSTING`: 14 statements present, 17 working detail. Not held: the machine's monthly cost → to the owner.
- `-WHAT-THE-SITE-READS`: the published copy read-only to the site, heavy use competing with loading → `STANDING.md`, left for Phase 2.
- `-BACKUP-THEMES`: 22 present, 14 working detail. Not held: why five weeks → `DECISIONS.md` entry; never restored off the machine → `STANDING.md`; `restic rewrite` to take a database out of old copies → `ACCOUNTS-RUNBOOK.md`.
- `-STYLE`: 35 of 37 values in the stylesheet; the light accent `#2f6cc4` recorded, its hover `#24559b` not → added to `DECISIONS.md`. Tones, second accent, and the forms' filled buttons against "text links rather than buttons" → `STANDING.md`. The example device texts → dropped; the stylesheet has the devices.

*Everything that pointed at the files* — the site's comments, the three account checks and the privacy check, the backup rehearsal, the owner-code script, the stylesheet, the accounts runbook, `DECISIONS.md`'s style pointer — re-pointed, committed as `474e826`.

*Because that changed the site's code*: staged `17-10-32Z`, rehearsal `200` and `200`; against it privacy FAIL at 2 broken then 15 of 15 with `docs/wording/PRIVACY.md`, apply 21, sign-in 45, admin 28, everyone else as they were, one person before and after. Deployed `17-11-22Z`, `200, 200, 301, 308, 200`, identical to `474e826` in all 23 files. The owner-code script reinstalled: the old installed copy matched the old commit, the new one matches the new, `700 root root`, and it parses.

*Deleted:* `PHASE-1.md`, the eight briefings, and the sweep proposal.

### What this test does not check

- **That the site is secure.** No one has reviewed the site's code or the
  machine for security. Items 8, 9, 11 and 12 check what was settled, not what
  an attacker could do.
- **That email reaches a real university inbox.** The checks send to Resend's
  test addresses. B1 sends one real email to an address of the owner's choosing.
- **That a certificate renewal works.** None has happened yet.
- **That anyone would be told if the backup failed.** Nothing does, and that is
  known (`STATE.md`, "Waiting for you"). Item 15 checks only that it ran.
- **Browsers other than the owner's**, screen readers and small screens.
- **Anything about the data.** Phase 0's tests closed it; item 20 checks only
  that Phase 1 did not change it.
- **The published database**, which does not exist and is not Phase 1's.

---

## An undo leaves an untouched bill alone

Written 2026-09-15 by the session that found the fault, built `db/103` and
changed both `tools/promote_session.sql` and `tools/rollback_promotion.sql`.
**It has been run and has passed**, on 2026-09-15: Part A by a session that did
none of that work, and Part B by the owner. The run is recorded below.

The Session 7 test found that taking Session 7 off the clean sheet took the
Gender Recognition Reform Bill off with it, although Session 7 changed not one
cell of it. That bill belongs to Session 6. The owner's decision, 2026-09-15:
a bill that was only restated stays put, and one that was written over still
comes off, because there is no copy of what it read before. Which case a line
is in is now recorded on the line when it is promoted, rather than worked out
afterwards from the wording of provenance notes.

**What to expect before starting.** At the time of writing: 470 bills, 1291
stage records, 186 provenance notes, 13 methodology notes, an empty error
checker and an empty gaps list. Four staging lines point at an earlier session's
bill, and no more will exist until another session is read in.

### Part A — mechanical

1. **Four lines carry a number, and no other line does.** `bill_candidate`
   holds `continued_bill_cells_changed` for candidates 412, 440, 468 and 474,
   reading 4, 6, 6 and 0; every other line is empty. Both checks are on the
   table: a line that continues nothing may not carry a number, and a number may
   not be negative.
   *Where from:* `db/103`. Those four are the only lines in the database that
   point at a bill of an earlier session.

2. **The four numbers are not taken on trust from the migration.** *Not in the
   script.* Inside a transaction that is thrown away: take Session 7 off, then
   Session 6 off, then promote Sessions 5, 6 and 7 again in that order, and read
   the four numbers. Expected: 412=4, 440=6, 468=6, 474=0, worked out by
   promotion from the staging lines and the clean sheet. Roll back.
   *Where from:* the migration counted provenance notes; promotion compares each
   line against the bill in front of it. Two routes with nothing in common, and
   the answer only counts if they agree. A number here decides whether a bill is
   deleted, so it is the one thing in this change that must not be assumed.

3. **Taking Session 7 off leaves the Gender Recognition Reform Bill alone.**
   *Not in the script.* Inside a transaction that is thrown away: take Session 7
   off. Expected: 469 bills, bill 473 gone, **bill 393 still there and identical
   in every column, its own timestamp included**, 1291 stage records, 186
   provenance notes, bill 393 still carrying its three stage records and its
   four provenance notes, and both Session 7 lines left with no bill number, no
   date and no count. Roll back.
   *Where from:* the owner's decision of 2026-09-15. This is the item the whole
   change exists for. Bill 393 is a Session 6 bill and Session 6 is not being
   taken off.

4. **The tool says so on screen, and not only in the data.** In the same run:
   the table headed "Bills of an earlier session that this session wrote over"
   is empty, the table headed "which STAY" lists bill 393 with no stage records
   coming off, and the closing message reads "Session 6 stayed where it is: this
   session restated 1 of its bills and changed nothing on them, so they were left
   alone. Nothing to promote again."
   *Where from:* a person deciding whether to go ahead reads the screen. If the
   data is right and the screen says the old thing, the change is half done.

5. **Taking Session 6 off still takes its three Session 5 bills off.** *Not in
   the script.* Inside a transaction that is thrown away: take Session 7 off,
   then Session 6 off. Expected: bills 303, 304 and 305 gone, 386 bills, and the
   closing message still reads "Session 5 also came off, because this session had
   written over 3 of its bills. Promote Session 5 again as well, and in that
   order." Roll back.
   *Where from:* those three lines changed 6, 6 and 4 cells. The behaviour was
   meant to narrow in one case and in no other, and this is what says it did.

6. **The preview matches what the script then does.** In the two runs above,
   compare the "About to remove" table against the difference between the
   figures before and after. Expected for Session 7: 1 bill, 0 stage records, 0
   provenance notes, and 470→469, 1291→1291, 186→186. Expected for Session 6:
   83 bills, 229 stage records, 85 provenance notes, and 469→386, 1291→1062,
   186→101.
   *Where from:* the Session 7 test found this table under-reporting — it said
   one bill and then removed two. It is the number a person reads before
   deciding, so it is checked against the deletion rather than against itself.

7. **It refuses rather than guesses.** *Not in the script.* Inside a transaction
   that is thrown away: empty line 474's number, then take Session 7 off.
   Expected: it stops with "Refusing: line(s) 474 point at an earlier session's
   bill and do not record how many cells they changed", and nothing is deleted.
   Roll back.
   *Where from:* every line promoted before `db/103` had no number, and a
   database restored from an older copy would have none either. A missing number
   must never be read as nought, because nought is the answer that spares a bill
   and a wrong sparing leaves a bill whose provenance cites a session that is no
   longer there.

8. **A stage record added to a bill that stays comes off, and nothing else of
   that bill does.** *Not in the script.* Inside a transaction that is thrown
   away: take Session 7 off; delete bill 393's Stage 3 record; promote Session 7
   again, so that line 474's Stage 3 row is now carried onto the bill; then take
   Session 7 off once more. Expected: bill 393 is still there with its other two
   stage records untouched, the Stage 3 record Session 7 made is gone, the count
   on line 474 is still 0 throughout, and line 474's stage row is back to
   unpromoted. Roll back.
   *Where from:* a line can restate a bill's cells and still bring a stage the
   bill has not got. Session 7 happens not to, so the path is not exercised by
   any real data and has to be built to be tested.

9. **Nothing was written by any of this.** 470 bills, 1291 stage records, 186
   provenance notes, error checker and gaps list empty, before and after the
   whole of Part A.

10. **Every column is still described.** `tools/make_data_dictionary.py`
    produces no difference from the committed dictionary: 19 tables, 182
    columns, all described.
    *Where from:* the standing rule. The count went from 181 to 182 with the new
    cell.

### Part B — the owner's sign-off

1. **That a bill only restated stays, and a bill written over still comes off.**
   The decision itself, taken on 2026-09-15 after being shown the three ways it
   could go and what each would cost. **Given on 2026-09-15.**

2. **That you can explain how this database works** from the documents alone,
   without help. The standing requirement. **Given on 2026-09-15**, on the same
   reading that completed the Session 7 test.

**Part B is complete**, and with Part A's ten items the `db/103` test is
complete.

### What this test does not check

- **Anything about Session 7's data.** Its own test covers that. This one is
  about what happens when a session is taken off again.
- **A line that changes cells on one bill and restates another, in the same
  session.** No such session exists. The tool handles them one bill at a time
  and item 5 shows the two cases separating, but the mixed case has no data
  behind it.
- **Taking sessions off in the wrong order.** The refusals that stop that are
  older than this change and are untouched by it.
- **Whether the four numbers describe the right cells.** Items 1 and 2 check
  that two independent routes agree on how many. What the changed cells were is
  the Session 6 test's business, and it has been run.

### The run, 2026-09-15, by a session that built none of it

**Run by a session that found no part of the fault, built no part of `db/103`,
changed neither tool and wrote no part of this test.** Its own opening check had
already read the same figures independently.

**All ten mechanical items pass.** Nothing was written. Items 2, 3, 5, 7 and 8
were each built inside a change that was thrown away, and 470 bills, 1291 stage
records, 186 provenance notes, 13 methodology notes, an empty error checker and
an empty gaps list were the figures before the first of them and after the last.

Worth naming from among the ten:

- **Item 2, the four numbers agree from the other end.** Session 7 was taken
  off, then Session 6, and Sessions 5, 6 and 7 were put back in that order.
  Promotion worked the numbers out for itself from the staging lines and the
  clean sheet in front of it, and reached 412=4, 440=6, 468=6, 474=0 — the same
  four the migration had filled in by counting provenance notes. The clean sheet
  came back to 470 bills, 1291 stage records and 186 provenance notes.
- **Item 3, the bill is untouched in every column.** With Session 7 off, bill
  393 was compared against the copy of itself taken before the undo, column by
  column across the whole row and not only the eight cells promotion writes.
  Not one column differs, the database's own timestamp included. It still
  carries its three stage records and its four provenance notes, bill 473 is
  gone, and both Session 7 lines are left with no bill number, no date and no
  count.
- **Item 4, the screen says it too.** "Bills of an earlier session that this
  session wrote over" is empty; "which STAY" lists bill 393, Session 6, Gender
  Recognition Reform (Scotland) Bill, with 0 stage records coming off; and the
  closing message reads word for word "Session 6 stayed where it is: this
  session restated 1 of its bills and changed nothing on them, so they were left
  alone. Nothing to promote again."
- **Item 5, the narrowing is confined to the one case.** Taking Session 6 off
  still takes bills 303, 304 and 305 with it, leaves 386 bills, and still says
  "Session 5 also came off, because this session had written over 3 of its
  bills. Promote Session 5 again as well, and in that order."
- **Item 6, the preview now matches the deletion.** For Session 7 it printed 1
  bill, 0 stage records, 0 provenance notes, and the figures went 470→469,
  1291→1291, 186→186. For Session 6 it printed 83, 229 and 85, and the figures
  went 469→386, 1291→1062, 186→101. Both match exactly, which is what the
  Session 7 test found they did not.
- **Item 7, it refuses.** With line 474's number emptied, taking Session 7 off
  stops on "Refusing: line(s) 474 point at an earlier session's bill and do not
  record how many cells they changed. Promote the session again with the current
  tool, which writes it, before taking it off." Nothing was deleted: the counts
  afterwards are 470, 1291 and 186.
- **Item 8, the path no real data exercises.** Session 7 was taken off, bill
  393's Stage 3 record deleted, and Session 7 promoted again, so that line 474's
  Stage 3 row was carried onto the bill for the first time and stamped with the
  record it made. Taking Session 7 off again removed that record and nothing
  else: bill 393 is still there, its Stage 1 and Stage 2 records are the same two
  records they were — the same numbers, not rebuilt ones — line 474's count read
  0 throughout, and its stage row is back to unpromoted.
- **Item 10.** The data dictionary regenerates with no difference from the
  committed file: 19 tables, 182 columns, all described.

**How the throwaway changes were made.** Both tools were run through
`tools/strip_for_rehearsal.py` and included inside one change that ended in a
discard, which is the standing method. The one thing added for this run was a
line dropping the tools' working tables between runs, because each tool makes
them afresh and a single change can only hold one set. That line touches nothing
the tools read or write, and neither tool was altered.

**One thing the run turned up that no item asked for.** Six working files from
the Session 6 dates work of the morning of 15 September are still in `/tmp/load`
on the server, although the sanity check recorded that day says every working
file in `/tmp` and `/var/tmp` had been removed. Nothing depends on them and
nothing is wrong in the database; the claim was simply wider than the fact.

---

## Session 7, and the first bill that has not finished

Written 2026-09-15 by the session that reviewed Session 7, built `db/102` and
promoted the session. **It has been run and has passed**, on 2026-09-15: Part A
by a session that did none of that work, and Part B by the owner. Item 18 failed
at the first run and passed when run again after `db/103`. The run is recorded
below.

Session 7 is two staging lines and the smallest ingest this project will do, but
it is the first that puts a bill on the clean sheet which has not finished, and
the first where a further appearance restates an existing record without
changing a cell of it. Both are what this test is about.

**What to expect before starting.** At the time of writing: 470 bills, 1291
stage records, 186 provenance notes, 13 methodology notes, an empty error
checker and an empty gaps list. Items 1 to 4 move if another session is
promoted; items 5 onwards should not.

### Part A — mechanical

1. **Session 7 is two lines, and put one bill on the clean sheet.** Both
   `bill_candidate` lines for session 7 are `accepted` with `reviewed_at`
   2026-09-15; line 473 promoted to bill 473 and line 474 to bill 393.
   *Where from:* the fact sheet has two bills, one of them a further appearance
   of a Session 6 bill, which by M6 belongs to the session it was introduced in
   and so adds no bill.

2. **The clean sheet is 470 bills**, of which exactly one belongs to session 7.
   *Where from:* 469 before promotion plus the one new bill.

3. **No stage record was added, and none was changed.** 1291 stage records,
   the same number as before Session 7 was promoted.
   *Where from:* bill 473 has completed no stage, and line 474's only stage row
   is a Stage 3 the bill already has at the same date. Promotion adds the stages
   a continued bill has not got and never overwrites one it has (db/086).

4. **No provenance note was added.** 186, the same number as before.
   *Where from:* line 473's facts all come from its own source, and line 474
   changed no cell, so there was nothing for a note to describe. Promotion
   writes a note only for a fact that did not come from the line's own source,
   and for a further appearance only for a cell that changed.

5. **Bill 473 reads as a live bill.** `outcome` `in_progress`, `enactment_status`
   `pending`, `date_introduced` 2026-09-09, `sp_bill_id` 1, `bill_type`
   `government`, and `date_concluded`, `date_royal_assent`, `asp_number` and
   `note` all empty.
   *Where from:* the Session 7 fact sheet, page 2: "Government Bill introduced
   on 9 September 2026 by Jenny Gilruth MSP." It says nothing else about the
   bill.

6. **Bill 473 has no stage records at all.** No rows in `stage_event` for it.
   *Where from:* the fact sheet records no stage for it, and the owner's dataset
   has none either. This is the first bill on the clean sheet with none.

7. **The further appearance changed nothing.** Bill 393's `outcome`, `note`,
   `enactment_status`, `date_assent_blocked`, `assent_block_route`,
   `assent_block_outcome`, `short_title` and `asp_number` each read exactly what
   they read before Session 7 was promoted — `passed`, `blocked`, 2023-01-16,
   `s35_order`, `still_blocked`, "Gender Recognition Reform (Scotland) Bill",
   and an empty asp number, with the note beginning "Not submitted for Royal
   Assent. On 16 January 2023 a Secretary of State made an order".
   *Where from:* rehearsed twice on 2026-09-15 inside transactions that were
   thrown away; the promotion's own "what changed" table returned no rows both
   times. This is the check that Session 7's sheet confirms the Session 6 record
   rather than disturbing it. **Bill 393's `updated_at` did move**, because
   promotion writes the eight cells whether or not they differ; that is the
   database's own stamp and not a cell a reader sees.

8. **Bill 393's provenance still cites the Session 6 fact sheet.** Four rows —
   `enactment_status`, `date_assent_blocked`, `assent_block_route`,
   `assent_block_outcome` — all `spice_factsheet_legislation`, `source_ref`
   "session 6, retrieved 2026-09-10", `observed_at` 2026-09-10.
   *Where from:* provenance describes where the value in front of the reader came
   from, and it came from the Session 6 sheet. `db/101` only rewrites a note's
   provenance where the cell changed, and nothing changed here. A row citing
   session 7 would mean a cell had moved.

9. **Line 474's Stage 3 row stayed on the staging sheet.** One `stage_candidate`
   row for candidate 474, `accepted`, 22 December 2022, with no
   `promoted_stage_event_id`.
   *Where from:* the bill already has that stage at that date, so the row stays
   as the second source that agrees. The error checker is what requires two
   sources for one stage to agree.

10. **The error checker and the gaps list are both empty.** No rows in
    `v_candidate_problems` or `v_stage_date_gaps`.
    *Where from:* the gaps list was written with live bills in mind — it asks a
    bill still before Parliament only for the stages below the furthest it has
    reached, so a bill that has reached none is asked for none. A row against
    bill 473 would mean that rule had been lost.

11. **The gaps list stays quiet for the right reason, not by accident.**
    *Not in the script.* Inside a transaction that is thrown away: add a Stage 2
    row to line 473, completed, dated. Expected: the gaps list then asks for
    Stage 1, because a live bill is asked for the stages below the furthest one
    it has reached. Roll back.
    *Where from:* the definition of `v_stage_date_gaps`, its `in_progress`
    branch. If the list stays empty after this, it is not exercising that branch
    and item 10 proves less than it appears to.

12. **M13 exists and says what it was agreed to say.** One `methodology_note`
    row, code M13, thirteen notes in all, `sort_order` 13, `applies_to`
    `{bill.outcome,bill.enactment_status,bill.date_introduced,stage_event.date_completed}`,
    and the body containing "not the same as a bill whose ending we could not
    find", "decided when the figure is drawn, not here", "a figure can cover all
    bills or only those that passed", "shown blank" and "nought days".
    *Where from:* `db/102`, and the owner's agreement of 2026-09-15.

13. **M13 does not contain either withdrawn draft.** The body contains neither
    "the difference is the bills still before the Parliament" nor "never reached
    its final stage".
    *Where from:* both were drafted, both were wrong, and both were caught before
    the note was applied. The first claimed the gap between a count of bills and
    a count of bills with a duration is the live bills; it was already 62 before
    Session 7 existed. The second stated a front-end decision as a property of
    the data. See `DECISIONS.md`, 2026-09-15.

14. **A timescale chart's Session 7 column is empty, not nought.**
    `v_stage_duration_summary` returns no row at all for session 7, and
    `v_bill_total_duration` holds no row for bill 473.
    *Where from:* the owner's instruction of 2026-09-15. Both views are built on
    periods between points a bill actually reached, so a bill with none
    contributes nothing rather than a zero. **This item can be moved by an
    outside change:** it moves the day a Session 7 bill completes a stage, which
    is the intended behaviour and not a failure.

15. **A bill that stopped early still has its periods.** In
    `v_bill_stage_durations`, bill 72 (School Meals (Scotland) Bill, rejected at
    Stage 1) has an introduction-to-Stage-1 period of 218 days with
    `bill_got_through_this_stage` false.
    *Where from:* the owner's instruction of 2026-09-15 that the flexibility to
    cover every bill with any terminal point, or only bills that completed every
    stage, must stay open. This item is the proof that M13 did not close it.

16. **Nothing else on the clean sheet moved.** Every bill other than 393 and 473
    has the same `updated_at` it had before Session 7 was promoted, and the
    per-session bill counts are 73, 81, 62, 86, 87, 80, 1.
    *Where from:* a promotion writes its own session's lines and the bills its
    lines continue, and nothing else. The safety copy
    `/var/tmp/legdata-before-db102-and-s7_2026-09-15.dump` is what to compare
    against if this fails.

17. **Every bill says where it came from.** No bill without a source, a
    reference and the day it was read — bill 473 included.
    *Where from:* the standing rule, and every earlier session's test item of the
    same shape.

18. **Rollback puts it back.** *Not in the script.* Inside a transaction that is
    thrown away: run `tools/rollback_promotion.sql` for session 7. Expected: 469
    bills, bill 473 gone, bill 393 still present and unchanged, 1291 stage
    records, 186 provenance notes, and both lines back to unpromoted. Roll back.
    *Where from:* the standing property that promotion is undoable, and the one
    part of it Session 7 tests that no earlier session did — taking a session off
    when one of its lines added nothing to the bill it points at.

    **Rewritten 2026-09-15, after the run below.** This item's expected answer
    was written before `db/103` and did not describe what the tool then did: it
    took bill 393 off as well. The owner's decision that day changed the tool to
    match the item rather than the item to match the tool, so the expected answer
    above now stands as written — and is checked properly in the `db/103` test,
    which exercises both cases and the refusal. **This item is not evidence until
    it is run again**, because the run recorded below was against the old tool.

    **Run again on 2026-09-15 against the current tool, by a session that built
    none of `db/103`: it passes.** 469 bills, bill 473 gone, bill 393 still
    present and not one column of it changed, 1291 stage records, 186 provenance
    notes, and both Session 7 lines back to unpromoted. Built inside a change
    that was thrown away; nothing was written.

### Part B — the owner's sign-off

None of these is for anyone else to answer. A sign-off is recorded here on the
day it is given, and nowhere else.

1. **That Session 7's two lines are right.** The new bill as the fact sheet
   states it, and the Gender Recognition Reform bill's second appearance
   restating the Session 6 record without changing it.
   **Given on 2026-09-15**, against both lines read in full before promotion.

2. **M13's wording, as a reader sees it.** Read in full on 2026-09-15, in three
   drafts: the first agreed, then withdrawn as false; the second withdrawn for
   writing a front-end decision into published methodology; the third agreed and
   applied.
   **Given on 2026-09-15.**

3. **That a timescale chart shows Session 7 blank, with this note against it.**
   The owner's own instruction, put here because it is what a reader sees.
   **Given on 2026-09-15.**

4. **That you can explain how this database works** from the documents alone,
   without help. The standing requirement, read in `HOW-THE-DATABASE-WORKS.md`
   with nobody walking through it. **Given on 2026-09-15.**

**Part B is complete. All four sign-offs were given on 2026-09-15**, and with
Part A's eighteen items the Session 7 test is complete. Session 7 is closed.

### The run, 2026-09-15

**Run by a session that reviewed no part of Session 7, wrote no part of
`db/102`, and wrote no part of this test.** Nothing was written: items 11 and 18
were built inside transactions that were thrown away, item 16 inside a scratch
database that was dropped afterwards, and 470 bills, 1291 stage records and 186
provenance notes were the same before and after, with the error checker and the
gaps list empty throughout.

**Seventeen of the eighteen mechanical items pass. Item 18 does not, and the
fault is in what the item expected, not in the database.** *Item 18 was run
again on 2026-09-15 after `db/103`, against the mended tool, and passes; the
account below is of the first run and is what the change came out of. All
eighteen now stand.*

Worth naming from among the seventeen:

- **Item 11, the branch does bite.** With a Stage 2 row added to line 473 inside
  a thrown-away transaction, the gaps list asks for exactly one thing: bill 473,
  Stage 1, "date not yet entered". So item 10's empty list is empty because the
  bill has reached no stage, not because the rule has been lost. The error
  checker also raised one row in that state — "Stage 2: fell_here is empty" —
  which is the invented row being incomplete and not a fault.
- **Item 16, taken against the safety copy.**
  `/var/tmp/legdata-before-db102-and-s7_2026-09-15.dump` was restored into a
  scratch database, the live database dumped in beside it, and the two compared
  row by row. One bill appeared, 473, and none vanished. Exactly one existing
  bill differs in any cell at all — bill 393 — and the one cell that differs is
  `updated_at`, from 11:40:56 to 13:27:40 on 15 September. No stage record and
  no provenance note appeared, vanished or changed: 1291 and 186 on both sides,
  identical row for row. M13 is the only methodology note that is new.
- **Item 7, proved rather than asserted.** The cell-by-cell comparison above is
  what settles it. Bill 393 reads exactly as it did before Session 7 was
  promoted, in every column of the bill and not only the eight the promotion
  writes, and `updated_at` is the only thing that moved.
- **Item 9, the second source that agrees.** Line 474's single Stage 3 row, 22
  December 2022, accepted, is still on the staging sheet with nothing saying it
  was promoted.

**Item 18 fails: rollback takes Session 6's bill off too.**

*Expected:* 469 bills, bill 473 gone, bill 393 still present and unchanged, 1291
stage records, 186 provenance notes, and both lines back to unpromoted.

*Found:* 468 bills. Bill 473 goes, as expected, and both staging lines go back
to unpromoted, as expected. But bill 393 comes off as well, taking its three
stage records and its four provenance notes with it — 1288 stage records and 182
provenance notes. The script says so while it runs: it lists bill 393 under
"Bills of an earlier session that this session added to, and which come off with
it", and it finishes "Session 6 also came off, because this session had added to
1 of its bills. Promote Session 6 again as well, and in that order."

This is what `tools/rollback_promotion.sql` has done since `db/081`, and its own
opening paragraphs describe it: a bill of an earlier session that a later
session's line points at has no copy of what it was before promotion, so it
comes off too and its own session is promoted again to put it back. **Promotion
is still undoable** — Session 6 and then Session 7 restores every cell by the
ordinary route — but the undo is wider than the item described, and the item was
written expecting the narrow one.

**What the run cannot decide, and is the owner's.** The script goes by whether a
line points at an earlier bill, not by whether the line changed anything. Session
7's line 474 changed no cell of bill 393, and bill 393 comes off regardless.
Whether that is right is a question about method, not a fault in the data.

**One thing the run turned up that no item asked for.** The script's own "About
to remove" table counts only the session being taken off. It printed 1 bill, 0
stage records and 0 provenance notes, and then removed 2 bills, 3 stage records
and 4 provenance notes. The bills listed in the table immediately above it are
not counted in it. Anyone running the script with `save=false` to see what it
would do is shown a figure smaller than what it then does.

**What happened next, the same day.** The owner took the wider undo as wrong:
the bill belongs to Session 6, and Session 6 is not the session coming off.
`db/103` records on each line how many cells it changed when it was promoted, and
the undo leaves a bill alone where that number is nought. The under-counting
preview was mended in the same change. Both are covered by their own test, above,
which this session did not run either.

### What this test does not check

- **Whether the Session 7 fact sheet is right.** It was read on 2026-09-10 and
  says what it says. Its two bills were compared against the owner's dataset and
  looked up at legislation.gov.uk before review; the sheet being wrong about
  something neither source covers is out of reach here.
- **Anything about Sessions 1 to 6.** Their own tests cover them. Item 16 checks
  only that Session 7 did not disturb them.
- **The bill that has not finished, after today.** Bill 473 was introduced six
  days before it was admitted. Everything about how it is recorded is provisional
  in the ordinary way — the next Session 7 fact sheet will say more, and M12
  governs what happens then.
- **Whether a chart is drawn correctly.** Item 14 checks that the data gives a
  chart nothing for Session 7. What a front end does with nothing is a front-end
  question, and by the owner's instruction of 2026-09-15 it stays one.

---

## A note we wrote is dated the day we wrote it

Written 2026-09-15 by the session that built `db/101` and changed
`tools/promote_session.sql`.

**Run 2026-09-15 by a session that built no part of it. All ten mechanical
items pass. Nothing was written: items 8, 9 and 10 were built inside
transactions that were thrown away, and 469 bills, 1291 stage records and 186
provenance notes were the same before and after, with the error checker and the
gaps list empty throughout. Item 3 was itself ambiguous and is rewritten; it was
not a fault in the data. Part B is the owner's and is not run here.**

`db/098` made a bill's note the eighth cell a further appearance carries, and
said why the note differs from the other seven: they are read off a fact sheet
and the note is written by us at review. It moved `source` to `manual` and left
`source_ref` and `observed_at` naming the Session 6 fact sheet and the day it
was retrieved. `db/101` moves all three together, and takes the date from the
line's own `reviewed_at` so no future session has to remember.

Found by item 14 of the Session 6 test above, which is what that item is for.

### Part A — the mechanical items

1. **The three rows now cite us, and are dated the day the notes were written.**
   Bills 303, 304 and 305: `source` = `manual`, `source_ref` = "written at
   review of session 6", `observed_at` = 2026-09-15.
   *Where from:* the three staging lines' own `reviewed_at`, which is
   2026-09-15 11:40:30 for all three, twenty-six seconds before the promotion
   that wrote these rows.

2. **No note row anywhere cites anything else.** Every `field_source` row with
   `field_name` = 'note' has a `source_ref` beginning "written at review of
   session ".
   *Where from:* db/101's own closing check, asked again from outside. There are
   three such rows in the database and no others.

3. **Each row still says what it said before, and now says what it used to say
   about itself.** This is the provenance row's own `note` column, not the
   bill's note, which item 6 requires to be untouched. Each of the three
   provenance rows still contains the earlier wording of the bill's note after
   "It read", and each ends with a sentence naming db/101, the date
   2026-09-10 and the reference it carried before.
   *Where from:* the same principle db/098 applied to the notes themselves —
   what a record said before is kept when it is rewritten.
   *Rewritten 2026-09-15* by the session that ran this test. It first said
   "Each of the three notes still contains the earlier wording after 'It read',
   and each ends with a sentence naming db/101" and named no column, which reads
   as the bill's note and contradicts item 6. Nothing in the data was wrong;
   both readings were checked.

4. **Nothing else in `field_source` moved.** Exactly three rows differ from what
   they were; none appeared and none vanished; 186 rows throughout.
   *Where from:* db/101 photographs every row before it writes and compares
   afterwards, character for character. This item asks the question the other
   way round: take a copy of `field_source` from
   `/var/tmp/legdata-before-db101_2026-09-15.dump` and compare.

5. **`assent_block_route` and `date_assent_blocked` still cite the Session 5
   footnote.** Five rows across bills 303, 304 and 305, `source_ref` = "session
   5, retrieved 2026-09-10".
   *Where from:* db/081's rule that a further appearance never changes those
   cells, and the Session 6 test's item of the same shape. **This is the trap in
   this migration:** the other cells are *not* all cited to the Session 6 sheet,
   so any check that assumed one citation would pass while being wrong.

6. **The notes on the clean sheet are untouched.** Bills 303, 304 and 305 read
   exactly as item 13 of the Session 6 test prints them, word for word.
   *Where from:* the owner agreed those three word for word on 2026-09-15. This
   migration is about provenance only and must not have moved them.

7. **The counts did not move.** 469 bills, 1291 stage records, 186 provenance
   notes, 0 on the error checker, 0 on the gaps list.
   *Where from:* the figures `STATE.md` carries, and db/101's own closing check.

8. **Promotion now writes these rows right without db/101.** Inside a
   transaction that is thrown away: take Session 6 off, promote Session 5 again,
   promote Session 6 again, and confirm the three note rows come out with
   `source_ref` "written at review of session 6" and `observed_at` 2026-09-15
   with no sentence naming db/101 in them — because the tool, not the migration,
   wrote them. Then confirm every bill and every stage record is identical to
   what it was, cell by cell, ignoring only `created_at` and `updated_at`.
   *Where from:* `tools/promote_session.sql` as this commit leaves it. Note that
   `promote_session.sql` makes temporary tables and is run twice here, so they
   must be dropped between the two runs.

9. **The date is taken from the line, not written in.** Change one of the three
   lines' `reviewed_at` to another day inside a thrown-away transaction, promote
   as in item 8, and confirm that bill's note row carries the new date while the
   other two do not.
   *Where from:* the rule as settled — the day the note was written is the day
   the line was reviewed — and the reason for taking it from the line: so that
   this holds for Session 7 and after without anybody remembering.

10. **The migration refuses a database that is not where it expects.** Inside a
    thrown-away transaction, run `db/101` a second time and confirm it refuses,
    naming the three note rows as not being where it expects them.
    *Where from:* its own opening guards. A migration that would run twice is
    one that could be run twice by accident.

### Part B — the owner's sign-off

1. **That "written at review of session 6" is what a reader should be told.**
   The alternative was to leave the fact sheet's reference beside a note we
   wrote. Agreed on 2026-09-15; put again here because it is what a reader sees
   against the note on three bills.
   **Given on 2026-09-15.**

**Part B is complete**, and with Part A's ten items it makes the `db/101` test
finished. No item of this test is outstanding.

### The run, 2026-09-15

**Run by a session that wrote no part of `db/101`, of the change to
`tools/promote_session.sql`, or of this test.** Nothing was written: items 8, 9
and 10 were built inside transactions that were thrown away, and 469 bills,
1291 stage records and 186 provenance notes were the same before and after,
with the error checker and the gaps list empty throughout.

**All ten mechanical items pass.**

Worth naming from among them:

- **Item 1, the twenty-six seconds.** The three Session 6 staging lines —
  candidates 440, 468 and 412 — all carry `reviewed_at` 2026-09-15 11:40:30,
  and the three provenance rows were created at 11:40:56. The date on the row
  is the day the line was reviewed, as the rule says, and not the day anything
  else happened.
- **Item 4, taken the other way round.** The pre-`db/101` copy was restored into
  a scratch database of its own and compared row by row against the live
  `field_source`: 186 rows in both, no id appeared and none vanished, and
  exactly three rows differ. In all three only `source_ref`, `observed_at` and
  the row's own `note` moved; `source` was already `manual`. The scratch
  database was dropped afterwards.
- **Item 5, the trap.** It is a real trap. The three bills' provenance divides
  three ways, not one: five rows cite "session 5, retrieved 2026-09-10" for
  `assent_block_route` and `date_assent_blocked`, thirteen cite "session 6,
  retrieved 2026-09-10" for the cells the Session 6 sheet gave, and three cite
  "written at review of session 6" for the note. A check that assumed a single
  citation would have passed while being wrong.
- **Item 8, the tool without the migration.** Session 6 taken off, Session 5 and
  then Session 6 promoted again with `tools/promote_session.sql` as this commit
  leaves it: the three note rows came out citing "written at review of session
  6" and dated 2026-09-15, with no sentence naming db/101 in them, because the
  tool wrote them and not the migration. Every bill and every stage record was
  identical to what it had been, cell by cell, ignoring only `created_at` and
  `updated_at` — 469 bills unchanged, 1291 stage records unchanged.
- **Item 9, the date comes from the line.** Moving candidate 440's `reviewed_at`
  to 2026-08-01 and promoting again put 2026-08-01 on bill 303's note row and
  left 304 and 305 at 2026-09-15. The date is read off the line, so Session 7
  and after get it right without anybody remembering.
- **Item 10, it refuses.** Run a second time, `db/101` stops with "Refusing: the
  three note rows are not where this migration expects them."

**Item 3 was itself ambiguous, and is rewritten** with what it first said. It
asked that "each of the three notes" keep the earlier wording and end with a
sentence naming db/101 — which reads as the bill's note, and item 6 requires the
bill's notes to be untouched. What actually holds it is the provenance row's own
`note` column, which does keep the earlier wording after "It read" and does end
naming db/101, 2026-09-10 and the reference the row carried before. Both
readings were checked; the data was right on the reading that was meant.

**Item 14 of the Session 6 test was then run again, and passes.** The three
rows carry `source` `manual`, `observed_at` 2026-09-15, and each keeps the
earlier wording after "It read". Item 14's own text was not touched by the
session that built `db/101` — it asked for 2026-09-15 before the failure and
asks for it still.

### What this test does not check

- **It does not check the notes themselves.** Their wording was agreed word for
  word on 2026-09-15 and is item 13 and sign-off 1 of the Session 6 test.
- **It does not check the other seven cells' provenance beyond item 5**, which
  the Session 6 test already covers.
- **It says nothing about sessions after 6.** Item 8 proves the tool writes the
  row correctly; whether Session 7's promotion does so in fact is Session 7's
  test.
- **It does not check M6**, which says nothing about dates and did not change.

---

## Session 6

Written 2026-09-15 by the session that admitted Session 6, promoted it, built
`db/098` to `db/100` and changed `tools/promote_session.sql`. It has not been
run. **A different session runs it**, as the procedure above requires.

Sessions 1 to 5 each had a test of this shape and Session 6 did not, which is
the drift the owner named on 2026-09-15: the week's work was tested in seven
pieces, each properly marked by another session, and nothing tested the session.
Those seven are below this entry and are **inherited, not re-argued**. What this
adds is what only exists once the session is on the clean sheet.

**Part A is mechanical.** Run `tools/closure_check_session_6.sql` and compare
each numbered block against the expected answer below. Items 16 and 17 are
deliberate faults and are not in the script; the session running this builds
each one inside a transaction it throws away.

**Part B is the owner's.** Nobody else can give those four.

### Part A — the mechanical items

1. **Counts.** 469 bills, 1291 stage records, 186 provenance notes, 0 problems
   on the error checker, 0 rows on the gaps list, 474 staging lines, 1295
   stage-date rows.
   *Where from:* 389 bills before, plus 80 — the fact sheet prints 83 entries and
   three of them are bills already on the clean sheet (M6). 1071 stage records
   plus 220, being the 223 stage dates admitted less the three the continued
   bills already had. The staging sheets do not move: nothing was loaded.
   **186 is recorded from the run and is not a prediction** — 112 before, 64 new
   notes on Session 6's own bills and 10 net on the three bills a second
   appearance changed.
   *An outside change can move this:* loading Session 7 moves every count.

2. **Every staging line reviewed, admitted, promoted and compared.** Sessions 1
   to 6 all `accepted`, with promoted and compared each equal to the number of
   lines: 73, 81, 62, 86, 87, 83. Session 7's 2 lines still `new`, 0 promoted.
   *Where from:* db/016, db/034, db/057, db/066, db/077 and db/099, each of which
   refuses to run unless the count is what it says.

3. **Every stage-date row reviewed and carried.** Session 6: 223 `accepted`, 220
   carried. Sessions 1 to 5 all `accepted` and all carried. Session 7: 1 `new`,
   0 carried.
   *Where from:* db/099 admits 223 and item 19 accounts for the three.

4. **No recorded difference left unadjudicated.** 0.
   *Where from:* the error checker refuses to let a line be admitted with one
   (db/044), and db/099 refuses to run while the checker finds anything.

5. **Session 6 on the clean sheet, by type and outcome.** Government: 60 passed,
   1 withdrawn. Member's: 6 passed, 5 rejected at Stage 1, 2 rejected at Stage 3,
   3 fell at dissolution, 3 withdrawn. 61 Government and 19 Member's, 80 in all.
   *Where from:* **the fact sheet's own counted summary**, read entry by entry on
   2026-09-14 and recorded in `STATE.md`: 55 Government and 5 Member's Acts, 6
   Government and 2 Member's awaiting Royal Assent, 10 fallen all Member's, 1
   Government and 3 Member's withdrawn — 62 Government and 20 Member's, 82. The
   two figures differ by exactly one Government bill and one Member's bill,
   which are the UNCRC and European Charter Bills: the fact sheet counts them in
   its Acts table and here they add to the Session 5 bills of the same name. So
   55 + 6 − 1 = 60 Government passed, and 5 + 2 − 1 = 6 Member's passed. The
   fallen 10 split 5 + 2 + 3 by db/092. The withdrawn 4 are the fact sheet's
   own; the Legal Continuity Bill is the third second appearance and the fact
   sheet excludes it from its totals in its own words.

6. **The arithmetic.** 83 printed entries, 3 second appearances, 80 bills.
   *Where from:* M6, which states 80 for Session 6 against the fact sheet's 82.

7. **The fourteen that did not pass.** 5 rejected at Stage 1, 2 rejected at
   Stage 3, 3 fell at dissolution, 4 withdrawn.
   *Where from:* db/092, which read all ten of the fact sheet's fallen bills in
   the Official Report, and the fact sheet's own withdrawn table.

8. **The seven the fact sheet left awaiting Royal Assent.** All seven `enacted`,
   with the numbers `db/091` records: 390 is 2026 asp 14, 391 asp 16, 392 asp 17,
   394 asp 15, 395 asp 13, 396 asp 19, 397 asp 18, each with a Royal Assent date
   in May 2026.
   *Where from:* legislation.gov.uk, read 2026-09-15 and recorded in db/091,
   where the dates also match the owner's dataset exactly.

9. **The one bill still stopped before Royal Assent.** Bill 393, the Gender
   Recognition Reform Bill: passed, `blocked`, `s35_order`, `still_blocked`,
   stopped on 2023-01-16. It is the only one in the whole database.
   *Where from:* the Session 6 fact sheet's footnote and db/093. The other three
   that were blocked are no longer: two were reconsidered and passed and one was
   withdrawn, all in Session 6.

10. **The five bills handled under emergency procedure**, each with the day the
    Parliament agreed to it: bills 433, 435, 453, 456 and 457.
    *Where from:* the Session 6 fact sheet, which is one of only two that state
    procedure, and db/087. Methodology note M10 tells a reader that a count of
    emergency bills counts only these.

11. **The three second appearances made no bills of their own.** 412 continues
    305, 440 continues 303, 468 continues 304; each stamped with the bill it
    continues, and none is a bill.
    *Where from:* db/081 and M6.

12. **The two bills reconsidered and passed.** Bill 303: `enacted`, 2026 asp 11,
    Royal Assent 2026-04-15, Reconsideration Stage reached 2026-02-04 and ended
    2026-03-03. Bill 304: `enacted`, 2024 asp 1, Royal Assent 2024-01-16,
    Reconsideration Stage reached 2023-09-14 and ended 2023-12-07. No other bill
    in the database has a Reconsideration Stage.
    *Where from:* the Session 6 fact sheet for the stage dates, and
    legislation.gov.uk for 303's title, number and assent date, read 2026-09-15
    and quoted on line 440. 304's number is the fact sheet's and the list of Acts
    for 2024 agrees.

13. **The three rewritten notes, in full, as a reader sees them.** Word for word:

    > **303** — Not submitted for Royal Assent when first passed. Following a
    > reference under section 33 of the Scotland Act 1998 by the Attorney General
    > and the Advocate General for Scotland, the Supreme Court ruled on 6 October
    > 2021 that some provisions of the bill were outwith the Parliament's
    > legislative competence, and it could not be submitted for Royal Assent in
    > its unamended form. The Parliament reconsidered the bill in Session 6 and
    > passed it again, and it received Royal Assent on 15 April 2026.

    > **304** — the same, ending: and it received Royal Assent on 16 January 2024.

    > **305** — Not submitted for Royal Assent. Following a reference under
    > section 33 of the Scotland Act 1998 by the Attorney General and the
    > Advocate General for Scotland, the Supreme Court ruled that some provisions
    > of the bill were outwith the Parliament's legislative competence, and it
    > could not be submitted for Royal Assent in its unamended form. The fact
    > sheet states no date for the ruling. The bill was withdrawn on 10 March 2022.

    *Where from:* the owner agreed each of the three on 2026-09-15, before they
    were written; db/098 wrote them onto the staging lines and the promotion
    carried them. Every date in them is sourced in db/098's own header.

14. **What those notes said before.** Three provenance rows, one per bill, each
    with source `manual`, observed 2026-09-15, and each keeping the earlier
    wording after "It read".
    *Where from:* db/098's rule that promotion writes the note's provenance as it
    does the other seven cells, with the note's own row saying it was rewritten
    at review rather than read off a fact sheet.

15. **No Act carries a note saying it never received Royal Assent.** No rows.
    *Where from:* this is the fault db/098 exists to prevent. Before it, promoting
    Session 6 would have returned bills 303 and 304 here.

16. **The new rule catches the fault it exists to catch.** *Not in the script.*
    Inside a transaction that is thrown away: blank `bill_note` on line 412 and
    the error checker raises "continues bill 305, which carries a note written
    from an earlier fact sheet, and this line has no note of its own". Put the
    note back and it goes quiet. Then set line 412's note to a string identical
    to bill 305's note and confirm the checker is quiet, because repeating the
    earlier wording is how a line says the note still stands.
    *Where from:* db/098, which states the rule and does not test it.

17. **Nothing the checker asked before db/098 stopped being asked.** *Not in the
    script.* db/098 replaced the whole error checker in order to add one rule, so
    the risk is a rule silently lost. Inside a transaction that is thrown away,
    give it four faults it refused before and confirm each is still refused: an
    Act's title with no year; a bill recorded as `blocked` with no note saying
    what stopped it; a stage dated before the stage before it; and a line
    continuing a bill from a later session.
    *Where from:* db/078, db/071, the stage checks, and db/082 respectively.

18. **Stage records for Session 6's bills.** Stage 1: 68 from the owner's
    dataset, 7 from bill pages, 5 from the Official Report. Stage 2: 68 from the
    dataset, 2 from bill pages. Stage 3: 66 from the fact sheet, 2 from the
    Official Report. 218 in all, and the two Reconsideration Stage rows sit on
    bills 303 and 304, which are Session 5 bills. 220 records written.
    *Where from:* the 136 dataset dates split 68 and 68, the 9 bill-page dates
    split 7 and 2, and the 7 Official Report dates split 5 and 2, which are the
    figures db/099 admits. The fact sheet's 71 are 66 Stage 3 records, the 2
    reconsideration rows, and the 3 at item 19.

19. **Accepted stage dates not carried: three.** One each on lines 412, 440 and
    468, all Stage 3. Lines 412 and 468 restate the date already on the bill
    they continue. **Line 440 does not, and must not:** it restates the Session 6
    fact sheet's "Passed on 23 May 2021", and bill 303's Stage 3 is 23 March
    2021. Both are expected. Promotion adds the stages a continued bill has not
    got and never overwrites one it has, so the bill keeps the adjudicated date
    while the staging line keeps what the Session 6 sheet printed.
    *Where from:* db/086 for the rule, and `DECISIONS.md` 2026-09-13 for the
    adjudication: the two fact sheets disagree, the Parliament's own bill page
    gives 23 March 2021, and the Session 6 date is deliberately kept on the
    staging sheet as what that document said. The item that proves the
    behaviour is item 13 of "Carried-over bills, and the blocked-bill record"
    below, which used this bill and this date as its fixture on 2026-09-14.
    *Corrected 2026-09-15*, having first been written as though all three
    restated the same date.

20. **Session 7's line.** Line 474 continues bill 393; both Session 7 lines still
    `new` and unpromoted. The error checker finds nothing and the gaps list holds
    nothing — the first time either has been empty since Session 6 was loaded.
    *Where from:* db/100. The two gaps the list held against line 474 were never
    missing dates: they are Stage 1 and Stage 2 on bill 393, from the owner's
    dataset.

21. **Nothing absurd in the durations.** No negative road to a final stage or to
    Royal Assent, nothing over 2000 days, and no bill that passed with no road at
    all. The five emergency bills reach their final stage in 3, 3, 6, 8 and 16
    days.
    *Where from:* the durations are read for the first time with Session 6 on.
    **The five figures are recorded from the run and are not a prediction**; what
    is predicted is that an emergency bill's road is short, which is what
    emergency procedure means.

22. **Every bill says where it came from.** No bill without a source, a reference
    and the day it was read.
    *Where from:* the standing rule, and Session 5's test item of the same shape.

23. **No provenance note's words are left hanging, and the three new notes end
    in a full stop.** No `field_source` row whose `value_seen` ends in "Read at",
    and each of bills 303, 304 and 305's notes ends in one.
    *Where from:* db/079, which is the only rule this project has ever settled
    about a note ending mid-sentence, and it is narrow on purpose: it forbids the
    one phrase "Read at", and its own words explain why a general rule was
    rejected — a source's words are quoted verbatim and end in dates, numbers,
    titles and web addresses, so a rule expecting a full stop would refuse most
    of the 106. The second half is db/098's own check on the three notes it
    wrote, asked here from outside.
    *Corrected 2026-09-15.* This item first asked for no note on the clean sheet
    ending in anything but `. ? ! "`, expected none, and cited db/079 for it.
    That is the rule db/079 considered and declined. Run as written it returns
    four Sessions 1 and 2 notes, every one of which rightly ends in a web
    address.

### Part B — the owner's sign-offs

None of these is for anyone else to answer. A sign-off is recorded here on the
day it is given, and nowhere else.

**All four given on 2026-09-15**, in one session, against the notes and the
paragraph read back in full rather than against a note about them. None of the
four changed anything: the three notes and M6's paragraph were signed off as
they stand. **Session 6 is closed.**

1. **The three notes as a reader now sees them**, read in full at item 13 — not
   as drafts, which is how they were agreed, but as what is on the clean sheet
   beside an Act of 2026 and an Act of 2024.
   **Given on 2026-09-15**, against all three read in full.

2. **M6's new closing paragraph**, read in full: "THE NOTE ON SUCH A BILL is
   written to cover the whole of its life, not the part of it the first fact
   sheet could see. Where a later fact sheet changes what the note should say,
   the note is rewritten, and what it read before is kept with the record of
   where each fact came from."
   **Given on 2026-09-15**, against the paragraph read in full.

3. **That Session 6's 80 bills and its fourteen endings are right.**
   **Given on 2026-09-15**, on the 83 staging lines and their 223 stage dates,
   before promotion.

4. **That you can explain how this database works** from the documents alone,
   without help. The standing requirement, put again because Session 6 is the
   first session that changes a bill already on the clean sheet in a way a reader
   sees.
   **Given on 2026-09-15.**

### The run, 2026-09-15

**Run by a session that wrote none of `db/098` to `db/100`, promoted nothing and
wrote no part of this test.** Nothing was written to the database by the run:
the two deliberate faults were built inside transactions that were thrown away,
and the bill count, stage count, provenance count, error checker and gaps list
were identical before and after.

**Twenty of the twenty-three mechanical items pass as written.** Items 1 to 13,
15, 16, 17, 18, 20, 21 and 22 each returned exactly their expected answer.

Worth naming from among them:

- **Item 16, the new rule.** Blanking line 412's `bill_note` brings the
  complaint out word for word as db/098 wrote it; restoring the note silences
  it; and setting the line's note to bill 305's wording character for character
  leaves the checker quiet, which is the "repeating the earlier wording" case
  the rule was designed to allow.
- **Item 17, nothing silently lost.** All four rules that existed before db/098
  still bite: an Act's title with no year, a bill recorded as blocked with no
  note saying what stopped it, a stage dated before the stage before it, and a
  line continuing a bill from a later session. Two of the four needed the fault
  rebuilding: dating a stage to 2019 and pointing a line at a bill that is not
  on the clean sheet each tripped a *different* rule first and never reached the
  one under test. The faults that do reach it are a Stage 3 dated between Stage 1
  and Stage 2 on a line that carries all three, and a Session 6 line pointed at a
  Session 6 bill.
- **Item 21, the durations.** Read for the first time with Session 6 on: nothing
  negative, nothing over 2000 days, no bill that passed with no road at all, and
  the five emergency bills reaching their final stage in 3, 3, 6, 8 and 16 days.

**One item failed, and the failure was real.**

- **Item 14.** The three note provenance rows carry `observed_at` 2026-09-10 and
  `source_ref` "session 6, retrieved 2026-09-10". The item expected 2026-09-15.
  db/098 set out to stop the note being attributed to the fact sheet and moved
  `source` to `manual`, but left the reference and the date pointing at the
  Session 6 sheet — so each row said the note had been seen in a document on a
  day when it did not yet exist. Nothing on the clean sheet was wrong; the
  account of where the note came from was. **Mended by `db/101` the same day**,
  with `tools/promote_session.sql` changed so the next session writes it right
  in the first place. That migration has its own test below, written by the
  session that built it and not run by it. **That test was marked on 2026-09-15
  by a session that wrote no part of it — all ten items pass — and item 14 was
  then run again and passes:** `source` `manual`, `observed_at` 2026-09-15, and
  each row keeping the earlier wording after "It read". Item 14's own text was
  never touched, so it asked for the same answer before and after.


**Two items were wrongly written, and neither is a fault in the data.**

- **Item 19** described all three uncarried Stage 3 dates as already on the bill
  with the same date. Line 440's is not: it restates the Session 6 sheet's
  23 May 2021 against bill 303's 23 March 2021. That disagreement was found,
  argued and settled on 2026-09-13, is recorded in `DECISIONS.md`, is written
  into the header of `tools/promote_session.sql`, and was used as the fixture
  for item 13 of the carried-over bills test on 2026-09-14. The behaviour is
  exactly what was decided. The item has been rewritten to say so.
- **Item 23** asked for no note on the clean sheet ending in anything but a
  full stop, question mark, exclamation mark or closing quote, and cited db/079.
  db/079 declined that rule in terms. Run as written it returns four notes from
  Sessions 1 and 2, each ending in a web address, and none of them wrong. The
  item has been rewritten to ask what db/079 actually settled.

**One thing in the documents contradicts the database**, found while checking
item 19 and mended in `DECISIONS.md` the same day: the 2026-09-13 entry gave as
its reason for rejecting 23 May 2021 that the date "falls between dissolution and
the new Parliament". It does not. Session 5 ended 4 May 2021, the election was
6 May and Session 6 first met on 13 May, so 23 May is ten days into the new
Parliament. The conclusion is untouched — the bill page settles the date at
23 March — but the sentence supporting it was wrong.

**Part A is finished.** Twenty items passed at the first run; item 14 failed,
was mended by `db/101`, and passes on the re-run of 2026-09-15; items 19 and 23
were rewritten that day to ask what had actually been settled, neither being a
fault in the data.

**Part B is complete. All four sign-offs were given on 2026-09-15**, none of
them changing anything. **Session 6 is closed.** No item of this test is
outstanding.

### What this test does not check

- **It does not check Session 7.** Its two lines are still `new`. Session 7 gets
  its own test.
- **It does not re-argue the seven piece-tests below it**, which a different
  session ran on 2026-09-15 and which passed on 35 of 35 mechanical items.
- **It does not check the three notes against a source for the Supreme Court's
  ruling.** That sentence is carried unchanged from the notes db/071 and db/072
  wrote off the Session 5 fact sheet's footnotes; only what follows it is new.
- **It says nothing about how Sessions 1 to 5's bills were handled.** No fact
  sheet before Session 6 states procedure, and M10 tells a reader so.

---

## Session 6's endings, and its stage dates

Written 2026-09-15 by the session that built `db/095` and `db/096` and changed
`tools/phd_stage_dates.py` and `tools/load_phd_stage_dates.sql`, which may
therefore not run it. **Nine items, all mechanical.** Nothing here writes to
the database; items 2 and 4 write only inside a transaction that is thrown away.

**Run 2026-09-15 by a session that built none of it. All nine pass.**

1. Passes. Fourteen endings, one per bill, no bill with two. Five
   `rejected_stage_1` at Stage 1, two `rejected_stage_3` at Stage 3, three that
   ran out of time at Stage 1 (Commissioner for Older People) and Stage 2
   (Ecocide, Freedom of Information Reform), four withdrawn at Stage 1. No
   Session 6 bill that did not pass is without one.
2. Passes, and more completely than asked. Run again unchanged it refuses:
   *Refusing: 24 line(s) already hold a stage row.* Each of the eight faults was
   then introduced on its own and each raised its own message: a mistyped line
   number (*name a line whose title does not match*), a Session 7 line (*not in
   Session 6*), a bill that passed (*passed or have no outcome*), a rejection
   dated a day late (*not dated the day the bill concluded*), a withdrawal given
   a date (*dated where nothing decided anything*), Ecocide's Stage 1 dated 2020
   (*outside the bill's life*), a bill page cited for a rejection and the
   Official Report cited for a withdrawal (both *cite the wrong kind of source
   for the outcome*), and an Official Report address the line does not carry
   (*cite a different Official Report page from the line*). A control run with
   the stage rows removed and nothing else altered passed, so the refusals are
   not simply refusing everything.
3. Passes. All four pages read again on 15 September still carry all three
   sentences, word for word, including *"This Bill was withdrawn at Stage 1 of
   the process to determine if it should become an Act."* The dates still agree
   with the fact sheet: 3 February 2026, 30 September 2025, 10 September 2025,
   16 January 2026. The three that ran out of time were read again with item 5
   of the fallen-bills test.
4. Passes. With bill 303's Stage 1 record deleted inside a transaction forced to
   roll back, the reader refuses: *line 440 'European Charter of Local
   Self-Government (Incorporation) (Scotland) Act 2026' is a further appearance
   of bill 303, but that bill holds only 1 of its first two stages on the clean
   sheet.* Run against the database as it stands it writes its 136 rows. Nothing
   was committed: bill 303 still holds three stage records.
5. Passes. Byte-identical to the CSV from the reader as it stood at 7d4a22c,
   693 lines, 675 of them dataset dates.
6. Passes. Session 6's CSV with line 390's Stage 2 moved to the day before its
   own Stage 1 is refused: *Check failed: the error checker finds 1 problem(s)
   this load has caused.* Unaltered it passes, loading 136 rows and reporting
   *1 problem(s) stood in the error checker before this load and still do.*
7. Passes. 223 stage rows: 136 `phd`, 71 `spice_factsheet_legislation`, 9
   `bill_page`, 7 `official_report`. All 223 are `new`.
8. Passes. Gaps list two rows, both line 474's; error checker one problem, line
   474's; clean sheet 389 bills, 1071 stage records, 112 provenance notes.
9. Passes. Both Stage 2 rows carry no date and no date reached, both say no
   Stage 2 proceedings took place, and each bill's only completed stage is
   Stage 1 — 5 February and 17 February 2026. Ecocide's page still reads *"A
   date for Stage 2 consideration of the Bill was not set prior to the
   dissolution of Parliament. Marshalled List and Groupings documents were
   therefore not produced"*, with the last amendment list dated 24 February
   2026. Freedom of Information Reform's lists no Stage 2 amendments and gives
   its financial resolution as agreed on 5 March 2026.

1. **Every Session 6 bill that did not pass says where it stopped, once.**
   Count the rows on the stage-dates sheet marked as where the bill ended, for
   Session 6. **Expected: 14, one per bill, and no bill with two.** Then check
   each sits at the right stage for its outcome: a bill rejected at Stage 1 ends
   at Stage 1, one rejected at Stage 3 ends at Stage 3, and the twelve that did
   not reach Stage 3 end before it. The expectation comes from the Parliament's
   own pages and Official Report, quoted in `db/092` and `db/095`, not from the
   database.

2. **The refusals in `db/095` refuse.** In a thrown-away transaction, run the
   migration again against the database it has already been applied to.
   **Expected: it refuses, naming the lines that already hold a stage row.**
   Then, still in a thrown-away transaction, alter its temp table one change at
   a time and check each refusal fires with its own message: a line whose title
   does not match its number; a line from another session; a bill that passed,
   given an ending; a rejection dated on a day other than the one the bill
   concluded; an ending dated where nothing decided anything; a completed stage
   outside the bill's own life; a row citing a bill page for a rejection, or the
   Official Report for a bill nothing decided; and a row citing an Official
   Report page the line itself does not cite.

3. **The four withdrawn bills' pages still say what `db/095` says they say.**
   Read all four pages again: Desecration of War Memorials, Disability
   Commissioner, Leases (Automatic Continuation etc.) and Prevention of Domestic
   Abuse. **Expected, on each: "... fell on <date>" under Stage 1, "Stage 2 has
   not been reached yet" below it, and "This Bill was withdrawn at Stage 1 of the
   process to determine if it should become an Act."** The date on each page must
   be the day the fact sheet already gives as the day the bill was withdrawn.
   **This is the item an outside change can move**: the Parliament revises its
   pages, and a page that now says something different is a finding, not a
   failure. The same goes for the three that ran out of time, whose pages
   `db/092` and `db/095` both rest on.

4. **The reader really is checking the lines it skips.** `tools/phd_stage_dates.py`
   writes nothing for a line that is a further appearance of a bill already on
   the clean sheet, because that bill holds its first two stages. In a
   thrown-away transaction, delete bill 303's Stage 1 record and run the reader
   for Session 6. **Expected: it refuses, naming line 440 and saying bill 303
   holds only one of its first two stages.** Put it back and it must run.

5. **Sessions 1 to 5 are unmoved by the change to the reader.** Run
   `tools/phd_stage_dates.py --sessions 1,2,3,4,5` and compare the CSV with one
   produced from the commit before this session's. **Expected: byte-identical,
   693 lines.** This is the same test the change to the reader passed when it
   was made, and it is here because a later change to the same file must pass it
   again.

6. **The loader still refuses a load that causes a problem.** `db/095` changed
   `tools/load_phd_stage_dates.sql` from "the error checker must be empty
   afterwards" to "the error checker must find nothing this load caused". Take
   Session 6's CSV, move one bill's Stage 2 date to before its own Stage 1, and
   run the loader with `-v save=false`. **Expected: it refuses, saying the load
   has caused one problem.** Run it unaltered and it must pass, reporting that
   one problem stood before the load and still does.

7. **What Session 6 now holds.** **Expected: 223 stage rows** — 136 from the
   owner's dataset, 71 from the legislation fact sheet, 9 from the Parliament's
   bill pages and 7 from the Official Report — **and all 223 waiting for
   review**, none accepted. The 136 is the reader's own count for the run of
   15 September; the 71, 9 and 7 are what the sheet held before it.

8. **Nothing is left unasked, and nothing new is wrong.** **Expected: the gaps
   list holds two rows, both Session 7's**, and **the error checker finds one
   problem, line 474's**, which waits on Session 6 being promoted. And the clean
   sheet is untouched by all of it: **389 bills, 1071 stage records, 112
   provenance notes.**

9. **The two bills that fell at Stage 2 read the same.** `db/095` described
   Ecocide and Freedom of Information Reform as different — two Stage 2 committee
   meetings on one, none on the other — and it was a misreading of the page. The
   owner ruled on 15 September that both completed Stage 1 and no more, and
   `db/096` corrected the notes. Check that **both Stage 2 rows say no Stage 2
   proceedings took place, both have no date and no date reached, and both bills'
   only completed stage is Stage 1**, dated 5 and 17 February 2026. Then read
   Ecocide's page again and check it still says "A date for Stage 2 consideration
   of the Bill was not set prior to the dissolution of Parliament", and that
   Freedom of Information Reform's still lists no Stage 2 amendments. **This is
   an item an outside change can move**, for the same reason as item 3.

### What this test does not check

- **It does not check any stage date against the Parliament's bill pages.**
  Session 6's 136 dataset dates are checked against each other and against what
  the sheet already held, and the error checker refuses dates in an impossible
  order — but a date that is wrong and still in order passes. 83 pages, and its
  own piece of work, exactly as Session 5 left it.
- **It does not check the review.** Every one of Session 6's 223 stage rows and
  83 lines is still waiting for the owner. Nothing here says the data is right,
  only that it is complete, consistent and traceable to what was read.
- **It does not check line 474**, the one problem the checker still finds.

---

## A bill that passed, was stopped, and was then withdrawn

Written 2026-09-15 by the session that built `db/094`, which may therefore not
run it. **Four items: three mechanical and one sign-off.** Nothing here writes to
the database.

**Run 2026-09-15 by a session that built none of it. The three mechanical items
pass; item 4 is for the owner.**

1. Passes. The two definitions differ in one place: a single replaced line, the
   rule this migration widened. Nothing is deleted — no hunk removes a line
   without replacing it, so no check disappeared.
2. Passes. Emptying line 412's two cells raises exactly one new complaint, on
   that line: *passed, but has no Royal Assent date, is recorded as
   'not_enacted' rather than as blocked or awaiting one, and says nothing about
   what followed the bill being stopped.* Put back, it goes. Across the whole
   database no line is in the state the rule refuses.
3. Passes on the line; **rehearsed, not witnessed, on the clean sheet.** Line
   412 reads `passed`, `not_enacted`, `s33_reference`, `withdrawn`, concluded
   2022-03-10, continuing bill 305. The promotion cannot be run for real until
   Session 6 has been reviewed, so it was dress-rehearsed inside a transaction
   that was thrown away, with the review stood in for by marking the session's
   rows accepted — the one thing in it that is not real. In the rehearsal bill
   305 comes out `passed`, `not_enacted`, `withdrawn`, concluded 10 March 2022,
   and its provenance note reads *"It read 'still_blocked' and now reads
   'withdrawn'."* **This item must be run again at the real promotion**, which
   is what the test says and what the rehearsal cannot replace.
4. **For the owner.** M5's wording. Untouched.

1. **The rebuilt error checker lost nothing.** Build the `db/090` view and the
   `db/094` view side by side under other names inside a transaction that is
   thrown away, read both definitions back out of the database, and compare them
   as text. **Expected: zero deleted lines, and the only change the one rule** —
   a bill that passed with no Royal Assent date now also passes the check if
   `assent_block_outcome` says what followed.

2. **The rule still refuses what it was written to refuse.** In a thrown-away
   transaction, empty line 412's two blocked-bill cells. **Expected: exactly one
   complaint on that line**, saying it is recorded as `'not_enacted'` rather than
   as blocked or awaiting one *and says nothing about what followed the bill
   being stopped*. Put them back and it must go. Then check the whole database:
   **no line at all is in the state the rule refuses.**

3. **The clean sheet ends up right.** Line 412 reads `passed`, `not_enacted`,
   `s33_reference`, `withdrawn`, concluded 2022-03-10, continuing bill 305.
   Today bill 305 reads `passed` and `still_blocked`. **Rehearse a promotion of
   Session 6 in a thrown-away transaction** — once Session 6 has been reviewed —
   and check bill 305 comes out `passed` and `withdrawn` with 10 March 2022
   beside it, and that a provenance note is written for
   `assent_block_outcome` saying it read `'still_blocked'` and now reads
   `'withdrawn'`. **This is the point of the whole change**: without it the clean
   sheet goes on saying a bill withdrawn in 2022 is still waiting for assent.

4. **Sign-off: is M5 still true enough?** `db/094` deliberately did not touch it.
   Two sentences in it have drifted: it says the mechanism that stopped a bill is
   recorded in `bill.note`, where since `db/084` it is also a cell of its own;
   and it closes by saying a bill's recorded state is the one given by the latest
   fact sheet read in, which M12 now qualifies for bills left awaiting Royal
   Assent. Neither makes anything in the data wrong. The question for the owner
   is whether the note a reader sees should be reworded, and if so the wording
   goes to them in full before it is changed.

### What this test does not check

- **It does not check the `withdrawn_from_earlier_session` section.** It is the
  one fact sheet section with no rule tying it to an outcome, and one line has
  ever been read from it. `db/094` says so and leaves it.
- **It does not check line 474**, the one problem the checker still finds. That
  waits on Session 6 being promoted.

---

## The blocked bills and two Act titles

Written 2026-09-15 by the session that built `db/093`, which may therefore not
run it. **Five items, all mechanical.** Nothing here writes to the database.

**Run 2026-09-15 by a session that built none of it. Four pass; item 1's number
has been overtaken by `db/094`.**

1. **The expectation is out of date, and nothing is wrong.** The checker finds
   **one** problem, not two: line 474's. Line 412's was settled later the same
   day by `db/094`, which widened the rule so that a bill saying what followed
   its being stopped accounts for itself. `db/093` wrote this item before that
   happened. The check that matters still holds: emptying line 412's two cells
   brings its complaint straight back, and nothing else anywhere complains.
2. Passes. Both read again at legislation.gov.uk on 15 September. *Dog Theft
   (Scotland) Act 2026*, 2026 asp 2, Royal Assent 10 February 2026, passed 16
   December 2025 — so the fact sheet's "2025 (asp 2)" was wrong in both cells,
   as `db/093` says. *European Charter of Local Self-Government (Incorporation)
   (Scotland) Act 2026*, 2026 asp 11, Royal Assent 15 April 2026. `title_kind`
   reads `act` on both. The European Charter page says the bill was *approved*
   by the Parliament on 3 March 2026, not passed — the Reconsideration Stage
   wording, and the same date as the Reconsideration Stage row on line 440.
3. Passes. Lines 393 and 474 both `s35_order`, `still_blocked`, and the
   quotation inside each `bill_note` matches `raw_footnote` word for word.
   Neither is `s33_reference`.
4. Passes on the lines; the consequence **rehearsed, not witnessed**. Lines 440
   and 468 read `reconsidered_passed`, `enacted`, each with a Reconsideration
   Stage row — 3 March 2026 and 7 December 2023. In the same thrown-away
   rehearsal described in the withdrawn-bill test, bills 303 and 304 come out
   `reconsidered_passed` and `enacted`, with provenance notes reading *"It read
   'still_blocked' and now reads 'reconsidered_passed'."* To be witnessed for
   real at the promotion.
5. Passes. 412 → 305, 440 → 303, 468 → 304, each by name as well as number.
   Line 474 points at nothing.

1. **The checker finds exactly two problems**, one on line 412 and one on line
   474, and nothing anywhere else. **Expected: 2.** Where the expectation comes
   from: `db/093`'s own closing check, and the two are the ones its header says
   it deliberately leaves.

2. **The two Act titles are right.** **Read them off legislation.gov.uk again**,
   not from here and not from the database: the Dog Theft (Scotland) Act 2026 at
   `asp/2026/2` and the European Charter of Local Self-Government
   (Incorporation) (Scotland) Act 2026 at `asp/2026/11`. Check the title, the
   number and that the Royal Assent date on each page matches the one already on
   the line — 2026-02-10 and 2026-04-15. Then check `title_kind` reads `act` on
   both. The Dog Theft line is the one to look at hardest: the fact sheet had the
   year wrong in the title and in the number, and only the number tripped a rule.

3. **The Gender Recognition Reform Bill says how it was stopped, in both fact
   sheets.** Lines 393 and 474: `s35_order`, `still_blocked`, and a `bill_note`
   that quotes the fact sheet's own footnote. **Check the footnote in
   `raw_footnote` against the quotation in the note, word for word.** The route
   must not be `s33_reference`: `ref_assent_block_route` explains why an
   executive order and a court ruling are not the same value, and getting it
   wrong would put this bill in with Session 5's three.

4. **The two reconsidered bills say so.** Lines 440 and 468:
   `reconsidered_passed`, `enacted`, and a Reconsideration Stage row on the line.
   **Then check the consequence:** promotion carries `assent_block_outcome` onto
   bills 303 and 304, which today read `still_blocked`. Rehearse a promotion of
   Session 6 in a thrown-away transaction once the two standing problems are
   gone, and check both bills come out `reconsidered_passed`.

5. **The second appearances point at the right bills.** 412 → 305, 440 → 303,
   468 → 304, by name as well as by number. Line 474 points at nothing, and
   must not: line 393 is not on the clean sheet.

### What this test does not check

- **It does not settle line 412.** Three of the checker's rules cannot all hold
  for that bill at once and the owner has been asked which gives. Until then the
  line carries only `continues_bill_id`.
- **It did not check `bill.note` for a continued bill.** When this was written,
  promotion did not carry `bill_note` onto a bill a line continues — only seven
  cells — so bills 303 and 304 would have kept the note Session 5 gave them,
  saying the bill could not be submitted for Royal Assent in its unamended form,
  while reading as enacted. That was raised in `STATE.md` as a question for the
  owner rather than a fault in `db/093`, and it stayed there until 2026-09-15,
  when the owner settled it: the note is the eighth cell a second appearance
  carries (`db/098`). **This exclusion no longer stands**, and what replaces it
  is items 13, 14 and 15 of the Session 6 test above. Nothing about `db/093` is
  changed by it.

---

## Why Session 6's ten bills fell

Written 2026-09-15 by the session that built `db/092`, which may therefore not
run it. **Six items: five mechanical and one sign-off.** Nothing here writes to
the database.

**Run 2026-09-15 by a session that built none of it. The five mechanical items
pass; item 6 is for the owner.**

1. Passes. Five, two and three, no Session 6 fallen line without an outcome, and
   the error checker silent on all ten.
2. Passes. All seven rejections carry `official_report_read_on` 2026-09-15, a
   `Result as recorded: "…"` quotation and an address, in `review_note`. The
   three that ran out of time carry no Official Report date.
3. **Passes, every figure.** All seven addresses opened again on 15 September.
   Line 400, 23 November 2023, S6M-11381, Pam Duncan-Glancy, *"For 19, Against
   90, Abstentions 0."* Line 405, 18 April 2024, S6M-12882, Mark Griffin, 20 /
   95 / 0. Line 404, 9 October 2025, S6M-19128, Douglas Ross, 52 / 63 / 0. Line
   407, 22 January 2026, S6M-20414, Sarah Boyack, 25 / 91 / 0. Line 403,
   3 February 2026, S6M-20627, Ash Regan, 54 / 64 / 0. Line 406, 24 February
   2026, S6M-20904, Graham Simpson, 30 / 66 / 27, and the Presiding Officer:
   *"For clarity, I note that the Scottish Parliament (Recall of Members) Bill
   is therefore not passed."* Line 398, 17 March 2026, S6M-21005, Liam McArthur,
   57 / 69 / 1, and *"The Assisted Dying for Terminally Ill Adults (Scotland)
   Bill falls."* Every motion, mover and figure is the one on the line.
4. Passes. Exactly five `member_motion_disagreed` across Session 6, all on
   Stage 1 rejections; the two Stage 3 rejections and the three dissolutions
   carry none.
5. Passes. The session row gives 2026-04-08 and records the pre-election recess
   from 26 March 2026. All three pages say the bill fell at dissolution on
   8 April 2026, and the last activity recorded on each is before the recess:
   5 February 2026 (Commissioner for Older People), 4 March 2026 (Ecocide),
   25 March 2026 (Freedom of Information Reform). The loader's proposal stands.
6. **Answered by the owner, 15 September: yes.** The distinction stands — a bill
   the Parliament refused to pass at Stage 3 is recorded as that, not as a bill
   that fell. Nothing needed building. See `DECISIONS.md`, 2026-09-15.

1. **The ten are answered, and split as `db/092` says.** Five `rejected_stage_1`,
   two `rejected_stage_3`, three `fell_dissolution`; no Session 6 fallen line
   without an outcome; and the error checker silent on all ten. **Expected: 5,
   2, 3, none and none.**

2. **Every rejection was read at the Official Report, and says so.** For the
   seven: `official_report_read_on` = 2026-09-15, a `Result as recorded: "…"`
   quotation, and an address. For the three that ran out of time:
   `official_report_read_on` **empty**, because nothing on those lines came from
   the Official Report — they were read at the Parliament's page for each bill,
   which is what `db/067` prescribes where the Parliament decided nothing.

3. **The seven divisions are right.** **Open each of the seven addresses and
   check the figures and the motion off the page itself** — not from the table
   below, and not from the database:

   | Line | Date | Motion | Mover | For / Against / Abstentions |
   |---|---|---|---|---|
   | 400 | 2023-11-23 | S6M-11381 | Pam Duncan-Glancy | 19 / 90 / 0 |
   | 405 | 2024-04-18 | S6M-12882 | Mark Griffin | 20 / 95 / 0 |
   | 404 | 2025-10-09 | S6M-19128 | Douglas Ross | 52 / 63 / 0 |
   | 407 | 2026-01-22 | S6M-20414 | Sarah Boyack | 25 / 91 / 0 |
   | 403 | 2026-02-03 | S6M-20627 | Ash Regan | 54 / 64 / 0 |
   | 406 | 2026-02-24 | S6M-20904 | Graham Simpson | 30 / 66 / 27 |
   | 398 | 2026-03-17 | S6M-21005 | Liam McArthur | 57 / 69 / 1 |

   **This item matters more than it looks.** A secondary summary of line 400's
   division gave figures that are not the ones the Official Report records. If
   any figure here disagrees with the page, the page wins and the line is wrong.

4. **A route sits only on a Stage 1 rejection.** The five have
   `member_motion_disagreed`; the two Stage 3 rejections and the three
   dissolutions have none. **Expected: exactly five routes across Session 6.**

5. **The three that ran out of time could not have been decided.** Check the
   session row: Session 6 ends 2026-04-08 and its note records a pre-election
   recess from 26 March 2026. Then **open each of the three bill pages** and
   check that the last recorded activity is before the recess and that the page
   says the bill fell at dissolution. **Expected: all three confirmed, and the
   loader's proposal standing.**

6. **Sign-off: are the two Stage 3 rejections rightly separated from the rest?**
   The fact sheet says only "Fell" for all ten. This session has made that into
   three different answers, and `rejected_stage_3` had one instance in the whole
   database before today — the Budget (Scotland) (No.2) Bill of Session 3, on a
   casting vote. The question for the owner is whether recording the Assisted
   Dying and Recall of Members bills as Stage 3 rejections, rather than as bills
   that simply fell, is the distinction they want the published data to draw.

### What this test does not check

- **It does not check any stage record.** None of the ten has one yet. Which
  stage each bill ended at, and `fell_here`, come with the stage dates, and the
  error checker's rules about them apply then — including whether a bill
  recorded as rejected at Stage 1 has a Stage 2 row it should not have.
- **It does not check the fifteen problems the checker still finds**, which are
  step 9's work.
- **It does not settle whether the Session 6 Disabled Children bill is a
  reintroduction** of the Session 5 bill of the same name by the same member.
  `reintroduced_from_bill_id` is left empty, which the data dictionary says
  means the bill did its own scrutiny — and it did, with its own committee
  report. Whether the published data should nonetheless link the two is a
  question for the owner, not a fault here.

---

## A fact sheet is a snapshot, and Session 6's comparison

Written 2026-09-15 by the session that built `db/089`, `db/090` and `db/091`,
the six hand-pairings in `tools/phd_stage_dates.py` and the one-sided report in
`tools/compare_sources.py`. It may therefore not run any of this. **Fourteen
items: thirteen mechanical and one sign-off.** Nothing here writes to the
database: every fixture runs inside a transaction that is thrown away.

**Run 2026-09-15 by a session that built none of it. All thirteen mechanical
items pass; item 14 is for the owner.**

**Before anything else**, record the three counts — bills, stage records,
provenance notes — and the error checker's and gaps list's sizes, and record
them again at the end. They must be 389, 1071 and 112 throughout, and the
checker must find 22 both times. Steps 7 and 8 of the runbook are the work that
clears those 22 and are not part of this test.

> **On the run: 389, 1071 and 112 held throughout, and the gaps list held two
> rows both times. The checker found one problem, not 22, both times.** Steps 7
> and 8 of the runbook ran later on the same day this test was written and
> cleared them — `db/092` to `db/096`. The figure is out of date, not wrong:
> what the item asks, that nothing here moves the counts, held.

### The rules

1. **The rebuilt error checker lost nothing.** Build the `db/088` view and the
   `db/090` view side by side under other names inside a transaction that is
   thrown away, read both definitions back out of the database, and compare
   them as text rather than by counting lines. **Expected: nothing removed —
   zero deleted lines — and the only additions are the three named in `db/090`:**
   the awaiting-assent look-up check, `'enacted'` joining the two values the
   awaiting-assent table may take, and the two date rules losing their
   `raw_… IS NOT NULL` condition and gaining the "fills a cell the fact sheet
   left empty" wording. Where the expectation comes from: `db/090`'s own header,
   which lists exactly what it changes.

2. **A Royal Assent date that fills an empty cell is now caught.** On a fixture
   line with `raw_date_royal_assent` empty, `date_royal_assent` set, and no
   citation in `review_note`: **expected exactly one new complaint,
   *date_royal_assent fills a cell the fact sheet left empty, but review_note
   carries no "Checked: date_royal_assent = ..." citation*.** Add the citation
   and the complaint must go. Where it comes from: this is the hole `db/090`
   says it closes, and the fault that let seven bills through.

3. **A Royal Assent date that contradicts the fact sheet is still caught.** The
   same fixture with `raw_date_royal_assent` printed and a different parsed
   date: **expected the old wording, *differs from the factsheet's own words
   (…)*, unchanged.** This is the item that proves `db/090` widened the rule
   rather than replacing it.

4. **The introduction date rule does both the same way.** Both halves of item 2
   and item 3 again for `date_introduced`. **Expected: the same two complaints,
   worded the same way.** Where it comes from: `db/090` closes this rule's
   identical hole at the same time, which the owner was told about after the
   eight parts were agreed and not before.

5. **Every awaiting-assent line must say it was looked up.** Take the
   `Checked: enactment_status = …` citation off one of the twelve lines in a
   thrown-away transaction: **expected exactly one complaint naming that line,
   and its text must name methodology note M12.** Put it back and the complaint
   must go. Then check the reverse: **expected zero such complaints across the
   whole database as it stands**, which is what `db/091` left.

6. **An awaiting-assent line may now be an Act, and could not be before.** In a
   thrown-away transaction, set one of the seven back to `pending` and check the
   checker is content, then to `not_enacted` and check it complains *read from
   the Bills awaiting Royal Assent table, but …*. **Expected: `enacted`,
   `pending` and `blocked` all pass, and nothing else does.**

### The bills

7. **The seven hold what `db/091` says.** For lines 390, 391, 392, 394, 395,
   396 and 397: `enactment_status` enacted, `title_kind` act, a Royal Assent
   date, an `asp_number` whose year is 2026, and a `short_title` ending in 2026.
   **Expected: all seven complete, and these exact values** —

   | Line | Act | Number | Royal Assent |
   |---|---|---|---|
   | 395 | Non-surgical Procedures and Functions of Medical Reviewers (Scotland) Act 2026 | 2026 asp 13 | 2026-05-12 |
   | 390 | Building Safety Levy (Scotland) Act 2026 | 2026 asp 14 | 2026-05-13 |
   | 394 | Greyhound Racing (Offences) (Scotland) Act 2026 | 2026 asp 15 | 2026-05-14 |
   | 391 | Children (Care, Care Experience and Services Planning) (Scotland) Act 2026 | 2026 asp 16 | 2026-05-15 |
   | 392 | Crofting and Scottish Land Court Act 2026 | 2026 asp 17 | 2026-05-18 |
   | 397 | Visitor Levy (Amendment) (Scotland) Act 2026 | 2026 asp 18 | 2026-05-21 |
   | 396 | Restraint and Seclusion in Schools (Scotland) Act 2026 | 2026 asp 19 | 2026-05-26 |

   Where the expectation comes from: **read each of the seven again at
   `https://www.legislation.gov.uk/asp/2026/<number>/introduction/enacted` and
   check the title, the number and the Royal Assent date off the page itself.**
   Do not take them from this table or from the database. `db/091` also records
   the day each bill passed as the fact sheet gives it; check that the page's
   "passed by the Parliament on" date agrees with the `raw_date_final` on the
   line, for all seven.

8. **Each of the seven carries four citations in the form promotion reads.**
   Apply promotion's own pattern —
   `Checked: ([a-z0-9_]+) = ([^\n]+?) \(([a-z_]+), ([^,]+), (\d{4}-\d{2}-\d{2})\)` —
   to each line's `review_note`. **Expected: `enactment_status`,
   `date_royal_assent`, `asp_number` and `short_title` each matched exactly
   once, with source `legislation_gov_uk` and date 2026-09-15, and the captured
   value equal to the value in the cell.** Line 390 carries a fifth, its
   introduction date from `db/089`. This matters because the value captured is
   what reaches the clean sheet as the provenance note's `value_seen`; a title
   with brackets in it is the case that could go wrong.

9. **The five that did not move did not move.** Lines 303, 304, 305, 393 and
   474: still `blocked`, still no Royal Assent date, no `asp_number`, title
   still a Bill's. **Expected: all five unchanged, each with exactly one
   `Checked: enactment_status = blocked` citation.** And on the clean sheet,
   bills 303, 304 and 305 unchanged in every cell and their provenance notes
   untouched — **expected 112 notes, none of them dated 2026-09-15.**

10. **`db/089`'s five cells.** Line 390 introduced 2025-06-05; line 424 Royal
    Assent 2021-11-15; line 465 Royal Assent 2022-03-03; line 432
    `Coronavirus (Discretionary Compensation for Self-isolation) (Scotland) Act
    2022`; line 453 `Non-Domestic Rates (Liability for Unoccupied Properties)
    (Scotland) Act 2026`. Where the expectations come from: **the Parliament's
    page for the Building Safety Levy Bill, and `asp 2021/20`, `asp 2022/1`,
    `asp 2022/2` and `asp 2026/1` respectively, read again.**

### The tools

11. **The comparison now runs clean on both sessions.** Run
    `tools/compare_sources.py` for Session 6 and for Session 7 and read the
    report; do not run the SQL. **Expected for Session 6: 80 of 83 lines paired,
    three unpaired and all three the known second appearances, zero one-sided
    cells, zero differences. For Session 7: 1 of 2 paired, one unpaired, zero
    and zero.** Then check the new report works at all: run it against the
    workbook as it was before this session — the copy is not kept, so rebuild
    the case by blanking one line's Royal Assent date in a thrown-away
    transaction — and **expect the one-sided cell to be named**.

12. **The six hand-pairings are right.** For each pair added to `MANUAL_PAIRS`
    at lines 419, 420, 421, 422, 432 and 453, check that the staging line and
    the named dataset row agree on both dates the two sources share. **Expected:
    all six agree on introduction and on Royal Assent.** This is the check that
    stops a bill's stage dates being attached to a different bill, which is the
    harm `MANUAL_PAIRS` exists to guard against.

13. **The working dataset.** `sources/phd/Billdates-September2026.xlsx`:
    **expected sha256
    `31b20b9cda180418ee78a62fcab6e30e076f1885c27d12ec62a6dea75324d69b`**, the
    Corrections sheet carrying a note dated 14 September 2026 with two entries,
    row 395's name reading "Discretionary Compensation for Self-isolation" and
    row 462's introduction date 5 June 2025. And **`tools/phd_stage_dates.py`
    for Sessions 1 to 5 must still give checksum
    `38e11f636b3ecd00db93c3d69c9b53a7d4dca48f6d1d416a38b8a45c00dc109c`**, which
    is what says none of the 675 stage dates the clean sheet holds from the
    dataset was disturbed. **An outside change can move this item**: correcting
    the dataset again moves the fingerprint, and only then.

### What the run found

1. Passes. Three hunks, every one a replaced line with its replacement, none a
   deletion, and the three are exactly the three `db/090` names. Nothing that
   the checker asked before it stopped asking.
2. Passes. Exactly one new complaint, worded as the item gives it. Nothing goes
   missing while it is there.
3. Passes. With the fact sheet's own date printed and different, the old wording
   comes back unchanged — so the rule was widened, not replaced.
4. Passes. Both halves, worded identically for `date_introduced`. Adding the
   citation clears it.
5. Passes. Removing the citation raises exactly one complaint, naming the line
   and methodology note M12. Across the database as it stands, all twelve
   awaiting-assent lines carry one and no such complaint is found.
6. Passes. Put back to `pending` as it stood before `db/091` — a Bill's title,
   no Royal Assent date, no number — the checker is content; the same line as
   `blocked` with a route and a note, content; as `not_enacted`, refused, *read
   from the Bills awaiting Royal Assent table, but outcome is 'passed' and it is
   recorded as 'not_enacted'*. Testing the rule on its own, `enacted`, `pending`
   and `blocked` pass and only `not_enacted` fires it.
7. **Passes, all seven, read again at legislation.gov.uk on 15 September.**
   Every title, number and Royal Assent date is the one in the table and the one
   on the line, and each page's *"passed by the Parliament on"* date agrees with
   the line's `raw_date_final`: 17 March (asp 13, 14), 18 March (15), 19 March
   (16) and 24 March 2026 (17, 18, 19).
8. Passes. Four citations on each of the seven, each matched exactly once by
   promotion's own pattern, source `legislation_gov_uk`, date 2026-09-15, the
   captured value equal to the cell — bracketed titles included. Line 390 carries
   its fifth, `date_introduced` from the bill page, read 2026-09-14. In the
   thrown-away promotion rehearsal all four arrive as provenance notes with the
   full value in `value_seen`, brackets and all, which is what the item was
   worried about.
9. Passes. All five still `blocked`, no Royal Assent date, no number, titles
   still a Bill's, one `Checked: enactment_status = blocked` citation each. 112
   provenance notes, none dated 2026-09-15.
10. Passes, all five, read again on 15 September. Carer's Allowance Supplement
    (Scotland) Act 2021, `asp 2021/20`, Royal Assent 15 November 2021.
    Transvaginal Mesh Removal (Cost Reimbursement) (Scotland) Act 2022,
    `asp 2022/1`, 3 March 2022. `asp 2022/2` gives *Coronavirus (Discretionary
    Compensation for Self-isolation) (Scotland) Act 2022*, exactly as on line
    432, lower-case "isolation" and all. `asp 2026/1` gives *Non-Domestic Rates
    (Liability for Unoccupied Properties) (Scotland) Act 2026*, exactly as on
    line 453. The Building Safety Levy Bill's page: *"The Bill was introduced on
    5 June 2025"*, and its stage dates — Stage 1 ended 8 January, Stage 2
    10 February, Stage 3 17 March 2026 — are the dataset's dates for line 390.
11. Passes. Session 6: 80 of 83 paired, three unpaired and all three the known
    second appearances (412, 440, 468), zero one-sided cells, zero differences.
    Session 7: 1 of 2, one unpaired, zero and zero. With line 395's Royal Assent
    date blanked inside a transaction forced to roll back — the state all seven
    were in before `db/091` — the one-sided cell is named: *line 395 … 
    date_royal_assent  this line -  dataset 2026-05-12*.
12. Passes. All six agree on introduction and on Royal Assent: 419/412
    2022-12-22 and 2023-03-27; 420/430 2023-12-21 and 2024-03-28; 421/445
    2024-12-18 and 2025-03-28; 422/469 2026-01-15 and 2026-03-31; 432/395
    2021-11-15 and 2022-03-23; 453/467 2025-11-24 and 2026-01-07.
13. Passes. The workbook's sha256 is
    `31b20b9cda180418ee78a62fcab6e30e076f1885c27d12ec62a6dea75324d69b`. Its last
    Corrections note is dated 14 September 2026 and carries two entries: row 395's
    name, now *Coronavirus (Discretionary Compensation for Self-isolation)
    (Scotland) Act 2022*, and row 462's introduction date, now 5 June 2025. The
    reader for Sessions 1 to 5 gives
    `38e11f636b3ecd00db93c3d69c9b53a7d4dca48f6d1d416a38b8a45c00dc109c`, 693
    lines.

### The owner

14. **Sign-off: does M12 tell a reader the truth, and enough of it?** Read it
    whole. It says the fact sheets are snapshots; that every bill left awaiting
    Royal Assent is looked up at legislation.gov.uk before it is admitted and
    the answer recorded either way; that where the Act has been made its date,
    number and title come from legislation.gov.uk with the day each was read;
    that the line still says it came from the fact sheet; and it names the seven
    bills. It also sends a reader to M5 for a bill that was stopped rather than
    waiting. The question for the owner is whether a researcher reading only
    M12 would understand why seven Session 6 Acts carry a different source from
    the other sixty.

    **Answered by the owner, 15 September, and the note is cut.** Reading it
    whole, they asked: "Why such a detailed explanation for the simple fact that
    we found the data to replace stale dates in the factsheet? Isn't that all we
    are saying?" Mostly it was. `db/097` cuts M12 from 290 words to 95 and
    retitles it *A fact sheet is a snapshot*. What goes: the second telling of
    "not a running record", the paragraph explaining line-source against
    field-source in the abstract, the list of the seven Acts — which duplicates
    the data and goes stale as sessions are added — and the closing paragraph on
    blocked bills, reduced to a clause pointing at M5. What stays: the snapshot
    and the seven Acts as evidence of it; that every awaiting-assent bill is
    checked **and the answer recorded either way**, which is what lets a reader
    tell "looked up, still no Act" from "never looked at"; and that the Act's
    date, number and title come from legislation.gov.uk with the day read. The
    procedure in `PROMOTION-RUNBOOK.md` is unchanged and still cites M12. The
    wording replaced is in `docs/STATE.md` as committed at `ccac41c`.

### What this test does not check

- **It does not check steps 7 and 8 of the runbook.** The 22 problems the error
  checker still finds are that work, untouched here.
- **It does not check promotion.** Session 6 cannot be promoted while those 22
  stand, so nothing here proves that four provenance notes per bill actually
  arrive on the clean sheet. Item 8 checks the citations are in the form
  promotion reads, which is not the same thing. The first promotion of Session 6
  must check it.
- **It does not check the other 71 Session 6 lines** beyond what the comparison
  says about them.
- **It does not check that legislation.gov.uk is right.** It is the source of
  record for an Act and is treated as such.
- **It cannot tell whether any other bill in the database has gone out of date
  since it was read.** The new rule covers bills a fact sheet left awaiting
  Royal Assent, which is where the problem showed itself. A fact sheet could in
  principle be stale about something else.

---

## The day a bill reached a stage

Written 2026-09-14 by the session that built `db/088`, which may therefore not
run it. **Seven items, all mechanical.** Nothing here needs the owner, and
nothing here writes to the database: everything runs inside a transaction that
is thrown away.

**Run on 2026-09-14** by a further session, which built none of `db/088` and
wrote nothing to the database: the counts were 389 bills, 1071 stage records and
112 provenance notes before and after, the error checker and the gaps list were
empty before and after, and no view or table was left behind on the server.
**All seven items as expected.** Four things came up while running them that the
test as written does not cover, and none of them is a fault in `db/088`:

- **Item 2's fixture is described short.** As the fixture is written out above it
  leaves `bill_type_stated` empty, and the error checker rightly says
  *bill_type_stated not proposed*. Filled with `members`, which is what the
  reader writes for this line, the checker says nothing at all and the gaps list
  is empty, which is what the item asks. The fixture needs that cell.
- **Item 5's complaint arrives among six, not alone.** The `db/088` one —
  *marked as a stage that did not happen, but reached on 2026-02-04* — is there,
  and the other five are `db/039`'s rules about a stage that did not happen,
  which the item says are not findings about `db/088`.
- **Item 7's second refusal could not be reached.** The clean sheet does refuse a
  day reached after the stage ended, by `stage_event_reached_before_it_ended`,
  exactly as the item says. But `stage_event_a_stage_that_did_not_happen_was_not_reached`
  never fires for this bill: an older rule refuses first, because only a Private
  Bill may skip a stage. The refusal exists and is unexercised, and exercising it
  needs a Private Bill.
- **Item 7's last sentence names one step where the scripts require two.**
  Taking Session 6 off on its own gives 388 bills, 1068 stage records and 108
  provenance notes, not 389, 1071 and 112 — because bill 303 is a Session 5 bill
  that Session 6 added to, so it comes off with Session 6. This is
  `rollback_promotion.sql` working as its own header says it does, and it prints
  *Session 5 also came off ... Promote Session 5 again as well, and in that
  order.* Doing that returns the counts to 389, 1071 and 112 exactly, and bill
  303 to the Bill title, `blocked`, `still_blocked`, no Royal Assent date and
  its three stage records. The expectation should say both steps.

**What each item gave.**

1. **The rebuilt views lost nothing.** Both views as `db/087` left them were
   built beside the live ones under other names inside a transaction that was
   thrown away, all four definitions read back out of the database, and the two
   pairs compared as text rather than by counting lines. **Nothing was removed
   from either: zero deleted lines in both diffs.** The error checker gains
   exactly the three new checks; the gaps list gains exactly the one new branch,
   *the Reconsideration Stage has a day it ended and nothing says when the
   Parliament agreed to it*. `date_reached` appears once in each rebuilt
   definition and only in the stage-rows CTE, which is how the new checks can see
   it at all.
2. **Nothing was said about a complete line.** No complaint about the fixture, no
   complaint anywhere else in the database, and an empty gaps list.
3. **A day reached after the stage ended.** Exactly one complaint, word for word:
   *Reconsideration Stage, from spice_factsheet_legislation: reached on
   2026-03-04, after it ended on 2026-03-03*.
4. **A day reached before the bill existed.** Exactly one complaint:
   *Reconsideration Stage, from spice_factsheet_legislation: reached on
   2020-05-04, before the bill was introduced on 2020-05-05*.
5. **A day reached on a stage that never happened.** The complaint is there, with
   `db/039`'s five beside it as above.
6. **A missing day reached.** The error checker says nothing. The gaps list
   carries one entry in the whole database — line 390, position 4,
   reconsideration, with the wording above. Putting the day back empties it. No
   Stage 1, 2 or 3 row anywhere is asked for a day reached.
7. **Refused on the clean sheet, carried by promotion.** The refusal is
   `stage_event_reached_before_it_ended`, and the same row with the days the
   right way round is accepted. Promoting Session 6 with the fixture whole and
   the error checker empty gave bill 303 a Reconsideration Stage record reading
   2026-02-04 and 2026-03-03, cited to the Session 6 fact sheet retrieved
   2026-09-10; its Stage 3 still read 2021-03-23, cited to Session 5; the bill
   read the Act title, `2026 asp 10`, `enacted`, 2026-04-15 and
   `reconsidered_passed`, with a provenance note cited to Session 6 behind each
   of the five changed cells; and the counts were 389 bills, 1072 stage records
   and 115 provenance notes.

`db/088` adds `date_reached` to both stage sheets, because the Session 6 fact
sheet gives two bills a Reconsideration Stage and prints two days for it — the
day the Parliament agreed to reconsider the bill and the day it approved it.
The migration writes nothing to the clean sheet: it adds an empty cell to each
stage sheet, two refusals to the clean sheet, three checks and one gaps-list
branch to the staging sheets, methodology note M11, and one widened definition.

**The fixture**, which every item after the first uses. One Session 6 staging
line for the European Charter of Local Self-Government (Incorporation) Bill as
review would leave it: a Member's Bill, introduced 5 May 2020, `continues_bill_id`
303, the Act title and `2026 asp 10` filled in, `enacted`, Royal Assent
15 April 2026, `s33_reference` and `reconsidered_passed`; with a Stage 3 row of
23 May 2021 and a Reconsideration Stage row reached 4 February 2026 and ended
3 March 2026. *The asp number is invented for the fixture; the real one is
settled from legislation.gov.uk at review.*

### The items

1. **The rebuilt views lost nothing.** Build the error checker and the gaps list
   as `db/087` left them beside the live ones under other names, read all four
   definitions back out of the database, and compare them as text. **Expected:**
   the error checker gains three checks and the new column arriving through its
   stage-rows CTE; the gaps list gains one branch and the same column. Nothing
   that was in a definition before is absent after. *From what the migration says
   it changes.* **This is the item that matters most**, for the reason `db/062`,
   `db/086` and `db/087` all say: a rebuild that drops a check is a rebuild that
   stops finding faults, and a line count cannot tell a reformat from a loss.

2. **A complete, consistent line is not complained about.** With the fixture
   present. **Expected:** the error checker says nothing about it and nothing
   anywhere else; the gaps list is empty, including for that line — its
   Reconsideration Stage has both days. *From the rule: everything the new
   checks ask about is satisfied.*

3. **A day reached after the stage ended is refused.** Set the Reconsideration
   Stage's `date_reached` to 4 March 2026. **Expected:** exactly one complaint,
   *Reconsideration Stage, from spice_factsheet_legislation: reached on
   2026-03-04, after it ended on 2026-03-03*. *From `db/088`.*

4. **A day reached before the bill existed is refused.** Set it to 4 May 2020,
   the day before the bill was introduced. **Expected:** one complaint,
   *reached on 2020-05-04, before the bill was introduced on 2020-05-05*, and no
   other. *From `db/088`.*

5. **A day reached on a stage the bill never had is refused.** Mark the row as a
   stage that did not happen, leaving the day reached. **Expected:** among the
   complaints, *marked as a stage that did not happen, but reached on
   2026-02-04*. The others are the rules `db/039` already had about a stage that
   did not happen, and they are not findings about `db/088`. *From `db/088` and
   `db/039`.*

6. **A missing day reached is a gap on this stage and is asked for on no other.**
   Put the row back as it was and empty `date_reached`. **Expected:** the error
   checker says nothing, and the gaps list carries one entry for that line at
   position 4, *the Reconsideration Stage has a day it ended and nothing says
   when the Parliament agreed to it*. No other line anywhere gains an entry, and
   no Stage 1, 2 or 3 row is ever asked for a day reached. *From the owner's
   decision of 2026-09-14 that it be flagged rather than refused, and from
   `db/088`.*

7. **The clean sheet refuses what the staging sheet only complains about, and
   promotion carries the cell.** First, try to write a stage record on the clean
   sheet reached 4 March 2026 and ended 3 March 2026. **Expected:** refused by
   `stage_event_reached_before_it_ended`. Then, with the fixture whole and the
   error checker empty, promote Session 6. **Expected:** bill 303 gains a
   Reconsideration Stage record reading 2026-02-04 and 2026-03-03, cited to the
   Session 6 fact sheet retrieved 2026-09-10; its Stage 3 record still reads
   2021-03-23, because promotion does not overwrite a stage the bill already has;
   the bill reads the Act title, `2026 asp 10`, `enacted`, 2026-04-15 and
   `reconsidered_passed`, with a provenance note behind each of the five changed
   cells; and the counts are 389 bills, 1072 stage records and 115 provenance
   notes. Taking Session 6 off again returns them to 389, 1071 and 112.
   *From `db/088` and `tools/promote_session.sql`.*

### What this test does not check

- **Any stage but the Reconsideration Stage.** No source states a day reached
  for any other, which is the whole point of M11, so nothing else is exercised.
- **That the two bills' dates are right**, or that they are the right two bills.
  That is the Session 6 ingest's own test, when there is one.
- **The reader.** It is tested separately, and its own test covers the two
  columns it now writes.
- **That M11 says the right thing to a reader.** That is the owner's to judge,
  and it is not a mechanical item.

---

## The prose reader for Sessions 6 and 7

Written 2026-09-14 by the session that built `tools/read_prose_factsheet.py`,
which may therefore not run it. **Eight items, all mechanical.** Nothing here
needs the owner, and nothing here writes to the database: the two load
rehearsals are run with `-v save=false`.

**Run on 2026-09-14** by a further session, which built none of the reader and
wrote nothing to the database: 389 bills, 1071 stage records and 112 provenance
notes before and after, and both load rehearsals rolled back. **All eight items
as expected.** Two notes, neither a fault in the reader:

- **Item 7's "69 stage-dates rows" is one of two numbers, and `STATE.md`'s "71"
  is the other.** The loader writes Session 6's stage dates in two goes: 69
  Stage 3 rows and 2 Reconsideration rows, 71 in all. Both figures are right
  about different things, and the item means the first.
- **One of item 8's nineteen is of a kind the item does not list.** The Legal
  Continuity Bill's Session 6 line draws *Stage 3, from
  spice_factsheet_legislation: final stage completed, but the outcome is not
  passed*, alongside the *introduced before the session began* the item does
  name. It is still a question for the owner rather than a fault in the reader —
  it is the same bill appearing a second time, and where its Stage 3 and its
  outcome belong is settled at review — but the item's list should name it.

**What each item gave.** 1: 83 rows and 2, with an empty `problems` list both
times. 2: 8 awaiting Royal Assent, 10 fallen, 4 withdrawn, 1 in the Session 5
section, 60 Acts; and 1 in progress, 1 awaiting Royal Assent. 3: awaiting Royal
Assent 6 Government and 2 Member's against the summary table's 5 and 3; Acts 55
and 5 against 56 and 4; fallen 0 and 10, withdrawn 1 and 3, the Session 5 bill
Government, all as printed; margins 62 and 20, total 82. 4: both wrapped
sentences read — the Care Reform Act as the National Care Service Bill, and the
Recall of Members Bill as the Recall and Removal of Members Bill. 5: exactly five
emergency bills, each with the date the fact sheet states. 6: both `Bill Act`
titles still whole in `raw_title` and mended in `short_title` with a note saying
so, and the European Charter row `sp_bill_id` 70 with its note, the Bill title
and no asp number. 7: "All checks passed" both times, 83 lines and 2, and both
rolled back. 8: 19 problems and 3, as above.

The reader turns the Session 6 and 7 fact sheets, which are prose, into the same
CSV the ruled-table reader writes for Sessions 1 to 5, so that
`tools/load_session.sql` has one contract to match. What it must get right that
nothing else does is in `docs/FACTSHEET-SURVEY.md` §1.

### The items

1. **Both documents are read with nothing left over.** Run the reader on each
   fact sheet. **Expected:** 83 rows for Session 6 and 2 for Session 7, and an
   empty `problems` list both times. The reader puts its own pieces back
   together and compares them with the document they came from, so an empty
   list means every character of both bodies landed in a heading, a sentence or
   a title. *The expectation comes from M6's arithmetic and from the reading
   recorded on 2026-09-14, not from the reader.*

2. **The sections are the ones the fact sheets print.** **Expected**, Session 6:
   8 awaiting Royal Assent, 10 fallen, 4 withdrawn, 1 in the Session 5 section
   of its own, 60 Acts. Session 7: 1 in progress, 1 awaiting Royal Assent.
   *From the fact sheets' own headings and summary tables.*

3. **The type counts are the reader's, and two of the fact sheet's own cells
   disagree with them.** Count Session 6's rows by section and type.
   **Expected:** awaiting Royal Assent 6 Government and 2 Member's where the
   summary table prints 5 and 3; Acts 55 and 5 where it prints 56 and 4;
   fallen 0 and 10, withdrawn 1 and 3, and the Session 5 bill Government, all
   as printed. The margins agree: 62 Government and 20 Member's once the
   excluded bill is left out, and 82 in total. *From reading the entries, and
   from the summary table printed in the same document.*

4. **A sentence that wraps across printed lines is read.** **Expected:** two
   rows carry a `title_as_introduced` — the Care Reform Act, introduced as the
   National Care Service (Scotland) Bill, and the Scottish Parliament (Recall
   of Members) Bill, introduced as the Scottish Parliament (Recall and Removal
   of Members) Bill. Both come from a sentence printed across two lines. A
   reader working line by line finds neither, and swallows the sentence into
   the next bill's title. *From `docs/FACTSHEET-SURVEY.md` §1 and §4.3.*

5. **Five bills carry a procedure and its date.** **Expected:** exactly five
   rows have `procedure` = `emergency`, and each has the date the fact sheet
   states beside it: Coronavirus (Extension and Expiry) 2021-06-22, Cost of
   Living (Tenant Protection) 2022-10-04, Post Office (Horizon System) Offences
   2024-05-15, Prisoners (Early Release) 2024-11-20, Non-Domestic Rates for
   Unoccupied Properties 2025-11-25. No row in Session 7. *From the fact sheet's
   own sentences, quoted in `db/087`.*

6. **What the fact sheet prints wrongly is mended in our title and never in its
   own words.** **Expected:** `raw_title` still reads "Agriculture and Rural
   Communities (Scotland) Bill Act 2024 (asp 11)" and "Housing (Scotland) Bill
   Act 2025 (asp 13)", while `short_title` reads them without the word Bill and
   `parser_note` says so. The European Charter row's `sp_bill_id` is 70 with a
   note that the fact sheet prints "(SP 70)", and its `short_title` is the Bill
   title with no `asp_number`, because the fact sheet prints neither the Act
   title nor the number. *From the fact sheet, and from the four wrongly printed
   titles recorded in `DECISIONS.md` on 2026-09-14.*

7. **The CSV is the one the loader takes.** Load each CSV with
   `-v save=false`. **Expected:** both say "All checks passed", 83 lines and 69
   stage-dates rows for Session 6, 2 lines and 1 stage-dates row for Session 7,
   and both roll back. Nothing is saved, and the counts afterwards are 389
   bills, 1071 stage records and 112 provenance notes. *From
   `tools/load_session.sql`'s own checks, which compare every cell of every line
   against the CSV.*

8. **The review list is the one recorded, and every item on it is a question
   for the owner rather than a fault in the reader.** **Expected:** 19 problems
   for Session 6 and 3 for Session 7, and every one of them either a bill
   introduced before its session began, a fallen bill whose outcome needs a
   judgement, a blocked bill whose route and outcome are for review, a bill with
   a Reconsideration Stage that does not yet say it was reconsidered after being
   stopped, an Act whose title or number the fact sheet did not print, or the
   Dog Theft Act's asp year. *From the rehearsal recorded on 2026-09-14 in `STATE.md`.*

### What this test does not check

- **That the rows are right about the bills.** They are candidates. Whether
  each is what the Parliament did is the owner's review, and the ingest test
  for Sessions 6 and 7 is where it is checked.
- **Anything loaded.** Nothing here is saved, so nothing here admits a session.
- **The Reconsideration Stage dates**, which the reader keeps as words in
  `parser_note` because there is nowhere else for them yet. Where they end up
  is the decision this reader is waiting on.
- **The reconciliation against the fact sheet's own summary**, beyond item 3's
  counting. What to do about the two cells that disagree is settled in
  `DECISIONS.md` and belongs to the ingest.

---

## Procedure, and the day the Parliament agreed to it

Written 2026-09-14 by the session that built `db/087`, which may therefore not
run it. **Seven items, all mechanical.** Nothing here needs the owner.

`db/087` gives `bill.procedure` its first values and adds
`bill.date_procedure_agreed` beside it, because the Session 6 fact sheet prints
"Motion agreed to treat as Emergency Bill on 22 June 2021" against five bills
and no earlier fact sheet states procedure at all. The migration writes nothing
to the clean sheet: it adds two empty cells, rebuilds the error checker and the
gaps list, and writes methodology note M10.

**Everything below can be run inside one transaction that is thrown away.** The
session that built this did exactly that to rehearse it; a fixture line is all
that is needed, and no bill on the clean sheet has to move.

**The fixture**, which every item after the first uses. One Session 6 staging
line, accepted, for the Prisoners (Early Release) (Scotland) Act 2025 (asp 1) as
the fact sheet prints it: a Government Bill introduced 18 November 2024, the
motion agreed 20 November 2024, passed 26 November 2024, Royal Assent 22 January
2025, with one accepted Stage 3 row of 26 November 2024, `procedure` =
`emergency` and `date_procedure_agreed` = 2024-11-20.

### The items

1. **The rebuilt views lost nothing.** The error checker and the gaps list are
   both written out in full in `db/087`, from `db/082` and `db/086`. Capture
   each view's running definition before applying `db/087` and again after, and
   compare the two texts. **Expected:** the only differences are the new blocks
   `db/087` adds — four checks and one refusal in the error checker, one branch
   and two extra columns on the `lines` list in the gaps list. Nothing that was
   in a definition before is absent after. *The expectation comes from what the
   migration says it changes, not from the database.* **This is the item that
   matters most:** `db/062` and `db/086` both found that a view rebuilt from an
   older migration's text quietly carries that text's stale names with it, and
   a rebuild that drops a check is a rebuild that stops finding faults.

2. **A complete, consistent line is not complained about.** With the fixture
   present, the error checker says nothing about it. **Expected:** no rows for
   that line. *From the rule: everything the new checks ask about is satisfied.*
   The gaps list will ask that line for its Stage 1 and Stage 2 dates, because a
   bill that passed should have all three and the fixture carries only Stage 3.
   That is the gaps list doing its ordinary job and is not a finding.

3. **A date with no procedure is refused.** Empty the line's `procedure`,
   leaving the date. **Expected:** exactly one complaint, *says a procedure was
   agreed on 2024-11-20, but does not say which procedure*. *From `db/087`.*

4. **A date outside the bill's life is refused, at both ends.** Put the
   procedure back and set the date to 1 November 2024, before the bill was
   introduced. **Expected:** *procedure agreed on 2024-11-01, before the bill
   was introduced on 2024-11-18*. Then set it to 1 December 2024, after the bill
   passed. **Expected:** *procedure agreed on 2024-12-01, after the bill had
   passed on 2024-11-26*. One complaint each time, and no other. *From `db/087`.*

5. **An emergency bill with no date is a gap and not a contradiction.** Leave
   `procedure` = `emergency` and empty the date. **Expected:** the error checker
   says nothing about the line, and the gaps list carries one entry for it with
   no stage named: *recorded as an emergency bill, and nothing says when the
   Parliament agreed to treat it as one*. *From the owner's instruction on
   2026-09-14, that it be flagged rather than refused, and from `db/087`.*
   Check the other way too: a line whose procedure is not `emergency` — set it
   to `budget` — must produce no such entry, because a Budget Bill has no motion
   to date.

6. **A further appearance that states a procedure is refused.** Give the line
   `continues_bill_id` = 303 and the introduction date of the bill it continues,
   5 May 2020, with the procedure and its date filled. **Expected:** a complaint
   beginning *continues bill 303 and states how the bill was handled*. Empty
   both cells and that complaint goes, while the line stays otherwise as it was.
   *From `db/087`: promotion carries seven cells from a further appearance and
   procedure is not among them, so a value there would be dropped in silence.*

7. **Promotion carries both cells, with provenance.** With the fixture as a bill
   of its own — no `continues_bill_id` — and the error checker empty, promote
   Session 6. **Expected:** the bill reads `emergency` and 2024-11-20; two
   provenance notes are written against it, `procedure` with the value seen
   `emergency` and `date_procedure_agreed` with 2024-11-20, both citing the
   Session 6 fact sheet retrieved 2026-09-10; and the counts for everything else
   are unchanged at 389 bills, 1071 stage records and 112 provenance notes.
   Then take the session off again and confirm the bill and both notes go with
   it. *From `db/087` and `tools/promote_session.sql`.*

### What this test does not check

- **That the five bills are the right five, or that their dates are right.**
  Nothing is loaded here. That is the Session 6 ingest's own test, when there is
  one.
- **Any procedure other than emergency.** Only emergency has ever been stated by
  a source, so budget, consolidation and the three statute law values are
  exercised nowhere except item 5's second limb, which only asks that they
  produce no gap entry.
- **Backfilling Sessions 1 to 5.** Not begun, and needs a source not yet agreed.
- **The prose reader.** It is built next, on top of this, and gets its own test.
- **That M10 says the right thing to a reader.** That is the owner's to judge,
  and it is not a mechanical item.

### The run, 2026-09-14, by a session that built none of it

**All seven items as expected.** Everything below happened inside transactions
that were thrown away: 389 bills, 1071 stage records, 112 provenance notes,
389 staging lines and 1071 staging stage rows before and after, the error
checker and the gaps list both empty at the end.

1. **The rebuilt views lost nothing. As expected.** The two definitions as
   `db/082` and `db/086` left them were built beside the live ones under other
   names, rather than replacing them, and the four texts were read out of the
   database and compared as text. The error checker gains five blocks and loses
   nothing: a date with no procedure, a date before introduction, a date after
   passing, a date after concluding, and the refusal of a further appearance
   that states a procedure — four checks and one refusal, which is what the
   migration says it adds. The gaps list gains the two cells on its `lines`
   list and carries them through its three branches, and gains one branch at
   the end for an emergency bill with no date. Not a line of either definition
   is absent afterwards.

2. **A complete, consistent line is not complained about. As expected.** The
   error checker says nothing about the fixture and nothing anywhere else. The
   gaps list asks that line for its Stage 1 and Stage 2 dates and for nothing
   else, which is its ordinary job on a line carrying only Stage 3.

3. **A date with no procedure is refused. As expected.** Exactly one complaint,
   *says a procedure was agreed on 2024-11-20, but does not say which
   procedure*, and nothing anywhere else.

4. **A date outside the bill's life is refused at both ends. As expected.**
   1 November 2024 gives *procedure agreed on 2024-11-01, before the bill was
   introduced on 2024-11-18*; 1 December 2024 gives *procedure agreed on
   2024-12-01, after the bill had passed on 2024-11-26*. One complaint each
   time and no other.

5. **An emergency bill with no date is a gap and not a contradiction. As
   expected, both ways.** The error checker says nothing; the gaps list carries
   one entry with no stage named, *recorded as an emergency bill, and nothing
   says when the Parliament agreed to treat it as one*, beside the line's two
   ordinary stage gaps. With the procedure set to `budget` instead, that entry
   goes and the two stage gaps remain.

6. **A further appearance that states a procedure is refused. As expected.**
   *continues bill 303 and states how the bill was handled…* Emptying both
   cells leaves the line otherwise as it was, still continuing bill 303, and
   the complaint goes.

   **The first run of this item produced a second complaint, and it is about
   the fixture rather than about `db/087`:** giving the line bill 303's
   introduction date while its raw words still read "18 November 2024" is a
   date that disagrees with the fact sheet it was read from, with no citation
   for the change. The item was run again with the raw words moved too, and
   `db/087`'s refusal was then the only thing said. Same shape as the note on
   the gaps list test's fixture: a complaint about a cell invented for a
   fixture is not a finding.

7. **Promotion carries both cells, with provenance. As expected.** The bill
   came onto the clean sheet as bill 395 reading `emergency` and 2024-11-20,
   with two provenance notes behind it — `procedure` seen as `emergency` and
   `date_procedure_agreed` seen as 2024-11-20, both citing the Session 6 fact
   sheet retrieved 2026-09-10. Counts with the session on were 390 bills, 1072
   stage records and 114 provenance notes: the fixture's own bill, its own
   Stage 3 record and its own two notes, and nothing else moved. Taking the
   session off again removed the bill, its stage record and both notes, and
   returned the counts to 389, 1071 and 112.

---

## The gaps list, and a bill's second appearance

Written 2026-09-14 by the session that built `db/086`, which may therefore not
run it. **Four items, all mechanical.**

**Run on 2026-09-14** by a further session, which built none of `db/086` and
wrote nothing to the database in order to run it: the fixture and every
alteration were planted inside one transaction that was thrown away. **All four
answered as expected.** The run is written up after the items.

**What the change did, in one line:** the gaps list no longer asks a line that
continues an earlier bill for a stage the bill it continues already has.

**Why it exists.** `db/081` made a factsheet row that is a further appearance of
a bill already on the clean sheet land on that bill, and `db/082` rebuilt the
error checker to read such a row correctly. The gaps list was not rebuilt, and
it asks every line that passed for all three of its stages. Found on 2026-09-14
while running the test above: the moment a Session 6 line for the European
Charter Bill existed, the gaps list showed its Stage 1 and Stage 2 as missing
dates. They are on the bill, from Session 5, 4 and 24 February 2021.

**Where the expectations come from.** Items 1 and 2 from the rule's stated
intent, checked against behaviour. Item 3 from `db/039`, which the change must
leave alone. Item 4 from the figures this session read out of the database and
recorded in `STATE.md`.

**Nothing here is the owner's.** No cell, no value, no dropdown list, nothing on
either sheet, no provenance, no methodology note. Only when a working list
complains. The design was agreed with the owner on 2026-09-14 before it was
built.

Each item plants its fixture inside a transaction that is then thrown away. The
fixture is the same hand-built Session 6 line for the European Charter Bill the
test above used, and is not Session 6 data.

1. **The false entries are gone, and were there before.** With the Session 6
   line on the staging sheet, the gaps list must show nothing. Then put the view
   back as `db/056` and `db/062` left it, and it must show two: Stage 1 and
   Stage 2 of that line, both "date not yet entered".

2. **The rule excuses only the stages that are really there.** Take bill 303's
   Stage 2 date off the clean sheet inside the rehearsal. The Session 6 line
   must then be asked for Stage 2, and for Stage 2 only — not Stage 1, which is
   still there, and not Stage 3. Then take the link away: with
   `continues_bill_id` empty and no stage rows of its own, the line must be
   asked for all three. Put the link back and it must be asked for none.

3. **The Robin Rigg Act is unmoved.** Its line is kept off the gaps list by the
   rule `db/039` added, which is the rule this one sits beside. It must still
   show nothing.

4. **Nothing else moved.** 389 bills, 1071 stage records, 112 provenance notes.
   The gaps list and the error checker are both empty across all 389 lines, as
   they were before.

### What this test does not check

- **The half of the rule about a stage that never happened.** The rule excuses a
  stage the earlier bill has *either* with a date *or* marked as one that never
  happened. Only the first half can be tested today: a stage marked as never
  having happened is allowed only on a Private Bill (`db/039`), and no Private
  Bill has ever appeared in two factsheets. The second half is there so that the
  two rules say the same thing, and it is untested until such a bill exists.
- **Anything about Session 6's actual contents.** No Session 6 row has been read
  in.
- **The second half of the gaps list** — a bill that did not pass with nothing
  saying where it ended. It is untouched by `db/086`, deliberately: a second
  appearance is where the bill ended, so its own line is the one that has to
  record the ending. No bill has ever appeared in three factsheets.

### The run, 2026-09-14

The fixture: one Session 6 staging line for the European Charter Bill, accepted,
a Members' Bill that passed, introduced 5 May 2020 — before Session 6 began —
carrying `continues_bill_id` = 303, with a Stage 3 row restating 23 May 2021 and
a Reconsideration Stage row of 8 June 2021. Bill 303 on the clean sheet is
unchanged throughout: Stage 1 on 4 February, Stage 2 on 24 February and Stage 3
on 23 March 2021.

1. **The false entries are gone, and were there before. As expected.** With the
   line present, the gaps list shows nothing — not for that line, and not
   anywhere: the whole list is empty. The view as `db/056` and `db/062` left it
   was rebuilt beside it under another name, rather than replacing the live one,
   and reading the same state it shows exactly two rows: the line's Stage 1 and
   Stage 2, both "date not yet entered", and nothing else in the database.

   **That reconstruction was checked rather than taken on trust.** `db/056`'s
   text does not run today as written — `db/061` renamed the column it calls
   `note`, and the live view carried the rename with it — so the one word was
   put back the way the rename put it. The two views were then read side by side
   on a state with every stage date in the database taken away, which asks both
   of them about all 389 lines at once: 1021 rows against 1018, the difference
   being three rows and all three the fixture line's, and **not one row that
   `db/086` asks for and the older view does not.** The change bites in the one
   place intended and nowhere else.

2. **The rule excuses only the stages that are really there. As expected, in all
   three limbs.** With bill 303's Stage 2 taken off the clean sheet, the line is
   asked for Stage 2 and for nothing else — not Stage 1, which is still on the
   bill, and not Stage 3. With bill 303 whole again, and the line stripped of its
   own stage rows and of its link, it is asked for all three. Putting the link
   back silences all three.

3. **The Robin Rigg Act is unmoved. As expected.** Its line shows nothing, with
   the fixture present and absent, and under both views. Its Preliminary and
   Consideration Stages are still the only stage records in the database marked
   as stages that never happened, which is what `db/039`'s rule reads.

4. **Nothing moved. As expected.** 389 bills, 1071 stage records, 112 provenance
   notes, 389 staging lines and 1071 staging stage rows, before and after; the
   gaps list and the error checker both empty across all 389 lines; and the view
   built for the comparison gone with the transaction.

**One note on the fixture, which is not a finding about `db/086`.** The first
fixture was built with only the cells this test needs, and the error checker
complained four times about it — an Act with no year in its title, no ASP
number, a title kind that is not `act`, and dates never compared against the
other sources. Every complaint is about a cell invented for the fixture, none
about the line continuing bill 303. A second fixture carrying those four cells
properly leaves the error checker silent and the gaps list empty, which is what
a real Session 6 line will look like.

---

## Carried-over bills, and the blocked-bill record

Written 2026-09-14 by the session that built the change, which may therefore not
run it. Every item below asks about a rule that session added, and a session may
not mark the check on a rule it added itself (`DECISIONS.md`, 2026-09-14).

This is not a session ingest. It is a change to how data is coded, made before
Session 6 is loaded, and it touches five bills. It is here because it added
rules, and rules need marking by somebody else.

**The change, in one line:** a fact sheet row that is a further appearance of a
bill already on the clean sheet now lands on that bill instead of making a
second one; a bill stopped before Royal Assent now records how and what
followed; and the Robin Rigg Act now says whose scrutiny it carried. See
`DECISIONS.md`, 2026-09-14, and `db/080`–`db/085`.

**Run on 2026-09-14** by a further session, which built none of `db/080`–`db/085`
and wrote nothing to the database in order to be able to run it: every fault was
planted inside a transaction that was thrown away, and the two promotion
rehearsals likewise. **All eighteen items answered as expected.** Two notes, and
one thing the test did not ask about.

- **Items 1 to 4, the values: as predicted in every limb.** Three bills carry the
  blocked record, 303, 304 and 305, each `passed` / `blocked` / `s33_reference` /
  `still_blocked`; 303 and 304 blocked on 2021-10-06 and 305 on no date. Each
  carries the footnote word for word, beginning and ending as the item says,
  cited to the Session 5 fact sheet and read on 2026-09-10 — and so, on the same
  three bills, do `assent_block_outcome`, `enactment_status` and, where there is
  one, `date_assent_blocked`. Bill 124 is the only bill saying whose scrutiny it
  carried, pointing at bill 71, Session 1, introduced 2002-06-27 against 124's
  2003-05-15. Its two empty stage rows name their own stages and give 9 January
  and 11 March 2003, both matching bill 71's own records, and no other stage row
  in the database is marked as a stage that never happened.

- **Items 5 to 9, the rules on the clean sheet: all five refuse.** Two items
  needed rewording to be a test at all. As written, item 6 puts the block cells
  on a bill whose outcome is `fell_dissolution`, and item 8 sets
  `reconsidered_passed` on a bill that is still recorded as blocked — each of
  which breaks a second rule at the same time, and in both cases
  `bill_blocked_says_still_blocked` refused it first, so the named rule was never
  reached. Faults were built that break only the named rule: outcome changed to
  `fell_dissolution` on a bill left blocked and still_blocked, which
  `bill_only_a_passed_bill_can_be_blocked` refused; and `reconsidered_passed`
  with `enactment_status` set to `not_enacted`, which
  `bill_reconsidered_and_passed_is_enacted` refused. A control confirmed the
  latter is allowed once the bill is made enacted. **This is a note about how two
  items were written, not about the rules.**

- **Items 10 to 12, the rules on the staging sheet: every one fires, and names
  the fault.** Item 10 both ways: a line introduced before its own fact sheet's
  session began and naming no bill is told that `continues_bill_id` must say
  which; naming the bill removes the complaint; and with dates past the end of
  Session 6 on a line that continues bill 303, neither "passed after the session
  ended" nor "concluded after the session ended" fires, while emptying
  `continues_bill_id` makes both fire at once. Items 11 and 12 fire on all
  twelve faults, each with its own message, and the checker returns to empty when
  the fixture is removed.

- **Items 13 to 15, promotion and rollback: as predicted.** A hand-built Session
  6 line for the European Charter Bill, carrying `continues_bill_id` = 303, a
  Reconsideration Stage and a Stage 3 restating 23 May 2021, promoted: the bill
  count did not move, 389 to 389; bill 303 gained its Reconsideration Stage;
  **its Stage 3 stayed 2021-03-23**; the line was stamped with 303; five cells
  changed, each carrying a note citing the Session 6 fact sheet, while
  `assent_block_route` still cites the Session 5 footnote read on 2026-09-10.
  Taking Session 6 off brought bill 303 off with it and said to promote Session 5
  again; after doing so the bill compared **identical in every cell**, with all
  three stage records and all seven provenance notes identical, the only
  difference being `created_at` and `updated_at`, which the database sets itself.
  Rolling back out of order was refused both ways, naming Session 6 and Session 2
  respectively.

- **Item 16: 389 bills, 1071 stage records, 112 provenance notes**, error checker
  and gaps list both empty, and the six new notes are three on
  `assent_block_route` and three on `assent_block_outcome`.

- **Item 17 could only be half answered, and the reason is worth recording.** The
  item asks for a copy of `bill` and `stage_event` from before `db/080`. No such
  copy was taken, and the only independent one that exists is the nightly backup
  of 2026-09-14 02:53, which is earlier than Session 5 reaching the clean sheet:
  302 bills, 828 stage records, 86 provenance notes, Sessions 1 to 4 only. It was
  restored into a scratch database, compared row by row on content — ignoring the
  reissued row numbers and the automatic stamps — and dropped. **Sessions 1 to 4
  differ in exactly four places, all attributable and only the last of them to
  this change:** bills 68 and 302's notes gained division figures (`db/069`);
  five provenance notes lost a trailing "Read at" (the mid-sentence mend of the
  same day); and bill 124's Consideration Stage note now names the Consideration
  Stage rather than the Preliminary (`db/084`, intended). Session 5 is not
  covered by that copy and rests on its own closed test together with item 14's
  cell-by-cell comparison of bill 303. **A copy taken before a change, rather
  than looked for afterwards, is what would have answered this item in full.**

- **Item 18: M6 and M9 read as written, and every figure checks.** M9's four:
  bill 124 runs 42 days from introduction to its Final Stage; the next shortest
  Private Bill is 132 (bill 207); the median of the 22 Private Bills that passed
  is 274; and 364 days separate bill 71's introduction from bill 124's Final
  Stage. M6's arithmetic against the fact sheets themselves: the Session 6 fact
  sheet prints 83 bill entries — 8 awaiting assent, 10 fallen, 5 withdrawn, 60
  Acts — and totals 82, its own footnote saying the total includes two bills
  introduced in Session 5, with the fifth withdrawn entry being the Legal
  Continuity Bill, printed and excluded; the Session 7 fact sheet prints 2 and
  totals 2. 389 + 83 + 2 = 474; 473 counted; 470 distinct.

**What the run turned up that the test did not ask about: the gaps list had not
been taught what the error checker was taught.** The moment the Session 6 fixture
existed, `v_stage_date_gaps` listed the European Charter Bill's Stage 1 and
Stage 2 as missing dates, which are on the bill from Session 5. Four bills would
have done this. Agreed with the owner and fixed the same day by `db/086`; its own
four items are the test above.


**All items are mechanical.** Nothing here needs the owner's judgement, because
nothing here is new data: the section 33 route is read from a footnote already
on the staging sheet word for word, and the Robin Rigg dates are already on the
clean sheet. What the owner has already agreed is the design, and that agreement
is recorded in `DECISIONS.md`.

**Where the expectations come from.** Items 1–4 from the Session 5 and Session 6
fact sheets and the Session 1 bill's own stage records, all quoted in
`DECISIONS.md`. Items 5–12 from the migrations' stated intent, checked against
behaviour rather than against the migrations' account of themselves. Item 13
from the figures read out of the database on 2026-09-14 and recorded in M9.

### Part A — the values

1. **Exactly three bills carry the blocked record**, and they are bills 303, 304
   and 305. Each has `assent_block_route` = `s33_reference` and
   `assent_block_outcome` = `still_blocked`, `outcome` = `passed` and
   `enactment_status` = `blocked`. Bills 303 and 304 have
   `date_assent_blocked` = 2021-10-06; bill 305 has none, because its footnote
   gives none.

2. **Each of those three carries the fact sheet's footnote as the provenance of
   `assent_block_route`**, word for word, cited to the Session 5 legislation
   fact sheet and read on 2026-09-10. Read the three notes out in full and
   confirm each begins "Following a reference under section 33 of the Scotland
   Act 1998 by the Attorney General and the Advocate General for Scotland" and
   ends in a full stop.

3. **Exactly one bill says whose scrutiny it carried**: bill 124, the Robin Rigg
   Act, pointing at bill 71. Bill 71 is a Session 1 bill introduced 27 June
   2002; bill 124 was introduced 15 May 2003.

4. **The Robin Rigg Act's two empty stage rows each name their own stage.** Read
   both in full. The Preliminary row ends "The Session 1 bill's Preliminary
   Stage was on 9 January 2003." and the Consideration row ends "The Session 1
   bill's Consideration Stage was on 11 March 2003." Both dates match bill 71's
   own stage records. No other stage row in the database is marked as a stage
   that never happened.

### Part B — the rules on the clean sheet bite

Each item plants the fault inside a transaction that is then thrown away, as
`db/062` and `db/078` proved theirs. Expected: every one is refused.

5. **`bill_block_cells_are_filled_together`.** Empty `assent_block_route` on
   bill 303 and leave `assent_block_outcome`; then the reverse.

6. **`bill_only_a_passed_bill_can_be_blocked`.** Put the block cells on a bill
   whose outcome is `fell_dissolution`.

7. **`bill_blocked_says_still_blocked`, both ways.** Set bill 303's
   `enactment_status` to `enacted` while it still says `still_blocked`; then set
   `assent_block_outcome` to `withdrawn` while `enactment_status` is `blocked`.

8. **`bill_reconsidered_and_passed_is_enacted`.** Set bill 303 to
   `reconsidered_passed` without making it enacted.

9. **`bill_not_reintroduced_from_itself`.** Point bill 124 at bill 124.

### Part C — the rules on the staging sheet bite

Each plants the fault on a staging line inside a transaction that is thrown
away, and reads `v_candidate_problems`. Expected: each names the fault, and the
checker is empty again afterwards.

10. **A line introduced before its own fact sheet's session began, and not
    saying which bill it is.** The message must name `continues_bill_id`. Then
    set `continues_bill_id` and confirm the complaint goes, and that "passed
    after the session ended" and "concluded after the session ended" do not
    fire on a line that carries dates outside its fact sheet's session.

11. **A line continuing a bill that is not there, a bill introduced on a
    different day, and a bill of the same or a later session.** Three separate
    faults, three separate messages.

12. **The block cells on a staging line**: one filled and one empty; a value not
    in its list; `blocked` with nothing saying what followed; `still_blocked`
    with an enactment status that is not `blocked`; `withdrawn` with no
    concluding date; a Reconsideration Stage row with no cell saying it was
    reconsidered, and a cell saying so with no row; and a stage marked as never
    having happened on a line that names no earlier bill.

### Part D — promotion and rollback

13. **A further appearance updates and does not insert.** Plant one Session 6
    staging line for the European Charter Bill with `continues_bill_id` = 303,
    a Reconsideration Stage row, and a Stage 3 row restating the Session 6 fact
    sheet's "Passed on 23 May 2021". Promote Session 6. Expected: the bill count
    does not move; bill 303 gains the Reconsideration Stage; **its Stage 3 stays
    23 March 2021**, because a further appearance never overwrites a stage that
    is already there; the line is stamped with 303; and each changed cell
    carries a note naming the Session 6 fact sheet, while `assent_block_route`
    still carries the Session 5 footnote.

14. **Rollback restores it exactly.** Take Session 6 off. Expected: bill 303
    comes off with it, the script says to promote Session 5 again, and after
    promoting Session 5 the bill is identical to what it was before item 13 —
    every cell, and its three stage records. Compare cell by cell, not by count.

15. **Taking a session off in the wrong order is refused, and says which.** With
    Session 6 on the clean sheet, try to take Session 5 off. Expected: refused,
    naming Session 6. Then try to take Session 1 off with Session 2 on the clean
    sheet. Expected: refused, naming Session 2.

### Part E — nothing else moved

16. **The counts.** 389 bills, 1071 stage records, 112 provenance notes. The
    error checker and the gaps list are both empty. Provenance was 106 before
    this change and 112 after, the six being the two block cells on each of the
    three bills.

17. **Sessions 1 to 5 are as they were**, apart from the five cells this change
    filled. Take a copy of `bill` and `stage_event` before the change from the
    commit before `db/080`, and compare row by row.

18. **M6 and M9 read as written.** Read both out in full. M6 gives the test —
    did the first bill end? — both answers, and the arithmetic: 474 rows, 473
    counted, 470 distinct bills, and 73, 81, 62, 86, 87, 80, 1 per session
    against the fact sheets' 73, 81, 62, 86, 87, 82, 2. M9 gives 42, 132, 274
    and 364 days. Check the four figures in M9 against the database, and the
    per-session figures in M6 against the fact sheets.

### What this test does not check

- **Anything about Session 6's actual contents.** No Session 6 row has been
  read in. Item 13's staging line is a fixture built by hand from the fact
  sheet's printed words, and its Act title and number are invented, because
  reading them off legislation.gov.uk is part of loading Session 6.
- **That the European Charter Bill's Act title and number are what we will
  record.** The Session 6 fact sheet prints neither: it lists the bill in its
  Acts table under the bill's own title with an SP number. They are to be read
  from legislation.gov.uk when Session 6 is loaded, as the Period Products and
  Higher Education Acts' were.
- **That `s35_order` works on a real bill.** No bill in the database was stopped
  by a section 35 order. The Gender Recognition Reform Bill is a Session 6 bill
  and is not loaded.
- **That `reconsidered_fell` works on a real bill.** No bill has ever done it.
- **Whether the design is right.** That is the owner's, and was agreed on
  2026-09-14 before any of it was built.

---

## Session 5

Written 2026-09-14 by a session that did none of Session 5's work: it did not
read the fact sheet in, did not build the review, did not admit it and did not
promote it.

**Part A run on 2026-09-14** by a further session, which did none of Session 5's
work and did not write this test. **Twenty-eight of the thirty items answered as
expected. The two that did not are the two this test predicted would not**: item
9, the Period Products Act's title, and item 15, M7 a session out of date. Both
were put right by `db/078` on the owner's decision the same day, and items 1, 5,
9, 14, 15 and 26 were re-run against the expectations written above — the
movements are marked **[moved by db/078]** where they occur. Nothing else in the
run changed by a single cell.

**One prediction resolved, and it was prose and not data.** Item 24's three
shortest roads read 1, 9 and 22 days, which are the fact sheet's own dates. The
session that promoted Session 5 had reported 1, 27 and 28. No bill's Stage 3
date on the clean sheet is wrong.

**Item 31 was added after that run** — it is the check on the rule `db/078`
itself added, which the session that added it was not allowed to mark. **It was
run on 2026-09-14 by a third session**, which added nothing to the database, and
**all four of its parts answered as expected**.

**Item 32 was added by that same third session.** While the owner was reading
Session 5's three Official Report notes for sign-off 2, eight notes across
Sessions 4 and 5 turned out to end mid-sentence. `db/079` mended them and added
the rule; item 32 asks that rule from outside. **It was run on 2026-09-14 by a
fourth session**, which added nothing to the database and did not write it, and
**all six of its parts answered as expected**.

**Part A is thirty-two items, and all thirty-two are answered as expected.**

**Part B is complete.** All nine sign-offs were given by the owner on 2026-09-14,
and are recorded below on the day they were given and nowhere else.

**Session 5 is closed**, on 2026-09-14, on the whole of Part A and the whole of
Part B. No item of this test is outstanding.

**Session 5 was already on the clean sheet when this was written, and had been
marked closed by the session that promoted it.** That is the thing the procedure
at the top of this file exists to prevent, and it is the second time it has
happened — Sessions 1 and 2 on 12 September were the first. The mark was wrong
and has been taken off; `STATE.md` now reads `next: closure test` for Session 5,
as it did for Session 4 between promotion and marking.

**What that costs, and what takes its place.** Sessions 3 and 4 had their tests
written while the session was still off the clean sheet, so an expected answer
could not have been copied out of the data even by accident. That protection is
not available here. In its place, every expected answer below says where it comes
from, and the sources are these, none of them the database:

- **a fresh extraction of the Session 5 fact sheet**, run on 2026-09-14 from
  `sources/factsheets/spice-legislation-session-5_retrieved-2026-09-10.pdf` with
  nothing supplied to the reader but the PDF and the session number;
- **the owner's dataset**, read directly out of the workbook — row counts, which
  bills carry which stage dates, and the file's own fingerprint;
- **`db/071` to `db/077` and the decisions they record**, which is where the
  review's codings, adjudications and agreed wordings live;
- **Session 4's closed test**, for anything covering the whole clean sheet that
  Session 5 does not move.

Where a figure could only have come from the database, the expected answer says
so and is not dressed up as a prediction. There are two: the lengths of the six
methodology notes Session 5 leaves alone, which are quoted from Session 4's test,
and nothing else.

**When to run it.** Now. Session 5 is on the clean sheet with its Stage 1 and
Stage 2 dates on it, which is the state these answers describe.

### What writing this test turned up — three things, all settled on 2026-09-14

**All three were put to the owner when Part A was reported, and all three were
agreed and built the same day.** What follows is as it was written, because it
is the account of what the test was for; each is marked with what was decided.

None is a matter of opinion about the data; each is a place where Session 5 was
handled differently from Session 4 under a rule that has not changed. **They are
put to the owner rather than fixed by the session that found them**, and the
items they affect are marked below, so that a failure is read as the known thing
and not as a discovery.

**1. The Period Products Act's title has no year in it, and its number does.**
The fact sheet prints the title as "Period Products (Free Provision) (Scotland)
Act (asp 1)", with no year anywhere in it. `db/073` settled the number at
legislation.gov.uk as `2021 asp 1` and left the title as the fact sheet printed
it. Session 4's equivalent was settled both ways: the Higher Education Governance
Act had **two** cells corrected, the number and the title, and Session 4's item 5
lists both, because the title is the half a reader sees. So on the same fault,
one session corrected the title and the next did not. `db/073`'s own note already
quotes legislation.gov.uk giving "Period Products (Free Provision) (Scotland) Act
2021", so the value is not in doubt and nothing needs to be looked up.

**Settled: the title carries its year.** `db/078` made the correction on the
staging sheet with its citation, and Session 5 was taken off the clean sheet and
put back so the title and its provenance note arrived by the same route as every
other admitted fact. It also added the rule that would have caught it: the error
checker now asks an Act's title for its year as it already asked the number.
**Item 14 moves too, which this paragraph did not foresee.**

**If the owner agrees the title should carry its year, items 1, 5, 9 and 26 move
together**: provenance notes 105 becomes 106, item 5 gains a `short_title` /
`legislation_gov_uk` row taking that pairing from 1 to 2, item 9's
`acts_whose_title_has_no_year` becomes 0, and item 26 gains a tenth cell that
must differ from a fresh reading. Nothing else is affected. **If the owner
decides the fact sheet's title stands**, item 9's expected answer becomes 1 with
a reason recorded here, and Session 4's handling is the one that needs revisiting
— not this one.

**2. M7 says the coding of why a bill fell has been done for four sessions.**
Five have now been coded: Session 5's seven fallen bills were split into three
rejected at Stage 1 and four out of time on 14 September. This is exactly what
`db/070` had to fix at Session 4's closure, when M7 still said three. A published
note saying less than the data holds is the fault `db/072` was written to prevent
in M5, in the same week. Item 15 expects M7 to say Sessions 1 to 5 and is
predicted to fail until a migration puts it right. **Settled: `db/078` put it
right, in the two sentences db/070 had to change at Session 4's closure.**

**3. The explainer contradicts itself on how many provenance notes there are.**
`docs/HOW-THE-DATABASE-WORKS.md` §3 says "The tab holds 86 notes in all: 72 about
bills, 13 about the sessions' own dates, and 1 about a stage", and §4 of the same
document says ninety-one, counting Session 5's nineteen. The second is current
and the first is a session behind: 105 in all, 91 about bills. **Part B item 9
cannot be put to the owner until that is fixed**, because it asks them to explain
the database from that document. **Settled: both passages were corrected on
2026-09-14, after the title correction moved the figures again — 106 in all, 92
about bills (22, 20, 15, 15 and 20 by session), 13 about the sessions' own dates
and 1 about a stage, every figure read back out of the database. Part B item 9
can now be put.**

**The one item an outside change can move** is item 27, the dataset's
fingerprint. Nothing else here is reopened by later work, and the three things
above are not outside changes: they are this session's own business.

### Part A — mechanical

Run `tools/closure_check_session_5.sql`. It reads only and changes nothing.
Compare each numbered result against the expected answer.

**1. Counts.** bills 389, stage_records 1071, provenance_notes 105,
checker_problems 0, gaps 0, staging_lines 389, stage_date_rows 1071.
**[Read exactly that. Moved by db/078: provenance_notes 106.]**

- **389** is 302 plus 87. The 87 is the Session 5 fact sheet's own summary total,
  and the fresh extraction produces exactly 87 lines from the PDF.
- **1071** is 828 plus Session 5's 243, and the 243 is a derivation to be checked
  rather than a number to be accepted: 78 bills passed — 75 Acts plus the 3 the
  fact sheet lists as awaiting Royal Assent — and each has three stages, which is
  234; the 3 rejected at Stage 1 have one each, which is 3; the 6 that ended
  where they stopped have one each, which is 6. 234 + 3 + 6 = 243. Every figure
  in that sentence is off the fact sheet.
- **The same 1071** for stage_date_rows. Every accepted stage-date row is carried
  to exactly one stage record, so with the whole of Session 5 promoted the two
  counts are equal. They are not equal at any point when a session is half on.
- **105** is 86 plus 19, and the 19 is derived from what
  `tools/promote_session.sql` writes a note for, against what Session 5's review
  actually settled: 3 outcomes read in the Official Report and 3 Stage 1
  rejection routes from the same pages (`db/073`); 4 bills coded as having fallen
  at dissolution, whose note is the rule and not a quotation; 3 notes on
  `enactment_status`, one per blocked bill, carrying the fact sheet's footnote as
  the words that were seen; 2 on `date_assent_blocked`, because only two of the
  three footnotes give a date; and 4 cells checked at review — two Royal Assent
  dates at legislation.gov.uk, one introduction date at the Parliament's bill
  page, and the Period Products Act's number (`db/073`, `db/074`).
  3 + 3 + 4 + 3 + 2 + 4 = 19. **This is one of the two places the title question
  bites:** correcting the title makes it 20 and the total 106.
- **0 and 0 are the rule**, for the session and for everything before it.

**2. Every staging line reviewed, admitted, on the clean sheet and compared.**
Session 1: 73 accepted, 73 promoted, 73 compared. Session 2: 81, 81, 81.
Session 3: 62, 62, 62. Session 4: 86, 86, 86. Session 5: 87, 87, 87. No other
review status appears in any session. From the fact sheets' own totals and the
rule that nothing reaches the clean sheet unaccepted.

**3. Every stage-date row.** Session 1: 200 accepted, 200 carried. Session 2:
213, 213. Session 3: 170, 170. Session 4: 245, 245. Session 5: 243, 243. No
other status. Sessions 1 to 4 are from their own tests; Session 5's 243 is item
1's derivation.

**4. A recorded difference with no adjudication.** 0. Session 5 recorded three —
two Royal Assent dates and the Solicitors Bill's introduction date — and all
three were settled on 14 September, each with a `Checked:` line beside the
`Differs:` line (`db/074`).

**5. What has been checked against the source that owns it.**

| Field | Source | Cells |
|---|---|---|
| `asp_number` | `legislation_gov_uk` | 3 |
| `bill_type` | `bill_page` | 1 |
| `date_assent_blocked` | `spice_factsheet_legislation` | 2 |
| `date_completed` | `bill_page` | 1 |
| `date_first_meeting` | `spice_factsheet_dates` | 7 |
| `date_introduced` | `bill_page` | 6 |
| `date_introduced` | `manual` | 1 |
| `date_royal_assent` | `legislation_gov_uk` | 13 |
| `date_session_end` | `spice_factsheet_dates` | 6 |
| `enactment_status` | `spice_factsheet_legislation` | 3 |
| `outcome` | `official_report` | 24 |
| `outcome` | `spice_factsheet_dates` | 14 |
| `short_title` | `legislation_gov_uk` | 1 **[db/078: 2]** |
| `short_title` | `manual` | 1 |
| `stage_1_rejection_route` | `official_report` | 22 |

That is Session 4's table with Session 5's nineteen added, and it sums to 105.
**Two of the pairings are new to the database**: a bill's `enactment_status` cited
to the legislation fact sheet, and `date_assent_blocked` to the same. Both exist
because the fact that stopped these bills is printed in a footnote rather than in
the row, so the only place the source's own words can live is a provenance note.
**If the title is corrected, `short_title` / `legislation_gov_uk` becomes 2.**

**The nineteen Session 5 cells are then listed in full.** Nineteen rows, not
eighteen and not twenty. **[Read nineteen. Moved by db/078 to twenty, the
twentieth being the Period Products Act's title.]** Two of the blocked bills carry the same footnote twice
over — once against the status and once against the date — which is not
duplication: they are provenance for two different cells. The UK Withdrawal Bill
has the status note only, its footnote giving no date. Every one of the nineteen was read on
2026-09-14.

**6. Reconciliation.** Our counts must match the fact sheet's own summary in
every cell and both margins. These figures are from the fresh extraction of the
Session 5 fact sheet, not out of the database:

| Session 5 | Government | Member's | Private | Committee | Total |
|---|---|---|---|---|---|
| Acts of the Scottish Parliament | 60 | 7 | 5 | 3 | 75 |
| Bills awaiting Royal Assent | 2 | 1 | 0 | 0 | 3 |
| Bills withdrawn | 1 | 1 | 0 | 0 | 2 |
| Bills fallen | 0 | 7 | 0 | 0 | 7 |
| **Total** | **63** | **16** | **5** | **3** | **87** |

The script's rows are `acts`, `awaiting_assent`, `withdrawn` and `fallen`, and
its `government_or_hybrid` column answers the fact sheet's "Government".
**This is the first reconciliation with four rows**, and the first in which our
`passed` is two of the fact sheet's tables added together: 75 Acts plus 3
awaiting. A three-row answer means the fourth table has not been read.

**On `bill_type` alone**: government 63, members 16, private 5, committee 3 —
**identical to the table above**, because Session 5 has no Hybrid Bill. A hybrid
appearing here means the reader has typed something `H` that the fact sheet does
not.

**7. Outcomes.** passed and enacted 75; passed and blocked 3; rejected at Stage 1
3, not enacted; withdrawn 2, not enacted; fell at dissolution 4, not enacted.

The fact sheet gives the row totals only — 75 Acts, 3 awaiting Royal Assent, 2
withdrawn, 7 fallen. Splitting the 7 into 3 + 4 is ours, methodology note M7:
three from the Official Report of the day, four from the day the session ended.
**No Session 5 bill was rejected at Stage 3, none fell for want of a financial
resolution, and none is recorded as pending**; those three values should not
appear. `pending` in particular is the value the fact sheet's own table heading
proposes and the footnotes refuse: see `DECISIONS.md`, 2026-09-14.

**8. Required cells.** Every column 0.

The second line is the cells the fact sheet does not fill: **no_sp_bill_number
75**, has_a_procedure 0, has_a_title_as_introduced 0. The Session 5 fact sheet
prints an SP Bill number for the twelve bills that did not become Acts — the
nine that did not pass and the three stopped before Royal Assent — and for none
of the 75 Acts, which the fresh extraction confirms cell by cell. A smaller
number here means a bill number has been invented.

**9. Every Session 5 Act.** 75 enacted, 0 without an asp number, 0 without an
assent date, 0 where the asp number's year disagrees with the assent year. The
75 is the fact sheet's own Acts total, and the three blocked bills are correctly
not among them: they have no number and no assent date, and they are not
`enacted`.

**And 0 Acts anywhere on the clean sheet whose number has no year** — the check
`db/062` added, which Session 5's Period Products Act was the first to trip.

**`acts_whose_title_has_no_year` — expected 0, and predicted to read 1.**
**[Read 1, and the one Act it named was the Period Products Act, as predicted.
No second name appeared. The owner settled the title question on 2026-09-14 and
`db/078` corrected it; re-run, this reads 0 and names nothing.]** This is
the title question above. The one Act it names should be the Period Products
(Free Provision) (Scotland) Act. **If a second name appears, that is not the
known thing** and is to be reported as its own finding: it would mean an Act
title has lost its year somewhere other than where the fact sheet printed it
short.

**10. Stage records per bill.** passed 3 stages × 78; rejected at Stage 1 1 × 3;
withdrawn 1 × 2; fell at dissolution 1 × 4. This is item 1's derivation seen per
bill, and the two must agree. The three blocked bills are inside the 78: being
stopped before Royal Assent takes nothing off a bill's stages.

**11. Where every Session 5 stage date came from.** `phd` 153 (all dated),
`spice_factsheet_legislation` 78 (all dated), `official_report` 3 (all dated),
`bill_page` 9 (6 undated), and nothing recorded as a stage that never happened.

- **78** is the passing date of every bill that passed, off the fact sheet: 73
  Stage 3 dates and 5 Final Stage dates.
- **153** is the owner's dataset, counted in the workbook rather than in the
  database: of its 86 Session 5 rows, 80 carry a Stage 1 date and 77 a Stage 2
  date. The three with a Stage 1 date and no Stage 2 date are the three bills
  rejected at Stage 1, whose date the Official Report already holds, so nothing
  is written for them; the six with no Stage 1 date at all are the six that
  ended where they stopped. That leaves 77 Stage 1 dates and 77 Stage 2 dates,
  less the Civil Partnership Act's Stage 2, which the bill page holds because the
  dataset had the month wrong (`db/076`): 77 + 76 = 153.
- **9** is the six undated endings, the Domestic Abuse Act's Stage 1 and Stage 2,
  and the Civil Partnership Act's Stage 2 — every one from the Parliament's own
  bill pages (`db/075`, `db/076`).
- **3** is the Stage 1 each rejected bill was rejected at.

**By position**, which is where the derivation is actually checked: `phd` 77 at
position 1 and 76 at position 2; `spice_factsheet_legislation` 78 at position 3;
`official_report` 3 at position 1; `bill_page` 7 at position 1 and 2 at position
2. Nothing at position 4: Session 5 has no Reconsideration stage, the two bills
that had one having had it in Session 6.

Across the whole clean sheet: `phd` 675, `spice_factsheet_legislation` 338,
`official_report` 29 (3 undated), `bill_page` 29 (26 undated), 2 recorded as
stages that never happened. Those four add to 1071, which is item 1's total.

**12. Two accepted rows for the same stage.** 0, in every session, and the
listing that follows returns nothing. Session 5's three Stage 1 dates come from
the Official Report, and **the dataset's dates for the same three bills agree
with it to the day** — Restricted Roads 13 June 2019, Culpable Homicide 21
January 2021, Post-mortem Examinations 26 January 2021, read in the workbook
before this test was written. The Civil Partnership Act's Stage 2 is the same
shape: the bill page holds it, the dataset now agrees since the correction, and
nothing should be written twice. A second row means the loader wrote the
dataset's date over a more primary source even though the two agree.

**13. How each Stage 1 rejection came about.** `member_motion_disagreed` 18
bills, 0 with a note for readers; `member_motion_amended_agreed` 2 bills, 2 with
notes; `committee_motion_9_14_18` 2 bills, 2 with notes. `other_route` should not
appear. The 18 is Sessions 1 to 4's 15 plus Session 5's 3, none of which needs a
reader's note: all three went the ordinary way.

The listing gives the three bills and the day each ended. Every one must have
`date_concluded` equal to its Stage 1 date and the source `official_report`:

| Bill | Route | Ended |
|---|---|---|
| Restricted Roads (20 mph Speed Limit) | `member_motion_disagreed` | 13 June 2019 |
| Culpable Homicide | `member_motion_disagreed` | 21 January 2021 |
| Post-mortem Examinations (Defence Time Limit) | `member_motion_disagreed` | 26 January 2021 |

**14. Every source on the list has a definition.** Nine sources, all true. Stage
records as item 11. `bill_rows` is `spice_factsheet_legislation` 389 and every
other source 0 — a bill's own line always comes from a legislation fact sheet.
Cells: `bill_page` 8, `legislation_gov_uk` 17, `manual` 2, `official_report` 46,
`spice_factsheet_dates` 27, `spice_factsheet_legislation` 5; `api`,
`bill_document` and `phd` 0. Those six add to 105, which is item 1.
**[moved by db/078: `legislation_gov_uk` 18, and the six add to 106. This test
did not name item 14 among the items the title question moves, and it does move
it — the same arithmetic as item 5, one row further down.]**

**`spice_factsheet_legislation` holding cells at all is new**, and it is the
footnotes: five cells, being the three blocked bills' status and the two dates.
Before Session 5 a legislation fact sheet was the source of whole lines and never
of a single cell.

**15. The notes a reader is given.** M1 to M8, eight of them, none empty.

Six are expected unchanged from Session 4's closed test, and those six figures
are quoted from it rather than derived: M1 358, M2 5140, M3 1088, M4 971, M6
1605, M8 2673. A length that has moved means somebody edited a note; find out who
and why before marking anything.

**M5 and M7 are the two Session 5 moves**, and neither is checked by its length:

- **M5** was 1940 at Session 4's test and `db/072` added two sentences to it, so
  that a reader is told the account of what became of the four blocked bills runs
  ahead of the data until Session 6's fact sheet is read in. Expected:
  `m5_counts_the_four_blocked_bills` true and `m5_says_it_runs_ahead_of_the_data`
  true.
- **M7** must say the coding of why a bill fell has been done for Sessions 1 to
  5. Expected: `m7_says_five_sessions_are_coded` true and `m7_still_says_four`
  false. **Predicted to fail on both**, which is the second of the three things
  above. **[Failed on both, as predicted, at 5003 characters. The owner agreed
  the correction on 2026-09-14 and `db/078` made it: two sentences, "Sessions 1,
  2, 3 and 4" to "1, 2, 3, 4 and 5" and "the first four sessions" to "the first
  five", M7 three characters longer at 5006. Re-run, both read as expected. The
  other seven notes did not move.]** Read the note in full: what matters is not the phrase the check looks
  for but whether a reader is told five sessions or four.

**16. Notes on the Session 5 staging lines.** 3 with a note for readers, 85 the
reader remarked on, and **at least 7 with a review note**.

- **3 notes for readers** are the three blocked bills, and nothing else: the
  three rejections took the ordinary route, which needs no explaining to a
  reader.
- **7 review notes** are lines 306, 309, 310 and 360 from `db/073` and the three
  adjudicated lines from `db/074`. **If it reads 10**, the three blocked bills
  carry one from review as well, which is likely and unobjectionable — read them
  and say so. Any other number, or a note on a line not in that list, is
  something to read out before marking.
- **85, not 87.** The two lines the reader said nothing about are the two
  withdrawn bills, the Children and Young People (Information Sharing) Bill and
  the Liability for NHS Charges Bill: neither became an Act, so there was no Act
  title to remark on, and neither fell unexplained. Session 4's single silent
  line was the same shape.

The reader's own remarks, and how many lines carry each, from the fresh
extraction:

| The reader said | Lines |
|---|---|
| title is the Act title, not the title as introduced | 72 |
| the factsheet says the bill fell and not why; outcome left for review | 6 |
| a footnote marker was removed from the word Bill; the footnote says the bill cannot be submitted… | 2 |
| title is the Act title, not the title as introduced; read from a row the factsheet split across a page | 2 |
| a footnote marker was removed from the word Bill; the footnote gives no date… | 1 |
| the factsheet says the bill fell and not why; outcome left for review; read from a row the factsheet split… | 1 |
| title is the Act title, not the title as introduced; the factsheet prints no year before the asp number | 1 |

The script truncates each to 76 characters, so the three longest collapse to
their openings; the counts are what to compare. **The three footnote remarks are
the reader deciding `blocked` rather than `pending` from the footnote's own
words**, which is the judgement `DECISIONS.md` records for 14 September, made by
the reader and not by a person.

**17. Where the Parliament changed what it called its own bills.** Government
bills by session and by how the type was styled at the time: Session 1
`executive` 51; Session 2 `executive` 53; Session 3 `executive` 44; Session 4
`executive` 15 and `government` 52; **Session 5 `government` 63 and no
`executive` at all.**

Session 4 is where the styling changed inside a session. Session 5 is the first
session with no Executive Bill in it, and the fresh extraction confirms why:
every one of its 63 government bills is typed plainly `G`, with no `G*` footnote
anywhere in the document. An `executive` count above 0 here means the reader has
carried Session 4's footnote forward.

**18. Every bill that did not pass says where it ended.** 0.

The listing shows the nine Session 5 bills that did not pass. Three name Stage 1,
dated from the Official Report, each date equal to the bill's `date_concluded` as
item 13 sets out. The other six are undated and cite the bill page, because none
of them ended on a decision of the Parliament: each stopped at Stage 1 without
completing it, and there was no vote to date. See `DECISIONS.md`, 2026-09-14.

**19. Every stage date held for a Session 5 bill that did not pass.** Nine rows,
one per bill, every one at stage_order 1, `completed` false, `fell_here` true.

The three rejections are dated as item 13 and **every one must say
`official_report`**. If any says `phd`, the dataset's date has been carried in
place of the Official Report's and this item fails — even though all three agree
to the day, because what is being checked is that the load left the more primary
source in place. The six endings are undated and say `bill_page`.

**20. The three bills that passed and were stopped before Royal Assent.** The
first bills on the clean sheet that have not finished.

| Bill | Passed | Blocked on | Note characters |
|---|---|---|---|
| UK Withdrawal from the European Union (Legal Continuity) | 21 March 2018 | empty | 385 |
| European Charter of Local Self-Government (Incorporation) | 23 March 2021 | 6 October 2021 | 357 |
| United Nations Convention on the Rights of the Child (Incorporation) | 16 March 2021 | 6 October 2021 | 357 |

Each must read `outcome` passed, `enactment_status` blocked, no Royal Assent
date and no asp number. **The empty cell against the UK Withdrawal Bill is the
fact sheet's own silence**, not a gap: its footnote gives no date for the ruling,
and the note says so in words.

The character counts are of the wording the owner agreed on 14 September, quoted
in `DECISIONS.md`, counted from that text and not from the database. **A small
difference means the words typed at review are not the words agreed** — which is
worth knowing either way, so read the note out beside the decision rather than
waving the number through or assuming the note is wrong.

The phrase checks are of facts and not of wordings, for the reason Session 4's
item 20 had to be rewritten: `opens_with_the_fact`, `names_the_mechanism`,
`names_who_referred_it` and `says_what_was_ruled` true on all three;
`gives_the_ruling_date` true on the two the fact sheet dates and false on the UK
Withdrawal Bill; `says_the_fact_sheet_gives_no_date` the other way round — false,
false, true.

**Each of the three has 3 stage records and 3 periods counted**, its Stage 3
dated and no fourth period, because there is no Royal Assent to count to. Their
Stage 3 dates are the passing dates above. This is the difference between a bill
that was stopped and a bill that is missing a date: the stages are complete and
the period after them does not exist.

**21. A bill that passed, has no Royal Assent date and does not say why.** 0, and
0 blocked bills with nothing said to a reader.

**This is the hole `db/071` found and closed**, and it is worth stating plainly
because it was open for every session before this one: a bill could have been
recorded as passed, given no Royal Assent date, left as not enacted with nothing
on the line saying why, and the error checker would have admitted it. The rule is
now worded about the Royal Assent date rather than about enactment. A non-zero
answer means it is open again.

**22. A Private Bill's stages are recorded under a Private Bill's names.**

| Bill type | 1 | 2 | 3 |
|---|---|---|---|
| committee | stage_1 3 | stage_2 3 | stage_3 3 |
| government | stage_1 63 | stage_2 62 | stage_3 62 |
| members | stage_1 16 | stage_2 8 | stage_3 8 |
| private | preliminary 5 | consideration 5 | final 5 |

Government's 63 at position 1 is the 62 that passed plus the withdrawn Children
and Young People Bill; members' 16 is the 8 that passed, the 3 rejected, the 1
withdrawn and the 4 out of time. `stage_1` appearing against `private` means the
loader has used the public names, and the comparison of a Private Bill's
Consideration Stage with an ordinary bill's Stage 2 then rests on a claim the
database is supposed to refuse.

**23. `db/077`'s guards, derived again rather than re-run.** A migration's own
provocations are the writer's account of itself; these are the same rules asked
of the clean sheet from outside. All four counts 0.

- **`stage_dates_before_introduction` 0** and
  **`stage_dates_after_the_bill_or_its_session_ended` 0**. The second is the
  guard that did not bite when `db/077` was written: its ceiling was the bill's
  own last stage date where the bill had neither a Royal Assent date nor a date
  it concluded, which on the three blocked bills is the date being checked, so a
  Stage 3 dated any year at all passed it. The ceiling is now the day the bill
  ended, and where it has not ended, the day the session ended — which is what
  the query above measures against. See `DECISIONS.md`, 2026-09-14.
- **`stages_out_of_order` 0.** This is the check that caught the Civil
  Partnership Act's Stage 2 being typed three months before its Stage 1
  (`db/076`), so it has bitten once for real.
- **`session_5_stage_dates_from_another_source` 0.** The four sources Session 5's
  review covered are the legislation fact sheet, the dataset, the Official Report
  and the bill page. Anything else on a Session 5 stage record was not reviewed.
- **The dateless listing is exactly six bills**, each at Stage 1: Disabled
  Children and Young People (Transitions to Adulthood), Fair Rents, Travelling
  Funfairs (Licensing), Welfare of Dogs, Children and Young People (Information
  Sharing) and Liability for NHS Charges. Seven means a date has been lost; five
  means one has been invented.

**24. Every period counted for Session 5.**

| Counted to | Periods |
|---|---|
| introduction → stage_1 | 76 |
| introduction → preliminary | 5 |
| stage_1 → stage_2 | 73 |
| preliminary → consideration | 5 |
| stage_2 → stage_3 | 73 |
| consideration → final | 5 |
| stage_3 → royal_assent | 70 |
| final → royal_assent | 5 |

312 in all. The 76 at the first row is the 73 public bills that passed plus the 3
rejected at Stage 1; the 70 at `stage_3 → royal_assent` is those 73 less the
three blocked, and that gap of three is the whole point of item 20. The six
undated endings count nothing, which is item 29.

**The shortest and longest roads from introduction to the end of Stage 3**, both
predicted from the fact sheet's own introduction and passing dates:

| | Days |
|---|---|
| Coronavirus (Scotland) Act 2020 | 1 |
| Coronavirus (Scotland) (No.2) Act 2020 | 9 |
| UK Withdrawal from the European Union (Legal Continuity) | 22 |
| Planning (Scotland) Act 2019 | 563 |
| Period Products (Free Provision) (Scotland) Act | 581 |
| Pow of Inchaffray Drainage Commission (Scotland) Act 2018 | 636 |

**Read the second and third rows carefully.** The session that promoted Session 5
reported the three shortest as 1, 27 and 28 days, the last two being Budget Acts.
The fact sheet's own dates make them 1, 9 and 22: the Coronavirus (No.2) Act was
introduced on 11 May 2020 and passed on 20 May, and the UK Withdrawal (Legal
Continuity) Bill on 27 February and 21 March 2018. If the answer here is 1, 9 and
22, the clean sheet agrees with the fact sheet and the earlier account was loose
prose. **If it is 1, 27 and 28, then two bills' Stage 3 dates on the clean sheet
are not the fact sheet's**, and that is a finding about the data rather than
about the prose.

### Then, outside the script

**25. The data dictionary is still true.**
`python3 tools/make_data_dictionary.py` produces no difference from the committed
file, at 17 tables and 162 columns. Session 5 added two columns to the staging
sheet in `db/071` — `date_assent_blocked` and `raw_footnote` — so the committed
dictionary must already describe both; if it does not, the script refuses to run
and the dictionary has to be committed with the migration that made them.

**26. The reader still reproduces what was loaded.** Extract the Session 5 fact
sheet afresh and compare against the staging lines' raw columns: 87 rows,
0 differing.

    extract_factsheet.py <pdf> --session 5 --csv out.csv

**Nothing may be supplied to the reader but the PDF and the session number.**
That is what this item is for.

**The worked-out columns that must differ, and only these** — nine cells across
nine bills. **[Read exactly nine, then exactly ten after `db/078`, the tenth
being the `short_title` this item already names below. 87 rows both times, every
one pairing, and no column that must not differ did.]**

- `outcome` on all seven bills the fact sheet's Fallen table holds, because since
  `db/051` the reader decides none of them: Culpable Homicide, Post-mortem
  Examinations (Defence Time Limit) and Restricted Roads (20 mph Speed Limit),
  read in the Official Report; Disabled Children and Young People (Transitions to
  Adulthood), Fair Rents, Travelling Funfairs (Licensing) and Welfare of Dogs,
  worked out from the day the session ended.
- `date_introduced` on one, corrected against the Parliament's bill page:
  Solicitors in the Supreme Courts of Scotland (Amendment), 26 September 2019
  where the fact sheet prints 2020.
- `asp_number` on one, which the fact sheet prints with no year: Period Products
  (Free Provision). **A tenth cell, `short_title` on the same bill, if the owner
  settles the title question.**

`outcome` must **not** differ on the two withdrawn bills. The reader reads the
Withdrawn table and codes them itself.

`enactment_status` and `date_assent_blocked` must **not** differ on the three
blocked bills. The reader produces both from the footnotes since `db/071`, and a
difference here means the review typed by hand what the reader already gives.

`date_royal_assent` must **not** differ on the Age of Criminal Responsibility Act
or the Heat Networks Act. Both disagreements were with the dataset, not with the
fact sheet, and the fact sheet's dates are what stand; a difference here means
the wrong source won.

`bill_type` must **not** differ, on any of the 87. The reader produces no
`stage_1_rejection_route`, `bill_note` or `official_report_read_on` at all, so
those are not comparisons.

**Also check the dissolution rule afresh**, as every session since the first
does: of the seven fallen bills in the fresh reading, exactly the four concluding
on Session 5's last day of **4 May 2021** are the four coded `fell_dissolution`,
none over and none missing. That is what makes those four differences a rule
being applied rather than a coding nobody can reproduce.

**27. The dataset's fingerprint** is sha256
`072184df1fd4fbc15ae9e66ca51f9e287de6bc9b3b8f4d8342f6cae4e79ac1d2`, computed
from `sources/phd/Billdates-September2026.xlsx` on 2026-09-14.

It was `6614b3a1…c135420f` when Session 4 closed, and Session 5 moved it twice
under the rule the owner settled that day: first the two Royal Assent dates the
fact sheet was right about, then the Civil Partnership Act's Stage 2 month, which
the error checker caught because the dates were in an impossible order. The
Corrections sheet carries all three, each with what it was checked against.

The ten Session 5 names paired by hand in `tools/phd_stage_dates.py` are not
corrections and do not move the fingerprint: the four Budget Acts, which the
dataset numbers within the session for a third session running, and six wording
slips. Every pair agrees on both dates the two sources share. **One Session 5
line has no dataset row at all** — the Domestic Abuse (Protection) (Scotland) Act
2021 — which is why 87 lines pair with 86 rows, and it is named in
`NOT_IN_DATASET` with the bill page that holds its two dates instead.

**This is the one item a later session can move.** Adjudicating a disagreement
for Session 6 or beyond corrects the file and the fingerprint changes with it.
Record the new one beside the old; nothing else about Session 5 is reopened by it.

**28. Promotion is still reversible.** **[Done on 2026-09-14 by the session
that ran this test, which had done none of Session 5's work. Off: 0 bills, 0
stage rows, no stamps on the staging lines, 302 bills left. Back on: 389, 1071,
105. Compared cell by cell against a copy taken first, the only differences were
record numbers and the times things were written. Thrown away; nothing left
behind. Done a second time for real when `db/078` corrected the title, which is
how that correction reached the clean sheet.]** Take Session 5 off and put it back inside a
transaction that is thrown away, and the result is identical. The procedure is in
`docs/PROMOTION-RUNBOOK.md`. The session that promoted Session 5 did this and
saved it, which is not the same as a session that did none of the work doing it:
Session 5 is the first session whose promotion writes provenance for a blocked
bill, and the first to go on with its Stage 1 and Stage 2 dates already there, so
there are two things in it that have never been undone by anyone else.

**29. Every period is counted, or has a stated reason.**
**[Ran clean: 1377 counted, 27 with no day recorded — 21 from Sessions 1 to 4
and Session 5's six undated endings — and, beside them, the 2 stages of the
reintroduced Robin Rigg Bill that never happened, which item 11 already counts.
So 29 stages are uncounted in all under two stated reasons, and the 27 this item
names is the first of the two. Worth saying plainly because the number alone
reads as a discrepancy and is not one.]**
`tools/duration_coverage.sql` runs clean: **1377 counted**, and 27 not counted —
21 from Sessions 1 to 4, as Session 4's test settled, and 6 from Session 5, being
the six undated endings. No third category; the script stops if one appears.

1377 is Session 4's 1065 plus Session 5's 312, which is item 24's table. **Note
what is not in the 27**: the three blocked bills contribute no uncounted period
at all, because the script only adds a Royal Assent point for a bill that was
enacted. A blocked bill is not a bill missing a period; it is a bill whose next
period does not exist.

**30. The repository is clean** and level with GitHub, and the migrations are
numbered without a gap. `db/063` and `db/066` share a filename, which is known
and accepted; see `STATE.md`, housekeeping.

**31. The rule `db/078` added, derived again rather than re-run.** **Written on
2026-09-14 by the session that added it, and deliberately not run by it.** The
migration proves its own rule by taking a year off a title, reading the checker
and putting it back; that is the writer's account of itself, and item 23 is here
because such an account is not a check. Ask the clean sheet and the staging
sheets the rule again, from outside:

- **Every line recorded as having become an Act has a title ending in a four-digit
  year.** Expected 335 of 335 on the staging sheets and 389 bills unaffected —
  335 being the enacted lines across Sessions 1 to 5, counted before the rule
  was added, when 334 of them already satisfied it.
- **No line that did not become an Act has one.** Expected 0 of 54: the 51
  recorded as not enacted and the 3 stopped before Royal Assent, whose titles
  end in "Bill". This is the half that matters, because a rule that asked every
  line for a year would quietly be wrong about every bill that never became an
  Act.
- **The rule is about enactment and not about the number.** A line with an
  `asp_number` and no enactment is not what it keys on; there are none, and
  there should be none.
- **And the checker still reports nothing at all.** Expected 0.

If any of those is not what is found, `db/078` is the migration to read first.

**Run on 2026-09-14** by a further session, which added nothing to the database
and did not write this item. **All four parts answer as expected.**

- **Every enacted line's title ends in a four-digit year: 335 of 335**, on the
  staging sheets and on the clean sheet alike, with no line of either failing.
- **No line that is not an Act has a year: 0 of 54**, and the 54 split 51 not
  enacted and 3 blocked, which is the split the item predicted.
- **No line carries an `asp_number` without being recorded as enacted**, and
  none of the 335 enacted lines is missing one, on either sheet.
- **The error checker reports nothing at all**, and the gaps list with it.

The rule was asked of the sheets and not of the migration, and `db/078` was not
read while asking it.

**32. The rule `db/079` added, asked of the notes rather than of the migration.**
**Written on 2026-09-14 by the session that added it, and deliberately not run
by it**, for the reason item 31 gives. Eight provenance notes ended with the
words "Read at" and then stopped, because the step that files a note cuts it at
the first address and that phrase existed only to introduce the address. The
step is mended, the eight were rewritten by taking Sessions 5 and 4 off the
clean sheet and putting them back, and the database now refuses a note that ends
that way. Ask the notes:

- **No note's words end in "Read at."** Expected 0 of 106, the 106 being item 1's
  figure.
- **The eight that did now end where their sentence ends**, in a closing
  quotation mark or a full stop: five in Session 4 and three in Session 5, all of
  them outcomes cited to the Official Report. The eight and the five-and-three
  split were counted off the staging sheets before anything was moved, and the
  two rehearsals moved three cells and five cells respectively.
- **The address was never part of the words and is not lost.** All **24** notes
  recording an outcome read in the Official Report still carry an address as
  their reference — the 24 is item 5's table — and each still carries the day it
  was read.
- **Sessions 1 to 3 are untouched.** Their **16** outcome notes never had an
  address to cut, because their review notes were worded differently, and none
  contains the phrase at all. 16 is 24 less the eight.
- **The rule binds a writer other than promotion.** It sits on the note itself
  and not in the staging checker, because the staging sheets were never wrong:
  their review notes carry the full sentence, address and all. So a change made
  by hand that ends a note in "Read at" must be refused too, and the check is
  worth making that way round rather than through promotion.
- **And the checker still reports nothing at all.** Expected 0.

If any of those is not what is found, `db/079` is the migration to read first.

**Run on 2026-09-14** by a further session, which added nothing to the database
and did not write this item. **All six parts answer as expected.**

- **No note's words end in "Read at": 0 of 106.**
- **The twenty-four outcome notes cited to the Official Report end where their
  sentence ends**, every one of them, in a closing quotation mark or a full
  stop. The eight are there: five in Session 4 and three in Session 5. Six of
  them end in a quoted "Motion disagreed to."; the Restricted Roads Bill's ends
  in the quoted title of the motion, and the Transplantation Bill's in the words
  "not printed on this page."
- **The address was never part of the words and is not lost.** All 24 carry an
  address beginning `https://` as the note's reference, and all 24 carry the day
  it was read.
- **Sessions 1 to 3 are untouched: 16 notes**, five, six and five, and not one
  of the 24 contains the phrase "Read at" anywhere at all any more.
- **The rule binds a writer other than promotion.** Asked twice inside a
  transaction that was then rolled back: adding " Read at" to the end of an
  existing note by hand was refused, and so was a new note written from nothing
  whose words ended that way. Nothing was left behind.
- **The error checker reports nothing at all**, and the gaps list with it.

The rule was asked of the notes and not of the migration, and `db/079` was not
read while asking it.

### Part B — the owner's sign-off

None of these is for anyone else to answer. A sign-off is recorded here on the
day it is given, and nowhere else.

**All nine given on 2026-09-14**, in one session, each against the rows and the
text read back out of the database rather than out of a note about them. Two of
the nine changed something: sign-off 2 turned up eight provenance notes ending
mid-sentence, mended by `db/079`, and sign-off 9 found the explainer silent about
the rule that mend added, which was written into it before the document was read.

**Part B is complete, and so is Part A**: item 32 was run on 2026-09-14 by a
session that did not write it, and answered as expected. **Session 5 is closed.**

1. **What happened to each bill.** The counts in items 6 and 7 are what you
   expect for Session 5: the reconciliation against the fact sheet's summary in
   every cell and both margins, including its fourth table for the first time,
   and the split of its seven fallen bills into three rejected at Stage 1 and
   four that ran out of time.
   **Given on 2026-09-14**, against the reconciliation read back out of the clean
   sheet and set beside the fresh extraction's table cell by cell, and against the
   seven fallen bills listed by name under each heading.
2. **The three bills read in the Official Report.** For each, the quotation on
   the line and the ending recorded against it. You found all three on the
   Parliament's bill pages, which print the divisions and name two of the three
   motions; the citation is the Official Report because that is where the
   Parliament decided, and the Restricted Roads motion's number and mover are
   from the bill page with the line saying so. The sign-off is on the record as
   it was read.
   **Given on 2026-09-14**, with all three notes handed over in full rather than
   summarised. **Reading them in full is what found the fault `db/079` mended**:
   each ended with the words "Read at" and nothing after them. The sign-off was
   given on the text as it then stood, and the eight characters removed since are
   the dangling phrase and nothing else — the quotation, the ending recorded and
   the citation are the same words the owner read.
3. **The three bills stopped from Royal Assent.** The words a reader sees against
   each, read in full off the clean sheet rather than out of the decision that
   agreed them, and that `blocked` rather than `pending` is still what you want —
   the table's heading says awaiting, the footnotes say cannot be submitted, and
   we followed the footnotes. Also that recording them as Session 5's fact sheet
   leaves them, with what happened next left to Session 6, is right.
   **Given on 2026-09-14**, against the three notes read in full off the clean
   sheet with the fact sheet's own footnote set beside each, against the
   definitions of `blocked` and `pending` as `ref_enactment_status` states them,
   and against M5's own statement that its account of what became of these bills
   runs ahead of the data. The UK Withdrawal Bill's missing block date was read as
   part of it: the fact sheet gives no date for its ruling, the line says so, and
   that is why these three carry five provenance notes and not six.
4. **The six bills that ended where they stopped**, checked against the clean
   sheet rather than against the note of them: each at Stage 1, not completed,
   marked where the bill ended, and undated because there was no decision to
   date.
   **Given on 2026-09-14**, against all six read off the clean sheet: one stage
   row each, Stage 1, not completed, marked as where the bill ended, undated, and
   each carrying the sentence the clean sheet writes for itself. Read with them:
   the two withdrawn and the four out of time, their introduction and conclusion
   dates, and that all four of the latter concluded on 4 May 2021, which
   `session.date_session_end` gives as the day Session 5 ended and which is the
   whole basis of the coding.
5. **The three adjudicated dates and the Act number the fact sheet printed
   short**: the two Royal Assents settled the fact sheet's way against
   legislation.gov.uk, the Solicitors Bill's introduction settled at 26 September
   2019 against the fact sheet's 2020, and the Period Products Act's number at
   2021 asp 1 — each with its source, its place in that source, the value in the
   source's own words and the day it was read.
   **And the question this test turned up: whether that Act's title should carry
   its year too**, as Session 4's Higher Education Governance Act's did. Item 9
   is written expecting yes. **The owner said yes on 2026-09-14, so this
   sign-off is now on four cells and not three, the fourth being
   `short_title` = Period Products (Free Provision) (Scotland) Act 2021, from
   legislation.gov.uk, read that day.**
   **Given on 2026-09-14**, all four cells together: each read back off the clean
   sheet with its source, its place in that source, the source's own words and the
   day it was read, and with the `Differs:` and `Checked:` lines from the staging
   line beside it. The Solicitors Bill is the one of the four that moved the line;
   the two Royal Assents did not, and the Period Products number and title were
   both absent from the fact sheet rather than disputed.
6. **The ten names paired by hand**, checked against the fact sheet and your
   dataset side by side, and **the one bill your dataset does not have** — the
   Domestic Abuse (Protection) (Scotland) Act 2021, whose Stage 1 and Stage 2
   come from its own bill page instead, with the introduction, Stage 3 and Royal
   Assent dates on that page agreeing with what the fact sheet already put on the
   line.
   **Given on 2026-09-14**, against the ten pairs listed with the fact sheet's
   wording beside the dataset's, and against the Domestic Abuse (Protection) Act
   read off the clean sheet stage by stage: Stage 1 and Stage 2 cited to the bill
   page with the page's own words, and introduction, Stage 3 and Royal Assent
   agreeing with what the fact sheet had already put on the line — the agreement
   `db/075` refuses the two new dates without.
7. **The Civil Partnership Act's Stage 2 month**, settled at the bill page at 11
   June 2020 where the dataset had 11 February, and the dataset corrected after
   the database, so that the record the two sources disagreed survives the file
   being put right.
   **Given on 2026-09-14**, against the bill page's own sentence, the four stage
   dates as the clean sheet now holds them, the staging row that still carries the
   whole account of the disagreement, and the file's Corrections sheet, which
   records the fingerprint the file had before each change so the chain back to
   the untouched thesis dataset is unbroken.

8. **M5 and M7 read in full**, as a reader will see them: M5 saying that its
   account of what became of the four blocked bills runs ahead of the data, and
   M7 saying which sessions the coding of why a bill fell has been done for.
   **M7 was a session out of date and no longer is** — see item 15. Read it as
   it now stands.
   **Given on 2026-09-14**, both read in full as a reader will see them, not
   summarised. M7 was read at 5006 characters, saying Sessions 1, 2, 3, 4 and 5.
   M5 was read with its closing sentence, which tells a reader outright that its
   account of what became of the four blocked bills runs ahead of the data.

9. **That you can explain how this database works** from the documents alone,
   without help. The standing requirement, put again because Session 5 is the
   first session that puts an unfinished bill on the clean sheet. **`docs/HOW-THE-DATABASE-WORKS.md` was wrong about its own
   contents when this was written**, §3 saying 86 notes and §4 ninety-one. Both
   were corrected on 2026-09-14 and it now says 106 and 92. It is ready to be
   read.
   **Given on 2026-09-14.** The figures corrected that day were re-checked
   against the database first and still stood at 106 and 92; nothing that day
   changed how many notes there are. One sentence was added to the explainer
   before it was read, saying that the notes tab now refuses a note whose words
   end "Read at" — `db/079`'s rule, which the document would otherwise have been
   silent about.


### Part C — what this test does not check

- **Whether Session 5's stage dates are right.** The 153 from the dataset rest on
  the dataset alone, and nothing has compared them against the Parliament's bill
  pages — 87 pages, and its own piece of work. The owner's judgement on 14
  September is that the error rate is likely very low and tolerable until there
  is a methodology for the check. The error checker catches a date in an
  impossible order, as it did for the Civil Partnership Act, and not one that is
  wrong and still in order.
- **Whether the 75 Royal Assent dates and 87 introduction dates nobody has
  checked are right.** Two Royal Assents and one introduction date were checked
  because the two sources disagreed; the rest agree between fact sheet and
  dataset, which is corroboration and not verification. M8 says which a reader
  has.
- **Whether the Official Report was read correctly beyond the words quoted.**
  Nobody has read the surrounding debate for any of the three rejections.
- **What became of the three blocked bills.** Two were reconsidered and enacted
  in Session 6 and one was withdrawn there. None of that is in the database, by
  decision, until Session 6's fact sheet has been read in; M5 says so in words,
  and passing this test says nothing about it.
- **Whether the section 33 and section 35 distinction should be a variable.**
  Four bills now sit under `blocked` by two different mechanisms. On the waiting
  list, to be revisited at a fifth.
- **Bills carried over between sessions.** Four bills appear in two fact sheets,
  and the double-count guard cannot see two of them — the European Charter and
  UNCRC Bills, which are "Bill" here and "Act" in Session 6. Nothing in Session 5
  trips it, so this test does not exercise it and passing says nothing about it.
- **The ceiling in item 23 as it will behave on a carried-over bill.** It will
  refuse one, correctly for everything on the clean sheet now and wrongly for
  Session 6. That is part of the carried-over-bills job `STATE.md` puts before
  Session 6 is loaded.
- **Anything about Sessions 6 and 7**, including the prose reader.

---

## Session 4

Written 2026-09-13 by a session that did none of Session 4's work: it did not
read the fact sheet in, did not build the review, and did not admit it.

**Run on 2026-09-14** by a third session, which had done none of Session 4's
work either. Twenty-five of the twenty-seven mechanical items matched their
predictions exactly. Two did not, and both turned out to be faults in the
prediction rather than in the data: item 26's arithmetic missed a period, and
item 20 looked for a form of words the note never had. Both expected answers are
corrected below, each marked and reasoned, so that what a later reader compares
against is the corrected figure and not the original guess.

**Part B is marked. All nine sign-offs were given on 2026-09-14**, in one
session, each against the rows read back out of the database rather than out of
a note about them. Three of the nine changed something. Item 7 settled that the
working dataset is corrected whenever it is found wrong, so the National
Galleries introduction date was corrected in the file and item 24 carries the new
fingerprint. Item 8 named M4 where it meant M1, and the test is corrected. Item 9
found the explainer silent on the note a reader sees and M7 a session out of
date, and both were put right before the document was read. **Session 4 is
closed.**

**Reopened on 2026-09-14, and closed again unchanged.** Five of Session 4's
provenance notes ended mid-sentence, with the words "Read at" and nothing after
them, and the fault was in the step that files a note rather than in anything
Session 4 read or typed. Session 4 was taken off the clean sheet and put back so
the five were rewritten by the ordinary route; see `db/079`. **No answer of this
test moves.** Item 5 counts the notes cited to the Official Report and says what
each is cited to, not how its words end, and its 21 is unchanged; the cells item
5 lists in full are the other four, none of them affected. The comparison against
a copy taken beforehand found those five cells and no others. This is marked here
only so that a later reader who compares the wording is not puzzled.

Session 4 was deliberately still off the clean sheet when this was written. So
every expected answer below is a prediction made from page 9 of the Session 4
fact sheet, the owner's dataset and the rules — not a description of a database
anyone has looked at. That is the whole point of the order the owner set: the
next session writes the test, a third runs it, and no session marks its own
work at either step. See `DECISIONS.md`, 2026-09-13.

**When to run it.** When Session 4 is on the clean sheet *and* its Stage 1 and
Stage 2 dates are loaded. Before that the counts are of a session half admitted
and the expected answers do not apply.

### Before Session 4 can be promoted at all — both done, 2026-09-13

Writing this test turned up two things Session 4's review did not settle.
Neither was a matter of opinion, and both had to be done before promotion, not
before the test is run. **Both were done on 2026-09-13, in `db/067` and in
`READ_ON`, and this section is kept as it was written with the answers added,
so that a reader can see the test's N was filled in from the sources and not
from the database.**

**First, two bills did not say where they ended.** The error checker was empty and the
gaps list held 160, of which 158 are Stage 1 and Stage 2 dates the load
supplies. **The other two were these:**

| Line | Bill | Ending | Concluded |
|---|---|---|---|
| 296 | Inquiries into Deaths (Scotland) Bill | withdrawn | 24 September 2015 |
| 300 | Footway Parking and Double Parking (Scotland) Bill | fell at dissolution | 23 March 2016 |

Neither has a stage record of any kind. This is the same job `db/056` did for
Session 3's four — two withdrawn bills and two that fell at dissolution, each
established by the owner from the Parliament's own bill page and recorded as an
undated stage row. It was not put on Session 4's review list, and it is the
first task of whichever session promotes Session 4.

**The Footway Parking Bill is not the same shape as Session 3's four.** The
owner's dataset gives it a Stage 1 vote on **1 March 2016**, three weeks before
the session ended — so the bill completed Stage 1 and was somewhere beyond it at
dissolution, where Session 3's two dissolution bills had no Stage 1 date at all.
The dataset is not a source for where a bill ended, and `tools/phd_stage_dates.py`
refuses on exactly this: *"ended before Stage 3, and the dataset dates stage 1
2016-03-01 — a stage nothing on the stage-dates sheet says it completed."* What
that bill's stages were has to come from the source that says so.

**This is why item 1 below carried an N.** Whether those two bills produce two
stage records or three or four was not predictable from the fact sheet, the
dataset or the rules — it turns on what the sources say, which is the owner's to
establish. **The session that records them writes the number into this test,
before promotion.** It is not for the marking session to work out, and a test
whose expected answer is derived after the fact is worth nothing.

**N is 3, settled on 2026-09-13 and recorded in `db/067`.** The Inquiries into
Deaths Bill produces one row and the Footway Parking Bill two:

| Bill | Stage | Date | Ends here | Source |
|---|---|---|---|---|
| Inquiries into Deaths | Stage 1 | none | yes | the bill page |
| Footway Parking | Stage 1 | 1 March 2016 | no, completed | Official Report, 1 March 2016 |
| Footway Parking | Stage 2 | none | yes | Official Report, 1 March 2016 |

The Inquiries into Deaths Bill was withdrawn by Patricia Ferguson on 24 September
2015, in writing to the Parliament's clerk and announced the same day in the
chamber, before the Parliament had debated or decided its general principles. The
Justice Committee had reported on it at Stage 1, but the stage was never
completed, so there is no date — Session 3's two withdrawn bills exactly.

The Footway Parking Bill's general principles **were** agreed, on 1 March 2016:
motion S4M-15759 in Sandra White's name, put at Decision Time and agreed to
without a division. So Stage 1 was completed, on the day the dataset gives, and
the bill stopped at Stage 2, undated. That is Session 1's Gaelic Language Bill
again, already on the clean sheet in this shape, so it is not a new question.

The Parliament's current bill page for the Footway Parking Bill says *"The Bill
fell at Stage 1 on 23 March 2016"*, which read literally contradicts the Official
Report. It is the site's coarse label — the bill got no further than Stage 1 —
and the Official Report is what records the decision. That is the order this
project already uses, and the owner settled it on 2026-09-13.

**Second, `tools/phd_stage_dates.py` had no reading date for Session 4.** `READ_ON`
held 1, 2 and 3, and the script refuses to run without one — deliberately, so
that a date supplied on the command line is not a date recorded nowhere. **Added
on 2026-09-13 as 2026-09-13**, the day the dataset was read for Session 4's
bills. With `db/067` applied the script runs and writes 158 stage rows, which is
what item 11 predicts.

**The one item an outside change can move** is item 24, the dataset's
fingerprint. Nothing else here is reopened by later work.

**What this test does not put again.** Sessions 1, 2 and 3 and their corrections
are settled. Where an answer below covers the whole database it is because
Session 4 moves it, and the earlier sessions' part of it is taken from their own
tests rather than re-derived.

### Part A — mechanical

Run `tools/closure_check_session_4.sql`. It reads only and changes nothing.
Compare each numbered result against the expected answer.

**1. Counts.** bills 302, stage_records 828, provenance_notes 86,
checker_problems 0, gaps 0, staging_lines 302, stage_date_rows 828.

- **302** is 216 plus the Session 4 fact sheet's own total of 86.
- **828** is 583 plus Session 4's 245, and the 245 should be checked as
  a derivation: 74 public Acts × 3 stages = 222; 5 Private Acts × 3 stages = 15;
  the 5 bills rejected at Stage 1 have one each = 5; the two endings above have
  3 between them. 222 + 15 + 5 + 3 = 245. The 3 is the N of the section above,
  settled in `db/067`.
- **The same 828** for stage_date_rows, and that is not a coincidence: every
  accepted stage-date row is carried to exactly one stage record, so once
  Session 4's 84 loaded rows are promoted the two counts are equal. They are 667
  and 583 today because Session 4's 84 are on the staging sheet and not yet
  carried.
- **Of Session 4's 245, 87 are already on the staging sheet** — 74 Stage 3
  dates and 5 Final Stage dates off the fact sheet, 5 Stage 1 dates read in
  the Official Report, and the 3 endings of `db/067` — and **158 arrive with the
  dataset**, being 79 bills ×
  two stages. The 79 is every bill that reached Stage 3; the dataset holds a
  Stage 2 date for exactly those 79 of its 86 Session 4 rows, which was counted
  in the dataset itself rather than in the database.
- **86** is 71 plus 15: 5 outcomes read in the Official Report, 5 Stage 1 routes
  from the same, 1 bill coded as having fallen at dissolution, and 4 cells
  checked at review — the Higher Education Governance Act's title and its
  number at legislation.gov.uk, the Land Reform Act's Royal Assent at the same,
  and the National Galleries Act's introduction date from the owner's own record.
- **0 and 0 are the rule.** The 160 gaps standing on 13 September are 158 dates
  this load supplies and the two endings above; a gap left after both is a
  question about a bill.

**2. Every staging line reviewed, admitted, on the clean sheet and compared.**
Session 1: 73 accepted, 73 promoted, 73 compared. Session 2: 81, 81, 81.
Session 3: 62, 62, 62. Session 4: 86, 86, 86. No other review status appears.
From the fact sheets' totals and the rule that nothing reaches the clean sheet
unaccepted.

**3. Every stage-date row.** Session 1: 200 accepted, 200 carried. Session 2:
213, 213. Session 3: 170, 170. Session 4: 245, 245. No other status.

**4. A recorded difference with no adjudication.** 0. Session 4 recorded two —
the Land Reform Act's Royal Assent and the National Galleries Act's introduction
date — and both were settled on 13 September, each with a `Checked:` line beside
the `Differs:` line.

**5. What has been checked against the source that owns it.**

| Field | Source | Cells |
|---|---|---|
| `asp_number` | `legislation_gov_uk` | 2 |
| `bill_type` | `bill_page` | 1 |
| `date_completed` | `bill_page` | 1 |
| `date_first_meeting` | `spice_factsheet_dates` | 7 |
| `date_introduced` | `bill_page` | 5 |
| `date_introduced` | `manual` | 1 |
| `date_royal_assent` | `legislation_gov_uk` | 11 |
| `date_session_end` | `spice_factsheet_dates` | 6 |
| `outcome` | `official_report` | 21 |
| `outcome` | `spice_factsheet_dates` | 10 |
| `short_title` | `legislation_gov_uk` | 1 |
| `short_title` | `manual` | 1 |
| `stage_1_rejection_route` | `official_report` | 19 |

Sessions 1 to 3 account for 71 of these, and the table above is theirs with
Session 4's fifteen added. Two of the rows are new pairings the database has not
held before: a title settled at legislation.gov.uk, and an introduction date
whose source is `manual`.

**The four Session 4 cells are then listed in full.** Expected:

| Bill | Cell | Source | Value seen |
|---|---|---|---|
| Higher Education Governance | `asp_number` | `legislation_gov_uk` | 2016 asp 15 |
| Higher Education Governance | `short_title` | `legislation_gov_uk` | Higher Education Governance (Scotland) Act 2016 |
| Land Reform | `date_royal_assent` | `legislation_gov_uk` | 2016-04-22 |
| National Galleries of Scotland | `date_introduced` | `manual` | 2015-06-25 |

All four read on 2026-09-13. **Four rows and not three**: the Higher Education
Governance Act's title contains a bracket, and reading a bracketed value out of
a citation is what `db/063` had to fix twice. Three rows here means promotion's
pattern has stopped at the first `(` again and one citation was silently not
seen; two citations collapsed into one means the greediness fault is back. See
`DECISIONS.md`, 2026-09-13.

**6. Reconciliation.** Our counts must match the fact sheet's own summary table
in every cell and both margins. These figures are read off page 9 of the Session
4 fact sheet, not out of the database:

| Session 4 | Government | Member's | Private | Committee | Total |
|---|---|---|---|---|---|
| Acts of the Scottish Parliament | 67 | 6 | 5 | 1 | 79 |
| Bills withdrawn | 0 | 1 | 0 | 0 | 1 |
| Bills fallen | 0 | 6 | 0 | 0 | 6 |
| **Total** | **67** | **13** | **5** | **1** | **86** |

The script's rows are `acts`, `fallen` and `withdrawn`, and its
`government_or_hybrid` column answers the fact sheet's "Government".

**On `bill_type` alone**: government 67, members 13, private 5, committee 1 —
**identical to the table above**, because Session 4 has no Hybrid Bill. Session 3
is the only session where the two readings differ, and its own test explains why.
A Hybrid Bill appearing here means the reader has typed something H that the
fact sheet does not.

**7. Outcomes.** 79 passed and enacted; 5 rejected at Stage 1; 1 withdrawn;
1 fell at dissolution. Every non-passing bill is `not_enacted`.

The fact sheet gives the row totals only — 79 Acts, 1 withdrawn, 6 fallen.
Splitting the 6 into 5 + 1 is ours, methodology note M7: five from the Official
Report of the day, one from the day the session ended. **No Session 4 bill was
rejected at Stage 3, none fell for want of a financial resolution, and none is
still live**; those three values should not appear.

**8. Required cells.** Every column 0.

The second line is the cells the fact sheet does not fill, and they are empty on
purpose: **no_sp_bill_number 79**, has_a_procedure 0, has_a_title_as_introduced 0.
The Session 4 fact sheet prints an SP Bill number only for the seven bills that
did not become Acts, which is why 79 of the 86 have none; a smaller number here
means a bill number has been invented.

**9. Every Session 4 Act.** 79 enacted, 0 without an asp number, 0 without an
assent date, 0 where the asp number's year disagrees with the assent year. 79 is
the fact sheet's own Acts total.

**And 0 Acts anywhere on the clean sheet whose number has no year.** This is the
check `db/062` added after the Session 4 fact sheet turned out to print two Act
titles with no year in them, and the number short with it. A non-zero answer
means one got past the checker, and the title is the half that matters: it is
what the site displays.

**10. Stage records per bill.** passed 3 stages × 79; rejected at Stage 1
1 × 5; the withdrawn Inquiries into Deaths Bill 1, and the Footway Parking Bill
2. This is item 1's derivation seen per bill; the two must agree.

**11. Where every Session 4 stage date came from.** `phd` 158 (all dated),
`spice_factsheet_legislation` 79 (all dated), `official_report` 7 (1 undated),
`bill_page` 1 (undated), and nothing recorded as a stage that never happened.

- **158** is 79 bills × two stages, the 79 being every bill that reached Stage 3
  — which in Session 4 is every bill that passed, there being none rejected
  there. Counted in the dataset itself: of its 86 Session 4 rows, 85 carry a
  Stage 1 date and 79 a Stage 2 date. The six with a Stage 1 date and no Stage 2
  date are the five the Official Report already dates and the Footway Parking
  Bill, and nothing is written for any of them — the rule Sessions 1 and 2 set.
  The one row with no Stage 1 date at all is the withdrawn Inquiries into Deaths
  Bill.
- **79** is 74 passing dates and 5 Final Stage dates, off the fact sheet.
- **7** is the five Stage 1 decisions read in the Official Report, plus the
  Footway Parking Bill's two rows from `db/067` — its Stage 1, dated 1 March
  2016, and its undated Stage 2.
- **1** is the Inquiries into Deaths Bill's undated Stage 1, from the bill page.

Across the whole clean sheet: `phd` 522, `spice_factsheet_legislation` 260,
`official_report` 26 (3 undated), `bill_page` 20 (all undated), 2 recorded
as stages that never happened. Those four add to 828, which is item 1's total.

**12. Two accepted rows for the same stage.** 0, in every session, and the
listing that follows it returns nothing. Session 4's five Stage 1 dates come from
the Official Report, and **the dataset's five dates for the same bills agree with
it to the day** — Assisted Suicide 27 May 2015, Pentland Hills 26 January 2016,
Alcohol 4 February 2016, Transplantation 9 February 2016, Criminal Verdicts
25 February 2016, all checked in the dataset before this test was written. So
nothing should produce a second row, and a second row means the loader wrote the
dataset's date over the Official Report's even though the two agree.

**13. How each Stage 1 rejection came about.** `member_motion_disagreed` 15
bills, 0 with a note; `member_motion_amended_agreed` 2 bills, 2 with notes;
`committee_motion_9_14_18` 2 bills, 2 with notes. `other_route` should not
appear. 15 is Sessions 1 to 3's 11 plus Session 4's 4, none of which needs a
reader's note because all four went the ordinary way. The 2 is Session 2's one
plus the Transplantation Bill, which is item 20.

The listing that follows gives the five bills and the day each ended. Every one
must have `date_concluded` equal to its Stage 1 date and the source
`official_report`:

| Bill | Route | Ended |
|---|---|---|
| Assisted Suicide | `member_motion_disagreed` | 27 May 2015 |
| Pentland Hills Regional Park Boundary | `member_motion_disagreed` | 26 January 2016 |
| Alcohol (Licensing, Public Health and Criminal Justice) | `member_motion_disagreed` | 4 February 2016 |
| Transplantation (Authorisation of Removal of Organs etc.) | `member_motion_amended_agreed` | 9 February 2016 |
| Criminal Verdicts | `member_motion_disagreed` | 25 February 2016 |

**14. Every source on the list has a definition.** Nine sources, all true. Stage
records as item 11. `bill_rows` is `spice_factsheet_legislation` 302 and every
other source 0 — a bill's own line always comes from a legislation fact sheet.
Cells: `bill_page` 7, `legislation_gov_uk` 14, `manual` 2, `official_report` 40,
`spice_factsheet_dates` 23; `api`, `bill_document`, `phd` and
`spice_factsheet_legislation` 0. Those five add to 86, which is item 1.

**15. The notes a reader is given.** M1 to M8, eight of them, none empty. Their
lengths: M1 358, M2 5140, M3 1088, M4 971, M5 1940, M6 1605, M7 **5001** and
M8 2673. A length that has moved means somebody edited a note; find out who and
why before marking anything.

**M7 was 4361 when this test was written, and moved on 2026-09-14**, after the
test was run and before Session 4 was closed. `db/069` added a paragraph saying
that where a division decided how a bill was rejected its figures are given in
the note, and that a structured record of how members voted is not yet part of
this resource. That is the only edit; the other seven are as predicted. See
`DECISIONS.md`, 2026-09-14. **Session 4 brings no ending and no rejection route the
notes do not already cover**, so nothing here should have needed to move — which
is itself the check.

**16. Notes on the Session 4 staging lines.** 8 with a review note, 1 with a note
for readers, 85 the reader remarked on. The one reader's note is the
Transplantation Bill's, which is item 20. This item is also a prompt to read what
is written there before signing anything off.

The reader's own remarks, and how many lines carry each:

| The reader said | Lines |
|---|---|
| title is the Act title, not the title as introduced | 72 |
| the fact sheet says the bill fell and not why; outcome left for review | 6 |
| introduced as an Executive Bill; styled a Government Bill by the time it passed; … | 5 |
| a footnote marker was removed from the year 2014; title is the Act title, not the title as introduced | 1 |
| title is the Act title, not the title as introduced; the fact sheet prints no year before the asp number | 1 |

85, not 86. **The one line the reader said nothing about is the Inquiries into
Deaths Bill**, and that is the shape it should be: it is the only bill of the 86
that neither became an Act nor fell, so the reader had no Act title to remark on
and no unexplained ending to leave for review. It is also one of the two bills
that do not yet say where they ended. The six "fell and not why" lines are
exactly the fact sheet's Fallen table, which is item 7; the 72 are the Acts whose
title on the line is the Act's and not the bill's as introduced.

**17. Where the Parliament changed what it called its own bills.** Government
bills by session and by how the type was styled at the time: Session 1
`executive` 51; Session 2 `executive` 53; Session 3 `executive` 44; Session 4
`executive` 15 **and `government` 52**.

**Session 4 is the first session in which any bill is styled `government`, and
the first in which the styling changes inside the session.** Everything before it
is Executive throughout. This is what `bill_type_stated` exists for and what M4
explains: `bill_type` stays `government` for all 67 so that a count of government
bills runs continuously across the changeover, and the contemporaneous styling is
kept rather than lost. A Session 4 answer of 67 `executive` and 0 `government`
means the styling has been flattened.

The listing that follows gives the five bills the fact sheet footnotes as
"Introduced as an Executive Bill (E)" — introduced as Executive, passed as
Government — every one `G*` in the fact sheet's own type column and `executive`
here:

| Bill | Introduced |
|---|---|
| Social Care (Self-directed Support) (Scotland) Act 2013 | 29 February 2012 |
| Local Government Finance (Unoccupied Properties etc.) (Scotland) Act 2012 | 26 March 2012 |
| Scottish Civil Justice Council and Criminal Legal Assistance Act 2013 | 2 May 2012 |
| Freedom of Information (Amendment) (Scotland) Act 2013 | 30 May 2012 |
| Water Resources (Scotland) Act 2013 | 27 June 2012 |

The other ten `executive` bills are typed plainly `E` and carry no footnote. The
two labels overlap in time rather than changing on a day — the last plain `E` was
introduced on 22 March 2012, after the first `G*` on 29 February — so do not
expect a clean boundary, and do not go looking for one.

**18. Every bill that did not pass says where it ended.** 0. **This is the item
the two endings above have to be recorded for**, and it will read 2 if they are
not.

The listing that follows shows the seven Session 4 bills that did not pass. Five
name Stage 1, dated from the Official Report, each date equal to the bill's
`date_concluded` as item 13 sets out. The other two are undated, because neither
ended on a decision of the Parliament: the Inquiries into Deaths Bill names
**Stage 1**, which it never completed, and the Footway Parking Bill names
**Stage 2**, which it never reached.

**19. Every stage date held for a Session 4 bill that did not pass.** Five rows
for the five rejected at Stage 1, each at stage_order 1, `completed` false,
`fell_here` true, dated as item 13, and **every one of the five must say
`official_report`**. If any says `phd`, the dataset's date has been carried in
place of the Official Report's and this item fails — even though all five agree
to the day, because what is being checked is that the load left the more primary
source in place.

Then the three rows the two endings add. **The Footway Parking Bill is the one to
look at**: the dataset dates its Stage 1 at 1 March 2016 and, until `db/067`,
nothing else on the sheet dated that stage. Its Stage 1 must read `completed`
true, `fell_here` false, dated 2016-03-01, and **`official_report`, not `phd`** —
the dataset agrees to the day, and this checks that the load left the more
primary source in place. Its Stage 2 and the Inquiries into Deaths Bill's Stage 1
are both undated, `completed` false, `fell_here` true.

**20. The Transplantation Bill's motion as amended, kept in full.** One row.
characters **1448**, and all four of `keeps_the_resolution`,
`names_the_amendment`, `gives_the_amendment_division` and
`gives_the_motion_division` true.

**Corrected on 2026-09-14, after the test was run.** As written, this item
expected 1376 characters and a `quotes_the_division` that looked in the note for
the Official Report's own phrase, "as amended, agreed to". It came back false,
and the note had never contained that phrase: it says the same thing the other
way round, "agreed to as amended". So the check tested a wording rather than a
fact, and it was the only one of the twenty-seven to fail.

Answering it turned up something real, though. The division figures were in the
database — they are recorded against every one of the nineteen Stage 1
rejections, in the Official Report's own words — but not in the text a reader
sees. **The owner settled on 2026-09-14 that both divisions are published**, and
`db/069` put them on the two bills rejected by this route, which took this note
from 1376 characters to 1448. The check now looks for the two divisions
themselves, which are facts read from the Official Report rather than a form of
words, so it cannot fail again for the same reason. See `DECISIONS.md`,
2026-09-14.

The member in charge's own motion S4M-15128 was amended by S4M-15128.1 into a
motion that did not agree to the general principles, and then agreed to as
amended on 9 February 2016. The resolution is the whole difference between this
route and the ordinary one — the Parliament declined the general principles *and*
resolved what should happen instead — so it is published beside the bill, quoted
and not summarised. A shorter note means the quotation has been trimmed; a note
that no longer mentions a soft opt-out means it has been paraphrased. See
`DECISIONS.md`, 2026-09-13, and `db/064`.

**21. A Private Bill's stages are recorded under a Private Bill's names.**

| Bill type | 1 | 2 | 3 |
|---|---|---|---|
| government | stage_1 67 | stage_2 67 | stage_3 67 |
| committee | stage_1 1 | stage_2 1 | stage_3 1 |
| members | stage_1 13 | stage_2 7 | stage_3 6 |
| private | preliminary 5 | consideration 5 | final 5 |

The members' 13 at position 1 is 6 bills that passed, 5 rejected at Stage 1, and
the two endings of `db/067`; the 7 at position 2 is the 6 that passed plus the
Footway Parking Bill's undated Stage 2. **Session 4 has five Private Bills, more
than any session so far**, and a Private Bill's stages are Preliminary,
Consideration and Final — never Stage 1, 2 and 3. `stage_1` appearing against
`private` means the loader has used the public names, and the comparison of a
Private Bill's Consideration Stage with an ordinary bill's Stage 2 then rests on
a claim the database is supposed to refuse.

### Then, outside the script

**22. The data dictionary is still true.**
`python3 tools/make_data_dictionary.py` produces no difference from the committed
file beyond its own date line. Session 4 should need no new column; if it has one,
the script refuses to run unless it carries a `COMMENT`, and the dictionary then
differs and must be committed with the migration that made it.

**23. The reader still reproduces what was loaded.** Extract the Session 4 fact
sheet afresh and compare against the staging lines' raw columns: 86 rows,
0 differing.

    extract_factsheet.py <pdf> --session 4 --csv out.csv

**Nothing may be supplied to the reader but the PDF and the session number.**
That is what this item is for.

**The worked-out columns that must differ, and only these** — nine cells across
eight bills:

- `outcome` on all six bills the fact sheet's Fallen table holds, because since
  `db/051` the reader decides none of them. Five read in the Official Report:
  Alcohol (Licensing, Public Health and Criminal Justice), Assisted Suicide,
  Criminal Verdicts, Pentland Hills Regional Park Boundary, Transplantation
  (Authorisation of Removal of Organs etc.). One worked out after the reading
  from the day the session ended: Footway Parking and Double Parking.
- `date_royal_assent` on one, corrected against legislation.gov.uk: Land Reform.
- `short_title` and `asp_number` on one, which the fact sheet prints with no year
  in the title and so no year in the number: Higher Education Governance.

`outcome` must **not** differ on the Inquiries into Deaths Bill. The reader reads
the Withdrawn table and codes it itself.

`date_introduced` must **not** differ on the National Galleries of Scotland Act.
That disagreement was with the dataset, not with the fact sheet, and the fact
sheet's 25 June 2015 is what stands; a difference here means the wrong source won.

`bill_type` must **not** differ, on any of the 86. The reader produces no
`stage_1_rejection_route`, `bill_note` or `official_report_read_on` at all, so
those are not comparisons.

**Also check the dissolution rule afresh**, as Sessions 1, 2 and 3 do: of the six
fallen bills in the fresh reading, exactly the one concluding on Session 4's last
day of **23 March 2016** is the one coded `fell_dissolution`, none over and none
missing. That is what makes the sixth difference a rule being applied rather than
a coding nobody can reproduce.

This session did not run this. The list above is a prediction from what was
changed after the load; a difference that is not on it is something to
investigate, not to wave through.

**24. The dataset's fingerprint** is sha256
`a9596ecf997f186b0dd9d069642560f65120ab7ca97d0a2387863d0157ed8b94` — **unchanged
from Session 3's item 22, and Session 4 did not move it.** Both of Session 4's
disagreements were settled without editing the workbook: the Land Reform Act's
Royal Assent because the dataset was right and the fact sheet wrong, and the
National Galleries Act's introduction date because the fact sheet was right, which
is recorded on the staging line with source `manual` rather than by correcting the
file. The eight Session 4 names that differ from the fact sheet's are paired by
hand in `tools/phd_stage_dates.py` — the four Budget Acts, which the dataset
numbers within the session, and four wording slips — not corrected either.

**This is the one item a later session can move.** Adjudicating a disagreement for
Session 5 or beyond corrects the file and the fingerprint changes with it. Record
the new one beside the old; nothing else about Session 4 is reopened by it.

**Moved once since this was written, by Part B item 7 rather than by a later
session.** On 2026-09-14 the owner ruled that the working file is corrected
whenever it is found to be wrong, the original dataset behind the 2021 thesis
being held separately for posterity, and the National Galleries introduction date
was corrected in it from 26 to 25 June 2015. The fingerprint is now
`6614b3a1871367284c452ff8564b213532c1ec786f344acb7d350131c135420f`; it was
`a9596ecf…57ed8b94` when this test was marked. The eight paired names are still
paired and not corrected, and the Land Reform Act's Royal Assent still stands as
the dataset always had it. Checked against a copy taken before the change:
exactly one cell differs on the data sheet -- D294 -- and seventeen on the
Corrections sheet, being the new note, its header row and its one entry.
`tools/phd_stage_dates.py` gives byte-identical output from the file before and
after, checksum `47fe0846…be1b3384`, so none of the 522 stage dates the clean
sheet holds from the dataset is affected, and `tools/compare_sources.py` now
finds all 73, 81, 62 and 86 lines paired with no difference in any of the four
sessions. Item 24 passes on the new fingerprint; no other item is reopened.

**25. Promotion is still reversible.** Take Session 4 off and put it back inside a
transaction that is thrown away, and the result is identical. The procedure is in
`docs/PROMOTION-RUNBOOK.md`. Session 4 is the largest session yet at 86 bills, the
first with five Private Bills in it, and the first whose promotion writes a
provenance note for a bracketed value, so this is not a formality.

**26. Every period is counted, or has a stated reason.** `tools/duration_coverage.sql`
runs clean: **1065 counted**, and not counted 21 plus whatever points the two
endings add — 19 of the 21 being stages that never reached their terminal point
and 2 stages that never happened, all of them from Sessions 1 to 3. No third
category; the script stops if one appears.

**Corrected on 2026-09-14, after the test was run: 1065, not 1064.** As written,
this item said 1064 is 743 plus Session 4's 321 — 79 bills passed, each counted
at four points (introduction to the first stage, then each stage to the next,
then the last stage to Royal Assent) = 316, and 5 bills rejected at Stage 1
counted from introduction to that decision = 5. **Session 4 has six non-passing
bills with a dated Stage 1, not five.** The Footway Parking Bill completed Stage
1 on 1 March 2016, three weeks before the session ended, so introduction to that
stage is a real period of 286 days and is counted. That is the very thing the
session before this one established, and the derivation was written without it.
Session 4's figure is 322 and the total 1065; Sessions 1 to 3's 743 is unmoved.
The per-stage table should read:

| Counted to | Periods |
|---|---|
| introduction → stage_1 | 266 |
| introduction → preliminary | 17 |
| introduction → final | 1 |
| stage_1 → stage_2 | 244 |
| preliminary → consideration | 17 |
| stage_2 → stage_3 | 244 |
| consideration → final | 16 |
| stage_3 → royal_assent | 243 |
| final → royal_assent | 17 |

**27. The repository is clean** and level with GitHub, and the migrations are
numbered without a gap.

### Part B — the owner's sign-off

None of these is for anyone else to answer. A sign-off is recorded here on the
day it is given, and nowhere else.

1. **What happened to each bill.** The counts in items 6 and 7 are what you
   expect for Session 4: the reconciliation against page 9 of the fact sheet in
   every cell and both margins, and the split of its six fallen bills into five
   rejected at Stage 1 and one that ran out of time. **Given 2026-09-14**, on
   the twelve cells and both margins read back beside page 9, and on the six
   named bills split five rejected at Stage 1 -- Assisted Suicide, Pentland
   Hills, Alcohol, Transplantation and Criminal Verdicts -- and one out of time
   at dissolution, the Footway Parking and Double Parking Bill.
2. **The five bills read in the Official Report.** For each, the quotation on the
   line and the ending recorded against it: Alcohol, Assisted Suicide, Criminal
   Verdicts and Pentland Hills rejected at Stage 1 on the member's own motion put
   and disagreed to; Transplantation rejected on that motion amended and agreed
   to. You predicted the fifth from the shape of the record before it was read;
   the sign-off is on the record as it was found, not on the prediction.
   **Given 2026-09-14**, on the five lines read out in the source's own words
   beside the ending recorded against each, including that the Criminal Verdicts
   motion is the one of the five the page names no member for, and that the
   Transplantation line's route quotes the division on the amendment, being what
   the route records, with both divisions on the line recording the outcome.
3. **The Transplantation Bill's motion as amended, read in full** as it will be
   published beside the bill, and that quoting the resolution — a soft opt-out
   system, a consultation, legislation next session if appropriate — is what you
   want a reader to see beside a bill counted as rejected at Stage 1.
   **Given 2026-09-14**, on the published note read out in full as it stands
   after `db/069`, with both divisions in it and the motion as amended quoted
   entire.
4. **The two endings you establish** for the Inquiries into Deaths Bill and the
   Footway Parking and Double Parking Bill, checked against the clean sheet
   rather than against the note of them, including whether the Footway Parking
   Bill's Stage 1 of 1 March 2016 is recorded and from what.
   **Given 2026-09-14**, on both endings read off the clean sheet: the Inquiries
   into Deaths Bill withdrawn on 24 September 2015 with one stage row, undated,
   marked where the bill ended; and the Footway Parking Bill's Stage 1 recorded
   as completed on 1 March 2016 from the Official Report of that day, ending at
   an undated Stage 2, against the Parliament's current bill page labelling it
   fallen at Stage 1.
5. **The two adjudicated dates and the two cells the fact sheet prints short**,
   and that the corrections are the ones you intended: the Land Reform Act's
   Royal Assent settled your dataset's way against legislation.gov.uk; the
   National Galleries Act's introduction date settled the fact sheet's way on
   your own record; and the Higher Education Governance Act's title and number,
   which the fact sheet prints with no year, taken from legislation.gov.uk — each
   with its source, its place in that source, the value in the source's own words
   and the day it was read, and the fact sheet's printed words left untouched
   beside them. **Given 2026-09-14**, on all four cells read out beside the fact
   sheet's own printed words: the Land Reform Act's Royal Assent of 22 April 2016
   against the fact sheet's 22 March; the National Galleries Act's introduction
   of 25 June 2015 against the dataset's 26 June; and the Higher Education
   Governance Act's title and number given their year, which the fact sheet
   prints without.
6. **The eight names paired by hand**, checked against the fact sheet and your
   dataset side by side: the four Budget Acts, which your dataset numbers within
   the session where the fact sheet gives the Act's short title, and the four
   wording slips. Every one agrees on both dates the two sources share.
   **Given 2026-09-14**, on the eight pairs read out side by side with the dates
   each shares -- the four Budget Acts and the four slips, Freedom of Information,
   Inquiries into Fatal Accidents, Land and Buildings Transaction Tax and
   Pentland Hills, the last sharing only its introduction date, having never
   become an Act.
7. **Whether the National Galleries introduction date should be corrected in your
   workbook.** Session 3's equivalent — the Autism Bill's Stage 1 date — was
   corrected in the file and the fingerprint moved with it. This one was settled
   on the staging line instead and the file left alone, so the dataset still says
   26 June 2015 where the database says 25 June. Either is defensible; they should
   not be decided differently by accident. Your call, and item 24 moves if you
   correct it. **Given 2026-09-14: corrected.** The owner ruled that this file is
   the live working copy and is corrected whenever it is found to be wrong, the
   original dataset behind the 2021 thesis being held separately for posterity.
   So Session 3's handling is the rule and Session 4 now follows it. The cell was
   changed from 26 to 25 June 2015, the Corrections sheet carries the change with
   its reason and what it was checked against, and item 24 carries the new
   fingerprint.
8. **The Parliament's own styling changing inside Session 4**: 15 government
   bills recorded as introduced when they were styled Executive Bills and 52 as
   Government Bills, against 67 counted as government throughout — and that M1
   says what you want said to a reader who notices. (**This item named M4 when it
   was written, which is the Hybrid Bill note and the wrong one; the note that
   covers the styling change is M1. Corrected on 2026-09-14 while the item was
   being marked, and the correction put to the owner rather than made silently.**)
   **Given 2026-09-14**, on the split read off the clean sheet -- 15 styled
   Executive, introduced between 16 June 2011 and 27 June 2012, and 52 styled
   Government, between 3 October 2012 and 28 January 2016, a clean break with no
   overlap -- and on M1's wording read out in full.
9. **That you can explain how this database works** from the documents alone,
   without help. The standing requirement, put again because Session 4 is the
   largest session so far and the first whose bills carry two different
   contemporaneous labels. Check `docs/HOW-THE-DATABASE-WORKS.md` is current
   before reading it: its counts still say 216 bills and 71 provenance notes, and
   the session that promotes Session 4 has to bring them to 302 and 86.
   **Given 2026-09-14.** The document was checked first and found level with the
   database at 302 and 86, but with one thing missing and one thing wrong, both
   put right before it was read: it never said where the note a reader sees lives
   on the clean sheet, which is where the two published divisions went, and M7
   still said the coding of why a bill fell had been done for three sessions when
   Session 4 made it four (`db/070`).

### Part C — what this test does not check

- **Whether the Session 4 dates nobody has checked are right.** 78 of the 79
  Royal Assent dates and 85 of the 86 introduction dates have never been checked
  against legislation.gov.uk or the Parliament's pages. The dataset agrees with
  every one of them, which is corroboration and not verification; M8 says which a
  reader has.
- **Whether the 158 Stage 1 and Stage 2 dates are right.** They rest on the
  dataset alone, and nothing has been compared against them.
- **Whether the Official Report was read correctly beyond the words quoted.**
  Nobody has read the surrounding debate for any of the five.
- **The wording of the amendment that defeated the Transplantation Bill.**
  S4M-15128.1 is named but not printed; the page the division was read on gives
  the question the Presiding Officer put and the two results, and not the
  amendment's own text.
- **Whether the Official Report and the bill page are right** about the two
  endings. The Footway Parking Bill in particular is recorded against the
  Official Report and *against* the current bill page's own label, which says it
  fell at Stage 1; the reasoning is in the section above, and a reader who thinks
  the label means what it says would code that bill differently.
- **Bills carried over between sessions.** Four bills appear in two fact sheets,
  and the double-count guard is not built. Nothing in Session 4 trips it —
  `STATE.md` has it due before Session 6 is loaded — so this test does not
  exercise it, and passing says nothing about it. No Session 4 bill appears in
  the Session 5 fact sheet under the same title, the Footway Parking Bill
  included, which was checked rather than assumed.
- **Anything about Sessions 5 to 7**, including the prose reader and the three
  bills Session 5's fact sheet lists as passed with no Royal Assent yet.

---

## Session 3

Written 2026-09-13 by the session that reviewed it and coded the nine bills that
did not pass.

**Run on 2026-09-13** by a session that did none of the work it tests: it did
not promote Session 3, did not load or admit the stage dates, and did not make
the change at `db/060`. **All twenty-four mechanical items pass.** Twenty-one
matched the expected answer as written. Three did not, and in all three the
data was right and the expected answer was wrong; each is corrected below with
the reason beside it, and the corrections are the only change made to this
test.

- **Item 15**, M2's length. Written against `db/055` as 3661; `db/060` amended
  M2 deliberately and it is 4347. The prediction went stale.
- **Item 19**, the Stage 1 dates of bills that did not pass. Five rows, not
  four. The fifth is the Budget (Scotland) (No.2) Bill's Stage 1 from the
  dataset, which this test's own item 11 predicts. The four the Official Report
  dates all say `official_report`, which is what the item checks.
- **Item 21**, the reader. 62 rows and not one of the fact sheet's own words
  differs, with nothing supplied but the PDF and the session number. Ten
  worked-out cells differ, not eight: the two extra are the bills that fell at
  dissolution, which `db/051` stopped the reader deciding. Applying the
  dissolution rule afresh to that reading returns exactly those two, none over
  and none missing.

Item 23 was rehearsed inside a transaction that was thrown away: 62 bills, 170
stage records and 15 provenance notes off, the same back on, and no unexpected
difference anywhere on either sheet. The working copy was compared and dropped.

`tools/duration_coverage.sql` was run in the same session and passes: of 764
points where a period could be counted, 743 are counted, 19 have no day because
the stage never reached its terminal point, and 2 did not happen. No third
category.

**Part B is marked. All nine sign-offs were given on 2026-09-13**, across two
sessions of that day: 1, 2, 3 and 7 in the first, and 4, 5, 6, 8 and 9 in the
second. Each is recorded against its own item with what it was given on.

**Session 3 is therefore closed.**

**When to run it.** When Session 3 is on the clean sheet *and* its Stage 1 and
Stage 2 dates are loaded. Closure means the session is finished, and Session 3
is not finished until its dates are in; run before that and the counts are of a
session half admitted.

**What that means for the two pieces of work still to come.** Promotion and the
stage-date load have not happened yet, so every expected answer below about them
is a prediction made from the fact sheet, the dataset and the rules — not a
description of a database anyone has looked at. That is deliberate. It makes
this test the independent check on the session that extends
`tools/phd_stage_dates.py` and runs the promotion, neither of which wrote it.

**The one item an outside change can move** is item 22, the dataset's
fingerprint. Nothing else here is reopened by later work.

**What this test does not put again.** Sessions 1 and 2 and their corrections
are settled; where an answer below covers the whole database it is because
Session 3 moves it, and the Sessions 1 and 2 part of it is taken from their own
test rather than re-derived.

### Part A — mechanical

Run `tools/closure_check_session_3.sql`. It reads only and changes nothing.
Compare each numbered result against the expected answer.

**1. Counts.** bills 216, stage_records 583, provenance_notes 71,
checker_problems 0, gaps 0, staging_lines 216, stage_date_rows 583.

- 216 is 154 plus the Session 3 fact sheet's own total of 62.
- 583 is 413 plus Session 3's 170, and the 170 should be checked as a
  derivation: 53 bills passed × 3 stages = 159; the Budget (Scotland) (No.2)
  Bill was rejected at Stage 3, so it has all three = 3; the Creative Scotland
  Bill completed Stage 1 and then fell = 1; the 3 rejected at Stage 1, the 2
  withdrawn and the 2 that fell at dissolution have one each = 7.
  159 + 3 + 1 + 7 = 170.
- 71 is 56 plus 15: 5 outcomes read from the Official Report, 3 Stage 1 routes
  from the same, 2 bills coded as having fallen at dissolution, and 5 cells
  checked at review against the source that owns them — two Royal Assent dates
  and one asp number at legislation.gov.uk, one introduction date and one bill
  type at the Parliament's bill pages.
- 0 and 0 are the rule. The 108 gaps that stood open on 13 September are the
  Stage 1 and Stage 2 dates this load supplies; a gap left after it is a
  question about a bill.

**2. Every staging line reviewed, admitted, on the clean sheet and compared.**
Session 1: 73 accepted, 73 promoted, 73 compared. Session 2: 81, 81, 81.
Session 3: 62, 62, 62. No other review status appears. From the fact sheets'
totals and the rule that nothing reaches the clean sheet unaccepted.

**3. Every stage-date row.** Session 1: 200 accepted, 200 carried. Session 2:
213, 213. Session 3: 170, 170. No other status. Session 3's 170 is item 1's
derivation: 62 rows already on the sheet, plus the 108 this load adds.

**4. A recorded difference with no adjudication.** 0. Session 3 recorded three
and all three were settled on 12 September.

**5. What has been checked against the source that owns it.**

| Field | Source | Cells |
|---|---|---|
| `asp_number` | `legislation_gov_uk` | 1 |
| `bill_type` | `bill_page` | 1 |
| `date_completed` | `bill_page` | 1 |
| `date_first_meeting` | `spice_factsheet_dates` | 7 |
| `date_introduced` | `bill_page` | 5 |
| `date_royal_assent` | `legislation_gov_uk` | 10 |
| `date_session_end` | `spice_factsheet_dates` | 6 |
| `outcome` | `official_report` | 16 |
| `outcome` | `spice_factsheet_dates` | 9 |
| `short_title` | `manual` | 1 |
| `stage_1_rejection_route` | `official_report` | 14 |

Sessions 1 and 2 account for 56 of these. Session 3 adds fifteen: the Forced
Marriage etc. Act's asp number, which its fact sheet omits; the Forth Crossing
Act's type; the Criminal Procedure Act's introduction date; the Double Jeopardy
and Forced Marriage etc. Acts' Royal Assent dates; five outcomes from the
Official Report; two from the dates fact sheet, being the bills coded as having
fallen at dissolution; and three Stage 1 routes.

**6. Reconciliation.** Our counts must match the fact sheet's own summary table
in every cell and both margins. These figures are read off page 8 of the Session
3 fact sheet, not out of the database:

| Session 3 | Executive | Member's | Private | Committee | Total |
|---|---|---|---|---|---|
| Acts | 42 | 7 | 2 | 2 | 53 |
| Withdrawn | 0 | 2 | 0 | 0 | 2 |
| Fallen | 3 | 4 | 0 | 0 | 7 |
| **Total** | **45** | **13** | **2** | **2** | **62** |

The script's rows are `acts`, `fallen` and `withdrawn`, and its
`government_or_hybrid` column answers the fact sheet's "Executive".

**On `bill_type` alone**: government 44, hybrid 1, members 13, private 2,
committee 2. This is where Session 3 differs from every session before it. The
fact sheet's summary has no Hybrid column and counts the Forth Crossing Act
under Executive, so its 45 is our 44 plus 1, and its Acts row of 42 is our 41
plus 1. That is methodology note M4, and it is why the reconciliation is done on
`analysis_group`.

**7. Outcomes.** 53 passed and enacted; 3 rejected at Stage 1; 1 rejected at
Stage 3; 2 withdrawn; 2 fell at dissolution; 1 fell because its financial
resolution was not agreed. Every non-passing bill is `not_enacted`.

The fact sheet gives the row totals only — 53 Acts, 2 withdrawn, 7 fallen.
Splitting the 7 into 3 + 1 + 2 + 1 is ours, methodology note M7: five from the
Official Report of the day, two from the day the session ended.

**8. Required cells.** Every column 0.

**9. Every Session 3 Act.** 53 enacted, 0 without an asp number, 0 without an
assent date, 0 where the asp number's year disagrees with the assent year. 53 is
the fact sheet's own Acts total.

**10. Stage records per bill.** passed 3 stages × 53; rejected at Stage 3
3 × 1; rejected at Stage 1 1 × 3; withdrawn 1 × 2; fell at dissolution 1 × 2;
fell for want of a financial resolution 1 × 1. This is item 1's derivation seen
per bill; the two must agree.

**11. Where every Session 3 stage date came from.** `phd` 108 (all dated),
`spice_factsheet_legislation` 53 (all dated), `official_report` 5 (all dated),
`bill_page` 4 (all undated), and nothing recorded as a stage that never
happened.

- **108** is 54 bills × Stage 1 and Stage 2. The 54 is the 53 that passed plus
  the Budget (Scotland) (No.2) Bill, which reached Stage 3. Counted in the
  dataset itself rather than in the database: of its 62 Session 3 rows, 58 carry
  a Stage 1 date and 54 a Stage 2 date. The four with a Stage 1 date and no
  Stage 2 date are bills the Official Report already dates, and nothing is
  written for them — the rule Sessions 1 and 2 set.
- **53** is each Act's passing date, off the fact sheet.
- **5** is the four Stage 1 decisions and the one Stage 3 decision read in the
  Official Report.
- **4** is the bills whose ending the owner established from the Parliament's
  bill pages. None is dated, because none ended on a decision of the Parliament.

Across the whole clean sheet: `phd` 364, `spice_factsheet_legislation` 181,
`official_report` 19 (2 undated), `bill_page` 19 (all undated), 2 recorded as
stages that never happened.

**12. Two accepted rows for the same stage.** 0, in every session, and the
listing that follows it returns nothing. A non-zero answer for Session 3 means
the loader wrote a second Stage 1 row for one of the four bills the Official
Report already dates. That is not automatically wrong — the precedence rule
exists for it, and since the Autism correction all four agree to the day — but
item 19 then has to say `official_report` for every one of them, and the
duplicate rows want an explanation.

**13. How each Stage 1 rejection came about.** `member_motion_disagreed` 11
bills, 0 with a note; `member_motion_amended_agreed` 1 bill, 1 with a note;
`committee_motion_9_14_18` 2 bills, 2 with notes. `other_route` should not
appear. 11 is Sessions 1 and 2's 8 plus Session 3's 3, all three of which went
the ordinary way and so add no reader's note.

**14. Every source on the list has a definition.** Nine sources, all true. Stage
records as item 11. `bill_rows` is `spice_factsheet_legislation` 216 and every
other source 0 — a bill's own line always comes from a legislation fact sheet.
Cells: `bill_page` 7, `legislation_gov_uk` 11, `official_report` 30,
`spice_factsheet_dates` 22, `manual` 1; `api`, `bill_document`, `phd` and
`spice_factsheet_legislation` 0.

**15. The notes a reader is given.** M1 to M8, eight of them, none empty, and
M7 the only one that mentions a financial resolution. Their lengths: M1 358,
M2 4347, M3 1088, M4 971, M5 1940, M6 1605, M7 4361, M8 2673. A length that has
moved means somebody edited a note; find out who and why before marking
anything.

**Corrected on 2026-09-13 by the session that ran this test.** The figures were
written against `db/055` and M2 was given as 3661. `db/060` then amended M2
deliberately, to say that a stage is counted where the Parliament took the
decision that ends it whatever it decided, and the test was not brought forward
with it. M2 is 4347 characters and the other seven have not moved. The check
itself stands: a length that moves still means a note was edited.

**Corrected again on 2026-09-13, later the same day.** `db/061` amended M2 a
second time, to say what the general note on a stage row is and what an empty
detail note means. M2 is 5140 characters and the other seven have not moved.

**M7 moved on 2026-09-14**, after Session 3 was closed: `db/069` added a
paragraph about the division figures now published beside a bill rejected at
Stage 1 by an unusual route. M7 is 5001 characters and the other six are as
above. Nothing about Session 3's own data is reopened by it.

**16. Notes on the Session 3 staging lines.** 9 with a review note, 1 with a
note for readers, 60 the reader remarked on. The one reader's note is the Forth
Crossing Act's. This item is also a prompt to read what is written there before
signing anything off.

**17. The bill that did not end at a stage.** One row: the Creative Scotland
Bill, `fell_financial_resolution_not_agreed`, concluded 18 June 2008, 1 stage
record, 1 completed stage, **0 stages it fell at**. The zero is the whole point
of the new ending: the Parliament agreed the bill's general principles, and it
fell afterwards on a vote that is not part of any stage.

**18. Every bill that did not pass says where it ended.** 0.

The listing that follows shows the nine Session 3 bills that did not pass. Eight
name a stage; the Creative Scotland Bill's stage columns are empty, which is
item 17. Of the eight, four are dated — Autism `stage_1` 12 January 2011, End of
Life Assistance `stage_1` 1 December 2010, Protection of Workers `stage_1` 22
December 2010, Budget (No.2) `stage_3` 28 January 2009, every one
`official_report` — and four are undated: the two withdrawn bills and the two
that fell at dissolution, none of which ended on a decision of the Parliament.

**19. The Stage 1 dates held for a Session 3 bill that did not pass.** Five
rows. Four are the ones the Official Report dates, and **every one of those four
must say `official_report`**: Autism 12 January 2011, Creative Scotland
18 June 2008, End of Life Assistance 1 December 2010, Protection of Workers
22 December 2010. If any says `phd`, the dataset's date has been carried in
place of the Official Report's and this item fails.

The fifth is the Budget (Scotland) (No.2) Bill, Stage 1 on 14 January 2009, and
it must say `phd`. The Official Report gives that bill its Stage 3, not its
Stage 1; its Stage 1 and Stage 2 come from the dataset like every other bill
that reached Stage 3.

**Corrected on 2026-09-13 by the session that ran this test.** The item was
written expecting four rows and the query it is written against returns every
Session 3 bill that did not pass and has a dated Stage 1, which is five. The
fifth was predicted by this test's own item 11 — the 108 dates are 54 bills'
worth, being the 53 that passed plus the Budget Bill — and the omission was in
the expected answer, not in what was loaded.

It mattered for one of them, and no longer does. The dataset dated the Autism
Bill's Stage 1 at 17 January 2011 against the Official Report's 12 January; the
owner settled it on 13 September and the dataset is corrected. All four now
agree with the Official Report to the day, so this item is checking that the
load left the more primary source in place, not adjudicating anything.

### Then, outside the script

**20. The data dictionary is still true.**
`python3 tools/make_data_dictionary.py` produces no difference from the
committed file beyond its own date line.

**21. The reader still reproduces what was loaded.** Extract the Session 3 fact
sheet afresh and compare against the staging lines' raw columns: 62 rows, 0
differing.

    extract_factsheet.py <pdf> --session 3 --csv out.csv

**Nothing may be supplied to the reader but the PDF and the session number.**
That is what this item is for.

**The worked-out columns that must differ, and only these** — ten cells across
nine bills:

- `outcome` on all seven bills the fact sheet's Fallen table holds, because
  since `db/051` the reader decides none of them. Five the fact sheet does not
  explain, and which were read in the Official Report: Autism, Budget (Scotland)
  (No.2), Creative Scotland, End of Life Assistance, Protection of Workers. Two
  that ran out of time, which are worked out after the reading from the day the
  session ended: Commissioner for Victims and Witnesses, and Long Leases.
- `date_royal_assent` on two, corrected against legislation.gov.uk: Double
  Jeopardy and Forced Marriage etc.
- `asp_number` on one, which the fact sheet omits: Forced Marriage etc.

`outcome` must **not** differ on the two withdrawn bills. The reader reads the
Withdrawn table and codes them itself.

**Also check the dissolution rule afresh**, as Sessions 1 and 2's item 18 does:
of the seven fallen bills in the fresh reading, exactly those concluding on
Session 3's last day of 22 March 2011 are the ones coded `fell_dissolution`,
none over and none missing. That is what makes the two extra differences a
rule being applied rather than a coding nobody can reproduce.

**Corrected on 2026-09-13 by the session that ran this test.** The item was
written listing eight cells across seven bills, from what was changed after the
load, and missed the two bills that fell at dissolution: `db/051` took that
decision away from the reader precisely so that it would be reproducible from
the session's last day, so their outcomes were always going to differ from a
fresh reading. Sessions 1 and 2's test records the same behaviour for all
eighteen of their fallen bills. The omission was in the expected answer.

`bill_type` must **not** differ. The fact sheet's own table types the Forth
Crossing Act H, and the owner's reading of the bill page agreed with it; only
the summary page disagrees, and the reader does not read the summary page. The
reader produces no `stage_1_rejection_route`, `bill_note` or
`official_report_read_on` at all, so those are not comparisons.

This session did not run this. The list above is a prediction from what was
changed after the load; a difference that is not on it is something to
investigate, not to wave through.

**22. The dataset's fingerprint** is sha256
`a9596ecf997f186b0dd9d069642560f65120ab7ca97d0a2387863d0157ed8b94`, recorded in
`DECISIONS.md`, 2026-09-13, after the Autism Stage 1 date. It was
`e04dc540…c38ea75` when this test was first drafted, and moved the same day.
**This is the one item a later session can move.** Adjudicating a disagreement
for Session 4 or beyond corrects the file and the fingerprint changes with it.
Record the new one beside the old; nothing else about Session 3 is reopened by
it.

**Moved on 2026-09-14**, after the National Galleries introduction date was
corrected while Session 4's Part B was marked, to
`6614b3a1871367284c452ff8564b213532c1ec786f344acb7d350131c135420f`.
`tools/phd_stage_dates.py` gives byte-identical output from the file before and
after, so Session 3's stage dates are untouched. Item 22 passes on the new
fingerprint; no other item about Session 3 is reopened.

**23. Promotion is still reversible.** Take Session 3 off and put it back inside
a transaction that is thrown away, and the result is identical. The procedure is
in `docs/PROMOTION-RUNBOOK.md`. Session 3 is the first session promoted with a
Hybrid Bill in it and the first with two of the endings, so this is not a
formality.

**24. The repository is clean** and level with GitHub, and the migrations are
numbered without a gap.

### Part B — the owner's sign-off

None of these is for anyone else to answer. A sign-off is recorded here on the
day it is given, and nowhere else.

1. **What happened to each bill.** The counts in items 6 and 7 are what you
   expect for Session 3. **Given 2026-09-13**, on the reconciliation against
   page 8 of the fact sheet: every cell and both margins are the fact sheet's
   own, and the two places we hold more than it does are the Forth Crossing
   Bill's type, which it files under Executive, and the split of its seven
   fallen bills by why they fell. Neither disagrees with it.
2. **The five bills read in the Official Report.** For each, the quotation on
   the line and the ending recorded against it: Autism, End of Life Assistance
   and Protection of Workers rejected at Stage 1 on the member's own motion;
   Budget (Scotland) (No.2) rejected at Stage 3 on the Presiding Officer's
   casting vote; Creative Scotland fallen for want of a financial resolution
   with its general principles agreed. **Given 2026-09-13**, on the five lines
   read out in the source's own words beside the ending recorded against each,
   including that the Creative Scotland Bill's Stage 1 is completed and no stage
   is marked as where the bill ended, there being none to put it on.
3. **The four endings you established from the Parliament's bill pages** — the
   two withdrawn bills and the two that fell at dissolution — checked against
   the clean sheet rather than against the note of them, including that none
   carries a date. **Given 2026-09-13**, on the four endings read off the clean
   sheet, on the day each bill stopped being live being recorded while the Stage
   1 row carries no date, and on all nineteen rows of that kind across the three
   sessions after `db/061` gave them one general note and kept nine detail notes.
4. **The Forth Crossing Act as a Hybrid Bill**, and that M4 says what you want
   said to a reader who is comparing our 44 government bills against the fact
   sheet's 45. **Given 2026-09-13**, on M4 read in full beside the clean sheet's
   row for the bill — recorded as a Hybrid Bill, and passed — and beside the
   Session 3 counts it has to reconcile: 44 government, 13 members', 2 committee,
   2 private and 1 Hybrid, against the fact sheet's stated 45 Executive.
5. **The three adjudicated dates and the asp number**, and that the corrections
   are the ones you intended. **Given 2026-09-13**, on the four cells read off
   the clean sheet beside what the fact sheet printed and what the dataset said:
   two Royal Assent dates settled the dataset's way against legislation.gov.uk,
   one introduction date settled the fact sheet's way against the Parliament's
   bill page, and the asp number the fact sheet omits taken from the same page
   that settles its Royal Assent — each with its source, its place in that
   source, the value in the source's own words and the day it was read, and the
   fact sheet's printed words left untouched beside them.
6. **The ten names corrected in the dataset**, checked against the workbook's
   Corrections sheet. **Given 2026-09-13**, on the ten read off the Corrections
   sheet as was and now — six slips against the Act's own title and the four
   Budget Acts renamed by year — and on all ten of the corrected spellings being
   found on the clean sheet, none missing.
7. **The Autism (Scotland) Bill's Stage 1 date.** The dataset said 17 January
   2011; the Official Report of 12 January 2011 records the motion disagreed to,
   and the fact sheet gives 12 January as the day the bill fell.
   **Given 2026-09-13**: the dataset needed correcting, and it is corrected to
   12 January. It had to be settled before the stage dates were loaded rather
   than at the end, because the loader's behaviour turns on it. What is left for
   the marking session is item 22, the new fingerprint.
8. **M7 as it now stands**, read in full: that it tells a reader what you want
   told about a bill falling for want of a financial resolution, and that saying
   the Parliament's own page is wrong about the Creative Scotland Bill is a
   claim you are content to publish. **Given 2026-09-13**, on M7 read in full,
   including that last claim.

   **And a point of semantics the owner raised, recorded because it will be
   asked again.** If a bill's general principles are agreed and it then cannot
   proceed for want of a financial resolution, at what stage did it fall —
   Stage 1, or a no-man's land between the stages? The owner's answer: arguably
   either, and it does not matter much provided the unusual nature of it is
   caught, which it is. It is caught by the data rather than by the argument:
   the Creative Scotland Bill has one stage row, Stage 1, completed and dated
   from the Official Report, and no stage at all is marked as where the bill
   ended. It is the only bill of 216 that ends that way. The ending is recorded
   on the bill and not pinned to a stage, so the no-man's land is represented as
   no-man's land. M7 does not say so in terms, and the owner did not require it
   to.
9. **That you can explain how this database works** from the documents alone,
   without help. The standing requirement, put again because Session 3 added an
   ending that behaves unlike the others. **Given 2026-09-13**, on
   `docs/HOW-THE-DATABASE-WORKS.md` read cold after it was brought up to date.
   It was six things out of date, because it had not been touched since
   11 September while Session 3 and nine migrations landed: the list of endings
   and the reader's notes were each a row short; the note on a stage row was
   still described as one note in three places; a bill ending with no stage
   marked was not described at all, which is the very thing this item was put
   again for; every session's dates were described as still to come when
   `db/048` had filled them; and the provenance counts at promotion stopped at
   Session 2. All six were corrected before the owner read it. Nothing in the
   database changed.

### Part C — what this test does not check

- **Whether the Session 3 dates nobody has checked are right.** 51 of the 53
  Royal Assent dates and 61 of the 62 introduction dates have never been checked
  against legislation.gov.uk or the Parliament's pages. The dataset agrees with
  every one of them, which is corroboration and not verification; M8 says which
  a reader has.
- **Whether the 108 Stage 1 and Stage 2 dates are right.** They rest on the
  dataset alone, and nothing has been compared against them.
- **Whether the Official Report was read correctly beyond the words quoted.**
  The five quotations were taken from pages cropped into halves, because reading
  those two-column PDFs whole interleaves them into nonsense. Nobody has read
  the surrounding debate.
- **Whether the Parliament's bill pages are right** about the four endings, or
  whether the web archive's copy is the page as it stood.
- **The comparison tool's known gap.** A bill it cannot pair is still recorded
  as compared. Session 3 has none unpaired, so nothing here rests on it, and it
  is not fixed.
- **Anything about Sessions 4 to 7**, including carry-over rows, the
  double-count guard and the prose reader, none of which Session 3 exercises.

---

## Sessions 1 and 2

Written 2026-09-12 by the session that loaded and corrected them.

**Run first on 2026-09-12, by the following session.** All sixteen mechanical
items matched, and items 17, 19, 20 and 21 passed. **Item 18 failed**, on seven
bills: the fact sheet reader could not reproduce the coding of a bill that fell
at dissolution without being handed the session's last day, which was recorded
nowhere. `db/051` and `db/052` moved that comparison onto the staging sheet, and
the expected answers below are corrected for it — items 1, 5, 14 and 18.

**Run again on 2026-09-12** by a session that made none of that change, which is
what marks it. **All twenty-one items pass.** Item 18 now passes as written,
with nothing supplied to the reader but the PDF and the session number: all 154
lines pair, and no raw column differs. Three worked-out columns do, each
accounted for and each carrying its own provenance — the outcome of all
eighteen fallen bills, which the reader no longer decides; five Royal Assent
dates checked against legislation.gov.uk; and one short title corrected at
review. Applying the dissolution rule afresh to that extraction and the session
tab returns exactly the seven bills coded that way, none over and none missing.
Item 20 was rehearsed for both sessions inside a transaction that was thrown
away: no unexpected differences either time.

**`db/053` was applied after the test was marked**, during sign-off 7, and the
mark stands. It changed the wording of M4, M7 and M8 and nothing else: eight
notes before and after, none empty, no column, no value and no bill's coding.
Item 15 tests the count and that none is empty, and neither moved. The only
figures affected anywhere are the word counts quoted at item 7 of Part B.

### Part A — mechanical

Run `tools/closure_check_sessions_1_2.sql`. It reads only and changes nothing.
Compare each numbered result against the expected answer.

**1. Counts.** bills 154, stage_records 413, provenance_notes 56,
checker_problems 0, gaps 0, staging_lines 154, stage_date_rows 413.

- 154 is the two factsheets' own totals, 73 and 81.
- 413 is derived and should be checked as a derivation, not taken on trust:
  128 bills passed × 3 stages = 384; of the 26 that did not pass, 24 have one
  stage each, the Gaelic Language Bill has two (Stage 1 completed, stopped at
  Stage 2) and the Session 1 Robin Rigg Bill has three (Preliminary and
  Consideration completed, stopped at Final) = 29. 384 + 29 = 413.
- 56 is 11 outcomes + 11 rejection routes + 1 title corrected at review + 13
  dates checked against the source that owns them + the 13 session dates loaded
  by `db/048` + the 7 bills coded as having fallen at dissolution, which gained
  a note each at `db/051`. It was 36 before the session dates and 49 before
  those seven; a session date is a fact about a session rather than about a
  bill, and carries its provenance like any other.
- 0 and 0 are the rule: a session cannot be promoted while the checker has
  anything, and a gap is a completed stage with no date and no explanation.

**2. Every staging line reviewed, admitted, on the clean sheet and compared.**
Session 1: 73 accepted, 73 promoted, 73 compared. Session 2: 81, 81, 81. No
other review status appears. From the factsheets' totals and the rule that
nothing reaches the clean sheet unaccepted (`db/044` for compared).

**3. Every stage-date row.** 413 accepted, 413 carried. No other status.

**4. A recorded difference with no adjudication.** 0. The rule is `db/044`: a
difference the comparison found is a problem until the owner has settled it.

**5. What has been checked against the source that owns it.**

| Field | Source | Cells |
|---|---|---|
| `date_completed` | `bill_page` | 1 |
| `date_first_meeting` | `spice_factsheet_dates` | 7 |
| `date_introduced` | `bill_page` | 4 |
| `date_royal_assent` | `legislation_gov_uk` | 8 |
| `date_session_end` | `spice_factsheet_dates` | 6 |
| `outcome` | `official_report` | 11 |
| `outcome` | `spice_factsheet_dates` | 7 |
| `short_title` | `manual` | 1 |
| `stage_1_rejection_route` | `official_report` | 11 |

The thirteen adjudicated dates are the owner's of 2026-09-12; the eleven
outcomes and routes are the Stage 1 rejections; the title is the one corrected
at review (`DECISIONS.md`, 2026-09-10). The thirteen session dates are `db/048`:
seven first meetings and six session ends, Session 7 having no end because it is
still running. The seven outcomes against the dates fact sheet are `db/051`: the
bills coded as having run out of time at dissolution, each note citing the same
document, page and reading date as its session's last day, because that is what
the coding rests on.

**6. Reconciliation.** Our counts must match each factsheet's own summary table
in every cell and both margins. These figures are read off the factsheets, not
out of the database — Session 1 page 7, Session 2 page 8:

| Session 1 | Executive | Member's | Private | Committee | Total |
|---|---|---|---|---|---|
| Acts | 50 | 8 | 1 | 3 | 62 |
| Withdrawn | 1 | 2 | 0 | 0 | 3 |
| Fallen | 0 | 6 | 2 | 0 | 8 |
| **Total** | **51** | **16** | **3** | **3** | **73** |

| Session 2 | Executive | Member's | Private | Committee | Total |
|---|---|---|---|---|---|
| Acts | 53 | 3 | 9 | 1 | 66 |
| Withdrawn | 0 | 5 | 0 | 0 | 5 |
| Fallen | 0 | 10 | 0 | 0 | 10 |
| **Total** | **53** | **18** | **9** | **1** | **81** |

The script's `government_or_hybrid` column answers the factsheets' "Executive",
which is methodology note M1. Neither session has a Hybrid Bill, so for these
two the distinction does not bite; from Session 3 it does.

**7. Outcomes.** Session 1: 62 passed and enacted, 3 withdrawn, 5 rejected at
Stage 1, 3 fell at dissolution. Session 2: 66, 5, 6, 4. Every non-passing bill
is `not_enacted`.

The factsheets give the row totals (62/3/8 and 66/5/10). Splitting "fallen" into
rejected-at-Stage-1 and fell-at-dissolution is ours, not the factsheets' —
methodology note M7 — and rests on the Official Report for the eleven
rejections. 5 + 6 = 11 rejections, and 3 + 4 = 7 fell at dissolution.

**8. Required cells.** Every column 0. Nothing the database demands is empty,
and every bill has an introduction date.

**9. Every Act.** 128 enacted, 0 without an asp number, 0 without an assent
date, 0 where the asp number's year disagrees with the assent year. 128 is
62 + 66 from the factsheets.

**10. Stage records per bill.** passed 3 stages × 128; rejected at Stage 1
1 stage × 11; withdrawn 1 stage × 8; fell at dissolution 1 stage × 5, 2 × 1,
3 × 1. The two- and three-stage cases are the Gaelic Language Bill and the
Session 1 Robin Rigg Bill; both are in `DECISIONS.md`, 2026-09-11.

**11. Where every stage date came from.** `phd` 256 (all dated),
`spice_factsheet_legislation` 128 (all dated) — called `spice_factsheet` until
`db/047` — `official_report` 14 (2 undated), `bill_page` 15 (all undated),
and 2 recorded as stages that never happened, both on the Session 2 Robin Rigg
Act. 256 is 128 bills that passed × Stage 1 and Stage 2. 128 is their passing
date. The undated rows are stages a bill stopped at where no decision of the
Parliament ended it.

**12. Two accepted rows for the same stage.** 0. Nothing has ever competed, so
the order of precedence has never had a case to decide in the real data —
`DECISIONS.md`, 2026-09-12. It was proved on planted rows and thrown away.

**13. How each Stage 1 rejection came about.** `member_motion_disagreed` 8 bills,
0 with a note; `member_motion_amended_agreed` 1 bill, 1 with a note;
`committee_motion_9_14_18` 2 bills, 2 with notes. The single amended-motion case
is the Proportional Representation (Local Government Elections) (Scotland) Bill.
`other_route` should not appear at all.

**14. Every source on the list has a definition.** Nine sources since `db/047`,
`has_a_definition` true for all. `api`, `bill_document`, `manual` and
`spice_factsheet_dates` carry no stage records — `bill_document` holds nothing by
design since `db/042` and its own description says so, and the dates factsheet
says when sessions began and ended, which is not a stage of a bill. The dates
fact sheet's cells are 20: the 13 session dates, and the 7 outcomes that rest on
them (`db/051`). It was 13 before that.

**15. The notes a reader is given.** M1 to M8, eight of them, none empty.

**16. Notes on the staging lines.** No expected figure. This is a prompt to look
at what is written there before signing anything off.

### Then, outside the script

**17. The data dictionary is still true.** `python3 tools/make_data_dictionary.py`
produces no difference from the committed file beyond its own date line.

**18. The reader still reproduces what was loaded.** Extract both factsheets
afresh and compare against the staging lines' raw columns: 154 rows, 0
differing. This is the check that the reader changes of 2026-09-12 left these
two sessions untouched.

**Nothing may be supplied to the reader but the PDF and the session number.**
That is the point of the item, and it is what it failed on when it was first
run: the reader took the session's last day as a command-line setting and used
it to code seven bills, so the answer depended on what had been typed rather
than on the fact sheet. `db/051` took that setting away. A run that needs
anything else typed is a failure of this item, whatever it produces.

    extract_factsheet.py <pdf> --session N --csv out.csv

**19. The dataset's fingerprint** matches the one recorded in `DECISIONS.md`,
2026-09-12, for the corrected working copy. **This is the one item a later
session can move.** Adjudicating a disagreement for Session 3 or beyond may
correct the dataset file, and the fingerprint changes when it does. Re-check
this item then, and record the new fingerprint beside the old; nothing else
about Sessions 1 and 2 is reopened by it.

**Moved twice since the mark, and re-checked both times.**
`c0d386c1…c688999` when this test was marked on 2026-09-12; then
`e04dc540…c38ea75` later that day, after Session 3's ten names and the Criminal
Procedure date; now
`a9596ecf997f186b0dd9d069642560f65120ab7ca97d0a2387863d0157ed8b94`, on
2026-09-13, after the Autism Stage 1 date; and now
`6614b3a1871367284c452ff8564b213532c1ec786f344acb7d350131c135420f`, on
2026-09-14, after the National Galleries introduction date. Nothing on the clean
sheet moved on any occasion. `tools/phd_stage_dates.py` gives byte-identical output from
every version of the file — checked across the first three on 2026-09-12, across
the fourth on 2026-09-13 and across the fifth on 2026-09-14 — so the 256 Stage 1
and Stage 2 dates
Sessions 1 and 2 hold are untouched. Item 19 passes; no other item is reopened.

**20. Promotion is still reversible.** Take a session off and put it back inside
a transaction that is thrown away, and the result is identical. The procedure is
in `docs/PROMOTION-RUNBOOK.md`.

**21. The repository is clean** and level with GitHub, and the migrations are
numbered without a gap.

### Part B — the owner's sign-off

None of these is for anyone else to answer. A sign-off is recorded here on the
day it is given, and nowhere else.

1. **What happened to each bill.** The counts in items 6 and 7 are what you
   expect for both sessions. **Given 2026-09-12.**
2. **The eleven Stage 1 rejections**: the route recorded for each, and the three
   notes a reader will see. Three, not four: eight rejections went the usual way
   and carry no note, one went by an amended motion and two by a committee
   motion under Rule 9.14.18. The fourth note a reader sees in these two
   sessions belongs to the Session 2 Robin Rigg Act, which passed, and is item
   4's business. **Given 2026-09-12.**
3. **The sixteen bills where you established where each ended**, as recorded in
   `DECISIONS.md`, 2026-09-11. Checked against the clean sheet, not against the
   note of it: it matches your answers in every cell. **Given 2026-09-12.**
4. **The Session 2 Robin Rigg Act's** Preliminary and Consideration Stages,
   recorded as stages that never happened. Both halves put and both content:
   that "never happened" is the right record rather than an empty cell, and
   that a reintroduced Private Bill carries its earlier scrutiny forward rather
   than repeating it. **Given 2026-09-12.**
5. **The thirteen adjudicated dates**, and that the five corrections are the
   ones you intended. Eight confirmations left standing and five corrections
   kept, all five Royal Assent dates against legislation.gov.uk.
   **Given 2026-09-12.**
6. **The nine corrections** on the Corrections sheet of the working dataset.
   Checked against the workbook itself: all nine recorded with what each was
   checked against, and the Dates sheet holds the corrected value in every one.
   **Given 2026-09-12.**
7. **M1 to M8**: that they tell a reader what you want told, and claim nothing
   you would not defend. Read in full, not in summary, and five changes came
   back: M4, M7 and M8, built as `db/053`. **Given 2026-09-12, on the corrected
   wording.** The word counts in item 15 move with it — M7 612 to 563, M8 542
   to 468, M4 160 to 161 — and nothing else about any note changes.
8. **That you can explain how this database works** from the documents alone,
   without help. This is the project's standing requirement, not a courtesy.
   **Given 2026-09-12**, on the documents as they stand, with nobody prompting.

**All eight given. Sessions 1 and 2 are closed**, 2026-09-12.

### Part C — what this test does not check

- **Whether the dates nobody has checked are right.** 120 of the 128 Royal
  Assent dates, and 150 of the 154 introduction dates, have never been checked
  against legislation.gov.uk or the Parliament's pages. That is the agreed
  position, not a defect: the factsheet is definitive unless checked, and M8
  says so to a reader. A pass here is not evidence those dates are right.
  **Corrected on 2026-09-12:** this bullet used to say those dates "rest on the
  factsheet alone", which was wrong. The PhD dataset was compiled from the
  ground up and is independent of the factsheets, and since the corrections of
  that day the two agree on every introduction date and every Royal Assent date
  in both sessions. That is corroboration, not verification, and M8 now says
  which of the two a reader has.
- **Whether the Stage 1 and Stage 2 dates are right.** 256 stage records rest on
  the PhD dataset alone. Nothing has been compared against them.
- ~~**That "fell at dissolution" can be re-derived.**~~ **No longer a limit, as
  of 2026-09-12.** It read: seven bills are coded that way because their
  concluding date matched the dissolution date, but no dissolution date is
  recorded anywhere in the database, so the coding cannot be checked from the
  data as it stands. `db/048` put every session's last day in, with its source,
  and `db/049` made the checker require a bill coded as having fallen at
  dissolution to have concluded on that day. All seven do. The converse is
  deliberately not required: a bill can be rejected at Stage 1 on the final
  sitting day, so that direction stays a proposal a person reviews.
  **Finished on 2026-09-12 by `db/051`**, which moved that proposal out of the
  fact sheet reader and onto the staging sheet. Until then the coding could be
  checked against the data but not re-derived from the fact sheet, because the
  reader was handed the date from outside. It now is, and each of the seven
  bills carries a note giving the rule and the source of its session's last
  day.
- **`procedure`, `party`, `sp_bill_id` and `title_as_introduced`.** Empty or
  sparse by decision, not by omission: no factsheet states procedure (`db/010`),
  party is future-proofing, Session 1's factsheet prints no bill numbers, and a
  stated introduced title is given for only one bill in these two sessions.
- **Anything about Sessions 3 to 7**, including the comparison tool, which has
  never run against a real load.
