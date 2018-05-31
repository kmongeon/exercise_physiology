quietly do _preamble.do

quietly{
estimates use M3 
estimates store M3 
estadd scalar _M3v1 = _b[var(P1[id]):_cons] 
estadd scalar _M3v2 = _b[var(P2[id]):_cons] 
estadd scalar _M3v3 = _b[cov(P1[id]*P2[id]):_cons]

estimates use M4 
estimates store M4 
estadd scalar _M4v1 = _b[var(P1[id]):_cons] 
estadd scalar _M4v2 = _b[var(P2[id]):_cons] 
estadd scalar _M4v3 = _b[cov(P1[id]*P2[id]):_cons]
}

#delimit ;


display "Specific estimation results for boys and girl.";
esttab M4, 
keep(r_boy: t_boy: g_boy: k_boy: r_gir: t_gir: g_gir: k_gir:) 
drop(r_boy:P1[id] t_boy:P1[id] r_gir:P1[id] t_gir:P1[id] g_boy:P2[id] k_boy:P2[id] g_gir:P2[id] k_gir:P2[id])
stats(_M4v1 _M4v2 _M4v3)
label compress nonotes numbers unstack 
b(%9.4f) se(%9.4f)  star(* 0.10 ** 0.05 *** 0.01) 
title("Table 4. Radial and tibial estimation results for boys and girl.") 
addnotes("Notes: Standard errors in parentheses.") 
varwidth(30) modelwidth(10) 
;

esttab M4 using table_sex_unrestricted.rtf, replace
keep(r_boy: t_boy: g_boy: k_boy: r_gir: t_gir: g_gir: k_gir:) 
drop(r_boy:P1[id] t_boy:P1[id] r_gir:P1[id] t_gir:P1[id] g_boy:P2[id] k_boy:P2[id] g_gir:P2[id] k_gir:P2[id])
stats(_M4v1 _M4v2 _M4v3)
label compress nonotes numbers unstack 
b(%9.4f) se(%9.4f)  star(* 0.10 ** 0.05 *** 0.01) 
title("Table 4. Radial and tibial estimation results for boys and girl.") 
addnotes("Notes: Standard errors in parentheses.") 
varwidth(30) modelwidth(10) 
;

#delimit cr