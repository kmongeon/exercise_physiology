{smcl}
{* *! version 1.1.5  29sep2014}{...}
{viewerdialog doedit "stata doedit"}{...}
{vieweralsosee "[R] doedit" "mansection R doedit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] do" "help do"}{...}
{viewerjumpto "Syntax" "doedit##syntax"}{...}
{viewerjumpto "Menu" "doedit##menu"}{...}
{viewerjumpto "Description" "doedit##description"}{...}
{viewerjumpto "Remarks" "doedit##remarks"}{...}
{title:Title}

{p2colset 5 19 21 2}{...}
{p2col :{manlink R doedit} {hline 2}}Edit do-files and other text files{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{cmdab:doed:it} [{it:{help filename}}]


{marker menu}{...}
{title:Menu}

{phang}
{bf:Window > Do-file Editor}


{marker description}{...}
{title:Description}

{pstd}
{cmd:doedit} opens the Do-file Editor.  This text editor lets you create and 
edit do-files, which typically contain a series of Stata commands.
If you specify {it:filename}, {cmd:doedit} will open a text file, such  
as a do-file or an ado-file, saved to disk.


{marker remarks}{...}
{title:Remarks}

{pstd}
Clicking on the {bf:Do-file Editor} button is equivalent to
typing {cmd:doedit}.

{pstd}
{cmd:doedit}, typed by itself, invokes the Editor with an empty document.
If you specify {it:filename}, that file is displayed in the Editor.

{pstd}
You may have more than one Do-file Editor open at once.  Each time you submit
the {cmd:doedit} command, a new window will be opened.

{pstd}
A tutorial discussion of {cmd:doedit} can be found in the
{it:Getting Started with Stata} manual.  Read
{findalias frdofiles} for an explanation of do-files, and then read 
{findalias gsmdoedit}, 
{findalias gsudoedit}, or 
{findalias gswdoedit} 
to learn how to use the Do-file Editor to create and execute do-files.
{p_end}
