*! version 1.0.8  03mar2017
program define export 
	version 12

	gettoken subcmd 0 : 0

	if `"`subcmd'"' == "delim" {
		ExpDelim `macval(0)'
	}
	else if `"`subcmd'"' == "delimi" {
		ExpDelim `macval(0)'
	}
	else if `"`subcmd'"' == "delimit" {
		ExpDelim `macval(0)'
	}
	else if `"`subcmd'"' == "delimite" {
		ExpDelim `macval(0)'
	}
	else if `"`subcmd'"' == "delimited" {
		ExpDelim `macval(0)'
	}
	else if `"`subcmd'"' == "exc" {
		ExpExcel `macval(0)'
	}
	else if `"`subcmd'"' == "exce" {
		ExpExcel `macval(0)'
	}
	else if `"`subcmd'"' == "excel" {
		ExpExcel `macval(0)'
	}
	else if `"`subcmd'"' == "sasxport" {
		ExpSasxport `0'
	}
	else {
		display as error `"export: unknown subcommand "`subcmd'""' 
		exit 198
	}

end

program ExpDelim
	version 13

	export_delimited `macval(0)'
end

program ExpExcel
	version 12

	scalar ExpExcelCleanUp = -1

	capture noi export_excel `macval(0)'
	nobreak {
		local rc = _rc
		if `rc' {
			if scalar(ExpExcelCleanUp) >= 0 {
				mata : export_excel_cleanup()
			}
		}
	}
	scalar drop ExpExcelCleanUp
	exit `rc'
end

program ExpSasxport
	fdasave `0'
end

version 12.0
mata:

void export_excel_cleanup()
{
	_xlbkrelease(st_numscalar("ExpExcelCleanUp"))
}
end
