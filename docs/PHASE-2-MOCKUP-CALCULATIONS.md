# The mock-ups' draft calculations

For whoever builds the charts. These are the calculations that gave the figures
in the mock-ups of 17 September 2026 (thoughts 1 to 6 in
`docs/PHASE-2-CHARTS-THOUGHTS.md`; the page is
https://claude.ai/artifact/XkH7LGSDzhFSo6FTYaxZx9). They are **drafts**: written
against the working database's names, run read-only, never saved into the
database, and not reviewed. They are kept so the figures can be reproduced and
the build does not start from nothing. Each runs in one `psql` call; `{TYPE}`
and `{VIEW}` are replaced before running, as each header says.

Checks made when they ran: every version of the outcome figures adds up to 470
bills; the 22 Private Bills that passed give a median of 274 days from
introduction to Final Stage, as M9 states.

Not yet settled for the build: which of these become views in the database, the
published copy's names, and how one line per bill is given behind each figure.

---

## Outcomes by session and type (thought 2, the stacked bars)

```sql
-- Outcomes by session and type, for the stacked bar chart (mock-up draft).
-- One line per session (and 'all' for every session together), type and
-- outcome, with a line for every combination. Built on v_outcome_by_type.
-- {TYPE}: analysis_group counts the Hybrid Bill as a government bill;
--         bill_type shows it on its own.
-- {VIEW}: 'full' keeps every outcome; 'simple' groups every ending other
--         than passed into not_passed, and keeps in_progress apart.
with counted as (
    select session_number::text as session, {TYPE} as type,
           case when '{VIEW}' = 'simple' and outcome not in ('passed', 'in_progress')
                then 'not_passed' else outcome end as outcome,
           bills
    from v_outcome_by_type
),
counted_all as (
    select session, type, outcome, bills from counted
    union all
    select 'all', type, outcome, bills from counted
),
sessions as (
    select session_number::text as session, session_number as ord from session
    union all select 'all', 99
),
types as (select distinct type from counted),
outcomes as (select distinct outcome from counted),
grid as (
    select s.session, s.ord, t.type, o.outcome
    from sessions s cross join types t cross join outcomes o
),
bills_of_type as (
    select session, type, sum(bills) as bills from counted_all group by session, type
)
select g.session, g.type, g.outcome,
       coalesce(bt.bills, 0) as bills_of_type,
       coalesce(sum(c.bills), 0) as bills,
       round(100.0 * coalesce(sum(c.bills), 0) / nullif(bt.bills, 0)) as percent
from grid g
left join counted_all c on c.session = g.session and c.type = g.type and c.outcome = g.outcome
left join bills_of_type bt on bt.session = g.session and bt.type = g.type
group by g.session, g.ord, g.type, g.outcome, bt.bills
order by g.ord, g.type, g.outcome;
```

## Outcomes by session, in figures (thought 3, the table)

`current_date` stands for the day the figures are worked out; on the site that
is the day the copy is taken.

```sql
-- Outcomes table (mock-up draft). One line per session, and 'all' for every
-- session together, for each type and for all types. Built on v_outcome_by_type.
-- {TYPE}: analysis_group counts the Hybrid Bill as a government bill;
--         bill_type shows it on its own.
-- A session's length runs from its first meeting to its last day, or, while it
-- is running, to the day the figures are worked out. Per year is bills
-- introduced over that length in years of 365.25 days. Every percentage is a
-- share of the bills introduced, as on the chart.
with typed as (
    select session_number, {TYPE} as type, outcome, bills from v_outcome_by_type
    union all
    select session_number, 'all', outcome, bills from v_outcome_by_type
),
types as (select distinct type from typed),
sessions as (
    select session_number, date_first_meeting,
           coalesce(date_session_end, current_date) as date_to,
           date_session_end is null as running
    from session
),
per_session as (
    select s.session_number::text as session, s.session_number as ord, t.type,
           extract(year from s.date_first_meeting)::int as year_from,
           case when s.running then null else extract(year from s.date_to)::int end as year_to,
           s.running,
           s.date_to - s.date_first_meeting as length_days,
           x.outcome, coalesce(x.bills, 0) as bills
    from sessions s cross join types t
    left join typed x on x.session_number = s.session_number and x.type = t.type
),
rows as (
    select session, ord, type, year_from, year_to, running, length_days, outcome, bills from per_session
    union all
    select 'all', 99, type,
           (select extract(year from min(date_first_meeting))::int from sessions),
           null, (select bool_or(running) from sessions),
           null, outcome, sum(bills)
    from per_session group by type, outcome
),
lengths as (
    select type, sum(length_days) as length_days
    from (select distinct session, type, length_days from per_session) d group by type
),
wide as (
    select r.session, r.ord, r.type, r.year_from, r.year_to, r.running,
           coalesce(r.length_days, l.length_days) as length_days,
           sum(r.bills) as introduced,
           sum(r.bills) filter (where r.outcome = 'passed') as passed,
           sum(r.bills) filter (where r.outcome not in ('passed', 'in_progress')) as not_passed,
           sum(r.bills) filter (where r.outcome = 'rejected_stage_1') as rejected_stage_1,
           sum(r.bills) filter (where r.outcome = 'rejected_stage_3') as rejected_stage_3,
           sum(r.bills) filter (where r.outcome = 'withdrawn') as withdrawn,
           sum(r.bills) filter (where r.outcome = 'fell_dissolution') as fell_dissolution,
           sum(r.bills) filter (where r.outcome = 'fell_financial_resolution_not_agreed') as fell_financial_resolution_not_agreed,
           sum(r.bills) filter (where r.outcome = 'in_progress') as in_progress
    from rows r left join lengths l on r.session = 'all' and l.type = r.type
    group by r.session, r.ord, r.type, r.year_from, r.year_to, r.running, r.length_days, l.length_days
)
select session, type, year_from, year_to, running, length_days,
       round(length_days / 365.25, 1) as length_years,
       introduced,
       coalesce(passed, 0) as passed,
       round(100.0 * coalesce(passed, 0) / nullif(introduced, 0)) as passed_pct,
       coalesce(not_passed, 0) as not_passed,
       round(100.0 * coalesce(not_passed, 0) / nullif(introduced, 0)) as not_passed_pct,
       coalesce(rejected_stage_1, 0) as rejected_stage_1,
       round(100.0 * coalesce(rejected_stage_1, 0) / nullif(introduced, 0)) as rejected_stage_1_pct,
       coalesce(rejected_stage_3, 0) as rejected_stage_3,
       round(100.0 * coalesce(rejected_stage_3, 0) / nullif(introduced, 0)) as rejected_stage_3_pct,
       coalesce(withdrawn, 0) as withdrawn,
       round(100.0 * coalesce(withdrawn, 0) / nullif(introduced, 0)) as withdrawn_pct,
       coalesce(fell_dissolution, 0) as fell_dissolution,
       round(100.0 * coalesce(fell_dissolution, 0) / nullif(introduced, 0)) as fell_dissolution_pct,
       coalesce(fell_financial_resolution_not_agreed, 0) as fell_financial_resolution_not_agreed,
       round(100.0 * coalesce(fell_financial_resolution_not_agreed, 0) / nullif(introduced, 0)) as fell_financial_resolution_not_agreed_pct,
       coalesce(in_progress, 0) as in_progress,
       round(100.0 * coalesce(in_progress, 0) / nullif(introduced, 0)) as in_progress_pct,
       round(introduced / (length_days / 365.25), 1) as per_year
from wide
order by ord, type;
```

## How long bills take (thought 4)

```sql
-- How long bills take, by session and type (mock-up draft).
-- Built on v_bill_stage_durations and v_bill_total_duration. Calendar days.
-- Stretches: introduction to the end of Stage 3 (a Private Bill's Final Stage,
-- by position, M2); introduction to the end of Stage 1; Stage 1 to Stage 2;
-- Stage 2 to Stage 3; the end of Stage 3 to Royal Assent (through the Supreme
-- Court and Reconsideration Stage where a bill went there, M5).
-- Bills: 'passed' takes only bills that passed; 'reached' takes every bill the
-- Parliament took the decision ending the stretch for, whichever way it went.
-- The Robin Rigg Act is measured from its own introduction (M9). The Hybrid
-- Bill is counted as a government bill (M4). Mean rounded to whole days; the
-- median may end in a half.
with periods as (
    select session_number, bill_type, bill_passed, 'intro_s3' as stretch, calendar_days_to_final_stage as days
    from v_bill_total_duration
    union all
    select session_number, bill_type, bill_passed, 'intro_s1', calendar_days
    from v_bill_stage_durations where previous_order = 0 and stage_order = 1
    union all
    select session_number, bill_type, bill_passed, 's1_s2', calendar_days
    from v_bill_stage_durations where previous_order = 1 and stage_order = 2
    union all
    select session_number, bill_type, bill_passed, 's2_s3', calendar_days
    from v_bill_stage_durations where previous_order = 2 and stage_order = 3
    union all
    select session_number, bill_type, bill_passed, 's3_ra', calendar_days_to_assent
    from v_bill_total_duration where calendar_days_to_assent is not null
    union all
    -- The same stretch leaving out bills stopped before Royal Assent (M5).
    select d.session_number, d.bill_type, d.bill_passed, 's3_ra_unstopped', d.calendar_days_to_assent
    from v_bill_total_duration d join bill b using (bill_id)
    where d.calendar_days_to_assent is not null and b.date_assent_blocked is null
),
typed as (
    select p.session_number::text as session, t.analysis_group as type, p.stretch, p.bill_passed, p.days
    from periods p join ref_bill_type t on t.code = p.bill_type
),
spread as (
    select session, type, stretch, bill_passed, days from typed
    union all select 'all', type, stretch, bill_passed, days from typed
),
spread2 as (
    select session, type, stretch, bill_passed, days from spread
    union all select session, 'all', stretch, bill_passed, days from spread
),
sets as (
    select session, type, stretch, 'reached' as bills, days from spread2
    union all
    select session, type, stretch, 'passed', days from spread2 where bill_passed
),
grid as (
    select s.session, s.ord, t.type, x.stretch, b.bills
    from (select session_number::text as session, session_number as ord from session union all select 'all', 99) s
    cross join (select distinct analysis_group as type from ref_bill_type union all select 'all') t
    cross join (values ('intro_s3'), ('intro_s1'), ('s1_s2'), ('s2_s3'), ('s3_ra'), ('s3_ra_unstopped')) x(stretch)
    cross join (values ('passed'), ('reached')) b(bills)
)
select g.session, g.type, g.stretch, g.bills,
       count(z.days) as n,
       round(avg(z.days)) as mean,
       percentile_cont(0.5) within group (order by z.days) as median,
       min(z.days) as shortest,
       max(z.days) as longest
from grid g
left join sets z on z.session = g.session and z.type = g.type and z.stretch = g.stretch and z.bills = g.bills
group by g.session, g.ord, g.type, g.stretch, g.bills
order by g.ord, g.type, g.stretch, g.bills;
```

---

## When in a session bills were introduced (thought 5)

Three results, each one JSON document: every bill's place in its session and
quarter; the counts, shares, averages and even-spread test by session and type;
and the change per session. Checked when it ran: the bills add up to 470, and the
test results and the change per session agree with a separate calculation made
outside the database the same day. The test's p-value uses `erfc`, which the
database has from PostgreSQL 16.

```sql
-- When bills were introduced in their session, by quarter (thought 5, mock-up draft).
-- A bill's position is the days from its session's first meeting to its
-- introduction, divided by the days from that first meeting to the session's
-- last day; Session 7 uses its expected last day (M14). Quarter 1 is a position
-- under 0.25, and so on; a bill exactly on a boundary goes in the later quarter
-- (proposed, not agreed; no bill is on one today).
-- Types: 'all', or ref_bill_type.analysis_group, so the Hybrid Bill counts as a
-- government bill (M4). Three results, each one JSON document: bills, sessions, trend.
with pos as (
    select b.bill_id, b.session_number, r.analysis_group as grp, b.sp_bill_id, b.short_title,
           b.date_introduced, s.is_current as running,
           (b.date_introduced - s.date_first_meeting)::numeric
             / (coalesce(s.date_session_end, s.date_session_end_expected) - s.date_first_meeting) as x
    from bill b
    join session s using (session_number)
    join ref_bill_type r on r.code = b.bill_type
),
q as (select *, least(4, floor(x * 4)::int + 1) as quarter from pos)
select json_agg(json_build_array(bill_id, session_number, grp, sp_bill_id, short_title, date_introduced,
                                 round(100 * x, 1), quarter) order by session_number, date_introduced)
from q;

with pos as (
    select b.session_number, r.analysis_group as grp, s.is_current as running,
           (b.date_introduced - s.date_first_meeting)::numeric
             / (coalesce(s.date_session_end, s.date_session_end_expected) - s.date_first_meeting) as x
    from bill b join session s using (session_number) join ref_bill_type r on r.code = b.bill_type
),
q as (select *, least(4, floor(x * 4)::int + 1) as quarter from pos),
types(type, ord) as (values ('all', 1), ('government', 2), ('members', 3), ('committee', 4), ('private', 5)),
typed as (select t.type, q.* from q cross join types t where t.type = 'all' or q.grp = t.type),
grouped as (
    select type, session_number::text as session, n, q1, q2, q3, q4, mean_x, median_x, running
    from (
        select type, session_number, count(*) as n,
               count(*) filter (where quarter = 1) as q1, count(*) filter (where quarter = 2) as q2,
               count(*) filter (where quarter = 3) as q3, count(*) filter (where quarter = 4) as q4,
               avg(x) as mean_x, percentile_cont(0.5) within group (order by x) as median_x,
               bool_or(running) as running
        from typed group by type, session_number
    ) g
    union all
    -- every finished session together; Session 7 is left out until it ends
    select type, 'all', count(*),
           count(*) filter (where quarter = 1), count(*) filter (where quarter = 2),
           count(*) filter (where quarter = 3), count(*) filter (where quarter = 4),
           avg(x), percentile_cont(0.5) within group (order by x), false
    from typed where not running group by type
),
grid as (
    select t.type, t.ord, s.session, s.ord as sord, s.running
    from types t
    cross join (select session_number::text as session, session_number as ord, is_current as running from session
                union all select 'all', 99, false) s
),
tested as (
    select g.type, g.session, g.ord, g.sord, g.running,
           coalesce(c.n, 0) as n, coalesce(c.q1, 0) as q1, coalesce(c.q2, 0) as q2,
           coalesce(c.q3, 0) as q3, coalesce(c.q4, 0) as q4, c.mean_x, c.median_x,
           -- chi-square against an even spread over the four quarters, three degrees of freedom
           case when c.n > 0 then (power(c.q1 - c.n / 4.0, 2) + power(c.q2 - c.n / 4.0, 2)
                                 + power(c.q3 - c.n / 4.0, 2) + power(c.q4 - c.n / 4.0, 2)) / (c.n / 4.0) end as chi2
    from grid g left join grouped c on c.type = g.type and c.session = g.session
)
select json_agg(json_build_object(
    'type', type, 'session', session, 'running', running, 'n', n,
    'q', json_build_array(q1, q2, q3, q4),
    'q_pct', case when n > 0 then json_build_array(round(100.0 * q1 / n), round(100.0 * q2 / n),
                                                  round(100.0 * q3 / n), round(100.0 * q4 / n)) end,
    'mean_pct', round(100 * mean_x, 1),
    'median_pct', round((100 * median_x)::numeric, 1),
    'chi2', round(chi2, 2),
    -- tested only for a finished session with at least 20 bills, so every quarter expects 5 or more
    'p', case when n >= 20 and not running
              then round((erfc(sqrt(chi2 / 2)::float8) + sqrt(2 * chi2 / pi()) * exp(-chi2 / 2))::numeric, 2) end
) order by ord, sord)
from tested;

with pos as (
    select b.session_number, r.analysis_group as grp,
           (b.date_introduced - s.date_first_meeting)::numeric
             / (coalesce(s.date_session_end, s.date_session_end_expected) - s.date_first_meeting) as x
    from bill b join session s using (session_number) join ref_bill_type r on r.code = b.bill_type
    where not s.is_current
),
types(type, ord) as (values ('all', 1), ('government', 2), ('members', 3), ('committee', 4), ('private', 5)),
fit as (
    -- straight-line fit of each bill's position on its session number, Sessions 1 to 6
    select t.type, t.ord, count(*) as n,
           regr_slope(x, session_number) as slope, regr_sxx(x, session_number) as sxx,
           regr_syy(x, session_number) as syy, regr_sxy(x, session_number) as sxy
    from pos cross join types t where t.type = 'all' or pos.grp = t.type
    group by t.type, t.ord
)
select json_agg(json_build_object(
    'type', type, 'n', n,
    'slope_pts', round((100 * slope)::numeric, 1),
    'p', case when n >= 20 then round(erfc((abs(slope) / sqrt((syy - sxy * sxy / sxx) / (n - 2) / sxx)) / sqrt(2))::numeric, 2) end
) order by ord)
from fit;
```

---

## The quickest and slowest bills (thought 6)

One JSON document: for each type and each stretch, the ten quickest and the ten
slowest bills, with ties kept. Checked when it ran: the quickest ten to Stage 3
end in a tie at 6 days with the next bill at 8, as `PHASE-2-CALCULATIONS.md`
found; 404 bills are timed to Stage 3 and 402 to Royal Assent.

```sql
-- The quickest and slowest bills (thought 6, mock-up draft).
-- 'stage3': calendar days from introduction to the Stage 3 vote (a Private Bill's
-- Final Stage, by position, M2), for every bill that passed.
-- 'assent': calendar days from introduction to Royal Assent, for every bill that
-- received it. A reintroduced bill is timed from its own introduction (M9).
-- Ranked within each type ('all', or ref_bill_type.analysis_group, so the Hybrid
-- Bill is a government bill, M4); rank() gives tied bills the same place, and
-- every bill tied at tenth is kept, so a list can run past ten.
with timed as (
    select b.bill_id, b.session_number, r.analysis_group as grp, b.sp_bill_id, b.short_title, b.asp_number,
           b.date_introduced, s3.date_completed as date_stage_3, b.date_royal_assent,
           b.date_assent_blocked is not null as was_blocked, b.procedure,
           b.reintroduced_from_bill_id is not null as reintroduced
    from bill b
    join ref_bill_type r on r.code = b.bill_type
    left join stage_event s3 on s3.bill_id = b.bill_id and s3.stage_order = 3 and s3.completed
),
stretches as (
    select 'stage3' as stretch, t.*, t.date_stage_3 - t.date_introduced as days from timed t
    where t.date_stage_3 is not null
    union all
    select 'assent', t.*, t.date_royal_assent - t.date_introduced from timed t
    where t.date_royal_assent is not null
),
types(type, ord) as (values ('all', 1), ('government', 2), ('members', 3), ('committee', 4), ('private', 5)),
ranked as (
    select t.type, t.ord, s.*,
           count(*) over (partition by t.type, s.stretch) as bills_timed,
           rank() over (partition by t.type, s.stretch order by s.days asc) as rank_quickest,
           rank() over (partition by t.type, s.stretch order by s.days desc) as rank_slowest
    from stretches s cross join types t
    where t.type = 'all' or s.grp = t.type
),
listed as (
    select 'quickest' as list, rank_quickest as rank, ranked.* from ranked where rank_quickest <= 10
    union all
    select 'slowest', rank_slowest, ranked.* from ranked where rank_slowest <= 10
)
-- a bill can be in both lists where a type has few bills
select json_agg(json_build_object(
    'type', type, 'stretch', stretch, 'bills_timed', bills_timed, 'list', list, 'rank', rank,
    'bill_id', bill_id, 'session', session_number, 'grp', grp, 'sp_bill_id', sp_bill_id,
    'title', short_title, 'asp', asp_number, 'introduced', date_introduced,
    'stage_3', date_stage_3, 'royal_assent', date_royal_assent, 'days', days,
    'blocked', was_blocked, 'procedure', procedure, 'reintroduced', reintroduced
) order by ord, stretch, list, rank, date_introduced)
from listed;
```

---

## The headline figures (thought 1)

One JSON document, no choices. Checked when it ran against the figures already
known: 470 bills, 404 passed, 402 Acts, 1 still before the Parliament.

```sql
-- The headline figures (thought 1, mock-up draft). One JSON document.
-- Counts every bill on the clean sheet; Session 7 is running, so its bills are
-- counted and have no ending yet (M13). The Hybrid Bill counts as a government
-- bill (M4). "Checked against its sources" is the newest date any row was read.
with b as (select bill.*, r.analysis_group as grp from bill join ref_bill_type r on r.code = bill.bill_type),
timed as (
    select b.bill_id, e.date_completed - b.date_introduced as days
    from b join stage_event e on e.bill_id = b.bill_id and e.stage_order = 3 and e.completed
    where b.outcome = 'passed'
),
by_type as (
    select grp, count(*) as bills, count(*) filter (where outcome = 'passed') as passed
    from b group by grp
)
select json_build_object(
    'bills', (select count(*) from b),
    'passed', (select count(*) from b where outcome = 'passed'),
    'acts', (select count(*) from b where enactment_status = 'enacted'),
    'live', (select count(*) from b where outcome = 'in_progress'),
    'sessions', (select count(*) from session),
    'sessions_ended', (select count(*) from session where date_session_end is not null),
    'first_meeting', (select min(date_first_meeting) from session),
    'median_days_to_stage_3', (select round(percentile_cont(0.5) within group (order by days)::numeric, 0) from timed),
    'passed_pct', json_object_agg(grp, round(100.0 * passed / bills)),
    'bills_by_type', json_object_agg(grp, bills),
    'last_checked', (select greatest(
        (select max(observed_at) from bill), (select max(observed_at) from stage_event),
        (select max(observed_at) from field_source)))
) from by_type;
```
