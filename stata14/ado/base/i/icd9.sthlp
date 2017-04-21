{smcl}
{* *! version 1.5.3  01sep2016}{...}
{viewerdialog icd9 "dialog icd9"}{...}
{vieweralsosee "[D] icd9" "mansection D icd9"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] icd" "help icd"}{...}
{viewerjumpto "Syntax" "icd9##syntax"}{...}
{viewerjumpto "Menu" "icd9##menu"}{...}
{viewerjumpto "Description" "icd9##description"}{...}
{viewerjumpto "Options" "icd9##options"}{...}
{viewerjumpto "Examples" "icd9##examples"}{...}
{viewerjumpto "Stored results" "icd9##results"}{...}
{title:Title}

{p2colset 5 17 19 2}{...}
{p2col :{manlink D icd9} {hline 2}}ICD-9-CM diagnosis and procedure codes{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Verify that variable contains defined codes

{p 8 16 2}
{c -(}{cmd:icd9}|{cmd:icd9p}{c )-}
{cmd:check} {varname}
{ifin}
[{cmd:,}
{opt any}
{opt l:ist}
{opth g:enerate(newvar)}]


{phang}
Clean variable and verify format of codes 

{p 8 16 2}
{c -(}{cmd:icd9}|{cmd:icd9p}{c )-}
{opt clean} {varname}
{ifin}
[{cmd:,}
{opt dot:s}
{opt pad}]


{phang}
Generate new variable from existing variable

{p 8 16 2}
{c -(}{cmd:icd9}|{cmd:icd9p}{c )-}
{opt gen:erate} {newvar} {cmd:=} {varname} {ifin}{cmd:,}
{opt cat:egory}

{p 8 16 2}
{c -(}{cmd:icd9}|{cmd:icd9p}{c )-}
{opt gen:erate} {newvar} {cmd:=} {varname} {ifin}{cmd:,}
{opt d:escription}
[{opt long} {opt end}]

{p 8 16 2}
{c -(}{cmd:icd9}|{cmd:icd9p}{c )-}
{opt gen:erate} {newvar} {cmd:=} {varname} {ifin}{cmd:,}
{opt r:ange(codelist)}


{phang}
Display code descriptions

{p 8 16 2}
{c -(}{cmd:icd9}|{cmd:icd9p}{c )-}
{opt look:up} {it:codelist}


{phang}
Search for codes from descriptions

{p 8 16 2}
{c -(}{cmd:icd9}|{cmd:icd9p}{c )-}
{opt sea:rch}
[{cmd:"}]{it:text}[{cmd:"}]
[[{cmd:"}]{it:text}[{cmd:"}] {it:...}]
[{cmd:,}
{opt or}]


{phang}
Display ICD-9 code source

{p 8 16 2}
{c -(}{cmd:icd9}|{cmd:icd9p}{c )-}
{opt q:uery}


{pstd}
{it:codelist} is

{p2colset 9 30 32 2}{...}
{p2col :{it:icd9code}}(the particular code){p_end}
{p2col :{it:icd9code}{cmd:*}}(all codes starting with){p_end}
{p2col :{it:icd9code}{cmd:/}{it:icd9code}}(the code range){p_end}
{p2colreset}{...}

{pstd}
or any combination of the above, such as {cmd:001* 018/019 E* 018.02}.
{it:icd9codes} must be typed with leading 0s.  For example, type
{cmd:001} (diagnosis code) or {cmd:01} (procedure code); typing {cmd:1}
will result in an error.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > ICD codes > ICD-9}


{marker description}{...}
{title:Description}

{pstd}
The {cmd:icd9} and {cmd:icd9p} commands are a suite of commands for working
with ICD-9-CM diagnosis and ICD-9-CM procedure codes from the 16th version
(effective October 1998) and later.  To see the current version of the
ICD-9-CM diagnosis codes and any changes that have been applied, type
{cmd:icd9} {cmd:query}.

{pstd}
{cmd:icd9} {cmd:check}, {cmd:icd9} {cmd:clean}, and {cmd:icd9} {cmd:generate}
are data management commands.  {cmd:icd9} {cmd:check} verifies that a variable
contains ICD-9-CM diagnosis codes and provides a summary of any problems
encountered.  {cmd:icd9} {cmd:clean} standardizes the format of the codes.
{cmd:icd9} {cmd:generate} can create a binary indicator variable containing
for whether the code is in a specified set of codes, a variable
containing a corresponding higher-level code, or a variable containing the
description of the code.

{pstd}
{cmd:icd9} {cmd:lookup} and {cmd:icd9} {cmd:search} are interactive utilities.
{cmd:icd9} {cmd:lookup} displays descriptions of the diagnosis codes specified
on the command line.  {cmd:icd9} {cmd:search} looks for relevant ICD-9-CM
diagnosis codes from key words given on the command line.

{pstd}
{cmd:icd9p} may be used in place of {cmd:icd9} for any command above to obtain
results for procedure codes.


{marker options}{...}
{title:Options}

{pstd}Options are presented under the following headings:

        {help icd9##options_icd9_check:Options for icd9[p] check}
        {help icd9##options_icd9_clean:Options for icd9[p] clean}
        {help icd9##options_icd9_gen:Options for icd9[p] generate}
        {help icd9##options_icd9_search:Options for icd9[p] search}

{pstd}
Warning: The option descriptions are brief and use jargon.  Please read the
{mansection D icd9Remarksandexamples:{it:Remarks and examples}} in
{bf:[D] icd9} before using the {cmd:icd9} or {cmd:icd9p} command.


{marker options_icd9_check}{...}
{title:Options for icd9[p] check}

{phang}
{opt any} tells {opt icd9}[{opt p}] {opt check} to verify that the codes
fit the format of ICD-9-CM codes but not to check whether the codes are
defined.

{phang}
{opt list} specifies that {cmd:icd9 check} list the observation number, the
invalid or undefined ICD-9-CM code, and the reason the code is invalid or if
it is undefined code. When specified with {cmd:icd9p check}, the {cmd:list}
option references ICD-9-CM procedure codes.

{phang}
{opth generate(newvar)} specifies that {opt icd9} {opt check} create a new
variable containing, for each observation, 0 if the observation contains a
defined code or is missing.  Otherwise, it contains a number from 1 to 10.
The positive numbers indicate the kind of problem and correspond to the
listing produced by {opt icd9} {opt check}.  The values are labeled
with the Stata-defined value label {cmd:__icd_9}.


{marker options_icd9_clean}{...}
{title:Options for icd9[p] clean}

{phang}
{opt dots} specifies that the period be included in the final format.  If
{cmd:dots} is not specified, then all periods are removed.

{phang}
{opt pad} specifies that {opt icd9} {opt clean} pad the codes with
spaces, front and back, to make the (implied) dots align vertically in
listings.  Specifying {opt pad} makes the resulting codes look better when
used with most other Stata commands.


{marker options_icd9_gen}{...}
{title:Options for icd9[p] generate}

{phang}
{opt category}, {opt description}, and {opt range(codelist)}
specify the contents of the new variable that {opt icd9}[{opt p}]
{opt generate} is to create.
You do not need to {opt icd9}[{opt p}] {opt clean} {it:varname} before using
{opt icd9}[{opt p}] {opt generate}; it will accept any ICD-9-CM format or
combination of formats.

{phang2}
{opt category} generates a new variable that also contains ICD-9-CM codes.
The resulting variable may be used with the other {opt icd9}[{opt p}]
subcommands.  For procedure codes, the category code is the first two
characters.  For diagnostic codes, the category code is the first three
characters, except for E-codes when it is the first four characters.

{phang2}
{opt description} creates {newvar} containing descriptions of the
ICD-9-CM codes.

{phang3}
{opt long} is for use with {opt description}.  It specifies that the
code be prepended to the text describing the code.

{phang3}
{opt end} modifies {opt long} (specifying {opt end} implies {opt long})
and places the code at the end of the string.

{phang2}
{opt range(codelist)} creates a new indicator variable equal to 1 when
the ICD-9-CM code is in the range specified and equal to 0 otherwise.


{marker options_icd9_search}{...}
{title:Option for icd9[p] search}

{phang}
{opt or} specifies that ICD-9-CM codes be searched for descriptions that
contain any word specified with {opt icd9}[{opt p}] {opt search}.  The default
is to list only descriptions that contain all the words specified.


{marker examples}{...}
{title:Examples}

{pstd}View log of changes made to the list of ICD-9 codes since {cmd:icd9} was
implemented in Stata{p_end}
{phang2}{cmd:. icd9 query}{p_end}

{pstd}Display a description of code 526.4{p_end}
{phang2}{cmd:. icd9 lookup 526.4}{p_end}

{pstd}Look up a range of codes{p_end}
{phang2}{cmd:. icd9 lookup 526/527}{p_end}

{pstd}Search for codes containing the words jaw and disease{p_end}
{phang2}{cmd:. icd9 search jaw disease}{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse nhds2010}{p_end}

{pstd}Clean {cmd:dx1} diagnosis code variable{p_end}
{phang2}{cmd:. icd9 clean dx1}{p_end}

{pstd}Create variable {cmd:main1} containing category codes for {cmd:dx1}{p_end}
{phang2}{cmd:. icd9 generate main1 = dx1, category}{p_end}

{pstd}Attempt to clean {cmd:dx3} diagnosis code variable; will return
error{p_end}
{phang2}{cmd:. icd9 clean dx3}{p_end}

{pstd}Flag observations containing invalid codes{p_end}
{phang2}{cmd:. icd9 check dx3, generate(prob)}{p_end}

{pstd}Clean {cmd:pr1} procedure code variable and add periods{p_end}
{phang2}{cmd:. icd9p clean pr1, dots}{p_end}

{pstd}Check that {cmd:pr1} contains valid procedure codes if {cmd:pr1}
is not missing{p_end}
{phang2}{cmd:. icd9p check pr1 if !missing(pr1)}{p_end}

{pstd}Create variable {cmd:dp1} containing descriptions of codes in {cmd:pr1}
{p_end}
{phang2}{cmd:. icd9p generate dp1 = pr1, description}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:icd9}[{opt p}] {cmd:check} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(e}{it:#}{cmd:)}}number of errors of type {it:#}{p_end}
{synopt:{cmd:r(esum)}}total number of errors{p_end}
{p2colreset}{...}

{pstd}
{cmd:icd9}[{opt p}] {cmd:clean} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of changes{p_end}
{p2colreset}{...}

{pstd}
{cmd:icd9}[{opt p}] {cmd:lookup} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of codes found{p_end}
{p2colreset}{...}
