{smcl}
{* *! version 1.0.0  12mar2015}{...}
{vieweralsosee "[BAYES] bayesstats" "mansection BAYES bayesstats"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayesmh postestimation" "help bayesmh postestimation"}{...}
{vieweralsosee "[BAYES] bayesstats bayesstats ess" "help bayesstats ess"}{...}
{vieweralsosee "[BAYES] bayesstats summary" "help bayesstats summary"}{...}
{vieweralsosee "[BAYES] bayesstats ic" "help bayesstats ic"}{...}
{title:Title}

{p2colset 5 27 29 2}{...}
{p2col :{manlink BAYES bayesstats} {hline 2}}Bayesian statistics after
bayesmh{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
The following subcommands are available with {cmd:bayesstats} after
{cmd:bayesmh}:

{synoptset 20}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb bayesstats ess}}effective sample sizes and related statistics{p_end}
{synopt :{helpb bayesstats summary}}Bayesian summary statistics for model parameters and their functions{p_end}
{synopt :{helpb bayesstats ic}}Bayesian information criteria and Bayes factors{p_end}
{synoptline}
{p2colreset}{...}
