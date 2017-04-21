*! version 1.0.0  28jan2016
program _bayesmh_clear
	version 14.0
	
	args mcmcobject
	
	global MCMC_debug
	capture mata: mata drop `mcmcobject'

	// clean up $MCMC_genvars
	local toklist $MCMC_genvars
	global MCMC_genvars
	gettoken tok toklist : toklist
	while `"`tok'"' != "" {
		capture drop `tok'
		gettoken tok toklist : toklist
	}

	// clean up $MCMC_tempmats
	local toklist $MCMC_tempmats
	global MCMC_tempmats
	gettoken tok toklist : toklist
	while `"`tok'"' != "" {
		capture matrix drop `tok'
		gettoken tok toklist : toklist
	}

	// clean up the equation label list
	_bayesmh_eqlablist clear
	
	global MCMC_xbdeflabs
	global MCMC_xbdefvars

	// matsize error counter
	global MCMC_matsizeerr
	global MCMC_matsizemin

	if `"$MCMC_postdata"' != "" {
		capture quietly erase `"$MCMC_postdata"'
		global MCMC_postdata ""
	}
end
