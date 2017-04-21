{smcl}
{* *! version 1.0.0  15feb2013}{...}
{viewerdialog forecast "dialog forecast"}{...}
{vieweralsosee "[TS] forecast clear" "mansection TS forecastclear"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] forecast" "help forecast"}{...}
{vieweralsosee "[TS] forecast create" "help forecast create"}{...}
{viewerjumpto "Syntax" "forecast_clear##syntax"}{...}
{viewerjumpto "Description" "forecast_clear##description"}{...}
{title:Title}

{p2colset 5 28 30 2}{...}
{p2col :{manlink TS forecast clear} {hline 2}}Clear current model from memory{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmdab:fore:cast} {cmd: clear}


{marker description}{...}
{title:Description}

{pstd}
{cmd:forecast} {cmd:clear} removes the current forecast model from memory.
{p_end}
