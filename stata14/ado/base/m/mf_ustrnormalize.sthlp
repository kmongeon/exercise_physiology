{smcl}
{* *! version 1.0.2  24feb2015}{...}
{vieweralsosee "[M-5] ustrnormalize()" "mansection M-5 ustrnormalize()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] string" "help m4_string"}{...}
{vieweralsosee "" "--"}{...}
{findalias asfrunicode}{...}
{viewerjumpto "Syntax" "mf_ustrnormalize##syntax"}{...}
{viewerjumpto "Description" "mf_ustrnormalize##description"}{...}
{viewerjumpto "Remarks" "mf_ustrnormalize##remarks"}{...}
{viewerjumpto "Conformability" "mf_ustrnormalize##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_ustrnormalize##diagnostics"}{...}
{viewerjumpto "Source code" "mf_ustrnormalize##source"}{...}
{title:Title}

{p 4 8 2}
{manlink M-5 ustrnormalize()} {hline 2} Normalize Unicode string


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:string matrix} {cmd:ustrnormalize(}{it:string matrix s}{cmd:,} {it:string matrix norm}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:ustrnormalize(}{it:s}{cmd:,} {it:norm}{cmd:)} normalizes Unicode string 
{it:s} to one of the five normalization forms specified by {it:norm}. 

{p 4 4 2}
When {it:s} is not a scalar, the function returns element-by-element
results.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Unicode normalization removes the Unicode string differences caused by 
Unicode character equivalence.  For example, the character "i" with two dots 
as in naïve can be represented either by a single Unicode code point,
{bf:\u00ef}, or by two code points, {bf:\u0069}, which is the regular "i ",
and {bf:\u0308}, which is the diaeresis character.  The code point {bf:\u00ef} and 
the code-point sequence {bf:\u0069\u0308} are considered Unicode equivalent.  
According to the Unicode standard, they should be treated as the same single 
character in Unicode string operations, such as display, comparison, and
selection.  But Stata does not support multiple code-point characters; each 
code point is considered a single Unicode character.  Hence,
{bf:\u0069\u0308} is displayed as two characters in the Results window.  
{cmd:ustrnormalize()} can be used to deal with this issue by normalizing 
{bf:\u0069\u0308} to its canonical equivalent composited {bf:NFC} 
form {bf:\u00ef}.

{p 4 4 2}
{it:norm} must be one of {bf:nfc}, {bf:nfd}, {bf:nfkc}, {bf:nfkd}, 
or {bf:nfkcc}.  The function returns an empty string for any other 
value of {it:norm}. 

{p 4 4 2}
{bf:nfc} specifies {bf:Normalization Form C}, which normalizes decomposed 
Unicode code points to canonical composited form.  {bf:nfd} specifies 
{bf:Normalization Form D}, which normalizes composited Unicode code points
to canonical decomposed form.  {bf:nfc} and {bf:nfd} produce canonical 
equivalent form.  {bf:nfkc} and {bf:nfkd} are similar to {bf:nfc} and 
{bf:nfd} but produce compatibility equivalent form. {bf:nfkcc} is similar to 
{bf:nfkc} but also handles case folding.  For details, see 
{browse "http://unicode.org/reports/tr15/"}.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:ustrnormalize(}{it:s}{cmd:,} {it:norm}{cmd:)}:
{p_end}
	    {it:s}:  {it:r x c}
	 {it:norm}:  {it:r x c} or 1 {it:x} 1
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
