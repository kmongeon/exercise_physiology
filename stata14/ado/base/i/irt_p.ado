*! version 1.0.1  01aug2016
program irt_p, eclass
	version 14
	local vv : di "version " string(_caller()) ", missing:"
	
	if "`e(cmd)'" != "irt" & "`e(cmd2)'" != "irt" {
		di "{err}last estimates not found"
		exit 198
	}
	
	syntax  anything(id="stub* or newvarlist") 	///
		[if] [in] [,				///
		pr					///
		xb					///
		latent					///
		SCores					///
		outcome(passthru)			///
		CONDitional1(string)			///
		CONDitional				///
		UNCONDitional				/// undocumented
		MARGinal				///
		EBMEANs					///
		EBMODEs					///
		se(passthru)				///
		INTPoints(passthru)			///
		TOLerance(passthru)			///
		ITERate(passthru)			///
	]

	local empty = missing("`pr'`xb'`latent'`scores'")
	if `empty' {
		di "{txt}(option {bf:pr} assumed)"
		syntax anything(id="stub* or newvarlist") [if] [in] [, *]
		local 0 `anything' `if' `in', `options' pr
	}
	
	`vv' gsem_p `0'

end

exit

