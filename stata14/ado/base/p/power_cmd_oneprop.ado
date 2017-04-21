*! version 1.0.2  20jan2015
program power_cmd_oneprop
	version 13

	syntax [anything] [, test * ]
	local type `test'
	pss_oneprop_`type' `anything', `options'
end

program pss_oneprop_test

	_pss_syntax SYNOPTS : onetest
	syntax [anything] , 	pssobj(string)			/// 
			    [ 	`SYNOPTS'			///
				test(string)			///
    				diff(string)			///
				BINOMial			/// undoc.
				WALD				/// undoc.
				SCORE	/// default, undoc.
				CRITVALues			///
				CONTINuity			///
    				*				/// 
			    ]
 
	gettoken arg1 anything : anything
	gettoken arg2 anything : anything
	
	if ("`arg2'"=="") local arg2 = .
	if ("`diff'"=="") local diff = .

	if (`"`test'"'!="") {
		local len = length(`"`test'"')
		if (`"`test'"'=="wald") local wald wald
		else if (`"`test'"'==bsubstr("binomial",1,`len') & `len'>4) {
			local binomial binomial
		}
	}
	local binomial = ("`binomial'"!="")
	local wald = ("`wald'"!="")
	local critvalues = ("`critvalues'"!="")
	local continuity = ("`continuity'"!="")

	mata:   `pssobj'.init( `alpha',"`power'","`beta'","`n'",	///
				`arg1',`arg2',`diff',`continuity');	///
		`pssobj'.compute();				     	///
		`pssobj'.rresults()
end
