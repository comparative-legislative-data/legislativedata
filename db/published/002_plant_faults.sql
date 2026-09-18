-- db/published/002_plant_faults: for the rehearsal only
--
-- Gives the site's login each permission it must not have, so that
-- 002_check_as_the_site.sh can be seen to report FAIL on items 4 to 10; with
-- -v fault=off, takes every one away again. Planted and removed within the
-- rehearsal, minutes apart; never left in place.
--
--   sudo -u postgres psql -X -d postgres -v fault=on  -f 002_plant_faults.sql
--   sudo -u postgres psql -X -d postgres -v fault=off -f 002_plant_faults.sql

\set ON_ERROR_STOP on
\if :{?fault}
\else
  \echo 'Refusing: say -v fault=on or -v fault=off.'
  \quit
\endif
SELECT :'fault' = 'on' AS planting \gset

\if :planting
  GRANT CONNECT ON DATABASE legdata TO legsite;
  GRANT TEMPORARY ON DATABASE published TO legsite;
  \connect published
  GRANT INSERT ON live.about TO legsite;
  GRANT USAGE ON SCHEMA previous, from_working, public TO legsite;
  GRANT USAGE ON FOREIGN SERVER working TO legsite;
  \echo 'Planted: seven permissions the site must not have.'
\else
  REVOKE CONNECT ON DATABASE legdata FROM legsite;
  REVOKE TEMPORARY ON DATABASE published FROM legsite;
  \connect published
  REVOKE INSERT ON live.about FROM legsite;
  REVOKE USAGE ON SCHEMA previous, from_working, public FROM legsite;
  REVOKE USAGE ON FOREIGN SERVER working FROM legsite;
  \echo 'Removed: all seven.'
\endif
