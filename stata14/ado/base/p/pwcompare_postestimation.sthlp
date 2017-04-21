{smcl}
{* *! version 1.0.5  03nov2014}{...}
{vieweralsosee "[R] pwcompare postestimation" "mansection R pwcomparepostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] pwcompare" "help pwcompare"}{...}
{viewerjumpto "Postestimation commands" "pwcompare postestimation##description"}{...}
{viewerjumpto "Example" "pwcompare postestimation##example"}{...}
{title:Title}

{p2colset 5 37 39 2}{...}
{p2col :{manlink R pwcompare postestimation} {hline 2}}Postestimation tools for
pwcompare{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are 
available after {cmd:pwcompare}{cmd:, post}:

{synoptset 17}{...}
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


{marker example}{...}
{title:Example}

{pstd}Setup for a one-way model{p_end}
{phang2}{cmd:. webuse yield}{p_end}
{phang2}{cmd:. regress yield i.fertilizer}{p_end}

{pstd}Mean yield for each fertilizer{p_end}
{phang2}{cmd:. pwcompare fertilizer, cimargins post}{p_end}

{pstd}Percent improvement in mean yield for fertilizer 2 compared with
fertilizer 1{p_end}
{phang2}
{cmd:. nlcom 100*(_b[2.fertilizer] - _b[1.fertilizer])/_b[1.fertilizer]}{p_end}
