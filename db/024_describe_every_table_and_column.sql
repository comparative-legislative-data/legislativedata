-- 024_describe_every_table_and_column.sql
-- A plain-English description on every table and every column.
--
-- Why this is a migration and not a document: a document written beside the
-- database drifts from it, which is what happened to docs/VARIABLES.md. A
-- comment stored IN the database cannot drift, is shown by Postico next to the
-- column it describes, and is what docs/DATA-DICTIONARY.md is generated from.
-- There is one source of truth and this is it.
--
-- 130 columns. 110 had no description at all before this migration.
--
-- House style for these descriptions: one sentence, plain English, no jargon.
-- Say what the column holds. Where it can be empty, say what empty means,
-- because "empty" and "zero" and "not applicable" are different facts.

BEGIN;

-- ===========================================================================
-- session — the seven parliaments.
-- ===========================================================================
COMMENT ON TABLE session IS 'The seven parliamentary sessions. Seven rows, one per session. A session runs from the first meeting after an election to dissolution before the next.';
COMMENT ON COLUMN session.session_number IS 'The session number, 1 to 7. This is the identifier the rest of the database uses.';
COMMENT ON COLUMN session.date_first_meeting IS 'Date the Parliament first met in this session. Empty means not yet filled in.';
COMMENT ON COLUMN session.date_dissolution IS 'Date the Parliament was dissolved before the next election. Empty means either not yet filled in, or the session is still running.';
COMMENT ON COLUMN session.is_current IS 'True for the session running now. Stored rather than worked out, so the current session is unambiguous while its dissolution date is still empty.';
COMMENT ON COLUMN session.note IS 'Free text for anything unusual about the session.';

-- ===========================================================================
-- bill — one row per bill. The live table.
-- ===========================================================================
COMMENT ON TABLE bill IS 'One row per bill. This is the checked, live data. A row only gets here by being promoted from bill_candidate, never by being typed in directly.';
COMMENT ON COLUMN bill.bill_id IS 'Our own identifier for the bill. Made up by us, not the Parliament''s. Never changes.';
COMMENT ON COLUMN bill.sp_bill_id IS 'The Parliament''s bill number within its session, e.g. 70 for SP Bill 70. Unique within a session, not across sessions. Empty where none is known — the Session 1 factsheet gives no numbers, and Sessions 2 to 5 give them only for bills that did not become Acts.';
COMMENT ON COLUMN bill.session_number IS 'Which session the bill was first introduced in. Points at the session table. A bill keeps this number however long it takes and whatever happens to it — see methodology note M6.';
COMMENT ON COLUMN bill.short_title IS 'The title the bill is known by at the latest point there is evidence for: the Act''s title where it became an Act, otherwise the title it had when it ended. This is the title to display.';
COMMENT ON COLUMN bill.title_as_introduced IS 'The title the bill had when it was introduced. Empty means not known, which is the usual case. Empty never means the title did not change.';
COMMENT ON COLUMN bill.bill_type IS 'Who introduced the bill: government, members, committee, private or hybrid. Allowed values are in ref_bill_type.';
COMMENT ON COLUMN bill.bill_type_stated IS 'How the type was written at the time — Executive Bill or Government Bill. Kept separately so a count of government bills stays continuous. Empty means not known. Allowed values are in ref_bill_type_stated.';
COMMENT ON COLUMN bill.procedure IS 'How the bill was handled under the Parliament''s rules: standard, emergency, budget and so on. Empty means not known. Do not fill this in with "standard" as a guess — no source consulted so far states it. Allowed values are in ref_procedure.';
COMMENT ON COLUMN bill.party IS 'Party of the member in charge. Empty means not applicable or not known, which includes bills introduced by a Law Officer. Independent is a real value, not an empty one. Allowed values are in ref_party.';
COMMENT ON COLUMN bill.date_introduced IS 'Date the bill was introduced. Empty means not known.';
COMMENT ON COLUMN bill.outcome IS 'What the Parliament did with the bill: passed, rejected, withdrawn, fell. Allowed values are in ref_outcome. This is deliberately separate from whether it became an Act.';
COMMENT ON COLUMN bill.enactment_status IS 'Whether the bill became an Act: enacted, not enacted, pending, or blocked. Allowed values are in ref_enactment_status. A bill can be passed and still not become an Act — see methodology note M5.';
COMMENT ON COLUMN bill.date_royal_assent IS 'Date the bill received Royal Assent and became an Act. Empty if it never did.';
COMMENT ON COLUMN bill.date_assent_blocked IS 'Date the bill was stopped from being sent for Royal Assent, by a Supreme Court ruling or by a UK Government order. Kept even if the block is later lifted. Empty means it never happened.';
COMMENT ON COLUMN bill.date_concluded IS 'Date the bill stopped being a live bill without becoming an Act — the date it was withdrawn, or fell. Empty for a bill that became an Act (its ending is the Royal Assent date) and empty for a bill still live.';
COMMENT ON COLUMN bill.asp_number IS 'The Act''s number, e.g. "2016 asp 8". Held here rather than left inside the title. Empty if the bill did not become an Act.';
COMMENT ON COLUMN bill.source IS 'Where this row''s facts came from. Allowed values are in ref_source.';
COMMENT ON COLUMN bill.source_ref IS 'The exact place within that source — which factsheet, which page.';
COMMENT ON COLUMN bill.observed_at IS 'The date we read the source. Matters because the Parliament revises published records.';
COMMENT ON COLUMN bill.note IS 'Free text for anything irregular about this bill. Also where a rename date goes, and where the reason a bill was blocked goes.';
COMMENT ON COLUMN bill.created_at IS 'When this row was first created. Set automatically.';
COMMENT ON COLUMN bill.updated_at IS 'When this row was last changed. Set automatically.';

-- ===========================================================================
-- bill_candidate — the staging table.
-- ===========================================================================
COMMENT ON TABLE bill_candidate IS 'One row per line read off a factsheet. This is the staging area: nothing here is treated as fact until it is reviewed and promoted into bill. Rows are kept permanently, including rejected ones, because they are the record of what the source actually said. Read it as three groups of columns: raw_ columns are the factsheet''s own words, the middle group is what we propose, and the review_ columns are the gate.';
COMMENT ON COLUMN bill_candidate.candidate_id IS 'Our identifier for this staged row.';
COMMENT ON COLUMN bill_candidate.session_number IS 'Which session''s factsheet this row was read from. Note this is the factsheet''s session, which for a handful of bills is not the session the bill belongs to.';
COMMENT ON COLUMN bill_candidate.raw_title IS 'The title exactly as the factsheet prints it, before any tidying.';
COMMENT ON COLUMN bill_candidate.raw_type IS 'The type letter exactly as the factsheet prints it: E, G, G*, M, C, P or H.';
COMMENT ON COLUMN bill_candidate.raw_date_introduced IS 'The introduction date exactly as printed, e.g. "6 October 1999".';
COMMENT ON COLUMN bill_candidate.raw_introduced_by IS 'Who introduced it, exactly as printed — a person, a committee, or a promoter. Not yet used; kept for a later slice.';
COMMENT ON COLUMN bill_candidate.raw_date_final IS 'The date in the last date column, exactly as printed. What it means depends on which table the row came from: passed, withdrawn, or fell.';
COMMENT ON COLUMN bill_candidate.raw_date_royal_assent IS 'The Royal Assent date exactly as printed.';
COMMENT ON COLUMN bill_candidate.raw_section IS 'Which table of the factsheet this row came from: acts, withdrawn, or fallen. This is the factsheet''s own classification.';
COMMENT ON COLUMN bill_candidate.sp_bill_id IS 'The SP Bill number, if the factsheet gives one.';
COMMENT ON COLUMN bill_candidate.short_title IS 'The title after tidying — the asp number taken out, line breaks joined up.';
COMMENT ON COLUMN bill_candidate.title_kind IS 'Whether the title in short_title is an Act title or a Bill title. Either "act" or "bill".';
COMMENT ON COLUMN bill_candidate.bill_type IS 'The bill type we propose, worked out from the type letter. Must be a value in ref_bill_type.';
COMMENT ON COLUMN bill_candidate.bill_type_stated IS 'The type as it was styled at the time, worked out from the type letter. Must be a value in ref_bill_type_stated.';
COMMENT ON COLUMN bill_candidate.procedure IS 'Procedure, if known. Normally empty: no factsheet states it.';
COMMENT ON COLUMN bill_candidate.date_introduced IS 'The introduction date, converted to a real date from raw_date_introduced.';
COMMENT ON COLUMN bill_candidate.end_stage_1_date IS 'Date Stage 1 was completed. For a bill rejected at Stage 1 this is the date of that decision, which is also the date it fell. Not available from the factsheets — filled in by hand from the Official Report.';
COMMENT ON COLUMN bill_candidate.end_stage_3_date IS 'Date the bill was passed, which is the date Stage 3 was completed. Empty if it was not passed.';
COMMENT ON COLUMN bill_candidate.date_concluded IS 'Date the bill was withdrawn or fell. Empty if it was passed.';
COMMENT ON COLUMN bill_candidate.date_royal_assent IS 'Royal Assent date, converted to a real date.';
COMMENT ON COLUMN bill_candidate.asp_number IS 'The Act number pulled out of the title, e.g. "2000 asp 5".';
COMMENT ON COLUMN bill_candidate.outcome IS 'The outcome we propose. Must be a value in ref_outcome.';
COMMENT ON COLUMN bill_candidate.enactment_status IS 'The enactment status we propose. Must be a value in ref_enactment_status.';
COMMENT ON COLUMN bill_candidate.source IS 'Where this row came from. Normally spice_factsheet.';
COMMENT ON COLUMN bill_candidate.source_ref IS 'Which factsheet and which page.';
COMMENT ON COLUMN bill_candidate.observed_at IS 'The date the source was read.';
COMMENT ON COLUMN bill_candidate.src_file IS 'The exact file the row was extracted from, by name.';
COMMENT ON COLUMN bill_candidate.src_page IS 'The page of that file the row was on.';
COMMENT ON COLUMN bill_candidate.parser_note IS 'Anything the extraction script noticed while reading the row — a date it could not parse, a cell that looked odd. Mechanical observations only, never guesses.';
COMMENT ON COLUMN bill_candidate.extracted_at IS 'When the extraction script created this row. Set automatically.';
COMMENT ON COLUMN bill_candidate.review_status IS 'THE GATE. One of: new (not looked at), accepted (checked and admitted), rejected (checked and refused), held (needs more work). Only accepted rows can be promoted.';
COMMENT ON COLUMN bill_candidate.review_note IS 'What the reviewer decided and why, including any citation used to settle a question.';
COMMENT ON COLUMN bill_candidate.reviewed_at IS 'When the row was reviewed. Empty means it has not been.';
COMMENT ON COLUMN bill_candidate.promoted_bill_id IS 'Which row in bill this candidate became. Empty means it has not been promoted. This is the only link between the staging table and the live table.';
COMMENT ON COLUMN bill_candidate.promoted_at IS 'When it was promoted. Empty means it has not been.';
COMMENT ON COLUMN bill_candidate.updated_at IS 'When this row was last changed. Set automatically.';

-- ===========================================================================
-- stage_event — stage dates.
-- ===========================================================================
COMMENT ON TABLE stage_event IS 'One row per stage a bill actually reached. A bill that fell at Stage 1 has one row, not three. Stages are recorded under their real names for that kind of bill: Stage 1, 2 and 3 for most bills, Preliminary, Consideration and Final Stage for Private and Hybrid Bills. Currently empty — it fills up when promotion runs.';
COMMENT ON COLUMN stage_event.stage_event_id IS 'Our identifier for this stage row.';
COMMENT ON COLUMN stage_event.bill_id IS 'Which bill this stage belongs to. Points at the bill table.';
COMMENT ON COLUMN stage_event.stage IS 'The stage''s real name for this kind of bill. Allowed values are in ref_stage, and which ones are allowed for which bill type is in ref_bill_type_stage.';
COMMENT ON COLUMN stage_event.stage_order IS 'Where this stage comes in the bill''s own sequence: 1, 2, 3 or 4. Use this to compare a Private Bill''s third stage with an ordinary bill''s third stage without claiming they are the same stage.';
COMMENT ON COLUMN stage_event.date_completed IS 'Date the stage was completed. Empty if the bill reached the stage but never completed it.';
COMMENT ON COLUMN stage_event.completed IS 'True if the stage was completed. False means the bill got there and stopped.';
COMMENT ON COLUMN stage_event.fell_here IS 'True if the bill ended at this stage. At most one true row per bill.';
COMMENT ON COLUMN stage_event.source IS 'Where this stage date came from. Allowed values are in ref_source.';
COMMENT ON COLUMN stage_event.source_ref IS 'The exact place within that source.';
COMMENT ON COLUMN stage_event.observed_at IS 'The date the source was read.';
COMMENT ON COLUMN stage_event.note IS 'Free text for anything irregular about this stage.';
COMMENT ON COLUMN stage_event.created_at IS 'When this row was created. Set automatically.';
COMMENT ON COLUMN stage_event.updated_at IS 'When this row was last changed. Set automatically.';

-- ===========================================================================
-- field_source — provenance for one field at a time.
-- ===========================================================================
COMMENT ON TABLE field_source IS 'Records where a single field came from, when that differs from where the rest of the row came from — for example a bill whose outcome came from a factsheet but whose dates came from the Official Report. Rows are only ever added, never changed, so a revised published record produces a second row rather than overwriting the first. Currently empty.';
COMMENT ON COLUMN field_source.field_source_id IS 'Our identifier for this provenance row.';
COMMENT ON COLUMN field_source.entity IS 'Which table the field is in, e.g. "bill".';
COMMENT ON COLUMN field_source.entity_id IS 'Which row in that table.';
COMMENT ON COLUMN field_source.field_name IS 'Which column. Checked against the real table, so a typo is refused.';
COMMENT ON COLUMN field_source.source IS 'Where this one field came from. Allowed values are in ref_source.';
COMMENT ON COLUMN field_source.source_ref IS 'The exact place within that source.';
COMMENT ON COLUMN field_source.value_seen IS 'The value in the source''s own words, before any tidying. This is what makes a later disagreement visible.';
COMMENT ON COLUMN field_source.observed_at IS 'The date the source was read. Not the date of the event — the date we looked.';
COMMENT ON COLUMN field_source.note IS 'Free text.';
COMMENT ON COLUMN field_source.created_at IS 'When this row was added. Set automatically.';

-- ===========================================================================
-- methodology_note — the judgement calls, for publication.
-- ===========================================================================
COMMENT ON TABLE methodology_note IS 'The judgement calls made in building this data, written out for readers. One row per judgement. The website shows these next to the variables they affect, so what the site says and what the data does cannot drift apart. Seven rows, M1 to M7.';
COMMENT ON COLUMN methodology_note.code IS 'Short code for the note, M1 to M7. Used to refer to it elsewhere.';
COMMENT ON COLUMN methodology_note.title IS 'One-line summary of the judgement.';
COMMENT ON COLUMN methodology_note.body IS 'The full explanation, as a reader of the published data should see it.';
COMMENT ON COLUMN methodology_note.applies_to IS 'Which columns this note is about, written as table.column. The website uses this to show the note in the right place.';
COMMENT ON COLUMN methodology_note.sort_order IS 'The order the notes are listed in.';
COMMENT ON COLUMN methodology_note.created_at IS 'When this note was added. Set automatically.';
COMMENT ON COLUMN methodology_note.updated_at IS 'When this note was last changed. Set automatically.';

-- ===========================================================================
-- The ref_ tables — allowed values for one column each.
-- ===========================================================================
COMMENT ON TABLE ref_bill_type IS 'Allowed values for bill.bill_type: who introduced the bill. Five rows.';
COMMENT ON COLUMN ref_bill_type.code IS 'The value stored in bill.bill_type.';
COMMENT ON COLUMN ref_bill_type.label IS 'How to display it, e.g. "Government Bill".';
COMMENT ON COLUMN ref_bill_type.definition IS 'What this type means.';
COMMENT ON COLUMN ref_bill_type.sort_order IS 'The order to list them in.';

COMMENT ON TABLE ref_bill_type_stated IS 'Allowed values for bill.bill_type_stated: how the type was written at the time. Separate from ref_bill_type so that "executive" cannot leak into a count of bill types and split the government series. Six rows.';
COMMENT ON COLUMN ref_bill_type_stated.code IS 'The value stored in bill.bill_type_stated.';
COMMENT ON COLUMN ref_bill_type_stated.label IS 'How to display it.';
COMMENT ON COLUMN ref_bill_type_stated.definition IS 'What this label meant and when it was used.';
COMMENT ON COLUMN ref_bill_type_stated.sort_order IS 'The order to list them in.';

COMMENT ON TABLE ref_outcome IS 'Allowed values for bill.outcome: what the Parliament did with the bill. Seven rows.';
COMMENT ON COLUMN ref_outcome.code IS 'The value stored in bill.outcome.';
COMMENT ON COLUMN ref_outcome.label IS 'How to display it.';
COMMENT ON COLUMN ref_outcome.definition IS 'What this outcome means.';
COMMENT ON COLUMN ref_outcome.is_final IS 'True if this outcome means the Parliament has finished with the bill. False for "in progress".';
COMMENT ON COLUMN ref_outcome.sort_order IS 'The order to list them in.';

COMMENT ON TABLE ref_enactment_status IS 'Allowed values for bill.enactment_status: whether the bill became an Act. Four rows.';
COMMENT ON COLUMN ref_enactment_status.code IS 'The value stored in bill.enactment_status.';
COMMENT ON COLUMN ref_enactment_status.label IS 'How to display it.';
COMMENT ON COLUMN ref_enactment_status.definition IS 'What this status means.';
COMMENT ON COLUMN ref_enactment_status.sort_order IS 'The order to list them in.';

COMMENT ON TABLE ref_procedure IS 'Allowed values for bill.procedure: how the bill was handled under the Parliament''s rules. Six rows.';
COMMENT ON COLUMN ref_procedure.code IS 'The value stored in bill.procedure.';
COMMENT ON COLUMN ref_procedure.label IS 'How to display it.';
COMMENT ON COLUMN ref_procedure.definition IS 'What this procedure means.';
COMMENT ON COLUMN ref_procedure.sort_order IS 'The order to list them in.';

COMMENT ON TABLE ref_party IS 'Allowed values for bill.party: the party of the member in charge. Seven rows.';
COMMENT ON COLUMN ref_party.code IS 'The value stored in bill.party.';
COMMENT ON COLUMN ref_party.label IS 'How to display it.';
COMMENT ON COLUMN ref_party.definition IS 'Anything worth saying about this party value.';
COMMENT ON COLUMN ref_party.sort_order IS 'The order to list them in.';

COMMENT ON TABLE ref_source IS 'Allowed values for any source column: the kinds of source this project takes facts from. Six rows.';
COMMENT ON COLUMN ref_source.code IS 'The value stored in a source column.';
COMMENT ON COLUMN ref_source.label IS 'How to display it.';
COMMENT ON COLUMN ref_source.definition IS 'What this source is and how far it can be relied on.';
COMMENT ON COLUMN ref_source.sort_order IS 'The order to list them in.';

COMMENT ON TABLE ref_stage IS 'Allowed values for stage_event.stage: the names stages actually have. Nine rows, covering both the ordinary Stage 1/2/3 sequence and the Preliminary/Consideration/Final sequence Private and Hybrid Bills use.';
COMMENT ON COLUMN ref_stage.code IS 'The value stored in stage_event.stage.';
COMMENT ON COLUMN ref_stage.label IS 'How to display it, e.g. "Preliminary Stage".';
COMMENT ON COLUMN ref_stage.definition IS 'What happens at this stage.';
COMMENT ON COLUMN ref_stage.sort_order IS 'The order to list them in.';

COMMENT ON TABLE ref_bill_type_stage IS 'Which stages belong to which kind of bill, and in what order. Twenty rows: five bill types times four positions. The database uses this to refuse a Stage 2 recorded against a Private Bill, or a Preliminary Stage against a Government Bill.';
COMMENT ON COLUMN ref_bill_type_stage.bill_type IS 'The bill type, from ref_bill_type.';
COMMENT ON COLUMN ref_bill_type_stage.stage_order IS 'Position in that bill type''s sequence: 1, 2, 3 or 4.';
COMMENT ON COLUMN ref_bill_type_stage.stage IS 'The stage that belongs at that position for that bill type, from ref_stage.';

COMMIT;
