*! version 1.0.5  13feb2015  
program discrim_lda_p
	version 10

	if !(("`e(cmd)'" == "discrim" & "`e(subcmd)'" == "lda") | ///
						("`e(cmd)'" == "candisc")) {
		error 301
	}
	if "`e(N_groups)'" == "" {
		di as err "e(N_groups) not found"
		exit 322
	}

	syntax anything(name=newvarlist id=newvarlist) [if] [in], [ ///
		Classification	/// group classification
		Pr		/// probabilities of group membership
		MAHalanobis	/// Mahalanobis distance squared to group
		CLSCore		/// classification function score
		DSCore		/// fisher discriminant score
		LOOClass	/// leave-one-out group classification
		LOOPr		/// leave-one-out probabilities
		LOOMahal	/// LOO Mahalanobis distance squared to group
		PRIors(string)	/// prior prob. (default to e(grouppriors))
		Group(string)	/// specifies a particular group
		TIEs(string)	/// ties
	]

	// Rules:
	//
	// -pr- with -group()- produces probabilities for the specified group
	// 	(i.e., expects 1 variable)
	//
	// -pr- without -group()- produces probabilities for the k groups
	//	(i.e., expects k variables)
	//
	// -mahalanobis-, -clscore-, -loopr-, and -loomahal- act like -pr-
	//	(1 var if -group()- specified or k vars otherwise)
	//
	// -dscore- allows from 1 to e(f) variables; -group()- is not allowed;
	//
	// -classification- and -group()- are not allowed together;
	// 	-classification- expects 1 variable
	//
	// -looclass- acts like -classification-
	//
	// If -group()- is not specified and only 1 var is given then -group()-
	//	defaults to the first group
	//
	// The default is -classification- if only 1 var specified (and
	//	-group()- not specified); the default is -pr- if k vars
	//	specified or 1 var with -group()- option
	//
	// The options that begin with -loo- are allowed only on observations
	//	that are part of e(sample)
	//

	// Mark which observations are to be predicted
	tempvar touse
	mark `touse' `if' `in'
	if "`looclass'`loopr'`loomahal'" != "" {
		// loo options further restricted to e(sample)
		qui replace `touse' = 0 if !e(sample)
	}

	// Get the list of new variables
	if "`dscore'" != "" {
		_stubstar2names `newvarlist', noverify nvars(`e(f)')
	}
	else {
		capture _stubstar2names `newvarlist', ///
						nvars(`e(N_groups)') singleok
		if c(rc) {
			if c(rc) == 102 & `"`group'"' != "" {
				error 103
			}
			else { // rerun to get error out
				_stubstar2names `newvarlist', ///
						nvars(`e(N_groups)') singleok
			}
		}
	}
	local varlist `s(varlist)'
	local typlist `s(typlist)'
	local nvars : word count `varlist'	// will be 1 or `e(N_groups)'
						// (unless -dscore-)
	if "`dscore'" != "" {
		if `nvars' > `e(f)' {
			di as err "dscore allows at most " `e(f)' " variables"
			exit 103
		}
	}

	// Set default statistic if not specified
	if ///
"`classification'`pr'`mahalanobis'`clscore'`dscore'`looclass'`loopr'`loomahal'" ///
	== "" {
		if `nvars' == 1 & `"`group'"' == "" {
			local classification classification
			local msg ///
			 "(option classification assumed; group classification)"
		}
		else if `nvars' == 1 { // 1 var but also group() specified
			local pr pr
			local msg ///
			      "(option pr assumed; group posterior probability)"
		}
		else {
			local pr pr
			local msg ///
			    "(option pr assumed; group posterior probabilities)"
		}
	}

	// Check for options that are not allowed together etc.
	opts_exclusive ///
"`classification' `pr' `mahalanobis' `clscore' `dscore' `looclass' `loopr' `loomahal'"

	if `"`ties'"' != "" & "`classification'`looclass'" == "" {
		// ties() allowed only with -classification- or -looclass-
		opts_exclusive  ///
	     "ties() `pr' `mahalanobis' `clscore' `dscore' `loopr' `loomahal'"
	}
	discrim prog_utility ties , `ties'
	local ties `s(ties)'
	if "`ties'" == "nearest" {
		di as err "ties(nearest) not allowed"
		exit 198
	}

	if "`classification'" != "" & `"`group'"' != "" {
		di as err "classification and group() may not be combined"
		exit 198
	}
	if "`looclass'" != "" & `"`group'"' != "" {
		di as err "looclass and group() may not be combined"
		exit 198
	}
	if "`dscore'" != "" & `"`group'"' != "" {
		di as err "dscore and group() may not be combined"
		exit 198
	}

	if `nvars' > 1 & `"`group'"' != "" {
		di as err "group() not appropriate with multiple new variables"
		exit 198
	}
	if `nvars' > 1 & "`classification'" != "" {
		di as err "only one variable allowed with classification option"
		exit 198
	}
	if `nvars' > 1 & "`looclass'" != "" {
		di as err "only one variable allowed with looclass option"
		exit 198
	}

	// Take care of group() option
	if `"`group'"' == "" | "`dscore'" != "" {
		numlist "1/`nvars'"
		local grplist `r(numlist)'
	}
	else {
		ParseGroup `group'
		local grplist `s(group)'
	}

	// Determine prior probabilities
	if `"`priors'"' != "" & "`dscore'" != "" {
		opts_exclusive "priors() dscore"
	}
	else if "`classification'`looclass'" == "" {
			// wait until call back if classification
		tempname priormat
		if `"`priors'"' == "" {
			if `"`e(grouppriors)'"' != "matrix" {
				di as err "matrix e(grouppriors) not found"
				exit 322
			}
			mat `priormat' = e(grouppriors)
			local redoC 0
		}
		else {
			tempname gcntmat
			if `"`e(groupcounts)'"' != "matrix" {
				di as err "matrix e(groupcounts) not found"
				exit 322
			}
			mat `gcntmat' = e(groupcounts)
			discrim prog_utility priors ///
					`"`priors'"' `e(N_groups)' `gcntmat'
			mat `priormat' = r(grouppriors)
			local redoC 1
		}
	}


	// Compute the predictions

	forvalues i = 1/`nvars' {
		tempvar tmp
		local tmpvlist `tmpvlist' `tmp'
	}

	if "`classification'`looclass'" != "" {	//-classification- or -looclass-
		forvalues i=1/`e(N_groups)' {
			tempname tmp`i'
			local tmps `tmps' `tmp`i''
		}
		if `"`priors'"' != "" {
			local propt `"priors(`priors')"'
		}
		if "`classification'" != "" {
			// call back through to get classification scores
			qui predict double `tmps', clscore `propt'

			local vlab1 "classification"
		}
		else {
			// call back through to get LOO probabilities
			qui predict double `tmps', loopr `propt'

			local vlab1 "LOO classification"
		}

		// generates `tmpvlist' variable and sets r(N_ties) to # ties
		qui discrim prog_utility assigngroup ///
				"`tmpvlist'" "`tmps'" "`touse'" "`ties'"

		local nties = r(N_ties)
		if `nties' {
			if "`msg'" != "" di as txt "`msg'" // this comes first
			local msg	// erase so won't appear again later
			di as txt "Warning: " as res "`nties' " ///
				as txt plural(`nties',"tie") " encountered"
			di as txt "ties are assigned to " _c
			if "`ties'" == "missing" {
				di as txt "missing values"
			}
			else if "`ties'" == "first" {
				di as txt "the first tied group value"
			}
			else if "`ties'" == "random" {
				di as txt "a random tied value"
			}
		}

		capture drop `tmps'
	}
	else if "`pr'`loopr'`mahalanobis'`loomahal'" != "" {
		if `nvars' == 1 {
			// set up tempvars for all N_groups even though we
			// only want pr for one group
			local holdgrpl `grplist'
			local nvars `e(N_groups)'
			local tmpvlist
			forvalues i=1/`nvars' {
				tempvar tmp
				local tmpvlist `tmpvlist' `tmp'
			}
		}
		forvalues i=1/`nvars' {
			if "`pr'" != "" {
				local vlab`i' "group`i' posterior probability"
			}
			else if "`loopr'" != "" {
				local vlab`i' ///
					"group`i' LOO posterior probability"
			}
			else if "`mahalanobis'" != "" {
				local vlab`i' ///
					"group`i' Mahalanobis squared distance"
			}
			else if "`loomahal'" != "" {
				local vlab`i' ///
				    "group`i' LOO Mahalanobis squared distance"
			}
		}

		foreach v of local tmpvlist {
			qui gen double `v' = .
		}

		if "`pr'" != "" {
			mata: _discrim_ldaMahal("`priormat'", ///
						"`tmpvlist'","`touse'", 1)
		}
		else if "`mahalanobis'" != "" {
			mata: _discrim_ldaMahal("`priormat'", ///
						"`tmpvlist'","`touse'", 0)
		}
		else if "`loopr'" != "" {
			mata: _discrim_ldaLoo("`priormat'", ///
						"`tmpvlist'", "`touse'", 1)
		}
		else {	// -loomahal-
			mata: _discrim_ldaLoo("`priormat'", ///
						"`tmpvlist'", "`touse'", 0)
		}

		if "`holdgrpl'" != "" {
			local nvars 1
			local tmpvlist : word `holdgrpl' of `tmpvlist'
			local vlab1 `vlab`holdgrpl''
		}
	}
	else if "`clscore'" != "" {	// -clscore-
		tempname Cmat
		if `redoC' {	// recompute the _cons for specified priors
			mata: _discrim_FixCmat("`Cmat'", "`priormat'")
		}
		else {	// priors are from e() so no need to change e(C)
			mat `Cmat' = e(C)
		}

		forvalues i = 1/`nvars' {
			ScoreIt `: word `i' of `grplist''	///
				`: word `i' of `tmpvlist''	///
				`Cmat'				///
				`touse'
			local vlab`i' ///
			  "group`: word `i' of `grplist'' classification score"
		}
	}
	else if "`dscore'" != "" {	// -dscore-
		tempname Lmat
		mat `Lmat' = e(L_unstd)
		forvalues i = 1/`nvars' {
			ScoreIt `: word `i' of `grplist''	///
				`: word `i' of `tmpvlist''	///
				`Lmat'				///
				`touse'
			local vlab`i' ///
				"discriminant score `: word `i' of `grplist''"
		}
	}
	else {				// should never reach inside here
		di as err "internal error in discrim_lda_p"
		exit 9935
	}

	// At this point data successfully generated in `tmpvlist' variables
	// transfer them to user requested variables (and of requested type)
	if "`msg'" != "" di as txt "`msg'"
	forvalues i = 1/`nvars' {
		`myqui' gen `: word `i' of `typlist'' ///
			    `: word `i' of `varlist'' ///
			  = `: word `i' of `tmpvlist'' if `touse'
		drop `: word `i' of `tmpvlist''
		label var `: word `i' of `varlist'' `"`vlab`i''"'
		// all but first time done quietly so only 1 missings message
		local myqui quietly
	}
end

program ScoreIt
	args grp var C touse
	tempname tmpmat
	mat `tmpmat' = `C'[1...,`grp']'
	mat score double `var' = `tmpmat' if `touse'
end

program ParseGroup, sclass
	sreturn clear
	local grparg `"`0'"'
	local ngrps = e(N_groups)

	if `"`grparg'"' == "" {
		// default to first group
		local ans 1
	}
	else if bsubstr(`"`grparg'"',1,1) == "#" {
		// Using #1 style of specifying the group
		local ans = bsubstr(`"`grparg'"',2,.)
		capture confirm integer number `ans'
		if c(rc) {
			di as err "invalid group()"
			di as err "`ans' found where integer expected"
			exit 7
		}
		if `ans' < 1 | `ans' > `ngrps' {
			di as err "invalid group()"
			di as err ///
			 "`ans' found where positive integer < `ngrps' expected"
			exit 7
		}
	}
	else { 
		capture confirm integer number `grparg'
// if not a number, see if it matches one of the group labels in e(grouplabels)
		if _rc {
			local glabs `"`e(grouplabels)'"'
			local ans : list posof `"`grparg'"' in glabs
			if `ans' == 0 {
				di as err "invalid group()"
				exit 198
			}
		}
		else { // value of variable
			tempname gv
			mat `gv' = e(groupvalues)
			local cols = colsof(`gv')
			local ans 0
			forvalues i = 1/`cols' {
				if reldif(`grparg', `gv'[1,`i']) < 1e-6 {
					local ans `i'
				}
			}
			if `ans' == 0 {
				di as err "invalid group()"
				exit 198
			}
		}
		
	}

	sreturn local group `ans'
end
