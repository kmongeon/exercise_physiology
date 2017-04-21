{smcl}
{* *! version 1.0.1  23jan2015}{...}
{viewerdialog "graph close" "dialog graph_close"}{...}
{vieweralsosee "[G-2] graph close" "mansection G-2 graphclose"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph drop" "help graph_drop"}{...}
{vieweralsosee "[G-2] graph manipulation" "help graph_manipulation"}{...}
{vieweralsosee "[G-2] graph replay" "help graph_replay"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] discard" "help discard"}{...}
{vieweralsosee "[D] erase" "help erase"}{...}
{vieweralsosee "[P] window manage" "help window manage"}{...}
{viewerjumpto "Syntax" "graph_close##syntax"}{...}
{viewerjumpto "Menu" "graph_close##menu"}{...}
{viewerjumpto "Description" "graph_close##description"}{...}
{viewerjumpto "Remarks" "graph_close##remarks"}{...}
{title:Title}

{p2colset 5 26 27 2}{...}
{p2col :{manlink G-2 graph close} {hline 2}}Close Graph windows{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Close named Graph windows

{p 8 23 2}
{cmdab:gr:aph}
{cmd:close}
{it:name}
[{it:name} ...]


{pstd}
Close all Graph windows

{p 8 23 2}
{cmdab:gr:aph}
{cmd:close }
[{cmd:_all}]


{phang}
{it:name} is the name of a Graph window and or the partial name of a 
Graph window with the {cmd:?} and {cmd:*} wildcard characters.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Manage graphs > Close graphs}


{marker description}{...}
{title:Description}

{pstd}
{cmd:graph} {cmd:close} closes specified or all Graph windows.


{marker remarks}{...}
{title:Remarks}

{pstd}
See {manhelp graph_manipulation G-2:graph manipulation} for an introduction to
the graph manipulation commands.  See {manhelp window_manage P:window manage}
for a discussion of how Stata's windowed interface is accessed.

{pstd}
{cmd:graph} {cmd:close} closes Graph windows, allowing users to easily manage
Stata's windowed interface. {cmd:graph} {cmd:close} can also be used to move
through series of graphs.  After each graph is examined, it can be closed
without manually closing the Graph window.  {cmd:Graph} is the default name of
the graph.

	{cmd:. graph twoway scatter faminc educ, ms(p)}
	...
	{cmd:. graph close Graph}

	{cmd:. graph twoway scatter faminc hsngval, ms(p)}
	...
	{cmd:. graph close Graph}
