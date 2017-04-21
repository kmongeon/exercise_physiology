{smcl}
{* *! version 1.2.2  04mar2015}{...}
{viewerdialog predict "dialog ologit_p"}{...}
{vieweralsosee "[R] ologit postestimation" "mansection R ologitpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ologit" "help ologit"}{...}
{viewerjumpto "Postestimation commands" "ologit postestimation##description"}{...}
{viewerjumpto "predict" "ologit postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "ologit postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "ologit postestimation##examples"}{...}
{title:Title}

{p2colset 5 34 36 2}{...}
{p2col :{manlink R ologit postestimation} {hline 2}}Postestimation tools for
ologit{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {opt ologit}:

{synoptset 17 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_svy_estat
INCLUDE help post_estimates
INCLUDE help post_forecast_star
INCLUDE help post_hausman_star
INCLUDE help post_lincom
INCLUDE help post_linktest
INCLUDE help post_lrtest_star
{synopt:{helpb ologit_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb ologit postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_suest
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:forecast}, {cmd:hausman}, and {cmd:lrtest} are not appropriate with
{cmd:svy} estimation results.  {cmd:forecast} is also not appropriate with
{cmd:mi} estimation results.{p_end}


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict}
{dtype}
{c -(}{it:stub}{cmd:*} | {newvar} | {it:{help newvarlist}}{c )-}
{ifin}
[{cmd:,} {it:statistic}
{opt o:utcome(outcome)} {opt nooff:set}]

{p 8 16 2}
{cmd:predict}
{dtype}
{c -(}{it:stub}{cmd:*} | {it:{help newvarlist}}{c )-}
{ifin}
{cmd:,}
{opt sc:ores}

{synoptset 17 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt p:r}}predicted probabilities; the default{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
If you do not specify {cmd:outcome()}, {cmd:pr} (with one new variable
specified) assumes {cmd:outcome(#1)}.{p_end}
{p 4 6 2}
You specify one or k new variables with {cmd:pr}, where {it:k} is the number
of outcomes.{p_end}
{p 4 6 2}
You specify one new variable with {cmd:xb} and {cmd:stdp}.{p_end}
INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
probabilities, linear predictions, and standard errors.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt pr}, the default, calculates the predicted probabilities.
If you do not also specify the {opt outcome()} option, you specify
k new variables, where k is the number of categories of the
dependent variable.  Say that you fit a model by typing
{cmd:ologit result x1 x2}, and {opt result} takes on three values.
Then you could type {cmd:predict p1 p2 p3} to obtain all three predicted
probabilities.  If you specify the {opt outcome()} option, you must specify
one new variable.  Say that {opt result} takes on the values 1, 2, and 3.
Typing {cmd:predict p1, outcome(1)} would produce the same {opt p1}.

{phang}
{opt xb} calculates the linear prediction.  You specify one new
variable, for example, {cmd:predict linear, xb}.  The linear prediction is
defined, ignoring the contribution of the estimated cutpoints.

{phang}
{opt stdp} calculates the standard error of the linear prediction.  You
specify one new variable, for example, {cmd:predict se, stdp}.

{phang}
{opt outcome(outcome)} specifies for which outcome the predicted probabilities
are to be calculated.  {opt outcome()} should contain either one value of
the dependent variable or one of {opt #1}, {opt #2}, {it:...}, with {opt #1}
meaning the first category of the dependent variable, {opt #2} meaning the
second category, etc.

{phang}
{opt nooffset} is relevant only if you specified {opth offset(varname)} for
{opt ologit}.  It modifies the calculations made by {opt predict} so that they
ignore the offset variable; the linear prediction is treated as xb rather than
as xb + offset.

{phang}
{opt scores} calculates equation-level score variables.  The number of score
variables created will equal the number of outcomes in the model.  If the
number of outcomes in the model was k, then

{pmore}
The first new variable will contain the derivative of the log likelihood with
respect to the regression equation.

{pmore}
The other new variables will contain the derivative of the log likelihood with
respect to the cutpoints.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :default}probabilities for each outcome{p_end}
{synopt :{opt p:r}}probability for a specified outcome{p_end}
{synopt :{cmd:xb}}linear prediction for a specified outcome{p_end}
{synopt :{cmd:stdp}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt pr} defaults to the first outcome.
{p_end}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for probabilities and linear
predictions.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse fullauto}{p_end}
{phang2}{cmd:. ologit rep77 i.foreign length mpg}{p_end}

{pstd}Predicted probabilities for each of the five outcomes{p_end}
{phang2}{cmd:. predict poor fair avg good exc}{p_end}

{pstd}Average marginal effects on the probability of an excellent repair record
{p_end}
{phang2}{cmd:. margins, dydx(*) predict(outcome(5))}

{pstd}Report information criteria{p_end}
{phang2}{cmd:. estat ic}{p_end}