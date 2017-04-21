*! version 1.0.2  30jul2015
program _mcmc_run, eclass
	version 14.0

	syntax ,   MCMCOBJECT(string) 	 	///
		[	 	 		///
		MCMCSize(string)	 	///
		BURNin(string)		 	///
		THINning(string)	 	///
		RSEED(string)	 	 	///
/* adaptation */	 	 	 	///
		EVERY(string)		 	///
		MINITER(string)		 	///
		MAXITER(string)  	 	///
		ALPHA(string)		 	///
		BETA(string)	 		///
		GAMMA(string)		 	///
		TARATE(string)	 		///
		TOLerance(string)		///
/* advanced */					///	
		SEARCH(string) 			///
		SEARCHREPEAT(string)	 	///
		SCale(real 2.38)	 	///
		COVariance(string)	 	///
/* reporting */				 	///
		CLEVel(string)	 		///
		HPD	 	 	 	///
		DOTS(string) 	 		///
		DOTSEVERY(string) 	 	///
		BATCH(string)	 		///
		CORRLAG(string)		 	///
		CORRTOL(string)		 	///
		NOTABle	 	 		///
		NOHEADer	 	 	///
		NOMODELSUMMary	 		///
		NOEXPRession			///
		BLOCKSUMMary			///
		TITLE(string asis)	 	///
		SAVing(string asis)	 	///
/* undocumented */				///
		EPSilon(real 0)	 		///
		NOECOV	 	 		///
		KEEPINITial	 	 	///
		BROWSE(integer 0)	 	///
		TEMPStart(real 0)	 	///
		TEMPGradient(real 0)	 	///
		RESTart(integer 0)	 	///
/* to save in ereturn */			///
		EXCLude(string)			///
		* ]

	// save for later: display options
	local dioptions `options'
	capture mata: `mcmcobject'
	if _rc != 0 {
		di as err "mcmc object not found"
		exit _rc
	}
	local adaptevery `every' // fot notational reason

	// most options are checked in _bayesmh_check_opts.ado;
	if `browse' < 0 {
		di as err "option {bf:browse()} must contain an integer >= 0"
		local browse 0
	}
	if `tempstart' < -1 {
		di as err "option {bf:tempstart()} must contain a number >= -1"
		exit 198
	}
	if `tempgradient' < 0 {
		di as err "option {bf:tempgradient()} must contain a " ///
			"number >= 0"
		exit 198
	}
	// check covariance()
	tempname stemp 
	if "`covariance'" != "" {
		mata: st_numscalar("`stemp'", `mcmcobject'.numparams())
		if `stemp' < 2 {
			di as err "option {bf:covariance()} may not be " ///
			  "specified for models with fewer than two parameters"
			exit 198
		}
		capture confirm matrix `covariance'
		if _rc == 0 {
			if !issymmetric(`covariance') {
				di as err "matrix {bf:`covariance'} must " ///
				   "be symmetric in option {bf:covariance()}"
				exit 505
			}
			tempname minv
			matrix `minv' = invsym(`covariance')
			if det(`minv') <= 0 {
				di as err "matrix {bf:`covariance'} must " ///
					"be positive definite in option " ///
					"{bf:covariance()}"
				exit 506
			}
			local rn: rowfullnames `covariance'
			local cn: colfullnames `covariance'
			mata: mcov = st_matrix(`"`covariance'"')
			mata: rnames = tokens(st_local("rn"))
			mata: cnames = tokens(st_local("cn"))
			mata: `mcmcobject'.init_upar_tucov(rnames, cnames, mcov)
			mata: mata drop mcov
		}
		else {
			di as err "option {bf:covariance()} must contain matrix"
			exit 198
		}
	}

	if "`nosummary'" != "" local nosummary 1
	else                   local nosummary 0

	// parse saving()
	local simdatapath
	if `"`saving'"' != "" {
		_savingopt_parse simdatapath replace : ///
			saving ".dta" `"`saving'"'
		local replacenote 0
		if ("`replace'"=="") {
			confirm new file `"`simdatapath'"'
		}
		else {
			cap confirm new file `"`simdatapath'"'
			if _rc==0 {
				local replacenote 1
			}
		}
	}
	else {
		local simdatapath `"`c(bayesmhtmpfn)'"'
	}
	
	tempname hasevaluators
	mata: st_numscalar("`hasevaluators'", `mcmcobject'.has_evaluators())
	if `hasevaluators' == 0 {
		// set post file
		local postdata `"`simdatapath'"'
	}
	else {
		// save simulation results to _bayesmh_sim.dta initially
		_mcmc_getfilename postdata : "_bayesmh_sim"
	}

	global MCMC_postdata `"`postdata'"'
	mata: `mcmcobject'.set_data_filename(`"`postdata'"')

	// set seed
	if ("`rseed'" != "") {
		set seed `rseed'
	}
	local rseed `c(seed)'

	mata: `mcmcobject'.set_seed(`"`rseed'"')

	mata: `mcmcobject'.run(		///
	 	`mcmcsize',		/// 
	 	`burnin',	 	/// 
	 	`thinning',		/// 
	 	`adaptevery',		/// 
	 	`miniter',	 	/// 
		`maxiter',	 	/// 
	 	`alpha',	 	/// 
	 	`beta',	 		/// 
	 	`epsilon',	 	///
	 	`gamma',	 	/// 
	 	`tarate',	 	/// 
	 	`tolerance',		/// 
	 	`scale',	 	///
	 	`browse',	 	///  
	 	`tempstart',	 	/// 
	 	`tempgradient',		///
	 	`searchrepeat',	 	///
	 	`restart',	 	///
	 	`dots',	 		/// 
	 	`dotsevery',		/// 
		`"`keepinitial'"'!="",	///
	 	`"`postdata'"' )

	tempname smcmcsize
	mata: st_numscalar("`smcmcsize'", `mcmcobject'.mcmc_size())
	if `smcmcsize' < 1 {
		di "no MCMC sample observations"
		exit 2000
	}

	////////////////////////////////////////////////////////////////////////
	// post e()

	tempname ltemp 
	mata: st_local(`"`ltemp'"', `mcmcobject'.global_touse())

	if `"``ltemp''"' != "" {
	 	tempvar touse
		mark `touse' ``ltemp''
		capture ereturn post, esample("`touse'") keepbayesmhtmpfn
		if _rc {
			ereturn post, keepbayesmhtmpfn
		}
	}
	else {
		ereturn post, keepbayesmhtmpfn
	}

	if `"`postdata'"' != `"`simdatapath'"' {
		// copy simulated data to the specified or temporary file 
		capture copy `"`postdata'"' `"`simdatapath'"', replace
		if _rc {
			di as txt "{p}Warning: file copy failed;"
			di as txt `"results are saved in {bf:`postdata'}.{p_end}"'
		}
		else { // erase duplicate simulation results
			erase `"`postdata'"'
			global MCMC_postdata ""
			local postdata `"`simdatapath'"'
		}
	}
	else {
		global MCMC_postdata ""
	}
	ereturn local filename = `"`postdata'"'

	// post search()
	if ("`search'"=="") {
		local search on
	}
	ereturn local search = `"`search'"'

	mata: st_local("`ltemp'", `mcmcobject'.get_seed())
	ereturn local rngstate = `"``ltemp''"'

	// model related
	mata: st_local("modequs", `mcmcobject'.model())
	ereturn hidden local modequs = `"`modequs'"'
	mata: st_local("moddag", `mcmcobject'.build_dag_model())
	ereturn hidden local moddag  = `"`moddag'"'

	mata: st_local("`ltemp'", `mcmcobject'.parequmap())
	ereturn local pareqmap  = `"``ltemp''"'
	mata: st_local("`ltemp'", `mcmcobject'.parnames())
	ereturn local parnames  = `"``ltemp''"'
	
	mata: st_local("`ltemp'", `mcmcobject'.postvar_names())
	ereturn local postvars  = `"``ltemp''"'

	mata: st_local("`ltemp'", `mcmcobject'.indepvar_names())
	ereturn hidden local indepvars = `"``ltemp''"'
	mata: st_local("`ltemp'", `mcmcobject'.indepvar_labels())
	ereturn hidden local indeplabels = `"``ltemp''"'

	mata: st_local("`ltemp'", `mcmcobject'.matparams())
	ereturn local matparams = `"``ltemp''"'
	mata: st_local("`ltemp'", `mcmcobject'.scparams())
	ereturn local scparams  = `"``ltemp''"'
	mata: st_local("`ltemp'", `mcmcobject'.omit_scparams())
	ereturn hidden local omitscparams  = `"``ltemp''"'

	mata: st_numscalar("`stemp'", `mcmcobject'.max_data_size())
	ereturn scalar N = `stemp'
	mata: st_numscalar("`stemp'", `mcmcobject'.k_params())
	ereturn scalar k = `stemp'
	mata: st_numscalar("`stemp'", `mcmcobject'.k_scparams())
	ereturn scalar k_sc  = `stemp'
	mata: st_numscalar("`stemp'", `mcmcobject'.k_matparams())
	ereturn scalar k_mat = `stemp'

	mata: st_numscalar("`stemp'", `mcmcobject'.start_loglik())
	ereturn hidden scalar ll_start = `stemp'
	mata: st_numscalar("`stemp'", `mcmcobject'.start_prior())
	ereturn hidden scalar lprior_start = `stemp'
	mata: st_numscalar("`stemp'", `mcmcobject'.start_posterior())
	ereturn hidden scalar lposterior_start = `stemp'

	mata: st_numscalar("`stemp'", `mcmcobject'.last_loglik())
	ereturn hidden scalar ll_last = `stemp'
	mata: st_numscalar("`stemp'", `mcmcobject'.last_prior())
	ereturn hidden scalar lprior_last = `stemp'
	mata: st_numscalar("`stemp'", `mcmcobject'.last_posterior())
	ereturn hidden scalar lposterior_last = `stemp'
	
	mata: `mcmcobject'.equations_ereport() 

	// simulation related 
	mata: st_numscalar("`stemp'", `mcmcobject'.mcmc_size())
	ereturn scalar mcmcsize = `stemp'
	mata: st_numscalar("`stemp'", `mcmcobject'.burnin_iter())
	ereturn scalar burnin   = `stemp'
	mata: st_numscalar("`stemp'", `mcmcobject'.total_iter())
	ereturn scalar mcmciter = `stemp'

	ereturn scalar thinning = `thinning'

	ereturn scalar scale	 = `scale'
	ereturn hidden local covariance = `"`covariance'"'

	ereturn scalar adapt_every	= `adaptevery'
	ereturn scalar adapt_miniter	= `miniter'
	ereturn scalar adapt_maxiter	= `maxiter'
	ereturn scalar adapt_alpha	= `alpha'
	ereturn scalar adapt_beta	= `beta'
	ereturn scalar adapt_gamma	= `gamma'
	if (`tarate'!=0) {
		ereturn hidden scalar adapt_tarate     = `tarate'
	}
	ereturn scalar adapt_tolerance      = `tolerance'
	ereturn hidden scalar adapt_epsilon = `epsilon'

	ereturn local exclude = `"`exclude'"'

	mata: st_numscalar("`stemp'", `mcmcobject'.acceptance_rate())
	ereturn scalar arate  = `stemp'
	mata: st_numscalar("`stemp'", `mcmcobject'.runtime())
	ereturn hidden scalar simtime = `stemp'
	mata: st_numscalar("`stemp'", `mcmcobject'.search_iter())
	ereturn scalar repeat  = `stemp'

	// block update parameters 
	mata: `mcmcobject'.blocks_ereport() 

	mata: st_local("`ltemp'", `mcmcobject'.m_method)
	ereturn local method   = `"``ltemp''"'
	mata: st_local("`ltemp'", `mcmcobject'.m_cmdline)
	ereturn local cmdline  = `"``ltemp''"'
	mata: st_local("`ltemp'", `mcmcobject'.m_command)
	ereturn local cmd      = `"``ltemp''"'

	if !`nosummary' {
		_mcmc_report, mcmcobject(`mcmcobject') 		///
			postdata(`"`postdata'"') 		///
	 	 	clevel(`clevel') 			///
			`hpd' batch(`batch')			///
	 	 	corrlag(`corrlag') corrtol(`corrtol')	///
	 	 	modequs(`"`modequs'"')			///
			moddag(`"`moddag'"')			///
	 	 	`notable' `noheader' `noeqtable'	///
			`nomodelsummary'	 		///
			`noexpression'				///
			`blocksummary'				///
	 	 	`dioptions' `noecov'			///
			title(`title') 
	}

	// display notes about saved files
	if (`"`saving'"'!="") {
		di
		_bayesmh_saving_notes `replacenote' `"`simdatapath'"'
	}
	
	// clear simulation parameters 
	mata: `mcmcobject'.clear_sample()
end

program _mcmc_getfilename
	args fname colon stub
	local i 1
	while `i'<=1000 {
		capture confirm new file `stub'`i'.dta
		if (_rc==0) {
			c_local `fname' `stub'`i'.dta
			exit
		}
		local ++i
	}
	di as err "{p 0 0 2}"
	di as err ///
  "could not find a filename for temporary {bf:bayesmh} file"
	di as err "{p_end}"
	di as err "{p 4 4 2}"
	di as err ///
  "I tried {bf:`stub'1.dta} through {bf:stub`i'.dta}."
	di as err "Perhaps you do not have write permission"
	di as err "in the current directory.  This may occur,"
	di as err "for example, if you started Stata by"
	di as err "clicking directly on the Stata executable"
	di as err "on a network drive.  You should make sure"
	di as err "you have write permission for the"
	di as err "current directory or use {helpb cd} to"
	di as err "change to a directory that has write"
	di as err "permission.  Use {helpb pwd}"
	di as err "to determine your current directory."
	di as err "{p_end}"
	exit 603
end
