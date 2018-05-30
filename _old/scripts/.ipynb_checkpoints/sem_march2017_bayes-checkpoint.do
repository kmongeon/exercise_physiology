
// import delimited using "/home/kevin/gitworking/exercise_physiology/workingdata_march2017.csv", clear
// drop if missing(rsos)



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
drop if missing(rsos)

gsem (rsos <-  grip matu )
gsem (rsos <-  grip matu  M1[id])


// keep rsos griph matu
// reg rsos griph matu


keep rsos grip matu id
fvset base none id

gsem rsos <- M[id]

bayesmh rsos, ///
	likelihood(normal({var_e_ijk})) ///
///
	prior({TestScore: _cons},  	normal(0,100)) ///
	block({TestScore: _cons},	gibbs) ///
///
	prior({var_e_ijk},      	igamma(1,1))  ///  	
	block({var_e_ijk},		gibbs) ///
///
	burnin(2500) mcmcsize(10000) thinning(1) rseed(14)
;
#delimit cr
	burnin(10000)  mcmcsize(10000) thinning(1) rseed(14) ///
	dots nomodelsummary notable
	
local var_int "{rsos:_cons} {var}"
bayesstats summary `var_int'
bayesgraph diagnostics `var_int'

	
bayesmh rsos , likelihood(normal({var})) noconstant  ///
	prior({rsos:_cons},  normal(0,100)) ///
	///
	prior({var},   	igamma(0.01,0.01)) ///
	///
	burnin(10000)  mcmcsize(10000) thinning(1) rseed(14) ///
	dots nomodelsummary notable
	 
*** good. results similar to OLS
set seed 14
bayesmh rsos grip matu i.id, likelihood(normal({var})) noconstant ///
	prior({rsos: grip}, normal(0,100))  ///
	prior({rsos: matu}, normal(0,100))  ///
	prior({rsos:i.id},  normal({rsos:cons},{var_0})) ///	
	prior({rsos:cons},  normal(0,100)) ///
	///
	prior({var},   	igamma(0.01,0.01)) ///
	prior({var_0},   igamma(0.01,0.01)) ///	
	///
	burnin(10000)  dots nomodelsummary notable
	
bayesstats summary {rsos:grip} {rsos:matu} {rsos:cons} {var}
bayesgraph diagnostics {rsos:grip} {rsos:matu} {rsos:cons} {var}


set seed 14
bayesmh rsos griph matu i.id, likelihood(normal({var})) noconstant ///
	prior({rsos: griph}, normal(0,100))  ///
	prior({rsos: matu}, normal(0,100))  ///
	prior({rsos:i.id},  normal({rsos:cons},{var_0})) ///	
	prior({rsos:cons},  normal(0,100)) ///
	///
	prior({var},   igamma(0.01,0.01)) ///
	prior({var_0},   igamma(0.01,0.01)) ///	
	block({rsos:griph}) ///
	block({rsos:matu}) ///
	block({rsos:cons})   ///
	block({rsos:i.id},split) ///	
	///
	burnin(10000)  dots
	
	block({var}) block({var_0})
///
>   block({weight:week}) block({weight:cons})                    ///
>   block({weight:i.id},
split
)

	
bayesstats summary {rsos:griph} {rsos:matu} {var}
bayesgraph diagnostics {rsos:} {var}

fvset base none id

bayesmh rsos griph matu, likelihood(normal({var})) noconstant reffects(id) ///
	prior({rsos:i.id}, 	normal({rsos:cons},{var_0})) ///
	prior({rsos:griph}, 	normal(0,100)) ///
	prior({rsos:matu }, 	normal(0,100)) ///
	prior({rsos:cons }, 	normal(0,100)) ///
	///
        prior({var},   		igamma(0.001,0.001)) ///
        prior({var_0}, 		igamma(0.001,0.001)) ///
	///
	block({var}) 		block({var_0})    ///
	block({rsos:matu}) 	block({rsos:cons}) ///
	burnin(2000) dots thinning(2)
	
	
bayesstats summary *
bayesgraph diagnostics {rsos:griph} {rsos:matu} {var}

webuse pig, clear
 bayesmh weight week, likelihood(normal({var}))             ///
                      prior({weight:}, normal(0,100))       ///
                      prior({var},     igamma(0.001,0.001)) ///
                      block({weight:}, gibbs)                ///
		      block({var},gibbs)  dots

bayesmh rsos griph i.id, likelihood(normal({var})) noconstant ///
prior({rsos:i.id i.id#c.week}, mvnormal(2,{rsos:cons},{rsos:week},{Sigma, matrix})) ///
  prior({rsos:week cons},   normal(0,100))                          ///
  prior({var},                igamma(0.001,0.001))                    ///
  prior({Sigma,m},            iwishart(2,3,I(2)))                     ///
  block({rsos:i.id},         reffects) ///
   block({rsos:i.id#c.week}, reffects) ///
   block({var},                gibbs) ///
   block({Sigma,m},            gibbs) ///
   burnin(10000) nomodelsummary notable dots
   
   bayesmh weight i.id i.id#c.week, likelihood(normal({var})) noconstant ///
prior({weight:i.id i.id#c.week}, mvnormal(2,{weight:cons},{weight:week},{Sigma, matrix})) ///
  prior({weight:week cons},   normal(0,100))                          ///
  prior({var},                igamma(0.001,0.001))                    ///
  prior({Sigma,m},            iwishart(2,3,I(2)))                     ///
  block({weight:i.id},         reffects) ///
   block({weight:i.id#c.week}, reffects) ///
   block({var},                gibbs) ///
   block({Sigma,m},            gibbs) ///
   burnin(10000) nomodelsummary notable do
   
