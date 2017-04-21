{smcl}
{* *! version 1.0.0  25mar2015}{...}
{vieweralsosee "[M-5] ustrpos()" "mansection M-5 ustrpos()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] strpos()" "help mf_strpos"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] string" "help m4_string"}{...}
{vieweralsosee "" "--"}{...}
{findalias asfrunicode}{...}
{viewerjumpto "Syntax" "mf_ustrpos##syntax"}{...}
{viewerjumpto "Description" "mf_ustrpos##description"}{...}
{viewerjumpto "Remarks" "mf_ustrpos##remarks"}{...}
{viewerjumpto "Conformability" "mf_ustrpos##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_ustrpos##diagnostics"}{...}
{viewerjumpto "Source code" "mf_ustrpos##source"}{...}
{title:Title}

{p 4 8 2}
{manlink M-5 ustrpos()} {hline 2} Find substring in Unicode string


{marker syntax}{...}
{title:Syntax}

{p 8 34 2}
{it:real matrix} {cmd:ustrpos(}{it:string matrix s}{cmd:,}{it:string scalar sf}{break}
 [{cmd:,}{it:real scalar n}]{cmd:)}

{p 8 34 2}
{it:real matrix} {cmd:ustrrpos(}{it:string matrix s}{cmd:,}{it:string scalar sf}{break}
 [{cmd:,}{it:real scalar n}]{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:ustrpos(}{it:s}{cmd:,} {it:sf}[{cmd:,} {it:n}]{cmd:)}
returns the character position in {it:s} at which {it:sf} is first found;
otherwise, it returns {cmd:0}.  If {it:n} is specified and is larger than
zero, the search starts at the {it:n}th Unicode character of {it:s}.

{p 4 4 2}
{cmd:ustrrpos(}{it:s}{cmd:,} {it:sf}[{cmd:,} {it:n}]{cmd:)}
returns the position in {it:s} at which {it:sf} is last found; otherwise, 
it returns {cmd:0}.  If {it:n} is specified and is larger than zero, the part
between the first Unicode character and the {it:n}th Unicode character of
{it:s} is searched.

{p 4 4 2}
When {it:s} is not a scalar, these functions return element-by-element
results.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
An invalid UTF-8 sequence in {it:s} or {it:sf} is replaced with 
a Unicode replacement character {bf:\ufffd} before the search is performed. 

{p 4 4 2}
Use {helpb mf_strpos:strpos()} or {helpb mf_strpos:strrpos()} to find 
the byte-based location of a substring in a string. 


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:ustrpos(}{it:s}{cmd:,}{it:sf} [{cmd:,}{it:n}]{cmd:)}, 
{cmd:ustrrpos(}{it:s}{cmd:,}{it:sf} [{cmd:,}{it:n}]{cmd:)}:
{p_end}
	    {it:s}:  {it:r x c}
           {it:sf}:  1 {it:x} 1 
            {it:n}:  1 {it:x} 1 
       {it:result}:  {it:r x c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
None.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
