{smcl}
{* *! version 1.1.6  03nov2014}{...}
{vieweralsosee "[R] ratio postestimation" "mansection R ratiopostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ratio" "help ratio"}{...}
{viewerjumpto "Postestimation commands" "ratio postestimation##description"}{...}
{viewerjumpto "Examples" "ratio postestimation##examples"}{...}
{title:Title}

{p2colset 5 33 35 2}{...}
{p2col :{manlink R ratio postestimation} {hline 2}}Postestimation tools for ratio{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:ratio}:

{synoptset 11}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_estatvce
INCLUDE help post_svy_estat
INCLUDE help post_estimates
INCLUDE help post_lincom
INCLUDE help post_nlcom
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker examples}{...}
{title:Examples}

    {hline}
    Setup
{phang2}{cmd:. webuse fuel}{p_end}
{phang2}{cmd:. ratio myratio: mpg1/mpg2}{p_end}

{pstd}Test if ratio is significantly different from 1{p_end}
{phang2}{cmd:. test _b[myratio] = 1}

    {hline}
    Setup
{phang2}{cmd:. webuse census2}{p_end}
{phang2}{cmd:. ratio (deathrate: death/pop) (marrate: marriage/pop)}{p_end}

{pstd}Test whether marriage rate equals death rate{p_end}
{phang2}{cmd:. test _b[deathrate] = _b[marrate]}{p_end}
    {hline}
