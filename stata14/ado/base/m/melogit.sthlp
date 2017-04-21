{smcl}
{* *! version 1.1.8  18feb2015}{...}
{viewerdialog melogit "dialog melogit"}{...}
{viewerdialog "svy: melogit" "dialog melogit, message(-svy-) name(svy_melogit)"}{...}
{vieweralsosee "[ME] melogit" "mansection ME melogit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ME] melogit postestimation" "help melogit postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ME] me" "help me"}{...}
{vieweralsosee "[ME] mecloglog" "help mecloglog"}{...}
{vieweralsosee "[ME] meprobit" "help meprobit"}{...}
{vieweralsosee "[ME] meqrlogit" "help meqrlogit"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy_estimation"}{...}
{vieweralsosee "[XT] xtlogit" "help xtlogit"}{...}
{viewerjumpto "Syntax" "melogit##syntax"}{...}
{viewerjumpto "Menu" "melogit##menu"}{...}
{viewerjumpto "Description" "melogit##description"}{...}
{viewerjumpto "Options" "melogit##options"}{...}
{viewerjumpto "Remarks" "melogit##remarks"}{...}
{viewerjumpto "Examples" "melogit##examples"}{...}
{viewerjumpto "Stored results" "melogit##results"}{...}
{title:Title}

{p2colset 5 21 23 2}{...}
{synopt :{manlink ME melogit} {hline 2}}Multilevel mixed-effects logistic regression
{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 18 2}
{cmd:melogit} {depvar} {it:fe_equation} [{cmd:||} {it:re_equation}]
	[{cmd:||} {it:re_equation} ...] 
	[{cmd:,} {it:{help melogit##options_table:options}}]

{p 4 4 2}
    where the syntax of {it:fe_equation} is

{p 12 24 2}
	[{indepvars}] {ifin} [{it:{help melogit##weight:weight}}]
	[{cmd:,} {it:{help melogit##fe_options:fe_options}}]

{p 4 4 2}
    and the syntax of {it:re_equation} is one of the following:

{p 8 18 2}
	for random coefficients and intercepts

{p 12 24 2}
	{it:{help varname:levelvar}}{cmd::} [{varlist}]
		[{cmd:,} {it:{help melogit##re_options:re_options}}]

{p 8 18 2}
	for random effects among the values of a factor variable

{p 12 24 2}
	{it:{help varname:levelvar}}{cmd::} {cmd:R.}{varname}

{p 4 4 2}
    {it:levelvar} is a variable identifying the group structure for the random
    effects at that level or is {cmd:_all} representing one group comprising all
    observations.{p_end}

{synoptset 25 tabbed}{...}
{marker fe_options}{...}
{synopthdr :fe_options}
{synoptline}
{syntab:Model}
{synopt :{opt nocon:stant}}suppress constant term from the fixed-effects
equation{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient
constrained to 1{p_end}
{synopt :{opt asis}}retain perfect predictor variables{p_end}
{synoptline}

{marker re_options}{...}
{synopthdr :re_options}
{synoptline}
{syntab:Model}
{synopt :{opth cov:ariance(melogit##vartype:vartype)}}variance-covariance structure of the random effects{p_end}
{synopt :{opt nocon:stant}}suppress constant term from the random-effects equation{p_end}
{synopt :{opth fw:eight(varname)}}frequency weights at higher levels{p_end}
{synopt :{opth iw:eight(varname)}}importance weights at higher levels{p_end}
{synopt :{opth pw:eight(varname)}}sampling weights at higher levels{p_end}
{synoptline}

{marker options_table}{...}
{synopthdr :options}
{synoptline}
{syntab:Model}
{synopt :{opt bin:omial}{cmd:(}{it:{help varname:varname}}|{it:#}{cmd:)}}set binomial trials if data are in binomial form{p_end}
{synopt :{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}
{synopt :{opt col:linear}}keep collinear variables{p_end}

{syntab:SE/Robust}
{synopt:{opth vce(vcetype)}}{it:vcetype} may be {cmd:oim}, {cmdab:r:obust},
or {cmdab:cl:uster} {it:clustvar}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt or}}report fixed-effects coefficients as odds ratios{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{opt notab:le}}suppress coefficient table{p_end}
{synopt :{opt nohead:er}}suppress output header{p_end}
{synopt :{opt nogr:oup}}suppress table summarizing groups{p_end}
{synopt :{opt nolr:test}}do not perform likelihood-ratio test comparing with logistic regression{p_end}
{synopt :{it:{help melogit##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Integration}
{synopt :{opth intm:ethod(melogit##intmethod:intmethod)}}integration method{p_end}
{synopt :{opt intp:oints(#)}}set the number of integration
(quadrature) points for all levels; default is {cmd:intpoints(7)}{p_end}

{syntab :Maximization}
{synopt :{it:{help melogit##maximize_options:maximize_options}}}control
the maximization process; seldom used{p_end}

INCLUDE help startval_table
{synopt :{opt dnumerical}}use numerical derivative techniques{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}

INCLUDE help me_vartype_table

INCLUDE help me_intmethod_table

INCLUDE help fvvarlist
{p 4 6 2}{it:depvar}, {it:indepvars}, and {it:varlist} may contain time-series
operators; see {help tsvarlist}.{p_end}
{p 4 6 2}{cmd:by} and {cmd:svy} are allowed; see {help prefix}.{p_end}
{p 4 6 2}
{opt vce()} and weights are not allowed with the {helpb svy} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s are allowed; 
see {help weight}.  Only one type of weight may be specified.
Weights are not supported under the Laplacian
approximation or for crossed models.{p_end}
{p 4 6 2}
{opt startvalues()}, {opt startgrid}, {opt noestimate}, {opt dnumerical}, and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp melogit_postestimation ME:melogit postestimation}
for features available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multilevel mixed-effects models > Logistic regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:melogit} fits mixed-effects models for binary and binomial responses.
The conditional distribution of the response given the random effects is
assumed to be Bernoulli, with success probability determined by the logistic
cumulative distribution function.

{pstd}
{cmd:melogit} performs optimization using the original metric of variance
components.  When variance components are near the boundary of the parameter
space, you may consider using the {cmd:meqrlogit} command,
which provides alternative parameterizations of variance components;
see {helpb meqrlogit:[ME] meqrlogit}.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt noconstant} suppresses the constant (intercept) term and may
be specified for the fixed-effects equation and for any of or all the
random-effects equations.

{phang}
{opth offset(varname)} specifies that {it:varname} be included in the
fixed-effects portion of the model with the coefficient constrained to be 1.

{phang}
{opt asis} forces retention of perfect predictor variables and their
associated, perfectly predicted observations and may produce instabilities in
maximization; see {manhelp probit R}.

INCLUDE help me_vartype_opt

INCLUDE help me_weight_opt

{phang}{cmd:binomial(}{help varname:{it:varname}}|{it:#}{cmd:)} specifies that
the data are in binomial form; that is, {depvar} records the number of
successes from a series of binomial trials.  
This number of trials is given either as {it:varname},
which allows this number to vary over the observations, or as the constant
{it:#}.  If {opt binomial()} is not specified (the default), {it:depvar} is
treated as Bernoulli, with any nonzero, nonmissing values indicating positive
responses.

{phang}
{opt constraints(constraints)},
{opt collinear}; see {helpb estimation options:[R] estimation options}.

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported, which
includes types that are derived from asymptotic theory ({cmd:oim}),
that are robust to some kinds of misspecification ({cmd:robust}), and
that allow for intragroup correlation ({cmd:cluster} {it:clustvar}); see
{helpb vce_option:[R] {it:vce_option}}.  If {cmd:vce(robust)} is specified,
robust variances are clustered at the highest level in the multilevel model.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options:[R] estimation options}.

{phang}
{opt or} reports estimated fixed-effects coefficients transformed to odds
ratios, that is, exp(b) rather than b.  Standard errors and confidence
intervals are similarly transformed.  This option affects how results are
displayed, not how they are estimated.  {cmd:or} may be specified either at
estimation or upon replay.

{phang}
{opt nocnsreport}; see {helpb estimation options:[R] estimation options}.

{phang}
{opt notable} suppresses the estimation table, either at estimation or
upon replay.

{phang}
{opt noheader} suppresses the output header, either at estimation or 
upon replay.

{phang}
{opt nogroup} suppresses the display of group summary information (number of 
groups, average group size, minimum, and maximum) from the output header.

{phang}
{opt nolrtest} prevents {cmd:melogit} from performing a likelihood-ratio
test that compares the mixed-effects logistic model with standard (marginal)
logistic regression.  This option may also be specified upon replay to
suppress this test from the output.

INCLUDE help displayopts_list

{dlgtab:Integration}

INCLUDE help me_integration_opt

{marker maximize_options}{...}
{dlgtab:Maximization}

{phang}
{it:maximize_options}:
{opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)},
{opt iter:ate(#)},
[{cmdab:no:}]{opt lo:g},
{opt tr:ace},
{opt grad:ient},
{opt showstep},
{opt hess:ian},
{opt showtol:erance},
{opt tol:erance(#)},
{opt ltol:erance(#)},
{opt nrtol:erance(#)},
{opt nonrtol:erance}, and
{opt from(init_specs)};
see {helpb maximize:[R] maximize}.
Those that require special mention for {cmd:melogit}
are listed below.

{pmore}
{opt from()} accepts a properly labeled vector of initial values or a list of
coefficient names with values.  A list of values is not allowed.

{pstd}
The following options are available with {opt melogit} but are not shown in
the dialog box:

{phang}
{opt startvalues(svmethod)}, {cmd:startgrid}[{cmd:(}{it:gridspec}{cmd:)}],
{opt noestimate}, and {opt dnumerical}; see {helpb meglm##startval:[ME] meglm}.

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] estimation options}.


{marker remarks}{...}
INCLUDE help me_weight_remarks


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse bangladesh}{p_end}

{pstd}Two-level random-intercept model, analogous to {cmd:xtlogit}{p_end}
{phang2}{cmd:. melogit c_use urban age child* || district:}{p_end}

{pstd}Two-level random-intercept and random-coefficient model{p_end}
{phang2}{cmd:. melogit c_use urban age child* || district: urban}{p_end}

{pstd}Two-level random-intercept and random-coefficient model, correlated random
effects{p_end}
{phang2}{cmd:. melogit c_use urban age child* || district: urban,}
       {cmd:cov(unstruct)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse towerlondon}{p_end}

{pstd}Three-level nested model, {cmd:subject} nested within {cmd:family}{p_end}
{phang2}{cmd:. melogit dtlm difficulty i.group || family: || subject:}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse fifeschool}{p_end}
{phang2}{cmd:. gen byte attain_gt_6 = attain > 6}{p_end}

{pstd}Two-way crossed random effects{p_end}
{phang2}{cmd:. melogit attain_gt_6 sex || _all:R.sid || pid:}{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:melogit} stores the following in {cmd:e()}:

{synoptset 24 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(k_f)}}number of fixed-effects parameters{p_end}
{synopt:{cmd:e(k_r)}}number of random-effects parameters{p_end}
{synopt:{cmd:e(k_rs)}}number of variances{p_end}
{synopt:{cmd:e(k_rc)}}number of covariances{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(p)}}significance{p_end}
{synopt:{cmd:e(ll_c)}}log likelihood, comparison model{p_end}
{synopt:{cmd:e(chi2_c)}}chi-squared, comparison model{p_end}
{synopt:{cmd:e(df_c)}}degrees of freedom, comparison model{p_end}
{synopt:{cmd:e(p_c)}}significance, comparison model{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 24 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:meglm}{p_end}
{synopt:{cmd:e(cmd2)}}{cmd:melogit}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression (first-level weights){p_end}
{synopt:{cmd:e(fweight}{it:k}{cmd:)}}{cmd:fweight} variable for {it:k}th highest level, if specified{p_end}
{synopt:{cmd:e(iweight}{it:k}{cmd:)}}{cmd:iweight} variable for {it:k}th highest level, if specified{p_end}
{synopt:{cmd:e(pweight}{it:k}{cmd:)}}{cmd:pweight} variable for {it:k}th highest level, if specified{p_end}
{synopt:{cmd:e(covariates)}}list of covariates{p_end}
{synopt:{cmd:e(ivars)}}grouping variables{p_end}
{synopt:{cmd:e(model)}}{cmd:logistic}{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(link)}}{cmd:logit}{p_end}
{synopt:{cmd:e(family)}}{cmd:bernoulli} or {cmd:binomial}{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(offset)}}offset{p_end}
{synopt:{cmd:e(binomial)}}binomial number of trials{p_end}
{synopt:{cmd:e(intmethod)}}integration method{p_end}
{synopt:{cmd:e(n_quad)}}number of integration points{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(opt)}}type of optimization{p_end}
{synopt:{cmd:e(which)}}{cmd:max} or {cmd:min}; whether optimizer is to perform
maximization or minimization{p_end}
{synopt:{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt:{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(datasignature)}}the checksum{p_end}
{synopt:{cmd:e(datasignaturevars)}}variables used in calculation of checksum{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginswtype)}}weight type for {cmd:margins}{p_end}
{synopt:{cmd:e(marginswexp)}}weight expression for {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 24 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt:{cmd:e(gradient)}}gradient vector{p_end}
{synopt:{cmd:e(N_g)}}group counts{p_end}
{synopt:{cmd:e(g_min)}}group-size minimums{p_end}
{synopt:{cmd:e(g_avg)}}group-size averages{p_end}
{synopt:{cmd:e(g_max)}}group-size maximums{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 24 tabbed}{...}
{p2col 5 15 19 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
