{smcl}
{* *! version 1.3.7  16may2016}{...}
{vieweralsosee "[M-4] statistical" "mansection M-4 statistical"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] intro" "help m4_intro"}{...}
{viewerjumpto "Contents" "m4_statistical##contents"}{...}
{viewerjumpto "Description" "m4_statistical##description"}{...}
{viewerjumpto "Remarks" "m4_statistical##remarks"}{...}
{title:Title}

{phang}
{manlink M-4 statistical} {hline 2} Statistical functions


{marker contents}{...}
{title:Contents}

{col 5}   [M-5]
{col 5}Manual entry{col 18}Function{col 39}Purpose
{col 5}{hline}

{col 5}   {c TLC}{hline 23}{c TRC}
{col 5}{hline 3}{c RT}{it: Pseudorandom variates }{c LT}{hline}
{col 5}   {c BLC}{hline 23}{c BRC}

{col 5}{bf:{help mf_runiform:runiform()}}{...}
{col 18}{cmd:runiform()}{...}
{col 39}uniform random variates
{col 18}{cmd:rnormal()}{...}
{col 39}normal (Gaussian) random variates
{col 18}{cmd:rseed()}{...}
{col 39}obtain or set the random-variate seed
{col 18}{cmd:rngstate()}{...}
{col 39}obtain or set the random-number 
{col 41}generator state
{col 18}{hline 10}
{col 18}{cmd:rbeta()}{...}
{col 39}beta random variates
{col 18}{cmd:rbinomial()}{...}
{col 39}binomial random variates
{col 18}{cmd:rchi2()}{...}
{col 39}chi-squared random variates
{col 18}{cmd:rdiscrete()}{...}
{col 39}discrete random variates
{col 18}{cmd:rexponential()}{...}
{col 39}exponential random variates
{col 18}{cmd:rgamma()}{...}
{col 39}gamma random variates
{col 18}{cmd:rhypergeometric()}{...}
{col 39}hypergeometric random variates
{col 18}{cmd:rigaussian()}{...}
{col 39}inverse Gaussian random variates
{col 18}{cmd:rlogistic()}{...}
{col 39}logistic random variates
{col 18}{cmd:rnbinomial()}{...}
{col 39}negative binomial random variates
{col 18}{cmd:rpoisson()}{...}
{col 39}Poisson random variates
{col 18}{cmd:rt()}{...}
{col 39}Student's t random variates
{col 18}{cmd:runiformint()}{...}
{col 39}uniform random integer variates
{col 18}{cmd:rweibull()}{...}
{col 39}Weibull random variates
{col 18}{cmd:rweibullph()}{...}
{col 39}Weibull (proportional hazards)
{col 41}random variates

{col 5}   {c TLC}{hline 34}{c TRC}
{col 5}{hline 3}{c RT}{it: Means, variances, & correlations }{c LT}{hline}
{col 5}   {c BLC}{hline 34}{c BRC}

{col 5}{bf:{help mf_mean:mean()}}{...}
{col 18}{cmd:mean()}{...}
{col 39}mean 
{col 18}{cmd:variance()}{...}
{col 39}variance 
{col 18}{cmd:quadvariance()}{...}
{col 39}quad-precision variance 
{col 18}{cmd:meanvariance()}{...}
{col 39}mean and variance
{col 18}{cmd:quadmeanvariance()}{...}
{col 39}quad-precision mean and variance
{col 18}{cmd:correlation()}{...}
{col 39}correlation
{col 18}{cmd:quadcorrelation()}{...}
{col 39}quad-precision correlation

{col 5}{bf:{help mf_cross:cross()}}{...}
{col 18}{cmd:cross()}{...}
{col 39}{it:X}'{it:X}, {it:X}'{it:Z}, {it:X}'diag({it:w}){it:Z}, etc.

{col 5}{bf:{help mf_corr:corr()}}{...}
{col 18}{cmd:corr()}{...}
{col 39}make correlation from variance matrix 

{col 5}{bf:{help mf_crossdev:crossdev()}}{...}
{col 18}{cmd:crossdev()}{...}
{col 39}({it:X}:-{it:x})'({it:X}:-{it:x}), ({it:X}:-{it:x})'({it:Z}:-{it:z}), etc.

{col 5}{bf:{help mf_quadcross:quadcross()}}{...}
{col 18}{cmd:quadcross()}{...}
{col 39}quad-precision {cmd:cross()}
{col 18}{cmd:quadcrossdev()}{...}
{col 39}quad-precision {cmd:crossdev()}

{col 5}   {c TLC}{hline 26}{c TRC}
{col 5}{hline 3}{c RT}{it: Factorial & combinations }{c LT}{hline}
{col 5}   {c BLC}{hline 26}{c BRC}

{col 5}{bf:{help mf_factorial:factorial()}}{...}
{col 18}{cmd:factorial()}{...}
{col 39}factorial
{col 18}{cmd:lnfactorial()}{...}
{col 39}natural logarithm of factorial
{col 18}{cmd:gamma()}{...}
{col 39}gamma function
{col 18}{cmd:lngamma()}{...}
{col 39}natural logarithm of gamma function
{col 18}{cmd:digamma()}{...}
{col 39}derivative of {cmd:lngamma()}
{col 18}{cmd:trigamma()}{...}
{col 39}second derivative of {cmd:lngamma()}

{col 5}{bf:{help mf_comb:comb()}}{...}
{col 18}{cmd:comb()}{...}
{col 39}combinatorial function {it:n} choose {it:k}

{col 5}{bf:{help mf_cvpermute:cvpermute()}}{...}
{col 18}{cmd:cvpermutesetup()}{...}
{col 39}permutation setup
{col 18}{cmd:cvpermute()}{...}
{col 39}return permutations, one at a time

{col 5}   {c TLC}{hline 27}{c TRC}
{col 5}{hline 3}{c RT}{it: Densities & distributions }{c LT}{hline}
{col 5}   {c BLC}{hline 27}{c BRC}

{col 5}{bf:{help mf_normal:normal()}}{...}
{col 18}{cmd:normalden()}{...}
{col 39}normal density
{col 18}{cmd:normal()}{...}
{col 39}cumulative normal
{col 18}{cmd:invnormal()}{...}
{col 39}inverse cumulative normal
{col 18}{cmd:lnnormalden()}{...}
{col 39}logarithm of the normal density
{col 18}{cmd:lnnormal()}{...}
{col 39}logarithm of the cumulative normal
{col 18}{hline 10}
{col 18}{cmd:binormal()}{...}
{col 39}cumulative binormal
{col 18}{hline 10}
{col 18}{cmd:lnmvnormalden()}{...}
{col 39}logarithm of the multivariate normal
{col 39}  density
{col 18}{hline 10}
{col 18}{cmd:betaden()}{...}
{col 39}beta density
{col 18}{cmd:ibeta()}{...}
{col 39}cumulative beta;
{col 39}  a.k.a. incomplete beta function
{col 18}{cmd:ibetatail()}{...}
{col 39}reverse cumulative beta
{col 18}{cmd:invibeta()}{...}
{col 39}inverse cumulative beta
{col 18}{cmd:invibetatail()}{...}
{col 39}inverse reverse cumulative beta
{col 18}{hline 10}
{col 18}{cmd:binomialp()}{...}
{col 39}binomial probability
{col 18}{cmd:binomial()}{...}
{col 39}cumulative binomial
{col 18}{cmd:binomialtail()}{...}
{col 39}reverse cumulative binomial
{col 18}{cmd:invbinomial()}{...}
{col 39}inverse cumulative binomial
{col 18}{cmd:invbinomialtail()}{...}
{col 39}inverse reverse cumulative binomial
{col 18}{hline 10}
{col 18}{cmd:chi2()}{...}
{col 39}cumulative chi-squared
{col 18}{cmd:chi2den()}{...}
{col 39}chi-squared density
{col 18}{cmd:chi2tail()}{...}
{col 39}reverse cumulative chi-squared
{col 18}{cmd:invchi2()}{...}
{col 39}inverse cumulative chi-squared
{col 18}{cmd:invchi2tail()}{...}
{col 39}inverse reverse cumulative chi-squared
{col 18}{hline 10}
{col 18}{cmd:dunnettprob()}{...}
{col 39}cumulative multiple range;
{col 39}  used in Dunnett's multiple comparison
{col 18}{cmd:invdunnettprob()}{...}
{col 39}inverse cumulative multiple range;
{col 39}  used in Dunnett's multiple comparison
{col 18}{hline 10}
{col 18}{cmd:exponentialden()}{...}
{col 39}exponential density
{col 18}{cmd:exponential()}{...}
{col 39}cumulative exponential
{col 18}{cmd:exponentialtail()}{...}
{col 39}reverse cumulative exponential
{col 18}{cmd:invexponential()}{...}
{col 39}inverse cumulative exponential
{col 18}{cmd:invexponentialtail()}{...}
{col 39}inverse reverse cumulative exponential
{col 18}{hline 10}
{col 18}{cmd:Fden()}{...}
{col 39}F density
{col 18}{cmd:F()}{...}
{col 39}cumulative F
{col 18}{cmd:Ftail()}{...}
{col 39}reverse cumulative F
{col 18}{cmd:invF()}{...}
{col 39}inverse cumulative F
{col 18}{cmd:invFtail()}{...}
{col 39}inverse reverse cumulative F
{col 18}{hline 10}
{col 18}{cmd:gammaden()}{...}
{col 39}gamma density
{col 18}{cmd:gammap()}{...}
{col 39}cumulative gamma;
{col 39}  a.k.a. incomplete gamma function
{col 18}{cmd:gammaptail()}{...}
{col 39}reverse cumulative gamma
{col 18}{cmd:invgammap()}{...}
{col 39}inverse cumulative gamma
{col 18}{cmd:invgammaptail()}{...}
{col 39}inverse reverse cumulative gamma
{col 18}{cmd:dgammapda()}{...}
{col 39}{it:dg/da}
{col 18}{cmd:dgammapdx()}{...}
{col 39}{it:dg/dx}
{col 18}{cmd:dgammapdada()}{...}
{col 39}{it:d2g/da2}
{col 18}{cmd:dgammapdadx()}{...}
{col 39}{it:d2g/dadx}
{col 18}{cmd:dgammapdxdx()}{...}
{col 39}{it:d2g/dx2}
{col 18}{cmd:lnigammaden()}{...}
{col 39}logarithm of the inverse gamma density
{col 18}{hline 10}
{col 18}{cmd:hypergeometricp()}{...}
{col 39}hypergeometric probability
{col 18}{cmd:hypergeometric()}{...}
{col 39}cumulative hypergeometric
{col 18}{hline 10}
{col 18}{cmd:igaussianden()}{...}
{col 39}inverse Gaussian density
{col 18}{cmd:igaussian()}{...}
{col 39}cumulative inverse Gaussian
{col 18}{cmd:igaussiantail()}{...}
{col 39}reverse cumulative inverse Gaussian 
{col 18}{cmd:invigaussian()}{...}
{col 39}inverse cumulative of inverse Gaussian 
{col 18}{cmd:invigaussiantail()}{...}
{col 39}inverse reverse cumulative of inverse
{col 39}  Gaussian
{col 18}{cmd:lnigaussianden()}{...}
{col 39}logarithm of the inverse Gaussian density
{col 18}{hline 10}
{col 18}{cmd:logisticden()}{...}
{col 39}logistic density
{col 18}{cmd:logistic()}{...}
{col 39}cumulative logistic
{col 18}{cmd:logistictail()}{...}
{col 39}reverse cumulative logistic
{col 18}{cmd:invlogistic()}{...}
{col 39}inverse cumulative logistic
{col 18}{cmd:invlogistictail()}{...}
{col 39}inverse reverse cumulative logistic
{col 18}{hline 10}
{col 18}{cmd:nbetaden()}{...}
{col 39}noncentral beta density
{col 18}{cmd:nibeta()}{...}
{col 39}cumulative noncentral beta
{col 18}{cmd:invnibeta()}{...}
{col 39}inverse cumulative noncentral beta
{col 18}{hline 10}
{col 18}{cmd:nbinomialp()}{...}
{col 39}negative binomial probability
{col 18}{cmd:nbinomial()}{...}
{col 39}cumulative negative binomial
{col 18}{cmd:nbinomialtail()}{...}
{col 39}reverse cumulative negative binomial
{col 18}{cmd:invnbinomial()}{...}
{col 39}inverse cumulative negative binomial
{col 18}{cmd:invnbinomialtail()}{...}
{col 39}inverse reverse cumulative negative
{col 39}  binomial
{col 18}{hline 10}
{col 18}{cmd:nchi2()}{...}
{col 39}cumulative noncentral chi-squared
{col 18}{cmd:nchi2den()}{...}
{col 39}noncentral chi-squared density
{col 18}{cmd:nchi2tail()}{...}
{col 39}reverse cumulative noncentral chi-squared
{col 18}{cmd:invnchi2()}{...}
{col 39}inverse cumulative noncentral chi-squared
{col 18}{cmd:invnchi2tail()}{...}
{col 39}inverse reverse cumulative noncentral
{col 39}  chi-squared
{col 18}{cmd:npnchi2()}{...}
{col 39}noncentrality parameter of {cmd:nchi2()}
{col 18}{hline 10}
{col 18}{cmd:nF()}{...}
{col 39}cumulative noncentral F
{col 18}{cmd:nFden()}{...}
{col 39}noncentral F density
{col 18}{cmd:nFtail()}{...}
{col 39}reverse cumulative noncentral F
{col 18}{cmd:invnF()}{...}
{col 39}inverse cumulative noncentral F
{col 18}{cmd:invnFtail()}{...}
{col 39}inverse reverse cumulative noncentral F
{col 18}{cmd:npnF()}{...}
{col 39}noncentrality parameter of {cmd:nF()}
{col 18}{hline 10}
{col 18}{cmd:nt()}{...}
{col 39}cumulative noncentral Student's t
{col 18}{cmd:ntden()}{...}
{col 39}noncentral Student's t density
{col 18}{cmd:nttail()}{...}
{col 39}reverse cumulative noncentral t
{col 18}{cmd:invnt()}{...}
{col 39}inverse cumulative noncentral t
{col 18}{cmd:invnttail()}{...}
{col 39}inverse reverse cumulative noncentral t
{col 18}{cmd:npnt()}{...}
{col 39}noncentrality parameter of {cmd:nt()}
{col 18}{hline 10}
{col 18}{cmd:poissonp()}{...}
{col 39}Poisson probability
{col 18}{cmd:poisson()}{...}
{col 39}cumulative Poisson
{col 18}{cmd:poissontail()}{...}
{col 39}reverse cumulative Poisson
{col 18}{cmd:invpoisson()}{...}
{col 39}inverse cumulative Poisson
{col 18}{cmd:invpoissontail()}{...}
{col 39}inverse reverse cumulative Poisson
{col 18}{hline 10}
{col 18}{cmd:t()}{...}
{col 39}cumulative Student's t
{col 18}{cmd:tden()}{...}
{col 39}Student's t density
{col 18}{cmd:ttail()}{...}
{col 39}reverse cumulative Student's t
{col 18}{cmd:invt()}{...}
{col 39}inverse cumulative Student's t
{col 18}{cmd:invttail()}{...}
{col 39}inverse reverse cumulative Student's t
{col 18}{hline 10}
{col 18}{cmd:tukeyprob()}{...}
{col 39}cumulative multiple range;
{col 39}  used in Tukey's multiple comparison
{col 18}{cmd:invtukeyprob()}{...}
{col 39}inverse cumulative multiple range;
{col 39}  used in Tukey's multiple comparison
{col 18}{hline 10}
{col 18}{cmd:weibullden()}{...}
{col 39}Weibull density
{col 18}{cmd:weibull}{...}
{col 39}cumulative Weibull
{col 18}{cmd:weibulltail()}{...}
{col 39}reverse cumulative Weibull
{col 18}{cmd:invweibull()}{...}
{col 39}inverse cumulative Weibull
{col 18}{cmd:invweibulltail()}{...}
{col 39}inverse reverse cumulative Weibull
{col 18}{hline 10}
{col 18}{cmd:weibullphden()}{...}
{col 39}Weibull (proportional hazards) density
{col 18}{cmd:weibullph}{...}
{col 39}cumulative Weibull (proportional hazards)
{col 18}{cmd:weibullphtail()}{...}
{col 39}reverse cumulative Weibull (proportional
{col 41}hazards)
{col 18}{cmd:invweibullph()}{...}
{col 39}inverse cumulative Weibull (proportional
{col 41}hazards)
{col 18}{cmd:invweibullphtail()}{...}
{col 39}inverse reverse cumulative Weibull
{col 41}(proportional hazards)
{col 18}{hline 10}
{col 18}{cmd:lnwishartden()}{...}
{col 39}logarithm of the Wishart density
{col 18}{cmd:lniwishartden()}{...}
{col 39}logarithm of the inverse Wishart density

{col 5}   {c TLC}{hline 29}{c TRC}
{col 5}{hline 3}{c RT}{it: Maximization & minimization }{c LT}{hline}
{col 5}   {c BLC}{hline 29}{c BRC}

{col 5}{bf:{help mf_optimize:optimize()}}{...}
{col 18}{cmd:optimize()}{...}
{col 44}function maximization & minimization
{col 18}{cmd:optimize_evaluate()}{...}
{col 44}evaluate function at initial values
{col 18}{cmd:optimize_init()}{...}
{col 44}begin optimization
{col 18}{cmd:optimize_init_}{it:*}{cmd:()}{...}
{col 44}set details
{col 18}{cmd:optimize_result_}{it:*}{cmd:()}{...}
{col 44}access results
{col 18}{cmd:optimize_query()}{...}
{col 44}report settings

{col 5}{bf:{help mf_moptimize:moptimize()}}{...}
{col 18}{cmd:moptimize()}{...}
{col 44}function optimization
{col 18}{cmd:moptimize_evaluate()}{...}
{col 44}evaluate function at initial values
{col 18}{cmd:moptimize_init()}{...}
{col 44}begin setup of optimization problem
{col 18}{cmd:moptimize_init_}{it:*}{cmd:()}{...}
{col 44}set details 
{col 18}{cmd:moptimize_result_}{it:*}{cmd:()}{...}
{col 44}access {cmd:moptimize()} results
{col 18}{cmd:moptimize_ado_cleanup()}{...}
{col 44}perform cleanup after ado 
{col 18}{cmd:moptimize_query()}{...}
{col 44}report settings
{col 18}{cmd:moptimize_util_}{it:*}{cmd:()}{...}
{col 44}utility functions for writing
{col 44}  evaluators and processing results

{col 5}   {c TLC}{hline 25}{c TRC}
{col 5}{hline 3}{c RT}{it: Logits, odds, & related }{c LT}{hline}
{col 5}   {c BLC}{hline 25}{c BRC}

{col 5}{bf:{help mf_logit:logit()}}{...}
{col 18}{cmd:logit()}{...}
{col 39}log of the odds ratio
{col 18}{cmd:invlogit()}{...}
{col 39}inverse log of the odds ratio
{col 18}{cmd:cloglog()}{...}
{col 39}complementary log-log
{col 18}{cmd:invcloglog()}{...}
{col 39}inverse complementary log-log

{col 5}   {c TLC}{hline 21}{c TRC}
{col 5}{hline 3}{c RT}{it: Multivariate normal }{c LT}{hline}
{col 5}   {c BLC}{hline 21}{c BRC}

{col 5}{bf:{help mf_ghk:ghk()}}{...}
{col 18}{cmd:ghk()}{...}
{col 39}GHK multivariate normal (MVN) simulator
{col 18}{cmd:ghk_init()}{...}
{col 39}GHK MVN initialization
{col 18}{cmd:ghk_init_}{it:*}{cmd:()}{...}
{col 39}set details
{col 18}{cmd:ghk()}{...}
{col 39}perform simulation
{col 18}{cmd:ghk_query_npts()}{...}
{col 39}return number of simulation points

{col 5}{bf:{help mf_ghkfast:ghkfast()}}{...}
{col 18}{cmd:ghkfast()}{...}
{col 39}GHK MVN simulator
{col 18}{cmd:ghkfast_init()}{...}
{col 39}GHK MVN initialization
{col 18}{cmd:ghkfast_init_}{it:*}{cmd:()}{...}
{col 39}set details
{col 18}{cmd:ghkfast()}{...}
{col 39}perform simulation
{col 18}{cmd:ghkfast_i()}{...}
{col 39}results for the ith observation
{col 18}{cmd:ghk_query_}{it:*}{cmd:()}{...}
{col 39}display settings

{col 5}{hline}


{marker description}{...}
{title:Description}

{p 4 4 2}
The above functions are statistical, probabilistic, or designed to work 
with data matrices.


{marker remarks}{...}
{title:Remarks}

{p2colset 8 29 32 2}{...}
{p 4 4 2}
Concerning data matrices, see 

{col 8}{...}
{bf:{help m4_stata:[M-4] stata}}{...}
{col 30}Stata interface functions

{p 4 4 2}
and especially 

{col 8}{...}
{bf:{help mf_st_data:[M-5] st_data()}}{...}
{col 30}Load copy of current Stata dataset
{col 8}{...}
{p2col:{bf:{help mf_st_view:[M-5] st_view()}}}{...}
 Make matrix that is a view onto current Stata dataset

{p 4 4 2}
For other mathematical functions, see

{col 8}{...}
{bf:{help m4_matrix:[M-4] matrix}}{...}
{col 30}Matrix mathematical functions

{col 8}{...}
{bf:{help m4_scalar:[M-4] scalar}}{...}
{col 30}Scalar mathematical functions

{col 8}{...}
{bf:{help m4_mathematical:[M-4] mathematical}}{...}
{col 30}Important mathematical functions
{p2colreset}{...}
