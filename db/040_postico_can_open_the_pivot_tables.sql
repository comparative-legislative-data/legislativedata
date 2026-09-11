-- 040_postico_can_open_the_pivot_tables.sql
--
-- Five pivot tables belonged to the administrator rather than to legdata, the
-- login Postico uses, so the owner could not open them. They are the ones that
-- lay out stage dates and durations per bill, which is what the stage dates
-- loaded on 2026-09-11 are for.
--
-- The cause, recorded in STATE.md since 2026-09-10: migrations run as postgres,
-- and whatever they create belongs to postgres unless told otherwise. db/031
-- and db/033 set the owner; the earlier migrations that made these five did
-- not. Nothing about the data changes here, only who may read them.
--
-- After this, every table and pivot table in public belongs to legdata, which
-- the check at the end requires.

BEGIN;

ALTER VIEW v_bill_stage_dates       OWNER TO legdata;
ALTER VIEW v_bill_stage_durations   OWNER TO legdata;
ALTER VIEW v_bill_total_duration    OWNER TO legdata;
ALTER VIEW v_outcome_by_type        OWNER TO legdata;
ALTER VIEW v_stage_duration_summary OWNER TO legdata;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n
    FROM pg_class
   WHERE relnamespace = 'public'::regnamespace AND relkind IN ('r', 'v')
     AND relowner <> 'legdata'::regrole;
  IF n > 0 THEN
    RAISE EXCEPTION '% table(s) or pivot table(s) still do not belong to legdata.', n;
  END IF;
END $$;

-- Every pivot table opens as Postico's user.
SET LOCAL ROLE legdata;
SELECT (SELECT count(*) FROM v_bill_stage_dates)       AS bill_stage_dates,
       (SELECT count(*) FROM v_bill_stage_durations)   AS bill_stage_durations,
       (SELECT count(*) FROM v_bill_total_duration)    AS bill_total_duration,
       (SELECT count(*) FROM v_outcome_by_type)        AS outcome_by_type,
       (SELECT count(*) FROM v_stage_duration_summary) AS stage_duration_summary;
RESET ROLE;

COMMIT;
