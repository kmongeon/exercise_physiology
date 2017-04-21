{smcl}
{* *! version 1.0.1  07jun2013}{...}
{viewerdialog "SEM Builder" "stata sembuilder"}{...}
{vieweralsosee "[SEM] Builder, generalized" "mansection SEM Builder,generalized"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] sem intro" "help sem_intro"}{...}
{vieweralsosee "[SEM] sem examples" "help sem_examples"}{...}
{viewerjumpto "Menu" "gsem_builder##menu"}{...}
{viewerjumpto "Description" "gsem_builder##description"}{...}
{viewerjumpto "Remarks" "gsem_builder##remarks"}{...}
{viewerjumpto "Video example" "gsem_builder##video"}{...}
{title:Title}

{p2colset 5 35 37 2}{...}
{p2col:{manlink SEM Builder, generalized} {hline 2}}SEM Builder for
generalized models{p_end}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > SEM (structural equation modeling) > Model building and estimation}

{phang}
Switch the Builder into generalized SEM mode by
clicking on the {bf:Change to Generalized SEM} button.


{marker description}{...}
{title:Description}

{pstd}
The SEM Builder lets you create path diagrams for generalized SEMs, fit those
models, and show results on the path diagram.  Here we extend the
discussion from {helpb sem_builder:[SEM] Builder}.  Read that entry first.


{marker remarks}{...}
{title:Remarks}

{pstd}
See {manlink SEM Builder, generalized}.

{pstd}
{cmd:gsem} also provides a command language interface.  This interface is
similar to path diagrams and is typable.  See
{helpb sem_and gsem path_notation:[SEM] sem and gsem path notation}.
{p_end}


{marker video}{...}
{title:Video example}

{phang}
{browse "http://www.youtube.com/watch?v=Xj0gBlqwYHI":SEM Builder in Stata}
{p_end}