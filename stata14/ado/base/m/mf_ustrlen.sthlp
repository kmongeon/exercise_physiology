{smcl}
{* *! version 1.0.4  05mar2015}{...}
{vieweralsosee "[M-5] ustrlen()" "mansection M-5 ustrlen()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] strlen()" "help mf_strlen"}{...}
{vieweralsosee "[M-5] udstrlen()" "help mf_udstrlen"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] string" "help m4_string"}{...}
{vieweralsosee "" "--"}{...}
{findalias asfrdiunicode}{...}
{viewerjumpto "Syntax" "mf_ustrlen##syntax"}{...}
{viewerjumpto "Description" "mf_ustrlen##description"}{...}
{viewerjumpto "Remarks" "mf_ustrlen##remarks"}{...}
{viewerjumpto "Conformability" "mf_ustrlen##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_ustrlen##diagnostics"}{...}
{viewerjumpto "Source code" "mf_ustrlen##source"}{...}
{title:Title}

{p 4 8 2}
{manlink M-5 ustrlen()} {hline 2} Length of Unicode string in Unicode characters


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real matrix}{space 8}{cmd:ustrlen(}{it:string matrix s}{cmd:)}

{p 8 12 2}
{it:real matrix} {cmd:ustrinvalidcnt(}{it:string matrix s}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:ustrlen(}{it:s}{cmd:)} returns the  number of Unicode characters in the 
Unicode string {it:s}.  An invalid UTF-8 sequence is counted as one Unicode 
character.  Note that any Unicode character besides ASCII characters 
(0-127) takes more than 1 byte in UTF-8 encoding, for example, 
"é" takes 2 bytes.

{p 4 4 2}
{cmd:ustrinvalidcnt(}{it:s}{cmd:)} returns the number of invalid UTF-8
sequences in {it:s}.  An invalid UTF-8 sequence can contain one byte or
multiple bytes.

{p 4 4 2}
When {it:s} is not a scalar, functions return element-by-element
results.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:ustrlen(}{it:s}{cmd:)}, when {it:s} is a binary string (a string
containing null terminator {cmd:char(0)}), returns the overall length of 
the Unicode string.  Note that null terminator {cmd:char(0)} is a valid 
Unicode code point.  

{p 4 4 2}
Use {helpb mf_udstrlen:udstrlen()} to obtain the length of a string in display
columns.  Use {helpb mf_strlen:strlen()} to obtain the length of a string in
bytes.
See {findalias frdiunicode}.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:ustrlen(}{it:s}{cmd:)},
{cmd:ustrinvalidcnt(}{it:s}{cmd:)}:
{p_end}
             {it:s}:  {it:r x c}
        {it:result}:  {it:r x c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:ustrlen(}{it:s}{cmd:)} and
{cmd:ustrinvalidcnt(}{it:s}{cmd:)}
return negative error codes if an error occurs. 


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
