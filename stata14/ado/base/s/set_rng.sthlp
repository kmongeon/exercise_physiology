{smcl}
{* *! version 1.0.3  20mar2015}{...}
{vieweralsosee "[R] set rng" "mansection R setrng"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FN] Random-number functions" "help random_number_functions"}{...}
{vieweralsosee "[R] set seed" "help set_seed"}{...}
{vieweralsosee "[R] set" "help set"}{...}
{viewerjumpto "Syntax" "set_rng##syntax"}{...}
{viewerjumpto "Description" "set_rng##description"}{...}
{viewerjumpto "Remarks" "set_rng##remarks"}{...}
{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :{manlink R set rng} {hline 2}}Set which random-number generator (RNG) to use{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:set}
{cmd:rng}
{c -(}{cmd:default} |
      {cmd:mt64} |
      {cmd:kiss32}{c )-}


{marker description}{...}
{title:Description}

{pstd}
{cmd:set} {cmd:rng} determines which random-number generator Stata's
{help random:random-number functions} will use.


{marker remarks}{...}
{title:Remarks}

{pstd}
By default, Stata uses the 64-bit Mersenne Twister ({cmd:mt64}) random-number
generator.  Earlier versions of Stata used the 32-bit KISS (keep it simple
stupid) ({cmd:kiss32}) random-number generator.

{pstd}
With {cmd:set rng default} (the default), code running under
{help version:version control} will automatically use the appropriate
random-number generator -- {cmd:mt64} as of Stata 14 and {cmd:kiss32}
for earlier code.

{pstd}
We recommend that you do not change Stata's default behavior for
its random-number generators.  Use {cmd:set rng} only if you wish to
always use a particular random-number generator, overriding Stata's
default version-control behavior.

{pstd}
See {manhelp random_number_functions FN:Random-number functions} and
{manhelp set_seed R:set seed} for more information on
Stata's random-number functions.
{p_end}
