*! version 1.0.1   02jan2015
program clog, byable(onecall)
	if _by() {
		local by "by `_byvars'`_byrc0':"
	}
	`by' clogit `0'
end

