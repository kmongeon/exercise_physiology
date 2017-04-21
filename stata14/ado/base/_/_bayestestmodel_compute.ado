*! version 1.0.0  21feb2015
program _bayestestmodel_compute
	version 14.0
	args mllmethod prvec lmlvec postprvec sumpostpr i
	//compute posterior probability for current model
	mat `lmlvec'[`i',1] = `e(`mllmethod')'
	mat `postprvec'[`i',1] = exp(`lmlvec'[`i',1])*`prvec'[`i',1]
	scalar `sumpostpr' = `sumpostpr' + `postprvec'[`i',1]
end
