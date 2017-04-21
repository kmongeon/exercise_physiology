*! version 1.0.0  05jun2013
program power_cmd_twomeans
	version 13

	syntax [anything] [, test * ]
	local type `test'
	pss_twomeans_`type' `anything', `options'
end

program pss_twomeans_test

	_pss_syntax SYNOPTS : twotest	
	syntax [anything] , 	pssobj(string) 	///
			   [ 	`SYNOPTS'	///
				diff(string) 	///
				sd1(string)	///
				sd2(string)	///
				sd(string)	///
				KNOWNSDs	///
				NORMAL		/// //undoc.
				welch		/// //undoc.
				*		///
			   ]
	if ("`knownsds'"!="") local normal normal
	
	gettoken arg1 anything : anything
	gettoken arg2 anything : anything

	if ("`arg1'"=="") {
		local arg1 = .
	}
	if ("`diff'"=="") {
		local diff = .
	}
	if ("`arg2'"=="") {
		local arg2 = .
	}

	if ("`sd'"=="") {
		if ("`sd1'"=="" & "`sd2'"=="") {
			local sd 1
			local sd1 .
			local sd2 .
		}
		else local sd .	
	}
	else {
		local sd1 .
		local sd2 .
	}
		
	mata:   `pssobj'.init(  `alpha', "`power'", "`beta'", 		///
				"`n'","`n1'","`n2'", "`nratio'", 	///
				`arg1',`arg2',`diff',`sd',`sd1',`sd2'); ///
		`pssobj'.compute();					///
		`pssobj'.rresults()
end
