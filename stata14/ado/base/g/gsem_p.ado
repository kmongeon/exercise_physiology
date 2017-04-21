*! version 1.3.2  20jul2016
program gsem_p, sortpreserve
	version 13
	local vv : display "version " string(_caller()) ":"

	tempname tname
	capture noisily `vv' Predict `tname' `0'
	local rc = c(rc)
	capture drop `tname'*
	capture mata: rmexternal("`tname'")
	exit `rc'
end

program Predict
	version 13
	if e(mecmd) == 1 {
		local MEOPTS stdp
	}
	local mip = c(max_intpoints)
	gettoken TNAME 0 : 0
	syntax  anything(id="stub* or newvarlist") 	///
		[if] [in] [,				///
		mu					/// statistics
		pr					///
		xb					///
		`MEOPTS'				///
		LATent					///
		eta					///
		DENsity					///
		DISTribution				///
		SURVival				///
		LATent1(string)				///
		se(string)				///
		EXPression(string)			///
		SCores					///
		NOOFFset				/// options
		FIXEDonly				/// undocumented
		MEANs					/// undocumented
		EBMEANs					///
		MODEs					/// undocumented
		EBMODEs					///
		CONDitional1(string)			///
		CONDitional				///
		UNCONDitional				/// undocumented
		MARGinal				///
		Outcome(string)				///
		EQuation(string)			/// NOT documented
		INTPoints(numlist int max=1 >0 <=`mip')	///
		ITERate(numlist int max=1 >0)		///
		TOLerance(numlist max=1 >=0)		///
		LOG					/// NOT documented
	]

	if "`intpoints'" == "1" {
		di as err "invalid intpoints() option;"
		di as err "intpoints(1) is not allowed by predict"
		exit 198
	}

	CheckXB, `xb'

	// parse statistics

	if `:length local equation' {
		if `:length local outcome' {
			opts_exclusive "outcome() equation()"
		}
		local outcome : copy local equation
	}
	if `:length local expression' {
		local EXP expression()
	}

	local STAT	`mu'		///
			`pr'		///
			`xb'		///
			`stdp'		///
			`latent'	///
			`eta'		///
			`density'	///
			`distribution'	///
			`survival'	///
			`EXP'
	opts_exclusive "`STAT'"

	if "`scores'" != "" {
		GenScores `TNAME' `0'
		exit
	}

	if `:length local latent1' {
		local STAT : list STAT - latent
		opts_exclusive "`STAT' latent()"
		local STAT latent
		local latent latent()
	}
	if `:length local outcome' {
		opts_exclusive "outcome() `latent'"
	}
	if "`STAT'" != "latent" & `:length local se' {
		di as err "option {bf:se(}) requires the {bf:latent} option"
		exit 198
	}
	if "`STAT'" == "" {
		di as txt "(option {bf:mu} assumed)"
		local STAT mu
	}

	// parse options

	if "`unconditional'" != "" {
		opts_exclusive "unconditional `xb'"
		opts_exclusive "unconditional `stdp'"
		opts_exclusive "unconditional `fixedonly'"
		opts_exclusive "unconditional `latent'"
		opts_exclusive "unconditional `ebmeans'"
		opts_exclusive "unconditional `means'"
		opts_exclusive "unconditional `ebmodes'"
		opts_exclusive "unconditional `modes'"
		local marginal marginal
	}
	if "`conditional1'" == "" {
		if "`conditional'" != "" {
			opts_exclusive "conditional `xb'"
			opts_exclusive "conditional `stdp'"
			opts_exclusive "conditional `unconditional'"
			opts_exclusive "conditional `marginal'"
			opts_exclusive "conditional `fixedonly'"
			opts_exclusive "conditional `ebmodes'"
			opts_exclusive "conditional `modes'"
			local means means
		}
	}
	else {
		ParseCond1, `conditional1'
		local condopt "conditional(`conditional1')"
		opts_exclusive "`condopt' `xb'"
		opts_exclusive "`condopt' `stdp'"
		opts_exclusive "`condopt' `unconditional'"
		opts_exclusive "`condopt' `marginal'"
		if "`conditional1'" != "fixedonly" {
			opts_exclusive "`condopt' `fixedonly'"
		}
		else {
			opts_exclusive "`condopt' `latent'"
			local fixedonly fixedonly
		}
		if "`conditional1'" != "ebmeans" {
			opts_exclusive "`condopt' `ebmeans'"
			opts_exclusive "`condopt' `means'"
			opts_exclusive "`condopt' `conditional'"
		}
		else	local means means
		if "`conditional1'" != "ebmodes" {
			opts_exclusive "`condopt' `ebmodes'"
			opts_exclusive "`condopt' `modes'"
		}
		else	local modes modes
	}

	opts_exclusive "`fixedonly' `latent'"
	opts_exclusive "`fixedonly' `ebmeans' `ebmodes' `marginal'"
	opts_exclusive "`stdp' `xb' `ebmeans' `ebmodes' `marginal'"
	if "`ebmeans'" != "" {
		local means means
	}
	if "`ebmodes'" != "" {
		local modes modes
	}

	opts_exclusive "`fixedonly' `means' `modes' `marginal'"
	opts_exclusive "`stdp' `xb' `means' `modes' `marginal'"
	if "`STAT'" == "xb" {
		local STAT eta
		local fixedonly fixedonly
	}
	else if e(k_hinfo) == 0 {
		if "`STAT'" == "latent" {
			di as err "option {bf:`latent'} not allowed;"
			di as err ///
			"no latent variables present in estimation results"
			exit 198
		}
		if "`marginal'" != "" {
			local latopt marginal
		}
		else if "`ebmeans'`means'" != "" {
			local latopt conditional(ebmeans)
		}
		else if "`ebmodes'`modes'" != "" {
			local latopt conditional(ebmodes)
		}
		if "`latopt'" != "" {
			di as txt "{p 0 6 2}"
			di as txt "note: Option {bf:conditional(fixedonly)} "
			di as txt "is assumed and option "
			if "`condopt'" != "" {
				di as txt "{bf:`condopt'}"
			}
			else	di as txt "{bf:`latopt'}"
			di as txt "is ignored because no "
			di as txt "latent variables are present in "
			di as txt "estimation results."
			di as txt "{p_end}"
			local marginal
			local means
			local modes
		}
		else if "`fixedonly'" == "" {
			di as txt "(option {bf:conditional(fixedonly)} assumed)"
		}
		local fixedonly fixedonly
	}
	else {
		if "`stdp'" != "" {
			local fixedonly fixedonly
		}
		if "`fixedonly'`means'`modes'`marginal'" == "" {
			if "`c(marginscmd)'" == "on" {
				local marginal marginal
			}
			else if "`STAT'" == "latent" {
				di as txt "(option {bf:ebmeans} assumed)"
				local means means
			}
			else {
				local means means
				di as txt ///
				"(option {bf:conditional(ebmeans)} assumed)"
			}
		}
	}
	local EBTYPE `means' `modes'
	if "`EBTYPE'" == "" {
		local EBTYPE means
	}

	// postestimation sample

	tempname touse
	mark `touse' `if' `in'

	if "`STAT'" == "stdp" {
		if `:length local outcome' {
			capture _ms_unab outcome : `outcome'
		}
		if `:length local outcome' {
			local depvar : copy local outcome
		}
		else {
			if bsubstr("`e(family1)'",1,4) == "mult" {
				local depvar : coleq e(b)
			}
			else {
				local depvar "`e(depvar)'"
			}
			gettoken depvar : depvar
		}
		if e(mecmd) == 0 {
			capture local vlabel : variable label `depvar'
			if c(rc) | !`:length local vlabel' {
				local vlabel : copy local depvar
			}
			local vlabel `" (`vlabel')"'
		}
		if strpos("`anything'", "*") {
			_stubstar2names `anything', nvars(1)
		}
		else {
			gsem_newvarlist `anything', nvars(1)
		}
		local typ "`s(typlist)'"
		local var "`s(varlist)'"
		local empty 0
		local match 0
		forval i = 1/`e(k_yinfo)' {
		    if "`e(yinfo`i'_name)'" == "`depvar'" {
			if "`e(yinfo`i'_finfo_family)'" == "ordinal" {
			    if "`e(yinfo`i'_xvars)'" == "" {
				local empty 1
			    }
			}
			local match 1
			continue, break
		    }
		}
		if `empty' {
			gen `typ' `var' = 0
		}
		else {
			_predict `typ' `var', stdp equation(`outcome')
		}
		if e(k_hinfo) {
			local fixmsg ", fixed portion only"
		}
		if e(xtcmd) == 1 {
			label var `var' ///
			"S.E. of the linear prediction of `e(depvar)'"
		}
		else {
			label var `var' ///
			"S.E. of the linear prediction`vlabel'`fixmsg'"
		}
		exit
	}

	// All the following mata functions produce a local macro named
	// VARLIST that contains the list of generated variables.

	local offset = "`nooffset'" == ""

	if "`fixedonly'" != "" {
		if "`EXP'" != "" {
			mata: _gsem_predict_exp("`TNAME'",		///
						"`anything'",		///
						"`touse'",		///
						`offset',		///
						"`expression'")
		}
		else if "`STAT'" == "eta" {
			mata: _gsem_predict_xb(	"`TNAME'",		///
						"`anything'",		///
						"`touse'",		///
						`offset',		///
						"`outcome'")
		}
		else if "`STAT'" == "density" {
			mata: _gsem_predict_dens("`TNAME'",		///
						"`anything'",		///
						"`touse'",		///
						`offset',		///
						"`outcome'")
		}
		else if "`STAT'" == "distribution" {
			mata: _gsem_predict_dist("`TNAME'",		///
						"`anything'",		///
						"`touse'",		///
						`offset',		///
						"`outcome'")
		}
		else if "`STAT'" == "survival" {
			mata: _gsem_predict_surv("`TNAME'",		///
						"`anything'",		///
						"`touse'",		///
						`offset',		///
						"`outcome'")
		}
		else {
			mata: _gsem_predict_mu(	"`TNAME'",		///
						"`anything'",		///
						"`touse'",		///
						`offset',		///
						"`STAT'" == "pr",	///
						"`outcome'")
		}
		MISSMSG `VARLIST'
		exit
	}

	if "`marginal'" != "" {
		if "`EXP'" != "" {
			mata: _gsem_predict_mexp("`TNAME'",		///
						"`anything'",		///
						"`touse'",		///
						`offset',		///
						"`expression'",		///
						"`intpoints'")
		}
		else if "`STAT'" == "eta" {
			mata: _gsem_predict_mxb("`TNAME'",		///
						"`anything'",		///
						"`touse'",		///
						`offset',		///
						"`outcome'",		///
						"`intpoints'")
		}
		else if "`STAT'" == "density" {
			mata: _gsem_predict_mdens("`TNAME'",		///
						"`anything'",		///
						"`touse'",		///
						`offset',		///
						"`outcome'",		///
						"`intpoints'")
		}
		else if "`STAT'" == "distribution" {
			mata: _gsem_predict_mdist("`TNAME'",		///
						"`anything'",		///
						"`touse'",		///
						`offset',		///
						"`outcome'",		///
						"`intpoints'")
		}
		else if "`STAT'" == "survival" {
			mata: _gsem_predict_msurv("`TNAME'",		///
						"`anything'",		///
						"`touse'",		///
						`offset',		///
						"`outcome'",		///
						"`intpoints'")
		}
		else {
			mata: _gsem_predict_mmu("`TNAME'",		///
						"`anything'",		///
						"`touse'",		///
						`offset',		///
						"`STAT'" == "pr",	///
						"`outcome'",		///
						"`intpoints'")
		}
		MISSMSG `VARLIST'
		exit
	}

	// The following predictions use empirical Bayes' estimates.

	local log = "`log'" != ""

	if _caller() < 14.2 {
		capture checkestimationsample
		if c(rc) {
			di as err "{p 0 0 2}"
			di as err "data have changed since estimation;{break}"
			di as err ///
"prediction of empirical Bayes `EBTYPE' requires the original " ///
"estimation data"
			di as err "{p_end}"
			exit 459
		}
		tempname esample
		quietly gen byte `esample' = e(sample)
	}
	else {
		local esample : copy local touse
	}

	if "`STAT'" == "latent" {
		mata: _gsem_predict_latent(	"`TNAME'",		///
						"`anything'",		///
						"`se'",			///
						"`esample'",		///
						"`EBTYPE'",		///
						"`latent1'",		///
						"`intpoints'",		///
						"`iterate'",		///
						"`tolerance'",		///
						`log')
		if _caller() < 14.2 {
			capture assert `touse' == `esample'
			if c(rc) {
				FILL `touse' `VARLIST'
			}
		}
		MISSMSG `VARLIST'
		exit
	}

	if "`STAT'" == "pr" {
		local prok 0
		local kdv = e(k_dv)
		forval i = 1/`kdv' {
			if inlist("`e(family`i')'",	"bernoulli",	///
							"ordinal",	///
							"multinomial") {
				local prok 1
				continue, break
			}
		}
		if (e(is_me)) {
			if inlist("`e(family)'",	"bernoulli",	///
							"ordinal",	///
							"multinomial") {
				local prok 1
			}
		}
		if (e(irtcmd) == 1) {
			local prok 1
		}
		if `prok' == 0 {
			di as err "option pr not allowed;"
			di as err "{p 0 0 2}"
			di as err "no depvars were specified using"
			di as err "family(bernoulli),"
			di as err "family(ordinal),"
			di as err "or family(multinomial)"
			di as err "{p_end}"
			exit 198
		}
	}

	quietly d, varlist
	local sortlist `"`r(sortlist)'"'

	mata: _gsem_predict_latent(	"`TNAME'",		///
					"double `TNAME'_*",	///
					"",			///
					"`esample'",		///
					"`EBTYPE'",		///
					"",			///
					"`intpoints'",		///
					"`iterate'",		///
					"`tolerance'",		///
					`log')
	if _caller() < 14.2 {
		capture assert `touse' == `esample'
		if c(rc) {
			FILL `touse' `VARLIST'
		}
	}
	local LATENT : copy local VARLIST

	if "`sortlist'" != "" {
		sort `sortlist'
	}

	if "`EXP'" != "" {
		mata: _gsem_predict_lexp("`TNAME'",		///
					"`anything'",		///
					"`touse'",		///
					`offset',		///
					"`expression'",		///
					"`LATENT'")
		MISSMSG `VARLIST'
		exit
	}

	if "`STAT'" == "eta" {
		mata: _gsem_predict_lxb("`TNAME'",		///
					"`anything'",		///
					"`touse'",		///
					`offset',		///
					"`outcome'",		///
					"`LATENT'")
		MISSMSG `VARLIST'
		exit
	}

	if "`STAT'" == "density" {
		mata: _gsem_predict_ldens("`TNAME'",		///
					"`anything'",		///
					"`touse'",		///
					`offset',		///
					"`outcome'",		///
					"`LATENT'")
		MISSMSG `VARLIST'
		exit
	}

	if "`STAT'" == "distribution" {
		mata: _gsem_predict_ldist("`TNAME'",		///
					"`anything'",		///
					"`touse'",		///
					`offset',		///
					"`outcome'",		///
					"`LATENT'")
		MISSMSG `VARLIST'
		exit
	}

	if "`STAT'" == "survival" {
		mata: _gsem_predict_lsurv("`TNAME'",		///
					"`anything'",		///
					"`touse'",		///
					`offset',		///
					"`outcome'",		///
					"`LATENT'")
		MISSMSG `VARLIST'
		exit
	}

	mata: _gsem_predict_lmu("`TNAME'",		///
				"`anything'",		///
				"`touse'",		///
				`offset',		///
				"`STAT'" == "pr",	///
				"`outcome'",		///
				"`LATENT'")
	MISSMSG `VARLIST'
end

program ParseCond1
	local	OPTS	EBMEANs		///
			EBMODEs		///
			FIXEDonly
	capture syntax [, `OPTS' ]
	if c(rc) {
		di as err "invalid {bf:conditional()} option;"
		syntax [, `OPTS' ]
		error 198 // [sic]
	}
	local cond `ebmeans' `ebmodes' `fixedonly'
	if `:list sizeof cond' > 1 {
		di as err "invalid {bf:conditional()} option;"
		opts_exclusive "`cond'"
	}
	c_local conditional1 `cond'
end

program GenScores
	gettoken TNAME 0 : 0
	syntax  anything(id="stub* or newvarlist") 	///
	[if] [in]					///
	[,						///
		SCores					///
		LOG					/// NOT documented
	]

	if "`e(n_quad)'" == "1" | "`e(intmethod)'" == "laplace" {
		di as err ///
"option scores not allowed with intmethod(laplace) results"
		exit 198
	}

	_score_spec `anything', ignoreeq strict
	local varlist `s(varlist)'
	local typlist `s(typlist)'

	local log = "`log'" != ""

	if `"`if'`in'"' != "" {
		tempname touse
		mark `touse' `if' `in'
	}

	if "`e(intmethod)'" != "" {
		checkestimationsample
	}
	tempname esample
	quietly gen byte `esample' = e(sample)
	foreach var of local varlist {
		gettoken type typlist : typlist
		quietly gen `type' `var' = 0
	}
	mata: _gsem_predict_scores(	"`TNAME'",		///
					"`varlist'",		///
					"`esample'",		///
					`log')
	local colna : colfullna e(b)
	foreach var of local varlist {
		gettoken spec colna : colna
		label var `var' "score for _b[`spec']"
		quietly replace `var' = . if !e(sample)
	}
	if "`touse'" != "" {
		foreach var of local varlist {
			quietly replace `var' = . if !`touse'
		}
	}
	MISSMSG `varlist'
end

program MISSMSG
	tempname touse
	quietly gen byte `touse' = 1
	markout `touse' `0'
	quietly count if !`touse'
	if r(N) {
		di as txt "(`r(N)' missing values generated)"
	}
end

program FILL
	gettoken touse 0 : 0
	foreach var of local 0 {
		local gvars : char `var'[gvars]
		if "`gvars'" != "" {
			quietly bysort `gvars' (`var') : ///
			replace `var' = `var'[1] if `touse'
		}
		quietly replace `var' = . if !`touse'
	}
end

program CheckXB
	syntax [, xb]
	if e(mecmd) == 1 | e(irtcmd) == 1 {
		exit
	}
	if "`xb'" == "" {
		exit
	}
	di as err "option xb not allowed;"
	di as err "{p 0 0 2}"
	di as err "For linear predictions use the {opt eta} option."
	if e(k_hinfo) != 0 {
		di as err "{break}"
		di as err "For linear predictions that treat all latent"
		di as err "variables as fixed at zero, use options"
		di as err "{bf:eta} and {bf:conditional(fixedonly)}."
	}
	di as err "{p_end}"
	exit 198
end

exit
