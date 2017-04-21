{smcl}
{* *! version 1.2.4  10aug2012}{...}
{vieweralsosee "[D] clear" "mansection D clear"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] discard" "help discard"}{...}
{vieweralsosee "[D] drop" "help drop"}{...}
{viewerjumpto "Syntax" "clear##syntax"}{...}
{viewerjumpto "Description" "clear##description"}{...}
{viewerjumpto "Examples" "clear##examples"}{...}
{title:Title}

{p2colset 5 18 20 2}{...}
{p2col :{manlink D clear} {hline 2}}Clear memory{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 13 2}{cmd:clear}

{p 8 13 2}{cmd:clear} [ {cmd:mata} | {cmd:results} | {cmd:matrix} | {cmd:programs} | {cmd:ado} ]

{p 8 13 2}{cmd:clear} [ {cmd:all} | {cmd:*} ]


{marker description}{...}
{title:Description}

{pstd}
{cmd:clear}, by itself, removes data and value labels from memory and is
equivalent to typing

{p2colset 9 34 36 2}{...}
{p2col :{cmd:. version {ccl stata_version}}}{p_end}
{p2col :{cmd:. drop _all}}(see {manhelp drop D}){p_end}
{p2col :{cmd:. label drop _all}}(see {manhelp label D}){p_end}
{p2colreset}{...}

{pstd}
{cmd:clear mata} removes Mata functions and objects from memory and
is equivalent to typing

{p2colset 9 34 36 2}{...}
{p2col :{cmd:. version {ccl stata_version}}}{p_end}
{p2col :{cmd:. mata: mata clear}}(see {manhelp mata_clear M-3:mata clear})
{p_end}
{p2colreset}{...}

{pstd}
{cmd:clear results} eliminates stored results from memory and is equivalent
to typing

{p2colset 9 34 36 2}{...}
{p2col :{cmd:. version {ccl stata_version}}}{p_end}
{p2col :{cmd:. return clear}}(see {manhelp return P}){p_end}
{p2col :{cmd:. ereturn clear}}(see {manhelp return P}){p_end}
{p2col :{cmd:. sreturn clear}}(see {manhelp return P}){p_end}
{p2col :{cmd:. _return drop _all}}(see {manhelp _return P}){p_end}
{p2colreset}{...}

{pstd}
{cmd:clear matrix} eliminates from memory all matrices created by Stata's
{cmd:matrix} command; it does not eliminate Mata matrices from memory.
{cmd:clear matrix} is equivalent to typing

{p2colset 9 34 36 2}{...}
{p2col :{cmd:. version {ccl stata_version}}}{p_end}
{p2col :{cmd:. return clear}}(see {manhelp return P}){p_end}
{p2col :{cmd:. ereturn clear}}(see {manhelp return P}){p_end}
{p2col :{cmd:. sreturn clear}}(see {manhelp return P}){p_end}
{p2col :{cmd:. _return drop _all}}(see {manhelp _return P}){p_end}
{p2col :{cmd:. matrix drop _all}}(see {manhelp matrix_utility P:matrix utility}){p_end}
{p2col :{cmd:. estimates drop _all}}(see {manhelp estimates R}){p_end}
{p2colreset}{...}

{pstd}
{cmd:clear programs} eliminates all programs from memory and is
equivalent to typing

{p2colset 9 34 36 2}{...}
{p2col :{cmd:. version {ccl stata_version}}}{p_end}
{p2col :{cmd:. program drop _all}}(see {manhelp program P}){p_end}
{p2colreset}{...}

{pstd}
{cmd:clear ado} eliminates all automatically loaded ado-file programs
from memory (but not programs defined interactively or by do-files).  It
is equivalent to typing

{p2colset 9 34 36 2}{...}
{p2col :{cmd:. version {ccl stata_version}}}{p_end}
{p2col :{cmd:. program drop _allado}}(see {manhelp program P}){p_end}
{p2colreset}{...}

{pstd}
{cmd:clear all} and {cmd:clear *} are synonyms.  They remove all data, value
labels, matrices, scalars, constraints,
clusters, stored results, sersets, and
Mata functions and objects from memory.  They also close all open
files and postfiles, clear the class system, close any
open Graph windows and dialog boxes, drop all
programs from memory, and reset all timers to zero.  They are
equivalent to typing

{p2colset 9 34 36 2}{...}
{p2col :{cmd:. version {ccl stata_version}}}{p_end}
{p2col :{cmd:. drop _all}}(see {manhelp drop D}){p_end}
{p2col :{cmd:. label drop _all}}(see {manhelp label D}){p_end}
{p2col :{cmd:. matrix drop _all}}(see {manhelp matrix_drop P:matrix utility})
{p_end}
{p2col :{cmd:. scalar drop _all}}(see {manhelp scalar P}){p_end}
{p2col :{cmd:. constraint drop _all}}(see {manhelp constraint R}){p_end}
{p2col :{cmd:. cluster drop _all}}(see {manhelp cluster_drop MV:cluster utility}){p_end}
{p2col :{cmd:. file close _all}}(see {manhelp file P}){p_end}
{p2col :{cmd:. postutil clear}}(see {manhelp postutil P:postfile}){p_end}
{p2col :{cmd:. _return drop _all}}(see {manhelp _return P}){p_end}
{p2col :{cmd:. discard}}(see {manhelp discard P}){p_end}
{p2col :{cmd:. program drop _all}}(see {manhelp program P}){p_end}
{p2col :{cmd:. timer clear}}(see {manhelp timer P}){p_end}
{p2col :{cmd:. mata: mata clear}}(see {manhelp mata_clear M-3:mata clear}){p_end}
{p2colreset}{...}


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. describe}{p_end}
{phang2}{cmd:. label list}

{pstd}Drop all data and value labels from memory{p_end}
{phang2}{cmd:. clear}

{pstd}Show that data and value labels have been eliminated from memory{p_end}
{phang2}{cmd:. describe}{p_end}
{phang2}{cmd:. label list}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. regress price mpg rep78 foreign}{p_end}
{phang2}{cmd:. summarize price}{p_end}
{phang2}{cmd:. ereturn list}{p_end}
{phang2}{cmd:. return list}{p_end}

{pstd}Eliminate stored results from memory{p_end}
{phang2}{cmd:. clear results}

{pstd}Show that stored results have been eliminated from memory{p_end}
{phang2}{cmd:. ereturn list}{p_end}
{phang2}{cmd:. return list}{p_end}
    {hline}
