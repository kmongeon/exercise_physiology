{smcl}
{* *! version 1.0.3  05mar2015}{...}
{vieweralsosee "[M-5] ustrreverse()" "mansection M-5 ustrreverse()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] strreverse()" "help mf_strreverse"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] string" "help m4_string"}{...}
{vieweralsosee "" "--"}{...}
{findalias asfrunicode}{...}
{viewerjumpto "Syntax" "mf_ustrreverse##syntax"}{...}
{viewerjumpto "Description" "mf_ustrreverse##description"}{...}
{viewerjumpto "Remarks" "mf_ustrreverse##remarks"}{...}
{viewerjumpto "Conformability" "mf_ustrreverse##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_ustrreverse##diagnostics"}{...}
{viewerjumpto "Source code" "mf_ustrreverse##source"}{...}
{title:Title}

{p 4 8 2}
{manlink M-5 ustrreverse()} {hline 2} Reverse Unicode string


{marker syntax}{...}
{title:Syntax}

{p 8 31 2}
{it:string matrix}
{cmd:ustrreverse(}{it:string matrix s}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:ustrreverse(}{it:string matrix s}{cmd:)} reverses the Unicode string
{it:s}.

{p 4 4 2}
When arguments are not scalar, this function returns element-by-element
results.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
The function does not take
{mansection U 12.4.2HandlingUnicodestrings:Unicode character equivalence}
into consideration.  Hence, a Unicode character in a decomposed form will not
be reversed as one unit.  An invalid UTF-8 sequence is replaced with a Unicode
replacement character {bf:\ufffd}.

{p 4 4 2}
Use {helpb mf_strreverse:strreverse()} to return a string with its bytes in
reverse order.   


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:ustrreverse(}{it:s}{cmd:)}:
{p_end}
		{it:s}:  {it:r x c}
	   {it:result}:  {it:r x c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:ustrreverse(}{it:s}{cmd:)} returns an empty string if an error occurs. 


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
