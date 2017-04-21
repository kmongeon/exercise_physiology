{smcl}
{* *! version 1.0.0  29mar2013}{...}
{findalias asfrnames}{...}
{title:Title}

{title:{findalias frnames}}

{pstd}
A name is a sequence of one to 32 letters ({cmd:A}-{cmd:Z} and 
{cmd:a}-{cmd:z}), digits ({cmd:0}-{cmd:9}), and underscores ({cmd:_}). 

{pstd}
Programmers:  Local macro names can have no more than 31 characters in the
name; see {findalias frlocal}.

{pstd}
Stata reserves the following names:

        {cmd:_all}     {cmd:float}   {cmd:_n}      {cmd:_skip}
        {cmd:_b}       {cmd:if}      {cmd:_N}      {cmd:str}{it:#}
        {cmd:byte}     {cmd:in}      {cmd:_pi}     {cmd:strL}
        {cmd:_coef}    {cmd:int}     {cmd:_pred}   {cmd:using}
        {cmd:_cons}    {cmd:long}    {cmd:_rc}     {cmd:with}
        {cmd:double} 

{pstd}
You may not use these reserved names for your variables.  

{pstd}
The first character of a name must be a letter or an underscore.  We
recommend, however, that you not begin your variable names with an underscore.
All of Stata's built-in variables begin with an underscore, and we reserve the
right to incorporate new {it:_variables} freely.

{pstd}
Stata respects case; that is, {cmd:myvar}, {cmd:Myvar}, and {cmd:MYVAR} are
three distinct names.

{pstd}
All objects in Stata -- not just variables -- follow this naming convention.
{p_end}
