{smcl}
{* *! version 1.0.4  11feb2015}{...}
{viewerdialog estat "dialog sem_estat, message(-eform-) name(sem_estat_eform)"}{...}
{vieweralsosee "[SEM] estat eform" "mansection SEM estateform"}{...}
{findalias asgsemlogit}{...}
{findalias asgsemcombined}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] intro 7" "mansection SEM intro7"}{...}
{vieweralsosee "[SEM] gsem" "help gsem_command"}{...}
{vieweralsosee "[SEM] gsem postestimation" "help gsem_postestimation"}{...}
{viewerjumpto "Syntax" "sem_estat_eform##syntax"}{...}
{viewerjumpto "Menu" "sem_estat_eform##menu"}{...}
{viewerjumpto "Description" "sem_estat_eform##description"}{...}
{viewerjumpto "Options" "sem_estat_eform##options"}{...}
{viewerjumpto "Remarks" "sem_estat_eform##remarks"}{...}
{viewerjumpto "Examples" "sem_estat_eform##examples"}{...}
{title:Title}

{p2colset 5 26 24 2}{...}
{p2col:{manlink SEM estat eform} {hline 2}}Display exponentiated
coefficients{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:estat} {cmd:eform}
[{it:eqnamelist}]
[{cmd:,}
{opt l:evel(#)}
{it:{help sem_estat_eform##display_options:display_options}}]

{phang}
where {it:eqnamelist} is a list of equation names.  In {cmd:gsem}, 
    equation names correspond to the names of the response variables. 
    If no {it:eqnamelist} is specified, exponentiated results for the first
    equation are shown.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > SEM (structural equation modeling) > Other >}
     {bf:Display exponentiated coefficients}


{marker description}{...}
{title:Description}

{pstd}
{cmd:estat eform} is for use after {cmd:gsem} but not {cmd:sem}.

{pstd}
{cmd:gsem} reports coefficients. 
You can obtain exponentiated coefficients and their standard errors
by using {cmd:estat} {cmd:eform} after estimation to redisplay results. 


{marker options}{...}
{title:Options}

{phang}
{opt level(#)};
see {helpb estimation options##level():[R] estimation options};
default is {cmd:level(95)}. 

{marker display_options}{...}
{phang}
{it:display_options}
     control the display of factor variables and more.
     Allowed {it:display_options} are
{opt noci},
{opt nopv:alues},
{opt noomit:ted},
{opt vsquish},
{opt noempty:cells},
{opt base:levels},
{opt allbase:levels},
{opt nofvlab:el},
{opt fvwrap(#)},
{opt fvwrapon(style)},
{opth cformat(%fmt)},
{opt pformat(%fmt)},
{opt sformat(%fmt)}, and
{opt nolstretch}.
See {helpb estimation options##display_options:[R] estimation options}.


{marker remarks}{...}
{title:Remarks}

{pstd}
In some generalized linear response functions, exponentiated coefficients
have a special meaning.  Those special meanings are as follows:

            Common name   Family        Link    Meaning of exp(coef)
	    {hline 60}
            logit         Bernoulli     logit   odds ratio
            ologit        ordinal       logit   odds ratio
            mlogit        multinomial   logit   relative-risk ratio
            Poisson       Poisson       log     incidence-rate ratio
            nbreg         nbreg         log     incidence-rate ratio
	    {hline 60}

            Survival distribution       Meaning of exp(coef)
	    {hline 60}
            exponential                 hazard ratio
            Weibull                     hazard ratio
            gamma                       time ratio
            loglogistic                 time ratio
            lognormal                   time ratio
	    {hline 60}

{pstd}
See {findalias gsemlogit} and {findalias gsemcombined}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse gsem_lbw}{p_end}

{pstd}Fit a model with one logistic regression and one Poisson 
regression{p_end}
{phang2}{cmd:. gsem (low <- ptl age smoke ht lwt i.race ui, logit)}{break}
        {cmd:(ptl <- age smoke ht, poisson)}{p_end}

{pstd}Display odds ratios for the logistic regression{p_end}
{phang2}{cmd:. estat eform low}{p_end}

{pstd}Display incidence-rate ratios for the Poisson regression{p_end}
{phang2}{cmd:. estat eform ptl}{p_end}

{pstd}Display odds ratios and incidence-rate ratios{p_end}
{phang2}{cmd:. estat eform low ptl}{p_end}
