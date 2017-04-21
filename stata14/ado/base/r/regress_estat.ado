*! version 1.1.3  20jan2015
program regress_estat, rclass
	version 9

	local ver : di "version " string(_caller()) ", missing :"

	if "`e(cmd)'" != "regress" {
		error 301
	}

	gettoken key rest : 0, parse(", ")
	local lkey = length(`"`key'"')

/* Regular */
	if `"`key'"' == bsubstr("ovtest",1,max(3,`lkey')) {
		`ver' ovtest `rest'
	}
	else if `"`key'"' == bsubstr("hettest",1,max(4,`lkey')) {
		hettest `rest'
	}
	else if `"`key'"' == bsubstr("szroeter",1,max(3,`lkey')) {
		szroeter `rest'
	}
	else if `"`key'"' == bsubstr("vif",1,max(3,`lkey')) {
		`ver' vif `rest'
	}
	else if `"`key'"' == bsubstr("imtest",1,max(3,`lkey')) {
		`ver' imtest `rest'
	}
	else if `"`key'"' == bsubstr("esize",1,max(3,`lkey')) {
		if _caller() < 13 {
			di as err ///
			"estat esize not allowed after regress run with version < 13"
			exit 301
		}
		else {
			estat_esize `rest'
		}
	}

/* Time series */
	else if `"`key'"' == bsubstr("dwatson",1,max(3,`lkey')) {
		dwstat `rest'
	}
	else if `"`key'"' == bsubstr("durbinalt",1,max(3,`lkey')) {
		durbina `rest'
	}
	else if `"`key'"' == bsubstr("bgodfrey",1,max(3,`lkey')) {
		bgodfrey `rest'
	}
	else if `"`key'"' == bsubstr("archlm",1,max(6,`lkey')) {
		archlm `rest'
	}
	else if `"`key'"' == "sbknown" | `"`key'"' == "sbsingle" {
		if _caller() < 13 {
			di as err "{p}estat `key' not allowed after regress"
			di as err "run with version < 13{p_end}"
			exit 301
		}
		else `key' `rest'
	}

/* Default */
	else {
		estat_default `0'
	}
	return add
end
