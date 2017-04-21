{smcl}
{* *! version 1.1.6  14mar2015}{...}
{vieweralsosee "[M-5] strreverse()" "mansection M-5 strreverse()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] ustrreverse()" "help mf_ustrreverse"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] string" "help m4_string"}{...}
{viewerjumpto "Syntax" "mf_strreverse##syntax"}{...}
{viewerjumpto "Description" "mf_strreverse##description"}{...}
{viewerjumpto "Remarks" "mf_strreverse##remarks"}{...}
{viewerjumpto "Conformability" "mf_strreverse##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_strreverse##diagnostics"}{...}
{viewerjumpto "Source code" "mf_strreverse##source"}{...}
{title:Title}

{p 4 8 2}
{manlink M-5 strreverse()} {hline 2} Reverse string


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:string matrix}
{cmd:strreverse(}{it:string matrix s}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:strreverse(}{it:s}{cmd:)} reverses the ASCII string {it:s}.

{p 4 4 2}
When {it:s} is not a scalar, {cmd:strreverse()} returns element-by-element
results.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:strreverse()} is intended for use with ASCII characters.
For Unicode characters beyond the ASCII range, the encoded
bytes are reversed.

{p 4 4 2}
Use {helpb mf_ustrreverse:ustrreverse()} to return a string with its Unicode 
characters in reverse order.   


{marker conformability}{...}
{title:Conformability}

    {cmd:strreverse(}{it:s}{cmd:)}:
	     {it:s}:  {it:r x c}
	{it:result}:  {it:r x c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
None.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
