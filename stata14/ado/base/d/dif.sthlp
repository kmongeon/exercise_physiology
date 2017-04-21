{smcl}
{* *! version 1.0.1  09oct2015}{...}
{viewerdialog irt "dialog irt"}{...}
{vieweralsosee "[IRT] dif" "mansection IRT dif"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[IRT] diflogistic" "help diflogistic"}{...}
{vieweralsosee "[IRT] difmh" "help difmh"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[IRT] irt" "help irt"}{...}
{viewerjumpto "Description" "irt##description"}{...}
{title:Title}

{p2colset 5 18 20 2}{...}
{p2col :{manlink IRT dif} {hline 2}}Introduction to differential item
functioning{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
Differential item functioning (DIF) occurs when items that are intended to
measure a latent trait are unfair, favoring one group of individuals over
another.  Investigating DIF involves evaluating whether a test item behaves
differently across respondents with the same value of the latent trait.  An
item "functions differently" across individuals with the same latent trait if
these individuals have different probabilities of selecting a given response.

{pstd}
See the following help files for details about the individual DIF tests,
including syntax and worked examples.

{p2colset 9 24 26 2}{...}
{* {pstd}}{...}
{* {bf:Differential item functioning}}{...}
{p2col :{helpb diflogistic}}Logistic regression DIF{p_end}
{p2col :{helpb difmh}}Mantel-Haenszel DIF{p_end}
{p2colreset}{...}
