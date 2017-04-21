{smcl}
{* *! version 1.0.1  18mar2015}{...}
{vieweralsosee "[BAYES] bayes" "mansection BAYES bayes"}{...}
{vieweralsosee "[BAYES] intro" "mansection BAYES intro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayesmh" "help bayesmh"}{...}
{vieweralsosee "[BAYES] bayesmh postestimation" "help bayesmh postestimation"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes_glossary"}{...}
{viewerjumpto "Description" "bayes##description"}{...}
{title:Title}

{p2colset 5 22 24 2}{...}
{p2col :{manlink BAYES bayes} {hline 2}}Introduction to commands for Bayesian analysis{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
This entry describes commands to perform Bayesian analysis.  Bayesian analysis
is a statistical procedure that answers research questions by expressing
uncertainty about unknown parameters using probabilities.  It is based on the
fundamental assumption that not only the outcome of interest but also all the
unknown parameters in a statistical model are essentially random and are
subject to prior beliefs.


{p2colset 9 30 32 2}{...}
{pstd}
{bf:Estimation}

{p2col :{helpb bayesmh}}Bayesian regression using MH{p_end}
{p2col :{helpb bayesmh evaluators}}User-written Bayesian models using MH{p_end}


{pstd}
{bf:Convergence tests and graphical summaries}

{p2col :{helpb bayesgraph}}Graphical summaries{p_end}


{pstd}
{bf:Postestimation statistics}

{p2col :{helpb bayesstats ess}}Effective sample sizes and related statistics{p_end}
{p2col :{helpb bayesstats summary}}Bayesian summary statistics{p_end}
{p2col :{helpb bayesstats ic}}Bayesian information criteria and Bayes factors{p_end}


{pstd}
{bf:Hypothesis testing}

{p2col :{helpb bayestest model}}Hypothesis testing using model posterior probabilities{p_end}
{p2col :{helpb bayestest interval}}Interval hypothesis testing{p_end}
