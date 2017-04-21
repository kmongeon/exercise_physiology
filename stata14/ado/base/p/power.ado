*! version 1.1.2  22aug2016
program power
	version 13
	tempname rhold
	_return hold `rhold'
	cap noi power_rsafe `0'
	if (_rc) {
		_return restore `rhold'
		exit _rc
	}
	sreturn clear
end

program power_rsafe

	// get method name and arguments
	_parse comma lhs rhs : 0
	gettoken method lhs : lhs
	local 0 `rhs'

	syntax [, 	test 						///
			SAVing(string asis) 				///
			GRaph GRaph1(string asis) GRSAVing(string asis) ///
			NOTABle TABle TABle1(string asis) NOTItle 	///
			/*undoc.*/ programok twosample			///
			* ]
	if (`"`graph'`graph1'"'!="") {
		local tograph 1
	}
	else {
		local tograph 0
	}
	if (`tograph' & `"`table'`table1'"'=="") {
		local notable notable
		local notitle notitle
	}
	local rhs `"`options' `notable' `table' `graph' `notitle' `programok'"'
	if (`"`table1'"'!="") {
		local rhs `"`rhs' table1(`table1')"'
	} 
	if (`"`graph1'"'!="") {
		local rhs `"`rhs' graph1(`graph1')"'
	} 

	// test
	local type test	
	_power_method_check method methname user : ///
					    `"`method'"' "`type'" "`programok'"
	if ("`user'"=="" & "`programok'`twosample'"!="") {
		di as err "{p}Options {bf:programok} and {bf:twosample} " ///
			  "are allowed only with "	 		  ///
			  "user-defined {bf:power} methods.{p_end}"
		exit 198
	}

	// saving()
	if `"`saving'"'!="" {
		_savingopt_parse fname replace : saving ".dta" `"`saving'"'
		if ("`replace'"=="") {
			confirm new file `"`fname'"'
		}
		local rhs `"`rhs' saving(`saving')"'
	}
	// grsaving()
	if `"`grsaving'"'!="" {
		_savingopt_parse grfname grreplace : ///
					grsaving ".dta" `"`grsaving'"'
		if ("`grreplace'"=="") {
			confirm new file `"`grfname'"'
		}
		local rhs `"`rhs' grsaving(`grsaving')"'
	}

	// create and initialize main class object
	cap noi {
		mata: u_mi_get_mata_instanced_var("PSSobj","__power_obj")
		if ("`user'"!="") {
			cap mata: `PSSobj' = _PSS_`method'_`type'()
			if _rc {
				cap mata: `PSSobj' = _PSS_`method'()
				if _rc {
					if ("`twosample'"=="") { 
						//one-sample user method
						mata: `PSSobj' = _PSS_`type'()
					}
					else { //two-sample user method
						mata: `PSSobj' = _PSS_twotest()
					}
					local user ado
				}
				else {
					local user mataclass
				}
			}
			else {
				local user mataclass
			}
			mata: `PSSobj'.setuserdefined("`user'")
		}
		else {
			mata: `PSSobj' = _PSS_`method'_`type'()
		}
	}
	local rc = _rc
	if `rc' {
		cap mata: mata drop `PSSobj'
		exit `rc'
	}
	if (`tograph') {
		// get user-specified dimensions
		_getusergrcols ydim xdim grcols graphopts gromit grforce : ///
								`"`graph1'"'
		if ("`grcols'"=="") local rhs `"`rhs' usergrcols(graph)"'
		else local rhs `"`rhs' usergrcols(`grcols')"'
		local usergrcols `grcols'
		local rhs `"`rhs' ydimopt(`ydim')"'
	}
	// execute command
	cap noi _power `method' `methname' `type' "`user'" `PSSobj' `lhs', `rhs'
	local rc = _rc
	// save table data
	if (!`rc' & `"`saving'"'!="") {
		preserve
		qui clear
		tempname tab
		mat `tab' = r(pss_table)
		local vars `r(columns)'
		local labels `"`r(collabels)'"'
		local nvars = colsof(`tab')
		qui svmat double `tab', names(col)
		foreach var of local vars {
			gettoken lab labels : labels
			qui label variable `var' `"`lab'"'
		}
		qui compress
		save `"`fname'"', `replace'
		restore
	}
	if (!`rc' & `tograph') {
		// get default options and plotted columns
		mata: `PSSobj'.getgropts("`ydim'","`xdim'",	///
					 "defgrcols","defgropts")
		local grcols `defgrcols' `usergrcols'
		if ("`gromit'"!="" & "`grforce'"=="" & ///
		    `: list gromit in grcols') {
			local didefgrcols : list uniq defgrcols
			di as err "{p 0 9 2}{bf:graph()}: option "
			di as err "{bf:omitcolumns()} may not contain any of "
			di as err "the default columns "
			di as err "{bind:({bf:`didefgrcols'})} "
			di as err "or specified columns{p_end}"
			exit 198 
		}
		local grcols : list uniq grcols
		// by default or with -power()-, omit power if beta is used 
		// unless power is also used; vice versa when -beta()- is 
		// specified
		mata: `PSSobj'.st_is_beta("is_beta")
		if (`is_beta') {
			local keepcol power
			local rmcol beta
		}
		else {
			local keepcol beta
			local rmcol power
		}
		if (`: list keepcol in grcols') { 
			if (!`: list rmcol in usergrcols') {
				local gromit `gromit' `rmcol'
				local defgropts : subinstr local defgropts ///
					  "defx(`rmcol')" ""
				local defgropts : subinstr local defgropts ///
					  "defy(`rmcol')" ""
			}
		}
		// target and delta
		mata: st_local("target", `PSSobj'.Target1.param)
		local rmcol `target'
		local keepcol delta
		if ("`rmcol'"!="`keepcol'" & `: list keepcol in grcols') { 
			if (!`: list rmcol in usergrcols') {
				local gromit `gromit' `rmcol'
				local defgropts : subinstr local defgropts ///
					  "defx(`rmcol')" ""
				local defgropts : subinstr local defgropts ///
					  "defy(`rmcol')" ""
			}
		}
		local keepcol target
		if (`: list keepcol in grcols') { 
			if (!`: list rmcol in usergrcols') {
				local gromit `gromit' `rmcol'
				local defgropts : subinstr local defgropts ///
					  "defx(`rmcol')" ""
				local defgropts : subinstr local defgropts ///
					  "defy(`rmcol')" ""
			}
		}
		local grcols : list grcols - gromit
		preserve
		mata: `PSSobj'.getgrdata("`grcols'")
		if (`"`grsaving'"'!="") {
			save `"`grfname'"', `grreplace'
		}
		// plot data
		_pss_graph, `defgropts' `graphopts'
		restore
	}

	// clean up
	mata: mata drop `PSSobj'

	exit `rc'
end

program _power
	gettoken method 0 : 0	
	gettoken methname 0 : 0	
	gettoken type 0 : 0
	gettoken user 0 : 0	
	gettoken pssobj 0 : 0
	
	_parse comma lhs rhs : 0
	local 0 `"`rhs'"'
	syntax [, usergrcols(string) ydimopt(string) /*internal*/ ///
		  programok /*undoc.*/ * ]
	local rhs `", `options'"'
	local cmdlhs `"`lhs'"'
	local cmdrhs `"`rhs'"'

	if ("`user'"!="ado") { 
		local topass pssobj(`pssobj') `type'
	}
	if ("`usergrcols'"=="graph") {
		local usergraph graph
		local usergrcols
	}
	else if ("`usergrcols'"!="") {
		local usergraph graph
	}
	if (`"`cmdrhs'"'=="") {
		local cmdrhs , 
	}
	local cmdrhs `cmdrhs' `topass'	
	local 0 `rhs'
	syntax [, PARallel NOTABle TABle TABle1(string asis) LOG DOTS ///
		  GRaph1(string asis) Graph * ]
	local rhs , `"`options' `log' `dots'"'

	if (`"`table1'"'!="") local table table
	opts_exclusive "`table' `notable'"
	local table `table'`notable'
	if ("`user'"=="ado" & "`notable'"=="") { //table output is default
						 //for user ado methods
		local table table
	}


	//check common options
	if ("`type'"=="test") {
		local cmnopts solvefor power beta alpha n n1 n2 nratio 
		local cmnopts `cmnopts' onesided direction
	}

	if (`"`graph1'`graph'"'==""){
		_pss_chk_`type'mainopts `cmnopts' rest cmnnumopts : ///
				`", pssobj(`pssobj') `options'"'		
	}
	else {
		_pss_chk_`type'mainopts `cmnopts' rest cmnnumopts : ///
				`", pssobj(`pssobj') `options' graph"'
	}				
	// run method-specific parser if exists
	cap findfile power_cmd_`method'_parse.ado
	local rc = _rc
	if (`rc' & "`user'"=="ado" & "`programok'"!="") {
		cap program list power_cmd_`method'_parse
		local rc = (_rc==111)
	}
	if !(`rc') {
		power_cmd_`method'_parse `cmdlhs' `cmdrhs'
	}

	// handle method-specific numlist options
	if ("`user'"=="ado") { //parser can also set s() results
		cap findfile power_cmd_`method'_init.ado
		local rc = _rc
		if (`rc' & "`programok'"!="") {
			cap program list power_cmd_`method'_init
			local rc = (_rc==111)
		}
		if !(`rc') { 
			power_cmd_`method'_init `0'
		}
		local numopts "`s(pss_numopts)'"
		local numopts : list numopts - cmnnumopts
		local usertarget "`s(pss_target)'"
		if ("`s(pss_notabdelta)'"!="") {
			local nodelta "notabdelta"
		}
		
		if ("`usergraph'"!="" & "`ydimopt'"=="" & 		///
		    "`solvefor'"=="esize" & "`usertarget'"=="") {
			di as err "{p}{bf:power}: incorrect user "
			di as err "specification{p_end}"
			di as err "{p 4 4 2} default graphical output "
			di as err "for effect-size determination "
			di as err "requires that "
			di as err "{bind:{bf:power_cmd_`method'_init.ado}} or"
			di as err "{bind:{bf:power_cmd_`method'_parse.ado}} "
			di as err "stores the name of the return "
			di as err "scalar containing the value of "
			di as err "the estimated target parameter in "
			di as err "{bf:s(pss_target)}{p_end}"
			exit 198
		}
		/*Note: uses Stata macros called 'matamac1', 'matamac2',
			'matafrommac', and 'matarmmac'*/
		mata: `pssobj'.inituserado( "`numopts'", 		///
					    "`s(pss_colnames)'",	///
					    "`s(pss_tabcolnames)'",	///
					    "`s(pss_allcolnames)'",	///
					    "`s(pss_alltabcolnames)'",	///
					   `"`s(pss_collabels)'"',	///
					   `"`s(pss_colformats)'"',	///
					    "`s(pss_colwidths)'",	///
					   `"`s(pss_colgrlabels)'"',	///
					   `"`s(pss_colgrsymbols)'"',	///
					    "`usertarget'",		///
					   `"`s(pss_targetlabel)'"',	///
					    "`s(pss_delta)'",		///
					    "`s(pss_argnames)'",	///
					    "`s(pss_titletest)'",	///
					    "`s(pss_subtitle)'",	///
					    "`s(pss_hyp_lhs)'",		///
					    "`s(pss_hyp_rhs)'",		///
					    "`s(pss_grhyp_lhs)'",	///
					    "`s(pss_grhyp_rhs)'",	///
					    "`nodelta'",		///
					    "`method'"			///
					  )
		
	}
	mata: st_local("numopts",`pssobj'.synnumopts) 
	if ("`numopts'"=="") {
		mata: st_local("numopts",`pssobj'.numopts)
	}
	local numopts : list numopts - cmnnumopts
	foreach opt of local numopts {
		local SYNOPTS `SYNOPTS' `opt'(numlist)
	}
	local 0 , `rest'
	syntax [, `SYNOPTS' * ]
	local otheropts `options' `topass'

	// init method
	mata: `pssobj'.initmain("`method'","`methname'",`"`otheropts'"', 1)

	// build argument list -- -power <method> <arglist> [, ...]- assumed
	// each argument values are stored in macros 1, 2, ..., respectively
	// arguments and multiple numbers in them are always allowed; 
	// power_cmd_<method>_parse should handle cases when such
	// syntax is not allowed
	local lhscp `lhs'
	local i 0
	while (`"`lhscp'"'!="") {
		gettoken arg lhscp : lhscp, match(par)
		local ++i
		qui numlist `"`arg'"'
		local `i' `r(numlist)'
	}
	local nargs `i'
	// init numlist options and arguments
	mata: `pssobj'.initnumopts(`nargs')

	// table() options
	_parse comma tablhs tabrhs : table1
	if (`"`tabrhs'"'=="") {
		local tabrhs ,
	}
	_pss_chk_tableopts byrow : `"`tablhs' `tabrhs' pssobj(`pssobj') `table'"'
	if ("`byrow'"!="" & "`log'`dots'"!="") {
		di as err "{bf:table()}'s suboption {bf:byrow} may not be " ///
			  "combined with {bf:`log'`dots'}"
		exit 198
	} 
	//check if specified graph columns are valid
	if (`"`usergrcols'"'!="") { 
		mata: st_local("allcolnames", `pssobj'.allcolnames)
		local notallowed : list usergrcols - allcolnames
		if ("`notallowed'"!="") {
			di as err "{p}{bf:graph()}: invalid "
			di as err plural(`: list sizeof notallowed',"column")
			di as err " specified{p_end}"
			di as err "{p 4 4 2}Some of the dimension options "
			di as err "include invalid columns.{p_end}"
			exit 198
		}
	}

	//clear current r() results
	mata: st_rclear()

	// do nested or parallel computations
	cap noi mata: `pssobj'.loop(("`parallel'"==""))
	local rc = _rc
	if (`rc') exit(`rc')

	//store r() results
	mata: `pssobj'.rresults()

	// output 
	if ("`byrow'"=="") {
		mata: `pssobj'.print()
	}
	else {
		mata: `pssobj'.is_tabsplit("split")
		if (!`split') {
			mata: `pssobj'.bottom()
		}
	}
end

program _power_method_check
	args macm macmname user colon method type programok

	if (`"`method'"'=="") {
		di as err "method must be specified"
		exit 198
	}

	local len = strlen(`"`method'"')
	if (`"`method'"'==bsubstr("onecorrelation",1,max(7,`len'))) {
		c_local `macm' "onecorr"
		c_local `macmname' "onecorrelation"
		exit
	}
	if (`"`method'"'=="onemean") {
		c_local `macm' "onemean"
		c_local `macmname' "onemean"
		exit
	}
	if (`"`method'"'==bsubstr("oneproportion",1,max(7,`len'))) {
		power_err_`type'method "oneproportion"
		c_local `macm' "oneprop"
		c_local `macmname' "oneproportion"
		exit
	}
	if (`"`method'"'==bsubstr("onevariance",1,max(6,`len'))) {
		c_local `macm' "onevar"
		c_local `macmname' "onevariance"
		exit
	}
	if (`"`method'"'==bsubstr("pairedmeans",1,max(7,`len'))) {
               	c_local `macm' "pairedm"
               	c_local `macmname' "pairedmeans"
               	exit
	}
	if (`"`method'"'==bsubstr("pairedproportions",1,max(7,`len'))) {
		power_err_`type'method "pairedproportions"
		c_local `macm' "pairedpr"
		c_local `macmname' "pairedproportions"
		exit
	}
	if (`"`method'"'==bsubstr("twocorrelations",1,max(7,`len'))) {
		power_err_`type'method "twocorrelations"
		c_local `macm' "twocorr"
		c_local `macmname' "twocorrelations"
		exit
	}
	if (`"`method'"'=="twomeans") {
		c_local `macm' "twomeans"
		c_local `macmname' "twomeans"
		exit
	}
	if (`"`method'"'==bsubstr("twoproportions",1,max(7,`len'))) {
		power_err_`type'method "twoproportions"
		c_local `macm' "twoprop"
		c_local `macmname' "twoproportions"
		exit
	}
	if (`"`method'"'==bsubstr("twovariances",1,max(6,`len'))) {
		c_local `macm' "twovar"
		c_local `macmname' "twovariances"
		exit
	}
	if (`"`method'"'=="oneway") {
		c_local `macm' "oneway"
		c_local `macmname' "oneway"
		exit
	}
	if (`"`method'"'=="twoway") {
		c_local `macm' "twoway"
		c_local `macmname' "twoway"
		exit
	}
	if (`"`method'"'=="repeated") {
		c_local `macm' "repeated"
		c_local `macmname' "repeated"
		exit
	}
	if (`"`method'"'=="mcc") {
		c_local `macm' "mcc"
		c_local `macmname' "mcc"
		exit
	}
	if (`"`method'"'=="cmh") {
		c_local `macm' "cmh"
		c_local `macmname' "cmh"
		exit
	}
	if (`"`method'"'=="trend") {
		c_local `macm' "trend"
		c_local `macmname' "trend"
		exit
	}
	if (`"`method'"'==bsubstr("logrank",1,max(3,`len'))) {
		c_local `macm' "logrank"
		c_local `macmname' "logrank"
		exit
	}
	if (`"`method'"'=="cox") {
		c_local `macm' "cox"
		c_local `macmname' "cox"
		exit
	}
	if (`"`method'"'==bsubstr("exponential",1,max(3,`len'))) {
		c_local `macm' "exp"
		c_local `macmname' "exponential"
		exit
	}
	
	// user-written methods
	cap qui findfile power_cmd_`method'.ado
	local rc = _rc
	if (`rc' & "`programok'"!="") {
		cap program list power_cmd_`method'
		local rc = (_rc==111)
	}
	if (`rc') {
		di as err `"{bf:power}: invalid method {bf:`method'}"'
		di as err "{p 4 4 2}The {bf:`method'} method is not one of the" 
		di as err "officially supported {bf:power}" 
		di as err "{help power##method:methods}.{p_end}" 
		exit 198
	}
	c_local `user' "user"
	c_local `macm' "`method'"
	c_local `macmname' "`method'"
end

program power_err_testmethod
	exit
end

program _getusergrcols
	args ydim xdim grcolumns grrest gromit forceomit colon graph1

	if (`"`graph1'"'=="") exit

	local 0 `", `graph1'"'
	syntax [, OMITCOLumns(string) /*undocumented*/ * ]

	local graphopts `"`options'"'
	local 0 `", `options'"'
	syntax [, Xdimension(string asis) 		///
		  Ydimension(string asis) 		///
		  BYdimension(string asis) 		///
		  PLOTdimension(string asis) 		///
		  GRAPHdimension(string asis) 		///
		  * ]

	_parse comma first rest : xdimension
	c_local `xdim' `first'
	local cols `first'
	local anycols `first'

	_parse comma first rest : ydimension
	c_local `ydim' `first'
	local cols `cols' `first'
	local anycols `anycols'`first'

	_parse comma first rest : bydimension
	local cols `cols' `first'
	local anycols `anycols'`first'

	_parse comma first rest : plotdimension
	local cols `cols' `first'
	local anycols `anycols'`first'

	_parse comma first rest : graphdimension
	local cols `cols' `first'
	local anycols `anycols'`first'

	_parse_omitcolumns omtcols force : `"`omitcolumns'"'

	c_local `grcolumns' "`cols'"
	c_local `grrest' `"`graphopts'"'
	c_local `gromit' "`omtcols'"
	c_local `forceomit' "`force'"
end

program _parse_omitcolumns
	args colmac optmac colon omitcolumns

	local 0 `"`omitcolumns'"'
	cap syntax [anything] [, force ]
	if (_rc) {
		di as err "{p}{bf:graph()'s} suboption {bf:omitcolumns()} "
		di as err "incorrectly specified{p_end}"
		exit _rc
	}
	c_local `colmac' `anything'
	c_local `optmac' `force'
end

exit
