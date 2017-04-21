*! version 1.0.2  22aug2016
program _mcmc_paramnotfound
	args param baselevel
if "`baselevel'" != "" {
	di as err `"{p}parameter {bf:{c -(}`param'{c )-}} not allowed{p_end}"'
	di as err "{p 4 4 2}There is no simulation data available for "
	di as err "base-level and omitted parameters."
	di as err "{p_end}"
	exit 498
}
else {
	di as err `"{p}parameter {bf:{c -(}`param'{c )-}} not found{p_end}"'
	di as err "{p 4 4 2}If you are specifying a function of parameters,"
	di as err "remember to enclose it in parentheses.  "
	di as err "If you are referring to regression coefficients, remember to "
	di as err "include the name of the corresponding dependent variable "
	di as err "as an equation label.  If you are referring "
	di as err "to equation labels or parameter names of regression"
	di as err "coefficients, remember to specify full variable names;"
	di as err "abbreviations are not allowed."
	di as err "{p_end}"
	exit 198
}
end
