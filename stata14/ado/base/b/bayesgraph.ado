*! version 1.0.5  22aug2016
version 14.0

program bayesgraph, eclass
	local version : di "version " string(_caller()) ", missing :"

	mata: getfree_mata_object_name("mcmcobject", "g_mcmc_model")

	// load parameters sorted by eqnames in global macros 
	// to be used by _mcmc_fv_decode in _mcmc_expand_paramlist
	_bayesmh_eqlablist import
	
	// trim white space
	local 0 `0'
	syntax [anything] [,*]
	
	capture noi _bayesgraph `anything', mcmcobject(`mcmcobject') `options'
	local rc = _rc

	_bayesmh_eqlablist clear
	
	capture mata: mata drop `mcmcobject'

	exit `rc'
end

program _bayesgraph, rclass
	
	// common multiopts
	syntax [anything], 		///
		MCMCOBJECT(string) 	///
		[USING(string) 		///
		SKIP(passthru)		///
		noLEGend		///
		noLABEL			///
		COMBINEf		///
		combine(string)		///
		BYPARMf			///
		byparm(string)		///
		sleep(string)		///
	 	wait			///
		name(string)		///
		saving(string)		///
		NOCLOSEe		///
	      	CLOSE			///
		nobinrescale		///
		freq			/// undocumented
	 	genecusum		/// undocumented
		graphopts(string) *]

	_bayesmhpost_options `"`skip'"'
	local every = `s(skip)' + 1
	local origopts `options'
	// get graph type
	local 0 `anything'
	gettoken graphtype 0 : 0, parse(",\ ")
	ParseGraphType, `graphtype'
	local graphtype `r(graphtype)'

	// Set sleeptime
	if "`sleep'" != "" {
		capture confirm number `sleep'
		local rc = _rc
		if !`rc' {
			capture assert `sleep' >= 0
			local rc = _rc | `rc'
		}
		if `rc' {
			di as err ///
	"{p}option {bf:sleep()} must contain a nonnegative integer{p_end}"
			exit 198
		}
		local sleep = `sleep'*1000
	}

	if "`closee'" != "" & "`close'" != "" {
		opt_exclusive "noclose close"
		exit 198
	}
	if "`binrescale'" == "nobinrescale" {
		local binrescale
	}
	else {
		local binrescale binrescale
	}

	// check argument combinations that don't depend
	// on the number of parameters
	if ("`combine'" != "") {
		if "`diagnostics'`matrix'" != "" {
			di as err "{p 0 4 2}cannot specify option "	///
				"{bf:combine()} for graph type "	///
				"{bf:`diagnostics'`matrix'}{p_end}"
			exit 198
		}
		else if "`byparmf'" != "" {
			opts_exclusive combine() byparm
			exit 198
		}
		else if "`byparm'" != "" {
			opts_exclusive combine() byparm()
			exit 198
		}			
	}
	if ("`combinef'" != "") {
		if "`diagnostics'`matrix'" != "" {
			di as err "{p 0 4 2}cannot specify option "	///
				"{bf:combine} for graph type "		///
				"{bf:`diagnostics'`matrix'}{p_end}"
			exit 198
		}
		else if "`byparmf'" != "" {
			opts_exclusive combine byparm
			exit 198
		}
		else if "`byparm'" != "" {
			opts_exclusive combine byparm()
			exit 198
		}			
	}	
	if ("`byparm'" != "") {
		if "`diagnostics'`matrix'" != "" {
			di as err "{p 0 4 2}cannot specify option "	///
				"{bf:byparm()} for graph type "		///
				"{bf:`diagnostics'`matrix'}{p_end}"
			exit 198
		}
	}
	if ("`byparmf'" != "") {
		if "`diagnostics'`matrix'" != "" {
			di as err "{p 0 4 2}cannot specify option "	///
				"{bf:byparm} for graph type "		///
				"{bf:`diagnostics'`matrix'}{p_end}"
			exit 198
		}
	}	
	if "`matrix'" != "" {
		if "`wait'" != "" {
			di as err "{p 0 4 2}cannot specify option "	///
				"{bf:wait} for graph type "		///
				"{bf:matrix}{p_end}"
			exit 198
		}
		if "`sleep'" != "" {
			di as err "{p 0 4 2}cannot specify option "	///
				"{bf:sleep()} for graph type "		///
				"{bf:matrix}{p_end}"
			exit 198
		}
	}

	if "`byparmf'" != "" & "`sleep'" != "" {
		opts_exclusive "byparm sleep()"
		exit 198
	}
	if "`byparm'" != "" & "`sleep'" != "" {
		opts_exclusive "byparm() sleep()"
		exit 198
	}
	if "`combinef'" != "" & "`sleep'" != "" {
		opts_exclusive "combine sleep()"
		exit 198
	}
	if "`combine'" != "" & "`sleep'" != "" {
		opts_exclusive "combine() sleep()"
		exit 198
	}
	if "`byparmf'" != "" & "`wait'" != "" {
		opts_exclusive "byparm wait"
		exit 198
	}
	if "`byparm'" != "" & "`wait'" != "" {
		opts_exclusive "byparm() wait"
		exit 198
	}
	if "`combinef'" != "" & "`wait'" != "" {
		opts_exclusive "combine wait"
		exit 198
	}
	if "`combine'" != "" & "`wait'" != "" {
		opts_exclusive "combine() wait"
		exit 198
	}

	local thetaok 0
	gettoken thetas 0 : 0, parse(",") bind
	if `"`thetas'"' == "_all" {
		local thetas
		local thetaok 1
	}
	if `"`thetas'"' != "" & `"`thetas'"' != "," {
		// label:i.factorvar must be called as {label:i.factorvar} 
		// in order to expand properly
		_mcmc_expand_paramlist `"`thetas'"' `"`e(parnames)'"'
		local thetas `s(thetas)'
		local thetaok 1
	}
	else if `thetaok' {
		local 0 `thetas'`0'
		local thetas `e(parnames)'
	}

	if !`thetaok' {
		di as err "you must specify at least one parameter"
		exit 111
	}

	local 0 `name'
 
	syntax [anything] [, REPLACE *]
	local namelist `anything'
	local nameopts `options' replace
	
	local 0 `saving'
	syntax [anything] [, REPLACE *]
	if `"`anything'"' != "" {
		local filelist `anything'
		local saveopts `options' `replace'
	}
	local savefile

	// save current settings and data
	preserve
	local omore `c(more)'
	if "`wait'" != "" {
		set more on
	}	
capture noi break {

	_mcmc_read_simdata, mcmcobject(`mcmcobject') 		///
		 thetas(`thetas')				///
		 using(`"`using'"') every(`every') norestore nobaselevels
	qui gen double _fw = _frequency

	local numpars `s(numpars)'
	// parnames may contain ""
	local parnames `"`s(parnames)'"'
	local varnames `s(varnames)'
	local addvar `s(tempnames)'

	local 0 , `origopts' 
	// Finish parsing
	local syni
	local syn 
	forvalues i = 1/`numpars' {
		if "`matrix'" == "" {
			local syni graph`i'opts(string)
		}
		if "`diagnostics'" != "" {
			local syni `syni'		///	
				trace`i'opts(string)	///	
				hist`i'opts(string)	///	
				kdens`i'opts(string)	///
				ac`i'opts(string)
		}
		syntax [, `syni' *]
		local 0 , `options'
	}
	if "`diagnostics'" != "" {
		local syn 			///	
			traceopts(string)	///	
			acopts(string)		///
			histopts(string)	///
			kdensopts(string)
	}	
	
	syntax, [`syn' *]
	local ooptions `options'

	// graph graphi trace tracei
	
	if `"`graph1opts'"' != "" & "`diagnostics'" != "" {
		local 0, `graph1opts'
		foreach word in trace ac hist kdens {
			local o`word'1opts ``word'1opts'
			local o`word'opts ``word'opts'
			syntax [, `word'1opts(string) ///
				`word'opts(string) *]
			local graph1opts `options'
			local 0, `graph1opts'
			local `word'1opts	///
				``word'opts'	/// 
				``word'1opts' `o`word'1opts'
			local `word'opts `o`word'opts'
		}			 
	}
	forvalues i = 2/`numpars' {
		if `"`graph`i'opts'"' != "" & "`diagnostics'" != "" {
			local 0, `graph`i'opts'
			foreach word in trace ac hist kdens {
				local o`word'1opts ``word'1opts'
				local o`word'opts ``word'opts'
				syntax [, `word'1opts(string) ///
					`word'opts(string) *]
				local graph`i'opts `options'
				local 0, `graph`i'opts'
				local `word'`i'opts	///
					``word'opts'	///
					``word'1opts'	/// 
					``word'`i'opts'
				local `word'1opts `o`word'1opts'
				local `word'opts `o`word'opts'
			}			 
		}
	}

	if `"`graphopts'"' != "" & "`diagnostics'" != "" {
		local 0, `graphopts'
		local otraceopts `traceopts'
		local ohistopts `histopts'
		local okdensopts `kdensopts'
		local oacopts `acopts'
		syntax [, traceopts(string) histopts(string) ///
				kdensopts(string) acopts(string) *]
		local graphopts `options'
		local 0, `graphopts'
		local traceopts `traceopts' `otraceopts'
		local histopts `histopts' `ohistopts'
		local kdensopts `kdensopts' `okdensopts'
		local acopts `acopts' `oacopts'

		forvalues i = 1/`numpars'	{
			foreach word in trace ac hist kdens {
				local o`word'`i'opts ``word'`i'opts'
				syntax [, `word'`i'opts(string)  *]
				local graphopts `options'
				local 0, `graphopts'
				local `word'`i'opts	///
					``word'`i'opts'	///
					`o`word'`i'opts'
			}
		}			 
	}
	forvalues i = 1/`numpars' {
		if "`byparmf'" != "" & ///
			`"`graph`i'opts'"' != "" {
			opts_exclusive "byparm graph`i'opts()"
		}
		if "`byparm'" != "" & ///
			`"`graph`i'opts'"' != "" {
			opts_exclusive "byparm() graph`i'opts()"
		}
	}
	local options `ooptions'

	// parsing is done


	local twowayopts `options'
	local alloptions `options' `graphopts'

	capture mata: `mcmcobject'
	if _rc != 0 {
		di as err  "MCMC object not found"
		exit _rc
	}
	tempname mcmcsize
	mata: st_numscalar("`mcmcsize'", `mcmcobject'.mcmc_size())
	if `mcmcsize' < 1 {
		di "no MCMC samples available"
		exit 2000
	}

	if "`matrix'" == "" & `"`combinef'`combine'`byparmf'`byparm'"'=="" {
		local nfiles: word count `filelist'
		if `nfiles'  >= 1 & `nfiles' < `numpars' {
			local n 1
			local flist `filelist'
			local filelist
			while `n' < `nfiles' {
				local stub: word `n' of `flist'
				local filelist `filelist' `stub'
				local n = `n' + 1
			}
			local stub: word `nfiles' of `flist'
			local n 1
			while `nfiles' <= `numpars' {
				local filelist `filelist' `stub'`n'
				local n      = `n' + 1
				local nfiles = `nfiles' + 1
			}
		}
	}
	if "`matrix'" == "" & `"`combinef'`combine'`byparmf'`byparm'"'=="" {
		local nnames: word count `namelist'
		if `nnames'  >= 1 & `nnames' < `numpars' {
			local n 1
			local nlist `namelist'
			local namelist
			while `n' < `nnames' {
				local stub: word `n' of `nlist'
				local namelist `namelist' `stub'
				local n = `n' + 1
			}
			local stub: word `nnames' of `nlist'
			local n 1
			while `nnames' <= `numpars' {
				local namelist `namelist' `stub'`n'
				local n      = `n' + 1
				local nnames = `nnames' + 1
			}
		}
	}
	local w: word count `namelist'
	if "`byparm'`byparmf'`combine'`combinef'" != "" & `w' > 1 {
		di as err "{p 0 4 2}invalid number of names specified in " ///
			"option {bf:name()}{p_end}"
		exit 198
	}
	local w: word count `filelist'
	if "`byparm'`byparmf'`combine'`combinef'" != "" & `w' > 1 {
		di as err "{p 0 4 2}invalid number of files specified in " ///
			"option {bf:saving()}{p_end}"
		exit 198
	}
	local cols 0
	local rows 0
	if `"`combinef'`combine'"' != "" {
		local combinef combinef
		local 0 , `combine'
		syntax [anything], [Cols(integer 0) Rows(integer 0) *]
		local combine `options'
		if `numpars' > 1 {
			if `cols' < 1 & `rows' < 1 {
				local cols = floor(sqrt(`numpars'))
			}
			if `cols' > `numpars' {
				local cols `numpars'
			}
			if `cols' <= 0 {
				if `rows' > `numpars' {
					local rows `numpars'
				}
				if `rows' < 1 {
					local rows 1
				}
				local cols = ceil(`numpars'/`rows')
			}
			else {
				local rows = ceil(`numpars'/`cols')
			}
		}
	}

	local ovarnames
	gettoken vartok varnames: varnames
	local i = 1
	while "`vartok'" != "" {
		capture confirm variable `vartok', exact
		local passin `vartok'
		if _rc {
			local passin `i'
			local i = `i' + 1
		}
		local ovarnames `ovarnames' `passin'
		gettoken vartok varnames: varnames	
	}	
	local varnames: copy local ovarnames
	local ovarnames
	local oparnames: copy local parnames
	local othetas: copy local thetas
	gettoken vartok varnames: varnames
	gettoken partok parnames: parnames
	gettoken thetatok thetas: thetas, bind
	while "`vartok'" != "" {
		capture confirm variable `vartok', exact
		local there = 1
		if _rc {
			tempvar vartok
			local addvar `addvar' `vartok'
			quietly mata: st_addvar("double", "`vartok'")
			quietly mata: st_store(., st_varindex(	///
				"`vartok'"),			///
				`mcmcobject'.find_param_data(	///
				`"`partok'"'))
			local there = 0
			label variable `vartok' `partok'
		}
		local ovarnames `ovarnames' `vartok'
		if ((substr(`"`thetatok'"',1,1) == "{" &	/// 
			substr(`"`thetatok'"',			///		
			length(`"`thetatok'"'),1) == "}") |	///
			(substr(`"`thetatok'"',1,1) == "(" &	/// 
			substr(`"`thetatok'"',			///		
			length(`"`thetatok'"'),1) == ")")) & 	///
			(subinstr(`"`thetatok'"',":","",1) != 	///
			`"`thetatok'"')  {	
			local s = substr("`thetatok'",2,length("`thetatok'")-2)
		}
		else {
			local s `thetatok'
		}
		if !`there' {
			local os = ltrim(rtrim(`"`s'"'))
			gettoken os1 os: os, parse(":")
			capture confirm name `os1'
			if _rc {
				local os `s'
			}
			else {
				gettoken colon os: os, parse(":")		
				local os = subinstr(`"`os'"'," ","",.)
			}
			if length(`"`os'"') < 15 {
				label variable `vartok' `"`os'"'
				char `vartok'[two] "No Note"
			}
			else {
				char `vartok'[two] "Note"
			}
			if subinstr(`"`s'"',"`partok'","",1) == `"`s'"' {
				local s `partok':`s'
			}
			char `vartok'[one] `"`s'"'
		}
		else {
			label variable `vartok' `"`s'"'
		}
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		gettoken thetatok thetas: thetas, bind
	}
	local varnames: copy local ovarnames
	local parnames: copy local oparnames
	local thetas: copy local othetas
	local everynote
        if `every' != 1 {
                label variable _index "Sample identifier"
		local everynote "Using thinning interval of `every'"
		if "`byparm'`byparmf'" != "" {
			local everynote "Graphs by parameter; `everynote'"
		}
        }
        else {
		if "`byparm'`byparmf'" != "" {
			local everynote "Graphs by parameter"
		}
                label variable _index "Iteration number"
        }

	if "`matrix'`byparmf'`byparm'`combine'`combinef'" != "" {
		local ovarnames: copy local varnames
		gettoken vartok varnames: varnames
		local note
		while "`vartok'" != "" {
			local g: char `vartok'[one]
			local g = subinstr("`g'",":", ":  ",1)
			local g = subinstr(`"`g'"',"{","[",.)
			local g = subinstr(`"`g'"',"}","]",.)
			local g = subinstr(`"`g'"',"[","{c -(}",.)
			local g = subinstr(`"`g'"',"]","{c )-}",.)
			local h: char `vartok'[two]
			if `"`g'"' != ""  & `"`h'"' == "Note" {
				local note = `"`note' "' + ///
					char(34) + `"`g'"' + char(34)
			}
			gettoken vartok varnames: varnames
		}
		if "`everynote'" != "" {
			local everynote note("`everynote'" `note')
		}
		else if `"`note'"' != "" {
			local everynote note(`note')
		}
		local varnames: copy local ovarnames	
	}
	if `"`freq'"' == ""  & "`matrix'" == "" {
		tempvar order
		gen double `order' = _n
		qui expand _fw
		qui replace _fw = 1
		sort `order', stable
		qui replace _index = _n
		qui tsset _index
	}
	if `"`freq'"' != "" & `"`matrix'`histogram'"' == "" {
		di as err "option {bf:freq} not allowed with graph type " ///
			`"`kdensity'`diagnostics'`trace'`ac'`cusum'"'
	}
	if `"`freq'"' != "" {
		local fw [fw=_fw]
	}	 
	qui tsset _index
	if "`matrix'" != "" {
		if `numpars' < 2 {
			di as err "graph type {bf:`matrix'} " ///
				"requires at least two parameters"
			exit 198
		}

		// use the first filename
		if `"`saving'"' != "" {
			gettoken filename filelist: filelist
			if `"`filename'"' == "" {
				local filename Graph__1
			}
			local savefile saving(`filename',`saveopts')
		}
		gettoken grname namelist: namelist
		if `"`grname'"' == "" {
			local grname Graph__1
		}
		local 0 , `alloptions'
		syntax [anything], [msize(string) *]
		
		if `"`msize'"' == "" local msize tiny
		if "`freq'" == "" {
			tempvar order
			gen double `order' = _n
			qui expand _fw
			qui replace _fw = 1
			sort `order', stable
			qui replace _index = _n
			qui tsset _index
		}
		graph matrix `varnames' `fw',			///
			msize(`msize') `everynote'		/// 
			`options'				///
			name(`grname',`nameopts') `savefile' 
	}
	else if "`diagnostics'" != "" {
		local combineopts `alloptions'
		local nth 0
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		while "`vartok'" != "" {
			local nth = `nth' + 1
			local note 
			local g: char `vartok'[one]
			local g = subinstr("`g'",":", ":  ",1)
			local g = subinstr(`"`g'"',"{","[",.)
			local g = subinstr(`"`g'"',"}","]",.)
			local g = subinstr(`"`g'"',"[","{c -(}",.)
			local g = subinstr(`"`g'"',"]","{c )-}",.)
			if `"`g'"' != "" {
				local note = `"`note' "' + ///
					char(34) + `"`g'"' + char(34)
			}
			if "`everynote'" != "" {
				local everynote`nth' note("`everynote'" `note')
			}
			else if `"`note'"' != "" {
				local everynote`nth' note(`note')
			}
			local 0 , `traceopts' `trace`nth'opts'
			syntax [anything], [ title(passthru) 		///
				xtitle(passthru) ytitle(passthru) 	///
				by(passthru) *]
			local trace`nth'opts `options'
			if "`by'" != "" {
				di as err				/// 
				"{p 0 4 2}suboption {bf:by()} not "	///
				"allowed in {bf:trace`nth'opts()}{p_end}"
				exit 191
			}
			if `"`title'"' == "" local title title(Trace)
			if `"`xtitle'"' == "" {
				local xtitle: variable label _index
				local xtitle xtitle(`xtitle')
			}
			if `"`ytitle'"' == "" {
				local ytitle ytitle("")
			}
			local gr_`nth'_tr			///
				quietly 			///
				tsline `vartok', `title'        ///
				`xtitle' `ytitle'  ///
				xlabel(,labsize(vsmall)) ylabel(,angle(0)) ///
				`trace`nth'opts'                           ///
				name(_`nth'_tr, replace) nodraw

			local 0 , `histopts' `hist`nth'opts'
			syntax [anything], [ by(passthru) title(passthru)    ///
				xtitle(passthru) ytitle(passthru) *]
			local hist`nth'opts `options'
			if `"`title'"' == "" local title title(Histogram)
			if `"`xtitle'"' == "" local xtitle xtitle("")
			if `"`ytitle'"' == "" local ytitle ytitle("")
			if `"`by'"' != "" {
				di as err				/// 
				"{p 0 4 2}suboption {bf:by()} not "	///
				"allowed in {bf:hist`nth'opts()}{p_end}"
				exit 191
			}			
			quietly hist `vartok',		/// 
				`title'			///
			     	`xtitle'		///
				`ytitle'		///
			     	`hist`nth'opts'		///
				name(_`nth'_hist, replace) nodraw

			local 0 , `acopts' `ac`nth'opts'
			syntax [, GENerate(passthru) ci CIOPts(string)  ///
				by(passthru) title(passthru)		///
				xtitle(passthru)			///
				ytitle(passthru) *]
			local ac`nth'opts `options'
			local 0, `ac`nth'opts'
			syntax, [level(string) *]
			if `"`level'"' != "" {
				local ci ci
			}
			if `"`by'"' != "" {
				di as err ///
				"{p 0 4 2}suboption {bf:by()} not " ///
				"allowed in option {bf:ac`nth'opts()}{p_end}"
				exit 191
			}
			if `"`generate'"' != "" {
				di as err	///
				"{p 0 4 2}suboption {bf:generate()} not " ///
				"allowed in option {bf:ac`nth'opts()}{p_end}"
				exit 198
			}
			if `"`title'"' == "" local title title(Autocorrelation)
			if `"`xtitle'"' == "" local xtitle xtitle("Lag")
			if `"`ytitle'"' == "" local ytitle ytitle("")
	
			if `"`ci'`ciopts'"' != "" {
				local ciopts ciopts(`ciopts')
			}
			else 	local ciopts ciopts(astyle(none))
			
			local gr_`nth'_ac				///	
				quietly ac `vartok', `title'		///
			     	`xtitle'			 	///
			     	`ytitle' ylabel(,angle(0)) 		///
			     	note("") msize(vsmall)                  ///
			     	`ciopts' 				///
			     	`ac`nth'opts'				///
			     	name(_`nth'_ac, replace) nodraw

			quietly summarize `vartok'
			local legpos 11
			if `r(max)' + `r(min)' > 2*`r(mean)'  local legpos 1

			local 0 , `kdensopts' `kdens`nth'opts'
			syntax [anything], [SHOW(string) 		///
				LEGend(string asis)			///
				title(passthru) xtitle(passthru) 	///
				ytitle(passthru)			///
				KDENSFirst(string) KDENSSecond(string) 	///
				GENerate(passthru) *] 
			local legendoff = 0
			if `"`legend'"' == "off" {
				local legendoff = 1
			}
			if `"`generate'"' != "" {
				di as err 				  ///
				"{p 0 4 2}suboption {bf:generate()} not " ///
				"allowed in option "			  ///
				"{bf:kdens`nth'opts()}{p_end}"
				exit 198
			}
			local kdens`nth'opts `options'

			local 0, `kdens`nth'opts'
			syntax ,[ by(passthru) NORmal NORMOPts(string) ///
				  STUdent(string) STOPts(string) *]
			if `"`by'"' != "" {
				di as err ///
				"{p 0 4 2}suboption {bf:by()} not " ///
			"allowed in option {bf:kdens`nth'opts()}{p_end}"
				exit 191
			}
			local kdens`nth'normal = `"`normal'`normopts'"' != ""
			local norm`nth'opts `normopts'
			if `"`show'"' != "none" & "`student'" != "" {
				di as err 				 ///
				"{p 0 4 2}suboption {bf:student()} not " ///
			"allowed in option {bf:kdens`nth'opts()}{p_end}"
				exit 198
			}
			if `"`show'"' != "none" & "`stopts'" != "" {
				di as err 				///
				"{p 0 4 2}suboption {bf:stopts()} not " ///
				"allowed in {bf:kdens`nth'opts()}{p_end}"
				exit 198
			}
			local kdens`nth'opts `options'
			local 0, `kdensfirst'
			syntax ,[ by(passthru) GENerate(passthru)	///
				NORmal NORMOPts(string) 		///
				STUdent(string) STOPts(string) n(passthru) *]
			if `"`generate'"' != "" {
				di as err ///
				"{p 0 4 2} suboption {bf:generate()} not"
				di as err " allowed in option "
				di as err "{bf:kdensfirst()} specified within"
				di as err " option {bf:kdens`nth'opts()}"
				exit 198
			}
			if `"`by'"' != "" {
				di as err "{p 0 4 2} suboption {bf:by()} not"
				di as err " allowed in option "
				di as err "{bf:kdensfirst()} specified within"
				di as err " option {bf:kdens`nth'opts()}"
				exit 191
			}
			if "`normal'" != "" {
				di as err "{p 0 4 2} suboption {bf:normal} not"
				di as err " allowed in option "
				di as err "{bf:kdensfirst()} specified within"
				di as err " option {bf:kdens`nth'opts()}"
				exit 198
			}
			if "`student'" != "" {
				di as err "{p 0 4 2} suboption {bf:student} not"
				di as err " allowed in option "
				di as err "{bf:kdensfirst()} specified within"
				di as err " option {bf:kdens`nth'opts()}"
				exit 198
			}
			if "`stopts'" != "" {
				di as err ///
				"{p 0 4 2} suboption {bf:stopts()} not"
				di as err " allowed in option "
				di as err "{bf:kdensfirst()} specified within"
				di as err " option {bf:kdens`nth'opts()}"
				exit 198
			}
			if "`normopts'" != "" {
				di as err ///
				"{p 0 4 2} suboption {bf:normopts()} not"
				di as err " allowed in option "
				di as err "{bf:kdensfirst()} specified within"
				di as err " option {bf:kdens`nth'opts()}"
				exit 198
			}
			local nfirst `n'
			if "`n'" == "" {
				local nfirst n(300)
			}
			local 0, `kdenssecond'
			syntax ,[ by(passthru) 	GENerate(passthru)	///	
				NORmal NORMOPts(string) 		///
				  STUdent(string) STOPts(string) n(passthru) *]
			if `"`generate'"' != "" {
				di as err ///
				"{p 0 4 2} suboption {bf:generate()} not"
				di as err " allowed in option "
				di as err "{bf:kdenssecond()} specified within"
				di as err " option {bf:kdens`nth'opts()}"
				exit 198
			}
			if `"`by'"' != "" {
				di as err "{p 0 4 2} suboption {bf:by()} not"
				di as err " allowed in option "
				di as err "{bf:kdenssecond()} specified within"
				di as err " option {bf:kdens`nth'opts()}"
				exit 191
			}
			if "`normal'" != "" {
				di as err "{p 0 4 2} suboption {bf:normal} not"
				di as err " allowed in option "
				di as err "{bf:kdenssecond()} specified within"
				di as err " option {bf:kdens`nth'opts()}"
				exit 198
			}
			if "`student'" != "" {
				di as err ///
				"{p 0 4 2} suboption {bf:student()} not"
				di as err " allowed in option "
				di as err "{bf:kdenssecond()} specified within"
				di as err " option {bf:kdens`nth'opts()}"
				exit 198
			}
			if "`stopts'" != "" {
				di as err ///
				"{p 0 4 2} suboption {bf:stopts()} not"
				di as err " allowed in option "
				di as err "{bf:kdenssecond()} specified within"
				di as err " option {bf:kdens`nth'opts()}"
				exit 198
			}
			if "`normopts'" != "" {
				di as err ///
				"{p 0 4 2} suboption {bf:normopts()} not"
				di as err " allowed in option "
				di as err "{bf:kdenssecond()} specified within"
				di as err " option {bf:kdens`nth'opts()}"
				exit 198
			}
			local nsecond `n'
			if "`n'" == "" {
				local nsecond n(300)
			}

			// add plot
			local 0, `kdens`nth'opts'
			syntax, [addplot(string) *]
			local kdens`nth'opts `options'	
			
			if `"`title'"' == "" local title title(Density)
			if `"`xtitle'"' == "" local xtitle xtitle("")
			if `"`ytitle'"' == "" local ytitle ytitle("")


			local n1 = floor(_N/2)
			local n2 = _N
			if `"`show'"' == "" | `"`show'"' == "both" {
				local Ngraph
				if !`kdens`nth'normal'  {
					local legend`nth'		///
					pos(`legpos')			///
					ring(0) col(1) label(1 "all")	///
					symxsize(7) label(2 "1-half")	///
					label(3 "2-half") `legend'
				}
				else {
					local legend`nth'		///
					pos(`legpos')			///
					ring(0) col(1) label(1 "all")	///
					label(2 "Normal density")	///
					symxsize(7) label(3 "1-half")	///
					label(4 "2-half") `legend'

					local Ngraph			///
					(fn_normden `vartok',	///
					yvarlab("normal `vartok'")	///
					lstyle(refline)			///
					range(`vartok')			///
					`norm`nth'opts')
				}
				if `legendoff' {
					local legend`nth' off
				}
			    
				quietly twoway				///	
				(kdensity `vartok',			///
				clp(solid)				///
				lcol(dknavy) note("") 			///
				boundary `kdens`nth'opts')        	///
				`Ngraph'				///
				(kdensity `vartok' in 1/`n1',	 	///
				boundary clp(dash) lcol(dkgreen)	///
				`nfirst' 				///
				`kdensfirst')				///
				(kdensity `vartok' in `n1'/`n2'		///
				,					///
				clp(dot) lcol(purple) `nsecond'		///
				boundary `kdenssecond'	///
				`title'					///	
				`xtitle'				/// 	
				`ytitle'				///
				legend(`legend`nth'')			///	
				name(_`nth'_kdens, replace) nodraw)	///
				|| `addplot'

			} // end of both
			else if `"`show'"' == "first" {
				local Ngraph
				if !`kdens`nth'normal' {
					local legend`nth' pos(`legpos')	/// 
					ring(0) col(1) label(1 "all")	///
					label(2 "1-half") `legend'
				}
				else {
					local legend`nth' pos(`legpos')	/// 
					ring(0) col(1) label(1 "all")	///
					label(2 "Normal density")	///
					label(3 "1-half") `legend'

					local Ngraph			///
					(fn_normden `vartok',		///
					yvarlab("normal `vartok'")	///
					lstyle(refline)			///
					range(`vartok')			///
					`norm`nth'opts')
				}
				if `legendoff' {
					local legend`nth' off
				}
			    	quietly twoway				///
				(kdensity `vartok',			///
				clp(solid)				///
				boundary				///
				lcol(dknavy) note("") `kdens`nth'opts')	///
				`Ngraph'				///
				(kdensity `vartok' in 1/`n1',		///
				clp(dash) boundary			///
				lcol(dkgreen) `nfirst' `kdensfirst'	///
			    	`title' `xtitle' 			///
				`ytitle'				///
				legend(`legend`nth'')			///
				name(_`nth'_kdens, replace) nodraw) || ///
				`addplot' 
			} // end of first
			else if `"`show'"' == "second" {
				local Ngraph
				if !`kdens`nth'normal' {
					local legend`nth' pos(`legpos')	///
					ring(0) col(1) label(1 "all")	///
					label(2 "2-half") `legend'
				}
				else {
					local legend`nth' pos(`legpos')	///
					ring(0) col(1) label(1 "all")	///
					label(2 "Normal density")	///
					label(3 "2-half") `legend'

					local Ngraph			///
					(fn_normden `vartok',		///
					yvarlab("normal `vartok'")	///
					lstyle(refline)			///
					range(`vartok')			///
					`norm`nth'opts')
				}
				if `legendoff' {
					local legend`nth' off
				}
			    	quietly twoway				///
				(kdensity `vartok',			///
				clp(solid)				///
				boundary lcol(dknavy) note("") 		///
				`kdens`nth'opts')			///
				`Ngraph'				///
				(kdensity `vartok'			///
				in `n1'/`n2', boundary			///
				clp(dot) lcol(purple) `nsecond'		/// 
				`kdenssecond'				///
				`title' `xtitle' 			///
				`ytitle'				///
				legend(`legend`nth'')			///
				name(_`nth'_kdens, replace) nodraw) ||	/// 
				`addplot'
			} // end of second
			else if `"`show'"' == "none" {
				local Ngraph
				if `kdens`nth'normal' {
					local Ngraph			///
					(fn_normden `vartok',		///
					yvarlab("normal `vartok'")	///
					lstyle(refline)			///
					range(`vartok')			///
					`norm`nth'opts')

					local legend`nth'		///
				     	legend(pos(`legpos') ring(0)	///
					col(1) label(1 "overall")	///
					label(2 "Normal density") `legend')
				} 
				if `legendoff' {
					local legend`nth' off
				}
				quietly twoway (			///
				kdensity `vartok', clp(solid)		///
				lcol(dknavy) boundary			///
				`legend`nth'' 				///
				`title'					///
				`xtitle'				///
				`ytitle' `kdens`nth'opts'		///
				name(_`nth'_kdens, replace) nodraw)	/// 
				`Ngraph' ||	/// 
				`addplot'
			} // end of none
			local partok`nth' `partok'
			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
			local more`nth' 0
			if "`vartok'" != "" & `"`wait'"' == "wait" {
				local more`nth' 1
			}

			local close`nth' 0
			if "`close'" != ""  & "`vartok'" != "" {
				local close`nth' 1
			}
		}
		local totd = `nth'
		gettoken filename filelist: filelist
		gettoken grname namelist: namelist
		forvalues nth = 1/`totd' {
			if `"`saving'"' != "" {
				if `"`filename'"' == "" {
					local filename Graph__`nth'
				}
				local savefile ///
					saving(`filename',`saveopts')
			}
			if `"`grname'"' == "" {
				local grname Graph__`nth'
			}
			`gr_`nth'_tr'
			`gr_`nth'_ac'
			local 0 , `combineopts'
			syntax [anything], [Cols(integer 2)	///
				imargin(string) title(passthru) *]
			if `"`imargin'"' == "" local imargin small
			if `"`title'"' == "" local title title({bf:`partok`nth''})
			local combineoptsi `options'
			quietly graph combine _`nth'_tr _`nth'_hist	///
				_`nth'_ac _`nth'_kdens,			/// 
				cols(`cols') imargin(`imargin')		///
				`title' `combineoptsi'			///
				`everynote`nth''			///
				`graph`nth'opts'			///
				name(`grname',`nameopts') `savefile'
			local ogname `grname'
			quietly graph drop _`nth'_tr
			quietly graph drop _`nth'_hist
			quietly graph drop _`nth'_ac
			quietly graph drop _`nth'_kdens
			if "`sleep'" != "" {
				sleep `sleep'
			}
			gettoken filename filelist: filelist
			gettoken grname namelist: namelist
			if `more`nth'' {
				more
			}
			if `close`nth'' {
				graph close `ogname'
			}
		}
	}
	else if `"`trace'"' != "" & `"`byparmf'`byparm'"' != "" {
		gettoken grname namelist: namelist
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		local i = 1
		local lab
		while "`vartok'" != "" {
			rename `vartok' _param_`i'
			local lab = `"`lab'"' +  `" `i' "' + ///
				char(34) + `"`partok'"' + char(34)
			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
			local i = `i' + 1
		}
		tempvar order
		qui gen `order' = _n
		qui reshape long _param_, i(`order') j(_pname)
		tempname labname
		label define `labname' `lab'
		label values _pname `labname'
		label variable _pname "parameter"
		local 0 , `byparm'
		syntax [, noRescale noYRescale noXRescale ///
			Rescalee YRescalee XRescalee *]
		local argyrescale yrescale
		if "`rescale'`rescalee'" != "" {
			local argyrescale 
		}
		if "`yrescale'`yrescalee'" != "" {
			local argyrescale 
		}
		local argxrescale noxrescale
		if "`rescale'`rescalee'" != "" {
			local argxrescale 
		}
		if "`xrescale'`xrescalee'" != "" {
			local argxrescale 
		}
		local byparm `options'
		local 0, `byparm'
		syntax, [noROWCOLDEFAULT Cols(passthru) Rows(passthru) *]
		local argcols cols(1)
		if "`cols'`rows'`rowcoldefault'" != "" {
			local argcols 
		}
		local byparm `cols' `rows' `options'
		local xtitle: variable label _index
		local 0, `alloptions'
		syntax, [by(passthru) *]
		if `"`by'"' != "" {
			di as err "option {bf:by()} not allowed"
			exit 191
		}			
		quietly tsline _param,	xtitle("`xtitle'") ytitle("")	///
					ylabel(,angle(0))		///
					`alloptions' by(_pname, 	///
					title("Trace plots") 		///
					`argyrescale' `argxrescale'	///
					`argcols' `everynote'		///
					`byparm')			///
					name(`grname',`nameopts')	///
					`savefile'
	}
	else if `"`trace'"' != "" & `"`combinef'`combine'"' != "" {
		local xtitle: variable label _index
		// use the first filename
		if `"`saving'"' != "" {
			gettoken filename filelist: filelist
			if `"`filename'"' == "" {
				local filename Graph__1
			}
			local savefile saving(`filename',`saveopts')
		}
		gettoken grname namelist: namelist
		if `"`grname'"' == "" {
			local grname Graph__1
		}
		local grcombine ""
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		local nth 0
		while "`vartok'" != "" {
			local nth = `nth' + 1
			local 0, `alloptions' `graph`nth'opts'
			syntax , [by(passthru) *]
			if `"`by'"' != "" {
				di as err "option {bf:by()} not allowed"
				exit 191
			}		
			if `numpars' > 1 {
				quietly tsline `vartok',		///
					title(`"{bf:`partok'}"')	///
					xtitle("`xtitle'") ytitle("")	///
					ylabel(,angle(0))		///
					`alloptions'			///
					`graph`nth'opts'		///
					name(_`nth'_tr, replace) nodraw    
				local grcombine `grcombine' _`nth'_tr
			}
			else {
				quietly tsline `vartok', 		///
					title(				///
					`"Trace of {bf:`partok'}"')	///
					xtitle("`xtitle'") ytitle("")	///
					ylabel(,angle(0))		///
					`everynote'			///
					`alloptions' `graph`nth'opts'	///
					name(`grname',`nameopts')	///
					`savefile'
			}
			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
		}
		if `numpars' > 1 {
			graph combine `grcombine',		///
				cols(`cols') imargin(small)	///
				title(`"Trace plots"')		///
				`everynote'			///
				`combine'			///
				name(`grname',`nameopts')	///
				`savefile' 
			gettoken next grcombine: grcombine
			while "`next'" != "" {
				quietly graph drop `next'
				gettoken next grcombine: grcombine
			}
		}		
	}
	else if "`trace'" != "" {
		local xtitle: variable label _index
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		gettoken filename filelist: filelist
		gettoken grname namelist: namelist
		local nth 0
		while "`vartok'" != "" {
			local nth = `nth' + 1				
			if `"`saving'"' != "" {
				if `"`filename'"' == "" {
					local filename Graph__`nth'
				}
				local savefile	///
				saving(`filename',`saveopts')
			}
			if `"`grname'"' == "" {
				local grname Graph__`nth'
			}
			local note 
			local g: char `vartok'[one]
			local g = subinstr("`g'",":", ":  ",1)
			local g = subinstr(`"`g'"',"{","[",.)
			local g = subinstr(`"`g'"',"}","]",.)
			local g = subinstr(`"`g'"',"[","{c -(}",.)
			local g = subinstr(`"`g'"',"]","{c )-}",.)
			if `"`g'"' != "" {
				local note = `"`note' "' + ///
					char(34) + `"`g'"' + char(34)
			}
			if "`everynote'" != "" {
				local everynote`nth' note("`everynote'" `note')
			}
			else if `"`note'"' != "" {
				local everynote`nth' note(`note')
			}
			local 0, `alloptions' `graph`nth'opts'
			syntax , [by(passthru) *]
			if `"`by'"' != "" {
				di as err "option {bf:by()} not allowed"
				exit 191
			}		
			quietly tsline `vartok', xtitle("`xtitle'")	///
				ytitle("")				/// 
				title(`"Trace of {bf:`partok'}"')	///
				`everynote`nth''			///
				`alloptions' `graph`nth'opts'		///
				name(`grname',`nameopts') `savefile'
			if "`sleep'" != "" {
				sleep `sleep'
			}
			local ogname `grname'
			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
			gettoken filename filelist: filelist
			gettoken grname namelist: namelist
				
			if "`vartok'" != "" & `"`wait'"' == "wait" {
				more
			}
			if "`close'" != ""  & "`vartok'" != "" {
				graph close `ogname'
			}
		}
	}
	else if `"`cusum'"' != "" & `"`byparmf'`byparm'"' != "" {
		local xtitle: variable label _index
		gettoken grname namelist: namelist
		local oparnames `"`parnames'"'
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		while "`vartok'" != "" {
			quietly summarize `vartok'
			quietly replace `vartok' = `vartok' - `r(mean)'
			quietly replace `vartok' = sum(`vartok')		
			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
		}
		local varnames: copy local ovarnames
		local parnames: copy local oparnames
		gettoken vartok ovarnames: ovarnames
		gettoken partok parnames: parnames
		local i = 1
		local lab
		while "`vartok'" != "" {
			rename `vartok' _param_`i'
			local lab = `"`lab'"' +  `" `i' "' + ///
				char(34) + `"`partok'"' + char(34)
			gettoken vartok ovarnames: ovarnames
			gettoken partok parnames: parnames
			local i = `i' + 1
		}
		qui reshape long _param_, i(_index) j(_pname)
		tempname labname
		label define `labname' `lab'
		label values _pname `labname'
		label variable _pname "parameter"
		local 0 , `byparm'
		syntax [, noRescale noYRescale noXRescale ///
			Rescalee YRescalee XRescalee *]
		local argyrescale yrescale
		if "`rescale'`rescalee'" != "" {
			local argyrescale 
		}
		if "`yrescale'`yrescalee'" != "" {
			local argyrescale 
		}
		local argxrescale noxrescale
		if "`rescale'`rescalee'" != "" {
			local argxrescale 
		}
		if "`xrescale'`xrescalee'" != "" {
			local argxrescale 
		}
		local byparm `options'
		local 0, `byparm'
		syntax, [noROWCOLDEFAULT Cols(passthru) Rows(passthru) *]
		local argcols cols(1)
		if "`cols'`rows'`rowcoldefault'" != "" {
			local argcols 
		}
		local byparm `cols' `rows' `options'
		local 0, `alloptions'
		syntax, [yline(string) by(passthru) *]
		local argyline yline(0)
		if `"`yline'"' != "" {
			local argyline 
		}
		if `"`by'"' != "" {
			di as err "option {bf:by()} not allowed"
			exit 191
		}			
		quietly tsline _param_,				///
			xtitle("`xtitle'") ytitle("")		///
			ylabel(,angle(0))			///
			`argyline' `alloptions' by(_pname,	/// 
			title(`"Cusum plots"') 			///
			`argyrescale' `argxrescale'		///
			`argcols' `everynote'			///
			`byparm')				///
			name(`grname',`nameopts')		///
			`savefile'
	}
	else if `"`cusum'"' != "" & "`combine'`combinef'" != "" {
		local xtitle: variable label _index
		// use the first filename
		if `"`saving'"' != "" {
			gettoken filename filelist: filelist
			if `"`filename'"' == "" {
				local filename Graph__1
			}
			local savefile saving(`filename',`saveopts')
		}
		gettoken grname namelist: namelist
		if `"`grname'"' == "" {
			local grname Graph__1
		}
			
		local grcombine ""
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		local nth 0
		while "`vartok'" != "" {
			local nth = `nth' + 1
			quietly summarize `vartok'
			quietly replace `vartok' = `vartok' - `r(mean)'
			quietly replace `vartok' = sum(`vartok')
			local 0, `alloptions' `graph`nth'opts'
			syntax, [yline(string) by(passthru) *]
			local argyline yline(0)
			if `"`yline'"' != "" {
				local argyline 
			}
			if `"`by'"' != "" {
				di as err "option {bf:by()} not allowed"
				exit 191
			}		
			if `numpars' > 1 {
				quietly tsline `vartok',		///
					title(`"{bf:`partok'}"')	///   
					xtitle("`xtitle'") ytitle("")	///
					ylabel(,angle(0)) `argyline'	///
					`alloptions'			///
					`graph`nth'opts'		///     
					name(_`nth'_cusum, replace) nodraw 
				local grcombine `grcombine' _`nth'_cusum
			}
			else {
				quietly tsline `vartok',		/// 
					title(				///
					`"Cusum of {bf:`partok'}"')	///
					xtitle("`xtitle'")		///
					ytitle("") ylabel(,angle(0))	///
					`argyline'			///
					`everynote'			///
					`alloptions' `graph`nth'opts'	///
					name(`grname',`nameopts')	///
					`savefile'
			}

			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
		}
		if `numpars' > 1 {
			graph combine `grcombine',		///
				col(`cols') imargin(small)	///
				title(`"Cusum plots"')		///
				`everynote'			///
				`combine'			///
				name(`grname',`nameopts')	///
				`savefile'
			gettoken next grcombine: grcombine
			while "`next'" != "" {
				quietly graph drop `next'
				gettoken next grcombine: grcombine
			}
		}
	}
	else if "`cusum'" != "" {
		local xtitle: variable label _index
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		gettoken filename filelist: filelist
		gettoken grname namelist: namelist
		local nth 0
		while "`vartok'" != "" {
			local nth = `nth' + 1
			if `"`saving'"' != "" {
				if `"`filename'"' == "" {
					local filename Graph__`nth'
				}
				local savefile saving(`filename',`saveopts')
			}
			if `"`grname'"' == "" {
				local grname Graph__`nth'
			}
				
			quietly summarize `vartok'
			quietly replace `vartok' = `vartok' - `r(mean)'
			quietly replace `vartok' = sum(`vartok')
			local 0, `alloptions' `graph`nth'opts'
			syntax, [yline(string) *]
			local argyline yline(0)
			if `"`yline'"' != "" {
				local argyline 
			}
			local note 
			local g: char `vartok'[one]
			local g = subinstr("`g'",":", ":  ",1)
			local g = subinstr(`"`g'"',"{","[",.)
			local g = subinstr(`"`g'"',"}","]",.)
			local g = subinstr(`"`g'"',"[","{c -(}",.)
			local g = subinstr(`"`g'"',"]","{c )-}",.)
			if `"`g'"' != "" {
				local note = `"`note' "' + ///
					char(34) + `"`g'"' + char(34)
			}
			if "`everynote'" != "" {
				local everynote`nth' note("`everynote'" `note')
			}
			else if `"`note'"' != "" {
				local everynote`nth' note(`note')
			}
			local 0, `alloptions' `graph`nth'opts'
			syntax , [by(passthru) *]
			if `"`by'"' != "" {
				di as err "option {bf:by()} not allowed"
				exit 191
			}		
			quietly tsline `vartok', 			///
				xtitle("`xtitle'") ytitle("")		///
				title(`"Cusum of {bf:`partok'}"')	///
				`everynote`nth''			///
				`argyline'				/// 
				`alloptions' `graph`nth'opts'		///
				name(`grname',`nameopts') `savefile'
			if "`sleep'" != "" {
				sleep `sleep'
			}
			local ogname `grname'
			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
			gettoken filename filelist: filelist
			gettoken grname namelist: namelist
				
			if "`vartok'" != "" & `"`wait'"' == "wait" {
				more
			}
			if "`close'" != ""  & "`vartok'" != "" {
				graph close `ogname'
			}
		}
	}
	else if `"`histogram'"' != "" & `"`byparmf'`byparm'"' != "" {
		gettoken grname namelist: namelist
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		local i = 1
		local lab
		while "`vartok'" != "" {
			rename `vartok' _param_`i'
			local lab = `"`lab'"' +  `" `i' "' + ///
				char(34) + `"`partok'"' + char(34)
			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
			local i = `i' + 1
		}
		tempvar order
		gen `order' = _n
		qui reshape long _param_, i(`order' _fw) j(_pname)
		tempname labname
		label define `labname' `lab'
		label values _pname `labname'
		label variable _pname "parameter"
		local 0 , `byparm'
		syntax [, noRescale noYRescale noXRescale ///
			Rescalee YRescalee XRescalee *]
		local argyrescale yrescale
		if "`rescale'`rescalee'" != "" {
			local argyrescale 
		}
		if "`yrescale'`yrescalee'" != "" {
			local argyrescale 
		}
		local argxrescale xrescale
		if "`rescale'`rescalee'" != "" {
			local argxrescale 
		}
		if "`xrescale'`xrescalee'" != "" {
			local argxrescale 
		}
		local byparm `options'
		local 0, `alloptions'
		syntax, [by(passthru) LEGend(string asis) NORMal ///
			NORMOPts(passthru) KDENsity KDENOPts(passthru) *]
		local legendoff 0
		if `"`legend'"' == "off" {
			local legendoff 1
		}
		if `"`by'"' != "" {
			di as err "option {bf:by()} not allowed"
			exit 191
		}
		local legendpass label(1 "Density")
		if `"`normal'`normopts'"' != "" {
			local legendpass `legendpass' label(2 "Normal density")	
			if `"`kdensity'`kdenopts'"' != "" {
				local legendpass `legendpass'	///
					label(3 "Kernel density")
			}
		}
		else if `"`kdensity'`kdenopts'"' != "" {
			local legendpass `legendpass' label(2 "Kernel density")
		}
		local legend legend(`legendpass' `legend')
		if `legendoff' {
			local legendoff legend(off)			
		}
		else {
			local legendoff 
		}
		quietly histogram _param_ `fw', xtitle("")		///
				ytitle("")				///
				`alloptions' 				///
				by(_pname, title(`"Histograms"')	///
				`argyrescale' `argxrescale'		///	
				`everynote' `byparm' `legendoff') 	///
				`binrescale'				/// 
				`legend'				///
				name(`grname',`nameopts') `savefile'
	}
	else if "`histogram'" != "" & "`combinef'`combine'" != "" {
		// use the first filename
		if `"`saving'"' != "" {
			gettoken filename filelist: filelist
			if `"`filename'"' == "" {
				local filename Graph__1
			}
			local savefile saving(`filename',`saveopts')
		}
		gettoken grname namelist: namelist
		if `"`grname'"' == "" {
			local grname Graph__1
		}
		local grcombine ""
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		local nth 0
		while "`vartok'" != "" {
			local nth = `nth' + 1
			local 0, `alloptions' `graph`nth'opts'
			syntax, [by(passthru) *]
			if `"`by'"' != "" {
				di as err "option {bf:by()} not allowed"
				exit 191
			}		
			if `numpars' > 1 {
				quietly histogram `vartok' `fw',	///
					title(`"{bf:`partok'}"')	/// 
					xtitle("") ytitle("")		///
					ylabel(,angle(0)) `alloptions'	///
					`graph`nth'opts'		///
					name(_`nth'_hist, replace) nodraw   
					
				local grcombine `grcombine' _`nth'_hist
			}
			else {
				quietly histogram `vartok' `fw',	///
					title(				///
					`"Histogram of {bf:`partok'}"')	///
					xtitle("") ytitle("")		///
					ylabel(,angle(0))		///
					`everynote'			/// 
					`alloptions' `graph`nth'opts'	/// 
					name(`grname',`nameopts')	///
					`savefile'
			}
			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
		}

		if `numpars' > 1 {
			graph combine `grcombine',		///
				col(`cols') imargin(small)	///
				title(`"Histogram plots"')	///
				`everynote'			///
				`combine'			///
				name(`grname',`nameopts')	///
				`savefile'
			gettoken next grcombine: grcombine
			while "`next'" != "" {
				quietly graph drop `next'
				gettoken next grcombine: grcombine
			}
		}
	}
	else if "`histogram'" != "" {
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		gettoken filename filelist: filelist
		gettoken grname namelist: namelist
		local nth 0
		while "`vartok'" != "" {
			local nth = `nth' + 1
			if `"`saving'"' != "" {
				if `"`filename'"' == "" {
					local filename Graph__`nth'
				}
				local savefile saving(`filename',`saveopts')
			}
			if `"`grname'"' == "" {
				local grname Graph__`nth'
			}
			local note 
			local g: char `vartok'[one]
			local g = subinstr("`g'",":", ":  ",1)
			local g = subinstr(`"`g'"',"{","[",.)
			local g = subinstr(`"`g'"',"}","]",.)
			local g = subinstr(`"`g'"',"[","{c -(}",.)
			local g = subinstr(`"`g'"',"]","{c )-}",.)
			if `"`g'"' != "" {
				local note = `"`note' "' + ///
					char(34) + `"`g'"' + char(34)
			}
			if "`everynote'" != "" {
				local everynote`nth' note("`everynote'" `note')
			}
			else if `"`note'"' != "" {
				local everynote`nth' note(`note')
			}
			local 0, `alloptions'
			syntax , [by(passthru) *]
			if `"`by'"' != "" {
				di as err "option {bf:by()} not allowed"
				exit 191
			}		
			quietly histogram `vartok' `fw', xtitle("")	///
				ytitle("")				///
				title(`"Histogram of {bf:`partok'}"')	///
				`everynote`nth''			///
				`alloptions' `graph`nth'opts'		///
				name(`grname',`nameopts') `savefile'
			if "`sleep'" != "" {
				sleep `sleep'
			}
			local ogname `grname'
			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
			gettoken filename filelist: filelist
			gettoken grname namelist: namelist
			
			if "`vartok'" != "" & `"`wait'"' == "wait" {
				more
			}
			if "`close'" != ""  & "`vartok'" != "" {
				graph close `ogname'
			}
		}
	}
	else if `"`ac'"' != "" & `"`byparmf'`byparm'"' != "" {
		local xtitle Lag
		local 0 , `alloptions'
		syntax [, generate(passthru) ci ciopts(passthru) ///
			by(passthru) level(string) *]
		if `"`generate'"' != "" {
			di as err "option {bf:generate()} not allowed"
			exit 198
		}
		if `"`by'"' != "" {
			di as err "option {bf:by()} not allowed"
			exit 191
		}		
		if "`ci'" != "" & `"`byparmf'"' != "" {
			opts_exclusive "ci byparm"
			exit 198
		}
		if `"`ciopts'"' != "" & `"`byparmf'"' != "" {
			opts_exclusive "ciopts() byparm"
			exit 198
		}
		if "`ci'" != "" & "`byparm'" != "" {
			opts_exclusive "ci byparm()"
			exit 198
		}
		if `"`ciopts'"' != "" & "`byparm'" != "" {
			opts_exclusive "ciopts() byparm()"
			exit 198
		}
		if `"`level'"' != "" & `"`byparmf'"' != "" {
			opts_exclusive "level() byparm"
			exit 198
		}
		if `"`level'"' != "" & "`byparm'" != "" {
			opts_exclusive "level() byparm()"
			exit 198
		}
		gettoken grname namelist: namelist
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		local i = 1
		local lab
		while "`vartok'" != "" {
			rename `vartok' _param`i'
			qui ac _param`i', generate(_ac`i') ///
				`alloptions' nograph
			qui gen _lag`i' = _n if _ac`i' != .
			local lab = `"`lab'"' +  `" `i' "' + ///
				char(34) + `"`partok'"' + char(34)
			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
			local i = `i' + 1
		}
		qui reshape long _param _ac _lag, i(_index) j(_pname)
		tempname labname
		label define `labname' `lab'
		label values _pname `labname'
		label variable _pname "parameter"
		local 0 , `alloptions'
		syntax [, lags(string) GENerate(string) ///
				level(string) fft *]
		local alloptions `options'
		local 0, `byparm'
		syntax [, noRescale noYRescale noXRescale ///
			Rescalee YRescalee XRescalee *]
		local argyrescale yrescale
		if "`rescale'`rescalee'" != "" {
			local argyrescale 
		}
		if "`yrescale'`yrescalee'" != "" {
			local argyrescale 
		}
		local argxrescale xrescale
		if "`rescale'`rescalee'" != "" {
			local argxrescale 
		}
		if "`xrescale'`xrescalee'" != "" {
			local argxrescale 
		}
		local byparm `options'
		qui twoway dropline _ac _lag if			///		
			_lag != ., pstyle(p1)			///
			xtitle("`xtitle'") ytitle("")		///
			ylabel(,angle(0))			///
			msize(small) note("")           	///
			`alloptions'				///
			by(_pname, title("Autocorrelations")	///	
			`argyrescale' `argxrescale'		///
			`everynote' `byparm')			///
			name(`grname',`nameopts') `savefile'
	}
	else if "`ac'" != "" & "`combinef'`combine'" != "" {
		local xtitle Lag
		// use the first filename
		if `"`saving'"' != "" {
			gettoken filename filelist: filelist
			if `"`filename'"' == "" {
				local filename Graph__1
			}
			local savefile saving(`filename',`saveopts')
		}
		gettoken grname namelist: namelist
		if `"`grname'"' == "" {
			local grname Graph__1
		}
		local grcombine ""
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		local nth 0
		while "`vartok'" != "" {
			local nth = `nth' + 1
			local 0 , `alloptions' `graph`nth'opts'
			syntax [, GENerate(passthru) 	///
				ci CIOPts(string) by(passthru) *]
			if `"`generate'"' != "" {
				di as err "option {bf:generate()} not allowed"
				exit 198
			}
			local graph`nth'opts `options'
			local 0, `graph`nth'opts'
			syntax ,[ level(passthru) *]
			if `"`level'"' != "" {
				local ci ci
			}
			if `"`ci'`ciopts'"' != "" {
				local ciopts ///
				ciopts(`ciopts')
			}
			else {
				local ciopts ///
				ciopts(astyle(none))
			}
			if `"`by'"' != "" {
				di as err "option {bf:by()} not allowed"
				exit 191
			}		
			if `numpars' > 1 {
				quietly ac `vartok',			///
					title(`"{bf:`partok'}"')	///
					xtitle("`xtitle'") ytitle("")	///
					ylabel(,angle(0))		///
					msize(small) note("")           ///
					 `ciopts' `graph`nth'opts'	///
					name(_`nth'_ac, replace) nodraw 
				local grcombine `grcombine' _`nth'_ac
			}
			else {
				quietly ac `vartok',			///
					title(				///
				`"Autocorrelation of {bf:`partok'}"')	///
					xtitle("`xtitle'") 		///
					ytitle("")			///
					ylabel(,angle(0)) msize(small)	///
					note("")			///
					`everynote'			///
					 `ciopts' `graph`nth'opts'	///    
					name(`grname',`nameopts')	///
					`savefile'
			}
				
			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
		}

		if `numpars' > 1 {
			graph combine `grcombine',			///
				col(`cols') imargin(small)		///
				title(`"Autocorrelation plots"')	///
				name(`grname',`nameopts')		///
				`everynote'				///
				`combine' `savefile'
			gettoken next grcombine: grcombine
			while "`next'" != "" {
				quietly graph drop `next'
				gettoken next grcombine: grcombine
			}
		}	
	}
	else if "`ac'" != "" {
		local xtitle Lag
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		gettoken filename filelist: filelist
		gettoken grname namelist: namelist
		local nth 0
		while "`vartok'" != "" {
			local nth = `nth' + 1
			local note 
			local g: char `vartok'[one]
			local g = subinstr("`g'",":", ":  ",1)
			local g = subinstr(`"`g'"',"{","[",.)
			local g = subinstr(`"`g'"',"}","]",.)
			local g = subinstr(`"`g'"',"[","{c -(}",.)
			local g = subinstr(`"`g'"',"]","{c )-}",.)
			if `"`g'"' != "" {
				local note = `"`note' "' + ///
					char(34) + `"`g'"' + char(34)
			}
			if "`everynote'" != "" {
				local everynote`nth' note("`everynote'" `note')
			}
			else if `"`note'"' != "" {
				local everynote`nth' note(`note')
			}

			if `"`saving'"' != "" {
				if `"`filename'"' == "" {
					local filename Graph__`nth'
				}
				local savefile saving(`filename',`saveopts')
			}
			if `"`grname'"' == "" {
				local grname Graph__`nth'
			}
			local 0 , `alloptions' `graph`nth'opts'
			syntax [, GENerate(passthru)	///
				ci CIOPts(string) by(passthru) *]
			if `"`generate'"' != "" {
				di as err "option {bf:generate()} not allowed"
				exit 198
			}
			if `"`by'"' != "" {
				di as err "option {bf:by()} not allowed"
				exit 191
			}		
			local graph`nth'opts `options'
			local 0, `graph`nth'opts'
			syntax ,[ level(passthru) *]
			if `"`level'"' != "" {
				local ci ci
			}
			if `"`ci'`ciopts'"' != "" {
				local ciopts ///
				ciopts(`ciopts')
			}
			else {
				local ciopts ///
				ciopts(astyle(none))
			}
			quietly ac `vartok', ytitle("")			///
				xtitle("`xtitle'")			///
				ylabel(,angle(0))			///
				`ciopts' note("") title(		///
				`"Autocorrelation of {bf:`partok'}"')	///
				`everynote`nth''			///
				`graph`nth'opts' name(`grname',		///
				`nameopts') `savefile'
			if "`sleep'" != "" {
				sleep `sleep'
			}
			local ogname `grname'
			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
			gettoken filename filelist: filelist
			gettoken grname namelist: namelist
			if "`vartok'" != "" & `"`wait'"' == "wait" {
				more
			}
			if "`close'" != ""  & "`vartok'" != "" {
				graph close `ogname'
			}
		}
	}
	else if `"`kdensity'"' != "" & `"`byparmf'`byparm'"' != "" {
		gettoken grname namelist: namelist
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		local 0 , `alloptions'
		syntax [anything], [SHOW(string) LEGend(string asis)	///
			GENerate(passthru) 				///
			KDENSFirst(string) KDENSSecond(string) by(passthru) *]
		local legendoff 0
		if `"`legend'"' == "off" {
			local legendoff 1
		} 
		if `"`generate'"' != "" {
			di as err "option {bf:generate()} not allowed"
			exit 198
		}
		if `"`by'"' != "" {
			di as err "option {bf:by()} not allowed"
			exit 191
		}
		local alloptions `options'
		local n1 = floor(_N/2)
		local n2 = _N
		tempvar first second
		gen byte `first' = _n <= `n1'
		gen byte `second' = _n >= `n1'
		local i = 1
		local lab
		local list _param 

		if !(	`"`show'"'=="first" | `"`show'"'=="second" |	///
			`"`show'"'=="none" | `"`show'"' =="" |		///
			`"`show'"' == "both") {
			di as err "{p 0 4 2}"		/// 
				"option {bf:show()} "	///
				"must be {bf:first}, "	///
				"{bf:second}, "		///
				"{bf:both}, or {bf:none}{p_end}"
			exit 198
		}
 
		local 0, `alloptions'
		syntax ,[ NORmal NORMOPts(string) ///
			  STUdent(string) STOPts(string) *]
		local kdensnormal = "`normal'`normopts'" != ""
		local normkopts `normopts'
		if "`student'" != "" {
			di as err "{p 0 4 2} option {bf:student()} not " ///
				"allowed{p_end}"
			exit 198
		}
		if "`stopts'" != "" {
			di as err "{p 0 4 2}option {bf:stopts()} not " ///
				"allowed{p_end}"
			exit 198
		}
		local alloptions `options'

		local 0, `kdensfirst'
		syntax ,[ NORmal NORMOPts(string) GENerate(passthru) ///
			  STUdent(string) STOPts(string) by(passthru) *]
		if `"`generate'"' != "" {
			di as err ///
			"{p 0 4 2}suboption {bf:generate()} not allowed "
			di as err "in option {bf:kdensfirst()}{p_end}"
			exit 198
		}
		if `"`by'"' != "" {
			di as err "{p 0 4 2}suboption {bf:by()} not allowed "
			di as err "in option {bf:kdensfirst()}{p_end}"
			exit 191
		}		
		if "`normal'" != "" {
			di as err "{p 0 4 2}suboption {bf:normal} not allowed "
			di as err "in option {bf:kdensfirst()}{p_end}"
			exit 198
		}
		if "`student'" != "" {
			di as err ///
			"{p 0 4 2}suboption {bf:student()} not allowed "
			di as err "in option {bf:kdensfirst()}{p_end}"
			exit 198
		}
		if "`stopts'" != "" {
			di as err ///
			"{p 0 4 2}suboption {bf:stopts()} not allowed "
			di as err "in option {bf:kdensfirst()}{p_end}"
			exit 198
		}
		if "`normopts'" != "" {
			di as err ///
			"{p 0 4 2}suboption {bf:normopts()} not allowed "
			di as err "in option {bf:kdensfirst()}{p_end}"
			exit 198
		}
		local kdensfirst `options'
		local nfirst n(300)
		if "`n'" != "" {
			local nfirst `n'
		}

		local 0, `kdenssecond'
		syntax ,[ NORmal NORMOPts(string)	/// 
			by(passthru) GENerate(passthru)	///
			  STUdent(string) STOPts(string) n(passthru) *]
		if `"`generate'"' != "" {
			di as err ///
			"{p 0 4 2}suboption {bf:generate()} not allowed "
			di as err "in option {bf:kdenssecond()}{p_end}"
			exit 198
		}
		if `"`by'"' != "" {
			di as err "{p 0 4 2}suboption {bf:by()} not allowed "
			di as err "in option {bf:kdenssecond()}{p_end}"
			exit 191
		}		
		if "`normal'" != "" {
			di as err "{p 0 4 2}suboption {bf:normal} not allowed "
			di as err "in option {bf:kdenssecond()}{p_end}"
			exit 198
		}
		if "`student'" != "" {
			di as err ///
			"{p 0 4 2}suboption {bf:student()} not allowed "
			di as err "in option {bf:kdenssecond()}{p_end}"
			exit 198
		}
		if "`stopts'" != "" {
			di as err ///
			"{p 0 4 2}suboption {bf:stopts()} not allowed "
			di as err "in option {bf:kdenssecond()}{p_end}"
			exit 198
		}
		if "`normopts'" != "" {
			di as err ///
			"{p 0 4 2}suboption {bf:normopts()} not allowed "
			di as err "in option {bf:kdenssecond()}{p_end}"
			exit 198
		}
		local kdenssecond `options'
		local nsecond n(300)
		if "`n'" != "" {
			local nsecond `n'
		}
		while "`vartok'" != "" {
			rename `vartok' _param`i'
			local lab = `"`lab'"' +  `" `i' "' + ///
				char(34) + `"`partok'"' + char(34)
			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
			local i = `i' + 1
		}
		tempvar order
		gen `order' = _n
		qui reshape long `list', i(`order' `first' `second' _fw) ///
			j(_pname)
		tempname labname
		label define `labname' `lab'
		label values _pname `labname'
		label variable _pname "parameter"
		sort _pname, stable
		local 0, `alloptions'
		syntax [, XTItle(passthru) YTItle(passthru) ///
			TItle(passthru) YLABel(passthru) *]
		local alloptions `options'
		local 0, `byparm'
		syntax [, noRescale noYRescale noXRescale ///
			Rescalee YRescalee XRescalee *]
		local argyrescale yrescale
		if "`rescale'`rescalee'" != "" {
			local argyrescale 
		}
		if "`yrescale'`yrescalee'" != "" {
			local argyrescale 
		}
		local argxrescale xrescale
		if "`rescale'`rescalee'" != "" {
			local argxrescale 
		}
		if "`xrescale'`xrescalee'" != "" {
			local argxrescale 
		}
		local byparm `options'
		local 0, `alloptions'
		syntax [, addplot(string) *]
		local alloptions `options'
		
		if "`show'" != "none" {
			local plot twoway			///
			(kdensity _param, clp(solid)		///
			lcol(dknavy)				///	
			boundary `alloptions')
			local Ngraph
			if `kdensnormal' {
				local plot `plot'		///
				(fn_normden _param,		///
				yvarlab("normal _param")	///
				lstyle(refline)			///
				range(_param)			///
				`normkopts')
			}
		}
		else {
			if `legendoff' {
				local legendoff legend(off)			
			}
			else {
				local legendoff 
			}
			if !`kdensnormal' {
				local plot twoway			///
				(kdensity _param, clp(solid)		///
				lcol(dknavy)				///	
				boundary `alloptions'			///
				xtitle("") ytitle("")			/// 
				ylabel(,angle(0))			///
				by(_pname, title(`"Densities"') 	///
				`argyrescale' `argxrescale'		///
				`everynote' `byparm' `legendoff')	///
				name(`grname',`nameopts')		///
				`savefile'				///
				`legend'				///
				`xtitle' `ytitle' `ylabel' `title')	///
				|| `addplot'
			}
			else {
				local plot twoway			///
				(kdensity _param, clp(solid)		///
				lcol(dknavy)				///	
				boundary `alloptions'			///
				xtitle("") ytitle("")			/// 
				ylabel(,angle(0))			///
				by(_pname, title(`"Densities"') 	///
				`argyrescale' `argxrescale'		///
				`everynote' `byparm' `legendoff')	///
				name(`grname',`nameopts')		///
				`savefile'				///
				`legend'				///
				`xtitle' `ytitle' `ylabel' `title'	///
				(fn_normden _param,			///
				yvarlab("normal _param")		///
				lstyle(refline)				///
				range(_param)				///
				`normkopts')				///
				|| `addplot'
			}
		}
		if inlist("`show'","both","") {
			if !`kdensnormal' {
				local legend 				///
				legend(pos(`legpos') ring(0) col(1)	///
				label(1 "overall") label(2 "1st-half")	///
				label(3 "2nd-half") `legend')		
			}
			else {
				local legend				///
				legend(pos(`legpos') ring(0) col(1)	///
				label(1 "overall")			/// 
				label(2 "Normal density")		///
				label(3 "1st-half")			///
				label(4 "2nd-half") `legend')		
			}
			if `legendoff' {
				local legend legend(off)
			}
			if `legendoff' {
				local legendoff legend(off)			
			}
			else {
				local legendoff 
			}
			local plot `plot' 				///
			(kdensity _param if `first' , clp(dash)		///
			lcol(dkgreen) boundary `nfirst' `kdensfirst')	///
			(kdensity _param if `second', clp(dot)		///
			lcol(purple) boundary `nsecond' `kdenssecond'	///
			xtitle("") ytitle("")				/// 
				ylabel(,angle(0))			///
				by(_pname, title(`"Densities"') 	///
				`argyrescale' `argxrescale'		///
				`everynote' `byparm' `legendoff')	///
				name(`grname',`nameopts')		///
				`savefile'				///
				`legend'				///
				`xtitle' `ytitle' `ylabel' `title')	/// 	
			|| `addplot'
		}
		else if "`show'" == "first" {
			if !`kdensnormal' {
				local legend 				///
				legend(pos(`legpos') ring(0) col(1)	///
				label(1 "overall") label(2 "1st-half")	///
				`legend')		
			}
			else {
				local legend				///
				legend(pos(`legpos') ring(0) col(1)	///
				label(1 "overall")			/// 
				label(2 "Normal density")		///
				label(3 "1st-half")			///
				`legend')		
			}
			if `legendoff' {
				local legend legend(off)
			}
			if `legendoff' {
				local legendoff legend(off)			
			}
			else {
				local legendoff 
			}
			local plot `plot' 				///
			(kdensity _param if `first', clp(dash)		///
			lcol(dkgreen) boundary `nfirst' `kdensfirst'	///
			xtitle("") ytitle("")				/// 
				ylabel(,angle(0))			///
				by(_pname, title(`"Densities"') 	///
				`argyrescale' `argxrescale'		///
				`everynote' `byparm' `legendoff')	///
				name(`grname',`nameopts')		///
				`savefile'				///
				`legend'				///
				`xtitle' `ytitle' `ylabel' `title')	///
			|| `addplot'
		}
		else if "`show'" == "second" {
			if !`kdensnormal' {
				local legend 				///
				legend(pos(`legpos') ring(0) col(1)	///
				label(1 "overall") 			///
				label(2 "2nd-half") `legend')		
			}
			else {
				local legend				///
				legend(pos(`legpos') ring(0) col(1)	///
				label(1 "overall")			/// 
				label(2 "Normal density")		///
				label(3 "2nd-half") `legend')		
			}
			if `legendoff' {
				local legend legend(off)
			}
			if `legendoff' {
				local legendoff legend(off)			
			}
			else {
				local legendoff 
			}
			local plot `plot'				///
			(kdensity _param if `second', clp(dot)		///
			lcol(purple) boundary `nsecond' `kdenssecond'	///
			xtitle("") ytitle("")			/// 
			ylabel(,angle(0))			///
			by(_pname, title(`"Densities"') 	///
			`argyrescale' `argxrescale'		///
			`everynote' `byparm' `legendoff')	///
			name(`grname',`nameopts')		///
			`savefile'				///
			`legend'				///
			`xtitle' `ytitle' `ylabel' `title')	///
			|| `addplot'
		}
		quietly `plot'					
	}
	else if "`kdensity'" != "" & "`combinef'`combine'" != "" {
		local n1 = floor(_N/2)
		local n2 = _N
		// use the first filename
		if `"`saving'"' != "" {
			gettoken filename filelist: filelist
			if `"`filename'"' == "" {
				local filename Graph__1
			}
			local savefile saving(`filename',`saveopts')
		}
		gettoken grname namelist: namelist
		if `"`grname'"' == "" {
			local grname Graph__1
		}
		
		local grcombine ""
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		local nth 0
		while "`vartok'" != "" {
			local nth = `nth' + 1
			quietly summarize `vartok'
			local legpos 11
			if `r(max)' + `r(min)' > 2*`r(mean)' {
				local legpos 1
			}

			local 0 , `alloptions' `graph`nth'opts'
			syntax [anything], [SHOW(string) by(passthru)	///
				GENerate(passthru) LEGend(string asis)	///
				KDENSFirst(string) KDENSSecond(string) *] 
			local legendoff 0
			if `"`legend'"' == "off" {
				local legendoff 1
			} 
			if `"`generate'"' != "" {
				di as err "option {bf:generate()} not allowed"
				exit 198
			}
			if `"`by'"' != "" {
				di as err "option {bf:by()} not allowed"
				exit 191
			}		
			local 0, `options'
			syntax [, 	XTItle(passthru) YTItle(passthru) ///
					TItle(passthru) YLABel(passthru) *]
			local graph`nth'opts `options'
			local 0, `graph`nth'opts'
			syntax ,[ NORmal NORMOPts(string) ///
				  STUdent(string) STOPts(string) *]
			local kdens`nth'normal = "`normal'`normopts'" != ""
			local norm`nth'opts `normopts'
			if `"`show'"' != "none" & "`student'" != "" {
				di as err	/// 	
				"{p 0 4 2}option {bf:student()} not " ///
					"allowed with overlaid graphs; " ///
					"specify {bf:show(none)}{p_end}"
				exit 198
			}
			if `"`show'"' != "none" & "`stopts'" != "" {
				di as err	/// 	
				"{p 0 4 2}option {bf:stopts()} not "   ///
					"allowed with overlaid graphs; "  ///
					"specify {bf:show(none)}{p_end}"
				exit 198
			}
			local graph`nth'opts `options'
			local 0, `kdensfirst'
			syntax ,[ NORmal NORMOPts(string)	///
				  STUdent(string) by(passthru)	/// 	
				  GENerate(passthru)		///
				  STOPts(string) n(passthru) *]
			if `"`by'"' != "" {
				di as err ///
				"{p 0 4 2}suboption {bf:by()} not allowed"
				di as err " in option {bf:kdensfirst()}{p_end}"
				exit 191
			}
			if `"`generate'"' != "" {
				di as err "{p 0 4 2}suboption {bf:generate()} "
				di as err "not allowed"
				di as err " in option {bf:kdensfirst()}{p_end}"
				exit 198
			}	
			if "`normal'" != "" {
				di as err "{p 0 4 2}suboption {bf:normal} "
				di as err "not allowed"
				di as err " in option {bf:kdensfirst()}{p_end}"
				exit 198
			}
			if "`student'" != "" {
				di as err "{p 0 4 2}suboption {bf:student()} "
				di as err "not allowed"
				di as err " in option {bf:kdensfirst()}{p_end}"
				exit 198
			}
			if "`stopts'" != "" {
				di as err "{p 0 4 2}suboption {bf:stopts()} "
				di as err "not allowed"
				di as err " in option {bf:kdensfirst()}{p_end}"
				exit 198
			}
			if "`normopts'" != "" {
				di as err "{p 0 4 2}suboption {bf:normopts()} "
				di as err "not allowed"
				di as err " in option {bf:kdensfirst()}{p_end}"
				exit 198
			}
			local nfirst `n'
			if "`n'" == "" {
				local nfirst n(300)
			}
			local kdensfirst `options'

			local 0, `kdenssecond'
			syntax ,[ NORmal NORMOPts(string) by(passthru)  ///
				  GENerate(passthru)			///
				  STUdent(string) STOPts(string) n(passthru) *]
			if `"`generate'"' != "" {
				di as err "{p 0 4 2}suboption {bf:generate()} "
				di as err "not allowed"
				di as err " in option {bf:kdenssecond()}{p_end}"
				exit 198
			}
			if `"`by'"' != "" {
				di as err "{p 0 4 2}suboption {bf:by()} "
				di as err "not allowed"
				di as err " in option {bf:kdenssecond()}{p_end}"
				exit 191
			}		
			if "`normal'" != "" {
				di as err "{p 0 4 2}suboption {bf:normal} "
				di as err "not allowed"
				di as err " in option {bf:kdenssecond()}{p_end}"
				exit 198
			}
			if "`student'" != "" {
				di as err "{p 0 4 2}suboption {bf:student()} "
				di as err "not allowed"
				di as err " in option {bf:kdenssecond()}{p_end}"
				exit 198
			}
			if "`stopts'" != "" {
				di as err "{p 0 4 2}suboption {bf:stopts()} "
				di as err "not allowed"
				di as err " in option {bf:kdenssecond()}{p_end}"
				exit 198
			}
			if "`normopts'" != "" {
				di as err "{p 0 4 2}suboption {bf:normopts()} "
				di as err "not allowed"
				di as err " in option {bf:kdenssecond()}{p_end}"
				exit 198
			}
			local nsecond `n'
			if "`n'" == "" {
				local nsecond n(300)
			}
			local 0,  `graph`nth'opts'
			syntax, [addplot(string) *]
			local graph`nth'opts `options'
			
			if `"`show'"' == "" | `"`show'"' == "both" {
				local Ngraph
				if !`kdens`nth'normal' {
					local legend`nth'		///
				     	legend(pos(`legpos') ring(0)	///
					col(1) label(1 "overall")	///
					label(2 "1st-half")		///
					label(3 "2nd-half") `legend')
				}
				else {
					local legend`nth'		///
				     	legend(pos(`legpos') ring(0)	///
					col(1) label(1 "overall")	///
					label(2 "Normal density")	///
					label(3 "1st-half")		///
					label(4 "2nd-half") `legend')

					local Ngraph			///
					(fn_normden `vartok',		///
					yvarlab("normal `vartok'")	///
					lstyle(refline)			///
					range(`vartok')			///
					`norm`nth'opts')
				}
				if `legendoff' {
					local legend`nth' legend(off)
				}
				if `numpars' > 1 {
					quietly twoway 			///
					(kdensity `vartok',		///
					clp(solid)			///
					lcol(dknavy)			///
					boundary			///
					note("") `graph`nth'opts')	///
					`Ngraph'			///
					(kdensity `vartok'		///
					in 1/`n1' , boundary		///
					clp(dash) lcol(dkgreen)		///
					`nfirst' `kdensfirst')		///
					(kdensity `vartok' in `n1'/`n2'	///
					, clp(dot) lcol(purple)		///
					boundary			///
					`nsecond' `kdenssecond'		///
					`legend`nth''			///
					xtitle("") ytitle("")		///
					ylabel(,angle(0))		///
					title(`"{bf:`partok'}"')	///
					name(_`nth'_kdens, replace)	///
					nodraw `xtitle' `ytitle'	///
					`title' `ylabel') || 		///
					`addplot'			   
					local grcombine `grcombine' 	///
						_`nth'_kdens
				}
				else {
					quietly twoway			 ///
					(kdensity `vartok' 		 ///
					, clp(solid)	 		 ///
					lcol(dknavy) note("")		 ///
					boundary			 ///
					`graph`nth'opts') 	 	 ///
					`Ngraph'			 ///
					(kdensity `vartok'		 ///
					in 1/`n1', boundary		 ///
					clp(dash) lcol(dkgreen)		 ///
					`nfirst' `kdensfirst')		 ///
				    	(kdensity `vartok'		 ///
					in `n1'/`n2',			 ///
					boundary		 	 ///
					clp(dot) lcol(purple)		 ///
					`nsecond' `kdenssecond'		 ///
					`legend`nth''			 ///
					xtitle("") ytitle("")		 ///
					ylabel(,angle(0))		 ///
					`everynote'			 ///
					title(				 ///
					`"Density of {bf:`partok'}"')	 ///
					name(`grname',`nameopts')	 ///
					`savefile' `xtitle' `ytitle'	 ///
					`title' `ylabel') ||	 ///
					`addplot'
				}
			} // end of both
			else if `"`show'"' == "first" {
				local Ngraph
				if !`kdens`nth'normal' {
					local legend`nth'		///
				     	legend(pos(`legpos') ring(0)	///
					col(1) label(1 "overall")	///
					label(2 "1st-half")		///
					`legend')
				}
				else {
					local legend`nth'		///
				     	legend(pos(`legpos') ring(0)	///
					col(1) label(1 "overall")	///
					label(2 "Normal density")	///
					label(3 "1st-half")		///
					`legend')

					local Ngraph			///
					(fn_normden `vartok',		///
					yvarlab("normal `vartok'")	///
					lstyle(refline)			///
					range(`vartok')			///
					`norm`nth'opts')
				}
				if `legendoff' {
					local legend`nth' legend(off)
				}
				if `numpars' > 1 {
					quietly twoway (kdensity	///
					`vartok', clp(solid)		///
					lcol(dknavy)			///
					note("") boundary		///
					`graph`nth'opts')		///
					`Ngraph'			///
					(kdensity `vartok'		///
					in 1/`n1',			///
					boundary			///
					clp(dash) lcol(dkgreen)		///
					`nfirst' `kdensfirst'		///
					`legend`nth''			///
					xtitle("") ytitle("")		///
					ylabel(,angle(0))		///
					title(`"{bf:`partok'}"')	///
					name(_`nth'_kdens, replace)	///
					nodraw `xtitle' `ytitle'	///
					`title' `ylabel')		///
					|| `addplot'	
					local grcombine `grcombine' 	///
						_`nth'_kdens
				}
				else {
					quietly twoway			///
					(kdensity `vartok',		///
					clp(solid) lcol(dknavy) 	///
					note("") boundary		///
					`graph`nth'opts')		///
					`Ngraph'			///
					(kdensity `vartok' in 1/`n1',	///
					clp(dash) lcol(dkgreen)		///
					boundary			///
					`nfirst' `kdensfirst'		///
					`legend`nth''			///
					xtitle("") ytitle("") 		///
					`everynote'			///
					ylabel(,angle(0)) title(	///
					`"Density of {bf:`partok'}"')	///
					name(`grname',`nameopts')	///
					`savefile' 			///
					`xtitle' `ytitle' `ylabel'	///
					`title')			///
					|| `addplot'		
				}	
			}
			else if `"`show'"' == "second" {
				local Ngraph
				if !`kdens`nth'normal' {
					local legend`nth'		///
				     	legend(pos(`legpos') ring(0)	///
					col(1) label(1 "overall")	///
					label(2 "2nd-half") `legend')
				}
				else {
					local legend`nth'		///
				     	legend(pos(`legpos') ring(0)	///
					col(1) label(1 "overall")	///
					label(2 "Normal density")	///
					label(3 "2nd-half") `legend')

					local Ngraph			///
					(fn_normden `vartok',		///
					yvarlab("normal `vartok'")	///
					lstyle(refline)			///
					range(`vartok')			///
					`norm`nth'opts')
				}
				if `legendoff' {
					local legend`nth' legend(off)
				}
				if `numpars' > 1 {
					quietly twoway			 ///
					(kdensity `vartok'		 ///
					, clp(solid)			 ///
					lcol(dknavy) note("")		 ///
					boundary			 ///
					`graph`nth'opts')    		 ///
					`Ngraph'			 ///
					(kdensity `vartok' in `n1'/`n2'	 ///
					,	 			 ///
					boundary		 	 ///
					clp(dot) lcol(purple)		 ///
					`nsecond' `kdenssecond'		 ///
					`legend`nth''			 ///
					xtitle("") ytitle("")		 ///
					ylabel(,angle(0))		 ///
					title(`"{bf:`partok'}"')	 ///
					`xtitle' `ytitle' `ylabel'	 ///
					`title'				 ///
					name(_`nth'_kdens, replace)	 ///
					nodraw)	 			 ///	
					|| `addplot'			   
					local grcombine `grcombine' 	///
						_`nth'_kdens
				}
				else {
					quietly twoway			 ///
					(kdensity `vartok'		 ///
					, clp(solid)			 ///
					lcol(dknavy) note("")		 ///
					boundary			 ///
					`graph`nth'opts')		 ///
					`Ngraph'			 ///	
					(kdensity `vartok' in `n1'/`n2'	 ///
					,	 			 ///
					boundary		 	 ///
					clp(dot) lcol(purple)		 ///
					`nsecond' `kdenssecond'		 ///
					`legend`nth''			 ///
					xtitle("") ytitle("")		 ///
					ylabel(,angle(0))		 ///
					`everynote'			 /// 	
					title(				 ///
					`"Density of {bf:`partok'}"')	 ///
					name(`grname',`nameopts')	 ///
					`savefile' `xtitle' `ytitle'	 ///
					`title' `ylabel')		 ///	
					|| `addplot'
				}
			} // end of second
			else if `"`show'"' == "none" {				
				local Ngraph
				if `kdens`nth'normal' {
					local Ngraph			///
					(fn_normden `vartok',		///
					yvarlab("normal `vartok'")	///
					lstyle(refline)			///
					range(`vartok')			///
					`norm`nth'opts')

					local legend`nth'		///
				     	legend(pos(`legpos') ring(0)	///
					col(1) label(1 "overall")	///
					label(2 "Normal density") `legend')
				}
				if `legendoff' {
					local legend`nth' legend(off)
				}
				if `numpars' > 1 {
					quietly twoway			///
					(kdensity `vartok',		///
					boundary			///
					clp(solid) lcol(dknavy)		///
					xtitle("") ytitle("")		///
					ylabel(,angle(0))		///
					title(`"{bf:`partok'}"')	///
					`legend`nth''			///
					`graph`nth'opts'		///
					name(_`nth'_kdens, replace)	///
					nodraw `xtitle' `ytitle'	///
					`ylabel' `title') `Ngraph' ||	///
					 `addplot'		
		   			local grcombine `grcombine' 	///
						_`nth'_kdens
				}
				else {
					quietly twoway 			///
					(kdensity `vartok',	 	///
					boundary			///
					clp(solid) lcol(dknavy)		///
					xtitle("") ytitle("")		///
					ylabel(,angle(0))		///
					`legend`nth''			///
					`everynote'			///
					title(				///
					`"Density of {bf:`partok'}"')	///
					`graph`nth'opts'		///
					name(`grname',`nameopts')	///
					`savefile'			///
					`xtitle' `ytitle' 		///
					`ylabel' `title')		///
					`Ngraph' || `addplot'
				}
			} // end of none
			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
		}		

		if `numpars' > 1 {
			graph combine `grcombine',		///
				col(`cols') imargin(small)	/// 
				title(`"Density plots"')	///
				`everynote'			///
				`combine'			///         
				name(`grname',`nameopts')	///
				`savefile' 
				
			gettoken next grcombine: grcombine
			while "`next'" != "" {
				quietly graph drop `next'
				gettoken next grcombine: grcombine
			}
		}
	}	
	else if "`kdensity'" != "" {
		local n1 = floor(_N/2)
		local n2 = _N
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		gettoken filename filelist: filelist
		gettoken grname namelist: namelist
		local nth 0
		while "`vartok'" != "" {
			local nth = `nth' + 1
			if `"`saving'"' != "" {
				if `"`filename'"' == "" {
					local filename Graph__`nth'
				}
				local savefile saving(`filename',`saveopts')
			}
			if `"`grname'"' == "" {
				local grname Graph__`nth'
			}
			quietly summarize `vartok'
			local legpos 11
			if `r(max)' + `r(min)' > 2*`r(mean)' {
				local legpos 1
			}
			local note 
			local g: char `vartok'[one]
			local g = subinstr("`g'",":", ":  ",1)
			local g = subinstr(`"`g'"',"{","[",.)
			local g = subinstr(`"`g'"',"}","]",.)	
			local g = subinstr(`"`g'"',"[","{c -(}",.)
			local g = subinstr(`"`g'"',"]","{c )-}",.)
			if `"`g'"' != "" {
				local note = `"`note' "' + ///
					char(34) + `"`g'"' + char(34)
			}
			if "`everynote'" != "" {
				local everynote`nth' note("`everynote'" `note')
			}
			else if `"`note'"' != "" {
				local everynote`nth' note(`note')
			}
			local 0 , `alloptions' `graph`nth'opts'
			syntax [anything], [SHOW(string) by(passthru) 	///
				GENerate(passthru) LEGend(string asis)	///
				KDENSFirst(string) KDENSSecond(string) *] 
			local legendoff 0
			if `"`legend'"' == "off" {
				local legendoff 1
			}
			if `"`by'"' != "" {
				di as err "option {bf:by()} not allowed"
				exit 191
			}
			if `"`generate'"' != "" {
				di as err "option {bf:generate()} not allowed"
				exit 198
			}	
			local graph`nth'opts `options'
			local 0, `graph`nth'opts'
			syntax [, 	XTItle(passthru) YTItle(passthru) ///
					TItle(passthru) YLABel(passthru) *]
			local graph`nth'opts `options'
			syntax ,[ NORmal NORMOPts(string) ///
				  STUdent(string) STOPts(string) *]
			local kdens`nth'normal = "`normal'`normopts'" != ""
			local norm`nth'opts `normopts'
			if `"`show'"' != "none" & "`student'" != "" {
				di as err				 /// 
				"{p 0 4 2}option {bf:student()} not " 	 ///
					"allowed with overlaid graphs; " ///
					"specify {bf:show(none)}{p_end}"
				exit 198
			}
			if `"`show'"' != "none" & "`stopts'" != "" {
				di as err			 	 /// 
				"{p 0 4 2}option {bf:stopts()} not "  	 ///
					"allowed with overlaid graphs; " ///
					"specify {bf:show(none)}{p_end}"
				exit 198
			}
			local graph`nth'opts `options'
			local 0, `kdensfirst'
			syntax ,[ NORmal NORMOPts(string) by(passthru)  ///
				  GENerate(passthru)			///
				  STUdent(string) STOPts(string) n(passthru) *]
			if `"`generate'"' != "" {
				di as err "{p 0 4 2} suboption {bf:generate()} "
				di as err ///
				"not allowed in option {bf:kdensfirst()}"
				di as err "{p_end}"
				exit 198
			}
			if `"`by'"' != "" {
				di as err "{p 0 4 2} suboption {bf:by()} "
				di as err ///
				"not allowed in option {bf:kdensfirst()}"
				di as err "{p_end}"
				exit 191
			}		
			if "`normal'" != "" {
				di as err "{p 0 4 2} suboption {bf:normal} "
				di as err ///
				"not allowed in option {bf:kdensfirst()}"
				di as err "{p_end}"
				exit 198
			}
			if "`student'" != "" {
				di as err "{p 0 4 2} suboption {bf:student()} "
				di as err ///
				"not allowed in option {bf:kdensfirst()}"
				di as err "{p_end}"
				exit 198
			}
			if "`stopts'" != "" {
				di as err "{p 0 4 2} suboption {bf:stopts()} "
				di as err ///
				"not allowed in option {bf:kdensfirst()}"
				di as err "{p_end}"
				exit 198
			}
			if "`normopts'" != "" {
				di as err "{p 0 4 2} suboption {bf:normopts()} "
				di as err ///
				"not allowed in option {bf:kdensfirst()}"
				di as err "{p_end}"
				exit 198
			}
			local nfirst `n'
			if "`n'" == "" {
				local nfirst n(300)
			}
			local kdensfirst `options'
			local 0, `kdenssecond'
			syntax ,[ NORmal NORMOPts(string) by(passthru)  ///
				  GENerate(passthru)			///
				  STUdent(string) STOPts(string) n(passthru) *]
			if `"`generate'"' != "" {
				di as err "{p 0 4 2} suboption {bf:generate()} "
				di as err ///
				"not allowed in option {bf:kdenssecond()}"
				di as err "{p_end}"
				exit 198
			}
			if `"`by'"' != "" {
				di as err "{p 0 4 2} suboption {bf:by()} "
				di as err ///
				"not allowed in option {bf:kdenssecond()}"
				di as err "{p_end}"
				exit 191
			}		
			if "`normal'" != "" {
				di as err "{p 0 4 2} suboption {bf:normal} "
				di as err ///
				"not allowed in option {bf:kdenssecond()}"
				di as err "{p_end}"
				exit 198
			}
			if "`student'" != "" {
				di as err "{p 0 4 2} suboption {bf:student()} "
				di as err ///
				"not allowed in option {bf:kdenssecond()}"
				di as err "{p_end}"
				exit 198
			}
			if "`stopts'" != "" {
				di as err "{p 0 4 2} suboption {bf:stopts()} "
				di as err ///
				"not allowed in option {bf:kdenssecond()}"
				di as err "{p_end}"
				exit 198
			}
			if "`normopts'" != "" {
				di as err "{p 0 4 2} suboption {bf:normopts()} "
				di as err ///
				"not allowed in option {bf:kdenssecond()}"
				di as err "{p_end}"
				exit 198
			}
			local nsecond `n'
			if "`n'" == "" {
				local nsecond n(300)
			}
			local kdenssecond `options'
			local 0, `graph`nth'opts'
			syntax [, addplot(string) *]
			local graph`nth'opts `options'

			if `"`show'"' == "" | `"`show'"' == "both" {
				local Ngraph
				if !`kdens`nth'normal' {
					local legend`nth'		///
				     	legend(pos(`legpos') ring(0)	///
					col(1) label(1 "overall")	///
					label(2 "1st-half")		///
					label(3 "2nd-half") `legend')
				}
				else {
					local legend`nth'		///
				     	legend(pos(`legpos') ring(0)	///
					col(1) label(1 "overall")	///
					label(2 "Normal density")	///
					label(3 "1st-half")		///
					label(4 "2nd-half") `legend')

					local Ngraph			///
					(fn_normden `vartok',		///
					yvarlab("normal `vartok'")	///
					lstyle(refline)			///
					range(`vartok')			///
					`norm`nth'opts')
				}
				if `legendoff' {
					local legend`nth' legend(off)
				}
				quietly twoway (kdensity `vartok'	///
				,					///
				boundary clp(solid)			/// 
				lcol(dknavy) note("") `graph`nth'opts')	///
				`Ngraph'				///
				(kdensity `vartok' in 1/`n1',		///
				clp(dash)				///
				boundary				///
				lcol(dkgreen) `nfirst' `kdensfirst')	///
				(kdensity `vartok' in `n1'/`n2'		///
				,	 				///
				boundary				///
				clp(dot) lcol(purple) `nsecond'		/// 	
				`kdenssecond'				///
				`legend`nth''				///
				xtitle("") ytitle("") ylabel(,angle(0))	///
				`everynote`nth''			///
				title(`"Density of {bf:`partok'}"')	///
				name(`grname',`nameopts')		///
				`savefile' `xtitle' `ytitle'		///
				`ylabel' `title') ||			///
				`addplot'				
			} // end of both
			else if `"`show'"' == "first" {
				local Ngraph
				if !`kdens`nth'normal' {
					local legend`nth'		///
				     	legend(pos(`legpos') ring(0)	///
					col(1) label(1 "overall")	///
					label(2 "1st-half")		///
					`legend')
				}
				else {
					local legend`nth'		///
				     	legend(pos(`legpos') ring(0)	///
					col(1) label(1 "overall")	///
					label(2 "Normal density")	///
					label(3 "1st-half")		///
					`legend')

					local Ngraph			///
					(fn_normden `vartok',		///
					yvarlab("normal `vartok'")	///
					lstyle(refline)			///
					range(`vartok')			///
					`norm`nth'opts')
				}
				if `legendoff' {
					local legend`nth' legend(off)
				}
				quietly twoway				///
				(kdensity `vartok', clp(solid)		///
				boundary				///
				lcol(dknavy) note("") `graph`nth'opts')	///
				`Ngraph'				///
				(kdensity `vartok' in 1/`n1'		/// 	
				, clp(dash)				///
				boundary				///
				lcol(dkgreen) `nfirst' `kdensfirst'	///
				`legend`nth'' xtitle("") ytitle("")	///
				ylabel(,angle(0)) title(		///
				`"Density of {bf:`partok'}"')		///
				`everynote`nth''			///
				name(`grname',`nameopts')		///
				`savefile' `xtitle' `ytitle'		///
				`ylabel' `title')			/// 	
				|| `addplot'					
			} // end of first
			else if `"`show'"' == "second" {
				local Ngraph
				if !`kdens`nth'normal' {
					local legend`nth'		///
				     	legend(pos(`legpos') ring(0)	///
					col(1) label(1 "overall")	///
					label(2 "2nd-half") `legend')
				}
				else {
					local legend`nth'		///
				     	legend(pos(`legpos') ring(0)	///
					col(1) label(1 "overall")	///
					label(2 "Normal density")	///
					label(3 "2nd-half") `legend')

					local Ngraph			///
					(fn_normden `vartok',		///
					yvarlab("normal `vartok'")	///
					lstyle(refline)			///
					range(`vartok')			///
					`norm`nth'opts')
				}
				if `legendoff' {
					local legend`nth' legend(off)
				}
				quietly twoway (			///
				kdensity `vartok', clp(solid)		///
				boundary				///
				lcol(dknavy) note("") `graph`nth'opts')	///
				`Ngraph'				///	
				(kdensity `vartok' in `n1'/`n2'		///
				,					///
				boundary				///
				clp(dot) lcol(purple) `nsecond'		/// 
				`kdenssecond'				///
				`legend`nth'' xtitle("") ytitle("")	///
				ylabel(,angle(0)) title(		///
				`"Density of {bf:`partok'}"')		///
				`everynote`nth''			///
				name(`grname',`nameopts')		///
				`savefile' `xtitle' `ytitle'		///
				`ylabel' `title') ||			///
				`addplot'				
			} // end of second
			else if `"`show'"' == "none" {
				local Ngraph
				if `kdens`nth'normal' {
					local Ngraph			///
					(fn_normden `vartok',		///
					yvarlab("normal `vartok'")	///
					lstyle(refline)			///
					range(`vartok')			///
					`norm`nth'opts')

					local legend`nth'		///
				     	legend(pos(`legpos') ring(0)	///
					col(1) label(1 "overall")	///
					label(2 "Normal density") `legend')
				}				
				if `legendoff' {
					local legend`nth' legend(off)
				}
				quietly twoway (kdensity `vartok'	///	
				,					///	
				boundary clp(solid)			///
				lcol(dknavy)				///
				`legend`nth'' xtitle("") ytitle("")	///
				ylabel(,angle(0)) title(		///
				`"Density of {bf:`partok'}"')		///
				`everynote`nth''			///
				`graph`nth'opts' name(`grname',		///
				`nameopts') `savefile' `xtitle'		///
				`ytitle' `ylabel' `title') 		///
				`Ngraph' || `addplot'
			} // end of none
			if "`sleep'" != "" {
				sleep `sleep'
			}
			local ogname `grname'
			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
			gettoken filename filelist: filelist
			gettoken grname namelist: namelist
				
			if "`vartok'" != "" & `"`wait'"' == "wait" {
				more
			}
			if "`close'" != "" & "`vartok'" != "" {
				graph close `ogname'
			}

		}
	}
}  // end of noi capture break
	set more `omore'
	if _rc {
		restore
		exit _rc
	}
	if "`genecusum'" == "" {
		restore
	}
	else {
		restore, not
	}
end

program ParseGraphType, rclass
	local syntargs DIAGnostics trace ac HISTogram KDENSity cusum matrix
	syntax, [`syntargs' *]
	if "`options'" != "" {
		gettoken opt : options
		if `"`opt'"' == "{" | `"`opt'"' == "}" {
			di as err "`opt' invalid graph type"		
		}
		else 	di as err "{bf:`opt'} invalid graph type"
		exit 198
	}
	local ret `diagnostics'`trace'`ac'`histogram'`kdensity'`cusum'`matrix'
	foreach word of local syntargs {
		local uword = lower("`word'")
		c_local `uword' ``uword''
	}
	if "`ret'" == "" {
		di as err "graph type not specified"
		exit 198
	}
	return local graphtype `ret'  
end

exit

