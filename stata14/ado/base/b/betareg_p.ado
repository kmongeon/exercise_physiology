*! version 1.0.11  12Dec2014
program define betareg_p
	version 14.0
	if `"`e(cmd)'"'!="betareg" {
		error 301
	}
	syntax [anything] [if] [in] [, SCores *]
	if `"`scores'"'=="" {
		BetaregPNoscore `0'
		exit
	}
	else {
		BetaregPScore `0'
	}
	
end

program define BetaregPScore
	syntax anything [if] [in], SCores
	marksample touse, novarlist
	local y `e(depvar)'
	
	_score_spec `anything' 
	local varlist `s(varlist)'
	local typlist `s(typlist)'
	local nvars: word count `varlist'

	tempvar mu phi dl_dmu dl_dphi dmu_dxb dphi_dzr s1 s2

	PredictCmean double `mu', touse(`touse')
	PredictScale double `phi', touse(`touse')
						// load dmu_dxb
	LoadDmuDxb `dmu_dxb', touse(`touse') mu(`mu')
						// load dphi_dzr
	LoadDphiDzr `dphi_dzr', touse(`touse') phi(`phi')
	
	qui gen double `dl_dmu' = `phi'*(digamma((1-`mu')*`phi')-	  ///
				digamma(`mu'*`phi') +log(`y')-log(1-`y'))

	qui gen double `dl_dphi'= digamma(`phi')-`mu'*digamma(`mu'*`phi') ///
				-(1-`mu')*digamma((1-`mu')*`phi') 	  ///
				+`mu'*log(`y')+(1-`mu')*log(1-`y') if `touse'
	
	qui gen double `s1' = `dl_dmu'*`dmu_dxb' if `touse'
	qui gen double `s2' = `dl_dphi'*`dphi_dzr' if `touse'
	
	forval i=1/`nvars' {
		local typ : word `i' of `typlist'
		local var : word `i' of `varlist'
		local eq  : word `i' of `y' scale
		gen `typ' `var'=`s`i''
		label var `var' "equation-level for [`eq'] score from betareg"
	}
	
end

program define LoadDmuDxb
	syntax newvarname [, mu(string) touse(string)]
	tempvar xb
	qui _predict double `xb' if `touse', xb equation(`e(depvar)') 
	local link `e(link)'
	
	if `"`link'"'=="probit" {
		qui gen double `varlist' = normalden(invnormal(`mu')) ///
			if `touse'  
	}
	else if `"`link'"'=="logit" {
		qui gen double `varlist' = `mu'*(1-`mu') if `touse'
	}
	else if `"`link'"'=="cloglog" {
		qui gen double `varlist' = exp(`xb'-exp(`xb')) if `touse'
	}
	else if `"`link'"'=="loglog" {
		qui gen double `varlist' = exp(-`xb'-exp(-`xb')) if `touse' 
	}

end

program define LoadDphiDzr
	syntax newvarname [,touse(string) phi(string)]
	tempvar zr
	qui _predict double `zr' if `touse', xb equation(scale)
	local slink `e(slink)'

	if `"`slink'"'=="identity" {
		qui gen double `varlist'=1 if `touse' 
	}
	else if `"`slink'"'=="root" {
		qui gen double `varlist'=2*`zr' if `touse'
	}
	else if `"`slink'"'=="log" {
		qui gen double `varlist'=exp(`zr') if `touse'
	}

end

program define BetaregPNoscore
	syntax newvarname [if] [in] [,	/// 
		CMean 			///
		CVARiance 		///
		xb 			///
		XBSCAle 		///
		stdp]

	marksample touse, novarlist
	
	local eq1 `e(depvar)'
	local eq2 scale

	local case : word count /// 
		`cmean' `cvariance' `xb' `xbscale' `stdp' `stdpscale'
	if `case'>1 {
		di as err "only one {it:statistic} may be specified"
		exit 498
	}

	if `case'==0 {
		local cmean cmean
		di  as txt "(option {bf:cmean} assumed)" 
	}

	if `"`xb'"'!="" {
					// predict xb
		_predict `typlist' `varlist' if `touse', xb equation(`eq1')
		label var `varlist' "Linear prediction in `e(depvar)' equation"
	}
	else if `"`xbscale'"'!="" {
					// predict xbscale 
		_predict `typlist' `varlist' if `touse', xb equation(`eq2')
		label var `varlist' "Linear prediction in scale equation"
	}
	else if `"`stdp'"'!="" {
					// predict stdp
		_predict `typlist' `varlist' if `touse', stdp equation(`eq1')
		label var `varlist' "S.E. of the linear prediction"
	}
	else if `"`cmean'"'!="" {
					// predict cmean
		PredictCmean  `typlist' `varlist',touse(`touse')
		label var `varlist' "Conditional mean of `e(depvar)'"
	}
	else if `"`cvariance'"'!="" {
					// predict cvar 
		PredictCvar `typlist' `varlist', touse(`touse')
		label var `varlist' "Conditional variance of `e(depvar)'"
	}
end

				//-- PredictCmean--//
program define PredictCmean 
	syntax newvarname [, touse(string)]
	local link `e(link)'
	local eqn `e(depvar)'
	tempvar xbv
	quietly _predict double `xbv' if `touse' ,xb equation(`eqn')
	if `"`link'"'=="logit" {
		qui gen `typlist' `varlist' = exp(`xbv')/(1+exp(`xbv')) ///
			if `touse'    
	}
	else if `"`link'"'=="probit" {
		qui gen `typlist' `varlist' = normal(`xbv') if `touse'  
	}
	else if `"`link'"'=="cloglog" {
		qui gen `typlist' `varlist' = 1-exp(-exp(`xbv')) if `touse'
	}
	else if `"`link'"'=="loglog" {
		qui gen `typlist' `varlist' = exp(-exp(-`xbv')) if `touse'
	}
end

				//--predict scale--//
program PredictScale
	syntax newvarname [,touse(string)]
	local slink `e(slink)'
	local eqn scale
	tempvar xbv
	quietly _predict double `xbv' if `touse', xb equation(`eqn')
	if `"`slink'"'=="log" {
		qui gen `typlist' `varlist'=exp(`xbv') if `touse' 
	}
	else if `"`slink'"'=="identity" {
		qui gen `typlist' `varlist'=`xbv' if `touse'
	}
	else if `"`slink'"'=="root" {
		qui gen `typlist' `varlist'= `xbv'^2 if `touse'
	}
end

				//--predict cvar--//
program PredictCvar
	syntax newvarname [,touse(string)] 
	tempvar mu_p phi_p
	PredictCmean `typlist' `mu_p', touse(`touse')
	PredictScale `typlist' `phi_p', touse(`touse')
	qui gen `typlist' `varlist' =`mu_p'*(1-`mu_p')/(1+`phi_p') 
end
