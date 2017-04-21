*! version 1.0.8  13jan2016
*! (subroutine to regres_p, tobit_p, heckma_p)
program define regre_p2 
	version 6
	args       vtyp         /* variable type for prediction
		*/ varn		/* new variable name
		*/ touse        /* touse variable
		*/ offset       /* "noffset" or "" 
		*/ p 		/* Pr() option contents
		*/ e 		/* e()  option contents
		*/ ystar	/* ystar() option contents
		*/ rmse 	/* RMSE or sigma for equation 
		*/ newcons	/* "constant(varname)" or "" 
		*/ fxbadj	/* function callback to adjust x'b for 
				   endogenous variables; used by -ivtobit- */

	if (`"`p'"'!="") + (`"`e'"'!="") + (`"`ystar'"'!="") > 1 { 
		error 198
	}

	local 0 `"`p'`e'`ystar'"'
	gettoken lb 0    : 0, parse(",")
	gettoken comma 0 : 0, parse(",")
	gettoken ub 0    : 0, parse(",")

	if trim(`"`0'"') != "" | trim(`"`comma'"')!="," { 
		error 198
	}

	tempvar L U
	qui gen double `L' = .
	qui gen double `U' = .
	
	Fix `lb'
	local lb `s(res)'
	local lb_o `s(res_o)'
	local lbc `s(class)'
	qui replace `L' = `lb_o'

	Fix `ub'
	local ub `s(res)'
	local ub_o `s(res_o)'
	local ubc `s(class)'
	qui replace `U' = `ub_o'

	capture assert `L' <= `U' if `touse' & !missing(`L') & !missing(`U')
	if _rc {
		if `"`p'"' != "" { local pred "{bf:pr({it:a},{it:b})}" }
		if `"`e'"' != "" { local pred "{bf:e({it:a},{it:b})}" }
		if `"`ystar'"' != "" { local pred "{bf:ystar({it:a},{it:b})}" }
		version 14: di "{err}option `pred' incorrectly " ///
			"specified; {it:b} must be >= {it:a}"
		exit 198
	}
		
	sret clear

	/*
		class contains "missing" or <nothing>.
		The title we want to set is 

				ub class
		lb class	"missing"	<nothing>
		-----------------------------------------
		"missing"	""		"y<ub"
		<nothing>	"y>lb"		"lb<y<ub"
	*/

	DepName depname
	if "`lbc'"=="missing" & "`ubc'"=="" {
		local ttl "`depname'<`ub_o'"
	}
	else if "`lbc'"=="" & "`ubc'"=="missing" {
		local ttl "`depname'>`lb_o'"
	}
	else if "`lbc'"=="" & "`ubc'"=="" {
		local ttl "`lb_o'<`depname'<`ub_o'"
	}

	tempvar yhat new
	qui _predict double `yhat' if `touse', xb `offset' `newcons'
	if "`fxbadj'" != "" {
		/* -ivtobit-: adjust x'b by endogenous model residuals	*/
		qui `fxbadj' `yhat', touse(`touse') noscale
	}

	if `"`p'"' != "" {
		CalcP `new' `yhat' "`rmse'" `touse' `L' `U' "`ttl'"
	}
	else if `"`e'"' != "" {
		CalcE `new' `yhat' "`rmse'" `touse' `L' `U' "`ttl'"
	}
	else 	CalcY `new' `yhat' "`rmse'" `touse' `L' `U' "`ttl'"

	local ttl : var label `new'
	gen `vtyp' `varn' = `new' if `touse'
	label var `varn' `"`ttl'"'
end

program define CalcP
	args P yhat s touse lb ub ttl
	quietly {
		gen double `P' = 1 if `touse' & `lb'==. & `ub'==.
		replace `P' = normprob(-(`lb'-`yhat')/`s') /*
			*/ if `touse' & `lb'!=. & `ub'==.
		replace `P' = normprob((`ub'-`yhat')/`s') /*
			*/ if `touse' & `lb'==. & `ub'!=. 
		replace `P' = normal((`ub'-`yhat')/`s') - /*
			*/ normal((`lb'-`yhat')/`s') /*
			*/ if `touse' & `lb'!=. & `ub'!=. 
	}
	DepName depname
	if "`ttl'"=="" {
		label var `P' `"Pr(`depname')"'
	}
	else 	label var `P' `"Pr(`ttl')"'
end

program define CalcE
	args E yhat s touse lb ub ttl
	local L "((`lb'-`yhat')/`s')"
	local U "((`ub'-`yhat')/`s')"
	quietly {
		gen double `E' = `yhat' if `touse' & `lb'==. & `ub'==.
		replace `E' = `yhat' + `s'*normd(`L')/normprob(-`L') /*
			*/ if `touse' & `lb'!=. & `ub'==.

		replace `E' = `yhat' - `s'*normd(`U')/normprob(`U') /*
			*/ if `touse' & `lb'==. & `ub'!=.

		replace `E' = `yhat' - /*
			*/ `s'*(normd(`U')-normd(`L')) / /*
			*/		(normprob(`U')-normprob(`L')) /*
			*/ if `touse' & `lb'!=. & `ub'!=.
	}
	DepName depname
	if "`ttl'"=="" {
		label var `E' `"E(`depname')"'
	}
	else	label var `E' `"E(`depname'|`ttl')"'
end

program define CalcY
	args Y yhat s touse lb ub ttl

	tempvar E p p2
	CalcE `E'  `yhat' `s' `touse' `lb' `ub'  ""
	CalcP `p'  `yhat' `s' `touse' `lb' `ub'  ""
	CalcP `p2' `yhat' `s' `touse'   .  `lb'  ""

	quietly { 
		gen double `Y' = `E' if `touse' & `lb'==. & `ub'==. 
		replace `Y' = `p'*`E' + (1-`p')*`lb' /*
			*/ if `touse' & `lb'!=. & `ub'==.
		replace `Y' = `p'*`E' + (1-`p')*`ub' /*
			*/ if `touse' & `lb'==. & `ub'!=.
		replace `Y' = `p'*`E' + `p2'*`lb' + (1-`p'-`p2')*`ub' /*
			*/ if `touse' & `lb'!=. & `ub'!=. 
	}
	DepName depname
	if "`ttl'"=="" {
		label var `Y' `"E(`depname')"'
	}
	else	label var `Y' `"E(`depname'*|`ttl')"'
end
	
program define Fix, sclass
	sret clear
	capture confirm numeric variable `0'
	if _rc {
		capture confirm number `0'
		if _rc==0 { 
			sret local res `0'
			sret local res_o `0'
			exit
		}
		else {
			capture local expr = `0'
			if _rc==0 {
				capture confirm number `expr'
				if _rc==0 {
					sret local res `expr'
					sret local res_o `0'
					exit
				}
			}
		}
	}
	
	if trim(`"`0'"')=="." {
		sret local res "."
		sret local res_o "."
		sret local class missing
		exit
	}
	syntax varname
	sret local res `varlist'
	sret local res_o `varlist'
end

program define DepName
	args name          /* name is lmacname to store the depvar name */

	local depname `e(depvar)'
	gettoken depname : depname
	if "`e(cmd)'" == "intreg" { local depname "y" }
	if "`e(cmd)'" == "svyintreg" { local depname "y" }

	c_local `name' `depname'
end

