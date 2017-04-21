*! version 1.0.0  14may2014
program power_cmd_logrank
	version 14

	syntax [anything] [, test * ]
	local type `test'
	pss_logrank_`type' `anything', `options'
end

program pss_logrank_test

	_pss_syntax SYNOPTS : twotest	
	syntax [anything] , 	pssobj(string) 	///
			   [ 	`SYNOPTS'	///
				HRatio(string)	///
				LNHRatio(string) ///
				SCHoenfeld 	///
				WDProb(string) 	///
				effect(string)  ///
				p1(string)	///	//undocumented
				*		///
			   ]
	gettoken arg1 anything : anything
	gettoken arg2 anything : anything
	
	if (`"`arg1'"'=="") {
		local arg1 .
	}
	if (`"`arg2'"'=="") {
		local arg2 .
	}
	if (`"`hratio'"'=="") {
		local hratio .
	}
	if (`"`lnhratio'"'=="") {
		local lnhratio .
	}
	if ("`p1'"=="") {
		local p1 .
	}
	if ("`wdprob'"=="") {
		local wdprob .
	}
	
	mata:   `pssobj'.init(  `alpha', "`power'", "`beta'", 		///
				"`n'", "`n1'", "`n2'", "`nratio'", 	///
				`arg1', `arg2',	`hratio', `lnhratio',	///
				`p1', `wdprob');			///
		`pssobj'.compute();					///
		`pssobj'.rresults()
end
