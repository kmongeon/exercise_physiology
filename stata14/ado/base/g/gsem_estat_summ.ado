*! version 1.1.0  10mar2015
program gsem_estat_summ, rclass
	version 13

	if "`e(cmd)'" != "gsem" {
		error 301
	}

	if !missing("`e(cmd2)'") local cmd `e(cmd2)'
	else local cmd `e(cmd)'

	capture assert e(sample)==0
	if !_rc {
		dis as err "e(sample) information not available"
		exit 498
	}

	syntax  [anything(name=eqlist)] [, 	/// ignored
		EQuation			/// ignored
		*				///
		]	
		
	if "`equation'"!="" {
		dis as txt "after `cmd', option equation ignored"
		local equation
	}
	
	if `:length local eqlist' {
		local vlist `eqlist'
	}
	else {
		local vlist `"`e(depvar)' `: colna e(b)'"'	
		local vlist : list uniq vlist
		local vlist : subinstr local vlist "bn." ".", all
		local Llist `"`e(REspec)' o._cons _cons"'
		local vlist : list vlist - Llist
		fvrevar `vlist', list
		confirm numeric variable `r(varlist)' 
	}

	estat_summ `vlist' , `options'
	return add
end

exit
