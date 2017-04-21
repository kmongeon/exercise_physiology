*! version 1.1.6  01jun2016
program _prefix_buildinfo, eclass
	syntax name(name=cmdname) [, h(name)]
	if "`h'" != "" {
		_post_fvinfo `h'
		exit
	}
	_ms_op_info e(b)
	if r(tsops) {
		quietly tsset, noquery
	}
	if "`cmdname'" == "cox" {
		local cmdname stcox
	}
	local fvaddcons fvaddcons
	local props : properties `cmdname'
	local addcons addcons
	local mprops `"`e(marginsprop)'"'
	if `:list fvaddcons in props' | `:list addcons in mprops' {
		local ADDCONS ADDCONS
	}
	if inlist("`cmdname'", "mlogit", "mprobit") {
		local fveq = e(k_eq) - (e(k_eq) == e(k_eq_base))
		local fveq fvinfoeq(`fveq')
	}
	else if inlist("`cmdname'", "manova", "mvreg") {
		local fveq fvinfoeq(1)
	}
	// the following -capture- is on purpose, if there is an error for any
	// reason then we just want to return without building the FV
	// information
	if "`e(wexp)'" != "" {
		local wgt "[`e(wtype)'`e(wexp)']"
	}
	capture ereturn repost `wgt' , buildfvinfo `ADDCONS' `fveq'
end
