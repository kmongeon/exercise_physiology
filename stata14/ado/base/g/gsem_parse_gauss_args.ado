*! version 1.1.1  14nov2016
program gsem_parse_gauss_args, sclass
	version 13

	local OPTS	LDepvar(passthru)	///
			UDepvar(passthru)	///
			LCensored(passthru)	///
			RCensored(passthru)	///
			LTruncated(passthru)	///
			RTruncated(passthru)
	capture syntax [, `OPTS']
	if c(rc) {
		di as err "option family() invalid;"
		di as err "invalid option for family gaussian"
		syntax [, `OPTS']
		exit 198	// [sic]
	}
	if `"`ldepvar'"' != "" | `"`udepvar'"' != "" {
		opts_exclusive `"`ldepvar' `udepvar'"' family
		opts_exclusive `"`ldepvar' `lcensored'"' family
		opts_exclusive `"`ldepvar' `rcensored'"' family
		opts_exclusive `"`udepvar' `lcensored'"' family
		opts_exclusive `"`udepvar' `rcensored'"' family
	}
	local fargs	`ldepvar'	///
			`udepvar'	///
			`lcensored'	///
			`rcensored'	///
			`ltruncated'	///
			`rtruncated'
	local fargs : list retok fargs
	sreturn local fargs `fargs'

	parseit, `fargs'
end

program parseit, sclass
	local OPTS	LDepvar(varname ts numeric)	///
			UDepvar(varname ts numeric)	///
			LCensored(string)		///
			RCensored(string)		///
			LTruncated(string)		///
			RTruncated(string)
	capture syntax [, `OPTS']
	if c(rc) {
		di as err "option family() invalid;"
		syntax [, `OPTS']
		exit 198	// [sic]
	}
	if "`ldepvar'" != "" {
		capture confirm number `ldepvar'
		if c(rc) {
			CheckNumVar ldepvar `ldepvar'
		}
	}
	if "`rcensored'" != "" {
		capture confirm number `rcensored'
		if c(rc) {
			CheckNumVar rcensored `rcensored'
		}
	}
	if "`lcensored'" != "" {
		capture confirm number `lcensored'
		if c(rc) {
			CheckNumVar lcensored `lcensored'
		}
	}
	if "`rcensored'" != "" {
		capture confirm number `rcensored'
		if c(rc) {
			CheckNumVar rcensored `rcensored'
		}
	}
	if "`ltruncated'" != "" {
		capture confirm number `ltruncated'
		if c(rc) {
			CheckNumVar ltruncated `ltruncated'
		}
	}
	if "`rtruncated'" != "" {
		capture confirm number `rtruncated'
		if c(rc) {
			CheckNumVar rtruncated `rtruncated'
		}
	}
	sreturn local ldepvar `ldepvar'
	sreturn local udepvar `udepvar'
	sreturn local lcensored `lcensored'
	sreturn local rcensored `rcensored'
	sreturn local ltruncated `ltruncated'
	sreturn local rtruncated `rtruncated'
end

program CheckNumVar
	args name spec

	local 0 `", `name'(`spec')"'
	capture syntax [, `name'(varname ts numeric)]
	if c(rc) {
		di as err "option family() invalid;"
		syntax [, `name'(varname ts numeric)]
		exit 198	// [sic]
	}
	c_local `name' `"``name''"'
end

exit
