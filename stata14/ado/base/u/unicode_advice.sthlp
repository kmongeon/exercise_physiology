{smcl}
{* *! version 1.0.0  20mar2015}{...}
{findalias asfrunicode}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] unicode" "help unicode"}{...}
{vieweralsosee "help encodings" "help encodings"}{...}
{title:Advice on using Unicode -- New to Stata 14}

{pstd}
Stata 14 is Unicode (UTF-8) aware.  
This means that you can now include accented characters,

        {c a'} {c e'g} {c i'} {c o^} {c u:} {c y'} ç ...

{pstd}
include symbols, 

        {c L-} {c Y=} € ≤ ≥ ≠ ∑ ...

{pstd}
and even include non-Latin characters,

	Здравствуйте          

	こんにちは

{pstd}
You may include them in your .dta files, do-files, ado-files, and other Stata
files. 

{pstd} 
All of Stata is Unicode aware.  You may use Unicode for variable names, 
labels, data, and anywhere else you wish.  And, it means that 
when you share data, others will see what you see. 

{pstd} 
{bf:You need to translate your .dta files, ado-files, and do-files}
if you previously used extended ASCII to include accented characters,
special symbols, or non-Latin characters in your Stata files.

{center:See the new command {bf:{help unicode_translate:unicode translate}}.}

{pstd}
Plain ASCII files do not need translating. 
Stata 14 will work even with old datasets using extended ASCII, but
the extended ASCII characters will not display correctly.  

{center:Learn more about using Unicode in Stata:}

{center:See {findalias frunicode}.}

