{smcl}
{* *! version 1.2.3  16sep2015}{...}
{viewerdialog predict "dialog mprobit_p"}{...}
{vieweralsosee "[R] mprobit postestimation" "mansection R mprobitpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] mprobit" "help mprobit"}{...}
{viewerjumpto "Postestimation commands" "mprobit postestimation##description"}{...}
{viewerjumpto "predict" "mprobit postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "mprobit postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "mprobit postestimation##examples"}{...}
{title:Title}

{p2colset 5 35 37 2}{...}
{p2col :{manlink R mprobit postestimation} {hline 2}}Postestimation tools for mprobit{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {opt mprobit}:

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
{synopt:{helpb mprobit_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb mprobit postestimation##predict:predict}}predicted
probabilities, linear predictions, and standard errors{p_end}
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
{synopt :{cmdab:p:r}}predicted probabilities; the default{p_end}
{synopt :{cmd:xb}}linear prediction{p_end}
{synopt :{cmd:stdp}}standard error of the linear prediction{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
If you do not specify {cmd:outcome()}, {cmd:pr} (with one new variable
specified), {cmd:xb}, and {cmd:stdp} assume {cmd:outcome(#1)}.{p_end}
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
{cmd:mprobit result x1 x2}, and {opt result} takes on three values.
Then you could type {cmd:predict p1 p2 p3} to obtain all three predicted
probabilities.  If you specify the {opt outcome()} option, you must specify
one new variable.  Say that {opt result} takes on the values 1, 2, and 3.
Typing {cmd:predict p1, outcome(1)} would produce the same {opt p1}.

{phang}
{opt xb} calculates the linear prediction, x_{it:i} a_{it:j}, for 
alternative {it:j} and individual {it:i}.  The index, {it:j}, corresponds 
to the outcome specified in {opt outcome()}.

{phang}
{opt stdp} calculates the standard error of the linear prediction.

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
{opt scores} calculates the equation-level score variables.  The {it:j}th new
variable will contain the scores for the {it:j}th fitted equation.


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

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sysdsn1}{p_end}
{phang2}{cmd:. mprobit insure age male nonwhite i.site}{p_end}

{pstd}Test that the coefficients on {cmd:2.site} and {cmd:3.site} are 0 in all
equations{p_end}
{phang2}{cmd:. test 2.site 3.site}{p_end}

{pstd}Test that all coefficients in equation {cmd:Uninsure} are 0{p_end}
{phang2}{cmd:. test [Uninsure]}{p_end}

{pstd}Test that {cmd:2.site} and {cmd:3.site} are jointly 0 in the {cmd:Prepaid}
equation{p_end}
{phang2}{cmd:. test [Prepaid]: 2.site 3.site}{p_end}

{pstd}Test that coefficients in equations {cmd:Prepaid} and {cmd:Uninsure} are
equal{p_end}
{phang2}{cmd:. test [Prepaid=Uninsure]}{p_end}

{pstd}Predict probability that a person belongs to the {cmd:Prepaid} insurance
category{p_end}
{phang2}{cmd:. predict p1 if e(sample), outcome(2)}{p_end}
