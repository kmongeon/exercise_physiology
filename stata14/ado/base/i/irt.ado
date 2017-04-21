*! version 1.0.8  12aug2016
program irt, eclass byable(onecall) prop(or irr svyg svyj svyb)
	version 14

	if _by() {
		local by "by `_byvars'`_byrc0':"
	}

	`by' _vce_parserun irt , noeqlist : `0'
	if "`s(exit)'" != "" {
		ereturn local cmdline `"irt `0'"'
		exit
	}

	if replay() {
		if `"`e(cmd2)'"' != "irt" {
			error 301
		}
		if _by() {
			error 190
		}
		irt_display `0'
		exit
	}

	`by' Estimate `0'

	ereturn local cmdline `"irt `0'"'
end

program Estimate, sortpreserve eclass byable(recall)

	if _by() {
		tempname bytouse
		mark `bytouse'
	}

	gettoken hybrid : 0
	if "`hybrid'" == "hybrid" {
		gettoken hybrid 0 : 0
	}

	syntax anything [if] [in] [fw pw iw] [, LLABel(name) noCNSReport ///
		noHEADer DVHEADer notable CONSTRaints(passthru) LISTwise ///
		from(passthru) ESTMetric noESTimate COEFLegend noCONTRACT *]

	marksample touse

	if missing("`llabel'") local llabel Theta

	if missing("`dvheader'") local dvheader "nodvheader"
	local opts_not `header' `cnsreport' `table' `dvheader'

	if "`estimate'"=="noestimate" {
		local coeflegend coeflegend
		local contract nocontract
	}

	if "`weight'" != "" local wopt [`weight'`exp']
	else local wopt
	
	local hassvy = "`c(prefix)'" == "svy"
	local hasipw = inlist("`weight'","iweight","pweight")
	if `hassvy' | `hasipw' | "`contract'" == "nocontract" {
		local preserve 0
	}
	else 	local preserve 1

	local 0 `anything' `if' `in', `options'

	_parse expand eq opt : 0
	local gl_if `opt_if'
	local gl_in `opt_in'
	local gl_opts `opt_op'
	local mif = !missing(`"`gl_if'`gl_in'"')

	_get_diopts diopts gl_opts, `gl_opts'

	local allowed 1pl 2pl 3pl grm rsm pcm gpcm nrm

	forvalues i = 1/`eq_n' {
		local 0 `eq_`i''
		gettoken model 0 : 0
		__check_model, model(`model') allowed(`allowed')
		if "`model'"=="3pl" local g_opt "SEPGuessing"
		syntax varlist [if] [in] [, LLABel1(string) `g_opt' *]
		
		local mif = `mif' + !missing(`"`if'`in'"')
		if `mif' > 1 {
			di "{err}multiple 'if' specifications not allowed"
			exit 198
		}
		
		local varlist : list varlist - touse
		_get_diopts eq_di eq_op, `options'
		local diopts `diopts' `eq_di'
		local eq_opts `eq_opts' `eq_op'

		if !missing("`llabel1'") {
			di as err ///
			"option {bf:llabel()} not allowed inside equation"
			exit 198
		}

		foreach v of local varlist {
			local mlist `mlist' `model'
			local ilist `ilist' `v'
		}

		sreturn clear
		__make_`model' `varlist', latent(`llabel') `sepguessing' ///
			ix(`i') touse(`touse') `constraints'
		local eqs `eqs' `s(eq)'
		local cns `cns' `s(cns)'
		local cns_usr `cns_usr' `s(cns_usr)'
		local _from `_from' `s(_from)'
		local model`i' `model'
		local modelname`i' `s(modelname)'
		local models `models' `model'
		local items`i' `varlist'
		local k_items`i' `=`:list sizeof varlist''
		local sepg`i' `s(sepg)'
		local n_cuts`i' `s(n_cuts)'
		local off`i' `s(off)'
		local ilist_fv `ilist_fv' `s(ilist_fv)'
	}
	_get_diopts diopts, `diopts'

	local dups : list dups ilist
	if !missing("`dups'") {
		di as err "duplicate items not allowed"
		exit 198
	}

	tempname base last
	local n : list sizeof ilist
	mat `base' = J(1,`n',0)
	mat `last' = J(1,`n',0)
	local j = 1
	foreach i of local ilist {
		qui summ `i' if `touse', meanonly
		if `r(min)'==`r(max)' {
			di "{err}the model is not identified;"
			di "{err}{p 4 4 2}"				///
				"item {bf:`i'} does not vary in the "	///
				"estimation sample{p_end}"
				exit 459
		}
		mat `base'[1,`j'] = `r(min)'
		mat `last'[1,`j'] = `r(max)'
		local ++j
	}
	mat colnames `base' = `ilist'
	mat colnames `last' = `ilist'

	local opts variance(`llabel'@1) latent(`llabel') ///
		constraints(`cns' `cns_usr') `startvalues' `listwise'

	if !missing("`_from'") & missing("`from'") {
		local from from(`_from')
	}

	if `preserve' {
		tempvar miss fw
		if "`listwise'" != "" {
			qui egen byte `miss' = rowmiss(`ilist') if `touse'
			qui replace `touse' = 0 if `miss'
		}
		else {
			qui egen byte `miss' = rownonmiss(`ilist') if `touse'
			qui replace `touse' = 0 if !`miss'
		}
		local 0 , `opts' `eq_opts' `gl_opts'
		syntax [, vce(string) *]
		_vce_parse, optlist(oim Robust) argoptlist(CLuster):,vce(`vce')
		local clust `r(cluster)'
		preserve
		contract `ilist' `clust' `touse' `wopt' if `touse', freq(`fw')
		local wt [fweight=`fw']
		local cmd1 `eqs' if `touse' `wt'
		qui count
		local N_p `r(N)'
	}
	else {
		local cmd1 `eqs' if `touse' `wopt'
	}
	
	local cmd1 `cmd1', `opts' `eq_opts' `gl_opts' `from'
	local cmd2 `eqs' `if' `in' `wopt', `opts' `eq_opts' `gl_opts' `from'

	gsem `cmd1' irtcmd noheader nocnsreport notable nodvheader `estimate'

	if `eq_n'==1 local MODEL `modelname1'
	else	     local MODEL "Hybrid IRT"
	ereturn local title "`MODEL' model"
	ereturn hidden local llabel `llabel'

	// hidden results
	ereturn hidden local cmdline2 `"gsem `cmd2'"'
	ereturn hidden local models `models'
	ereturn hidden local model_list `mlist'
	ereturn hidden local item_list `ilist'
	ereturn hidden local item_list_fv `ilist_fv'
	ereturn hidden matrix base = `base'
	ereturn hidden matrix last = `last'

	forvalues i = 1/`eq_n' {
		ereturn local model`i' `model`i''
		ereturn local items`i' `items`i''
		ereturn scalar k_items`i' = `k_items`i''

		capture ereturn scalar sepguess`i' = `sepg`i''

		ereturn local n_cuts`i' `n_cuts`i''
		local off `off' `off`i''
	}
	capture ereturn hidden local off `off'

	foreach c in `cns' {
		local tmp : constraint `c'
		ereturn hidden local irt_cns_`c' `tmp'
		constraint drop `c'
	}
	ereturn hidden local irt_cns_list `cns'

	ereturn scalar irt_k_eq = `eq_n'

	ereturn local estat_cmd irt_estat
	ereturn local cmd2 irt
	
	ereturn local predict "irt_p"
	
	ereturn hidden local marginsdefault "`e(marginsdefault)'"
	ereturn hidden local marginsok "`e(marginsok)'"
	ereturn hidden local marginsnotok "`e(marginsnotok)'"
	ereturn hidden scalar contract = `preserve'
	
	if `preserve' {
		restore
		ereturn repost `wopt', esample(`touse')
		ereturn scalar N_patterns = `N_p'
		if "`wopt'" == "" {
			ereturn local wtype
			ereturn local wexp
		}
		signestimationsample `ilist' `clust'
	}

	irt_display, `diopts' `opts_not' `coeflegend' `estmetric'
end

program __check_model
	syntax , model(string) allowed(string)
	local good : list posof "`model'" in allowed
	if !`good' {
		di as err "invalid model {bf:`model'};"
		di as err "{bf:`model'} is not one of the officially "	///
			"supported {help irt} models."
		exit 198
	}
end

program __make_1pl, sclass
	syntax varlist , latent(name) ix(string) touse(varname)
	__check01 `varlist' , touse(`touse') model(1pl)
	sreturn local ilist_fv `s(ilist_fv)'
	sreturn local eq (`latent'@a`ix' -> `varlist', logit)
	sreturn local off `=`:list sizeof varlist'*2'
	sreturn local modelname "One-parameter logistic"
end

program __make_2pl, sclass
	syntax varlist , latent(name) ix(string) touse(varname)
	__check01 `varlist' , touse(`touse') model(2pl)
	sreturn local ilist_fv `s(ilist_fv)'
	sreturn local eq (`latent' -> `varlist', logit)
	sreturn local off `=`:list sizeof varlist'*2'
	sreturn local modelname "Two-parameter logistic"
end

program __make_3pl, sclass
	syntax varlist , latent(name) ix(string) touse(varname) ///
		[ SEPGuessing CONSTRaints(numlist) ]

	__check01 `varlist' , touse(`touse') model(3pl)
	sreturn local ilist_fv `s(ilist_fv)'

	local sepg = !missing("`sepguessing'")

	if !`sepg' {
		gettoken i rest : varlist
		foreach j of local rest {
			constraint free
			local c `r(free)'
			constraint `c' _b[`i'_logitc:_cons] =	///
				 _b[`j'_logitc:_cons]
			local cns `cns' `c'
		}
	}

	sreturn local eq (`latent' -> `varlist', family(3pl))
	sreturn local cns `cns'
	sreturn local cns_usr `constraints'
	sreturn local sepg `sepg'
	sreturn local off `=`:list sizeof varlist'*3'
	sreturn local modelname "Three-parameter logistic"
end

program __make_grm, sclass
	syntax varlist , latent(name) ix(string) touse(varname)
	tempname m
	local off 0
	foreach v in `varlist' {
		qui tab `v' if `touse', matrow(`m')
		local off = `off' + `r(r)'
		local cuts `cuts' `r(r)'
		forvalues i=1/`=rowsof(`m')' {
			local z = `m'[`i',1]
			__isInteger `z' `v'
			local ilist_fv `ilist_fv' `z'.`v'
		}
		local _from `_from' `v':`latent'=1
	}
	sreturn local eq (`latent' -> `varlist', ologit)
	sreturn local off `off'
	sreturn local n_cuts `cuts'
	sreturn local _from `_from'
	sreturn local ilist_fv `ilist_fv'
	sreturn local modelname "Graded response"
end

program __make_nrm, sclass
	syntax varlist , latent(name) ix(string) touse(varname)
	local off 0
	local i 0
	foreach v in `varlist' {
		local ++i
		tempname m`i'
		
		qui tab `v' if `touse', matrow(`m`i'')
		local n_cuts = `r(r)'
		local cuts `cuts' `r(r)'
		local off = `off' + `r(r)'*2
		
		forvalues j=1/`n_cuts' {
			local z = el(`m`i'',`j',1)
			__isInteger `z' `v'
			local ilist_fv `ilist_fv' `z'.`v'
			if `j'>1 {
				local _from `_from' `z'.`v':`latent'=1
			}
		}
	}

	sreturn local eq (`latent' -> `varlist', mlogit)
	sreturn local off `off'
	sreturn local n_cuts `cuts'
	sreturn local _from `_from'
	sreturn local ilist_fv `ilist_fv'
	sreturn local modelname "Nominal response"
end

program __make_pcm,  sclass
	syntax varlist , latent(name) ix(string) touse(varname) [generalized]

	local g = !missing("`generalized'")
	local n_vars : list sizeof varlist

	local off 0
	local i 0
	foreach v in `varlist' {
		local ++i
		if `g' local c `i'
		local k 0

		tempname m`i'
		qui tab `v' if `touse', matrow(`m`i'')
		local n_cuts = `r(r)'
		local cuts `cuts' `r(r)'
		local off = `off' + `n_cuts'*2
		forvalues j=1/`n_cuts' {
			local z = el(`m`i'',`j',1)
			__isInteger `z' `v'
			local ilist_fv `ilist_fv' `z'.`v'
			local eq ( `z'.`v' <- `latent'@(`k'*a`c'_`ix') , mlogit)
			local ++k
			local eqs `eqs' `eq'
			if `j'>1 {
				local _from `_from' `z'.`v':`latent'=`=`j'-1'
			}
		}
	}

	sreturn local eq `eqs'
	sreturn local off `off'
	sreturn local n_cuts `cuts'
	sreturn local _from `_from'
	sreturn local ilist_fv `ilist_fv'
	sreturn local modelname "Partial credit"
end

program __make_gpcm, sclass
	syntax varlist , latent(passthru) ix(passthru) touse(passthru)
	local 0 `varlist', `latent' `ix' `touse' `options' generalized
	__make_pcm `0'
	sreturn local eq `s(eq)'
	sreturn local off `s(off)'
	sreturn local n_cuts `s(n_cuts)'
	sreturn local _from `s(_from)'
	sreturn local ilist_fv `s(ilist_fv)'
	sreturn local modelname "Generalized partial credit"
end

program __make_rsm,  sclass
	syntax varlist , latent(name) ix(string) touse(varname)

	local n_vars : list sizeof varlist

	gettoken y ys : varlist

	marksample touse

	local i 0
	local ++i
	local k 0

	tempname m`i'
	qui tab `y' if `touse', matrow(`m`i'')
	local n_cuts = `r(r)'
	local cuts `cuts' `r(r)'
	local off = `off' + `n_cuts'*2

	forvalues j=1/`n_cuts' {
		local z = el(`m1',`j',1)
		__isInteger `z' `y'	
		local ilist_fv `ilist_fv' `z'.`y'
		local eq ( `z'.`y' <- `latent'@(`k'*a_`ix') , mlogit)
		local ++k
		local eqs `eqs' `eq'
		if `j'>1 {
			local _from `_from' `z'.`y':`latent'=`=`j'-1'
		}
	}

	local ncuts1 `n_cuts'
	local cns_ok = `n_cuts'>2

	foreach v in `ys' {
		local ++i
		local k 0

		tempname m`i'
		qui tab `v' if `touse', matrow(`m`i'')
		local n_cuts = `r(r)'
		if `n_cuts' != `ncuts1' {
			di as err "items {bf:`varlist'} must have "	///
				"the same number of levels"
			exit 198
		}
		local cuts `cuts' `r(r)'
		local off = `off' + `n_cuts'*2
		forvalues j=1/`n_cuts' {
			local z = el(`m`i'',`j',1)
			__isInteger `z' `v'
			local ilist_fv `ilist_fv' `z'.`v'
			local eq ( `z'.`v' <- `latent'@(`k'*a_`ix') , mlogit)
			local ++k
			local eqs `eqs' `eq'
			if `j'>1 {
				local _from `_from' `z'.`v':`latent'=`=`j'-1'
			}
		}
	}

	if `cns_ok' {
		forvalues i = `ncuts1'(-1)3 {
			local j = `i'-1
			local e1 = `m1'[`j',1]
			local e2 = `m1'[`i',1]
			local cns`i' _b[`e2'.`y':_cons] - _b[`e1'.`y':_cons]
		}

		local k 2
		foreach v in `ys' {
			forvalues i = `ncuts1'(-1)3 {
				local j = `i'-1
				local e1 = `m`k''[`j',1]
				local e2 = `m`k''[`i',1]

				constraint free
				local c `r(free)'
				constraint `c' `cns`i'' = ///
					_b[`e2'.`v':_cons] - _b[`e1'.`v':_cons]
				local cns `cns' `c'
			}
			local ++k
		}
	}

	sreturn local eq `eqs'
	sreturn local cns `cns'
	sreturn local off `off'
	sreturn local n_cuts `cuts'
	sreturn local _from `_from'
	sreturn local ilist_fv `ilist_fv'
	sreturn local modelname "Rating scale"
end

program __check01, sclass
	syntax varlist, touse(varname) model(string)
	foreach v of varlist `varlist' {
		capture assert missing(`v') | inlist(`v',0,1) if `touse'
                if _rc {
di "{err}variable `v' has invalid values;"
di "{err}irt `model' requires item variables be coded 0, 1, or missing"
exit 198
                }
                local ilist_fv `ilist_fv' 0.`v' 1.`v'
	}
	sreturn local ilist_fv `ilist_fv'
end

program __isInteger
	args k item
	capture confirm integer number `k'
	if _rc {
		di "{err}item `item' contains noninteger values"
		exit 198
	}
end

exit
