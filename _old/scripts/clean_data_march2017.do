
/*
* November 8 2016
* Met with Nota and Baraket at 9:30
* 1. Elimimate curosr analysis, 2. Include hierarctical (not mediated) model, 3. Include full mediated model
* ssc install tabout 
*ssc install estout

set more off, perm
clear all

global dir "c(pwd)"
di $dir

cd "/home/kevin/gitworking/exercise_physiology"

import delimited IzzyLongitudinalWorkingMarch2015.csv,  case(lower) clear 
order id session sequence
sort id sequence
save di, replace

import delimited torque.csv, case(lower) clear
drop if session==0
drop sequence
rename new_sequence sequence
order id session sequence
sort id  sequence
foreach var in ptiso pt60 pt240 {
replace `var' = . if `var'==-9999
}
save dt, replace

** Identify potentially data with errors
* Nota: July  2016
import delimited NegativeIDs.csv, case(lower) clear
keep nota id sequence 
keep if nota==1
save db1, replace

* Baraket: Nov 2016
import delimited data_examine_falk_nov2016.csv, case(lower) clear
keep falk id sequence
keep if falk==1
save db2, replace

* merge
use di, clear
sort id sequence
merge 1:1 id sequence using dt,  nogen
merge 1:1 id sequence using db1, nogen
merge 1:1 id sequence using db2, nogen

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
*replace ptiso=.  if ptiso >200
capture drop griph 
reg grip rsos 

predict griph 
replace griph = grip if !missing(grip)

capture drop ptisoh  
reg ptiso tsos
predict ptisoh 
replace ptisoh = ptiso if !missing(ptiso) & ptiso>200

capture drop rsosh  
reg rsos griph matu if nota==.
predict rsosh if nota==.
replace rsosh = rsos if nota==1

capture drop tsosh  
reg tsos ptisoh matu if falk==.
predict tsosh if falk==.
replace tsosh = tsos if falk==1

capture drop ntxch  
reg ntxc bn.id
predict ntxch 
replace ntxch = ntxc if !missing(ntxc)

capture drop mvhh  
reg mvh   ntxch 
predict mvhh 
replace mvhh = mvh if !missing(mvh)

count if missing(rsos)
count if missing(tsos)
count if missing(grip)
count if missing(ptiso)
count if missing(matu)
count if missing(ntxc)
count if missing(godin)
count if missing(vitd)

foreach var in $Y $X $Z ptisoh griph ntxch rsosh tsosh {
sum `var'
count if missing(`var')
}



// reg rsos grip matu if nota==.
// predict rhat 
// replace rsos = rhat if nota==1
// drop rhat

gen male = gender -1 
gen fema = gender

export delimited using "/home/kevin/gitworking/exercise_physiology/workingdata_march2017.csv", replace
*/
