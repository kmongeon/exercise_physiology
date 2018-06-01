#delimit cr

/*
ssc install distinct
net from http://www.sealedenvelope.com/ 
net install xfill.pkg
net install xtab.pkg
net install xcount.pkg
net install reformat.pkg
*/
clear all
pwd

global DS "_data_source"
global DO "_data_out"

cd $DS
capture mkdir $DO

tempfile dt1
tempfile dt2

import excel "bone_muscle_merged.xlsx", sheet("bone_muscle_merged") firstrow clear  
save `dt1'
import excel "Kevin PTISO.xlsx", sheet("SeqSort2")  firstrow clear
rename ID id
rename SEQ sequence
save `dt2'

use `dt1'
merge 1:1  id sequence using `dt2'
drop if _merge==2
drop _merge
drop M

order Biodex MatLab, after(ptiso)

destring rsos tsos grip ptiso Biodex MatLab ntxc matu mvh age, replace force
sort id sequence

cd $DO
export excel using AllObservations.xls, firstrow(variables) replace

******************************************************
* describe data
******************************************************
gen _o = _n
egen _id = group(id)
by id: gen _v = _n

quietly tabulate _id
display r(r)

by id: gen size =_N if _v==1
tab size

gen _season = season if _v==1
bys _season: tab size

******************************************************
* missing observations
******************************************************

* omitted
gen omit = ""
replace omit = Exclusion if Exclusion!="none"
replace omit = NoSOS if (missing(omit) & !missing(NoSOS)) 
replace omit = "missed apt" if T=="missing data du eto missed apt"
replace omit = "missed apt" if T=="missing data missed apt"
replace omit = "missed apt" if T=="missing data missing apt"
tab omit
keep if missing(omit)


* grip strength
count if sequence==1

* accelerometer data
tab Nomvh

* Ntx/creatine  
tab Nontx

sort id sequence

export excel using "AnalysisObservations.xls", firstrow(variables) replace

******************************************************
* summary
******************************************************

quietly tabulate _id
display r(r)

count

sum rsos tsos grip ptiso Biodex MatLab ntxc matu mvh age,  separator(0) 
putexcel set "summary.xls"
