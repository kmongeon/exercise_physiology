*! version 1.0.1  10nov2015

/* procedure taken from section 15.7.2 (Wooldridge, 2nd ed.)		*/
program define ivfprobit_twostep, rclass
	version 14.1
	syntax, depvar(string) indepvars(string) ivvars(string)  ///
		ivindvars(string) touse(varname) resid(string)   ///
		[ noconstant wtype(string) wvar(varname) verbose ///
		  inititerate(passthru) nolog binary ]

	if "`wtype'" != "" {
		local wgt [`wtype'=`wvar']
	}
	if "`verbose'" != "" {
		/* debugging						*/
		local cap cap noi
		local log
	}
	else {
		if "`log'" == "" {
			local cap cap noi
			local qui qui
			local nocoef nocoef
		}
		else {	// nolog
			local cap cap
			local qui qui
			local nocoef nocoef
		}
	}

	if "`inititerate'" != "" {
		ParseIterate, `inititerate'
		local iteropt iterate(`r(iterate)')
		local iteropt1 `iteropt'
	}
	else {
		/* set a limit on the -nl- search; no feedback to user	*/
		local iteropt1 iterate(100)
	}

	local kiv : list sizeof ivvars
	tempname b b0 b1 b2 b3 br tau2 theta rho dfr

	/* Wooldridge, procedure 15.1					*/
	MVReg `ivvars' = `ivindvars', touse(`touse') wtype(`wtype') wvar(`wvar')

	mat `b1' = r(b)
	scalar `dfr' = r(df_r)
	mat `tau2' = r(Sigma)

	if "`verbose'" != "" {
		mat `b0' = `b1''
		matlist `b0', title(regression coefficients)
	}

	forvalues i=1/`kiv' {
		local ivvar : word `i' of `ivvars'
		local iveq : subinstr local ivvar "." "_", all
		local r`i' : word `i' of `resid'
		mat score double `r`i'' = `b1' if `touse', eq(`iveq')
		qui replace `r`i'' = `ivvar' - `r`i'' if `touse'
	}
	if "`binary'" != "" {
		local call probit
	}
	else {
		local call fracreg probit
		local extra " fractional"
	}
	if "`log'" == "" {
		di as txt _n "Fitting exogenous`extra' probit model"
	}
	local notest = 0
	qui _rmdcoll `depvar' `indepvars' `resid' `wgt' if `touse', ///
		expand `constant'
	if r(k_omitted) {
		/* may have dropped tempvars (residuals); mask it	*/
		tempname bc C

		local vlist `r(varlist)'
		if "`constant'" == "" {
			local vlist `vlist' _cons
		}
		local kvar : list sizeof vlist
		mat `bc' = J(1,`kvar',0)
		mat colnames `bc' = `vlist'
		_make_constraints, b(`bc')
		mat `C' = e(Cm)
		local constraints constraints(`C') collinear
	}
	`cap' `call' `depvar' `indepvars' `resid' `wgt' if `touse', ///
		`constant' `iteropt' `nocoef' `log' `constraints'
	local rc = c(rc)
	if (`rc') {
		di as txt "{p 0 2 9}Warning: {helpb `call'} failed to " ///
		 "compute initial estimates. Using {helpb regress}.{p_end}"

		`qui' regress `depvar' `indepvars' `resid' `wgt' if `touse', ///
			`constant'
		mat `b' = e(b)
		mat coleq `b' = `depvar'
		local notest = 1
	}
	else {
		mat `b' = e(b)
		if "`binary'" != "" {
			mat coleq `b' = `depvar'
		}
	}
	local stripe : colfullnames `b'
	local eqs : coleq `b'
	local eqs :subinstr local eqs "." "_", all count(local k)
	if `k' {
		/* -fracreg- leaves TS op in equation names		*/
		mat coleq `b' = `eqs'
	}
	local k : list sizeof indepvars

	forvalues i=1/`kiv' {
		local ri : word `i' of `resid'
		if !`notest' {
			/* endogeneity test				*/
			if "`binary'" != "" {
				qui test _b[`r`i''] = 0, `accum'
				scalar `br' = _b[`ri']
			}
			else {
				qui test [`depvar']_b[`r`i''] = 0, `accum'
				scalar `br' = [`depvar']_b[`ri']
			}
			local accum accumulate
		}
		else {
			scalar `br' = _b[`ri']
		}
		local si : word `++k' of `stripe'
		_ms_parse_parts `si'
		if `br'==0 & r(omit) {
			local ivvar : word `i' of `ivvars'
			di as txt "{p 0 10 2}Warning: endogenous variable " ///
			 "`ivvar' may not be identified{p_end}"
		}
	}
	return add

	local k = colsof(`b')
	local kt = `k' - `kiv'
	local k1 = `k' - 1
	if "`constant'" != "" {
		/* no constant						*/
		local `++kt'
		local k1 = `k'
	}
	mat `theta' = `b'[1,`kt'..`k1']'
	mat `b3' = I(1)+`theta''*`tau2'*`theta'
	scalar `rho' = `b3'[1,1] 		// 1/(1-rho^2)

	/* unscaled coefficients (p.588, Wooldridge)			*/
	local kt1 = `kt'-1
	local eq : colfullnames `b'
	if "`constant'" == "" {
		mat `b0' = `b'[1,`k']
		local eq0 : word `k' of `eq'
	}
	mat `b' = `b'[1,1..`kt1']
	local eq : colfullnames `b'
	if "`constant'" == "" {
		mat `b' = (`b',`b0')
		local eq `eq' `eq0'
		mat colnames `b' = `eq'
	}
	scalar `rho' = 1/sqrt(`rho') 	// sqrt(1-rho^2)

	tempname eta T C
	if `kiv' > 1 {
		/* nl search 						*/
		CovSearch, tau2(`tau2') b(`b') theta(`theta') rho(`rho') ///
			`iteropt1' `verbose'
		scalar `rho' = r(rho)	// sqrt(1-rho^2) = sqrt(1-eta'tau2*eta)
		mat `eta' = r(eta)
	}
	else {
		CovPD, theta(`theta') tau2(`tau2') rho(`rho') `verbose'
		mat `eta' = (diag(vecdiag(`tau2'))*`theta')*`rho'
	}
	mat `b' = `b'*`rho'
	mat `T' = ((1,`eta'')\(`eta',`tau2'))
	cap mat `C' = cholesky(`T')
	local rc = c(rc)
	if `rc'  {
		di as txt "{p 0 8 2}Warning: Initial covariance " ///
		 "matrix is not positive definite.{p_end}"
	}
	TransformAtanh, cov(`T')

	mat `b2' = r(b)
	mat `b' = (`b',`b1',`b2')

	if "`verbose'" != "" {
		matlist `b', title("initial estimates")
	}

	return mat b = `b'
end

program define TransformAtanh, rclass
	syntax, cov(name)

	tempname R v r b

	local T `cov'
	local ks = rowsof(`T')

	mata: st_matrix("`v'",1:/sqrt(diagonal(st_matrix("`T'"))))
	mata: st_matrix("`R'",st_matrix("`v'"):*st_matrix("`T'"):* ///
		st_matrix("`v'")')

	forvalues i=1/`ks' {
		if `i' > 1 {
			mat `T'[`i',`i'] = log(`T'[`i',`i'])/2
		}
		forvalues j=`=`i'+1'/`ks' {
			scalar `r' = `R'[`j',`i']
			mat `T'[`j',`i'] = atanh(`r')
		}
	}
	local j = `ks'*(`ks'+1)/2-1
	mat `b' = J(1,`j',0)
	local k = 0
	forvalues i=1/`ks' {
		forvalues j=`=`i'+1'/`ks' {
			local stripe `stripe' athrho`j'_`i':_cons
			mat `b'[1,`++k'] = `T'[`j',`i']
		}
	}
	forvalues i=2/`ks' {
		local stripe `stripe' lnsigma`i':_cons
		mat `b'[1,`++k'] = `T'[`i',`i']
	}
	mat colnames `b' = `stripe'

	return mat b = `b'
end

program define TransformCholesky, rclass
	syntax cov(name)

	tempname b

	local T `mat'
	local ks = rowsof(`T')
	mat `T' = cholesky(`T')
	forvalues i=2/`ks' {
		mat `T'[`i',`i'] = log(`T'[`i',`i'])
	}
	local j = `ks'*(`ks'+1)/2
	mata: st_matrix("`b'",vech(st_matrix("`T'"))[|2\ `j'|]')

	forvalues i=1/`ks' {
		if `i' > 1 {
			local stripe `stripe' lns_`i'_`i':_cons
		}
		forvalues j=`=`i'+1'/`ks' {
			local stripe `stripe' s_`j'_`i':_cons
		}
	}
	mat colnames `b' = `stripe'

	return mat b = `b'
end

/* copied from -mvreg-							*/
program define MVReg, rclass
	version 14

	tempname sigma tsig
	tempname rcv

	gettoken word 0 : 0, parse(" =:,")
	while `"`word'"' != ":" & `"`word'"' != "=" { 
		if `"`word'"' == "," | `"`word'"'=="" { 
			error 198
		}
		local eqnames `eqnames' `word'
		gettoken word 0 : 0, parse(" :,")
	}

	tsunab depvars : `eqnames'
	local eqnames : subinstr local depvars "." "_" , all
	syntax varlist(numeric fv ts), touse(varname) ///
		[ wtype(string) wvar(varname) COLLinear ]

	if "`wtype'" != "" {
		local wts [`wtype'=`wvar']
	}
	local neq : word count `eqnames'

	tempname ee xx xy yy bb xxi cxxi b idfe
	qui mat accum `ee' = `depvars' `varlist' if `touse' `wts'

	local nobs = r(N)
	local neqp1 = `neq' + 1
	mat `xx' = `ee'[`neqp1'...,`neqp1'...]
	mat `xy' = `ee'[`neqp1'...,1..`neq']
	mat `yy' = `ee'[1..`neq',1..`neq']
	mat drop `ee'
	mat `xxi' = syminv(`xx')
	mat `bb' = `xy'' * `xxi'
	mat `rcv' = `yy' - `bb'*`xx'*`bb''

	local knum = rowsof(`xx') - diag0cnt(`xxi')
	local dfe = `nobs' - `knum'
	if `dfe' < 1 {
		di as err "insufficient residual degrees of freedom"
		exit 2001
	}
	scalar `idfe' = 1/`dfe'
	mat `rcv' = `rcv' * `idfe'
	mat `cxxi' = `rcv' # `xxi'
	forvalues i=1/`neq' {
		mat `xx' = `bb'[`i',1...]
		local eqn : word `i' of `eqnames'
		local dep : word `i' of `depvars'
		mat coleq `xx' = `eqn'
		mat `b' = nullmat(`b') , `xx'
	}
	local stripe : colfullnames `b'
	mat colnames `cxxi' = `stripe'
	mat rownames `cxxi' = `stripe'

	return mat b = `b'
	return mat V = `cxxi'
	return matrix Sigma `rcv'
	return scalar dfe = `dfe'

	return local eqnames "`eqnames'"
	return local depvar  "`depvars'"
	return scalar k  = `knum'
	return scalar df_r = `dfe'
	return scalar k_eq = `neq'
	return scalar N    = `nobs'

	mat drop `xx' `yy' `xy' `bb'
end

program define ParseIterate, rclass
	cap noi syntax, inititerate(integer)

	local rc = c(rc)
	if !`rc' {
		if `inititerate' < 0 {
			local rc = 198
		}
	}
	if `rc' {
		di as txt "{phang}Option {bf:inititerate()} was "           ///
		 "incorrectly specified.  It must be a nonnegative integer." ///
		 "{p_end}".
		exit `rc'
	}
	return local iterate = `inititerate'
end

program define CovPD, rclass
	syntax, theta(name) tau2(name) rho(name) [ verbose ]

	tempname T C cov

	if "`verbose'" != "" {
		local noi noi
	}
	local rc = 1
	local iter = 0
	while `rc' & `++iter'<=10 {
		mat `cov' = (diag(vecdiag(`tau2'))*`theta')*`rho'
		mat `T' = ((1,`cov'')\(`cov',`tau2'))
		cap `noi' mat `C' = cholesky(`T')
		local rc = c(rc)
		if `rc' {
			if "`verbose'" != "" {
				di as txt "reducing cov(err,resid)"
			}
			mat `theta' = 0.5*`theta'
		}
	}
	if `rc' {
		di as err "initial covariance is not positive definite"
		exit 506
	}
	return mat cov = `cov'
end

program define CovSearch, rclass
	syntax, tau2(name) b(name) theta(name) rho(name) [ verbose ///
		iterate(passthru) ]

	tempvar y
	tempname tau2i b0 eta b1 R
	if "`verbose'" != "" {
		local noi noi
	}
	/* tau2 = var(resid)						*/
	mat `tau2i' = syminv(`tau2')
	local kb = colsof(`b')
	local ke = rowsof(`theta')
	local k = `kb' + `ke'
	local i1 = `kb' + 1

	CovPD, theta(`theta') tau2(`tau2') rho(`rho') `verbose'
	/* theta = cov(depvar,resid)/var(resid)				*/
	/* scaled corr(depvar,resid)					*/
	mat `eta' = cholesky(diag(vecdiag(`tau2')))*`theta'

	/* rho = inverse scale = sqrt(1-rho^2)				*/
	mat `b0' = `b'*`rho'	// unscaled coefficients
	mat `eta' = `eta'*`rho'
	forvalues i=1/`ke' {
		mat `eta'[`i',1] = atanh(`eta'[`i',1])
	}
	mat `b0' = (`b0',`eta'')

	qui gen double `y' = .
	forvalues i=1/`kb' {
		qui replace `y' = `b'[1,`i'] in `i'
	}
	local j = 0
	forvalues i=`i1'/`k' {
		qui replace `y' = `theta'[`++j',1] in `i'
	}

	cap `noi' nl _ivfprobit_cov_eval @ `y', nparameters(`k')       ///
		init(`b0') tau2(`tau2') tau2i(`tau2i') b(`b') `iterate'
	/* nl errors out if it does not converge			*/
	local rc = c(rc)
	if !`rc' {
		mat `b1' = e(b)
		mat `eta' = `b1'[1,`i1'..`k']'		// corr(depvar,resid)
	}
	forvalues i=1/`ke' {
		mat `eta'[`i',1] = tanh(`eta'[`i',1])
	}
	/* cov(depvar,resid)						*/
	mat `eta' = cholesky(diag(vecdiag(`tau2')))*`eta'
	if !`rc' {
		mat `theta' = `tau2i'*`eta'
		mat `R' = I(1)-`eta''*`theta'
		/* rho = sqrt(var(eps))					*/
		scalar `rho' = `R'[1,1]
		scalar `rho' = sqrt(`rho')
	}
	return mat eta = `eta'
	return scalar rho = `rho'
end

exit
