{* *! version 1.0.0  12mar2015}{...}
{phang}
{it:exprspec} is an optionally labeled expression of model parameters
specified in parentheses:

{p 12 15 2}
{cmd:(}[{it:exprlabel}{cmd::}]{it:expr}{cmd:)}

{p 8 8 2}
{it:exprlabel} is a valid Stata name, and {it:expr} is a scalar expression
that may not contain matrix model parameters. See 
{it:{mansection BAYES bayesmhpostestimationRemarksandexamplesSpecifyingfunctionsofmodelparameters:Specifying functions of model parameters}} in {bf:[BAYES] bayesmh postestimation} for
examples.
