{smcl}
{* *! version 1.2.1  29oct2014}{...}
{viewerdialog predict "dialog cnsreg_p"}{...}
{vieweralsosee "[R] eivreg postestimation" "mansection R eivregpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] eivreg" "help eivreg"}{...}
{viewerjumpto "Postestimation commands" "eivreg postestimation##description"}{...}
{viewerjumpto "predict" "eivreg postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "eivreg postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "eivreg postestimation##examples"}{...}
{title:Title}

{p2colset 5 34 36 2}{...}
{p2col :{manlink R eivreg postestimation} {hline 2}}Postestimation tools for eivreg{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {opt eivreg}:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_forecast
INCLUDE help post_lincom
INCLUDE help post_linktest
{synopt:{helpb eivreg_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb eivreg postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict}
{dtype}
{newvar}
{ifin}
[{cmd:,} {it:statistic}]

{synoptset 17 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt r:esiduals}}residuals{p_end}
INCLUDE help regstats
{synoptline}
{p2colreset}{...}
INCLUDE help esample
INCLUDE help whereab


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
linear predictions, residuals, standard errors, probabilities, and expected
values.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}{opt xb}, the default, calculates the linear prediction.

{phang}{opt residuals} calculates the residuals, that is, y - xb.

{phang}
{opt stdp} calculates the standard error of the prediction, which can be
thought of as the standard error of the predicted expected value or mean for
the observation's covariate pattern.  The standard error of the prediction is
also referred to as the standard error of the fitted value.

{phang}
{opt stdf} calculates the standard error of the forecast, which is the
standard error of the point prediction for 1 observation and is
commonly referred to as the standard error of the future or forecast value. By
construction, the standard errors produced by {opt stdf} are always larger
than those produced by {opt stdp}; see
{it:{mansection R regressMethodsandformulas:Methods and formulas}} in
{bf:[R] regress}.

{phang}
{cmd:pr(}{it:a}{cmd:,}{it:b}{cmd:)} calculates
{bind:Pr({it:a} < xb + u < {it:b})}, the probability that y|x would be observed
in the interval ({it:a},{it:b}).

{pmore}
{it:a} and {it:b} may be specified as numbers or variable names;
{it:lb} and {it:ub} are variable names;{break}
{cmd:pr(20,30)} calculates {bind:Pr(20 < xb + u < 30)};{break}
{cmd:pr(}{it:lb}{cmd:,}{it:ub}{cmd:)} calculates
{bind:Pr({it:lb} < xb + u < {it:ub})}; and{break}
{cmd:pr(20,}{it:ub}{cmd:)} calculates {bind:Pr(20 < xb + u < {it:ub})}.

{pmore}
{it:a} missing {bind:({it:a} {ul:>} .)} means minus infinity;
{cmd:pr(.,30)} calculates {bind:Pr(-infinity < xb + u < 30)};{break}
{cmd:pr(}{it:lb}{cmd:,30)} calculates {bind:Pr(-infinity < xb + u < 30)} in
observations for which {bind:{it:lb} {ul:>} .}{break}
and calculates {bind:Pr({it:lb} < xb + u < 30)} elsewhere.

{pmore}
{it:b} missing {bind:({it:b} {ul:>} .)} means plus infinity; {cmd:pr(20,.)}
calculates {bind:Pr(+infinity > xb + u > 20)};{break}
{cmd:pr(20,}{it:ub}{cmd:)} calculates {bind:Pr(+infinity > xb + u > 20)} in
observations for which {bind:{it:ub} {ul:>} .}{break}
and calculates {bind:Pr(20 < xb + u < {it:ub})} elsewhere.

{phang}
{opt e(a,b)} calculates
{bind:{it:E}(xb + u | {it:a} < xb + u < {it:b})}, the expected value of y|x
conditional on y|x being in the interval ({it:a},{it:b}), meaning that y|x is
truncated.  {it:a} and {it:b} are specified as they are for {opt pr()}.

{phang}
{opt ystar(a,b)} calculates {it:E}(y*),
where {bind:y* = {it:a}} if
{bind:xb + u {ul:<} {it:a}}, {bind:y* = {it:b}} if
{bind:xb + u {ul:>} {it:b}}, and {bind:y* = xb + u} otherwise,
meaning that y* is censored.  {it:a} and {it:b} are specified as
they are for {opt pr()}.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt xb}}linear prediction; the default{p_end}
INCLUDE help regstats_margins
{synopt :{opt r:esiduals}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for
linear predictions, probabilities, and expected values.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}

{pstd}Fit regression in which {cmd:weight} and {cmd:mpg} are measured with
reliabilities .85 and .9{p_end}
{phang2}{cmd:. eivreg price weight foreign mpg, r(weight .85 mpg .9)}

{pstd}Calculate fitted values for estimation sample only{p_end}
{phang2}{cmd:. predict prhat if e(sample)}

{pstd}Calculate standard errors of fitted values{p_end}
{phang2}{cmd:. predict stderr if e(sample), stdp}{p_end}
