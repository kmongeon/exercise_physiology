*! version 1.4.1  13feb2015
program sem_display
	version 12

	if "`e(cmd)'" != "sem" {
		error 301
	}
	if _by() {
		error 190
	}

	if "`e(prefix)'" != "" {
		_prefix_display `0'
	}
	else	Display `0'
end

program Display
	syntax [,	STANDardized		///
		  	SHOWGinvariant		///
			noLABel			///
			NOFVLABel		///
			FVLABel			///
		  	noHEADer		///
		  	noTABLE			///
		  	noFOOTnote		///
			wrap(numlist max=1)	///
			fvwrap(passthru)	///
		  	*			///
	]

	if "`wrap'" != "" {
		opts_exclusive `"wrap(`wrap') `fvwrap'"'
		local fvwrap fvwrap(`wrap')
	}
	if "`label'" != "" {
		opts_exclusive "`label' `fvlabel'"
		local fvlabel nofvlabel
	}
	else {
		local fvlabel `nofvlabel' `fvlabel'
	}

	_get_diopts diopts, `options' `fvwrap' `fvlabel'

	local header = "`header'" == ""
	if `header' {
		Header, `standardized'
	}
	local blank `header'

	if ("`table'" == "") {
		if `blank' {
			di
			local blank 0
		}
		if "`standardized'" != "" {
			if "`e(groupvar)'" != "" {
				local showginvariant showginvariant
			}
		}
		if e(estimates) == 0 {
			local coefl coeflegend selegend
			local coefl : list diopts & coefl
			if `"`coefl'"' == "" {
				local diopts `diopts' coeflegend
			}
		}
		_coef_table,			///
			cmdextras		///
			`standardized'		///
			`showginvariant'	///
			`footnote'		///
			`diopts'
	}

	if "`footnote'"=="" { 
		if `blank' {
			di
		}
		Footer
	}

end

program Header
	syntax [, STANDardized]
	local c1  _col( 1)
	local c2  _col(20)
	local c3  _col(49)
	local c4  _col(67)

	local ffmt "%10.0fc"
	local gfmt "%10.0g"

	di
	di 	 as txt "`e(title)'"					///
	    `c3' as txt "Number of obs" 				///
	    `c4' as txt "= " as res `ffmt' e(N)

	local crtype = upper(bsubstr(`"`e(crittype)'"',1,1)) + 		///
			bsubstr(`"`e(crittype)'"',2,.)

	if e(N_groups) > 1 {
		local gvar `e(groupvar)'
        	di `c1' as txt "Grouping variable"			///
        	   `c2' as txt "= " as res abbrev("`gvar'",16)		///
        	   `c3' as txt "Number of groups"  			///
        	   `c4' as txt "= " as res `ffmt' e(N_groups)
	}

	di `c1' as txt "Estimation method"  				///
	   `c2' as txt "= " as res e(method)

	if `"`e(critvalue)'"' != "" {
		di `c1' as txt "`crtype'" `c2' "= " as res `gfmt' e(critvalue)
	}

end

program Footer 
	if  "`e(chi2type_note)'" != "" {
		di as txt "{p 0 6 2 79}"
		di as txt "Note: The `e(chi2type_note)' test of model"
		di as txt "vs. saturated is not reported because the"
		if e(df_s) < e(dim_s) {
			di as txt "saturated model is not full rank."
		}
		else {
			di as txt "fitted model is not full rank."
		}
		di as txt "{p_end}"
	}
	else if  "`e(chi2type_ms)'" != "" {
		local df   : display       `e(df_ms)'
		if "`e(chi2type_ms)'" == "Discr." {
			local chi2 : display %8.2f `e(chi2_ms)'
		}
		else {
			local chi2 : display %9.2f `e(chi2_ms)'
		}
		local sk   _skip(`=3-strlen("`df'")')

		dis as txt  "`e(chi2type_ms)' test of model vs. saturated:" ///
			    " chi2({res:`df'}) " `sk' "= {res:`chi2'}, "    ///
			    "Prob > chi2 = " as res %6.4f e(p_ms)
	}
	if e(sbentler) == 1 {
		local chi2sb : display %9.2f `e(chi2sb_ms)'
		dis as txt "Satorra-Bentler scaled test:   " ///
			   " chi2({res:`df'}) " `sk' "= {res:`chi2sb'}, " ///
			   "Prob > chi2 = " as res %6.4f e(psb_ms)
	}
	if e(estimates) == 0 {
		di as txt "{p 0 6 2 79}"
		di as txt "Note: The above coefficient values are starting"
		di as txt "values and not the result of a fully fitted model."
		di as txt "{p_end}"
	}
	ml_footnote
end

exit
