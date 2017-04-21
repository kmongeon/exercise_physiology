{smcl}
{* *! version 1.0.3  04mar2015}{...}
{viewerdialog tebalance "dialog tebalance"}{...}
{vieweralsosee "[TE] tebalance" "mansection TE tebalance"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] tebalance summarize" "help tebalance summarize"}{...}
{vieweralsosee "[TE] tebalance overid" "help tebalance overid"}{...}
{vieweralsosee "[TE] tebalance density" "help tebalance density"}{...}
{vieweralsosee "[TE] tebalance box" "help tebalance box"}{...}
{vieweralsosee "[TE] teffects" "help teffects"}{...}
{vieweralsosee "[TE] stteffects" "help stteffects"}{...}
{viewerjumpto "Syntax" "tebalance##syntax"}{...}
{viewerjumpto "Description" "tebalance##description"}{...}
{title:Title}

{p2colset 5 23 25 2}{...}
{p2col :{manlink TE tebalance} {hline 2}}Check balance after teffects or stteffects estimation{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:tebalance} {it:subcommand} ... [{cmd:,} {it:options}]

{synoptset 16}{...}
{synopthdr:subcommand}
{synoptline}
{synopt :{helpb tebalance summarize:summarize}}compare means and variances in
raw and balanced data{p_end}
{synopt :{helpb tebalance overid:overid}}overidentification test{p_end}
{synopt :{helpb tebalance density:density}}kernel density plots for raw and balanced data{p_end}
{synopt :{helpb tebalance box:box}}box plots for each treatment level for
balanced data{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
The {cmd:tebalance} postestimation commands produce diagnostic
statistics, test statistics, and diagnostic plots to assess whether a
{helpb teffects} or {helpb stteffects} command balanced the covariates
over treatment levels.
{p_end}
