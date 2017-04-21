*! version 1.1.0  20feb2015
program _pss_chk_testmainopts
	version 13

	args msolvefor mpower mbeta malpha mN mN1 mN2 mnratio mside ///
	     mdirection rest mnumopts colon 0

	syntax [, pssobj(string) 		///
		  Alpha(string) 		///
		  Power(string) 		///
		  Beta(string) 			///
		  n(string)			///
		  ONESIDed 			///
		  DIRection(string)		///
		  NOTItle			///
		  compute(string)		/// //two-sample options
		  n1(string)			///
		  n2(string)			/// 
		  NRATio(string)		///
		  NFRACtional 			///
		  graph				/// //internal
		  * 				///
		]

	if ("`pssobj'"!="") {
		mata: st_local("twosample", strofreal(`pssobj'.twosample))
		mata: st_local("multisample",strofreal(`pssobj'.multisample))
		if (`twosample') {
			local twosampopts `", "`nratio'""'
		}
		if (`multisample') {
			local 0, `options'
			syntax, [ NPERGroup(string) NPERCell(string) ///
				NPERSTRatum(string) * ]
			local npg `npergroup'`npercell' `nperstratum'
		}
		mata: `pssobj'.getusertype("user")
	}
	else {
		local twosample 0
		local multisample 0
	}
	if (!`twosample') {
		if (`"`compute'"'!="") {
			di as err "option {bf:compute()} not allowed"
			usererr1 "`user'"
			exit 198
		}
		c_local `mN1' ""
		c_local `mN2' ""
		if (!`multisample') {
			if (`"`n1'"'!="") {
				di as err "option {bf:n1()} not allowed"
				usererr1 "`user'"
				exit 198
			}
			if (`"`n2'"'!="") {
				di as err "option {bf:n2()} not allowed"
				exit 198
			}
			if (`"`nratio'"'!="") {
				di as err "option {bf:nratio()} not allowed"
				exit 198
			}
			c_local `mnratio' ""
		}
	}
	// other options
	c_local `rest' `options'

	// determine what to compute
	if (`"`compute'"'!="") { // two-sample case only
		if (`"`n'"'!="") {
			di as err "{bf:n()} cannot be combined with " ///
			 "{bf:compute()}"
			exit 198
		}
		if (`"`n1'"'!="" & `"`n2'"'!="") {
			di as err "{bf:compute()} cannot be combined with " ///
				  "{bf:n1()} and {bf:n2()}"
			exit 198
		}
		if (`"`nratio'"'!="") {
			di as err "{bf:nratio()} cannot be combined with " ///
				  "{bf:compute()}"
			exit 198
		}
		if (`"`compute'"'=="n1") {
			if (`"`n1'"'!="") {
				di as err "{p}{bf:n1()} cannot be combined " ///
				"with {bf:compute(n1)}{p_end}"
				exit 198
			}
			if (`"`n2'"'=="") {
				di as err "{bf:compute(n1)} requires that " ///
				 "you specify {bf:n2()}"
				exit 198
			}
			local solvefor n1
		}
		else if (`"`compute'"'=="n2") {
			if (`"`n2'"'!="") {
				di as err "{bf:n2()} cannot be combined " ///
				 "with {bf:compute(n2)}"
				exit 198
			}
			if (`"`n1'"'=="") {
				di as err "{bf:compute(n2)} requires that " ///
				 "you specify {bf:n1()}"
				exit 198
			}
			local solvefor n2
		}
		else {
			di as err "{bf:compute()}: invalid specification " ///
				  `"`compute'"'
			exit 198
		}
	}
	else if (`"`n'`n1'`n2'`npg'"'=="") {
		local solvefor n
	}
	else if (`"`power'`beta'"'=="") {
		local solvefor power
	}
	else if (`"`n'`n1'`n2'`npg'"'!="" & `"`power'`beta'"'!="") {
		local solvefor esize
	}
	if (`"`pssobj'"'!="") {
		mata: `pssobj'.st_setbeta()
	}
	c_local `msolvefor' `solvefor'


	// alpha()
	_pss_chk01opts alpha : "alpha" `"`alpha'"'
	if ("`alpha'"=="") {
		local alpha 0.05
	}
	c_local `malpha' `alpha'
	local numopts alpha

	// power(), beta()
	if (`"`power'`beta'"'=="" & "`solvefor'"!="power") {
		local power 0.8
		c_local `mpower' `power'
	}
	else if (`"`power'"'!="" & `"`beta'"'!="") {
		di as err "{bf:power()} and {bf:beta()} may not be combined"
		exit 198
	}
	else if (`"`beta'"'!="") {
		_pss_chk01opts beta : "beta" `"`beta'"'
		c_local `mbeta' `beta'
		local numopts `numopts' beta
	}
	else if ("`solvefor'"!="power") {
		_pss_chk01opts power : "power" `"`power'"'
		c_local `mpower' `power'
	}
	if ("`solvefor'"!="power" & "`power'"!="") {
		local numopts `numopts' power
	}

	/* multisample has more than 2 levels				*/
	if (!`multisample') {
		// n(), n1(), n2(), nratio()	
		if (`"`n'"'!="" & `"`n1'"'!="" & `"`n2'"'!="") {
			di as err ///
"{bf:n()}, {bf:n1()}, and {bf:n2()} may not be combined"
			exit 198
		}
		if (`"`nratio'"'!="" & `"`n1'"'!="" & `"`n2'"'!="") {
			di as err ///
"{bf:nratio()}, {bf:n1()}, and {bf:n2()} may not be combined"
			exit 198
		}
		if (`"`n'"'!="" & `"`n1'"'!="" & `"`nratio'"'!="") {
			di as err ///
"{bf:n()}, {bf:n1()}, and {bf:nratio()} may not be combined"
			exit 198
		}
		if (`"`n'"'!="" & `"`n2'"'!="" & `"`nratio'"'!="") {
			di as err ///
"{bf:n()}, {bf:n2()}, and {bf:nratio()} may not be combined"
			exit 198
		}
	}
	_pss_chkposintopts n : "n" `"`n'"'
	c_local `mN' `n'
	local kn = 0
	local kn1 = 0
	local kn2 = 0
	if ("`n'"!="") {
		local nlist `n'
		local kn : list sizeof nlist
		local numopts `numopts' n
	}
	if (`"`n1'"'!="") {
		_pss_chkposintopts n1 : "n1" `"`n1'"'
		local n1list `n1'
		local kn1 : list sizeof n1list
		local numopts `numopts' n1
		c_local `mN1' `n1'
	}
	if (`"`n2'"'!="") {
		_pss_chkposintopts n2 : "n2" `"`n2'"'
		local n2list `n2'
		local kn2 : list sizeof n2list
		local numopts `numopts' n2
		c_local `mN2' `n2'
	}
	if `kn' == 1 {
		if `kn1' == 1 {
			if `n1list' >= `nlist' {
				di as err "{p}{bf:n1(`n1list')} must be " ///
				 "less than {bf:n(`nlist')}{p_end}"
				exit 198
			}
		}
		else if `kn1' > 1 {
			cap numlist "`n1list'", range(>0 <`nlist')
			local rc = c(rc)
			if `rc' {
				di as err "{p}values of {bf:n1()} must " ///
				 "be less than {bf:n(`nlist')}{p_end}"
				exit `rc'
			}
		}
		if `kn2' == 1 {
			if `n2list' >= `nlist' {
				di as err "{p}{bf:n2(`n2list')} must be " ///
				 "less than {bf:n(`nlist')}{p_end}"
				exit 198
			}
		}
		else if `kn2' > 1 {
			cap numlist "`n2list'", range(>0 <`nlist')
			local rc = c(rc)
			if `rc' {
				di as err "{p}values of {bf:n2()} must " ///
				 "be less than {bf:n(`nlist')}{p_end}"
				exit `rc'
			}
		}
	}
	if (!`multisample' & `"`nratio'"'!="") {	
		_pss_chkg0opts nratio : "nratio" `"`nratio'"'
		local numopts `numopts' nratio
		c_local `mnratio' `nratio'
	}
	// nfractional
	if (!`twosample' & !`multisample') {
		if ("`nfractional'"!="" & "`solvefor'"!="n") {
			di as err "{p}option {bf:nfractional} is allowed "
			di as err "only with sample-size determination for "
			di as err "one-sample and paired tests{p_end}"
			exit 198
		}
	}

	// onesided
	c_local `mside' `onesided'

	// direction()
	if ("`solvefor'"=="esize") {
		if (`"`direction'"'=="") {
			mata:`pssobj'.getsdefdir("defdir")
			if (`defdir'==1) {
				c_local `mdirection' "upper"
				local direction "upper"
			}	
			else if (`defdir'==0 ) {
				c_local `mdirection' "lower"
				local direction "lower"
			}	
		}
		else {
			_pss_chk_direction direction : `", `direction'"'
			c_local `mdirection' "`direction'"
		}
	}
	else if (`"`direction'"'!="") {
		di as err "{p}option {bf:direction()} is allowed only " ///
			  "for effect-size determination{p_end}"
		exit 198
	}
	
	// numlist options
	c_local `mnumopts' `numopts'

	// set main options
	if (`"`pssobj'"'!="") {
		mata: `pssobj'.setmainopts("`solvefor'",	///
					   "`onesided'",	///
					   "`direction'",	///
					   "`summary'",		///
					   "`notitle'",		///
					   "`nfractional'",	///
					   "`graph'"`twosampopts')
	}
end

program usererr1
	args user

	if ("`user'"=="") exit

	di as err "{p}To allow this option with user-defined power methods, "
	di as err "you must specify {bf:twosample} with {bf:power}."
end

program _pss_chk01opts
	args vals colon optname optvals

	if (`"`optvals'"'=="") exit

	cap numlist `"`optvals'"', range(>0 <1)
	if (_rc==123) {
		cap noi numlist `"`optvals'"', range(>0)
		di as err "in option {bf:`optname'()}"
		exit 123
	}
	if (_rc) {
		di as err ///
"{bf:`optname'()} must contain numbers between 0 and 1"
		exit 121
	}
	c_local `vals' `r(numlist)'
end

program _pss_chkposintopts
	args vals colon optname optvals

	if (`"`optvals'"'=="") exit

	cap numlist `"`optvals'"', range(>0) integer
	if (_rc==123) {
		cap noi numlist `"`optvals'"', range(>0)
		di as err "in option {bf:`optname'()}"
		exit 123
	}
	if (_rc) {
		di as err ///
"{bf:`optname'()} must contain positive integers"
		exit 121
	}
	c_local `vals' `r(numlist)'
end

program _pss_chkg0opts
	args vals colon optname optvals

	if (`"`optvals'"'=="") exit

	cap numlist `"`optvals'"', range(>0)
	if (_rc==123) {
		cap noi numlist `"`optvals'"', range(>0)
		di as err "in option {bf:`optname'()}"
		exit 123
	}
	if (_rc) {
		di as err ///
"{bf:`optname'()} must contain positive numbers "
		exit 121
	}
	c_local `vals' `r(numlist)'
end

program _pss_chk_direction
	args direction colon 0

	cap syntax [, Upper Lower ]
	local rc = _rc
	if (!`rc') {
		cap opts_exclusive "`upper' `lower'"
		local rc = _rc
	}
	if (`rc') {
		di as err "{p}{bf:direction()} may include only one of "
		di as err "{bf:upper} or {bf:lower}{p_end}"
		exit `rc'
	}
	c_local `direction' "`upper'`lower'"
end
