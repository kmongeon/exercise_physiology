{smcl}
{* *! version 1.0.10  26jan2015}{...}
{vieweralsosee "[ME] me" "mansection ME me"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ME] Glossary" "help me_glossary"}{...}
{viewerjumpto "Syntax by example" "me##syntax_ex"}{...}
{viewerjumpto "Formal syntax" "me##syntax"}{...}
{viewerjumpto "Description" "me##description"}{...}
{title:Title}

{p2colset 5 16 18 2}{...}
{p2col :{manlink ME me} {hline 2}}Introduction to me commands{p_end}
{p2colreset}{...}


{marker syntax_ex}{...}
{title:Syntax by example}

    {title:Linear mixed-effects models}

{phang}
Linear model of {cmd:y} on {cmd:x} with random intercepts by {cmd:id}

        {cmd:mixed y x || id:}

{phang}
Three-level linear model of {cmd:y} on {cmd:x} with random intercepts by
{cmd:doctor} and {cmd:patient}

        {cmd:mixed y x || doctor: || patient:}

{phang}
Linear model of {cmd:y} on {cmd:x} with random intercepts and coefficients on
{cmd:x} by {cmd:id}

        {cmd:mixed y x || id: x}

{phang}
Same model with covariance between the random slope and intercept

        {cmd:mixed y x || id: x, covariance(unstructured)}

{phang}
Linear model of {cmd:y} on {cmd:x} with crossed random effects for {cmd:id}
and {cmd:week}

        {cmd:mixed y x || _all: R.id || _all: R.week}

{phang}
Same model specified to be more computationally efficient

        {cmd:mixed y x || _all: R.id || week:}

{phang}
Full factorial repeated-measures ANOVA of {cmd:y} on {cmd:a} and {cmd:b} with
random effects by {cmd:field}

        {cmd:mixed y a##b || field:}


    {title:Generalized linear mixed-effects models}

{phang}
Logistic model of {cmd:y} on {cmd:x} with random intercepts by {cmd:id},
reporting odds ratios

        {cmd:melogit y x || id: , or}

{phang}
Same model specified as a GLM

        {cmd:meglm y x || id:, family(bernoulli) link(logit)}

{phang}
Three-level ordered probit model of {cmd:y} on {cmd:x} with random intercepts 
by {cmd:doctor} and {cmd:patient}

        {cmd:meoprobit y x || doctor: || patient:}


{marker syntax}{...}
{title:Formal syntax}

{phang}Linear mixed-effects models

{p 12 18 2}
{opt mixed} {depvar} {it:fe_equation} [{cmd:||} {it:re_equation}] 
	[{cmd:||} {it:re_equation} ...] 
	[{cmd:,} {it:options}]

{phang2}
    where the syntax of the fixed-effects equation, {it:fe_equation}, is

{p 12 24 2}
	[{indepvars}] {ifin}
        [{it:{help mixed##weight:weight}}]
	[{cmd:,} {it:{help mixed##fe_options:fe_options}}]

{phang2}
    and the syntax of a random-effects equation, {it:re_equation}, is the
    same as below for a generalized linear mixed-effects model.


{phang}Generalized linear mixed-effects models

{p 12 18 2}
{cmd:me}{it:cmd} {depvar} {it:fe_equation} [{cmd:||} {it:re_equation}]
	[{cmd:||} {it:re_equation} ...] 
	[{cmd:,} {it:{help meglm##options_table:options}}]

{phang2}
    where the syntax of the fixed-effects equation, {it:fe_equation}, is

{p 12 24 2}
	[{indepvars}] {ifin} [{cmd:,} {it:fe_options}]

{phang2}
    and the syntax of a random-effects equation, {it:re_equation}, is one of
    the following:

{p 8 18 2}
	for random coefficients and intercepts

{p 12 24 2}
	{it:{help varname:levelvar}}{cmd::} [{varlist}]
		[{cmd:,} {it:{help meglm##re_options:re_options}}]

{p 8 18 2}
	for random effects among the values of a factor variable

{p 12 24 2}
	{it:{help varname:levelvar}}{cmd::} {cmd:R.}{varname}

{phang2}
    {it:levelvar} is a variable identifying the group structure for the random
    effects at that level or is {cmd:_all} representing one group comprising
    all observations.{p_end}


{marker description}{...}
{title:Description}

{pstd}
Mixed-effects models are characterized as containing both fixed effects
and random effects.  The fixed effects are analogous to standard
regression coefficients and are estimated directly.  The random effects are
not directly estimated (although they may be obtained postestimation) but are
summarized according to their estimated variances and covariances.  Random
effects may take the form of either random intercepts or random coefficients,
and the grouping structure of the data may consist of multiple levels of
nested groups.  As such, mixed-effects models are also known in the literature
as multilevel models and hierarchical models.
Mixed-effects commands fit mixed-effects models for a variety of distributions
of the response conditional on normally distributed random effects.


    {title:Mixed-effects linear regression}

{p 8 26 2}{helpb mixed} {space 8} Multilevel mixed-effects linear regression{p_end}


{marker GLMM}{...}
    {title:Mixed-effects generalized linear model}

{p 8 26 2}{helpb meglm} {space 8} Multilevel mixed-effects generalized linear model{p_end}


    {title:Mixed-effects binary regression}

{p 8 26 2}{helpb melogit}{space 8}Multilevel mixed-effects logistic regression{p_end}
{p 8 26 2}{helpb meqrlogit}{space 6}Multilevel mixed-effects logistic regression (QR decomposition){p_end}
{p 8 26 2}{helpb meprobit}{space 7}Multilevel mixed-effects probit regression{p_end}
{p 8 26 2}{helpb mecloglog}{space 6}Multilevel mixed-effects complementary log-log regression{p_end}


    {title:Mixed-effects ordinal regression}

{p 8 26 2}{helpb meologit}{space 7}Multilevel mixed-effects ordered logistic regression{p_end}
{p 8 26 2}{helpb meoprobit}{space 6}Multilevel mixed-effects ordered probit regression{p_end}


    {title:Mixed-effects count-data regression}

{p 8 26 2}{helpb mepoisson}{space 6}Multilevel mixed-effects Poisson regression{p_end}
{p 8 26 2}{helpb meqrpoisson}{space 4}Multilevel mixed-effects Poisson regression (QR decomposition){p_end}
{p 8 26 2}{helpb menbreg}{space 8}Multilevel mixed-effects negative binomial regression{p_end}


    {title:Mixed-effects multinomial regression}

{pmore}
Although there is no {cmd:memlogit} command, multilevel mixed-effects
multinomial logistic models can be fit using {cmd:gsem}; see
{findalias gsemtmlogit}.
{p_end}


    {title:Mixed-effects survival model}

{p 8 26 2}{helpb mestreg}{space 6}Multilevel mixed-effects parametric survival
model{p_end}
