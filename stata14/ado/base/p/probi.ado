*! version 1.0.2   02jan2015
program probi, byable(onecall) prop(svyb svyj svyr)
	if _by() {
		local by "by `_byvars'`_byrc0':"
	}
	`by' probit `0'
end
exit
