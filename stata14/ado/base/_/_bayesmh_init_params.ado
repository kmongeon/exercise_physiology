*! version 1.0.4  10mar2016
program _bayesmh_init_params
	version 14.0

	args mcmcobject initial optional

	_mcmc_parse expand `initial'
	local initial `s(eqline)'

	while `"`initial'"' != "" {
		local 1
		gettoken param initial : initial, bind

		while regexm(`"`param'"', "^{.+}") {
			if !regexm(`"`param'"', "^{.+}$") {
				di as err "invalid initial parameter " ///
					`"{bf:`param'} in option "' ///
					"{bf:initial()}" 
				exit 198
			}
			local 1 `"`1' `param'"'
			gettoken param initial : initial, bind
		}

		if `"`1'"' == "" {
			di as err "invalid {bf:initial()} specification"
			exit 198
		}

		local 2 `param'

		local ismat 0
		capture confirm number `2'
		if _rc {
			capture confirm matrix `2'
			local ismat = !_rc
		}
		if _rc {
			tempname tmat
			capture matrix `tmat' = `2'
			local 2 `tmat'
			local ismat = !_rc
		}
		if _rc {
			di as err "invalid initial for {bf:`1'}"
			exit 480
		}
		local ival `2'
		if `ismat' {
			mata: mcov = st_matrix("`ival'")
			gettoken param 1 : 1
			while `"`param'"' != "" {
				_mcmc_parse word `param'
				if `"`s(word)'"' == "" & !`optional' {
					di as err "parameter {bf:`param'} " ///
						"not found in {bf:initial()}"
					gettoken param 1 : 1
					continue
				}
				if "`s(prefix)'" != "." {
					local param `s(prefix)':`s(word)'
				}
				else local param `s(word)'
	
				if "`s(matval)'" != "1" & !`optional' {
					di as err `"parameter `param' "' ///
					   "not found in option {bf:initial()}"
					exit 480
				}
				if !issymmetric(`ival') {
					di as err `"matrix {bf:`ival'} " ///
						"must be symmetric"'
					exit 505
				}
				if $MCMC_debug {
					di `"init `param' -> `ival'"'
				}
	
				mata: `mcmcobject'.init_mpar(	///
					"`param'", mcov, `optional')
				mata: mata drop mcov

				gettoken param 1 : 1
			}
		}
		else {
			gettoken param 1 : 1
			while (`"`param'"' != "") {
				_mcmc_parse word `param'
				if `"`s(word)'"' == "" & !`optional' {
					di as err "parameter {bf:`param'} " ///
						"not found in {bf:initial()}"
					gettoken param 1 : 1
					continue
				}
				if "`s(prefix)'" != "." {
					local param `s(prefix)':`s(word)'
				}
				else local param `s(word)'
				if "`s(matval)'" == "1" & !`optional' {
					di as err `"parameter `param' "' ///
					   "not found in option {bf:initial()}"
					exit 480
				}
				if $MCMC_debug {
					di `"init `param' -> `ival'"'
				}
				if "`s(latval)'" == "1" {
					mata: `mcmcobject'.init_tvar(	///
						"`param'", `ival', `optional')
				}
				else {
					mata: `mcmcobject'.init_upar(	///
						"`param'", `ival', `optional')
				}
				gettoken param 1 : 1
			}
		}
	}
end
