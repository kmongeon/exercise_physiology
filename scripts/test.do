
import delimited ./data/IzzyLongitudinalWorkingMarch2015.csv,  case(lower) clear 
order id session sequence
sort id sequence
save ./out/di, replace

import delimited ./data/torque.csv, case(lower) clear
drop if session==0
drop sequence
rename new_sequence sequence
order id session sequence
sort id  sequence
foreach var in ptiso pt60 pt240 {
replace `var' = . if `var'==-9999
}
save ./out/dt, replace

** Identify potentially data with errors
* Nota: July  2016
import delimited ./data/NegativeIDs.csv, case(lower) clear
keep nota id sequence 
keep if nota==1
save ./out/db1, replace

* Baraket: Nov 2016
import delimited ./data/data_examine_falk_nov2016.csv, case(lower) clear
keep falk id sequence
keep if falk==1
save ./out/db2, replace

* merge
use ./out/di, clear
sort id sequence
merge 1:1 id sequence using ./out/dt,  nogen
merge 1:1 id sequence using ./out/db1, nogen
merge 1:1 id sequence using ./out/db2, nogen

rename radius_sos rsos
rename tibial_sos tsos

rename grip_strength_best grip 
rename mat_offset_new matu

rename godin_pa godin
rename ntxcreat ntxc
rename caloricintake cint
renam calcium calc 
rename vitd vitd 
rename v48 vitd2
rename paq_total_score paq
rename totmvh mvh

global U id session sequence 
global Y rsos tsos
global X grip ptiso pt60 godin paq ntxc cint calc vitd vitd2 mvh
global Z matu age gender
global D nota falk

keep $U $Y $X $Z $D

***grip only

*drop if missing(rsos)
*drop if missing(tsos)
*drop if missing(grip)
*drop if missing(ptiso) 
drop if matu>5
drop if id==517 & sequence==7

sort id sequence
by id: egen seq = seq()
global U id session sequence seq

order $U $D $Y $X $Z 

xtset id seq
count 
