*! version 1.0.1  11sep2013
program power_cmd_twoprop
	version 13

	syntax [anything] [, test * ]
	local type `test'
	pss_twoprop_`type' `anything', `options'
end

program pss_twoprop_test

	_pss_syntax SYNOPTS : twotest	
	syntax [anything] , 	pssobj(string) 	///
			   [ 	`SYNOPTS'	///
				test(string)	///
				diff(string)	///
				RDiff(string)	///
				ratio(string)	///
				RRisk(string)	///
				ORatio(string)	///
				effect(string)  ///
				CHI2		///	// undoc.
				FISHER		///	// undoc.
				LRCHI2		///	// undoc.
				CONTINuity	///
				*		///
			   ]

	gettoken arg1 anything : anything
	gettoken arg2 anything : anything

	if (`"`test'"'!="") {
		if (`"`test'"'=="lrchi2") local lrchi2 lrchi2
		else if (`"`test'"'=="fisher") local fisher fisher
		else if (`"`test'"'!="chi2") {
			di as err ///
			`"{p}{bf:test()}: invalid method {bf:`test'}{p_end}"'
			exit 198
		}
	}

	// handle effect
	if ("`arg1'"!="" & "`arg2'"!="") local nargs 2
	else if ("`arg1'"!="" & "`arg2'"=="") local nargs 1
	else local nargs 0
	_pss_twoprop_parseeffect effect : `"`effect'"' `nargs' ///
					  "`diff'" "`rdiff'"  ///
					  "`ratio'" "`rrisk'" "`oratio'"

	if ("`arg1'"=="") {
		local arg1 .
	}

	if ("`arg2'"=="") {
		local arg2 .
	}

	if ("`diff'"=="") {
		local diff .
	}

	if ("`rdiff'"=="") {
		local rdiff .
	}
	
	if ("`oratio'"=="") {
		local oratio .
	}
	
	if ("`rrisk'"=="") {
		local rrisk .
	}

	if ("`ratio'"=="") {
		local ratio .
	}
	local continuity = ("`continuity'"!="")

	mata:   `pssobj'.init(  `alpha', "`power'", "`beta'", 		///
				"`n'","`n1'","`n2'", "`nratio'", 	///
				`arg1', `arg2',	`diff', `rdiff', 	///
				`ratio', `rrisk' , `oratio', `continuity'); ///
		`pssobj'.compute();					///
		`pssobj'.rresults()
end
