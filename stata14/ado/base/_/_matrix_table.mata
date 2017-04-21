*! version 1.2.0  07nov2014
version 12

local sumcmds mean proportion ratio total

mata:

void _matrix_table()
{
	class _m_table scalar T
	string	scalar	s

	T = _m_table()
	T.set_mat(st_local("matrix"))
	T.set_sort(strlen(st_local("sort")) ? "on" : "off")
	s = st_local("formats")
	if (strlen(s)) {
		T.set_format(tokens(s))
	}

	T.set_cmdextras(strlen(st_local("cmdextras")) ? "on" : "off")
	T.set_pclassmat(st_local("pclassmatrix"))
	T.set_lstretch(st_local("lstretch") == "nolstretch" ? "off" : "on")

	T.set_do_titles(strlen(st_local("titles")) == 0 ? "on" : "off")
	T.set_diopts(st_local("diopts"))

	T.validate()
	T.labels_for_notes()
	T.report_table()
}

end
