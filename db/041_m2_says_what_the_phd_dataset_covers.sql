-- 041_m2_says_what_the_phd_dataset_covers.sql
--
-- Methodology note M2 said the owner's dataset "covers Sessions 1 to 6". That
-- was written at db/033 from the thesis's own span, and is wrong twice over,
-- as the owner set out on 2026-09-12:
--   - the published thesis covers Sessions 1 to 5;
--   - collection continued after it, so the dataset also covers Sessions 6
--     and 7.
-- The file supplied on 2026-09-11 holds 469 bills across all seven sessions,
-- the latest introduced on 9 September 2026. A bill has no Stage 1 or Stage 2
-- date in it only where it has not yet reached that stage: Session 7's single
-- bill, and five in Session 6.
--
-- M2 is published beside the figures, so the wording is the owner's; this is
-- the correction they gave.

BEGIN;

UPDATE methodology_note
   SET body = replace(
         body,
         'which covers Sessions 1 to 6. They are added one session at a time;',
         'which covers Sessions 1 to 5 as published, and which has been maintained since, '
         'so that it covers Sessions 6 and 7 as well. A bill has no Stage 1 or Stage 2 date '
         'in it only where it has not yet reached that stage. They are added one session at '
         'a time;')
 WHERE code = 'M2';

DO $$
DECLARE b text;
BEGIN
  SELECT body INTO b FROM methodology_note WHERE code = 'M2';
  IF b LIKE '%covers Sessions 1 to 6.%' THEN
    RAISE EXCEPTION 'M2 still says the dataset covers Sessions 1 to 6.';
  END IF;
  IF b NOT LIKE '%Sessions 1 to 5 as published%'
     OR b NOT LIKE '%covers Sessions 6 and 7 as well%' THEN
    RAISE EXCEPTION 'M2 was not corrected as expected.';
  END IF;
  RAISE NOTICE 'M2 now describes the dataset as published to Session 5 and maintained since.';
END $$;

COMMIT;
