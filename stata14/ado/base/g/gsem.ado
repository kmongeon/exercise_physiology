*! version 1.2.1  27oct2015
program gsem, eclass byable(onecall) properties(svyb svyj svyg)
	version 13
	local vv : di "version " string(_caller()) ", missing:"

	if replay() {
		if "`e(cmd)'" != "gsem" & "`e(cmd2)'" != "gsem" & ///
		  "`e(cmd2)'" != "meglm" {
			error 301
		}
		if _by() {
			error 190
		}
		Display `0'
		exit
	}

	quietly ssd query
	if r(isSSD) {
		di as err "gsem not allowed with summary statistic data"
		exit 111
	}

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}

	tempname GSEM
	capture noisily `vv' `BY' Estimate `GSEM' `0'
	local rc = c(rc)
	capture mata: rmexternal("`GSEM'")
	capture drop `GSEM'*
	if (`rc') exit `rc'
	ereturn local cmdline `"gsem `0'"'
end

program Estimate, byable(recall) eclass
	version 13
	local vv : di "version " string(_caller()) ", missing:"
	gettoken GSEM : 0

	if _by() {
		tempname bytouse
		mark `bytouse'
	}

	// Fit sets the following local macros:
	//
	//	cluster
	//	diopts

	`vv' `BY' Fit "`bytouse'" `0'

	`vv' gsem_ereturn `GSEM'

	if "`cluster'" != "" {
		ereturn local clustvar `"`cluster'"'
	}
	ereturn hidden scalar gsem_vers = 2

	if e(k_eq_model) {
		_prefix_model_test
	}

	Display, `diopts'
end

program Fit, eclass sortpreserve
	version 13
	local vv : di "version " string(_caller()) ", missing:"
	gettoken bytouse 0 : 0
	gettoken GSEM 0 : 0

	tempname touse b
	`vv' gsem_parse `GSEM', touse(`touse') bytouse(`bytouse') : `0'
	local mltype	`"`r(mltype)'"'
	local mleval	`"`r(mleval)'"'
	local mlspec	`"`r(mlspec)'"'
	local mlopts	`"`r(mlopts)'"'
	local mlvce	`"`r(mlvce)'"'
	local mlwgt	`"`r(mlwgt)'"'
	local nolog	`"`r(nolog)'"'
	local mlprolog	`"`r(mlprolog)'"'
	local mlextra	`"`r(mlextra)'"'
	local mlgroup	`"`r(mlgroup)'"'
	local mlclust	`"`r(mlclust)'"'
	c_local diopts	`"`r(diopts)'"'
	local est	= r(estimate)
	local full	= r(full_msg)
	matrix `b' = r(b)
	if "`r(Cns)'" != "" {
		tempname Cns
		matrix `Cns' = r(Cns)
		local cnsopt constraint(`Cns')
	}

	if `est' {
		_vce_parse `touse',		///
			opt(OIM OPG Robust)	///
			argopt(CLuster)		///
			: , `mlvce'
		c_local cluster `"`r(cluster)'"'
		if `full' & "`nolog'" == "" {
			di
			di as txt "Fitting full model:"
		}
		set buildfvinfo off			// auto-reset on exit
		ml model `mltype' `mleval'		///
			`mlspec'			///
			`mlwgt'				///
			if `touse',			///
			`mlopts'			///
			`mlvce'				///
			`mlprolog'			///
			`mlextra'			///
			`mlgroup'			///
			`cnsopt'			///
			collinear			///
			init(`b', copy)			///
			maximize			///
			missing				///
			nopreserve			///
			search(off)			///
			userinfo(`GSEM')		///
			wald(0)				///
							 // blank
		ereturn hidden scalar estimates = 1
	}
	else {
		di
		di as txt "Posting starting values:"
		tempname V grad
		local dim = colsof(`b')
		matrix `V' = J(`dim',`dim',0)
		local colna : colful `b'
		matrix colna `V' = `colna'
		matrix rowna `V' = `colna'
		matrix `grad' = J(1,`dim',.)
		matrix colna `grad' = `colna'
		ereturn post `b' `V' `Cns', esample(`touse')
		ereturn matrix gradient `grad'
		ereturn hidden scalar estimates = 0
		quietly count if e(sample)
		ereturn scalar N = r(N)
		ereturn scalar k_autoCns = 0
	}

	ereturn local footnote	gsem_footnote
	ereturn local estat_cmd	gsem_estat
	ereturn local predict	gsem_p
end

program Display
	syntax [,	noHeader	///
			noDVHeader	///
			noLegend	///
			notable		///
			*		///
	]
	_get_diopts diopts, `options'
	if e(estimates) == 0 {
		local coefl coeflegend selegend
		local coefl : list diopts & coefl
		if `"`coefl'"' == "" {
			local diopts `diopts' coeflegend
		}
	}
	_prefix_display, `header' `dvheader' `legend' `table' `diopts'
end

exit
