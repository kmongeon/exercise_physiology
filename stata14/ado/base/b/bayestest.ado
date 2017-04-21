*! version 1.0.4  03jan2017
program bayestest
	version 14

	_parse comma lhs rhs : 0, bindcurly
	if (`"`rhs'"'=="") {
		local rhs ,
	}
	gettoken subcmd lhs : lhs
	local 0 , `subcmd'
	syntax [, INTerval MODEL * ]
	local subcmd `interval'`model'
	if ("`options'"!="") {
		di as err `"subcommand {bf:`options'} is not "' ///
			     "supported by {bf:bayestest}"
		exit 198
	}
	if ("`subcmd'"=="") {
		di as err "{bf:bayestest} requires subcommand " ///
			    "{bf:model} or {bf:interval}"
		exit 198
	}

	if ("`subcmd'"=="model") {
		_bayestest_`subcmd' `lhs' `rhs'
		exit
	}
	//bayestest interval requires an mcmc object
	mata: getfree_mata_object_name("mcmcobject", "__g_mcmc_model")

	cap noi _bayestest_`subcmd' `lhs' `rhs'	mcmcobject(`mcmcobject')
	local rc = _rc
	//clean up
	capture mata: mata drop `mcmcobject'

	exit `rc'
end

program _bayestest_model, rclass
	syntax [anything], [			///
			PRIOR(numlist >=0 <=1) 	///
			MARGLMethod(string)	///
			]
	//get names of estimation results
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

	//check option marglmethod()
	_bayesmh_chk_marglmethod marglmethod mllname mlleresult : ///
							`"`marglmethod'"'
	//check option prior()
	local npr  : list sizeof prior
	if (`npr'>0 & `npr'>`nest') {
		di as err "{bf:prior()}: too many prior probabilities specified"
		exit 198
	}
	if (`npr'>0 & `npr'<`nest'-1) {
		di as err "{bf:prior()}: too few prior probabilities specified"
		exit 198
	}
	tempname prvec
	if (`"`prior'"'!="") {
		mat `prvec' = J(`nest',1,0)
		tempname prsum
		scalar `prsum' = 0
		tokenize `"`prior'"'
		forvalues i=1/`=`nest'-1' {
			scalar `prsum' = `prsum'+``i''
			mat `prvec'[`i',1] = ``i''
		}
		if ("``nest''"!="") {
			scalar `prsum' = `prsum'+``nest''
			mat `prvec'[`nest',1] = ``nest''
			if (`prsum'!=1) {
				di as err "{p}"
				di as err "{bf:prior()}: prior probabilities"
				di as err "must sum to one{p_end}"
				exit 198
			}
		}
		else {
			if (`prsum'>=1) {
			   	di as err "{bf:prior()}: invalid prior " ///
					  "probabilities"
				di as err "{p 4 4 2}You specified only `npr'"
				di as err "prior probabilities for `nest'" 
				di as err "models; their sum should be less"
				di as err "than one{p_end}"
				exit 198
			}
			tempname pr`nest'
			scalar `pr`nest'' = 1 - `prsum'
			mat `prvec'[`nest',1] = 1-`prsum'
		}
	}
	else {
		mat `prvec' = J(`nest',1,1/`nest')
	}

	//collect ln(ML) and compute posterior probabilities
	tempname lmlvec postprvec sumpostpr
	mat `lmlvec'    = J(`nest',1,.)
	mat `postprvec' = J(`nest',1,.)
	scalar `sumpostpr' = 0
	_bayes_estloop rownames : "`names'" ///
"_bayestestmodel_compute `mlleresult' `prvec' `lmlvec' `postprvec' `sumpostpr'"
	//to allow missing values, compute in Mata
	if `sumpostpr' <= 0 {
		// try to fix numerical overflow
		mata: st_matrix("`postprvec'", ///
			st_matrix("`lmlvec'"):+log(st_matrix("`prvec'")))
		mata: _tempsc = mean(st_matrix("`postprvec'"))
		mata: st_matrix("`postprvec'", ///
			exp(st_matrix("`postprvec'"):-_tempsc))
		mata: st_numscalar("`sumpostpr'", sum(st_matrix("`postprvec'")))
	}
	if `sumpostpr' <= 0 {
		mata: st_matrix("`postprvec'", ///
			st_matrix("`lmlvec'"):+log(st_matrix("`prvec'")))
		mata: _tempmat = ///
			st_matrix("`postprvec'"):>=max(st_matrix("`postprvec'"))
		mata: st_matrix("`postprvec'", ///
			_tempmat:*(st_matrix("`postprvec'"):<.))
	}
	mata: st_matrix("`postprvec'", ///
		st_matrix("`postprvec'")/st_numscalar("`sumpostpr'"))

	//display results
	di
	di as txt "Bayesian model tests"

	tempname mcmcsum
	matrix `mcmcsum' = (`lmlvec',`prvec',`postprvec' )
	matrix colnames `mcmcsum' = "log(ML)" "P(M)" "P(M|y)"
	matrix rownames `mcmcsum' = `rownames'

	di
	qui _matrix_table `mcmcsum', formats(%9.4f %9.4f %9.4f)
	local tablen  = `s(width)'+2
	_matrix_table `mcmcsum', formats(%9.4f %9.4f %9.4f)
	di as text "{p 0 6 0 `tablen'}Note: Marginal likelihood (ML)"
	di as txt  "is computed using `mllname' approximation.{p_end}"

	// clear return
	return clear 
	return local  names	  = `"`names'"'
	return local  marglmethod = "`marglmethod'"
	return matrix test	  = `mcmcsum'
end

program _bayestest_interval, rclass
	if `"`e(cmd)'"' != "bayesmh" | `"`e(parnames)'"' == "" {
		di as err "last estimates not found"
		exit 301
	}
	_parse comma anything rhs : 0, bindcurly
	if (`"`rhs'"'=="") {
		di as err "invalid syntax"
		di as err "{p 4 4 2}You most likely forgot to include one"
		di as err "of your test specifications in parentheses{p_end}"
		exit 198
	}
	local 0 `rhs'
	syntax, 					///
			MCMCOBJECT(string)		///
		[	USING(string) 			///
			Lower(string) Upper(string)	///
			JOINT				///
			*				///
		]
	local opts `options'
	if (`"`anything'"'=="") {
		di as err "{p}you must specify at least one scalar model"
		di as err "parameter or expression of model parameters{p_end}"
		exit 198
	}
	if (`"`anything'"'=="_all") {
		di as err "{bf:_all} not allowed with {bf:bayestest interval}"
		exit 198
	}
	if ("`joint'"!="") {
		di as err "option {bf:joint} not allowed"
		di as err "{p 4 4 2}Perhaps you forgot to include your joint"
		di as err "specification in parentheses.{p_end}"
		exit 198
	}

	// load parameters sorted by eqnames in global macros 
	// to be used by _mcmc_fv_decode
	_bayesmh_eqlablist import

	local hypos `anything'
	// label:i.factorvar must be called as {label:i.factorvar} 
	// in order to expand properly
	_mcmc_fv_decode `"`hypos'"'
	local hypos `s(outstr)'

	_bayesmh_eqlablist clear
	
	gettoken tok : hypos, match(paren)
	if ("`paren'"=="" | `"`lower'`upper'"'!="") { // single test
		if ("`paren'"!="") {
			gettoken hypos : hypos, match(paren)
		}
		_bayestestint_getlabel prlab expr : `"`hypos'"' "prob1"
		_bayestestint_buildexpr expr exprleg : ///
				`"`expr', lower(`lower') upper(`upper')"'
		local thetas (`prlab':`expr')
		local exprlegend (`prlab'):(`exprleg')
	}
	else { // multiple tests
		_bayestestint_multtestparse thetas exprlegend : `"`hypos'"'
	}

	//check and parse common options
	_bayesmhpost_options `"`opts'"'
	local every = `s(skip)'+1
	local corrlag `s(corrlag)'
	local corrtol `s(corrtol)'
	local nolegend `s(nolegend)'
	local nobaselevels `s(nobaselevels)'
	local diopts `"`s(diopts)'"'

	//load simulation dataset and create mcmcobject based on it
	_mcmc_read_simdata, mcmcobject(`mcmcobject')	        ///
			    thetas(`thetas') using(`"`using'"') ///
	 	 	    every(`every') `nobaselevels' 
	local numpars	 `s(numpars)'
	local parnames   `"`s(parnames)'"'

	//check that mcmcobject is created
	mata:st_local("nomcmcobj",strofreal(findexternal("`mcmcobject'")==NULL))
	if (`nomcmcobj') {
		di as err "{bf:`mcmcobject'} not found"
		exit 3498
	}
	//compute the corresponding MCMC sample size
	tempname mcmcsize
	mata: st_numscalar("`mcmcsize'", `mcmcobject'.mcmc_size())
	if `mcmcsize' < 1 {
		di as err "insufficient MCMC sample size"
		exit 2001
	}
	//update maximum correlation lag based on current MCMC size
	_bayesmh_chk_corrlag corrlag : `corrlag' `mcmcsize'

	//compute results
	local clevel = 0.95
	mata: `mcmcobject'.summarize_matrix(J(0,0,""), J(0,0,0), ///
		0/*batch*/, `corrlag', `corrtol', `clevel', J(1,0,0))

	tempname mcmcsum meanfail mineff avgeff maxeff	cikind acfail 
	tempname essmat mcsemat mcsefail quantmat hpdmat covmat
	mata: `mcmcobject'.stata_report(				///
		"numpars",	"parnames",	""/*noinitmat*/,	///
		"`mcmcsum'",	"`mcmcsize'",	"`meanfail'",		///
		"`quantmat'",	"`hpdmat'",	"`cikind'",		///
		"`mcsemat'",	"`mcsefail'",				///
		"`essmat'",	"`covmat'",	"`acfail'",		///
		"`mineff'",	"`avgeff'",	"`maxeff'", 		///
		0/*no HPD*/,	"`nobaselevels'" != "")
		
	capture confirm matrix `mcmcsum'
	if _rc {
		di as err `"cannot summarize parameters {bf:`parnames'}"'
		exit _rc
	}

	//display results	
	di
	di as txt "Interval tests"				///
		_col(20) as txt "MCMC sample size" _col(37) "="	///
		_col(38) as res %10.0fc `mcmcsize'
	if `"`nolegend'"' == "" {
		// extra separation line
		di
		tempname mat
		matrix `mat' = `mcmcsum'[.,1..3]
		qui _matrix_table `mat', formats(%9.0g %10.5f %9.0g)
		local tablen  = `s(width)'
		_mcmc_expr legend `"`exprlegend'"' "" "`tablen'"
	}
	_mcmc_table summary  `numpars' `"`parnames'"' `clevel' "``cikind''" ///
		`mcmcsum' "`diopts'" "shorttable"
	_mcmc_mcsefailnote `mcsefail' `linesize'

	//return results
	matrix `mcmcsum' = `mcmcsum'[.,1..3]
	matrix colnames `mcmcsum' = "Mean" "Std Dev" "MCSE"
	matrix rownames `mcmcsum' = `parnames'
	return clear 
	_mcmc_expr return `"`exprlegend'"'
	ret add
	return local names    = `"`parnames'"'
	return scalar corrtol = `corrtol'
	return scalar corrlag = `corrlag'
	return scalar skip    = `every'-1
	return matrix summary = `mcmcsum'
end

program _bayestestint_multtestparse
	args tothetas tolegend colon hypos

	gettoken 0 hypos : hypos, match(paren)
	local nprlabs 1
	local prlablist
	if (`"`0'"'=="") {
		di as err "{p}you must specify at least one scalar"
		di as err "model parameter or expression of model"
		di as err "parameters{p_end}"
		_dieqerr `"(`0')"'
		exit 198
	}
	while (`"`0'"'!="") {
		if ("`paren'"!="(") {
			di as err "multiple test specifications " ///
				  "must each be included in parentheses"
			_dieqerr `"`0'"'
		}
		_parse comma jntspec rhs : 0, bindcurly
		if (`"`rhs'"'=="") {
			local rhs ,
		}
		local hold0 `"`0'"'
		local 0 `rhs'
		syntax [, JOINT * ]
		local 0 `"`hold0'"'
		if ("`joint'"=="") {
			local jntspec `"`0'"'
		}
		if (`"`jntspec'"'=="") {
			di as err "{p}you must specify at least one scalar"
			di as err "model parameter or expression of model"
			di as err "parameters{p_end}"
			_dieqerr `"(`0')"'
			exit 198
		}
		local deflab prob`nprlabs'
		cap noi _bayestestint_getlabel prlab expr : ///
						`"`jntspec'"' "`deflab'"
		if (_rc) {
			_dieqerr `"(`0')"'
		}
		if ("`prlab'"=="`deflab'") {
			local ++nprlabs
		}
		if (`: list prlab in prlablist') {
			di as err "label {bf:`prlab'} already defined"
			_dieqerr `"(`0')"'
		}
		local prlablist `prlablist' `prlab'
		if ("`joint'"!="") { // joint test
			local jntexpr
			local jntspec `expr'
			gettoken spec jntspec : jntspec, match(jntpar)
			local rc 0
			if ("`jntpar'"!="(") {
				local rc 198
			}
			if (`rc'==0) {
				gettoken spec2 : jntspec, match(jntpar)
				if ("`jntpar'"!="(" | `"`spec2'"'=="") {
					local rc 198
				}
			}
			if (`rc'==198) {
				di as err "{p}at least two specifications in" 
				di as err "parentheses are required for joint"
				di as err "testing;"
				di as err ///
"{bind:{bf:(({it:testspec1}) ({it:testspec2}), joint)}}"
				di as err "{p_end}"
				_dieqerr `"(`0')"'
				exit 198
			}
			if (`"`options'"'!="") {
				di as err `"{bf:`options'} not allowed"'
				_dieqerr `"(`0')"'
			}
			while (`"`spec'"'!="") {
				if ("`jntpar'"!="(") {
					di as err "test specification " ///
					          "must be specified in " ///
					          "parentheses"
					_dieqerr `"`spec'"' `"(`0')"'
				}
				//remove test-specific labels
				gettoken lab expr : spec, ///
						parse(":") bind bindcurly
				if (`"`expr'"'=="") {
					local expr `"`lab'"'
				}
				else {
					gettoken colon expr : expr, ///
						parse(":") bind bindcurly
				}
			        _bayestestint_buildexpr expr exprleg : ///
					      `"`expr'"' `"(`spec')"' `"(`0')"'
				if (`"`jntexpr'"'=="") {
					local jntexpr (`expr')
					local jntleg `exprleg'
				}
				else {
					local jntexpr `jntexpr' & (`expr')
					local jntleg `jntleg', `exprleg'
				}
				gettoken spec jntspec : jntspec, match(jntpar)
			}
			local expr `"`jntexpr'"'
			local exprleg `"`jntleg'"'
		}
		else { // separate tests
			_bayestestint_buildexpr expr exprleg : ///
							`"`expr'"' `"(`0')"'
		}
		local thetas `thetas' (`prlab':`expr')
		local legend `legend' (`prlab'):(`exprleg')
		gettoken 0 hypos : hypos, match(paren)
	}
	c_local `tothetas' "`thetas'"
	c_local `tolegend' "`legend'"
end

program _dieqerr
	args eq eq2

	if (`"`eq'"'=="") {
		exit 198
	}
	_mcmc_diparams dieq : `"`eq'"'
	if (`"`eq2'"'=="") {
		di as err `"{p} -- above applies to {bf:`dieq'}{p_end}"'
	}
	else {
		_mcmc_diparams dieq2 : `"`eq2'"'
		di as err ///
	`"{p} -- above applies to {bf:`dieq'} in {bf:`dieq2'}{p_end}"'
	}
	exit 198
end

program _bayestestint_getlabel
	args tolab toexpr colon spec deflab
	gettoken prlab expr : spec, parse(":") bind bindcurly
	if (`"`expr'"'=="") {
		local expr `"`prlab'"'
		local prlab  "`deflab'"
	}
	else {
		confirm names `prlab'
		tokenize `prlab'
		if `"`1'"' != `"`prlab'"' {
			di as err "{bf:`prlab'} invalid name"
			exit 7
		}
		gettoken colon expr : expr, parse(":") bind bindcurly
	}
	c_local `toexpr' `"`expr'"'
	c_local `tolab' `"`prlab'"'
end

program _bayestestint_check_lowerupper
	args tol tou toleq togeq colon lower upper extra
	if (`"`lower'`upper'"'=="") {
		di as err "option {bf:lower()} or " ///
			  "{bf:upper()} must be specified`extra'"
		exit 198
	}
	local leq "<"
	local geq ">"
	_bayestestint_check_luopt lower geq : "`lower'" "lower" "`geq'" 
	_bayestestint_check_luopt upper leq : "`upper'" "upper" "`leq'"
	if ("`lower'"!="." & "`upper'"!=".") {
		if (`lower' >= `upper') {
			di as err "{p}option {bf:lower()} may not exceed " ///
				  "or be equal to option {bf:upper()}{p_end}"
			exit 198
		}
	}
	else if ("`lower'"=="." & "`upper'"==".") {
		di as err "{p}only one of option {bf:lower()} or " ///
			  "{bf:upper()} may contain a missing value{p_end}"
		exit 198
	}
	c_local `tol'	"`lower'"
	c_local `toleq'	"`leq'"
	c_local `tou'	"`upper'"
	c_local `togeq'	"`geq'"
end

program _bayestestint_check_luopt
	args tomac eqmac colon option optname eq

	local 0 `option'
	syntax [anything(id="`optname'()" name=option)] [, INCLusive *]
	if (`"`option'"'!="" & `"`option'"'!=".") {
		cap confirm number `option'
		if _rc {
			di as err "option {bf:`optname'()} must contain a " ///
				  "number or a missing value ({bf:.})"
			exit 198
		}
	}
	else {
		local option .
	}
	if (`"`options'"'!="") {
		di as err `"suboption {bf:`options'} not allowed "' ///
			  "within option {bf:`optname'()}"
		exit 198
	}
	if ("`inclusive'"!="") {
		local eq "`eq'="
	}
	c_local `tomac' `option'
	c_local `eqmac' "`eq'"
end

program _bayestestint_buildexpr
	args toexpr toexprleg colon expr testspec eq2

	_parse comma anything rhs : expr, bindcurly
	if (`"`rhs'"'=="") {
		local rhs ,
	}
	local 0 `rhs'
	syntax [, Lower(string) Upper(string) * ]
	if (`"`anything'"'=="") {
		di as err "{p}you must specify at least one scalar model " ///
			  "parameter or expression of model parameters{p_end}"
		_dieqerr `"`testspec'"' `"`eq2'"'
	}
	gettoken expr anything : anything, parse("==") bind bindcurly
	local eqtest = bsubstr(`"`anything'"', 1, 2) == "=="
	local rc 0
	if (`eqtest') {
		if (`"`lower'"'!="") {
			di as err "option {bf:lower()} not allowed " ///
				  "with equality test"
			local rc = 198
		}
		if (`"`upper'"'!="") {
			di as err "option {bf:upper()} not allowed " ///
				  "with equality test"
			local rc = 198
		}
		gettoken eq anything : anything, parse("==") bind bindcurly
		local val `"`anything'"'
	}
	else {
		if (`"`testspec'"'!="") {
			local extra " within parentheses"
		}
		// check lower() and upper()
		cap noi _bayestestint_check_lowerupper lower upper leq geq : ///
						"`lower'" "`upper'" 	///
						"`extra'"
		local rc = _rc
	}
	if `rc' {
		_dieqerr `"`testspec'"' `"`eq2'"'
	}
	if ("`options'"!="") {
		di as err `"{bf:`options'} not allowed"'
		_dieqerr `"`testspec'"' `"`eq2'"'
	}
	if (`eqtest') {
		cap noi _bayestestint_expr_equal expr : `"`expr'"' `"`val'"'
		if (_rc) {
			_dieqerr `"`testspec'"' `"`eq2'"'
		}
		local exprleg `expr'
	}
	else {
		_bayestestint_expr expr exprleg : `"`expr'"'	///
					`"`lower'"' `"`upper'"' "`leq'" "`geq'"
	}
	c_local `toexpr'    "`expr'"
	c_local `toexprleg' "`exprleg'"
end

program _bayestestint_expr_equal
	args toexpr colon expr val

	cap confirm number `val'
	if (_rc) {
		di as err "{p}real number is required " ///
			  "following {bf:==} in the equality test{p_end}"
		exit 198
	}
	c_local `toexpr' "`expr'==`val'"
end

program _bayestestint_expr
	args toexpr toexprleg colon expr lower upper leq geq
	if ("`lower'"==".") {
		local expr `"`expr' `leq' `upper'"'
		local exprleg `"`expr'"'
	}
	else if ("`upper'"==".") {
		local expr `"`expr' `geq' `lower'"'
		local exprleg `"`expr'"'
	}
	else {
		if ("`geq'"==">") {
			local leq1 <
		}
		else {
			local leq1 <=
		}
		local exprleg `"`lower' `leq1' `expr' `leq' `upper'"'
		local expr (`expr' `geq' `lower') & (`expr' `leq' `upper')
	}
	c_local `toexpr'    `"`expr'"'
	c_local `toexprleg' `"`exprleg'"'
end
