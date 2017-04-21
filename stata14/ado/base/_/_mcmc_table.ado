*! version 1.0.3  19sep2016
program _mcmc_table
	version 14.0
	gettoken cmd 0 : 0
	_mcmc_table_`cmd' `0'
end

program _mcmc_table_summary, sclass
	version 14.0

	args numpars parnames clevel citype mcmcsum diopts shorttable 

	capture confirm matrix `mcmcsum'
	if c(rc) != 0 {
		exit 198
	}
	
	tempname newparnames mtemp
	
	// check if all parameters have the same label 
	local `newparnames' ""
	local label ""
	tokenize `"`parnames'"'
	while "`*'" != "" {
		gettoken lab name: 1, parse(":")
		if `"`lab'"' != `"`1'"' {
	 	   local name = bsubstr(`"`name'"',2,bstrlen(`"`name'"'))
	 	   local `newparnames' `"``newparnames''`name' "'
	 	   if `"`label'"' == "" local label `lab'
	 	   else if `"`label'"' != `"`lab'"' local label .
		}
		else {
	 	   local `newparnames' `"``newparnames''`1' "'
	 	   local label .
		}
		mac shift
	}

	if `"`shorttable'"' != "" {
		matrix `mtemp' = `mcmcsum'[.,1..3]
		quietly _matrix_table `mtemp',		///
			formats(%9.0g %9.5f %9.0g)	///
			notitles `diopts'
	}
	else {
		quietly _matrix_table `mcmcsum',			///
			formats(%9.0g %9.0g %8.0g %9.0g %9.0g %9.0g)	///
			notitles `diopts'
	}
	
	capture matrix rownames `mcmcsum' = `parnames'
	if _rc {
		matrix rownames `mcmcsum' = `parnames'
	}
	
	local clinesize  = `s(width)'
	local col1len	 = `s(width_col1)'

	local col1sep	 = `col1len' + 1
	local parnamelen = `col1len' - 1

	local ncint   = string(100*`clevel')
	local strcint = `"[`ncint'% Cred. Interval]"'
	local nlen    = bstrlen("`strcint'")
	if `nlen' > 20 {
		local strcint = `"[`ncint'% Cred. Int.]"'
		local nlen    = bstrlen(`"`strcint'"')
	}
	if `nlen' > 20 {
		local strcint = `"[`ncint'% CI]"'
		local nlen    = bstrlen(`"`strcint'"')
	}
	local nlen1    = floor(`nlen'/2)
	local strcint1 = bsubstr(`"`strcint'"', 1, `nlen1')
	local strcint2 = ///
		bsubstr(`"`strcint'"',  bstrlen(`"`strcint1'"')+1, `nlen')
	
	if `nlen1' < 10 {
		local strcint2 = `"`strcint2'"' + /// 
			bsubstr("	 	 ", 1, 10-`nlen1')
	}

	local ncint   = `col1len' + 56 - floor(bstrlen("`strcint'")/2)
	local ncikind = `col1len' + 56 - floor(bstrlen("`citype'") /2)

	local hpadlength = `clinesize' - `col1len' - 1

	/* extra separation line */
	di " "

	if `"`shorttable'"' != "" {
		di as txt "{hline `col1len'}"	///
		   _col(`col1sep') "{c TT}" "{hline `=`hpadlength'+1'}" 
	}
	else {
		di as txt  "{hline `col1len'}"	///
			_col(`col1sep') "{c TT}" "{hline `hpadlength'}"	///
			_newline _col(`col1sep') as txt "{c |}"	 	///
			_col(`ncikind') as txt "`citype'"	 
	}

	if "`label'" != "." & `"`label'"' != "" {
		local nlab = udstrlen(`"`label'"')
		if `nlab' > `col1len' {
	 	   local label = udsubstr(`"`label'"',1,`col1len'-1) + "~"
	 	   local nlab 0
		}
		else local nlab = `col1len' - `nlab'
		di as txt _col(`nlab') `"`label'"' _col(`col1sep') as txt "{c |}" _c
		matrix roweq	`mcmcsum' = ""
		matrix rownames `mcmcsum' = ``newparnames''
	}
	else {
		di as txt _col(`col1sep') "{c |}" _c
		matrix rownames `mcmcsum' = `parnames'
	}

	if `"`shorttable'"' != "" {
		local meanpos = `col1sep' +  3 + 4
		local sdpos   = `col1sep' + 14 + 1
		local mcsepos = `col1sep' + 27 + 3
		di  _col(`meanpos') as txt "Mean"		///
			_col(`sdpos')   as txt "Std. Dev."	///
			_col(`mcsepos') as txt "MCSE"
	}
	else {
		local meanpos = `col1sep' + 3 + 4
		local sdpos   = `col1sep' + 14
		local mcsepos = `col1sep' + 27 + 1
		local medpos  = `col1sep' + 37
		di  _col(`meanpos') as txt "Mean"		///
			_col(`sdpos')   as txt "Std. Dev."	///
			_col(`mcsepos') as txt "MCSE"		///
			_col(`medpos')  as txt "Median"		///
			_col(`ncint')   as txt "`strcint'"
	}

	_ms_build_info `mcmcsum', row
	if `"`shorttable'"' != "" {
		matrix `mtemp' = `mcmcsum'[.,1..3]
		_matrix_table `mtemp',			///
			formats(%9.0g %10.5f %9.0g)	///
			notitles `diopts'
	}
	else {
		_matrix_table `mcmcsum',				///
			formats(%9.0g %9.0g %8.0g %9.0g %9.0g %9.0g)	///
			notitles `diopts'
	}

	exit
end

program _mcmc_table_ess
	args numpars parnames essmat diopts

	capture confirm matrix `essmat'
	if c(rc) != 0 {
		exit 198
	}
	
	tempname newparnames mtemp
	local fmts %10.2f %11.2f %12.4f	
	// check if all parameters have the same label
	local `newparnames' ""
	local label ""
	tokenize `"`parnames'"'
	while "`*'" != "" {
		gettoken lab name: 1, parse(":")
		if `"`lab'"' != `"`1'"' {
	 	   local name = bsubstr(`"`name'"',2,bstrlen(`"`name'"'))
	 	   local `newparnames' `"``newparnames''`name' "'
	 	   if `"`label'"' == "" local label `lab'
	 	   else if `"`label'"' != `"`lab'"' local label .
		}
		else {
	 	   local `newparnames' `"``newparnames''`1' "'
	 	   local label .
		}
		mac shift
	}

	quietly _matrix_table `essmat',		///
		formats(`fmts')			///
		notitles `diopts'

	local clinesize = `s(width)'
	local col1len   = `s(width_col1)'

	local col1sep	 = `col1len' + 1
	local parnamelen = `col1len' - 1

	local hpadlength = `clinesize' - `col1len' - 1

	// extra separation line 
	di " "
	
	di "{hline `col1len'}" _col(`col1sep') "{c TT}" "{hline `hpadlength'}" 

	if "`label'" != "." & `"`label'"' != "" {
		local nlab = udstrlen(`"`label'"')
		if `nlab' > `parnamelen' {
	 	   local label = udsubstr(`"`label'"',1,`parnamelen'-1) + "~"
	 	   local nlab 0
		}
		else local nlab = `parnamelen' - `nlab'
		di  _col(`nlab') as txt `"`label'"'	///
			_col(`col1sep') as txt "{c |}" _c
		matrix roweq	`essmat' = ""
		matrix rownames `essmat' = ``newparnames''
	}
	else {
		di  _col(`col1sep') as txt "{c |}" _c
		matrix rownames `essmat' = `parnames'
	}

	local esspos = `col1len' + 10
	local corpos = `col1len' + 16
	local effpos = `col1len' + 30
	di  _col(`esspos') as txt "ESS"	 	 	///
		_col(`corpos') as txt "Corr. time"	///
		_col(`effpos') as txt "Efficiency"

	_ms_build_info `essmat', row
	_matrix_table `essmat', formats(`fmts') notitles `diopts'
	
end
