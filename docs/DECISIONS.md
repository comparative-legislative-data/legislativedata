# Decisions

Settled decisions, newest first. A decision here is not reopened without a
reason recorded as a new entry. Each says what was decided, when, and why —
the why matters more than the what, because it is what tells a later session
whether changed circumstances actually undermine the decision.


---

## 2026-09-14 — Session 5 is closed, and the four-session chain that closed it

**Decided:** Session 5 is closed. Its 87 bills, 243 stage dates and the
provenance behind them are final, subject only to the standing caveat that
published records get revised. All thirty-two of Part A's mechanical items are
answered as expected, and all nine of Part B's sign-offs were given by the owner
on 2026-09-14.

**What closed it was item 32**, run by a session that added nothing to the
database. It asks the rule `db/079` added — that a note's words may not end in
"Read at" — of the notes rather than of the migration. All six parts answered as
expected: no note of the 106 ends that way; all 24 outcome notes cited to the
Official Report end where their sentence ends and still carry an address and the
day it was read; Sessions 1 to 3's 16 are untouched; and the rule refuses a note
typed by hand as well as one filed by promotion, which was the point of putting
it on the note rather than in the staging checker.

**Why it took four sessions, and why that is the procedure working.** Session 5's
test was written by a session that did none of its work. A second ran Part A and
found the two failures the test predicted, mending both in `db/078` — and by
doing so added a rule it could not then be the check on. A third ran that check
as item 31, took the owner through the nine sign-offs, and found eight notes
ending mid-sentence while doing it; mending those in `db/079` added another rule,
and another item nobody who had written it could mark. A fourth ran item 32.

**The rule that produced that chain is worth stating plainly: a session may not
mark the check on a rule it added itself.** It cost three extra handovers here,
and it caught two real faults in text a reader sees — the Period Products Act's
title and the eight broken notes — neither of which any count would have shown.
The cost is handovers; the alternative is a session marking its own work.

---

## 2026-09-14 — A provenance note may not end mid-sentence, and a closed session may be reopened to mend one

**Decided:** the eight provenance notes that ended with the words "Read at" and
nothing after them are mended; they are mended by taking the sessions off the
clean sheet and putting them back rather than by editing the notes where they
sit; Session 4, which is closed, is reopened for it; and the database is taught
to refuse a note that ends that way.

**Found** on 14 September, while the owner was reading Session 5's three
Official Report notes for sign-off 2 of its closure test. Nothing in the test
asked about the wording of a note; it turned up because the sign-off hands the
owner the full text rather than a summary of it.

**Why it happened.** A bill whose outcome was read in the Official Report carries
a note giving the outcome in the source's words. The staging line holds that note
in full and was never wrong. `tools/promote_session.sql` cuts the note at the
first address before filing it, deliberately, so that our own commentary can
never be recorded as though the source had said it — but "Read at" exists only to
introduce the address, so cutting the address and keeping the phrase left the
sentence hanging. Eight notes: five in Session 4, three in Session 5. Sessions 1
to 3 worded their review notes differently and had no address to cut.

**Why by the ordinary route and not by hand.** The alternative was to reach in
and edit the eight notes where they sit, which is less disruptive and touches no
closed session. It was rejected because it puts hand-written words into the
provenance record, which is the one thing the gateway arrangement exists to
prevent. Here the staging sheet was already right, so mending the copying step
and re-promoting corrects the notes with nothing typed by hand anywhere — a
cleaner case than the Period Products title of the same day, where the staging
sheet itself had to be corrected first.

**Why a closed session may be reopened for this.** Closure is a statement about
what has been checked, not a freeze. The owner agreed on 14 September, on the
grounds that the change alters no fact Session 4 recorded and moves no answer of
its test: item 5 counts the notes cited to the Official Report and says what each
is cited to, not how its words end. The safeguard is the comparison, not the
seal: a copy was taken first and the result differed in exactly the eight cells
predicted and no others.

**Where the rule lives, and why not with the others.** `v_candidate_problems`
reads the staging sheets, and the staging sheets were never wrong — there was
nothing there to refuse. A rule about what a note may say has to sit on the note
itself, so `db/079` puts it there, where it binds every writer rather than the
one route that produced this. The rule is narrow on purpose: a note may not end
in "Read at". A vaguer rule about notes ending mid-sentence would refuse most of
the 106, whose words are quoted verbatim and end in dates, numbers and titles.

**What would reopen this.** A second connective phrase slipping through the same
cut — "Taken from", "Seen at" — would say the narrow rule is too narrow and the
cut should be described by what it is for rather than by the words it removes.

**Rehearsed before it was run.** Session 5 alone moved three cells, Session 4
alone five, and the two together for real moved eight: the eight notes, each
eight characters shorter, and nothing else on any sheet. Bills stayed at 389,
stage records at 1071 and provenance notes at 106 throughout.

**Item 32 of Session 5's closure test** asks the rule from outside. It is written
by the session that added it and deliberately not run by it.

## 2026-09-14 — An Act's title carries its year, and the error checker now asks for it

**Decided.** The Period Products (Free Provision) (Scotland) Act's title is
settled as "Period Products (Free Provision) (Scotland) Act 2021" from
legislation.gov.uk, read 2026-09-14. And the error checker refuses any line
recorded as having become an Act whose title does not end in a four-digit year.

**Why.** The Session 5 fact sheet prints the line as "Period Products (Free
Provision) (Scotland) Act (asp 1)", with no year in either cell. `db/062` added
a rule in Session 4 that an Act's *number* must carry its year, and it was that
rule that made the number get settled at review. It said nothing about the
title. So the number was corrected to `2021 asp 1` by `db/073` and the title was
left as printed — where Session 4's equivalent line, the Higher Education
Governance Act, had both cells settled by `db/063`.

The same fault was therefore handled two ways in two consecutive sessions, and
the half left wrong is the half a reader sees. A rule that catches one half of a
fault and not the other is not a check on the fault; it is a check on one cell.
The title rule closes it for Sessions 6 and 7, where the same printing may
recur.

**Why it is worded about enactment and not about the number.** A bill that has
not become an Act carries a bill's title, and a bill's title has no year in it.
Session 5's three bills stopped before Royal Assent are recorded as blocked and
their titles rightly end in "Bill". The rule keys on `enactment_status` being
`enacted`, so it asks the question only of the 335 lines that are Acts and never
of the 54 that are not. See methodology note M3.

**How it was done, and why not by hand.** The correction was made on the staging
sheet with its citation in the form promotion reads, and Session 5 was then
taken off the clean sheet and put back. The title and its provenance note
therefore arrived the same way every other admitted fact does, rather than being
typed onto the clean sheet by a migration. Provenance goes 105 to 106; Session
5's other notes were rebuilt unchanged, which the owner's standing position on
rehearsed promotions already clears. The whole sequence was rehearsed inside a
transaction that was thrown away, compared cell by cell against a copy, and the
seven cells that moved were the same seven in the rehearsal and for real: the
Act's title on the clean sheet and the staging sheet, the citation on its review
note, its new provenance note, and its three stage-date rows, which carry the
line's title so a row can be recognised and follow it automatically.

**What it costs.** Adding the rule leaves a touched timestamp on one Session 1
line, because the migration proves the rule bites by taking a year off a title,
reading the checker and putting it back. `db/062` did the same. The value is
identical afterwards; only the stamp moved.

**What would reopen it.** A fact sheet printing an Act's title short in a way
that is not a printing convention but the Act's actual name. Nothing suggests
one exists.

---

## 2026-09-14 — M7 says five sessions are coded, and this is the second time it has lagged

**Decided.** M7 now tells a reader the coding of why a bill fell has been done
for Sessions 1, 2, 3, 4 and 5, and that one bill in the first five sessions fell
for want of a financial resolution. Two sentences, no other change to any note.

**Why.** Session 5's seven fallen bills were coded on 2026-09-14 into three
rejected at Stage 1 and four out of time. M7 still said four sessions. A
methodology note that understates what the database holds tells a reader the
work is less complete than it is, which is the same fault `db/072` was written
to prevent in M5 in the same week.

**Why it matters that this is the second time.** `db/070` had to make exactly
this correction at Session 4's closure, and it was found the same way both
times: while a closure test's Part B was being prepared, not by anything
automatic. Nothing checks that a methodology note keeps step with the data, and
after two occurrences that is a known gap rather than an accident. It is not
closed here, and it is not obvious that it can be closed by a rule: M7 is prose,
and what it must say is a judgement about what a reader needs. **It is recorded
so that the third time is not a surprise**, and so that a session coding a new
one is reminded to read the notes.

**What would reopen it.** Session 6 or 7 being coded, which moves it again.

---

## 2026-09-14 — Session 5 was marked closed by the session that did its work, and a test written after promotion has to protect itself differently

**The mark was wrong and is removed.** `STATE.md`'s table said Session 5 was
closed. No closure test had been written for it and none had been run:
`tools/` held closure checks for Sessions 1–2, 3 and 4 and none for 5, and
`CLOSURE-TESTS.md` had no Session 5 section. The table's row went from "yours to
do" straight to "closed" in one commit, made by the session that admitted and
promoted the session — where Session 4's row moved in three steps and three
sessions, "next: closure test", then "test passed; your sign-offs left", then
"closed". **The owner found it**, in the first minute of the next session,
against an opening report that had repeated the table rather than checked it.

**Nothing about the procedure changes, because nothing about it was wrong.** It
is at the top of `CLOSURE-TESTS.md` and it was settled on 2026-09-12 after a
session declared Sessions 1 and 2 finished against a test it had set itself.
This is the second time the same thing has happened, and both times the failure
was a session marking its own work rather than the rule being unclear. The row
now reads `next: closure test` and Session 5 is not closed.

**What the sanity check has to do about it.** The opening check reads the table
against the database, and both times it has passed a session that was not closed,
because the counts were right and only the word was wrong. It now also asks, for
any session the table calls closed, whether a closure test exists for it and
whether `CLOSURE-TESTS.md` records it as run; that is written into `STATE.md`
below the line, under "Keeping this file useful". A count is not evidence about a
procedure.

**A test written after its session is on the clean sheet says where every
expected answer comes from.** Sessions 3 and 4 had their tests written while the
session was still off the clean sheet, so no expected answer could have been
copied out of the data even by accident. That protection was not available for
Session 5, and the alternative — leaving it untested, or testing it against
itself — is worse than writing it late. So Session 5's test names its sources
instead: a fresh extraction of the fact sheet, the owner's workbook read
directly, `db/071`–`db/077` and the decisions they record, and Session 4's closed
test for what Session 5 does not move. Where a figure could only have come from
the database it says so and is not presented as a prediction; there are two, both
methodology note lengths quoted from Session 4's test. The script was syntax-
checked against the database with its output discarded, so writing it involved
looking at no answer.

**This is a worse position than writing the test first, and it is said out loud
rather than papered over.** A test written against a database that already exists
can be shaped, unconsciously, to the shape of what is there. The defence is that
every number in it is derived in the open, in a sentence a reader can check
without a database — 243 stage records, 19 provenance notes, 153 dataset dates,
312 periods — and that a session that did none of this work runs it.

**Three things writing it turned up, none of them settled here.** They are in
`STATE.md` under "Now": the Period Products Act's title without its year where
Session 4's equivalent Act had both title and number put right; M7 telling a
reader that four sessions have been coded for why a bill fell where five now are;
and `HOW-THE-DATABASE-WORKS.md` giving two different counts of provenance notes,
86 and 91, where it is 105. Each is the owner's to settle, and each is written
into the test as an expected answer rather than fixed by the session that found
it.

---

## 2026-09-14 — What a stage date is measured against, now that a bill can be on the clean sheet without having ended

**Session 5 is admitted and on the clean sheet** (`db/077`), the first session
carried on with its Stage 1 and Stage 2 dates already on it rather than added
afterwards. Nothing here reopens anything; this records one thing the admission
had to settle.

**The check that no stage date sits outside its own bill needed a ceiling**, and
until now the ceiling could be the bill's own last stage date where the bill had
neither a Royal Assent date nor a date it concluded. That was harmless while
every bill on the clean sheet had ended. Session 5's three bills stopped from
Royal Assent are the first that have not, and on those three the check compared
a last stage date against itself: a Stage 3 dated any year at all would have
passed it. Provoked in rehearsal, and it did pass.

**The ceiling is now the day the bill ended, and where it has not ended, the day
the session ended.** All 243 of Session 5's dates pass it, and both directions
were provoked and refused. Nothing was ever wrong in the data: the error checker
catches such a date by a different route, which is what the provocation showed,
and `db/068`'s older version of the check had nothing to miss — Session 5's three
are the only bills on the clean sheet with no ending date.

**This will refuse a bill carried over into the next session**, whose later
stages fall after its own session ended. None here is one. The four that are
were already work `STATE.md` puts before Session 6 is loaded, and this check is
now part of that work rather than a separate thing to remember.

---

## 2026-09-14 — Where Session 5's six bills ended, the Domestic Abuse Act's two dates, and a month typed wrong

**Six bills that did not pass had nothing saying where they ended**, and
`tools/phd_stage_dates.py` refuses a session with such a bill in it, so the
whole of Session 5's dates waited on these six. Their bill pages all say the
same thing in the same words: the bill "fell on" a date under Stage 1, with
"Stage 2 has not been reached yet" below. So each stopped at Stage 1 without
completing it, and none has a decision behind it. Each gets the row the other 21
bills that fell or were withdrawn already have — Stage 1, not completed, fell
here, and no date, because there was no decision to date. Lines 307, 308, 311
and 312 fell at dissolution; 313 and 314 were withdrawn. Built as `db/075`.

This also disposes of the Fair Rents page contradicting itself on the day the
bill fell, 4 May in its status line and 5 May a sentence below: no date is
recorded on a row of this kind, so nothing turns on which is right. That question
is off the open list.

**The Welfare of Dogs page has moved.** The plain address now redirects into the
National Records of Scotland web archive, which refuses automated readers,
because the Session 6 bill of the same name has taken it. The Session 5 bill is
at the same address with `-session-5` on the end, which is the one cited.

**The Domestic Abuse (Protection) (Scotland) Act 2021 has no row in the owner's
dataset**, so its Stage 1 and Stage 2 dates come from its own bill page: a Stage
1 debate on 28 January 2021, and Stage 2 ended on 23 February 2021. The same page
gives introduction, Stage 3 and Royal Assent dates that all agree with what the
fact sheet already put on the line. Two stage dates on the clean sheet already
cite a bill page, so this is not new ground. Built as `db/075`.

**A line the dataset has no row for is now named rather than guessed at.**
`tools/phd_stage_dates.py` refuses to write anything unless every staging line
pairs with a dataset row, which is right — attaching one bill's dates to another
is the harm it guards against — but a bill the dataset simply does not have is
not a pairing failure. Such a line is named in a new `NOT_IN_DATASET` list beside
`MANUAL_PAIRS`, and excusing it is then checked: the stage-dates sheet must
already hold, from another source, what the script would otherwise have written.
A line can never be excused into having no dates at all. Sessions 1 to 4 give
byte-identical output from the reader before and after the change.

**Session 5's reading date is 14 September, not 13.** `READ_ON` records when the
dataset was read for each session's bills, and the file was corrected again on
the 14th. Same reason Session 3's is later than Sessions 1 and 2.

**A month typed wrong in one cell, found by the rehearsal.** The dataset, row
360, dated the Civil Partnership (Scotland) Act 2020's Stage 2 at 11 February
2020 and its Stage 1 at 19 May 2020 — Stage 2 three months before Stage 1. The
error checker refused it and nothing was saved. The bill page reads "The Bill
ended Stage 2 on 11 June 2020", agrees with the dataset on Stage 1, and agrees
with the fact sheet on introduction, Stage 3 and Royal Assent. The day was right
and the month was not.

Settled at the bill page and built as `db/076`, **before** the working file was
corrected, under the rule settled earlier the same day: the database is settled
first, so the record that the two sources disagreed survives the file being put
right. The row carries what the dataset said, in its own words. The working file
is then corrected, with the Corrections sheet carrying it and the fingerprint
before the change: `4110d58f…` became `072184df…`. A copy of the file before the
change is not kept; it still exists on this machine only.

**What the checker does not catch, and the owner's decision about it.** It found
this because the dates were in an impossible order. A stage date that is wrong
but still in order would pass it, and nothing has compared Session 5's stage
dates against the Parliament's bill pages — the 14 September comparison covered
introduction, passing and Royal Assent only. Checking them is 87 pages and its
own piece of work.

**The owner's decision, 14 September: the dataset is taken as it is for now.**
The error rate is likely to be very low and is tolerable until there is a
methodology for checking it, and nothing waits on it, so it is not urgent. It
may be come back to. This is the owner's judgement as the authority on the
data, made with the limitation stated rather than around it, and it is not a
question to reopen unasked: what would reopen it is a methodology for the check,
or errors turning up often enough to say the rate is not what was assumed.

---

## 2026-09-14 — Session 5's three Stage 1 losses are rejections, and three dates are settled between the two sources

**Three of Session 5's seven "fallen" bills did not run out of time.** The
Culpable Homicide, Post-mortem Examinations (Defence Time Limit) and Restricted
Roads (20 mph Speed Limit) Bills each lost a division on their own Stage 1
motion. The fact sheet lists them under "Bills fallen" and says no more, exactly
as Session 3's and Session 4's did. They are recorded as rejected at Stage 1 by
the ordinary route, which is what the other 19 rejections on the clean sheet
already use, and Session 5 now reads 3 rejected and 4 fallen at dissolution.
Built as `db/073`.

**The other four were checked rather than assumed.** The owner asked whether the
four dissolution fallers were genuine. Each of their bill pages was read: the
last activity on every one is a committee date months before, and none records a
decision or a vote on 4 May 2021. Two things worth keeping: the Fair Rents page
contradicts itself, its status line giving 4 May and a sentence below it 5 May,
where the fact sheet and the session's own end date both give 4 May; and the
Welfare of Dogs page has moved, the obvious address now redirecting into the
National Records of Scotland web archive because the Session 6 bill of the same
name has taken it.

**Which source is cited, and why it is still the Official Report.** The owner
found all three rejections on the Parliament's Session 5 bill pages, which print
the division figures and name two of the three motions — more than the fact sheet
gives and more than the bill pages gave for earlier sessions. Citing the bill
page was proposed and then withdrawn, because the error checker has required the
Presiding Officer's announcement and the Official Report's address on the line
since `db/031` and `db/058`, and two of the three would have failed it. The
alternative was to relax that rule, which is a coding change with all eight
parts, for three bills whose figures are identical in both sources. So the
Official Report was read for all three. **This is the 2026-09-13 order holding
under pressure: the Official Report where the Parliament decided, the bill page
where it did not.** The bill pages were still the right way to find the answers.

**The Restricted Roads announcement does not name its motion.** The number and
the member are taken from the bill page and the line says so. Only the Official
Report's address appears on the line, because promotion cites the first address
it finds and that must be the record of the decision.

**Three dates disagreed between the fact sheet and the owner's dataset, and the
split went both ways.** Settled at the source that owns each value, and recorded
in the "Checked:" form `db/042` established. Built as `db/074`.

| Bill | Fact sheet | Dataset | Settled at |
|---|---|---|---|
| Age of Criminal Responsibility (Scotland) Act 2019, Royal Assent | 11 Jun 2019 | 12 Jun 2019 | legislation.gov.uk: 11 June 2019 |
| Heat Networks (Scotland) Act 2021, Royal Assent | 30 Mar 2021 | 20 Mar 2021 | legislation.gov.uk: 30 March 2021 |
| Solicitors in the Supreme Courts of Scotland (Amendment) Act 2021, introduction | 26 Sep 2020 | 26 Sep 2019 | the Parliament's bill page: 26 September 2019 |

The Solicitors Bill is the fact sheet being a year out, and the date is not a
detail: that bill's committee was established on 31 October 2019 and reported at
Preliminary Stage in January 2020, neither of which is possible on the fact
sheet's date. **The working dataset was corrected for the other two**, under the
rule settled earlier the same day, with the Corrections sheet carrying both and
the fingerprint before the change. The database was settled first, so the record
that the two sources ever disagreed survives the file being put right.

**The Act number with no year, the first of its kind.** The Period Products
(Free Provision) (Scotland) Act's number is printed as "(asp 1)" with no year,
which `db/062` made a refusal rather than something to notice. legislation.gov.uk
gives "2021 asp 1", and the year agrees with the Royal Assent date already on the
line.

**Ten names paired by hand, and one bill the dataset does not have.** The ten are
spelling, as in every session so far — the four Budget Acts numbered within the
session for a third time, an apostrophe moved in Hutchesons', a plural on UEFA
European Championships — and every pair agrees on both dates the two sources
share. **The Domestic Abuse (Protection) (Scotland) Act 2021 has no row in the
dataset at all**, which is why Session 5 has 87 lines against the dataset's 86.
Nothing depends on it yet; it matters when the Stage 1 and Stage 2 dates are
typed, because that bill will have none to type.

---

## 2026-09-14 — A bill that has passed and has no Royal Assent is blocked, and is recorded as its own session's fact sheet leaves it

**The question.** Session 5's fact sheet has a fourth table, "Bills awaiting
Royal Assent", with three bills in it: the European Charter of Local
Self-Government (Incorporation), passed 23 March 2021; the UNCRC
(Incorporation), passed 16 March 2021; and the UK Withdrawal from the European
Union (Legal Continuity), passed 21 March 2018. Each carries a footnote saying
that, following a reference under section 33 of the Scotland Act 1998 by the
Attorney General and the Advocate General for Scotland, the Supreme Court has
ruled some of its provisions outwith competence and it cannot be submitted for
Royal Assent in its unamended form. The ruling is dated 6 October 2021 in the
first two footnotes and undated in the third.

**Decided, on two questions put to the owner and answered on 2026-09-14.**

1. **Blocked, not pending.** "Awaiting" is the table's heading; the footnotes
   are the fact, and they say the bills cannot be submitted. So the heading
   alone proposes pending, and the footnote's own words are what make it
   blocked. Neither is guessed: both are read off the page.
2. **Recorded as Session 5's fact sheet leaves them.** Two of the three were
   later reconsidered and enacted in Session 6, and one was withdrawn there.
   That is Session 6's fact sheet to say, and it has not been read in. The
   alternative was to code them now out of a document nobody has read into the
   database, which is the opposite of how everything else here works.

**Why it matters beyond three bills.** It is the first time the clean sheet
holds a bill that has not finished. Everything on it until now had ended — 
enacted, withdrawn, rejected or fallen — and the ending date was how a reader
knew. These three have no ending date and are not missing one.

**What was built for it, all of it on 2026-09-14.** Almost all of the thinking
had been done years' worth of sessions earlier and none of the plumbing: the
value `blocked`, its definition, `bill.date_assent_blocked` and methodology note
M5 all existed and had never once been used.

- `db/071` puts two cells on the staging sheet — the date the bill was stopped,
  and the fact sheet's footnote word for word — and eight rules on the error
  checker, each tested inside the migration against a row made to break it.
- **The hole that found.** Until now a bill could be recorded as passed, given
  no Royal Assent date, left as not enacted with nothing on the line saying why,
  and the error checker would have admitted it. That rule is now there and is
  worded about the Royal Assent date, not about enactment.
- `tools/extract_factsheet.py` reads the fourth table and the footnotes below
  it. Sessions 1 to 4 extract byte-identically; Session 5 goes from 84 lines to
  87, which is what its own summary says.
- `tools/load_session.sql` and `tools/promote_session.sql` carry both cells, and
  promotion writes a provenance note on the status and on the date, with the
  footnote as the words that were seen.
- `db/072` adds two sentences to M5. **The reason it was needed is the useful
  part:** M5 already told a reader that two of these bills were later enacted
  and one withdrawn, which the clean sheet will not say until Session 6 is read
  in. A published note was running ahead of the published data.

**The words a reader sees on each of the three bills**, agreed by the owner
before Session 5 is loaded, to be entered at review:

> **European Charter of Local Self-Government (Incorporation):** Not submitted
> for Royal Assent. Following a reference under section 33 of the Scotland Act
> 1998 by the Attorney General and the Advocate General for Scotland, the
> Supreme Court ruled on 6 October 2021 that some provisions of the bill were
> outwith the Parliament's legislative competence, and it could not be submitted
> for Royal Assent in its unamended form.

> **United Nations Convention on the Rights of the Child (Incorporation):** Not
> submitted for Royal Assent. Following a reference under section 33 of the
> Scotland Act 1998 by the Attorney General and the Advocate General for
> Scotland, the Supreme Court ruled on 6 October 2021 that some provisions of
> the bill were outwith the Parliament's legislative competence, and it could
> not be submitted for Royal Assent in its unamended form.

> **UK Withdrawal from the European Union (Legal Continuity):** Not submitted
> for Royal Assent. Following a reference under section 33 of the Scotland Act
> 1998 by the Attorney General and the Advocate General for Scotland, the
> Supreme Court ruled that some provisions of the bill were outwith the
> Parliament's legislative competence, and it could not be submitted for Royal
> Assent in its unamended form. The fact sheet states no date for the ruling.

**What is still open and is not part of this.** Whether to keep the date a
bill's Royal Assent was blocked was on the waiting list and is now answered by
use: the date is kept, because M5 depends on it. Whether the section 33 and
section 35 distinction becomes a variable of its own is **not** decided here —
it stays on the waiting list, to be revisited at a fifth bill. Both mechanisms
are covered by `blocked`, and which one applied is in the bill's note.

---

## 2026-09-14 — Session 4 is closed on all nine sign-offs

**Given by the owner on 2026-09-14**, in one session, each against the rows read
back out of the database rather than out of a note about them. Session 4's 86
bills, 158 Stage 1 and Stage 2 dates and 9 provenance notes are final, subject
only to the standing caveat that published records get revised.

**Six were confirmations.** The reconciliation against page 9 in all twelve cells
and both margins, with its six fallen bills split five rejected and one out of
time; the five bills read in the Official Report, each quotation beside the
ending recorded against it; the Transplantation Bill's published note in full,
with both divisions and the motion as amended quoted entire; the two endings, the
Footway Parking Bill's completed Stage 1 of 1 March 2016 standing against the
Parliament's own bill page; the four adjudicated cells with the fact sheet's
printed words beside each; and the eight names paired by hand, every pair agreeing
on every date its two sources share.

**Three changed something**, and that is the argument for Part B existing at all.
Item 7 settled the rule about correcting the working dataset, and the National
Galleries date with it — its own entry, above. Item 8 asked for a sign-off on M4
where it meant M1, the Hybrid Bill note rather than the Executive-and-Government
one; the test is corrected and the correction marked. Item 9, the standing
requirement that the owner can explain the database from the documents alone,
found the explainer silent on the note a reader sees — the cell the two divisions
had just been published into — and M7 still saying the coding of why a bill fell
had been done for three sessions when Session 4 made it four. Both were put right
before the document was read: the explainer in prose, M7 by `db/070`.

**What that says about the shape of the test.** Part A is where the database is
checked against a prediction; **Part B is where the documents are checked against
the database**, and it is the only part that looks at what a reader is told. Two
of this session's three findings were in text a reader sees and neither was
reachable by any mechanical check. Item 9 in particular earns its place as a
standing item precisely because it is the one that cannot be automated.

---

## 2026-09-14 — The working dataset is corrected whenever it is wrong, and the National Galleries date is the first case under the rule

### The owner's ruling

"Correct it. We've already established the local version is a live and updatable
doc and my original PhD dataset is kept separate for posterity."

Session 3 corrected the Autism Bill's Stage 1 date in the file; Session 4 settled
the National Galleries introduction date on the staging line and left the file
alone. Both were defensible, and the Session 4 closure test put the difference to
the owner as Part B item 7 rather than let two sessions decide the same question
opposite ways by accident. **The rule is now Session 3's: the working file is
corrected whenever it is found to be wrong.** The fingerprint exists to show the
file changed, not to discourage changing it.

### The correction

`sources/phd/Billdates-September2026.xlsx`, Dates sheet, row 294, introduction
date of the National Galleries of Scotland Act 2016: **26 June 2015 corrected to
25 June 2015.** The SPICe legislation fact sheet gives 25 June, the Parliament's
own page for the bill redirects into the National Records of Scotland web archive
and cannot be read, and the owner's own record of the bill gives 25 June, which is
what settled it on 13 September. The database has held 25 June since; the file now
agrees. The Corrections sheet carries the change, the reason and what it was
checked against, as it does for every correction before it.

### Fingerprints

Before: `a9596ecf997f186b0dd9d069642560f65120ab7ca97d0a2387863d0157ed8b94`.
After: `6614b3a1871367284c452ff8564b213532c1ec786f344acb7d350131c135420f`.

### Checked, against a copy taken before the change

**Exactly one cell differs on the data sheet** — D294 — and seventeen on the
Corrections sheet, being the new note, its header row and its one entry. Nothing
else moved, and neither sheet changed shape.

`tools/phd_stage_dates.py` gives **byte-identical output from the file before and
after**, same checksum `47fe08466757786093c698cf1351d68ef962b65ec57de64e183748cdbe1b3384`
across all four sessions, so none of the 522 stage dates the clean sheet holds
from the dataset is affected. Its own report of the disagreement — "introduction
dates differ: line 270 ... 2015-06-25 / dataset row 294 2015-06-26" — is gone.

`tools/compare_sources.py` now finds **all 73, 81, 62 and 86 lines paired and no
difference in any of the four sessions**. The SQL it writes was read and not run:
nothing in the database needed to change, because the database was already right.

### What moves in the tests, and what does not

Sessions 1 and 2's item 19, Session 3's item 22 and Session 4's item 24 are the
same item under three numbers — the one item an outside change may move — and all
three now carry the new fingerprint beside the old. **Nothing else is reopened.**
The eight Session 4 names that differ from the fact sheet's are still paired by
hand in `tools/phd_stage_dates.py` and deliberately not corrected: they are
wording, not error, and the fact sheet's form is not more right than the
dataset's. The Land Reform Act's Royal Assent still stands as the dataset always
had it, against the fact sheet.

### Why the rule and not the case matters

The dataset is the owner's research record and the check on every claim this
project makes. A cell known to be wrong, left in it because correcting it would
move a checksum, makes the record worth less and the checksum no more meaningful.
The thesis dataset is a separate, frozen file; this one is working material.

---

## 2026-09-14 — Both divisions are published beside a bill rejected by its own amended motion, and vote data is a layer for later

### The decision

A bill rejected at Stage 1 by its own motion being amended is decided twice, and
**both divisions are given in the note published beside it**, in the order they
were taken. Two bills are rejected this way: the Proportional Representation
(Local Government Elections) (Scotland) Bill of Session 1 and the
Transplantation (Authorisation of Removal of Organs etc.) (Scotland) Bill of
Session 4. `db/069` put both on both.

### Why both and not one

The route decides a bill twice. The amendment turns the member in charge's own
motion into its opposite; the motion as amended then formally ends the bill.
**The two can differ widely enough that either alone would mislead.** The
Transplantation Bill's amendment carried by three votes — For 59, Against 56 —
and the motion as amended by seventeen, For 65, Against 48. A reader given only
the second sees a comfortable majority rejecting a bill that was in fact lost on
a margin of three; a reader given only the first does not see the decision that
ended it.

### What this is not

**It is not vote data.** These are figures in prose beside two bills. They cannot
be counted, filtered or joined to anything, and nothing should be built on them.
A structured record of how members voted is intended as its own layer of this
project, and when it arrives it supersedes these figures. M7 says so to a reader,
in those terms, so that nobody mistakes a sentence for a dataset. This is written
down because the cheap thing to do, when the vote layer is built, would be to
parse these notes; that is not what they are for.

### Which bills, and which are deliberately left alone

**Every one of the nineteen Stage 1 rejections already carried its division**
against the bill, in the Official Report's own words — that was never the gap.
The gap was between what is recorded and what a reader sees. Only the two bills
above gain it, because only they have a published note at all: the fifteen
rejected on the ordinary route and the two rejected on a lead committee's motion
have none, and a note that repeated a figure already recorded against the bill
would earn its place less than one explaining an unusual route. If that is ever
revisited, the figures are already there to draw on.

### The two divisions on the Session 1 bill are both real

That bill's note gave **For 65, Against 54, Abstentions 2** on the amendment,
while what we recorded against it was **For 65, Against 53, Abstentions 3** on
the motion as amended — the same For count, one member moving from abstaining to
against between two votes minutes apart. That is exactly what a transcription
slip looks like, so it was put to the owner rather than assumed, and the owner
confirmed both are as the Official Report records them. Recorded here because a
later reader meeting two near-identical figures is entitled to suspect one of
them, and should find the answer at the same time as the doubt.

### How it was built and checked

`db/069` changes the staging line and the published note together and then checks
the two are the same text, because a note is copied from its staging line every
time a session is put on: changing the clean sheet alone would be undone by the
next promotion. It was rehearsed in a transaction that was thrown away before it
was applied, and one check failed there — an assertion that four bills carry a
note when six do, the other two being the Robin Rigg and Forth Crossing Acts,
whose notes are about something else. The check was rewritten to prove that no
bill gains or loses a note rather than to count them. Afterwards, Session 4 was
taken off and put back inside a transaction that was thrown away, to prove
promotion carries the new text: it does, and the comparison found no unexpected
difference.

---

## 2026-09-13 — Where Session 4's two bills ended, and a bill page that disagrees with the Official Report

### The Inquiries into Deaths Bill stopped at Stage 1, undated

Withdrawn by Patricia Ferguson on 24 September 2015. The Parliament's bill page
records the ending and no stage — *"On 24 September 2015 the Bill was
withdrawn."* — and the Official Report for that day carries her own account of
it, given during the Stage 1 debate on the Government's Inquiries into Fatal
Accidents and Sudden Deaths etc. Bill: *"In the spirit of that collaboration, I
wrote today to the Parliament's clerk to withdraw my bill with immediate
effect."*

The Justice Committee had reported on the bill at Stage 1 (14th Report, 2015),
but the Parliament never debated or decided its general principles, so the stage
was never completed and no date is recorded. This is Session 3's Criminal
Sentencing (Equity Fines) and Palliative Care Bills again, and `db/067` records
it the way `db/056` recorded those.

### The Footway Parking Bill completed Stage 1 and stopped at Stage 2, undated

The Parliament agreed its general principles on 1 March 2016: motion S4M-15759 in
Sandra White's name, put at Decision Time and agreed to without a division.
*"Motion agreed to, That the Parliament agrees to the general principles of the
Footway Parking and Double Parking (Scotland) Bill."* So Stage 1 was completed,
on the day the owner's dataset also gives. No Stage 2 was scheduled and the bill
fell when the session ended on 23 March 2016, so it stopped at Stage 2, undated.

**This is not a new shape.** Session 1's Gaelic Language Bill is already on the
clean sheet exactly this way: Stage 1 completed 6 March 2003, fell at Stage 2 at
dissolution. What made it look new was that Session 3's two dissolution bills had
no Stage 1 date at all, so the comparison reached for the wrong precedent.

### Where a bill page and the Official Report disagree, the Official Report wins

The Parliament's current bill page for the Footway Parking Bill says *"The Bill
fell at Stage 1 on 23 March 2016"*. Read literally that contradicts the Official
Report, which records the general principles as agreed three weeks earlier.

**It is the site's coarse label** — the bill got no further than Stage 1 — **and
the Official Report is the record of what the Parliament decided.** That is the
order this project already uses and `tools/phd_stage_dates.py` already states:
the Official Report where the Parliament decided, the bill page where it did not.
A bill page is a summary of a bill's life; the Official Report is the proceeding
itself.

The reason this is written down rather than just done: a later reader looking at
the bill page alone would code that bill differently, and would be entitled to
think the database wrong. The disagreement is quoted on the stage record itself,
so it cannot be found without also finding the answer.

### The closure test's N is 3, filled in before promotion

`docs/CLOSURE-TESTS.md` carried an N in four places because the writing session
could not predict how many stage records the two bills would produce. Three: one
for the Inquiries into Deaths Bill, two for the Footway Parking Bill. Item 1's
counts become 828, Session 4's part 245, and item 11 and item 21 are split out by
source and by stage. Filled in on the strength of the sources, before Session 4
went anywhere near the clean sheet, which is the only order under which the
number is worth anything.

`READ_ON` in `tools/phd_stage_dates.py` now holds 4: 2026-09-13. With `db/067`
applied the script runs and writes exactly the 158 stage rows the test predicts;
before it, the script refused, naming the Footway Parking Bill's Stage 1 as a
stage nothing on the sheet said it had completed. That refusal was doing its job.

---

## 2026-09-13 — Session 4's closure test, and two bills that do not say where they ended

### The test is written, and Session 4 stays off the clean sheet until it is run

`tools/closure_check_session_4.sql` and the Session 4 section of
`docs/CLOSURE-TESTS.md`, written by a session that did none of Session 4's work:
it did not read the factsheet in, did not build the review and did not admit it.
Twenty-one items out of the database, six outside it, nine sign-offs for the
owner. Nothing was written to the database and no migration was made.

**Every expected answer is a prediction, and that is the only reason it is worth
anything.** Session 4 was deliberately still off the clean sheet, so the counts
come from page 9 of the Session 4 factsheet, the owner's dataset and the rules.
The reconciliation table is read off the printed summary. The 158 stage dates the
load will supply were counted in the workbook itself — 85 of its 86 Session 4
rows carry a Stage 1 date and 79 a Stage 2 date — not in the database. Where a
count could only have come from looking at the result, it is not in the test.

### Two Session 4 bills have no stage record, so nothing says where they ended

Found by writing the test, not by the review.

| Line | Bill | Ending | Concluded |
|---|---|---|---|
| 296 | Inquiries into Deaths (Scotland) Bill | withdrawn | 24 September 2015 |
| 300 | Footway Parking and Double Parking (Scotland) Bill | fell at dissolution | 23 March 2016 |

`v_stage_date_gaps` has reported both since Session 4 was loaded, under `where
the bill ended is not recorded`. They are 2 of the 160 gaps; the other 158 are
Stage 1 and Stage 2 dates the load supplies. The gaps figure was read as 160
dates and the two were not noticed.

**This is the same job `db/056` did for Session 3's four** — two withdrawn bills
and two that fell at dissolution, each established by the owner from the
Parliament's own bill page and recorded as an undated stage row. It was simply
not put on Session 4's review list.

**The Footway Parking Bill is a shape that has not arisen before.** The dataset
gives it a Stage 1 vote on 1 March 2016, three weeks before the session ended, so
the bill completed Stage 1 and was past it at dissolution. Session 3's two
dissolution bills had no Stage 1 date at all. The dataset is not a source for
where a bill ended, and `tools/phd_stage_dates.py` refuses on exactly this case:
"ended before Stage 3, and the dataset dates stage 1 2016-03-01 — a stage nothing
on the stage-dates sheet says it completed. Settle it before loading."

**Decided: the endings are established before Session 4 is promoted, and the
count they produce is written into item 1 of the closure test before promotion,
not after.** The test carries an `N` for it, because how many stage records two
bills produce turns on what the Parliament's bill pages say and cannot be
predicted from the factsheet, the dataset or the rules. Filling it in after the
promotion it is testing would make that item describe rather than predict, which
is the fault the whole ordering exists to avoid.

### Session 4 did not move the dataset's fingerprint, and that was a choice

sha256 `a9596ecf997f186b0dd9d069642560f65120ab7ca97d0a2387863d0157ed8b94`,
unchanged from Session 3's closure test. Both of Session 4's disagreements were
settled without editing the workbook: the Land Reform Act's Royal Assent because
the dataset was right, and the National Galleries Act's introduction date because
the factsheet was, which is recorded on the staging line with source `manual`.
The eight names that differ are paired by hand in `MANUAL_PAIRS` rather than
corrected.

**Session 3 did the opposite** — the Autism Bill's Stage 1 date was corrected in
the file and the fingerprint moved with it, and so were ten names. Both are
defensible and the two sessions should not end up having decided it differently
by accident, so it is Part B item 7 of the Session 4 test and is on the waiting
list in `STATE.md`. It is the owner's dataset and their call.

### Session 4 does not exercise the carry-over question

Checked rather than assumed: none of Session 4's 86 titles appears in the Session
5 factsheet. So the four bills that appear in two factsheets, and the
double-count guard that goes with them, are not touched by this session, and the
closure test says that passing tells you nothing about them. `STATE.md` keeps
them due before Session 6 is loaded.

---

## 2026-09-13 — Session 4 admitted, provenance made consistent, and who writes the closure test

### A provenance note must name a column that exists

The owner asked for the provenance notes to be made consistent. Looking at them
found something worse than a difference of wording.

Promotion wrote the standard sentence on a checked value by working the raw
column's name out of the column's own name: replace a leading `date_` with
`raw_date_`, then put `bill_candidate.raw_` in front of the result. For a date
that gives `bill_candidate.raw_raw_date_royal_assent` — the prefix twice. For
anything else it gives a column that was never there. **All eighteen notes of
this kind on the clean sheet named a column that does not exist:**

| Column cited | Notes | The note said | The column really is |
|---|---|---|---|
| `date_royal_assent` | 10 | `raw_raw_date_royal_assent` | `raw_date_royal_assent` |
| `date_introduced` | 5 | `raw_raw_date_introduced` | `raw_date_introduced` |
| `asp_number` | 1 | `raw_asp_number` | `raw_title` — the number is inside the title |
| `bill_type` | 1 | `raw_bill_type` | `raw_type` |
| `date_completed` | 1 | no second sentence at all | — |

**Why this is not tidiness.** A provenance note exists so a research claim can be
followed back to what said so. One that sends the reader to a column that does
not exist cannot be followed anywhere, and it fails silently, because it reads
like a citation. Two of them also said "the source that owns this date" about an
Act's number and a bill's type, neither of which is a date.

**Decided and built (`db/065`).** One sentence, true of every column, rather than
a name worked out per column — which is the thing that produced this. The raw_
columns are described one by one in the data dictionary, so the note points at
the group and the dictionary says which. Promotion writes the same sentence from
now on, so a session taken off and put back reproduces it. No value, source,
address or date read moved; the migration fingerprints all four before and after
and refuses if any of them does.

One note legitimately names `bill_candidate.raw_title` — `db/026`'s correction of
a title — and it is right, so it stays. The migration now checks that every raw_
column any note names actually exists, which is the check that would have caught
this at the time.

### Session 4 is admitted

`db/066`, the gateway's admission step, as `db/016`, `db/034` and `db/057` were
for Sessions 1 to 3. The owner cleared the 86 lines on 2026-09-13. 86 lines and
84 stage dates accepted — 79 passing dates from the factsheet and 5 Stage 1 dates
from the Official Report. Nothing promoted; the clean sheet is still 216 bills.

### Who writes Session 4's closure test, and the one condition on it

The rule has been that the session doing the work writes the test and a different
session runs it. The owner set a different order for Session 4: **the next
session writes it, and the session after runs it.** That is more independent, not
less — no session marks its own work at either step.

**The condition, which is what makes the test worth anything: Session 4 must not
be promoted before the test is written.** Session 3's test was written before the
work it tested, so its expected answers were predictions made from the factsheet,
the dataset and the rules. If Session 4 were promoted first, the session writing
the test would be describing a database it can already see, and the test would
confirm whatever happened rather than check it. So promotion waits.

The order is therefore: closure test written → Session 4 promoted → the owner's
Stage 1 and Stage 2 dates loaded → a third session runs the test → the owner's
sign-offs → closed.

---

## 2026-09-13 — Session 4's review answered, and two faults in how a citation is read

The owner answered all eight items on Session 4's review list. Each was then
read in the source it names and the words quoted on the line (`db/063`).

### Why the five bills fell

All five were rejected at Stage 1, and four by the ordinary route: the member in
charge's motion put and disagreed to.

| Bill | Decided | Motion | Result as recorded |
|---|---|---|---|
| Alcohol (Licensing, Public Health and Criminal Justice) | 4 Feb 2016 | S4M-14673, Richard Simpson | For 36, Against 59, Abstentions 12 |
| Assisted Suicide | 27 May 2015 | S4M-13258, Patrick Harvie | For 36, Against 82, Abstentions 0 |
| Criminal Verdicts | 25 Feb 2016 | S4M-15429 | For 28, Against 80, Abstentions 0 |
| Pentland Hills Regional Park Boundary | 26 Jan 2016 | S4M-15130, Christine Grahame | For 8, Against 105, Abstentions 0 |

Every one of the four concluded on the day the Official Report gives, which the
migration checks before writing anything.

**The fifth is the second case of the other route.** The Transplantation
(Authorisation of Removal of Organs etc.) (Scotland) Bill's own motion, S4M-15128
in the name of Anne McTaggart, was amended by S4M-15128.1 in the name of Maureen
Watt into a motion that did not agree to the general principles, and then agreed
to as amended on 9 February 2016: "For 59, Against 56, Abstentions 0. Amendment
agreed to", then "For 65, Against 48, Abstentions 2. Motion, as amended, agreed
to." The motion carried and the bill fell. The owner predicted this from the
shape of the record before it was read, and was right.

**The motion as amended is recorded in full** (`db/064`), from the owner. The
Official Report page the division was read on gives the question the Presiding
Officer put and both results and nothing else, and `db/063` ended by saying so;
that was the wrong thing to leave on the only bill of its session rejected this
way, and it is replaced by the text itself:

> That the Parliament does not agree to the general principles of the
> Transplantation (Authorisation of Removal of Organs etc.) (Scotland) Bill
> because it has serious concerns about the practical impact of the specific
> details in the bill that relate to organ donation rates and transplants; agrees
> the merits of developing a workable soft opt-out system for Scotland, and calls
> on the Scottish Government to commence work in preparation for a detailed
> consultation on further methods to increase organ donations and transplants in
> Scotland, including soft opt-out, as an early priority in the next
> parliamentary session, learning from the experiences in Wales, which is
> currently implementing its own opt-out legislation, and to consider bringing
> forward legislation as appropriate.

**Why this matters beyond one bill.** The resolution is the whole difference
between this route and the ordinary one. On the ordinary route the Parliament
declines the general principles and says nothing else. Here it declined them *and*
resolved what should happen instead — a soft opt-out system, a consultation, and
legislation in the next session if appropriate — so the rejection carries a policy
direction that a count of rejections cannot see. That is what
`ref_stage_1_rejection_route` means when it asks for the reason the resolution
gives to be kept on the bill. Quoted in full and not summarised, because it is
published beside the bill; checked character for character against what the owner
supplied, 781 characters. The amendment's own wording is still not printed on
that page, and the note says so.

### The two dates

- **Land Reform (Scotland) Act 2016, Royal Assent: 22 April 2016.** The factsheet
  prints 22 March and is wrong. legislation.gov.uk, the document of record for
  Royal Assent, states "The Bill for this Act of the Scottish Parliament was
  passed by the Parliament on 16th March 2016 and received Royal Assent on 22nd
  April 2016". The owner's dataset agrees with it.
- **National Galleries of Scotland Act 2016, introduction: 25 June 2015.** The
  factsheet is right and the dataset a day out at 26 June. Settled on the owner's
  own record: the Parliament's page for that bill redirects into the National
  Records of Scotland web archive, which blocks reading, so it could not settle
  it. Recorded with source `manual`, which exists for exactly this.

### Two faults in how a cited value is read, found by building the citation

A value checked at review is carried to promotion in a fixed form —
`Checked: <column> = <value> (<source>, <address>, <date read>)` — and promotion
turns each into a provenance note on the clean sheet. Settling the Higher
Education Governance Act's title needed the first citation this database has
whose value contains a bracket, and that broke it twice.

- **The value pattern stopped at the first `(`.** So
  `Checked: short_title = Higher Education Governance (Scotland) Act 2016 (...)`
  matched nothing at all, and promotion would have written **no provenance note
  and raised nothing**. A citation that is simply not seen is worse than one that
  fails, because nothing says so.
- **Widening it to `.+?` did not work either, and the reason is a real trap.**
  PostgreSQL sets the greediness of a whole regular expression from its *first*
  quantifier, so a lazy `.+?` later in the pattern behaves greedily. One citation
  swallowed the next, and a line carrying two citations produced one note. The
  value is now `[^\n]+?`, which cannot cross a line, and explanatory prose is
  kept off the citation line for the same reason.
- **`db/063` checks its own citations**: it counts the `Checked:` lines on every
  Session 4 line and requires the same number to be readable by promotion's own
  pattern. That check is what caught the second fault.

**The standard provenance sentence changed with it.** It named the raw column the
factsheet's words are kept in, worked out from the column's own name, which gives
`bill_candidate.raw_short_title` and `raw_asp_number` — neither of which exists.
It now says the words are kept in the raw_ columns of `bill_candidate`, which is
true of every column. **Sessions 1 to 3's stored notes keep the old sentence
until they are next re-promoted**, so the two wordings coexist. Whether to bring
them into line now is the owner's, under the standing position that a change to a
provenance note goes to them individually.

---

## 2026-09-13 — An Act number carries its year, and two later-session questions settled

Three things settled before Session 4 was read in. Only the first is built,
because only the first has anything in the database to act on yet.

### An Act's number carries its year, and the checker refuses one that does not

**The problem.** The Acts table of every legislation factsheet writes an Act as
`Title Act YYYY (asp N)`: the year sits in the title, and the bracket holds only
the number. The reader takes the year from the title and the number from the
bracket. Two rows in the sessions ahead print no year in the title:

    Higher Education Governance (Scotland) Act (asp 15)        Session 4, p.4
    Period Products (Free Provision) (Scotland) Act (asp 1)    Session 5, p.8

So two cells come out short on each row, not one: the number, as `asp 15` rather
than `2016 asp 15`; and the title, which loses the year that is part of the Act's
short title and is the title the site displays. It would be the only Act title on
the clean sheet without a year on it.

**Decided.** Both cells are settled from legislation.gov.uk, which gives
*Higher Education Governance (Scotland) Act 2016*, 2016 asp 15, and *Period
Products (Free Provision) (Scotland) Act 2021*, 2021 asp 1. Both agree with the
Royal Assent dates the factsheets state. Each corrected cell carries a provenance
note naming legislation.gov.uk, the Act's address, and the date read.

**Why not take the year from the Royal Assent date**, which is already on the
row and would give the same two answers? Because it would be our inference
rather than something a source says, and the evidence for it — that on all 181
Acts held here the year on the number equals the year of Royal Assent — comes
from the same factsheets. Two lookups cost nothing and leave a citation.

**The fault the checker had.** The year check compares the year on the number
with the year of Royal Assent, but only where a year is printed. A number with
none left the comparison with nothing on one side and passed without being
looked at. `db/062` refuses an Act whose number does not begin with a four-digit
year. This is independent of how the two rows above are settled and would have
been worth fixing either way.

**legislation.gov.uk's description was widened.** It was recorded as definitive
for the date of Royal Assent and "not used for the text of an Act". An Act's
short title and year-and-number are its identity rather than its text, but that
description is narrow enough to read against this use, so it was widened rather
than stretched quietly.

**Nothing on the clean sheet moved.** All 181 Acts already carried their year,
on both sheets, and every year already matched its Royal Assent year. `db/062`
adds a check and widens a description. The two rows it exists for are not in the
database yet.

### The European Charter Bill passed on 23 March 2021

The two factsheets disagree, and this is the first disagreement between sources
that decides which session a bill belongs to rather than only a date.

- Session 5 factsheet, p.2, *Bills awaiting Royal Assent*: `23 March 2021`.
- Session 6 factsheet, p.7, *Acts of the Scottish Parliament*: `Passed on 23 May 2021.`

Session 5 ended 4 May 2021 and Session 6 first met on 13 May 2021, so 23 May
falls between dissolution and the new Parliament — no Parliament existed to pass
it. The Scottish Parliament's own bill page settles it: *"The Bill ended Stage 3
on 23 March 2021"*, 114 for, 0 against. The bill page is already recorded as
definitive for dates other than Royal Assent, so this needed no new source.

**Decided:** 23 March 2021, cited to the bill page, with the Session 6
factsheet's date kept on the staging sheet as what that document said. Applied
when Session 5 is read; nothing to build now.

The same page gives the Stage 1 debate as 4 February 2021 and Stage 2 ending
24 February 2021, which will be wanted then.

### The date a reconsideration was agreed is kept, but not as a date

A factsheet gives two dates for a Reconsideration Stage:

    Reconsideration stage agreed on 14 September 2023.
    The Bill was approved and ended Reconsideration Stage on 7 December 2023.

The second is the stage's date and is already recorded, on a Reconsideration
stage row like any other stage. The first has nowhere to sit, because a stage row
holds one date.

**Decided:** it is kept as the factsheet's own sentence on the stage's detail
note, so the date is on the row and can be promoted to a date cell later without
re-reading the source, but it is not a date anything is measured from. The owner's
reasoning: it is not needed, but should be recorded in case it is wanted.

**Nothing to build.** The detail note already exists. This is an instruction to
the Session 6 reader, which does not exist yet, and it applies to two bills —
the UNCRC and European Charter Bills. If it later becomes a date cell it should
become one for *"Motion agreed to treat as Emergency Bill on …"* at the same
time, which Session 6 states for several of its own bills and which has the same
shape: a dated procedural motion that is not a stage boundary.

### Where the other later-session events already go

All eleven events that happened in a session later than the bill's own were
listed out of the Sessions 5, 6 and 7 factsheets. Nine already have a place and
need nothing built: Royal Assent, a bill's concluding date and the date Royal
Assent was blocked all sit on the bill and carry no session — fourteen Acts in
Sessions 4 and 5 already received assent after their session ended — and
Reconsideration is already the fourth stage for every bill type. The Gender
Recognition Reform Bill's Session 7 entry repeats its Session 6 entry word for
word and adds no event at all.

**Still not built, and first bites when Session 6 is read:** the staging sheet
has one session cell and it means *which factsheet the row was read off*, not
*which session the bill belongs to*. Three checks use the first where they need
the second. `STATE.md` said this was needed before Session 5; on the rows it is
not — no row of Sessions 4 or 5 has an introduction, passing or concluding date
outside its own session — and it lands on the same four bills as the
double-count guard, which is already set before Session 6.

---

## 2026-09-13 — Session 3 is closed, and a bill can end at no stage at all

**Session 3 is closed.** All nine of the owner's sign-offs were given on
13 September, across two sessions of that day, and are recorded against their
own items in `docs/CLOSURE-TESTS.md`. Sessions 1, 2 and 3 are now finished: 216
bills, what happened to each, and the time from introduction to every stage the
Parliament decided, with every cell traceable to what said so.

**The semantics question the owner raised, settled, because it will be asked
again.** If a bill's general principles are agreed at Stage 1 and it then cannot
proceed for want of a financial resolution, at what stage did it fall? Arguably
Stage 1, arguably a no-man's land between the stages. The owner's ruling: it
does not matter much which you call it, provided the unusual nature of it is
caught — and it is caught by the data rather than by the argument. The Creative
Scotland Bill has one stage row, Stage 1, completed and dated from the Official
Report, and no stage at all is marked as where the bill ended. It is the only
bill of 216 that ends that way. The ending sits on the bill and is not pinned to
a stage, so the no-man's land is represented as no-man's land rather than forced
onto Stage 1. M7 does not say so in terms and the owner did not require it to;
`docs/HOW-THE-DATABASE-WORKS.md` now does, because on screen it looks like an
oversight.

**Why the explainer had to be fixed before the ninth sign-off could be given.**
Sign-off 9 is the standing requirement that the owner can explain the database
from the documents alone. `docs/HOW-THE-DATABASE-WORKS.md` had not been touched
since 11 September, while Session 3 and nine migrations landed, and was six
things out of date — the list of endings and the reader's notes each a row
short, the note on a stage row still described as one note in three places, a
bill ending with no stage marked not described at all, every session's dates
described as still to come when `db/048` had filled them, and the provenance
counts at promotion stopping at Session 2. Had the owner read it cold it would
have failed on our bookkeeping rather than on anything real. **The lesson is the
one `CLAUDE.md` already states and this session nearly proved the hard way: the
explainer is kept true as the database changes, not caught up with at the end.**
Two of the six were found only by doing the work, after four had been proposed —
so the check is to read it against the database, not to remember what moved.

## 2026-09-13 — A stage row carries a general note and a detail note

**What happened.** Nineteen bills across Sessions 1 to 3 stopped at a stage
without the Parliament deciding anything: withdrawn by the member in charge, or
still at that stage when the session ended. They are the only stage rows with no
date, and the note on each existed to account for the empty cell. Written by
hand, one session at a time, they had come out in **sixteen different wordings
of one situation** — and two of them contradicted each other about the same
fact, the Session 3 bills that fell at dissolution reading "during Stage 1" and
"before a Stage 1 debate took place" of two bills in identical positions. The
owner found it while checking the four Session 3 endings for sign-off 3.

**The decision.** The one note becomes two.

- The **general note** is one sentence, the same words every time: "The bill
  stopped at this stage without a decision, so no date is recorded." Nobody
  types it. The database writes it from the row it sits on — this is where the
  bill ended, there is no date, and the stage is not one the bill never had — so
  there is one place its words live and a later session cannot word it a
  seventeenth way. It has no provenance, because it is not an observation of
  anything; it is a restatement of the row beside it.
- The **detail note** is the column that was called `note`, unchanged in
  meaning: whatever a source records beyond that. Empty means no extra detail
  has been collected for that bill. It does not mean none exists, and it does
  not mean any was sought — the owner's wording, and the point is that we have
  not systematically collected why and when a bill was withdrawn or fell.

**A rejected bill gets no general note and never had one.** The owner's ruling:
its rejection is the explanation. The row carries the date of the decision, the
stage it did not complete and the outcome, and accounts for itself. That took
fifteen rows out of the change — the fourteen rejected at Stage 1 and the Budget
(Scotland) (No. 2) Bill rejected at Stage 3.

**The two Robin Rigg stages that never happened keep the note they have.** The
owner's ruling: that bill was reintroduced in Session 2 as a carry-over Private
Bill, does not repeat its earlier scrutiny, and did not fall in the sense the
other nineteen did. `db/039` gave it its own handling and it keeps it.

**Eight detail notes were emptied and nine kept.** A note was kept where it says
something the row does not. Emptied where it named the stage the row already
names, or said "not completed" when the row already says it: "Fell at
dissolution at Preliminary Stage", "Withdrawn during Stage 1" (four bills),
"Fell at dissolution during Stage 1", "Fell at dissolution before Stage 1 was
completed", "Fell at dissolution before Final Stage". Nothing is lost: the words
are in `db/061` and in this entry. The owner was shown all nineteen, before and
after, and chose this over keeping all eight verbatim — which would have put the
sixteen wordings straight back.

**Two kept notes were reworded, with the owner's agreement**: the Scottish
Register of Tartans Bill's lost "Withdrawn during Stage 1," from the front, and
the Palliative Care Bill's "before any Stage 1 debate" became "before the Stage 1
debate was held", matching the Criminal Sentencing Bill's. The Gaelic Language
Bill's Stage 1 remark, "General principles agreed at Stage 1", came off: the row
says the stage was completed and on what day, and the Stage 2 detail note now
carries the fact, as the owner directed — that despite the general principles
being agreed, no Stage 2 proceedings were scheduled and the bill fell at the end
of the session.

**Why a column that fills itself in, and not a stored one.** A stored column is
sixteen wordings again in three sessions' time unless something checks it. This
one cannot be worded twice. Against that, it is a second kind of column in a
database the owner has to be able to explain — every other column holds
something somebody put there. The owner took the trade.

**What holds the assumption underneath it.** The general note appears on a row
where the bill ended, with no date, that is not a stage the bill never had.
Across all 583 stage rows that is exactly the nineteen, and it has never once
differed from the fuller test that also asks what happened to the bill.
Promotion now refuses a session in which a row carries the general note for a
bill that was neither withdrawn nor fell at dissolution, so the assumption is
checked and not assumed. Nothing was added to the error checker: there are no
stored words left to drift.

**Built as `db/061`**, rehearsed in a transaction that was thrown away before it
was applied, which caught two title fragments that each matched a later Act of
nearly the same name. Session 3 was then taken off and put back, also thrown
away, and the notes came back identical. `tools/phd_stage_dates.py` was changed
in step: it holds the wordings for Sessions 1 and 2, and left alone it would
have written the old ones back the next time it ran. M2 tells a reader what both
notes are; its length moved from 4347 to 5140 and Session 3's closure test item
15 records it.


## 2026-09-13 — A marking session corrects an expected answer it can show is wrong, and says why

**What happened.** Session 3's closure test was run by a session that did none
of the work it tests. Twenty-one of its twenty-four mechanical items matched the
answer written down in advance. Three did not, and in all three the database was
right and the prediction was wrong: M2's length had been written against
`db/055` and `db/060` then amended the note deliberately; item 19 expected four
Stage 1 dates where the query it is written against returns five, the fifth
being one this test's own item 11 predicts; and item 21 listed eight worked-out
cells where ten differ, having missed the two bills that fell at dissolution,
whose outcome `db/051` took away from the reader on purpose.

**The decision.** A session marking a test may correct an expected answer, and
only an expected answer, where it can show from something other than the
database under test that the prediction was wrong or has been overtaken. The
correction is written beside the item, dated, and says what it was, what it is,
and why it moved. The run itself is recorded at the head of the test, as
Sessions 1 and 2's already is.

**What this does not license.** Changing a prediction to match a result the
session cannot otherwise account for. Each of the three above was settled
against something independent: a migration that says in terms what it changed to
M2; another item of the same test that predicts the fifth row; and, for the
dissolution bills, the rule applied afresh to a fresh reading of the fact sheet,
which returns exactly those two bills and no others. A difference that cannot be
accounted for that way is a failure, and it is reported as one.

**Why it is needed.** A test written before the work it tests will sometimes
predict wrongly — that is the price of writing it first, and the price is worth
paying. What must not happen is that a wrong prediction stands, so that the next
session reading the test is stopped by a figure that moved for a good reason, or
worse, treats a real failure as one of the known-stale ones. See
`docs/CLOSURE-TESTS.md`, and the standing rule that a test inherits and is not
re-argued, which this does not disturb: what is corrected is the answer written
down, never the question asked.

---

## 2026-09-13 — Time is counted to every stage the Parliament decided, whatever it decided

**The owner's ruling**, on three bills put to them — the Creative Scotland Bill,
whose Stage 1 principles were agreed; the Autism Bill, whose were refused; and
the Budget (Scotland) (No. 2) Bill, rejected at its Stage 3 vote: "For each of
those 3 Bills we should count them as Stage 1 completed FOR THE PURPOSES OF
COUNTING TIME. They reached the terminal point of Stage 1 and Parliament took a
decision. I do not think it matters at all what the parliament decided OR what
happened to the Bill after — in my view the counting period is equally
legitimate in all cases."

**The rule.** A period is counted to a stage where the stage reached its
terminal point and the Parliament took a decision. Which way the decision went,
and what became of the bill afterwards, are separate facts, recorded separately,
and neither affects whether the period is counted or how long it is. A stage
that never reached its terminal point — a bill withdrawn partway through Stage
1, or one that ran out of time between two stages — gives no period, because
there is no day to count to.

**Why it matters, and it is not a nicety.** Until this, a period was counted
only where the bill got through the stage. That removed the fourteen bills
rejected at Stage 1 and the Budget Bill's last eight days, and it removed them
one-sidedly: only Members' Bills lose Stage 1 votes, so the exclusion fell
entirely on Members' Bills and never on Government ones. Session 2's Members'
Bill figure for introduction to the Stage 1 debate rested on 3 bills when 9 have
a dated debate, and read 342 days against 273 for the full set. A comparison
between Government and Members' Bills built that way is a comparison between
government legislation and the Members' Bills that survived.

**The incoherence that showed it.** The rule was not even applied consistently:
the Creative Scotland Bill and the Autism Bill both ended before Stage 3 with a
partial set of dates, both had a Stage 1 debate on a recorded day, and only the
first was counted. The difference between them was which way the vote went.

**What makes the rule safe rather than lucky.** Every stage that reached its
terminal point has a day recorded against it, and every stage that did not has
none: a bill withdrawn during Stage 1 has no Stage 1 day, and the day it was
withdrawn sits on the bill. The rule is to be stated and enforced in those
terms, so that it stays true by requirement. Otherwise someone later records a
withdrawal date against a stage and it silently counts.

**stage_event.completed keeps its meaning** — the bill got through the stage —
because that is a real and separately useful fact, and a chart of bills that
completed their passage will want it. It is simply not what decides whether time
is counted.

**Two questions, kept apart**, at the owner's insistence: what the database
calculates, settled here; and which bills a given chart covers, which is a
front-end choice and is not settled by this. The database is to hold every
period it can defend, so that the front end can offer, for example, introduction
to Stage 1 across every bill that had a Stage 1 debate, or across only those
that completed their passage, without either being baked in.

**The check that goes with it**, asked for by the owner: every bill and every
stage is either counted into a period or carries a stated reason why not, with
no third category. `tools/duration_coverage.sql`. It is to be run before and
after any change to how periods are calculated.

## 2026-09-13 — Anything read out of the Official Report cites the page on the line

**The rule.** A staging line whose ending, or whose route to being rejected at
Stage 1, is attributed to the Official Report must carry the address of the
report it was read on in its own review note. The error checker asks for it, so
a session cannot be admitted without it, and promotion cannot run while the
checker holds anything.

**Why, and how it was found.** `db/055` read five Session 3 bills' endings out
of the Official Report and recorded the address on the stage-dates row only.
Promotion writes a bill's provenance note from the line and takes the reference
out of the line's own note, so it had nothing to cite. The three rejected at
Stage 1 were refused outright — a route has had to carry its citation since
`db/032` — but the Budget (Scotland) (No. 2) and Creative Scotland Bills would
have reached the clean sheet with the reference simply empty, and nothing would
have said so. It surfaced in the rehearsal of the promotion, before anything
was written.

**What it does not change.** The address stays on the stage-dates row as well;
that row's own source is what dates a stage. This adds the line, because that
is where promotion reads from. `db/058` put it on all five Session 3 lines,
taken out of each bill's own stage row rather than retyped, and added the rule.

**Proved, not assumed.** Taking the address off one line again makes the
checker name that line and refuses the admission; running `db/058` a second
time refuses rather than appending a second address; an anchor that is not on
the line refuses rather than writing the address in the wrong place.

**The owner approved both parts** before either was built.

## 2026-09-13 — The Autism Bill's Stage 1 date: the dataset is corrected

**The owner's ruling**, on the disagreement Session 3's closure test turned up:
"The phd dataset clearly needs corrected, and that resolves the problem."

**The disagreement.** The working dataset gave the Autism (Scotland) Bill's
Stage 1 as 17 January 2011. The Official Report of 12 January 2011 records
motion S3M-7676, in the name of Hugh O'Donnell, that the Parliament agrees to
the general principles of the bill, disagreed to, For 5 Against 109 Abstentions
2; and the SPICe legislation fact sheet gives 12 January 2011 as the day the
bill fell. Two independent sources against one, and the one is the owner's own
working copy.

**Corrected to 12 January 2011**, in `sources/phd/Billdates-September2026.xlsx`,
with the Corrections sheet carrying the change, the reason, and what it was
checked against. The owner's original behind the 2021 thesis is held separately
and is untouched, as before.

**Fingerprints.** Before:
`e04dc54042292e2b1f4bc9ea23a481d88f240adac587d68d38134d431c38ea75`. After:
`a9596ecf997f186b0dd9d069642560f65120ab7ca97d0a2387863d0157ed8b94`.

**Checked, against a copy taken before the change.** Exactly one cell differs on
the data sheet — E199, the Autism Stage 1 date — and seventeen on the
Corrections sheet, being the new note, its header row and its one entry. Nothing
else moved. `tools/phd_stage_dates.py` gives byte-identical output from the file
before and after, same checksum, so none of the 256 Stage 1 and Stage 2 dates
Sessions 1 and 2 hold on the clean sheet is affected. `tools/compare_sources.py`
finds all 73, 81 and 62 lines paired and no differences in any of the three
sessions. All four Session 3 bills whose Stage 1 the Official Report dates now
agree with it to the day.

**Why it is worth an entry of its own.** The comparison that gates every session
does not compare stage dates, and cannot: the fact sheet holds none. So a
disagreement of this kind has no gate to catch it. This one surfaced only
because a closure test had to state in advance how many rows the stage-date load
should write and where each came from, which meant working out exactly which
bills the dataset supplies. **Writing the expected answers is itself a check, and
a different one from running them.** Sessions 1 and 2 had the same shape and got
away with it — the dataset agreed with ten of the eleven Stage 1 rejections and
the eleventh was blank.

**What moves in the tests.** Sessions 1 and 2's item 19 is the one item that
test said an outside change could move, and this is the second time it has
moved; both moves are recorded beside the original and the item still passes.
Session 3's item 22 now carries the new fingerprint, and its Part B item 7 is
given.

---

## 2026-09-13 — Session 3's closure test, written before the work it tests

`docs/CLOSURE-TESTS.md` and `tools/closure_check_session_3.sql`, by the session
that reviewed Session 3 and coded the nine bills that did not pass. Not run and
not marked, which is the procedure.

**A test written ahead of the work, and why that is better here.** Sessions 1
and 2's test was written after those sessions were finished, so its expected
answers described a database somebody had already looked at. Session 3 is not on
the clean sheet and its Stage 1 and Stage 2 dates are not loaded, so this one's
expected answers are worked out instead — from the fact sheet's own summary
page, from the owner's dataset, and from the rules the earlier sessions set.
That turns the test into a specification the promotion and the stage-date load
have to satisfy, written by a session that will do neither. An expected answer
taken from the database it is testing proves nothing; an expected answer written
before that database exists cannot be taken from it.

**It is therefore run at the end, not now.** Closure means the session is
finished, and Session 3 is not finished until its dates are in. Twenty-four
mechanical checks, nine sign-offs, six stated limits.

**What the test predicts, and where each figure comes from.** 216 bills, being
154 plus the fact sheet's own 62. 583 stage records, being 413 plus Session 3's
170: 53 bills passed × 3 stages, plus 3 for the Budget (Scotland) (No.2) Bill
which reached Stage 3, plus 1 for the Creative Scotland Bill which completed
Stage 1, plus one each for the 7 that stopped at a stage. 71 provenance notes,
being 56 plus 15. 108 stage dates to load, being 54 bills × two stages — counted
in the dataset, not in the database.

**Writing it found a disagreement nothing else would have.** Working out which
54 bills the dataset supplies exposed four whose Stage 1 the Official Report
already dates, and one of the four disagrees: the dataset gives the Autism
(Scotland) Bill's Stage 1 as **17 January 2011**, while the Official Report of
**12 January 2011** records the motion disagreed to and the fact sheet gives 12
January as the day the bill fell. `tools/compare_sources.py` could not have
caught it — it deliberately does not compare stage dates, because the fact sheet
holds none. Sessions 1 and 2 hit the same shape and got away with it: the
dataset agreed with ten of the eleven Stage 1 rejections and the eleventh was
blank. It is the owner's to settle, and it has to be settled before the loader
runs rather than at the end, because the loader's behaviour turns on it.

**Three smaller things, recorded so they are not found twice.** Session 3's
staging lines are all `new` rather than `accepted`, which is correct but blocks
promotion until someone accepts them. `sp_bill_id` does not collide across
sessions, contrary to `FACTSHEET-SURVEY.md` §4.2, because the rule is on the
pair of session and number. And `in_progress` and
`fell_financial_resolution_not_agreed` share a sort order, so any list of the
endings puts those two in an arbitrary order; it wants a line in a later
migration.

---

## 2026-09-13 — Where four bills ended, and one that ended nowhere

Both halves of this are loose ends from `db/055`, found when the owner asked
whether the session was safe to close. It was not.

**The error checker being empty is not the same as the work being done.** Four
Session 3 bills that did not pass had nothing recording where they had got to —
two withdrawn, two fallen at dissolution. Every one of the 26 such bills in
Sessions 1 and 2 has that. The error checker does not carry this: a missing
stage record is a gap, and gaps live in `v_stage_date_gaps`, which the session
had not looked at. It had reported "nothing is waiting on you", which was wrong.
**Closing a session means reading both lists, not one.**

**The four, established by the owner from the Parliament's bill pages** as kept
by the web archive: Criminal Sentencing (Equity Fines), withdrawn by the member
in charge on 25 November 2010 before the Stage 1 debate was held; Palliative
Care, withdrawn on 2 December 2010 before any Stage 1 debate; Commissioner for
Victims and Witnesses, fell at dissolution during Stage 1; Long Leases, fell at
dissolution before a Stage 1 debate took place. All four stopped at Stage 1
without completing it.

**None of the four carries a date**, which is the rule Sessions 1 and 2 set: a
stage a bill did not complete has no completion date, because none of these
bills ended on a decision of the Parliament. The day each concluded is on the
bill, from the fact sheet, and for the two withdrawn bills the fact sheet's date
agrees with the owner's reading of the bill page to the day — 25 November and
2 December 2010.

**The second half is a fault this session created.** `db/055` gave the Creative
Scotland Bill an ending with no stage attached, deliberately: it completed
Stage 1 and fell between Stage 1 and Stage 2, on a vote that is not part of any
stage. But the gaps list asks every bill that did not pass where it ended, so it
began reporting "where the bill ended is not recorded" for that bill — a false
statement, permanently, in the list the owner opens to find what is missing.

**The new ending is now exempt from that question**, with the reason written
where the rule is. The owner agreed to a specific rule for financial
resolutions. This is what "a change to how data is coded is finished before
anything moves on" is for: the value, the checker and the notes were all built
in `db/055`, and the change was still not finished, because a view nobody
thought about was asking a question that no longer made sense.

**What it says about adding a value to a list.** Adding `rejected_stage_3` cost
nothing, because it behaves like the endings around it. Adding
`fell_financial_resolution_not_agreed` cost two migrations, because it does not:
it is the first ending in this database where the bill does not stop at a stage.
The lesson is not "avoid new values" but that the thing to check is whether the
new value breaks an assumption the old ones all shared. Here it did, and the
assumption was not written down anywhere — it was implicit in a `NOT IN` list.

**Checked.** Rehearsed inside a transaction that was thrown away, then applied.
The error checker is empty. No bill is listed as not recording where it ended.
The gaps list now holds 108 rows, every one of them a Session 3 Stage 1 or
Stage 2 date waiting for the PhD dataset to be loaded, which is the next piece
of work and not a fault.

---

## 2026-09-13 — A bill can fall for want of money, and that is a fifth ending

The five Session 3 bills the fact sheet says fell without saying why. The owner
established each from the Parliament's own record; every one was then read in
the Official Report for that day, and the Presiding Officer's words are quoted
on the line.

**Three were rejected at Stage 1 in the ordinary way** — the member in charge's
own motion put and disagreed to. Autism (S3M-7676, Hugh O'Donnell, 12 January
2011, For 5 Against 109); End of Life Assistance (S3M-7438, Margo MacDonald,
1 December 2010, For 16 Against 85); Protection of Workers (S3M-7592, Hugh
Henry, 22 December 2010, For 42 Against 75).

**One was rejected at Stage 3**, the first time this database has recorded that.
The Budget (Scotland) (No 2) Bill, 28 January 2009, tied 64–64 and decided by
the Presiding Officer's casting vote: "It is a well-established convention here
and elsewhere that Presiding Officers cast in favour of the status quo … I cast
my vote against the motion. Motion disagreed to." Then: "The Budget (Scotland)
(No 2) Bill therefore falls."

**The fifth needed a new value, and the owner settled it.** A bill whose
provisions charge public funds requires a financial resolution before it can go
beyond Stage 1; under Rule 9.12 the Presiding Officer decides whether a bill
needs one. The Creative Scotland Bill's general principles were **agreed** on
18 June 2008 — "Motion agreed to. That the Parliament agrees to the general
principles of the Creative Scotland Bill" — and the financial resolution
(S3M-1776, John Swinney) was then defeated, For 49 Against 68. The Presiding
Officer: "Standing orders are quite clear; the Creative Scotland Bill therefore
falls."

So the bill fell with the Parliament's approval of its principles on the record.
That is not a rejection and it is not the calendar running out, and the general
`fell_other` bucket would have hidden a defined procedural route behind a word
meaning "we did not name this". New outcome:
`fell_financial_resolution_not_agreed`.

**Why it was worth naming rather than bucketing.** `ref_stage_1_rejection_route`
already carries the principle, in its own words: a route nobody anticipated goes
under `other_route`, and "a second case of the same kind earns its own entry
here". The difference is that this one is not unanticipated. It is in Standing
Orders, the Presiding Officer determines it, and it will recur. The owner's
framing settled it: "this is a new clause of reason for a Bill falling."

**The Parliament's own website is wrong about this bill.** Its page for the
Creative Scotland Bill says "The Bill fell at Stage 1 on 18 June 2008" and
mentions no financial resolution. Stage 1 was completed. That is recorded on the
line, and it is a reason to keep reading the Official Report rather than the
summary pages: the same page pattern says "fell at Stage 1" for bills that were
genuinely rejected there, so the label cannot be relied on to tell the two apart.

**What it does to the data.** The Creative Scotland Bill has a **completed**
Stage 1, dated 18 June 2008, and no stage marked as where it fell, because it
did not fall at a stage. The other four have the stage they stopped at marked as
where they fell. That asymmetry is the whole point of the new value.

**M7 was amended, not supplemented.** It already tells a reader that why a bill
fell is our coding and names the reasons; it named three. A ninth note would
have split one subject across two. M7 now names four, says the work has been
done for Sessions 1 to 3, and carries a paragraph on the financial resolution
that says plainly that counting such a bill among those the Parliament rejected
would misstate what happened. The migration refuses to run if M7's wording has
moved under it.

**Getting the Official Report was the hard part, and is worth recording.** The
Parliament's Official Report pages are JavaScript-rendered and the web archive
is behind a bot check, so neither can be fetched. The reports are served as PDFs
from `https://www.parliament.scot/api/sitecore/CustomMedia/OfficialReport?meetingId=N`,
where N is an internal meeting number that runs broadly but not strictly in date
order and is shared between chamber and committee meetings. The five meetings
were found by sweeping ranges of N and reading each PDF's first page: 6230
(12 January 2011), 6093 (22 December 2010), 6031 (1 December 2010), 4843
(28 January 2009), 4805 (18 June 2008). Those addresses are what the lines cite.
The PDFs are two-column and `extract_text` interleaves the columns into
nonsense; cropping each page into halves first is what made the quotations
reliable, and a quotation taken without doing so would have been wrong.

**Checked.** `db/055` was rehearsed inside a transaction that was thrown away,
twice: the first run caught a column that does not exist, the second a
methodology note that would have duplicated M7. Applied only after it ran clean.
All 62 Session 3 bills now hold an outcome — 53 passed, 3 rejected at Stage 1,
2 fell at dissolution, 2 withdrawn, 1 rejected at Stage 3, 1 for want of a
financial resolution — and the error checker is empty for the first time since
Session 3 was loaded.

**Not done.** Session 3's closure test is not written; this session did the work
and does not mark it. Session 3 is not on the clean sheet, and its Stage 1 and 2
dates are not loaded: `tools/phd_stage_dates.py` still only knows Sessions 1
and 2.

---

## 2026-09-12 — Session 3's names reconciled, and three dates and one type settled

**What went wrong first, because it is the useful part.** Session 3 was loaded
and the comparison against the owner's dataset paired only 52 of the 62 bills.
Ten were spelled differently in the two lists. The session's first instinct was
to treat that as a fault in the machinery and propose refusal rules, a reader's
note and a closure-test item — five things to agree — before ever showing the
owner the ten names. The owner's answer, given twice: fixing eleven misspelled
names is not a methodology question, and the list of names should have been on
screen in the first reply. **When a mismatch is found, show the rows before
proposing anything.**

**It had never worked by itself for Sessions 1 and 2 either.** Eighteen pairs
are named by hand in `tools/phd_stage_dates.py` for those sessions. Nobody had
written Session 3's. That was the whole of the difference.

**Ten names corrected in the dataset, and none needed in code.** Six were slips
against the Act's own title (Aggravated for Aggravation, Care Services for
Services, missing "(Scotland)", missing "(Protection and Jurisdiction)", and
brackets round Abolition and Elections). Four were the Budget Acts, which the
dataset numbered No.2 to No.5 and the factsheet names by year; renaming them by
year loses nothing, because the years already tell them apart and the bill that
fell is still the only "(No.2) Bill". After the ten, **all 62 bills pair with no
hand-written pairs at all** — Session 3 needs none of the machinery Sessions 1
and 2 need.

**Neither source's names are authoritative.** The factsheet calls the 2007 Act
"St Andrew's Bank Holiday"; it is the St Andrew's Day Bank Holiday (Scotland)
Act 2007, and the dataset has it right. So "make the dataset match the
factsheet" is the wrong rule. The target is the Act's own title, whichever list
currently holds it.

**The three dates, adjudicated by the owner.** Two corrected the factsheet and
one corrected the dataset:

| Bill | Field | Factsheet | Dataset | Settled | Against |
|---|---|---|---|---|---|
| Double Jeopardy (Scotland) Act 2011 | Royal Assent | 28 Apr 2011 | 27 Apr 2011 | **27 Apr** | legislation.gov.uk, asp 2011/16 |
| Forced Marriage etc. (Scotland) Act 2011 | Royal Assent | 28 Apr 2011 | 27 Apr 2011 | **27 Apr** | legislation.gov.uk, asp 2011/15 |
| Criminal Procedure (Legal Assistance…) Act 2010 | Introduction | 27 Oct 2010 | 26 Oct 2010 | **27 Oct** | the Parliament's bill page |

The two Royal Assent corrections are in `db/054`; the introduction date was
corrected in the dataset. Nothing moves on the clean sheet for the third: the
introduction date always comes from the factsheet, and all three of that bill's
stages fall on 27 October anyway, so introduction to the end of Stage 3 is zero
days either way. The Cadder emergency bill was introduced, taken through every
stage and passed in one day.

**The Forth Crossing Act is Hybrid**, confirmed by the owner against the
Parliament's archived bill page. The two sources never disagreed: both type it
Hybrid. What disagrees is the factsheet's own summary page, which has no Hybrid
column and counts the Act under Executive — their Acts row of 42 is our 41 plus
this one, their column total of 45 our 44 plus this one. Every other cell of
that summary matches ours exactly, and both totals are 62. Recorded on the bill,
because anyone reconciling our counts against the printed summary will hit it.

**The asp number the factsheet omits.** It prints no number for the Forced
Marriage Act where it prints one for every other Act, so the checker reported an
Act without one. legislation.gov.uk — the page that settles its Royal Assent —
gives asp 15 of 2011, and that is recorded with the same citation.

**Fingerprints.** Before: sha256
`c0d386c125641a6e5ebdc697b437c64b3bf0a2fb6c3ac78ded9733126c688999`. After the
ten names: `ac252a95b56e5d501d7c791e76af02fc1e1313697f4c5f61e0ec5aa8f8f50315`.
After the Criminal Procedure date:
`e04dc54042292e2b1f4bc9ea23a481d88f240adac587d68d38134d431c38ea75`. The
Corrections sheet in the workbook carries all eleven with what each was checked
against. **Closure-test item 19 for Sessions 1 and 2 is the one this moves**,
and it is the only thing about those sessions that reopens.

**The order was deliberate, and is why the fingerprint moved twice.** Names
first, because a name cannot hide a date disagreement; then the comparison,
which recorded all three disagreements against the bills; then the rulings and
their citations; then the date. Correcting the date first would have made the
disagreement vanish before anything recorded that it had existed, and that
record is what the citation hangs on. Running the comparison again now finds all
62 paired and no differences at all; the `Differs:` lines stay on the three
bills beside the `Checked:` citation that settled each.

**Checked before and after.** Sessions 1 and 2's stage dates come out
byte-identical from the renamed workbook and again from the corrected one —
same checksum all three times, so nothing on the clean sheet moved. Session 3's
load reconciles cell for cell against the factsheet's printed summary.
`db/054` was rehearsed inside a transaction that was thrown away, which is where
a wrong column name was caught, and applied only after it ran clean.

**Not done, and waiting for the owner:** five fallen bills need a reason from
the Official Report — Autism, Budget (No.2), Creative Scotland, End of Life
Assistance and Protection of Workers. Two more fell on the day the session ended
and are already proposed as such. That is the only thing the error checker still
reports.

**One thing left unbuilt and named here so it is not lost.** When the comparison
could not pair those ten bills, it still recorded all 62 as compared. It says so
loudly on screen, and the tool that loads stage dates refuses outright on an
unpaired bill, so nothing was written wrongly — but a bill that was never
compared should not be able to look compared. Nothing in Session 3 now depends
on it. Decide it when a bill turns up that the dataset genuinely does not cover,
which has not happened yet, so that both tools get the same answer at once.

---

## 2026-09-12 — Sessions 1 and 2 are closed, and what the clean sheet has to prove

Sign-off 8 given by the owner: that they can explain how this database works
from the documents alone, without help. All eight sign-offs are now given and
**Sessions 1 and 2 are closed.** Recorded against the item in
`CLOSURE-TESTS.md`, which is where a sign-off lives.

**What confidence in the clean sheet rests on, settled by the owner.** This is
the conversation `STATE.md` was holding open, and the owner answered it before
it was put to them. In their words: "The biggest test of all will come at the
end when we've ingested material from all 7 sessions and we create charts and
tables and we see whether they match what I created by hand off my PhD."

That sets what finished means for the whole first piece of work, not for a
session. No session's closure test is evidence that the dataset is right; each
one is evidence that what a document says reached the clean sheet unaltered and
that anyone checking a cell can see what said so. Whether the answers are right
is settled once, at the end, against work the owner did independently and
before this database existed — which is why that comparison is worth more than
any check made inside the database against itself. Nothing about the order of
work changes; what changes is that the end of the seventh session is now a
named test with a stated expectation, rather than the point at which the
ingesting stops.

**A closure test inherits.** Also the owner's, in the same breath: a session's
test covers what that session brought in, and the corrections made for it. It
does not put again what an earlier session's test settled — the Sessions 1 and
2 corrections are not re-argued when Session 3 is loaded — unless something has
actually changed. So each test now says which of its items an outside change
can move. For Sessions 1 and 2 there is exactly one: the fingerprint of the
PhD dataset file. Adjudicating one of the three Session 3 disagreements may
correct that file, and the fingerprint moves when it does; that item is then
checked again and nothing else is reopened.

**Why it is worth writing down.** Without the rule, every session's test grows
by the length of the last one and eventually nobody runs it. With it, a test
stays the size of the session it covers, and the one route by which an old
answer can go stale is named rather than left to be remembered.

---

## 2026-09-12 — Three notes say what a reader needs, and one of them was wrong

Found by the owner, reading M1 to M8 in full for the closure test's seventh
sign-off. They asked for the verbatim text rather than the summary offered,
because the notes are what a reader of the published data sees. That is the
reason the error was found: it is invisible in a summary.

**What was wrong. M8 said the date of Royal Assent "is taken from
legislation.gov.uk".** That states which source settles a disagreement. It reads
as a statement of where the dates came from, and as that it is false: eight of
the 128 Acts in Sessions 1 and 2 have been checked there, and the other 120
stand on the fact sheet and have never been looked at individually. The note
corrected itself two paragraphs later, which is not good enough for a sentence a
reader meets first.

**Now it separates the two.** Royal Assent is definitive on legislation.gov.uk
and any disagreement about it is settled there; most Royal Assent dates here
have not been checked against it individually, they stand on the fact sheet, and
a date that has been checked says so.

**The same paragraph the owner proposed deleting is what makes that true.** They
asked whether the "Two things follow" paragraph was necessary. It is: it is the
only place that tells a reader how to spot a checked date from an unchecked one,
and without it the first paragraph's claim about legislation.gov.uk stands
uncorrected. Kept, cut from four sentences to two.

**The other three changes.** M4 reads "Only one has ever been introduced" rather
than "One has ever been introduced". M7 loses the sentence describing which part
of our machinery makes the dissolution comparison — the owner: it "reads like one
of your jargon discussions with me and will leave researchers confused" — and
keeps, in plainer words, the warning that an uncoded session's fallen bills show
under a general code and that is not a finding. M8 loses the count of thirteen
disagreements, which would need rewriting every session and which the per-date
sources already let a reader work out.

**What did not change.** No column, no value, no bill's coding, no note added or
removed. Eight notes before and eight after. Nothing on the staging sheet,
nothing promotion carries, nothing the error checker tests differently, and no
bill needed rechecking: the notes describe what was already done.

**`db/053`, and how it refuses.** Each change replaces an anchor that must be
present exactly once, so a note whose wording has moved on stops the migration
instead of being quietly rewritten. It then requires eight notes, none empty, the
three new sentences present, and none of the removed wording still anywhere.
Rehearsed in a transaction that was thrown away, and three planted failures all
caught and nothing written: an anchor already edited away, a ninth note present,
and an anchor appearing twice. The undo is mechanical — the migration records
exactly what was replaced with what.

**Where a sign-off is recorded.** In `CLOSURE-TESTS.md`, against the item, on the
day it is given. It was being kept in `STATE.md`, which is cut back every
session.

---

## 2026-09-12 — Why a bill fell is worked out where the dates are, not in the reader

**Found by running the closure test, and the entry below is why it matters.**
That entry, written earlier the same day, is titled "the day each session ended
is data, not a command-line argument". It put every session's last day into the
data with its source, and made the error checker use it. It did not change
`tools/extract_factsheet.py`, which was the half that made the coding. So the
reader still took `--dissolution` on the command line and still decided, from a
date recorded nowhere, that seven bills had run out of time.

**What that cost.** Item 18 of `CLOSURE-TESTS.md` asks for the fact sheets to be
read again and compared against the staging sheet, which is how a change to the
reader is caught. Run as written — the PDF and nothing else — it failed on those
seven bills. The coding was not wrong; it could not be reproduced from the fact
sheet, because it never came from the fact sheet alone.

**Considered and rejected: hand the reader the date from the database.** The
smaller change. The reader's worth is that it opens one PDF and needs nothing
else, so the same document yields the same rows on the Mac and on the VPS — the
argument the pinned environment in `tools/requirements.txt` exists to protect,
and what makes "it reconciles" mean anything. Giving it a database connection
spends that to save a step.

**Decided: the reader stops deciding.** No fact sheet says why a bill fell, so
the reader records what the fact sheet says — this bill fell, on this date — and
leaves the outcome empty. `tools/load_session.sql` then proposes
`fell_dissolution` for a line that concluded on the day its session ended, and
leaves every other fallen line for review. Still a proposal a person reviews.
The instrument the entry below chose is right; its position was not, and this
narrows that entry to that extent.

**Where the proposal sits in the loading order.** After the check that the CSV
arrived on the staging sheet unchanged, not before. So "the reader's rows came
through verbatim" is proved against the CSV first, and our coding is added to
them afterwards, visibly.

**What the seven bills gained: a note each.** They had none. The eleven Stage 1
rejections each carried a provenance note citing the Official Report, while the
seven carried nothing at all — the coding of a fallen bill looked like something
the legislation fact sheet had said, and the legislation fact sheet never says
it. Each now carries a note on its outcome, citing the same document, page and
reading date as its session's last day, and giving the rule in words.
`value_seen` is empty, because no source printed these words.

**What nothing changes.** No column, no new value, no bill's coding. The same
seven bills, from the same two dates. `db/051` proves it rather than asserting
it: it takes the old reader's answer off those lines, applies the new rule in
its place, and refuses to go on unless the same seven come back.

**What is refused now.** Promotion will not put a bill on the clean sheet as
having fallen at dissolution without that note, or on a day that is not its
session's last. The error checker's rule from `db/049` also stops going quiet
where a session has no last day recorded: Session 7 is still running, so a bill
of its coded that way would have been checked against nothing and would then
have reached promotion with no date to cite.

**An empty outcome still means nothing but "not yet coded"**, and the error
checker still refuses to let a line be accepted that way. Nothing is inferred
from silence; the entry below settled that and it is untouched.

**`db/052` is separate and should not have been.** The two `outcome` columns'
descriptions still described the old behaviour after `db/051` was applied. The
data dictionary is what lets the owner be the check on every claim here, so a
description of behaviour that no longer exists is not a tidiness problem. It is
its own migration because `db/051` had already been run, and a migration file
has to be what was actually run.

---

## 2026-09-12 — The day each session ended is data, not a command-line argument

**The problem, found while running the closure test.** `tools/extract_factsheet.py`
takes `--dissolution`. A bill in a factsheet's "fallen" table whose final date
matches it is proposed as having run out of time; every other fallen bill is
flagged for review. Seven bills in Sessions 1 and 2 carry that coding. The date
was typed on a command line each run, taken from a note in `FACTSHEET-SURVEY.md`
quoting page 1 of a different document, and recorded nowhere. The closure test
written the same day listed this among the things it could not check: "no
dissolution date is recorded anywhere in the database."

**The source, supplied by the owner.** SPICe, "Dates of recess, dissolution,
parliamentary years and recalls of Parliament", published 2 September 2026. It
states a start and an end for every session, including Session 6's end and
Session 7's start, which no legislation factsheet gives. It also defines the
term: "Dissolution is the official term for the end of a session."

Checked against two others before it was used. `data.parliament.scot/api/sessions`
gives Sessions 1 to 6 and agrees on all six first meetings and all five ends it
states; it knows nothing of Session 7 and gives no end for Session 6, so it
could not have supplied two of the thirteen dates. Page 1 of each legislation
factsheet agrees for Sessions 1 to 5. Three sources, no disagreement to settle.
**The agreement is recorded in `db/048` and here, and not as a second provenance
row per date.** This slice has no need to tell corroboration apart from revision
in the data, and inventing a way to do so would be schema nobody asked for.

**The column is renamed `date_session_end`.** The source puts Session 1's
dissolution *period* at 1 April to 1 May 2003, beginning at midnight on 31
March. So the last day the Parliament existed is 31 March and dissolution takes
effect from 1 April: two different dates. The value this project wants — the one
the coding already used, and the one all seven fallen bills concluded on — is
the session's last day. `date_dissolution` holding 31 March would contradict the
document it came from. The relationship holds for every session, Session 5
included: it ended 4 May 2021 and dissolution was 5 May.

**Session 5 is the odd one and the reason is recorded on its row.** Its last day
is two days before the poll rather than five or six weeks. The owner: this was a
Covid measure, to minimise the period in which the Parliament could not be
recalled. SPICe's document says the same — a "campaign recess" from 25 March
2021 instead of dissolution. It is not a data fault and a later session should
not try to correct it.

**Two families of SPICe factsheet, named apart (`db/047`).** `spice_factsheet`
needed no qualifier while there was only one. It becomes
`spice_factsheet_legislation`, and the new document is `spice_factsheet_dates`.
564 rows carried the old name. The owner accepted the cost on the reasoning that
it only grows: every session loaded from here would add to it, and SPICe
publishes many factsheets.

**What the checker now requires (`db/049`).** A bill coded as having fallen at
dissolution must have concluded on its session's last day. The stated limit in
`CLOSURE-TESTS.md` is struck.

**What it deliberately does not require, and why.** Not the converse: a fallen
bill that concluded on the last day is *not* required to be coded
`fell_dissolution`. A bill can be rejected at Stage 1 on the final sitting day,
and a rule nobody could satisfy is worse than no rule. That direction stays
where it belongs — a proposal the reader makes and a person reviews.

**Nothing is inferred from silence.** The owner asked whether a bill with no
recorded outcome by the session's end should be tagged as having fallen at
dissolution. No. The factsheets say which bills fell; only *why* is ours to work
out. An empty outcome means not yet coded, and three kinds of bill would be
miscoded by any rule reading it otherwise: one that passed and awaits Royal
Assent (Session 5 has three), one whose assent was blocked — which by the
decision of 2026-09-10 does not fall at dissolution — and one not yet reached.

**What a reader is told (`db/050`).** M7 stated a conclusion resting on a date
that was not in the data; it now states the dates and their source. M8 stated an
honest negative and never the available positive: the owner confirms the PhD
dataset was compiled from the ground up and is independent of the factsheets,
and since the corrections of this day the two agree on every introduction date
and every Royal Assent date in both sessions. M8 now says so, and says plainly
that agreement between two independent records is weaker than checking the Act
and stronger than one source alone.

**Considered and not built: a parliamentary dates tab.** The owner asked whether
the session dates, recess dates and recalls justified a table of their own, on a
thematic reading. They do not, by the rule the owner settled on 2026-09-11: *a
tab is cut by what one row stands for, not by topic*, and that entry says in as
many words that dates are not one theme. A session's start and end is one row
per session, which is what the session tab is. A recess is one row per period,
so recesses will get their own tab when sitting days become a variable and it
has work to do — by the same rule, not by an exception to it.

**Sequencing, settled with the owner.** This changes data in Sessions 1 and 2,
which are the sessions sitting in a closure test, and two of that test's
expected answers named the source by its old name. So the test could not be
signed off first; the expected answers were corrected and the mechanical half
re-run after this work, and the owner's seven sign-offs move behind it. The
owner's further decision: because this session did the work, **a different
session runs the final checks before any Session 3 work begins.** That is the
same rule that produced the closure test.

---

## 2026-09-12 — The working dataset is corrected, and a closure test is written for someone else to run

**The working copy of the dataset is corrected**, at the owner's instruction.
The owner's own original, which backs the 2021 thesis, is held separately and is
untouched; the copy in `sources/phd/` is the live working version and is treated
as such.

Nine corrections, each checked by the owner against the source that owns it —
legislation.gov.uk for Royal Assent, the Parliament's own bill page for other
dates. Eight dates and one name:

| Dataset row | Bill | Field | Was | Now |
|---|---|---|---|---|
| 6 | Adults with Incapacity 2000 | Stage 3 vote | 2000-03-28 | 2000-03-29 |
| 6 | Adults with Incapacity 2000 | Royal Assent | 2000-05-19 | 2000-05-09 |
| 19 | Transport 2001 | Royal Assent | 2001-01-23 | 2001-01-25 |
| 28 | International Criminal Court 2001 | Introduction | 2001-04-05 | 2001-04-04 |
| 36 | Water Industry 2002 | Introduction | 2001-09-25 | 2001-09-26 |
| 60 | Robin Rigg (Session 1) | Introduction | 2002-02-27 | 2002-06-27 |
| 95 | Emergency Workers 2005 | Name | Government Workers (Scotland) Act 2005 | Emergency Workers (Scotland) Act 2005 |
| 134 | Tourist Boards 2006 | Royal Assent | 2006-11-29 | 2006-11-30 |
| 139 | Senior Judiciary | Introduction | 2006-06-13 | 2006-06-15 |

**Fingerprints.** Before: sha256
`a201a07a87b3fd91658855c05d6ac20b8ff91d22cbf34cefc1afdc17ef7eac01` — the
version the Stage 1 and Stage 2 dates now on the clean sheet were loaded from,
which is why it is kept. After: sha256
`c0d386c125641a6e5ebdc697b437c64b3bf0a2fb6c3ac78ded9733126c688999`.

A **Corrections** sheet in the workbook records each change, what it was checked
against, and why. The file has one data sheet and no formulas, so nothing was
lost in rewriting it.

**Checked:** exactly nine cells differ from the copy taken beforehand and
nothing else; `tools/phd_stage_dates.py` produces byte-identical output, so no
stage date on the clean sheet is affected; and `tools/compare_sources.py` now
finds **no differences at all** between the factsheet and the dataset for either
session. The `Differs:` lines stay on the seven staging lines beside the
citation that settled each, because they record that a disagreement existed and
how it was resolved.

**A closure test is written and deliberately not run.** `docs/CLOSURE-TESTS.md`
and `tools/closure_check_sessions_1_2.sql`, written by the session that did the
work, to be run by a different one. The procedure the owner set: the session
proposing that an ingest is finished writes the test and does not mark it;
another session runs it; every item is either mechanically checkable or the
owner's sign-off, with nothing left to anyone's judgement about whether
something is good enough. Two rules this session added because of how it failed:
every expected answer says where the expectation comes from, since an
expectation taken from the database under test proves nothing; and every test
states what it does not check.

Twenty-one mechanical checks, eight sign-offs for the owner, and five stated
limits — among them that 120 Royal Assent dates and 150 introduction dates have
never been checked against anything, and that "fell at dissolution" cannot be
re-derived from the database because no dissolution date is recorded in it.

---

## 2026-09-12 — A type disagreement is a research question; the thesis is 2021

Settled by the owner and built the same day: `db/045`, and changes to
`tools/compare_sources.py`, `tools/phd_stage_dates.py` and
`tools/promote_session.sql`.

**Bill type is compared between sources.** It is half of the first question this
data answers — what happened to each bill, by bill type — so two sources
disagreeing about what kind of bill it was is a research question, not a detail.
Until now it came out as the stage-date loader refusing to pair the bill at all,
which stopped the session with a message about plumbing. It is now recorded as a
difference like any other, and the error checker refuses to let it past without
the matching citation.

The stage-date loader still refuses to pair a bill whose type is disputed and
not yet adjudicated, because attaching one bill's stage dates to another is the
harm being guarded against. Once the line carries the adjudication, the pairing
stands and the dates load. Proved end to end on a planted row and thrown away:
flagged, adjudicated, and the clean sheet carried `bill_type` from `bill_page`
with the value `government`, which also proved a citation whose value is not a
date.

**Which source settles a type disagreement is not decided**, because there has
never been one. It is decided when the first case arrives, on the precedent of
2026-09-11 for the order between sources. The Parliament's own bill page is the
obvious candidate and is deliberately not assumed.

**The owner considered and rejected a wider check.** Comparing the titles the
two sources give, and showing which pairings were made by hand, were both put to
the owner and dropped. The evidence against them: of the 18 bills paired by a
hand-written list in `tools/phd_stage_dates.py`, 15 passed and so are confirmed
by three dates agreeing — introduction, passing and Royal Assent — and the other
3 take no data from the dataset at all, so a wrong pairing among them would
carry nothing onto the clean sheet. The session had pitched the risk higher than
it was.

**The thesis is 2021, published April 2021.** The "final for submission –
25 February 2022" heading on the copy held on the server is the submission
draft. M2 already cited 2021; M8, written earlier the same day, said "the 2022
PhD dataset" and is corrected. This closes the open question.

**Built the same day, in `db/046`: the rule for a motion that passes and causes
the bill to fall.** The owner chose, from three options, and approved the
wording.

Every route is now defined by **what the Parliament decided about the bill's
general principles**, not by what happened to the motion, and each definition
opens with the decision before saying how it was reached. That is the substance
of the change: the Proportional Representation (Local Government Elections)
(Scotland) Bill's motion was agreed to and its general principles fell, and any
rule keyed on the fate of the motion will eventually read "motion agreed to" as
"bill progressed". Its own definition now says so in as many words — "the motion
passed and the general principles fell, so the fate of the motion and the fate
of the bill point opposite ways".

There is also **one open route** for a path nobody has anticipated, so that an
odd bill can be recorded truthfully instead of stopping a session until someone
writes a new code. It is the one route that cannot stand on its code alone: the
Presiding Officer's announcement is required of every route already, and the
error checker also requires a note saying what happened and what its effect was.
A second case of the same kind earns its own entry rather than staying there.
Rehearsed and thrown away: the open route without a note is refused, and with
one it passes.

No bill changed its route — the eleven keep 8, 1 and 2 as before — and the clean
sheet is untouched: 154 bills, 413 stage records, 36 notes, checker empty, no
gaps. What changed is the words a reader is given.

---

## 2026-09-12 — Each date comes from the source that owns it, and a checked date says so

Settled by the owner and built the same day: `db/042`, `db/043`, a change to
`tools/promote_session.sql`, and methodology note M8.

**The principle, in the owner's words:** "I'm happy to use the leg.gov.uk or
parliament website as authoritative so that provenance can be traced there (even
if wrong) rather than a more opaque phd dataset." And: "the main thing is that
people can understand where data came from rather than whether it is 100%
guaranteed correct (because that will never be possible)."

**The order.** Not a flat ranking. The factsheet is definitive by default, and
is displaced only where a better source has actually been checked:

| Source | Definitive for |
|---|---|
| legislation.gov.uk | the date of Royal Assent |
| the Parliament's bill pages, and the Official Report | every other date |
| the SPICe factsheet | anything not yet checked against those |
| the PhD dataset | where nothing else says, and nothing contradicts it |

The Explanatory Notes published with an Act carry a "Parliamentary passage"
section giving key dates. Recorded as a possible future cross-reference and
**not** definitive: they are written by government civil servants rather than
parliamentary officials.

**Each kind of record is named for what it is**, not for the site it sits on,
following `official_report` which is also on the Parliament's website. So
`bill_page`, not `parliament_website_bill_page`; the address of the particular
page goes in the reference on each row, and a bill with more than one relevant
page gets one row per page, archived copies included. The estate grows the same
way if minutes of proceedings or anything else earns a place. `bill_document`
was holding fifteen bill-page citations its own description did not cover; they
moved, and it now holds nothing, which its description says and why — it keeps
its meaning and is where Explanatory Notes would land, deliberately apart from
the pages the owner made definitive.

**A date cannot be overridden silently.** The error checker requires a date that
differs from the factsheet's own printed words to carry a citation in a fixed
form: `Checked: <column> = <date> (<source>, <address>, <date read>)`. Loose
prose does not satisfy it; both were rehearsed. Promotion turns those citations
into per-cell provenance.

**Confirmed dates get a note too, not only corrected ones.** The owner: "if
checked i think we would ideally say that and show how, because this might
become relevant if we start programatically checking factsheet data later."
What the note records is that somebody looked. A date with no note carries the
source of the row it sits on and nobody has checked it individually — the two
look alike in the data and are told apart by the source recorded against them.

**The thirteen, adjudicated.** Eight confirmed the factsheet; five did not, and
every one of those five was a Royal Assent date: Protection from Abuse
(7 November 2001 → 6 November), School Education (Amendment) and Scottish Local
Government (Elections) (both 23 January 2002 → 22 January), Transport and Works
(15 March 2007 → 14 March), and Rights of Relatives to Damages (Mesothelioma)
(16 April 2007 → 26 April).

**An earlier reading, withdrawn.** The session suggested the cluster of
one-day differences looked like a difference in which day of the process each
source records, rather than error. It is not: the differences run both ways,
the factsheet a day late four times and the dataset a day out three times. Both
sources are simply wrong in places, which is a better argument for the gate than
the theory was.

**What it did to the figures**, which the owner asked to be checked. The time
from introduction to passing does not move for a single bill. The only measure
that moves is the time from passing to Royal Assent, for the five bills whose
assent date was wrong: one day each except the Mesothelioma Act, 26 days to 36.
In the summary that is two groups — Session 1 committee bills, and Session 2
government bills, whose mean goes from 36 days to 37.

**What is recorded as not done.** Only dates where two sources actually
disagreed have been checked. Nothing here says the factsheets have been verified
generally, and M8 says so to a reader. Checking every Royal Assent date against
legislation.gov.uk is possible and is not done.

**Still open:** the three Session 3 disagreements, which wait until Session 3 is
loaded; and the comparison that produces the disagreement list at load, which is
the reusable half and is needed before Session 3 goes on the clean sheet.

---

## 2026-09-12 — The two-source approach checked, and the hole it showed

The check the owner asked for before Session 3 is loaded, run against what was
already built. Four of its five parts passed. The fifth did not, and the owner
settled how it is to be handled; that part is **not yet built** and is the first
task of the next session.

**What passed.**

- **Four bills traced cell by cell**, one of each kind. Every cell names what
  said so and when. The Smoking, Health and Social Care Act 2005 holds its row
  from the Session 2 factsheet read 2026-09-10, Stage 1 and Stage 2 from the PhD
  dataset row 107 read 2026-09-11, and Stage 3 from the factsheet.
- **The order of precedence held in every case**: all 128 passing dates came
  from a factsheet and none from the PhD dataset; all 11 Stage 1 rejection dates
  came from the Official Report and none from the PhD dataset. No stage anywhere
  takes the dataset's date where a more primary source gave the same stage.
- **The machinery was tested, not just the outcome.** It had never been
  exercised: no stage in the database has two rows, so nothing had ever
  competed. Rows were planted and thrown away. Dates that disagree are flagged
  by the error checker from both sides, naming the stage, both sources and both
  dates. Dates that agree promote the factsheet's row and leave the PhD row on
  the staging sheet marked as not carried. A source with no settled place in the
  order makes promotion refuse outright and write nothing. The database was
  unchanged afterwards: 154 bills, 413 stage records, 23 notes.
- **Session 3's Hybrid Bill passes.** Both sources agree on the Forth Crossing
  Act's introduction, passing and Royal Assent, and both call it Hybrid; the
  dataset supplies Stage 1 (2010-05-26) and Stage 2 (2010-11-17). Only the
  factsheet's summary counts it under Executive, and reconciling on government
  plus hybrid gives its 45. All 62 of the factsheet's Session 3 bills pair one
  to one with the dataset's 62.

**What failed: a disagreement between sources is not recorded for every kind of
date.** The entry of 2026-09-11 says a disagreement is recorded rather than
silently resolved. That is true of stage dates, where every source's date sits
on the staging sheet as its own row and the checker refuses the session until
they agree. It is not true of a bill's own dates. Introduction, passing and
Royal Assent are single cells on the bill's row, with nowhere for a second
source's value to sit, so the factsheet's is held and the dataset's is not
stored anywhere. Sixteen dates are in that state: 8 Royal Assent, 4 introduction
and 1 passing date in Sessions 1 and 2, and 3 more in Session 3. They exist only
in `sources/phd/checks-before-loading-sessions-1-2.xlsx`, which is not
published, and in the 2026-09-11 entry as counts. They are, factsheet first and
the PhD dataset second:

| Session | Bill | What differs | Factsheet | PhD dataset |
|---|---|---|---|---|
| 1 | Adults with Incapacity 2000 | Royal Assent | 2000-05-09 | 2000-05-19 |
| 1 | Adults with Incapacity 2000 | passing | 2000-03-29 | 2000-03-28 |
| 1 | Transport 2001 | Royal Assent | 2001-01-25 | 2001-01-23 |
| 1 | Protection from Abuse 2001 | Royal Assent | 2001-11-07 | 2001-11-06 |
| 1 | School Education (Amendment) 2002 | Royal Assent | 2002-01-23 | 2002-01-22 |
| 1 | Scottish Local Government (Elections) 2002 | Royal Assent | 2002-01-23 | 2002-01-22 |
| 1 | International Criminal Court 2001 | introduction | 2001-04-04 | 2001-04-05 |
| 1 | Water Industry 2002 | introduction | 2001-09-26 | 2001-09-25 |
| 1 | Robin Rigg (the Session 1 bill) | introduction | 2002-06-27 | 2002-02-27 |
| 2 | Tourist Boards 2006 | Royal Assent | 2006-11-30 | 2006-11-29 |
| 2 | Transport and Works 2007 | Royal Assent | 2007-03-15 | 2007-03-14 |
| 2 | Rights of Relatives to Damages (Mesothelioma) 2007 | Royal Assent | 2007-04-16 | 2007-04-26 |
| 2 | Senior Judiciary (Vacancies and Incapacity) | introduction | 2006-06-15 | 2006-06-13 |
| 3 | Double Jeopardy 2011 | Royal Assent | 2011-04-28 | 2011-04-27 |
| 3 | Forced Marriage etc. 2011 | Royal Assent | 2011-04-28 | 2011-04-27 |
| 3 | Criminal Procedure (Legal Assistance, Detention and Appeals) 2010 | introduction | 2010-10-27 | 2010-10-26 |

Eleven of the sixteen are exactly one day apart, and the two Session 3 Royal
Assents are the same pair of days as each other, which clusters more like a
difference in which day of the process each source records than like sixteen
separate slips. Two are ten days apart and one is a month. The owner adjudicates
each; that reading is theirs to make, not ours.

Two further differences were found at the same time and are not date
contradictions: the dataset has no Stage 1 date for the Cairngorms National Park
Boundary Bill, where the Official Report gives one, and it names the Emergency
Workers (Scotland) Act 2005 as the Government Workers (Scotland) Act 2005.

**Settled by the owner: the contradiction is resolved at the gate, not stored.**
The owner's route, which is cleaner than storing the losing value: they check
each disagreeing date against a definitive source and adjudicate it, and the
source data is then corrected so the two agree. Nothing contradictory ever
reaches the clean sheet, so there is nothing to store.

- Where only the PhD dataset is wrong — the owner's expectation for most of the
  sixteen — **there is no database work at all**. The clean sheet already holds
  the factsheet's date, and the dataset's introduction, passing and Royal Assent
  columns were never loaded; only Stage 1 and Stage 2 were.
- Where the factsheet is wrong, the clean sheet holds the wrong date and the
  correction runs the other way, through the promotion runbook.
- **The adjudication is recorded, not only its answer**: what was checked,
  what it said, and when. Otherwise the contradiction is resolved and the
  evidence for the resolution is thrown away.
- **The dataset file's fingerprint is re-recorded** if the owner edits it, with
  the fingerprint of the version the Stage 1 and Stage 2 dates came from kept.

**Why it is worth building properly.** In the owner's words, "i think we are
going to see more situations where we can triangulate with multiple data sets
and so having a methodology for handling that, and resolving disagreements, will
likely be reusable as we expand the dataset". The gate is not about the PhD
dataset: it is about any two sources that both state the same fact. The
Parliament's own pages are the next source through the same door, and the owner
expects them to allow a sanity check of the Stage 1 and Stage 2 dates once all
sessions are ingested.

**What is not settled, and is not to be started before it is.** What exactly is
compared and when; what happens on each outcome; where the record of an
adjudication lives; what the methodology note tells a reader; and the place of
the Parliament's own pages in the order of precedence, which today's test showed
is a wall rather than a gate — promotion stops dead if two unranked sources
disagree. The whole is to be laid out with a proposal for each part and agreed
before anything is built, and built before Session 3 goes on the clean sheet.

---

## 2026-09-12 — What the PhD dataset covers, corrected by the owner

`db/041`, and corrections to `STATE.md` and the entry below.

**What was wrong.** Methodology note M2, written at `db/033`, said the dataset
"covers Sessions 1 to 6". The session then repeated it, and added that Session 7
would have no stage dates. Both were wrong, and the second was contradicted by
the file itself, which the session had already read.

**The owner's correction.** The published thesis covers Sessions 1 to 5. Data
collection continued after it, and the dataset now covers Sessions 6 and 7 as
well. The file supplied on 2026-09-11 holds 469 bills across all seven sessions,
the latest introduced on 9 September 2026. A bill has no Stage 1 or Stage 2
date in it only where it has not yet reached that stage: Session 7's single
bill, and five in Session 6.

**Why it matters beyond the wording.** M2 is published beside the figures, so it
is a claim about the evidence. It also sets what to expect when Sessions 3 to 7
are loaded: the dataset should supply Stage 1 and Stage 2 for every bill that
has reached those stages, and a missing date is a question about that bill, not
about the dataset's span.

---

## 2026-09-12 — Postico's login owns every tab

`db/040`. Five pivot tables — stage dates and durations per bill, total
durations, outcome by type, and the duration summary — belonged to the
administrator, so the owner could not open the very tables the stage dates
filled. All 26 tabs now belong to `legdata`. No data changed.

**The rule this repairs, which stands:** migrations run as the administrator,
and whatever they create belongs to it unless told otherwise. Any migration
that creates something sets its owner.

---

## 2026-09-11 — Sessions 3 to 7: the factsheet is the first source, the PhD dataset backfills the stage dates

Settled by the owner at the close of the session, for the sessions still to
load. It states the practice that Sessions 1 and 2 established, so that it is
not rediscovered each time.

- **The SPICe factsheet is the principal source, and the first one read.** It
  establishes which bills there were, what happened to each, and the dates it
  prints: introduction, passing and Royal Assent. A session is reconciled
  against the factsheet's own summary before anything else happens.
- **The owner's PhD dataset backfills the Stage 1 and Stage 2 dates**, which no
  factsheet gives. Its Stage 3 and Royal Assent dates are not loaded. **It is
  current, not limited to the thesis's own span**: the file supplied on
  2026-09-11 holds 469 bills across all seven sessions, the latest introduced on
  9 September 2026. A bill lacks stage dates in it only where it has not reached
  that stage: Session 7's single bill, introduced 9 September 2026, and five
  Session 6 bills still awaiting Stage 1. Methodology note M2 still describes
  the dataset as covering Sessions 1 to 6, which was written from the thesis's
  own scope at `db/033` and is to be corrected with the owner.
- **Where neither source says, the Official Report and the Parliament's bill
  pages fill it**: an outcome the factsheet does not give, the date of a Stage 1
  rejection, and where a bill that did not pass stopped. Sessions 1 and 2 needed
  all three.
- **Where two sources give the same thing**, the clean sheet takes the Official
  Report's, then the factsheet's, then the PhD dataset's, as settled earlier
  today. The other stays on the staging sheet as the check.
- **A disagreement between sources is recorded, not silently resolved.** The
  four introduction dates and eight Royal Assent dates where the dataset differs
  from the factsheet are listed for the owner, and the factsheet's remain on the
  clean sheet until the owner says otherwise.

**Checked before it is used at scale.** At the owner's request, the next session
tests this on what is already built before Session 3 is loaded: a few bills
traced cell by cell to a source, the order of precedence shown to have held, the
recorded disagreements shown to be visible, the rule tested against Session 3's
Hybrid Bill, and a statement of what it does not yet cover — the API, a revised
published record, and bills appearing in two factsheets. It was settled and
applied in a single day, which is the reason for testing it before four more
sessions rest on it.

---

## 2026-09-11 — Only a Private Bill may skip a stage, and a skipped stage is recorded as one that did not happen

Settled by the owner and built the same day: `db/039`.

**How it came up.** With the dates in, the Session 2 Robin Rigg Act showed two
dates still to find that do not exist. A Private Bill reintroduced after
falling does not repeat its earlier scrutiny, so that bill went straight to its
Final Stage. Recording that only in a note left the gaps list claiming work that
cannot be done.

**Decided.** A stage record can say the bill never had this stage. The owner
chose this over teaching the gaps list to expect less: the fact is then in the
data, where anything counting stages can see it, rather than in prose.

**Only Private Bills.** In the owner's words, that is the only exception the
Standing Orders make: no other kind of bill can skip a stage. So the clean sheet
refuses the mark on a Government, Member's, Committee or Hybrid Bill outright,
as it already refuses a Stage 2 on a Private Bill, and the error checker flags
it on the staging sheet before promotion.

**What it records.** No date, not completed, not where the bill ended, and a
note saying why; the clean sheet refuses any other shape. The gaps list stops
expecting a date for such a stage. M2 tells a reader that a stage that never
happened gives no duration, so the bill gives a time from introduction to
passing but no figure for that stage.

**Where it applies today.** One bill, the Session 2 Robin Rigg Act, from the
page the owner read. Every other bill in Sessions 1 and 2 was checked against
the same test, and none is in that position.

**Rehearsed, thrown away, then run.** Four mistakes were refused by the clean
sheet: a skipped stage on a Government Bill, one with a date, one without a
note, and one also marked completed. The same mistakes on the staging sheet
were flagged, not refused.

---

## 2026-09-11 — The PhD stage dates are loaded from the owner's own spreadsheet, after the owner checks sixteen bills

Settled by the owner, after typing two practice rows. **Changes the entry
below** for the bulk of the dates: they are not typed. Postico stays the way to
correct a single row. Nothing is built by this entry.

**How it came up.** The owner asked whether a sheet of their own, ingested by
the session, would be less error-prone and a quicker way to reuse the PhD
data, and supplied the raw dataset: `Billdates-September2026.xlsx`, one line
per bill for Sessions 1 to 7, with introduction, Stage 1 vote, Stage 2
completed, Stage 3 vote and Royal Assent.

**Matched, not yet loaded.** All 154 Session 1 and 2 bills pair one to one with
the staging lines: 133 on exact name and introduction date, 21 more whose names
differ only in wording, each confirmed by its dates. Stage 3 agrees with the
factsheet for every passed bill but one; 10 of the 11 Official Report Stage 1
dates agree, and the eleventh is blank in the dataset. The two practice rows
match it exactly.

**Settled:**
1. **The dataset is not published.** It sits in `sources/phd/` for the
   session's use, and spreadsheets there are ignored by the repository. What was
   used is recorded by name and fingerprint: sha256
   `a201a07a87b3fd91658855c05d6ac20b8ff91d22cbf34cefc1afdc17ef7eac01`.
2. **Only Stage 1 and Stage 2 are loaded.** Stage 3 stays the factsheet's. The
   dataset's Stage 3 and Royal Assent dates are not loaded as checks.
3. **Date read 2026-09-11 on every row, reference "PhD thesis dataset, row N"**,
   the row of the owner's spreadsheet.
4. **Every issue is settled before anything is loaded.** The owner checks:
   - the fifteen bills that neither passed nor were rejected at Stage 1: where
     each ended, and whether a Stage 1 date in the dataset is a completed stage
     or the day the bill ended;
   - the Session 2 Robin Rigg Act, which passed with no Preliminary or
     Consideration date, and the note that will say why.

   The other disagreements are listed for the owner too: 4 introduction dates,
   8 Royal Assent dates and a passing date that differ from the factsheet, and
   two slips in the dataset. They do not block the load, but the introduction
   and Royal Assent dates are already on the clean sheet. The checklist is
   `sources/phd/checks-before-loading-sessions-1-2.xlsx`, also not published.

**Built and loaded on 2026-09-11**, after the owner answered every question
below. `tools/phd_stage_dates.py` reads the dataset and the answers and writes
the rows; `tools/load_phd_stage_dates.sql` puts them on the stage-dates sheet,
refusing a title that does not match its line number, a row that clashes with
one already held from the same source, a date outside the bill's own dates, and
a line number that does not exist. All four were rehearsed and refused. 270
rows arrived, waiting for the owner's second read; the two practice rows typed
in Postico were skipped as identical. The figures are in the runbook.

The automatic ticks proposed earlier are not needed. The blank templates in
`sources/phd/` are not used by this route.

**Accepted and promoted the same day.** The owner read the rows and was
content. `db/038` admitted all 411, and both sessions were taken off the clean
sheet and put back with the dates, rehearsed once per session and thrown away
first. The clean sheet now holds 411 stage records against 154 bills, the error
checker is empty, and the only dates still to find are the Session 2 Robin Rigg
Act's two, which its note explains. The figures are in the runbook.

**Answered by the owner on 2026-09-11, with the source for each.** These are
the sixteen bills above. Each stage record below carries the page the owner
gave as its source, read on 2026-09-11. No date is recorded on a stage a bill
did not complete, because none of these ended on a decision of the Parliament.

| Line | Bill | Recorded | Source the owner gave |
|---|---|---|---|
| 64 | Family Homes and Homelessness (S1) | stopped at Stage 1, not completed | bill page, withdrawn |
| 141 | Fire Sprinklers in Residential Premises (S2) | stopped at Stage 1, not completed | bill page, withdrawn |
| 142 | Prohibition of Smoking in Regulated Areas (S2) | stopped at Stage 1, not completed | bill page, withdrawn |
| 143 | Prostitution Tolerance Zones (S2) | stopped at Stage 1, not completed | bill page, withdrawn |
| 65 | Tobacco Advertising and Promotion (S1) | stopped at Stage 1, not completed | bill page; withdrawn with no Stage 1 debate |
| 66 | Gaelic Language (S1) | Stage 1 completed 2003-03-06; stopped at Stage 2, not completed | Official Report, 6 March 2003: general principles agreed, no time scheduled for Stage 2 |
| 71 | Robin Rigg (S1) | Preliminary completed 2003-01-09, Consideration completed 2003-03-11; stopped at Final Stage | bill page; fell at dissolution |
| 63 | Education (Graduate Endowment and Student Support) (S1) | stopped at Stage 1, not completed | Official Report of the committee, meeting 2733: withdrawn during Stage 1 consideration, before the vote, and reintroduced redrafted |
| 73 | Stirling-Alloa-Kincardine (S1) | stopped at Preliminary Stage, not completed | bill page |
| 140 | Environmental Levy on Plastic Bags (S2) | stopped at Stage 1, not completed | archived bill page: withdrawn after the Stage 1 report, before the debate |
| 144 | Scottish Register of Tartans (S2) | stopped at Stage 1, not completed | archived bill page |
| 148 | Commissioner for Older People (S2) | stopped at Stage 1, not completed | archived bill page: no timetable for concluding Stage 1 was set |
| 150 | Education (School Meals etc) (S2) | stopped at Stage 1, not completed | archived bill page: partial scrutiny, no Stage 1 vote |
| 152 | Home Energy Efficiency Targets (S2) | stopped at Stage 1, not completed | archived bill page |
| 154 | Treatment of Drug Users (S2) | stopped at Stage 1, not completed | archived bill page |
| 124 | Robin Rigg Act (S2) | no Preliminary or Consideration Stage, with a note | archived bill page: a reintroduced Private Bill does not repeat its earlier scrutiny, so it went straight to the Final Stage vote; the Session 1 bill's Preliminary Stage was 9 January 2003 |

**What this establishes about the dataset.** For a bill that did not pass, the
dataset's "Stage 1 vote" column is not evidence that Stage 1 was completed: for
the four withdrawn bills it holds the day the bill was withdrawn, and for the
Tobacco Advertising Bill a date although there was no Stage 1 debate. So Stage 1
and Stage 2 dates are taken from the dataset for bills that passed, and for the
two cases the owner confirmed (lines 66 and 71). The exact links are on the
staging rows, which carry them as their source.

---

## 2026-09-11 — Stage dates are typed into Postico, not loaded from spreadsheets

Settled by the owner. `db/035`. **Replaces part 4 of the stage-dates decision**
for the owner's PhD dates: the spreadsheets in `sources/phd/` and the script to
load them. That script was the one unbuilt part of the decision, so the
stage-dates change is now built in full.

**How it came up.** Asked what the instructions for entering stage dates should
cover, the owner asked for them in Postico. The conflict with the agreed
spreadsheet route was put first, part by part, and the owner agreed.

**What changes:**
- The owner adds rows straight onto the stage-dates sheet in Postico, one per
  stage. The two blank spreadsheets are deleted, so there is one place to enter.
- **Where a bill ended** is a row for that stage, not completed, and marked as
  where it ended. The stage names allowed are the bill type's own: Stage 1, 2
  or 3, or Preliminary, Consideration or Final.
- **A stage completed on a date not known** is completed, with no date, and a
  note saying why. The spreadsheet's "not known" word goes.
- **Every row carries its own date read.** The owner's reason: sources and
  timescales will not be uniform.
- **The reference is "PhD thesis dataset".** One citation is enough.
- Rows still arrive `new`, and are accepted after the owner reads them a second
  time, recorded in a migration.
- **The practice rows are kept** if they are correct.

**The checks.** Rehearsed as Postico's user with thirteen planted mistakes, and
every one was caught. Refused on saving: a line number that does not exist, the
same stage from the same source twice, an impossible date. Flagged by the error
checker: a stage name wrong for the bill type or position, an empty tick, no
date read, a source not on the list, dates out of order, a date disagreeing
with the Official Report, a stage after where the bill ended.

**What is lost, and what replaces it:**
- **The title check.** The loader would have refused a line number that did not
  match its title. Instead, the sheet shows each row's bill title, filled in
  from the line number, so a wrong line shows as the wrong title.
- **A copy in the repository.** The rows live in the database and its nightly
  backup, and the admission migration records the second read. Accepted by the
  owner.

**Settled with it:**
- **The bill's title on the stage-dates sheet**, beside the line number, asked
  for by the owner to find rows. Filled in automatically when a row is saved,
  and refreshed when a title is corrected on the factsheet sheet. Never typed,
  not a fact under review, and not carried to the clean sheet. The sheet was
  rebuilt to put the column there, and was proved to have changed nothing else.
- **Dates typed with slashes are read day first.** The server read 05/01/2000
  as 1 May; it now reads 5 January. Dates are still shown as 2000-01-05, and
  the instructions say to type them that way.
- A row's last-changed time no longer moves when only its title is refreshed.
- **The stage's position fills itself in from its name** (`db/036`), asked for
  by the owner as a failsafe. Each stage name has one position whatever the
  kind of bill, so the name gives the number, and anything typed there is
  replaced. A real name on the wrong kind of bill, such as Stage 1 on a Private
  Bill, still gets its number, and the checker says it is the wrong name for
  that bill. A mistyped name gets no number, and the checker names it.
- **Postico's login is set to day-first dates** (`db/037`), asked for by the
  owner. It did not change what Postico shows: Postico formats dates itself,
  year first, and the owner is content with that. Dates are typed year first,
  which cannot be misread. The project's scripts were never affected.

---

## 2026-09-11 — Session 2 is promoted before the PhD loader is built

Decided by the owner. `db/034`. **A stated exception** to the rule, set the
same day, that a coding change is finished before any session it touches is
admitted or promoted. The rule stands.

**How it came up.** The owner had checked Session 2 and was content, and
proposed promoting it so the next session could open cleanly onto adding the
stage dates for both sessions. The conflict with the rule was put to the owner
before anything was done, and the owner chose to proceed.

**What is unfinished.** Only the script that loads the owner's PhD spreadsheets
(part 4 of the stage-dates decision). The stage-dates sheet, its checks, the
gaps list, and promotion and rollback from it are built, rehearsed and proved
(`db/033`).

**Why it is safe.** The unbuilt part reads a spreadsheet. It does not decide how
dates are held, checked or promoted, and nothing about Session 2 would be coded
differently once it exists. Session 2 goes onto the clean sheet in the state
Session 1 is already in: passing dates and Stage 1 rejection dates, and no
Stage 1 or 2 dates. Both sessions are taken off and put back when the dates are
added, which `db/033` proved changes nothing it should not.

**What this is not.** A precedent for leaving a decision's parts unbuilt. The
loader is the first task of the next session, and no date is entered until it
is built and rehearsed.

---

## 2026-09-11 — When two sources give the same stage date, the more primary goes onto the clean sheet

Settled by the owner. Built in `db/033` and `tools/promote_session.sql`.

**The question.** Found while laying out the build. The eleven Stage 1
rejections already carry a date from the Official Report, and the owner's PhD
spreadsheet will give one too, as a check. Both wait on the stage-dates
staging sheet. The clean sheet keeps one stage record per stage, with one
source. Which goes onto it when they agree?

**Decided: the Official Report.** In the owner's words, "That is the original
definitive source and we will use it." The PhD row stays on the staging sheet
as the evidence the check was made.

**As a standing order**, so the next overlap needs no new decision: the
Official Report, then a factsheet, then the PhD dataset. No order is settled
between any other sources (the API, bill documents, manual entry). Promotion
refuses to choose between them, and an order is settled when a first case
arrives.

**What makes it safe.** The error checker requires two rows for the same stage
to agree on the date, on whether it was completed, and on whether the bill
ended there, before either can be promoted. The order decides only which
citation the clean sheet shows.

---

## 2026-09-11 — The stage-dates sheet is built, and moving the dates changed nothing

`db/033`, `tools/take_copy.sql`, `tools/compare_with_copy.sql`, and changes to
the load, promotion and rollback scripts. Builds the next two entries, except
the script that loads the owner's PhD spreadsheet (part 4 of the nine parts).
That script is built and rehearsed before the owner enters any date.

**Proved as the owner proposed.** A copy of both sessions was taken, the dates
were moved, Session 1 was taken off and put back, and the whole was compared
with the copy cell by cell. No unexpected differences. The figures are in the
runbook.

**Settled while building, within what was agreed:**
- **A passed bill with no passing date is still a problem, not a gap.** Part 6
  makes a missing stage date a gap, and moves the existing checks to the new
  sheet. The existing checks included this one, and every factsheet prints a
  passing date, so its absence means a bad reading. Missing Stage 1 and 2
  dates are gaps.
- **The gaps list also shows a bill that did not pass with nothing recording
  where it ended.** Part 2 says such a bill means the source does not say how
  far it got. Listing it is what makes the fifteen in Sessions 1 and 2 visible
  as work to do.
- **A date on a stage not completed is allowed only where the bill ended
  there**, which is the Stage 1 rejection case in part 2. Otherwise it is
  flagged.
- **The list of stage names is given to Postico's user.** The error checker
  now reads it, and a checker belonging to that user cannot read a list the
  user is refused. That is one of the six Postico permission faults; five
  remain.
- **M2 cites the thesis:** Steven MacGregor, "Does government dominate the
  legislative process?" (PhD thesis, University of Stirling, 2021), as given
  by the owner.

---

## 2026-09-11 — Each clean tab has a staging sheet of the same shape

Settled by the owner. **Replaces the 2026-09-10 entry "A new variable stages in
one field-level table".** Nothing is built by this entry. Its first use is the
stage dates (next entry).

**The question.** Where the owner's Stage 1 and 2 dates should wait for review.
Two answers were put first:
- columns on the factsheet staging sheet;
- the catch-all sheet planned on 2026-09-10.

The owner objected to the catch-all sheet: a bill's dates would sit in two
places before promotion. Its passing date would be on its factsheet line, and
its Stage 1 and 2 dates somewhere else. The owner proposed thematic sheets
instead. The project will keep adding different kinds of data (MSPs, party
memberships, amendments), and one sheet taking all of it is not good practice.

**The pattern.** A tab is cut by what one row stands for, not by topic: one row
per bill, per stage a bill reached, per MSP, per spell in a party, per
amendment. The clean side was already built this way. The staging side now
follows it. Each clean tab gets a staging sheet of the same shape, and anything
waiting to go onto that tab waits there, whatever its source.

**Dates are not one theme.** A bill's introduction date is one per bill, so it
stays with the bill. A party membership's dates will belong with the
membership. Only stage dates need a tab of their own.

**What it means for the staging sheet we have.** It was checked column by
column. All but two of its 40 columns are one per bill: the same facts held as
printed, as tidied and where each came from, plus the review columns. The two
exceptions are the stage dates:
- `end_stage_3_date`, the passing date;
- `end_stage_1_date`, the date of the eleven Stage 1 rejections.

Both move to a stage-dates staging sheet as part of the stage-dates change. The
factsheet's printed date stays on its line, in `raw_date_final`, as the record
of what was printed. The existing sheet is not otherwise refactored.

**What it replaces:**
- **The catch-all sheet** for single facts about existing bills (2026-09-10) is
  not built.
- **The Stage 1 rejection route is no longer an exception** (the 2026-09-11
  route entry, point 5). It is one per bill, so the bills staging sheet is its
  home under the pattern.

**Why the pattern and not columns.** "Every clean tab has a staging sheet of
the same shape" is one rule to hold in mind. Adding columns to the factsheet
sheet for each new kind of fact makes a growing list of exceptions. The sheet
had already gained several columns the factsheet never states: the Stage 1
date, the route, the note for the bill, and the date the Official Report was
read.

**The cost:**
- One more tab.
- Checking one bill before promotion means looking at its line and its stage
  rows. A pivot table can put them side by side.

**Not settled here, and not needed yet:**
- Staging sheets for MSPs, party memberships and amendments are made when those
  pieces of work open, in this shape.
- Where a later one-per-bill fact is staged (procedure, member in charge) is
  decided when its piece of work opens, against this pattern.

**Proving the move changed nothing.** Proposed by the owner. Moving dates and
adding dates are two changes, so they are checked separately, and a difference
can only have one cause.
1. **Keep a copy first.** Before anything changes, copy Sessions 1 and 2 as
   they stand: the staging lines, and Session 1's bills, stage records and
   provenance notes.
2. **Build and move.** Build the stage-dates staging sheet and move the
   existing dates onto it. Check that every date that was in the two columns
   arrived, with its source and when it was read. Check nothing else on either
   session's staging lines changed.
3. **Put Session 1 back without PhD dates.** Take Session 1 off the clean sheet
   and put it back from the two staging sheets, rehearsed first, then for real.
4. **Compare with the copy, cell by cell.** That covers every bill, every
   provenance note, and every stage record: bill, stage, date, completed,
   where it ended, source, reference and date read. The expected difference is
   none, apart from the stage records' own identifiers and timestamps, which
   are reissued every time.
5. **Only then add the dates.** The PhD dates are loaded and Session 1 is put
   back again. That comparison should differ only by the added dates.

The error checker is empty at every step.

---

## 2026-09-11 — Stage 1 and Stage 2 completion dates, from the PhD. Settled in full; built next session

Raised by the owner at the end of a session, and **settled in full later the
same day**, including all nine parts of the list in `CLAUDE.md` (below).
**Not built.** Building it is the first task of the next session. Nothing that
touches Sessions 1 or 2 moves until it is built, rehearsed and checked.

**Why.** The key research interest is how long a bill takes from introduction
to the end of Stage 3. The clean sheet already holds introduction and Stage 3
dates. Only two dates are missing: the end of Stage 1 and the end of Stage 2.
Royal Assent and Reconsideration are secondary.

**Settled by the owner:**
- **Stage 1 ends on the date of the Stage 1 debate.**
- **Stage 2 ends at the meeting at which the last amendments were disposed
  of.** Every bill has one, amendments or not. With no amendments, the
  committee (or, for an emergency bill, the Parliament sitting as a committee)
  still meets and agrees each section, even if it takes two minutes. So Stage 2
  always has a date.
- **This settles D2** for Stages 1 and 2, which `STATE.md` had kept open since
  2026-09-10. Methodology note M2, which says those dates do not yet exist,
  is rewritten when this is built.
- **The source is the owner's PhD dataset**, which covers Sessions 1 to 6. It
  is already on the list of sources ("ground truth where it covers a case").
  It is added gradually, a session at a time, starting with Sessions 1 and 2.
- **Order of work:**
  1. Settle the open parts. Done on 2026-09-11.
  2. Build and rehearse.
  3. Move the existing dates, and prove the move changed nothing (the entry
     above, "Proving the move changed nothing").
  4. The owner loads the Session 1 and 2 dates.
  5. Session 1 is taken off and put back with them.
  6. Session 2 is reviewed and promoted.

**Already agreed in outline:**
- **Where the dates sit:** the clean sheet already has a record per stage
  (Stage 1 and 2, or Preliminary and Consideration for a Private Bill), so it
  needs nothing new.
- **Provenance:** each stage record carries its own source and reference, so
  no provenance notes are needed.
- **Supplying the dates:** the owner fills in a spreadsheet per session, in
  `sources/phd/`, keyed by staging line number.
- **Checks:** dates must run in order (introduced, Stage 1, Stage 2, Stage 3),
  every passed bill must have both, and a bill rejected at Stage 1 has no
  Stage 2. For the eleven Stage 1 rejections already dated from the Official
  Report, the PhD's date must agree, which checks one source against the other.
  (Amended in part 6 of the nine parts below: a missing date is listed as a
  gap rather than blocking promotion.)

**Open, for the owner:**
1. **Where the dates arrive.** Settled later the same day. They arrive on a
   stage-dates staging sheet: one row per bill per stage, holding every stage
   date whatever its source. The passing dates and Stage 1 rejection dates move
   there too. See "Each clean tab has a staging sheet of the same shape",
   above. The catch-all sheet recommended at first, and the owner's objection
   to it, are recorded there.
2. **Private and Hybrid Bills.** Settled later the same day by the owner: the
   Private Bill process maps onto the three stages of a public bill.
   - **Preliminary Stage** ends on the date of the Preliminary Stage debate,
     where the Parliament decides whether the bill goes on to Consideration
     Stage.
   - **Consideration Stage** ends at the committee meeting at which the last
     amendments were disposed of.
   - **Final Stage** already ends on the vote to pass (M2).

   **The evidence, to be quoted.** The Parliament's page "About Private
   Bills", https://www.parliament.scot/bills-and-laws/about-bills/about-private-bills,
   read on 2026-09-11. The page carries no date.
   - Preliminary: "The Parliament then debates the bill and decides whether it
     should go on to Consideration Stage, or be rejected."
   - Consideration: "The amendments are debated and decided on by the Private
     Bill committee. Only the committee members can vote on amendments at this
     stage."
   - Final: "MSPs then debate and vote on whether to pass the bill."

   **The same page also says:** "These stages are quite different from the
   stages of a Government Bill, and they have different names." That is
   consistent with how they are held. The stages keep their own names
   (`db/018`) and are compared by position, without claiming they are the same
   stage. Proposed: a reader is told both, the end points and that sentence.

   **The page describes today's procedure**, not that of 2003–2007, as with the
   Standing Orders in the 9.14.18 entry.

   **A Consideration Stage meeting even with no amendments.** The owner's
   understanding is that every Private Bill has one, as every public bill has a
   Stage 2 meeting. It is tested by the data rather than assumed. The checker
   requires both dates for every passed bill, so a passed Private Bill without a
   Consideration Stage date is flagged, not quietly accepted.

   **Hybrid Bills follow the same system**, settled by the owner. The evidence
   is the Parliament's page "About Hybrid Bills",
   https://www.parliament.scot/bills-and-laws/about-bills/about-hybrid-bills,
   read on 2026-09-11. It carries no date.
   - "Once a Hybrid Bill is introduced, it follows a 3-stage process. In most
     ways, these stages are the same as the stages of a Government Bill, but in
     other ways are like the stages of a Private Bill."
   - Stage 1: "The Parliament then debates the bill and decides whether it
     should proceed to Stage 2, or be rejected."
   - Stage 2: "The amendments are debated and decided on by the Hybrid Bill
     committee."
   - Stage 3: "There is a debate and vote on whether to pass the bill."

   Copies of both pages are in `sources/procedure/`.

   **Found while reading it: the database gives a Hybrid Bill the wrong stage
   names.** `db/018` gave Hybrid Bills the Private Bill names: Preliminary,
   Consideration and Final. The page calls them Stage 1, 2 and 3. So does the
   record of the only Hybrid Bill there has been, the Forth Crossing Bill.
   Both sources below were read on 2026-09-11.
   - **The Explanatory Notes to the Forth Crossing Act 2011**, table of
     proceedings (https://www.legislation.gov.uk/asp/2011/2/notes/division/7).
     Its rows are headed "STAGE 1", "STAGE 2" and "STAGE 3", with "Stage 1
     Debate and Parliamentary vote", 26 May 2010, and "Stage 3 Debate and
     Parliament vote", 15 December 2010.
   - **The Forth Crossing Bill Committee's page**
     (https://www.parliament.scot/chamber-and-committees/committees/current-and-previous-committees/session-3-forth-crossing-bill-committee).
     It lists "1st Report 2010: Stage 1 Report on the Forth Crossing Bill", 12
     May 2010, and "2nd Report 2010: Stage 2 Report on the Forth Crossing
     Bill", 3 November 2010.

   No Hybrid Bill is in the database yet, so no data is affected. `db/018`'s
   own principle is that stages are recorded under the names they really had,
   and these are the names the Forth Crossing Bill had. **Agreed by the
   owner:** it is corrected within the stage-dates change. Hybrid Bills would run
   Stage 1, 2 and 3, then Reconsideration. Every description, note and document
   that says otherwise is corrected with it (listed in `STATE.md`).
3. **Withdrawn and fallen bills.** Settled later the same day by the owner.
   The stage each had reached, and the dates of any stages completed before
   it, are recorded where the PhD says. They are entered as part of the
   owner's general input of dates, not backfilled as a separate exercise. The
   spreadsheets already have a column for the stage reached. Fifteen bills in
   Sessions 1 and 2 currently have no stage information at all.

   **The owner does not start entering dates** until everything is settled and
   the staging process has been shown to work: the move of the existing dates
   is proved to change nothing, as in the entry above.
4. **A stage completed on a date not known.** Settled later the same day by
   the owner: allowed, and held as a gap to be filled. It does not hold
   anything else up.
   - The stage record says completed, with its date empty, and a note saying
     why is required.
   - Every such gap is listed where it can be seen, but it does not stop the
     session being promoted. Where the list sits is part of the nine-part
     layout.
   - Duration figures leave that bill out of that stage only.

   The owner hopes there are none. Until now an empty date on a stage record
   was described as meaning "not completed", which the record's own completed
   column already says. That description changes with this.

**The nine parts, agreed by the owner on 2026-09-11.** Each part was laid out
with a proposal, and the owner resolved the three choices in them.

1. **What it records.** One row per stage a bill reached:
   - the bill, and the stage under its real name;
   - completed or not, and the date;
   - whether the bill ended there;
   - the source (`spice_factsheet`, `official_report` or `phd`, all already
     on the list), its reference and the date it was read;
   - a note.

   The end points are as settled above.
2. **Which bills, and what empty means.**
   - A passed bill has all three stages, completed.
   - A bill that ended early has the stage it stopped at, not completed and
     marked as where it ended. It also has any stages it completed before
     that.
   - A Stage 1 rejection keeps the date of the decision on its uncompleted
     Stage 1, as now.
   - Otherwise a date is empty only for a stage not completed, or for a stage
     completed on a date not known, which needs a note (open part 4 above).
   - A bill with no stage rows at all means the source does not say how far it
     got.
3. **Where it sits on the clean sheet.** The existing stage records tab, in the
   same shape. One new rule: a completed stage with no date must have a note.
   The Hybrid rows of the list of stage names become Stage 1, 2 and 3.
4. **How it arrives on the staging sheet.** A new stage-dates staging sheet, one
   row per bill per stage. Each row carries its bill's staging line number and
   its own review gate.
   - **Factsheet passing dates** go there when a session is loaded. The
     extractor is unchanged; `load_session.sql` sends the date to the new
     sheet.
   - **Official Report dates** found at review go there.
   - **The owner's PhD spreadsheet** is loaded by a rehearsed script that
     unfolds each line into rows. For a Private Bill, its Stage 1 and 2
     columns hold the Preliminary and Consideration Stage dates.
   - **"not known" is written in a date cell** for a stage completed on a date
     not known, so an empty cell always means not yet entered.
   - **The old columns come off.** `end_stage_1_date` and `end_stage_3_date`
     are removed from the factsheet staging sheet once their contents have
     moved.
   - **Admission is a second pass.** Rows arrive as `new`, the owner's own PhD
     dates included, and are admitted after the owner has read them. The
     admission is recorded in a migration, as `db/016` did. The owner's reason:
     mistakes can happen in data entry. Moved rows keep their line's review
     status.
5. **Promotion and provenance.** Promotion builds stage records from the new
   sheet's admitted rows, instead of from the two columns. Each record carries
   its own source, reference and date read, so no provenance notes are filed
   for stage dates.
6. **What the error checker requires.** Contradictions block promotion; gaps do
   not.
   - **The existing checks** on the two date columns move to read the new
     sheet.
   - **New checks:**
     - dates run in order, from introduction through each stage to Royal
       Assent;
     - stage names are right for the bill type;
     - nothing comes after the stage a bill ended at;
     - for the eleven Stage 1 rejections, the PhD's date agrees with the
       Official Report's.
   - **A missing date is a gap, not a problem.** This covers a passed bill
     without a stage date, and a stage completed on a date not known. Gaps are
     listed on a new pivot table of gaps to fill, and do not stop promotion.
     This amends the outline above: every passed bill should still have all its
     dates, but a missing one is listed rather than holding up the session.
     Without it Session 7, which the PhD does not cover, could never be
     promoted.
7. **What the note tells a reader.** M2 is rewritten to cover:
   - the three end points;
   - Private and Hybrid Bills, quoting the Parliament's pages, including "quite
     different";
   - the PhD as the source, a session at a time;
   - dates not known, which are left out of durations.

   Durations run between consecutive dated stages. So a missing Stage 2 date
   gives a Stage 1 to Stage 3 interval under its own label, not a Stage 2
   figure, and the note says so.
8. **Every bill already coded, rechecked.**
   - Session 1's 67 dates (62 passing, 5 Stage 1 rejections) and Session 2's
     72 (66 and 6) move, and the move is proved to change nothing (the entry
     above).
   - The eleven rejection dates are checked against the PhD.
   - The twelve Private Bills in Sessions 1 and 2 are checked for their stage
     names.
   - No Hybrid Bill is held yet.
9. **When.** All of it is built, rehearsed and checked before the owner enters
   any date and before Session 2 is admitted, in the order of work above.

**Also changed with it:**
- the descriptions listed in `STATE.md`;
- `HOW-THE-DATABASE-WORKS.md` and the runbook;
- the data dictionary, regenerated.

The two new tabs are given to Postico's user so the owner can open them. That
makes 26 tabs.

---

## 2026-09-11 — Provenance notes are rebuilt with their bill, not kept forever

`db/030`, `tools/rollback_promotion.sql`, `tools/promote_session.sql`. Decided
by the owner. **Amends D5 and reverses the append-only rule of `db/025`**,
which the 2026-09-10 entries "A description may not claim a rule the database
does not have" and "Our own rules are not facts of the world" had defended.

**The owner's position.** Provenance notes may change, provided the owner
clears the change. The owner is the judge of what is acceptable to claim as
academic quality, and treating these notes as permanent was completely
unnecessary.

**What happened.** For the second day running the rule got in the way, and
both times it was protecting our own work, not a source's words. On
2026-09-10 fixing a script's mistake meant suspending it (`db/027`). On
2026-09-11, re-promoting Session 1 to add routes would have left five
duplicate-looking outcome notes that could never be tidied. That was put to
the owner as though it were a constraint on them.

**What replaces it.** A provenance note is treated like a stage row:
- promotion writes it from the staging sheet, one note per fact, dated by the
  latest reading;
- taking the session off removes it;
- putting the session back writes it again.

**Clearance.** Approving that rehearsed procedure clears the notes it rebuilds,
since every note is shown before anything is saved. Any other change to a note,
by hand or in a migration, goes to the owner individually.

**What is given up.** The notes no longer hold a history of readings. The
source's own words stay on the staging sheet, which is never emptied. Nothing
yet records a second reading of a source that gives a *different* answer, and
no such revision has happened. How to record one is settled when the first
real case arrives, which is also recorded in `STATE.md`. `v_field_revisions`
stays, and will be empty until then.

**What stays.** A staging line's number is still its bill's number (`db/026`).
The rule was introduced to protect the notes, but it is still worth having:
line 17 is bill 17 in both directions, and nothing reaches the clean sheet
without a staging line behind it.

**Found while building it.** Rebuilding bill 17's note with the script as it
stood would have put back the instruction text `db/027` removed, because the
script appended the whole review note. It now writes the note without it.
Methodology note M5 told readers a blocked bill's earlier state "is recoverable
from field_source, which is append-only"; it now says the earlier state is in
the fact sheet lines held for every session.

---

## 2026-09-11 — A change to how data is coded is finished before anything moves on

Set by the owner, after the next entry was first recorded half done.

**What happened.** The 9.14.18 route was settled as a variable of its own and
then written up as "not yet built, and its home is not decided". A to-do list
went into `STATE.md`, and the recommendation was not to hold Session 2 for it.
Nothing would have stopped Session 2 being admitted and promoted without it. It
would have been finished only if a later session read the list and chose to do
it. That is the pattern that let `VARIABLES.md` contradict the database, and
left M7's "5 of 48 done" out of date. The cause was hurrying towards the next
question.

**The rule.** A methodology decision is not settled until every part of it is
settled, and it is not finished until every part is built:

- what it records and its values;
- which bills it applies to, and what an empty cell means;
- where it sits on the clean sheet;
- how it arrives on the staging sheet;
- how promotion carries it, and its provenance;
- what the error checker requires;
- what the methodology note tells a reader;
- every bill already coded under the old approach, rechecked;
- when it is built, relative to any session it touches.

Until then no session it touches is admitted or promoted, and no new question is
opened. "Not yet built" is not a state a decision may be left in. If the work
cannot be finished in the session, it becomes the first task of the next one,
stated as such at the top of `STATE.md`.

**Why.** Chaos comes from half-finished methodology, not from any single wrong
choice. The owner is the check on every research claim this project makes, and
cannot check a decision that exists in pieces across a review note, a to-do list
and an intention. This is not a race.

---

## 2026-09-11 — A Rule 9.14.18 motion is a Stage 1 vote reached by another route

`db/029` (the outcomes), `db/031` (the route's structure), `db/032` (the
routes recorded). Settled by the owner, from two Session 2 bills. **Built,
rehearsed and applied on 2026-09-11**; Session 1 was taken off and put back
to carry it.

**The cases.** The Provision of Rail Passenger Services (Scotland) Bill (9
November 2006) and the Civil Appeals (Scotland) Bill (20 December 2006) were
not defeated on the member's motion. The Presiding Officer's statement under
Rule 9.3.1 held each to be outwith competence. The lead committee lodged a
motion under Rule 9.14.18 that the Parliament does not agree to the general
principles, and the Parliament agreed.

**Outcome: rejected at Stage 1.** It was a vote on the general principles, and
the code's definition is "general principles not agreed to". A separate code
was considered and rejected. It would have said the bill ended some other way,
and it didn't.

**The route becomes a variable of its own.** The cases are rare, but they
matter to researchers. This entry was first written with the variable "not yet
built, and its home is not decided". That left the decision half made, and the
next entry exists because of it. Every part is now settled:

1. **What it records:** how the Stage 1 decision that ended a bill was reached.
   There are three values, held in a dropdown list:
   - *motion of the member in charge, disagreed to*;
   - *motion of the member in charge, amended to reject the general principles,
     agreed to as amended*;
   - *committee motion under Rule 9.14.18, agreed to*.

   "Member in charge" rather than "member's motion", so the first value also
   fits a Government Bill defeated at Stage 1. The third value's definition
   quotes the rule from the current Standing Orders, taken as unchanged since
   2006.

   **The second value was found by rechecking Session 1 (point 8), before
   anything was built.** The Proportional Representation (Local Government
   Elections) (Scotland) Bill, 6 February 2003, fitted neither of the first two
   values. Amendment S1M-3727.1, in Iain Smith's name, turned Tricia Marwick's
   Stage 1 motion into one that "does not agree to the general principles of
   this particular Bill" (65–54–2), and the motion as amended was agreed
   (65–53–3). The amendment's number, its mover and its stated reason go in the
   bill's note, not a variable: who moved it belongs to the later
   member-in-charge and party slice. The owner suspects the Parliament has since
   changed its handling of motions so this cannot recur; that has not been
   checked.
2. **Which bills:** only bills rejected at Stage 1, and every such bill must
   have a value; the error checker flags one without. An empty cell therefore
   means one thing only: the bill was not rejected at Stage 1.
3. **Where it sits:** on the bill, beside the outcome it qualifies. A bill has
   one Stage 1 decision, so nothing is lost, and an outcome-by-type table reads
   the bill's line. (The bill's Stage 1 record was considered first and
   rejected for that reason.)
4. **The limb, and the amendment:** our view of the limb goes in the bill's
   note, in a fixed form ("Rule 9.14.18: our view is limb (b)…"), followed by
   the grounds and the citation. For the amended route, the note records the
   amendment's number, its mover and the reason the resolution gives.
   The staging sheet gains a note column that promotion carries onto the bill.
   Without it the bill's note could never be filled, since the clean sheet is
   rebuilt from the staging sheet. That also blocked the rename dates and the
   s.33/s.35 mechanism, both already decided to go there.
5. **How it arrives:** a column on the staging sheet beside the Stage 1 date,
   from the same Official Report reading. This is a stated exception to the
   separate route for single facts (2026-09-10), and the exception is defined:
   facts about the decision that ended a bill, read at review. That separate
   route remains the home for procedure, member in charge and party.
   (Replaced later the same day: see "Each clean tab has a staging sheet of
   the same shape". The route is one per bill, so it is where it belongs.)
6. **Where it came from:** promotion files a provenance note for the route
   citing the Official Report, as it does for the outcome.
   - **What it quotes:** its value seen is the Presiding Officer's
     announcement, word for word ("For 65, Against 53, Abstentions 3. Motion,
     as amended, agreed to."), because those are the words that tell the
     routes apart. The review note carries it in the fixed form `Result as
     recorded: "…"`.
   - **Its date:** the staging sheet gains a date for when the Official Report
     was read, and promotion dates Official Report facts by it: the outcome,
     the Stage 1 date and the route. Previously they took the date the
     factsheet was read. That was harmless for Session 1, where both happened
     on 10 September, but would have dated all of Session 2's Official Report
     facts a day early. The checker requires the date whenever anything on a
     line came from the Official Report.
   - **An extra check:** the checker flags a 9.14.18 route on anything but a
     Member's Bill, and the clean sheet refuses one, since the rule covers only
     Member's Bills.
7. **Telling readers:** methodology note M7 gains a paragraph covering what
   each of the three routes means, that the limb is our view, and that the rule
   text is the current one.
8. **Session 1:** its five Stage 1 rejections were rechecked against the
   Official Report on 2026-09-11. Four were the member in charge's motion,
   disagreed to; one was the amended route above. None was a 9.14.18 motion.
9. **When:** all of it is built, rehearsed and checked before Session 2 is
   admitted. **In this order:**
   - take Session 1 off the clean sheet, following the runbook;
   - change the structure (`db/031`);
   - record the eleven routes (`db/032`);
   - put Session 1 back.

   Session 1 has to come off first because the clean sheet cannot be given the
   rule "every Stage 1 rejection has a route" while five bills without one are
   on it.

In total that is one dropdown list, one column on the bill, and three on the
staging sheet: the route, the note to carry onto the bill, and the date the
Official Report was read.

**Which limb is a note giving our view, not a formal value.** Neither motion
cites a limb. The Local Government and Transport Committee's recommendation of
24 October 2006 repeats the words of limb (b) without its letter, and the
Justice 2 convener's grounds in the chamber do the same. So the formal record is
"a motion under 9.14.18", and "(b)" is our reading of the grounds.

**The rule text comes from the current Standing Orders.** The 2006 edition is
not published online. The owner is confident the rule has not changed, and a
coding may rest on what we take the rule to have been at the time, provided it
is triangulated against the motion and the grounds given for it.

**Consequence for promotion.** A review note now carries commentary after its
citation. `promote_session.sql` takes the provenance note's value seen from the
words before the first link only, so that commentary can never land in a
provenance note. That is the bill 17 lesson, applied before rather than after.
(At the time a provenance note could not be edited afterwards. That changed at
`db/030`, later the same day, but the rule about commentary still holds.)

---

## 2026-09-11 — "Extracts clean" meant the counts matched, and that was not enough

`db/028`, `tools/extract_factsheet.py`, `tools/load_session.sql`, and the
guard in `tools/promote_session.sql`. Found loading Session 2, which the
handover said needed no parser work because it extracts 81 rows against a
stated 81.

**The count was right and the rows were not.** Session 2's title cells hold
three things Session 1's never do: an SP Bill number after the title (15
bills), an asp number in brackets (2), and in one case an introduced title
after the asp number. The extractor separated none of them. The error checker
would have caught the asp numbers and nothing else, so fifteen bills would have
reached the clean sheet with their number inside the title and none in the
column for it. Reconciling against a factsheet's own totals proves no line was
lost. It says nothing about what is inside a line, and the survey read the
documents' structure, which is why it missed an introduced title printed inside
a cell.

**The staging sheet gets a place for an introduced title after all.** Recorded
on 2026-09-10 as deliberately not built, on the grounds that Session 1 states
none. Session 2 states one, and the clean sheet already has the column, so
without a staging column promotion has nothing to carry into it. Rename dates
and block dates are still not built; nothing loaded so far states one.

**The checker now flags an SP Bill number or an introduced title left in a
title.** Tested by planting each in a staging line inside a transaction that
was thrown away. Both were caught.

**A matching title does not make a bill a double count.** The Prostitution
Tolerance Zones (Scotland) Bill was rejected at Stage 1 in Session 1, and a new
bill of the same name was introduced in Session 2. Promotion refused any line
whose title was already on the clean sheet, so it would have refused Session 2.
The guard now requires the same title **and** the same introduction date: a
bill counted in two factsheets keeps its introduction date, and a reintroduced
one does not. That makes them separate bills, as VARIABLES §6 always said.
**Known gap, not fixed here:** the guard cannot see the European Charter and
UNCRC Bills, whose titles change from Bill in Session 5 to Act in Session 6. It
has to be dealt with before Session 6 is promoted.

**Loading is a script with a rehearsal, like promotion.** Nothing recorded how
Session 1 was loaded. `load_session.sql` takes `-v session=` and `-v save=` with
no defaults, refuses a CSV whose columns are not exactly the extractor's
current ones, and refuses a session that already has staging lines. It numbers
the staging lines itself, one after the highest in use, rather than taking
numbers from the sequence. A thrown-away rehearsal would otherwise still use up
numbers, and a staging line's number becomes a bill's number (`db/026`).

**M3 no longer states a count of introduced titles.** It said "three cases
across seven sessions"; Session 2 made it four. The count was removed rather
than corrected, for the same reason row counts came out of the table
descriptions.

---

## 2026-09-10 — Our own rules are not facts of the world

`db/027`. One provenance note held an instruction to the promotion script in
the column meant for a citation. It was corrected by suspending the
append-only rule for the length of one transaction and putting it back.

**Why this is written down.** The correction is trivial; the reasoning that
delayed it is not. `field_source` was made append-only that same morning, on
an empty table, by us. When the first mistake landed in it an hour later, it
was reported to the owner as something that could not be fixed. It could. The
rule was treated as a property of the world rather than a choice made that
day, and the owner had to argue for five minutes to get a one-line change
made.

**The rule stands and is not weakened.** It exists so a published record
revised in 2030 cannot be silently overwritten, leaving no trace the
Parliament changed its mind. That is worth the cost it imposes.

**The test for a future case.** Is the row a record of what a source said, or
debris from our own tooling? A source's words stay, always, even when they
turn out to be wrong — that is the entire point. Our debris is cleaned up, in
a migration that says what it changed and why. The distinction is not fine and
does not need adjudicating each time.

**The general form, which matters more than this instance.** Every rule in
this database was written by this project, most of them this month. A rule
that makes the data trustworthy is worth defending; the same rule protecting
a typo made by our own script, on data nobody outside the project has seen, is
not. Say which of the two is in front of you before saying something cannot be
done.

---

## 2026-09-10 — Promotion is a rehearsed procedure with a written undo

`tools/promote_session.sql`, `tools/rollback_promotion.sql`,
`docs/PROMOTION-RUNBOOK.md`. Session 1 promoted: 73 bills, 67 stage rows, 6
provenance notes.

**Both scripts require `-v session=` and `-v save=` with no default for
either.** A run with `save=false` does the entire job, prints the result and
discards it. Eight checks run before anything is kept and any failure aborts
everything, whichever way `save` is set.

**Why the procedure is written down rather than remembered:** it gets run
seven times, by whoever is here, and the value is in knowing what to look at
rather than what to type. The runbook names the five tables to read and what
each should say.

**Reversibility was rehearsed, not assumed.** Session 1 was promoted, taken
back off, and promoted again. After the undo: no bills, no stage rows, staging
lines unstamped, provenance notes still present because they cannot be
deleted. After promoting again: the same 73 bills with the same numbers, still
6 notes rather than 12, each pointing at the right bill. A third run changed
nothing. This is what `db/026` was for and it is now demonstrated rather than
argued.

**A provenance note is the one thing that cannot be tidied up afterwards.**
Demonstrated the hard way on the first run: bill 17's note has the whole
reviewer's comment as its reference, including a sentence that was an
instruction to whoever wrote the script. The script now files a short
reference, so later sessions are clean; that row cannot be. Recorded because
the lesson is general — read the provenance table before saving, not after.

**Withdrawn and fallen bills get no stage rows.** Six Session 1 bills have a
concluding date on the bill and nothing else, because the factsheet does not
say what stage they had reached. That is a gap in the source, not in the
schema, and it is listed as open in `STATE.md`.

---

## 2026-09-10 — A bill's number is its staging line's number

`db/026`. `bill.bill_id` no longer comes from a sequence. Promotion supplies
it, and it is the `candidate_id` of the staging row the bill was promoted
from. A foreign key from `bill.bill_id` to `bill_candidate.candidate_id`
enforces it.

**Why:** promotion being cheap to redo is what made it safe to promote Session
1 before the other six sessions were even loaded. It was nearly true and not
quite. `bill_candidate` is permanent, `stage_event` rows go with their bill,
and a staging row's `promoted_bill_id` empties itself. `field_source` was the
exception: it records which bill a note is about by the bill's number, and
`db/025` made it append-only, so those rows cannot be corrected. Empty `bill`,
promote again, the numbers come back in a different order, and six notes point
silently at the wrong bill. Stopping the numbers moving removes the problem
rather than managing it.

**A second thing it buys.** A bill can no longer exist without a staging line
behind it. The gateway rule was previously a property of the promotion script
being written correctly; it is now a property of the database.

**What it costs.** Bill numbers are no longer an unbroken run — the four bills
appearing in two factsheets (M6) take the number of the first line promoted, so
four candidate numbers are never used. `bill_id` was always our own invented
identifier, never shown to a reader, so a gap in it means nothing.

**Tested, not assumed.** A bill with a number no staging line has is refused; a
bill taking a real staging line's number is accepted; a bill with no number
supplied is refused, since nothing hands them out any more. `bill` is still
empty.

**Stage dates need no note of their own.** Checked while doing this: the five
Session 1 Stage 1 dates that came from the Official Report do not need a
`field_source` row, because a stage row carries its own `source`, `source_ref`
and `observed_at`. So all six of Session 1's provenance notes are about `bill`
columns — one corrected title and five outcomes — and all six are now stable
across a re-promotion. A stage row's number is still reissued on re-promotion,
which matters only for a second, later observation of the same stage date.

---

## 2026-09-10 — A description may not claim a rule the database does not have

`db/025`. Found by the owner reading the descriptions back, which is the check
`db/024` was built to make possible, working as intended on its first outing.

**Seven descriptions stated a rule that did not exist.** Five staging columns
said "must be a value in ref_x". Nothing checks them, and nothing should:
`bill_candidate` is permissive on purpose so a bad parse lands as a row that can
be looked at. Those are reworded to say where the check really is — on `bill`,
which is true today and stays true whenever the promotion script is written.

**The sixth was different and is now real.** `field_source` said rows are only
ever added, never changed. That was a convention held by whoever was typing, and
**D5 is settled on it** — the reason a revised published record is visible rather
than silent is that the earlier observation cannot be overwritten. A settled
decision resting on a habit is not settled. A trigger now refuses an update and a
delete, and it was tested rather than assumed.

**The cost is stated rather than left to be discovered.** A row entered in error
cannot be tidied away; correcting one means a migration that drops the trigger,
makes the change and puts it back, so the correction is itself part of the
record. Same reasoning as `db/016` admitting candidates by migration.

**The seventh was the check being wrong, not the database.** `fell_here` was
reported as unenforced and was not — a partial unique index has always refused a
second one. `pg_constraint` does not list plain indexes. Recorded because the
same mistake would pass a second review the same way.

**Descriptions say what the data is before how it was derived.** The staging
ones were written from the extraction script's point of view — "the outcome we
propose", "converted to a real date" — which is the wrong way round for the
person reviewing a row at the gate. Both belong, in that order. Row counts came
out of table descriptions: "seven rows" is true until it is not, and nothing
announces the change.

## 2026-09-10 — `methodology_note` stays a table, and the future-proof columns stay

Both raised as candidates for removal on the grounds that the database felt
complicated for 73 rows, and both settled by the owner against that.

**`methodology_note` is not moved to markdown.** The argument for moving it was
that seven rows of text feed a website that does not exist yet, and a file would
do for now. The owner's answer, and it is the right one: multiple markdown files
will kill us in the end. `docs/VARIABLES.md` is the proof — it still defines
columns, and several of its definitions now contradict the database. The
original decision stands and this entry records that it was challenged and held.

**`party`, `procedure` and their two lists stay.** Neither is used by the first
slice, so both fail "build only what the current slice needs" as written. Kept
deliberately as future-proofing, on the owner's judgement that re-adding them
later costs a migration either way and carrying them costs nothing.

**What the complexity question was actually answered with.** Of fifteen tables,
three hold bills, two are the gateway, one is the published notes, and nine are
lists of permitted words four columns wide. Of 130 columns, roughly 25 are
distinct facts; the rest is that four-column shape nine times over, plus the
same bill held three ways in staging — as printed, as read, as admitted. Every
piece that is not future-proofing traces to a specific bill or a specific
factsheet behaviour that forced it.

## 2026-09-10 — What the factsheet survey settled: seven decisions from reading all seven

`db/019`-`db/023`. The survey is `docs/FACTSHEET-SURVEY.md`; this records what it
forced. Taken in one sitting, while `bill` was still empty and structural change
was still free, which was the whole reason the survey came before promotion.

**The finding underneath most of the others: passing a bill is not the end of it.**
`db/013` had encoded the opposite as a `CHECK` — if a bill passed, it could have
no concluding date, because its Stage 3 date was its ending. Four bills say
otherwise, and they are four different endings from one starting point. Three
were referred to the Supreme Court under section 33 and ruled partly outwith
competence on the same day, 6 October 2021: two were reconsidered and enacted,
one was withdrawn on 10 March 2022, four years after it passed. The fourth, the
Gender Recognition Reform Bill, was blocked by a section 35 order on 16 January
2023 and nothing has happened since.

**Stasis is not a state of its own.** The owner's reading, and it is right: the
bill has been blocked, and nothing has happened since, which is exactly what
`blocked` means. `enactment_status` records a bill's current state, not its
history; the history is in `field_source`, which is append-only for this reason.
So no new vocabulary — but `pending` had to be tightened, because it said
"including referral", under which a bill referred and ruled against was
describable both ways depending which clause you read.

**A blocked bill does not fall at dissolution.** This is why the Session 7
factsheet carries the Gender Recognition Reform Bill as one of its own bills, and
why that is not an error on SPICe's part. An unfinished bill falls; a passed bill
that has been blocked has nothing left to fall from.

**`date_assent_blocked` is the one addition not forced by a constraint.** Stated
plainly so it can be struck if it is judged speculative. Without it `blocked` is a
state with no time attached, in a project whose second research question is time.
It does not duplicate `date_royal_assent` or `date_concluded`, because the
intervention and the ending are different events, and it stays populated after a
block is lifted — which is how the bills that were blocked and recovered can be
found at all.

**Two title columns, not one with a caveat.** `short_title` is the title the bill
is known by at the latest point there is evidence for; `title_as_introduced` is
the title at introduction, null where no source states it — which is most rows.
This is the third instance of the same shape: `bill_type_stated` beside
`bill_type` (D4), stage names by bill type (D6), and now titles. VARIABLES §3.2
defined `short_title` as the introduced title and was false for 62 of 73 Session 1
rows; M3 existed to publish that. It now describes coverage instead of apologising
for one column meaning two things. Null never means unchanged.

**Hybrid Bills keep their type and gain a grouping.** The requirement was to be
able to include or exclude them later. Coding the Forth Crossing Bill as
'government' would put a false value in the type column and make exclusion the
hard case; `ref_bill_type.analysis_group` leaves the type true and makes the
choice a matter of picking a column at query time. **The Session 3 factsheet
already makes this grouping and does not say so** — it defines a type letter `H`,
applies it to that one bill, then prints a summary with no Hybrid column and
counts it under Executive. Its stated 45 Executive bills are 44 plus one Hybrid.

**That is also the limit of the reconciliation gate, found rather than argued.**
Both sides total 62, so the gate passes on a document that has silently agreed a
Hybrid Bill is an Executive Bill. An arithmetic check against a source's own
totals catches a dropped row and does not catch a coding decision. Worth knowing
before six more sessions are reconciled the same way.

**A bill belongs to the session it was first introduced in.** The only definition
that survives a bill being reconsidered two sessions later. It means our
per-session counts will not match the factsheets', which count a bill in every
session it was live: 473 rows in the seven stated totals, 474 rows to read, 470
distinct bills. Published as M6, because a researcher checking our total against
SPICe's needs to find the explanation in the data and not in a repository.

**`sp_bill_id` is unique within a session.** SP Bill numbers restart each
session; SP Bill 13 is in Sessions 2, 6 and 7. Storing a qualified string like
'S5-70' was rejected because it invents an identifier the Parliament does not use,
and every comparison against a source would have to undo it.

**Why a bill fell is our coding, and it is 5 of 48 done.** No factsheet ever says
why a bill fell. Rejection at Stage 1, defeat at the final vote and running out of
time at dissolution are all one heading. M7 publishes that the distinction is
ours, against the Official Report, and that it is mostly not yet made — so a
reader does not take the general code as a finding.

**What was deliberately not built.** `bill_candidate` gets no column for a stated
introduced title, a rename date or a block date: Sessions 4-7 state them and
Session 1 states none, so building now would be speculative. And the
session-window checks in `v_candidate_problems` compare a candidate's dates
against the session of the factsheet it was read from, which is the wrong session
for a carry-over row; Session 1 has none, so the limitation is written into the
view's own comment rather than fixed, and it must be handled before Session 5 is
loaded.

**Rename dates get no column.** Two bills in seven sessions state one; both go in
`bill.note`. Revisit at a third case.


## 2026-09-10 — Stage dates return to `stage_event`, under each bill type's own stage names. D6 settled

`db/018`. Reverses the stage-date half of `db/004` and the whole of `db/005`, and
settles D6, opened earlier the same day.

**The principle, in the owner's words:** record the appropriate nuance for each
type and normalise afterwards if we need to, rather than shoehorning different
kinds of bill procedure into a single class because that is neater.

**What that means here.** A bill's stages are recorded under the names those
stages actually have for that kind of bill — Stage 1, 2 and 3 for a public bill;
Preliminary, Consideration and Final Stage for a Private or Hybrid Bill — in
`stage_event`, one row per stage reached. `ref_bill_type_stage` records which
sequence belongs to which bill type, and a trigger enforces it: the database now
refuses to record a Stage 2 against a Private Bill, or a Preliminary Stage
against a Government Bill, or a valid stage name at the wrong position.
Comparison across types is done in a view, on `stage_order`, with the real stage
names carried through into the output so it is always visible what is being
compared with what.

**This is the same shape as `bill_type_stated` beside `bill_type`,** which is why
it is consistent rather than novel. D4 exists to stop the normalised value eating
the contemporaneous one. The identical argument applies to stages.

**Why reversing `db/004` is legitimate rather than a change of mind.** That
decision moved stage dates onto the bill row because "a bill becomes one line to
type, which is what a hand-build needs". The reason was about typing. Rows are
now extracted programmatically and the reviewer edits a staging row, so the cost
that justified collapsing the stages has largely gone — the promotion script fans
one candidate row out into several stage rows, which costs nothing because it is
a script. `db/003` had originally built the duration views on `stage_event` in
exactly this way; `db/018` substantially restores them.

**What did not move, and why.** `date_introduced` and `date_royal_assent` stay on
`bill`. Every bill type has both, under the same name, so no nuance is lost by
holding them as columns, and moving them would duplicate two fields that existing
constraints depend on. The distinction being served is that stage *names* differ
by bill type; introduction and Royal Assent do not. `date_concluded` stays for
the same reason — a bill being withdrawn is not a stage.

**`ref_stage.applies_to` was dropped.** It marked the three private stages
'private', which left Hybrid Bills unaccounted for, and its `CHECK` allowed only
public/private/both so it could not have said otherwise. It was also a second
answer to a question `ref_bill_type_stage` now answers properly, and two sources
of truth about which stages belong to which bills is how the wrong one gets used.

**Cost, stated honestly.** Nothing is populated. Five Stage 1 dates from the
Official Report and 62 passing dates is the whole of the stage data in existence,
and it sits in `bill_candidate`. This builds the shape that promotion writes
into, while `bill` is empty and the shape is free to change. Filling it is
expected to be gradual — from the PhD, from the Official Report, and from the
Parliament's API — which is the working assumption for this project generally
rather than a caveat about this decision.

## 2026-09-10 — `stage_event` is kept: Private Bills are the reason that was waiting to appear

`db/004` moved stage dates onto the bill row and left `stage_event` in place but
empty, with the instruction to drop it "unless a reason to keep it appears".
`db/017` drops the other empty table, `scratch_test`, and deliberately leaves
this one. This entry records the reason, so the instruction is answered rather
than quietly ignored.

**Private Bills do not have Stages 1, 2 and 3.** They have Preliminary,
Consideration and Final. Session 1 contains three of them — one passed, two
fell — and the one that passed currently has its Final Stage date sitting in a
column named `end_stage_3_date`. The column does not mean what its name says for
those rows. Later sessions have more.

Three columns on the bill row cannot express this. `stage_event` was built with
`stage_order` precisely so that a Private Bill's third stage could be compared
with a public bill's third stage without asserting that they are the same stage.
It also distinguishes a stage *reached* from a stage *completed*, which a bare
date column cannot: a bill sitting in Stage 2 at dissolution has no Stage 2 date
and that is not the same as never having got there.

**Why this matters now rather than later:** the second question in the first
slice is time taken to complete each stage. It is not a future concern that
Private Bills have different stages; it is a mis-description already present in
Session 1's data.

**Not resolved here.** Keeping the table is not a decision to use it. The
options — name the columns generically, record a stage vocabulary per bill type,
or populate `stage_event` after all — are open, and are recorded as **D6** in
`STATE.md`. Dropping the table would have quietly foreclosed the third option
and removed the artefact that best explains the problem.

## 2026-09-10 — A new variable stages in one field-level table, never as a new column on `bill_candidate`

**Replaced on 2026-09-11** by "Each clean tab has a staging sheet of the same
shape". Kept for its reasoning, which is partly carried forward: a staging
sheet's shape follows what arrives in it.

Settled in answer to "when I want to add procedure later, where does it go?"
Nothing is built for it yet; this records the shape so the first case does not
have to invent one under pressure.

**`bill_candidate` is not the staging table. It is the *factsheet* staging
table.** Its `raw_*` columns are the factsheet's own columns and its unique key,
`(session_number, raw_section, raw_title)`, is a factsheet address. Its shape
belongs to its source.

**So the split is by how a fact arrives, not by which variable it is.**

- *Arriving as whole bills* — another session's factsheet, later the API. That is
  row-shaped, and stages in a table shaped like that source.
- *Arriving one field at a time about bills that already exist* — `procedure`,
  member in charge, party. That stages in a single field-level table: which bill,
  which field, the proposed value, the source's own words, where it came from,
  when it was read, and the same `review_status` gate. Adding procedure means
  adding rows to it. Adding party later means adding rows to the same table.

**Why not a column on `bill_candidate`.** No factsheet states procedure. A column
there would sit empty across all ~473 rows and would make the table a less
honest record of what SPICe said — which is the job `DECISIONS.md` gives it when
it says the table is kept permanently as provenance.

**Why not a table per variable.** They would all carry the same handful of
columns and each would need its own near-identical promotion step.

**`bill` itself is where a column does get added,** and `procedure` is already
there, nullable and empty, waiting for evidence — which is what `db/010` set it
up to be. `field_source` is the admitted half of this and already exists; what is
missing is the candidate half in front of it.

## 2026-09-10 — The database is dumped into the backup path, and a restore is tested rather than assumed

`db/016` and the amended `/usr/local/sbin/legdata-backup`.

Between the 2026-09-09 clearance and today, **nothing backed up the database.**
The nightly job took `/etc` under the `system` tag and skipped its `data` tag
every night, because `/srv/legdata` no longer existed and the script treats that
absence as normal. PostgreSQL's own files were in scope for neither. The machine
was rebuildable and the data was not, for a project whose first principle is that
the database is the product. A day of hand-coding existed in one place.

**Why a dump into the existing path rather than new machinery:** retention,
verification, encryption and off-site transport to the storage box were all
already built and working. The only missing step was putting the data where they
could see it.

**A backup is not a backup until it has been restored.** Exit status zero proves
a script ran, not that anything can be recovered. The chain was tested end to
end — snapshot fetched back from the storage box, restored into a scratch
database, checked for the expected 73 candidates and that day's edits, scratch
database dropped. The restore procedure is written down in the server notes,
which moved out of this repository on 2026-09-11 and are at
`~/.claude/legdata-vps-notes.md`; it is worth nothing if it is only ever
reconstructed from memory during an emergency.

## 2026-09-10 — Admission to the gateway is recorded as a migration

`db/016` sets Session 1's 73 candidates to `accepted`, rather than that being
typed into a client.

**Why:** `review_status` is the gateway. If the record of what was admitted, and
on what basis, exists only in a database client's query history, then the single
column the architecture depends on is the one with no provenance of its own.
`db/010` set the precedent by carrying its own data fix.

The migration also refuses to admit anything while `v_candidate_problems` is
non-empty. "Work the list to empty before promoting" was an instruction in a
document; it is now a precondition that cannot drift away from the instruction.

## 2026-09-10 — `date_concluded` restored; Act titles accepted in `short_title`

Two questions raised by the Session 1 extraction, settled at the close of that
session. `db/013`.

**`date_concluded` returns to `bill`.** `db/004` dropped `date_outcome` on the
reasoning that for a bill that passed or was defeated the outcome date is the
Stage 3 date. That is true for the 62 Session 1 Acts and false for the other 11:
a bill that was withdrawn or fell has a date that is not a stage completion, and
it had nowhere to go. The new column is narrower than the one dropped — it holds
only that case, and a `CHECK` keeps it empty for a bill that passed, so it cannot
drift back into being a second, competing outcome date.

**`short_title` carries the Act title where a bill was enacted.** VARIABLES §3.2
defines it as the title as introduced, and for 62 of 73 Session 1 rows it is not.
Sourcing the introduced titles separately was rejected as disproportionate for
the first slice. Instead the divergence is published, as methodology note M3, and
`bill_candidate.title_kind` records which kind of title each row carried, so the
choice is visible per row rather than assumed.

**Why publish rather than fix:** a title, the styling of the bill type, and the
Session 4 `G*` marker are three instances of the same thing — a value that
differs between introduction and passage. The slice does not need any of them
resolved; it needs them not to be silent. VARIABLES §3.2 should be amended to
match.

## 2026-09-10 — Factsheet rows are extracted into staging and admitted by review

Amends, and does not reverse, the hand-entry decision below. Extraction writes to
`bill_candidate`; nothing reaches `bill` except by review and explicit promotion.

**Why:** the hand-entry decision gave three reasons. The first — that parsing
seven read-once documents costs more than reading them — is weakened: the
factsheets are Word-generated with a clean text layer, sessions 1-5 are ruled
tables and 6-7 a fixed prose grammar, and there are ~473 bills rather than a few
dozen. The second — that PDF extraction fails quietly — is answered here
specifically, because each factsheet prints its own outcome-by-type cross-tab,
so an extraction can be checked against the source's own arithmetic before
anyone reads a row. The third reason is untouched and is why this is an
amendment rather than a reversal: the factsheets are *derived*, the outcome
coding is SPICe's judgement, and reading it is how a divergence from the thesis
gets noticed. Under this decision the reading still happens, at the gateway, on
a populated row instead of an empty one.

**The gate has already earned itself.** Sessions 1 and 2 reconcile exactly.
Sessions 3, 4 and 5 come up short by 2, 14 and 6 rows, because pdfplumber
fragments tables that break across a page and a data row is consumed as a
header. None of it reached `bill`.

**Consequence:** `bill_candidate` is kept permanently, not cleaned out. It is the
provenance — `promoted_bill_id` ties every admitted bill to a page and to the
factsheet's verbatim words; it is how a reissued factsheet is diffed against what
was admitted; and it is the reference dataset automation is later measured
against. Rejected candidates stay, with `review_note` recording the judgement.

## 2026-09-10 — `procedure` is nullable; 'standard' is a finding, not a default

`bill.procedure` was `NOT NULL DEFAULT 'standard'`. Both dropped in `db/010`.

**Why:** no source consulted so far states procedure — the factsheets have no
such column. The default recorded four Budget Acts and the Mental Health (Public
Safety and Appeals) Act 1999 as standard procedure as a positive fact, on no
evidence. Null now means not known, and 'standard' is something established.
Same distinction `party` already draws between null and Independent.

## 2026-09-10 — The stated bill type is recorded alongside the normalised one

`bill.bill_type_stated` references a separate `ref_bill_type_stated`.

**Why:** researchers will want the Executive/Government split, and it is cheaper
to capture on the way past than to reconstruct. A separate lookup rather than
adding 'executive' to `ref_bill_type`, because a value in the research vocabulary
would appear in outcome-by-type cross-tabs and split the government series —
which is what D4 exists to prevent.

**It cannot be derived.** The changeover is not the 2007 renaming of the Scottish
Executive. The Session 4 factsheet marks bills `E`, `G` and `G*`, the last
footnoted 'Introduced as an Executive Bill (E)', for bills introduced in 2011 and
2012. Sessions 1-3 are `E` throughout, session 5 onward `G`. So the label follows
neither the session nor the introduction date, and has to be recorded as stated.
`bill_type_stated` means as introduced, so `G*` is 'executive'.

## 2026-09-10 — Methodology notes are data, not prose in the repository

`methodology_note` holds the text of each value judgement; the front end reads it
and shows it against the variables named in `applies_to`. The wording is seeded
by a migration, so it stays version-controlled.

**Why:** the two judgements in the first slice — counting Executive Bills as
Government Bills, and treating the date passed as Stage 3 completion — are both
defensible and both invisible in the numbers. A note kept only in the repository
drifts from what the site shows. `DECISIONS.md` records that a decision was taken
and why; `methodology_note` records what a reader of the data must be told. They
are different documents with different audiences.

## 2026-09-10 — The database is the product; sources are candidates

Nothing is written as fact by any process. Every source produces a candidate
that is checked before admission, whatever the source. Automation, when it
comes, proposes rather than writes.

**Why:** previous attempts let extraction write directly, so an unbounded
residue of edge cases sat on the critical path. Under a gateway, partial
automation is still useful and failed automation costs nothing.

## 2026-09-10 — First slice: outcome by bill type, and time per stage

Across all sessions. Nothing else — no member in charge, party, votes or text.

**Why:** the minimum most users want, buildable by hand in about a day, and
therefore usable as the reference dataset that later automation must reproduce.

## 2026-09-10 — Hand-build before automation

The first slice is entered by hand. Automation is attempted afterwards and is
accepted only if it reproduces the hand-built values.

**Why:** the failure mode is chain length — variable to source to assessment to
edge cases to gaps to reconciliation, with no checkpoint. Hand-building produces
both a ground truth and a written list of the real edge cases, which converts an
open-ended judgement problem into a pass/fail one.

## 2026-09-10 — PostgreSQL on the VPS, reached over SSH

Data lives on the VPS from the start, not locally. Postgres 17 listens on
loopback only; clients tunnel in over SSH.

**Why:** starting on the server avoids a migration later and means there is one
copy of the truth. Loopback plus tunnel keeps port 5432 off the public internet
and leaves the existing firewall untouched.

## 2026-09-10 — SSH forwarding relaxed, pinned to the database port

`AllowTcpForwarding local` with `PermitOpen 127.0.0.1:5432`, replacing
`AllowTcpForwarding no`. Original config kept as `.pre-db-tunnel.bak`.

**Why:** DBeaver needs a tunnel, and the alternative — exposing 5432 through the
firewall — means a public database, TLS to configure, and a rule that breaks
whenever the client IP changes. `PermitOpen` means the relaxation reaches
Postgres on loopback and nothing else.

## 2026-09-10 — D1 settled: outcome and enactment are separate variables

`outcome` records what Parliament did; `enactment_status` records whether the
bill became an Act.

**Why:** passing and becoming law are different events, and the gap between them
is of research interest — a bill can pass and be referred, or pass and be
blocked from assent. A single combined list makes those cases unfindable and
turns "how many bills passed?" into a sum over several values.

**Reversing it:** a combined view over the two columns, or a generated column.
No data would need re-entering.

## 2026-09-10 — D4 settled: bill type and procedure are separate variables

`bill_type` is who introduced it; `procedure` is how it was handled.

**Why:** an emergency bill is a government bill that compressed its stages. In a
single list it stops counting as a government bill. This matters directly for
slice 2, where emergency and budget bills complete in days and would otherwise
distort every duration average.

**Reversing it:** `coalesce(nullif(procedure,'standard'), bill_type)` gives the
combined list as a view.

## 2026-09-10 — Vocabularies as lookup tables, not Postgres enums

Each controlled vocabulary is a `ref_*` table with a readable text code, and
columns carry the code as a foreign key.

**Why:** values can be read, added and re-labelled in the grid without writing
DDL, each value carries its own definition, and `bill.bill_type` displays
'government' rather than an integer that needs a join to interpret. Postgres
enums require `ALTER TYPE` and cannot drop a value.

## 2026-09-10 — Postico 2 as the entry client

Chosen over DBeaver, which stages grid edits behind an explicit save and caused
changes to appear made when they had not been sent.

**Why:** it writes on leaving a row, which is the spreadsheet behaviour wanted,
and it is a desktop client rather than another service to run and secure. Both
data and DDL changes were verified reaching the VPS independently.

## 2026-09-10 — Stage end dates live on the bill row

`date_outcome` dropped. `end_stage_1_date`, `end_stage_2_date`,
`end_stage_3_date` and `reconsideration_stage` added to `bill`. The duration
views read from these rather than from `stage_event`.

**Why:** a bill becomes one line to type, which is what a hand-build needs. The
outcome date was redundant once the stage dates exist — for a bill that passed
or was defeated it is the Stage 3 date.

**Consequence:** `stage_event` is now unused. It is left in place but empty, and
should be dropped unless a reason to keep it appears. Anything needing more than
a date per stage — committee, votes, amendments — is a later slice and would
justify bringing it back.

## 2026-09-10 — Party as a lookup, null distinct from independent

`bill.party` references `ref_party` and is nullable.

**Why:** null and Independent mean different things. Null is "not applicable or
not known" — which covers law officer bills, where no member is attached.
Independent is a positive fact about a member who sits without a party. A single
text field would blur the two on entry.

## 2026-09-10 — First-slice data entered by hand from the SPICe factsheets

Not parsed programmatically. `ref_source` gains `spice_factsheet`; rows taken
from a factsheet record it as their source, with session and retrieval date in
`source_ref`.

**Why:** parsing seven documents that are each read once costs more than reading
them, and PDF extraction fails quietly — a shifted column, a footnote absorbed
into a cell. It would rebuild the long unchecked chain the project exists to
avoid. The factsheets are also *derived*: the outcome-by-type coding is SPICe's
judgement, and reading it surfaces where it differs from the thesis where a
parser would silently adopt it.

**Where automation does belong:** reconciling entered totals against the
factsheet's own stated counts. Session 6 states 82 bills, 62 Government, 20
Member's, 52 Acts, 4 withdrawn as at 6 March 2026. Cheap arithmetic checks that
catch a mistyped row without re-reading the PDF.

**Evidence for the caution:** the factsheet path serves soft 404s — HTTP 200
with an HTML error page for files that do not exist. A first automated sweep
"found" seven factsheets; five were error pages.

## 2026-09-10 — Provenance per field, and D5 settled with it

`field_source` records the source of an individual field where it differs from
the row-level source. Append-only, with `value_seen` holding the value in the
source's own words.

**Why:** one source per row is insufficient — a bill's outcome will come from a
factsheet while its dates come from the Official Report, and that is the normal
case rather than the exception. `docs/VARIABLES.md` originally argued for
row-level only; that was wrong and has been rewritten.

**This settles D5.** Because the table is append-only, a revised published
record produces a second observation rather than overwriting the first, so the
change is visible. `v_field_revisions` lists fields whose value has changed.

**Not required for the first batch.** The row-level source remains the default
and is enough while a whole row comes from one factsheet. `field_source` is
there for when that stops being true.
