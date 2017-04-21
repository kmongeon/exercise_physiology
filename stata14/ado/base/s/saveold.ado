*! version 4.1.2  13feb2015

program saveold
	version 14

	local 0 `"using `0'"'

	capture syntax using/ [, noLabel REPLACE ALL ]
	if (_rc) {
		local hasversion 1 
		syntax using/ [, noLabel REPLACE ALL Version(real 13) ]
	}
	else {
		local version 13
		local hasversion 0
	}

	map_to_dtafmt dtafmt : `version'

	if ("`dtafmt'"=="118") {
		di as txt "{p 0 2 2}"
		di as txt "(This is Stata 14. You could have used {bf:save} instead"
		di as txt " of {bf:saveold}.)"
		di as txt "{p_end}"
		save `"`using'"', `label' `replace' `all' 
		exit
	}

	if ("`dtafmt'"=="117") {
		di as txt "(saving in Stata 13 format)"
		if (!`hasversion') {
			di as txt "{p 0 6 2}"
			di as txt "(FYI, {bf:saveold} has options"
			di as txt "{bf:version(12)} and {bf:version(11)} that"
			di as txt "write files in older Stata formats)"
			di as txt "{p_end}"
		}
		save `"`using'"', `label' `replace' `all' dtaformat(117)
		exit
	}

	/* 116 is handled by 117 above.  The formats are the same for 
	   our purposes, and map_to_dtafmt returned 117 in all cases.
	*/

	saveold_115 `"`using'"', `label' `replace' `all' dtafmt(`dtafmt')
end

program map_to_dtafmt
	args macname colon version 

	if (trunc(`version')==14 & `version'<=`c(version)') {
		c_local `macname' 118
		exit
	}
	if (trunc(`version')==13) {
		c_local `macname' 117
		exit
	}
	if (trunc(`version')==12) {
		c_local `macname' 115
		exit
	}
	if (trunc(`version')==11) { 
		c_local `macname' 115-11
		exit
	}

	di as err "version(`version') invalid"
	di as err "{p 4 4 2}"
	if (`version'>`c(version)') {
		di as err "This is Stata `c(version)'. It cannot"
		di as err "write .dta files in future formats"
		di as err "about which it knows nothing."
	}
	else {
		di as err "Stata 14 can write .dta files for Stata 14, 13,"
		di as err "12, or 11."
		di as err "It cannot write .dta formats older than that." 
		di as err "(Stata 11 was released in 2009.)"
	}
	di as err "{p_end}"
	exit 198
end


program define saveold_115
	version 13
	local 0 `"using `0'"'
	syntax using/ [, noLabel REPLACE ALL DTAFMT(string)]
	* preserve 
	foreach var of varlist _all {
		local type : type `var'
		local bad 0
		if `"`type'"' == "strL" {
			local bad 1
		}
		else if bsubstr(`"`type'"',1,3) == "str" {
		    if real(bsubstr(`"`type'"',4,.)) > 244 {
			local bad 1
		    }
		}
		if `bad' {
			di as err					///
			"data cannot be saved in old .dta format"
			di as err					///
			"{p 4 4 2}"					///
			"Data contain {bf:strL} or {bf:str}{it:#}, "	///
			"{it:#}>244, and prior releases of Stata would " ///
			"not know how to process these variables.  "	///
			"Either {bf:drop} the variables or use "	///
			"{bf:recast} with the {bf:force} option "	///
			"to change them to {bf:str244}. "		///
			"{p_end}"
			exit 459
		}
	}
	if ("`dtafmt'"=="115-11") {
		di as txt "{p 0 1 2}"
		di as txt "(saving in Stata 12 format, which Stata 11 can read)"
		di as txt "{p_end}"
	}
	else {
		di as txt "{p 0 1 2}"
		di as txt "(saving in Stata 12 format, which can be read"
		di as txt "by Stata 11 or 12)"
		di as txt "{p_end}"
	}
		
	save `"`using'"', `label' `replace' `all' `intercooled' dtaformat(115)
end
