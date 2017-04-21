*! version 2.1.2  01apr2016
program _sum_table, rclass
	version 9
	if (!c(noisily) & c(coeftabresults) == "off") {
		exit
	}
	if "`e(cmd)'" == "" {
		error 301
	}
	if "`e(mi)'"=="mi" {
		local MIOPTS BMATrix(string) VMATrix(string) DFMATrix(string)
		local MIOPTS `MIOPTS' PISEMATrix(string) EMATrix(string)
		local MIOPTS `MIOPTS' DFTable NOCLUSTReport NOEQCHECK DFONLY
		local MIOPTS `MIOPTS' ROWMATrix(string) ROWCFormat(string) 
		local MIOPTS `MIOPTS' NOROWCI 
        }

	syntax [,	Level(cilevel)		///
			COEFLegend		///
			SELEGEND		///
			cformat(passthru)	///
			noLSTRETCH		///
			`MIOPTS'		///
			CITYPE(string)		/// NOT DOCUMENTED
			percent			/// NOT DOCUMENTED
	]
	_get_diopts ignore, `cformat'
	local cformat `"`s(cformat)'"'

	if ("`e(mi)'"=="mi") {
		is_svysum `e(cmd_mi)'
	}
	else {
		is_svysum `e(cmd)'
	}
	if !r(is_svysum) {
		error 301
	}

	local type `coeflegend' `selegend' `dfonly'
	opts_exclusive "`type'"
	if "`type'" == "" {
		local type nopvalues
	}
	if "`e(over)'" != "" {
		local depname `"Over"'
	}
	else	local depname `" "'
	if !missing("`percent'") {
		local coefttl Percent
		if `"`s(cformat)'"'=="" local cformat %9.2f
	}
	else 	local coefttl "`e(depvar)'"
	local cmdextras cmdextras

	mata: _coef_table()
	return add
end

exit
