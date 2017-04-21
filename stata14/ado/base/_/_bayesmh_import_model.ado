*! version 1.2.2  12may2016
program _bayesmh_import_model , sclass
	version 14.0
	local vv : di "version " string(_caller()) ", missing:"

	local alleqn ""
	local stop 0
	// retrieve parentheses-bounded equations
	while !`stop' { 
		gettoken eqn 0 : 0, parse("\ ,[") match(paren) bind
		if "`paren'" == "(" {
	 		local alleqn "`alleqn' (`eqn')"
	 		continue
		}
		local 0 `"`eqn' `0'"'
		local stop 1
	}

	local zero `"`0'"'
	capture syntax [anything] [if/] [in] [fw], [    	///
		MCMCOBJECT(string)				///
	 	LIKELihood(string)				///
	 	EVALuator(string) LLEVALuator(string)		///
	 	NOXBOK	/* omitting regressors is OK */ 	///
	 	NOCONStant					///
		REffects(string)				///
		SHOWREffects(string)				///
	 	INITial(string)					///
	 	NOMLEINITial					///
	 	EXCLude(string)					///
		NOSHOW(string)					///
	 	ADAPTation(string)				///
	 	SEED(integer -1)	 	 	 	///
	 	PREDICT	 	 	 	 	 	///
	 	PARSEONLY	 	 	 	 	///
	 	DRYRUN	 	 	 	 	 	///
	 	NOEXPRession 	 	 	 	 	///
		NOMODELSUMMary					///
	 	DEBUG	 	 	 	 	 	///
		REMULTieqok	 	 	 		///
		INITRANDom					///
		* ]

	if _rc {
		local eqline `0'
		gettoken anything eqline : eqline, parse("=") bind
		gettoken next     eqline : eqline, parse("=") bind
		if `"`anything'"' != "" & `"`next'"' == "=" {
			// non-linear equation
			local anything `"`anything'`next'"'
			gettoken next : eqline, parse("\ ,") bind
			if `"`next'"' != ","  & ///
			   `"`next'"' != "in" & `"`next'"' != "if" {
				gettoken next eqline : eqline, parse(",") bind
				// sanity check for expression
				_mcmc_parmlist `next' noxberror
				local anything `"`anything'`next'"'
			}
			local 0 `eqline'
			syntax  [if/] [in] [fw] , [  		///
			MCMCOBJECT(string)			///
			LIKELihood(string)			///
			EVALuator(string) LLEVALuator(string)	///
			NOXBOK	/* omitting regressors is OK*/	///
			NOCONStant				///
			REffects(string)			///
			SHOWREffects(string)			///
			INITial(string)				///
			NOMLEINITial				///
			EXCLude(string)				///
			NOSHOW(string)				///
			ADAPTation(string)			///
			SEED(integer -1)			///
			PREDICT	 	 	 	 	///
			PARSEONLY	 	 	 	///
			DRYRUN	 	 	 	 	///
	 		NOEXPRession 	 	 	 	///
			NOMODELSUMMary				///
			DEBUG	 	 	 	 	///
			REMULTieqok	 	 	 	///
			INITRANDom				///
			* ]
		}
		else {
			// reproduce the error
			local 0 `zero'
			syntax  [anything] [if] [in] [fw], [*]
		}
	}

	if "`initrandom'" != "" & "`nomleinitial'" != "" {
		di as err "options {bf:`initrandom'} and {bf:`nomleinitial'} " ///
			"cannot be combined"
		exit 198
	}

	// capture the yvar in a single equation specification
	local yvar
	gettoken next : anything, parse("=") bind
	capture confirm variable `next' 
	if _rc == 0 {
		local yvar `next'
	}

	if `"`mcmcobject'"' == "" {
		di as err "invalid specification" 
		exit 198
	}
	capture mata: `mcmcobject'
	if _rc != 0 {
		di as err `"{bf:`mcmcobject'} not found"'
		exit _rc
	}

	// Bayesian model
	local lbayesianmethod

	global MCMC_debug  0
	if "`debug'" != "" {
		global MCMC_debug  1
		mata: `mcmcobject'.m_debug = 1
	}

	if "`predict'" != "" {
		mata: `mcmcobject'.m_predict = 1
	}

	if `"`evaluator'"' != "" & `"`llevaluator'"' != "" {
		opts_exclusive "evaluator() llevaluator()"
	}
	local gevaluator `evaluator'
	
	if `"`likelihood'"' != "" {
		local alleqn `alleqn'
		if `"`anything'"' != "" local alleqn `"`alleqn' `anything'"'
		local alleqn `"`alleqn', likelihood(`likelihood') `noconstant' re(`reffects')"'
		local alleqn `alleqn'
		local alleqn `"(`alleqn')"'
	}
	else if `"`evaluator'"' != "" {
		if `"`anything'"' != "" local alleqn `"`alleqn' `anything'"'
		local alleqn `alleqn'
		local alleqn `"`alleqn', evaluator(`evaluator') `noconstant'"'
		local alleqn `alleqn'
		local alleqn `"(`alleqn')"'
	}
	else if `"`llevaluator'"' != "" {
		if `"`anything'"' != "" local alleqn `"`alleqn' `anything'"'
		local alleqn `alleqn'
		local alleqn `"`alleqn', llevaluator(`llevaluator') `noconstant'"'
		local alleqn `alleqn'
		local alleqn `"(`alleqn')"'
	}
	else {
		local alleqn `"`alleqn' `anything'"'
		local alleqn `alleqn'
	}

	if `"`alleqn'"' == "" {
		di as err "invalid specification" 
		exit 198
	}

	_bayesmh_eqlablist init

	// list of fv shortcuts
	local fveqlist
	// list of random-effects parameters
	local relablist
	local reparamlist
	local redefparams

	// xbdefines
	global MCMC_xbdeflabs
	global MCMC_xbdefvars

	// global touse
	local eqif `if'
	if `"`eqif'"' == "" {
		local eqif 1
	}
	local eqin `in'
	local eqwt `weight'
	local weqexp "`exp'"

	marksample touse
	mata: `mcmcobject'.set_global_touse(`"if `eqif' `in'"')

	// global `gtouse' as union of all equation-specific `touse'
	tempvar gtouse
	quietly gen `gtouse' = 0

	// list of equations
	local list_eq_names	
	// list of model parameters
	local list_par_names
	local list_par_prefix
	local list_par_isvar
	local list_depvar_names
	local list_indepvar_names
	local list_expr

	// global noconstant
	local gnoconstant `noconstant'
	local greffects `reffects'
	local allreffects
	local allreffectspar

	// blocks from redefine's
	local reblocks
	
	// list of temporary vars used for definitions
	local list_defvar_names
	if "`eqin'" != "" {
		tempvar din
		qui gen `din' = 0
		qui replace `din' = 1 `eqin'
		if `"`eqif'"' == "" {
			local eqif 1
		}
		local eqifin `eqif' & `din'
	}
	else {
		local eqifin `eqif'
	}

	// parse defines
	local defines `"`options'"'
	local options ""

	while `"`defines'"' != "" {
		gettoken eqline defines: defines, parse("\ ()") match(paren)

		local defopt
		// parse data/params until the first option
		if `"`eqline'"' == "xbdefine" | `"`eqline'"' == "redefine" {
			local defopt `eqline'
			gettoken eqline defines : defines, match(paren)
			// equations begin with ( 
			if "`paren'" != "(" {
				di as err "{bf:(} is expected after {bf:`defopt'}"
				exit _rc
			}
		}
		else {
			gettoken next defines : defines, match(paren)
			// move to options
			if "`paren'" == "(" {
				local options `"`options'`eqline'(`next') "'
			}
			else {
				local options `"`options'`eqline' "'
				if `"`next'"' != "" {
					local defines `"`next' `defines'"'
				}
			}
			continue
		}

		// equations begin with (
		if "`paren'" != "(" {
			local option `eqline'
			continue
		}

		gettoken ylabel next : eqline, parse(":") bind bindcurly
		gettoken next xlist  : next, parse(":") bind bindcurly

		if `"`next'"' != ":" {
			di as err "{bf:`defopt'(`eqline')} is misspecified:"
di as err `"{p 4 4 2}you should use column to separate definition name.{p_end}"'
			exit 198
		}

		if "`defopt'" == "redefine" {
			tokenize `"`xlist'"', parse(".")
			capture confirm numeric variable `3'
			if "`2'" != "." | _rc {
di as err "{bf:redefine(`eqline')} is misspecified:"
di as err `"{p 4 4 2}you should specify a single factor variable.{p_end}"'
				exit 198
			}
			local reblocks `reblocks' ///
				block({`ylabel':`xlist'}, reffects)
		}

		// markout missing observations from xlist
		markout `touse' `xlist'

		_mcmc_fv_decode `"`xlist'"'
		local xlist `s(outstr)'
		local eqline `ylabel':`xlist'

		// make shortcuts to all fv-parameters
		local fvvarlist `s(fvlablist)'
		gettoken tok fvvarlist : fvvarlist
		while `"`tok'"' != "" {
			local fveqlist = `"`fveqlist' {`ylabel':`tok'}"'
			gettoken tok fvvarlist : fvvarlist
		}
		
	 	_mcmc_scan_identmats `eqline'
	 	local eqline `s(eqline)'

		if $MCMC_debug {
	 		di " "
		 	di `"	 	define: `eqline'"'
		}

		_mcmc_xbdefinename `ylabel'
		local xbvar `s(xbdefine)'

		global MCMC_xbdeflabs $MCMC_xbdeflabs `ylabel'
		global MCMC_xbdefvars $MCMC_xbdefvars `xbvar'
		global MCMC_genvars $MCMC_genvars `xbvar'
		quietly generate double `xbvar' = 0

		gettoken next : xlist, parse("(") match(paren)
		if "`paren'" == "(" {
			if `"`xlist'"' != `"(`next')"' {
				di as err "invalid definition of expression" ///
				`" {bf:`xlist'}"'
				exit 198
			}
		}
		else {
			if "`defopt'" == "redefine" {
				tokenize `xlist'
				local xlist
				while "`*'" != "" {
					if bsubstr("`1'",1,2) == "r." {
						local xlist "`xlist' `1'"
					}
					else {
						local xlist "`xlist' r.`1'"
					}
					local redefparams ///
						"`redefparams' {`ylabel':`1'}"
					mac shift
				}
			}
			
			local varlist `xlist'
			local xlist
		 	gettoken next varlist : varlist
		 	while `"`next'"' != "" {
				local xlist = `"`xlist'`ylabel':`next' "'
				gettoken next varlist : varlist
		 	}
		}
				
		local eqline `xbvar', define(`xlist')

		_mcmc_parse equation `eqline', nocons

		if `"`s(x)'"' == "" {
			di as err "{bf:`defopt'(`ylabel':`xlist')} is misspecified:"
			di as err `"{p 4 4 2}expression {bf:`xlist'} "' ///
			" must include at least one model parameter.{p_end}"
			exit 198
		}
		
		if `"`s(y)'"' == "" {
			di `"{txt}note:{bf:define(`eqline')} is dropped"'
			continue
		}

		// update beta_label lists
		local varlist0 `s(xprefix)'
		local varlist  `s(x)'
		gettoken lyvar varlist0 : varlist0
		gettoken next  varlist  : varlist
		while `"`next'"' != "" { 
			if `"`lyvar'"' != "." & `"`lyvar'"' != "" {
				_bayesmh_eqlablist ind `lyvar'
				_bayesmh_eqlablist up  `lyvar' `next' `s(ylabind)'
			}
			gettoken lyvar varlist0 : varlist0
			gettoken next  varlist  : varlist
		}

		mata: `mcmcobject'.add_factor()	
		mata: `mcmcobject'.set_factor(			///
	 		NULL,	 	 	 	 	///
		 	"`s(dist)'",	 			///
		 	`"`s(eval)'"', "`s(evallist)'", 	///
		 	"`s(exprhasvar)'",	 	 	///
		 	"`s(argcount)'",	 	 	///
		 	"`s(y)'",	 	 		///
		 	"`s(yisvar)'",	 	 	 	///
		 	"`s(yislat)'",	 	 	 	///
		 	"`s(yismat)'",	 	 	 	///
		 	"`s(yprefix)'",	 	 		///
		 	"`s(yinit)'",				///
		 	"`s(yomit)'",				///
		 	"`s(x)'",	 	 	 	///
		 	"`s(xisvar)'",	 	 	 	///
		 	"`s(xislat)'",	 	 	 	///
		 	"`s(xismat)'",	 	 	 	///
			"`s(xisfact)'",		 	 	///
		 	"`s(xprefix)'",	 	 		///
		 	"`s(xargnum)'",	 	 		///
		 	"`s(xinit)'",	 	 	 	///
		 	"`s(xomit)'",	 	 	 	///
		 	"`s(nocons)'",	 	 		///
			"",                                     ///
		 	`"`llevaluator'"', "", "")

		// needs better solution!
		mata: `mcmcobject'.drop_pdist()

		if `"`yvar'"' != "" {
			markout `touse' `yvar'
		}

		mata: `mcmcobject'.set_touse( ///
			NULL, st_data(., "`touse'"), "", J(1,0,0), "", "")

	} // end of while

	// save for later
	local priors `options'
	local optinitial ""

	if $MCMC_debug {
		di " "
		di `"	likelihood: `alleqn'"'
		di " "
		di `"	    priors: `priors'"'
	}

	local n_nl 0
	local n_eq 0
	while `"`alleqn'"' != "" { // begin while

		local ++n_eq

		local if `lgs_if'
		local in `lgs_in'
		local weight `lgs_wt'
		
		gettoken 0 alleqn : alleqn, match(paren) bind
		if `"`paren'"' != "(" {
			di as err `"invalid likelihood specification {bf:`0'}"' 
			exit 198 
		}

		_mcmc_parse ifincomma `0'
		local lhs `s(lhs)'
		local rhs `s(rhs)'
		local 0 `rhs'

		syntax  [if/] [in] [fw] [,			///
	 		LIKELihood(string)			///
		 	EVALuator(string) LLEVALuator(string)	///
			NOCONStant      			///
			REffects(string)			///
		 	* ]

		if `"`levaluator'"' != "" & `"`llevaluator'"' != "" {
			opts_exclusive "evaluator() llevaluator()"
		}
		if `"`evaluator'"' == "" {
			local evaluator `llevaluator'
		}

		if `"`if'"' != "" {
			local if `eqifin' & `if'
		}
		else {
			local if `eqifin'
		}
		
		if `"`in'"' != "" {
			tempvar deqin
			quietly gen `deqin' = 0
			quietly replace `deqin' = 1 `in'
			local if `deqin' & `if'
		}
		if `"`weight'"' == "" {
			local weight `eqwt'
			local exp "`weqexp'"
		}

		local ifinopt if `if' 
		local weightopt ""
		local weightexp `"`exp'"'
		if `"`weight'"' != "" {
			local weightopt = `"[`weight'`exp']"'
		}
		local if `ifinopt'
		// mark the sample before the next call of syntax
		marksample touse
		// update global touse
		quietly replace `gtouse' = `gtouse' | `touse'

		local exp1    "`exp'"
		local weight1 "`weight'"

		if `"`reffects'"' == "" {
			local reffects `greffects'
		}
		local fvreffects
		if `"`reffects'"' != "" {
		
			if (`n_eq' > 1 & `"`remultieqok'"' == "") {
				di as err "{bf:reffects} option not allowed with " ///
					"multiple likelihood equations"
				exit 198
			}

			local 0 `reffects'
			capture syntax [anything] [,FVVARLISTok]
			if `"`fvvarlistok'"' == "" {
				capture syntax [varname] [,]
				if _rc {
					di as err "invalid {bf:reffects} specification"
					capture noi syntax [varname] [,]
					exit 198
				}
			}
			else {
				capture syntax [varlist(fv)] [,FVVARLISTok]
				if _rc {
					di as err "invalid {bf:reffects} specification"
					capture noi syntax [varlist(fv)] [,FVVARLISTok]
					exit 198
				}
				local reffects `varlist'
			}
			tokenize `"`reffects'"'
			local reffects
			local revars
			while "`*'" != "" {
				if bsubstr("`1'",1,4) == "ibn." {
					local reffects "`reffects' `1'"
				}
				else {
					local reffects "`reffects' ibn.`1'"
				}
				local revars "`revars' `1'"
				mac shift
			}

			_mcmc_fv_decode `"`reffects'"' `touse'
			local fvreffects `s(outstr)'
			
			if regexm(`"`fvreffects'"', "ibn.") {
				di as err "{bf:reffects} option not allowed for " ///
					`"variable {bf:`revars'}"'
				exit 198
			}
		}

		local 0 `lhs'
		local ct 1
		while `ct' > 0 {
			local 0 : subinstr local 0 ": " ":", count(local ct)
		}
		local ct 1
		while `ct' > 0 {
			local 0 : subinstr local 0 " :" ":", count(local ct)
		}

		// check for [multiple y`s = common x's] equation
		// tolerate parents: (y1 y2 = x1 x2 .. xp)
		gettoken anything : 0, parse("=,") bind match(paren)
		if `"(`anything')"' == `"`0'"' {
			local 0 `anything'
		}
		gettoken anything 0 : 0, parse("=,") bind
		gettoken next	  0 : 0, parse("=,") bind
		
		tokenize `anything'
		if `"`1'"' != "" & `"`next'"' == "=" {
		 	local anything `"`0'"'
		 	local 0 ""
		 	while "`*'" != "" {
				local 0 "`0'(`1' `anything') " 
				mac shift
		 	}
		}
		else local 0 `"`anything' `next' `0'"'

		// check for multiple univariate (y x) equations
		gettoken next : likelihood, parse("\ (") bind
		local l = length(`"`next'"')
		local isuni 1

		_mcmc_distr expand `"`next'"'
		
		if `"`s(distribution)'"' == "mvnormal"  |		///
		`"`s(distribution)'"' == "mvnormal0" | `"`evaluator'"' != "" {
			local isuni 0
		}

		if `"`reffects'"' != "" & `"`s(llf)'"'== "llf" {
			di as err "{bf:reffects} option not allowed with " ///
				"generic likelihood"
			exit 198
		}

		if `"`reffects'"' != "" & `isuni' == 0 {
			di `"{txt}note:random effects {bf:`reffects'} are shared "' ///
				"between dependent variables"
		}

		_parse expand lcs lgs: 0

		if `isuni' & `lcs_n' > 1 {
			local eqn ""
			while `lcs_n' > 0 {
				local next `"`lcs_`lcs_n''"'
				local next `"`next', likelihood(`likelihood') "'
				local next `"`next' evaluator(`evaluator') "'
				local next `"`next' `noconstant'"'
				local eqn  `"`eqn'(`next') "'
				local `--lcs_n'
			}

			local alleqn `"`eqn'`alleqn'"'
			local alleqn `alleqn'

			// load the first equation
			gettoken 0 alleqn : alleqn, match(paren)
			
			_parse comma lhs rhs : 0

			local 0 `rhs'
			capture syntax [,				///
				LIKELihood(string)	 	 	///
				EVALuator(string) LLEVALuator(string)	///
				NOCONStant      	 	 	///
				* ]

			if `"`evaluator'"' != "" & `"`llevaluator'"' != "" {
				opts_exclusive "evaluator() llevaluator()"
			}
			if `"`evaluator'"' == "" {
				local evaluator `llevaluator'
			}
			local 0 `lhs'
			
		} // if `isuni' & `lcs_n' > 1

		if `"`likelihood'"' == "" & `"`evaluator'"' == "" {
			di as err "invalid likelihood specification" 
			exit 198 
		}

		gettoken  dist distrparams : likelihood, parse("\ (,")
		gettoken  distrparams distopts : distrparams,	///
			parse("\ (,")  match(paren)
		if "`paren'" != "(" local distrparams ""
		_mcmc_distr expand `dist'
		local dist `s(distribution)'
		if bsubstr(`"`distopts'"', 1, 1) == "," {
			gettoken next distopts : distopts, parse(",")
		}

		if `"`dist'"' == "ologit" | `"`dist'"' == "oprobit" {
			if "`noconstant'" != "" {
				di as err "likelihood {bf:`dist'} does not " ///
					"allow option {bf:noconstant}"
				exit 198
			}
		}

		if "`noconstant'" == "" {
			local noconstant `gnoconstant'
		}

		_mcmc_getmleopts mleopts : "`dist'" "`distopts'"

		_parse expand lcs lgs : 0, gweight

		local eqline ""
		local xlist  ""	
		local ylist  ""
		local ylabel ""
		local d `lcs_n'

		scalar min_rmse = 0
		local mvequ ""
		local allnonlinear 1

		forvalues i=1/`lcs_n' { // begin forvalues
			local eqn `lcs_`i''

		 	gettoken ylabel eqn : eqn, parse(":") bind bindcurly
		 	if bsubstr(`"`eqn'"',1,1) == ":" {
				gettoken next eqn : eqn, parse(":") bind bindcurly
				// next == :
				// save it for later
				local lcs_`i' `eqn' 
		 	}
		 	else {
				local eqn `ylabel' 
				local ylabel ""
		 	}
		 	if `"`ylabel'"' != "" {
				capture confirm name `ylabel'
				if c(rc) {
					di as err "invalid label {bf:`ylabel'}"
					exit c(rc)
				}
			}

		 	gettoken anything eqn : eqn, parse("\ =,") ///
		 		match(paren) bind

			gettoken tok next : eqn, parse("\ =,") match(paren)
		 	if `"`tok'"' == "=" {
				gettoken next : next, parse("\ =,") match(paren)
				local eqn (`next')	 	
		 	}

		 	gettoken tok next : eqn, parse("\ =,") match(paren)
			local isnl 0

			if `"`anything'"' != "" & `"`tok'"' != "" & ///
		 	  `"`paren'"' == "(" {
				if `"`next'"' != "" {
		 	 	 	 di as err `"{bf:`eqn'} is "' ///
		 	 	 	 	"invalid nonlinear expression"
		 	 	 	 exit 198
				}
				local isnl 1
				local ++n_nl
				local anything `"`anything' = (`tok')"'
				local mvequ    `"`mvequ' (`anything')"'
				local eqn      `"`anything'"'

				// parse expression
				_mcmc_parmlist (`tok')
		 	}
		 	else {
				// should be a varlist
				local 0 `lcs_`i''

				// `no variables defined' error if no data
				// var, {var},(var) and ({var}) equivalent
				capture syntax [varlist(fv)] [,]
				if _rc {
di as err "invalid {bf:bayesmh} specification"
di as err "{p 4 4 2} Equation is misspecified: " 
capture noi syntax [varlist(fv)] [,]
di as err "{p_end}"
di as err `"-- above applies to equation {bf:(`lcs_`i'')}"'
exit 198
				}
				local mvequ `"`mvequ' (`varlist')"'
				local eqn   `"`varlist'"'
				local allnonlinear 0
		 	}
			if (`n_eq'>1 & `n_nl'>0 & "`debug'" == "") {
				di as err "nonlinear specifications are " ///
				   "not supported for multiple-equation models"
				exit 198
			}

			if (`"`reffects'"' != "" & `n_nl' > 0) {
				di as err "{bf:reffects} option not allowed with " ///
					"nonlinear models"
				exit 198
			}
			
		 	if `i' > 1 {
				if `"`xlist'"' != "" {
					local xlist = `"`xlist', "'
				}
			}

			local expr 0

			gettoken yvar eqn : eqn, parse("\ (=") bind
			if `"`yvar'"' == "" {
				di as err "no dependent variable specified"
				exit 198 
			}
			
			// ylabel:beta set
			local lyvar `yvar'
		 	if `"`ylabel'"' == "" local ylabel `yvar'
		 	else local lyvar `"`ylabel':`yvar'"'

		 	capture confirm variable `yvar'
		 	if _rc == 0 {
				capture confirm numeric variable `yvar'
				if _rc {
					error 2000
				}
				local expr 1			
			}
		 	tokenize `"`yvar'"', parse("{}")
		 	if `"`1'"' == "{" & `"`3'"' == "}" & `"`2'"' != "" {
				local expr 2
			}
		 	if `expr' == 0 {
				di as err "no variables defined"
				exit 111
		 	}
		 	else {
				local ylist = `"`ylist'`lyvar' "'
		 	}

			if `expr' == 1 {
				local ldups   $MCMC_eqlablist
				local lxbdefs $MCMC_xbdeflabs
				if `"$MCMC_xbdeflabs"' != "" {
					local ldups: list ldups - lxbdefs
				}
				local ldups `ldups' `yvar'
				local ldups : list dups ldups
				if `"`ldups'"' != "" {
					di as err "duplicate dependent " ///
						`"variable {bf:`ldups'}"'
					exit 198
				}
			}

		 	gettoken next : eqn, parse("=") bind
		 	if `"`next'"' == "=" {
				gettoken next eqn: eqn, parse("=") bind
				gettoken next : eqn, parse("") match(paren)
				if "`paren'" == "(" {
					local eqn `"`next'"'
				}
				local xlist `"`xlist'(`eqn')"'
				continue
		 	}

		 	local eqnocons `noconstant'
		 	local xwasempty = `"`xlist'"' == ""
		 	local xempty 1

		 	local xvarlist `eqn'
			// decode factors and interactions
		 	_mcmc_fv_decode `"`eqn'"' `touse'

			// make shortcuts to all fv-parameters
			local fvvarlist `s(fvlablist)'
			gettoken tok fvvarlist : fvvarlist
			while `"`tok'"' != "" {
				local fveqlist = `"`fveqlist' {`ylabel':`tok'}"'
				gettoken tok fvvarlist : fvvarlist
			}
				
			local varlist0 `s(outstr)'
			
			local ldups : list dups varlist0
			if `"`ldups'"' != "" {
				di as err `"duplicate variable {bf:`ldups'}"'
				exit 198
			}

			local ldups `varlist0' `yvar'
			local ldups : list dups ldups
			if `"`ldups'"' != "" {
				di as err `"duplicate variable {bf:`ldups'}"'
				exit 198
			}

			// update $MCMC_eqlablist and `beta_ylabel'
			_bayesmh_eqlablist ind `ylabel'
			local ylabind `s(ylabind)'

			local varlist `varlist0'
		 	gettoken next varlist : varlist
		 	while `"`next'"' != "" {
				_bayesmh_eqlablist up `ylabel' `next' `ylabind'

				local xempty 0
				local xlist = `"`xlist'`ylabel':`next' "'
				if `"`next'"' == "_cons" {
					local eqnocons "noconstant"
				}
				gettoken next varlist : varlist
		 	}

			if `"`dist'"' == "ologit" | `"`dist'"' == "oprobit" {
				local eqnocons "noconstant"
			}

			if `"`dist'"' == "dexponential" | ///
			   `"`dist'"' == "dbernoulli"   | ///
			   `"`dist'"' == "dbinomial"    | ///
			   `"`dist'"' == "dpoisson" {
				if `"`reffects'"' != "" {
				di as err "{bf:reffects} option not allowed with " ///
					"{bf:`dist'()} likelihood model"
					exit 198
				}
				if "`noconstant'" != "" {
				di as err "{bf:`noconstant'} not allowed with " ///
					"{bf:`dist'()} likelihood model"
					exit 198
				}
				if "`xlist'" != "" {
				di as err "variable {bf:`varlist0'} " ///
					"not allowed with {bf:`dist'()} likelihood model"
					exit 198
				}
				local eqnocons "noconstant"
			}
			
		 	if `"`eqnocons'"' == "" & `expr' == 1 {
				local xempty 0
				local xlist = `"`xlist'`ylabel':_cons "'

				_bayesmh_eqlablist up `ylabel' _cons `ylabind'
		 	}

			if `"`reffects'"' != "" {
				// setup reffects blocks
				tokenize `reffects'
				while "`*'" != "" {
					local priors `priors' ///
						block({`ylabel':`1'}, reffects)
					// make random-effects shortcut
					local tok = regexr(`"`1'"',"ibn.","i.")
					local relablist = ///
						`"`relablist' {`ylabel':`tok'}"'
					mac shift
				}

				tokenize `fvreffects'
				while "`*'" != "" {
					if bsubstr("`1'",1,2) == "r." {
					local xlist "`xlist' `ylabel':`1'"
					}
					else {
					local xlist "`xlist' `ylabel':r.`1'"
					}
					local xempty 0
					local allreffects ///
						"`allreffects' `ylabel':`1'"
					local reparamlist ///
						"`reparamlist' {`ylabel':`1'}"
					mac shift
				}
			}

			if `i' > 1 {
				if !`xwasempty' & `xempty' {
					// add 0 suffix to xlist
					local xlist = `"`xlist'0"'
				}
				if `xwasempty' & !`xempty' {
					// multivariate case
					// add (d-1) zero prefixes to xlist
					local j `i'
					while `j' > 1 {
						local `--j'
						local xlist = `"0,`xlist'"'
					}
				}
		 	}

			// fit some models to get initials 
		 	if `"`parseonly'"' == "" & `"`nomleinitial'"' == "" {
				_mle_initials `"`dist'"'	  ///
					`"`yvar'"'		  ///
					`"`ylabel'"'		  ///
					`"`xvarlist'"'            ///
					`"`eqnocons'"'		  ///
					`"`distrparams'"'	  ///
					`"`mleopts'"'		  ///
					`"`touse'"'		  ///
					`"`weightopt'"'		  ///
					`"`reffects'"'
				local optinitial "`optinitial' `s(optinitial)'"
		 	}

		} // end of forvalues

		if `allnonlinear' & "`noconstant'" != "" {
			di as err "{bf:`noconstant'} not allowed with " ///
				"nonlinear models"
			exit 198
		}

		local extravars	""
		local passthruopts ""
		local progparams   ""

		if `"`evaluator'"' == "" { // likelihood
		 	gettoken likelihood distrparams : likelihood, ///
		 		parse("\ (,")
		 	gettoken distrparams next: distrparams, ///
				parse("\ ,") match(paren)
		 	gettoken item : next, parse("\ ,")
		 	if `"`paren'"' != "(" {
				local distrparams ""
		 	}

		 	_mcmc_distr expand `likelihood'
			local llf `s(llf)'
			// additional response variables
		 	if `"`item'"' == "," {
				gettoken item next : next, parse("\ ,")
		 	}
		 	local distopts `next'

			if `"`likelihood'"' != "" {
				_mcmc_distr likelihood		///
					`"`likelihood'"' 	///
					`"`ylist'"'		///
					`"`xlist'"'		///
					`"`distrparams'"'	///
					`"`distopts'"'		///
					`"`noxbok'"'		///
					`"`touse'"'		///
					`"`isnl'"'		///
					`"`llf'"'

				local likelihood  `s(dist)'
				local distrparams `s(distparams)'
				local xlist	  `s(xlist)'
				local ylist	  `s(ylist)'
				local lbayesianmethod `s(likmodel)'
				// last-in first-out order
				local optinitial "`optinitial' `s(optinitial)'"
	 		}

		 	if `"`likelihood'"' == "" {
				di as err "likelihood must be specified"
				exit 198 
		 	}

		 	local eqline ""

			// in multivariate case add the dimension `d'
			if (`"`likelihood'"' == "mvnormal" | ///
			    `"`likelihood'"' == "mvnormal0") & `d' >= 1 { 
				local eqline = `"`eqline'`d'"'		
			}

			if `"`xlist'"' != "" { 
				if `"`eqline'"' != "" {
					local eqline = `"`eqline',`xlist'"'
				}
				else {
					local eqline = `"`xlist'"'
				}
		 	}
		 	if `"`distrparams'"' != "" {
				if `"`eqline'"' != "" {
					local eqline = "`eqline', `distrparams'"
				}
				else {
					local eqline = `"`distrparams'"'
				}
		 	}
		 	local eqline = "`ylist', `likelihood'(`eqline') nocons"
		}
		else { // evaluator ->
			local zero `0'
			local 0 `evaluator'
			syntax [anything] [,		///
				PARAMeters(string)	///
				EXTRAVARS(string)	///
				PASSTHRUopts(string) *]

		 	local evaluator `anything'
		 	local 0 `zero'
		 	if `"`evaluator'"' == "" {
				di as err "evaluator must be specified"
				exit 198 
		 	}

			if `"`extravars'"' != "" {
				capture confirm variable `extravars'
				if _rc {
					local tok: word count `extravars'
					if `tok' > 1 {
di as err "invalid option {bf:extravars()}:"
di as err `"{bf:`extravars'} must be variables"'
					}
					else {
di as err "invalid option {bf:extravars()}:"
di as err `"{bf:`extravars'} must be a variable"'
					}
					exit 198
				}
		 	}

		 	if `"`parameters'"' != "" { 
				gettoken tok parameters: parameters, ///
					parse("\ ") bind bindcurly
				while `"`tok'"' != "" {
					capture confirm number `tok'
					if _rc { 
						tokenize `"`tok'"', parse("{}")
						if `"`1'"' != "{" | ///
						   `"`3'"' != "}" {
di as err "invalid option {bf:parameters()}:"				
di as err `"{bf:`tok'} must be a model parameter"'
exit 198
						}
					}
					if `"`progparams'"' != "" {
						local progparams ///
							`progparams',`tok'
					}
					else {
						local progparams `tok'
					}
					gettoken tok parameters : ///
					parameters, parse("\ ") bind bindcurly
				}
				local ct 1
				while `ct' > 0 {
					local progparams : subinstr local ///
						progparams ",," "," , ///
						count(local ct)
				}
				if `"`xlist'"' != "" { 	 	 	 
					local eqline = ///
				`"`ylist', `evaluator'(`xlist',`progparams') nocons"'
				}
				else {
					local eqline = ///
				`"`ylist', `evaluator'(`progparams') nocons"'	
				}
			}
		 	else {
				local eqline = ///
				`"`ylist', `evaluator'(`xlist') nocons"'
	 		}
		}

		_mcmc_scan_identmats `eqline'
		local eqline `s(eqline)'
			
		if $MCMC_debug {
			di " "
			di `"	 	parse: `eqline'"'
		}

		_mcmc_parse equation `eqline'

		local list_distr `list_distr' `s(dist)'
		local list_wtype `list_wtype' `exp1'
		local list_wexp  `list_wexp'  `weight1'

		if `"`evaluator'"' == "" {
			mata: `mcmcobject'.add_distr_name(	///
				`"`s(dist)'"',			///
				`"`weight1'"',			///
				`"`exp1'"',			///
				0, "", "", "")
		}
		else {
			mata: `mcmcobject'.add_distr_name(	///
				`"`s(dist)'"',			///
				`"`weight1'"',			///
				`"`exp1'"',			///
				1,				///
				`"`progparams'"', 		///
				`"`extravars'"', 		///
				`"`passthruopts'"')
		}

		// update beta_label lists
		local varlist0 `s(xprefix)'
		local varlist  `s(x)'
		gettoken lyvar varlist0 : varlist0
		gettoken next  varlist  : varlist
		while `"`next'"' != "" { 
			if `"`lyvar'"' != "." & `"`lyvar'"' != "" {
				_bayesmh_eqlablist ind `lyvar'
				_bayesmh_eqlablist up  `lyvar' `next' `s(ylabind)'
			}
			gettoken lyvar varlist0 : varlist0
			gettoken next  varlist  : varlist
		}

		local list_depvar_names `list_depvar_names' `s(y)'
		local list_eq_names	`list_eq_names' `s(yprefix)'

		local list_par_names	`list_par_names' `s(x)'
		local list_par_prefix   `list_par_prefix' `s(xprefix)'
		local list_par_isvar	`list_par_isvar' `s(xisvar)'

		local list_expr `"`list_expr' `s(eval)'"'
		if `"`s(y)'"' == "" && `"`s(eval)'"' == "" {
			di as err `"{bf:`eqline'} not allowed"'
			exit 198 
		}	

		// extra dependent params from definitions
		local extravars `extravars' `s(exvarlist)'	
		local exparams
		local varlist `s(exvarlist)'
		gettoken next varlist : varlist
		while "`next'" != "" {
			if regexm(`"$MCMC_genvars"', "`next'") {
				tokenize $MCMC_eqlablist
				local ylabind 1
				while `"`1'"' != "" & `"`next'"' != `"`1'"' {
					local ylabind = `ylabind'+1
					mac shift
				}
				local ltemp BETA_`ylabind'
				local exparams = `"`exparams' $`ltemp'"'
			}
			gettoken next varlist : varlist
		}
		while regexm(`"`exparams'"', "{") {
			local exparams = regexr(`"`exparams'"', "{", "")
		}
		while regexm(`"`exparams'"', "}") {
			local exparams = regexr(`"`exparams'"', "}", "")
		}

		mata: `mcmcobject'.add_factor()
		mata: `mcmcobject'.set_factor(			///
		 	NULL,	 	 	 	 	///
		 	"`s(dist)'",	 			///
		 	`"`s(eval)'"', "`s(evallist)'",		///
		 	"`s(exprhasvar)'",	 	 	///
		 	"`s(argcount)'",	 	 	///
		 	"`s(y)'",	 	 	 	///
		 	"`s(yisvar)'",	 	 	 	///
		 	"`s(yislat)'",	 	 	 	///
		 	"`s(yismat)'",	 	 	 	///
		 	"`s(yprefix)'",	 	 		///
		 	"`s(yinit)'",	 	 	 	///
		 	"`s(yomit)'",	 	 	 	///
		 	"`s(x)'",				///
		 	"`s(xisvar)'",	 	 	 	///
		 	"`s(xislat)'",	 	 	 	///
		 	"`s(xismat)'",	 	 	 	///
			"`s(xisfact)'",		 	 	///
		 	"`s(xprefix)'",	 	 		///
		 	"`s(xargnum)'",	 	 		///
		 	"`s(xinit)'",				///
		 	"`s(xomit)'",				///
		 	"`s(nocons)'",				///
			"`exparams'",                           ///
		 	`"`llevaluator'"',			///
		 	`"`extravars'"',			///
			`"`passthruopts'"')

		// markout missing observations from varlist
		markout `touse' `s(varlist)'

		if `"`weightexp'"' != "" {
	 		gettoken next weightexp : weightexp, ///
	 			parse("\ =") match(paren)
		 	if "`weightexp'" == "" local weightexp "`next'"

			capture confirm variable `weightexp'
			if _rc {
				tempvar wexptemp
				qui generate double `wexptemp' = `weightexp'
				mata: `mcmcobject'.set_touse(		///
					NULL, 				///
					st_data(., "`touse'"),		///
					`"`ifinopt'"',			///
					st_data(., "`wexptemp'"),	///
					`"`weight1'"',			///
					`"`weightopt'"')
			}
			else {
				mata: `mcmcobject'.set_touse(		///
					NULL, 				///
					st_data(., "`touse'"),		///
					`"`ifinopt'"',			///
					st_data(., "`weightexp'"),	///
					`"`weight1'"',			///
					`"`weightopt'"')
			}
		}
		else {
		 	mata: `mcmcobject'.set_touse(		///
				NULL,				///
				st_data(., "`touse'"),		///
				`"`ifinopt'"',			///
				J(1,0,0),			///
				`"`weight1'"',			///
				`"`weightopt'"')
		}
	} // end of while

	// form the title
	if `"`lbayesianmethod'"' == "" {
		local lbayesianmethod "Bayesian regression"
	}
	mata: `mcmcobject'.m_title = `"`lbayesianmethod'"'
	
	_bayesmh_check_parameters `""`list_par_names'""'	///
		`""`list_par_prefix'""'			///
		`""`list_par_isvar'""'			///
		`""`list_depvar_names'""'		///
		`""`list_eq_names'""'

	mata: `mcmcobject'.set_depvar_names(`"`s(depvar_names)'"')
	mata: `mcmcobject'.set_var_names(`"`s(var_names)'"')
	mata: `mcmcobject'.set_eq_names(`"`s(eq_names)'"')

	local singley ""
	tokenize $MCMC_eqlablist
	if `"`1'"' != "" & `"`2'"' == "" {
		local singley `1'
	}

	_bayes_prior_opt "`mcmcobject'" "`gtouse'" "`singley'" `"`priors'"'

	local options		= `"`s(options)'"'
	local optinitial	= `"`optinitial' `s(optinitial)'"'
	local list_par_names	= `"`list_par_names' `s(list_par_names)'"'
	local list_par_prefix	= `"`list_par_prefix' `s(list_par_prefix)'"'
	local list_par_isvar	= `"`list_par_isvar' `s(list_par_isvar)'"'
	local list_expr		= `"`list_expr' `s(list_expr)'"'
	local extravars		= `"`extravars' `s(extravars)'"'

	_bayesmh_check_parameters		///
		`""`list_par_names'""'	///
		`""`list_par_prefix'""'	///
		`""`list_par_isvar'""'

	mata: `mcmcobject'.set_var_names(`"`s(var_names)'"')
	mata: `mcmcobject'.add_list_expr(`"`list_expr'"'   )

	if `"`parseonly'"' != "" {
		if $MCMC_debug != 0 {
			di as text `"{bf:`parseonly'} exit"'
		}
		/// sreturn
		sreturn clear
		sreturn local mcmcobject   = `"`mcmcobject'"'
		sreturn local tempidentmat = `"`tempidentmat'"'

		// clean up the label list
		local lablist $MCMC_eqlablist
		local eqlablist
		// populate eqlablist only if there are eq-labeled parameters
		if `"$MCMC_beta_1"' != "" {
			gettoken ylabel lablist : lablist
			while `"`ylabel'"' != "" {
				local eqlablist `eqlablist' {`ylabel':}
				gettoken ylabel lablist : lablist
			}
		}

		// list of shortcuts {ylab:}
		sreturn local eqnames	= `"`eqlablist'"'
		sreturn local fveqlist	= `"`fveqlist'"'
		sreturn local relablist	= `"`relablist'"'
		sreturn local reparams	= `"`reparamlist' `redefparams'"'
		exit 0
	}

	local blocks `reblocks' `options'

	_bayes_block_opt "`gtouse'" `"`blocks'"' `"`allreffects'"'

	local simoptions = `"`s(simoptions)'"'
	local blocksline = `"`s(blocksline)'"'	

	_mcmc_parse blocks `blocksline'
	mata: `mcmcobject'.set_blocks(				///
	`"`s(params)'"',  `"`s(parids)'"', `"`s(prefix)'"',	///
	`"`s(matrix)'"',  `"`s(latent)'"',	 		///
	`"`s(sampler)'"', `"`s(split)'"',	 		///
	`"`s(scale)'"',   `"`s(cov)'"',	 	 		///
	`"`s(arate)'"',   `"`s(atol)'"')

	_bayesmh_check_opts ,`simoptions' adaptation(`adaptation')
	local simoptions `"`s(simoptions)'"'
	local adaptation `"`s(adaptation)'"'

	if `"`initial'"' != "" {
		_mcmc_fv_decode	`"`initial'"'
		local initial `"`s(outstr)'"'
	}

	if "`exclude'" != "" {
		_mcmc_fv_decode	`"`exclude'"'
		_mcmc_parse expand `s(outstr)'
		local exclude `s(eqline)'
	}

	if "`noshow'" != "" {
		_mcmc_fv_decode	`"`noshow'"'
		_mcmc_parse expand `s(outstr)'
		local noshow `s(eqline)'
	}

	// expand shortcuts in `exclude', `noshow' and `initial'
	local lablist $MCMC_eqlablist
	gettoken ylabel lablist : lablist
	local ylabind 1
	while `"`ylabel'"' != "" {
		local ltemp BETA_`ylabind'
		while regexm(`"`exclude'"', `"{`ylabel':}"') {
			local exclude = regexr(`"`exclude'"', ///
				`"{`ylabel':}"', `"$`ltemp'"')
		}
		while regexm(`"`noshow'"', `"{`ylabel':}"') {
			local noshow = regexr(`"`noshow'"', ///
				`"{`ylabel':}"', `"$`ltemp'"')
		}
		while regexm(`"`showreffects'"', `"{`ylabel':}"') {
			local showreffects = regexr(`"`showreffects'"', ///
				`"{`ylabel':}"', `"$`ltemp'"')
		}
		while regexm(`"`initial'"', `"{`ylabel':}"') {
			local initial = regexr(`"`initial'"', ///
				`"{`ylabel':}"', `"$`ltemp'"')
		}
		gettoken ylabel lablist : lablist
		local `++ylabind'
	}

	if $MCMC_debug {
		di " "
		di `"exclude: `exclude'"'
		di " "
		di `"noshow: `noshow'"'
		di " "
		di `"initial: `initial'"'
	}

	local allreffectspar `reparamlist'
	if `"`showreffects'"' != "" {
		capture _mcmc_fv_decode	`"`showreffects'"'
		if _rc {
			di as err "invalid random-effects parameter " ///
				`"{bf:`showreffects'} in option "'    ///
				"{bf:showreffects()}" 
			exit 198
		}
		_mcmc_parse expand `s(outstr)'
		local showpars `s(eqline)'
		local commonstr : list showpars - allreffectspar
		if `"`commonstr'"' != "" {
			di as err "invalid random-effects parameters " ///
				`"{bf:`showreffects'} in option "'     ///
				"{bf:showreffects()}" 
			exit 198
		}
		local allreffectspar : list allreffectspar - showpars
	}
	local noshow `noshow' `allreffectspar'

	// sreturn
	sreturn clear
	sreturn local mcmcobject	= `"`mcmcobject'"'
	sreturn local simoptions	= `"`simoptions' `adaptation'"'
	sreturn local initial	  	= `"`initial'"'
	sreturn local optinitial	= `"`optinitial'"'
	sreturn local initrandom	= `"`initrandom'"'
	sreturn local exclude		= `"`exclude'"'
	sreturn local noshow		= `"`noshow'"'
	sreturn local seed		= `"`seed'"'
	sreturn local dryrun		= `"`dryrun'"'
	sreturn local noexpression	= `"`noexpression'"'
	sreturn local nomodelsummary	= `"`nomodelsummary'"'

end

program _mle_initials, sclass

	args dist yvar ylabel xvarlist eqnocons distrparams distopts ///
		touse weightopt reffects

	tempname mb tmodel

	tokenize `"`dist'"', parse(`"""')
	local dist `1'
	tokenize `"`yvar'"', parse(`"""')
	local yvar `1'
	tokenize `"`ylabel'"', parse(`"""')
	local ylabel `1'
	tokenize `"`xvarlist'"', parse(`"""')
	local xvarlist `1'
	tokenize `"`eqnocons'"', parse(`"""')
	local eqnocons `1'
	tokenize `"`distrparams'"', parse(`"""')
	local distrparams `1'
	tokenize `"`distopts'"', parse(`"""')
	local distopts `1'

	local optinitial ""

	if `"`touse'"' != "" {
		local touse if `touse'
	}

	if "`xvarlist'" == "" & "`eqnocons'" != "" {
	
		if "`dist'" == "dpoisson" | "`dist'" == "dexponential" {
			_mcmc_parse args `distrparams'
			if `"`distrparams'"' == `"`s(param1)'"' {
				capture summ `yvar', meanonly
				if _rc == 0 {
					local optinitial = ///
					`"`distrparams' `=r(mean)' `optinitial'"'
				}
			}
		}

		sreturn local optinitial = `"`optinitial'"'
		exit 0
	}

	capture _estimates hold `tmodel'

	if "`dist'" == "normal" | "`dist'" == "mvnormal" | ///
	   "`dist'" == "mvnormal0" {
		capture regress `yvar' `xvarlist' `reffects' ///
			`touse' `weightopt', `eqnocons' 
		if _rc & `"`reffects'"' != "" {
			capture regress `yvar' `xvarlist' ///
				`touse' `weightopt', `eqnocons' 
		}
		if _rc == 0 {
		 	scalar min_rmse = `e(rmse)'
			if min_rmse <= 0 {
				scalar min_rmse = 1
			}
		 	mat `mb' = e(b)
		 	local varlist: colnames `mb'
		 	gettoken next varlist : varlist
		 	local j 0
		 	while `"`next'"' != "" { 
				local ++j
				if regexm(`"`next'"', "o\.") {
					gettoken next varlist : varlist
					continue
				}
				local optinitial = ///
`"{`ylabel':`next'} `=(`mb'[1,`j'])' `optinitial'"'
				gettoken next varlist : varlist
			}

			tokenize `"`distrparams'"', parse("{}=,")
			if `"`1'"' == "{" & `"`2'"' != "" & `"`3'"' == "}" {
				local optinitial = /// 
					`"{`2'} `=(min_rmse^2)' `optinitial'"'
			}
		}
	}

	if "`dist'" == "probit" | "`dist'" == "logit"  | "`dist'" == "mlogit" {
		capture `dist' `yvar' `xvarlist' `reffects' ///
			`touse' `weightopt', `eqnocons' `distopts'
		if _rc & `"`reffects'"' != "" {
			capture `dist' `yvar' `xvarlist' ///
				`touse' `weightopt', `eqnocons' `distopts'
		}
		if _rc == 0 {
		 	mat `mb' = e(b)
		 	local varlist: colnames `mb'
		 	gettoken next varlist : varlist
		 	local j 0
		 	while `"`next'"' != "" {
				local ++j
				if regexm(`"`next'"', "o\.") {
					gettoken next varlist : varlist
					continue
				}
				local optinitial = ///
`"{`ylabel':`next'} `=(`mb'[1,`j'])' `optinitial'"'
				gettoken next varlist : varlist
			}
		}
	}
	
	if "`dist'" == "poissonreg" | "`dist'" == "poisson" { 
		capture poisson `yvar' `xvarlist' `reffects' ///
			`touse' `weightopt', `eqnocons' `distopts'
		if _rc & `"`reffects'"' != "" {
			capture poisson `yvar' `xvarlist' ///
				`touse' `weightopt', `eqnocons' `distopts'
		}
		if _rc == 0 { 
			mat `mb' = e(b)
			local varlist: colnames `mb'
			gettoken next varlist : varlist
			local j 0
			while `"`next'"' != "" { 
				local `++j'
				if regexm(`"`next'"', "o\.") {
					gettoken next varlist : varlist
					continue
				}
				local optinitial = ///
`"{`ylabel':`next'} `=(`mb'[1,`j'])' `optinitial'"'
				gettoken next varlist : varlist
			}
		}
	}

	if "`dist'" == "expreg" | "`dist'" == "exponential" { 
		capture gsem `yvar' <-`xvarlist' `reffects' `touse' `weightopt', ///
			`eqnocons' `distopts' family(exponential)
		if _rc & `"`reffects'"' != "" {
			capture gsem `yvar' <-`xvarlist' `touse' `weightopt', ///
				`eqnocons' `distopts' family(exponential)
		}
		if _rc == 0 {
			mat `mb' = e(b)
			local varlist: colnames `mb'
			gettoken next varlist : varlist
			local j 0
			while `"`next'"' != "" { 
				local `++j'
				if regexm(`"`next'"', "o\.") {
					gettoken next varlist : varlist
					continue
				}
				local optinitial = ///
`"{`ylabel':`next'} `=(`mb'[1,`j'])' `optinitial'"'
				gettoken next varlist : varlist
			}
		}
	}

	if "`dist'" == "binlogit" | "`dist'" == "binomial" {
		capture gsem `yvar' <-`xvarlist' `reffects' `touse' `weightopt', ///
			`eqnocons' `distopts' family(binomial `distrparams')
		if _rc & `"`reffects'"' != "" {
			capture gsem `yvar' <-`xvarlist' `touse' `weightopt', ///
			`eqnocons' `distopts' family(binomial `distrparams')
		}
		if _rc == 0 {
			mat `mb' = e(b)
			local varlist: colnames `mb'
			gettoken next varlist : varlist
			local j 0
			while `"`next'"' != "" {
				local `++j'
				if regexm(`"`next'"', "o\.") {
					gettoken next varlist : varlist
					continue
				}
				local optinitial = ///
			`"{`ylabel':`next'} `=(`mb'[1,`j'])' `optinitial'"'
				gettoken next varlist : varlist
			}
		}
	}

	if "`dist'" == "lognormal" {
		capture gsem `yvar' <-`xvarlist' `reffects' `touse' `weightopt', ///
			`eqnocons' `distopts' family(lognormal)
		if _rc & `"`reffects'"' != "" {
			capture gsem `yvar' <-`xvarlist' `touse' `weightopt', ///
				`eqnocons' `distopts' family(lognormal)
		}
		if _rc == 0 {
			mat `mb' = e(b)
			local varlist: colfullnames `mb'
			gettoken next varlist : varlist
			local j 0
			while `"`next'"' != "" { 
				local `++j'
				if regexm(`"`next'"', "o\.") {
					gettoken next varlist : varlist
					continue
				}
				local optinitial = ///
				`"{`next'} `=(`mb'[1,`j'])' `optinitial'"'
				gettoken next varlist : varlist
			}
		}
	}
	
	if "`dist'" == "ologit" | "`dist'" == "oprobit" {
		capture `dist' `yvar' `xvarlist' `reffects' ///
			`touse' `weightopt', `distopts'
		if _rc & `"`reffects'"' != "" {
			capture `dist' `yvar' `xvarlist' ///
				`touse' `weightopt', `distopts'
		}
		if _rc == 0 { 
			mat `mb' = e(b)
			local varlist: colfullnames `mb'
			gettoken next varlist : varlist
			gettoken tok next : next, parse(":")
			local j 0
			while `"`next'"' != "" & `"`tok'"' == "`ylabel'" { 
				local `++j'
				if regexm(`"`next'"', "o\.") {
					gettoken next varlist : varlist
					continue
				}
				local optinitial = ///
`"{`tok'`next'} `=(`mb'[1,`j'])' `optinitial'"'
				gettoken next varlist : varlist
				gettoken tok next : next, parse(":")
			}
			local next `tok'`next'
			local k 0
			while `"`next'"' != "" { 
				local `++k'
				local `++j'
				gettoken tok next : next, parse("/")
				if `"`next'"' == "" local next `tok'
				gettoken tok : next, parse(":")
				if `"`tok'"' == "cut`k'" {
				local optinitial = ///
`"{`ylabel':_cut`k'} `=(`mb'[1,`j'])' `optinitial'"'
				local varlist0 = `"`varlist0' `ylabel':_cut`k'"'
				}
				gettoken next varlist : varlist
		 	}
		}
	}

	capture _estimates unhold `tmodel'

	sreturn local optinitial = `"`optinitial'"'
end

program _mcmc_getmleopts
	args mleopts colon dist distopts	
	local 0 ,`distopts'
	syntax [, OFFset(passthru) EXPosure(passthru) ///
		  BASEoutcome(passthru) * ]		  
	c_local `mleopts' "`offset' `exposure' `baseoutcome'"
end

program _mcmc_xbdefinename, sclass
	args label
	local varname ""
	local i 0
	while "`varname'" == "" {
		capture confirm variable __lvar_`label'_`i'
		if (_rc==111) {
			local varname __lvar_`label'_`i'
			continue
		}
		local ++i
		if (`i'>=999) {
			di as err "{p 0 0 2}"
			di as err "could not find a name for temporary variable"
			di as err "{p_end}"
			di as err "{p 4 4 2}"
			di as err "I tried __lvar_`label'_0 through __lvar_`label'_`i'."
			di as err "{p_end}"
			exit 603
		}
	}
	sreturn local xbdefine `varname'
	
end
