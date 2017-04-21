{smcl}
{* *! version 1.0.4  05mar2015}{...}
{vieweralsosee "[M-5] uchar()" "mansection M-5 uchar()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] ascii()" "help mf_ascii"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] string" "help m4_string"}{...}
{vieweralsosee "" "--"}{...}
{findalias asfrunicode}{...}
{viewerjumpto "Syntax" "mf_uchar##syntax"}{...}
{viewerjumpto "Description" "mf_uchar##description"}{...}
{viewerjumpto "Remarks" "mf_uchar##remarks"}{...}
{viewerjumpto "Conformability" "mf_uchar##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_uchar##diagnostics"}{...}
{viewerjumpto "Source code" "mf_uchar##source"}{...}
{title:Title}

{p 4 8 2}
{manlink M-5 uchar()} {hline 2} Convert code point to Unicode character 


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:string matrix} {cmd:uchar(}{it:real matrix c}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:uchar(c)} returns the Unicode character 
in UTF-8 encoding corresponding to Unicode code point {it:c}.  It returns 
an empty string if {it:c} is beyond the Unicode code-point range. 

{p 4 4 2}
When {it:c} is not a scalar, this function returns element-by-element
results.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:uchar()} returns the same results as {helpb mf_char:char()} for 
code points 0-127.  


{marker conformability}{...}
{title:Conformability}

    {cmd:uchar(}{it:c}{cmd:)}:
	    {it:c}:  {it:r x c}
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
