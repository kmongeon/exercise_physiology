{smcl}
{* *! version 1.0.2  18mar2015}{...}
{viewerdialog "bayestest model" "dialog bayestest_model"}{...}
{vieweralsosee "[BAYES] bayestest model" "mansection BAYES bayestestmodel"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayesmh" "help bayesmh"}{...}
{vieweralsosee "[BAYES] bayesmh postestimation" "help bayesmh postestimation"}{...}
{vieweralsosee "[BAYES] bayesstats ic" "help bayesstats ic"}{...}
{vieweralsosee "[BAYES] bayesstats summary" "help bayesstats summary"}{...}
{vieweralsosee "[BAYES] bayestest interval" "help bayestest interval"}{...}
{viewerjumpto "Syntax" "bayestest model##syntax"}{...}
{viewerjumpto "Menu" "bayestest model##menu"}{...}
{viewerjumpto "Description" "bayestest model##description"}{...}
{viewerjumpto "Options" "bayestest model##options"}{...}
{viewerjumpto "Examples" "bayestest model##examples"}{...}
{viewerjumpto "Stored results" "bayestest model##results"}{...}
{title:Title}

{p2colset 5 32 34 2}{...}
{p2col :{manlink BAYES bayestest model} {hline 2}}Hypothesis testing using model posterior probabilities{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 11 2}
{opt bayestest} {cmd:model} [{it:namelist}] [{cmd:,} {it:options}]

{phang}
where {it:namelist} is a name, a list of names, {cmd:_all}, or {cmd:*}.
A name may be {cmd:.}, meaning the current (active) estimates.
{cmd:_all} and {cmd:*} mean the same thing.

{synoptset 20 tabbed}{...}
{marker options_table}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{opth prior(numlist)}}specify prior probabilities for tested
models; default is all models are equally likely{p_end}

{syntab:Advanced}
{synopt :{cmdab:marglm:ethod(}{it:{help bayestest model##method:method}}{cmd:)}}specify marginal-likelihood approximation method;
default is to use Laplace-Metropolis approximation, {cmd:lmetropolis}; rarely used{p_end}
{synoptline}

{synoptset 15}{...}
{marker method}{...}
{synopthdr:method}
{synoptline}
{synopt :{cmdab:lmet:ropolis}}Laplace-Metropolis approximation; default{p_end}
{synopt :{cmd:hmean}}harmonic-mean approximation{p_end}
{synoptline}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Bayesian analysis > Hypothesis testing using model posterior probabilities}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayestest model} computes posterior probabilities of Bayesian models fit
using the {cmd:bayesmh} command.  These posterior probabilities can be used to
test hypotheses about model parameters.  The command reports marginal
likelihoods, prior probabilities, and posterior probabilities for all tested
models.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opth prior(numlist)} specifies prior probabilities for models.  By default,
all models are assumed to be equally likely.  You may specify probabilities
for all tested models, in which case the probabilities must sum to one.
Alternatively, you may specify probabilities for all but the last model, in
which case the sum of the specified probabilities must be less than one, and
the probability for the last model is computed as one minus this sum.

{dlgtab:Advanced}

{phang}
{cmd:marglmethod(}{it:{help bayestest model##method:method}}{cmd:)} specifies
a method for approximating the marginal likelihood.  {it:method} is either
{cmd:lmetropolis}, the default, for Laplace-Metropolis approximation or
{cmd:hmean} for harmonic-mean approximation.  This option is rarely used.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse oxygen}{p_end}
{phang2}{cmd:. set seed 14}{p_end}
{phang2}{cmd:. bayesmh change c.age##i.group, likelihood(normal({c -(}var{c )-}))}
        {cmd:prior({change:}, flat) prior({c -(}var{c )-}, jeffreys)}
	{cmd:saving(full_simdata)}{p_end}
{phang2}{cmd:. estimates store full}

{phang2}{cmd:. set seed 14}{p_end}
{phang2}{cmd:. bayesmh change age i.group, likelihood(normal({c -(}var{c )-}))}
        {cmd:prior({change:}, flat) prior({c -(}var{c )-}, jeffreys)} 
        {cmd:saving(reduced_simdata)}{p_end}
{phang2}{cmd:. estimates store reduced}

{phang2}{cmd:. set seed 14}{p_end}
{phang2}{cmd:. bayesmh change, likelihood(normal({c -(}var{c )-}))}
	{cmd:prior({change:}, flat) prior({c -(}var{c )-}, jeffreys)}
        {cmd:saving(intonly_simdata)}{p_end}
{phang2}{cmd:. estimates store intonly}

{pstd}Obtain the probabilities associated with the models {bf:full},
{bf:reduced}, and {bf:intonly}{p_end}
{phang2}{cmd:. bayestest model full reduced intonly}

{pstd}Specify prior probabilities for each model{p_end}
{phang2}{cmd:. bayestest model full reduced intonly, prior(.5 .4 .1)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:bayestest model} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 17 2: Scalars}{p_end}
{synopt:{cmd:r(name)}}names of estimation results used{p_end}
{synopt:{cmd:r(marglmethod)}}method for approximating marginal likelihood:
{cmd:lmetropolis} or {cmd:hmean}{p_end}

{p2col 5 15 17 2: Matrices}{p_end}
{synopt:{cmd:r(test)}}test results for parameters in {cmd:r(names)}{p_end}
{p2colreset}
