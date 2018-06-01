
quietly do ./scripts/_preamble.do

quietly{
estimates use M1 
estimates store M1 
estadd scalar _M1v1 = _b[var(P1[id]):_cons] 
estadd scalar _M1v2 = _b[var(P2[id]):_cons] 
estadd scalar _M1v3 = _b[cov(P1[id]*P2[id]):_cons]

estimates use M2 
estimates store M2 
estadd scalar _M2v1 = _b[var(P1[id]):_cons]
estadd scalar _M2v2 = _b[var(P2[id]):_cons]
estadd scalar _M2v3 = _b[cov(P1[id]*P2[id]):_cons]
}

foreach var in md html rtf tex {
    #delimit ;
    esttab M1 M2 using ./docs/table_all_particiapants.`var',replace
    keep(r: t: g: k:) 
    order(r:g t:k)
    drop(r:P1[id] t:P1[id] g:P2[id] k:P2[id])
    label compress nonotes numbers unstack 
    b(%9.4f) se(%9.4f)  star(* 0.10 ** 0.05 *** 0.01) 
    title("Table 2. Functional model of bone development test results.") 
    mtitles("General" "Specific")
    addnotes("Notes: Standard errors in parentheses.") 
    varwidth(25) modelwidth(10) stats(_M1v1 _M1v2 _M1v3 _M2v1 _M2v2 _M2v3)
    ;
    #delimit cr
}    



