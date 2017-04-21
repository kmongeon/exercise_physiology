{smcl}
{* *! version 1.0.1  24jul2015}{...}
{viewerdialog irt "dialog irt"}{...}
{viewerdialog "svy: irt" "dialog irt, message(-svy-) name(svy_irt)"}{...}
{vieweralsosee "[IRT] irt hybrid" "mansection IRT irthybrid"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[IRT] irt hybrid postestimation" "help irt hybrid postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[IRT] irt" "help irt"}{...}
{vieweralsosee "[IRT] irt rsm" "help irt rsm"}{...}
{vieweralsosee "[SEM] gsem" "help gsem_command"}{...}
{viewerjumpto "Syntax" "irt hybrid##syntax"}{...}
{viewerjumpto "Menu" "irt hybrid##menu_irt"}{...}
{viewerjumpto "Description" "irt hybrid##description"}{...}
{viewerjumpto "Options" "irt hybrid##options"}{...}
{viewerjumpto "Examples" "irt hybrid##examples"}{...}
{viewerjumpto "Stored results" "irt hybrid##results"}{...}
{title:Title}

{p2colset 5 25 27 2}{...}
{p2col :{manlink IRT irt hybrid} {hline 2}}Hybrid IRT models{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:irt hybrid} {cmd:(}{it:model} {it:varlist_1}{cmd:)}
{cmd:(}{it:model} {it:varlist_2}{cmd:)} [...]
{ifin}
[{help irt hybrid##weight:{it:weight}}]
[{cmd:,} {it:options}]

{synoptset 16 tabbed}{...}
{synopthdr:model}
{synoptline}
{synopt :{helpb irt 1pl:1pl}}One-parameter logistic model{p_end}
{synopt :{helpb irt 2pl:2pl}}Two-parameter logistic model{p_end}
{p2coldent:* {helpb irt 3pl:3pl}}Three-parameter logistic model{p_end}
{synopt :{helpb irt grm:grm}}Graded response model{p_end}
{synopt :{helpb irt nrm:nrm}}Nominal response model{p_end}
{synopt :{helpb irt pcm:pcm}}Partial credit model{p_end}
{synopt :{helpb irt pcm:gpcm}}Generalized partial credit model{p_end}
{synopt :{helpb irt rsm:rsm}}Rating scale model{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}* The full syntax for {cmd:3pl} is
{cmd:(3pl} {varlist} [{cmd:,} {opt sepg:uessing}]{cmd:)}.
Option {cmd:sepguessing} is documented in {helpb irt 3pl}.{p_end}

{p 4 6 2}{it:varlist_1}, {it:varlist_2}, ..., {it:varlist#} may not
contain duplicate items.


{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
INCLUDE help opt_irt_model

{syntab:SE/Robust}
INCLUDE help opt_irt_vce

{syntab:Reporting}
INCLUDE help opt_irt_report
{synopt :{help irt_hybrid##display_options:{it:display_options}}}control
INCLUDE help opt_irt_display

{syntab:Integration}
{synopt :{cmdab:intm:ethod(}{help irt_hybrid##intmethod:{it:intmethod}}{cmd:)}}integration method{p_end}
INCLUDE help opt_irt_int

{syntab:Maximization}
{synopt :{it:{help irt_hybrid##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

{synopt :{cmdab:startv:alues(}{it:{help irt_hybrid##startvalues:svmethod}}{cmd:)}}method for obtaining starting values{p_end}
INCLUDE help opt_irt_nodb
{synoptline}
{p2colreset}{...}

INCLUDE help irt_intmethod_table

INCLUDE help irt_syntax_notes
{p 4 6 2}
See {manhelp irt_hybrid_postestimation IRT:irt hybrid postestimation} for features
available after estimation.


INCLUDE help menu_irt


{marker description}{...}
{title:Description}

{pstd}
{cmd:irt hybrid} fits IRT models to combinations of binary, ordinal, and
nominal items.


{marker options}{...}
{title:Options}

{dlgtab:Model}

INCLUDE help irt_model_opts

{dlgtab:SE/Robust}

INCLUDE help irt_vce_opt

{dlgtab:Reporting}

INCLUDE help irt_display_opts

{dlgtab:Integration}

INCLUDE help irt_int_opts

{dlgtab:Maximization}

INCLUDE help irt_max_opts

INCLUDE help irt_nodlg_opts


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse science}

{pstd}Fit an NRM to items {cmd:q1-q3} and a PCM to item {cmd:q4}{p_end}
{phang2}{cmd:. irt hybrid (nrm q1-q3) (pcm q4)}

    {hline}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse masc1}

{pstd}Fit a 3PL model to items {cmd:q1-q9}, where each item has its own
pseudoguessing parameter{p_end}
{phang2}{cmd:. irt 3pl q1-q9, sepguessing startvalues(iterate(5))}

{pstd}Display the estimation table in ascending order of the pseudoguessing
parameter{p_end}
{phang2}{cmd:estat report, sort(c) byparm}

{pstd}Fit a 2PL model to the five items for which the pseudoguessing parameter
is close zero and fit a 3PL model with separate pseudoguessing parameters to
the remaining four items{p_end}
{phang2}{cmd:. irt hybrid (2pl q2 q3 q5 q8 q9)}
        {cmd:(3pl q1 q4 q6 q7, sepguessing),}
        {cmd:startval(iter(5))}

    {hline}

{marker results}{...}
{title:Stored results}

{pstd}
{cmd:irt} stores the following in {cmd:e()}:

{synoptset 25 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(k_rc)}}number of covariances{p_end}
{synopt:{cmd:e(k_rs)}}number of variances{p_end}
{synopt:{cmd:e(irt_k_eq)}}number of IRT model groups{p_end}
{synopt:{cmd:e(k_items}{it:#}{cmd:)}}number of items in {it:#}th IRT model group{p_end}
{synopt:{cmd:e(sepguess}{it:#}{cmd:)}}{cmd:1} if {it:#}th IRT model contains a separate pseudoguessing parameter{p_end}
{synopt:{cmd:e(k_cat}{it:#}{cmd:)}}number of categories for the {it:#}th item, ordinal{p_end}
{synopt:{cmd:e(k_out}{it:#}{cmd:)}}number of outcomes for the {it:#}th item, nominal{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(n_quad)}}number of integration points{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if target model converged, {cmd:0}
        otherwise{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:gsem}{p_end}
{synopt:{cmd:e(cmd2)}}{cmd:irt}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(model}{it:#}{cmd:)}}name of IRT model for the {it:#}th model group{p_end}
{synopt:{cmd:e(items}{it:#}{cmd:)}}names of items in {it:#}th IRT model group{p_end}
{synopt:{cmd:e(n_cuts}{it:#}{cmd:)}}numlist of cuts in {it:#}th IRT model group{p_end}
{synopt:{cmd:e(depvar)}}names of all item variables{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(family}{it:#}{cmd:)}}family for the {it:#}th {it:item}{p_end}
{synopt:{cmd:e(link}{it:#})}link for the {it:#}th {it:item}{p_end}
{synopt:{cmd:e(intmethod)}}integration method{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(opt)}}type of optimization{p_end}
{synopt:{cmd:e(which)}}{cmd:max} or {cmd:min}; whether optimizer is to perform
maximization or minimization{p_end}
{synopt:{cmd:e(method)}}estimation method: {cmd:ml}{p_end}
{synopt:{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt:{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(datasignature)}}the checksum{p_end}
{synopt:{cmd:e(datasignaturevars)}}variables used in calculation of
checksum{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(covariates)}}list of covariates{p_end}
{synopt:{cmd:e(footnote)}}program used to implement the footnote
display{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(_N)}}sample size for each item{p_end}
{synopt:{cmd:e(b)}}parameter vector{p_end}
{synopt:{cmd:e(b_pclass)}}parameter class{p_end}
{synopt:{cmd:e(cat}{it:#}{cmd:)}}categories for the {it:#}th item, ordinal{p_end}
{synopt:{cmd:e(out}{it:#}{cmd:)}}outcomes for the {it:#}th item, nominal{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt:{cmd:e(gradient)}}gradient vector{p_end}
{synopt:{cmd:e(V)}}covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
