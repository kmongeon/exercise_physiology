*! version 1.0.1  29jan2015
program power_cmd_twomeans_parse
	version 13

	syntax [anything] [, test * ]
	local type `test'
	_power_twomeans_`type'_parse `anything', `options'

end

program _power_twomeans_test_parse

	syntax [anything(name=args)]  , pssobj(string) 	///
				[	ONESIDed 	///
					NORMAL 		/// undoc.
					KNOWNSDs 	///
					* 		///
				]
	local 0 , `options' `onesided' `normal' `knownsds'

	if ("`knownsds'"!="") local normal normal

	mata: st_local("solvefor", `pssobj'.solvefor)

	//to check if iteration options are allowed
	local isiteropts 0
	if ("`solvefor'"=="n"|"`solvefor'"=="n1"|"`solvefor'"=="n2") {
		if ("`normal'"!="" & "`onesided'"!="") {
			local msg "sample sizes for a normal one-sided test"
		}
		else {
			local isiteropts 1
			local star init(string) *
		}
	}
	else if ("`solvefor'"=="esize") {
		if ("`normal'"!="" & "`onesided'"!="") {
			local msg "effect size for a normal one-sided test"
		}
		else {
			local isiteropts 1
			local star init(string) *
		}
	}
	else if ("`solvefor'"=="power") {
		local msg power
	}
	if (!`isiteropts') {
		_pss_error iteroptsnotallowed , ///
			`options' txt(when computing `msg')
	}

	_pss_syntax SYNOPTS : twotest  

	syntax [, 		`SYNOPTS' 	///
				diff(string)	///
				sd1(string)	///
				sd2(string)	///
				sd(string)	///
				KNOWNSDs	///
				NORMAL		/// undoc.
				welch		/// undoc.
				`star'		///
		]

	if (`isiteropts') {
		if (bsubstr("`solvefor'",1,1)=="n") local validate n

		_pss_chk_iteropts `validate', `options' init(`init') ///
			pssobj(`pssobj')
		_pss_error optnotallowed `"`s(options)'"'
	}

	gettoken arg1 args : args, match(par)
	gettoken arg2 args : args, match(par)
	local nargs 0
	if `"`arg1'"'!="" {
		cap numlist `"`arg1'"'
		if (_rc) {
			di as err "means must contain numbers"
			exit 198
		}
		local a1list `r(numlist)'
		local ka1 : list sizeof a1list

		local ++nargs
	}
	if `"`arg2'"'!="" {
		cap numlist `"`arg2'"'
		if (_rc) {
			di as err "means must contain numbers"
			exit 198
		}
		local a2list `r(numlist)'
		local ka2 : list sizeof a2list

		local ++nargs

		if `ka1'==1 & `ka2'==1 {
			if reldif(`a1list',`a2list')<1e-10 {
				di as err "{p}the control-group mean and " ///
				 "the experimental-group mean are equal; " ///
				 "this is not allowed{p_end}"
				exit 198
			} 
		}
	}
	if `"`args'"'!="" {
		local ++nargs
	}

	// check arguments and diff()
	if (`"`diff'"'=="") {
		_pss_error argstwotest  "`nargs'" "`solvefor'" 	///
					"twomeans" "mean"

		if "`init'"!="" & "`solvefor'"=="esize" & `ka1'==1 {
			_pss_chk_init "control-group mean" "`init'" 	///
				"`a1list'" "`direction'"
		}
	}
	else {
		if (`nargs'> 2) {
			_pss_error argstwotest "`nargs'" "`solvefor'"  ///
					       "twomeans" "mean"
		}
		else if ("`solvefor'"=="esize") {
			di as err "option {bf:diff()} is not allowed with " ///
			 "effect-size determination"
			exit 184
		}
		else if (`nargs'> 1) {
			di as err "{p}only one of experimental-group mean " ///
				  "or option {bf:diff()} is allowed {p_end}"
			exit 198
		}
		else if (`nargs'==0) {
		    di as err "{p}control-group mean must be specified{p_end}"
		    exit 198
		}
		cap numlist `"`diff'"'
		if (_rc) {
			di as err "{bf:diff()} must contain numbers"
			exit 198
		}
		local mlist `r(numlist)'
		local k : list sizeof mlist
		if `k' == 1 {
			if abs(`mlist') < 1e-10 {
				di as err "{p}invalid {bf:diff(`mlist')}: " ///
				 "zero is not allowed{p_end}"
				exit 198
			}
		}
	}
	
	// check sd1() sd2() and sd()
	if (`"`sd'"'!="") {
		if (`"`sd1'"'!="" | `"`sd2'"'!="") {
			di as err "{p}{bf:sd()} is not allowed in a "	///
			"combination with {bf:sd1()} or {bf:sd2()}{p_end}"
			exit 198
		}
		if (`"`welch'"'!="") {
			di as err "{p}{bf:sd()} may not be combined with " ///
			 "{bf:welch}{p_end}"
			exit 198
		}
		cap numlist `"`sd'"', range(>0)
		if (_rc) {
			di as err "{bf:sd()} must contain positive numbers"
			exit 198
		}
	}
	else if (`"`sd1'`sd2'"'!="") {
		if (`"`sd1'"'!="") {
			if (`"`sd2'"'=="") {
				di as err "{p}{bf:sd2()} must be " ///
				 "specified with {bf:sd1()}{p_end}"
				exit 198 
			}	

			cap numlist `"`sd1'"', range(>0)
			if (_rc) {
				di as err "{bf:sd1()} must contain " ///
				 "positive numbers"
				exit 198
			}	
		}
		if (`"`sd2'"'!="") {
			if (`"`sd1'"'=="") {
				di as err "{p}{bf:sd1()} must be " ///
				 "specified with {bf:sd2()}{p_end}"
				exit 198 
			}

			cap numlist `"`sd2'"', range(>0)
			if (_rc) {
				di as err "{bf:sd2()} must contain " ///
				 "positive numbers"
				exit 198
			}
		}
	}
	else {
		if (`"`welch'"'!="") {
			di as err "{p}both {bf:sd1()} and {bf:sd2()} are " ///
			 "needed when {bf:welch} is specified{p_end}"
			exit 198

		}
	}

	// check normal welch and unequal
	if (`"`normal'"'!="") {
		if (`"`welch'"'!="") {
			di as err "{p}{bf:normal} may not be combined " ///
			 "with {bf:welch}{p_end}"
			exit 184
		}
	}

	if (`"`knownsds'"'!="") {
		if (`"`welch'"'!="") {
			di as err "{p}{bf:knownsds} may not be combined " ///
			 "with {bf:welch}{p_end}"
			exit 184
		}
	}
	mata: `pssobj'.initonparse("`diff'","`sd1'`sd2'","`knownsds'",	///
				   "`normal'","`welch'")
end