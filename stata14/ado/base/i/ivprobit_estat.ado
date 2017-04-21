*! version 2.0.2  19oct2015
program define ivprobit_estat, rclass
	local vcaller = string(_caller())
	version 9
	if "`e(cmd)'" != "ivprobit" {
		error 301
	}
	gettoken subcmd rest : 0, parse(", ")
	local subcmd : list retokenize subcmd
	local k = strlen("`subcmd'")
	if (!`k') {
		di as err "subcommand required"
		exit 198
	}
	if "`subcmd'" == bsubstr("covariance",1,max(3,`k')) {
		Cov `rest'
	}
	else if "`subcmd'" == bsubstr("correlation",1,max(3,`k')) {
		Cor `rest'
	}
	else {
		version `vcaller': probit_estat `0'
	}
	return add 
end

program define Cov, rclass
	syntax, [ * ]

	tempname cov

	if "`e(method)'" == "twostep" {
		di as err "not available after {bf:ivprobit, twostep}"
		exit 322
	}

	mat `cov' = e(Sigma)

	Matlist `cov', `options'

	return mat cov = `cov'
end

program define Cor, rclass
	syntax, [ * ]

	tempname cor sig

	if "`e(method)'" == "twostep" {
		di as err "not available after {bf:ivprobit, twostep}"
		exit 322
	}

	mat `cor' = e(Sigma)
	local lab : colfullnames `cor'
	mata: st_matrix("`sig'",diag(1:/sqrt(diagonal(st_matrix("`cor'")))))
	mat `cor' = `sig'*`cor'*`sig'
	mat `cor' = 0.5*(`cor'+`cor'')
	mat colnames `cor' = `lab'
	mat rownames `cor' = `lab'

	Matlist `cor', `options'

	return mat cor = `cor'
end

program Matlist
	syntax namelist(min=1 max=1), [ FORmat(passthru) left(integer 2) * ]

	if "`options'" != "" {
		ParseBorder, `options'

		local border `s(border)'
	}
	matlist `namelist', title(`title') `format' `border' left(`left')
end

program define ParseBorder, sclass
	syntax, [ BORder(passthru) * ]

	local 0, `options'
	if "`border'" != "" {
		if "`options'" != "" {
			gettoken options rest : options, bind
			di as err "option `options' not allowed"
			exit 198
		}
	}
	else {
		syntax, [ BORder ]
	}
	sreturn local border `border'
end
exit
