{smcl}
{* *! version 1.2.5  20mar2015}{...}
{viewerdialog predict "dialog melogit_p"}{...}
{viewerdialog estat "dialog melogit_estat"}{...}
{vieweralsosee "[ME] melogit postestimation" "mansection ME melogitpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ME] melogit" "help melogit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ME] meglm postestimation" "help meglm postestimation"}{...}
{viewerjumpto "Postestimation commands" "melogit postestimation##description"}{...}
{viewerjumpto "predict" "melogit postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "melogit postestimation##syntax_margins"}{...}
{viewerjumpto "estat" "melogit postestimation##syntax_estat"}{...}
{viewerjumpto "Examples" "melogit postestimation##examples"}{...}
{viewerjumpto "Stored results" "melogit postestimation##results"}{...}
{title:Title}

{p2colset 5 36 38 2}{...}
{p2col :{manlink ME melogit postestimation} {hline 2}}Postestimation tools for
melogit{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after
{cmd:melogit}:

{synoptset 18}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb melogit postestimation##estatgroup:estat group}}summarize
the composition of the nested groups{p_end}
{synopt :{helpb melogit postestimation##estaticc:estat icc}}estimate
intraclass correlations{p_end}
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
{synopt:{helpb melogit_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb melogit postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
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
{synopt :{opt cond:itional}{cmd:(}{it:{help melogit_postestimation##ctype:ctype}}{cmd:)}}compute {it:statistic} conditional on estimated random effects; default is {cmd:conditional(ebmeans)}{p_end}
{synopt :{opt marginal}}compute {it:statistic} marginally with respect to the random effects{p_end}
{synopt :{opt nooff:set}}make calculation ignoring offset or exposure{p_end}

{syntab :Integration}
{synopt :{it:{help melogit_postestimation##int_options:int_options}}}integration
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


{marker syntax_estat}{...}
{marker estatgroup}{...}
{marker estaticc}{...}
{title:Syntax for estat}

{pstd}
Summarize the composition of the nested groups

{p 8 14 2}
{cmd:estat} {opt gr:oup}


{pstd}
Estimate intraclass correlations

{p 8 14 2}
{cmd:estat} {opt icc} [{cmd:,} {opt l:evel(#)}]


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
{cmd:estat icc} displays the intraclass correlation for pairs of latent linear
responses at each nested level of the model.  Intraclass correlations are
available for random-intercept models or for random-coefficient models
conditional on random-effects covariates being equal to 0.  They are not
available for crossed-effects models.


{marker option_estat_icc}{...}
{title:Option for estat icc}

{phang}
{opt level(#)}
specifies the confidence level, as a percentage, for confidence intervals.
The default is {cmd:level(95)} or as set by {helpb set level}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse towerlondon}{p_end}
{phang2}{cmd:. melogit dtlm difficulty i.group || family: || subject:}
{p_end}

{pstd}Summarize composition of nested groups{p_end}
{phang2}{cmd:. estat group}{p_end}

{pstd}Predictions of random effects{p_end}
{phang2}{cmd:. predict re_urban re_cons, reffects}{p_end}

{pstd}Predicted probabilities, incorporating random effects{p_end}
{phang2}{cmd:. predict p}{p_end}

{pstd}Predicted probabilities, ignoring subject and family effects{p_end}
{phang2}{cmd:. predict p_fixed, conditional(fixedonly)}{p_end}

{pstd}Compute residual intraclass correlations{p_end}
{phang2}{cmd:. estat icc}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat icc} stores the following in {cmd:r()}:

{synoptset 13 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(icc}{it:#}{cmd:)}}level-{it:#} intraclass correlation{p_end}
{synopt:{cmd:r(se}{it:#}{cmd:)}}standard errors of level-{it:#} intraclass
        correlation{p_end}
{synopt:{cmd:r(level)}}confidence level of confidence intervals{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(label}{it:#}{cmd:)}}label for level {it:#}{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(ci}{it:#}{cmd:)}}vector of confidence intervals (lower and upper)
        for level-{it:#} intraclass correlation{p_end}
{p2colreset}{...}

{pstd}
For a {it:G}-level nested model, {it:#} can be any integer between 2 and {it:G}.
{p_end}
