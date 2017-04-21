*! version 1.0.1  28jan2016
program _bayes_block_opt, sclass
	version 14.0

	args gtouse blocks allreffects

	local simoptions
	local blocksline

	while `"`blocks'"' != "" {

		gettoken eqline blocks: blocks, parse("\ ()") match(paren)
		// parse data/params until the first option
		if `"`eqline'"' == "block" {
	 		local sampler
		 	gettoken eqline blocks : blocks, match(paren)
			// equations begin with (
		 	if "`paren'" != "(" {
				di as err "( is expected after block"
				exit _rc
		 	}

			_mcmc_scan_identmats `eqline'
			local eqline `s(eqline)'

			gettoken blpars blopts : eqline, parse(",") bindcurly
			local 0 `blopts'
			syntax [anything] [, REffects *]
			local blopts `reffects' `options'

		 	_mcmc_fv_decode `"`blpars'"' `gtouse'
		 	local eqline `s(outstr)'

			if `"`reffects'"' != "" {
				while regexm(`"`blpars'"', "{") {
					local blpars = ///
						regexr(`"`blpars'"', "{", "")
				}
				while regexm(`"`blpars'"', "}") {
					local blpars = ///
						regexr(`"`blpars'"', "}", "")
				}

				tokenize `blpars', parse(":")
				if `"`1'"' == "" | `"`2'"' != ":" | ///
					`"`4'"' != "" {
					di as err "only one "                      ///
			`"{bf:{c -(}}{it:depvar}{bf::i.}{it:varname}{bf:{c )-}} "' ///
			"specification is allowed within "                         ///
			"random-effects {bf:block()} option" 
					exit 198
				}

				tokenize `3', parse(".")
				if (`"`1'"' != "i" & `"`1'"' != "ibn") | ///
					`"`2'"' != "." {
					di as err "only one "                      ///
			`"{bf:{c -(}}{it:depvar}{bf::i.}{it:varname}{bf:{c )-}} "' ///
			"specification is allowed within "                         ///
			"random-effects {bf:block()} option" 
					exit 198
				}

				if `"`3'"' != "" & `"`4'"' == "" {
				capture confirm variable `3'
				if _rc {
					di as err `"{bf:`3'} must be a variable "' ///
					"in order to be used within "		   ///
					"random-effects {bf:block()} option" 
					exit 198
				}
				}
			}
			else {
				local blpars `eqline'
				while regexm(`"`blpars'"', "{") {
					local blpars = ///
						regexr(`"`blpars'"', "{", "")
				}
				while regexm(`"`blpars'"', "}") {
					local blpars = ///
						regexr(`"`blpars'"', "}", "")
				}
				// `allreffects' params not allowed in blocks
				local commonstr : list blpars & allreffects
				if `"`commonstr'"' != "" {
					di as err "random-effects parameters " ///
					`"{bf:`commonstr'} not allowed in "'   ///
					"{bf:block()} option" 
					exit 198
				}
			}

			if `"`blopts'"' != "" {	
				local eqline = `"`eqline', `blopts'"'
			}
				
		 	local lablist $MCMC_eqlablist
			local ylabind 1
		 	gettoken ylabel lablist : lablist
		 	while `"`ylabel'"' != "" {
				local ltemp BETA_`ylabind'
				while regexm(`"`eqline'"', `"{`ylabel':}"') {
		 	 	 	 local eqline = regexr(`"`eqline'"', ///
					`"{`ylabel':}"', `"$`ltemp'"')
				}
				gettoken ylabel lablist : lablist
				local `++ylabind'
		 	}

		 	if `"`blocksline'"' == "" {
				local blocksline `"`eqline'"'
		 	}
		 	else {
				local blocksline `"`blocksline';`eqline'"'
		 	}
		}
		else {
	 		gettoken next blocks : blocks, match(paren)
			// move to options 
	 		if "`paren'" == "(" {
				local simoptions `"`simoptions'`eqline'(`next') "'
	 		}
	 		else {
				local simoptions `"`simoptions'`eqline' "'
				if `"`next'"' != "" {
	 		 	 	 local blocks `"`next' `blocks'"'
				}
	 		}
	 		continue
		}
	}
	
	sreturn local simoptions = `"`simoptions'"'
	sreturn local blocksline = `"`blocksline'"'
end
