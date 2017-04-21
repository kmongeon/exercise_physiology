*! version 1.0.5  01aug2016
program xtordinal_p, sclass
	version 13
	local vv : di "version " string(_caller()) ", missing:"
	
	if !inlist("`e(cmd2)'","xtologit","xtoprobit") {
		di "{err}last estimates not found"
		exit 198
	}
	
	syntax  anything 				///
		[if] [in] [, 				///
		pr					///
		pu0					///
		xb					///
		stdp					///
		noOFFset				///
		Outcome(passthru)			///
		*]
	
	local pred `xb' `stdp' `pu0' `pr'
	if `=`:list sizeof pred'' > 1 {
		di "{err}only one of {bf:xb}, {bf:stdp}, {bf:pr}, " ///
			"{bf:pu0} can be specified"
		exit 198
	}
	
	if "`pu0'" != "" {
		local pred pr
		local fix fixedonly
	}
	if "`pr'" != "" {
		local pred pr
		local fix marginal
	}

	if "`pred'" == "" {
		if "`c(marginscmd)'" == "on" {
			if _caller() > 14 {
				local pred pr
				local fix marginal
			}
			else {
				local pred xb
			}
		}
		else {
			di "{txt}(option xb assumed; linear prediction)"
			local pred xb
		}
	}

	if inlist("`pred'","xb","stdp") & "`outcome'"!="" {
		di "{err}option {bf:outcome()} not allowed with {bf:`pred'}"
		exit 198
	}
	`vv' gsem_p `anything' `if' `in' , `pred' `offset' `outcome' `fix' `options'
		
end
exit

