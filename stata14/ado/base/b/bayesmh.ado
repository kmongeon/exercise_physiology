*! version 1.1.7  10mar2016
program bayesmh, eclass
	version 14.0
	local version : di "version " string(_caller()) ", missing :"

	// trim white space
	capture local 0 `0'
	if _rc {
		if (substr(`"`0'"',1,1)=="=") {
			di as err "{depvar} variable not specified"
			exit 198
		}
		di as err "invalid specification"
		exit 198
	}

	global MCMC_debug  0
	global MCMC_genvars
	global MCMC_tempmats
	global MCMC_eqlablist
	// matsize error counter
	global MCMC_matsizeerr 0
	global MCMC_matsizemin 0
	
	local rc 0
	if replay() {
		if "`e(cmd)'" != "bayesmh" {
			error 301 
		}

		// create a _c_mcmc_model object
		mata: getfree_mata_object_name("mcmcobject", "g_mcmc_model")
		mata: `mcmcobject' = _c_mcmc_model()

		// make sure mcmcobject goes as option
		local 1 `"`0'"'
		gettoken next 1 : 1, parse(",") bind
		if `"`0'"' != "," & `"`1'"' == "" {
		   local 0 `0',
		}
		capture noisily _mcmc_report `0' mcmcobject(`mcmcobject')
		local rc = _rc
	}
	else {
	
		if _by() { 
			error 190 
		}

		_bayesmh_syntax_precheck `0'

		// create a _c_mcmc_model object
		mata: getfree_mata_object_name("mcmcobject", "g_mcmc_model")
		mata: `mcmcobject' = _c_mcmc_model()

		mata: `mcmcobject'.m_command = "bayesmh"
		mata: `mcmcobject'.m_cmdline = `"`0'"'
		mata: `mcmcobject'.m_method  = "Random-walk Metropolis-Hastings"
		
		local 1 `"`0'"'
		gettoken next 1 : 1, parse(",") bind
		if `"`1'"' == "" {
			local 0 `0',
		}
		capture noisily _bayesmh `0' mcmcobject(`mcmcobject')
		local rc = _rc

		// report _mcmc_fv_decode's "matsize too small" error 908
		if `rc' & $MCMC_matsizeerr > 0 {
			cap noisily error(908)
			if $MCMC_matsizemin <= 11000 {
				di in red "recommended matsize is " ///
					$MCMC_matsizemin
			}
		}

	} // replay()

	_bayesmh_clear `mcmcobject'

	exit `rc'
end

program _bayesmh, eclass

	_bayesmh_import_model `0'

	local mcmcobject = `"`s(mcmcobject)'"'
	local simoptions = `"`s(simoptions)'"'
	local initial	 = `"`s(initial)'"'
	local optinitial = `"`s(optinitial)'"'
	local initrandom = `"`s(initrandom)'"'
	local exclude	 = `"`s(exclude)'"'
	local noshow	 = `"`s(noshow)'"'
	local seed	 = `"`s(seed)'"'
	local dryrun	 = `"`s(dryrun)'"'
	local nomodelsummary	 = `"`s(nomodelsummary)'"'
	local noexpression = `"`s(noexpression)'"'

	// make sure $MCMC_genvars exist
	local toklist $MCMC_genvars
	gettoken tok toklist : toklist
	while `"`tok'"' != "" {
		// initialize tempvars as missing
		capture generate double `tok' = .
		if _rc {
			capture replace `tok' = .
		}
		gettoken tok toklist : toklist
	}

	// build the model
	mata: `mcmcobject'.build_factors(NULL, NULL, 0)

	// block processing
	mata: `mcmcobject'.build_blocks()
	mata: `mcmcobject'.block_verify(NULL)

	// first initialize the optional starting values
	// apply optinitial only if random initial is not requested
	if `"`optinitial'"' != "" & `"`initrandom'"' == "" {
		_bayesmh_init_params `mcmcobject' `"`optinitial'"' 1
	}

	if `"`initial'"' != "" {
		_bayesmh_init_params `mcmcobject' `"`initial'"' 0
	}

	if `"`initrandom'"' != "" {
		mata: `mcmcobject'.init_random()
	}

	if "`exclude'" != "" {
		local toklist `exclude'
		gettoken next toklist : toklist, bindcurly
		while "`next'" != "" {
			_mcmc_parse word `next'
			if "`s(prefix)'" != "." {
				mata: `mcmcobject'.exclude_params(	///
					"`s(prefix)':`s(word)'")
			}
			else {
				mata: `mcmcobject'.exclude_params("`s(word)'")
			}
			gettoken next toklist : toklist, bindcurly
		}
	}

	if "`noshow'" != "" {
		// verify all noshow parameters
		local toklist `noshow'
		gettoken next toklist : toklist, bindcurly
		while "`next'" != "" {
			_mcmc_parse word `next'
			if "`s(prefix)'" != "." {
				mata: `mcmcobject'.noshow_params(	///
					"`s(prefix)':`s(word)'")
			}
			else {
				mata: `mcmcobject'.noshow_params("`s(word)'")
			}
			gettoken next toklist : toklist, bindcurly
		}
	}

	if $MCMC_debug != 0 {
		mata: `mcmcobject'.factor_view(NULL)
		mata: `mcmcobject'.block_view(NULL)
	}

	if `seed' >= 0 {
		set seed `seed' 
	}
	mata: `mcmcobject'.set_seed("`c(seed)'")

	if "`dryrun'" != "" {
		_mcmc_model, mcmcobject(`mcmcobject') `noexpression' ///
			     `nomodelsummary'
		exit 0
	}

	// Run simulation
	_mcmc_run, mcmcobject(`mcmcobject') `simoptions' /// 
		exclude(`exclude') `noexpression' `nomodelsummary'

end

program _bayesmh_syntax_precheck

	_parse comma lhs rhs : 0, bindcurly
	local 0 `rhs'
	syntax [, LIKELihood(string) PRIOR(string) EVALuator(string) ///
		  LLEVALuator(string) * ]
	if `"`evaluator'"' != "" & `"`llevaluator'"' != "" {
		opts_exclusive "evaluator() llevaluator()"
		exit 198
	}
	if `"`evaluator'"' != "" & `"`prior'"' != "" {
		opts_exclusive "evaluator() prior()"
		exit 198
	}
	local orhs `rhs'
	gettoken tok : lhs, match("par")
	local required1 `likelihood'`prior'`evaluator'`llevaluator'
	//no options
	if "`par'"!="(" & `"`orhs'"' == "" {	
		di as err "invalid {bf:bayesmh} specification"
		di as err "{p 4 4 2}No options specified.  Perhaps, you"
		di as err "omitted the comma." 
		di as err "To fit one of the supported models,"
		di as err "you must specify a likelihood model in"
		di as err "option {bf:likelihood()} and a prior distribution"
		di as err "in option {bf:prior()}.  To fit your own model,"
		di as err "you must specify, for example, the name of your"
		di as err "posterior-function evaluator in option"
		di as err "{bf:evaluator()}.  See {helpb bayesmh} and"
		di as err "{helpb bayesmh evaluators} for details."
		di as err "{p_end}"
		exit 198
	}
	if (("`par'"!="(" & (`"`required1'"'=="")) | 	///
			   ("`par'" != "(" & 		///
				`"`likelihood'"'!="" & `"`prior'"'=="") | ///
			   ("`par'" != "(" &		///
				`"`prior'"' != "" & ///
			`"`likelihood'`llevaluator'`evaluator'"' == "")) {
		di as err "invalid {bf:bayesmh} specification"
		di as err "{p 4 4 2}To fit one of the supported models,"
		di as err "you must specify a likelihood model in"
		di as err "option {bf:likelihood()} and a prior distribution"
		di as err "in option {bf:prior()}.  To fit your own model,"
		di as err "you must specify, for example, the name of your"
		di as err "posterior-function evaluator in option"
		di as err "{bf:evaluator()}.  See {helpb bayesmh} and"
		di as err "{helpb bayesmh evaluators} for details."
		di as err "{p_end}"
		exit 198
	}
	
	if ("`par'"!="(") {
		// Check single expression
		local olhs `lhs'
		// get through equation name if there is one
		gettoken first olhs : ///
				olhs , parse(":") bindcurly
		capture confirm name `first'
		if !_rc {
			gettoken first olhs : ///
				olhs , parse(":") bindcurly
			if `"`olhs'"' != "" {
				local 0 `olhs'			
			}
			else {
				local 0 `lhs'
			}
		}
		else {	
			local 0 `lhs' 
		}
		capture syntax [anything(equalok)] [if] [in] [fweight]
		if !_rc {
			if (subinstr(`"`anything'"',"=","",1) ///
				!= `"`anything'"') {
				gettoken first anything: ///
					anything , parse("=") bindcurly
				capture nvarcheck `first'
				local rc = _rc
				if !`rc' {
local w: word count `first'
if `w' > 1 & `"`likelihood'"' != "" {
	cap _check_mvnormal , `likelihood'
	if _rc {
		di as err "invalid {bf:bayesmh} specification"
		di as err "{p 4 4 2}Multiple dependent variables can only"
		di as err "be specified with {bf:likelihood(mvnormal())}."
		di as err "{p_end}"
		exit 198
	}
}
local ovars `first'
gettoken first anything: anything , parse("=") bindcurly
local 0 `anything'
capture syntax varlist(fv) [if] [in] [fweight]
if _rc & `"`anything'"' != "" {
	//nonlinear expression
	local w: word count `ovars'
	if `w' > 1 {
		di as err "invalid {bf:bayesmh} specification"
		di as err "{p 4 4 2}Multiple dependent variables cannot"
		di as err "be specified in the same equation as a" 
		di as err "nonlinear expression.{p_end}"
		exit 198
	}				
	gettoken first anything: anything, bindcurly
	if !(substr(`"`first'"',1,1) =="(" & ///
	     substr(`"`first'"',length(`"`first'"'),1) == ")") {
		di as err "invalid {bf:bayesmh} specification"
		di as err "{p 4 4 2}Nonlinear expressions must be"
		di as err "specified in parentheses.{p_end}"
		exit 198	
	}				
}
else if `"`anything'"' != "" {
	capture nvarcheck `varlist'
	local rc = _rc
	if `rc' {
		nvarcheck `varlist'
	}
}
				}
				else {
di as err "invalid {bf:bayesmh} specification"
if "`first'" == "" {
	di as err "{p 4 4 2}No {depvar} specified.{p_end}"
	exit 198
}
else {
	nvarcheck `first'
}
				}
			}
			else {
				capture nvarcheck `anything'
				local rc = _rc
				if `rc' & "`anything'" == "" {
di as err "invalid {bf:bayesmh} specification"
di as err "{p 4 4 2}No {depvar} specified.{p_end}"
exit 198
				}
				else if `rc' {
					nvarcheck `anything'
				}
			}					
		}
	}

	if ("`par'"!="(" | `"`evaluator'`llevaluator'"'!="") {
		exit
	}
	//multivariate model

	//multiple specifications
	_parse expand lc lg : lhs, gweight

	// Check that parentheses are used properly
	// global comma already taken care of and results are in orhs
	if `lc_n' > 1 {
		local nlhs `lhs'
		forvalues i=1/`lc_n' {
			gettoken fnlhs nlhs: nlhs, bindcurly 
			if `i' == `lc_n' - 1 {
				local 0 `nlhs'
				syntax [anything(equalok)] [if] [in] ///
					[fweight]
				local nlhs `anything'
				local nlhs = ltrim(rtrim(`"`nlhs'"'))
				if ~(substr(`"`nlhs'"',1,1) == "(" & 	///
				     substr(`"`nlhs'"',			///
					    length(`"`nlhs'"'),1) == ")") {
di as err "invalid {bf:bayesmh} specification"
di as err "{p 4 4 2}Equation is not "
di as err "enclosed in parentheses or "
di as err "a comma is omitted "
di as err "before the specification of options."
di as err "{p_end}"
di as err `"-- above applies to equation {bf:`lc_`lc_n''}"'
exit 198	 
				}				 
			}
		}
	}

	// fully check expressions

	forvalues i=1/`lc_n' {
		_parse comma lhs rhs : lc_`i', bindcurly
		// check single expression
		local olhs `lc_`i''
		// get through equation name if there is one
		gettoken first olhs: ///
			olhs , parse(":") bindcurly
		capture confirm name `first'
		if !_rc {
			gettoken first olhs: ///
				olhs , parse(":") bindcurly
			if `"`olhs'"' != "" {
				local 0 `olhs'			
			}
			else {
				local 0 `lc_`i''
			}
		}
		else {	
			local 0 `lc_`i'' 
		}
		local nl_`i' = 0
		capture syntax [anything(equalok)] [if] [in] [fweight]
		if !_rc {
			if (subinstr(`"`anything'"',"=","",1) ///
				!= `"`anything'"') {
				gettoken first anything: ///
					anything , parse("=") bindcurly
				capture nvarcheck `first'
				local rc = _rc
				if !`rc' {
					local w: word count `first'
					if `w' > 1 & `"`likelihood'"' != "" {
						cap _check_mvnormal , ///
							`likelihood'
						if _rc {
di as err "invalid {bf:bayesmh} specification"
di as err "{p 4 4 2}Multiple dependent variables can only"
di as err "be specified with {bf:likelihood(mvnormal())}.{p_end}"
di as err `"-- above applies to equation {bf:(`lc_`i'')}"'
exit 198
						}
					}
					local ovars `first'
					gettoken first anything: ///
						anything , parse("=") bindcurly
					local 0 `anything'
					capture syntax varlist [if] [in] [fweight]
					if _rc & `"`anything'"' != "" {
local nl_`i' = 1
//nonlinear expression
local w: word count `ovars'
if `w' > 1 {
	di as err "invalid {bf:bayesmh} specification"
	di as err "{p 4 4 2}Multiple dependent variables may not"
	di as err "be specified in the same equation as" 
	di as err "a nonlinear expression.{p_end}"
	di as err `"-- above applies to equation {bf:(`lc_`i'')}"'
	exit 198
}				
gettoken first anything: anything, bindcurly
if !(substr(`"`first'"',1,1)=="(" & ///
     substr(`"`first'"',length(`"`first'"'),1) == ")") {
	di as err "invalid {bf:bayesmh} specification"
	di as err "{p 4 4 2}Nonlinear expressions must be"
	di as err "specified in parentheses.{p_end}"
	di as err `"-- above applies to equation {bf:(`lc_`i'')}"'
	exit 198	
}				
					}
					else if `"`anything'"' != "" {
						capture nvarcheck `varlist'
						local rc = _rc
						if `rc' {
							nvarcheck `varlist'
						}
					}
				}
				else {
					di as err ///
					    "invalid {bf:bayesmh} specification"
					if "`first'" == "" {
di as err "{p 4 4 2}No {depvar} specified.{p_end}"
di as err `"-- above applies to equation {bf:(`lc_`i'')}"'
exit 198
					}
					else {
						nvarcheck `first'
					}
				}
			}
			else {
				capture nvarcheck `anything'
				local rc = _rc
				if `rc' {
di as err "invalid {bf:bayesmh} specification"
if `"`anything'"' == "" {
	di as err "{p 4 4 2}No {depvar} specified.{p_end}"
}
else {
	di as err "{p 4 4 2}Nonlinear expressions must be"
	di as err "specified in parentheses following"
	di as err "an equal sign.{p_end}"
}
di as err `"-- above applies to equation {bf:(`lc_`i'')}"'
exit 198
				}
			}					
		}
	}

	// disallow if/in if multivariate normal
	if (`"`likelihood'"'!="") {
		cap noi _check_mvnormal , `likelihood'
		if !_rc  {
			forvalues i = 1/`lc_n' {
				_parse comma lhs rhs : lc_`i', bindcurly
				// forbid if/in if multivariate normal
				local 0 `lhs'
				syntax anything(equalok) [if] [in]
				if `"`if'"' != ""  {
di as err "invalid {bf:bayesmh} specification"
di as err "{p 4 4 2}{bf:if} not allowed with"
di as err "{bf:likelihood(mvnormal())}."
di as err "{p_end}"
di as err `"-- above applies to equation {bf:(`lc_`i'')}"'
exit 198			 
				}
				if `"`in'"' != ""  {
di as err "invalid {bf:bayesmh} specification"
di as err "{p 4 4 2}{bf:in} not allowed with"
di as err "{bf:likelihood(mvnormal())}"
di as err "{p_end}"
di as err `"-- above applies to equation {bf:(`lc_`i'')}"'
exit 198			 
				}
			}
			exit
		}
	}
	//multiple specifications

	// check whether mvnormal is specified in another equation
	local mvnineq = 0
	forvalues i = 1/`lc_n' {
		_parse comma lhs rhs : lc_`i', bindcurly
		local 0 `rhs'
		syntax [, LIKElihood(string) *]
		local 0, `likelihood'
		capture _check_mvnormal `0'
		if !_rc {
			local mvnineq = 1
		}
	}

	// final checks
	forvalues i=1/`lc_n' {
		_parse comma lhs rhs : lc_`i', bindcurly
		local 0 `rhs'
		syntax [, LIKELihood(string) LLEVALuator(string) REffects(string) *]
		if `"`options'"' != "" {
			local 0, `options'
			local oopts `options'
			qui capture syntax [, noCONStant]
			if _rc {
				di as err "invalid {bf:bayesmh} specification"
				di as err "{p 4 4 2}Equation is misspecified:"
				local 0, `oopts'
				capture noi syntax [, noCONStant]
				di as err "{p_end}"
				di as err ///
			`"-- above applies to equation {bf:(`lc_`i'')}"'
				exit 198			 
			}
		}
		if (`"`likelihood'`llevaluator'"'=="") {
			di as err "invalid {bf:bayesmh} specification"
			di as err "{p 4 4 2}You must specify a likelihood model"
			di as err "in option {bf:likelihood()} or likelihood"
			di as err "evaluator in option {bf:llevaluator()}"
			di as err "within the equation specification."
			if (`lc_n'>1) {
				di as err "For a multivariate model, you must"
				di as err "specify global option"
				di as err "{bf:likelihood(mvnormal())}."
				if `mvnineq' {
					di as err ///
					"{bf:likelihood(mvnormal())}" 
					di as err "is currently"
					di as err ///
					"specified in an equation and not"
					di as err "as a global option."
				}
			}
			di as err "See {helpb bayesmh} and"
			di as err "{helpb bayesmh evaluators} for details."
			di as err "{p_end}"
			di as err ///
				`"-- above applies to equation {bf:(`lc_`i'')}"'
			exit 198
		}
	}
end

program _check_mvnormal
	syntax [, MVNormal(string asis) *]
	if (`"`mvnormal'"'=="") {
		exit 198
	}
end

program nvarcheck, rclass
	syntax varlist(numeric fv)
	return local varlist `varlist'
end
