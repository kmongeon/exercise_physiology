{smcl}
{* *! version 1.1.6  14nov2014}{...}
{viewerdialog stdescribe "dialog stdescribe"}{...}
{vieweralsosee "[ST] stdescribe" "mansection ST stdescribe"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] stset" "help stset"}{...}
{vieweralsosee "[ST] stsum" "help stsum"}{...}
{vieweralsosee "[ST] stvary" "help stvary"}{...}
{viewerjumpto "Syntax" "stdescribe##syntax"}{...}
{viewerjumpto "Menu" "stdescribe##menu"}{...}
{viewerjumpto "Description" "stdescribe##description"}{...}
{viewerjumpto "Options" "stdescribe##options"}{...}
{viewerjumpto "Examples" "stdescribe##examples"}{...}
{viewerjumpto "Video example" "stdescribe##video"}{...}
{viewerjumpto "Stored results" "stdescribe##results"}{...}
{title:Title}

{p2colset 5 24 26 2}{...}
{p2col :{manlink ST stdescribe} {hline 2}}Describe survival-time data{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:stdescribe} {ifin} [{cmd:,} {opt w:eight} {opt nosh:ow}]

{pstd}
You must {cmd:stset} your data before using {cmd:stdescribe};  see
{manhelp stset ST}.

{pstd}
{opt fweight}s, {opt iweight}s, and {opt pweight}s may be specified
using {cmd:stset}; see {manhelp stset ST}.

{pstd}
{cmd:by} is allowed; see {manhelp by D}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Survival analysis > Summary statistics, tests, and tables >}
     {bf:Describe survival-time data}


{marker description}{...}
{title:Description}

{pstd}
{cmd:stdescribe} reports the characteristics of a survival-time dataset.
The report includes the number of subjects and per-subject summary statistics
related to the number of records, entry and exit times, gaps in the data, time
at risk, and number of failures.

{pstd}
{cmd:stdescribe} can be used with single- or multiple-record and single- or 
multiple-failure st data.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt weight} specifies that the summary use weighted rather than unweighted 
statistics.  {opt weight} does nothing unless you specified a weight when you 
{cmd:stset} the data.  The {opt weight} option and the ability to ignore 
weights are unique to {cmd:stdescribe}.  The purpose of {cmd:stdescribe} is to
describe the data in a computer sense -- the number of records,
etc. -- and for that purpose, the weights are best ignored.

{phang}
{opt noshow} prevents {cmd:stdescribe} from showing the key st variables.  This 
option is seldom used because most people type {cmd:stset, show} or 
{cmd:stset, noshow} to set whether they want to see these variables mentioned 
at the top of the output of every st command; see {manhelp stset ST}.


{marker examples}{...}
{title:Example with single-record survival data}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse page2}

{pstd}Describe survival-time data{p_end}
{phang2}{cmd:. stdescribe}


{title:Example with multiple-record survival data}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse stan3}

{pstd}Prevent other st commands from showing st setting information{p_end}
{phang2}{cmd:. stset, noshow}

{pstd}Describe survival-time data{p_end}
{phang2}{cmd:. stdescribe}

{pstd}Describe survival-time data for patients not receiving a
transplant{p_end}
{phang2}{cmd:. stdescribe if !transplant}

{pstd}Describe survival-time data for patients receiving a transplant{p_end}
{phang2}{cmd:. stdescribe if transplant}


{title:Example with multiple-failure data}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse mfail2}

{pstd}Describe survival-time data{p_end}
{phang2}{cmd:. stdescribe}


{marker video}{...}
{title:Video example}

{phang}
{browse "https://www.youtube.com/watch?v=zw8UvYdI8y8":How to describe and summarize survival data}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:stdescribe} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N_sub)}}number of subjects{p_end}
{synopt:{cmd:r(N_total)}}number of records{p_end}
{synopt:{cmd:r(N_min)}}minimum number of records{p_end}
{synopt:{cmd:r(N_mean)}}mean number of records{p_end}
{synopt:{cmd:r(N_med)}}median number of records{p_end}
{synopt:{cmd:r(N_max)}}maximum number of records{p_end}
{synopt:{cmd:r(t0_min)}}minimum first entry time{p_end}
{synopt:{cmd:r(t0_mean)}}mean first entry time{p_end}
{synopt:{cmd:r(t0_med)}}median first entry time{p_end}
{synopt:{cmd:r(t0_max)}}maximum first entry time{p_end}
{synopt:{cmd:r(t1_min)}}minimum final exit time{p_end}
{synopt:{cmd:r(t1_mean)}}mean final exit time{p_end}
{synopt:{cmd:r(t1_med)}}median final exit time{p_end}
{synopt:{cmd:r(t1_max)}}maximum final exit time{p_end}
{synopt:{cmd:r(N_gap)}}number of subjects with gap{p_end}
{synopt:{cmd:r(gap)}}total gap, if gap{p_end}
{synopt:{cmd:r(gap_min)}}minimum gap, if gap{p_end}
{synopt:{cmd:r(gap_mean)}}mean gap, if gap{p_end}
{synopt:{cmd:r(gap_med)}}median gap, if gap{p_end}
{synopt:{cmd:r(gap_max)}}maximum gap, if gap{p_end}
{synopt:{cmd:r(tr)}}total time at risk{p_end}
{synopt:{cmd:r(tr_min)}}minimum time at risk{p_end}
{synopt:{cmd:r(tr_mean)}}mean time at risk{p_end}
{synopt:{cmd:r(tr_med)}}median time at risk{p_end}
{synopt:{cmd:r(tr_max)}}maximum time at risk{p_end}
{synopt:{cmd:r(N_fail)}}number of failures{p_end}
{synopt:{cmd:r(f_min)}}minimum number of failures{p_end}
{synopt:{cmd:r(f_mean)}}mean number of failures{p_end}
{synopt:{cmd:r(f_med)}}median number of failures{p_end}
{synopt:{cmd:r(f_max)}}maximum number of failures{p_end}
{p2colreset}{...}
