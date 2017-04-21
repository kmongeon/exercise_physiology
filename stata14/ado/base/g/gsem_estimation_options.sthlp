{smcl}
{* *! version 1.2.1  16apr2014}{...}
{vieweralsosee "[SEM] gsem estimation options" "mansection SEM gsemestimationoptions"}{...}
{vieweralsosee "[SEM] intro 8" "mansection SEM intro8"}{...}
{vieweralsosee "[SEM] intro 9" "mansection SEM intro9"}{...}
{vieweralsosee "[SEM] intro 12" "mansection SEM intro12"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] gsem" "help gsem_command"}{...}
{viewerjumpto "Syntax" "gsem_estimation_options##syntax"}{...}
{viewerjumpto "Description" "gsem_estimation_options##description"}{...}
{viewerjumpto "Options" "gsem_estimation_options##options"}{...}
{viewerjumpto "Remarks" "gsem_estimation_options##remarks"}{...}
{viewerjumpto "Examples" "gsem_estimation_options##examples"}{...}
{title:Title}

{p2colset 5 38 40 2}{...}
{p2col:{manlink SEM gsem estimation options} {hline 2}}Options affecting
estimation{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:gsem} {help sem and gsem path notation:{it:paths}}
... {cmd:,} ... {it:estimation_options}


{synoptset 25}{...}
{synopthdr:estimation_options}
{synoptline}
{synopt :{opt meth:od}{cmd:(}{helpb sem_option_method##method:ml}{cmd:)}}method used to obtain the estimated parameters; only one method available with {cmd:gsem}{p_end}
{synopt :{opt vce}{cmd:(}{it:{help sem_option_method##vcetype:vcetype}{cmd:)}}}{it:vcetype} may be {opt oim}, {opt opg}, {opt r:obust}, or {opt cl:uster} {it:clustvar}{p_end}
{synopt :{opt pw:eights}{cmd:(}{it:{help gsem_estimation_options##weights:varlist}{cmd:)}}}sampling weight variables for each level{p_end}
{synopt :{opt fw:eights}{cmd:(}{it:{help gsem_estimation_options##weights:varlist}{cmd:)}}}frequency weight variables for each level{p_end}
{synopt :{opt iw:eights}{cmd:(}{it:{help gsem_estimation_options##weights:varlist}{cmd:)}}}importance weight variables for each level{p_end}

{synopt :{cmd:from(}{it:{help gsem_estimation_options##matname:matname}}{cmd:)}}specify starting values{p_end}
{synopt :{cmdab:startv:alues(}{it:{help gsem_estimation_options##startvalues():svmethod}}{cmd:)}}method for obtaining starting values{p_end}
{synopt :{cmdab:startg:rid}[{cmd:(}{it:{help gsem_estimation_options##startgrid():gridspec}}{cmd:)}]}perform a grid search to improve starting values{p_end}
{synopt :{opt noest:imate}}do not fit the model; show starting values instead{p_end}

{synopt :{cmdab:intm:ethod(}{it:{help gsem_estimation_options##intmethod:intmethod}}{cmd:)}}integration method{p_end}
{synopt :{opt intp:oints(#)}}set the number of integration (quadrature) points{p_end}
{synopt :{cmdab:adapt:opts(}{it:{help gsem_estimation_options##adaptopts:adaptops}}{cmd:)}}options for adaptive quadrature{p_end}

{synopt :{opt listwise}}apply {cmd:sem}'s (not {cmd:gsem}'s) rules for
omitting observations with missing values{p_end}

{synopt :{opt dnumerical}}use numerical derivative techniques{p_end}

{synopt :{it:{help gsem_estimation_options##maximize_options:maximize_options}}}control the maximization process for specified model; seldom used{p_end}
{synoptline}

{synoptset 25}{...}
{marker intmethod}{...}
{synopthdr :intmethod}
{synoptline}
{synopt :{opt mv:aghermite}}mean-variance adaptive Gauss-Hermite quadrature;
the default{p_end}
{synopt :{opt mc:aghermite}}mode-curvature adaptive Gauss-Hermite quadrature{p_end}
{synopt :{opt gh:ermite}}nonadaptive Gauss-Hermite quadrature{p_end}
{synopt :{opt lap:lace}}Laplacian approximation{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 25}{...}
{marker adaptopts}{...}
{synopthdr :adaptopts}
{synoptline}
{synopt: [{cmd:{ul:no}}]{opt lo:g}}whether to display the iteration log
for each numerical integral calculation{p_end}
{synopt: {opt iter:ate(#)}}set the maximum number of iterations of the
adaptive technique; default is {cmd:iterate(1001)}{p_end}
{synopt: {opt tol:erance(#)}}set tolerance for determining convergence
of the adaptive parameters; default is {cmd:tolerance(1e-8)}{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
These options control how results are obtained,
from starting values, to numerical integration (also known as quadrature),
to how variance estimates are obtained.


{marker options}{...}
{title:Options}

{phang}
{cmd:method(ml)}
     is the default and is the only method available with {cmd:gsem}.  This
     option is included for compatibility with {cmd:sem}, which provides
     several methods; see {helpb sem_option_method:[SEM] sem option method()}.

{phang}
{opt vce(vcetype)} specifies the technique used to obtain the
variance-covariance matrix of the estimates.
See {helpb sem_option_method:[SEM] sem option method()}.

{marker weights}{...}
{phang}
{opth pweights(varlist)}, {opt fweights(varlist)}, and {opt iweights(varlist)}
specify weight variables
to be applied from the observation (first) level to the highest level groups.
Only one of these options may be specified, and none of them are allowed with
crossed models or {cmd:intmethod(laplace)}.

{pmore}
{opt pweights(varlist)} specifies sampling weights and implies
{cmd:vce(robust)} if the {cmd:vce()} option was not also specified.

{pmore}
{opt fweights(varlist)} specifies frequency weights.

{pmore}
{opt iweights(varlist)} specifies importance weights.

{marker matname}{...}
{marker startval}{...}
{marker startvalues()}{...}
{marker startgrid()}{...}
{phang}
{opt from(matname)},
{opt startvalues(svmethod)},
and
{cmd:startgrid}[{cmd:(}{it:gridspec}{cmd:)}]
	specify overriding starting values, specify how other starting values
are to be calculated, and provide the ability to improve the starting values.
All of this is discussed in {manlink SEM intro 12}.  Below we provide a
technical description.

{pmore}
        {opt from(matname)} allows you to specify starting values.
        See {manlink SEM intro 12} and see
        {helpb sem and gsem option from:[SEM] sem and gsem option from()}.
        We show the syntax as {opt from(matname)}, but {cmd:from()}
        has another, less useful syntax, too.
        An alternative to {cmd:from()} is {cmd:init()} used in
        the path specifications;
        see {helpb sem and gsem path notation:[SEM] sem and gsem path notation}.

{pmore}
        {cmd:startvalues()} specifies how starting values are to be
        computed.  Starting values specified in {cmd:from()} override the
        computed starting values, and starting values specified via
        {cmd:init()} override both.

{pmore}
        {cmd:startvalues(zero)} specifies that starting values are to be
        set to 0.

{pmore}
        {cmd:startvalues(constantonly)} builds on {cmd:startvalues(zero)}
        by fitting a constant-only model for each response to obtain
        estimates of intercept and scale parameters, and it substitutes 1 for
        the variances of latent variables.

{pmore}
        {cmd:startvalues(fixedonly)} builds on {cmd:startvalues(constantonly)}
        by fitting a full fixed-effects model for each response variable to
        obtain estimates of coefficients along with intercept and scale
        parameters, and it continues to use 1 for the variances of latent
        variables.

{pmore}
        {cmd:startvalues(ivloadings)} builds on {cmd:startvalues(fixedonly)}
        by using instrumental-variable methods with the generalized residuals
        from the fixed-effects models to compute starting values for
        latent variable loadings, and still uses 1 for the variances of
        latent variables.

{pmore}
        {cmd:startvalues(iv)} builds on {cmd:startvalues(ivloadings)}
        by using instrumental-variable methods with generalized residuals
        to obtain variances of latent variables.

{pmore}
{cmd:startgrid()} performs a grid search on variance components
        of latent variables to improve starting values.  This is well
	discussed in {manlink SEM intro 12}.  No grid search is performed by
	default unless the starting values are found to be not feasible, in
	which case {cmd:gsem} runs {cmd:startgrid()} to perform a "minimal"
	search involving L^3 likelihood evaluations, where L is the number of
	latent variables.  Sometimes this resolves the problem.  Usually,
	however, there is no problem and {cmd:startgrid()} is not run by
	default.  There can be benefits from running {cmd:startgrid()} to get
        better starting values even when starting values are feasible.

{phang}
{cmd:noestimate} specifies that the model is not to be fit.  Instead,
        starting values are to be shown (as modified by the above options
        if modifications were made), and they are to be shown using
        the {cmd:coeflegend} style of output.  An important use of this
        option is before you have modified starting values at all; you can
        type the following:

{phang3}{cmd:. gsem ..., ... noestimate}{p_end}
{phang3}{cmd:. matrix b = e(b)}{p_end}
{phang3}{cmd:. ...} {it:(modify elements of b)} {cmd:...}{p_end}
{phang3}{cmd:. gsem ..., ... from(b)}

{phang}
{opt intmethod(intmethod)},
{opt intpoints(#)}, and
{opt adaptopts(adaptopts)}
        affect how integration for the latent variables is numerically
        calculated.

{pmore}
        {opt intmethod(intmethod)} specifies the method and defaults
        to {cmd:intmethod(mvaghermite)}.  We recommend this method,
        although sometimes the more computationally intensive
        {cmd:intmethod(mcaghermite)} works better for multilevel models
        that are failing to converge. Sometimes it is useful to fall back
	on the less computationally intensive and less accurate
	{cmd:intmethod(ghermite)} and {cmd:intmethod(laplace)} to get the model
	to converge and then perhaps use one of the other more accurate
        methods.  All of this is explained in {manlink SEM intro 12}.
	{cmd:intmethod(laplace)} is the default when fitting crossed models.
        Crossed models are often difficult.

{pmore}
        {opt intpoints(#)} specifies the number of integration points
        to use and defaults to {cmd:intpoints(7)}.  Increasing the number
        increases accuracy but also increases computational time.
        Computational time is roughly proportional to the number specified.
        See {manlink SEM intro 12}.

{pmore}
        {opt adaptopts(adaptopts)} affects the adaptive part of
        adaptive quadrature (another term for numerical integration) and
        thus is relevant only for {cmd:intmethod(mvaghermite)}, 
        {cmd:intmethod(mcaghermite)}, and {cmd:intmethod(laplace)}.

{pmore}
        {cmd:adaptopts()} defaults to
        {cmd:adaptopts(nolog iterate(1001) tolerance(1e-8))}.

{pmore}
[{cmd:no}]{cmd:log}
        specifies whether iteration logs are shown each
        time a numerical integral is calculated.

{pmore}
        {cmd:iterate()} specifies the maximum number of iterations of the
        adaptive technique.

{pmore}
        {cmd:tolerance()} specifies the tolerance for determining convergence
        of the adaptive parameters.  Convergence is declared when the
        relative change in the log likelihood is less than or equal
        to the tolerance.

{phang}
{cmd:listwise} applies {cmd:sem}'s rules rather than {cmd:gsem}'s rules
        for omitting observations with missing values.
        By default, {cmd:gsem} is sometimes able to use observations
        containing missing values for fitting parts of the model.
        {cmd:sem}, meanwhile, applies a listwise-deletion rule
        unless it is using {cmd:method(mlmv)}.  Specifying {cmd:listwise}
        allows us at StataCorp to verify that {cmd:gsem} and {cmd:sem}
        produce the same results.  We find that reassuring.  Actually,
        automated tests verify that results are the same before shipping.
        For your information, {cmd:sem} and {cmd:gsem} use different
        numerical machinery for obtaining results, and thus the near equality
        of results is a strong test that each is coded correctly.
        You may find {cmd:listwise} useful if you are reproducing results
        from another package that uses listwise deletion.

{phang}
{cmd:dnumerical} specifies that during optimization, the gradient vector and
Hessian matrix be computed using numerical techniques instead of analytical
formulas.  By default, {cmd:gsem} uses analytical formulas for computing the
gradient and Hessian for all integration methods except
{cmd:intmethod(laplace)}.

{marker maximize_options}{...}
{phang}
{it:maximize_options}
     specify the standard and rarely specified options for controlling the
     maximization process; see {manhelp maximize R}.  The relevant options for
     {cmd:gsem} are
{opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)}, 
{opt iter:ate(#)}, [{cmd:{ul:no}}]{opt lo:g}, {opt tr:ace}, 
{opt grad:ient}, {opt showstep},
{opt hess:ian},
{opt tol:erance(#)},
{opt ltol:erance(#)},
{opt nrtol:erance(#)}, and
{opt nonrtol:erance}.


{marker remarks}{...}
{title:Remarks}

{pstd}
For more information on {opt vce()}, see
{manlink SEM intro 8} and {manlink SEM intro 9}.

{pstd}
For more information on the other options, see
{manlink SEM intro 12}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse gsem_cfa}{p_end}

{pstd}Fit a two-factor measurement model{p_end}
{phang2}{cmd:. gsem (MathAb -> q1-q8, logit) (MathAtt -> att1-att5, ologit)}{p_end}

{pstd}Compute robust standard errors{p_end}
{phang2}{cmd:. gsem (MathAb -> q1-q8, logit)}{break}
        {cmd:(MathAtt -> att1-att5, ologit), vce(robust)}{p_end}

{pstd}Perform numerical integration using mode-and-curvature adaptive 
Gauss-Hermite quadrature{p_end}
{phang2}{cmd:. gsem (MathAb -> q1-q8, logit)}{break} 
	{cmd:(MathAtt -> att1-att5, ologit), intmethod(mcaghermite)}{p_end}

