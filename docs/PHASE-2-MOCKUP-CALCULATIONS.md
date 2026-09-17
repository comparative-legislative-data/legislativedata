# The mock-ups' draft calculations

For whoever builds the charts. These are the calculations that gave the figures
in the mock-ups of 17 September 2026 (thoughts 2, 3 and 4 in
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
