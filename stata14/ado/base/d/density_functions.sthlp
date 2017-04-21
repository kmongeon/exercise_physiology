{smcl}
{* *! version 2.0.5  02may2016}{...}
{vieweralsosee "[FN] Statistical functions" "mansection FN Statisticalfunctions"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] egen" "help egen"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] statistical" "help m4_statistical"}{...}
{viewerjumpto "Functions" "density functions##functions"}{...}
{viewerjumpto "References" "density functions##references"}{...}
{title:Title}

{p 4 22 24 2}{...}
{manlink FN Statistical functions}


{marker functions}{...}
{title:Functions}

{pstd}
The probability distribution and density functions are organized under the
following headings:

{phang2}{help density_functions##beta:Beta and noncentral beta distributions}{p_end}
{phang2}{help density_functions##binomial:Binomial distributions}{p_end}
{phang2}{help density_functions##chisquare:Chi-squared and noncentral chi-squared distributions}{p_end}
{phang2}{help density_functions##dunnett:Dunnett's multiple range distributions}{p_end}
{phang2}{help density_functions##exponential:Exponential distributions}{p_end}
{phang2}{help density_functions##F:F and noncentral F distributions}{p_end}
{phang2}{help density_functions##gamma:Gamma and inverse gamma distributions}{p_end}
{phang2}{help density_functions##hypergeometric:Hypergeometric distributions}{p_end}
{phang2}{help density_functions##igaussian:Inverse Gaussian distributions}{p_end}
{phang2}{help density_functions##logistic:Logistic distributions}{p_end}
{phang2}{help density_functions##negative_binomial:Negative binomial distributions}{p_end}
{phang2}{help density_functions##normal:Normal (Gaussian), log of the normal, binormal, and multivariate normal distributions}{p_end}
{phang2}{help density_functions##poisson:Poisson distributions}{p_end}
{phang2}{help density_functions##t:Student's t and noncentral Student's t distributions}{p_end}
{phang2}{help density_functions##tukey:Tukey's Studentized range distributions}{p_end}
{phang2}{help density_functions##weibull:Weibull distributions}{p_end}
{phang2}{help density_functions##weibullph:Weibull (proportional hazards) distributions}{p_end}
{phang2}{help density_functions##wishart:Wishart and inverse Wishart distributions}{p_end}


{marker beta}{...}
{title:Beta and noncentral beta distributions}

INCLUDE help f_betaden

INCLUDE help f_ibeta

INCLUDE help f_ibetatail

INCLUDE help f_invibeta

INCLUDE help f_invibetatail

INCLUDE help f_nbetaden

INCLUDE help f_nibeta

INCLUDE help f_invnibeta


{marker binomial}{...}
{title:Binomial distributions}

INCLUDE help f_binomialp

INCLUDE help f_binomial

INCLUDE help f_binomialtail

INCLUDE help f_invbinomial

INCLUDE help f_invbinomialtail


{marker chisquare}{...}
{title:Chi-squared and noncentral chi-squared distributions}

INCLUDE help f_chi2den

INCLUDE help f_chi2

INCLUDE help f_chi2tail

INCLUDE help f_invchi2

INCLUDE help f_invchi2tail

INCLUDE help f_nchi2den

INCLUDE help f_nchi2

INCLUDE help f_nchi2tail

INCLUDE help f_invnchi2

INCLUDE help f_invnchi2tail

INCLUDE help f_npnchi2


{marker dunnett}{...}
{title:Dunnett's multiple range distributions}

INCLUDE help f_dunnettprob

INCLUDE help f_invdunnettprob


{marker exponential}{...}
{title:Exponential distributions}

INCLUDE help f_exponentialden

INCLUDE help f_exponential

INCLUDE help f_exponentialtail

INCLUDE help f_invexponential

INCLUDE help f_invexponentialtail


{marker F}{...}
{title:F and noncentral F distributions}

INCLUDE help f_fden

INCLUDE help f_f

INCLUDE help f_ftail

INCLUDE help f_invf

INCLUDE help f_invftail

INCLUDE help f_nfden

INCLUDE help f_nf

INCLUDE help f_nftail

INCLUDE help f_invnf

INCLUDE help f_invnftail

INCLUDE help f_npnf


{marker gamma}{...}
{title:Gamma and inverse gamma distributions}

INCLUDE help f_gammaden

INCLUDE help f_gammap

INCLUDE help f_gammaptail

INCLUDE help f_invgammap

INCLUDE help f_invgammaptail

INCLUDE help f_dgammapda

INCLUDE help f_dgammapdada

INCLUDE help f_dgammapdadx

INCLUDE help f_dgammapdx

INCLUDE help f_dgammapdxdx

INCLUDE help f_lnigammaden


{marker hypergeometric}
{title:Hypergeometric distributions}

INCLUDE help f_hypergeometricp

INCLUDE help f_hypergeometric


{marker igaussian}
{title:Inverse Gaussian distributions}

INCLUDE help f_igaussianden

INCLUDE help f_igaussian

INCLUDE help f_igaussiantail

INCLUDE help f_invigaussian

INCLUDE help f_invigaussiantail

INCLUDE help f_lnigaussianden


{marker logistic}{...}
{title:Logistic distributions}

INCLUDE help f_logisticden

INCLUDE help f_logistic

INCLUDE help f_logistictail

INCLUDE help f_invlogistic

INCLUDE help f_invlogistictail


{marker negative_binomial}{...}
{title:Negative binomial distributions}

INCLUDE help f_nbinomialp

INCLUDE help f_nbinomial

INCLUDE help f_nbinomialtail

INCLUDE help f_invnbinomial

INCLUDE help f_invnbinomialtail


{marker normal}{...}
{title:Normal (Gaussian), log of the normal, binormal, and multivariate normal distributions}

INCLUDE help f_normalden

INCLUDE help f_normal

INCLUDE help f_invnormal

INCLUDE help f_lnnormalden

INCLUDE help f_lnnormal

INCLUDE help f_binormal

INCLUDE help f_lnmvnormalden


{marker poisson}{...}
{title:Poisson distributions}

INCLUDE help f_poissonp

INCLUDE help f_poisson

INCLUDE help f_poissontail

INCLUDE help f_invpoisson

INCLUDE help f_invpoissontail


{marker t}{...}
{title:Student's t and noncentral Student's t distributions}

INCLUDE help f_tden

INCLUDE help f_t

INCLUDE help f_ttail

INCLUDE help f_invt

INCLUDE help f_invttail

INCLUDE help f_invnt

INCLUDE help f_invnttail

INCLUDE help f_ntden

INCLUDE help f_nt

INCLUDE help f_nttail

INCLUDE help f_npnt


{marker tukey}{...}
{title:Tukey's Studentized range distributions}

INCLUDE help f_tukeyprob

INCLUDE help f_invtukeyprob


{marker weibull}{...}
{title:Weibull distributions}

INCLUDE help f_weibullden

INCLUDE help f_weibull

INCLUDE help f_weibulltail

INCLUDE help f_invweibull

INCLUDE help f_invweibulltail


{marker weibullph}{...}
{title:Weibull (proportional hazards) distributions}

INCLUDE help f_weibullphden

INCLUDE help f_weibullph

INCLUDE help f_weibullphtail

INCLUDE help f_invweibullph

INCLUDE help f_invweibullphtail


{marker wishart}{...}
{title:Wishart and inverse Wishart distributions}

INCLUDE help f_lnwishartden

INCLUDE help f_lniwishartden


{marker references}{...}
{title:References}

{marker JKB1995}{...}
{phang}
Johnson, N. L., S. Kotz, and N. Balakrishnan.  1995.
{it:Continuous Univariate Distributions, Vol. 2}.  2nd ed.  New York: Wiley.

{marker M1981}{...}
{phang}
Miller, R. G., Jr.  1981.
{it:Simultaneous Statistical Inference}.  2nd ed.  New York: Springer.
{p_end}
