
quietly do ./scripts/_preamble.do

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

foreach var in md html rtf tex {
    #delimit ;
    esttab M3 using ./docs/table_boys_girls_general.`var', replace
    keep(r_boy: t_boy: g_boy: k_boy: r_gir: t_gir: g_gir: k_gir:) 
    drop(r_boy:P1[id] t_boy:P1[id] r_gir:P1[id] t_gir:P1[id] g_boy:P2[id] k_boy:P2[id] g_gir:P2[id] k_gir:P2[id])
    stats(_M3v1 _M3v2 _M3v2)
    b(%9.4f) se(%9.4f)  star(* 0.10 ** 0.05 *** 0.01) 
    label compress nonotes numbers unstack
    title("Table 3. Bone property estimation results for boys and girls.") 
    mtitles("General" "Specific")
    addnotes("Notes: Standard errors in parentheses.") 
    varwidth(25) modelwidth(10) stats(_M3v1)
}