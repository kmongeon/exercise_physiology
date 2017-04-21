*! version 1.3.0  01mar2015
program define poisso_p
	version 6, missing

	syntax [anything] [if] [in] [, SCores * ]
	if `"`scores'"' != "" {
		ml score `0'
		exit
	}

		/* Step 1:
			place command-unique options in local myopts
			Note that standard options are
			LR:
				Index XB Cooksd Hat
				REsiduals RSTAndard RSTUdent
				STDF STDP STDR noOFFset
			SE:
				Index XB STDP noOFFset
		*/
	local myopts "N IR Pr(string)"

		/* Step 2:
			call _propts, exit if done,
			else collect what was returned.
		*/
	_pred_se "`myopts'" `0'
	if `s(done)' {
		exit
	}
	local vtyp  `s(typ)'
	local varn `s(varn)'
	local 0 `"`s(rest)'"'

		/* Step 3:
			Parse your syntax.
		*/
	syntax [if] [in] [, `myopts' noOFFset]

		/* Step 4:
			Concatenate switch options together
		*/
	local type "`n'`ir'"
	local args `"`pr'"'
	if "`pr'" != "" {
		local propt pr(`pr')
	}
		/* Step 5:
			quickly process default case if you can
			Do not forget -nooffset- option.
		*/

		/* Step 6:
			mark sample (this is not e(sample)).
		*/
	marksample touse


		/* Step 7:
			handle options that take argument one at a time.
			Comment if restricted to e(sample).
			Be careful in coding that number of missing values
			created is shown.
			Do all intermediate calculations in double.
		*/


		/* Step 8:
			handle switch options that can be used in-sample or
			out-of-sample one at a time.
			Be careful in coding that number of missing values
			created is shown.
			Do all intermediate calculations in double.
		*/

	if ("`type'"=="" & `"`args'"'=="") | "`type'"=="n" {
		if "`type'"=="" {
			di in smcl in gr /*
			*/ "(option {bf:n} assumed; predicted number of events)"
		}
		tempvar xb
		qui _predict double `xb' if `touse', xb `offset'
		gen `vtyp' `varn' = exp(`xb') if `touse'
		label var `varn' "Predicted number of events"
		exit
	}

	if "`type'"=="ir" {
		tempvar xb
		qui _predict double `xb' if `touse', xb nooffset
		gen `vtyp' `varn' = exp(`xb') if `touse'
		label var `varn' "Predicted incidence rate"
		exit
	}
	local type `type'
	if `"`args'"'!="" {
		if "`type'" != "" {
			error 198
		}
		tpredict_p2 "`vtyp'" "`varn'" "`touse'" "`offset'" "`pr'"
		exit
	}

	error 198
end

