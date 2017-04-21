*! version 1.0.2   02jan2015
program logi, byable(onecall) prop(or svyb svyj svyr)
	if _by() {
		local by "by `_byvars'`_byrc0':"
	}
	`by' logit `0'
end
exit
