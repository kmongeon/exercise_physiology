
* November 8 2016
* Met with Nota and Baraket at 9:30
* 1. Elimimate curosr analysis, 2. Include hierarctical (not mediated) model, 3. Include full mediated model
*ssc install tabout 
*ssc install estout

set more off
clear all
cd "~/Documents/bone"

import delimited dm.csv, case(lower) clear
sort id sequence 
save dr, replace

import delimited torque.csv, case(lower) clear
drop sequence
rename new_sequence sequence
sort id sequence
save dt, replace

merge 1:1 id sequence using dr
rename _merge dr_merge 

merge 1:1 id sequence using "msObsToDrop.dta"
drop if _merge==3 
drop _merge index v1 dr_merge

order id session sequence
sort id session sequence
gen newSeq1 = 0
gen newSeq2 = 0
replace newSeq1 = 1 if session==1 & sequence ==3
replace newSeq1 = 2 if session==1 & sequence ==5
replace newSeq1 = 3 if session==1 & sequence ==7
replace newSeq2 = 1 if session==2 & sequence ==2
replace newSeq2 = 2 if session==2 & sequence ==4
replace newSeq2 = 3 if session==2 & sequence ==6
gen newSeq3 = newSeq1
replace newSeq3 = newSeq2 if newSeq1==0
gen newSeq = newSeq3
sort id newSeq
by id: gen seq = _n
sort id seq 
drop newSeq newSeq1 newSeq2 newSeq3 

rename radius_sos rsos
rename grip_strength_best grip
rename mat_offset_new matu
rename gender fema
rename vit_d vita
rename paq_total_score pact
rename ntxcreat ntxc

*summary of all data
sum * , sep(0)
sum * if fema ==0, sep(0)
sum * if fema ==1, sep(0)

*data for analysis
local radial_var "id sequence session rsos grip age matu fema vita pact"
local tibial_var "tibial_sos tibial_z wrist_flexion_best grip forearm_length forearm_lean_csa forearm_us_csa anterior_csa anterior_radius ant_rad_csa anterior_ulna ant_ulna_csa posterior post_csa tibialis_anterior  biodex_id pt*"
keep `radial_var' `tibial_var'
drop if missing(id) 
drop if missing(sequence) 
drop if missing(session) 
drop if missing(rsos) 
drop if missing(grip) 
drop if missing(age) 
drop if missing(matu) 
drop if missing(fema) 
drop if missing(vita) 
drop if missing(pact) 
drop if matu>7

gen Cage = round(age)
tab Cage
replace Cage = 15 if Cage>15
gen male = (fema==0)

la var Cage "Age"
la var rsos "Radial SOS"
la var grip "Grip strength"
la var matu "Maturity offset"
la var fema "Fema"
la var male "Male"
label define gender 0 "Female" 1 "Male" 
label values male gender

egen nid = group(id)
drop id session
order nid seq
sort  nid seq
duplicates report nid seq
xtset nid seq
order nid seq rsos grip age matu fema male Cage vita pact `tibial_var'

*data out for 3d plot
export delimited using "radial_tibial_data.csv", replace
save radial_tibial_data, replace

clear all
cd "~/Documents/bone"
use radial_tibial_data, clear
set dp period 
shell rm -r out
shell mkdir out

*sex distribution. LR test: null is distribuions are the same
tabulate seq fema, chi2 lrchi2 row

*shapiro-wilks: null is distribution is normal
swilk *
by seq, sort : swilk *

*table1:  Summary stats by measurement occasion
tabout seq using "out/table1_all.csv", replace f(4) sum style(csv) ///
c(N rsos mean rsos sd rsos mean grip sd grip mean matu sd matu) 
tabout seq using "out/table1_female.csv" if fema==0, append f(4) sum style(csv) ///
c(N rsos mean rsos sd rsos mean grip sd grip mean matu sd matu) 
tabout seq using "out/table1_male.csv" if fema==1, append f(4) sum style(csv) ///
c(N rsos mean rsos sd rsos mean grip sd grip mean matu sd matu)

drop Cage
*Empirical models (random effects, fully mediated, partially mediated)
global RE  "rsos <- grip matu M1[nid] c.grip#M1S[nid]"
global FM "(rsos <- grip matu M1[nid] c.grip#M1S[nid]) (grip <- matu M2[nid]) "
global PM "(rsos <- grip M1[nid] c.grip#M1S[nid]) (grip <- matu M2[nid])"

eststo RE_A: gsem $RE
eststo FM_A: gsem $FM
eststo PM_A: gsem $PM
eststo PM_M: gsem $PM if male==1
eststo PM_F: gsem $PM if male==0

drop if ptiso==-9999
global TRE60  "tibial_sos <- pt60 matu M1[nid] c.pt60#M1S[nid]"
global TRE240  "tibial_sos <- pt240 matu M1[nid] c.pt240#M1S[nid]"

global TPM60 "(tibial_sos <- pt60  M1[nid] c.pt60#M1S[nid]) (pt60 <- matu M2[nid]) "
global TPM240 "(tibial_sos <- pt240  M1[nid] c.pt240#M1S[nid]) (pt240 <- matu M2[nid]) "

eststo TRE: gsem $TRE60
eststo TRE: gsem $TRE240
eststo TPM60: gsem $TPM60
