
import delimited /mnt/intel1200/projects/git/exercise_physiology/out/data_analysis.csv, clear 

xtset id trip
xtsum rsos tsos


ereturn list

return list
di `r(N)'


ttest rsos, by(gender)


oneway rsos gender , tabulate

tab rsos gender, chi

tabstat rsos tsos, s(mean median sd var count range min max) by(gender)

