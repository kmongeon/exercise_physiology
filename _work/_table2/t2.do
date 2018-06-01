capture log close
log using "./_table2/t2", smcl replace
//_1q
quietly use ./_analysis/DM, clear
quietly do _preamble.do

quietly estimates use M1
quietly estimates store M1 

quietly estimates use M2
quietly estimates store M2 

esttab M1 M2 , ///
keep(r: t: g: k:) ///
order(r:g t:k) ///
drop(r:P1[id] t:P1[id] g:P2[id] k:P2[id]) ///
label compress nonotes numbers unstack  ///
b(%9.4f) se(%9.4f)  star(* 0.10 ** 0.05 *** 0.01)  ///
title("Table 2. Functional model of bone development test results.")  ///
mtitles("General" "Specific") ///
addnotes("Notes: Standard errors in parentheses.") ///
varwidth(25) modelwidth(10) stats(_M1v1 _M1v2 _M1v3 _M2v1 _M2v2 _M2v3) 
    
    
//_^
log close
