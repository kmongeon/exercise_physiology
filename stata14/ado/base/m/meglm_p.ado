*! version 1.2.1  01aug2016
program meglm_p, eclass
	version 13
	local vv : di "version " string(_caller()) ", missing:"
	
	if "`e(cmd)'" != "meglm" & "`e(cmd2)'" != "meglm" {
		di "{err}last estimates not found"
		exit 198
	}
	if "`e(family)'"=="" {
		di "{err}e(family) not found"
		exit 198
	}
	if "`e(link)'"=="" {
		di "{err}e(link) not found"
		exit 198
	}
	
	syntax  anything(id="stub* or newvarlist") 	///
		[if] [in] [,				///
		REFfects				///
		remeans					/// undocumented
		remodes					/// undocumented
		reses(string)	 			///
		mu					///
		pr					///
		eta					///
		FITted					/// undocumented
		RESiduals				///
		PEArson					///
		DEViance				///
		ANScombe				///
		xb					///
		stdp					///
		SCores					///
		CONDitional1(string)			///
		CONDitional				///
		UNCONDitional				/// undocumented
		MARGinal				///
		FIXEDonly				/// undocumented
		EBMEANs					///
		EBMODEs					///
		means					/// undocumented
		modes					/// undocumented
		mean					/// disallowed
		mode					/// disallowed
		*					///
	]
	
	local mm `mean'`mode'
	if "`mm'"!="" {
		di "{err}option {bf:`mm'} not allowed"
		exit 198
	}
	if "`eta'" != "" {
		local fitted eta
	}
	
	local STAT `remeans' `remodes' `mu' `pr' `fitted' `residuals'	///
		`pearson' `deviance' `anscombe' `xb' `stdp' `reffects'	///
		`scores'
	opts_exclusive "`STAT'"

	if "`scores'" != "" {
		`vv' gsem_p `0'
		exit
	}

	if "`fitted'" == "fitted" {
		local fitted eta
	}
	
	local STAT ///
	    `mu'`pr'`fitted'`residuals'`pearson'`deviance'`anscombe'`xb'`stdp'
	if !missing("`STAT'") {
		if !missing("`reses'") {
			di "{err}option {bf:reses()} not allowed with " ///
				"option {bf:`STAT'}"
			exit 198
		}
	}

	if "`unconditional'" != "" {
		opts_exclusive "unconditional `xb'"
		opts_exclusive "unconditional `stdp'"
		opts_exclusive "unconditional `fixedonly'"
		opts_exclusive "unconditional `reffects'"
		opts_exclusive "unconditional `remeans'"
		opts_exclusive "unconditional `remodes'"
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
			opts_exclusive "conditional `reffects'"
			opts_exclusive "conditional `remeans'"
			opts_exclusive "conditional `remodes'"
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
		opts_exclusive "`condopt' `stdp'"
		opts_exclusive "`condopt' `xb'"
		opts_exclusive "`condopt' `reffects'"
		opts_exclusive "`condopt' `remeans'"
		opts_exclusive "`condopt' `remodes'"
		opts_exclusive "`condopt' `unconditional'"
		opts_exclusive "`condopt' `marginal'"
		if "`conditional1'" != "fixedonly" {
			opts_exclusive "`condopt' `fixedonly'"
		}
		else	local fixedonly fixedonly
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

	if "`ebmeans'" != "" {
		local means means
	}
	if "`ebmodes'" != "" {
		local modes modes
	}

	local mm `marginal' `means' `modes'
	opts_exclusive "`xb' `mm'"
	opts_exclusive "`stdp' `mm'"
	opts_exclusive "`fixedonly' `mm'"
	if "`reffects'`remeans'`remodes'" != "" local reffects latent
	if "`reffects'"=="latent" & !e(k_r) {
		di "{err}random-effects equation(s) empty; predictions of " ///
			"random effects not available"
		exit 198
	}
	if "`remeans'" != "" {
		if "`mm'" != "" {
			di "{err}option {bf:`mm'} not allowed with {bf:remeans}"
			exit 198
		}
		local mm means
	}
	if "`remodes'" != "" {
		if "`mm'" != "" {
			di "{err}option {bf:`mm'} not allowed with {bf:remodes}"
			exit 198
		}
		local mm modes
	}
	if "`reses'" != "" local reses se(`reses')
	if "`reses'" != "" & "`reffects'"=="" {
		di "{err}option {bf:reses()} requires the {bf:reffects} " ///
			" option"
		exit 198
	}

	if "`mm'" == "" & e(k_hinfo) == 0 {
		local fixedonly fixedonly
	}

	local STAT `pearson' `deviance' `anscombe' `stdp'
	opts_exclusive "`marginal' `STAT'"
	local STAT `deviance' `anscombe'
	local fixed `fixedonly'`xb'`stdp'

	local type "`residuals'`pearson'`deviance'`anscombe'"
	
	local fn `e(family)'
	
	if inlist("`fn'","ordinal") & "`type'"!="" {
		di "{err}statistic {bf:`type'} not available with `fn' outcomes"
		exit 198
	}
	if !inlist("`fn'","gaussian") & "`type'"=="residuals" {
		di "{err}statistic {bf:`type'} not available with `fn' family"
		exit 198
	}
	if "`fn'"=="nbinomial" & "`e(dispersion)'"=="constant" {
		if "`type'"=="deviance" | "`type'"=="anscombe" {
			di "{err}statistic {bf:`type'} not available for " ///
				"`fn' family with constant dispersion"
		exit 198
		}
	}
	if !inlist("`fn'","bernoulli","ordinal") & "`pr'"=="pr" {
		di "{err}statistic {bf:pr} not available with `fn' family"
		exit 198
	}

	if "`mm'"=="" {
		if _caller() >= 14 & "`c(marginscmd)'" == "on" {
			local mm marginal
		}
		else {
			local mm means
		}
	}
	if "`fixed'" != "" local mm

	if "`reffects'" != "" {
		di as txt "(calculating posterior `mm' of random effects)"
	}
	else if "`fixed'" == "" & "`mm'" != "marginal" {
	    if e(k_hinfo) != 0 {
		di as txt "(predictions based on fixed effects and "	///
			"posterior `mm' of random effects)"
	    }
	}
		
	local gsem = "`type'"==""
	if `gsem' {
		local preds `reffects' `reses' `fitted' `fixedonly' 	///
			`xb' `stdp' `mm' `pr' `mu'
		local cmd `anything' `if' `in' , `preds' `options'
		`vv' gsem_p `cmd'
		exit
	}
	
	// residuals, pearson, deviance, anscombe -- need mu for calculations
	
	local y `e(depvar)'
	_stubstar2names `anything', nvars(1) outcome single
	local varn `s(varlist)'
	local vtyp `s(typlist)'
	
	marksample touse, novarlist
	
	tempvar mu
	`vv' gsem_p double `mu' if `touse' , mu `fixedonly' `mm' `options'
	
	if "`type'"=="residuals" {
		qui gen `vtyp' `varn' = `y' -`mu' if `touse'
		label var `varn' "Residuals`lab'"
		exit
	}
	
	if "`type'"=="pearson" {
		tempvar p
		qui _pearson_`fn' `y' `mu' `p' `touse'
		qui gen `vtyp' `varn' = `p' if `touse'
		label var `varn' "Pearson residuals`lab'"
		exit
	}
	
	if "`type'"=="deviance" {
		tempvar d
		qui _deviance_`fn' `y' `mu' `d' `touse'
		qui gen `vtyp' `varn' = `d'
		label var `varn' "deviance residuals`lab'"
		exit
	}
	
	if "`type'"=="anscombe" {
		tempvar a
		qui _anscombe_`e(family)' `y' `mu' `a' `touse'
		qui gen `vtyp' `varn' = `a'
		label var `varn' "Anscombe residuals`lab'"
		exit
	}
	
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

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++ pearson residuals

program _pearson_bernoulli
	args y mu p touse
	gen double `p' = (`y'-`mu') / sqrt( `mu'*(1-`mu') ) if `touse'
end

program _pearson_binomial
	args y mu p touse
	if "`e(binomial)'"=="" local r_ij = 1
	else local r_ij `e(binomial)'
	gen double `p' = (`y'-`mu') / sqrt( `mu'*(1-`mu'/`r_ij') ) if `touse'
end

program _pearson_gamma
	args y mu p touse
	gen double `p' = (`y'-`mu') / sqrt(`mu'^2) if `touse'
end

program _pearson_gaussian
	args y mu p touse
	gen double `p' = `y'-`mu' if `touse'
end

program _pearson_nbinomial
	args y mu p touse
	if "`e(dispersion)'"=="mean" {
		local k = exp(_b[lnalpha:_cons])
		gen double `p' = (`y'-`mu') / sqrt(`mu' + `k'*`mu'^2) if `touse'
	}
	else {
		local k = exp(_b[lndelta:_cons])
		gen double `p' = (`y'-`mu') / sqrt(`mu' + `k'*`mu') if `touse'
	}
end

program _pearson_ordinal
	di "Pearson residuals not available with ordinal outcomes"
	exit 198
end

program _pearson_poisson
	args y mu p touse
	gen double `p' = (`y'-`mu') / sqrt(`mu') if `touse'
end

// +++++++++++++++++++++++++++++++++++++++++++++++++++++++ deviance residuals

program _deviance_bernoulli
	args y mu d touse
	gen double `d' = -2*ln(1-`mu') if `y'==0 & `touse'
	replace `d' = -2*ln(`mu') if `y'==1 & `touse'
	replace `d' = sign(`y'-`mu')*sqrt(`d') if `touse'
end

program _deviance_binomial
	args y mu d touse
	if "`e(binomial)'"=="" local r_ij = 1
	else local r_ij `e(binomial)'
	gen double `d' = 2*`r_ij'*ln( `r_ij'/(`r_ij'-`mu') ) if `y'==0 & `touse'
	replace `d' = 2*`y'*ln(`y'/`mu') + ///
		2*(`r_ij'-`y')*ln( (`r_ij'-`y')/(`r_ij'-`mu') ) ///
		if (`y'>0 & `y'<`r_ij') & `touse'
	replace `d' = 2*`r_ij'*ln(`r_ij'/`mu') if `y'==`r_ij' & `touse'
	replace `d' = sign(`y'-`mu')*sqrt(`d') if `touse'
end

program _deviance_gamma
	args y mu d touse
	gen double `d' = -2*( ln(`y'/`mu') - (`y'-`mu')/`mu' ) if `touse'
	replace `d' = sign(`y'-`mu')*sqrt(`d') if `touse'
end

program _deviance_gaussian
	args y mu d touse
	gen double `d' = (`y'-`mu')^2 if `touse'
	replace `d' = sign(`y'-`mu')*sqrt(`d') if `touse'
end

program _deviance_nbinomial
	args y mu d touse
	local k = exp(_b[lnalpha:_cons])
	gen double `d' = 2*ln(1+`k'*`mu')/`k' if `y'==0 & `touse'
	replace `d' = 2*`y'*ln(`y'/`mu') - ///
		(2/`k')*(1+`k'*`y')*ln( (1+`k'*`y')/(1+`k'*`mu') ) ///
		if `y'>0 & `y'<. & `touse'
	replace `d' = sign(`y'-`mu')*sqrt(`d') if `touse'
end

program _deviance_ordinal
	di "{err}deviance residuals not available with ordinal outcomes"
	exit 198
end

program _deviance_poisson
	args y mu d touse
	gen double `d' = 2*`mu' if `y'==0 & `touse'
	replace `d' = 2*`y'*ln(`y'/`mu') - 2*(`y'-`mu') ///
		if `y'>0 & `y'<. & `touse'
	replace `d' = sign(`y'-`mu')*sqrt(`d') if `touse'
end

// +++++++++++++++++++++++++++++++++++++++++++++++++++++++ anscombe residuals

program _anscombe_bernoulli
	args y mu a touse
	gen double `a' = 1.5 * 						///
		( `y'^(2/3)*_hyp2f1(`y') - `mu'^(2/3)*_hyp2f1(`mu') ) /	///
		(`mu'*(1-`mu'))^(1/6) if `touse'
end

program _anscombe_binomial
	args y mu a touse
	if "`e(binomial)'"=="" local r_ij = 1
	else local r_ij `e(binomial)'
	gen double `a' = 1.5 * 						///
		( `y'^(2/3)*_hyp2f1(`y'/`r_ij') - 			///
		  `mu'^(2/3)*_hyp2f1(`mu'/`r_ij') 			///
		) / 							///
		( `mu'*(1-`mu'/`r_ij') )^(1/6) if `touse'
end

program _anscombe_gamma
	args y mu a touse
	gen double `a' = 3*( (`y'/`mu')^(1/3) - 1 ) if `touse'
end

program _anscombe_gaussian
	args y mu a touse
	gen double `a' = (`y'-`mu') if `touse'
end

program _anscombe_nbinomial
	args y mu a touse
	local k = exp(_b[lnalpha:_cons])
	gen double `a' = ( _hyp2f1(-`k'/`y') - _hyp2f1(-`k'/`mu') +	///
			   1.5*(`y'^(2/3)-`mu'^(2/3)) ) /		///
			 (`mu' + `k'*`mu'^2)^(1/6) if `touse'
end

program _anscombe_ordinal
	di "{err}Anscombe residuals not available with ordinal outcomes"
	exit 198
end

program _anscombe_poisson
	args y mu a touse
	gen double `a' = 1.5*(`y'^(2/3) - `mu'^(2/3)) / `mu'^(1/6) if `touse'
end

exit

