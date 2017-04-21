*! version 1.0.7  23feb2016
program define export_delimited
	version 13

	capture syntax [varlist] using/ [if] [in] [, *]
	if _rc {
		local orig0 `"`0'"'
		local 0 `"using `0'"'
		cap syntax using/ [if] [in] [, *]
		if _rc {
			if _rc == 111 {
				dis as err `"variable(s) not defined"'
				exit 111
			}
			local 0 `"`orig0'"'
			syntax [varlist] using/ [if] [in]		///
				[, DELIMiter(string)			///
				NOVARnames				///
				NOLABel					///
				DATAFmt					///
				Quote					///
				REPLACE]
		}
		else {
			syntax using/ [if] [in]				///
				[, DELIMiter(string)			///
				NOVARnames				///
				NOLABel					///
				DATAFmt					///
				Quote					///
				REPLACE]
		}
	}
	else {
		syntax [varlist] using/ [if] [in]			///
			[, DELIMiter(string)				///
			NOVARnames					///
			NOLABel						///
			DATAFmt						///
			Quote						///
			REPLACE]
	}
	if (`"`varlist'"'=="") {
		unab varlist : _all
	}

	mata : export_delim_export_file()
end

version 13.0
mata:
mata set matastrict on

struct _export_delim_parse_info {
	string scalar		filename
	string scalar		op_varlist
	string scalar		op_if
	string scalar		op_in
	string scalar		op_delimiter
	real scalar		op_novarnames
	real scalar		op_novallabel
	real scalar		op_datafmt
	real scalar		op_quote
	real scalar		op_replace
}

void export_delim_export_file()
{
	struct _export_delim_parse_info scalar pr

	export_delim_pr_init(pr)
	export_delim_parse_syntax(pr)
	export_delim_write_file(pr)
}

void export_delim_pr_init(struct _export_delim_parse_info scalar pr)
{
	pr.filename = ""
	pr.op_varlist = ""
	pr.op_if = ""
	pr.op_in = ""
	pr.op_delimiter = ""
	pr.op_novarnames = 0
	pr.op_novallabel = 0
	pr.op_datafmt = 0
	pr.op_quote = 0
	pr.op_replace = 0
}

void export_delim_parse_syntax(struct _export_delim_parse_info scalar pr)
{
	export_excel_build_filename(pr)

	pr.op_varlist = st_local("varlist")
	pr.op_if = st_local("if")
	pr.op_in = st_local("in")

	if (st_local("delimiter") != "") {
		export_excel_parse_delimiter(pr)
	}

	pr.op_novarnames = (st_local("novarnames") != "")
	pr.op_novallabel = (st_local("nolabel") != "")
	pr.op_datafmt = (st_local("datafmt") != "")
	pr.op_quote = (st_local("quote") != "")
	pr.op_replace = (st_local("replace") != "")
}

void export_excel_build_filename(struct _export_delim_parse_info scalar pr)
{
	string scalar		default_filetype
	string scalar		using_file, file, path
	string scalar		HoldPWD, basename
	real scalar		rc

	file =  ""
	path = ""
	using_file = st_local("using")
	basename = pathbasename(using_file)

	if(basename=="") {
		errprintf("%s not a valid filename\n", using_file)
		exit(198)
	}
/*
	if (bsubstr(using_file, 1, 1)=="~") {
		if (st_global("c(os)")!="Windows") {
			(void) pathsplit(using_file, path, file)
			HoldPWD = pwd()
			rc = _chdir(path)
			if (rc == 0) {
				path = pwd()
			}
			else {
				errprintf("invalid path :%s", path)
				exit(170)
			}
			chdir(HoldPWD)
		}
		using_file = pathjoin(path, file)
	}
*/

	default_filetype = ".csv"
	if(pathsuffix(using_file) == "") {
		using_file = using_file + default_filetype
	}

	using_file = prochome(using_file, 0)

	pr.filename = using_file
}

void export_excel_parse_delimiter(struct _export_delim_parse_info scalar pr)
{
	string scalar		delimiter

	delimiter = st_local("delimiter")

	if (delimiter == "tab") {
		pr.op_delimiter = "tab"
		return
	}
	if (strlen(delimiter)>1) {
errprintf("{bf:%s} invalid character in {bf:delimiter()} option\n", delimiter)
		exit(198)
	}
	pr.op_delimiter = sprintf(`"delimiter(`"%s"')"', delimiter)
}

void export_delim_write_file(struct _export_delim_parse_info scalar pr)
{
	real scalar		rc, opts
	string scalar		quote, cmd, options

	quote = `"""'
	rc = _stata(sprintf("quietly confirm new file %s%s%s",
		quote, pr.filename, quote), 1)

	if (rc & !pr.op_replace) {
		errprintf("file {bf:%s} already exists\n", pr.filename)
		exit(602)
	}

	cmd = sprintf("%s using %s%s%s %s %s", pr.op_varlist, quote,
		pr.filename, quote, pr.op_if, pr.op_in)

	opts = pr.op_novarnames + pr.op_novallabel + pr.op_datafmt + pr.op_quote

	if (strlen(pr.op_delimiter)>0 | opts | pr.op_replace) {
		options = ", "
	}

	if (pr.op_delimiter != "") {
		options = options + pr.op_delimiter
	}
	if (pr.op_novarnames) {
		options = options + " nonames"
	}
	if (pr.op_novallabel) {
		options = options + " nolabel"
	}
	if (pr.op_datafmt) {
		options = options + " datafmt"
	}
	if (pr.op_quote) {
		options = options + " quote"
	}
	if (pr.op_replace) {
		options = options + " replace"
	}

//	printf("%s %s\n", cmd, options)

	rc = _stata(sprintf("_export_delimited %s %s", cmd, options))
	if (rc) {
		exit(603)
	}
	printf("{txt}file %s saved\n", pr.filename)
}

end
