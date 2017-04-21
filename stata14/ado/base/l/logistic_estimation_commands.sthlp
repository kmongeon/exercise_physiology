{smcl}
{* *! version 1.1.1  02mar2015}{...}
{title:Description}

{pstd}Stata has a variety of commands for performing estimation when the 
dependent variable is dichotomous or polytomous.  Here is a list of some
estimation commands that may be of interest.  See
{help estimation commands}
for a complete list of all of Stata's estimation commands.

{p2colset 5 41 43 2}{...}
{p2col :Command{space 6}Manual entry}Description{p_end}
{p2line}
{p2col :{helpb asclogit}{space 5}{bf:[R] asclogit}}Alternative-specific conditional logit (McFadden's choice) model{p_end}
{p2col :{helpb asmprobit}{space 4}{bf:[R] asmprobit}}Alternative-specific multinomial probit regression{p_end}
{p2col :{helpb asroprobit}{space 3}{bf:[R] asroprobit}}Alternative-specific rank-ordered probit regression{p_end}
{p2col :{helpb binreg}{space 7}{bf:[R] binreg}}GLM models for the binomial family{p_end}
{p2col :{helpb biprobit}{space 5}{bf:[R] biprobit}}Bivariate probit regression{p_end}
{p2col :{helpb clogit}{space 7}{bf:[R] clogit}}Conditional (fixed-effects) logistic regression{p_end}
{p2col :{helpb cloglog}{space 6}{bf:[R] cloglog}}Complementary log-log regression{p_end}
{p2col :{helpb exlogistic}{space 3}{bf:[R] exlogistic}}Exact logistic regression{p_end}
{p2col :{helpb glm}{space 10}{bf:[R] glm}}Generalized linear models{p_end}
{p2col :{helpb heckoprobit}{space 2}{bf:[R] heckoprobit}}Ordered probit model with sample selection{p_end}
{p2col :{helpb heckprobit}{space 3}{bf:[R] heckprobit}}Probit model with sample selection{p_end}
{p2col :{helpb hetprobit}{space 4}{bf:[R] hetprobit}}Heteroskedastic probit model{p_end}
{p2col :{helpb ivprobit}{space 5}{bf:[R] ivprobit}}Probit model with endogenous covariates{p_end}
{p2col :{helpb logit}{space 8}{bf:[R] logit}}Logistic regression, reporting coefficients{p_end}
{p2col :{helpb mecloglog}{space 4}{bf:[ME] mecloglog}}Multilevel mixed-effects complementary log-log regression{p_end}
{p2col :{helpb meglm}{space 8}{bf:[ME] meglm}}Multilevel mixed-effects generalized linear model{p_end}
{p2col :{helpb melogit}{space 6}{bf:[ME] melogit}}Multilevel mixed-effects logistic regression{p_end}
{p2col :{helpb meprobit}{space 5}{bf:[ME] meprobit}}Multilevel mixed-effects probit regression{p_end}
{p2col :{helpb mlogit}{space 7}{bf:[R] mlogit}}Multinomial (polytomous) logistic regression{p_end}
{p2col :{helpb meologit}{space 5}{bf:[ME] meologit}}Multilevel mixed-effects ordered logistic regression{p_end}
{p2col :{helpb meoprobit}{space 4}{bf:[ME] meoprobit}}Multilevel mixed-effects ordered probit regression{p_end}
{p2col :{helpb mprobit}{space 6}{bf:[R] mprobit}}Multinomial probit regression{p_end}
{p2col :{helpb nlogit}{space 7}{bf:[R] nlogit}}Nested logit regression
(RUM-consistent and nonnormalized){p_end}
{p2col :{helpb ologit}{space 7}{bf:[R] ologit}}Ordered logistic regression{p_end}
{p2col :{helpb oprobit}{space 6}{bf:[R] oprobit}}Ordered probit regression{p_end}
{p2col :{helpb probit}{space 7}{bf:[R] probit}}Probit regression{p_end}
{p2col :{helpb rologit}{space 6}{bf:[R] rologit}}Rank-ordered logistic regression{p_end}
{p2col :{helpb scobit}{space 7}{bf:[R] scobit}}Skewed logistic regression{p_end}
{p2col :{helpb slogit}{space 7}{bf:[R] slogit}}Stereotype logistic regression{p_end}
{p2col :{helpb svy estimation:svy:}{space 9}{bf:[SVY] svy estimation}}Estimation commands for survey data{p_end}
{p2col :{helpb xtcloglog}{space 4}{bf:[XT] xtcloglog}}Random-effects and population-averaged cloglog models{p_end}
{p2col :{helpb xtgee}{space 8}{bf:[XT] xtgee}}GEE population-averaged generalized linear models{p_end}
{p2col :{helpb xtlogit}{space 6}{bf:[XT] xtlogit}}Fixed-effects, random-effects, and population-averaged logit models{p_end}
{p2col :{helpb xtologit}{space 5}{bf:[XT] xtologit}}Random-effects ordered logistic models{p_end}
{p2col :{helpb xtoprobit}{space 4}{bf:[XT] xtoprobit}}Random-effects ordered probit models{p_end}
{p2col :{helpb xtprobit}{space 5}{bf:[XT] xtprobit}}Random-effects and population-averaged probit models{p_end}
{p2line}
{p2colreset}{...}
