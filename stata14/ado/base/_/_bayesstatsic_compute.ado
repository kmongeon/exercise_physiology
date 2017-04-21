*! version 1.0.0  21feb2015
program _bayesstatsic_compute
	version 14.0
	args mllmethod dicvec lmlvec i

	mat `lmlvec'[`i',1] = `e(`mllmethod')'
	mat `dicvec'[`i',1] = e(dic)
end
