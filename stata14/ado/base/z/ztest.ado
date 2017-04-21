*! version 1.0.2  17feb2015
program define ztest, rclass byable(recall)
	version 14

	/* turn "==" into "=" if needed before calling -syntax- */
	gettoken vn rest : 0, parse(" =")
	gettoken eq rest : rest, parse(" =")
	if `"`eq'"' == "==" {
		local 0 `vn' = `rest'
	}

	syntax varname [=/exp] [if] [in] [, /*
	*/ BY(varname) UNPaired Level(cilevel) /*
	*/ sddiff(passthru) corr(passthru) /*
	*/ sd1(passthru) sd2(passthru) sd(passthru) ]

	
	marksample touse, novarlist 

	if `"`exp'"'!="" {
		if `"`by'"'!="" {
			di as err /*
		     */ "{p} {bf:by()} and {bf:=} may not be combined {p_end}"
			exit 198
		}

		if `"`unpaired'"'!="" { /* do two-sample (unpaired) test */

			cap confirm variable `exp'
			if (_rc) {
				di as err /*
				*/ "{p} two variables must be specified " /*
				*/ "for unpaired z test {p_end}"
				exit 198
			}	
			if (`"`sddiff'`corr'"' != "") {
				di as err /*
				*/ "{p}{bf:corr()} and {bf:sddiff()} may not" /*
				*/ " be specified for unpaired z test {p_end}"
				exit 198
			}			
			Zt_two `varlist' `exp' if `touse',  /*
				*/ level(`level') `sd1' `sd2' `sd'
			ret add
			exit
		}

		/* If here, we do one-sample (paired) test. */

		capture confirm number `exp'
		if _rc==0 {
			if (`"`sddiff'`sd1'`sd2'`corr'"' != "") {
				di as err /*
	*/ "{p}{bf:sddiff()}, {bf:corr()}, {bf:sd1()}, and {bf:sd2()} " /*
	*/ "may not be specified for one-sample z test {p_end}"
				exit 198
			}	
			Zt_one `varlist' if `touse', /*
				*/ level(`level') `sd' exp(`exp')
			ret add
			exit
		}

		confirm variable `exp'		
		
		Zt_paired `varlist' `exp' if `touse', /*
			*/ level(`level') `sddiff' `corr' `sd' `sd1' `sd2'
		
		ret add
		exit
	}

	/* If here, do two-sample (unpaired) test with by(). */

	if `"`by'"'=="" {
                di in red "by() option required"
                exit 100
        }

	if (`"`sddiff'`corr'"' != "") {
		di as err "{p}{bf:corr()} and {bf:sddiff()} "  /*
		*/ "may not be specified for unpaired z test {p_end}"
		exit 198
	}

	Zt_by `varlist' if `touse', level(`level') `sd1' `sd2' `sd' by(`by')
	
	ret add
end

/* follow _ttest:ByString */
program define Zt_by, rclass
	syntax varlist [if] [in], level(cilevel) by(varname) /*
	*/ [sd(string) sd1(string) sd2(string)]
		
	if (`"`sd'`sd1'`sd2'"' == "" ) {
		local sd1 = 1
		local sd2 = 1
	}

	else if (`"`sd'"'!= "" & (`"`sd1'"'!="" | `"`sd2'"'!=""))  {
		di as err "{p}{bf:sd()} may not be combined "  /*
		*/ "with {bf:sd1()} or {bf:sd2()} {p_end}"
		exit 184
	}
	
	else if (`"`sd'"'!= "" & `"`sd1'`sd2'"'=="")  {
		cap assert `sd' > 0
		if (_rc) {
			di as err "{bf:sd()} must contain positive values"
			exit 411
		}	
		local sd1 = `sd'
		local sd2 = `sd'
	}	
	
	
	else if ((`"`sd1'"' != "" & `"`sd2'"' == "") | /*
	*/ (`"`sd2'"' != "" & `"`sd1'"' == "")) {
		di as err "{p}{bf:sd1()} and {bf:sd2()} must be "  /*
		*/ "specified together{p_end}"
		exit 198
	}	

	else if (`"`sd1'"' != "" & `"`sd2'"' != "") {
		cap assert `sd1' > 0
		if (_rc) {
			di as err "{bf:sd1()} must contain positive values"
			exit 411
		}
		cap assert `sd2' > 0
		if (_rc) {
			di as err "{bf:sd2()} must contain positive values"
			exit 411
		}		
	}	

			
	capture confirm string variable `by'
	if c(rc) {
		Zt_by_number `varlist' `if' `in', level(`level') /*
		*/ by(`by') sd1(`sd1') sd2(`sd2')
	}
	else Zt_by_string `varlist' `if' `in', level(`level')/*
	*/ by(`by') sd1(`sd1') sd2(`sd2')
	ret add
end	

program define Zt_by_string, rclass
	syntax varlist [if] [in], level(cilevel) by(varname) sd1(real) sd2(real)
	marksample touse
	markout `touse' `by', strok

	tempvar obs val1 val2
	
	gen `c(obs_t)' `obs' = _n if `touse'
	sum `obs' if `touse', mean
	if r(N) == 0 {
		noi error 2000
	}

/* get first value */
	scalar `val1' = `by'[r(min)]
	qui replace `obs' = . if `by' == `val1'
	sum `obs', mean
	if r(N) == 0 {
		di in red "1 group found, 2 required"
		exit 420
	}	
	scalar `val2' = `by'[r(min)]
	qui replace `obs' = . if `by' == `val2'
	sum `obs', mean
	if r(N) {
		di in red "more than 2 groups found, only 2 allowed"
		exit 420
	}
	
	
/* Make it so that `val1' < `val2' . */
	if `val1' > `val2' {
		tempname temp
		scalar `temp' = `val1'
		scalar `val1' = `val2'
		scalar `val2' = `temp'	
	}

/* Get #obs, mean for first group */	
	sum `varlist' if `by'==`val1' & `touse', mean
        local n1 = r(N)
        local m1 = r(mean)
/* Get #obs, mean for first group */	
	sum `varlist' if `by'==`val2' & `touse', mean
        local n2 = r(N)
        local m2 = r(mean)

/* Shorten groups labels if necessary. */
	local val1 : display udsubstr(`val1',1,8)
	local val2 : display udsubstr(`val2',1,8)
/* Take substr() again because binary 0 might have expanded to \0 */
	local val1 = udsubstr(`"`val1'"',1,8)
	local val2 = udsubstr(`"`val2'"',1,8)
	
	ztesti `n1' `m1' `sd1' `n2' `m2' `sd2', /*
		*/ xname(`"`val1'"') yname(`"`val2'"') level(`level')
	ret add
end

program define Zt_by_number, rclass
	syntax varlist [if] [in], level(cilevel) by(varname) sd1(real) sd2(real)
	marksample touse
	markout `touse' `by'

	qui sum `by' if `touse', mean
	if r(N) == 0 {
		noi error 2000
	}

	/* check that there are exactly 2 groups */
	local min = r(min)
	local max = r(max)
        if `min' == `max' {
		di in red "1 group found, 2 required"
		exit 420
	}	
        qui count if `by'!=`min' & `by'!=`max' & `touse'   
	if r(N) {
		di in red "more than 2 groups found, only 2 allowed"
		exit 420
	}
	
	
	/* Get #obs, mean for first group */	
	qui sum `varlist' if `by'==`min' & `touse', mean
        local n1 = r(N)
        local m1 = r(mean)
	/* Get #obs, mean for first group */	
	qui sum `varlist' if `by'==`max' & `touse', mean
        local n2 = r(N)
        local m2 = r(mean)
	
	/* Get group labels */
	local lab1 `min'
	local lab2 `max'
	
	local bylab: value label `by'
	if `"`bylab'"'!="" {
		local lab1:label `bylab' `lab1'
		local lab2:label `bylab' `lab2'
	}	
	
	local lab1 = udsubstr(`"`lab1'"',1,8)
	local lab2 = udsubstr(`"`lab2'"',1,8)
	
	ztesti `n1' `m1' `sd1' `n2' `m2' `sd2', /*
		*/ xname("`lab1'") yname("`lab2'") level(`level')
	ret add
end

program define Zt_two, rclass
	syntax varlist [if] [in], level(cilevel) /*
	*/ [sd(string) sd1(string) sd2(string)]
	
	if (`"`sd'`sd1'`sd2'"' == "" ) {
		local sd1 = 1
		local sd2 = 1	
		
	}
	
	else if (`"`sd'"'!= "" & (`"`sd1'"'!="" | `"`sd2'"'!=""))  {
		di as err "{p}{bf:sd()} may not be combined "  /*
		*/ "with {bf:sd1()} or {bf:sd2()} {p_end}"
		exit 184
	}
	
	else if (`"`sd'"'!= "" & `"`sd1'`sd2'"'=="")  {
		cap assert `sd' > 0
		if (_rc) {
			di as err "{bf:sd()} must contain positive values"
			exit 411
		}	
		local sd1 = `sd'
		local sd2 = `sd'
	}	
	
	else if ((`"`sd1'"' != "" & `"`sd2'"' == "") | /*
	*/ (`"`sd2'"' != "" & `"`sd1'"' == "")) {
		di as err "{p}{bf:sd1()} and {bf:sd2()} must be "  /*
		*/ "specified together{p_end}"
		exit 198
	}	

	else if (`"`sd1'"' != "" & `"`sd2'"' != "") {
		cap assert `sd1' > 0
		if (_rc) {
			di as err "{bf:sd1()} must contain positive values"
			exit 411
		}
		cap assert `sd2' > 0
		if (_rc) {
			di as err "{bf:sd2()} must contain positive values"
			exit 411
		}		
	}	
	
		
	marksample touse, novarlist 

        tokenize `varlist'
	qui sum `1' if `touse', mean
        local n1 = r(N)
        local m1 = r(mean)     

	qui sum `2' if `touse', mean
        local n2 = r(N)
        local m2 = r(mean)
 
	ztesti `n1' `m1' `sd1' `n2' `m2' `sd2', /*
		*/ xname("`1'") yname("`2'") level(`level')
	ret add

end

program define Zt_one, rclass
	syntax varname [if] [in], level(cilevel) exp(real) [sd(real 1)] 
	
	if (`sd' <= 0) {
		di as err "{bf:sd()} must contain positive values"
		exit 411		
	}	

        marksample touse
	qui sum `varlist' if `touse', mean
        local n = r(N)
        local m = r(mean)     

	ztesti `n' `m' `sd' `exp', xname("`varlist'") level(`level')
	ret add

end


program define Zt_paired, rclass
	syntax varlist [if] [in], level(cilevel) [sddiff(string) /*
	*/ corr(string) sd(string) sd1(string) sd2(string)]

	/* parse options */
	if (`"`sddiff'"' != "") {
		if ("`corr'`sd1'`sd2'`sd'" != "") {
			di as err /*
		  */ "{p}{bf:corr()}, {bf:sd()}, {bf:sd1()}, and " /*
		  */ "{bf:sd2()} may not be combined with {bf:sddiff()}{p_end}"
			exit 184	
		}

		cap assert `sddiff' > 0
		if (_rc) {
			di as err "{bf:sddiff()} must contain positive values"
			exit 411
		}	
	}
		
		
	else if (`"`sddiff'`corr'"' == "") {
		di as err /*
		*/ "{p}either {bf:corr()} or {bf:sddiff()} must be specified" /*
		*/ " for paired z test {p_end}"
		exit 198
	}
	
	else if (`"`corr'"' != "") {	
		
		cap assert (`corr' >= -1 & `corr' <=1)
		if (_rc) {
			di as err "{p} {bf:corr()} must be between -1" /*
			*/ " and 1, inclusively {p_end}"
			exit 198
		}	
			
		if (`"`sd'`sd1'`sd2'"' == "" ) {
			local sd1 = 1
			local sd2 = 1
		}

		else if (`"`sd'"'!= "" & (`"`sd1'"'!="" | `"`sd2'"'!=""))  {
			di as err "{p}{bf:sd()} may not be combined "  /*
			*/ "with {bf:sd1()} or {bf:sd2()} {p_end}"
			exit 184
		}
	
		else if (`"`sd'"'!= "" & `"`sd1'`sd2'"'=="")  {
			cap assert `sd' > 0
			if (_rc) {
				di as err /*
				   */ "{bf:sd()} must contain positive values"
				exit 411
			}
			local sd1 = `sd'
			local sd2 = `sd'
		}	
	
		else if ((`"`sd1'"' != "" & `"`sd2'"' == "") | /*
		*/ (`"`sd2'"' != "" & `"`sd1'"' == "")) {
			di as err "{p}{bf:sd1()} and {bf:sd2()} must be "  /*
			*/ "specified together{p_end}"
			exit 198
		}	

		else if (`"`sd1'"' != "" & `"`sd2'"' != "") {
			cap assert `sd1' > 0
			if (_rc) {
				di as err /*
				   */ "{bf:sd1()} must contain positive values"
				exit 411
			}
			cap assert `sd2' > 0
			if (_rc) {
				di as err /*
				   */ "{bf:sd2()} must contain positive values"
				exit 411
		}		
	}	
	
		local sddiff = sqrt(`sd1'^2+`sd2'^2-2*`corr'*`sd1'*`sd2')
	
	}	
		
	marksample touse
	tokenize `varlist'
	tempvar diff

	
	quietly {
		summarize `1' if `touse', mean
		local m1 = r(mean)
		summarize `2' if `touse', mean
		local m2 = r(mean)
		
		gen double `diff' = `1' - `2' if `touse'
		summarize `diff', mean
		local n = r(N)
		local m = r(mean)
	
		if `n' == 0  {
			noisily error 2000 
		}
	}
/* Compute statistics. */

        local z  = `m'*sqrt(`n')/`sddiff'
        local se = `sddiff'/sqrt(`n')

        local p = 2 - 2*normal(abs(`z'))
        if `z' < 0 {
                local pl = `p'/2
                local pr = 1 - `pl'
        }
        else {
                local pr = `p'/2
                local pl = 1 - `pr'
        }

/* Display table of mean, std err, etc. */

	di _n in gr "Paired z test"

	_ttest header `level' `1'

	if (`"`corr'"'!="") {
		_ttest table `level' `1' `n' `m1' `sd1' ztest
		_ttest table `level' `2' `n' `m2' `sd2' ztest
		_ttest divline
	}
	_ttest table `level' "diff" `n' `m' `sddiff' ztest

	_ttest botline
	di as txt _col(6) "mean(diff) = mean(" as res /// 
		abbrev(`"`1'"',16) as txt ///
		" - " as res abbrev(`"`2'"',16) as txt ")" ///
		as txt _col(67) "z = " as res %8.4f `z'

/* Display Ho. */

	di as txt " Ho: mean(diff) = 0" _col(50) as txt 

/* Display Ha. */

        local tt : di %8.4f `z'
        local p1 : di %6.4f `pl'
        local p2 : di %6.4f `p'
        local p3 : di %6.4f `pr'

        di
        _ttest center2 "Ha: mean(diff) < 0"  /*
	*/             "Ha: mean(diff) != 0" /*
	*/             "Ha: mean(diff) > 0"

        _ttest center2 "Pr(Z < z) = @`p1'@"   /*
        */             "Pr(|Z| > |z|) = @`p2'@" /*
        */             "Pr(Z > z) = @`p3'@"

/* Save results. */

	ret scalar N_1  = `n'
	ret scalar mu_1 = `m1'
        ret scalar N_2  = `n'
        ret scalar mu_2 = `m2'
	ret scalar z    = `z'
	ret scalar p    = `p'
	ret scalar p_l  = `pl'
	ret scalar p_u  = `pr'
	ret scalar se   = `se'
	ret scalar sd_d = `sddiff'
	if (`"`corr'"' !="") {
		ret scalar corr = `corr'
		ret scalar sd_1 = `sd1'
		ret scalar sd_2 = `sd2'
	}	
	ret scalar level = `level'
end
