{smcl}
{* *! version 1.0.6  15dec2014}{...}
{viewerdialog power "dialog power_dlg"}{...}
{vieweralsosee "[PSS] power, table" "mansection PSS power,table"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS] power" "help power"}{...}
{vieweralsosee "[PSS] power, graph" "help power_optgraph"}{...}
{viewerjumpto "Syntax" "power_opttable##syntax"}{...}
{viewerjumpto "Menu" "power_opttable##menu"}{...}
{viewerjumpto "Description" "power_opttable##description"}{...}
{viewerjumpto "Suboptions" "power_opttable##suboptions"}{...}
{viewerjumpto "Remarks" "power_opttable##remarks"}{...}
{viewerjumpto "Examples" "power_opttable##examples"}{...}
{viewerjumpto "Stored results" "power_opttable##results"}{...}
{title:Title}

{p2colset 5 27 29 2}{...}
{p2col :{manlink PSS power, table} {hline 2}}Produce table of the results from
the power command{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Produce default table 

{p 8 16 2}
{opt power} ... {cmd:,} {cmdab:tab:le} ...


{phang}
Suppress table

{p 8 16 2}
{opt power} ... {cmd:,} {cmdab:notab:le} ...
  

{marker tablespec}{...}
{phang}
Produce custom table

{p 8 16 2}
{opt power} ... {cmd:,} {cmdab:tab:le(}[{it:colspec}] [{cmd:,} {it:{help power_opttable##tableopts:tableopts}}]{cmd:)} ...


{marker colspec}{...}
{pstd}
where {it:colspec} is

{p 16 16 2}
{it:{help power_opttable##column:column}}[{cmd::}{it:label}] [{it:column}[{cmd::}{it:label}] [...]]

{pstd}
{it:column} is one of the columns defined {help power_opttable##column:below},
and {it:label} is a column label (may contain quotes and compound quotes).

{synoptset 28 tabbed}{...}
{marker tableopts}{...}
{synopthdr:tableopts}
{synoptline}
{syntab:Table}
{synopt: {cmd:add}}add {it:column}s to the default table{p_end}
{synopt: {opth lab:els(power_opttable##labspec:labspec)}}change default labels
for specified columns; default labels are column names{p_end}
{synopt: {opth wid:ths(power_opttable##widthspec:widthspec)}}change default
column widths; default is specific to each column{p_end}
{synopt: {opth f:ormats(power_opttable##fmtspec:fmtspec)}}change default
column formats; default is specific to each column{p_end}
{synopt:{opt noformat}}do not use default column formats{p_end}
{synopt: {opt sep:arator(#)}}draw a horizontal separator line every {it:#}
lines; default is {cmd:separator(0)}, meaning no separator lines{p_end}
{synopt:{opt div:ider}}draw divider lines between columns{p_end}
{synopt:{opt byrow}}display rows as computations are performed; 
seldom used{p_end}
{synopt:{opt nohead:er}}suppress table header; seldom used{p_end}
{synopt:{opt cont:inue}}draw a continuation border in the table output;
    seldom used{p_end}
{synoptline}
{p 4 6 2}
{cmd:noheader} and {cmd:continue} are not shown in the dialog box.
{p_end}

{synoptset 28}{...}
{marker column}{...}
{synopthdr :column}
{synoptline}
{synopt :{opt alpha}}significance level{p_end}
{synopt :{opt power}}power{p_end}
{synopt :{opt beta}}type II error probability{p_end}
{synopt :{opt N}}total number of subjects{p_end}
{synopt :{opt N1}}number of subjects in the control group{p_end}
{synopt :{opt N2}}number of subjects in the experimental group{p_end}
{synopt :{opt nratio}}ratio of sample sizes, experimental to control{p_end}
{synopt :{opt delta}}effect size{p_end}
{synopt :{opt target}}target parameter{p_end}
{synopt :{opt _all}}display all supported columns{p_end}
{synopt :{it:method_columns}}columns specific to the 
{help power##method:method} specified with {cmd:power}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
By default, the following columns are displayed:{p_end}
{phang2}
{cmd:alpha}, {cmd:power}, and {cmd:N} are always displayed;{p_end}
{phang2}
{cmd:N1} and {cmd:N2} are displayed for two-sample methods;{p_end}
{phang2}
{cmd:delta} is displayed when defined by the method;{p_end}
{phang2}
additional columns specific to each {cmd:power} {help power##method:method}
may be displayed.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Power and sample size}


{marker description}{...}
{title:Description}

{pstd}
{cmd:power, table} displays results in a tabular format.  {cmd:table} is
implied if any of the {cmd:power} command's arguments or options contain more
than one element.  The {cmd:table} option is useful if you are producing
graphs and would like to see the table as well or if you are producing results
one case at a time using a loop and wish to display results in a table.  The
{cmd:notable} option suppresses table results; it is implied with the
graphical output of {cmd:power, graph}; see
{manhelp power_optgraph PSS:power, graph}.


{marker suboptions}{...}
{title:Suboptions}

{pstd}
The following are suboptions within the {cmd:table()} option of the 
{cmd:power} command.

{dlgtab:Table}

{phang}
{cmd:add} requests that the columns specified in 
{it:{help power_opttable##colspec:colspec}} be added to the default table.  The
columns are added to the end of the table.

{marker labspec}{...}
{phang}
{opt labels(labspec)} specifies labels to be used in the table for the
specified columns.  {it:labspec} is

{pmore}
{it:{help power_opttable##column:column}} {cmd:"}{it:label}{cmd:"} [{it:column} {cmd:"}{it:label}{cmd:"} [...]]

{pmore}
{cmd:labels()} takes precedence over the specification of column labels
in {it:{help power_opttable##colspec:colspec}}.

{marker widthspec}{...}
{phang}
{opt widths(widthspec)} specifies column widths.  The default values are the
widths of the default column formats plus one.  If the {cmd:noformat} option
is used, the default for each column is nine.  The column widths are adjusted
to accommodate longer column labels and larger format widths.  {it:widthspec}
is either a list of values including missing values ({help numlist}) or

{pmore}
{it:{help power_opttable##column:column}} {it:#} [{it:column} {it:#} [...]]

{pmore}
For the value-list specification, the number of specified values may not
exceed the number of columns in the table.  A missing value ({cmd:.}) may be
specified for any column to indicate the default width.  If fewer widths are
specified than the number of columns in the table, the last width specified is
used for the remaining columns.

{pmore}
The alternative column-list specification provides a way to change widths
of specific columns.

{marker fmtspec}{...}
{phang}
{opt formats(fmtspec)} specifies column formats.  The default is {cmd:%7.0g}
for integer-valued columns and {cmd:%7.4g} for real-valued columns.
{it:fmtspec} is either a list of string value-list of
{help format:format}s that may include empty strings or a column list:

{pmore}
{it:{help power_opttable##column:column}} {cmd:"}{it:{help format:fmt}}{cmd:"} [{it:column} {cmd:"}{it:fmt}{cmd:"} [...]]

{pmore}
For the value-list specification, the number of specified values may not
exceed the number of columns in the table.  Am empty string ({cmd:""}) may be
specified for any column to indicate the default format.  If fewer formats are
specified than the number of columns in the table, the last format specified
is used for the remaining columns.

{pmore}
The alternative column-list specification provides a way to change
formats of specific columns.

{phang}
{opt noformat} requests that the default formats not be applied to the column
values.  If this suboption is specified, the column values are based on the
column width.

{phang}
{opt separator(#)} specifies how often separator lines should be drawn between
rows of the table.  The default is {cmd:separator(0)}, meaning that no
separator lines should be displayed.

{phang}
{opt divider} specifies that divider lines be drawn between columns.  The
default is no dividers.

{phang}
{opt byrow} specifies that table rows be displayed as computations are
performed.  By default, the table is displayed after all computations are
performed.  This suboption may be useful when the computation of each row of the
table takes a long time.

{pstd}
The following suboptions are available but are not shown in the dialog box:

{phang}
{cmd:noheader} prevents the table header from displaying.  This suboption is
useful when the command is issued repeatedly, such as within a loop.

{phang}
{cmd:continue} draws a continuation border at the bottom of the table.  This
suboption is useful when the command is issued repeatedly, such as  within a
loop.


{marker remarks}{...}
{title:Remarks}

{pstd}
If you specify the {cmd:table} option or include more than one element in
command arguments or in options allowing multiple values, the {cmd:power}
command displays results in a tabular form.  If desired, you can suppress the
table by specifying the {cmd:notable} option.  The {cmd:table} option is
useful if you are producing graphical output or if you are producing results
one case at a time, such as within a loop, and wish to display results in a
table; see {mansection PSS power,tableRemarksandexamplesex4:example 4} in
{bf:[PSS] power, table}.

{pstd}
Each method specified with the {cmd:power} command has its own default table.
Among the columns that are always included in the default table are
significance level ({cmd:alpha}), power ({cmd:power}), total sample size
({cmd:N}), and effect size ({cmd:delta}){cmd:ash}if effect size is defined by
the method.  For two-sample methods, the columns containing the sample sizes
of the control and experimental groups, {cmd:N1} and {cmd:N2}, respectively,
are also included after the total sample size.

{pstd}
You can build your own table by specifying the columns and, optionally, their
labels in the {cmd:table()} option.  You can also add columns to the default
table by specifying {cmd:add} within {cmd:power}'s {cmd:table()} option.  The
columns are displayed in the order they are specified.  Each method provides
its own list of supported columns; see the description of the {cmd:table()}
option for each method.   You can further customize the table by specifying
various suboptions within {cmd:power}'s {cmd:table()} option.

{pstd}
The default column labels are the column names.  You can provide your own
column labels in {it:{help power_opttable##colspec:colspec}} or by
specifying {cmd:table()}'s suboption {cmd:labels()}.  The labels containing
spaces should be enclosed in quotes, and the labels containing quotes should be
enclosed in compound quotes.  The {cmd:labels()} suboption is useful for
changing the labels of existing columns; see
{help power opttable##examples:examples} below for details.

{pstd}
The default formats are {cmd:%7.4g} for real-valued columns and {cmd:%7.0g}
for integer-valued columns.  If the {cmd:noformat} suboption is specified, the
default column widths are nine characters.  You can use {cmd:formats()} to
change the default column formats and {cmd:widths()} to change the default
column widths.  The {cmd:formats()} and {cmd:widths()} suboptions provide two
alternative specifications, a value-list specification or a column-list
specification.  The value-list specification accepts a list of
values -- strings for formats and numbers for
widths -- corresponding to each column of the displayed table.  Empty
strings ({cmd:""}) for formats and missing values ({cmd:.}) for widths are
allowed and denote the default values.  It is an error to specify more values
than the number of displayed columns.  If fewer values are specified, then the
last value specified is used for the remaining columns.  The column-list
specification includes a list of pairs containing a column name followed by
the corresponding value of the format or width.  This specification is useful
if you want to modify the formats or the widths of only selected columns.  For
column labels or formats exceeding the default column width, the widths of the
respective columns are adjusted to accommodate the column labels and the
specified formats.

{pstd}
If you specify the {cmd:noformat} suboption, the default formats are ignored,
and the format of a column is determined based on the column width: if the
column width is {it:#}, the displayed format is
{cmd:%}({it:#} - 2){cmd:.}{it:#}{cmd:g}.
For example, if the column width is 9, the displayed format is {cmd:%7.0g}.

{pstd}
You may further customize the look of the table by using {opt separator(#)} to
include separator lines after every {it:#} lines and by using the 
{cmd:divider} suboption to include divider lines between columns.

{pstd}
The {cmd:noheader} and {cmd:continue} suboptions are useful when you are
building your own table within a loop; see
{mansection PSS power,tableRemarksandexamplesex4:example 4} in
{bf:[PSS] power, table}.


{marker examples}{...}
{title:Examples}

{pstd}
These examples are intended for quick reference.  For a conceptual overview of
{cmd:power, table} and examples with discussion, see
{mansection PSS power,tableRemarksandexamples:{it:Remarks and examples}} in
{bf:[PSS] power, table}.

{pstd}
    Display results in a table{p_end}
{phang2}{cmd:. power onemean 0 1, table}{p_end}
{phang2}{cmd:. power onemean 0 (1 2)}

{pstd}
    Change labels of specified columns{p_end}
{phang2}{cmd:. power onemean 0 (1 2),}
       {cmd:table(, labels(N "Sample size" sd "Std. Dev."))}

{pstd}
    Same as above, also changing widths or formats of some columns{p_end}
{phang2}{cmd:. power onemean 0 (1 2), n(5)}
       {cmd:table(, labels(N "Sample size" sd "Std. Dev.")}
       {cmd:widths(N 14 sd 14) formats(power "%7.5f" alpha "%6.3f"))}

{pstd}
    Add additional columns not shown by default{p_end}
{phang2}{cmd:. power onemean 0 (1 2), table(diff, add)}

{pstd}
    Produce a table with only the specified columns, using custom
    labels{p_end}
{phang2}{cmd:. power onemean 0 (1 2),}
       {cmd:table(alpha:"Significance level"}
       {cmd:power:Power N:"Sample size" delta:"Effect size", widths(. 15))}

{pstd}
    Display all available columns{p_end}
{phang2}{cmd:. power onemean 0 (1 2), table(_all, widths(8))}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:power, table} stores the following in {cmd:r()} in addition to other
results stored by {helpb power##results:power}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
INCLUDE help pss_rrestab_sc.ihlp

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
INCLUDE help pss_rrestab_mac.ihlp

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
INCLUDE help pss_rrestab_mat.ihlp
{p2colreset}{...}
