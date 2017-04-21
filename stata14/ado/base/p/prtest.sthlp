{smcl}
{* *! version 1.1.11  11jan2015}{...}
{viewerdialog "prtest" "dialog prtest"}{...}
{viewerdialog "prtesti" "dialog prtesti"}{...}
{vieweralsosee "[R] prtest" "mansection R prtest"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] bitest" "help bitest"}{...}
{vieweralsosee "[MV] hotelling" "help hotelling"}{...}
{vieweralsosee "[R] proportion" "help proportion"}{...}
{vieweralsosee "[R] ttest" "help ttest"}{...}
{viewerjumpto "Syntax" "prtest##syntax"}{...}
{viewerjumpto "Menu" "prtest##menu"}{...}
{viewerjumpto "Description" "prtest##description"}{...}
{viewerjumpto "Options" "prtest##options"}{...}
{viewerjumpto "Remarks" "prtest##remarks"}{...}
{viewerjumpto "Examples" "prtest##examples"}{...}
{viewerjumpto "Stored results" "prtest##results"}{...}
{title:Title}

{p2colset 5 19 21 2}{...}
{p2col :{manlink R prtest} {hline 2}}Tests of proportions{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
One-sample test of proportion

{p 8 15 2}
{cmd:prtest} {varname} {cmd:==} {it:#p} {ifin} [{cmd:,} {opt l:evel(#)}]


{phang}
Two-sample test of proportions using groups

{p 8 15 2}
{cmd:prtest} {varname} {ifin} {cmd:,} {opth "by(varlist:groupvar)"} [{opt l:evel(#)}]


{phang}
Two-sample test of proportions using variables

{p 8 15 2}
{cmd:prtest} {it:{help varname:varname1}} {cmd:==} {it:{help varname:varname2}}
    {ifin} [{cmd:,} {opt l:evel(#)}]


{phang}
Immediate form of one-sample test of proportion

{p 8 16 2}
{cmd:prtesti} {it:#obs1} {it:#p1} {it:#p2} 
[{cmd:,} {opt l:evel(#)} {opt c:ount}]


{phang}
Immediate form of two-sample test of proportions

{p 8 16 2}{cmd:prtesti} {it:#obs1} {it:#p1} {it:#obs2} {it:#p2} 
[{cmd:,} {opt l:evel(#)} {opt c:ount}]


{phang}
{cmd:by} is allowed with {cmd:prtest}; see {manhelp by D}.


{marker menu}{...}
{title:Menu}

    {title:prtest}

{phang2}
{bf:Statistics > Summaries, tables, and tests >}
    {bf:Classical tests of hypotheses > Proportion test}

    {title:prtesti}

{phang2}
{bf:Statistics > Summaries, tables, and tests >}
     {bf:Classical tests of hypotheses > Proportion test calculator}


{marker description}{...}
{title:Description}

{pstd}
{cmd:prtest} performs tests on the equality of proportions using
large-sample statistics.  The test can be performed for one sample against a
hypothesized population value or for no difference in population proportions
estimated from two samples.

{pstd}
{cmd:prtesti} is the immediate form of {cmd:prtest}; see {help immed}.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opth "by(varlist:groupvar)"} specifies a numeric variable that contains the
group information for a given observation.  This variable must have only two
values.  Do not confuse the {opt by()} option with the {cmd:by} prefix; both
may be specified.

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for
confidence intervals.  The default is {cmd:level(95)} or as set by 
{helpb set level}.

{phang}
{opt count} specifies that integer counts instead of proportions be used in
the immediate forms of {cmd:prtest}.  In the first syntax, {cmd:prtesti}
expects that {it:#obs1} and {it:#p1} are counts -- {it:#p1} {ul:<}
{it:#obs1} -- and {it:#p2} is a proportion.  In the second syntax,
{cmd:prtesti} expects that all four numbers are integer counts, that
{it:#obs1} {ul:>} {it:#p1}, and that {it:#obs2} {ul:>} {it:#p2}.


{marker remarks}{...}
{title:Remarks}

{pstd}
For one-sample tests of proportions with small sample sizes and to obtain
exact p-values, researchers should use {helpb bitest}.


{marker examples}{...}
{title:Examples}

    {hline}
    Setup
{phang2}{cmd:. sysuse auto}{p_end}

{phang}One-sample test of proportion{p_end}
{phang2}{cmd:. prtest foreign==.4}

    {hline}
    Setup
{phang2}{cmd:. webuse cure}{p_end}

{phang}Two-sample test of proportions using variables{p_end}
{phang2}{cmd:. prtest cure1==cure2}

    {hline}
    Setup
{phang2}{cmd:. webuse cure2}{p_end}

{phang}{cmd:cure} has same proportion for males and females{p_end}
{phang2}{cmd:. prtest cure, by(sex)}

{phang}Immediate form of one-sample test of proportion{p_end}
{phang2}{cmd:. prtesti 50 .52 .70}{p_end}

{phang}First two numbers are counts{p_end}
{phang2}{cmd:. prtesti 30 4  .7, count}{p_end}

{phang}Immediate form of two-sample test of proportions{p_end}
{phang2}{cmd:. prtesti 30 .4  45 .67}{p_end}

{phang}All numbers are counts{p_end}
{phang2}{cmd:. prtesti 30 4  45 17, count}{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:prtest} and {cmd:prtesti} store the following in {cmd:r()}:

{synoptset 10 tabbed}{...}
{p2col 4 10 14 2: Scalars}{p_end}
{synopt:{cmd:r(z)}}z statistic{p_end}
{synopt:{cmd:r(P_}{it:#}{cmd:)}}proportion for variable {it:#}{p_end}
{synopt:{cmd:r(N_}{it:#}{cmd:)}}number of observations for variable {it:#}{p_end}
{p2colreset}{...}
