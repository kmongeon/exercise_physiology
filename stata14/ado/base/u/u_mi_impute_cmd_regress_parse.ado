*! version 1.0.1  13oct2015
program u_mi_impute_cmd_regress_parse
	version 12	
	// preliminary syntax check
	syntax [anything(everything equalok)] [aw fw pw iw],	///
			impobj(string)			/// //internal
		[					/// 
			NOCONStant			///
			*				/// //common univ. opts
		]
	if ("`weight'"!="") { // accommodates default weights
		local wgtexp [`weight' `exp']
	}
	u_mi_impute_cmd__uvmethod_parse `anything' `wgtexp',		///
		impobj(`impobj') method(regress) cmd(_regress)		///
		cmdopts(`noconstant') `noconstant' `options'
end
