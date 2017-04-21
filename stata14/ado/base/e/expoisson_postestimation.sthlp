{smcl}
{* *! version 1.2.1  02mar2015}{...}
{viewerdialog estat "dialog expoisson_estat"}{...}
{vieweralsosee "[R] expoisson postestimation" "mansection R expoissonpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] expoisson" "help expoisson"}{...}
{viewerjumpto "Postestimation commands" "expoisson postestimation##description"}{...}
{viewerjumpto "estat" "expoisson postestimation##syntax_estat_se"}{...}
{viewerjumpto "Examples" "expoisson postestimation##examples"}{...}
{title:Title}

{p2colset 5 37 39 2}{...}
{p2col :{manlink R expoisson postestimation} {hline 2}}Postestimation tools for
expoisson{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation command is of special interest after
{cmd:expoisson}:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb expoisson postestimation##estatse:estat se}}report
coefficients or IRRs and their asymptotic standard errors {p_end}
{synoptline}
{p2colreset}{...}

{pstd}
The following standard postestimation commands are also available:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_estatsum
INCLUDE help post_estimates
{synoptline}
{p2colreset}{...}


{marker syntax_estat_se}{...}
{marker estatse}{...}
{title:Syntax for estat}

{p 8 14 2}
{cmd:estat} {opt se}  
[{cmd:,} {cmd:irr}]


INCLUDE help menu_estat


{marker des_estat}{...}
{title:Description for estat}

{pstd}
{cmd:estat se} reports regression coefficients or incidence-rate asymptotic
standard errors.  The estimates are stored in the matrix {cmd:r(estimates)}.


{marker option_estat_se}{...}
{title:Option for estat se}

{phang}
{cmd:irr} requests that the incidence-rate ratios and their asymptotic standard
errors be reported.  The default is to report the coefficients and their
asymptotic standard errors.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse smokes}

{pstd}Perform exact Poisson regression of {cmd:cases} on {cmd:smokes} using
exposure {cmd:peryrs}{p_end}
{phang2}{cmd:. expoisson cases smokes, exposure(peryrs) irr}{p_end}

{pstd}Report the estimated incidence rates and their asymptotic standard 
errors{p_end}
{phang2}{cmd:. estat se, irr}{p_end}
