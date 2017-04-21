*! version 1.0.0  28jan2016
program _bayesmh_check_parameters, sclass
	version 14.0
	
	args par_name par_prefix par_isvar depvar_names eq_names

	tokenize `par_name', parse(`"""')
	local par_name `1'
	tokenize `par_prefix', parse(`"""')
	local par_prefix `1'
	tokenize `par_isvar', parse(`"""')
	local par_isvar `1'
	tokenize `depvar_names', parse(`"""')
	local depvar_names `1'
	tokenize `eq_names', parse(`"""')
	local eq_names `1'

	local var_names
	local npars: word count `par_name'
	local i 1

	mata: _check_duplicates()

	while `i' <= `npars' {
		local name  : word `i' of `par_name'
		local prefix: word `i' of `par_prefix'
		if `"`prefix'"' == "." {
			local ++i
			continue
		}
		local varname `name'
		tokenize `varname', parse(".")
		if `"`1'"' != "" & `"`2'"' == "." {
			local varname `3'
		}
		capture confirm numeric var `varname'
		if _rc == 0 {
			local var_names `var_names' `varname'
		}
		local ++i
	}

	local eqnames
	local neqs: word count `depvar_names'
	local i 1
	while `i' <= `neqs' {
		local name  : word `i' of `depvar_names'
		local prefix: word `i' of `eq_names'
		if `i' > 1 local eqnames `"`eqnames' "'
		if `"`prefix'"' == "." {
			local eqnames `eqnames'`name'
		}
		else {
			local eqnames `eqnames'`prefix'
		}
		local ++i
	}

	sreturn local n_eq	 	= `neqs'
	sreturn local depvar_names	= `"`depvar_names'"'
	sreturn local var_names		= `"`var_names'"'
	sreturn local eq_names		= `"`eqnames'"'
end

mata:
function _check_duplicates() 
{
	real scalar i, j, npars
	string rowvector parname, prefix, isvar
	string scalar iname
	
	parname = tokens(st_local("par_name"))
	prefix = tokens(st_local("par_prefix"))
	isvar = tokens(st_local("par_isvar"))
	npars = length(parname)

	for(i = 1; i <=npars; i++) {
		if (prefix[i] == ".") {
			continue
		}
		iname = parname[i]
		for(j = 1; j <=npars; j++) {
			if (parname[j] == iname & 
				prefix[j] == "." & isvar[j] == "0") {
errprintf("parameter name {bf:%s} not allowed\n", parname[j])
errprintf("all parameters {bf:%s} should be specified equation labels\n", iname)
exit(198)
			}
		}
	}
}
end
