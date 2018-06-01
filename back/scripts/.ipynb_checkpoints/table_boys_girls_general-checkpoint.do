
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
    esttab M3 using ./docs/table_boys_girls_general.`var'
}