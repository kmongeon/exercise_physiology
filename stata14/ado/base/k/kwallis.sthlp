{smcl}
{* *! version 1.1.6  29sep2014}{...}
{viewerdialog kwallis "dialog kwallis"}{...}
{vieweralsosee "[R] kwallis" "mansection R kwallis"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] nptrend" "help nptrend"}{...}
{vieweralsosee "[R] oneway" "help oneway"}{...}
{vieweralsosee "[R] ranksum" "help ranksum"}{...}
{vieweralsosee "[R] sdtest" "help sdtest"}{...}
{vieweralsosee "[R] signrank" "help signrank"}{...}
{viewerjumpto "Syntax" "kwallis##syntax"}{...}
{viewerjumpto "Menu" "kwallis##menu"}{...}
{viewerjumpto "Description" "kwallis##description"}{...}
{viewerjumpto "Option" "kwallis##option"}{...}
{viewerjumpto "Example" "kwallis##example"}{...}
{viewerjumpto "Stored results" "kwallis##results"}{...}
{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :{manlink R kwallis} {hline 2}}Kruskal-Wallis equality-of-populations rank test{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:kwallis} {varname} {ifin} {cmd:,} {opth "by(varlist:groupvar)"}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Nonparametric analysis > Tests of hypotheses >}
      {bf:Kruskal-Wallis rank test}


{marker description}{...}
{title:Description}

{pstd}
{cmd:kwallis} performs a Kruskal-Wallis test of the hypothesis that several
samples are from the same population.  This test is a multisample
generalization of the two-sample Wilcoxon (Mann-Whitney) rank-sum test.


{marker option}{...}
{title:Option}

{phang}
{opth "by(varlist:groupvar)"} is required.  It specifies a variable
that identifies the groups.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse census}{p_end}

{pstd}Test equality of median age distribution across all regions simultaneously
{p_end}
{phang2}{cmd:. kwallis medage, by(region)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:kwallis} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(df)}}degrees of freedom{p_end}
{synopt:{cmd:r(chi2)}}chi-squared{p_end}
{synopt:{cmd:r(chi2_adj)}}chi-squared adjusted for ties{p_end}
{p2colreset}{...}
