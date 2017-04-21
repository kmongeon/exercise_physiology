*! version 1.0.1  12oct2015
* adjust Xb for ivprobit and ivtobit endogenous model residuals
program define ivadjust_xb
	syntax varlist(min=1 max=1 numeric), touse(name) [ noscale ]

	tempvar zg r
	tempname V v z b m v11

	local Xb `varlist'
	mat `b' = e(b)
	mat `V' = e(Sigma)
	local k = e(endog_ct)
	local k1 = `k' + 1
	scalar `v11' = `V'[1,1]
	mat `v' = `V'[2..`k1',1]
	mat `V' =  `V'[2..`k1',2..`k1']'
	mat `V' = invsym(`V')
	mat `z' = `V'*`v'
	qui gen double `r' = 0 if `touse'
	forvalues i=1/`k' {
		local var : word `i' of `e(instd)' bind
		local eq : subinstr local var "." "_", all
		mat score double `zg' = `b' if `touse', eq(`eq')
		qui replace `r' = `r' + (`var'-`zg')*`z'[`i',1] if `touse'
		qui drop `zg'
	}
	qui replace `Xb' = `Xb'+`r' if `touse'
	if "`scale'" == "" {
		mat `m' = `v''*`z'
		scalar `m' = sqrt(`v11'-`m'[1,1])
		qui replace `Xb' = `Xb'/`m' if `touse'
	}
end
exit
