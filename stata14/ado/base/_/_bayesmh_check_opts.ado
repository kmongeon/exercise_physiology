*! version 1.0.1  23aug2016
program _bayesmh_check_opts, sclass 
	version 14.0
	syntax , [			///
		MCMCSize(string)	///
		BURNin(string)		///
		THINning(string)	///
		RSEED(passthru)		///
		EXCLude(passthru)	///
/* adaptation */			///
		ADAPTation(string)	///
		SCale(string)		///
		COVariance(passthru)	///
		NOSHOW(passthru)	///
		CLEVel(passthru)	///
		Level(string)		///
		HPD			///
		BATCH(string)		///
		DOTS			///
		DOTS1(string)		///
		DRYRUN			///
		NOTABle			///
		NOHEADer		///
		NOMODELSUMMary		///
		NOEXPRession		///
		BLOCKSUMMary		///
		SAVing(passthru)	///
/* advanced */				///
		CORRLAG(string)		///
		CORRTOL(string)		///
		SEARCH(string)		///
/* supported display options */		///
		NOOMITted		///
		VSQUISH			///
		NOEMPTYcells		///
		BASElevels		///
		ALLBASElevels		///
		NOFVLABel		///
		FVWRAP(integer 1)	///
		FVWRAPON(string)	///
		NOLSTRETCH		///
		TITLE(passthru)		///
/* undocumented */			///
		NOECOV 			///
		NOTWOCOLHEADER		///
		KEEPINITial	 	///
		]
	local simopts `rseed' `exclude' `covariance' `noshow' 
	local simopts `simopts' `hpd' `dryrun' `notable' `noheader'
	local simopts `simopts' `nomodelsummary' `noexpression' `blocksummary'
	local simopts `simopts' `noomitted' `vsquish' `noemptycells' `baselevels' 
	local simopts `simopts' `allbaselevels' `nofvlabel' fvwrap(`fvwrap')
	local simopts `simopts' `fvwrapon' `nolstretch' `title' `saving'
	local simopts `simopts' `noeqcov' `notwocolheader' `keepinitial'

	// check burnin()
	if (`"`burnin'"'!="") {
		cap confirm integer number `burnin'
		local rc = _rc
		if (!`rc') {
			if (`burnin'<0) {
				local rc 198
			}
		}
		if `rc' {
			di as err "{p}option {bf:burnin()} must contain "
			di as err "a nonnegative integer{p_end}"
			exit `rc'
		}
	}
	else {
		local burnin 2500
	}

	// check mcmcsize()
	if (`"`mcmcsize'"'!="") {
		cap confirm integer number `mcmcsize'
		local rc = _rc
		if (!`rc') {
			if (`mcmcsize'<=0) {
				local rc 198
			}
		}
		if `rc' {
			di as err "{p}option {bf:mcmcsize()} must contain "
			di as err "a positive integer{p_end}"
			exit `rc'
		}
	}
	else {
		local mcmcsize 10000
	}

	// check thinning()
	if (`"`thinning'"'!="") {
		local max = floor(`mcmcsize'/2)
		if (`max'<=0) {
			di as err "MCMC sample size must be larger " ///
				  "to use {bf:thinning()}"
			exit 198
		}
		cap confirm integer number `thinning'
		local rc = _rc
		if (!`rc') {
			if (`thinning'<=0) {
				local rc 198
			}
		}
		if `rc' {
			di as err "{p}option {bf:thinning()} must contain "
			di as err "a positive integer{p_end}"
			exit `rc'
		}
		_bayesmh_note_skip "`=(`thinning'-1)'" "`mcmcsize'" "storing"
	}
	else {
		local thinning 1
	}

	// check scale()
	if (`"`scale'"'!="") {
		_check_number `scale' "" 0 "." "<" ">" scale()
	}
	else {
		local scale 2.38
	}

	// check summary options common to bayesstats summary
	local summopts batch(`batch') `clevel' level(`level') `hpd' 
	local summopts `summopts' corrlag(`corrlag') corrtol(`corrtol')
	local summopts `summopts' mcmcsize(`mcmcsize')"'
	_bayesmh_summaryopts `"`summopts'"'
	local clevel "`s(clevel)'"
	local hpd    "`s(hpd)'"
	if (`"`batch'"'!="") {
		local batch  "`s(batch)'"
	}
	else {
		local corrlag "`s(corrlag)'"
		local corrtol "`s(corrtol)'"
		// update maximum correlation lag based on specified MCMC size
		qui _bayesmh_chk_corrlag corrlag : `corrlag' `mcmcsize' nonote
	}

	// check search(); builds s(repeat)
	_check_search, `search'
	local repeat "`s(repeat)'"

	// check dots and dots()
	if (`"`dots'"'!="" & "`dots1'"!="") {
		di as err "only one of {bf:dots} or {bf:dots()} is allowed"
		exit 198
	}
	if (`"`dots1'`dots'"'=="") {
		local dots 0
		local dotsevery 0
	}
	else if ("`dots'"!="") {
		local dots 100
		local dotsevery 1000
	}
	else {
		_check_dots `dots1'
		local dots `s(dots)'
		local dotsevery `s(dotsevery)'
	}


	// check adaptation(); builds s(adaptation)
	_check_adaptation, `adaptation' 	///
			   mcmcsize(`mcmcsize') ///
			   burnin(`burnin') thinning(`thinning')

	// store results
	local simopts `simopts' burnin(`burnin') mcmcsize(`mcmcsize') 
	local simopts `simopts' thinning(`thinning') scale(`scale') 
	local simopts `simopts' corrtol(`corrtol') corrlag(`corrlag') 
	local simopts `simopts' batch(`batch') clevel(`clevel') dots(`dots') 
	local simopts `simopts' dotsevery(`dotsevery')
	local simopts `simopts' search(`search') searchrepeat(`repeat')
	sret local simoptions `"`simopts'"'
end

program _check_dots, sclass
	syntax [anything(name=dots)] [, every(string) * ]
	if (`"`options'"'!="") {
		di as err "suboption {bf:`options'} is not allowed in " ///
			  "option {bf:dots()}"
		exit 198
	}
	if (`"`dots'"'!="") {
		_check_number `dots' "integer" 0 "." "<" ">" dots()
	}
	else {
		local dots 1
	}
	if (`"`every'"'!="") {
		_check_number `every' "integer" 0 "." "<" ">" "dots(, every())"
	}
	else {
		local every 0
	}
	sret local dots `dots'
	sret local dotsevery `every'
end

program _check_search, sclass
	syntax [, ON OFF REPEAT(string) * ]
	if (`"`options'"'!="") {
		di as err "suboption {bf:`options'} is not allowed in " ///
			  "option {bf:search()}"
		exit 198
	}
	if (`"`repeat'"'!="") {
		_check_number `repeat' "integer" 0 "." "<" ">" search(repeat())
	}
	else {
		local repeat 500
	}
	if ("`off'"!="") {
		local repeat 0
	}
	sret local repeat "`repeat'"
end

program _check_adaptation, sclass
	syntax [,			///
		EVERY(string)		///
		MINITER(string)		///
		MAXITER(string)		///
		ALPHA(string)	  	///
		BETA(string)		///
		GAMMA(string)		///
		TARATE(string)		/// 
		TOLerance(string)	///
		EPSilon(string)		/// //undocumented
		MCMCSize(string)	/// //internal
		BURNin(string)		/// //internal
		THINning(string)	/// //internal
		*			///
	]
	if (`"`options'"'!="") {
		di as err "suboption {bf:`options'} is not allowed in " ///
			  "option {bf:adaptation()}"
		exit 198
	}
	local mcmctotal = `burnin'+(`mcmcsize'-1)*`thinning'+1
	// check every()
	if (`"`every'"'!="") {
		_check_number `every' "integer" 0 "`mcmctotal'" "<" ">" ///
			adaptation(every())
		local userevery `every'
	}
	else {
		local every 100
	}
	// check maxiter()
	if (`"`maxiter'"'!="") {
		_check_number `maxiter' "integer" 0 "." "<" ">" ///
			adaptation(maxiter())
		local usermaxiter `maxiter'
	}
	else {
		local maxiter 25
	}
	// check miniter()
	if (`"`miniter'"'!="") {
		if ("`usermaxiter'"!="") {
			local maxsize = `maxiter'
		}
		else {
			local maxsize .
		}
		_check_number `miniter' "integer" 0 "`maxsize'" "<" ">" ///
			adaptation(miniter())
		local userminiter `miniter'
	}
	else {
		local miniter 5
	}
	// check alpha()
	if (`"`alpha'"'!="") {
		_check_number `alpha' "" 0 1 "<" ">" adaptation(alpha())
	}
	else {
		local alpha 0.75
	}
	// check beta()
	if (`"`beta'"'!="") {
		_check_number `beta' "" 0 1 "<" ">" adaptation(beta())
	}
	else {
		local beta 0.8
	}
	// check gamma()
	if (`"`gamma'"'!="") {
		_check_number `gamma' "" 0 1 "<" ">" adaptation(gamma())
	}
	else {
		local gamma 0
	}
	// check tarate()
	if (`"`tarate'"'!="") {
		_check_number `tarate' "" 0 1 "<=" ">=" adaptation(tarate())
	}
	else {
		local tarate 0
	}
	// check tolerance()
	if (`"`tolerance'"'!="") {
		_check_number `tolerance' "" 0 1 "<=" ">=" ///
			adaptation(tolerance())
	}
	else {
		local tolerance 0.01
	}
	// check epsilon()
	if (`"`epsilon'"'!="") {
		_check_number `epsilon' "" 0 "." "<" ">" adaptation(epsilon())
		local beta 0 //reset beta() to be zero
	}
	else {
		local epsilon 0
	}

	// update default values based on specified mcmcsize() and burnin()
	if `"`userevery'"' == "" {
		if `maxiter' > 0 {
			if `every' > `mcmctotal' {
				local every `mcmctotal'
				di as txt ///
		"note: option {bf:adaptation(every())} changed to `mcmctotal'"
			}
		}
	}
	if `"`usermaxiter'"' == "" {
		if `every' > 0 {
			local maxiter = max(`maxiter',floor(`burnin'/`every'))
		}	
	}
	local maxitersize = floor((`mcmctotal')/`every')
	if `maxiter' > `maxitersize' {
		local maxiter `maxitersize'
		di as txt "note: option {bf:adaptation(maxiter())} changed " ///
			"to `maxitersize'"
	}
	if `"`userminiter'"' == "" {
		local miniter = min(`miniter',`maxiter')
	}

	// store results
	local adaptopts every(`every') maxiter(`maxiter') miniter(`miniter')
	local adaptopts `adaptopts' alpha(`alpha') beta(`beta') gamma(`gamma') 
	local adaptopts `adaptopts' tarate(`tarate') tolerance(`tolerance')
	local adaptopts `adaptopts' epsilon(`epsilon')
	sret local adaptation `"`adaptopts'"'
end

program _check_number
	args number integer min max leq geq optname

	cap confirm `integer' number `number'
	if ("`integer'"!="") {
		local numborint integer
		local dinumber an integer
	}
	else {
		local numborint number
		local dinumber a number
	}
	if ("`max'"=="." & `min'==0) {
		if ("`leq'"=="<") {
			local dinumber a nonnegative `numborint'
		}
		else {
			local dinumber a positive `numborint'
		}
	}
	else if ("`max'"=="." & `min'!=0) {
		if ("`leq'"=="<") {
			local dinumber `dinumber' greater than or equal to `min'
		}
		else {
			local dinumber `dinumber' greater than `min'
		}
	}
	else if ("`max'"=="`min'") {
		local dinumber `dinumber' equal to `min'
	}
	else {
		if ("`leq'"=="<" & "`geq'"==">") {
			local dinumber `dinumber' between `min' and `max'
			local dinumber `dinumber' inclusive
		}
		else if ("`leq'"=="<" & "`geq'"==">=") {
			local dinumber `dinumber' between `min' (inclusive) 
			local dinumber `dinumber' and `max'
		}
		else if ("`leq'"=="<=" & "`geq'"==">") {
			local dinumber `dinumber' between `min'
			local dinumber `dinumber' and `max' (inclusive)
		}
		else {
			local dinumber `dinumber' between `min' and `max'
		}
		
	}
	local rc = _rc
	if (!`rc') {
		if (`number'`leq'`min' | `number'`geq'`max') {
			local rc 198
		}
	}
	if `rc' {
		di as err "{p}option {bf:`optname'} must contain"
		di as err "`dinumber'{p_end}"
		exit `rc'
	}
end
