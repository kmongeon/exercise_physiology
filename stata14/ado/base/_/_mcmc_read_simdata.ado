*! version 1.0.6  22aug2016
program _mcmc_read_simdata, sclass
	version 14.0

	syntax , MCMCOBJECT(string)                            /// 
		[THETAS(string) USING(string) EVERY(integer 1) ///
		 NORESTore NOBASELEVELS]

	if `"`thetas'"' == "" {
		di as err `"parameter not found"'
		exit 198
	}

	mata: `mcmcobject' = _c_mcmc_model()

	if `"`using'"' == "" {
		local using `"`e(filename)'"'
	}

	if `"`using'"' == "" {
		di as err `"last estimates not found"'
		exit 301
	}

	local simfileerr "{p}specified file {bf:`using'} does not contain "
	local simfileerr `simfileerr' "proper simulation results as produced "
	local simfileerr `simfileerr' "by {bf:bayesmh, saving()}{p_end}"
	
	local allthetas `"`thetas'"'
	local readnames
	local checknames

	if `"`e(cmd)'"' == "bayesmh" {
		mata: `mcmcobject'.m_varNames  = tokens(`"`e(indepvars)'"')
		mata: `mcmcobject'.m_varLabels = tokens(`"`e(indeplabels)'"')

		mata: `mcmcobject'.m_postVarNames = tokens(`"`e(postvars)'"')
		mata: st_local("checknames", ///
			invtokens(`mcmcobject'.form_simdata_colnames()))

		mata: `mcmcobject'.m_parNames = tokens(`"`e(parnames)'"')
		mata: st_local("varlabels", `"`e(parnames)'"')

		mata: `mcmcobject'.m_parEquMap = tokens(`"`e(pareqmap)'"')

		mata: `mcmcobject'.set_par_names(	///
			tokens(`"`e(scparams)'"'),	///
			tokens(`"`e(omitscparams)'"'),	///
			tokens(`"`e(matparams)'"'),	///
			tokens(`"`e(latparams)'"'))
		mata:  st_local("readnames",	///
			`mcmcobject'.postvar_getparnames(`"`allthetas'"'))
		local readnames _index _loglikelihood _logposterior ///
			`readnames'  _frequency
		local readnames = subinstr(`"`readnames'"', "  ", " ", .)
	}

	if `"`using'"' != "" {
		capture quietly describe using `"`using'"'
		if (_rc == 0) {
			local postdata `"`using'"'
			local using
		}
		else {
			gettoken postdata using : using
		}
	}
	while `"`postdata'"' != "" {

	if `"`postdata'"' != ""  & "`norestore'" == "" {
		preserve
	}
	if `"`readnames'"' != "" {
		capture use `readnames' using `"`postdata'"', clear
	}
	else {
		capture use `"`postdata'"', clear
		local readnames `checknames'
	}
	if _rc {
		di as err `"file {bf:`postdata'} not found"'
		exit _rc
	}
	cap confirm numeric var _index _loglikelihood _logposterior _frequency
	if _rc {
		di as err `"`simfileerr'"'
		exit 301
	}
	qui summarize _frequency, meanonly
	if `r(N)' == 0 {
		di as err `"`simfileerr'"'
		exit 301
	}
	if `every' != floor(`every') | `every' < 1 | `every' > `r(sum)' {
		di as err "option {bf:every()} must contain an integer " ///
			"between 1 and `r(sum)'"'
		exit 198
	}

	if `every' > 1 {
		mata: resize_mcmc_index(`every')
	}

	if `"`e(cmd)'"' == "bayesmh" {
		quietly ds
		// simple model check: are readnames and e(parnames) the same? 
		if `"`readnames'"' != `"`r(varlist)'"' {
			di as err `"`simfileerr'"'
			exit 301
		}
	}
	else {
		quietly ds
		local varlist   `r(varlist)'
		local varnames  `varlist'
		local varlabels `varlist'
		mata: `mcmcobject'.m_postVarNames = tokens(`"`varlist'"')
		mata: `mcmcobject'.m_parNames	  = tokens(`"`varlist'"')
		mata: `mcmcobject'.m_parEquMap	  = tokens(`"`varlist'"')
		mata: `mcmcobject'.set_par_names( ///
			tokens(`"`varlist'"'), J(1,0,""), J(1,0,""), J(1,0,""))
	}

	local numpars 0
	local parnames
	local varnames 
	local tempnames
	local rowsep
	local exprlegend
	local parrequest
	
	local thetas `"`allthetas'"'
	gettoken tok thetas: thetas, match(paren) bind
	while `"`tok'"' != "" {
		tempvar v
		local `++numpars'
		// Stata expression 
		if "`paren'" == "(" {		
			gettoken vname tok: tok, parse(":{") bind 
			gettoken `v': tok, parse(":") bind 
			if `"`vname'"' != "" & `"`vname'"' != "{" & ///
			`"``v''"' == ":" {
				capture confirm names `vname'
				if _rc {
					di as err "{bf:`vname'} invalid name"
					exit 7
				}
				tokenize `vname'
				if `"`1'"' != `"`vname'"' {
					di as err "{bf:`vname'} invalid name"
					exit 7
				}
				// remove : 
				gettoken `v' tok: tok, parse(":") bind 
				local exprlegend ///
					`"`exprlegend' (`vname'):(`tok')"'
			}
			else {
				local tok `vname'`tok' 
				local vname expr`numpars'
				local exprlegend	///
					`"`exprlegend' (expr`numpars'):(`tok')"'
			}

			_mcmc_parse expand `tok'
			mata:  st_local("tok",	///
				`mcmcobject'.postvar_translate(`"`s(eqline)'"'))
			capture quietly generate double `v' = `tok'
			if _rc != 0 {
				_mcmc_diparams dieq : `"`s(eqline)'"'	
				di as err `"invalid expression {bf:`dieq'}"'
				exit _rc		
			}
			local tempnames `tempnames' `v'
			local varnames  `varnames'  `v'
			// allow multi-word names 
			if `"`parnames'"' == "" {
				local parnames `""`vname'""'
			}
			else {
				local parnames `"`parnames' "`vname'""'
			}
		}
		else {
			local n = bstrlen(`"`tok'"')
			if bsubstr(`"`tok'"',1,1) == "{" & `n' > 2 {
				if bsubstr(`"`tok'"',`n',.) == "}" {
					local n = `n' - 2
					local tok = bsubstr(`"`tok'"',2,`n')
				}
			}
			if "`nobaselevels'" != "" {
				mata: st_local("`v'",	///
					`mcmcobject'.postvar_lookup(`"`tok'"',1))
			}
			else {
				mata: st_local("`v'",	///
					`mcmcobject'.postvar_lookup(`"`tok'"',0))
			}
			if `"``v''"' == "" {
				_mcmc_paramnotfound `"`tok'"'
			}
			if `"``v''"' == "omitted" {
				local `v'
			}
			if `"``v''"' != "" {
				confirm variable ``v'', exact
				local varnames `varnames' ``v''
				if `"`parnames'"' == "" {
					local parnames `""`tok'""'
				}
				else {
					local parnames `"`parnames' "`tok'""'
				}
			}
			else {
				local parrequest `"`parrequest' `tok'"'
			}
		}
		local rowsep `rowsep' 0
		gettoken tok thetas: thetas, match(paren) bind
	}
	local parrequest `"`parrequest' `parnames'"'
	mata: `mcmcobject'.import_par_names("parnames", ///
		"varnames", "`nobaselevels'" != "")
	if `"`varnames'"' == "" {
		if "`nobaselevels'" != "" {
			_mcmc_paramnotfound `parrequest' baselevel
		}
		else {
			_mcmc_paramnotfound `parrequest'
		}
	}

	mata: st_view(__y=., ., invtokens(`mcmcobject'.form_simdata_colnames()))
	mata: `mcmcobject'.import_simdata(__y)
	mata: mata drop __y

	if `"`postdata'"' != "" & "`norestore'" == "" {
		restore
	}

	gettoken postdata using : using
	} // while `"`postdata'"' != ""

	sreturn local numpars    = `"`numpars'"'
	sreturn local varnames   = `"`varnames'"'
	sreturn local parnames   = `"`parnames'"'
	sreturn local tempnames  = `"`tempnames'"'
	sreturn local exprlegend = `"`exprlegend'"'
end
