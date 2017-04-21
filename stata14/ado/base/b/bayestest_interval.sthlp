{smcl}
{* *! version 1.0.3  10feb2016}{...}
{viewerdialog "bayestest interval" "dialog bayestest_interval"}{...}
{vieweralsosee "[BAYES] bayestest interval" "mansection BAYES bayestestinterval"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayesmh" "help bayesmh"}{...}
{vieweralsosee "[BAYES] bayesmh postestimation" "help bayesmh postestimation"}{...}
{vieweralsosee "[BAYES] bayesstats summary" "help bayesstats summary"}{...}
{vieweralsosee "[BAYES] bayestest model" "help bayestest model"}{...}
{vieweralsosee "" "--"}{...}
{viewerjumpto "Syntax" "bayestest interval##syntax"}{...}
{viewerjumpto "Menu" "bayestest interval##menu"}{...}
{viewerjumpto "Description" "bayestest interval##description"}{...}
{viewerjumpto "Options" "bayestest interval##options"}{...}
{viewerjumpto "Examples" "bayestest interval##examples"}{...}
{viewerjumpto "Stored results" "bayestest interval##results"}{...}
{title:Title}

{p2colset 5 35 37 2}{...}
{p2col :{manlink BAYES bayestest interval} {hline 2}}Interval hypothesis testing{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Test one interval hypothesis about continuous or discrete parameter

{p 8 11 2}
{opt bayestest} {cmdab:int:erval}
   {it:{help bayestest_interval##intspecs:exspec}} [{cmd:,} {it:{help bayestest_interval##luspec_table:luspec}}
                   {it:{help bayestest_interval##options_table:options}}]


{phang}
Test one point hypothesis about discrete parameter

{p 8 11 2}
{opt bayestest} {cmdab:int:erval} {it:{help bayestest_interval##intspecs:exspec}}{cmd:==}{it:#} 
[{cmd:,} {it:{help bayestest_interval##options_table:options}}]


{phang}
Test multiple hypotheses separately

{p 8 11 2}
{opt bayestest} {cmdab:int:erval} {cmd:(}{it:{help bayestest_interval##intspecs:testspec}}{cmd:)} [{cmd:(}{it:{help bayestest_interval##intspecs:testspec}}{cmd:)} ...]
[{cmd:,} {it:{help bayestest_interval##options_table:options}}]


{phang}
Test multiple hypotheses jointly

{p 8 11 2}
{opt bayestest} {cmdab:int:erval} {cmd:(}{it:{help bayestest_interval##intspecs:jointspec}}{cmd:)}
[{cmd:,} {it:{help bayestest_interval##options_table:options}}]


{phang}
Full syntax

{p 8 11 2}
{opt bayestest} {cmdab:int:erval} 
{cmd:(}{it:{help bayestest_interval##intspecs:spec}}{cmd:)} 
[{cmd:(}{it:{help bayestest_interval##intspecs:spec}}{cmd:)} ...]
[{cmd:,} {it:{help bayestest_interval##options_table:options}}]


{marker intspecs}{...}
{phang}
{it:exspec} is optionally labeled expression of model parameters,
[{it:prlabel}{cmd::}]{it:expr}, where {it:prlabel} is a valid Stata name (or
{cmd:prob}{it:#} by default), and {it:expr} is a 
{help bayes_glossary##scalar_model_parameter:scalar model parameter} or
scalar expression containing (parentheses are optional) scalar model
parameters.  The expression {it:expr} may not contain variable names.

{phang}
{it:testspec} is {it:exspec}[{cmd:,} {it:luspec}] or
{it:exspec}{cmd:==}{it:#} for discrete parameters only.

{phang}
{it:jointspec} is [{it:prlabel:}]{cmd:(}{it:testspec}{cmd:)}
{cmd:(}{it:testspec}{cmd:)} ...{cmd:, joint}.  The labels (if any) of
{it:testspec} are ignored.

{phang}
{it:spec} is one of {it:testspec} or {it:jointspec}.

{synoptset 43}{...}
{marker luspec_table}{...}
{p2coldent :{it:luspec}}Null hypothesis{p_end}
{synoptline}
{synopt :{opt l:ower(#)} [{opt u:pper(.)}]}{it:theta > #}{p_end}
{synopt :{opt l:ower}{cmd:(}#{cmd:,}{opt incl:usive)} [{opt u:pper(.)}]}{it:theta >= #}{p_end}
{synopt :[{opt l:ower(.)}] {opt u:pper(#)}}{it:theta < #}{p_end}
{synopt :[{opt l:ower(.)}] {opt u:pper}{cmd:(}#{cmd:,}{opt incl:usive)}}{it:theta <= #}{p_end}
{synopt :{opt l:ower(#_l)} {opt u:pper(#_u)}}{it:#_l < theta < #_u}{p_end}
{synopt :{opt l:ower(#_l)} {opt u:pper}{cmd:(}{it:#_u}{cmd:,}{opt incl:usive)}}{it:#_l < theta <= #_u}{p_end}
{synopt :{opt l:ower}{cmd:(}{it:#_l}{cmd:,}{opt incl:usive)} {opt u:pper(#_u)}}{it:#_l <= theta < #_u}{p_end}
{synopt :{opt l:ower}{cmd:(}{it:#_l}{cmd:,}{opt incl:usive)} {opt u:pper}{cmd:(}{it:#_u}{cmd:,}{opt incl:usive)}}{it:#_l <= theta <= #_u}{p_end}
{synoptset 30 tabbed}{...}
{synoptline}

{p2colreset}{...}
{p 4 6 2}{cmd:lower(}{it:intspec}{cmd:)} and {cmd:upper(}{it:intspec}{cmd:)}
specify the lower- and upper-interval values, respectively.{p_end}

{p 4 6 2}{it:intspec} is {p_end}
{p 8 10 2}{it:#} [{cmd:,} {opt incl:usive}] {p_end}
{p 4 6 2}where # is the interval value, and suboption {opt inclusive} specifies that this value should be included in the interval, meaning a closed interval.
Closed intervals make sense only for discrete parameters.{p_end}
{p 4 6 2}{it:intspec} may also contain a dot ({cmd:.}), meaning negative
infinity for
{cmd:lower()} and positive infinity for {cmd:upper()}.
Either option {cmd:lower(.)} or option {cmd:upper(.)} must be specified.


{synoptset 13 tabbed}{...}
{marker options_table}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{opt skip(#)}}skip every {it:#} observations from the MCMC sample; default is {cmd:skip(0)}{p_end}
{synopt :{opt noleg:end}}suppress table legend{p_end}

{syntab:Advanced}
{synopt :{opt corrlag(#)}}specify maximum autocorrelation lag; default
varies{p_end}
{synopt :{opt corrtol(#)}}specify autocorrelation tolerance; default is {cmd:corrtol(0.01)}{p_end}
{synoptline}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Bayesian analysis > Interval hypothesis testing}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayestest interval} performs interval hypothesis tests for model
parameters and functions of model parameters using current estimation results
from the {cmd:bayesmh} command.  {cmd:bayestest interval} reports mean
estimates, standard deviations, and MCMC standard errors of posterior
probabilities associated with an interval hypothesis.


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

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. set seed 14}{p_end}
{phang2}{cmd:. bayesmh mpg, likelihood(normal({c -(}var{c )-})) prior({mpg:_cons}, flat)}
	{cmd:prior({c -(}var{c )-}, jeffreys)}

{pstd}Estimated posterior mean probability of an interval hypothesis for {bf:{mpg:_cons}}{p_end}
{phang2}{cmd:. bayestest interval {mpg:_cons}, lower(19) upper(22)}

{pstd}Label the estimate {cmd:prob_mean}{p_end}
{phang2}{cmd:. bayestest interval (prob_mean:{mpg:_cons}), lower(19) upper(22)}

{pstd}Test multiple hypotheses separately{p_end}
{phang2}{cmd:. bayestest interval ({mpg:_cons}, lower(19) upper(22))}
	{cmd:({c -(}var{c )-}, lower(24) upper(47))}

{pstd}Test multiple hypotheses jointly{p_end}
{phang2}{cmd:. bayestest interval (({mpg:_cons}, lower(19) upper(22))}
	{cmd:({c -(}var{c )-}, lower(24) upper(47)), joint)}

{pstd}Test a function of model parameters{p_end}
{phang2}{cmd:. bayestest interval (sd:sqrt({c -(}var{c )-})), lower(4.9) upper(6.9)}
		
    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. clear}{p_end}
{phang2}{cmd:. set seed 12345}{p_end}
{phang2}{cmd:. set obs 20}{p_end}
{phang2}{cmd:. generate double y = rpoisson(2)}{p_end}
{phang2}{cmd:. set seed 14}{p_end}
{phang2}{cmd:. bayesmh y, likelihood(dpoisson({mu}))}
	{cmd:prior({mu}, index(0.25,0.25,0.25,0.25)) initial({mu} 2)}

{pstd}Test point hypothesis for a discrete parameter{p_end}
{phang2}{cmd:. bayestest interval {mu}==1}{p_end}

{pstd}Test multiple point hypotheses separately{p_end}
{phang2}{cmd:. bayestest interval ({mu}==1) ({mu}==2) ({mu}==3)}
	{cmd:({mu}==4)}

{pstd}Test an open-interval hypothesis{p_end}
{phang2}{cmd:. bayestest interval {mu}, lower(2) upper(4)}

{pstd}Test a closed-interval hypothesis{p_end}
{phang2}{cmd:. bayestest interval {mu}, lower(2, inclusive) upper(4, inclusive)}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:bayestest interval} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 17 2: Scalars}{p_end}
{synopt:{cmd:r(skip)}}number of MCMC observations to skip in the
computation; every {cmd:r(skip)} observations are skipped{p_end}
{synopt:{cmd:r(corrlag)}}maximum autocorrelation lag{p_end}
{synopt:{cmd:r(corrtol)}}autocorrelation tolerance{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 17 2: Macros}{p_end}
{synopt:{cmd:r(expr_}{it:#}{cmd:)}}{it:#}th probability expression{p_end}
{synopt:{cmd:r(names)}}names of probability expressions{p_end}

{p2col 5 15 17 2: Matrices}{p_end}
{synopt:{cmd:r(summary)}}test results for parameters in {cmd:r(names)}{p_end}
{p2colreset}{...}
