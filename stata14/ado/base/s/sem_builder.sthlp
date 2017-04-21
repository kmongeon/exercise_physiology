{smcl}
{* *! version 1.0.1  31may2013}{...}
{viewerdialog "SEM Builder" "stata sembuilder"}{...}
{vieweralsosee "[SEM] Builder" "mansection SEM Builder"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] sem intro" "help sem_intro"}{...}
{vieweralsosee "[SEM] sem examples" "help sem_examples"}{...}
{viewerjumpto "Menu" "sem_builder##menu"}{...}
{viewerjumpto "Description" "sem_builder##description"}{...}
{viewerjumpto "Remarks" "sem_builder##remarks"}{...}
{viewerjumpto "Video example" "sem_builder##video"}{...}
{title:Title}

{p2colset 5 22 24 2}{...}
{p2col:{manlink SEM Builder} {hline 2}}SEM Builder{p_end}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > SEM (structural equation modeling) > Model building and estimation}


{marker description}{...}
{title:Description}

{pstd}
The SEM Builder lets you create path diagrams for SEMs, fit those models, and
show results on the path diagram.  Here we discuss standard linear 
SEMs; see {helpb gsem_builder:[SEM] Builder, generalized} for information on
using the Builder to create models with generalized responses and multilevel
structure.

{marker remarks}{...}
{title:Remarks}

{pstd}
See {manlink SEM Builder}.

{pstd}
{cmd:sem} also provides a command language interface.  This interface is
similar to path diagrams and is typable.  See
{helpb sem_and gsem path_notation:[SEM] sem and gsem path notation}.
{p_end}


{marker video}{...}
{title:Video example}

{phang}
{browse "http://www.youtube.com/watch?v=Xj0gBlqwYHI":SEM Builder in Stata}
{p_end}
