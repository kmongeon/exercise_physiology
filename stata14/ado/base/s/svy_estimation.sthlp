{smcl}
{* *! version 1.1.23  20mar2015}{...}
{vieweralsosee "[SVY] svy estimation" "mansection SVY svyestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SVY] svy postestimation" "help svy_postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SVY] estat" "help svy_estat"}{...}
{vieweralsosee "[SVY] svy" "help svy"}{...}
{vieweralsosee "[SVY] svyset" "help svyset"}{...}
{viewerjumpto "Description" "svy_estimation##description"}{...}
{viewerjumpto "Menu" "svy_estimation##menu"}{...}
{viewerjumpto "Examples" "svy_estimation##examples"}{...}
{p2colset 5 27 29 2}{...}
{title:Title}

{pstd}
{manlink SVY svy estimation} {hline 2} Estimation commands for survey data


{marker description}{...}
{title:Description}

{pstd}
Survey data analysis in Stata is essentially the same as standard data
analysis.
The standard syntax applies; you just need to also remember the following:

{phang2}
o  Use {cmd:svyset} to identify the survey design characteristics.

{phang2}
o  Prefix the estimation commands with {cmd:svy:}.

{pstd}
For example,

{pmore2}
{cmd:. webuse nhanes2f}{break}
{cmd:. svyset psuid [pweight=finalwgt], strata(stratid)}{break}
{cmd:. svy: regress zinc age c.age#c.age weight female black orace rural}

{pstd}
See {manhelp svyset SVY} and {manhelp svy SVY}.

{pstd}
The following estimation commands support the {cmd:svy} prefix.

{synoptset 20 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{syntab:Descriptive statistics}
{synopt :{helpb mean}}Estimate means{p_end}
{synopt :{helpb proportion}}Estimate proportions{p_end}
{p2col :{helpb ratio}}Estimate ratios{p_end}
{p2col :{helpb total}}Estimate totals{p_end}

{syntab:Linear regression models}
{p2col :{helpb churdle}}Cragg hurdle regression{p_end}
{p2col :{helpb cnsreg}}Constrained linear regression{p_end}
{p2col :{helpb etregress}}Linear regression with endogenous treatment effects{p_end}
{p2col :{helpb glm}}Generalized linear models{p_end}
{p2col :{helpb intreg}}Interval regression{p_end}
{p2col :{helpb nl}}Nonlinear least-squares estimation{p_end}
{p2col :{helpb regress}}Linear regression{p_end}
{p2col :{helpb tobit}}Tobit regression{p_end}
{p2col :{helpb truncreg}}Truncated regression{p_end}

{syntab:Structural equation models}
{p2col :{helpb sem_command:sem}}Structural equation model estimation command{p_end}
{p2col :{helpb gsem_command:gsem}}Generalized structural equation model estimation command{p_end}

{syntab:Survival-data regression models}
{p2col :{helpb stcox}}Cox proportional hazards model{p_end}
{p2col :{helpb streg}}Parametric survival models{p_end}

{syntab:Binary-response regression models}
{p2col :{helpb biprobit}}Bivariate probit regression{p_end}
{p2col :{helpb cloglog}}Complementary log-log regression{p_end}
{p2col :{helpb hetprobit}}Heteroskedastic probit regression{p_end}
{p2col :{helpb logistic}}Logistic regression, reporting odds ratios{p_end}
{p2col :{helpb logit}}Logistic regression, reporting coefficients{p_end}
{p2col :{helpb probit}}Probit regression{p_end}
{p2col :{helpb scobit}}Skewed logistic regression{p_end}

{syntab:Discrete-response regression models}
{p2col :{helpb clogit}}Conditional (fixed-effects) logistic regression{p_end}
{p2col :{helpb mlogit}}Multinomial (polytomous) logistic regression{p_end}
{p2col :{helpb mprobit}}Multinomial probit regression{p_end}
{p2col :{helpb ologit}}Ordered logistic regression{p_end}
{p2col :{helpb oprobit}}Ordered probit regression{p_end}
{p2col :{helpb slogit}}Stereotype logistic regression{p_end}

{syntab:Fractional-response regression models}
{p2col :{helpb betareg}}Beta regression{p_end}
{p2col :{helpb fracreg}}Fractional-response regression{p_end}

{syntab:Poisson regression models}
{p2col :{helpb cpoisson}}Censored Poisson regression{p_end}
{p2col :{helpb etpoisson}}Poisson regression with endogenous treatment effects{p_end}
{p2col :{helpb gnbreg}}Generalized negative binomial regression{p_end}
{p2col :{helpb nbreg}}Negative binomial regression{p_end}
{p2col :{helpb poisson}}Poisson regression{p_end}
{p2col :{helpb tnbreg}}Truncated negative binomial regression{p_end}
{p2col :{helpb tpoisson}}Truncated Poisson regression{p_end}
{p2col :{helpb zinb}}Zero-inflated negative binomial regression{p_end}
{p2col :{helpb zip}}Zero-inflated Poisson regression{p_end}

{syntab:Instrumental-variables regression models}
{p2col :{helpb ivprobit}}Probit model with continuous endogenous covariates{p_end}
{p2col :{helpb ivregress}}Single-equation instrumental-variables regression{p_end}
{p2col :{helpb ivtobit}}Tobit model with continuous endogenous covariates{p_end}

{syntab:Regression models with selection}
{p2col :{helpb heckman}}Heckman selection model{p_end}
{p2col :{helpb heckoprobit}}Ordered probit model with sample selection{p_end}
{p2col :{helpb heckprobit}}Probit model with sample selection{p_end}

{syntab:Multilevel mixed-effects models}
{p2col :{helpb mecloglog}}Multilevel mixed-effects complementary log-log regression{p_end}
{p2col :{helpb meglm}}Multilevel mixed-effects generalized linear model{p_end}
{p2col :{helpb melogit}}Multilevel mixed-effects logistic regression{p_end}
{p2col :{helpb menbreg}}Multilevel mixed-effects negative binomial regression{p_end}
{p2col :{helpb meologit}}Multilevel mixed-effects ordered logistic regression{p_end}
{p2col :{helpb meoprobit}}Multilevel mixed-effects ordered probit regression{p_end}
{p2col :{helpb mepoisson}}Multilevel mixed-effects Poisson regression{p_end}
{p2col :{helpb meprobit}}Multilevel mixed-effects probit regression{p_end}
{p2col :{helpb mestreg}}Multilevel mixed-effects parametric survival models{p_end}

{syntab:Item response theory}
{p2col :{helpb irt 1pl}}One-parameter logistic model{p_end}
{p2col :{helpb irt 2pl}}Two-parameter logistic model{p_end}
{p2col :{helpb irt 3pl}}Three-parameter logistic model{p_end}
{p2col :{helpb irt grm}}Graded response model{p_end}
{p2col :{helpb irt nrm}}Nominal response model{p_end}
{p2col :{helpb irt pcm}}Partial credit model{p_end}
{p2col :{helpb irt rsm}}Rating scale model{p_end}
{p2col :{helpb irt hybrid}}Hybrid IRT models{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Survey data analysis >} ...

{pstd}
Dialog boxes for all statistical estimators that support {cmd:svy} can be
found on the above menu path.  In addition, you can access survey data
estimation from standard dialog boxes on the {bf:SE/Robust} or
{bf:SE/Cluster} tab.


{marker examples}{...}
{title:Examples}

{pstd}
Descriptive statistics
{p_end}
{phang2}
{cmd:. webuse nmihs}
{p_end}
{phang2}
{cmd:. svyset [pweight=finwgt], strata(stratan)}
{p_end}
{phang2}
{cmd:. svy: mean birthwgt}
{p_end}

{pstd}
Regression models
{p_end}
{phang2}
{cmd:. webuse nhanes2d}
{p_end}
{phang2}
{cmd:. svyset}
{p_end}
{phang2}
{cmd:. svy: logistic highbp height weight age age2 female}
{p_end}
{phang2}
{cmd:. svy, subpop(female): logistic highbp height weight age age2}
{p_end}

{pstd}
Cox proportional hazards model
{p_end}
{phang2}
{cmd:. webuse nhefs}
{p_end}
{phang2}
{cmd:. svyset psu2 [pw=swgt2], strata(strata2)}
{p_end}
{phang2}
{cmd:. stset age_lung_cancer [pw=swgt2], fail(lung_cancer)}
{p_end}
{phang2}
{cmd:. svy: stcox former_smoker smoker male urban1 rural}
{p_end}

{pstd}
Multiple baseline hazards
{p_end}
{phang2}
{cmd:. stphplot, strata(revised_race) adjust(former_smoker smoker male urban1 rural) zero legend(col(1))}
{p_end}
{phang2}
{cmd:. svy: stcox former_smoker smoker male urban1 rural, strata(revised_race)}
{p_end}
