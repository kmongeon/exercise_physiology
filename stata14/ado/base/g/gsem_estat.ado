*! version 1.0.2  20jan2015 
program gsem_estat
	version 13

	gettoken cmd : 0, parse(", ")

	if `"`cmd'"' == "eform" {
		gettoken cmd 0 : 0, parse(", ")
		Eform `0'
		exit
	}

	local lcmd : length local cmd

	if `"`cmd'"'==bsubstr("summarize",1,max(2,`lcmd')) { 
		gettoken cmd 0 : 0, parse(", ")
		gsem_estat_summ `0'
		exit
	}

	estat_default `0'
end

program MultList, rclass
	args eq

	local nmult = e(k_mult)
	forval i = 1/`nmult' {
		if "`eq'" != e(mult`i'_name) {
			continue
		}
		local depvar : copy local eq
		local ncats = e(mult`i'_ncats)
		forval j = 1/`ncats' {
			if `j' != e(mult`i'_ibase) {
				local val = el(e(mult`i'_map),1,`j')
				local list `list' `val'.`depvar'
			}
		}
		return local list `"`list'"'
		exit
	}

	return local list "`eq'"
end

program Eform
	syntax [anything(name=eqlist)] [, *]

	foreach eq of local eqlist {
		MultList `eq'
		local list `list' `r(list)'
	}

	estat_eform `list', `options'
end

exit
