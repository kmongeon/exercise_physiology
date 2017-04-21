*! version 1.0.0  26mar2014
program ztesti, rclass
	version 14

/* Parse. */

	gettoken 1 0 : 0 , parse(" ,")
	gettoken 2 0 : 0 , parse(" ,")
	gettoken 3 0 : 0 , parse(" ,")
	gettoken 4 0 : 0 , parse(" ,")
	gettoken 5 : 0 , parse(" ,")

	if "`5'"=="" | "`5'"=="," { /* Do one-sample test */

		local args1 "`1' `2' `3' `4'"
		syntax [, Xname(string) Yname(string) Level(cilevel)]

/* call _ttest check ztest ...*/
                _ttest check ztest one `args1' /* check numbers */

                OneTest `args1' `level' `"`xname'"'
		ret add

                exit
        }

/* Here only if two-sample test. */

	gettoken 5 0 : 0 , parse(" ,")
	gettoken 6 0 : 0 , parse(" ,")
        local arg1 "`1' `2' `3'"
        local arg2 "`4' `5' `6'"
	syntax [, Xname(string) Yname(string) Level(cilevel)]

        _ttest check ztest first  `arg1' /* check numbers */
        _ttest check ztest second `arg2' /* check numbers */

        TwoTest `arg1' `arg2' `level' `"`xname'"' `"`yname'"' 
	ret add
end

program define OneTest, rclass
	args n m s m0 level xname

/* Compute statistics. */

	local z = (`m' - `m0')*sqrt(`n')/`s'
	local se = `s'/sqrt(`n')

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

	di _n in gr "One-sample z test"

	_ttest header `level' `"`xname'"'

	if `"`xname'"'=="" {
		local xname "x" 
	}

	_ttest table `level' `"`xname'"' `n' `m' `s' 1
	_ttest botline

/* Display Ho. */

	if length("`m0'") > 8 {
		local m0 : di %8.0g `m0'
		local m0 = trim("`m0'")
	}

	
	di as txt "    mean = mean(" as res `"`xname'"' as txt ")" ///
		_col(67) as txt "z = " as res %8.4f `z'

	di as txt "Ho: mean = " as res `"`m0'"' _col(50) as txt

/* Display Ha. */

	local p1 : di %6.4f `pl'
        local p2 : di %6.4f `p'
        local p3 : di %6.4f `pr'
	

        di
        _ttest center2 "Ha: mean < @`m0'@"  /*
	*/             "Ha: mean != @`m0'@" /*
	*/             "Ha: mean > @`m0'@"

	_ttest center2 "Pr(Z < z) = @`p1'@"   /*
	*/             "Pr(|Z| > |z|) = @`p2'@" /*
	*/             "Pr(Z > z) = @`p3'@"

	/* double save in S_# and r() */
	
	ret scalar N_1  = `n'
	ret scalar mu_1 = `m'
	ret scalar z    = `z'
	ret scalar p    = `p'
	ret scalar p_l  = `pl'
	ret scalar p_u  = `pr'
	ret scalar se   = `se'
	ret scalar sd_1 = `s'
	ret scalar level = `level'
	
end	

program define TwoTest, rclass
	args n1 m1 s1 n2 m2 s2 level xname yname 

/* Compute statistics. */

	local se = sqrt((`s1')^2/`n1' + (`s2')^2/`n2')
	local z  = (`m1'-`m2')/`se'
	
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

	di _n in gr "Two-sample z test"

	_ttest header `level' `"`xname'"'

	if `"`xname'"'=="" {
		local xname "x"
	}
	if `"`yname'"'=="" {
		local yname "y" 
	}
	_ttest table `level' `"`xname'"' `n1' `m1' `s1' 1
	_ttest table `level' `"`yname'"' `n2' `m2' `s2' 1
	_ttest divline

/* Display difference. */

	_ttest dtable `level' "diff" . `m1'-`m2' `se' . 1

	_ttest botline

	
/* Display error messages. */


/* Display Ho. */

	di as txt _col(5) "diff = mean(" as res abbrev(`"`xname'"',16) ///
		as txt ") - mean(" as res abbrev(`"`yname'"',16) ///
		as txt ")" _col(67) ///
		as txt "z = " as res %8.4f `z'
	di as txt "Ho: diff = 0"

/* Display Ha. */

	local p1 : di %6.4f `pl'
        local p2 : di %6.4f `p'
        local p3 : di %6.4f `pr'

        di
        _ttest center2 "Ha: diff < 0" "Ha: diff != 0" "Ha: diff > 0"

	_ttest center2 "Pr(Z < z) = @`p1'@"   /*
	*/             "Pr(|Z| > |z|) = @`p2'@" /*
	*/             "Pr(Z > z) = @`p3'@"

	/* save r() */
        ret scalar N_1  = `n1'
        ret scalar mu_1 = `m1'
        ret scalar N_2  = `n2'
        ret scalar mu_2 = `m2'
        ret scalar z    = `z'
        ret scalar p    = `p'
        ret scalar p_l  = `pl'
        ret scalar p_u  = `pr'
        ret scalar se   = `se'
        ret scalar sd_1 = `s1'
        ret scalar sd_2 = `s2'
	ret scalar level = `level'

end

