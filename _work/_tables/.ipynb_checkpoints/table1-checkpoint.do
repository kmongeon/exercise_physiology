capture log close
log using "./_tables/table1", smcl replace
//_1q
quietly use ./_analysis/DM, clear
quietly xtset id trip
quietly foreach var in rsos tsos {
    xtsum `var'
    scalar `var'_mean = r(mean)
    scalar `var'_sd   = r(sd)
    }
//_2
display %3.2f rsos_mean
//_3
display %3.2f rsos_sd
//_^
log close
