{smcl}
{* *! version 1.0.3  05mar2015}{...}
{vieweralsosee "[M-5] udstrlen()" "mansection M-5 udstrlen()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] strlen()" "help mf_strlen"}{...}
{vieweralsosee "[M-5] ustrlen()" "help mf_udstrlen"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] string" "help m4_string"}{...}
{vieweralsosee "" "--"}{...}
{findalias asfrdiunicode}{...}
{viewerjumpto "Syntax" "mf_udstrlen##syntax"}{...}
{viewerjumpto "Description" "mf_udstrlen##description"}{...}
{viewerjumpto "Remarks" "mf_udstrlen##remarks"}{...}
{viewerjumpto "Conformability" "mf_udstrlen##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_udstrlen##diagnostics"}{...}
{viewerjumpto "Source code" "mf_udstrlen##source"}{...}
{title:Title}

{p 4 8 2}
{manlink M-5 udstrlen()} {hline 2} Length of Unicode string in display columns


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real matrix} {cmd:udstrlen(}{it:string matrix s}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:udstrlen(}{it:s}{cmd:)} returns the number of columns needed to display 
the Unicode string {it:s} in Stata's Results window.

{p 4 4 2}
When {it:s} is not a scalar, {cmd:udstrlen()} returns element-by-element
results.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Unicode characters from the Chinese, Japanese, and Korean languages usually 
require two display columns.  A Latin character usually requires one column.  
Any invalid UTF-8 sequence requires one column.
See {findalias frdiunicode} for details.

{p 4 4 2}
Use {helpb mf_ustrlen:ustrlen()} to obtain the length of a string in Unicode 
characters.  Use {helpb mf_strlen:strlen()} to obtain the length of a string
in bytes.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:udstrlen(}{it:s}{cmd:)}:
{p_end}
            {it:s}:  {it:r x c}
       {it:result}:  {it:r x c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:udstrlen(}{it:s}{cmd:)} returns a negative error code if an error occurs. 


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
