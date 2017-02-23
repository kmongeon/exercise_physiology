
* November 8 2016
* Met with Nota and Baraket at 9:30
* 1. Elimimate curosr analysis, 2. Include hierarctical (not mediated) model, 3. Include full mediated model
ssc install tabout 
ssc install estout

set more off
clear all
cd "~/Documents/bone"

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

* Identify potentially data with errors
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
reg mvh ntxch 
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

gen male = 1- gender  
gen fema = gender

global W "rsos tsos griph ptisoh ntxch mvhh "
sum $W
foreach var in $W {
capture egen z`var' = std(`var')
}

foreach var in cint calc vitd godin paq{
capture egen z`var' = std(`var')
}


************************
* summary stats
corr rsos griph matu
corr tsos ptisoh matu

correlate griph matu
scalar r1 = r(rho) 

correlate ptisoh matu
scalar r1 = r(rho) 

xtsum rsos tsos griph ptisoh matu if _est_m5==1
xtdescribe

gsem ///
(rsos <-  griph  matu  M1[id]) ///
(tsos <-  ptisoh matu  M1[id]) ///
(griph <-   matu   ) ///
(ptisoh <-  matu   ) ,coeflegend
matrix b = e(b) 

gsem ///
(rsos <-  griph  matu  		ntxc M1[id] )
gsem ///
(rsos <-  griph  matu  		ntxc M1[id]) ///
(tsos <-  ptisoh matu mvhh  ntxc M2[id]) ///
(griph <-   matu   ) ///
(ptisoh <-  matu   ) , from(b, skip)
matrix b = e(b)


gsem ///
(zrsos   <- zgriph  matu  		 zntxc M1[id]) ///
(ztsos   <- zptisoh matu  zmvhh zntxc M2[id]) ///
(zgriph  <- matu   ) ///
(zptisoh <- matu   ) 
matrix z = e(b)

gsem ///
(rsos <-  i1.male#c.griph  griph  matu  	 ntxc M1[id]) ///
(tsos <-  i1.male#c.ptisoh ptisoh matu  mvhh ntxc M2[id]) ///
(griph <-   matu  male ) ///
(ptisoh <-  matu  male )
matrix w1 = e(b)

gsem ///
(zrsos <-  i1.male#c.zgriph  zgriph  matu  	 zntxc M1[id]) ///
(ztsos <-  i1.male#c.zptisoh zptisoh matu  zmvhh zntxc M2[id]) ///
(zgriph <-   matu  male ) ///
(zptisoh <-  matu  male )
matrix w2 = e(b)

gsem ///
(rsos <-  griph  matu  		ntxc M1[id]) ///
(tsos <-  ptisoh matu  mvhh ntxc M2[id]) ///
(griph <-   matu   M3[id]) ///
(ptisoh <-  matu   M4[id]) , from(b, skip) 
estimates store m1


gsem ///
(zrsos   <- zgriph  matu  		 zntxc M1[id]) ///
(ztsos   <- zptisoh matu  zmvhh zntxc M2[id]) ///
(zgriph  <- matu   M3[id]) ///
(zptisoh <- matu   M4[id]) , from(z, skip)   
estimates store m2

gsem ///
(zrsos   <- zgriph  matu  		zntxc M1[id]) ///
(ztsos   <- zptisoh matu  zmvhh zntxc M1[id]) ///
(zgriph  <- matu   M3[id]) ///
(zptisoh <- matu   M3[id]) , from(z, skip)

gsem ///
(rsos <-  i1.male#c.griph  griph  matu  	 ntxc M1[id]) ///
(tsos <-  i1.male#c.ptisoh ptisoh matu  mvhh ntxc M2[id]) ///
(griph <-   matu  male M3[id]) ///
(ptisoh <-  matu  male M4[id]) , from(w1, skip)
estimates store m3

gsem ///
(zrsos <-  i1.male#c.zgriph  zgriph  matu  	 	 zntxc M1[id]) ///
(ztsos <-  i1.male#c.zptisoh zptisoh matu  zmvhh zntxc M2[id]) ///
(zgriph <-   matu  male M3[id]) ///
(zptisoh <-  matu  male M4[id]) , from(w2, skip)
estimates store m4

gsem ///
(rsos <-  i1.male#c.griph  griph  i1.male#c.matu matu  	  M1[id]) ///
(tsos <-  i1.male#c.ptisoh ptisoh i1.male#c.matu matu     M2[id]) ///
(griph <-    matu male M3[id]) ///
(ptisoh <-   matu male M4[id]) , from(w1, skip)
estimates store m5

estimate restore m5
estimate replay m5
nlcom _b[griph:_cons]
nlcom _b[griph:male]
nlcom _b[griph:_cons] + _b[griph:male]

nlcom _b[ptisoh:_cons]
nlcom _b[ptisoh:male]
nlcom _b[ptisoh:_cons] + _b[ptisoh:male]


nlcom _b[rsos:i1.male#c.grip] + _b[rsos:griph]

nlcom _b[tsos:i1.male#c.ptisoh] + _b[tsos:ptisoh]

********* maturation effects on bone
nlcom _b[rsos:matu]
nlcom _b[rsos:1.male#c.matu]
nlcom _b[rsos:1.male#c.matu] +  _b[rsos:matu]

nlcom _b[tsos:matu]
nlcom _b[tsos:1.male#c.matu]
nlcom _b[tsos:1.male#c.matu] +  _b[tsos:matu]


nlcom _b[rsos:griph]
nlcom _b[rsos:1.male#c.griph]
nlcom _b[rsos:1.male#c.griph] + _b[rsos:griph]

nlcom _b[tsos:ptisoh]
nlcom _b[tsos:1.male#c.ptisoh]
nlcom _b[tsos:1.male#c.ptisoh] + _b[tsos:ptisoh]

***** total effect 
* tibial
nlcom _b[griph:matu]
nlcom _b[rsos:griph]
nlcom _b[rsos:matu] 

nlcom _b[griph:matu]*_b[rsos:griph]
nlcom _b[rsos:matu] + _b[griph:matu]*_b[rsos:griph]

nlcom _b[griph:matu]
nlcom _b[rsos:1.male#c.griph] + _b[rsos:griph]
nlcom _b[rsos:1.male#c.matu] + _b[rsos:matu] 

nlcom ///
_b[rsos:1.male#c.matu] + _b[rsos:matu] + ( ///
(_b[rsos:1.male#c.griph] + _b[rsos:griph])* _b[griph:matu] )

* difference
nlcom ///
_b[rsos:matu] + _b[griph:matu]*_b[rsos:griph] - ( ///
_b[rsos:1.male#c.matu] + _b[rsos:matu] + ( ///
(_b[rsos:1.male#c.griph] + _b[rsos:griph])* _b[griph:matu] ) ///
)

*radial
*girls
nlcom _b[tsos:matu] + _b[ptisoh:matu]*_b[tsos:ptisoh]
* boys
nlcom ///
_b[tsos:1.male#c.matu] + _b[tsos:matu] + ( ///
(_b[tsos:1.male#c.ptisoh] + _b[tsos:ptisoh])* _b[ptisoh:matu] ///
)

* difference
nlcom ///
_b[tsos:matu] + _b[ptisoh:matu]*_b[tsos:ptisoh] - ( ///
_b[tsos:1.male#c.matu] + _b[tsos:matu] + ( ///
(_b[tsos:1.male#c.ptisoh] + _b[tsos:ptisoh])* _b[ptisoh:matu] ) ///
)


****
nlcom ///
_b[rsos:1.male#c.matu] + _b[rsos:matu] + ///
_b[griph:1.male#c.matu] + _b[griph:matu]*_b[rsos:1.male#c.griph] + _b[rsos:griph]

****
nlcom _b[ptisoh:matu]
nlcom _b[tsos:ptisoh]
nlcom _b[tsos:matu] 

nlcom _b[ptisoh:matu]*_b[tsos:ptisoh]
nlcom _b[tsos:matu] + _b[ptisoh:matu]*_b[tsos:ptisoh]

nlcom _b[ptisoh:1.male#c.matu] + _b[ptisoh:matu]
nlcom _b[tsos:1.male#c.ptisoh] + _b[tsos:ptisoh]
nlcom _b[tsos:1.male#c.matu] + _b[tsos:matu] 

nlcom ///
_b[tsos:1.male#c.matu] + _b[tsos:matu] + ///
_b[ptisoh:1.male#c.matu] + _b[ptisoh:matu]*_b[tsos:1.male#c.ptisoh] + _b[tsos:ptisoh]


esttab m1 m2 , wide ci noparentheses stats(N ll) ci( %9.2f) b(%9.2f) nostar interaction('-') replace, using esttable1.txt 

esttab m3 m4 , wide ci noparentheses stats(N ll)  ci( %9.2f) b(%9.2f) nostar interaction('-') , using esttable2.txt

esttab m1 m5 , wide ci noparentheses stats(N ll)  ci( %9.2f) b(%9.2f) nostar interaction('-') , using esttable3.txt

estimates restore m1
nlcom  _b[var(M3[id]):_cons] / ( _b[var(e.griph):_cons] + _b[var(M3[id]):_cons] )
nlcom  _b[var(M4[id]):_cons] / ( _b[var(e.ptisoh):_cons] + _b[var(M4[id]):_cons] )

nlcom  _b[var(M1[id]):_cons] / ( _b[var(e.rsos):_cons] + _b[var(M1[id]):_cons] )
nlcom  _b[var(M2[id]):_cons] / ( _b[var(e.tsos):_cons] + _b[var(M2[id]):_cons] )

nlcom  _b[cov(M3[id],M4[id]):_cons] / ( _b[var(M3[id]):_cons]^0.5 * _b[var(M4[id]):_cons]^0.5  )
nlcom  _b[cov(M3[id],M4[id]):_cons] 
nlcom  _b[var(M3[id]):_cons]
nlcom  _b[var(M4[id]):_cons] 

nlcom  _b[cov(M1[id],M2[id]):_cons] / ( _b[var(M1[id]):_cons]^0.5 * _b[var(M2[id]):_cons]^0.5  )
nlcom  _b[cov(M1[id],M2[id]):_cons] 
nlcom  _b[var(M1[id]):_cons]
nlcom  _b[var(M2[id]):_cons]  

nlcom _b[griph:matu]-_b[ptisoh:matu]
test _b[griph:matu]==_b[ptisoh:matu]

*indirect effect 
nlcom _b[griph:matu]*_b[rsos:griph]
nlcom _b[ptisoh:matu]*_b[tsos:ptisoh]

* total effects
nlcom _b[griph:matu]*_b[rsos:griph]+_b[rsos:matu]
nlcom _b[ptisoh:matu]*_b[tsos:ptisoh]+_b[tsos:matu]

estimate replay m5

estimates restore m2

nlcom  _b[var(M3[id]):_cons] / ( _b[var(e.zgriph):_cons] + _b[var(M3[id]):_cons] )
nlcom  _b[var(M4[id]):_cons] / ( _b[var(e.zptisoh):_cons] + _b[var(M4[id]):_cons] )

nlcom  _b[var(M1[id]):_cons] / ( _b[var(e.zrsos):_cons] + _b[var(M1[id]):_cons] )
nlcom  _b[var(M1[id]):_cons] / ( _b[var(e.ztsos):_cons] + _b[var(M2[id]):_cons] )

nlcom  _b[cov(M3[id],M4[id]):_cons] / ( _b[var(M3[id]):_cons]^0.5 * _b[var(M4[id]):_cons]^0.5  )
nlcom  _b[cov(M3[id],M4[id]):_cons] 
nlcom  _b[var(M3[id]):_cons]
nlcom  _b[var(M4[id]):_cons] 

nlcom  _b[cov(M1[id],M2[id]):_cons] / ( _b[var(M1[id]):_cons]^0.5 * _b[var(M2[id]):_cons]^0.5  )
nlcom  _b[cov(M1[id],M2[id]):_cons] 
nlcom  _b[var(M1[id]):_cons]
nlcom  _b[var(M2[id]):_cons]  

nlcom _b[zgriph:matu]-_b[zptisoh:matu]
test _b[zgriph:matu]==_b[zptisoh:matu]

estimates restore m1

nlcom _b[griph:matu]
nlcom _b[rsos:griph]
nlcom _b[griph:matu]*_b[rsos:griph]

nlcom _b[ptisoh:matu]
nlcom _b[tsos:ptisoh]
nlcom _b[ptisoh:matu]*_b[tsos:zptisoh]

estimates restore m2

nlcom _b[zgriph:matu]
nlcom _b[zrsos:zgriph]
nlcom _b[zgriph:matu]*_b[zrsos:zgriph]

nlcom _b[zptisoh:matu]
nlcom _b[ztsos:zptisoh]
nlcom _b[zptisoh:matu]*_b[ztsos:zptisoh]

estimates restore m1
nlcom _b[griph:matu]
nlcom _b[rsos:griph]
nlcom _b[griph:matu]*_b[rsos:griph]
nlcom _b[rsos:matu] 
nlcom _b[rsos:matu] + _b[griph:matu]*_b[rsos:griph]

estimates restore m1
nlcom _b[ptisoh:matu]
nlcom _b[tsos:ptisoh]
nlcom _b[ptisoh:matu]*_b[tsos:ptisoh]
nlcom _b[tsos:matu] 
nlcom _b[tsos:matu] + _b[ptisoh:matu]*_b[tsos:ptisoh]
