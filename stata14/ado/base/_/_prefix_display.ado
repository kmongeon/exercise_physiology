*! version 1.6.3  01apr2016
program _prefix_display, sclass
	version 9
	local vv : di "version " string(max(11,_caller())) ", missing:"
	is_svysum `e(cmd)'
	local is_sum = r(is_svysum)

	// only allow 'eform' options if NOT svy summary commands
	local eform 0
	if ! `is_sum' {
		local regopts NEQ(integer -1) First PLus SHOWEQns
		local eform 1
	}
	else	local neq -1
	local has_rules = inlist("`e(cmd)'", "logistic", "logit", "probit")
	if `has_rules' {
		local altopt "noRULES"
	}
	local is_logistic = "`e(cmd)'" == "logistic"
	if `is_logistic' {
		local altopt "`altopt' COEF OR"
		local eform 0
	}
	local is_st = bsubstr("`e(cmd2)'",1,2) == "st"
	if `is_st' {
		if "`e(frm2)'" == "hazard" | "`e(cmd2)'" == "stcox" {
			local altopt "NOHR"
		}
		else	local altopt "TR"
		local eform 0
	}
	local is_irt = "`e(cmd2)'" == "irt"
	if `is_irt' {
		local altopt DVHEADER ESTMetric
	}
	syntax [,				///
		Level(cilevel)			///
		noHeader			///
		NODVHeader			///
		noLegend			///
		Verbose				///
		TItle(passthru)			///
		notable				/// not documented
		`regopts'			/// _coef_table options
		SVY				/// ignored
		noFOOTnote			///
		`altopt'			///
		CITYPE(passthru)		/// not documented
		percent				/// not documented
		*				///
	]

	local dvheader `nodvheader' `dvheader'
	opts_exclusive "`dvheader'"

	if `eform' {
		_get_diopts diopts options, `options'
	}
	else {
		_get_diopts ignore
		_get_diopts diopts, `options'
		local diopts : list diopts - ignore
		local options
	}

	if `is_sum' & "`e(novariance)'" != "" {
		exit
	}

	if `is_irt' {
		if "`e(prefix)'" == "svy" {
			local not_irt dvheader coeflegend estmetric
			if "`:list not_irt & diopts'" != "" {
				local is_irt 0
			}
		}
		else {
			local is_irt 0
		}
	}

	if "`first'" != "" & `"`showeqns'"' == "" {
		local neq 1
	}
	if `neq' > 0 {
		local neqopt neq(`neq')
	}
	else	local neq

	// verify only valid -eform- option specified
	if `is_st' {
		local cmdname = e(cmd2)
	}
	else	local cmdname = e(cmd)
	_check_eformopt `cmdname', eformopts(`options') soptions

	// check for total number of equations
	local k_eq 0
	Chk4PosInt k_eq
	if `k_eq' == 0 {
		local k_eq : coleq e(b), quote
		local k_eq : list clean k_eq
		local k_eq : word count `k_eq'
	}
	// check for auxiliary parameters
	local k_aux 0
	Chk4PosInt k_aux
	// check for extra equations
	local k_extra 0
	Chk4PosInt k_extra

	local blank
	if "`header'" == "" {
		if `is_irt' {
			local dvheader nodvheader
		}
		_coef_table_header, `title' `rules' `dvheader'
		if "`legend'" == "" {
			if "`e(vce)'" != "" ///
			& ("`e(cmd)'" != "`e(cmdname)'" | "`verbose'" != "") {
				_prefix_legend `e(vce)', `verbose'
				if "`e(vce)'" == "jackknife" ///
				 & "`e(jkrweight)'" == "" ///
				 & "`e(wtype)'" != "iweight" ///
				 & ("`e(k_extra)'`verbose'" != "0" ///
				 |  "`e(k_eexp)'" == "0") {
					_jk_nlegend `s(col1)' ///
						`"`e(nfunction)'"'
					local blank blank
				}
			}
			if `is_sum' {
				_svy_summarize_legend `blank'
				local blank `s(blank)'
			}
		}
		sreturn local blank `blank'
	}

	// check to exit early
	if ("`table'" != "") exit

	if "`header'`blank'" == "" {
		di
	}

	// display the table of coefficients
	if inlist("`e(vce)'","jackknife","brr") {
		local nodiparm nodiparm
	}
	if `is_sum' {
		_sum_table, level(`level') `diopts' `citype' `percent'
		local lsizeopt linesize(`s(width)')
	}
	else if `is_irt' {
		irt_display, noheader level(`level') `diopts'
	}
	else {
		if `is_logistic' & "`coef'" == "" {
			local options or
		}
		if `is_st' {
			if `"`e(frm2)'`e(noeform)'`nohr'"' == "hazard" | ///
			   `"`e(cmd2)'`nohr'"' == "stcox" {
				local options hr
			}
			else if `"`tr'`e(noeform)'"' == "tr" {
				local options tr
			}
		}
		`vv'							///
		_coef_table, level(`level') `neqopt' `first' `plus'	///
			`nodiparm' `showeqns' `diopts' `options'	///
			cmdextras `citype'
	}
	if "`plus'`footnote'" == "" {
		tempname hold
		_return hold `hold'
		_prefix_footnote, `tr' `lsizeopt'
		_return restore `hold'
	}
end

program Chk4PosInt
	args ename
	if `"`e(`ename')'"' != "" {
		capture confirm integer number `e(`ename')'
		if !c(rc) {
			if `e(`ename')' > 0 {
				c_local `ename' `e(`ename')'
			}
		}
		capture 
	}
end

exit
