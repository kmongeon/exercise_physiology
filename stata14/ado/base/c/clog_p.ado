*! version 1.3.0  25feb2015
program define clog_p
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
				STDF STDP STDR CONstant(varname) 
			SE:
				Index XB STDP CONstant(varname)
		*/
	local myopts "Pr"

		/* Step 2:
			call _propts, exit if done, 
			else collect what was returned.
		*/
	_pred_se "`myopts'" `0'
	if `s(done)' { exit }
	local vtyp  `s(typ)'
	local varn `s(varn)'
	local 0 `"`s(rest)'"'


		/* Step 3:
			Parse your syntax.
		*/
	syntax [if] [in] [, `myopts' noOFFset]

	if "`pr'"=="" {
		di in smcl in gr "(option {bf:pr} assumed; Pr(`e(depvar)'))"
	}
	tempvar tt
	qui _predict double `vtyp' `tt' `if' `in', `offset' xb
	gen double `vtyp' `varn' = 1 - exp(-exp(`tt'))
	label var `varn' "Pr(`e(depvar)')"
end