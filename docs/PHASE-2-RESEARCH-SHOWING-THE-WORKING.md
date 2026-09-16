# Phase 2 research, R3: how others show the working behind a figure

Written 16 September 2026 by a session that wrote neither `PHASE-2.md` nor the
research commission, nor R1 or R2. Every page cited was read on 16 September
2026. Quotations are exact; `[…]` marks a cut.

Nothing was downloaded except documentation, one chart's own data file from the
ONS, and one chart's data package from Our World in Data (its data file, its
description file and its readme), to see what travels with a figure. The two
files were looked at, not analysed. What goes with a download of the whole
dataset is R1's; the design of this site's pages is not in scope.

---

## 1. What was found, in a screen

- **Official statistics ask for the working to be available, not for it to sit
  beside the figure.** The Code of Practice for Statistics (edition 3.0) asks
  producers to "Be clear about the methods used", to provide "metadata and
  coding where appropriate", and to "Ensure statistics are reproducible". The
  government's chart guidance asks for "the specific data source for each chart"
  and the chart's data "as an accessible data download".
- **Official producers show the working in prose.** The ONS, the Department
  for Education and the Scottish Government put a source line and notes under
  each chart, and keep the methods on pages of their own. The code, where it is
  published at all, is somewhere else, usually GitHub.
- **Each ONS chart has its own data file**, holding the chart's title, notes,
  units and numbers, but not its source or its release date.
- **Our World in Data goes furthest for a chart.** Each chart has a page saying
  what the data is, where each source was "Retrieved on", what processing was
  done, "Last updated" and "Next expected update". Its download is stamped with
  the day it was downloaded. Its code is public, and its pipeline is built so
  that "the result of any step is a pure function of its inputs". The chart
  page links to a description of the whole pipeline, not to the code for that
  chart.
- **Only one of the sites read shows the calculation itself beside the result.**
  Datasette, a tool for publishing a database, has a "View and edit SQL" link
  on every table showing "the SQL query that was used for the page". Every
  record has its own web address. The query that was shown is the query that
  ran, because the page is made from it.
- **Data journalism publishes a methodology article and a code repository**:
  The Markup, The Economist, FiveThirtyEight and the BBC's data units all do. The
  article is prose for readers; the repository is for anyone who wants to re-run
  it.
- **A political science journal checks the working before publication.** The
  American Journal of Political Science has the author's materials checked to
  confirm "that they do, in fact, reproduce the analytic results reported".
- **No source read guarantees in words that the calculation shown is the one
  that ran**, except by how the thing is built. The civil service's standard for
  reproducible analysis rests the guarantee on process: no manual steps, the
  code under version control, the documentation kept with the code.
- **Reaching a single record** is possible at Datasette (every row has an
  address) and, for sources, at Our World in Data (a linked spreadsheet names
  the source of each data point). The official producers that were read
  publish totals, not records.
- **Dates are shown three ways**: when it was released and when it is next due
  (ONS, Scottish Government); when it was last updated, with a list of changes
  (Department for Education, Our World in Data); and when the reader took it
  (Our World in Data's download, and the Department for Education's saved
  tables, which warn when newer figures exist).
- **Keeping old versions is the usual practice here too.** The ONS keeps previous
  releases, Our World in Data keeps dated archive copies and offers an embedded
  chart "that will never change or update", and the Code asks that statistics
  "continue to be publicly available, such as through web or data archiving".
  The Scottish Government replaced its tables in place, with a dated notice
  saying what changed.

---

## 2. The findings in full

### 2.1 The Code of Practice for Statistics

The Office for Statistics Regulation's page for the Code
(`osr.statisticsauthority.gov.uk/publications/the-code-of-practice-for-statistics/`)
gives it as published 3 November 2025. The PDF read is
`osr.statisticsauthority.gov.uk/wp-content/uploads/sites/3/2026/08/Code-of-Practice-for-Statistics-3.0.pdf`,
"Edition 3.0", 35 pages.

**It is written for anyone, not only government.** "Everyone can apply or draw
on the Code" (p.3). OSR runs a "Voluntary Application" scheme for producers
of statistics that are not official statistics, which asks members to publish
"a statement explaining how they apply and meet the Code principles" (p.13).
Joining is a question for the owner (§5), not a finding that it should be done.

**What it asks about the working**, among the standards for official statistics:

- 7.4: "Be clear about the methods used. Explain quality issues related to the
  methods, systems and processes […]" (p.23).
- 7.3: "Explain the nature of data sources and why they were selected,
  anticipating possible areas of misunderstanding or misuse. Prominently
  communicate limitations in the underlying data and explain their impact on
  the statistics" (p.23).
- 10.2: "Make sure statistics, data and related guidance are easily accessible.
  Provide other relevant information, such as metadata and coding where
  appropriate" (p.25).
- 10.5: "Support the reuse of data and statistics, preventing barriers to use
  where possible. Ensure statistics are reproducible. […]" (p.25).

Its glossary defines both words. **Coding**: "The act of using computer languages
such as R or Python. Coding can be used when producing statistics to automate
data manipulation, do statistical analysis, and create visualisations for more
efficient and reproducible production." **Reproducible**: "Using the same data
and methods as the original study to obtain the same results. […] An RAP is
designed to be run and re-run numerous times and produce a consistent output"
(pp.34–35).

**On a published figure used in public**, the standards for public bodies say
figures are made available "so that the public can easily access, scrutinise
and verify claims and decisions made based on them", and ask: "Be clear about
where statistics, data and wider analysis used in public communications come
from" (p.28).

**On change and keeping old copies:**

- 3.9: "Release revisions and corrections of errors transparently and as soon as
  possible in line with the organisation's published policy, being clear about
  the nature and scale of change" (p.19).
- 10.7: "Ensure that statistics continue to be publicly available, such as
  through web or data archiving" (p.25).
- 3.1 asks for releases to be pre-announced "in a 12-month release calendar"
  (p.18).

The Code does not say where on a page the methods or code should sit.

### 2.2 The civil service's standard for reproducible analysis

**The minimum standard.** The Government Analysis Function's page
(`analysisfunction.civilservice.gov.uk/support/reproducible-analytical-pipelines/`)
defines Reproducible Analytical Pipelines as "automated statistical and
analytical processes" and says that "at a minimum a RAP must":

- "minimise manual steps, for example copy-paste, point-click or drag-drop
  operations. Where it is absolutely necessary to include a manual step in the
  process this must be documented as described below"
- "be built using open source software which is available to anyone, preferably
  R or python"
- "deepen technical and quality assurance processes with peer review to ensure
  that the process is reproducible and that the below requirements have been
  met"
- "guarantee an audit trail using version control software, preferably Git"
- "be open to anyone – this can be facilitated most easily through the use of
  file and code sharing platforms"
- "follow existing good practice for quality assurance […]"
- "contain well-commented code and have documentation embedded and version
  controlled within the product, rather than saved elsewhere"

It allows that "restrictions, such as access to databases" may stop a team
building the whole process this way, and then "the above requirements apply to
the selected part of the process."

**The strategy.** *Reproducible Analytical Pipelines (RAP) strategy*,
20 June 2022
(`analysisfunction.civilservice.gov.uk/policy-store/reproducible-analytical-pipelines-strategy/`):

- "The best way to improve reproducibility is to write analysis as code with no
  manual steps."
- "Analysts will open source their products and tools wherever possible […].
  Open sourcing analysis helps users to understand what was done."
- On who does it already: "The UK Coronavirus Dashboard and Explore Education
  Statistics teams publish their code and methods. The Office for National
  Statistics' Centre for Crime and Justice and Public Health Scotland publish
  the code behind their statistics."
- On data that changes underneath: "When source data are not version
  controlled, they cannot reproduce earlier workflows."

**The regulator's review.** OSR, *Reproducible Analytical Pipelines: Overcoming
barriers to adoption*, 23 March 2021
(`osr.statisticsauthority.gov.uk/publications/reproducible-analytical-pipelines-overcoming-barriers-to-adoption/`),
describes the approach as "using programming languages to automate manual
processes, version control software to robustly manage code and code storage
platforms to collaborate, facilitate peer review and publish analysis". Among
its findings: "RAP is not all or nothing: implementing just some RAP principles
will result in improvements."

None of the three says the code should be shown beside a figure. They make the
code the record of what was done, and ask that it be open.

### 2.3 The government's guidance on charts

*Data visualisation: charts*, Government Analysis Function, 19 May 2022
(`analysisfunction.civilservice.gov.uk/policy-store/data-visualisation-charts/`),
whose page says it is for "People in government who design and publish charts".

- **Source**: "You should give the specific data source for each chart and link
  directly to it if you can. Avoid stating things like 'Office for National
  Statistics' and then linking to the website homepage. You should help users
  find the data." The format it gives: "[publication, survey or other source of
  data] from the [organisation]".
- **The chart's data**: "It is best practice to provide the data displayed in
  each chart as an accessible data download. Providing data downloads improves
  the transparency of our data visualisations and allows people to accurately
  recreate our charts for their own needs." And: "You should link to a data
  download underneath each chart. The file type and size should be included in
  the link."
- **Where the words go**: "all text related to the chart should be in the body
  text of the webpage unless it is essential for it to be in the image of the
  chart. For example, titles and footnotes should be in the body text but
  annotations can go within the image." The source "should be in the body text
  of the page and not part of the chart image." The reason given is
  accessibility.
- **Footnotes**: "footnotes do play an important role in making sure data is not
  misused", but should be "in the body text of a page", limited "to only
  important information", and concise.

It says nothing about dating a chart.

### 2.4 The Office for National Statistics

**A bulletin.** *Labour market overview, UK: September 2026*
(`ons.gov.uk/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/bulletins/uklabourmarket/latest`).

- **The top of the page**: "This is the latest release. View previous releases",
  then "Release date: 15 September 2026" and "Next release: 20 October 2026".
- **Each chart** has a title that states the finding, a subtitle saying what is
  plotted, a source line ("Source: Labour Force Survey (LFS) and Workforce Jobs
  (WFJ) from the Office for National Statistics, and Pay As You Earn Real Time
  Information (RTI) from HM Revenue and Customs (HMRC)"), numbered notes, and
  "Download this chart" with three choices: "Image", ".csv", ".xls".
- **The whole bulletin** has "View all data used in this Statistical bulletin",
  a section "Data sources and quality", and "Cite this statistical bulletin":
  "Office for National Statistics (ONS), released 15 September 2026, ONS
  website, statistical bulletin, Labour market overview, UK: September 2026".
- **Figures that will change are flagged in the text**: "Figures for August
  should be treated as provisional estimates and are likely to be revised when
  more data are received next month." It links separate datasets of past
  revisions: "We publish information on revisions to payrolled employees
  monthly."

**What a chart's data file holds.** The .csv for Figure 1 was downloaded. It
holds, in this order: the chart's title; its subtitle; its two notes; "Unit",
"Thousands"; then the column headings and 144 rows of figures. **It does not
hold the source line, the release date, or a link back to the bulletin.**

**Methods** sit on their own pages. The *Labour Force Survey (LFS) QMI*
(Quality and Methodology Information)
(`ons.gov.uk/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/methodologies/labourforcesurveylfsqmi`)
is dated "Last revised: 17 November 2025" and runs to sections on "Quality
characteristics of the data" and "Methods used to produce the data". It is
reached by links from the bulletin, not shown beside a chart.

**Revisions.** The ONS page *Revisions and corrections of errors*
(`ons.gov.uk/methodology/methodologytopicsandstatisticalconcepts/revisions`)
links separate revisions policies for economic, labour market and population
statistics. Only the landing page was read.

### 2.5 The Department for Education's statistics service

*Explore education statistics*, a service the civil service strategy (§2.2)
names as publishing its code and methods. It is built on a database: readers
can make their own tables.

**A release page.** *Schools, pupils and their characteristics*, academic year
2025/26
(`explore-education-statistics.service.gov.uk/find-statistics/school-pupils-and-their-characteristics/2025-26`):

- **Dates at the top**: "Published 4 June 2026", "Last updated 14 July 2026",
  "3 updates", "Next release June 2027", and "All releases in this series".
- **The list of updates**
  (`…/2025-26/updates`) is a table of dates and reasons: "14 July 2026 | Typo
  resolved", "16 June 2026 | Typo resolved", "4 June 2026 | First published",
  "4 June 2026 | Featured table links added."
- **Four tabs**: "Release home", "Explore and download data", "Methodology",
  "Help and related information".

**The data tab** (`…/2025-26/explore`) offers "Download all data (ZIP)",
"Featured tables" ("pre-prepared tables created from a statistical release's
data sets"), the data sets themselves, and "Data guidance": "Description of the
data sets included in this release, including information on data sources,
coverage, quality and any data conventions used."

**Saved tables.** The help page
(`explore-education-statistics.service.gov.uk/help-support`): "Once you've
created your table, you can download the data it contains for your own offline
analysis, or share a permanent webpage of the created table."

The service's own code is public on GitHub
(`github.com/dfe-analytical-services/explore-education-statistics`). Its page
for a saved table (`src/explore-education-statistics-frontend/src/modules/permalink/PermalinkPage.tsx`,
last changed 26 January 2026) shows "Created:" and the date, and one of these
warnings when the data has moved on:

- "The data used in this table is no longer valid."
- "A newer release of this publication is available and may include updated
  figures."
- "The data used in this table may be invalid as the subject file has been
  amended or removed since its creation."

**So a saved table does not change silently**: it keeps its creation date and
tells the reader when it is out of date. The charts on the release page are
drawn in the browser, so what their own labels carry was not seen.

### 2.6 The Scottish Government

**A statistics publication.** *Recorded Crime in Scotland, 2024-25*
(`gov.scot/publications/recorded-crime-scotland-2024-25/`), "Published 24 June
2025", "From Chief Statistician".

- **A correction is told at the top**, in a section headed "Errata": "An errata
  was published on 07/10/2025 as a result of updated Antisocial offences data
  for 2024-25. Amendments have been made to PDF pages 2, 30, 32, 33, and 48 and
  to Tables 2, 3, 4 and A17. The HTML, PDF and Excel have been updated to
  reflect these changes." The corrected versions replaced the originals at the
  same address.
- **Charts** (`…/pages/total-recorded-crime/`) have a title stating the
  finding, a subtitle saying what is plotted, and notes. Figure 4 carries its
  second source and a caution: "Population data source: Mid-2023 population
  estimates from National Records of Scotland (NRS)", and explains that the
  rates "may differ from those published in previous years" because population
  estimates were revised.
- **The working is on a page of its own**, *Data and methodology*
  (`…/pages/data-and-methodology/`). It starts with a checklist, "How to access
  background or source data", with ticked boxes. It says where the data came
  from, what changed in how it was collected, and one decision in the terms a
  reader needs: "it is desirable for Accredited Official Statistics purposes
  that time series comparisons between 2015-16 to 2023-24 are on a like-for-like
  basis. As such the 2015-16 to 2023-24 data used in this bulletin remains that
  which was submitted immediately following each of these years."
- **Where the numbers are**: "All tables referred to throughout the bulletin are
  available in the 'Supporting documents' Excel workbook", with "an
  'Introduction' sheet […] alongside a 'Notes' sheet". The longer series is
  sent to statistics.gov.scot.

**statistics.gov.scot has since been retired.** Its query page
(`statistics.gov.scot/sparql`) now opens: "statistics.gov.scot is no longer being
updated and is now available for reference only. All new data is published on
data.gov.scot." The 2025 bulletin still points to it. `data.gov.scot` is marked
"Beta".

### 2.7 Our World in Data

**A chart's data page.** *Life expectancy*
(`ourworldindata.org/grapher/life-expectancy`). Below the chart:

- **A short block of labels and values**: "Data source", "Riley (2005);
  Zijdeman et al. (2015); HMD (2025); UN WPP (2024) – with major processing by
  Our World in Data"; "Unit", years; "Date range", 1543-2023; "Last updated",
  2025-10-22; "Next expected update", 2026-10-22; and a named person under
  "Managed by".
- **"What you should know about this data"**: plain-language cautions, one of
  them naming two particular country-years that look wrong and saying why.
- **"How did Our World in Data process this data?"**: a general paragraph, then
  a link, "At the link below you can find a detailed description of the
  structure of our data pipeline, including links to all the code used to
  prepare data across Our World in Data." Then "Notes on our processing step
  for this indicator", in prose: which source was used for which years, and
  which won where two overlapped.
- **Down to the single data point**: "Detailed information on the source of
  each data point can be found on this page", linking to a Google Sheets
  spreadsheet.
- **Each source**: a description, "Retrieved on" (for example "October 22,
  2025"), "Retrieved from" with the address, and the source's own citation,
  labelled "the citation of the original data obtained from the source, prior
  to any processing or adaptation by Our World in Data."
- **"How to cite"**: a citation for the page and one for the data. Both point to
  a dated archive copy, not the live page: "Retrieved September 16, 2026 from
  https://archive.ourworldindata.org/20260910-005924/grapher/life-expectancy.html
  (archived on September 10, 2026)".

The FAQ (`ourworldindata.org/faqs`): "In every chart, we clearly indicate the
source of the data being shown. We also indicate whenever we have combined data
sources or made changes to the original datasets (such as regional
aggregations, per capita transformations, etc.)."

**What travels with the chart.** The download offers "a ZIP file containing a
CSV file, metadata in JSON format, and a README", in "full data" or "displayed
data". The three files were fetched separately:

- **The readme** opens: "This data package contains the data that powers the
  chart "Life expectancy" on the Our World in Data website. It was downloaded on
  September 16, 2026." It explains each column, repeats the processing notes and
  the cautions, gives "Last updated" and "Next expected update", and links the
  pipeline description.
- **The description file** carries, for the column, a short and a long
  description, the processing notes, the unit, "lastUpdated", "nextUpdate", a
  short and a long citation, and a link to fuller metadata. At the top level:
  "dateDownloaded": "2026-09-16". The API documentation
  (`docs.owid.io/projects/etl/api/chart-api/`) lists "dateDownloaded: Timestamp
  of when the data was downloaded" among what it always includes.
- **The data file** is four columns: entity, code, year, value.

**The chart as an image** carries four pieces of text: the title, the subtitle,
"Data source: Riley (2005); Zijdeman et al. (2015); HMD (2025); UN WPP (2024)",
and "OurWorldinData.org/life-expectancy | CC BY". **No date.**

**Live or frozen.** The FAQ: "When embedding one of our interactive charts in
your website, you can choose between a live embed that always reflects our
latest data updates, or an archived embed that will never change or update."

**How the working is built.** The technical documentation
(`docs.owid.io/projects/etl/`) is "to give external readers insight into how we
manage and publish our data". From *Features constraints*
(`…/architecture/design/features-constraints/`):

- "To ensure that members of the public can run and audit our code, we have
  designed the ETL to be a standalone Python program that operates on flat files
  and fetches what it needs on demand."
- "All our data work is public by default".
- "To ensure our work is reproducible, we take our own snapshots of any upstream
  data that we use, meaning that if in future the upstream data producer changes
  their site, their data or their API, we can still build our datasets from 'raw
  ingredients'."
- "[We] forbid steps from using any data as input that isn't explicitly declared
  as a dependency. This means that the result of any step is a pure function of
  its inputs."

From *ETL Model* (`…/architecture/design/phases/`): the processed data is
reshaped and then "loaded to Grapher", its charting system, which holds it in a
database ("the way it must look when being inserted to MySQL"). So **the working
is done in files and code, and the site reads a database** filled from them.

**From a chart to its code.** The fuller metadata for this chart
(`api.ourworldindata.org/v1/indicators/1118466.metadata.json`) gives
"catalogPath": `grapher/demography/2025-10-22/life_expectancy/…`, and each
source's "dateAccessed" and "datePublished". The *ETL Model* page explains that
such a path tells you where the code is, and it does: files named
`life_expectancy.py` and `life_expectancy.meta.yml` are in the public repository
under `etl/steps/data/garden/demography/2025-10-22/`. **The route exists, but
the chart page does not link to it**: a reader has to know the convention.
The file of descriptions sits beside the code that it describes.

The charting software's code is public "for transparency and educational
reference" but not licensed for reuse without permission (FAQ).

### 2.8 Data journalism

**The Markup**, a nonprofit newsroom, now part of CalMatters. *About*
(`themarkup.org/about`): "Our approach is scientific: We build datasets from
scratch, bulletproof our reporting, and show our work." It runs a series
called *Show Your Work* (`themarkup.org/series/show-your-work`) of methodology
articles, one beside each investigation.

One of them, *How We Investigated L.A.'s Homelessness Scoring System*,
28 February 2023
(`themarkup.org/show-your-work/2023/02/28/how-we-investigated-l-a-s-homelessness-scoring-system`):

- "This article describes our analyses' data sources, methodologies, findings,
  and limitations."
- Near the top, a box: "See our data here. GitHub".
- "We chose not to publish the raw dataset provided to us by LAHSA, which
  includes answers to deeply personal questions, to protect the privacy of the
  individuals included in the dataset. The code we used to clean the raw data, a
  cleaned version of the data, and all other code we used for these analyses are
  available on Github."
- It reports its own checks: it recalculated scores from the answers, and "they
  matched the listed total score ("TOTAL_SCORE") 98.9 percent of the time", then
  says where the mismatches were and which figure it used.
- "For the full output of our regressions, please refer to this computational
  notebook in GitHub."
- It ends with a section headed "Limitations".

**FiveThirtyEight** (`github.com/fivethirtyeight/data`): "Data and code behind
the articles and graphics at FiveThirtyEight". It adds: "As of June 13, 2023,
sports predictions and forecasts are no longer being updated."

**The Economist**, excess deaths model
(`github.com/TheEconomist/covid-19-the-economist-global-excess-deaths-model`):
"This repository contains the replication code and data for The Economist's
excess deaths model". It links three things for three readers: the briefing
("what the model shows"), the methodology ("how we constructed it") and the
interactive ("all the improvements we have made since"). On sources: "Within
script 1, the source for each variable is also given as the data is loaded". It
gives a suggested citation with "[Accessed ---]" for the reader to fill in.

**The BBC England Data Unit and BBC Shared Data Unit**
(`github.com/BBC-Data-Unit`, 317 public repositories) keep one repository per
story. *Thousands of flood defences below standard as Storm Bram hit*
(`github.com/BBC-Data-Unit/flood-defences`) has three sections: a summary with
a link to the story, "Get the data" (one CSV, by local authority), and
"Methodology", which begins: "All of the Shared Data Unit's findings come from a
dataset prepared by Defra's data services team", then says what else was tried
and why it was not used.

### 2.9 A political science journal

*AJPS Verification Policy*, American Journal of Political Science
(`ajps.org/ajps-verification-policy/`):

- The author "must provide materials that are sufficient to enable interested
  researchers to verify all of the analytic results that are reported in the
  text and supporting materials."
- "All verification files must be stored in a Dataset within the AJPS
  Dataverse, on the Harvard Dataverse Network."
- "When the final draft of the manuscript is submitted, the materials will be
  verified to confirm that they do, in fact, reproduce the analytic results
  reported in the article. Publication in the American Journal of Political
  Science is contingent upon provision of complete verification materials and
  successful verification of their content."

The page does not say who runs the check.

### 2.10 Sites that show the calculation beside the result

**Datasette**, open-source software for publishing a database on the web.

*Pages and API endpoints* (`docs.datasette.io/en/stable/pages.html`):

- A table page can be filtered and sorted, and then "click the "View and edit
  SQL" link to see the SQL query that was used for the page and edit and
  re-submit it."
- "Every row in every Datasette table has its own URL. This means individual
  records can be linked to directly."

*Running SQL queries* (`docs.datasette.io/en/stable/sql_queries.html`):

- "Datasette treats SQLite database files as read-only and immutable."
- "Any Datasette SQL query is reflected in the URL of the page, allowing you to
  bookmark them, share them with others and navigate through previous queries
  using your browser back button."
- Pre-written calculations can be published two ways, as saved views in the
  database or as "canned queries" named in a settings file.

*Metadata* (`docs.datasette.io/en/stable/metadata.html`): a publisher can set a
source and licence, with links, for the whole site, a database or a table, and
"The source and license information will also be included in the footer of
every page served by Datasette."

**A live example.** The *global-power-plants* table
(`global-power-plants.datasettes.com/global-power-plants/global-power-plants`,
which redirected to `datasette.io/global-power-plants/global-power-plants`)
shows "✎ View and edit SQL", "This data as json, CSV", and the definition of the
table at the foot of the page. Each power plant's row has its own "source" and
"url" columns, so the source of each record is one of its cells. A row's own
page was not opened (§4).

**Observable Framework**, open-source software for building data sites. Its
website sits behind a security check, so its documentation was read from its
public repository (`github.com/observablehq/framework`, `docs/data-loaders.md`):

- "Data loaders generate static snapshots of data during build. For example, a
  data loader might query a database and output CSV data, or server-side render
  a chart and output a PNG image."
- "since data loaders run only during build, your users don't need direct access
  to your data warehouse, making your dashboards more secure and robust."
- A loader that fails "must return a non-zero exit code. If a data loader
  produces a zero exit code, Framework will assume that it was successful and
  will cache and serve the output to the client."

So in this design the calculation runs once, when the site is built, and
readers are served its result as a file.

### 2.11 Side by side

| | Where the working is | The figure's own data | Down to a record | Shown = ran? | Date on the figure |
|---|---|---|---|---|---|
| ONS | source and notes under chart; methods on own pages | .csv/.xls per chart, without source or date | no | not stated | release date and next release, on the page only |
| Dept for Education | methodology tab; data guidance | whole release as ZIP; readers' own tables | no | not stated | published, last updated, list of updates; saved table dated and warns |
| Scottish Government | methodology page; notes under chart | one Excel workbook | no | not stated | published; dated errata; replaced in place |
| Our World in Data | processing notes on the chart page; pipeline docs; public code | ZIP per chart with readme and description | source per data point, in a spreadsheet | by construction of the pipeline | last updated, next update; download stamped; image undated; archive copies |
| Datasette | the calculation itself, one click from the table | CSV and JSON of any page | every row has an address | yes, the page is made from it | none seen |
| The Markup, Economist, FiveThirtyEight, BBC | methodology article; code repository | files in the repository | cleaned records where not private | not stated | article date |
| AJPS | replication files in Dataverse | yes | as the author provides | checked before publication | journal's |

---

## 3. Where practice disagrees

- **Whether the calculation sits beside the figure.** Only Datasette puts it
  there. Our World in Data puts prose notes beside the chart and the code a
  convention away. The official producers put methods on separate pages and the
  code, where published, on GitHub. Journalists put prose in an article and code
  in a repository. The Code asks for "coding where appropriate" without saying
  where.
- **Whether the words belong in the chart image.** The government's chart
  guidance says titles, sources and footnotes go in the page and not the image,
  for accessibility. Our World in Data puts the title, subtitle, source and
  address inside the image, and no date. Neither the ONS chart file nor the Our
  World in Data image carries a date; nothing read argued for one.
- **Whether the chart's own data travels with its source and date.** The
  government guidance asks for a download under every chart. The ONS gives one
  without source or date. Our World in Data's carries both, and the date the
  reader took it. The Scottish Government and the Department for Education give
  the whole release's data rather than a chart's.
- **How the "shown = ran" guarantee is given.** By process, where the civil
  service's standard puts it: no manual steps, version control, documentation in
  the same place as the code. By construction, at Datasette: the page is made
  from the calculation it shows. By a separate check, at AJPS. Not stated at all,
  by the journalists read and the official pages read. Our World in Data states
  the process and keeps the description files beside the code.
- **Files or a database.** Our World in Data works in files and serves from a
  database. Observable Framework runs any database work when the site is built
  and serves files. Datasette serves a database, locked against changes. The
  Department for Education's reader-built tables need a database, and it is the
  database that lets a saved table know it is out of date. The journalists and
  the journal publish files. None read says that holding the data one way or the
  other is what makes the working visible.
- **When the calculation runs.** Once, at publication (Observable, ONS chart
  files, Our World in Data's archive) or every time a reader asks (Datasette,
  the Department for Education's table tool). A figure computed on request is
  current, and a link to it can show different numbers next month. The
  Department for Education answers that with a creation date and a warning. Our
  World in Data answers it with a dated archive copy and a frozen embed.
- **Keeping old versions.** The ONS keeps previous releases; the Department for
  Education keeps all releases in a series; Our World in Data archives dated
  copies and cites them; the Code asks that statistics continue to be available
  "such as through web or data archiving". The Scottish Government replaced the
  corrected tables at the same address and said so. R1 found the same split
  among datasets.
- **How far down a reader can go.** Official statistics stop at totals, partly
  because the records are about people. The Markup published cleaned records
  and withheld the raw ones for the same reason. Datasette gives every row an
  address. Our World in Data gives each data point's source but not a page for
  it.

---

## 4. What could not be found or read

- **The Institute for Government's Parliamentary Monitor**, the nearest UK
  example about a legislature, was not read. Three guessed addresses for recent
  editions were not found, and the site's search is behind a bot check.
- **Observable's website** is behind a security check. Its documentation was
  read from its GitHub repository instead.
- **Evidence**, a tool that builds report pages from written queries, was not
  read. Its documentation address now leads to a page about a different product
  of the company's, and it was not pursued.
- **The Scottish Government's statistics policies** (revisions, corrections,
  release practice) were not found. Five guessed addresses returned "not found",
  and the site's search needs a browser.
- **The ONS's revisions policies** were read only as a list of links, and its
  data visualisation guidance only as an index page.
- **The Department for Education's charts** are drawn in the browser, so what
  their labels and sources say was not seen.
- **A Datasette row page** was not opened: the address tried for the demo was
  wrong. The finding that every row has an address rests on the documentation.
- **Public Health Scotland's and the ONS Centre for Crime and Justice's
  published code**, named by the civil service strategy, were not read.
- **OSR's guidance on the public-use standards** and its 2025 review of
  "intelligent transparency" were linked but not read.
- **ProPublica's data store** was fetched and not read; nothing here rests on it.
- **No study of what readers of these sites can read, or use**, was looked for.
  None of the sources read says in terms which readers are expected to read code.
  What can be said is what is offered: Our World in Data gives worked examples
  for a spreadsheet, Python and R; Datasette's filters need no code but editing
  its calculation needs SQL; the official producers write for the public and put
  code elsewhere.

---

## 5. Questions only the owner can answer

1. **Who the working is for.** "ideally showing our sql working" serves a reader who
   reads SQL. Prose serves everyone. Our World in Data and the official
   producers lead with prose and put the code a step away; Datasette leads with
   the calculation. Which reader comes first on this site is yours.
2. **The calculation beside the figure, or a step away.** Beside it, as
   Datasette does; linked from it; or kept in the repository and named.
3. **This repository is already public on GitHub.** The code that builds the
   dataset is therefore already published, as the RAP standard asks. Whether a
   figure's page links to its calculation there, which ties the site's working to
   an outside service, or shows it on the site itself, is yours.
4. **A data file per chart**, as the government's chart guidance asks and the
   ONS and Our World in Data give, and whether it carries the source and the date
   taken as Our World in Data's does.
5. **A date inside a downloaded chart image.** Settled already: the date sits
   beside the heading, inside a screenshot. A chart saved as an image file is a
   different route: Our World in Data puts the source in the image and no date,
   and the government guidance keeps text out of the image altogether.
6. **A link that goes stale.** If a reader shares a link to a figure and the
   data changes, the Department for Education keeps the creation date and warns;
   Our World in Data offers a frozen copy. With no archive, the question is
   whether the page says the numbers may have changed since the link was made.
7. **How far down a reader can go**: from a figure to the list of bills in it,
   and from a bill to its provenance notes. Whether each bill has its own
   address follows from it, and the plan already notes nothing asks whether
   there is a page per bill.
8. **Independent checking of a published figure.** AJPS has the figures re-run
   from the published materials before publication. Whether a closure test
   re-runs each published figure from its published calculation, rather than
   checking the page, is yours.
9. **The Code's voluntary application scheme.** Anyone may apply the Code and
   join a register by publishing a statement. It is a public commitment with
   an outside body, so it is named here and not proposed.

---

## 6. Recommendation

*This is a recommendation, kept apart from the findings. The owner may read
everything above without it.*

- **Keep each figure's calculation in one file, and have the site both run it
  and show it from that file.** That gives Datasette's guarantee, that what is
  shown is what ran, without adding Datasette. A check can then compare the
  text on the page with the file in the repository.
- **On a figure's page, in this order:** the figure; the rule in a sentence of
  plain English, and the methodology notes it rests on; the source; the date;
  then the calculation itself, folded away until asked for. This follows Our
  World in Data's order and adds the step it leaves out.
- **Give every figure its own data file**, carrying the date taken, the
  sources and the address of the page it came from, as Our World in Data's does
  and the ONS's does not.
- **Let a reader get from a figure to the bills counted in it, and from a bill
  to its provenance notes.** That is the property that separates this resource
  from the dashboard in `PLAN.md`, and only Datasette among the sites read
  offers it.
- **Put the date inside a downloaded chart image as well**, since nothing read
  does and the reason in the screenshot decision applies to an image file too.
- **When a page's numbers change, say so on the page** with the date, in the
  way the Department for Education's saved tables and the Scottish
  Government's errata do. This is not an archive, and it is the practice
  closest to the no-archive promise.
- **Leave the repository link a question until question 3 is answered**, since
  it ties the working to an outside service.
