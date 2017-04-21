*! version 1.0.1  15oct2013

program _pss_syntax

	args synmac colon cmdtype iteropts

	_pss_syntax_`cmdtype' syn : `iteropts'
	c_local `synmac' "`syn'"
end


program _pss_syntax_onetest
	args synmac colon iteropts

	_pss_syntax_common syncmn
	if ("`iteropts'"!="") {
		_pss_syntax_iteropts syniter
	}
	local syn "test Alpha(string) Power(string) Beta(string) n(string)"
	local syn "`syn' DIRection(string) ONESIDed NFRACtional"
	local syn "`syn' `syniter' `syncmn'"
	c_local `synmac' "`syn'" 
end


program _pss_syntax_twotest
	args synmac colon iteropts

	_pss_syntax_common syncmn
	if ("`iteropts'"!="") {
		_pss_syntax_iteropts syniter
	}
	local syn "test Alpha(string) Power(string) Beta(string) n(string)"
	local syn "`syn' n1(string) n2(string) NRATio(string) compute(string)"
	local syn "`syn' DIRection(string) ONESIDed NFRACtional"
	local syn "`syn' `syniter' `syncmn'"
	c_local `synmac' "`syn'" 
end

program _pss_syntax_multitest
	args synmac colon iteropts

	_pss_syntax_common syncmn
	if ("`iteropts'"!="") {
		_pss_syntax_iteropts syniter
	}
	local syn "test Alpha(string) Power(string) Beta(string) n(string)"
	local syn "`syn' NPERGroup(string) GRWeights(string)"
	local syn "`syn' NFRACtional"
	local syn "`syn' `syniter' `syncmn'"
	c_local `synmac' "`syn'" 
end

program _pss_syntax_multileveltest
	args synmac colon iteropts

	_pss_syntax_common syncmn
	if ("`iteropts'"!="") {
		_pss_syntax_iteropts syniter
	}
	local syn "test Alpha(string) Power(string) Beta(string) n(string)"
	local syn "`syn' CELLWeights(string) NPERCell(string)"
	local syn "`syn' NFRACtional"
	local syn "`syn' `syniter' `syncmn'"
	c_local `synmac' "`syn'" 
end

program _pss_syntax_iteropts
	args synmac

	local syn "init(string) ITERate(string) TOLerance(string)"
	local syn "`syn' FTOLerance(string) NOLOG"
	c_local `synmac' "`syn'" 
end

program _pss_syntax_common
	args synmac

	local syn "PARallel NOTItle"
	local syn "`syn' SAVing(string asis) GRSAVing(string asis)"
	local syn "`syn' NOTABle TABle TABle1(string asis)"
	local syn "`syn' GRaph GRaph1(string asis)"
	c_local `synmac' "`syn'" 
end
