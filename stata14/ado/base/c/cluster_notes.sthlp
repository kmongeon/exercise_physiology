{smcl}
{* *! version 1.1.6  31oct2014}{...}
{viewerdialog "cluster notes" "dialog cluster_note"}{...}
{vieweralsosee "[MV] cluster notes" "mansection MV clusternotes"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] cluster programming utilities" "help cluster_programming"}{...}
{vieweralsosee "[MV] cluster utility" "help cluster_utility"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] cluster" "help cluster"}{...}
{vieweralsosee "[MV] clustermat" "help clustermat"}{...}
{vieweralsosee "[D] notes" "help notes"}{...}
{vieweralsosee "[D] save" "help save"}{...}
{viewerjumpto "Syntax" "cluster notes##syntax"}{...}
{viewerjumpto "Menu" "cluster notes##menu"}{...}
{viewerjumpto "Description" "cluster notes##description"}{...}
{viewerjumpto "Examples" "cluster notes##examples"}{...}
{title:Title}

{p2colset 5 27 29 2}{...}
{p2col :{manlink MV cluster notes} {hline 2}}Place notes in cluster analysis{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

INCLUDE help cluster_notes_syntax


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate analysis > Cluster analysis > Postclustering >}
      {bf:Cluster analysis notes}


{marker description}{...}
{title:Description}

{pstd}
{cmd:cluster} {cmd:notes} is a set of commands to manage notes for a
previously run cluster analysis.  You can attach notes that become part of the
data and are saved when the data are saved and retrieved when the data are
used.  {cmd:cluster} {cmd:notes} may also be used to list notes for all
defined cluster analyses or for specific cluster analyses names.

{pstd}
{cmd:cluster notes drop} allows you to drop cluster notes.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. cluster notes myclus: Group 9 looks strange.  Examine it closer.}{p_end}
{phang}{cmd:. cluster notes ageclus: Consider removing the singleton groups.}{p_end}
{phang}{cmd:. cluster notes}{p_end}
{phang}{cmd:. cluster notes myclus}{p_end}
{phang}{cmd:. cluster notes drop clusxyz in 3 6/8}{p_end}
{phang}{cmd:. cluster notes drop ageclus}{p_end}
{phang}{cmd:. cluster notes}{p_end}
