{smcl}
{* *! version 1.1.34  08mar2015}{...}
{vieweralsosee "[U] 20 Estimation and postestimation commands (estimation)" "help estcom"}{...}
{vieweralsosee "[U] 20 Estimation and postestimation commands (postestimation)" "help postest"}{...}
{title:Title}

{pstd}
Quick reference for estimation commands


{title:Description}

{pstd}
This entry provides a quick reference for Stata's estimation commands.  
Because enhancements to Stata are continually being made, type 
{cmd:search estimation commands} for possible additions to this list; see 
{manhelp search R}.

{pstd}
For a discussion of properties shared by all estimation commands, see
{help estcom}.

{pstd}
For a list of prefix commands that can be used with many of these estimation
commands, see {manhelp prefix U:11.1.10 Prefix commands}.


{synoptset 20}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb anova}}Analysis of variance and covariance{p_end}
{synopt :{helpb arch}}ARCH family of estimators{p_end}
{synopt :{helpb areg}}Linear regression with a large dummy-variable set{p_end}
{synopt :{helpb arfima}}Autoregressive fractionally integrated moving-average models{p_end}
{synopt :{helpb arima}}ARIMA, ARMAX, and other dynamic regression models{p_end}
{synopt :{helpb asclogit}}Alternative-specific conditional logit (McFadden's choice) model{p_end}
{synopt :{helpb asmprobit}}Alternative-specific multinomial probit regression{p_end}
{synopt :{helpb asroprobit}}Alternative-specific rank-ordered probit regression{p_end}

{synopt :{helpb bayesmh}}Bayesian regression using Metropolis-Hastings algorithm{p_end}
{synopt :{helpb betareg}}Beta regression{p_end}
{synopt :{helpb binreg}}Generalized linear models: Extensions to the binomial family{p_end}
{synopt :{helpb biprobit}}Bivariate probit regression{p_end}
{synopt :{helpb boxcox}}Box-Cox regression models{p_end}
{synopt :{helpb bsqreg}}Bootstrapped quantile regression{p_end}

{synopt :{helpb ca}}Simple correspondence analysis{p_end}
{synopt :{helpb camat}}Simple correspondence analysis of a matrix{p_end}
{synopt :{helpb candisc}}Canonical linear discriminant analysis{p_end}
{synopt :{helpb canon}}Canonical correlations {p_end}
{synopt :{helpb churdle}}Cragg hurdle regression{p_end}
{synopt :{helpb clogit}}Conditional (fixed-effects) logistic regression{p_end}
{synopt :{helpb cloglog}}Complementary log-log regression{p_end}
{synopt :{helpb cnsreg}}Constrained linear regression{p_end}
{synopt :{helpb contrast:contrast, post}}Post contrasts as estimation results{p_end}
{synopt :{helpb cpoisson}}Censored Poisson regression{p_end}

{synopt :{helpb dfactor}}Dynamic-factor models{p_end}
{synopt :{helpb discrim knn}}kth-nearest-neighbor discriminant analysis{p_end}
{synopt :{helpb discrim lda}}Linear discriminant analysis{p_end}
{synopt :{helpb discrim logistic}}Logistic discriminant analysis{p_end}
{synopt :{helpb discrim qda}}Quadratic discriminant analysis{p_end}

{synopt :{helpb eivreg}}Errors-in-variables regression{p_end}
{synopt :{helpb eteffects}}Endogenous treatment-effects estimation{p_end}
{synopt :{helpb etpoisson}}Poisson regression with endogenous treatment effects{p_end}
{synopt :{helpb etregress}}Linear regression with endogenous treatment effects{p_end}
{synopt :{helpb exlogistic}}Exact logistic regression{p_end}
{synopt :{helpb expoisson}}Exact Poisson regression{p_end}

{synopt :{helpb factor}}Factor analysis{p_end}
{synopt :{helpb factormat}}Factor analysis of a correlation matrix{p_end}
{synopt :{helpb fracreg}}Fractional response regression{p_end}
{synopt :{helpb frontier}}Stochastic frontier models{p_end}

{synopt :{helpb glm}}Generalized linear models{p_end}
{synopt :{helpb gmm}}Generalized method of moments estimation{p_end}
{synopt :{helpb gnbreg}}Generalized negative binomial model{p_end}
{synopt :{helpb gsem_command:gsem}}Generalized structural equation model
estimation command{p_end}

{synopt :{helpb heckman}}Heckman selection model{p_end}
{synopt :{helpb heckoprobit}}Ordered probit model with sample selection{p_end}
{synopt :{helpb heckprobit}}Probit model with sample selection{p_end}
{synopt :{helpb hetprobit}}Heteroskedastic probit model{p_end}

{synopt :{helpb intreg}}Interval regression{p_end}
{synopt :{helpb iqreg}}Interquantile range regression{p_end}
{synopt :{helpb irt 1pl}}One-parameter logistic model{p_end}
{synopt :{helpb irt 2pl}}Two-parameter logistic model{p_end}
{synopt :{helpb irt 3pl}}Three-parameter logistic model{p_end}
{synopt :{helpb irt gpcm}}Generalized partial credit model{p_end}
{synopt :{helpb irt grm}}Graded response model{p_end}
{synopt :{helpb irt hybrid}}Hybrid IRT models{p_end}
{synopt :{helpb irt nrm}}Nominal response model{p_end}
{synopt :{helpb irt pcm}}Partial credit model{p_end}
{synopt :{helpb irt rsm}}Rating scale model{p_end}
{synopt :{helpb ivpoisson}}Poisson model with continuous endogenous covariates{p_end}
{synopt :{helpb ivprobit}}Probit model with continuous endogenous covariates{p_end}
{synopt :{helpb ivregress}}Single-equation instrumental-variables estimation{p_end}
{synopt :{helpb ivtobit}}Tobit model with continuous endogenous covariates{p_end}

{synopt :{helpb logistic}}Logistic regression, reporting odds ratios{p_end}
{synopt :{helpb logit}}Logistic regression, reporting coefficients{p_end}

{synopt :{helpb manova}}Multivariate analysis of variance and covariance{p_end}
{synopt :{helpb margins:margins, post}}Post margins as estimation results{p_end}
{synopt :{helpb mca}}Multiple and joint correspondence analysis{p_end}
{synopt :{helpb mds}}Multidimensional scaling for two-way data{p_end}
{synopt :{helpb mdslong}}Multidimensional scaling of proximity data in long format{p_end}
{synopt :{helpb mdsmat}}Multidimensional scaling of proximity data in a matrix{p_end}
{synopt :{helpb mean}}Estimate means{p_end}
{synopt :{helpb mecloglog}}Multilevel mixed-effects complementary log-log regression{p_end}
{synopt :{helpb meglm}}Multilevel mixed-effects generalized linear model{p_end}
{synopt :{helpb melogit}}Multilevel mixed-effects logistic regression{p_end}
{synopt :{helpb menbreg}}Multilevel mixed-effects negative binomial regression{p_end}
{synopt :{helpb meologit}}Multilevel mixed-effects ordered logistic regression{p_end}
{synopt :{helpb meoprobit}}Multilevel mixed-effects ordered probit regression{p_end}
{synopt :{helpb mepoisson}}Multilevel mixed-effects Poisson regression{p_end}
{synopt :{helpb meprobit}}Multilevel mixed-effects probit regression{p_end}
{synopt :{helpb meqrlogit}}Multilevel mixed-effects logistic regression (QR decomposition){p_end}
{synopt :{helpb meqrpoisson}}Multilevel mixed-effects Poisson regression (QR decomposition){p_end}
{synopt :{helpb mestreg}}Multilevel mixed-effects parametric survival models{p_end}
{synopt :{helpb mgarch ccc}}Constant conditional correlation multivariate GARCH model{p_end}
{synopt :{helpb mgarch dcc}}Dynamic conditional correlation multivariate GARCH model{p_end}
{synopt :{helpb mgarch dvech}}Diagonal vech multivariate GARCH model{p_end}
{synopt :{helpb mgarch vcc}}Varying conditional correlation multivariate GARCH model{p_end}
{synopt :{helpb mixed}}Multilevel mixed-effects linear regression{p_end}
{synopt :{helpb ml}}Maximum likelihood estimation{p_end}
{synopt :{helpb mlexp}}Maximum likelihood estimation of user-specified expressions{p_end}
{synopt :{helpb mlogit}}Multinomial (polytomous) logistic regression{p_end}
{synopt :{helpb mprobit}}Multinomial probit regression{p_end}
{synopt :{helpb mswitch}}Markov-switching regression models{p_end}
{synopt :{helpb mvreg}}Multivariate regression{p_end}

{synopt :{helpb nbreg}}Negative binomial regression{p_end}
{synopt :{helpb newey}}Regression with Newey-West standard errors{p_end}
{synopt :{helpb nl}}Nonlinear least-squares estimation{p_end}
{synopt :{helpb nlogit}}Nested logit model (RUM-consistent and nonnormalized){p_end}
{synopt :{helpb nlsur}}System of nonlinear equations{p_end}

{synopt :{helpb ologit}}Ordered logistic regression{p_end}
{synopt :{helpb oprobit}}Ordered probit regression{p_end}

{synopt :{helpb pca}}Principal component analysis{p_end}
{synopt :{helpb pcamat}}Principal component analysis of a correlation or
covariance matrix{p_end}
{synopt :{helpb poisson}}Poisson regression{p_end}
{synopt :{helpb prais}}Prais-Winsten and Cochrane-Orcutt regression{p_end}
{synopt :{helpb probit}}Probit regression{p_end}
{synopt :{helpb procrustes}}Procrustes transformation{p_end}
{synopt :{helpb proportion}}Estimate proportions{p_end}
{synopt :{helpb pwcompare:pwcompare, post}}Post pairwise comparisons as estimation results{p_end}
{synopt :{helpb pwmean:pwmean}}Perform pairwise comparisons of means{p_end}

{synopt :{helpb qreg}}Quantile regression{p_end}

{synopt :{helpb ratio}}Estimate ratios{p_end}
{synopt :{helpb reg3}}Three-stage estimation for systems of simultaneous equations{p_end}
{synopt :{helpb regress}}Linear regression{p_end}
{synopt :{helpb rocfit}}Parametric ROC models{p_end}
{synopt :{helpb rocreg}}Parametric and nonparametric ROC regression{p_end}
{synopt :{helpb rologit}}Rank-ordered logistic regression{p_end}
{synopt :{helpb rreg}}Robust regression{p_end}

{synopt :{helpb scobit}}Skewed logistic regression{p_end}
{synopt :{helpb sem_command:sem}}Structural equation model estimation command{p_end}
{synopt :{helpb slogit}}Stereotype logistic regression{p_end}
{synopt :{helpb sqreg}}Simultaneous-quantile regression{p_end}
{synopt :{helpb sspace}}State-space models{p_end}
{synopt :{helpb stcox}}Cox proportional hazards model{p_end}
{synopt :{helpb stcrreg}}Competing-risks regression{p_end}
{synopt :{helpb stteffects ipw}}Survival-time inverse-probability weighting{p_end}
{synopt :{helpb stteffects ipwra}}Survival-time inverse-probability-weighted regression adjustment{p_end}
{synopt :{helpb stteffects ra}}Survival-time regression adjustment{p_end}
{synopt :{helpb stteffects wra}}Survival-time weighted regression adjustment{p_end}
{synopt :{helpb streg}}Parametric survival models{p_end}
{synopt :{helpb sureg}}Zellner's seemingly unrelated regression{p_end}
{synopt :{helpb svy estimation:svy:}}Estimation commands for survey data{p_end}
{synopt :{helpb "svy: tabulate oneway"}}One-way tables for survey data{p_end}
{synopt :{helpb "svy: tabulate twoway"}}Two-way tables for survey data{p_end}

{synopt :{helpb teffects aipw}}Treatment effects via augmented inverse-probability weighting{p_end}
{synopt :{helpb teffects ipw}}Treatment effects via probability weighting{p_end}
{synopt :{helpb teffects ipwra}}Treatment effects via inverse-probability-weighted regression adjustment{p_end}
{synopt :{helpb teffects nnmatch}}Treatment effects via nearest-neighbors matching{p_end}
{synopt :{helpb teffects psmatch}}Treatment effects via propensity-score matching{p_end}
{synopt :{helpb teffects ra}}Treatment effects using regression adjustment{p_end}
{synopt :{helpb tnbreg}}Truncated negative binomial regression{p_end}
{synopt :{helpb tobit}}Tobit regression{p_end}
{synopt :{helpb total}}Estimate totals{p_end}
{synopt :{helpb tpoisson}}Truncated Poisson regression{p_end}
{synopt :{helpb truncreg}}Truncated regression{p_end}

{synopt :{helpb ucm}}Unobserved-components model{p_end}

{synopt :{helpb var}}Vector autoregressive models{p_end}
{synopt :{helpb var svar}}Structural vector autoregressive models{p_end}
{synopt :{helpb varbasic}}Fit a simple VAR and graph IRFs and FEVDs{p_end}
{synopt :{helpb vec}}Vector error-correction models{p_end}
{synopt :{helpb vwls}}Variance-weighted least squares{p_end}

{synopt :{helpb xtabond}}Arellano-Bond linear dynamic panel-data estimation{p_end}
{synopt :{helpb xtcloglog}}Random-effects and population-averaged cloglog models{p_end}
{synopt :{helpb xtdpd}}Linear dynamic panel-data estimation{p_end}
{synopt :{helpb xtdpdsys}}Arellano-Bond/Blundell-Bond estimation{p_end}
{synopt :{helpb xtfrontier}}Stochastic frontier models for panel data{p_end}
{synopt :{helpb xtgee}}Fit population-averaged panel-data models by using GEE{p_end}
{synopt :{helpb xtgls}}Fit panel-data models using GLS{p_end}
{synopt :{helpb xthtaylor}}Hausman-Taylor estimator for error-components models{p_end}
{synopt :{helpb xtintreg}}Random-effects interval data regression models{p_end}
{synopt :{helpb xtivreg}}Instrumental variables and two-stage least squares for panel-data models{p_end}
{synopt :{helpb xtlogit}}Fixed-effects, random-effects, and population-averaged logit models{p_end}
{synopt :{helpb xtnbreg}}Fixed-effects, random-effects, and population-averaged negative binomial models{p_end}
{synopt :{helpb xtologit}}Random-effects ordered logistic models{p_end}
{synopt :{helpb xtoprobit}}Random-effects ordered probit models{p_end}
{synopt :{helpb xtpcse}}OLS or Prais-Winsten models with panel-corrected standard errors{p_end}
{synopt :{helpb xtpoisson}}Fixed-effects, random-effects, and population-averaged Poisson models{p_end}
{synopt :{helpb xtprobit}}Random-effects and population-averaged probit models{p_end}
{synopt :{helpb xtrc}}Random-coefficients models{p_end}
{synopt :{helpb xtreg}}Fixed-, between-, and random-effects, and population-averaged linear models{p_end}
{synopt :{helpb xtregar}}Fixed- and random-effects linear models with an AR(1) disturbance{p_end}
{synopt :{helpb xtstreg}}Random-effects parametric survival models{p_end}
{synopt :{helpb xttobit}}Random-effects tobit models{p_end}

{synopt :{helpb zinb}}Zero-inflated negative binomial regression{p_end}
{synopt :{helpb zip}}Zero-inflated Poisson regression{p_end}
{synoptline}
{p2colreset}{...}