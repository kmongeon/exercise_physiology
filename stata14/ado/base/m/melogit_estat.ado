*! version 1.0.1  20jun2014
program melogit_estat
	version 13

	if "`e(cmd2)'" != "melogit" {
		error 301
	}

	meglm_estat `0'
	exit
end

exit
