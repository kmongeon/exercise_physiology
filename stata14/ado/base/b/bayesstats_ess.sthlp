{smcl}
{* *! version 1.0.2  17mar2015}{...}
{viewerdialog "bayesstats ess" "dialog bayesstats_ess"}{...}
{vieweralsosee "[BAYES] bayesstats ess" "mansection BAYES bayesstatsess"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayesmh" "help bayesmh"}{...}
{vieweralsosee "[BAYES] bayesmh postestimation" "help bayesmh postestimation"}{...}
{vieweralsosee "[BAYES] bayesstats summary" "help bayesstats summary"}{...}
{viewerjumpto "Syntax" "bayesstats_ess##syntax"}{...}
{viewerjumpto "Menu" "bayesstats_ess##menu"}{...}
{viewerjumpto "Description" "bayesstats_ess##description"}{...}
{viewerjumpto "Options" "bayesstats_ess##options"}{...}
{viewerjumpto "Examples" "bayesstats_ess##examples"}{...}
{viewerjumpto "Stored results" "bayesstats_ess##results"}{...}
{title:Title}

{p2colset 5 31 31 2}{...}
{p2col :{manlink BAYES bayesstats ess} {hline 2}}Effective sample sizes and related statistics{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Statistics for all model parameters 

{p 8 11 2}
{opt bayesstats ess} [{cmd:,} {it:{help bayesstats_ess##options_table:options}}]

{p 8 11 2}
{opt bayesstats ess} {cmd:_all} [{cmd:,} {it:{help bayesstats_ess##options_table:options}}]


{phang}
Statistics for selected model parameters

{p 8 11 2}
{opt bayesstats ess} {it:{help bayesstats_ess##paramspec:paramspec}} [{cmd:,} {it:{help bayesstats_ess##options_table:options}}]


{phang}
Statistics for functions of model parameters

{p 8 11 2}
{opt bayesstats ess} {it:{help bayesstats_ess##exprspec:exprspec}} [{cmd:,} {it:{help bayesstats_ess##options_table:options}}]


{phang}
Full syntax 

{p 8 11 2}
{opt bayesstats ess} {it:spec} [{it:spec} ...] [{cmd:,} {it:{help bayesstats_ess##options_table:options}}]


{marker paramspec}{...}
INCLUDE help bayes_paramspec

{marker exprspec}{...}
INCLUDE help bayes_exprspec

{phang}
{it:spec} is one of {it:{help bayesstats_ess##paramspec:paramspec}}  
or {it:{help bayesstats_ess##exprspec:exprspec}}.

{synoptset 20 tabbed}{...}
{marker options_table}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{opt skip(#)}}skip every {it:#} observations from the MCMC sample;
default is {cmd:skip(0)}{p_end}
{synopt :{opt noleg:end}}suppress table legend{p_end}
{synopt :{it:{help bayesstats ess##display_options:display_options}}}control
spacing, line width, and base and empty cells{p_end}

{syntab:Advanced}
{synopt :{opt corrlag(#)}}specify maximum autocorrelation lag; default
varies{p_end}
{synopt :{opt corrtol(#)}}specify autocorrelation tolerance; default is
{cmd:corrtol(0.01)}{p_end}
{synoptline}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Bayesian analysis > Effective sample sizes}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayesstats ess} calculates effective sample sizes (ESS), correlation
times, and efficiencies for model parameters and functions of model parameters
using current estimation results from the {cmd:bayesmh} command.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt skip(#)} specifies that every {it:#} observations from the MCMC sample
not be used for computation.  The default is {cmd:skip(0)} or to use all
observations in the MCMC sample.  Option {cmd:skip()} can be used to subsample
or thin the chain.  {opt skip(#)} is equivalent to a thinning interval of
{it:#}+1.  For example, if you specify {cmd:skip(1)}, corresponding to the
thinning interval of 2, the command will skip every other observation in the
sample and will use only observations 1, 3, 5, and so on in the computation.
If you specify {cmd:skip(2)}, corresponding to the thinning interval of 3, the
command will skip every 2 observations in the sample and will use only
observations 1, 4, 7, and so on in the computation.  {cmd:skip()} does not
thin the chain in the sense of physically removing observations from the
sample, as is done by {cmd:bayesmh}'s {cmd:thinning()} option.  It only
discards selected observations from the computation and leaves the original
sample unmodified.

{phang}
{cmd:nolegend} suppresses the display of the table legend.  The table legend
identifies the rows of the table with the expressions they represent.

{marker display_options}{...}
{phang}
{it:display_options}:
{opt vsquish},
{opt noempty:cells},
{opt base:levels},
{opt allbase:levels}, 
{opt nofvlab:el},
{opt fvwrap(#)}, 
{opt fvwrapon(style)}, and 
{opt nolstretch};
   see {helpb estimation options##display_options:[R] estimation options}.

{dlgtab:Advanced}

{phang}
{opt corrlag(#)} specifies the maximum autocorrelation lag used for
calculating effective sample sizes.  The default is
min{500,{cmd:mcmcsize()}/2}.  The total autocorrelation is computed as the sum
of all lag-k autocorrelation values for k from 0 to either {cmd:corrlag()} or
the index at which the autocorrelation becomes less than {cmd:corrtol()} if
the latter is less than {cmd:corrlag()}.

{phang}
{opt corrtol(#)} specifies the autocorrelation tolerance used for calculating
effective sample sizes.  The default is {cmd:corrtol(0.01)}.  For a given
model parameter, if the absolute value of the lag-k autocorrelation is less
than {cmd:corrtol()}, then all autocorrelation lags beyond the kth lag are
discarded.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse oxygen}{p_end}
{phang2}{cmd:. set seed 14}{p_end}
{phang2}{cmd:. bayesmh change age group, likelihood(normal({c -(}var{c )-}))}
        {cmd:prior({change:}, flat) prior({c -(}var{c )-}, jeffreys)}

{pstd}Effective sample sizes for all model parameters{p_end}
{phang2}{cmd:. bayesstats ess}

{pstd}Effective sample size for parameter {cmd:{change:age}}{p_end}
{phang2}{cmd:. bayesstats ess {change:age}}

{pstd}Effective sample sizes for a function of model parameter
{cmd:{c -(}var{c )-}}{p_end}
{phang2}{cmd:. bayesstats ess (sqrt({c -(}var{c )-}))}

{pstd}Effective sample sizes for multiple functions of model parameters with
labels for each expression{p_end}
{phang2}{cmd:. bayesstats ess (exp_age: exp({change:age})) (sd: sqrt({c -(}var{c )-}))}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:bayesstats ess} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 17 2: Scalars}{p_end}
{synopt:{cmd:r(skip)}}number of MCMC observations to skip in the
computation; every {cmd:r(skip)} observations are skipped{p_end}
{synopt:{cmd:r(corrlag)}}maximum autocorrelation lag{p_end}
{synopt:{cmd:r(corrtol)}}autocorrelation tolerance{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 17 2: Macros}{p_end}
{synopt:{cmd:r(expr_}{it:#}{cmd:)}}{it:#}th expression{p_end}
{synopt:{cmd:r(names)}}names of model parameters and expressions{p_end}
{synopt:{cmd:r(exprnames)}}expression labels{p_end}

{p2col 5 15 17 2: Matrices}{p_end}
{synopt:{cmd:r(ess)}}matrix with effective sample sizes, correlation times, and efficiencies for parameters in {cmd:r(names)}{p_end}
{p2colreset}{...}
