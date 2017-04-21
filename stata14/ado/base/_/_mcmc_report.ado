*! version 1.0.6  19feb2016
program _mcmc_report, eclass
	version 14.0

	syntax ,  MCMCOBJECT(string) [				///
		CLEVel(string)					///
		Level(passthru) 				///
		HPD						///
		BATCH(string)					///
		CORRLAG(string)					///
		CORRTOL(string)					///
		NOTABle NOHEADer NOMODELSUMMary			///
		NOEXPRession					///
		BLOCKSUMMary					///
		SAVing(string asis)				///
		TITLE(string asis)			 	///
		POSTdata(string)			/// internal
		MODEQUS(string) MODDAG(string)		/// internal
		NOECOV					/// internal
		NOTWOCOLHEADER				/// internal
	 	  * ]

	// check summary options common to bayesstats summary
	local summopts batch(`batch') clevel(`clevel') `level' `hpd' 
	local summopts `summopts' corrlag(`corrlag') corrtol(`corrtol')
	local summopts `summopts' mcmcsize(`mcmcsize')"'
	_bayesmh_summaryopts `"`summopts'"'
	local batch  "`s(batch)'"
	local clevel "`s(clevel)'"
	local hpd    "`s(hpd)'"
	local corrlag `s(corrlag)'
	local corrtol `s(corrtol)'

	if `"`saving'"' != "" {
		_savingopt_parse fname replace : saving ".dta" `"`saving'"'
		cap confirm file `"`c(bayesmhtmpfn)'"'
		if _rc {
			di as err "current simulation results do not exist" 
			exit _rc
		}
		local replacenote 0
		if ("`replace'"=="") {
			confirm new file `"`fname'"'
		}
		else {
			cap confirm new file `"`fname'"'
			if _rc==0 {
				local replacenote 1
			}
		}
		qui copy `"`c(bayesmhtmpfn)'"' `"`fname'"', `replace'
		di as txt "note: " _c
		_bayesmh_saving_notes `replacenote' `"`fname'"'
		mata: st_global("e(filename)",`"`fname'"')
		exit
	}

	_get_diopts diopts, `options'

	local 0 ,`diopts'
	syntax [anything], [BASElevels ALLBASElevels *]
	local nobaselevels = "`baselevels'" == "" & "`allbaselevels'" == ""
		
	local clevel = `clevel'/100

	capture mata: `mcmcobject'
	if _rc != 0 {
		di as err "mcmc object not found"
		exit _rc
	}

	tempname ltemp lburnin lacr	///
		numpars mcmcsize llml	///
		ltotaliter initmat	///
		citype acfail thetas	///
		essmat mcsemat hpdmat 	///
		quantmat covmat 	///
		mcmcsum mcmcmat 	///
		meanfail mappars 	///
		mineff avgeff maxeff	///
		mindsize avgdsize maxdsize ///
		indepvars mcsefail matinit ty

	if `"`postdata'"' != "" {
		preserve

		use `"`postdata'"', clear

		mata: st_local("`ltotaliter'",	///
			strofreal(`mcmcobject'.total_iter()))
		mata: st_local("`lburnin'",	///
			strofreal(`mcmcobject'.burnin_iter()))
		mata: st_local("`lacr'",	///
			strofreal(`mcmcobject'.acceptance_rate()))
		mata: st_local("`ltemp'",	///
			invtokens(`mcmcobject'.form_simdata_colnames()))

		quietly ds
		if "``ltemp''" != "`r(varlist)'" {
			di as err `"incompatible data file `postdata'"'
			exit 198
		}
		mata: st_view(`ty'=., ., "``ltemp''")
		mata: `mcmcobject'.import_simdata(`ty')
		mata: mata drop `ty'
		
		scalar `llml' = .

		restore
	}
	else {
		if `"`e(filename)'"' != "" local postdata `"`e(filename)'"'

		mata: `mcmcobject'.m_parNames	  = tokens(`"`e(parnames)'"')
		mata: `mcmcobject'.m_parEquMap	  = tokens(`"`e(pareqmap)'"')
		mata: `mcmcobject'.m_postVarNames = tokens(`"`e(postvars)'"')
		mata: `mcmcobject'.m_parInit	  = st_matrix("e(init)")
	
		if `"`e(exclude)'"' != "" {
			mata: `mcmcobject'.m_paramExcluded = 1
		}

		if `"`postdata'"' != "" {
			preserve
			capture use `"`postdata'"', clear
			if _rc {
	 	 		di as err `"cannot open `postdata'"'
	 	 		exit _rc
			}
		}

		mata: `mcmcobject'.set_par_names(	///
			tokens(`"`e(scparams)'"'  ),	///
			tokens(`"`e(discparams)'"'),	///
			tokens(`"`e(matparams)'"' ),	///
			tokens(`"`e(latparams)'"' ))

		// call set_omit_scparams after set_par_names
		mata: `mcmcobject'.set_omit_scparams(`"`e(omitscparams))'"')

		// needed for BIC
		mata: `mcmcobject'.set_data_size("e(_N)")
		mata: `mcmcobject'.set_dic(`e(dic)')
		mata: `mcmcobject'.set_llatmean(`e(llatmean)')

		// check whether varnames and e(parnames) are the same 
		mata: st_local("`ltemp'", ///
			invtokens(`mcmcobject'.form_simdata_colnames()))
		quietly ds
		if `"``ltemp''"' != `"`r(varlist)'"' {
			di as err `"incompatible data file `postdata'"'
			exit 198
		}
		mata: st_view(`ty'=., ., "``ltemp''")
		mata: `mcmcobject'.import_simdata(`ty')
		mata: mata drop `ty'

		if `"`postdata'"' != "" restore

		// load model equations from e 
		local modequs `"`e(modequs)'"'
		local moddag  `"`e(moddag)'"'

		local `ltotaliter' `"`e(mcmciter)'"'
		local `lburnin'	   `"`e(burnin)'"'
		local `lacr'       `"`e(arate)'"'
		
		scalar `llml' = `e(lml_lm)'

		mata: `mcmcobject'.m_method = `"`e(method)'"'
		mata: `mcmcobject'.m_title  = `"`e(title)'"'
	}

	if `"`title'"' != "" {
		mata: `mcmcobject'.m_title  = `"`title'"'
	}

	// some MCMC sample size dependencies
	mata: st_numscalar("`mcmcsize'", `mcmcobject'.mcmc_size())
	if `mcmcsize' < 1 {
		di as err "no MCMC sample observations"
		exit 2000
	}
	// update maximum correlation lag based on current MCMC size
	_bayesmh_chk_corrlag corrlag : `corrlag' `mcmcsize'
	
	// update batch size based on current MCMC size
	if `batch' > `mcmcsize'/2 {
		local batch = floor(`mcmcsize'/2)
		di as txt "note: option {cmd:batch()} changed to {cmd:`batch'}"
	}

	mata: `mcmcobject'.summarize(`batch', `corrlag', `corrtol', `clevel')
	mata: `mcmcobject'.stata_report(	///
		"`numpars'",  "`thetas'",	///
		"`initmat'",  "`mcmcsum'",	///
		"`mcmcsize'", "`meanfail'",	///
		"`quantmat'", "`hpdmat'",   	///
		"`citype'",   "`mcsemat'",	///
		"`mcsefail'", "`essmat'",	///
		"`covmat'",   "`acfail'",	///
		"`mineff'",   "`avgeff'",	///
		"`maxeff'",   "`hpd'" != "",	///
		`nobaselevels')

	capture confirm matrix `mcmcsum'
	if _rc {
		local notable notable
	}

	mata:`mcmcobject'.data_size( ///
			"`mindsize'", "`avgdsize'", "`maxdsize'", "_N")

	// begin output 
	local col1len  = 13
	local linesize = 78
	if "`notable'" == "" {
		quietly _matrix_table `mcmcsum',			///
			formats(%9.0g %9.0g %8.0g %9.0g %9.0g %9.0g)	///
			notitles `diopts'
		local linesize = `s(width)'
		local col1len  = `s(width_col1)'
	}

	local labpos = `linesize'-28
	if `mindsize' < `maxdsize' {
		local labpos = `linesize'-30
	}
	local effpos = `linesize'-15
	local eqpos  = `linesize'-11
	local numpos = `linesize'-9
	
	if "`noheader'" == "" { 

		if "`nomodelsummary'" == "" {
			_mcmc_model , mcmcobject(`mcmcobject')     ///
			lmodel(`"`modequs'"') linesize(`linesize') ///
			`noexpression' 
		}
		if "`blocksummary'" != "" {
			_mcmc_blocksummary, linesize(`linesize')
		}
		
if ("`notwocolheader'"=="") { // leave style as is
		// extra separation line 
		di
		mata: st_local("`ltemp'", `mcmcobject'.m_title)
		di as txt `"``ltemp''"'				///
			_col(`labpos') as txt "MCMC iterations"	///
			_col(`eqpos') "="	 	 	 ///
			_col(`numpos') as res %10.0fc ``ltotaliter''
		mata: st_local("`ltemp'", `mcmcobject'.m_method)
		di as txt `"``ltemp''"'	 	 		///
			_col(`labpos') as txt "Burn-in"		///
			_col(`eqpos') "="			///
			_col(`numpos') as res %10.0fc ``lburnin''
		di _col(`labpos') as txt "MCMC sample size"	///
			_col(`eqpos') "="	 	 	///
			_col(`numpos') as res  %10.0fc `mcmcsize'

		if `numpars' > 1 & `mindsize' < `maxdsize' { 
			di _col(`labpos') as txt "Number of obs:"	///
				_col(`effpos') "min ="	 	 	///
				_col(`numpos') as res %10.0fc `mindsize'
			di _col(`effpos') as txt "avg ="		///
				_col(`numpos') as res %10.0fc `avgdsize'
			di _col(`effpos') as txt "max ="		///
				_col(`numpos') as res %10.0fc `maxdsize'
		}
		else {
			di _col(`labpos') as txt "Number of obs"	///
				_col(`eqpos') "="	 	 	///
				_col(`numpos') as res  %10.0fc `mindsize'
		}

		di _col(`labpos') as txt "Acceptance rate"	///
			_col(`eqpos') "="	 	 	///
			_col(`numpos') as res %10.4g ``lacr''

		if (`llml'== .) {
			mata: st_numscalar("`llml'", ///
				`mcmcobject'.laplace_loglik())
		}
		if (`llml'==.) {
			local LML ///
		"{help j_bayesmh_marglmiss:Log marginal likelihood}"
		}
		else {
			local LML Log marginal likelihood
		}

		if `numpars' > 1 & `mineff' < `maxeff' { 
			di _col(`labpos') as txt "Efficiency:"		///
				_col(`effpos') "min ="	 	 	///
				_col(`numpos') as res %10.4g `mineff'
			di _col(`effpos') as txt "avg ="		///
				_col(`numpos') as res %10.4g `avgeff'
			di as txt "`LML' = " 		///
				as res %10.0g `llml' 			///
				_col(`effpos') as txt "max ="	 	///
				_col(`numpos') as res %10.4g `maxeff'
		}
		else {
			di as txt "`LML' = " 		///
				as res %10.0g `llml'			///
				_col(`labpos') as txt "Efficiency"	///
				_col(`eqpos') "="	 	 	///
				_col(`numpos') as res %10.4g `avgeff'
		}
	}
} //end notwocolheader

	global MCMC_matsizemin = `numpars'

	if "`notable'" == "" {

	// thetas' in compound quotes for may contain multi-word names in quotes 
		_mcmc_table summary `numpars' `"``thetas''"'	///
			`clevel' "``citype''" `mcmcsum' "`diopts'"
		_mcmc_batchnote `batch' `linesize'
		if (`batch'==0) {
			_mcmc_mcsefailnote `mcsefail' `linesize'
		}
	}

	mata: st_numscalar("`ltemp'", `mcmcobject'.adapt_aftburnin())
	if `ltemp' == 1 {
		local NOTE {help j_bayesmh_adaptsim:Note:}
		di as txt "{p 0 6 0 `linesize'}`NOTE' Adaptation " ///
			"continues during simulation.{p_end}"
		ereturn hidden scalar adapt_duringsim = 0
	}
	
	if "``acfail''" != "" & `corrlag' > 0 {
		di as txt "{p 0 6 0 `linesize'}Note: There is a high " ///
			"autocorrelation after `corrlag' "	///
			`"`=plural(`corrlag',"lag")'.{p_end}"'
		ereturn hidden scalar is_highcorr = 1
	}
	else {
		ereturn hidden scalar is_highcorr = 0
	}

	mata: st_numscalar("`ltemp'", `mcmcobject'.is_adapttol_notmet())
	local NOTE {help j_bayesmh_adapttol:Note:}
	if `ltemp' == 2 {
		di as txt "{p 0 6 0 `linesize'}`NOTE' Adaptation tolerance " ///
			"is not met in at least one of the blocks.{p_end}"
		ereturn hidden scalar is_aratemet = 0
	}
	else if `ltemp' == 1 {
		di as txt "{p 0 6 0 `linesize'}`NOTE' Adaptation tolerance " ///
			"is not met.{p_end}"
		ereturn hidden scalar is_aratemet = 0
	}
	else {
		ereturn hidden scalar is_aratemet = 1
	}
	
	// ereturn 
	mata: st_local("`ltemp'", `mcmcobject'.m_title)
	ereturn local title = `"``ltemp''"'

	ereturn scalar clevel = `clevel'*100
	if `"`hpd'"' != "" {
		capture confirm matrix `hpdmat'
		if !_rc {
			ereturn scalar hpd	= 1
			matrix `mcmcmat'	= `hpdmat'[1..`numpars',1..2]
			matrix `mcmcmat'	= `mcmcmat''
			ereturn matrix cri	= `mcmcmat'
		}
	}
	else {
		capture confirm matrix `quantmat'
		if !_rc {
			ereturn scalar hpd	= 0
			matrix `mcmcmat'	= `quantmat'[1..`numpars',1..2]
			matrix `mcmcmat'	= `mcmcmat''
			ereturn matrix cri	= `mcmcmat'
		}
	}
	
	ereturn scalar batch	= `batch'
	ereturn scalar corrlag  = `corrlag'
	ereturn scalar corrtol  = `corrtol'

	ereturn scalar eff_min  = `mineff'
	ereturn scalar eff_max  = `maxeff'
	ereturn scalar eff_avg  = `avgeff'

	mata: st_numscalar("`ltemp'", `mcmcobject'.get_dic())
	ereturn scalar dic = `ltemp'
	mata: st_numscalar("`ltemp'", `mcmcobject'.get_llatmean())
	ereturn hidden scalar llatmean = `ltemp'
	mata: st_numscalar("`ltemp'", `mcmcobject'.mean_logposter())
	ereturn hidden scalar lp_mean = `ltemp'
	mata: st_numscalar("`ltemp'", `mcmcobject'.harmonic_loglik())
	ereturn hidden scalar lml_h = `ltemp'
	mata: st_numscalar("`ltemp'", `mcmcobject'.laplace_loglik())
	ereturn scalar lml_lm = `ltemp'
	mata: st_numscalar("`ltemp'", `mcmcobject'.adapt_iters())
	ereturn hidden scalar adapt_iters = `ltemp'

	capture confirm matrix `mcmcsum'
	if !_rc {
		matrix `mcmcmat'	= `mcmcsum'[1..`numpars',1]
		matrix `mcmcmat'	= `mcmcmat''
		ereturn matrix mean	= `mcmcmat'

		matrix `mcmcmat'	= `mcmcsum'[1..`numpars',4]
		matrix `mcmcmat'	= `mcmcmat''
		ereturn matrix median	= `mcmcmat'
	}
	else {
		global MCMC_matsizemin = `numpars'
	}

	capture confirm matrix `mcsemat'
	if !_rc {
		matrix `mcmcmat'	= `mcsemat'[1..`numpars',1]
		matrix `mcmcmat'	= `mcmcmat''
		ereturn matrix sd 	= `mcmcmat'

		matrix `mcmcmat'	= `mcsemat'[1..`numpars',2]
		matrix `mcmcmat'	= `mcmcmat''
		ereturn matrix mcse	= `mcmcmat'
	}
	
	capture confirm matrix `essmat'
	if !_rc {
		matrix `mcmcmat'	= `essmat'[1..`numpars',1]
		matrix `mcmcmat'	= `mcmcmat''
		ereturn matrix ess	= `mcmcmat'
	}

	if `"`noecov'"' == "" {
		capture confirm matrix `covmat'
		if !_rc {
			ereturn matrix Cov  = `covmat'
		}
	}

	capture confirm matrix `initmat'
	if !_rc {
		capture matrix `mcmcmat'    = `initmat''
	}
	if !_rc {
		ereturn matrix init = `mcmcmat'
	}

	ereturn local cmd = "bayesmh"
end

