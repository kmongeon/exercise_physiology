{smcl}
{* *! version 1.1.5  22jan2016}{...}
{viewerdialog predict "dialog meqrpoisson_p"}{...}
{viewerdialog estat "dialog meqrpoisson_estat"}{...}
{vieweralsosee "[ME] meqrpoisson postestimation" "mansection ME meqrpoissonpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ME] meqrpoisson" "help meqrpoisson"}{...}
{viewerjumpto "Postestimation commands" "meqrpoisson postestimation##description"}{...}
{viewerjumpto "predict" "meqrpoisson postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "meqrpoisson postestimation##syntax_margins"}{...}
{viewerjumpto "estat" "meqrpoisson postestimation##syntax_estat"}{...}
{viewerjumpto "Examples" "meqrpoisson postestimation##examples"}{...}
{viewerjumpto "Stored results" "meqrpoisson postestimation##results"}{...}
{viewerjumpto "Reference" "meqrpoisson postestimation##reference"}{...}
{title:Title}

{p2colset 5 40 42 2}{...}
{p2col :{manlink ME meqrpoisson postestimation} {hline 2}}Postestimation tools for
meqrpoisson{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after
{cmd:meqrpoisson}:

{synoptset 18}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb meqrpoisson postestimation##estatgroup:estat group}}summarize
the composition of the nested groups{p_end}
{synopt :{helpb meqrpoisson postestimation##estatcov:estat recovariance}}display
  the estimated random-effects covariance matrix (or matrices){p_end}
{synoptline}
{p2colreset}{...}

{pstd}
The following standard postestimation commands are also available:

{synoptset 18}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_hausman
INCLUDE help post_lincom
INCLUDE help post_lrtest
{synopt:{helpb meqrpoisson_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb meqrpoisson postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 4 4 2}
Syntax for obtaining estimated random effects and their standard errors

{p 8 16 2}
{cmd:predict} {dtype}
{it:{help meqrpoisson_postestimation##newvarsspec:newvarsspec}}
{ifin}
{cmd:,}
{opt ref:fects}
[{opth reses:(meqrpoisson_postestimation##newvarsspec:newvarsspec)}
{opt relev:el(levelvar)}]


{p 4 4 2}
Syntax for obtaining other predictions

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} 
[{cmd:,} {it:statistic}
{opt nooff:set}
{opt fixed:only}]


{marker newvarsspec}{...}
{phang}
{it:newvarsspec} is {it:stub}{cmd:*} or {it:{help newvarlist}}.

{synoptset 13 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt mu}}predicted mean; the default{p_end}
{synopt :{cmd:xb}}linear predictor for the fixed portion of the model only{p_end}
{synopt :{cmd:stdp}}standard error of the fixed-portion linear prediction{p_end}
{synopt :{opt pea:rson}}Pearson residuals{p_end}
{synopt :{opt dev:iance}}deviance residuals{p_end}
{synopt :{opt ans:combe}}Anscombe residuals{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
mean responses; linear predictions; standard errors;
and Pearson, deviance, and Anscombe residuals.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{marker reffects}{...}
{phang}
{opt reffects} calculates posterior modal estimates of the 
random effects.  By default, estimates for all random effects in the model 
are calculated.  However, if the {opt relevel(levelvar)} option is specified,
then estimates for only level {it:levelvar} in the model are calculated.  For
example, if {cmd:class}es are nested within {cmd:school}s, then typing

{p 12 16 2}{cmd:. predict b*, reffects relevel(school)}{p_end}

{pmore}
would yield random-effects estimates at the school level.  You must
specify {it:q} new variables, where {it:q} is the number of random-effects
terms in the model (or level).  However, it is much easier to just specify
{it:stub}{cmd:*} and let Stata name the variables
{it:stub}{cmd:1}, {it:stub}{cmd:2}, ..., {it:stubq} for you.

{phang}
{opth reses:(meqrpoisson_postestimation##newvarsspec:newvarsspec)}
calculates standard errors for the random-effects estimates.
By default, standard errors for all random effects in the model are
calculated.  However, if the {opt relevel(levelvar)} option is specified, then
standard errors for only level {it:levelvar} in the model are calculated; see
the {helpb meqrpoisson postestimation##reffects:reffects} option.

{pmore}
You must specify {it:q} new variables, where {it:q} is the number of
random-effects terms in the model (or level).  However, it is much easier to
just specify {it:stub}{cmd:*} and let Stata name the variables
{it:stub}{cmd:1}, {it:stub}{cmd:2}, ..., {it:stubq} for you.  The new
variables will have the same storage type as the corresponding random-effects
variables.

{pmore}
The {cmd:reffects} and {cmd:reses()} options often generate multiple new 
variables at once.  When this occurs, the random effects (or standard 
errors) contained in the
generated variables correspond to the order in which the variance components
are listed in the output of {cmd:meqrpoisson}.  Still, examining the variable
labels of the generated variables (with the {cmd:describe} command, for
instance) can be useful in deciphering which variables correspond to which
terms in the model.

{phang}
{opt relevel(levelvar)} specifies the level in the model at which
predictions for random effects and their standard errors are
to be obtained.  {it:levelvar} is the name of the model level and is either
the name of the variable describing the grouping at that level or is {cmd:_all},
a special designation for a group comprising all the estimation data.

{marker mu}{...}
{phang} 
{opt mu}, the default, calculates the predicted mean, that is, the predicted count.
By default, this is based on a linear predictor that
includes both the fixed effects and the random effects, and the predicted
mean is conditional on the values of the random effects.  Use the
{cmd:fixedonly} option (see {help meqrpoisson postestimation##fixedonly:below})
if you want predictions that include only the fixed portion of the model, that
is, if you want random effects set to 0.

{phang}
{opt xb} calculates the linear prediction based on the estimated fixed effects
(coefficients) in the model.  This is equivalent to fixing all random effects
in the model to their theoretical (prior) mean value of 0.

{phang}
{opt stdp} calculates the standard error of the fixed-effects linear
predictor.

{phang}
{opt pearson} calculates Pearson residuals.  Pearson residuals large in
absolute value may indicate a lack of fit.  By default, residuals include both
the fixed portion and the random portion of the model.  The {opt fixedonly}
option modifies the calculation to include the fixed portion only.

{phang}
{opt deviance} calculates deviance residuals.  Deviance residuals are
recommended by
{help meqrpoisson postestimation##MN1989:McCullagh and Nelder (1989)}
as having the best properties for
examining the goodness of fit of a GLM.  They are approximately normally
distributed if the model is correctly specified.  They may be plotted against
the fitted values or against a covariate to inspect the model's fit.  By
default, residuals include both the fixed portion and the random portion of the
model.  The {opt fixedonly} option modifies the calculation to include the
fixed portion only.

{phang}
{opt anscombe} calculates Anscombe residuals, which are designed to closely
follow a normal distribution.  By default, residuals include both the fixed
portion and the random portion of the model.  The {opt fixedonly} option
modifies the calculation to include the fixed portion only.

{phang}
{opt nooffset} is relevant only if you specified 
{cmd:offset(}{help varname:{it:varname_o}}{cmd:)} or 
{cmd:exposure(}{it:varname_e}{cmd:)} 
for {cmd:meqrpoisson}.  It modifies the calculations made by {cmd:predict} so 
that they ignore the offset/exposure variable; the linear prediction is treated
as xb rather than xb + offset or xb + exposure, whichever is relevant.

{marker fixedonly}{...}
{phang}
{opt fixedonly} modifies predictions to include only the fixed portion 
of the model, equivalent to setting all random effects equal to 
0;  see the {helpb meqrpoisson postestimation##mu:mu} option.


INCLUDE help syntax_margins1

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{cmd:xb}}linear predictor for the fixed portion of the model only; the default{p_end}
{synopt :{opt ref:fects}}not allowed with {cmd:margins}{p_end}
{synopt :{cmd:mu}}not allowed with {cmd:margins}{p_end}
{synopt :{cmd:stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt pea:rson}}not allowed with {cmd:margins}{p_end}
{synopt :{opt dev:iance}}not allowed with {cmd:margins}{p_end}
{synopt :{opt ans:combe}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for
linear predictions.


{marker syntax_estat}{...}
{marker estatgroup}{marker estatcov}{...}
{title:Syntax for estat}

{pstd}
Summarize the composition of the nested groups

{p 8 14 2}
{cmd:estat} {opt gr:oup} 


{pstd}
Display the estimated random-effects covariance matrix (or matrices)

{p 8 14 2}
{cmd:estat} {opt recov:ariance} [{cmd:,} {opt relev:el(levelvar)}
          {opt corr:elation} {help matlist:{it:matlist_options}}]


INCLUDE help menu_estat


{marker des_estat}{...}
{title:Description for estat}

{pstd}
{cmd:estat group} reports number of groups and minimum, average, and maximum
group sizes for each level of the model.  Model levels are identified by
the corresponding group variable in the data.  Because groups are treated
as nested, the information in this summary may differ from what you would
get if you used the {cmd:tabulate} command on each group variable individually.

{pstd}
{cmd:estat recovariance} displays the estimated variance-covariance matrix 
of the random effects for each level of the model.  Random effects can be
either random intercepts, in which case the corresponding rows and columns of
the matrix are labeled as {cmd:_cons}, or random coefficients, in which case
the label is the name of the associated variable in the data.


{marker options_estat_recov}{...}
{title:Options for estat recovariance}

{phang}
{opt relevel(levelvar)} specifies the level in the model for which the
random-effects covariance matrix is to be displayed and returned in
{cmd:r(cov)}.  By default, the covariance matrices for all levels in the model
are displayed.  {it:levelvar} is the name of the model level and is either the
name of the variable describing the grouping at that level or is {cmd:_all}, a
special designation for a group comprising all the estimation data.

{phang}
{opt correlation} displays the covariance matrix as a correlation matrix and
returns the correlation matrix in {cmd:r(corr)}.

{phang}
{it:matlist_options} are style and formatting options that control how the
matrix (or matrices) is displayed; see {helpb matlist:[P] matlist} for
a list of options that are available.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse epilepsy}{p_end}
{phang2}{cmd:. meqrpoisson seizures treat lbas lbas_trt lage visit || subject: visit, cov(unstructured) intpoints(9)}{p_end}

{pstd}Random-effects covariance matrix for level {cmd:subject}{p_end}
{phang2}{cmd:. estat recovariance}{p_end}

{pstd}Random-effects correlation matrix for level {cmd:subject}{p_end}
{phang2}{cmd:. estat recovariance, correlation}{p_end}

{pstd}Predictions of random effects{p_end}
{phang2}{cmd:. predict re_visit re_cons, reffects}{p_end}

{pstd}Predicted counts, incorporating random effects{p_end}
{phang2}{cmd:. predict n}{p_end}

{pstd}Predicted counts, setting all random effects to zero{p_end}
{phang2}{cmd:. predict n_fixed, fixedonly}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat recovariance} stores the following in {cmd:r()}:

{synoptset 13 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(relevels)}}number of levels{p_end}
{p2colreset}{...}

{synoptset 13 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(Cov}{it:#}{cmd:)}}level-{it:#} random-effects covariance matrix{p_end}
{synopt:{cmd:r(Corr}{it:#}{cmd:)}}level-{it:#} random-effects correlation matrix
	(if option {cmd:correlation} was specified){p_end}
{p2colreset}{...}

{pstd}
For a {it:G}-level nested model, {it:#} can be any integer between 2 and {it:G}.
{p_end}


{marker reference}{...}
{title:Reference}

{marker MN1989}{...}
{phang}
McCullagh, P., and J. A. Nelder. 1989.
{browse "http://www.stata.com/bookstore/glm.html":{it:Generalized Linear Models}. 2nd ed.}
London: Chapman & Hall/CRC.
{p_end}
