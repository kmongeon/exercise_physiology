{smcl}
{* *! version 1.0.2  17mar2015}{...}
{viewerdialog "bayesstats summary" "dialog bayesstats_summary"}{...}
{vieweralsosee "[BAYES] bayesstats summary" "mansection BAYES bayesstatssummary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayesmh" "help bayesmh"}{...}
{vieweralsosee "[BAYES] bayesmh postestimation" "help bayesmh postestimation"}{...}
{vieweralsosee "[BAYES] bayestest model" "help bayestest model"}{...}
{vieweralsosee "[R] estimates" "help estimates"}{...}
{vieweralsosee "" "--"}{...}
{viewerjumpto "Syntax" "bayesstats_summary##syntax"}{...}
{viewerjumpto "Menu" "bayesstats_summary##menu"}{...}
{viewerjumpto "Description" "bayesstats_summary##description"}{...}
{viewerjumpto "Options" "bayesstats_summary##options"}{...}
{viewerjumpto "Examples" "bayesstats_summary##examples"}{...}
{viewerjumpto "Stored results" "bayesstats_summary##results"}{...}
{title:Title}

{p2colset 5 35 37 2}{...}
{p2col :{manlink BAYES bayesstats summary} {hline 2}}Bayesian summary statistics{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Summary statistics for all model parameters 

{p 8 11 2}
{opt bayesstats} {opt summ:ary} [{cmd:,} {it:{help bayesstats_summary##options_table:options}}]

{p 8 11 2}
{opt bayesstats} {opt summ:ary} {cmd:_all} [{cmd:,} {it:{help bayesstats_summary##options_table:options}}]


{phang}
Summary statistics for selected model parameters

{p 8 11 2}
{opt bayesstats} {opt summ:ary} {it:{help bayesstats_summary##paramspec:paramspec}} [{cmd:,} {it:{help bayesstats_summary##options_table:options}}]


{phang}
Summary statistics for functions of model parameters

{p 8 11 2}
{opt bayesstats} {opt summ:ary} {it:{help bayesstats_summary##exprspec:exprspec}} [{cmd:,} {it:{help bayesstats_summary##options_table:options}}]


{phang}
Summary statistics of log-likelihood and log-posterior functions 

{p 8 11 2}
{opt bayesstats} {opt summ:ary} {cmd:_loglikelihood} | {cmd:_logposterior} [{cmd:,} {it:{help bayesstats_summary##options_table:options}}]


{phang}
Full syntax 

{p 8 11 2}
{opt bayesstats} {opt summ:ary} {it:{help bayesstats_summary##spec:spec}} [{it:{help bayesstats_summary##spec:spec}} ...] 
[{cmd:,} {it:{help bayesstats_summary##options_table:options}}]


{marker paramspec}{...}
INCLUDE help bayes_paramspec

{marker exprspec}{...}
INCLUDE help bayes_exprspec

{phang}
{cmd:_loglikelihood} and {cmd:_logposterior} also have respective synonyms
{cmd:_ll} and {cmd:_lp}.

{marker spec}{...}
{phang}
{it:spec} is one of {it:{help bayesstats_summary##paramspec:paramspec}}, 
{it:{help bayesstats_summary##exprspec:exprspec}}, 
{cmd:_loglikelihood} (or {cmd:_ll}), or {cmd:_logposterior} (or {cmd:_lp}).


{synoptset 20 tabbed}{...}
{marker options_table}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{opt clev:el(#)}}set credible interval level; default is {cmd:clevel(95)}{p_end}
{synopt :{opt hpd}}display HPD credible intervals instead of the default equal-tail credible intervals{p_end}
{synopt :{opt batch(#)}}specify length of block for batch-mean calculations; default is {cmd:batch(0)}{p_end}
{synopt :{opt skip(#)}}skip every {it:#} observations from the MCMC sample;
default is {cmd:skip(0)}{p_end}
{synopt :{opt noleg:end}}suppress table legend{p_end}
{synopt :{it:{help bayesstats_summary##display_options:display_options}}}control
row spacing, line width, and display of omitted variables{p_end}

{syntab:Advanced}
{synopt :{opt corrlag(#)}}specify maximum autocorrelation lag; default varies{p_end}
{synopt :{opt corrtol(#)}}specify autocorrelation tolerance; default is {cmd:corrtol(0.01)}{p_end}
{synoptline}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Bayesian analysis > Summary statistics}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayesstats summary} calculates and reports posterior summary statistics
for model parameters and functions of model parameters using current
estimation results from the {cmd:bayesmh} command.  Posterior summary
statistics include posterior means, posterior standard deviations, MCMC
standard errors (MCSE), posterior medians, and equal-tailed credible intervals
or highest posterior density (HPD) credible intervals.


{marker options}{...}
{title:Options}

{dlgtab:Main}

INCLUDE help bayes_clevel_hpd

INCLUDE help bayes_batch

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
{opt nolegend} suppresses the display of table legend.  The table legend
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

INCLUDE help bayes_corr.ihlp


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse oxygen}{p_end}
{phang2}{cmd:. set seed 14}{p_end}
{phang2}{cmd:. bayesmh change age group, likelihood(normal({c -(}var{c )-}))}
        {cmd:prior({change:}, flat) prior({c -(}var{c )-}, jeffreys)}

{pstd}Summaries for all model parameters{p_end}
{phang2}{cmd:. bayesstats summary}

{pstd}Summaries for model parameters {cmd:{change:age}} and {cmd:{c -(}var{c )-}}{p_end}
{phang2}{cmd:. bayesstats summary {change:age} {c -(}var{c )-}}

{pstd}Summaries for model parameters {cmd:{change:age}} and {cmd:{change:_cons}}{p_end}
{phang2}{cmd:. bayesstats summary {change:age _cons}}
	
{pstd}Summaries for model parameters in the equation for {bf:change}{p_end}
{phang2}{cmd:. bayesstats summary {change:}}

{pstd}Summaries for a function of model parameters labeled {cmd:sd}{p_end}
{phang2}{cmd:. bayesstats summary (sd: sqrt({c -(}var{c )-}))}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:bayesstats summary} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 17 2: Scalars}{p_end}
{synopt:{cmd:r(clevel)}}credible interval level{p_end}
{synopt:{cmd:r(hpd)}}{cmd:1} if {cmd:hpd} is specified; {cmd:0} otherwise {p_end}
{synopt:{cmd:r(batch)}}batch length for batch-mean calculations{p_end}
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
{synopt:{cmd:r(summary)}}matrix with posterior summaries statistics for parameters in {cmd:r(names)}{p_end}
