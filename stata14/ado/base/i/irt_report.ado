*! version 2.0.1  27jan2015
program irt_report
	version 14

	if `"`e(cmd2)'"' != "irt" {
		exit 301
	}

	if "`e(cmd)'" == "estat" {
		Replay `0'
		exit
	}

	Report `0'
end

program Replay, rclass
	syntax [, notable noHEADer *]
	_get_diopts diopts, `options'

	if "`table'" == "notable" {
		local qui qui
	}

	if "`e(b_eqmat)'" == "matrix" {
		local eqmat eqmat(e(b_eqmat))
	}

	if "`header'" == "" {
		_coef_table_header
	}
	`qui'				///
	_coef_table,	`eqmat'		///
			showeq		///
			noeqcheck	///
			baselevels	///
			vsquish		///
			`options'
	return add

	tempname t
	matrix `t' = e(b)
	return matrix b `t'
	if "`e(V)'" == "matrix" {
		matrix `t' = e(V)
		return matrix V `t'
	}
	if "`e(V)'" == "matrix" {
		matrix `t' = e(V)
		return matrix V `t'
	}
end

program Report, rclass
	syntax [anything] [,			///
			ALABel(name)		///
			BLABel(name)		///
			CLABel(name)		///
			BYParm			///
			sort(string asis)	///
			verbose			/// NOT DOCUMENTED
			SEQlabel		///
			POST			///
			COEFLegend		///
			SELEGEND		/// NOT DOCUMENTED
			notable			/// NOT DOCUMENTED
			noHEADer		/// NOT DOCUMENTED
			hybrid			/// NULL OPT
			novce			/// NULL OPT
			*			/// display_options
	]

	if `"`sort'"' != "" {
		// creates the following local macros:
		//	sort
		//	descending
		ParseSort `sort'
	}

	_get_diopts diopts, `options'

	tempname x
	local ITEMS `"`e(item_list)'"'
	local dim : list sizeof ITEMS
	matrix `x' = J(1,`dim',0)
	matrix colna `x' = `ITEMS'
	_unab `anything', mat(`x')
	local anything `"`r(varlist)'"'

	local LEGEND `coeflegend' `selegend'
	if "`LEGEND'" != "" & "`post'" == "" {
		di as err ///
		"option {bf:`LEGEND'} not allowed without option {bf:post}"
		exit 198
	}

	if "`table'" == "notable" {
		local qui qui
	}

	tempname b v eq

	// _irt_parms_build() is aware of the following local macros:
	//	anything
	//	alabel
	//	blabel
	//	clabel
	//	byparm
	//	sort
	//	descending
	//	verbose
	//	seqlabel
	//	post

	mata: _irt_parms_build()
	return add

	matrix `b' = return(b)
	matrix `v' = return(V)
	if "`return(eq_models)'" == "matrix" {
		matrix `eq' = return(eq_models)
		local eqmat eqmat(`eq')
	}

	if "`header'" == "" {
		_coef_table_header, nodvheader
	}
	`qui'				///
	_coef_table,	bmat(`b')	///
			vmat(`v')	///
			`eqmat'		///
			showeq		///
			noeqcheck	///
			nocnsreport	///
			baselevels	///
			vsquish		///
			`LEGEND'	///
			`options'
	return add
end

program ParseSort
	capture syntax name(name=ptype id=type) [, Descending]
	if c(rc) {
		di as err "invalid sort() option;"
		syntax name(name=ptype id=type) [, Descending]
		exit 198	// [sic]
	}
	if !inlist("`ptype'", "a", "b", "c") {
		di as err "invalid sort() option;"
		di as err "parameter `ptype' not recognized"
		exit 198
	}
	c_local sort `ptype'
	c_local descending `descending'
end

exit
