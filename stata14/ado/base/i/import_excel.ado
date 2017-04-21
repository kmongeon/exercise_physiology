*! version 1.0.13  03mar2017
program define import_excel
	version 12

	if ("`c(excelsupport)'" != "1") {
		dis as err `"import excel is not supported on this platform."'
		exit 198
	}

	gettoken filename rest : 0, parse(" ,")
	gettoken comma : rest, parse(" ,")

	if (`"`filename'"' != "" & (trim(`"`comma'"') == "," |		///
		trim(`"`comma'"') == "")) {
		local 0 `"using `macval(0)'"'
	}

	capture syntax using/, DESCribe
	if _rc {
		capture syntax using/					///
			[, SHeet(string)				///
			CELLRAnge(string)				///
			FIRSTrow					///
			ALLstring					///
			case(string)					///
			locale(string)					///
			clear]
		if _rc {
		syntax [anything(name=extvarlist id="extvarlist" equalok)] ///
			using/						///
			[, SHeet(string)				///
			CELLRAnge(string)				///
			FIRSTrow					///
			ALLstring					///
			locale(string)					///
			clear]
		}
	}
	mata : import_excel_import_file()
end

