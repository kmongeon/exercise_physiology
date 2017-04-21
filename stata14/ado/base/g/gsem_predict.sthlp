{smcl}
{* *! version 1.2.4  22jul2016}{...}
{viewerdialog predict "dialog gsem_p"}{...}
{vieweralsosee "[SEM] predict after gsem" "mansection SEM predict after gsem"}{...}
{vieweralsosee "[SEM] intro 7" "mansection SEM intro7"}{...}
{vieweralsosee "[SEM] methods and formulas for gsem" "mansection SEM methodsandformulasforgsem"}{...}
{findalias asgsemoirt}{...}
{findalias asgsemtirt}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] gsem" "help gsem_command"}{...}
{vieweralsosee "[SEM] gsem postestimation" "help gsem_postestimation"}{...}
{viewerjumpto "Syntax" "gsem_predict##syntax"}{...}
{viewerjumpto "Menu" "gsem_predict##menu"}{...}
{viewerjumpto "Description" "gsem_predict##description"}{...}
{viewerjumpto "Options" "gsem_predict##options"}{...}
{viewerjumpto "Remarks" "gsem_predict##remarks"}{...}
{viewerjumpto "Examples" "gsem_predict##examples"}{...}
{title:Title}

{p2colset 5 33 35 2}{...}
{p2col:{manlink SEM predict after gsem} {hline 2}}Generalized linear
predictions, etc.{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax for predict}

{pstd}
Syntax for predicting observed endogenous outcomes and other statistics

{p 8 16 2}
{cmd:predict} {dtype}
{it:newvarsspec}
{ifin} [{cmd:,}
{it:{help gsem_predict##statistic:statistic}}
{it:{help gsem_predict##options:options}}]

{pstd}
Syntax for obtaining estimated latent variables and their standard errors

{p 8 16 2}
{cmd:predict} {dtype}
{it:newvarsspec}
{ifin}{cmd:,}
{it:{help gsem_predict##lstatistic:lstatistic}}
[{it:{help gsem_predict##loptions:loptions}}]

{pstd}
Syntax for obtaining ML scores

{p 8 16 2}
{cmd:predict}
{dtype}
{it:newvarsspec}
{ifin}{cmd:,} {opt sc:ores}


{pstd}
{it:newvarsspec} is {it:stub}{cmd:*} or {it:{help newvarlist}}.

{phang}
The default is to predict observed endogenous variables with empirical
Bayes means predictions of the latent variables.

{marker statistic}{...}
{synoptset 22 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt :{opt mu}}expected value of {depvar}; the default{p_end}
{synopt :{opt pr}}probability (synonym for {cmd:mu} when mu is a
probability){p_end}
{synopt :{opt eta}}expected value of linear prediction of {depvar}{p_end}
{synopt :{opt den:sity}}density function at {depvar}{p_end}
{synopt :{opt dist:ribution}}distribution function at {depvar}{p_end}
{synopt :{opt surv:ival}}survivor function at {depvar}{p_end}
{synopt :{opt exp:ression}{cmd:(}{it:{help gsem_predict##exp:exp}{cmd:)}}}calculate prediction using {it:exp}{p_end}
{synoptline}

{marker options}{...}
{synoptset 22 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
{synopt :{opt cond:itional}{cmd:(}{it:{help meglm_postestimation##ctype:ctype}}{cmd:)}}compute {it:statistic} conditional on estimated latent variables; default is {cmd:conditional(ebmeans)}{p_end}
{synopt :{opt marginal}}compute {it:statistic} marginally with respect to the latent variables{p_end}
{synopt :{opt nooffset}}make calculation ignoring offset or exposure{p_end}
{p2coldent:+ {cmd:outcome(}{depvar} [{it:#}]{cmd:)}}specify observed
response variable (default all){p_end}

{syntab :Integration}
{synopt :{it:{help gsem_predict##int_options:int_options}}}integration
	options{p_end}
{synoptline}
{p 4 6 2}
+ {opt outcome(depvar #)} is allowed only if {it:depvar} has family
   {cmd:multinomial}, {cmd:ordinal}, or {cmd:bernoulli}.
   Predicting other generalized responses requires
   specifying only {opt outcome(depvar)}.{break}
{opt outcome(depvar #)} may also be specified as
   {cmd:outcome(}{it:#}.{it:depvar}{cmd:)}
   or {cmd:outcome(}{it:depvar} {cmd:#}{it:#}{cmd:)}.{break}
{cmd:outcome(}{it:depvar} {cmd:#3)} means the third outcome value.
   {cmd:outcome(}{it:depvar} {cmd:#3)} would mean the same as
   {cmd:outcome(}{it:depvar} {cmd:4)} if outcomes were 1, 3, and 4.

{marker ctype}{...}
{synoptset 22}{...}
{synopthdr :ctype}
{synoptline}
{synopt :{opt ebmean:s}}empirical Bayes means of latent variables; the default{p_end}
{synopt :{opt ebmode:s}}empirical Bayes modes of latent variables{p_end}
{synopt :{opt fixed:only}}prediction
	for the fixed portion of the model only{p_end}
{synoptline}

{marker lstatistic}{...}
{synoptset 22 tabbed}{...}
{synopthdr:lstatistic}
{synoptline}
{syntab:Main}
{synopt :{opt latent}}empirical Bayes prediction of all latent variables{p_end}
{synopt :{opth latent(varlist)}}empirical Bayes prediction of specified latent variables{p_end}
{synoptline}

{marker loptions}{...}
{synoptset 22 tabbed}{...}
{synopthdr:loptions}
{synoptline}
{syntab:Main}
{synopt :{opt ebmean:s}}empirical Bayes means of latent variables; the default{p_end}
{synopt :{opt ebmode:s}}empirical Bayes modes of latent variables{p_end}
{synopt :{cmd:se(}{it:stub}{cmd:*}{c |}{help varlist:{it:newvarlist}}{cmd:)}}standard errors of empirical Bayes estimates{p_end}

{syntab :Integration}
{synopt :{it:{help gsem_predict##int_options:int_options}}}integration
	options{p_end}
{synoptline}

{marker int_options}{...}
{synoptset 22}{...}
{synopthdr:int_options}
{synoptline}
{synopt :{opt intp:oints(#)}}use
	{it:#} quadrature points to compute marginal predictions and
	empirical Bayes means{p_end}
{synopt :{opt iter:ate(#)}}set
	maximum number of iterations in computing statistics involving
	empirical Bayes estimators{p_end}
{synopt :{opt tol:erance(#)}}set convergence tolerance for computing
	statistics involving empirical Bayes estimators{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > SEM (structural equation modeling) > Predictions}


{marker description}{...}
{title:Description}

{pstd}
{cmd:predict} is a standard postestimation command of Stata.
This entry concerns use of {cmd:predict} after {cmd:gsem}.
See {helpb sem_predict:[SEM] predict after sem} if you fit your model with
{cmd:sem}.

{pstd}
{cmd:predict} after {cmd:gsem} creates new variables containing
observation-by-observation values of estimated observed response variables,
linear predictions of observed response variables, or endogenous or
exogenous latent variables.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{cmd:mu}, the default, calculates the expected value of the outcomes.

{phang}
{cmd:pr} calculates predicted probabilities and is a synonym for {cmd:mu}.
This option is available only for multinomial, ordinal, and Bernoulli
outcomes.

{phang} 
{cmd:eta} calculates the fitted linear prediction.

{phang} 
{cmd:density} calculates the density function.
This prediction is computed using the current values of the observed
variables, including the dependent variable.

{phang} 
{cmd:distribution} calculates the distribution function.
This prediction is computed using the current values of the observed
variables, including the dependent variable.
This option is not allowed for multinomial outcomes.

{phang} 
{cmd:survival} calculates the survivor function.
This prediction is computed using the current values of the observed
variables, including the dependent variable.
This option is only allowed for exponential, gamma, loglogistic,
lognormal, and Weibull outcomes.

{marker exp}{...}
{phang} 
{opt expression(exp)}
    specifies the prediction as an expression.  {it:exp} is any valid Stata
    expression, but the expression must contain a call to one of the two
    special functions unique to this option:

{p 8 11 6}
1. {opt mu(outcome)}: The {opt mu()} function specifies the
calculation of the mean prediction for {it:outcome}.
If {opt mu()} is specified without {it:outcome}, the mean prediction for
the first outcome is implied.

{p 11 11 6}
{opt pr(outcome)}: The {opt pr()} function is a synonym for
{opt mu(outcome)} when {it:outcome} identifies a multinomial, ordinal, or
Bernoulli outcome.

{p 8 11 6}
2. {opt eta(outcome)}: The {cmd:eta()} function specifies the
calculation of the linear prediction for {it:outcome}.
If {cmd:eta()} is specified without {it:outcome}, the linear predictor for
the first outcome is implied.

{p 11 11 6}
When you specify {it:exp}, both of these functions may be used repeatedly,
in combination, and in combination with other Stata functions and expressions.

{phang}
{opt conditional(ctype)} and {cmd:marginal} specify how latent variables are
handled in computing {it:statistic}.

{phang2}
{cmd:conditional()} specifies that {it:statistic} will be computed conditional
on specified or estimated latent variables.

{phang3}
{cmd:conditional(ebmeans)}, the default, specifies that empirical Bayes
means be used as the estimates of the latent variables.
These estimates are also known as posterior mean estimates of the latent
variables.

{phang3}
{cmd:conditional(ebmodes)} specifies that empirical Bayes modes be used as the
estimates of the latent variables.
These estimates are also known as posterior mode estimates of the latent
variables.

{phang3}
{cmd:conditional(fixedonly)} specifies that all latent variables be set
to zero, equivalent to using only the fixed portion of the model.

{phang2}
{cmd:marginal} specifies that the predicted {it:statistic} be computed
marginally with respect to the latent variables, which means that
{it:statistic} is calculated by integrating the prediction function with
respect to all the latent variables over their entire support.

{pmore2}
Although this is not the default, marginal predictions are often very useful
in applied analysis.
They produce what are commonly called population-averaged estimates.
They are also required by {helpb margins}.

{phang}
{cmd:nooffset}
is relevant only if option {cmd:offset()} or {cmd:exposure()} was
specified at estimation time.
{cmd:nooffset} specifies that {cmd:offset()} or {cmd:exposure()} 
be ignored, which produces predictions as if all subjects had equal
exposure.

{phang}
{cmd:outcome(}{depvar} [{it:#}]{cmd:)} specifies that predictions for
{it:depvar} be calculated.
Predictions for all observed response variables are computed by default.
If {it:depvar} is a multinomial or an ordinal outcome, then {it:#}
optionally specifies which outcome level to predict.

{phang}
{cmd:latent} and {opth latent(varlist)} specify that the latent
variables be estimated using empirical Bayes predictions.
By default or if the {opt ebmeans} option is specified, empirical Bayes means
are computed.
With the {opt ebmodes} option, empirical Bayes modes are computed.

{pmore}
{cmd:latent} requests empirical Bayes estimates for all latent variables.

{pmore}
{opt latent(varlist)} requests empirical Bayes estimates for the
specified latent variables.

{phang}
{cmd:ebmeans} specifies that empirical Bayes means be used to
predict the latent variables.

{phang}
{cmd:ebmodes} specifies that empirical Bayes modes be used to
predict the latent variables.

{phang}
{cmd:se(}{it:stub}{cmd:*}|{it:{help varlist:newvarlist}}{cmd:)} calculates
standard errors of the empirical Bayes estimators and stores the result in
{it:newvarlist}.  This option requires the {opt latent} or
{opt latent()} option.

{phang}
{opt scores} calculates the scores for each coefficient in {cmd:e(b)}.
This option requires a new variable list of length equal to 
the number of columns in {cmd:e(b)}.  Otherwise, use {it:stub}{cmd:*}
to have {cmd:predict} generate enumerated variables with
prefix {it:stub}.

{dlgtab:Integration}

{phang}
{opt intpoints(#)} specifies the number of quadrature points used to
compute marginal predictions and the empirical Bayes means;
the default is the value from estimation.

{phang}
{opt iterate(#)} specifies the maximum number of iterations when computing
statistics involving empirical Bayes estimators; the default is the value from
estimation.

{phang}
{opt tolerance(#)} specifies convergence tolerance when computing
statistics involving empirical Bayes estimators; the default is the value
from estimation.


{marker remarks}{...}
{title:Remarks}

{pstd}
Out-of-sample prediction is allowed for all {cmd:predict} options except
{cmd:scores}.

{pstd}
{cmd:predict} has two ways of specifying the names of the variables to be
created:

{phang3}
{cmd:. predict} {it:stub}{cmd:*,} ...

{pstd}
or

{phang3}
{cmd:. predict} {it:firstname secondname} ...{cmd:,} ...

{pstd}
The first creates variables named {it:stub}{cmd:1}, {it:stub}{cmd:2}, ....
The second creates variables with names that you specify.  We strongly
recommend using the {it:stub}{cmd:*} syntax when creating multiple variables
because you have no way of knowing the order in which to specify the
individual variable names to correspond to the order in which {cmd:predict}
will make the calculations.  If you use {it:stub}{cmd:*}, the variables will
be labeled and you can rename them.

{pstd}
The second syntax is useful when you create one variable and specify
{cmd:outcome()}, {cmd:expression()}, or {cmd:latent()}.

{pstd}
See {manlink SEM intro 7}, {findalias gsemoirt}, and {findalias gsemtirt}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse gsem_cfa}{p_end}
{phang2}{cmd:. gsem (MathAb -> (q1-q8)@b), logit var(MathAb@1)}{p_end}

{pstd}Predicted probability of success for all observed response variables{p_end}
{phang2}{cmd:. predict pr*, pr}{p_end}

{pstd}Empirical Bayes mean prediction of the latent variable{p_end}
{phang2}{cmd:. predict ability, latent(MathAb)}{p_end}
