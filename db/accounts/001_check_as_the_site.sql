-- db/accounts/001_check_as_the_site: what the website's login can and cannot do
--
-- Run as the site's own machine account, against the accounts database:
--
--   sudo -u legsite psql -X -d accounts -v practice=keep -f 001_check_as_the_site.sql
--
-- Each item prints PASS or FAIL, and the script stops at the end with an error
-- if anything failed. It uses one invented person, Practice Applicant at
-- practice.applicant@example.org, who is not a real person. With -v practice=keep
-- that person is left in place, approved, for the backup rehearsal to look for;
-- otherwise they are deleted, and deleting them is itself the last item.
--
-- Refuses to run if anybody other than the practice person is in the database:
-- this is for the rehearsal and for the day the database is made, not for later.
--
-- Everything runs inside one block and reports as it goes, because the site's
-- login is not allowed to make even a scratch tab, and should not be.

\set ON_ERROR_STOP on
\if :{?practice}
\else
  \set practice delete
\endif

DO $$
DECLARE
  n int;
  pid bigint;
  failed boolean;
  results boolean[] := '{}';
  whats text[] := '{}';
  i int;
  bad text;
BEGIN
  IF current_user <> 'legsite' THEN
    RAISE EXCEPTION 'Refusing: run this as legsite, not %.', current_user;
  END IF;
  SELECT count(*) INTO n FROM person WHERE email <> 'practice.applicant@example.org';
  IF n > 0 THEN
    RAISE EXCEPTION 'Refusing: % real person(s) are in this database.', n;
  END IF;
  DELETE FROM person WHERE email = 'practice.applicant@example.org';

  -- 1. The site can add an applicant.
  INSERT INTO person (email, name, title, position)
  VALUES ('practice.applicant@example.org', 'Practice Applicant', NULL,
          'Invented, for the rehearsal')
  RETURNING person_id INTO pid;
  results := results || coalesce(((SELECT state = 'applied' AND decided_at IS NULL FROM person WHERE person_id = pid)), false);
  whats := whats || 'an applicant can be added, and starts as applied'::text;

  -- 2. The site cannot make anyone the owner, either when adding or afterwards.
  --    Only a refusal on permission counts. Refused for any other reason means
  --    the site got past the permission, which is the failure being looked for.
  failed := false;
  BEGIN
    INSERT INTO person (email, name, position, is_owner)
    VALUES ('practice.owner@example.org', 'Practice Owner', 'Invented', true);
  EXCEPTION
    WHEN insufficient_privilege THEN failed := true;
    WHEN OTHERS THEN failed := false;
  END;
  BEGIN
    UPDATE person SET is_owner = true WHERE person_id = pid;
    failed := false;
  EXCEPTION
    WHEN insufficient_privilege THEN NULL;
    WHEN OTHERS THEN failed := false;
  END;
  results := results || failed;
  whats := whats || 'the site cannot make anyone the owner'::text;

  -- 3. The site cannot change a person's email.
  failed := false;
  BEGIN
    UPDATE person SET email = 'changed@example.org' WHERE person_id = pid;
  EXCEPTION WHEN insufficient_privilege THEN failed := true;
  END;
  results := results || failed;
  whats := whats || 'the site cannot change a person''s email'::text;

  -- 4. An email in capitals is refused rather than stored twice.
  failed := false;
  BEGIN
    INSERT INTO person (email, name, position)
    VALUES ('Practice.Applicant@example.org', 'Practice Applicant', 'Invented');
  EXCEPTION WHEN check_violation THEN failed := true;
  END;
  results := results || failed;
  whats := whats || 'an email not in lower case is refused'::text;

  -- 5. Approving without saying when is refused.
  failed := false;
  BEGIN
    UPDATE person SET state = 'approved' WHERE person_id = pid;
  EXCEPTION WHEN check_violation THEN failed := true;
  END;
  results := results || failed;
  whats := whats || 'approving without a date is refused'::text;

  -- 6. Approving with a date works.
  UPDATE person SET state = 'approved', decided_at = now() WHERE person_id = pid;
  results := results || coalesce(((SELECT state = 'approved' FROM person WHERE person_id = pid)), false);
  whats := whats || 'approving with a date works'::text;

  -- 7. A code that lasts longer than 15 minutes is refused.
  failed := false;
  BEGIN
    INSERT INTO sign_in_code (person_id, code_hash, expires_at)
    VALUES (pid, 'practice-scramble', now() + interval '20 minutes');
  EXCEPTION WHEN check_violation THEN failed := true;
  END;
  results := results || failed;
  whats := whats || 'a code lasting 20 minutes is refused'::text;

  -- 8. A 15-minute code and a 30-day device can be added.
  INSERT INTO sign_in_code (person_id, code_hash, expires_at)
  VALUES (pid, 'practice-scramble', now() + interval '15 minutes');
  INSERT INTO signed_in_device (person_id, marker_hash, expires_at)
  VALUES (pid, 'practice-marker-scramble', now() + interval '30 days');
  results := results || coalesce(((SELECT count(*) = 1 FROM sign_in_code WHERE person_id = pid)
    AND (SELECT count(*) = 1 FROM signed_in_device WHERE person_id = pid)), false);
  whats := whats || 'a 15-minute code and a 30-day device can be added'::text;

  -- 9. A device signed in for 31 days is refused.
  failed := false;
  BEGIN
    INSERT INTO signed_in_device (person_id, marker_hash, expires_at)
    VALUES (pid, 'practice-marker-2', now() + interval '31 days');
  EXCEPTION WHEN check_violation THEN failed := true;
  END;
  results := results || failed;
  whats := whats || 'a device signed in for 31 days is refused'::text;

  -- 10. The site can see nothing in this database but its three tabs, and
  --     cannot add one.
  results := results || ((SELECT count(*) FROM information_schema.tables
                           WHERE table_schema = 'public') = 3
                         AND NOT has_schema_privilege('public', 'CREATE')
                         AND NOT has_database_privilege(current_database(), 'TEMPORARY'));
  whats := whats || 'the site sees only the three tabs, and cannot add one'::text;

  -- 11. Deleting the person takes their code and device with them.
  DELETE FROM person WHERE person_id = pid;
  results := results || ((SELECT count(*) FROM person) = 0
                         AND (SELECT count(*) FROM sign_in_code) = 0
                         AND (SELECT count(*) FROM signed_in_device) = 0);
  whats := whats || 'deleting a person deletes their code and device'::text;

  FOR i IN 1 .. array_length(results, 1) LOOP
    RAISE NOTICE '% %: %', CASE WHEN results[i] THEN 'PASS' ELSE 'FAIL' END, i, whats[i];
    IF NOT results[i] THEN bad := concat_ws(', ', bad, i::text); END IF;
  END LOOP;
  IF bad IS NOT NULL THEN RAISE EXCEPTION 'FAILED: item(s) %.', bad; END IF;
  IF array_length(results, 1) <> 11 THEN
    RAISE EXCEPTION 'FAILED: % items ran, not 11.', array_length(results, 1);
  END IF;
  RAISE NOTICE 'All 11 pass.';
END $$;

-- With practice=keep, the practice person is put back, approved, with no code
-- and no device, for the backup rehearsal to look for.
SELECT :'practice' = 'keep' AS keep_practice \gset
\if :keep_practice
  INSERT INTO person (email, name, title, position)
  VALUES ('practice.applicant@example.org', 'Practice Applicant', NULL,
          'Invented, for the rehearsal');
  UPDATE person SET state = 'approved', decided_at = now()
   WHERE email = 'practice.applicant@example.org';
  \echo 'The practice person is left in place, approved, for the backup rehearsal.'
\endif

