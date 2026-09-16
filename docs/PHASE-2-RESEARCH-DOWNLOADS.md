# Phase 2 research, R1: how a dataset is handed to a researcher

Written 16 September 2026 by a session that wrote neither `PHASE-2.md` nor the
research commission. Every page cited was read on 16 September 2026 unless it
says otherwise. Quotations are exact; `[…]` marks a cut.

Nothing was downloaded except documentation: ICPSR's preparation guide, V-Dem's
codebook, ParlGov's readme and codebook, and the Comparative Agendas Project's
Scottish Bills codebook. No data file was opened. The licence is left to R2, and
how the working is shown on a page is left to R3.

---

## 1. What was found, in a screen

- **Everyone offers more than one format.** V-Dem gives Stata, CSV, R and SPSS.
  ICPSR gives plain text, tab-separated text, SAS, SPSS and Stata. ParlGov gives
  a single database file, an Excel workbook and tab-separated tables. The Center
  for Effective Lawmaking gives Excel and Stata. Voteview recommends CSV. The
  Comparative Agendas Project gives CSV alone.
- **The UK Data Service advises open formats for public data**, and says a CSV
  file loses its labels, so they have to travel separately.
- **What travels with the data is much the same everywhere.** V-Dem's download
  is typical: *"Dataset, Codebook, What's New, Cautionary Notes, and Suggested
  Citations."* The archives also ask for:
  - a plain-text readme;
  - a user guide saying how the data were compiled, from what sources, and what
    was derived;
  - a record of where every variable taken from someone else came from, and
    under what licence;
  - a standard citation;
  - an edition number.
- **The standard for describing variables is DDI**, which "most social science
  data archives in the world" use. It is a file for machines. Archives turn it
  into a readable codebook, and ICPSR accepts "a uniform, structured format"
  where DDI is not possible. Lighter standards exist for describing a CSV file,
  but no archive read asks for them.
- **Worked-out figures travel, marked as worked out, with how they were
  worked out.** ICPSR asks for an "audit trail", and "ideally […] the exact
  programming statements". V-Dem labels each variable with its type and prints
  the formula beside it. ParlGov keeps its calculated tables under their own
  name prefix. V-Dem and the Center for Effective Lawmaking publish the code.
- **Several files, zipped, with a readme**, is the shape the archives, V-Dem
  and ParlGov use. The US projects and the Comparative Agendas Project instead
  put data files and documentation side by side on one page, as separate
  downloads.
- **Data that changes is handled in two ways.**
  - *Numbered releases, old ones kept*: V-Dem, ParlGov, ParlaMint.
  - *Updated in place, dated, old ones not offered*: the Congressional Bills
    Project and the Center for Effective Lawmaking.
  - *In between*: the UK Data Service provides "only […] the most current
    version" but numbers its editions and publishes a history of changes.
    Voteview updates live but keeps copies of past releases.
- **Citation principles ask more than the no-archive promise gives.** The main
  statement of data citation principles asks that a reader be able to check that
  the data they retrieve "is the same as was originally cited". The research
  data community's recommendation for data that changes requires earlier states
  to be retrievable.
- **The nearest comparable dataset is the Comparative Agendas Project's
  "Scottish Bills"**: 161 bills, 1999–2008, one CSV and a one-page codebook
  listing each variable in a line, with no values, sources or method.
- **A permanent identifier (a DOI) is universal** among the archives, V-Dem and
  ParlGov. Every one comes through an outside service.

---

## 2. The findings in full

### 2.1 The UK Data Service

**Formats it accepts.** "Recommended formats",
`https://www.data-archive.ac.uk/managing-data/standards-and-procedures/recommended-formats/`
(the Service's own address redirects there). Formats are chosen "with regard to
their suitability for data sharing and reuse, and for supporting long-term
preservation". For tables:

- *with extensive metadata* (labels, codes, defined missing values): preferred
  are SPSS, Stata or SAS files; or "Delimited text and command ('setup') file
  […] containing metadata information"; or a DDI file;
- *with minimal metadata*: preferred are CSV and tab-delimited text, "Including
  delimited text of given character set with SQL data definition statements
  where appropriate"; Excel, Access and OpenDocument spreadsheets are acceptable;
- *documentation*: preferred are RTF, PDF, HTML, OpenDocument text and R
  Markdown; plain text and Word are acceptable.

**Why open formats.** "File formats and data conversion",
`https://ukdataservice.ac.uk/learning-hub/data-producer-support/preparing-data-for-sharing-and-reuse/technical-preparation/fileformatsanddataconversion/`:

> If you plan to make data publicly available, you should choose an open,
> platform-independent format where possible.

> the creation of a CSV version of each SPSS or Stata format file is a good
> policy, although such files will not contain label metadata, which will need
> to be saved separately.

It also warns that moving between Stata and SPSS "may result in information
loss", because they handle missing values and labels differently.

**What a deposit must include.** "Prepare your data collection for deposit",
`https://ukdataservice.ac.uk/help/deposit-data/prepare-your-data-for-deposit/`:

- the data must be "the final, cleaned, quality-assured and documented version";
- a study-level document (a user guide or technical report) must describe how
  the data were "collected, generated or compiled (including […] data sources
  where applicable)", the processing, "Any anonymisation, transformations or
  derivation", and the quality assurance applied;
- "for collections containing multiple files or complex structures, a ReadMe
  file providing an overview of the collection must be submitted";
- a codebook, which "At minimum […] must include Dataset Name; Dataset
  Description; Variable Name; Variable Description/Label; Data Type; Values
  (where applicable) and Length (where applicable)";
- "Missing value codes are defined and documented";
- for variables taken from other sources, a *Variable Information Log*, "to
  ensure transparency regarding the origin and licensing of all externally
  sourced variables";
- file names with no spaces or capitals, words joined by underscores.

**Derived variables.** "Data-level documentation",
`https://ukdataservice.ac.uk/learning-hub/data-producer-support/preparing-data-for-sharing-and-reuse/documenting-and-describing-data/data-leveldocumentation/`.
Documentation should explain "What transformations or modifications have been
applied" and "How missing or incomplete material is represented", and describe
"Derived or constructed variables and how they were created":

> Where derivations are simple, documentation within the variable label may be
> sufficient. More complex derivations should be described in sufficient detail
> to allow the logic to be understood or reproduced. Retaining syntax or command
> files supports transparency.

It adds that distinctions such as "not applicable", "not known" or "not asked"
"can materially affect analysis".

**Keeping working files apart from what is released.** "Preparing release
versions of data",
`https://ukdataservice.ac.uk/learning-hub/data-producer-support/preparing-data-for-sharing-and-reuse/technical-preparation/preparingreleaseversionsofdata-2/`:
"separating raw, processed and final release files", because "Maintaining a
clear distinction between internal working files and external release versions
helps avoid confusion and supports reproducibility."

**The codebook standard.** "Metadata",
`https://ukdataservice.ac.uk/learning-hub/data-producer-support/preparing-data-for-sharing-and-reuse/documenting-and-describing-data/metadata/`.
DDI "is used by most social science data archives in the world", and the
Service builds its catalogue records with it. Among the "administrative
metadata" a dataset carries are "version history" and "rights and copyright
information". "We prepare a standard bibliographic citation for each data
collection."

**Versions, and only the current one.** "Collection level citation",
`https://www.data-archive.ac.uk/managing-data/standards-and-procedures/persistent-identifiers/collection-level-citation/`:

> We only provide access for the most current version of data, as changes can
> be made to data due to errors, or updates that make the older versions
> inadvisable to use. As yet, we have not seen requests for older versions, as
> most users are looking for the most up to date social and economic
> information.

> So, our citation does not point directly to data files but to metadata.

Changes are sorted by impact. Adding or removing a variable, or "significant new
documentation", gets a new identifier with a new number on the end; "correcting
typos" and "small changes in labels" do not. "The DOI resolves to a jump page
which lists the history of changes." Its standard citation:

> Office for National Statistics, Social Survey Division, Northern Ireland
> Statistics and Research Agency. (2019). Quarterly Labour Force Survey, January
> - March, 2012. [data collection]. 7th Edition. UK Data Service. SN: 7037, DOI:
> 10.5255/UKDA-SN-7037-8

That study's own read-me, `https://doc.ukdataservice.ac.uk/doc/7037/read7037.htm`,
has a "NEW EDITION INFORMATION" section: "For the seventh edition (September
2019), the variable FDSNGDEG (Higher subject coding frame) was added to the
data." Its curation note says "Multiple data and documentation formats may be
generated for dissemination and preservation".

**Citing part of a dataset.** "Quantitative data subsets", same site. A saved
table in the Service's online tool "will always query and display the most
recent edition of the data". Its proposed citation for a table is the table's
title and link, then "In" and the citation for the whole collection.

**Citing correctly.** "Cite data correctly",
`https://ukdataservice.ac.uk/learning-hub/new-to-using-data/#cite-data-correctly`.
Every catalogue page has a citation tool offering APA, DataCite, Harvard and
other styles. Researchers citing several studies should give "the individual
study numbers used, and their edition numbers, alongside it to ensure
reproducibility."

### 2.2 ICPSR

ICPSR's website refused scripted reading on every page tried (§4). Its
*Guide to Social Science Data Preparation and Archiving* could be read, at
`https://www.icpsr.umich.edu/files/deposit/dataprep.pdf`. The file is dated
February 2020. Page numbers below are the guide's own.

**What researchers are handed** (p. 17, in its example data management plan):

> ICPSR will make the quantitative data files available in several widely used
> formats, including ASCII, tab-delimited (for use with Excel), SAS, SPSS, and
> Stata. Documentation will be provided as PDF.

For keeping, ICPSR "stores quantitative data as ASCII along with setup files for
the statistical software packages, and documentation is preserved using XML and
PDF/A." Each dataset gets a DOI and "A standard citation" (p. 16).

**Formats** (p. 47). "Ideally, the dataset should be accessible using a standard
statistical package, such as SAS, SPSS, or Stata." Archives "increasingly
encourage the deposit of system files and use this format for dissemination",
while "Many archives view ASCII (raw) data files as the most stable format for
preserving data" (p. 48). It warns that converting to SAS's transport format
can erase the difference between kinds of missing data, which "become
irretrievable" (p. 48).

**The codebook** (pp. 32–35). ICPSR recommends DDI. "It may not be possible for a
project to produce documentation that is DDI-conformant. In those situations,
using a uniform, structured format […] is the best alternative." For each
variable it asks for:

- "The exact question wording or the exact meaning of the datum";
- "Exact meaning of codes";
- "Missing data codes […] Different types of missing data should have distinct
  codes";
- "Unweighted frequency distribution or summary statistics";
- "Imputation and editing information. Documentation should identify data that
  have been estimated or extensively edited";
- and, for constructed variables:

> Documentation should include “audit trails” for such variables, indicating
> exactly how they were constructed, what decisions were made about imputations,
> and the like. Ideally, documentation would include the exact programming
> statements used to construct such variables.

A variable's label should say "whether the variable is constructed from other
items". For a dataset not built from a survey, the documentation gives
"citations to the original sources or documents from which the data were
obtained" (p. 34). A separate "Coding information" document "details the rules
and definitions used for coding the data" (p. 36).

**The readme** (p. 36): "a plain-text document that makes research data easier
to navigate and use, and is stored alongside data". "README files are always
saved in .txt format".

**Versions** (p. 37): "With explicit version numbers, which are reflected in
dataset names, it becomes easier to match documentation to datasets". Constructed
variables are added "to the end of the codebook, with appropriate labels and the
formulas used to create them" (p. 38).

**Data built from existing published sources** (pp. 49–50), the closest case to
this dataset. Where combining sources is straightforward, the report "should
clearly identify the source of the existing data including version and/or date".
Where it takes judgement, "the researcher is providing a useful service by
archiving the linked data". And:

> All useful derived variables should be archived also, especially if they are
> used in analyses included in publications. […] The code or setup file used to
> link the files and create the derived variables should also be provided.

### 2.3 Describing the variables: DDI, and lighter standards

**DDI-Codebook**, `https://ddialliance.org/ddi-codebook`. The current version is
2.6, dated 15 April 2026; the one before, 2.5, dates from 2012. It is
"Structured, descriptive documentation of the content, meaning, provenance, and
access for a single data set", covering "identification, authorship, ownership,
purpose, background methodologies, source information, provenance, quality
control, access, physical file structures, variables/variable groupings, and
related materials." It is an XML file, written for software.

**What a codebook holds**, `https://ddialliance.org/create-a-codebook`:
"a dataset's record layout, list of variable names and labels, concepts,
categories, cases, missing value codes, frequency counts, notes, universe
statements, and so on." The Alliance's own example is a readable PDF codebook
with the same content as a DDI file beside it. The tools it lists for making
DDI are specialist ones, some commercial. It notes the information "can
sometimes be provided by a researcher in a readme file".

**For Excel**, `https://ddialliance.org/document-data-in-excel`: "A well
formatted Excel file will have one dataset per sheet."

**CSV on the Web**, W3C, `https://www.w3.org/TR/tabular-data-primer/` (a Working
Group Note of 25 February 2016). It starts from a limitation:

> CSV is also a poor format for data. There is no mechanism within CSV to
> indicate the type of data in a particular column, or whether values in a
> particular column must be unique.

Its answer is a small description file beside the CSV, named after it (for
`countries.csv`, `countries.csv-metadata.json`), which can describe several
CSV files at once, give titles and descriptions, and say what values each
column may hold. On notes attached to single cells: "There's no standardised
facility in the CSV on the Web specifications for annotating individual cells".

**Data Package**, `https://datapackage.org/standard/data-package/`: "A simple
container format for describing a coherent collection of data in a single
package". A folder holds a description file, `datapackage.json`, the data files,
an optional `README.md` and a `scripts` folder. The description carries a
licence, sources, contributors, a version number ("SHOULD conform to the
Semantic Versioning requirements") and a creation date. A package's name
"SHOULD NOT change when a data package is updated". On the licence field: "This
property is not legally binding".

**Citation File Format**, `https://citation-file-format.github.io/`: a plain-text
`CITATION.cff` file with "human- and machine-readable citation information for
software (and datasets)", read by GitHub, Zenodo and Zotero.

**Google Dataset Search**,
`https://developers.google.com/search/docs/appearance/structured-data/dataset`:
a description embedded in the web page that describes a dataset, to help it be
found. For a dataset that "derives from or aggregates several originals", it
says to name them. Google writes that it hopes "to improve our recommendations
[…] around the description of provenance, versioning".

### 2.4 Citing a dataset

**The Joint Declaration of Data Citation Principles** (FORCE11, 2014),
`https://force11.org/info/joint-declaration-of-data-citation-principles-final/`.
Eight principles; four bear on this project:

> 4. Unique Identification. A data citation should include a persistent method
> for identification that is machine actionable, globally unique, and widely used
> by a community.

> 5. Access. Data citations should facilitate access to the data themselves and
> to such associated metadata, documentation, code, and other materials […]

> 6. Persistence. Unique identifiers, and metadata describing the data, and its
> disposition, should persist — even beyond the lifespan of the data they
> describe.

> 7. Specificity and Verifiability. […] Citations or citation metadata should
> include information about provenance and fixity sufficient to facilitate
> verifying that the specific timeslice, version and/or granular portion of data
> retrieved subsequently is the same as was originally cited.

Its glossary allows a date where there is no version: a version "can also be
described by a 'timeslice' or access date where a formal version is
unavailable". It does "not include recommendations for specific
implementations".

**Citing data that changes.** The Research Data Alliance's *Data Citation of
Evolving Data* (2015),
`https://www.rd-alliance.org/groups/data-citation-wg/outputs/scalable-dynamic-data-citation-methodology/`.
It proposes citing a saved request for the data, stamped with the time it was
made, which re-runs against the data as it stood then. That depends on keeping
every earlier state:

> Data Versioning: For retrieving earlier states of datasets the data needs to
> be versioned. Markers shall indicate inserts, updates and deletes of data in
> the database.

> Instead of providing static data exports or textual descriptions of data
> subsets, we support a dynamic, query centric view of data sets.

Its fourteen detailed rules are in an attached PDF, not read.

### 2.5 V-Dem

**The download page**, `https://www.v-dem.net/data/the-v-dem-dataset/`:

> Each ZIP includes: Dataset, Codebook, What's New, Cautionary Notes, and
> Suggested Citations.

There are four datasets, each "Version 16", "Published March 2026", in "STATA,
CSV, R, SPSS". R users are pointed to an R package holding the data. The
codebook, methodology, country units, how indices are built, and the project's
organisation are separate documents alongside.

**Versions change past values.** The page's FAQ answers "Can I compare index
scores across versions […]?" with "No", because "We currently allow our coders
to update and change their ratings back in time". The citation names the
version and carries a DOI: "[…] 2026. "V-Dem [Country-Year/Country-Date] Dataset
v16" Varieties of Democracy (V-Dem) Project. https://doi.org/10.23696/vdemds26."

**Old versions are kept.** `https://v-dem.net/data/dataset-archive/`: "Access and
download previous dataset versions", versions 10 to 16 on the site, older ones
at two university archives.

**The codebook**, `https://www.v-dem.net/documents/70/codebook_v16.pdf`, 507 pages,
read in part. It opens with "New in Version 16 compared to Version 15",
"Cautionary Notes" and "Suggested Citation". Every variable has a type, and the
types separate what was taken from what was made:

> Type A: Variables coded by Project Managers and Research Assistants\
> This data is based on existing sources and is factual in nature.

> Type D: Indices\
> Variables composed of type A, or C variables. This data may be accomplished by adding a denominator (e.g., per capita), by creating a
> cumulative scale, or by aggregating larger concepts […]

> Type E: Non-V-Dem variables\
> If we import a variable from another source
> without doing any original coding […] it is not considered a V-Dem product.
> […] If, however, we gather data from a number of sources and combine them in a
> more than purely mechanical fashion (requiring some judgment on our part), we
> regard this as a V-Dem product […]

A worked-out variable's entry names its type in its heading ("Electoral
democracy index (D)"), lists the variables it is built from under "Source(s)",
says which releases it appears in, and gives the formula under "Aggregation".
"Since version 11 of the V-Dem dataset we have released the code that is used
for creating the V-Dem datasets to the public".

### 2.6 ParlGov

Parties, elections and cabinets in EU and OECD democracies, 1900–2023.

**The project ended in 2024.** "Retiring from ParlGov", 1 October 2024,
`https://www.parlgov.org/2024/10/01/retiring-from-parlgov/`:

> parlgov-experimental.db includes all public information from the project. All
> other information (data tables, news, docs, news entries, etc.) is derived from
> it.

"All changes since mid-2009 are documented in news entries". The maintainers
keep "an archive of document sources (several thousand files)" and "versions of
the entire SQLite database" privately. The site stays up "as long as it needs
only security updates".

**Releases.** Stable releases went to Harvard Dataverse from 2016
(`https://www.parlgov.org/2016/03/09/parlgov-archive-at-harvard-dataverse/`),
with "development" versions on the site between them. The final one, "ParlGov
2024 Release", `https://doi.org/10.7910/DVN/2VZ5ZC`, was read through
Dataverse's public listing. It is under CC0 and holds ten files:

- `readme.txt`;
- `codebook.md` and `codebook.pdf`;
- `parlgov-stable.db` and `parlgov-experimental.db`, each the whole database
  as one file, openable in free database software but not in Excel;
- `parlgov-stable.xlsx`;
- `view_cabinet.tab`, `view_election.tab`, `view_party.tab`, and
  `view_variable.tab`, which describes the variables in the other three.

**The readme** starts with the citation and "Version — 12 August 2024". It gives
each table a line, marks the three main ones "(main view)", and says "text files
are utf-8 encoded". Then the credits.

**The codebook** is "Created on 12 August 2024, 14:52 from ParlGov database
documentation entries". In order:

- the reference, and the two articles describing the design;
- *coding rules* for parties, elections and cabinets, each with its data
  sources;
- *country notes*, called "an evolving and incomplete documentation";
- *changes by release*, under "New information", "Documentation" and
  "Corrections and updates". Corrections are listed one by one, for example
  "NLD cabinet 1946: removed VVD".

It says openly what is less certain: pre-1945 observations "are experimental
and may need revision", and some items are "Experimental version only — coding
incomplete". **Calculated tables are named apart**, with the prefix
`viewcalc_`. For seats at a cabinet's formation it states the rule: "calculated
based on 1. election result or parliament composition table – most recent date
used 2. parliament change table entries after (1)", "stored in viewcalc
parliament composition".

### 2.7 The Comparative Agendas Project, and its Scottish Bills

**The datasets page**, `https://www.comparativeagendas.net/datasets_codebooks`.
Each dataset has a paragraph, a count ("N observations spanning the years"), a
dataset download and a codebook download.

**Scottish Bills**:

> The short and long titles of Bills of the Scottish Parliament were blind-coded
> by two researchers; assigning a majortopic and subtopic code to each. This
> procedure led to eighty-five percent inter-coder reliability for major topics.
> The remaining differences were resolved through discussion by the project
> leaders.

"161 observations spanning the years 1999 to 2008". The file is
`uk_scottishbills_v1_1.csv` (not downloaded). Beside it on the page: Scottish
Hearings (1999–2007) and Scottish Statutory Instruments (1999–2014).

**Its codebook**, `uk_scottishbills_codebook_v1_1.pdf`, is one page: "Scottish
Bills: Master Codebook Release 1999-2008 (v 1.1)", "Last Updated: 08 June 2016",
with its corresponding article (John, Bevan and Jennings, 2011, *Journal of
European Public Policy* 18(7)). Each variable gets one line:

> type: Type of Bill. Specifically whether the Bill was introduced by a member,
> a committee, the executive or if it was introduced privately.

> outcome: The outcome of the Bill. Specifically whether the bill was enacted,
> withdrawn or if it was fallen.

> date: The data of the outcome.

The other variables are `id`, `introduced`, `session`, `year`, `royal_assent`,
`description` ("Previously called short_title"), `long_title`, `act_title`,
`majortopic` and `subtopic`. It gives no coded values, no sources for dates or
outcomes, and no method beyond the web paragraph.

**Versions in file names.** For US Congressional Hearings the page says "please
be mindful of which version of the dataset you use (indicated by the year and
version number suffix at the end of the file name). For previous versions of the
dataset beginning in 2018, please email".

**Citation**, `https://www.comparativeagendas.net/pages/How-to-cite`: each
country's data has its own wording. For the United Kingdom it is the book
*Policy Agendas in British Politics* (John, Bertelli, Jennings and Bevan, 2013).
R2 recorded this page as not found. It was read today at this address.

### 2.8 The Congressional Bills Project

Its address now serves an unrelated site. Its own pages were read as the
Internet Archive kept them.

**About** (captured 23 September 2020),
`https://web.archive.org/web/20200923230512/http://www.congressionalbills.org/index.html`:
"more than 400,000 bills introduced in the U.S. Congress", organised "in a format
that facilitates quantitative studies". And: "we are confident that users will
find errors that we have overlooked among the 400,000 cases. Please let us know
when you find them!"

**Download** (captured 28 November 2020),
`https://web.archive.org/web/20201128160448/http://www.congressionalbills.org/download.html`.
Files are split by range of Congresses, each marked with the date it was last
updated, such as "(updated 8/11/2018)". No version numbers are given and no
earlier files are offered. Corrections are announced at the top of the page:

> The 93-114th file has been updated. We have corrected numerious errors related
> to the ReportH, ReportS, PassH, PassS, MRef and Majority variables.

The notice traces the errors to the sources the variables were built from, with
a named bill and its source page as an example of each. It also passes on a
warning it had not yet resolved: "The Congressional Research Service has also
informed us that there may be errors for the PassS and PassH variables for the
93rd Congress."

It tells the reader how to open the files in Excel, step by step. It gives the
number of records in each file and asks: "Please confirm that the row numbers
are correct and that the columns have lined up properly."

**Codebooks** (captured 24 April 2021),
`https://web.archive.org/web/20210424083951/http://www.congressionalbills.org/codebooks.html`.
A worked-out filter for "Important Bills [updated 4/20/2017]" is published as
the exact Excel formula that computes it. That is followed by the judgement made
by hand on top: "We then reviewed all bills with 'designate' in their titles and
tagged those that (in our judgement) named or renamed buildings". When the topic
codes changed in 2014, "The earlier bills codes (oldMajor, oldMinor) are
included through the 112th Congress."

### 2.9 Two more datasets about a legislature

**Voteview**, US congressional roll-call votes, `https://voteview.com/data`:

> Data is updated live, as new votes are taken. If you are an institutional user
> of our data and wish to be notified before major or breaking changes are made
> to the data, please see the About page.

The citation carries a year and the address, and no version. A reader chooses
the kind of data, the chamber and the Congress, then a format: "CSV
(Recommended)", "JSON (Web Developers)", and two older formats marked "Not
Recommended". Each kind of data has an article describing its fields. Worked-out
scores are published as articles showing "how scores are calculated", with the
code. A copy of the whole database is "updated weekly and is provided without
warranty", and:

> Browse prior database releases: We retain archival copies of our complete
> database release. We recommend users only use the most current version of our
> data. These archival releases may be missing new rollcall or member data, and
> may also be missing corrections made to existing data.

`https://voteview.com/about` offers an email list for "major changes", "no more
than annual in frequency", run through an outside email company.

**The Center for Effective Lawmaking**, `https://thelawmakers.org/data-download`.
Its scores count each legislator's bills at five stages, from introduced to law.
Files come as Excel and Stata. The date of revision is in the file name, for
example `CELHouse93to118-REVISED-06.26.2025.xlsx`. Each score is cited to a book
or article with "updated at www.thelawmakers.org".

Its methodology page, `https://thelawmakers.org/methodology`, says where the
dates come from ("the 'All Actions' section of the bill summary" on congress.gov).
It also gives the formula and its weights. When the method changed from the
117th Congress, both versions stayed in the download ("including both LES 1.0
and 2.0"), and the page gives the correlation between old and new.

### 2.10 ParlaMint

Its project page refused scripted reading (§4). Its GitHub page,
`https://github.com/clarin-eric/ParlaMint`, was read. The corpora are transcripts,
not tables, so their formats do not carry over. What does is the release
practice: "The latest version of ParlaMint is 5.0". Each variant has its own
permanent address in a university repository. The repository also holds "the
build environemt for a release, and all associated data", including the scripts
that convert the master files into "useful derived formats".

### 2.11 Repositories that keep versions for you

Both would mean an account with somebody else, so they are listed here and put
to the owner in §5, not built around.

- **Harvard Dataverse**, where ParlGov deposited,
  `https://guides.dataverse.org/en/latest/user/dataset-management.html`. Editing
  a published dataset creates a new version, 1.1 or 2.0. A "Versions" tab lists
  the history and can show the differences between two versions. Tables
  uploaded as Stata, SPSS, R, Excel, CSV or tab-separated files can be downloaded
  in several forms: tab-separated text, the original file, R, "Variable Metadata
  (as a DDI Codebook XML file)", and a citation in RIS, EndNote or BibTeX.
- **Zenodo**, `https://help.zenodo.org/docs/deposit/manage-versions/`. Each new
  version is "a completely new record with separate metadata, files and
  persistent identifier, but it is linked to all previous and future versions.
  This ensures that if a researcher cite the specific version, they can be sure
  the files did not change."

### 2.12 Side by side

| | Formats | Beside the data | Worked-out values | When it changes |
|---|---|---|---|---|
| UK Data Service | open formats for public data; statistics packages | readme, user guide, codebook, sources log, citation | described, with the code | current only; numbered editions; history of changes |
| ICPSR | plain text, tab-separated, SAS, SPSS, Stata; PDF documents | codebook, readme, coding rules, citation | "audit trail", ideally the code | advises version numbers in file names |
| V-Dem | Stata, CSV, R, SPSS | codebook, what's new, cautions, citations | typed "D", formula beside it, code public | numbered; old versions kept |
| ParlGov | database file, Excel, tab-separated | readme, codebook with changes listed | separate tables, `viewcalc_` | yearly releases kept; ended 2024 |
| CAP Scottish Bills | CSV | one-page codebook | none | "v1_1" in file name |
| Congressional Bills | tab- or semicolon-separated text | codebook, crosswalks | filter published as its formula | updated in place, dated; corrections on the page |
| Voteview | CSV recommended; JSON | an article per kind of data | articles with code | live; weekly copies kept |
| Center for Effective Lawmaking | Excel, Stata | methodology page, FAQ | formula on the page; old and new method both kept | revision date in file name |

---

## 3. Where practice disagrees

- **Keeping old versions.** V-Dem, ParlGov, ParlaMint, Dataverse and Zenodo
  keep every release. The UK Data Service keeps only the current one, and says
  users have not asked for older ones. The Congressional Bills Project and the
  Center for Effective Lawmaking replace files in place. Voteview keeps old
  copies but advises against using them. The citation principles (§2.4) sit
  with the first group.
- **Version numbers or dates.** V-Dem, ICPSR and CAP number. The Congressional
  Bills Project and the Center for Effective Lawmaking date. The UK Data Service
  does both. The FORCE11 glossary accepts a date "where a formal version is
  unavailable".
- **What counts as a new version.** The UK Data Service gives a new identifier
  only for "high impact" changes, not typos. Dataverse forces a major version
  whenever a file is added or removed. Zenodo makes every new version a new
  record.
- **Which formats.** The archives lead with statistics-package formats, which
  keep labels inside the file. The UK Data Service's advice for public data, and
  Voteview's recommendation, lead with CSV, which needs its labels described
  elsewhere. Excel appears as a main format only at ParlGov and the Center for
  Effective Lawmaking.
- **How the codebook is written.** Archives want DDI. Projects write a PDF
  (V-Dem), Markdown and PDF generated from the database's own descriptions
  (ParlGov), web articles (Voteview), or one page (CAP). No project read offers
  a DDI file of its own; Dataverse generates one.
- **Where worked-out values sit.** In the same file, typed and labelled (V-Dem);
  in separate tables with their own prefix (ParlGov); in separate files and
  articles (Voteview, the Center for Effective Lawmaking).
- **How corrections are told.** A list of each correction in the codebook
  (ParlGov). A notice on the download page, with worked examples (Congressional
  Bills). A "What's New" document (V-Dem). An edition note in the read-me (UK
  Data Service). A mailing list for major changes (Voteview).

---

## 4. What could not be found or read

- **ICPSR's website** refused scripted reading on every page tried: its deposit
  guide pages, its citation page, a study page and its home page (a browser
  check). What ICPSR hands a researcher today is known only from its 2020 guide.
- **The UK Data Service's catalogue pages** show nothing unless the page is run
  in a browser, so what one study's download holds was not seen. Only the
  study's read-me was read.
- **ParlaMint's project page at `clarin.eu`** sits behind a bot check. Its GitHub
  page was read instead.
- **The Congressional Bills Project's own site** now serves an unrelated site.
  Its archived pages date from 2020 and 2021; whether the project has a new home
  was not found.
- **The Research Data Alliance's fourteen rules** are in a PDF attached to the
  page, not read. Only the summary was read.
- **V-Dem's codebook** was read in its opening sections and one variable entry,
  not all 507 pages.
- **DataCite's own guidance on citation** was not found: the address tried
  returned "not found", and no other was tried.
- **The Parliament's own open data site** was not read for how it hands out its
  data; R2 found its notes page cannot be read without a browser.
- **No survey of what researchers prefer** was looked for. Everything here is
  what publishers do, not what readers asked for.

---

## 5. Questions only the owner can answer

1. **Which software your researchers use.** CSV alone serves everyone but carries
   no labels. Excel, Stata, R and SPSS versions each serve a group. Practice
   offers anything from one to five.
2. **A number, a date, or both, on each download.** The date is settled. Whether
   downloads also carry a release number, and what counts as a new release, is
   not.
3. **A public record of corrections.** ParlGov lists each correction; the
   Congressional Bills Project announces them on the download page with worked
   examples. This is not an archive of old versions. Whether the project keeps
   one, and where, is yours.
4. **What the documentation says about the no-archive promise.** That is
   settled. The citation principles ask for what it does not give: a reader
   cannot later retrieve the exact file they cited. Whether a download says so
   in plain words is a question of wording.
5. **Worked-out figures: in the same file as the dates, or in a file of their
   own**, and whether the code that computes them travels with the download.
6. **A permanent identifier (DOI).** Every archive and most projects have one.
   It means an account with an outside service, such as a repository like
   Zenodo or Dataverse, or DataCite through an institution. None is proposed
   here.
7. **Depositing a copy with an archive**, such as a UK Data Service record, or
   a release on Dataverse or Zenodo. The same outside-account question, and a
   different answer to "no archive": the archive would keep what the project
   does not.
8. **The earlier Scottish Bills dataset.** CAP's 161 bills, 1999–2008, record
   type, outcome and dates for bills this dataset also covers. Whether the
   documentation mentions it, for readers who know it, is yours.

---

## 6. Recommendation

*This is a recommendation, kept apart from the findings. The owner may read
everything above without it.*

- **Offer one zipped download containing:**
  - a plain-text readme;
  - the data as CSV;
  - a readable codebook;
  - the methodology notes;
  - the provenance notes;
  - a suggested citation;
  - the licence statement;
  - a "what changed" section.

  That is V-Dem's list, with the archives' readme added. The archives and the
  larger projects converge on it.
- **Choose any extra format from question 1**, not from practice. Practice
  covers every format, so it cannot settle this. CSV is the one format all of
  them could open.
- **Write the codebook to the UK Data Service's minimum, plus the empty cell.**
  For each column: name, description, type, the values it may hold, and what
  empty means. Say where each value came from, as ICPSR asks of data built from
  published sources. The distinction between "not applicable" and "not known" is
  the one both archives single out. Do not attempt DDI: no project of this size
  read produces it.
- **Mark worked-out figures as worked out, and print how.** Use V-Dem's pattern:
  in the codebook, each worked-out column says it is worked out, which columns
  it comes from, and the rule. Whether the code travels too is question 5, and
  practice leans to yes.
- **Name the file with the date it was taken**, as the Center for Effective
  Lawmaking does. Put the same date in the readme and the citation. This follows
  the FORCE11 glossary's allowance for an access date where there is no formal
  version. It makes no promise that an archive would have to keep.
- **Keep a dated list of corrections in the documentation**, as ParlGov does.
  The no-archive promise stays. A reader who cited an older download can then
  at least see what has changed since.
- **Leave the permanent identifier and any deposit to questions 6 and 7.** Both
  are outside accounts, and nothing above depends on them.
