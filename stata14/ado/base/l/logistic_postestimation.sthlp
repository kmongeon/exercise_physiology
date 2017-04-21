{smcl}
{* *! version 1.2.3  04mar2015}{...}
{viewerdialog predict "dialog logit_p"}{...}
{viewerdialog estat "dialog logit_estat"}{...}
{viewerdialog lroc "dialog lroc"}{...}
{viewerdialog lsens "dialog lsens"}{...}
{vieweralsosee "[R] logistic postestimation" "mansection R logisticpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] logistic" "help logistic"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] estat classification" "help estat classification"}{...}
{vieweralsosee "[R] estat gof" "help logistic estat gof"}{...}
{vieweralsosee "[R] lroc" "help lroc"}{...}
{vieweralsosee "[R] lsens" "help lsens"}{...}
{viewerjumpto "Postestimation commands" "logistic postestimation##description"}{...}
{viewerjumpto "predict" "logistic postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "logistic postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "logistic postestimation##examples"}{...}
{viewerjumpto "References" "logistic postestimation##references"}{...}
{title:Title}

{p2colset 5 36 38 2}{...}
{p2col :{manlink R logistic postestimation} {hline 2}}Postestimation tools for
logistic{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after
{cmd:logistic}:

{synoptset 20}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb estat classification}}report various summary statistics, including the classification table{p_end}
{synopt :{helpb logistic estat gof:estat gof}}Pearson or Hosmer-Lemeshow goodness-of-fit test{p_end}
{synopt :{helpb lroc}}compute area under ROC curve and graph the curve{p_end}
{synopt :{helpb lsens}}graph sensitivity and specificity versus probability cutoff{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
These commands are not appropriate after the {cmd:svy} prefix.
{p_end}

{pstd}
The following standard postestimation commands are also available:

{synoptset 20 tabbed}{...}
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
{synopt:{helpb logistic_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb logistic postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
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
{cmd:predict} {dtype} {newvar} {ifin} 
[{cmd:,} {it:statistic} {opt nooff:set} {opt rule:s} {opt asif}]

{synoptset 20 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt p:r}}probability of a positive outcome; the default{p_end}
{synopt :{cmd:xb}}linear prediction{p_end}
{synopt :{cmd:stdp}}standard error of the prediction{p_end}
{p2coldent :* {opt db:eta}}{help logistic postestimation##P1981:Pregibon (1981)} Delta-Beta influence statistic{p_end}
{p2coldent :* {opt de:viance}}deviance residual{p_end}
{p2coldent :* {opt dx:2}}{help logistic postestimation##HLS2013:Hosmer, Lemeshow, and Sturdivant (2013)} Delta
chi-squared influence statistic{p_end}
{p2coldent :* {opt dd:eviance}}{help logistic postestimation##HLS2013:Hosmer, Lemeshow, and Sturdivant (2013)} Delta-D
influence statistic{p_end}
{p2coldent :* {opt h:at}}{help logistic postestimation##P1981:Pregibon (1981)} leverage{p_end}
{p2coldent :* {opt n:umber}}sequential number of the covariate
pattern{p_end}
{p2coldent :* {opt r:esiduals}}Pearson residuals; adjusted for number
sharing covariate pattern{p_end}
{p2coldent :* {opt rs:tandard}}standardized Pearson residuals; adjusted
for number sharing covariate pattern{p_end}
{synopt :{opt sc:ore}}first derivative of the log likelihood with respect to xb{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help unstarred
{p 4 6 2}
{opt pr}, {opt xb}, {opt stdp}, and {opt score} are the only options allowed
with {cmd:svy} estimation results.


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
probabilities, linear predictions, standard errors,
influence statistics, deviance residuals, leverages, sequential
numbers, Pearson residuals, and equation-level scores.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt pr}, the default, calculates the probability of a positive outcome.

{phang}
{opt xb} calculates the linear prediction.

{phang}
{opt stdp} calculates the standard error of the linear prediction.

{phang}
{opt dbeta} calculates the {help logistic postestimation##P1981:Pregibon (1981)}
Delta-Beta influence statistic, a standardized measure of the difference in the
coefficient vector that is due to deletion of the observation along with all
others that share the same covariate pattern.  In
{help logistic postestimation##HLS2013:Hosmer, Lemeshow, and Sturdivant (2013, 154-155)}
jargon, this statistic is M-asymptotic; that is, it is adjusted for the number
of observations that share the same covariate pattern.

{phang}
{opt deviance} calculates the deviance residual.  

{phang}
{opt dx2} calculates the
{help logistic postestimation##HLS2013:Hosmer, Lemeshow, and Sturdivant (2013, 191)} Delta
chi-squared influence statistic, reflecting the decrease in the Pearson
chi-squared that is due to deletion of the observation and all others that
share the same covariate pattern.

{phang}
{opt ddeviance} calculates the
{help logistic postestimation##HLS2013:Hosmer, Lemeshow, and Sturdivant (2013, 191)} Delta-D
influence statistic, which is the change in the deviance residual that is due
to deletion of the observation and all others that share the same covariate
pattern.

{phang}
{opt hat} calculates the {help logistic postestimation##P1981:Pregibon (1981)}
leverage or the diagonal elements of the hat matrix adjusted for the number of
observations that share the same covariate pattern. 

{phang}
{opt number} numbers the covariate patterns -- observations with the same
covariate pattern have the same number.  Observations not used in estimation
have {opt number} set to missing.  The first covariate pattern is numbered
1, the second 2, and so on. 

{phang}
{opt residuals} calculates the Pearson residual as given by
{help logistic postestimation##HLS2013:Hosmer, Lemeshow, and Sturdivant (2013, 155)} and
adjusted for the number of observations that share the same covariate pattern.

{phang}
{opt rstandard} calculates the standardized Pearson residual as given by
{help logistic postestimation##HLS2013:Hosmer, Lemeshow, and Sturdivant (2013, 191)} and
adjusted for the number of observations that share the same covariate pattern.

{phang}
{opt score} calculates the equation-level score, the first derivative of the
log likelihood with respect to the linear prediction.

{dlgtab:Options}

{phang}
{opt nooffset} is relevant only if you specified {opth offset(varname)} for
{opt logistic}.  It modifies the calculations made by {opt predict} so that
they ignore the offset variable; the linear prediction is treated as xb
rather than as xb + offset.

{phang}
{opt rules} requests that Stata use any rules that were used to
identify the model when making the prediction.  By default, Stata calculates
missing for excluded observations.  See
{mansection R logitpostestimationRemarksandexamplesex1_logitp:example 1} in
{bf:[R] logit postestimation}.

{phang}
{opt asif} requests that Stata ignore the rules and the exclusion criteria
and calculate predictions for all observations possible by using the estimated
parameter from the model.  See
{mansection R logitpostestimationRemarksandexamplesex1_logitp:example 1} in
{bf:[R] logit postestimation}.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt p:r}}probability of a positive outcome; the default{p_end}
{synopt :{cmd:xb}}linear prediction{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt db:eta}}not allowed with {cmd:margins}{p_end}
{synopt :{opt de:viance}}not allowed with {cmd:margins}{p_end}
{synopt :{opt dx:2}}not allowed with {cmd:margins}{p_end}
{synopt :{opt dd:eviance}}not allowed with {cmd:margins}{p_end}
{synopt :{opt h:at}}not allowed with {cmd:margins}{p_end}
{synopt :{opt n:umber}}not allowed with {cmd:margins}{p_end}
{synopt :{opt r:esiduals}}not allowed with {cmd:margins}{p_end}
{synopt :{opt rs:tandard}}not allowed with {cmd:margins}{p_end}
{synopt :{opt sc:ore}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

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
{phang2}{cmd:. webuse lbw}

{pstd}Fit logistic regression to predict low birth weight{p_end}
{phang2}{cmd:. logistic low age lwt i.race smoke ptl ht ui}

{pstd}Graph ROC curve and calculate area under the curve{p_end}
{phang2}{cmd:. lroc}

{pstd}Graph sensitivity and specificity against probability cutoff{p_end}
{phang2}{cmd:. lsens}

{pstd}Report classification table and summary statistics{p_end}
{phang2}{cmd:. estat class}

{pstd}Perform goodness-of-fit test{p_end}
{phang2}{cmd:. estat gof}

{pstd}Calculate fitted probabilities for estimation sample only{p_end}
{phang2}{cmd:. predict phat if e(sample)}

{pstd}Calculate Pearson residuals{p_end}
{phang2}{cmd:. predict r, resid}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse nhanes2, clear}

{pstd}Fit logistic regression with three-way interaction{p_end}
{phang2}{cmd:. logistic highbp sex##agegrp##c.bmi}

{pstd}Estimate for each {cmd:sex} the probability of high blood pressure at
equally spaced values of {cmd:bmi}{p_end}
{phang2}{cmd:. margins sex, at(bmi=(10(5)65))}

{pstd}Plot estimates against {cmd:bmi}{p_end}
{phang2}{cmd:. marginsplot}

{pstd}Estimate for each {cmd:sex} changes in the probability of high blood
pressure associated with five-unit increases in BMI{p_end}
{phang2}{cmd:. margins sex, at(bmi=(10(5)65)) contrast(atcontrast(ar._at)}
   {cmd:marginswithin)}

{pstd}Plot results{p_end}
{phang2}{cmd:. marginsplot}{p_end}

    {hline}


{marker references}{...}
{title:References}

{marker HLS2013}{...}
{phang}
Hosmer, D. W., Jr., S. A. Lemeshow, and R. X. Sturdivant. 2013.
{browse "http://www.stata.com/bookstore/applied-logistic-regression/":{it:Applied Logistic Regression}. 3rd ed.}
Hoboken, NJ: Wiley.

{marker P1981}{...}
{phang}
Pregibon, D. 1981. Logistic regression diagnostics.
{it:Annals of Statistics} 9: 705-724.
{p_end}
