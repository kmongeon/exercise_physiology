{smcl}
{* *! version 1.2.5  20mar2015}{...}
{viewerdialog predict "dialog mecloglog_p"}{...}
{viewerdialog estat "dialog mecloglog_estat"}{...}
{vieweralsosee "[ME] mecloglog postestimation" "mansection ME mecloglogpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ME] mecloglog" "help mecloglog"}{...}
{vieweralsosee "[ME] meglm postestimation" "help meglm postestimation"}{...}
{viewerjumpto "Postestimation commands" "mecloglog postestimation##description"}{...}
{viewerjumpto "predict" "mecloglog postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "mecloglog postestimation##syntax_margins"}{...}
{viewerjumpto "estat" "mecloglog postestimation##syntax_estat_group"}{...}
{viewerjumpto "Examples" "mecloglog postestimation##examples"}{...}
{title:Title}

{p2colset 5 38 40 2}{...}
{p2col :{manlink ME mecloglog postestimation} {hline 2}}Postestimation tools for
mecloglog{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation command is of special interest after
{cmd:mecloglog}:

{synoptset 18}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb mecloglog postestimation##estatgroup:estat group}}summarize
the composition of the nested groups{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
The following standard postestimation commands are also available:

{synoptset 18 tabbed}{...}
{p2coldent :Command}Description{p_end}
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
{synopt:{helpb mecloglog_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb mecloglog postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:hausman} and {cmd:lrtest} are not appropriate with {cmd:svy}
estimation results.


INCLUDE help syntax_me_predict

INCLUDE help syntax_me_predict_stats

{marker options_table}{...}
{synoptset 25 tabbed}{...}
{synopthdr :options}
{synoptline}
{syntab :Main}
{synopt :{opt cond:itional}{cmd:(}{it:{help mecloglog_postestimation##ctype:ctype}}{cmd:)}}compute {it:statistic} conditional on estimated random effects; default is {cmd:conditional(ebmeans)}{p_end}
{synopt :{opt marginal}}compute {it:statistic} marginally with respect to the random effects{p_end}
{synopt :{opt nooff:set}}make calculation ignoring offset or exposure{p_end}

{syntab :Integration}
{synopt :{it:{help mecloglog_postestimation##int_options:int_options}}}integration
	options{p_end}
{synoptline}
{p 4 6 2}
{cmd:pearson},
{cmd:deviance},
{cmd:anscombe}
may not be combined with {cmd:marginal}.
{p_end}

INCLUDE help syntax_me_predict_ctype

INCLUDE help syntax_me_predict_reopts

INCLUDE help syntax_me_predict_intopts


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
mean responses; linear predictions; density and distribution functions;
standard errors; and Pearson, deviance, and Anscombe residuals.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{cmd:mu}, the default, calculates the predicted mean, that is, the
probability of a positive outcome.

INCLUDE help syntax_me_predict_desc


INCLUDE help syntax_margins

INCLUDE help syntax_me_margins_stats

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for
mean responses and linear predictions.


{marker syntax_estat_group}{...}
{marker estatgroup}{...}
{title:Syntax for estat}

{p 8 14 2}
{cmd:estat} {opt gr:oup} 


INCLUDE help menu_estat


{marker des_estat}{...}
{title:Description for estat}

{pstd}
{cmd:estat group} reports number of groups and minimum, average, and maximum
group sizes for each level of the model.  Model levels are identified by
the corresponding group variable in the data.  Because groups are treated
as nested, the information in this summary may differ from what you would
get if you used the {cmd:tabulate} command on each group variable individually.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse towerlondon}{p_end}
{phang2}{cmd:. mecloglog dtlm difficulty i.group || family: || subject:}
{p_end}

{pstd}Summarize composition of nested groups{p_end}
{phang2}{cmd:. estat group}{p_end}

{pstd}Predictions of random effects{p_end}
{phang2}{cmd:. predict re_urban re_cons, reffects}{p_end}

{pstd}Predicted probabilities, incorporating random effects{p_end}
{phang2}{cmd:. predict p}{p_end}

{pstd}Predicted probabilities, ignoring subject and family effects{p_end}
{phang2}{cmd:. predict p_fixed, conditional(fixedonly)}{p_end}
