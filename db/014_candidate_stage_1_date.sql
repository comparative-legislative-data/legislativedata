-- 014_candidate_stage_1_date.sql
-- bill_candidate was built to mirror what the SPICe factsheets carry, and they
-- carry no stage dates — only introduced, passed and Royal Assent. The Official
-- Report supplies Stage 1 decision dates for the five Session 1 bills that were
-- rejected at Stage 1, so the staging table needs somewhere to put them.
--
-- Only Stage 1. No source consulted so far gives a Stage 2 date, and there is no
-- point in a column for data that does not exist yet.

BEGIN;

ALTER TABLE bill_candidate ADD COLUMN end_stage_1_date date;

COMMENT ON COLUMN bill_candidate.end_stage_1_date IS
 'Date Stage 1 completed. For a bill rejected at Stage 1 this is the date of that decision, which is also the date it fell — the same date recording two different facts. See methodology note M2. Not available from the factsheets.';

COMMIT;
