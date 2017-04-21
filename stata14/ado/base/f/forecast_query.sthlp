{smcl}
{* *! version 1.0.1  15apr2013}{...}
{viewerdialog forecast "dialog forecast"}{...}
{vieweralsosee "[TS] forecast query" "mansection TS forecastquery"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] forecast" "help forecast"}{...}
{vieweralsosee "[TS] forecast describe" "help forecast describe"}{...}
{viewerjumpto "Syntax" "forecast_query##syntax"}{...}
{viewerjumpto "Description" "forecast_query##description"}{...}
{viewerjumpto "Examples" "forecast_query##examples"}{...}
{viewerjumpto "Stored results" "forecast_query##results"}{...}
{title:Title}

{p2colset 5 28 30 2}{...}
{p2col :{manlink TS forecast query} {hline 2}}Check whether a forecast model
has been started{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmdab:fore:cast} {cmdab:q:uery}  


{marker description}{...}
{title:Description}

{pstd}
{cmd:forecast query} issues a message indicating whether a forecast model has
been started.


{marker examples}{...}
{title:Examples}

{pstd}Check if there are any forecast models in memory{p_end}
{phang2}{cmd:. forecast query}

{pstd}Create a forecast model named {cmd:fcmodel}{p_end}
{phang2}{cmd:. forecast create fcmodel}

{pstd}Recheck for forecast models in memory{p_end}
{phang2}{cmd:. forecast query}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:forecast query} stores the following in {cmd:r()}:

{synoptset 14 tabbed}{...}
{p2col 5 14 18 2: Scalars}{p_end}
{synopt:{cmd:r(found)}}{cmd:1} if model started; {cmd:0} otherwise{p_end}

{p2col 5 14 18 2: Macros}{p_end}
{synopt:{cmd:r(name)}}model name{p_end}
{p2colreset}{...}
