*! version 1.0.2  02may2016
program _bayesmh_eqlablist
	version 14.0
	_bayesmh_eqlablist_`0'
end

program _bayesmh_eqlablist_init
	global MCMC_eqlablist " "
	global BETA_1
	global MCMC_beta_1
end

program _bayesmh_eqlablist_import
	
	if `"`e(cmd)'"' != "bayesmh" | `"`e(parnames)'"' == "" {
		di as err "last estimates not found"
		exit 301
	}

	// initialize with 1 interval 
	global MCMC_eqlablist " "

	local parnames `"`e(parnames)'"'
	gettoken next parnames : parnames
	while `"`next'"' != "" {

		local eqlab
		local param `"`next'"'
		tokenize `"`next'"', parse(":")
		if `"`1'"' != "" & `"`2'"' == ":" {
			local eqlab `"`1'"'
			local param `"`3'"'
		}
		if `"`eqlab'"' == "" {
			gettoken next parnames : parnames
			continue
		}
		// update $MCMC_eqlablist
		if !regexm(`"$MCMC_eqlablist"', `" `eqlab' "') {
			global MCMC_eqlablist `"$MCMC_eqlablist`eqlab' "'
			local eqlabind : word count $MCMC_eqlablist
			local ltemp BETA_`eqlabind'
			global `ltemp'
			// clear global MCMC_beta_`ylabind'
			local eqlablist MCMC_beta_`eqlabind'
			global `eqlablist'
		}
		else {
			tokenize $MCMC_eqlablist
			local eqlabind 1
			while`"`1'"' != "" & `"`eqlab'"' != `"`1'"' {
				local eqlabind = `eqlabind'+1
				mac shift
			}
			local eqlablist MCMC_beta_`eqlabind'
		}
		if !regexm(`"$`eqlablist'"', `"`param' "') {
			global `eqlablist' = `"$`eqlablist'`param' "'
		}
		gettoken next parnames : parnames
	}
end

program _bayesmh_eqlablist_clear
	local toklist $MCMC_eqlablist
	local ylabind : word count $MCMC_eqlablist
	gettoken tok toklist : toklist
	forvalues tok = 1/`ylabind' {
		// clear global MCMC_beta_`tok'
		local ltemp BETA_`tok'
		global `ltemp'
		local ltemp MCMC_beta_`tok'
		global `ltemp'
		gettoken tok toklist : toklist
	}
	global MCMC_eqlablist
end


program _bayesmh_eqlablist_ind, sclass
	args yvar
	local ylabind 1
	if !regexm(`"$MCMC_eqlablist"', `"`yvar' "') {
		global MCMC_eqlablist = ///
			`"$MCMC_eqlablist`yvar' "'
		local ylabind : word count $MCMC_eqlablist
	}
	else {
		tokenize $MCMC_eqlablist
		local ylabind 1
		while `"`1'"' != "" & `"`yvar'"' != `"`1'"' {
			local ylabind = `ylabind'+1
			mac shift
		}
	}
	sreturn local ylabind = `ylabind'
end

program _bayesmh_eqlablist_up
	args yvar param ylabind

	local ltemp BETA_`ylabind'
	local gtemp `"$`ltemp'"'
	if !regexm(`"`gtemp'"', `"{`yvar':`param'} "') {
		global `ltemp' = `"`gtemp'{`yvar':`param'} "'
		local ltemp MCMC_beta_`ylabind'
		local gtemp `"$`ltemp'"'
		global `ltemp' = `"`gtemp'`param' "'
	}
end
