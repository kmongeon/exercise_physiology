*! version 1.0.11  07jun2015
program define import
	version 12
	local version : di "version " string(_caller()) ":"

	gettoken subcmd 0 : 0, parse(" ,")

	if `"`subcmd'"' == "delim" {
		`version' ImpDelim `macval(0)'
	}
	else if `"`subcmd'"' == "delimi" {
		`version' ImpDelim `macval(0)'
	}
	else if `"`subcmd'"' == "delimit" {
		`version' ImpDelim `macval(0)'
	}
	else if `"`subcmd'"' == "delimite" {
		`version' ImpDelim `macval(0)'
	}
	else if `"`subcmd'"' == "delimited" {
		`version' ImpDelim `macval(0)'
	}
	else if `"`subcmd'"' == "exc" {
		ImpExcel `macval(0)'
	}
	else if `"`subcmd'"' == "exce" {
		ImpExcel `macval(0)'
	}
	else if `"`subcmd'"' == "excel" {
		ImpExcel `macval(0)'
	}
	else if `"`subcmd'"' == "hav" {
		ImpHaver `macval(0)'
	}
	else if `"`subcmd'"' == "have" {
		ImpHaver `macval(0)'
	}
	else if `"`subcmd'"' == "haver" {
		ImpHaver `macval(0)'
	}
	else if `"`subcmd'"' == "sasxport" {
		ImpSasxport `macval(0)'
	}
	else {
		display as error `"import: unknown subcommand "`subcmd'""'
		exit 198
	}

end

program ImpDelim
	version 13
	local version : di "version " string(_caller()) ":"
	`version' import_delimited `macval(0)'
end

program ImpExcel
	version 12

	scalar ImpExcelCleanUp = -1
	capture noi import_excel `macval(0)'

	nobreak {
		local rc = _rc
		if `rc' {
			if ImpExcelCleanUp >= 0 {
				mata : import_excel_cleanup()
			}
		}
	}
	scalar drop ImpExcelCleanUp
	exit `rc'
end

program ImpHaver
	version 12

	capture noi import_haver `macval(0)'

	nobreak {
		local rc = _rc
		if `rc' {
			mata : import_haver_cleanup()
		}
	}
	exit `rc'
end

program ImpSasxport
	capture syntax [anything] , Describe [*]
	if _rc==0 {
		fdadescribe `anything', `options'
		exit
	}

	fdause `macval(0)'
end

version 12.0
mata:

void import_excel_cleanup()
{
	_xlbkrelease(st_numscalar("ImpExcelCleanUp"))
}

void import_haver_cleanup()
{
	if (st_global("c(os)") == "Windows") {
		(void) _haver_set_aggregation(0)
		(void) _haver_close_db()
	}
}


end

