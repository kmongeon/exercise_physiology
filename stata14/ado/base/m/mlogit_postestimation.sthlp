{smcl}
{* *! version 1.2.3  16sep2015}{...}
{viewerdialog predict "dialog mlogit_p"}{...}
{vieweralsosee "[R] mlogit postestimation" "mansection R mlogitpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] mlogit" "help mlogit"}{...}
{viewerjumpto "Postestimation commands" "mlogit postestimation##description"}{...}
{viewerjumpto "predict" "mlogit postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "mlogit postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "mlogit postestimation##examples"}{...}
{title:Title}

{p2colset 5 34 36 2}{...}
{p2col :{manlink R mlogit postestimation} {hline 2}}Postestimation tools for mlogit{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {opt mlogit}:

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
INCLUDE help post_lrtest_star
{synopt:{helpb mlogit_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb mlogit postestimation##predict:predict}}predictions, residuals,
influence statistics, and other diagnostic measures{p_end}
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
{c -(}{it:stub}{cmd:*} | {it:{help newvar}} | {it:{help newvarlist}}{c )-}
{ifin}
[{cmd:,} {it:statistic} {opt o:utcome(outcome)}]

{p 8 16 2}
{cmd:predict}
{dtype}
{c -(}{it:stub}{cmd:*} | {it:{help newvarlist}}{c )-}
{ifin}
{cmd:,} {opt sc:ores}

{synoptset 17 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt p:r}}predicted probabilities; the default{p_end}
{synopt :{cmd:xb}}linear prediction{p_end}
{synopt :{cmd:stdp}}standard error of the linear prediction{p_end}
{synopt :{cmd:stddp}}standard error of the difference in two linear
predictions{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
If you do not specify {cmd:outcome()}, {cmd:pr} (with one new variable
specified), {cmd:xb}, and {cmd:stdp} assume {cmd:outcome(#1)}.  You must
specify {cmd:outcome()} with the {cmd:stddp} option.{p_end}
{p 4 6 2}
You specify one or k new variables with {cmd:pr}, where {it:k} is the number
of outcomes.{p_end}
{p 4 6 2}
You specify one new variable with {cmd:xb}, {cmd:stdp}, and {cmd:stddp}.{p_end}
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
{cmd:mlogit result x1 x2}, and {opt result} takes on three values.
Then you could type {cmd:predict p1 p2 p3} to obtain all three predicted
probabilities.  If you specify the {opt outcome()} option, you must specify
one new variable.  Say that {opt result} takes on the values 1, 2, and 3.
Typing {cmd:predict p1, outcome(1)} would produce the same {opt p1}.

{phang}
{opt xb} calculates the linear prediction.  You must also specify the
{opt outcome(outcome)} option.

{phang}
{opt stdp} calculates the standard error of the linear prediction.
You must also specify the {opt outcome(outcome)} option.

{phang}
{opt stddp} calculates the standard error of the difference in two
linear predictions.  You must specify the {opt outcome(outcome)} option,
and here you specify the two particular outcomes of interest inside
the parentheses, for example, {cmd:predict sed, stdp outcome(1,3)}.

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
{opt scores} calculates equation-level score variables.  The number of
score variables created will be one less than the number of outcomes in the
model.  If the number of outcomes in the model were k, then

{pmore}
the first new variable will contain the first derivative of the log
likelihood with respect to the first equation;

{pmore}
the second new variable will contain the first derivative of the log
likelihood with respect to the second equation;

{pmore}
...

{pmore}
the (k-1)th new variable will contain the first derivative of the log
likelihood with respect to the (k-1)st equation.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :default}probabilities for each outcome{p_end}
{synopt :{opt p:r}}probability for a specified outcome{p_end}
{synopt :{cmd:xb}}linear prediction for a specified outcome{p_end}
{synopt :{cmd:stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{cmd:stddp}}not allowed with {cmd:margins}{p_end}
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
{cmd:margins} estimates margins of response for probabilities and linear
predictions.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse sysdsn1}{p_end}
{phang2}{cmd:. mlogit insure age male nonwhite i.site}{p_end}

{pstd}Test joint significance of {cmd:2.site} and {cmd:3.site} in all equations
{p_end}
{phang2}{cmd:. test 2.site 3.site}{p_end}

{pstd}Test joint significance of coefficients in {cmd:Prepaid} equation{p_end}
{phang2}{cmd:. test [Prepaid]}{p_end}

{pstd}Test joint significance of {cmd:2.site} and {cmd:3.site} in {cmd:Uninsure}
equation{p_end}
{phang2}{cmd:. test [Uninsure]: 2.site 3.site}{p_end}

{pstd}Test if coefficients in {cmd:Prepaid} and {cmd:Uninsure} equations are
equal{p_end}
{phang2}{cmd:. test [Prepaid=Uninsure]}{p_end}

{pstd}Predict probabilities of outcome 1 for estimation sample{p_end}
{phang2}{cmd:. predict p1 if e(sample), outcome(1)}{p_end}

{pstd}Display summary statistics of {cmd:p1}{p_end}
{phang2}{cmd:. summarize p1}{p_end}

{pstd}Compute linear prediction for {cmd:Indemnity} equation{p_end}
{phang2}{cmd:. predict idx1, outcome(Indemnity) xb}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto, clear}{p_end}
{phang2}{cmd:. mlogit rep78 mpg displ}{p_end}

{pstd}Compute the predicted probability at the regressors' means for each
outcome{p_end}
{phang2}{cmd:. margins, atmeans}{p_end}

{pstd}Compute the average marginal effect of each regressor on the probability
of each of the outcomes 1-3{p_end}
{phang2}{cmd:. margins, dydx(*) predict(outcome(1)) predict(outcome(2)) predict(outcome(3))}{p_end}
    {hline}
