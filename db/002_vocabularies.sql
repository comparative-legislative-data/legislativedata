-- 002_vocabularies.sql
-- Seed values for the lookup tables, and the seven sessions.
-- These are proposals: add, re-label or remove values in the grid as needed.
-- Session dates are deliberately left NULL rather than guessed.

BEGIN;

INSERT INTO ref_bill_type (code, label, definition, sort_order) VALUES
 ('government','Government Bill','Introduced by the Scottish Government. Called an Executive Bill before 2007; one value, with the contemporary label reconstructable from the session.',1),
 ('members','Member''s Bill','Introduced by an individual MSP.',2),
 ('committee','Committee Bill','Introduced by a committee of the Parliament.',3),
 ('private','Private Bill','Promoted for private interests; uses its own stage sequence.',4),
 ('hybrid','Hybrid Bill','Introduced under the hybrid bill procedure. First session in which this is possible needs confirming.',5);

INSERT INTO ref_procedure (code, label, definition, sort_order) VALUES
 ('standard','Standard','Ordinary three-stage procedure.',1),
 ('emergency','Emergency','Stages compressed, often into a single day. Flag rather than exclude: these distort duration averages.',2),
 ('budget','Budget','Budget Bill procedure.',3),
 ('consolidation','Consolidation','Consolidation of existing law.',4),
 ('statute_law_repeals','Statute Law Repeals',NULL,5),
 ('statute_law_revision','Statute Law Revision',NULL,6);

INSERT INTO ref_outcome (code, label, definition, is_final, sort_order) VALUES
 ('passed','Passed','Passed at Stage 3.',true,1),
 ('rejected_stage_1','Rejected at Stage 1','General principles not agreed to.',true,2),
 ('rejected_stage_3','Rejected at Stage 3','Defeated at the final vote.',true,3),
 ('withdrawn','Withdrawn','Withdrawn by the member in charge.',true,4),
 ('fell_dissolution','Fell at dissolution','Not concluded when the session ended.',true,5),
 ('fell_other','Fell (other)','Fell for another reason; record it in note.',true,6),
 ('in_progress','In progress','Still before Parliament.',false,7);

INSERT INTO ref_enactment_status (code, label, definition, sort_order) VALUES
 ('enacted','Enacted','Received Royal Assent and became an Act.',1),
 ('not_enacted','Not enacted','Did not become an Act.',2),
 ('pending','Pending','Passed but assent not yet determined, including referral.',3),
 ('blocked','Blocked','Passed but prevented from receiving assent.',4);

INSERT INTO ref_stage (code, label, definition, applies_to, sort_order) VALUES
 ('introduction','Introduction','Bill introduced.','both',1),
 ('stage_1','Stage 1','General principles.','public',2),
 ('stage_2','Stage 2','Committee consideration of amendments.','public',3),
 ('stage_3','Stage 3','Final consideration and the decision to pass.','public',4),
 ('preliminary','Preliminary Stage','Private bill equivalent of Stage 1.','private',5),
 ('consideration','Consideration Stage','Private bill amendment stage.','private',6),
 ('final','Final Stage','Private bill final stage.','private',7),
 ('reconsideration','Reconsideration Stage','After referral or a section 35 order. Breaks the assumption that Stage 3 is the end.','both',8),
 ('royal_assent','Royal Assent','Assent granted.','both',9);

INSERT INTO ref_source (code, label, definition, sort_order) VALUES
 ('api','Parliament API','data.parliament.scot.',1),
 ('official_report','Official Report','Chamber or committee proceedings.',2),
 ('bill_document','Bill document','Bill as introduced, marshalled list, explanatory notes.',3),
 ('phd','PhD dataset','Coded for the 2022 thesis. Ground truth where it covers a case.',4),
 ('manual','Manual','Entered by hand from knowledge or a source not otherwise listed; say which in note.',5);

INSERT INTO session (session_number, is_current, note) VALUES
 (1,false,'Dates to be filled in.'),
 (2,false,'Dates to be filled in.'),
 (3,false,'Dates to be filled in.'),
 (4,false,'Dates to be filled in.'),
 (5,false,'Dates to be filled in.'),
 (6,false,'Dates to be filled in.'),
 (7,true ,'Not published on the API. Dates to be filled in.');

COMMIT;
