*! version 1.0.3  16may2016
program bayesstats
	version 14.0

	_parse comma lhs rhs : 0, bindcurly
	if (`"`rhs'"'=="") {
		local rhs , 
	}
	gettoken subcmd lhs : lhs

	local 0 , `subcmd'
	syntax [, SUMMary ESS IC * ]
	local subcmd `summary'`ess'`ic'
	if ("`options'"!="") {
		di as err `"subcommand {bf:`options'} is not "' ///
			"supported by {bf:bayesstats}"
		exit 198
	}
	if ("`subcmd'"=="") {
		di as err "{bf:bayesstats} requires subcommand " ///
			"{bf:summary}, {bf:ess}, or {bf:ic}"
		exit 198
	}
	
	// call to _bayesstats_ic
	if ("`subcmd'"=="ic") {
		// paramref check
		_mcmc_expand_paramlist `"`lhs'"'
		_bayesstats_`subcmd' `lhs' `rhs'
		exit
	}
	if ("`e(cmd)'"!="bayesmh") {
		di as err "last estimates not found"
		exit 301
	}
	if (`"`e(filename)'"'=="") {
		di as err "simulation results not found"
		exit 301
	}

	// load parameters sorted by eqnames in global macros 
	// to be used by _mcmc_fv_decode in _mcmc_expand_paramlist
	_bayesmh_eqlablist import

	// paramref check
	_mcmc_expand_paramlist `"`lhs'"'

	// other bayesstats subcommands require an mcmc object
	mata: getfree_mata_object_name("mcmcobject", "__g_mcmc_model")

	cap noi _bayesstats `subcmd' `lhs' `rhs' mcmcobject(`mcmcobject')
	local rc = _rc
	
	_bayesmh_eqlablist clear
	
	// clean up
	capture mata: mata drop `mcmcobject'

	exit `rc'
end

program _bayesstats
	syntax [anything], MCMCOBJECT(string) [*]
	gettoken subcmd anything : anything
	local anything `anything' //trim leading spaces

	// parse paramref
	_bayesmhpost_paramlist thetas : `"`anything'"'

	// call subcommand		
	_bayesstats_`subcmd' "`mcmcobject'" "`thetas'" `"`options'"'
end

program _bayesstats_ess, rclass
	args mcmcobject thetas opts

	local 0 , `opts'
	syntax [, USING(string) * ]

	// check and parse common options
	_bayesmhpost_options `"`options'"'
	local every = `s(skip)'+1
	local corrlag `s(corrlag)'
	local corrtol `s(corrtol)'
	local nolegend `s(nolegend)'
	local nobaselevels `s(nobaselevels)'
	local diopts `"`s(diopts)'"'

	// load simulation dataset and create mcmcobject based on it
	_mcmc_read_simdata, mcmcobject(`mcmcobject')		///
			    thetas(`thetas') using(`"`using'"') ///
	 	 	    every(`every') `nobaselevels' 
	local numpars	 `s(numpars)'
	local parnames   `"`s(parnames)'"'
	local exprlegend `"`s(exprlegend)'"'
	
	// check that mcmcobject is created
	mata:st_local("nomcmcobj",strofreal(findexternal("`mcmcobject'")==NULL))
	if (`nomcmcobj') {
		di as err "{bf:`mcmcobject'} not found"
		exit 3498
	}
	
	// compute the corresponding MCMC sample size
	tempname mcmcsize
	mata: st_numscalar("`mcmcsize'", `mcmcobject'.mcmc_size())
	if `mcmcsize' < 2 {
		di as err "insufficient MCMC sample size"
		exit 2001
	}
	
	// update maximum correlation lag based on current MCMC size
	_bayesmh_chk_corrlag corrlag : `corrlag' `mcmcsize'

	local clevel 0.95
	mata: `mcmcobject'.summarize_matrix(J(0,0,""), J(0,0,0), 0, ///
		`corrlag', `corrtol', `clevel', J(1,0,0))
	tempname essmat	
	tempname mcmcsum meanfail mineff avgeff maxeff	cikind acfail 
	tempname mcsemat mcsefail quantmat hpdmat covmat indepvars
	mata: `mcmcobject'.stata_report(				///
		"numpars",	"parnames",	""/*noinitmat*/,	///
		"`mcmcsum'",	"`mcmcsize'",	"`meanfail'",		///
		"`quantmat'",	"`hpdmat'",	"`cikind'",		///
		"`mcsemat'",	"`mcsefail'",				///
		"`essmat'",	"`covmat'",	"`acfail'",		///
		"`mineff'",	"`avgeff'",	"`maxeff'", 		///
		0/*no HPD*/,	"`nobaselevels'" != "")
		
	capture confirm matrix `essmat'
	if _rc {
		di as err "cannot obtain efficiency summaries " ///
		     `"for parameters {bf:`thetas'}"'
		exit _rc
	}

	// display results
	local col1len  = 13
	local linesize = 51
	
	// obtain the width of the table
	qui _matrix_table `essmat', formats(%10.2f %11.2f %12.4f) `diopts'
	local linesize = `s(width)'
	local col1len  = `s(width_col1)'
	local labpos = `linesize'-27
	local eqpos  = `linesize'-10
	local numpos = `linesize'-9
		
	di 
	di as txt "Efficiency summaries"			///
		_col(`labpos') as txt "MCMC sample size"	///
		_col(`eqpos') "="  _col(`numpos') as res %10.0fc `mcmcsize'
	if `"`nolegend'"' == "" & `"`exprlegend'"' != "" {
		di
		_mcmc_expr legend `"`exprlegend'"'
	}
	_mcmc_table ess `numpars' `"`parnames'"' `essmat' `"`diopts'"'
	_mcmc_mcsefailnote `mcsefail' `linesize'

	// return results
	matrix colnames `essmat' = "ESS" "Corr time" "Efficiency"
	matrix rownames `essmat' = `parnames'
	return clear
	_mcmc_expr return `"`exprlegend'"'
	return add
	return local names	= `"`parnames'"'
	return matrix ess	= `essmat'
	return scalar corrtol	= `corrtol'
	return scalar corrlag	= `corrlag'
	return scalar skip	= `every'-1
end

program _bayesstats_summary, rclass
	args mcmcobject thetas opts

	local 0 , `opts'
	syntax [, USING(string) * ]
	
	// check and parse summary options
	_bayesmh_summaryopts `"`options'"'
	local batch  "`s(batch)'"
	local clevel "`s(clevel)'"
	local hpd    "`s(hpd)'"
	local every = `s(skip)'+1
	local corrlag `s(corrlag)'
	local corrtol `s(corrtol)'
	local nolegend `s(nolegend)'
	local nobaselevels `s(nobaselevels)'
	local diopts `"`s(diopts)'"'

	// load simulation dataset and create mcmcobject based on it
	_mcmc_read_simdata, mcmcobject(`mcmcobject')		///
			    thetas(`thetas') using(`"`using'"') ///
	 	 	    every(`every') `nobaselevels' 
	local numpars	 `s(numpars)'
	local parnames   `"`s(parnames)'"'
	local exprlegend `"`s(exprlegend)'"'
	//check that mcmcobject is created
	mata:st_local("nomcmcobj",strofreal(findexternal("`mcmcobject'")==NULL))
	if (`nomcmcobj') {
		di as err "{bf:`mcmcobject'} not found"
		exit 3498
	}
	
	// compute the corresponding MCMC sample size
	tempname mcmcsize
	mata: st_numscalar("`mcmcsize'", `mcmcobject'.mcmc_size())
	if `mcmcsize' < 2 {
		di as err "insufficient MCMC sample size"
		exit 2001
	}
	local maxsize = floor(`mcmcsize'/2)
	if (`batch' > `maxsize') {
		di as err "{p}option {bf:batch()} may not exceed half of "
		di as err "MCMC sample size, `maxsize'{p_end}"
		exit 198
	}
	
	// update maximum correlation lag based on current MCMC size
	_bayesmh_chk_corrlag corrlag : `corrlag' `mcmcsize'

	// compute results
	tempname mcmcsum meanfail mineff avgeff maxeff	cikind acfail essmat 
	tempname mcsemat mcsefail quantmat hpdmat covmat indepvars
	local clev = `clevel'/100
	mata: `mcmcobject'.summarize_matrix(J(0,0,""), J(0,0,0),  ///
		`batch', `corrlag', `corrtol', `clev',J(1,0,0))
	mata: `mcmcobject'.stata_report(				///
		"numpars",	"parnames",	""/*noinitmat*/,	///
		"`mcmcsum'",	"`mcmcsize'",	"`meanfail'",		///
		"`quantmat'",	"`hpdmat'",	"`cikind'",		///
		"`mcsemat'",	"`mcsefail'",				///
		"`essmat'",	"`covmat'",	"`acfail'",		///
		"`mineff'",	"`avgeff'",	"`maxeff'", 		///
		"`hpd'" != "",	"`nobaselevels'" != "")

	capture confirm matrix `mcmcsum'
	if _rc {
		di as err `"cannot summarize parameters {bf:`thetas'}"'
		exit _rc
	}

	// display results
	local col1len  = 13
	quietly _matrix_table `mcmcsum', ///
		formats(%9.0g %9.0g %9.0g %9.0g %9.0g %9.0g) `diopts'
	local linesize = `s(width)'
	local col1len  = `s(width_col1)'
	local labpos = `linesize'-28
	local eqpos  = `linesize'-11
	local numpos = `linesize'-10
		
	di
	di as txt "Posterior summary statistics"		///
		_col(`labpos') as txt "MCMC sample size"	///
		_col(`eqpos') "="				///
		as res %10.0fc `mcmcsize'
	if `batch' > 0 {
		di _col(`labpos') as txt "Batch size"		///
		_col(`eqpos') "="				///
		_col(`numpos') as res %10.0fc `batch'
	}
	if `"`nolegend'"' == "" & `"`exprlegend'"' != "" {
		di 
		_mcmc_expr legend `"`exprlegend'"'
	}
	_mcmc_table summary  `numpars' `"`parnames'"' `clev' ///
		"``cikind''" `mcmcsum' `"`diopts'"'
	_mcmc_batchnote `batch' `linesize'
	if (`batch'==0) {
		_mcmc_mcsefailnote `mcsefail' `linesize'
	}

	// return results
	matrix colnames `mcmcsum' = ///
		"Mean" "Std Dev" "MCSE" "Median" "CrI lower" "CrI upper"
	matrix rownames `mcmcsum' = `parnames'
	return clear
	_mcmc_expr return `"`exprlegend'"'
	return add
	return local names	= `"`parnames'"'
	return matrix summary	= `mcmcsum'
	return scalar corrtol	= `corrtol'
	return scalar corrlag	= `corrlag'
	return scalar skip	= `every'-1
	return scalar batch	= `batch'
	return scalar hpd	= `"`hpd'"' != ""
	return scalar clevel	= `clevel'
end

program _bayesstats_ic, rclass
	syntax [anything], [			///
		BASEModel(string)		///
		BAYESFactor			///
		MARGLMethod(string)		///
		diconly				///
		]
	
	// get names of estimation results
	est_expand `"`anything'"', default(.) starok
	local names `r(names)'
	local norig : list sizeof names
	local names : list uniq names
	local nest  : list sizeof names
	if (`nest'==0) {
		di as txt "no stored estimation results"
		exit
	}
	if (`nest'<`norig') {
		di as txt "note: duplicate estimation results are omitted"
	}
	
	// check option basemodel()
	if (`:list sizeof basemodel'>1) {
		di as err "{bf:basemodel()}: only one estimation name allowed"
		exit 198
	}
	if (`"`basemodel'"'=="") {
		gettoken basemodel : names
		local bmpos 1
	}
	else {
		local bmpos : list posof "`basemodel'" in names
		if (`bmpos'==0) {
			di as err "{p}{bf:basemodel()}: estimation name"
			di as err `"{bf:`basemodel'} is not one of specified"'
			di as err "estimation names{p_end}"
			exit 198
		}
	}
	
	// check option marglmethod()
	_bayesmh_chk_marglmethod marglmethod mllname mlleresult : ///
							`"`marglmethod'"'

	// loop over estimation results and store ln(ML) and DIC
	tempname lmlvec dicvec bfvec baselml
	mat `lmlvec' = J(`nest',1,.)
	mat `dicvec' = J(`nest',1,.)
	_bayes_estloop rownames : `"`names'"' ///
		"_bayesstatsic_compute `mlleresult' `dicvec' `lmlvec'"
	
	// compute Bayes factors
	scalar `baselml' = `lmlvec'[`bmpos',1]
	mat `bfvec' = `lmlvec' - `baselml'*J(`nest',1,1)
	if `"`bayesfactor'"' == "" {
		local bflab "log(BF)"
	}
	else {
		mata: st_matrix("`bfvec'", exp(st_matrix("`bfvec'")))
		local bflab "BF"
	}
	mat `bfvec'[`bmpos',1] = .

	// display results
	tempname mcmcsum

	if "`diconly'" == "" { 
		di
		di as txt "Bayesian information criteria"
		
		matrix `mcmcsum' = (`dicvec',`lmlvec',`bfvec')
		matrix colnames `mcmcsum' = "DIC" "log(ML)" "`bflab'"
		matrix rownames `mcmcsum' = `rownames'	
	}
	else {
		di
		di as txt "Deviance information criterion"

		matrix `mcmcsum' = (`dicvec')
		matrix colnames `mcmcsum' = "DIC"
		matrix rownames `mcmcsum' = `rownames'	
	}
	
	di
	qui _matrix_table `mcmcsum'
	local tablen  = `s(width)'
	_matrix_table `mcmcsum'

	// return results
	return clear 
	
	if "`diconly'" == "" { 
		di as txt "{p 0 6 0 `tablen'}Note: Marginal likelihood (ML) " ///
			"is computed using `mllname' approximation.{p_end}"
		return scalar bayesfactor	= ("`bayesfactor'"!="")
		return local  basemodel		= "`basemodel'"
		return local  marglmethod	= "`marglmethod'"
	}

	return local  names	= "`names'"
	return matrix ic	= `mcmcsum'
end

program _bayesmhpost_paramlist
	args toparams colon paramlist
	
	if (`"`paramlist'"' == "_all" | `"`paramlist'"' == "*") {
		 local paramlist
	}
	if `"`paramlist'"' != "" {
		// label:i.factorvar must be called as {label:i.factorvar} 
		// in order to expand properly
		_mcmc_expand_paramlist `"`paramlist'"' `"`e(parnames)'"'
		local thetas `s(thetas)'
		if `"`thetas'"' == "" {
			_mcmc_paramnotfound `"`paramlist'"'
		}
	}
	else {
		if `"`e(parnames)'"' == "" {
			di as err "last estimates not found"
			exit 301
		}
		local thetas `e(parnames)'
	}
	c_local `toparams' "`thetas'"
end
