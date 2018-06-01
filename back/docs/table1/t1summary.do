capture log close
log using "t1summary", smcl replace
//_1q
quietly do t1gen.do
local f %3.2f
//_2
display %3.2f sos_diff_mu
//_3
display %3.2f sos_diff_pv
//_4
display %3.2f rdiff_mu
//_5
display %3.2f rdiff_pv
//_6
display %3.2f tdiff_mu
//_7
display %3.2f tdiff_pv
//_^
log close
