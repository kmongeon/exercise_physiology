{smcl}
{* *! version 1.2.2  04mar2015}{...}
{viewerdialog predict "dialog slogit_p"}{...}
{vieweralsosee "[R] slogit postestimation" "mansection R slogitpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] slogit" "help slogit"}{...}
{viewerjumpto "Postestimation commands" "slogit postestimation##description"}{...}
{viewerjumpto "predict" "slogit postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "slogit postestimation##syntax_margins"}{...}
{viewerjumpto "Example" "slogit postestimation##example"}{...}
{title:Title}

{p2colset 5 34 36 2}{...}
{p2col:{manlink R slogit postestimation} {hline 2}}Postestimation tools for slogit{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {opt slogit}:

{synoptset 17 tabbed}{...}
{p2coldent:Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_svy_estat
INCLUDE help post_estimates
INCLUDE help post_hausman_star
INCLUDE help post_lincom
INCLUDE help post_lrtest_star
{synopt:{helpb slogit_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt:{helpb slogit_postestimation##syntax_predict:predict}}predicted
    probabilities, estimated index and its approximate standard error{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_suest
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:hausman} and {cmd:lrtest} are not appropriate with {cmd:svy} estimation
results.{p_end}


{marker syntax_predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict}
{dtype}
{c -(}{it:stub}{cmd:*} | {newvar} | {it:{help newvarlist}}{c )-}
{ifin}
[{cmd:,} {it:statistic} {opt o:utcome(outcome)}]

{p 8 16 2}
{cmd:predict}
{dtype}
{c -(}{it:stub}{cmd:*} | {it:{help newvarlist}}{c )-}
{ifin}
{cmd:,} {opt sc:ores}

{marker statistic}{...}
{synoptset 17 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt:{opt p:r}}probability of one of or all the dependent variable outcomes;
the default{p_end}
{synopt:{opt xb}}index for the kth outcome{p_end}
{synopt:{opt stdp}}standard error of the index for the kth outcome{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
If you do not specify {cmd:outcome()}, {cmd:pr} (with one new variable
specified), {cmd:xb}, and {cmd:stdp} assume {cmd:outcome(#1)}.{p_end}
{p 4 6 2}
You specify one or k new variables with {cmd:pr}, where k is the number
of outcomes.{p_end}
{p 4 6 2}
You specify one new variable with {cmd:xb} and {cmd:stdp}.{p_end}
INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
probabilities, indexes for the kth outcome, and standard errors.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt pr}, the default, calculates the probability of each of the categories of
the dependent variable or the probability of the level specified in
{opt outcome()}.  If you specify the {opt outcome(outcome)} option, you need to
specify only one new variable; otherwise, you must specify a new variable for
each category of the dependent variable.

{phang}
{opt xb} calculates the index for outcome level k and dimension d.  It returns
a vector of zeros if k = {cmd:e(i_base)}.  A synonym for {opt xb} is
{opt index}.  If {opt outcome()} is not specified, {cmd:outcome(#1)} is
assumed.

{phang}
{opt stdp} calculates the standard error of the index.
A synonym for {opt stdp} is {opt seindex}.
If {opt outcome()} is not specified, {cmd:outcome(#1)} is assumed.

{phang}
{opt outcome(outcome)} specifies the outcome for which the statistic is to be
calculated.  {opt equation()} is a synonym for {opt outcome()}: it does not
matter which you use.  {opt outcome()} or {opt equation()} can be specified
using 

{pin2}
{cmd:#1}, {cmd:#2}, ..., where {cmd:#1} means the first category of
the dependent variable, {cmd:#2} means the second category, etc.; 

{pin2}
the values of the dependent variable; or 

{pin2}
the value labels of the dependent variable if they exist.

{phang}
{opt scores} calculates the equation-level score variables.  For models with d
dimensions and m levels, d + (d + 1)(m - 1) new variables are created. 

{pmore}
	The first d new variables will contain the scores for the d regression equations.

{pmore}
	The next d(m - 1) new variables will contain the scores for the scale parameters.

{pmore}
	The last m - 1 new variables will contain scores for the intercepts.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :default}probabilities for each outcome{p_end}
{synopt:{opt p:r}}probability of one of or all the dependent variable outcomes{p_end}
{synopt:{opt xb}}index for the kth outcome{p_end}
{synopt:{opt stdp}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt pr} and {opt xb} default to the first outcome.
{p_end}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for probabilities and indexes for
the kth outcome.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sysdsn1}{p_end}

{pstd}Fit stereotype logistic regression model{p_end}
{phang2}{cmd:. slogit insure age male nonwhite i.site, dim(1) base(1)}
{p_end}

{pstd}Estimate group probabilities{p_end}
{phang2}{cmd:. predict pIndemnity pPrepaid pUninsure}{p_end}
