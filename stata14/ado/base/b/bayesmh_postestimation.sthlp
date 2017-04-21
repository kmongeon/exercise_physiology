{smcl}
{* *! version 1.0.2  04may2015}{...}
{vieweralsosee "[BAYES] bayesmh postestimation" "mansection BAYES bayesmhpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayesmh" "help bayesmh"}{...}
{vieweralsosee "[BAYES] bayesmh evaluators" "help bayesmh evaluators"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes_glossary"}{...}
{viewerjumpto "Description" "bayesmh postestimation##description"}{...}
{viewerjumpto "Remarks" "bayesmh postestimation##remarks"}{...}
{viewerjumpto "Examples" "bayesmh postestimation##examples"}{...}
{title:Title}

{p2colset 5 39 41 2}{...}
{p2col :{manlink BAYES bayesmh postestimation} {hline 2}}Postestimation tools 
for bayesmh{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
The following postestimation commands are available after {cmd:bayesmh}: 

{synoptset 24 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb bayesgraph}}graphical summaries and convergence diagnostics{p_end}
{synopt :{helpb bayesstats ess}}effective sample sizes and related statistics{p_end}
{synopt :{helpb bayesstats summary}}Bayesian summary statistics for model parameters and their functions{p_end}
{synopt :{helpb bayesstats ic}}Bayesian information criteria and Bayes factors{p_end}
{synopt :{helpb bayestest model}}hypothesis testing using model posterior probabilities{p_end}
{synopt :{helpb bayestest interval}}interval hypotheses testing{p_end}
{p2coldent:* {helpb estimates}}cataloging estimation results{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:estimates table} and {cmd:estimates stats} are not appropriate with
{cmd:bayesmh} estimation results.
{p_end}


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help bayesmh_postestimation##modelparams:Different ways of specifying model parameters}
        {help bayesmh_postestimation##functions:Specifying functions of model parameters}
        {help bayesmh_postestimation##storing:Storing estimation results after bayesmh}

{pstd}
After estimation, you can use {cmd:bayesgraph} to check convergence of MCMC
visually.  Once convergence is established, you can use {cmd:bayesstats}
{cmd:summary} to obtain Bayesian summaries such as posterior means and standard
deviations of model parameters and functions of model parameters;
{cmd:bayesstats ess} to compute effective sample sizes and related statistics
for model parameters and functions of model parameters; and {cmd:bayesstats}
{cmd:ic} to compute Bayesian information criteria and Bayes factors for model
parameters and their functions.  You can use {cmd:bayestest} {cmd:model} to
test hypotheses by comparing posterior probabilities of models.  You can also
use {cmd:bayestest interval} to test interval hypotheses about parameters and
functions of parameters.

{pstd}
For an overview example of postestimation commands, see
{mansection BAYES bayesRemarksandexamplesOverviewexample:{it:Overview example}} in
{bf:[BAYES] bayes}.


{marker modelparams}{...}
{title:Different ways of specifying model parameters}

{pstd}
Many {cmd:bayesmh} postestimation commands such as {cmd:bayesstats summary}
and {cmd:bayesgraph} allow you to specify model parameters for which you want
to see the results.  To see results for all parameters, simply type a
postestimation command without arguments after {cmd:bayesmh} estimation, for
example,

{phang2}
{cmd:. bayesstats summary}

{pstd}
or you could type 

{phang2}
{cmd:. bayesstats summary _all}

{pstd}
To manually list all model parameters, type

{phang2}
{cmd:. bayesstats summary {param1} {param2}} ...

{pstd}
or

{phang2}
{cmd:. bayesstats summary {param1 param2}} ...

{pstd}
The only exception is the {cmd:bayesgraph} command when there is more than one
model parameter.  In that case, {cmd:bayesgraph} requires that you either
specify {cmd:_all} to request all model parameters or specify the model
parameters of interest.

{pstd}
You can refer to a single model parameter in the same way you define
parameters in the {cmd:bayesmh} command.  For example, for a parameter with
name {cmd:param} and no equation name, you can use {cmd:{param}}.  For a
parameter with name {cmd:param} and equation name {cmd:eqname}, you can use
its full name {cmd:{eqname:name}}, where the equation name and the parameter
name are separated with a colon.  With postestimation commands, you can also
omit the equation name when referring to the parameter with an equation name.

{pstd}
In the presence of more than one model parameter, you have several ways for
referring to multiple parameters at once.  If parameters have the same equation
name, you can refer to all the parameters with that equation name as
follows.

{pstd}
Suppose that you have three parameters with the same equation name
{cmd:eqname}. Then the specification

{phang2}
{cmd:. bayesstats summary {eqname:param1} {eqname:param2} {eqname:param3}}

{pstd}
is the same as the specification

{phang2}
{cmd:. bayesstats summary {eqname:}}

{pstd}
or the specification

{phang2}
{cmd:. bayesstats summary {eqname:param1 param2 param3}}

{pstd}
The above specification is useful if we want to refer to a subset of
parameters with the same equation name. For example, in the above, if we
wanted to use only {cmd:param1} and {cmd:param2}, we could type

{phang2}
{cmd:. bayesstats summary {eqname:param1 param2}}

{pstd}
There is also a convenient way to refer to the parameters with the same name
but different equation names.  For example, typing

{phang2}
{cmd:. bayesstats summary {eqname1:param} {eqname2:param}}

{pstd}
is the same as simply typing

{phang2}
{cmd:. bayesstats summary {param}}

{pstd}
You can mix and match all the specifications above in one call to a
postestimation command.  You can also specify expressions of model parameters;
see {help bayesmh_postestimation##functions:{it:Specifying functions of model parameters}}
for details.

{pstd}
Note that if {cmd:param} refers to a matrix model parameter, then the results
will be provided for all elements of the matrix.  For example, if {cmd:param}
is the name of a 2 x 2 matrix, then typing

{phang2}
{cmd:. bayesstats summary {param}}

{pstd}
implies the following:

{phang2}
{cmd:. bayesstats summary {param_1_1} {param_1_2} {param_2_1} {param_2_2}}

{marker functions}{...}
{title:Specifying functions of model parameters}

{pstd}
You can use {cmd:bayesmh} postestimation commands to obtain results for
functions or expressions of model parameters.  Each expression must be
specified in parentheses.  An expression can be any Stata expression, but it
may not include matrix model parameters.  However, you may include
individual elements of matrix model parameters.  You may provide labels for
your expressions.

{pstd}
For example, we can obtain results for the exponentiated parameter
{cmd:{param}} as follows:

{phang2}
{cmd:. bayesstats summary (exp({param}))}

{pstd}
Note that we specified the expression in parentheses.

{pstd}
We can include a label, say, {cmd:myexp}, in the above by typing

{phang2}
{cmd:. bayesstats summary (myexp: exp({param}))}

{pstd}
We can specify multiple expressions by typing

{phang2}
{cmd:. bayesstats summary (myexp: exp({param}) (sd: sqrt({c -(}var{c )-})))}

{pstd}
If {cmd:param} is a matrix, we can specify expressions, including its elements,
but not the matrix itself in the following:

{phang2}
{cmd:. bayesstats summary (exp({param_1_1})) (exp({param_1_2}))} ...


{marker storing}{...}
{title:Storing estimation results after bayesmh}

{pstd}
The {cmd:bayesmh} command stores various {cmd:e()} results such as scalars,
macros, and matrices in memory like any other estimation command.  Unlike
other estimation commands, {cmd:bayesmh} also saves the resulting simulation
dataset containing MCMC samples of parameters to disk.  Many {cmd:bayesmh}
postestimation commands such as {cmd:bayesstats summary} and {cmd:bayesstats}
{cmd:ess} require access to this file.  If you do not specify the
{cmd:saving()} option with {cmd:bayesmh}, the command saves simulation results
in a temporary Stata dataset.  This file is being replaced with the new
simulation results each time {cmd:bayesmh} is run.  To save your simulation
results, you must specify the {cmd:saving()} option with {cmd:bayesmh}, in
which case your simulation results are saved to the specified file in the
specified location and will not be overridden by the next call to
{cmd:bayesmh}.

{pstd}
You can specify the {cmd:saving()} option during estimation by typing

{phang2}
{cmd:. bayesmh} ...{cmd:, likelihood() prior()} ... {cmd:saving()}

{pstd}
or on replay by typing

{phang2}
{cmd:. bayesmh, saving()}

{pstd}
As you can with other estimation commands, you can use {cmd:estimates store} to
store {cmd:bayesmh} estimation results in memory and {cmd:estimates save} to
save them to disk, but you must first use the {cmd:saving()} option with
{cmd:bayesmh} to save simulation data in a permanent dataset. For example,
type

{phang2}
{cmd:. bayesmh} ...{cmd:, likelihood() prior()} ...  {cmd:saving(bmh_simdata)}{p_end}
{phang2}
{cmd:. estimates store model1}

{pstd}
or, after {cmd:bayesmh} estimation, type

{phang2}
{cmd:. bayesmh, saving(bmh_simdata)}{p_end}
{phang2}
{cmd:. estimates store model1}

{pstd}
Once you create a permanent dataset, it is your responsibility to erase it
after it is no longer needed.  {cmd:estimates drop} and {cmd:estimates clear}
will drop estimation results only from memory; they will not erase the
simulation files you saved.

{phang2}
{cmd:. estimates drop model1}{p_end}
{phang2}
{cmd:. erase bmh_simdata.dta}

{pstd}
See {manhelp estimates R} for more information about commands managing
estimation results.  {cmd:estimates table} and {cmd:estimates stats} are not
appropriate after {cmd:bayesmh}.
{p_end}


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse oxygen}{p_end}
{phang2}{cmd:. set seed 14}{p_end}
{phang2}{cmd:. bayesmh change age group, likelihood(normal({c -(}var{c )-}))}
        {cmd:prior({change:}, flat) prior({c -(}var{c )-}, jeffreys)}

{pstd}Check convergence visually for all parameters{p_end}
{phang2}{cmd:. bayesgraph diagnostics _all}

{pstd}Effective sample sizes and efficiencies for all model parameters{p_end}
{phang2}{cmd:. bayesstats ess}

{pstd}Summaries for all model parameters{p_end}
{phang2}{cmd:. bayesstats summary}

{pstd}Summaries for a function of a model parameter {cmd:{c -(}var{c )-}}{p_end}
{phang2}{cmd:. bayesstats summary (sd:sqrt({c -(}var{c )-}))}

{pstd}Compute probability that {bf:{change:group}} is between 4 and 8{p_end}
{phang2}{cmd:. bayestest interval {change:group}, lower(4) upper(8)}{p_end}

{pstd}Store current estimation results{p_end}
{phang2}{cmd:. bayesmh, saving(agegroup_sim)}{p_end}
{phang2}{cmd:. estimates store agegroup}

{pstd}Compare current model to the model with an interaction between {cmd:age} and
{cmd:group} using Bayes factors{p_end}
{phang2}{cmd:. set seed 14}{p_end}
{phang2}{cmd:. bayesmh change c.age##i.group, likelihood(normal({c -(}var{c )-}))}
        {cmd:prior({change:}, flat) prior({c -(}var{c )-}, jeffreys)}
	{cmd:saving(full_sim)}{p_end}
{phang2}{cmd:. estimates store full}{p_end}
{phang2}{cmd:. bayesstats ic agegroup full}{p_end}

{pstd}Compute model probabilities{p_end}
{phang2}{cmd:. bayestest model agegroup full}

{pstd}Dropping estimates from memory and deleting simulation data{p_end}
{phang2}{cmd:. estimates drop full agegroup}{p_end}
{phang2}{cmd:. erase full_sim.dta}{p_end}
{phang2}{cmd:. erase agegroup_sim.dta}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse hearthungary}{p_end}
	
{pstd}Storing estimates in memory{p_end}
{phang2}{cmd:. set seed 14}{p_end}
{phang2}{cmd:. bayesmh disease restecg isfbs age male, likelihood(logit)}
		{cmd:prior({disease:}, normal(0,1000)) saving(simdata1.dta)}{p_end}
{phang2}{cmd:. estimates store m1}{p_end}
	
{pstd}Storing most recent estimates in memory by replaying the model{p_end}
{phang2}{cmd:. bayesmh}{p_end}
{phang2}{cmd:. estimates store m1}{p_end}
	
{pstd}Dropping estimates from memory and deleting simulation data{p_end}
{phang2}{cmd:. estimates drop m1}{p_end}
{phang2}{cmd:. erase simdata1.dta}{p_end}

    {hline}
