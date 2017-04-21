{smcl}
{* *! version 1.0.5  20mar2015}{...}
{vieweralsosee "[TE] treatment effects" "mansection TE treatmenteffects"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] Glossary" "help te_glossary"}{...}
{viewerjumpto "Description" "treatment effects##description"}{...}
{title:Title}

{p2colset 5 31 33 2}{...}
{p2col :{manlink TE treatment effects} {hline 2}}Introduction to
treatment-effects commands{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
This manual documents commands that use observational data to estimate the
effect caused by getting one treatment instead of another.  In observational
data, treatment assignment is not controlled by those who collect the data;
thus some common variables affect treatment assignment and treatment-specific
outcomes.  Observational data is sometimes called retrospective data or
nonexperimental data, but to avoid  confusion, we will always use the term
"observational data".

{pstd}
When all the variables that affect both treatment assignment and outcomes
are observable, the outcomes are said to be conditionally independent of
the treatment, and the {cmd:teffects} and {cmd:stteffects} estimators may
be used.

{pstd}
When not all of these variables common to both treatment assignment and
outcomes are observable, the outcomes are not conditionally independent 
of the treatment, and {cmd:eteffects}, {cmd:etpoisson}, or {cmd:etregress}
may be used.

{pstd}
{cmd:teffects} and {cmd:stteffects} offer much flexibility in estimators and
functional forms for the treatment-assignment models.  {cmd:teffects} provides
models for continuous, binary, count, fractional, and nonnegative outcome
variables.  {cmd:stteffects} provides many functional forms for survival-time
outcomes.  See
{bf:{mansection TE teffectsintro:[TE] teffects intro}},
{bf:{mansection TE teffectsintroadvanced:[TE] teffects intro advanced}}, and
{bf:{mansection TE stteffectsintro:[TE] stteffects intro}} for more
information.

{pstd}
{cmd:eteffects}, {cmd:etpoisson}, and {cmd:etregress} offer less flexibility
than {cmd:teffects} because more structure must be imposed when conditional
independence is not assumed.
{cmd:eteffects} is for continuous, binary, count, fractional, and nonnegative
outcomes and uses a probit model for binary treatments; see
{manhelp eteffects TE}.
{cmd:etpoisson} is for count outcomes and uses a normal distribution to model
treatment assignment; see {helpb etpoisson:[TE] etpoisson}.
{cmd:etregress} is for linear outcomes and uses
a normal distribution to model treatment assignment; see
{helpb etregress:[TE] etregress}.


    {title:Treatment effects}

{p 8 30 2}{helpb teffects aipw} {space 5} Augmented inverse-probability weighting{p_end}
{p 8 30 2}{helpb teffects ipw} {space 6} Inverse-probability weighting{p_end}
{p 8 30 2}{helpb teffects ipwra} {space 4} Inverse-probability-weighted
regression adjustment{p_end}
{p 8 30 2}{helpb teffects nnmatch} {space 2} Nearest-neighbor matching{p_end}
{p 8 30 2}{helpb teffects psmatch} {space 2} Propensity-score matching{p_end}
{p 8 30 2}{helpb teffects ra} {space 7} Regression adjustment{p_end}

    {title:Survival treatment effects}

{p 8 30 2}{helpb stteffects ipw} {space 4} Survival-time inverse-probability weighting{p_end}
{p 8 30 2}{helpb stteffects ipwra} {space 2} Survival-time inverse-probability-weighted
regression adjustment{p_end}
{p 8 30 2}{helpb stteffects ra} {space 5} Survival-time regression adjustment{p_end}
{p 8 30 2}{helpb stteffects wra} {space 4} Survival-time weighted regression adjustment{p_end}

    {title:Endogenous treatment effects}

{p 8 30 2}{helpb eteffects} {space 9} Endogenous treatment-effects estimation
{p_end}
{p 8 30 2}{helpb etpoisson} {space 9} Poisson regression with endogenous
treatment effects{p_end}
{p 8 30 2}{helpb etregress} {space 9} Linear regression with endogenous
treatment effects{p_end}


