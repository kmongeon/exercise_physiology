{smcl}
{* *! version 1.0.3  30nov2015}{...}
{viewerdialog "bayesstats ic" "dialog bayesstats_ic"}{...}
{vieweralsosee "[BAYES] bayesstats ic" "mansection BAYES bayesstatsic"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayesmh" "help bayesmh"}{...}
{vieweralsosee "[BAYES] bayesmh postestimation" "help bayesmh postestimation"}{...}
{vieweralsosee "[BAYES] bayestest model" "help bayestest model"}{...}
{vieweralsosee "[R] estimates" "help estimates"}{...}
{viewerjumpto "Syntax" "bayesstats_ic##syntax"}{...}
{viewerjumpto "Menu" "bayesstats_ic##menu"}{...}
{viewerjumpto "Description" "bayesstats_ic##description"}{...}
{viewerjumpto "Option" "bayesstats_ic##options"}{...}
{viewerjumpto "Examples" "bayesstats_ic##examples"}{...}
{viewerjumpto "Stored results" "bayesstats_ic##results"}{...}
{title:Title}

{p2colset 5 30 32 2}{...}
{p2col :{manlink BAYES bayesstats ic} {hline 2}}Bayesian information criteria and Bayes factors{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{opt bayesstats ic} 
[{it:namelist}]
[{cmd:,} {it:options}]

{phang}
where {it:namelist} is a name, a list of names, {cmd:_all}, or {cmd:*}.  A
name may be {cmd:.}, meaning the current (active) estimates.  {cmd:_all} and
{cmd:*} mean the same thing.

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{opt basem:odel(name)}}specify a base or reference model; default is
the first-listed model{p_end}
{synopt :{opt bayesf:actor}}report BFs instead of the default log BFs{p_end}
{synopt :{opt diconly}}report only DIC{p_end}

{syntab:Advanced}
{synopt :{opth marglm:ethod(bayesstats_ic##method:method)}}specify
marginal-likelihood approximation method; default is to use Laplace-Metropolis
approximation, {opt lmetropolis}; rarely used{p_end}
{synoptline}

{marker method}{...}
{synoptset 14}{...}
{synopthdr:method}
{synoptline}
{synopt :{opt lmet:ropolis}}Laplace-Metropolis approximation; the default{p_end}
{synopt :{opt hmean}}harmonic-mean approximation{p_end}
{synoptline}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Bayesian analysis > Information criteria}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayesstats ic} calculates and reports model-selection statistics,
including the deviance information criterion (DIC), log marginal-likelihood,
and Bayes factors (BFs), using current estimation results from the
{cmd:bayesmh} command.  BFs can be displayed in the original metric or in the
log metric.  The command also provides two different methods to approximate
marginal likelihood.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt basemodel(name)} specifies the name of the model to be used as a base or
reference model when computing BFs.  By default, the first-listed model is
used as a base model.

{phang}
{opt bayesfactor} specifies that BFs be reported instead of the default log
BFs.

{phang}
{opt diconly} specifies that only DIC be reported in the table and that the log 
marginal likelihood and Bayes factors be omitted from the table. Options 
{opt basemodel()}, {opt basefactor}, and {opt marglmethod()} have no effect when
the {opt diconly} option is specified.

{dlgtab:Advanced}

{marker marglmethod}{...}
{phang}
{cmd:marglmethod(}{it:{help bayesstats_ic##method:method}}{cmd:)} specifies a
method for approximating the marginal likelihood.  {it:method} is either
{cmdab:lmetropolis}, the default, for Laplace-Metropolis approximation or
{cmd:hmean} for harmonic-mean approximation.  This option is rarely used.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse oxygen}
	
{pstd}Information criteria for the most recent model{p_end}
{phang2}{cmd:. set seed 14}{p_end}
{phang2}{cmd:. bayesmh change age group, likelihood(normal({c -(}var{c )-}))}
        {cmd:prior({change:}, flat) prior({c -(}var{c )-}, jeffreys)}{p_end}
{phang2}{cmd:. bayesmh, saving(reduced_simdata)}{p_end}
{phang2}{cmd:. estimates store reduced}{p_end}
{phang2}{cmd:. bayesstats ic}

{pstd}Information criteria for models {bf:full} and {bf:reduced}{p_end}
{phang2}{cmd:. set seed 14}{p_end}
{phang2}{cmd:. bayesmh change c.age##i.group, likelihood(normal({c -(}var{c )-}))}
        {cmd:prior({change:}, flat) prior({c -(}var{c )-}, jeffreys)}
        {cmd:saving(full_simdata)}{p_end}
{phang2}{cmd:. estimates store full}{p_end}
{phang2}{cmd:. bayesstats ic full reduced}
	
{pstd}Information criteria with {cmd:reduced} as base model for the Bayes factor{p_end}
{phang2}{cmd:. bayesstats ic full reduced, basemodel(reduced)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:bayesstats} {cmd:ic} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(bayesfactor)}}{cmd:1} if {cmd:bayesfactor} is specified; {cmd:0} otherwise{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(names)}}names of estimation results used{p_end}
{synopt:{cmd:r(basemodel)}}name of the base or reference model{p_end}
{synopt:{cmd:r(marglmethod)}}method for approximating marginal likelihood: {cmd:lmetropolis} or {cmd:hmean}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(ic)}}matrix reporting {cmd:DIC}, {cmd:log(ML)}, and {cmd:log(BF)} or {cmd:BF} if {cmd:bayesfactor} is used{p_end}
{p2colreset}{...}
