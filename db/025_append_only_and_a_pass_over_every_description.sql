-- 025_append_only_and_a_pass_over_every_description.sql
--
-- One constraint, and a pass over every description in the database.
--
-- Why: db/024 gave every column a description, which was the fix for having
-- none. Reading them back with the owner found two separate faults.
--
-- FIRST, seven descriptions stated a rule the database does not apply.
-- In bill_candidate, five columns said "must be a value in ref_x" — nothing
-- checks any of them, and nothing should: staging is deliberately permissive
-- (db/008) so a bad parse lands as a row you can look at rather than as an
-- import error. Those five are reworded to say where the check really is.
-- One is different, because the rule it claimed is one the project actually
-- depends on, so this migration creates it:
--
--   field_source said "rows are only ever added, never changed". It was a
--   convention. D5 — how a revised published record stays visible instead of
--   being silently overwritten — is settled on that being a property of the
--   table, so it is made one here.
--
-- stage_event.fell_here was flagged in the same review as unenforced and was
-- not: stage_event_one_fell_idx, a partial unique index, has always refused a
-- second fell_here row for a bill. The review looked in pg_constraint, which
-- does not list plain indexes. Recorded because the same mistake would pass a
-- second review the same way: to ask whether a rule exists, read pg_indexes and
-- pg_trigger as well as pg_constraint. Its description now names the index.
--
-- field_source is empty today, which is the cheapest moment this will ever be.
--
-- SECOND, the descriptions leaned toward how a value was produced rather than
-- what it is. That was worst in bill_candidate, where they were written from
-- the extraction script's point of view — "the outcome we propose", "converted
-- to a real date". A reviewer at the gate needs both, in this order: what the
-- value IS in bill terms, then where it came from, then what empty means and
-- what is actually enforced. Row counts are removed from table descriptions:
-- "seven rows" is true until it is not, and nothing announces the change.
--
-- House style, extending db/024's: never claim a constraint this migration or
-- an earlier one did not create.

BEGIN;

-- ===========================================================================
-- The rule the description claimed and the database did not have.
-- ===========================================================================

-- field_source is append-only. A source read twice produces two rows, so a
-- revision is visible as a second observation rather than replacing the first.
-- That is the whole of the answer to D5, and it was held only by convention.
--
-- The cost, stated rather than discovered later: a row entered in error cannot
-- be tidied away. Correcting one means a migration that drops this trigger,
-- makes the change and puts it back — so the correction is itself recorded,
-- which is the point. Same reasoning as db/016 admitting candidates by
-- migration rather than by typing into a client.
CREATE FUNCTION field_source_append_only() RETURNS trigger
LANGUAGE plpgsql AS $fn$
BEGIN
  RAISE EXCEPTION
    'field_source is append-only; % refused. A source read again is a new row, not a change to the old one.',
    TG_OP;
END;
$fn$;

CREATE TRIGGER field_source_no_change
  BEFORE UPDATE OR DELETE ON field_source
  FOR EACH ROW EXECUTE FUNCTION field_source_append_only();



-- ===========================================================================
-- bill_candidate — the factsheet staging table.
-- ===========================================================================

COMMENT ON COLUMN bill_candidate.session_number IS
  'Which session''s factsheet this line was read from — not necessarily the session the bill belongs to. A bill still live when a session ended appears in two factsheets; bill.session_number records the session it was introduced in. See methodology note M6.';

COMMENT ON COLUMN bill_candidate.raw_title IS
  'The bill or Act title exactly as the factsheet prints it, including the asp number where the factsheet runs it into the title, and the line breaks. Never edited: this is the record of what SPICe said.';

COMMENT ON COLUMN bill_candidate.raw_type IS
  'The one-letter code the factsheet uses for who introduced the bill, exactly as printed: E Executive, G Government, G* introduced as Executive and passed as Government, M Member''s, C Committee, P Private, H Hybrid.';

COMMENT ON COLUMN bill_candidate.raw_date_introduced IS
  'The date of introduction as the factsheet prints it, e.g. "6 October 1999". Held as text so the printed form survives even where it could not be read as a date.';

COMMENT ON COLUMN bill_candidate.raw_introduced_by IS
  'The person, committee or promoter the factsheet names as introducing the bill, exactly as printed. Not used in the first slice; kept because re-reading seven PDFs later to get it would cost more than storing it now.';

COMMENT ON COLUMN bill_candidate.raw_date_final IS
  'The date in the factsheet''s last date column, exactly as printed. What it means depends on which of the factsheet''s tables the line sat in: the date the bill was passed, the date it was withdrawn, or the date it fell. See raw_section.';

COMMENT ON COLUMN bill_candidate.raw_date_royal_assent IS
  'The date of Royal Assent as the factsheet prints it. Empty for a bill that did not become an Act.';

COMMENT ON COLUMN bill_candidate.raw_section IS
  'Which of the factsheet''s tables this line sat in: acts, withdrawn or fallen. This is SPICe''s own judgement of what happened to the bill, and it is what outcome and enactment_status are derived from.';

COMMENT ON COLUMN bill_candidate.sp_bill_id IS
  'The Parliament''s bill number within its session, as the factsheet gives it. Empty where the factsheet gives none: Session 1 gives no numbers at all, and Sessions 2 to 5 give them only for bills that did not become Acts.';

COMMENT ON COLUMN bill_candidate.short_title IS
  'The bill or Act title, tidied for use: the asp number moved out into asp_number and broken lines rejoined. raw_title stays as the record of what was printed. Whether this is the Act''s title or the bill''s is in title_kind.';

COMMENT ON COLUMN bill_candidate.title_kind IS
  'Which kind of title short_title holds: the title of the Act as passed, or the title the bill carried when it ended. Set to "act" for lines from the factsheet''s Acts table and "bill" for the rest. It exists because a bill''s title usually changes on enactment, so the two are not the same thing and the row must say which it has. Nothing enforces the two values, here or anywhere: bill has no equivalent column, so this is checked by eye at review or not at all.';

COMMENT ON COLUMN bill_candidate.bill_type IS
  'Who introduced the bill: government, members, committee, private or hybrid. Our proposed value, converted from the factsheet''s type letter in raw_type — E and G both become government, M members, C committee, P private, H hybrid. Executive and Government collapse into one value here on purpose, so that a count of government bills runs continuously across the 2007 changeover; the contemporaneous styling is not lost, it is kept beside this column in bill_type_stated. Should be a code from ref_bill_type. Nothing in this table enforces that, but bill.bill_type does, so a wrong value cannot reach the live table.';

COMMENT ON COLUMN bill_candidate.bill_type_stated IS
  'How that same type was styled at the time: an Executive Bill or a Government Bill. Converted from the same letter but keeping the distinction it makes — E and G* become executive, G becomes government. This is the half of the pair that bill_type deliberately flattens; the two columns are read together. Should be a code from ref_bill_type_stated. Nothing in this table enforces that, but bill.bill_type_stated does.';

COMMENT ON COLUMN bill_candidate.procedure IS
  'How the bill was handled under the Parliament''s rules — standard, emergency, budget and so on. Always empty from a factsheet: none of them state procedure. Deliberately not defaulted to "standard", which would record budget and emergency bills as standard procedure on no evidence. See db/010.';

COMMENT ON COLUMN bill_candidate.date_introduced IS
  'The date the bill was introduced, as a real date, read from raw_date_introduced. Empty where the factsheet gave none, or where the printed form could not be read — parser_note says which.';

COMMENT ON COLUMN bill_candidate.end_stage_3_date IS
  'The date the bill was passed, which is the date Stage 3 was completed — Final Stage for a Private or Hybrid Bill. Taken from raw_date_final for lines in the Acts table. Empty for a bill that was not passed. See methodology note M2.';

COMMENT ON COLUMN bill_candidate.date_concluded IS
  'The date the bill stopped being a live bill without becoming an Act — the date it was withdrawn, or the date it fell. Taken from raw_date_final for lines in the Withdrawn and Fallen tables. Empty for a bill that was passed.';

COMMENT ON COLUMN bill_candidate.date_royal_assent IS
  'The date the bill received Royal Assent and became an Act, as a real date, read from raw_date_royal_assent. Empty if it never did.';

COMMENT ON COLUMN bill_candidate.asp_number IS
  'The Act''s number, e.g. "2000 asp 5", taken out of raw_title where the factsheet runs it into the title. Empty if the bill did not become an Act.';

COMMENT ON COLUMN bill_candidate.outcome IS
  'What the Parliament did with the bill: passed, withdrawn, or one of the ways a bill can fall. Taken from which of the factsheet''s tables the line sat in — Acts means passed, Withdrawn means withdrawn. Left empty for a fallen bill unless it fell on the dissolution date, because no factsheet says why a bill fell; that distinction is ours to make against the Official Report, and parser_note flags each such row. Should be a code from ref_outcome. Nothing in this table enforces that, but bill.outcome does. See methodology note M7.';

COMMENT ON COLUMN bill_candidate.enactment_status IS
  'Whether the bill became an Act: enacted, not enacted, pending or blocked. Taken from the same table the line sat in — Acts means enacted, everything else not enacted. Should be a code from ref_enactment_status. Nothing in this table enforces that, but bill.enactment_status does.';

COMMENT ON COLUMN bill_candidate.source IS
  'What kind of source this line came from. Normally spice_factsheet. Should be a code from ref_source. Nothing in this table enforces that, but bill.source does.';

COMMENT ON COLUMN bill_candidate.source_ref IS
  'The exact place within that source — which factsheet, which page — so the line can be found again by hand.';

COMMENT ON COLUMN bill_candidate.observed_at IS
  'The date we read the source. Matters because the Parliament revises published records, so the same factsheet can say something different later.';

COMMENT ON COLUMN bill_candidate.src_file IS
  'The name of the PDF file this line was extracted from. Held separately from source_ref so a re-run of the extractor can be compared against the exact file used.';

COMMENT ON COLUMN bill_candidate.src_page IS
  'The page of that PDF the line was on.';

COMMENT ON COLUMN bill_candidate.parser_note IS
  'What the extraction script noticed while reading this line — a date it could not read, a type letter it did not recognise, a bill that fell before dissolution so the reason is unknown. Mechanical observations only; the script never guesses. Empty means it saw nothing unusual.';

COMMENT ON COLUMN bill_candidate.review_status IS
  'THE GATE. Whether a person has checked this line and admitted it: new (not looked at), accepted (checked and admitted), rejected (checked and refused), held (needs more work). Only accepted lines can be promoted into bill. This is the one value in this table the database enforces, and the column the whole architecture rests on.';

COMMENT ON COLUMN bill_candidate.review_note IS
  'What the reviewer decided and why, including any citation used to settle a question — this is where an Official Report reference for a corrected date or outcome is recorded. Empty means nothing needed saying.';

COMMENT ON COLUMN bill_candidate.reviewed_at IS
  'When a person reviewed this line. Empty means it has not been reviewed.';

COMMENT ON COLUMN bill_candidate.promoted_bill_id IS
  'Which row in bill this line became. Empty means it has not been promoted. This is the only link between the staging table and the live table, and it is what makes an admitted bill traceable back to the page it was read from.';

COMMENT ON COLUMN bill_candidate.promoted_at IS
  'When this line was promoted into bill. Empty means it has not been.';

COMMENT ON COLUMN bill_candidate.end_stage_1_date IS
  'The date Stage 1 was completed. For a bill rejected at Stage 1 this is the date of that decision, which is also the date the bill fell. No factsheet states it: every value here was entered by hand from the Official Report, with the citation in review_note.';


-- ===========================================================================
-- bill — the live table. Two cross-references it was missing.
-- ===========================================================================

COMMENT ON COLUMN bill.bill_type IS
  'Who introduced the bill: government, members, committee, private or hybrid. Executive and Government Bills are one value here on purpose, so that a count of government bills runs continuously across the 2007 changeover; the contemporaneous styling is not lost, it is kept in bill_type_stated. Allowed values are in ref_bill_type. To fold Hybrid Bills in with government, group on ref_bill_type.analysis_group instead — see methodology note M4.';

COMMENT ON COLUMN bill.outcome IS
  'What the Parliament did with the bill: passed, rejected at Stage 1 or Stage 3, withdrawn, or fell. Allowed values are in ref_outcome. Deliberately separate from whether it became an Act, which is enactment_status. No source states why a bill fell — rejection, defeat at the final vote and running out of time at dissolution are one heading in every factsheet — so the distinction between the values is our reading against the Official Report. See methodology note M7.';


-- ===========================================================================
-- stage_event — fell_here is now enforced, so it can say so.
-- ===========================================================================

COMMENT ON COLUMN stage_event.fell_here IS
  'True on the stage where the bill ended. A bill can have at most one such row, and the database enforces it — the partial unique index stage_event_one_fell_idx. False everywhere else, including on every stage of a bill that passed.';

COMMENT ON COLUMN stage_event.completed IS
  'True if the bill got through this stage. False means it reached the stage and stopped there, which is a different fact from never having reached it — a bill sitting in Stage 2 at dissolution has a Stage 2 row with completed false, and no Stage 3 row at all.';

COMMENT ON COLUMN stage_event.stage_order IS
  'Where this stage comes in its own bill type''s sequence: 1, 2, 3 or 4. It exists so a Private Bill''s Consideration Stage can be compared with an ordinary bill''s Stage 2 without claiming they are the same stage. Which stage sits at which position for which bill type is in ref_bill_type_stage, and a trigger refuses any other combination.';


-- ===========================================================================
-- field_source — append-only is now a property of the table, not a habit.
-- ===========================================================================

COMMENT ON TABLE field_source IS
  'Where one individual field came from, when that is not where the rest of its row came from — a bill whose outcome came from a factsheet but whose Stage 1 date came from the Official Report. Rows can only be added: the database refuses an update or a delete, so reading a source again produces a second observation beside the first rather than replacing it, and a revision to a published record is visible instead of silent. That is what settles D5.';

COMMENT ON COLUMN field_source.entity IS
  'Which table the field lives in. The database allows three values and no others: bill, stage_event and session. Provenance cannot be recorded at this level about anything else, including a staging row — bill_candidate keeps its own source columns.';

COMMENT ON COLUMN field_source.entity_id IS
  'Which row in that table, by its identifier. Not checked against the table it names: nothing stops this pointing at a row that does not exist, or at a different row than intended if bill is ever emptied and re-promoted.';

COMMENT ON COLUMN field_source.field_name IS
  'Which column of that row this provenance is about. A trigger checks the name against the real table, so a misspelling is refused rather than quietly orphaning the record.';

COMMENT ON COLUMN field_source.value_seen IS
  'The value in the source''s own words, before any tidying — what was actually printed, not what we made of it. This is what a later disagreement is visible against: without it a revised source can only be noticed as a different value, never as a different wording.';

COMMENT ON COLUMN field_source.observed_at IS
  'The date we read the source. Not the date of the event it describes — the date we looked. Two rows for the same field differ by this.';

COMMENT ON COLUMN field_source.note IS
  'Free text for anything worth saying about this observation. Empty is normal.';


-- ===========================================================================
-- session, methodology_note — row counts out of the descriptions.
-- ===========================================================================

COMMENT ON TABLE session IS
  'The parliamentary sessions, one row each. A session runs from the Parliament''s first meeting after an election to its dissolution before the next. Every bill belongs to the session it was introduced in.';

COMMENT ON COLUMN session.session_number IS
  'The session number — 1 for the Parliament elected in 1999, counting up. This is the identifier the rest of the database uses. The database accepts up to 20, so a new session needs no schema change.';

COMMENT ON TABLE methodology_note IS
  'The judgement calls made in building this data, written out for readers rather than kept in the repository. One row per judgement, referred to by code as M1, M2 and so on. The website shows each note against the columns named in applies_to, so what the site tells a reader and what the data does cannot drift apart.';

COMMENT ON COLUMN methodology_note.code IS
  'Short code for the note — M1, M2 and so on — used to refer to it from a column description, a decision record, or the website.';

COMMENT ON COLUMN methodology_note.applies_to IS
  'Which columns this note is about, each written as table.column. The website uses it to put the note where a reader will meet the problem. A name here is not checked against the real table, so a column that is renamed or dropped leaves this pointing at nothing — db/023 had to fix exactly that.';


-- ===========================================================================
-- The lists of allowed values. Their columns described what they are for
-- mechanically -- "the value stored in x", "how to display it" -- which
-- says nothing a reader could not already see. Row counts removed.
-- ===========================================================================

COMMENT ON TABLE ref_bill_type IS
  'Who introduced the bill. Every allowed value for bill.bill_type is a row here, with its own definition, so a value can be added or re-labelled without changing the schema and so each one carries the text explaining it to a reader.';

COMMENT ON COLUMN ref_bill_type.code IS
  'The short word stored in bill.bill_type and used in queries. Readable on purpose, so a row shows "government" rather than a number that has to be looked up.';

COMMENT ON COLUMN ref_bill_type.label IS
  'The full name to show a reader, e.g. "Government Bill". The code is what queries and data files use; this is what a person sees on screen.';

COMMENT ON COLUMN ref_bill_type.definition IS
  'What this bill type means, in the Parliament''s terms. This is the text to show a reader who asks what a value means, and it is the reason the allowed values live in a table rather than as a bare list inside the schema.';

COMMENT ON COLUMN ref_bill_type.sort_order IS
  'The order to list these values in on screen. A display choice, not a fact about the bill type.';

COMMENT ON TABLE ref_bill_type_stated IS
  'How a bill type was written at the time, which is not always how we classify it. Every allowed value for bill.bill_type_stated is a row here, with its own definition, so a value can be added or re-labelled without changing the schema and so each one carries the text explaining it to a reader.';

COMMENT ON COLUMN ref_bill_type_stated.code IS
  'The short word stored in bill.bill_type_stated and used in queries. Readable on purpose, so a row shows "executive" rather than a number that has to be looked up.';

COMMENT ON COLUMN ref_bill_type_stated.label IS
  'The full name to show a reader, e.g. "Executive Bill". The code is what queries and data files use; this is what a person sees on screen.';

COMMENT ON COLUMN ref_bill_type_stated.definition IS
  'What this styling means, in the Parliament''s terms. This is the text to show a reader who asks what a value means, and it is the reason the allowed values live in a table rather than as a bare list inside the schema.';

COMMENT ON COLUMN ref_bill_type_stated.sort_order IS
  'The order to list these values in on screen. A display choice, not a fact about the styling.';

COMMENT ON TABLE ref_enactment_status IS
  'Whether the bill became an Act. Every allowed value for bill.enactment_status is a row here, with its own definition, so a value can be added or re-labelled without changing the schema and so each one carries the text explaining it to a reader.';

COMMENT ON COLUMN ref_enactment_status.code IS
  'The short word stored in bill.enactment_status and used in queries. Readable on purpose, so a row shows "not_enacted" rather than a number that has to be looked up.';

COMMENT ON COLUMN ref_enactment_status.label IS
  'The full name to show a reader, e.g. "Not enacted". The code is what queries and data files use; this is what a person sees on screen.';

COMMENT ON COLUMN ref_enactment_status.definition IS
  'What this status means, in the Parliament''s terms. This is the text to show a reader who asks what a value means, and it is the reason the allowed values live in a table rather than as a bare list inside the schema.';

COMMENT ON COLUMN ref_enactment_status.sort_order IS
  'The order to list these values in on screen. A display choice, not a fact about the status.';

COMMENT ON TABLE ref_outcome IS
  'What the Parliament did with the bill. Every allowed value for bill.outcome is a row here, with its own definition, so a value can be added or re-labelled without changing the schema and so each one carries the text explaining it to a reader.';

COMMENT ON COLUMN ref_outcome.code IS
  'The short word stored in bill.outcome and used in queries. Readable on purpose, so a row shows "fell_dissolution" rather than a number that has to be looked up.';

COMMENT ON COLUMN ref_outcome.label IS
  'The full name to show a reader, e.g. "Fell at dissolution". The code is what queries and data files use; this is what a person sees on screen.';

COMMENT ON COLUMN ref_outcome.definition IS
  'What this outcome means, in the Parliament''s terms. This is the text to show a reader who asks what a value means, and it is the reason the allowed values live in a table rather than as a bare list inside the schema.';

COMMENT ON COLUMN ref_outcome.sort_order IS
  'The order to list these values in on screen. A display choice, not a fact about the outcome.';

COMMENT ON TABLE ref_party IS
  'The party of the member in charge. Every allowed value for bill.party is a row here, with its own definition, so a value can be added or re-labelled without changing the schema and so each one carries the text explaining it to a reader.';

COMMENT ON COLUMN ref_party.code IS
  'The short word stored in bill.party and used in queries. Readable on purpose, so a row shows "independent" rather than a number that has to be looked up.';

COMMENT ON COLUMN ref_party.label IS
  'The full name to show a reader, e.g. "Independent". The code is what queries and data files use; this is what a person sees on screen.';

COMMENT ON COLUMN ref_party.definition IS
  'What this party means, in the Parliament''s terms. This is the text to show a reader who asks what a value means, and it is the reason the allowed values live in a table rather than as a bare list inside the schema.';

COMMENT ON COLUMN ref_party.sort_order IS
  'The order to list these values in on screen. A display choice, not a fact about the party.';

COMMENT ON TABLE ref_procedure IS
  'How the bill was handled under the Parliament''s rules. Every allowed value for bill.procedure is a row here, with its own definition, so a value can be added or re-labelled without changing the schema and so each one carries the text explaining it to a reader.';

COMMENT ON COLUMN ref_procedure.code IS
  'The short word stored in bill.procedure and used in queries. Readable on purpose, so a row shows "emergency" rather than a number that has to be looked up.';

COMMENT ON COLUMN ref_procedure.label IS
  'The full name to show a reader, e.g. "Emergency". The code is what queries and data files use; this is what a person sees on screen.';

COMMENT ON COLUMN ref_procedure.definition IS
  'What this procedure means, in the Parliament''s terms. This is the text to show a reader who asks what a value means, and it is the reason the allowed values live in a table rather than as a bare list inside the schema.';

COMMENT ON COLUMN ref_procedure.sort_order IS
  'The order to list these values in on screen. A display choice, not a fact about the procedure.';

COMMENT ON TABLE ref_source IS
  'The kinds of source this project takes facts from. Every allowed value for any source column is a row here, with its own definition, so a value can be added or re-labelled without changing the schema and so each one carries the text explaining it to a reader.';

COMMENT ON COLUMN ref_source.code IS
  'The short word stored in any source column and used in queries. Readable on purpose, so a row shows "spice_factsheet" rather than a number that has to be looked up.';

COMMENT ON COLUMN ref_source.label IS
  'The full name to show a reader, e.g. "SPICe legislation factsheet". The code is what queries and data files use; this is what a person sees on screen.';

COMMENT ON COLUMN ref_source.definition IS
  'What this kind of source means, in the Parliament''s terms. This is the text to show a reader who asks what a value means, and it is the reason the allowed values live in a table rather than as a bare list inside the schema.';

COMMENT ON COLUMN ref_source.sort_order IS
  'The order to list these values in on screen. A display choice, not a fact about the kind of source.';

COMMENT ON TABLE ref_stage IS
  'The names stages actually have, covering both the Stage 1/2/3 sequence and the Preliminary/Consideration/Final sequence Private and Hybrid Bills use. Every allowed value for stage_event.stage is a row here, with its own definition, so a value can be added or re-labelled without changing the schema and so each one carries the text explaining it to a reader.';

COMMENT ON COLUMN ref_stage.code IS
  'The short word stored in stage_event.stage and used in queries. Readable on purpose, so a row shows "preliminary" rather than a number that has to be looked up.';

COMMENT ON COLUMN ref_stage.label IS
  'The full name to show a reader, e.g. "Preliminary Stage". The code is what queries and data files use; this is what a person sees on screen.';

COMMENT ON COLUMN ref_stage.definition IS
  'What this stage means, in the Parliament''s terms. This is the text to show a reader who asks what a value means, and it is the reason the allowed values live in a table rather than as a bare list inside the schema.';

COMMENT ON COLUMN ref_stage.sort_order IS
  'The order to list these values in on screen. A display choice, not a fact about the stage.';

COMMENT ON TABLE ref_bill_type_stage IS
  'Which stages belong to which kind of bill, and in what order. Five bill types times four positions: government, members and committee bills run Stage 1, 2 and 3 then Reconsideration; private and hybrid bills run Preliminary, Consideration and Final Stage then Reconsideration. A trigger on stage_event reads this table, so the database refuses a Stage 2 recorded against a Private Bill, or a Preliminary Stage against a Government Bill, or a real stage name at the wrong position.';

COMMENT ON COLUMN ref_bill_type_stage.bill_type IS
  'The kind of bill this sequence belongs to, from ref_bill_type.';

COMMENT ON COLUMN ref_bill_type_stage.stage_order IS
  'Position in that bill type''s own sequence: 1, 2, 3 or 4. The same number means the same point in the process across bill types, which is what makes durations comparable between a Private Bill and a Government Bill.';

COMMENT ON COLUMN ref_bill_type_stage.stage IS
  'The stage that sits at that position for that bill type, from ref_stage. This is the pairing that lets the two sequences be compared without pretending the names match.';

COMMENT ON COLUMN ref_bill_type.analysis_group IS
  'The bill type this one is counted as when types are grouped for analysis. Every type groups to itself except hybrid, which groups to government. Group on bill_type to see Hybrid Bills separately; group on analysis_group to fold them in, which is what the SPICe factsheets do without saying so — the Session 3 factsheet defines a Hybrid type, applies it to one bill, then counts that bill under Executive. See methodology note M4.';

COMMIT;
