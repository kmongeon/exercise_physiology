{smcl}
{* *! version 1.1.12  03apr2013}{...}
{vieweralsosee "[D] import" "mansection D import"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] edit" "help edit"}{...}
{vieweralsosee "[D] import delimited" "help import delimited"}{...}
{vieweralsosee "[D] import excel" "help import excel"}{...}
{vieweralsosee "[D] import haver" "help import haver"}{...}
{vieweralsosee "[D] import sasxport" "help import sasxport"}{...}
{vieweralsosee "[D] infile (fixed format)" "help infile2"}{...}
{vieweralsosee "[D] infile (free format)" "help infile1"}{...}
{vieweralsosee "[D] infix" "help infix"}{...}
{vieweralsosee "[D] input" "help input"}{...}
{vieweralsosee "[D] odbc" "help odbc"}{...}
{vieweralsosee "[D] xmlsave" "help xmlsave"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] export" "help export"}{...}
{viewerjumpto "Description" "import##description"}{...}
{viewerjumpto "Summary of the different methods" "import##summary"}{...}
{viewerjumpto "Video example" "import##video"}{...}
{title:Title}

{p2colset 5 19 21 2}{...}
{p2col :{manlink D import} {hline 2}}Overview of importing data into Stata
{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
This entry provides a quick reference for determining which method to use for
reading non-Stata data into memory.
See {findalias frdatain} for more details.


{marker summary}{...}
{title:Summary of the different methods}


{title:{opt import excel} (see {manhelp import_excel D:import excel})}

{phang}
1.  {opt import excel} reads worksheets from Microsoft Excel ({cmd:.xls}
    and {cmd:.xlsx}) files.

{phang}
2.  Entire worksheets can be read, or custom cell ranges can be read.


{title:{opt import delimited} (see {manhelp import_delimited D:import delimited})}

{phang}
1.  {opt import delimited} reads text-delimited files.

{phang}
2.  The data can be tab-separated or comma-separated.
A custom delimiter may also be specified.

{phang}
3.  An observation must be on only one line.

{phang}
4.  The first line of the file can optionally contain the names of the
variables.


{title:{cmd:odbc} (see {manhelp odbc D})}

{phang}
1.  ODBC, an acronym for Open DataBase Connectivity, is a standard for
exchanging data between programs.  Stata supports the ODBC standard for
importing data via the {opt odbc} command and can read from any ODBC data
source on your computer.


{title:{opt infile} (free format) -- infile without a dictionary (see {help infile1})}

{phang}
1.  The data can be space-separated, tab-separated, or comma-separated.

{phang}
2.  Strings with embedded spaces or commas must be enclosed in quotes
(even if tab- or comma-separated).

{phang}
3.  An observation can be on more than one line, or there can even be
multiple observations per line.


{title:{cmd:infix} (fixed format) (see {manhelp infix D:infix (fixed format)})}

{phang}
1.  The data must be in fixed-column format.

{phang}
2.  An observation can be on more than one line.

{phang}
3.  {opt infix} has simpler syntax than {opt infile} (fixed format).


{title:{cmd:infile} (fixed format) -- infile with a dictionary (see {help infile2})}

{phang}
1.  The data may be in fixed-column format.

{phang}
2.  An observation can be on more than one line.

{phang}
3.  ASCII or EBCDIC data can be read.

{phang}
4.  {opt infile} (fixed format) has the most capabilities for reading data.


{title:{cmd:import sasxport} (see {manhelp import_sasxport D:import sasxport})}

{phang}
1.  {opt import sasxport} reads SAS XPORT Transport format files.

{phang}
2.  {opt import sasxport} will also read value label information from a
    {opt formats.xpf} XPORT file, if available.


{title:{cmd:import haver} (Windows only) (see {manhelp import_haver D:import haver})}

{phang}
1.  {opt import haver} reads Haver Analytics ({browse "http://www.haver.com/"})
    database files.


{title:{cmd:xmluse} (see {manhelp xmlsave D})}

{phang}
1.  {opt xmluse} reads extensible markup language (XML) files -- highly
adaptable text-format files derived from the standard generalized markup
language (SGML).

{phang}
2.  {opt xmluse} can read either an Excel-format XML or a Stata-format XML
file into Stata.
{p_end}


{marker video}{...}
{title:Video example}

{phang}
{browse "http://www.youtube.com/watch?v=iCvZ9pvPy-8":Copy/paste data from Excel into Stata}
{p_end}
