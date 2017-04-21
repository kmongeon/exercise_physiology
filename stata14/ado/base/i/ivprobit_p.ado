*! version 2.0.2  16oct2015

program define ivprobit_p
	local vcaller = string(_caller())
	version 8

	syntax [anything] [if] [in] [, SCores * ]

	local version = cond(missing(e(version)),0,e(version))
	if `"`scores'"' != "" {
		if `"`e(method)'"' == "twostep" {
			di as err ///
			"option scores is not allowed with twostep results"
			exit 322
		}
		if `version' < 14.1 {
			global IV_NEND `e(endog_ct)'
			ml score `0'
			macro drop IV_*
			exit
		} 
		local kscores = e(k_eq)
		_stubstar2names `anything', nvars(`kscores')
		local scores `s(varlist)'
		local stype : word 1 of `s(typlist)'

		forvalues i=1/`kscores' {
			tempvar s`i'
			qui gen double `s`i'' = .
			local slist `slist' `s`i''
		}
		tempvar touse
		tempname b 

		marksample touse
		local depvar : word 1 of `e(depvar)'
		local kendog = `e(endog_ct)'
		mat `b' = e(b)
		mata: ivfprobit_mopt("`b'","`depvar'",`kendog',"`touse'", ///
			"","","","","","","nolog","",1,0,"`slist'")

		local eqs : coleq `b'
		local eqs : list uniq eqs

		forvalues i=1/`kscores' {
			local si : word `i' of `scores'
			local eq : word `i' of `eqs'
			gen `stype' `si' = `s`i'' if `touse'
			label variable `si' "Scores for equation `eq'"
		}
		exit
	}

		/* Step 1:
			place command-unique options in local myopts
			Note that standard options are
			LR:
				Index XB Cooksd Hat 
				REsiduals RSTAndard RSTUdent
				STDF STDP STDR noOFFset
			SE:
				Index XB STDP noOFFset
		*/

	local myopts Pr ASIF RULEs XB

		/* Step 2:
			call _propts, exit if done, 
			else collect what was returned.
		*/
			/* takes advantage that -myopts- produces error
			 * if -eq()- specified w/ other that xb and stdp */
	_pred_se "`myopts'" `0'
	if `s(done)' { 
		exit 
	}
	local vtyp  `s(typ)'
	local varn `s(varn)'
	local 0 `"`s(rest)'"'


		/* Step 3:
			Parse your syntax.
		*/

	syntax [if] [in] [, `myopts' ]
	
		/* Step 4 not needed here */

		/* Step 5:
			quickly process default case if you can 
		*/

	if "`pr'`asif'`rules'`xb'"=="" {
		di as text "(option xb assumed; fitted values)"
		local xb "xb"
	}
	if "`e(method)'" == "twostep"  & "`xb'" == "" {
		di as err "probabilities not available with two-step estimator"
		exit 198
	}	

	if "`xb'" != "" {
		_predict `vtyp' `varn' `if' `in' 
		label var `varn' "Fitted values"
		exit
	}
	
		/* Step 6:
			mark sample (this is not e(sample)).
		*/
	marksample touse



		/* Step 8:
			handle switch options that can be used in-sample or 
			out-of-sample one at a time.
			Be careful in coding that number of missing values
			created is shown.
			Do all intermediate calculations in double.
		*/

				/* Get the model index (Xb), 
				 * required for all remaining options */
	
	if `: word count `asif' `pr' `rules'' > 1 {
		 as error "only one of {bf:pr}, {bf:rules}, or " ///
		  "{bf:asif} may be specified"
		exit 198
	}
				 
	local depname `e(depvar)'
	tempvar Xb
	qui _predict double `Xb' if `touse' ,xb
	if `vcaller' > 14.0 {
		ivadjust_xb `Xb', touse(`touse')
	}

	if "`asif'" != "" {		/* Just return norm(xb), no rules */
		gen `vtyp' `varn' =  norm(`Xb') if `touse'
		if `vcaller' <= 14.0 {
        		label var `varn' "Prob of positive outcome when corr=0"   
		}
		else {
			label var `varn' "Probability of positive outcome"
		}
		exit
	}
	
        tempname rulmat j
        mat `rulmat' = e(rules)
	local names : rownames(`rulmat')
	local rows = rowsof(`rulmat')
	gen `vtyp' `varn' = norm(`Xb') if `touse'
	if `vcaller' <= 14.0 {
        	label var `varn' "Prob of positive outcome when rho=0"   
	}
	else {
		label var `varn' "Probability of positive outcome"
	}
	if (`rulmat'[1,1] == 0 & `rulmat'[1,2] == 0 & ///
		`rulmat'[1,3] == 0 & `rulmat'[1,4] == 0) {
		/* No rules to apply; exit */
		exit
	}

	if "`rules'" != "" {
		forvalues i = 1/`rows' {
			if `rulmat'[`i',1] == 4 {
				continue
			}
			local v : word `i' of `names'
			sca `j' = `rulmat'[`i', 2]
			if `rulmat'[`i', 3] == 0 {
				qui replace `varn' = 0 if `v' != `j' & `touse'
			}
			if `rulmat'[`i', 3] == 1 {
				qui replace `varn' = 1 if `v' != `j' & `touse'
			}
			if `rulmat'[`i', 3] == -1 {
				if `rulmat'[`i', 1] == 2 {
					qui replace `varn' = 1 ///
						if `v' > `j' & `touse'
					qui replace `varn' = 0 ///
						if `v' < `j' & `touse'
				}
				else {
					qui replace `varn' = 1 ///
						if `v' < `j' & `touse'
					qui replace `varn' = 0 ///
						if `v' > `j' & `touse'
				}
			}
		}
		exit
	}
	
	if "`pr'" != "" {
		/* Go through and set to missing if rules omitted obs.*/
		forvalues i = 1/`rows' {
			if `rulmat'[`i',1] == 4 {
				continue
			}	
			local v : word `i' of `names'
			sca `j' = `rulmat'[`i', 2]
			if `rulmat'[`i', 3] == 0 | `rulmat'[`i', 3] == 1 | /*
				*/ `rulmat'[`i', 3] == -1 {
				qui count if `v' != `j' & `touse'
				loc n = r(N)
				loc s "s"
				if `n' == 1 {
					loc s ""
				}
				qui replace `varn' = . if `v' != `j' & `touse'
				di "(`n' missing value`s' generated)"
			}
		}
		exit
	}

			/* Step 10.
				Issue r(198), syntax error.
				The user specified more than one option
			*/
	error 198
end

exit

