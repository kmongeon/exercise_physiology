*! version 1.0.2   02jan2015
program mlog, byable(onecall) prop(rrr svyb svyj svyr)
	if _by() {
		local by "by `_byvars'`_byrc0':"
	}
	`by' mlogit `0'
end
exit
