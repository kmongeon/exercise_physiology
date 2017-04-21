{smcl}
{* *! version 1.0.5  07oct2016}{...}
{viewerdialog heckprobit "dialog heckprobit"}{...}
{viewerdialog "svy: heckprobit" "dialog heckprobit, message(-svy-) name(svy_heckprobit)"}{...}
{vieweralsosee "[R] heckprobit" "mansection R heckprobit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] heckprobit postestimation" "help heckprobit postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] etregress" "help etregress"}{...}
{vieweralsosee "[R] heckman" "help heckman"}{...}
{vieweralsosee "[R] heckoprobit" "help heckoprobit"}{...}
{vieweralsosee "[R] probit" "help probit"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy_estimation"}{...}
{viewerjumpto "Syntax" "heckprobit##syntax"}{...}
{viewerjumpto "Menu" "heckprobit##menu"}{...}
{viewerjumpto "Description" "heckprobit##description"}{...}
{viewerjumpto "Options" "heckprobit##options"}{...}
{viewerjumpto "Examples" "heckprobit##examples"}{...}
{viewerjumpto "Stored results" "heckprobit##results"}{...}
{title:Title}

{p2colset 5 23 25 2}{...}
{p2col :{manlink R heckprobit} {hline 2}}Probit model with sample selection{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:heckprobit} {depvar} {indepvars} {ifin}
[{it:{help heckprobit##weight:weight}}]
{cmd:,}
{opt sel:ect}{cmd:(}[{it:{help depvar:depvar_s}} {cmd:=}]
                     {it:{help varlist:varlist_s}}
[{opt nocon:stant} {opth off:set(varname:varname_o)}]{cmd:)}
[{it:options}]

{synoptset 28 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Model}
{p2coldent :* {opt sel:ect()}}specify selection equation:  dependent and independent variables; whether to have constant term and offset variable{p_end}
{synopt :{opt nocon:stant}}suppress constant term{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient constrained to 1{p_end}
{synopt :{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}
{synopt:{opt col:linear}}keep collinear variables{p_end}

{syntab :SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim},
{opt r:obust}, {opt cl:uster} {it:clustvar}, {cmd:opg}, {opt boot:strap}, or
{opt jack:knife}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt fir:st}}report first-step probit estimates{p_end}
{synopt :{opt noskip}}perform likelihood-ratio test{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help heckprobit##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab :Maximization}
{synopt :{it:{help heckprobit##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {opt select()} is required. The full specification is{break}
{opt sel:ect}{cmd:(}[{it:depvar_s} {cmd:=}] {it:varlist_s}
[{cmd:,} {opt nocon:stant} {opt off:set(varname_o)}]{cmd:)}.
{p_end}
{p 4 6 2}{it:indepvars} and {it:varlist_s} may contain factor variables; see
{help fvvarlist}.{p_end}
{p 4 6 2}{it:depvar}, {it:indepvars}, {it:depvar_s}, and {it:varlist_s} may
contain time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2}{cmd:bootstrap}, {cmd:by}, {cmd:fp}, {cmd:jackknife}, {cmd:rolling},
{cmd:statsby}, and {cmd:svy} are allowed; see {help prefix}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}
{opt vce()},
{opt first},
{opt noskip},
and weights are not allowed with the {helpb svy} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2}{opt pweight}s, {opt fweight}s, and {opt iweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp heckprobit_postestimation R:heckprobit postestimation} for
features available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Sample-selection models > Probit model with sample selection}


{marker description}{...}
{title:Description}

{pstd}
{cmd:heckprobit} fits maximum-likelihood probit models with sample selection.

{pstd}
{cmd:heckprob} is a synonym for {cmd:heckprobit}.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{cmd:select(}[{it:{help depvar:depvar_s}} {cmd:=}] {it:{help varlist:varlist_s}}
[{cmd:,} {opt noconstant} {opth offset:(varname:varname_o)}]{cmd:)}
specifies the variables and options for the
selection equation.  It is an integral part of specifying a selection model
and is required.  The selection equation should contain at least one variable
that is not in the outcome equation.

{pmore}
If {it:depvar_s} is specified, it should be coded as 0 or 1, 0
indicating an observation not selected and 1 indicating a selected observation.
If {it:depvar_s} is not specified, observations for which {it:depvar} is not
missing are assumed selected, and those for which {it:depvar} is missing are
assumed not selected.

{pmore}
{cmd:noconstant} suppresses the selection constant term (intercept).

{pmore}
{opt offset(varname_o)} specifies that selection offset {it:varname_o} be
included in the model with the coefficient constrained to be 1.

{phang}
{opt noconstant}, {opth offset(varname)}, {opt constraints(constraints)},
{opt collinear}; see
{helpb estimation options:[R] estimation options}.

{dlgtab:SE/Robust}

INCLUDE help vce_asymptall

{dlgtab:Reporting}

{phang}
{opt level(#)}; see 
{helpb estimation options##level():[R] estimation options}.

{phang}
{opt first} specifies that the first-step probit estimates of the selection
equation be displayed before estimation.

{phang}
{cmd:noskip} specifies that a full maximum-likelihood model with only a
constant for the regression equation be fit.  This model is not displayed
but is used as the base model to compute a likelihood-ratio test for the model
test statistic displayed in the estimation header.  By default, the overall
model test statistic is an asymptotically equivalent Wald test that all the
parameters in the regression equation are zero (except the constant).  For
many models, this option can substantially increase estimation time.

{phang}
{opt nocnsreport}; see
     {helpb estimation options##nocnsreport:[R] estimation options}.

{marker display_options}{...}
INCLUDE help displayopts_list

{marker maximize_options}{...}
{dlgtab:Maximization}

{phang}
{it:maximize_options}: {opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)},
{opt iter:ate(#)}, [{cmdab:no:}]{opt lo:g}, {opt tr:ace},
{opt grad:ient}, {opt showstep},
{opt hess:ian}, {opt showtol:erance},
{opt tol:erance(#)}, {opt ltol:erance(#)},
{opt nrtol:erance(#)}, {opt nonrtol:erance}, and
{opt from(init_specs)}; see {manhelp maximize R}.  These options are seldom
used.

{pmore}
Setting the optimization type to {cmd:technique(bhhh)} resets the default
{it:vcetype} to {cmd:vce(opg)}.

{pstd}
The following option is available with {opt heckprobit} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] estimation options}.


{marker examples}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse school}{p_end}

{pstd}Fit a probit model with sample selection{p_end}
{phang2}{cmd:. heckprobit private years logptax, sel(vote=years loginc logptax)}
{p_end}

{pstd}Replay results, but display legend of coefficients rather than the
statistics for the coefficients{p_end}
{phang2}{cmd:. heckprobit, coeflegend}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:heckprobit} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_cens)}}number of censored observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(k_aux)}}number of auxiliary parameters{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(ll_0)}}log likelihood, constant-only model{p_end}
{synopt:{cmd:e(ll_c)}}log likelihood, comparison model{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(chi2_c)}}chi-squared for comparison test{p_end}
{synopt:{cmd:e(p_c)}}p-value for comparison test{p_end}
{synopt:{cmd:e(p)}}significance of comparison test{p_end}
{synopt:{cmd:e(rho)}}rho{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(rank0)}}rank of {cmd:e(V)} for constant-only model{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:heckprobit}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}names of dependent variables{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(offset1)}}offset for regression equation{p_end}
{synopt:{cmd:e(offset2)}}offset for selection equation{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald} or {cmd:LR}; type of model chi-squared
	test{p_end}
{synopt:{cmd:e(chi2_ct)}}type of comparison chi-squared test{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(opt)}}type of optimization{p_end}
{synopt:{cmd:e(which)}}{cmd:max} or {cmd:min}; whether optimizer is to perform
                         maximization or minimization{p_end}
{synopt:{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt:{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt:{cmd:e(gradient)}}gradient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
