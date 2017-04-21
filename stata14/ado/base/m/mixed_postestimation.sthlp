{smcl}
{* *! version 1.2.0  22jan2016}{...}
{viewerdialog predict "dialog mixed_p"}{...}
{viewerdialog estat "dialog mixed_estat"}{...}
{vieweralsosee "[ME] mixed postestimation" "mansection ME mixedpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ME] mixed" "help mixed"}{...}
{viewerjumpto "Postestimation commands" "mixed postestimation##description"}{...}
{viewerjumpto "predict" "mixed postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "mixed postestimation##syntax_margins"}{...}
{viewerjumpto "estat" "mixed postestimation##syntax_estat"}{...}
{viewerjumpto "test" "mixed postestimation##syntax_test"}{...}
{viewerjumpto "lincom" "mixed postestimation##syntax_lincom"}{...}
{viewerjumpto "contrast" "mixed postestimation##syntax_contrast"}{...}
{viewerjumpto "pwcompare" "mixed postestimation##syntax_pwcompare"}{...}
{viewerjumpto "Examples" "mixed postestimation##examples"}{...}
{viewerjumpto "Stored results" "mixed postestimation##results"}{...}
{viewerjumpto "Reference" "mixed postestimation##reference"}{...}
{title:Title}

{p2colset 5 34 36 2}{...}
{p2col :{manlink ME mixed postestimation} {hline 2}}Postestimation tools for
mixed{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after
{cmd:mixed}:

{synoptset 18}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb mixed postestimation##estatdf:estat df}}calculate and display
degrees of freedom for fixed effects{p_end}
{synopt :{helpb mixed postestimation##estatgroup:estat group}}summarize
the composition of the nested groups{p_end}
{synopt :{helpb mixed postestimation##estaticc:estat icc}}estimate
intraclass correlations{p_end}
{synopt :{helpb mixed postestimation##estatcov:estat recovariance}}display
the estimated random-effects covariance matrix (or matrices){p_end}
{synopt :{helpb mixed postestimation##estatwcor:estat wcorrelation}}display
model-implied within-cluster correlations and standard deviations{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
The following standard postestimation commands are also available:

{synoptset 18}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb mixed_postestimation##contrast:contrast}}contrasts and ANOVA-style joint tests of estimates{p_end}
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_hausman
{synopt :{helpb mixed_postestimation##lincom:lincom}}point estimates, standard errors, testing, and inference for linear combinations of coefficients{p_end}
INCLUDE help post_lrtest
{synopt:{helpb mixed_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb mixed postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
{synopt:{helpb mixed postestimation##pwcompare:pwcompare}}pairwise comparisons of estimates{p_end}
{synopt :{helpb mixed_postestimation##test:test}}Wald tests of simple and composite linear hypotheses{p_end}
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 4 4 2}
Syntax for obtaining BLUPs of random effects and the BLUPs' standard errors

{p 8 16 2}
{cmd:predict} {dtype}
{it:{help mixed_postestimation##newvarsspec:newvarsspec}}
{ifin}
{cmd:,}
{opt ref:fects}
[{opth reses:(mixed_postestimation##newvarsspec:newvarsspec)}
{opt relev:el(levelvar)}]


{p 4 4 2}
Syntax for obtaining scores after ML estimation

{p 8 16 2}
{cmd:predict} {dtype}
{it:{help mixed_postestimation##newvarsspec:newvarsspec}}
{ifin} {cmd:,} {cmdab:sc:ores}


{p 4 4 2}
Syntax for obtaining other predictions

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} 
[{cmd:,} {it:statistic} {opt relev:el(levelvar)}]


{marker newvarsspec}{...}
{phang}
{it:newvarsspec} is {it:stub}{cmd:*} or {it:{help newvarlist}}.

{synoptset 18 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{cmd:xb}}linear prediction for the fixed portion of the 
model only; the default{p_end}
{synopt :{cmd:stdp}}standard error of the fixed-portion linear 
prediction{p_end}
{synopt :{opt fit:ted}}fitted values, fixed-portion linear prediction plus
contributions based on predicted random effects{p_end}
{synopt :{opt res:iduals}}residuals, response minus fitted values{p_end}
{p2coldent :* {opt rsta:ndard}}standardized residuals{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help unstarred


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
linear predictions, standard errors, fitted values, residuals, and
standardized residuals.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt xb}, the default, calculates the linear prediction xb
based on the estimated fixed effects (coefficients) in the model.  This
is equivalent to fixing all random effects in the model to their theoretical
mean value of 0.

{phang}
{opt stdp} calculates the standard error of the linear predictor xb.

{marker reffects}{...}
{phang}
{opt reffects} calculates best linear unbiased predictions (BLUPs) of the 
random effects.  By default, BLUPs for all random effects in the model 
are calculated.  However, if the {opt relevel(levelvar)} option is specified,
then BLUPs for only level {it:levelvar} in the model are calculated.  For
example, if {cmd:class}es are nested within {cmd:school}s, then typing

{p 12 16 2}{cmd:. predict b*, reffects relevel(school)}{p_end}

{pmore}
would produce BLUPs at the school level.  You must specify
q new variables, where q is the number of random-effects terms
in the model (or level).   However, it is much easier to just specify 
{it:stub}{cmd:*} and let Stata name the variables {it:stub}{cmd:1},
{it:stub}{cmd:2}, ..., {it:stub}q for you.

{pmore}
{help mixed_postestimation##MLMUS:Rabe-Hesketh and Skrondal (2012, sec. 2.11.2)}
discuss the link between the empirical Bayes predictions and BLUPs and how
these predictions are unbiased.  They are unbiased when the groups associated
with the random effects are expected to vary in repeated samples.  If you
expect the groups to be fixed in repeated samples, then these predictions are
no longer unbiased.

{phang}
{opth reses:(mixed_postestimation##newvarsspec:newvarsspec)}
calculates the standard errors of the BLUPs of the random effects.
By default, standard errors for all BLUPs in the model are calculated.
However, if the {opt relevel(levelvar)} option is specified, then standard
errors for only level {it:levelvar} in the model are calculated; see the
{helpb mixed postestimation##reffects:reffects} option.

{pmore}
You must specify q new variables, where q is the number of
random-effects terms in the model (or level).  However, it is much easier to
just specify {it:stub}{cmd:*} and let Stata name the variables
{it:stub}{cmd:1}, {it:stub}{cmd:2}, ..., {it:stub}q for you.
The new variables will have the same storage type as the corresponding
random-effects variables.

{pmore}
The {cmd:reffects} and {cmd:reses()} options often generate multiple new 
variables at once.  When this occurs, the random effects (or standard 
errors) contained in the generated variables correspond to the order in which
the variance components are listed in the output of {cmd:mixed}.  Still,
examining the variable labels of the generated variables (with the
{cmd:describe} command, for instance) can be useful in deciphering which
variables correspond to which terms in the model.

{phang}
{opt fitted} calculates fitted values, which are equal to the fixed-portion
linear predictor plus contributions based on predicted
random effects, or in mixed-model notation, xb + Zu.   By default, the fitted
values take into account random effects from all levels in the model, however,
if the {opt relevel(levelvar)} option is specified, then the fitted values are
fit beginning at the topmost level down to and including level
{it:levelvar}.  For example, if {cmd:class}es are nested within {cmd:school}s,
then typing

{p 12 16 2}{cmd:. predict yhat_school, fitted relevel(school)}{p_end}

{pmore}
would produce school-level predictions.  That is, the predictions 
would incorporate school-specific random effects but not those for 
each class nested within each school.

{phang}
{opt residuals} calculates residuals, equal to the responses minus fitted 
values.  By default, the fitted values take into account random effects
from all levels in the model; however, if the {opt relevel(levelvar)} option is
specified, then the fitted values are fit beginning at the topmost 
level down to and including level {it:levelvar}.

{phang}
{opt rstandard} calculates standardized residuals, equal to the residuals
multiplied by the inverse square root of the estimated error covariance matrix.

{phang}
{cmd:scores} calculates the parameter-level scores, one for each parameter 
in the model including regression coefficients and variance
components.  The score for a parameter is the first derivative of the
log likelihood (or log pseudolikelihood) with respect to that parameter.
One score per highest-level group is calculated, and it is placed on the
last record within that group.  Scores are calculated in the estimation
metric as stored in {cmd:e(b)}.

{pmore}
{cmd:scores} is not available after restricted maximum-likelihood
(REML) estimation.

{phang}
{opt relevel(levelvar)} specifies the level in the model at which
predictions involving random effects are to be obtained; see the options
above for the specifics.  {it:levelvar} is the name of the model level and is
either the name of the variable describing the grouping at that level or is
{cmd:_all}, a special designation for a group comprising all the estimation
data.


INCLUDE help syntax_margins1

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{cmd:xb}}linear prediction for the fixed portion of the 
model only; the default{p_end}
{synopt :{opt ref:fects}}not allowed with {cmd:margins}{p_end}
{synopt :{opt sc:ores}}not allowed with {cmd:margins}{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt fit:ted}}not allowed with {cmd:margins}{p_end}
{synopt :{opt res:iduals}}not allowed with {cmd:margins}{p_end}
{synopt :{opt rsta:ndard}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for
linear predictions.


{marker syntax_estat}{...}
{marker estatgroup}{marker estatcov}{marker estaticc}{marker estatwcor}{marker estatdf}{...}
{title:Syntax for estat}

{pstd}Summarize the composition of the nested groups

{p 8 14 2}
{cmd:estat} {opt gr:oup} 


{pstd}Estimate intraclass correlations

{p 8 14 2}
{cmd:estat} {opt icc} [{cmd:,} {opt l:evel(#)}] 


{pstd}Display the estimated random-effects covariance matrix (or matrices)

{p 8 14 2}
{cmd:estat} {opt recov:ariance} [{cmd:,} {opt relev:el(levelvar)}
          {opt corr:elation} {help matlist:{it:matlist_options}}]


{pstd}Display model-implied within-cluster correlations and standard deviations

{p 8 14 2}
{cmd:estat} {opt wcor:relation} [{cmd:,} {it:wcor_options}]


{pstd}Report or calculate degrees of freedom for fixed effects

{p 8 14 2}
{cmd:estat} {opt df} [{cmd:,} 
	{opt meth:od}{cmd:(}{help mixed##df_method:{it:df_methods}}{cmd:)}
	{opt post}[{cmd:(}{help mixed##df_method:{it:df_method}}{cmd:)}]
	{opt eim} {opt oim}]


{marker options_estat_wcorrelation}{...}
{synoptset 18}{...}
{synopthdr :wcor_options}
{synoptline}
{synopt :{opt at(at_spec)}}specify the cluster for which you want the
	correlation matrix; default is the first two-level cluster
	encountered in the data{p_end}
{synopt:{opt all}}display correlation matrix for all the data{p_end}
{synopt:{opt cov:ariance}}display the covariance matrix instead of the
	correlation matrix{p_end}
{synopt:{opt list}}list the data corresponding to the correlation matrix{p_end}
{synopt:{opt nosort}}list the rows and columns of the correlation matrix in
	the order they were originally present in the data{p_end}
{synopt :{opth format(%fmt)}}set the display format; default is {cmd:format(%6.3f)}{p_end}
{synopt :{help matlist:{it:matlist_options}}}style and formatting options that control how
	matrices are displayed{p_end}
{synoptline}
{p2colreset}{...}


INCLUDE help menu_estat


{marker des_estat}{...}
{title:Description for estat}

{pstd}
{cmd:estat group} reports the number of groups and minimum, average, and
maximum group sizes for each level of the model.  Model levels are identified
by the corresponding group variable in the data.  Because groups are treated
as nested, the information in this summary may differ from what you would get
if you used the {cmd:tabulate} command on each group variable individually.

{pstd}
{cmd:estat icc} displays the intraclass correlation for pairs of responses at
each nested level of the model.  Intraclass correlations are available for
random-intercept models or for random-coefficient models conditional on
random-effects covariates being equal to 0.  They are not available for
crossed-effects models or with residual error structures other than
independent structures.

{pstd}
{cmd:estat recovariance} displays the estimated variance-covariance matrix 
of the random effects for each level in the model.  Random effects can be
either random intercepts, in which case the corresponding rows and columns of
the matrix are labeled as {cmd:_cons}, or random coefficients, in which case
the label is the name of the associated variable in the data.

{pstd}
{cmd:estat wcorrelation} displays the overall correlation matrix for a given
cluster calculated on the basis of the design of the random effects and their
assumed covariance and the correlation structure of the residuals.  This allows
for a comparison of different multilevel models in terms of the ultimate
within-cluster correlation matrix that each model implies.

{pstd}
{cmd:estat df} calculates and displays the degrees of freedom (DF) for each
fixed effect using the specified methods. This allows for a comparison of
different DF methods.  {cmd:estat df} can also be used to continue with
postestimation using a different DF method without rerunning the mixed model,
which is useful if one wants to change the current DF method after comparing
methods.


{marker option_estat_icc}{...}
{title:Option for estat icc}

{phang}
{opt level(#)}
specifies the confidence level, as a percentage, for confidence intervals.
The default is {cmd:level(95)} or as set by {helpb set level}.


{marker options_estat_recov}{...}
{title:Options for estat recovariance}

{phang}
{opt relevel(levelvar)} specifies the level in the model for which the
random-effects covariance matrix is to be displayed.
By default, the covariance matrices for all levels in the model
are displayed.  {it:levelvar} is the name of the model level and is either the
name of the variable describing the grouping at that level or is {cmd:_all}, a
special designation for a group comprising all the estimation data.

{phang}
{opt correlation} displays the covariance matrix as a correlation matrix.

{phang}
{it:matlist_options} are style and formatting options that control how the
matrix (or matrices) is displayed; see {helpb matlist:[P] matlist} for
a list of options that are available.


{title:Options for estat wcorrelation}

{marker atspec}{...}
{phang}
{opt at(at_spec)} specifies the cluster of observations for which you want the
within-cluster correlation matrix.  {it:at_spec} is

{phang3}
{it:relevel_var} {cmd:=} {it:value}
   [{it:relevel_var} {cmd:=} {it:value} ...]

{pmore}
For example, if you specify

{phang3}
{cmd:. estat wcorrelation, at(school = 33)}

{pmore}
you get the within-cluster correlation matrix for those observations 
in school 33.  If  you specify

{phang3}
{cmd:. estat wcorrelation, at(school = 33 classroom = 4)}

{pmore}
you get the correlation matrix for classroom 4 in school 33.

{pmore}
If {cmd:at()} is not specified, then you get the correlations
for the first level-two cluster encountered in the data.  This is
usually what you want.

{phang}
{opt all} specifies that you want the correlation matrix for all 
the data.  This is not recommended unless you have a relatively small dataset
or you enjoy seeing large N x N matrices.  However, this can prove
useful in some cases.

{phang}
{opt covariance} specifies that the within-cluster covariance matrix be
displayed instead of the default correlations and standard deviations.

{phang}
{opt list} lists the model data for those observations depicted in the
displayed correlation matrix.  This option is useful if you have many
random-effects design variables and you wish to see the represented values of
these design variables.

{phang}
{opt nosort} lists the rows and columns of the correlation matrix in the order
that they were originally present in the data.  Normally,
{cmd:estat wcorrelation} will first sort the data according to level
variables, by-group variables, and time variables to produce correlation
matrices whose rows and columns follow a natural ordering.  {opt nosort}
suppresses this.

{phang}
{opth format(%fmt)} sets the display format for the standard-deviation vector
and correlation matrix.  The default is {cmd:format(%6.3f)}.

{phang}
{it:matlist_options} are style and formatting options that control how the
matrix (or matrices) is displayed; see {helpb matlist:[P] matlist} for
a list of options that are available.


{marker option_estat_df}{...}
{title:Options for estat df}

{phang}
{opth method:(mixed##df_method:df_methods)} specifies a list of methods to
compute DF.  The supported methods are {cmd:residual}, {cmd:repeated},
{cmd:anova}, {cmd:satterthwaite}, and {cmd:kroger}; more than one method may
be specified. Methods {cmd:satterthwaite} and {cmd:kroger} are only available
with REML estimation.  If option {cmd:dfmethod()} was not specified in the
most recently fit {cmd:mixed} model, then option {cmd:method()} is required.
See
{mansection ME mixedRemarksandexamplesSmall-sampleinferenceforfixedeffects:{it:Small-sample inference for fixed effects}} under {it:Remarks and examples}
in {bf:[ME] mixed} for more details.  

{phang}
{cmd:post} causes {cmd:estat df} to behave like a Stata estimation
command.  When {cmd:post} is specified, {cmd:estat df} will post the DF for
each fixed effect as well as everything related to the DF computation to
{cmd:e()} for the method specified in {cmd:method()}.  Thus, after posting,
you could continue to use this DF for other postestimation commands.  For
example, you could use {cmd:test, small} to perform Wald F tests on linear
combination of the fixed effects.

{pmore} 
{cmd:post} may also be specified using the syntax 
{opth post:(mixed##df_method:df_method)}. You must use this syntax if you
specify multiple {it:df_methods} in option {cmd:method()}.  With this syntax,
{cmd:estat df} computes the DF using the method specified in {cmd:post()}
and stores the results in {cmd:e()}. Only one computation method may be
specified using the syntax {cmd:post()}.

{pmore} 
The {it:df_method} specified in {cmd:post()} must be one of the DF methods
specified in option {cmd:method()}. If only one method is specified in option
{cmd:method()}, then one can simply use {cmd:post} to make this DF method
active for postestimation and for {cmd:mixed} replay.

{phang}
{cmd:eim} specifies that the expected information matrix be used in the DF
computation. It can be used only when {cmd:method()} contains {cmd:kroger} or
{cmd:satterthwaite}.  {cmd:eim} is the default and may not be specified
with {cmd:oim}.

{phang}
{cmd:oim} specifies that the observed information matrix be used in the DF
computation. It can be used only when {cmd:method()} contains {cmd:kroger} or
{cmd:satterthwaite} and may not be specified with {cmd:eim}.


{marker syntax_test}{...}
{marker test}{...}
{title:Syntax for test and testparm}

{p 8 16 2}
{cmdab:te:st} {cmd:(}{it:{help test##spec:spec}}{cmd:)}
[{cmd:(}{it:{help test##spec:spec}}{cmd:)} ...]
[{cmd:,} {it:{help test##test_options:test_options}} {opt small}]

{p 8 16 2}
{cmd:testparm}
{varlist}
[{cmd:,} {it:{help test##testparm_options:testparm_options}} {opt small}]


{marker menu_test}{...}
{title:Menu for test and testparm}

{phang}
{bf:Statistics > Postestimation}


{marker des_test}{...}
{title:Description for test and testparm}

{pstd}
{cmd:test} and {cmd:testparm}, by default, perform chi-squared tests of simple
and composite linear hypotheses about the parameters for the most recently fit
{cmd:mixed} model.  They also support F tests with a small-sample
adjustment for fixed effects.{p_end}


{marker options_test}{...}
{title:Options for test and testparm}

{dlgtab:Options}

{phang}
{it:test_options}; see {helpb test:[R] test} options. Options {cmd:df()}, 
{cmd:common}, and {cmd:nosvyadjust} may not be specified together with 
{cmd:small}.
 
{phang}
{it:testparm_options}; see options of {it:testparm} in {helpb test:[R] test}. Options {cmd:df()} and {cmd:nosvyadjust} may not be specified together with 
{cmd:small}.

{phang}
{opt small} specifies that F tests for fixed effects be carried out with
the denominator degrees of freedom (DDF) obtained by the same method used in
the most recently fit {cmd:mixed} model.  If option {cmd:dfmethod()} is not
specified in the previous {cmd:mixed} command, option {opt small} is not
allowed.  For certain methods, the DDF for some tests may not be available.
See
{mansection ME mixedRemarksandexamplesSmall-sampleinferenceforfixedeffects:{it:Small-sample inference for fixed effects}}
in {bf:[ME] mixed} for more details.

 
{marker syntax_lincom}{...}
{marker lincom}{...}
{title:Syntax for lincom}

{p 8 16 2}
{cmd:lincom} {it:{help exp}} 
[{cmd:,} {it:{help lincom##options:lincom_options}} {opt small}]


{marker menu_lincom}{...}
{title:Menu for lincom}

{phang}
{bf:Statistics > Postestimation}


{marker des_lincom}{...}
{title:Description for lincom}

{pstd}
{cmd:lincom}, by default, computes point estimates, standard errors, z
statistics, p-values, and confidence intervals for linear combinations of
coefficients after {cmd:mixed}.  {cmd:lincom} also provides t statistics
for linear combinations of the fixed effects, with the degrees of freedom
calculated by the DF method specified in option {cmd:dfmethod()} of
{cmd:mixed}.


{marker options_lincom}{...}
{title:Options for lincom}

{phang}
{it:lincom_options}; see {helpb lincom:[R] lincom} options. Options {cmd:df()}
may not be specified together with {cmd:small}.

{phang}
{opt small} specifies that t statistics for linear combinations of fixed
effects be displayed with the degrees of freedom obtained by the same method
used in the most recently fit {cmd:mixed} model.  If option {cmd:dfmethod()}
is not specified in the previous {cmd:mixed} command, option {opt small} is
not allowed.  For certain methods, the degrees of freedom for some linear
combinations may not be available.  See
{mansection ME mixedRemarksandexamplesSmall-sampleinferenceforfixedeffects:{it:Small-sample inference for fixed effects}}
in {bf:[ME] mixed} for more details.


{marker syntax_contrast}{...}
{marker contrast}{...}
{title:Syntax for contrast}

{p 8 16 2}
{cmd:contrast} {it:{help contrast##syntax:termlist}} 
[{cmd:,} {it:{help contrast##options_table:contrast_options}} {opt small}]


{marker menu_contrast}{...}
{title:Menu for contrast}

{phang}
{bf:Statistics > Postestimation}


{marker des_contrast}{...}
{title:Description for contrast}

{pstd}
{cmd:contrast}, by default, performs chi-squared tests of linear hypotheses
and forms contrasts involving factor variables and their interactions for the
most recently fit {cmd:mixed} model.  {cmd:contrast} also supports tests
with small-sample adjustments after {cmd:mixed, dfmethod()}.


{marker options_contrast}{...}
{title:Options for contrast}

{phang}
{it:contrast_options}; see {helpb contrast:[R] contrast} options. Options
{cmd:df()} and {cmd:nosvyadjust} may not be specified together with
{cmd:small}.

{phang}
{opt small} specifies that tests for contrasts be carried out with
the DDF obtained by the same method used in
the most recently fit {cmd:mixed} model.  If option {cmd:dfmethod()} is not
specified in the previous {cmd:mixed} command, option {opt small} is not
allowed.  For certain methods, the DDF for some contrasts may not be available.
See
{mansection ME mixedRemarksandexamplesSmall-sampleinferenceforfixedeffects:{it:Small-sample inference for fixed effects}}
in {bf:[ME] mixed} for more details.


{marker syntax_pwcompare}{...}
{marker pwcompare}{...}
{title:Syntax for pwcompare}

{p 8 16 2}
{cmd:pwcompare} {it:{help pwcompare##syntax:marginlist}} 
[{cmd:,} {it:{help pwcompare##options_table:pwcompare_options}} {opt small}]


{marker menu_pwcompare}{...}
{title:Menu for pwcompare}

{phang}
{bf:Statistics > Postestimation}


{marker des_pwcompare}{...}
{title:Description for pwcompare}

{pstd}
{cmd:pwcompare} performs pairwise comparisons across the levels of factor
variables from the most recently fit {cmd:mixed} model.  {cmd:pwcompare}, by
default, reports the comparisons as contrasts (differences) of margins along
with z tests or confidence intervals for the pairwise comparisons.
{cmd:pwcompare} also supports t tests with small-sample adjustments after
{cmd:mixed, dfmethod()}.


{marker options_pwcompare}{...}
{title:Options for pwcompare}

{phang}
{it:pwcompare_options}; see {helpb pwcompare:[R] pwcompare} options. Options
{cmd:df()} may not be specified together with {cmd:small}.

{phang}
{opt small} specifies that t tests for pairwise comparisons be carried out
with the degrees of freedom obtained by the same method used in the most
recently fit {cmd:mixed} model with the {cmd:dfmethod()} option.  If option
{cmd:dfmethod()} is not specified in the previous {cmd:mixed} command, option
{opt small} is not allowed.  For certain methods, the degrees of freedom for
some pairwise comparisons may not be available.  See
{mansection ME mixedRemarksandexamplesSmall-sampleinferenceforfixedeffects:{it:Small-sample inference for fixed effects}}
in {bf:[ME] mixed} for more details.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse pig}{p_end}
{phang2}{cmd:. mixed weight week || id: week, covariance(unstructured)}{p_end}

{pstd}Random-effects correlation matrix for level ID{p_end}
{phang2}{cmd:. estat recovariance, correlation}{p_end}

{pstd}Display within-cluster marginal standard deviations and correlations
for a cluster{p_end}
{phang2}{cmd:. estat wcorrelation, format(%4.2g)}{p_end}

{pstd}BLUPS of random effects and standard errors of BLUPs{p_end}
{phang2}{cmd:. predict u1 u0, reffects reses(s1 s0)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse productivity, clear}{p_end}
{phang2}{cmd:. mixed gsp private emp hwy water other unemp || region: ||}
             {cmd:state:}{p_end}

{pstd}Summarize composition of nested groups{p_end}
{phang2}{cmd:. estat group}{p_end}

{pstd}Fitted values at region level{p_end}
{phang2}{cmd:. predict gsp_region, fitted relevel(region)}{p_end}

{pstd}Log likelihood scores{p_end}
{phang2}{cmd:. predict double sc*, scores}{p_end}

{pstd}Compute residual intraclass correlations{p_end}
{phang2}{cmd:. estat icc}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse childweight}
{p_end}
{phang2}{cmd:. mixed weight age || id: age, covariance(unstructured)}{p_end}

{pstd}Display within-cluster correlations for the first cluster{p_end}
{phang2}{cmd:. estat wcorrelation, list}{p_end}

{pstd}Display within-cluster correlations for ID 258{p_end}
{phang2}{cmd:. estat wcorrelation, at(id=258) list}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse pig, clear}{p_end}
{phang2}{cmd:. mixed weight i.week || id:, reml}{p_end}

{pstd}Calculate and compare the DFs using three different methods{p_end}
{phang2}{cmd:. estat df, method(kroger anova repeated)}{p_end}

{pstd}Post the {cmd:kroger} method to {cmd:e()}{p_end}
{phang2}{cmd:. estat df, method(kroger) post}{p_end}

{pstd}Test that coefficient on {cmd:2.week} equals coefficient on
{cmd:3.week}, and adjust for small sample using the Kenward-Roger
method{p_end}
{phang2}{cmd:. test 2.week = 3.week, small}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse pig, clear}{p_end}
{phang2}{cmd:. mixed weight i.week || id:, reml dfmethod(kroger)}{p_end}

{pstd}Test that coefficient on {cmd:2.week} equals coefficient on
{cmd:3.week}, and adjust for small sample using the Kenward-Roger method{p_end}
{phang2}{cmd:. test 2.week = 3.week, small}{p_end}

{pstd}Test that all coefficients on {cmd:i.week} are 0, and adjust for small
sample using the Kenward-Roger method{p_end}
{phang2}{cmd:. testparm i.week, small}{p_end}

{pstd}Estimate a linear combination of fixed effects, and adjust for small 
sample using the Kenward-Roger method{p_end}
{phang2}{cmd:. lincom 2.week + 3.week, small}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse cont3way, clear}{p_end}
{phang2}{cmd:. mixed y sex##race || group:, reml dfmethod(kroger)}{p_end}

{pstd}Test the main effects of each factor with small-sample adjustment using the Kenward-Roger method{p_end}
{phang2}{cmd:. contrast sex race, small}{p_end}

{pstd}Test the reference category contrasts of {cmd:race}, and adjust for small
sample{p_end}
{phang2}{cmd:. contrast r.race, small}{p_end}

{pstd}Test the interaction effects with small-sample adjustment{p_end}
{phang2}{cmd:. contrast race#sex, small}{p_end}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat icc} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(icc}{it:#}{cmd:)}}level-{it:#} intraclass correlation{p_end}
{synopt:{cmd:r(se}{it:#}{cmd:)}}standard errors of level-{it:#} intraclass
         correlation{p_end}
{synopt:{cmd:r(level)}}confidence level of confidence intervals{p_end}
{p2colreset}{...}

{synoptset 15 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(label}{it:#}{cmd:)}}label for level {it:#}{p_end}
{p2colreset}{...}

{synoptset 15 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(ci}{it:#}{cmd:)}}vector of confidence intervals (lower and upper)
        for level-{it:#} intraclass correlation{p_end}
{p2colreset}{...}

{pstd}
For a G-level nested model, {it:#} can be any integer between 2 and G.
{p_end}

{pstd}
{cmd:estat recovariance} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(relevels)}}number of levels{p_end}
{p2colreset}{...}

{synoptset 15 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(Cov}{it:#}{cmd:)}}level-{it:#} random-effects covariance matrix{p_end}
{synopt:{cmd:r(Corr}{it:#}{cmd:)}}level-{it:#} random-effects correlation matrix
	(if option {cmd:correlation} was specified){p_end}
{p2colreset}{...}

{pstd}
For a G-level nested model, {it:#} can be any integer between 2 and G.
{p_end}

{pstd}
{cmd:estat wcorrelation} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(sd)}}standard deviations{p_end}
{synopt:{cmd:r(Corr)}}within-cluster correlation matrix{p_end}
{synopt:{cmd:r(Cov)}}within-cluster variance-covariance matrix{p_end}
{synopt:{cmd:r(G)}}variance-covariance matrix of random effects{p_end}
{synopt:{cmd:r(Z)}}model-based design matrix{p_end}
{synopt:{cmd:r(R)}}variance-covariance matrix of level-one errors{p_end}

{pstd}
{cmd:estat df} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(dfmethods)}}DF methods{p_end}
{p2colreset}{...}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(df)}}parameter-specific DF for each method specified in {cmd:method()}{p_end}
{synopt:{cmd:r(V_df)}}variance-covariance matrix of the estimators when {cmd:kroger} method is specified{p_end}

{pstd}
If {cmd:post()} is specified, {cmd:estat df} also stores the following in {cmd:e()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:e(F)}}overall F test statistic for the method specified in {cmd:post()}{p_end}
{synopt:{cmd:e(ddf_m)}}model DDF for the method specified in {cmd:post()}{p_end}
{synopt:{cmd:e(df_max)}}maximum DF for the method specified in {cmd:post()}{p_end}
{synopt:{cmd:e(df_avg)}}average DF for the method specified in {cmd:post()}{p_end}
{synopt:{cmd:e(df_min)}}minimum DF for the method specified in {cmd:post()}{p_end}
{p2colreset}{...}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:e(dfmethod)}}DF method specified in {cmd:post()}{p_end}
{synopt:{cmd:e(dftitle)}}title for DF method{p_end}
{p2colreset}{...}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(df)}}parameter-specific DFs for the method specified in {cmd:post()}{p_end}
{synopt:{cmd:e(V_df)}}variance-covariance matrix of the estimators when {cmd:kroger} method is posted{p_end}

{pstd}
{cmd:pwcompare} with option {cmd:small} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(L_df)}}degrees of freedom for each margin difference{p_end}
{synopt:{cmd:r(M_df)}}degrees of freedom for each margin estimate{p_end}

{pstd}
{cmd:pwcompare} with options {cmd:post} and {cmd:small} stores the following in {cmd:e()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(L_df)}}degrees of freedom for each margin difference{p_end}
{synopt:{cmd:e(M_df)}}degrees of freedom for each margin estimate{p_end}


{marker reference}{...}
{title:Reference}

{marker MLMUS}{...}
{phang}
Rabe-Hesketh, S., and A. Skrondal. 2012.
{browse "http://www.stata-press.com/books/multilevel-longitudinal-modeling-stata/index.html":{it:Multilevel and Longitudinal Modeling Using Stata}.}
3rd ed. College Station, TX: Stata Press.
{p_end}
