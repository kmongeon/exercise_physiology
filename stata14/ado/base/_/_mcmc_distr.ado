*! version 1.0.9  18mar2016
program _mcmc_distr, sclass
	version 14.0
	gettoken cmd 0 : 0
	_mcmc_distr_`cmd' `0'
end

program _mcmc_distr_checkname, sclass

	args dist context

	local l = bstrlen(`"`dist'"')
	if `l' >= 4 & bsubstr(`"`dist'"',1,max(4,`l')) ==	///
			bsubstr("normal",1,max(4,`l')) {
		local dist normal
	}
	else if `l' >= 7 & bsubstr(`"`dist'"',1,max(7,`l')) ==	///
			bsubstr("lognormal",1,max(7,`l')) {
		local dist lognormal
	}
	else if `l' >= 5 & bsubstr(`"`dist'"',1,max(5,`l')) ==	///
			bsubstr("lnormal",1,max(5,`l')) {
		local dist lognormal
	}
	else if `l' >= 9 & bsubstr(`"`dist'"',1,max(9,`l')) ==	///
			bsubstr("mvnormal0",1,max(9,`l')) {
		local dist mvnormal 
	}
	else if `l' >= 4 & bsubstr(`"`dist'"',1,max(4,`l')) ==	///
			bsubstr("mvn0",1,max(4,`l')) {
		local dist mvnormal
	}
	else if `l' >= 3 & bsubstr(`"`dist'"',1,max(3,`l')) ==	///
			bsubstr("mvnormal",1,max(3,`l')) {
		local dist mvnormal 
	}
	else if `l' >= 9 & bsubstr(`"`dist'"',1,max(9,`l')) ==	///
			bsubstr("zellnersg",1,max(9,`l')) {
		local dist zellnersg
	}
	else if `l' >= 10 & bsubstr(`"`dist'"',1,max(10,`l')) == ///
			bsubstr("zellnersg0",1,max(10,`l')) {
		local dist zellnersg0
	}
	else if `l' >= 4 & bsubstr(`"`dist'"',1,max(4,`l')) ==	///
			bsubstr("uniform",1,max(4,`l')) {
		local dist uniform
	}
	else if `l' >= 3 & bsubstr(`"`dist'"',1,max(3,`l')) ==	///
			bsubstr("exponential",1,max(3,`l')) {
		local dist exponential
	}
	else if `l' >= 4 & bsubstr(`"`dist'"',1,max(4,`l')) ==	///
			bsubstr("dexponential",1,max(4,`l')) {
		local dist dexponential
	}
	else if `l' >= 6 & bsubstr(`"`dist'"',1,max(6,`l')) == ///
			bsubstr("expreg",1,max(6,`l')) {
		local dist expreg
	}
	else if `l' >= 3 & bsubstr(`"`dist'"',1,max(3,`l')) ==	///
			bsubstr("gamma",1,max(3,`l')) {
		local dist gamma
	}
	else if `l' >= 4 & bsubstr(`"`dist'"',1,max(4,`l')) ==	///
			bsubstr("igamma",1,max(4,`l')) {
		local dist igamma
	}
	else if `l' >= 6 & bsubstr(`"`dist'"',1,max(6,`l')) ==	///
			bsubstr("expgamma",1,max(6,`l')) {
		local dist expgamma
	}
	else if `l' >= 4 & bsubstr(`"`dist'"',1,max(4,`l')) ==	///
			bsubstr("beta",1,max(4,`l')) {
		local dist beta
	}
	else if `l' >= 4 & bsubstr(`"`dist'"',1,max(4,`l')) ==	///
			bsubstr("chi2",1,max(4,`l')) {
		local dist chi2
	}
	else if `l' >= 4 & bsubstr(`"`dist'"',1,max(4,`l')) ==	///
			bsubstr("wishart",1,max(4,`l')) {
		local dist wishart
	}
	else if `l' >= 5 & bsubstr(`"`dist'"',1,max(5,`l')) ==	///
			bsubstr("iwishart",1,max(5,`l')) {
		local dist iwishart
	}
	else if `l' >= 4 & bsubstr(`"`dist'"',1,max(4,`l')) ==	///
			bsubstr("jeffreys",1,max(4,`l')) {
		local dist jeffreys
	}
	else if `l' >= 4 & bsubstr(`"`dist'"',1,max(4,`l')) ==	///
			bsubstr("bernoulli",1,max(4,`l')) {
		local dist bernoulli
	}
	else if `l' >= 5 & bsubstr(`"`dist'"',1,max(5,`l')) ==	///
			bsubstr("dbernoulli",1,max(5,`l')) {
		local dist dbernoulli
	}
	else if `l' >= 5 & bsubstr(`"`dist'"',1,max(5,`l')) ==	///
			bsubstr("binomial",1,max(5,`l')) {
		local dist binomial
	}
	else if `l' >= 6 & bsubstr(`"`dist'"',1,max(6,`l')) ==	///
			bsubstr("dbinomial",1,max(6,`l')) {
		local dist dbinomial
	}
	else if `l' >= 5 & bsubstr(`"`dist'"',1,max(5,`l')) ==	///
			bsubstr("index",1,max(5,`l')) {
		local dist index
	}
	else if `l' >= 4 & bsubstr(`"`dist'"',1,max(4,`l')) ==	///
			bsubstr("poisson",1,max(4,`l')) {
		local dist poisson
	}
	else if `l' >= 5 & bsubstr(`"`dist'"',1,max(5,`l')) ==	///
			bsubstr("dpoisson",1,max(5,`l')) {
		local dist dpoisson
	}
	else if `l' >= 10 & bsubstr(`"`dist'"',1,max(10,`l')) == ///
			bsubstr("poissonreg",1,max(10,`l')) {
		local dist poissonreg 
	}
	else if `l' >= 4 & bsubstr(`"`dist'"',1,max(4,`l')) ==	///
			bsubstr("density",1,max(4,`l')) {
		local dist density
	}
	else if `l' >= 7 & bsubstr(`"`dist'"',1,max(7,`l')) ==	///
			bsubstr("logdensity",1,max(7,`l')) {
		local dist logdensity
	}
	else if `l' >= 3 & bsubstr(`"`dist'"',1,max(3,`l')) ==	///
			bsubstr("llf",1,max(3,`l')) {
		local dist logdensity
	}
	else if `l' >= 4 & bsubstr(`"`dist'"',1,max(4,`l')) ==	///
			bsubstr("flat",1,max(4,`l')) {
		local dist logdensity 
	}
	else if `l' >= 5 & bsubstr(`"`dist'"',1,max(5,`l')) ==	///
			bsubstr("logit",1,max(5,`l')) {
		local dist logit
	}
	else if `l' >= 5 & bsubstr(`"`dist'"',1,max(5,`l')) ==	///
			bsubstr("logistic",1,max(5,`l')) {
		local dist logit
	}
	else if `l' >= 8 & bsubstr(`"`dist'"',1,max(8,`l')) ==	///
			bsubstr("binlogit",1,max(8,`l')) {
		local dist binlogit
	}
	else if `l' >= 6 & bsubstr(`"`dist'"',1,max(6,`l')) ==	///
			bsubstr("ologit",1,max(6,`l')) {
		local dist ologit
	}
	else if `l' >= 6 & bsubstr(`"`dist'"',1,max(6,`l')) ==	///
			bsubstr("probit",1,max(6,`l')) {
		local dist probit
	}
	else if `l' >= 7 & bsubstr(`"`dist'"',1,max(7,`l')) ==	///
			bsubstr("oprobit",1,max(7,`l')) {
		local dist oprobit
	}
	else if `l' >= 6 & bsubstr(`"`dist'"',1,max(6,`l')) ==	///
			bsubstr("define",1,max(6,`l')) {
		local dist define
	}
	else {
		capture `dist'
		if _rc == 199 {
			if `"`context'"' == "likelihood" {
				di as err ///
		`"{p}likelihood model {bf:`dist'} "' ///
		"is not supported in option {bf:likelihood()}{p_end}"
			}
			else if `"`context'"' == "prior" {
				di as err `"{p}distribution {bf:`dist'} "' ///
		"is not supported in option {bf:prior()}{p_end}"
			}
			else {
				di as err `"{p}evaluator {bf:`dist'} "' ///
					"is unrecognized{p_end}"
				exit 199
			}
			exit 198
		}
	}
	sreturn local distribution `dist'
end

program _mcmc_distr_expand, sclass
	args dist
	local l = bstrlen(`"`dist'"')
	local title `dist'

	if `l' >= 4 & bsubstr(`"`dist'"',1,max(4,`l')) ==	///
			bsubstr("uniform",1,max(4,`l')) {
		local dist uniform
		local title Uniform
	}
	else if `l' >= 4 & bsubstr(`"`dist'"',1,max(4,`l')) ==	///
			bsubstr("normal",1,max(4,`l')) {
		local dist normal
		local title Normal
	}
	else if `l' >= 7 & bsubstr(`"`dist'"',1,max(7,`l')) ==	///
			bsubstr("lognormal",1,max(7,`l')) {
		local dist lognormal
		local title LogNormal
	}
	else if `l' >= 5 & bsubstr(`"`dist'"',1,max(5,`l')) ==	///
			bsubstr("lnormal",1,max(5,`l')) {
		local dist lognormal
		local title LogNormal
	}
	else if `l' >= 9 & bsubstr(`"`dist'"',1,max(9,`l')) ==	///
			bsubstr("mvnormal0",1,max(9,`l')) {
		local dist mvnormal0
		local title MVN
	}
	else if `l' >= 4 & bsubstr(`"`dist'"',1,max(4,`l')) ==	///
			bsubstr("mvn0",1,max(4,`l')) {
		local dist mvnormal0
		local title MVN
	}
	else if `l' >= 3 & bsubstr(`"`dist'"',1,max(3,`l')) ==	///
			bsubstr("mvnormal",1,max(3,`l')) {
		local dist mvnormal
		local title MVN
	}
	else if `l' >= 4 & bsubstr(`"`dist'"',1,max(4,`l')) ==	///
			bsubstr("bernoulli",1,max(4,`l')) {
		local dist bernoulli
		local title Bernoulli
	}
	else if `l' >= 5 & bsubstr(`"`dist'"',1,max(5,`l')) ==	///
			bsubstr("dbernoulli",1,max(5,`l')) {
		local dist dbernoulli
		local title Bernoulli
	}
	else if `l' >= 5 & bsubstr(`"`dist'"',1,max(5,`l')) ==	///
			bsubstr("binomial",1,max(5,`l')) {
		local dist binomial
		local title Binomial logistic
	}
	else if `l' >= 6 & bsubstr(`"`dist'"',1,max(6,`l')) ==	///
			bsubstr("dbinomial",1,max(6,`l')) {
		local dist dbinomial
		local title Binomial
	}
	else if `l' >= 4 & bsubstr(`"`dist'"',1,max(4,`l')) ==	///
			bsubstr("beta",1,max(4,`l')) {
		local dist beta
		local title Beta
	}
	else if `l' >= 5 & bsubstr(`"`dist'"',1,max(5,`l')) ==	///
			bsubstr("logit",1,max(5,`l')) {
		local dist logit
		local title Logistic
	}
	else if `l' >= 5 & bsubstr(`"`dist'"',1,max(5,`l')) ==	///
			bsubstr("logistic",1,max(5,`l')) {
		local dist logit
		local title Logistic
	}
	else if `l' >= 6 & bsubstr(`"`dist'"',1,max(6,`l')) ==	///
			bsubstr("blogit",1,max(6,`l')) {
		local dist binlogit
		local title Binomial logistic
	}
	else if `l' >= 8 & bsubstr(`"`dist'"',1,max(8,`l')) ==	///
			bsubstr("binlogit",1,max(8,`l')) {
		local dist binlogit
		local title Binomial logistic
	}
	else if `l' >= 6 & bsubstr(`"`dist'"',1,max(6,`l')) ==	///
			bsubstr("ologit",1,max(6,`l')) {
		local dist ologit
		local title Ordered logistic
	}
	else if `l' >= 6 & bsubstr(`"`dist'"',1,max(6,`l')) ==	///
			bsubstr("probit",1,max(6,`l')) {
		local dist probit
		local title Probit
	}
	else if `l' >= 7 & bsubstr(`"`dist'"',1,max(7,`l')) ==	///
			bsubstr("oprobit",1,max(7,`l')) {
		local dist oprobit
		local title Ordered probit
	}
	else if `l' >= 3 & bsubstr(`"`dist'"',1,max(3,`l')) ==	///
			bsubstr("exponential",1,max(3,`l')) {
		local dist exponential
		local title Exponential
	}
	else if `l' >= 4 & bsubstr(`"`dist'"',1,max(4,`l')) ==	///
			bsubstr("dexponential",1,max(4,`l')) {
		local dist dexponential
		local title Exponential
	}
	else if `l' >= 3 & bsubstr(`"`dist'"',1,max(3,`l')) ==	///
			bsubstr("geometric",1,max(3,`l')) {
		local dist geometric
		local title Geometric
	}
	else if `l' >= 3 & bsubstr(`"`dist'"',1,max(3,`l')) ==	///
			bsubstr("gamma",1,max(3,`l')) {
		local dist gamma
		local title Gamma
	}
	else if `l' >= 4 & bsubstr(`"`dist'"',1,max(4,`l')) ==	///
			bsubstr("igamma",1,max(4,`l')) {
		local dist igamma
		local title InvGamma
	}
	else if `l' >= 4 & bsubstr(`"`dist'"',1,max(4,`l')) ==	///
			bsubstr("poisson",1,max(4,`l')) {
		local dist poisson
		local title Poisson
	}
	else if `l' >= 5 & bsubstr(`"`dist'"',1,max(5,`l')) ==	///
			bsubstr("dpoisson",1,max(5,`l')) {
		local dist dpoisson
		local title Poisson
	}
	else if `l' >= 10 & bsubstr(`"`dist'"',1,max(10,`l')) == ///
			bsubstr("poissonreg",1,max(10,`l')) {
		local dist poissonreg
		local title Poisson
	}
	else if `l' >= 4 & bsubstr(`"`dist'"',1,max(4,`l')) ==	///
			bsubstr("chi2",1,max(4,`l')) {
		local dist chi2
		local title ChiSquared
	}
	else if `l' >= 3 & bsubstr(`"`dist'"',1,max(3,`l')) ==	///
			bsubstr("llf",1,max(3,`l')) {
		local dist logdensity
		local title Generic
		local llf llf
	}
	else if `l' >= 7 & bsubstr(`"`dist'"',1,max(7,`l')) ==	///
			bsubstr("logdensity",1,max(7,`l')) {
		local dist logdensity
		local title LogDensity
	}
	else if `l' >= 4 & bsubstr(`"`dist'"',1,max(4,`l')) ==	///
			bsubstr("density",1,max(4,`l')) {
		local dist density
		local title Density
	}
	else if `l' >= 4 & bsubstr(`"`dist'"',1,max(4,`l')) ==	///
			bsubstr("flat",1,max(4,`l')) {
		local dist logdensity
		local title Flat
	}
	else if `l' >= 4 & bsubstr(`"`dist'"',1,max(4,`l')) ==	///
			bsubstr("jeffreys",1,max(4,`l')) {
		local dist jeffreys
		local title Jeffreys
	}
	else if `l' >= 5 & bsubstr(`"`dist'"',1,max(5,`l')) ==	///
			bsubstr("index",1,max(5,`l')) {
		local dist index
		local title Index
	}
	else if `l' >= 4 & bsubstr(`"`dist'"',1,max(4,`l')) ==	///
			bsubstr("wishart",1,max(4,`l')) {
		local dist wishart
		local title Wishart
	}
	else if `l' >= 5 & bsubstr(`"`dist'"',1,max(5,`l')) ==	///
			bsubstr("iwishart",1,max(5,`l')) {
		local dist iwishart
		local title InvWishart
	}
	else if `l' >= 9 & bsubstr(`"`dist'"',1,max(9,`l')) ==	///
			bsubstr("zellnersg",1,max(9,`l')) {
		local dist zellnersg
		local title ZellnersG
	}
	else if `l' >= 10 & bsubstr(`"`dist'"',1,max(10,`l')) ==  ///
			bsubstr("zellnersg0",1,max(10,`l')) {
		local dist zellnersg0
		local title ZellnersG
	}
	else if `l' >= 4 & bsubstr(`"`dist'"',1,max(4,`l')) ==	///
			bsubstr("constant",1,max(4,`l')) {
		local dist constant
		local title Constant
	}
	else if `l' >= 4 & bsubstr(`"`dist'"',1,max(4,`l')) ==	///
			bsubstr("Constant",1,max(4,`l')) {
		local dist constant
		local title Constant
	}
	else {
		local dist  ""
		local title ""
	}
	sreturn local distribution `dist'
	sreturn local title `title'
	sreturn local llf `llf'
end

program  _mcmc_ntrials, sclass

	args ylist dist distparams touse
	gettoken ntrials distparams : distparams, ///
		match(paren) parse(",") bindcurly
	if `"`ntrials'"' == "," {
		gettoken ntrials : distparams, match(paren) parse(",") bindcurly
	}
	if `"`ntrials'"' == "" {
		di as err "number of trials must be " ///
			  "specified with likelihood {bf:`dist'()}"
		exit 198
	}
	capture confirm integer number `ntrials'
	if _rc {
		capture confirm variable `ntrials'
		if _rc {
			di as err ///
			"likelihood {bf:`dist'()} " ///
				"must contain a variable or a number."
			exit 198
			/*di as err ///
		"option {bf:binomial()} in option {bf:likelihood()}: " ///
		"{bf:`ntrials'} must be a variable or a number."
			exit 198*/
		}
		sreturn local ntrials = `"(`ntrials')"'
	}
	else {
		capture assert `ntrials' > 0
		if _rc {
			di as err "invalid specification of " ///
				  "likelihood {bf:`dist'()}; "
			di as err "{p 4 4 2}Number of trials must be " ///
				  "a positive integer.{p_end}"
			exit 198
		}
		sreturn local ntrials = `"`ntrials'"'
	}
	tempvar tempv
	capture generate `tempv' = `ylist' > `ntrials' ///
		if `touse' &  `ylist' != .
	if _rc == 0 {
		summarize `tempv', meanonly
		if `r(max)' > 0 {
			di as err ///
	"{bf:`dist'()}: {bf:`ylist'} > {bf: `ntrials'} in some cases."
			exit 499
		}
	}
end

program _mcmc_distr_likelihood, sclass

	args dist ylist xlist distrparams distopts noxbok touse isnl llf

	local nyargs 0
	local nxargs 0
	local ndargs 0

	_mcmc_distr_expand `dist'
	if `"`s(distribution)'"' == "" {
		di as err `"{p}likelihood model {bf:`dist'} "' ///
			"is not supported in option {bf:likelihood()}{p_end}"
		exit 198
	}
	local dist `s(distribution)'

	local likmodel "Bayesian regression"

	// strip end spaces 
	local xlist `xlist'
	local ylist `ylist'
	local toklist `xlist'
	local toklist : subinstr local toklist "{" "(", all
	local toklist : subinstr local toklist "}" ")", all
	local nlm 0
	while `"`toklist'"' != "" {
		gettoken tok toklist: toklist, parse(",") match(paren) bind
		if "`paren'" == "(" {
			local nlm 1
		}
		if `"`tok'"' == "," {
			continue
		}
		if `"`tok'"' == "0" {
			//di as err "too few variables specified"
			error 102
		}
		local `++nxargs'
	}
	// xlist is lost 
	local toklist `ylist'
	// ylist is kept 
	while `"`toklist'"' != "" {
		gettoken tok toklist: toklist, match(paren) bind
		local `++nyargs'
	}

	if ("`dist'"!="normal" & "`dist'"!="mvnormal") {
		local SYNOPTS OFFset(varname numeric)
	}
	if ("`dist'"=="binomial" | "`dist'"=="binlogit") {
		local SYNOPTS `SYNOPTS' NOGLMTRansform
	}
	if ("`dist'"=="poisson") {
		local SYNOPTS `SYNOPTS' EXPosure(varname numeric)
	}
	if ("`dist'"=="poisson" | "`dist'"=="exponential") {
		local SYNOPTS `SYNOPTS' NOGLMTRansform
	}
	if ("`dist'"=="mlogit") {
		local SYNOPTS `SYNOPTS' BASEoutcome(integer 0)
	}
	if ("`dist'"=="coxph") {
		local SYNOPTS `SYNOPTS' FAILure(varname numeric)
	}

	local 0 , `distopts'
	syntax [, `SYNOPTS' * ]
	if `"`offset'"' != "" & `isnl' {
		di as error "{bf:offset()} not allowed with nonlinear equations"
		exit 198 
	}

	if ("`options'"!="") {
		di as err "{p}option {bf:`options'} is not supported " ///
			  "by likelihood model {bf:`dist'}{p_end}"
		exit 198
	}

	local distname "`dist'"
	if `"`dist'"' == "binlogit" {
		local dist binomial
	}
	if `"`dist'"' == "binomial" & `"`noglmtransform'"' == "" {
		local dist binlogit
	}

	local specerror ///
	       `"invalid specification {bf:`distname'} in option {bf:likelihood()}"'

	_mcmc_parse args `distrparams'
	local distrparams `s(args)'
	local ndargs `s(nargs)'	
	local optinitial

	if `"`dist'"' == "normal" {
		if `ndargs' < 1 {
			di as err ///
			"invalid specification of likelihood {bf:`distname'};"
			di as err "{p 4 4 2}You must specify"
			di as err "a variance argument.{p_end}"
			exit 198 
		}
		if `"`noxbok'"' == "" {
			if `nxargs' != 1 {
				di as err ///
			"invalid specification of likelihood {bf:`distname'};"
				di as err "{p 4 4 2}You must specify"
				di as err "a linear predictor when option"
				di as err "{bf:noconstant} is specified.{p_end}"
				exit 198
			}
			if `nxargs' != 1 | `ndargs' != 1 {
				di as err `"`specerror'"'
				exit 198 
			}
			capture confirm number `distrparams'
			if !_rc {
				if `distrparams'<0 {
di as err "invalid specification of likelihood {bf:`dist'()}:"
di as err "variance must be > 0"
exit 198
				}
			}
		}
		else {
			if `nxargs'+`ndargs' > 3 {
				di as err `"`specerror'"'
				exit 198 
			}
		}
		// last arg is var 
		if `"`s(param`ndargs')'"' != "" {
			local optinitial =	///
				`"`s(param`ndargs')' 1 `optinitial'"'
		}
		local likmodel "Bayesian normal regression"
	} 
	else if `"`dist'"' == "lognormal" {
		if `ndargs' < 1 {
			di as err ///
			"invalid specification of likelihood {bf:`distname'};"
			di as err "{p 4 4 2}You must specify"
			di as err "a variance argument.{p_end}"
			exit 198 
		}
		if `"`noxbok'"' == "" {
			if `nxargs' != 1 {
				di as err ///
			"invalid specification of likelihood {bf:`distname'};"
				di as err "{p 4 4 2}You must specify"
				di as err "a linear predictor when option"
				di as err "{bf:noconstant} is specified.{p_end}"
				exit 198 
			}
			if `nxargs' != 1 | `ndargs' != 1 {
				di as err `"`specerror'"'
				exit 198 
			}
			capture confirm number `distrparams'
			if !_rc {
				if `distrparams'<0 {
di as err "invalid specification of likelihood {bf:`dist'()}:"
di as err "variance must be > 0"
exit 198
				}
			}
		}
		else {
			if `nxargs'+`ndargs' > 3 {
				di as err `"`specerror'"'
				exit 198
			}
		}
		// last arg is var 
		if `"`s(param`ndargs')'"' != "" {
			local optinitial =	///
				`"`s(param`ndargs')' 1 `optinitial'"'
		}
		if `"`offset'"' != "" {
			local ylist `ylist' `offset'
		}	
		local likmodel "Bayesian lognormal regression"
	}
	else if `"`dist'"' == "exponential" {
		if `nxargs'+`ndargs' != 1 {
			di as err `"`specerror'"'
			exit 198
		}
		if `nxargs' == 1 | `ndargs' == 0 {
			if `"`noglmtransform'"' == "" {
				// exponential regression
				local dist expreg
			}
		}
		else {
			// last arg is lambda
			if `"`s(param`ndargs')'"' != "" {
				local optinitial = ///
					`"`s(param`ndargs')' 1 `optinitial'"'
			}
		}
		/*if `"`noglmtransform'"' != "" & `"`offset'"' != "" {
			di as err "option {bf:`distname'()} in " ///
				  "option {bf:likelihood()}: "
			di as err "{p 4 4 2}Offset is not supported when {bf:noglmtransform} is specified.{p_end}"
			exit 198
		}*/
		if `"`offset'"' != "" {
			local ylist `ylist' `offset'
			local offset
		}
		local likmodel "Bayesian exponential regression"
	}
	else if `"`dist'"' == "dexponential" {
		if `nxargs' != 0 | `ndargs' != 1 {
			di as err `"`specerror'"'
			exit 198
		}
		gettoken meanpar: distrparams, match(paren) parse(",") bindcurly
		if `"`meanpar'"' == `"`s(param1)'"' {
			local optinitial = `"`meanpar' 1 `optinitial'"'
		}
		if `"`offset'"' != "" {
			di as err "option {bf:`distname'()} in " ///
				  "option {bf:likelihood()}: "
			di as err "{p 4 4 2}Offset is not supported.{p_end}"
			exit 198
		}
		local dist exponential
		local likmodel "Bayesian exponential model"
	}
	else if `"`dist'"' == "mvnormal" {
		if `"`xlist'"' == "" {
			//di as err "too few variables specified"
			error 102
		}
		if `ndargs' < 1 {
			di as err ///
			"invalid specification of likelihood {bf:`distname'};"
			di as err "{p 4 4 2}You must specify a covariance"
			di as err "matrix as an argument.{p_end}"
			exit 198 
		}
		if `ndargs' != 1 {
			di as err `"`specerror'"'
			exit 198 
		}
		if `nxargs' > 0 & `nyargs' != `nxargs' {
			di as err `"`specerror'"'
			exit 198 
		}
		local likmodel "Bayesian multivariate normal regression"
	}
	else if `"`dist'"' == "probit" {
		if `nxargs' == 0 {
			di as err ///
			"invalid specification of likelihood {bf:`distname'};"
			di as err "{p 4 4 2}Independent variables must be "
			di as err "specified if option {bf:noconstant} is used.{p_end}"
			exit 102
		}
		if `nxargs'+`ndargs' < 1 | `nxargs'+`ndargs' > 2 {
			di as err `"`specerror'"'
			exit 198 
		}
		if `"`offset'"' != "" {
			local ylist `ylist' `offset'
		}
		local likmodel "Bayesian probit regression"
	}
	else if `"`dist'"' == "logit" {
		if `nxargs' == 0 {
			di as err ///
			"invalid specification of likelihood {bf:`distname'};"
			di as err "{p 4 4 2}Independent variables must be "
			di as err "specified if option {bf:noconstant} is used.{p_end}"
			exit 102
		}	
		if `nxargs' + `ndargs' != 1 {
			di as err `"`specerror'"'
			exit 198
		}
		if `"`offset'"' != "" {
			local ylist `ylist' `offset'
		}
		local likmodel "Bayesian logistic regression"
	}
	else if `"`dist'"' == "dbernoulli" {
		if `ndargs' != 1 {
			di as err ///
			"invalid specification of likelihood {bf:`distname'()};"
			di as err "{p 4 4 2}You must specify an argument.{p_end}"
			exit 198
		}
		if `nxargs' != 0 | `ndargs' != 1 {
			di as err `"`specerror'"'
			exit 198
		}

		local tokens `"`distrparams'"'
		gettoken probpar tokens: tokens, ///
			match(paren) parse(",") bindcurly
		if `"`probpar'"' == `"`s(param1)'"' {
			if `"`probpar'"' != "" {
				local optinitial = `"`probpar' 0.5 `optinitial'"'
			}
		}
		else if `"`paren'"' != "(" {
			di as err ///
			"invalid specification of likelihood {bf:`distname'()};"
			di as err "{p 4 4 2}Probability of success must be " ///
				  "a scalar parameter or an expression.{p_end}"
			exit 198
		}
		local distrparams `"`s(args)'"'

		if `"`offset'"' != "" {
			di as err "option {bf:`distname'()} in " ///
				  "option {bf:likelihood()}: "
			di as err "{p 4 4 2}Offset is not supported.{p_end}"
			exit 198
		}
		local dist bernoulli
		local likmodel "Bayesian Bernoulli model"
	}
	else if `"`dist'"' == "binomial" | `"`dist'"' == "dbinomial" {

		local tokens `"`distrparams'"'
		if `ndargs' == 0 {
			di as err ///
			"invalid specification of likelihood {bf:`distname'()};"
			di as err "{p 4 4 2}You must specify an argument.{p_end}"
			exit 198
		}
		else if `ndargs' == 1 {
			if `nxargs' == 0 {
			di as err ///
			"invalid specification of likelihood {bf:`distname'()};"
			di as err "{p 4 4 2}You must specify independent "
			di as err "variable or include constant term.{p_end}"
			exit 198
			}
		}
		else {
		
		if `ndargs' != 2 {
			di as err ///
			"invalid specification of likelihood {bf:`distname'()};"
			di as err "{p 4 4 2}You must specify two arguments.{p_end}"
			exit 198
		}
		if `nxargs' > 0 {
			di as err ///
			"invalid specification of likelihood {bf:`distname'()}:"
			di as err "too many variables specified"
			exit 198
		}
		if `nxargs' != 0 | `ndargs' != 2 {
			di as err `"`specerror'"'
			exit 198
		}
		
		gettoken probpar tokens: tokens, ///
			match(paren) parse(",") bindcurly
		if `"`probpar'"' == `"`s(param1)'"' {
			if `"`probpar'"' != "" {
				local optinitial = `"`probpar' 0.5 `optinitial'"'
			}
		}
		else if `"`paren'"' != "(" {
			di as err ///
			"invalid specification of likelihood {bf:`distname'()};"
			di as err "{p 4 4 2}Probability of success must be " ///
				  "a scalar parameter or an expression.{p_end}"
			exit 198
		}
		
		} // if `ndargs' != 1

		_mcmc_ntrials `"`ylist'"' "`distname'" `"`tokens'"' `"`touse'"'
		local distrparams `"`s(args)'"'

		if `"`offset'"' != "" {
			di as err "option {bf:`distname'()} in " ///
				  "option {bf:likelihood()}: "
			di as err "{p 4 4 2}Offset is not supported.{p_end}"
			exit 198
		}
		
		local dist binomial
		local likmodel "Bayesian binomial model"
	}
	else if `"`dist'"' == "binlogit" {
		if `ndargs' != 1 {
			di as err ///
			"invalid specification of likelihood {bf:`distname'()};"
			di as err "{p 4 4 2}You must specify an argument.{p_end}"
			exit 198
		}
		_mcmc_ntrials `"`ylist'"' "`distname'" `"`distrparams'"' `"`touse'"'
		local distrparams `"`s(args)'"'
		
		if `nxargs' < 1 {
			local xlist 0
		}
		if `"`offset'"' != "" {
			local ylist `ylist' `offset'
		}
		local likmodel "Bayesian binomial regression"
	}
	else if `"`dist'"' == "ologit" | `"`dist'"' == "oprobit" {

		if `ndargs' != 0 {
			di as err ///
			"invalid specification of likelihood {bf:`distname'};"
			di as err "{p 4 4 2}Independent variables must be "
			di as err "specified if option {bf:noconstant} is used.{p_end}"
			exit 102
		}
		if `nyargs' != 1 {
			di as err "{depvar} must be specified"
			exit 102
		}
		if `nxargs' < 1 {
			local xlist 0
		}
		qui tabulate `ylist' if `touse'
		if r(r) < 2 {
			di as err "too few categories in variable {bf:`ylist'}"
			exit 148
		}
		local i 1
		while `i' < r(r) {
			if `"`distrparams'"' != "" ///
				local distrparams `distrparams',
			local distrparams `distrparams' {`ylist':_cut`i'}
			local `++i'
		}
		if `"`offset'"' != "" {
			local ylist `ylist' `offset'
			local offset
		}
		if `"`dist'"' == "ologit" {
			local likmodel "Bayesian ordered logit regression"
		}
		if `"`dist'"' == "oprobit" {
			local likmodel "Bayesian ordered probit regression"
		}
	}
	else if `"`dist'"' == "dpoisson" {
		if `nxargs' != 0 | `ndargs' != 1 {
			di as err `"`specerror'"'
			exit 198
		}
		gettoken meanpar: distrparams, match(paren) parse(",") bindcurly
		if `"`meanpar'"' == `"`s(param1)'"' {
			local optinitial = `"`meanpar' 1 `optinitial'"'
		}
		if `"`offset'"' != "" {
			di as err "option {bf:`distname'()} in " ///
				  "option {bf:likelihood()}: "
			di as err "{p 4 4 2}Offset is not supported.{p_end}"
			exit 198
		}
		local dist poisson
		local likmodel "Bayesian Poisson model"
	}
	else if `"`dist'"' == "poisson" {
		if `nxargs' + `ndargs' != 1 {
			di as err `"`specerror'"'
			exit 198
		}
		if `nxargs' == 1 | `ndargs' == 0 {
			if `"`noglmtransform'"' == "" { // poisson regression
				local dist poissonreg
			}
		}
		else {
			// last arg is lambda 
			if `"`s(param`ndargs')'"' != "" {
				local optinitial =	///
					`"`s(param`ndargs')' 1 `optinitial'"'
			}
		}
		if `"`exposure'"' != "" & `"`offset'"' != "" {
			di as err "option {bf:offset()} and {bf:exposure()} may not be combined"
			exit 198
		}
		/*if `"`noglmtransform'"' != "" & `"`offset'"' != "" {
			di as err "option {bf:`distname'()} in " ///
				  "option {bf:likelihood()}: "
			di as err "{p 4 4 2}Offset is not supported when {bf:noglmtransform} is specified.{p_end}"
			exit 198
		}
		if `"`noglmtransform'"' != "" & `"`exposure'"' != "" {
			di as err "option {bf:`distname'()} in " ///
				  "option {bf:likelihood()}: "
			di as err "{p 4 4 2}Exposure is not supported when {bf:noglmtransform} is specified.{p_end}"
			exit 198
		}*/
		if `"`exposure'"' != "" {
			local ylist `ylist' `exposure' `exposure'
		}
		if `"`offset'"' != "" {
			local ylist `ylist' `offset'
		}
		local likmodel "Bayesian Poisson regression"
	}
	else if `"`dist'"' == "density" | `"`dist'"' == "logdensity" {
		// tolerate _cons in -llf- model 
		if `"`xlist'"' == `"`ylist':_cons"' {
			local xlist
			local nxargs 0
		}
		if `nxargs' >= 1  & "`llf'" != "" {
			di as err "{p}{indepvars} not allowed;{p_end}"
			di as err "{p 4 4 2}Option {bf:likelihood(llf())} "
			di as err "may not be specified with independent "
			di as err "variables.  Use substitutable expressions "
			di as err "to include linear predictors in "
			di as err "suboption {bf:llf()}.  For example, "
			di as err "to include a linear combination of "
			di as err "{bf:x1} and {bf:x2}, use "
			di as err "{bf:{c -(}xb: x1 x2{c )-}}.{p_end}"
			exit 198 
		}
		if `nxargs' >= 1 & `ndargs' > 0 {
			di as err ///
			"{bf:`dist'} invalid specification of likelihood"
				exit 198
		}
		else {
			if `ndargs' > 1 {
				di as err ///
			"{bf:`dist'} invalid specification of likelihood"
				exit 198
			}
		}
		if `ndargs' == 0 {
			local distrparams 0
		}
	}
	else {
		di as err "likelihood {bf:`dist'} not supported"
		exit 198
	}

	// update the following 
	sreturn local dist	 `dist'
	sreturn local distparams `distrparams'
	sreturn local xlist	 `xlist'
	sreturn local ylist	 `ylist'
	sreturn local likmodel   `likmodel'
	sreturn local optinitial `optinitial'
end

program _mcmc_distr_prior, sclass
	args dist ylist distrparams distargnum

	_mcmc_distr_expand `dist'
	if `"`s(distribution)'"' == "" {
		di as err `"{p}distribution {bf:`dist'} "' ///
			"is not supported in option {bf:prior()}{p_end}"
		exit 198
	}
	local dist `s(distribution)'

	local nyargs 0
	// strip end spaces
	local ylist `ylist'
	local toklist `ylist'
	// ylist is kept
	while `"`toklist'"' != "" {
		gettoken tok toklist: toklist, match(paren) bind
		local `++nyargs'
	}

	local specerror `"invalid specification of prior {bf:`dist'}"'

	_mcmc_parse args `distrparams'

	local distrparams `s(args)'
	local ndargs `s(nargs)'
	local optinitial
	local minexp 0
	local maxexp -1

	if `"`dist'"' == "normal" | `"`dist'"' == "lognormal" {
		local minexp 1
		local maxexp 2
		// last arg is var
		capture confirm number `s(number`ndargs')'
		if !_rc {
			if `s(number`ndargs')'<=0 {
di as err "invalid specification of prior {bf:`dist'()}:"
di as err "variance must be positive"
exit 198
			}
		}
		if `ndargs' >= 2 {
			if `"`s(param1)'"' != "" {
				local optinitial =	///
					`"`s(param1)' 0 `optinitial'"'
			}
			if `"`s(param2)'"' != "" {
				local optinitial =	///
					`"`s(param2)' 1 `optinitial'"'
			}
		}
		else {
			if `"`s(param`ndargs')'"' != "" {
				local optinitial =	///
					`"`s(param`ndargs')' 1 `optinitial'"'
			}
		}
	}
	else if `"`dist'"' == "uniform" {
		local minexp 2
		local maxexp 2

		local a 0
		local b 0
		capture confirm number `s(number1)'
		if !_rc {
			local a 1
		}
		capture confirm number `s(number2)'
		if !_rc {
			local b 1
		}
		if `a' & `b' {
			if `s(number1)'>=`s(number2)' {
di as err "invalid specification of prior {bf:uniform()}:"
di as err "lower bound must be less than upper bound"
exit 198
			}
		}
		if `"`s(param1)'"' != "" {
			local optinitial =	///
				`"`s(param1)' 0 `optinitial'"'
		}
		if `"`s(param2)'"' != "" {
			local optinitial =	///
				`"`s(param2)' 1 `optinitial'"'
		}
	}
	else if `"`dist'"' == "gamma" | `"`dist'"' == "igamma" {
		local minexp 2
		local maxexp 2
		// the 2 params must be positive 
		if `"`s(number1)'"' != "" {
			capture confirm number `s(number1)'
			if _rc == 0 {
				if `s(number1)'<=0 {
di as err "invalid prior distribution {bf:`dist'()}:"
di as err "shape parameter must be positive"
exit 198
				}
			}
		}
		if `"`s(param1)'"' != "" {
			local optinitial = `"`s(param1)' 1 `optinitial'"'
		}
		if `"`s(number2)'"' != "" {
			capture confirm number `s(number2)'
			if _rc == 0 {
				if `s(number2)'<=0 {
di as err "invalid prior distribution {bf:`dist'()}:"
di as err "scale parameter must be positive"
exit 198
				}
			}
		}
		if `"`s(param2)'"' != "" {
			local optinitial = `"`s(param2)' 1 `optinitial'"'
		}
	}
	else if `"`dist'"' == "exponential" {
		local minexp 1
		local maxexp 1
		if `"`s(number1)'"' != "" {
			capture confirm number `s(number1)'
			if _rc == 0 {
				if `s(number1)'<=0 {
di as err "invalid prior distribution {bf:`dist'()}:"
di as err "scale parameter must be positive"
exit 198
				}
			}
		}
		if `"`s(param1)'"' != "" {
			local optinitial =	///
				`"`s(param1)' 1 `optinitial'"'
		}
	}
	else if `"`dist'"' == "beta" {
		local minexp 2
		local maxexp 2
		// the 2 params must be positive
		if `"`s(number1)'"' != "" {
			capture confirm number `s(number1)'
			if _rc == 0 {
				if `s(number1)'<=0 {
di as err "invalid prior distribution {bf:`dist'()}:"
di as err "shape parameter must be positive"
exit 198
				}
			}
		}
		if `"`s(param1)'"' != "" {
			local optinitial = `"`s(param1)' 1 `optinitial'"'
		}
		if `"`s(number2)'"' != "" {
			capture confirm number `s(number2)'
			if _rc == 0 {
				if `s(number2)'<=0 {
di as err "invalid prior distribution {bf:`dist'()}:"
di as err "shape parameter must be positive"
exit 198
				}
			}
		}
		if `"`s(param2)'"' != "" {
			local optinitial = `"`s(param2)' 1 `optinitial'"'
		}
	}
	else if `"`dist'"' == "chi2" {
		local minexp 1
		local maxexp 1
		if `"`s(number1)'"' != "" {
			capture confirm number `s(number1)'
			if _rc == 0 {
				if `s(number1)'<=0 {
di as err "invalid prior distribution {bf:`dist'()}:"
di as err "degrees of freedom must be positive"
exit 198
				}
			}
		}
		if `"`s(param1)'"' != "" {
			local optinitial =	///
				`"`s(param1)' 1 `optinitial'"'
		}
	}
	else if `"`dist'"' == "bernoulli" {
		local minexp 1
		local maxexp 1
		if `"`s(number1)'"' != "" {
			capture confirm number `s(number1)'
			if _rc == 0 {
				if `s(number1)'<0 | `s(number1)'>1 {
di as err "invalid prior distribution {bf:`dist'()}:"
di as err "probability must be in [0,1]"
exit 198
				}
			}
		}
		if `"`s(param1)'"' != "" {
			local optinitial =	///
				`"`s(param1)' 0.5 `optinitial'"'
		}
	}
	else if `"`dist'"' == "binomial" {
		local minexp 2
		local maxexp 2
		if `"`s(number1)'"' != "" {
			capture confirm number `s(number1)'
			if _rc == 0 {
				if `s(number1)'<0 | `s(number1)'>1 {
di as err "invalid prior distribution {bf:`dist'()}:"
di as err "probability must be in [0,1]"
exit 198
				}
			}
		}
		if `"`s(param1)'"' != "" {
			local optinitial =	///
				`"`s(param1)' 0.5 `optinitial'"'
		}
	}
	else if `"`dist'"' == "index" {
		local minexp 1
		local maxexp = 1e6
		
		tokenize "`distrparams'", parse(",")
		local sum = 0
		local hasexpr 0
		while "`1'" != "" {
			capture confirm number `1'
			if !_rc {
				if `1'<0 | `1'>1 {
di as err "invalid prior distribution {bf:`dist'()}:"
di as err "probability must be in [0,1]"
exit 198
				}
				local sum = `sum' + `1'
			}
			else local hasexpr 1
			mac shift 2
		}

		if `hasexpr' & `sum'>=1 {
di as err "invalid prior distribution {bf:`dist'()}:"
di as err "sum of probabilities must be less than 1"
exit 198
		}
		if !`hasexpr' & `sum'!=1 {
di as err "invalid prior distribution {bf:`dist'()}:"
di as err "sum of probabilities must equal 1"
exit 198
		}

		// one-initials
		local i = `s(nargs)'
		local a = 1/`i'
		while `i' > 0 {
			if (`"`s(param`i')'"' != "") {
				local optinitial =	///
					`"`s(param`i')' `a' `optinitial'"'
			}
			local `--i'
		}
	}
	else if `"`dist'"' == "poisson" {
		local minexp 1
		local maxexp 1
		if `"`s(number1)'"' != "" {
			capture confirm number `s(number1)'
			if _rc == 0 {
				if `s(number1)'<=0 {
di as err "invalid prior distribution {bf:`dist'()}:"
di as err "mean parameter must be positive"
exit 198
				}
			}
		}
		if `"`s(param1)'"' != "" {
			local optinitial = ///
				`"`s(param1)' 1 `optinitial'"'
		}
	}
	else if `"`dist'"' == "density" | `"`dist'"' == "logdensity" {
		local minexp 0
		local maxexp 1
		if `ndargs' == 0 {
			local distrparams 0
		}
	}
	else if `"`dist'"' == "mvnormal" {
		local minexp = 2
		local maxexp = `nyargs' + 2
		
		capture confirm number `s(number1)'
		if _rc {
di as err "invalid prior distribution {bf:`dist'(`distrparams')}:"
di as err "dimension must be a positive number"
exit 503
		}

		local i = 2 + `s(number1)'
		if `s(nargs)' != 2 & `s(nargs)' != 3 & `s(nargs)' != `i' {
di as err "invalid prior distribution {bf:`dist'(`distrparams')}:"
			if `i' == 3 {
di as err "{bf:`dist'} requires 2 or 3 arguments"
			}
			else {
di as err "{bf:`dist'} requires 2, 3, or `i' arguments"
			}
exit 198
		}
		if `s(nargs)' == 3 & `s(nargs)' != `i' {
			if `"`s(matrix2)'"' == "" {
di as err `"invalid prior specification: {bf:`dist'(`distrparams')}"'
exit 198
			}
		}
		// zero-initials
		local i = 1 + `s(number1)'
		while `i' > 1 {
			if (`"`s(param`i')'"' != "") {
				local optinitial =	///
					`"`s(param`i')' 0 `optinitial'"'
			}
			local `--i'
		}
	}
	else if `"`dist'"' == "mvnormal0" {
		local minexp 1
		local maxexp 2
		gettoken dim distrparams : distrparams, parse(",")
		if `"`dim'"' != "" {
			capture confirm number `dim'
			if _rc == 0 {
				if `dim' <= 0 {
					local _rc 1
				}
			}
			if _rc {
di as err "invalid prior distribution {bf:`dist'(`distrparams')}:"
di as err "dimension must be a positive number"
exit 503
			}
			local n = `dim' - 1
			local distrparams `"0`distrparams'"'
			while `n' > 0 {
				local distrparams `"0,`distrparams'"'
				local n = `n' - 1
			}
			local distrparams `"`dim',`distrparams'"'
		}
	}
	else if `"`dist'"' == "zellnersg" {
		local minexp = 4
		local maxexp = `nyargs' + 4
	}
	else if `"`dist'"' == "zellnersg0" {
		local minexp 4
		local maxexp 4
		tokenize `"`distrparams'"', parse(",")
		local distrparams `"`1'`2'`3'`4'0,`5'`6'`7'"'
		local dist zellnersg
	}	
	else if `"`dist'"' == "wishart" | `"`dist'"' == "iwishart" {
		local minexp 3
		local maxexp 3
		capture confirm number `s(number1)'
		if _rc != 0 {
			di as err "invalid prior distribution {bf:`dist'()}:"
			di as err "dimension must be a number"
			exit 198 
		}
		// 2nd arg is df
		if `"`s(param2)'"' != "" {
			local optinitial =	///
				`"`s(param2)' 1 `optinitial'"'
		}
	}	
	else if `"`dist'"' == "jeffreys" {
		local minexp 0
		local maxexp 1
		if `"`s(number1)'"' != "" {
			capture confirm number `s(number1)'
			if _rc == 0 {
				if `s(number1)' <= 0 {
					local _rc 1
				}
			}
			if _rc != 0 {
di as err "invalid prior distribution {bf:`dist'()}:"
di as err "dimension must be a positive number"
exit 503
			}
		}
	}
	else {
		di as err `"prior {bf:`dist'} not supported"'
		exit 198
	}

	if `ndargs' < `minexp' {
		local msg = plural(`minexp',"parameter")
		di as err "{p}prior distribution {bf:`dist'} expects at " ///
			"least `minexp' `msg'{p_end}"
		exit 198
	}
	if `ndargs' > `maxexp' {
		di as err "prior distribution {bf:`dist'} has too many " ///
			"parameters"
		exit 198 
	}

	// update the following
	sreturn local distribution	`dist'
	sreturn local distrparams	`distrparams'
	sreturn local ylist		`ylist'
	sreturn local optinitial	`optinitial'
end

