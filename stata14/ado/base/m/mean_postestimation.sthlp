{smcl}
{* *! version 1.2.3  04mar2015}{...}
{vieweralsosee "[R] mean postestimation" "mansection R meanpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] mean" "help mean"}{...}
{viewerjumpto "Postestimation commands" "mean postestimation##description"}{...}
{viewerjumpto "Example" "mean postestimation##example"}{...}
{title:Title}

{p2colset 5 32 34 2}{...}
{p2col :{manlink R mean postestimation} {hline 2}}Postestimation tools for mean{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:mean}:

{synoptset 11}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_estatvce
INCLUDE help post_svy_estat
INCLUDE help post_estimates
INCLUDE help post_hausman
INCLUDE help post_lincom
INCLUDE help post_nlcom
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse fuel}{p_end}
{phang2}{cmd:. mean mpg1 mpg2}{p_end}

{pstd}Test if means are equal (equivalent to a two-sample paired
t-test){p_end}
{phang2}{cmd:. test mpg1 = mpg2}{p_end}
