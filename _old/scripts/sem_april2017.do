
* November 8 2016
* Met with Nota and Baraket at 9:30
* 1. Elimimate curosr analysis, 2. Include hierarctical (not mediated) model, 3. Include full mediated model
* ssc install tabout 
*ssc install estout

clear all
cd "~/research/exercise_physiology"

capture rmdir "out"
mkdir "out"

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

sum rsosh tsosh griph ptisoh ntxch

gsem ///
(rsos <-  griph  matu  M1[id]) ///
(tsos <-  ptisoh matu  M1[id]) ///
(griph <-   matu   ) ///
(ptisoh <-  matu   ) 
matrix b = e(b)

gsem ///
(rsos <-  griph  matu  		M1[id]) ///
(tsos <-  ptisoh matu mvhh  M2[id]) ///
(griph <-   matu   ) ///
(ptisoh <-  matu   ) , from(b, skip)
matrix b = e(b)


gsem ///
(rsos <-  griph  matu  		M1[id]) ///
(tsos <-  ptisoh matu  mvhh M2[id]) ///
(griph <-   matu   M3[id]) ///
(ptisoh <-  matu   M4[id]) , from(b, skip)

matrix b = e(b)


gsem ///
(rsos <-  griph  matu   	ntxch  M1[id]) ///
(tsos <-  ptisoh matu  mvhh ntxch  M2[id]) ///
(griph <-   matu  godin ) ///
(ptisoh <-  matu  godin ) 

matrix b = e(b)

gsem ///
(rsos <-  griph  matu   	ntxch  M1[id]) ///
(tsos <-  ptisoh matu  mvhh ntxch  M2[id]) ///
(griph <-   matu  godin M3[id]) ///
(ptisoh <-  matu  godin M4[id]) , from(b, skip)


gsem ///
(rsos <- grip  matu  ntxc mvh M1[id]  c.grip#M3[id]) ///
(grip <- matu  vitd godin ) ///
(tsos <- ptiso matu ntxc mvh M2[id] c.ptiso#M4[id]) ///
(ptiso <- matu vitd godin) 

gsem ///
(rsos <-  grip  matu  ntxc mvh M1[id] ) ///
(grip <-  matu  vitd godin ) ///
(tsos <-  ptiso matu ntxc mvh M1[id]@1 c.ptiso#M4[id]) ///
(ptiso <- matu  vitd godin) 

gsem ///
(rsos <-  grip  matu ntxc     M1[id]) ///
(tsos <-  ptiso matu ntxc mvh M2[id]) ///
(grip <-   matu vitd godin  ) ///
(ptiso <-  matu vitd godin  ) 

gsem ///
(rsos <-  grip  matu ntxc      M1[id]) ///
(tsos <-  ptiso matu ntxc mvh  M2[id]) ///
(grip <-   matu gender ) ///
(ptiso <-  matu gender ) 
matrix b = e(b)

gen fgrip = gender*grip
gen fptiso = gender*ptiso
gen mgrip  = 1 - fgrip
gen mptiso = 1 - fptiso
gen fmatu = gender*matu
gen mmatu = 1-fmatu

gsem ///
(rsos <-  fgrip  mgrip matu M1[id]   ) ///
(tsos <-  fptiso mptiso matu M1[id]    ) ///
(fgrip <-   fmatu    ) ///
(mgrip <-   mmatu    ) 
matrix b = e(b)

gsem ///
(rsos <-   bn.gender#c.grip  matu  M1[id] ) ///
(tsos <-   bn.gender#c.ptiso  matu M1[id]) ///
(grip <-   matu  bn.gender, nocons ) ///
(ptiso <-  matu  bn.gender, nocons ) , from(b, skip)

gsem ///
(rsos <-  grip  matu ntxc      M1[id]) ///
(tsos <-  ptiso matu ntxc mvh  M1[id]) ///
(grip <-   matu godin vitd ) ///
(ptiso <-  matu godin vitd  ) if gender==1
matrix b = e(b)

gsem ///
(rsos <-  grip  matu ntxc  M1[id]#c.grip   ) ///
(tsos <-  ptiso matu ntxc mvh M1[id]#c.ptiso ) ///
(grip <-   matu godin vitd M2[id] ) ///
(ptiso <-  matu godin vitd M3[id]), from(b, skip)
matrix b = e(b)

gsem ///
(rsos <-  grip  matu ntxc      M1[id]) ///
(tsos <-  ptiso matu ntxc mvh  M2[id]) ///
(grip <-   matu  M3[id]) ///
(ptiso <-  matu ), from(b, skip)
matrix b = e(b)

gsem ///
(rsos <-  grip  matu ntxc      M1[id]) ///
(tsos <-  ptiso matu ntxc mvh  M2[id]) ///
(grip <-   matu  M3[id]) ///
(ptiso <-  matu  M4[id]), from(b, skip)

matrix b = e(b)

gsem ///
(rsos <-  grip  matu ntxc      M1[id]) ///
(tsos <-  ptiso matu ntxc mvh  M2[id]) ///
(grip <-   matu  gender) ///
(ptiso <-  matu  gender) 
matrix b = e(b)


gsem ///
(rsos <-  grip  matu ntxc      M1[id]) ///
(tsos <-  ptiso matu ntxc mvh  M2[id]) ///
(grip <-   matu godin vitd ) ///
(ptiso <-  matu godin vitd ) if gender==1

matrix b = e(b)

gsem ///
(rsos <-  grip  matu ntxc      M1[id]) ///
(tsos <-  ptiso matu ntxc mvh  M2[id]) ///
(grip <-   matu godin vitd ) ///
(ptiso <-  matu godin vitd ) , from(b)
matrix b = e(b)

gsem ///
(rsos <-  grip  matu ntxc      M1[id]) ///
(tsos <-  ptiso matu ntxc mvh  M2[id]) ///
(grip <-   matu godin vitd M3[id]) ///
(ptiso <-  matu godin vitd M4[id]) if ptiso <240, from(b)

matrix b = e(b)
foreach var in rsos grip matu godin {
gen d`var' = `var' - l.`var', after(falk)
}

reg rsos grip matu if nota==.
predict rhat 
replace rsos = rhat if nota==1
drop rhat

replace ptiso=.  if ptiso >200
reg ptiso grip
predict ptisohat 
replace ptiso = ptisohat if missing(ptiso)
drop ptisohat 

reg grip ptiso 
predict griphat
replace grip = griphat if missing(grip)
drop griphat

reg mvh paq
predict mvhhat
replace mvh = mvhhat  if missing(mvh)
drop mvhhat

reg ntxc rsos tsos
predict ntxch
replace ntxc = ntxch  if missing(ntxc)
drop ntxch

gen matu2 = matu*matu

sum rsos tsos grip ptiso age mvh ntxc paq godin cint calc vitd vitd2
corr  rsos tsos grip ptiso age mvh ntxc paq godin cint calc vitd vitd2
foreach var  in rsos tsos grip ptiso age mvh ntxc paq godin cint calc vitd vitd2 {
egen z`var' = std(`var')
}

gen zptiso2 = zptiso*zptiso
gen zgrip2 = zgrip*zgrip

*****************************************************************
corr rsos grip matu
corr tsos ptiso matu

xtsum rsos tsos grip ptiso matu
xtdescribe

***********
eststo r4: gsem (rsos <- grip   ntx   M1[id] ) (grip <- matu  vitd godin)  

eststo r1: gsem (rsos <- grip matu ntxc  M1[id] )   (grip@0 <-  , nocons)  if _est_r4==1
scalar s1 = e(ll)
eststo r2: gsem ///
(rsos <- grip matu ntxc M1[id]) ///
(grip <- matu vitd godin ) /// 

if _est_r4==1

eststo r2: gsem ///
(rsos <- grip matu ntxc M1[id]) ///
(grip <- matu  vitd godin ) /// 
if _est_r4==1

scalar s2 = e(ll)
eststo r3: gsem (rsos <- grip   ntx   M1[id] ) (grip <- matu  M2[id])  if _est_r4==1
scalar s3 = e(ll)
eststo r4: gsem (rsos <- grip   ntx   M1[id] ) (grip <- matu  vitd godin  c.matu#M2[id])  if _est_r4==1
scalar s4 = e(ll)

*******************
. gsem ///
> (rsos <- grip matu ntxc M1[id]) ///
> (grip <- matu  vitd godin ) ///
> (tsos <- ptiso matu ntxc mvh M2[id]) ///
> (ptiso <- matu vitd godin)


gsem ///
(rsos <- grip matu ntxc  M1[id]) ///
(grip <- matu vitd  godin ) ///
(tsos <- ptiso matu ntxc mvh M2[id]) ///
(ptiso <- matu vitd godin) if nota!=1 & falk!=1

gsem (tsos <- ptiso matu mvh ntxc  M1[id] )  if _est_r4==1

gen matu2 = matu*matu
gen matu3 = matu*matu*matu

gsem (tsos <- ptiso matu ntxc mvh M1[id])
gsem (tsos <- ptiso matu ntxc mvh M1[id] c.ptiso#M3[id]) (ptiso <- matu vitd M2[id]) if ptiso <210
gsem (tsos <- ptiso 	 ntxc mvh M1[id]) (ptiso <- matu vitd M2[id]) if ptiso <210


gsem (tsos <- ptiso matu ntxc mvh M1[id]) ///
(ptiso <- matu vitd ) ///
(mvh <- matu vitd M2[id]) if ptiso <210

gsem (tsos <- ptiso matu mvh ntx  M1[id] ) (ptiso <- matu vitd M2[id])   if ptiso<200 
gsem (tsos <- ptiso 	 mvh ntx  M1[id]) (ptiso <- matu vitd M2[id])  if ptiso<200 & falk!=1 & nota!=1






gsem (lnrsos <- lngrip  lnage M1[id] ) (lngrip <- lnage )   (lntsos <- lnptiso lnage  M1[id] )  (lnptiso <- lnage  )  if  ptiso <200 

gsem (rsos <- grip  matu M1[id] ) (grip <- matu M2[id] )   (tsos <- lnptiso matu  M1[id] )  (lnptiso <- matu M3[id]  ) if  ptiso <200 

gsem (zrsos <- zgrip  matu  M1[id] )  (zgrip <- matu M2[id] )   (ztsos <- zptiso matu   M1[id] )   (zptiso <- matu M3[id]  )  if  nota!=1 
gsem (zrsos <- zgrip  matu  M1[id] )  (zgrip <- matu M2[id] )   (ztsos <- zptiso matu   M1[id] )   (zptiso <- matu M2[id]  )  if  nota!=1 ,

gsem ///
 (zrsos <- zgrip  matu  zgodin  M1[id] M3[id]#c.zgrip )  ///
 (ztsos <- zptiso matu zgodin  M1[id] M3[id]#c.zptiso)  ///
 (zgrip <-   matu M2[id] )  ///
 (zptiso <- matu M2[id] ) ///
  if  nota!=1 & ptiso<200 & falk!=1 ///
, cov(M2[id]*M1[id]@0 M2[id]*M3[id]@0 M1[id]*M3[id]@0)

corr zmvh zntxc zpaq zgodin zcint zcalc zvitd matu zrsos ztsos zgrip zptiso


foreach var in zmvh zntxc zpaq zgodin zcint zcalc zvitd {
gsem ///
 (zrsos <- zgrip  matu  `var' M1[id] )  ///
 (ztsos <- zptiso matu `var' M1[id] )  ///
 (zgrip <-   matu  M2[id] )  ///
 (zptiso <- matu M2[id] ) ///
  if  nota!=1 & ptiso<200 & falk!=1 ///
, cov(M2[id]*M1[id]@0)
}

reg ptiso grip
predict ptisohat if missing(ptiso)
replace ptiso = ptisohat if missing(ptiso)
drop zptisohat

sum rsos tsos ptiso grip matu
reg zgrip zrsos matu
predict 
reg zgrip matu

constraint 1 _b[zrsos:M1[id]] =  1
constraint 2 _b[ztsos:M1[id]] =  1
constraint 3 _b[zgrip:M2[id]] =  1
constraint 4 _b[zptiso:M2[id]] =  1

gsem ///
 (zrsos <- zgrip   matu   M1[id]  )  ///
 (ztsos <- zptiso  matu  zmvh M1[id] )  ///
 (zgrip <-   matu zvitd zgodin)  ///
 (zptiso <- matu zvitd zgodin )  ///
, constraints(1 2)  

constraint 1 _b[zrsos:matu =  1
constraint 2 _b[ztsos:M1[id]] =  1
constraint 3 _b[zgrip:matu] =  _b[zptiso:matu] 
constraint 4 _b[zptiso:M2[id]] =  1

gsem ///
 (zrsos <- zgrip    matu                 M1[id]@1)   ///
 (ztsos <- zptiso  matu     zmvh  M1[id]@1)    ///
 (zgrip <-   matu   M2[id]@1)  ///
 (zptiso <- matu   M2[id]@1) , cov(M1[id]*M2[id]@0)

, cov(M1[id]*M2[id]@0)

constraint 1 _b[zrsos:matu] =  _b[ztsos:matu] 
constraint 2 _b[zrsos:matu2] =  _b[ztsos:matu2] 
constraint 3 _b[zrsos:zgrip] =  _b[ztsos:zptiso] 
constraint 4 _b[zgrip:matu] =  _b[zptiso:matu] 


* almost all at 0.05
gsem ///
 (zrsos <- zgrip   matu      zntxc             M1[id] )   ///
 (ztsos <- zptiso  matu     zntxc zmvh  M1[id]  )    ///
 (zgrip <-   matu  M2[id]     )  ///
 (zptiso <- matu  M3[id]      )   

gsem ///
 (zrsos <- zgrip   matu    zntxc              M1[id]   )    ///
 (ztsos <- zptiso  matu   zntxc zmvh   M1[id]   )    ///
 (zgrip <-   matu   M2[id]   )  ///
 (zptiso <- matu   M2[id]   )   

gsem ///
 (zrsos <- zgrip   matu  zntxc              M1[id] )    ///
 (ztsos <- zptiso  matu  zntxc zmvh  M1[id]   )    ///
(zgrip <-   matu  zgodin  )  ///
(zptiso <- matu  zvitd   )  
matrix b = e(b)

* very good results
gsem ///
 (zrsos <- zgrip   matu  zntxc             M1[id]   )    ///
 (ztsos <- zptiso  matu  zntxc zmvh  M1[id]   )    ///
(zgrip <-   matu  zgodin   M2[id]   )  ///
(zptiso <- matu  zvitd      M3[id]  )  , from(b) 


 gsem ///
 (zrsos <- zgrip   matu  zntxc             )    ///
 (ztsos <- zptiso  matu  zntxc zmvh  )    ///
(zgrip <-   matu  zgodin    )  ///
(zptiso <- matu  zvitd      ) 
matrix b = e(b)

gsem ///
 (zrsos <- zgrip   matu  zntxc             M1[id]   )    ///
 (ztsos <- zptiso  matu  zntxc zmvh  M2[id]   )    ///
(zgrip <-   matu  zgodin   M3[id]   )  ///
(zptiso <- matu  zvitd      M4[id]  )  , from(b)

zntxc zpaq zgodin zcint
, constraint(1 2 3 4)

 ///
, cov(M1[id]*M2[id]@0)


scatter ztsos zpaq

gsem (rsos <- grip  matu M1[id] c.grip#M3[id] ) (grip <- matu  M2[id])  
gsem (rsos <- grip  matu M1[id] ) (grip <- matu  M2[id])  (M1[id] <-grip)
lrtest r1 r2 , stats
lrtest r3 r2  , stats
lrtest r3 r4  , stats

di "chi2(2) = " 2*(re-me)
di "Prob > chi2 = "chi2tail(1, 2*(s3-s2))

*********
gsem (tsos <- ptiso matu mvh ntx   M1[id] )  
gsem (tsos <- ptiso matu mvh ntx  M1[id] ) (ptiso <- matu vitd  c.matu#M2[id])   if ptiso<200 

gsem (tsos <- ptiso matu mvh ntx  M1[id] ) (ptiso <- matu vitd M2[id])   if ptiso<200 
gsem (tsos <- ptiso 	 mvh ntx  M1[id]) (ptiso <- matu vitd M2[id])  if ptiso<200 & falk!=1 & nota!=1






gsem (rsos <- grip matu  M1[id] ) 
sum drsos dgrip dmatu
gen prsos = drsos / rsos 
gen pgrip = dgrip / grip

reg rsos id
sum  rsos grip matu drsos dgrip prsos pgrip
corr rsos grip matu
corr tsos ptiso matu

xtsum rsos tsos grip ptiso matu
xtdescribe

xtmixed rsos id || id:
gsem (rsos <- M[id])
gsem (rsos <- )
xtreg rsos  , re

constraint 1 _b[rsos:matu] = 0
constraint 2 _b[grip:vitd] = 0
constraint 3 _b[grip:godin] = 0
constraint 4 _b[grip:M2[id]] = 0

eststo r1: gsem (rsos <- grip matu ntxc  M1[id] ) 
scalar r1 = e(ll)

eststo r4: gsem (rsos <- grip   ntx   M1[id] ) (grip <- matu  vitd godin  M2[id])  

eststo r1: gsem (rsos <- grip matu ntxc  M1[id] )   (grip@0 <- ) 

eststo r1: gsem (rsos <- grip matu ntxc  M1[id] )   (grip@0 <-  , nocons)  if _est_r4==1
scalar s1 = e(ll)
eststo r2: gsem (rsos <- grip matu ntxc  M1[id] ) (grip <- matu  M2[id])  if _est_r4==1
scalar s2 = e(ll)
eststo r3: gsem (rsos <- grip   ntx   M1[id] ) (grip <- matu  M2[id])  if _est_r4==1
scalar s3 = e(ll)
eststo r4: gsem (rsos <- grip   ntx   M1[id] ) (grip <- matu  vitd godin  M2[id])  if _est_r4==1
scalar s4 = e(ll)
di  s1
di  s2
di  s3
di s4

lrtest r1 r2 , stats
lrtest r3 r2  , stats
lrtest r3 r4  , stats

di "chi2(2) = " 2*(re-me)
di "Prob > chi2 = "chi2tail(1, 2*(s3-s2))


eststo r3: gsem (rsos <- grip matu ntx   M1[id] ) (grip <- matu vitd godin M2[id])  , constraint(1)
nlcom _b[rsos:grip]*_b[grip:matu]
nlcom _b[rsos:grip]*_b[grip:vitd]
nlcom _b[rsos:grip]*_b[grip:godin]

lrtest r1 r2 , stats
lrtest r3 r2 
sem (rsos <- grip             ntx   ) (grip <- matu vitd godin ) 
estat teffects
nlcom _b[rsos:grip]*_b[grip:matu]

*table1:  Summary stats by measurement occasion
tabout seq using "out/table1_all.csv", replace f(4) sum style(csv) ///
c(N rsos mean rsos sd rsos mean grip sd grip mean matu sd matu) 
tabout seq using "out/table1_female.csv" if fema==0, append f(4) sum style(csv) ///
c(N rsos mean rsos sd rsos mean grip sd grip mean matu sd matu) 
tabout seq using "out/table1_male.csv" if fema==1, append f(4) sum style(csv) ///
c(N rsos mean rsos sd rsos mean grip sd grip mean matu sd matu)


gsem (rsos <- grip matu ntx  M1[id] ) , noci
gsem (rsos <- grip matu ntx M1[id] ) 
gsem (rsos <- grip matu ntx M1[id]  c.grip#M2[id] )    (grip <- matu M2[id]) 
gsem (rsos <- grip matu ntx M1[id] ) (grip <- matu M2[id]) 
gsem (rsos <- grip           ntx M1[id] c.grip#M2[id]  ) (grip <- matu M2[id]) 

gsem (tsos <- ptiso matu M1[id])  if ptiso<200

gen ptisod = ptiso

gsem (tsos <- ptiso matu mvh ntx   M1[id] )  
gsem (tsos <- ptiso matu mvh ntx  M1[id] ) (ptiso <- matu vitd M2[id])   if ptiso<200 

gsem (tsos <- ptiso matu mvh ntx  M1[id] ) (ptiso <- matu vitd M2[id])   if ptiso<200 
gsem (tsos <- ptiso 	 mvh ntx  M1[id]) (ptiso <- matu vitd M2[id])  if ptiso<200 & falk!=1 & nota!=1

gsem (tsos <- ptiso matu  M1[id] ) , listwise
gsem (lntsos <- lnptiso matu M1[id] ) 

gsem (rsos <- grip matu ntx godin vitd M1[id] ) 
gsem (rsos <- grip matu ntx M1[id] ) 
gsem (rsos <- grip matu ntx M1[id] c.grip#M2[id])
gsem (rsos <- grip matu ntx M1[id] ) (grip <-   M2[id]) 
gsem (rsos <- grip matu ntx M1[id] ) 
xtmixed rsos grip matu ntx || id: grip

gsem (rsos <- grip matu ntx M1[id] ) (grip <- matu M2[id]) 
gsem (rsos <- grip           ntx M1[id] ) (grip <- matu M2[id]) 

gsem (rsos <- grip           ntx M1[id]   c.grip#M3[id]) (grip <- matu M2[id]) 


predict nv1, mu outcome(rsos)
predict nv1, mu outcome(rsos)
predict mv11, eta outcome(rsos)
predict nv2, mu outcome(grip)
predict s*, latent
predict x*, eta conditional(fixedonly)

predict ability, outcome(grip)
predict stub*

margins, dydx(grip)
estat summarize

g
gsem (rsos <- grip      ntx M1[id] ) (grip <- matu godin vitd M2[id]) , group(male)
gsem (rsos <- grip       M1[id] ) (grip <- matu  M2[id]) 
gsem (rsos <- grip matu M1[id] ) (grip <- matu  M2[id]) 

gsem (tsos <- ptiso matu M1[id])  if ptiso<200
gsem (tsos <- ptiso matu M1[id])  if ptiso<200

gsem (tsos <- ptiso matu ntx mvh vitd M1[id] ) if (dtsos>0 & dptiso>0 & falk!=1) 
gsem (tsos <- ptiso matu ntx mvh vitd M1[id] ) if (dtsos>0 & dptiso>0 & falk!=1)

gsem (tsos <- ptiso matu mvh ntx  M1[id]) (ptiso <- matu   M2[id]) if (dtsos>0 & dptiso>0 & falk!=1)
gsem (tsos <- ptiso 	  ntx mvh M1[id] c.ptiso#M3[id]) (ptiso <- matu vitd)    if ptiso<200
gsem (tsos <- ptiso 	matu mvh   M1[id] ) (ptiso <- matu   M2[id])    if ptiso<200

gsem (tsos <- ptiso 	matu mvh   M1[id] c.ptiso#M3[id]) (ptiso <- matu   M2[id])    if ptiso<200
gsem (tsos <- ptiso 	 mvh   M1[id] c.ptiso#M3[id]) (ptiso <- matu   M2[id])    if ptiso<200

gsem (tsos <- ptiso matu mvh ntx  M1[id]) (ptiso <- matu vitd M2[id])   if ptiso<200
gsem (tsos <- ptiso 	 mvh ntx  M1[id]) (ptiso <- matu vitd M2[id])  if ptiso<200

gsem (tsos <- ptiso matu  M1[id] ) (ptiso <- matu  M2[id]) 
gsem (tsos <- ptiso godin  M1[id] ) (ptiso <- matu  M2[id])  if ptiso<200

sem (tsos <- ptiso matu mvh ntx  M1[id]) (ptiso <- matu vitd M2[id]) 
gsem (tsos <- ptiso matu mvh ntx  M1[id]) (ptiso <- matu vitd M2[id])   if ptiso<200 
gsem (tsos <- lnptiso matu mvh ntx  M1[id]) (lnptiso <- matu vitd M2[id])   if ptiso<200


/*
gsem rsos <- grip matu  M1[id] 
gsem rsos <- grip matu  M1[id] if nota!=1
gsem rsos <- grip matu  M1[id] if falk!=1
gsem rsos <- grip matu  M1[id] if nota!=1 & falk!=1

gsem tsos <- ptiso matu godin M1[id] 
gsem tsos <- ptiso matu godin M1[id] if nota!=1
gsem tsos <- ptiso matu godin M1[id] if falk!=1
gsem tsos <- ptiso matu godin M1[id] if nota!=1 & falk!=1

gsem tsos <- pt60 matu godin M1[id] 
gsem tsos <- pt60 matu godin M1[id] if nota!=1
gsem tsos <- pt60 matu godin M1[id] if falk!=1
gsem tsos <- pt60 matu godin M1[id] if nota!=1 & falk!=1

*/
********************************************************************************
eststo r11: gsem (rsos <- grip matu M1[id] ) (grip <- matu M2[id])
eststo r12: gsem (rsos <- grip matu M1[id] ) (grip <- matu ), covstructure(_LEx, diagonal)
eststo r13: gsem (rsos <- grip matu M1[id] ) (grip <- matu ), covstructure(_LEx, un)
eststo r14: gsem (rsos <- grip matu M1[id] ) (grip <- matu M2[id]), cov(e.rsos*e.grip )
eststo r15: gsem (rsos <- grip matu M1[id] ) (grip <- matu M2[id]), cov(e.rsos*e.grip M1[id]*M2[id])


eststo r2: gsem (rsos <- grip matu M1[id] ) (grip <- matu M2[id])
eststo r3: gsem (rsos <- grip matu M1[id] ) (grip <- matu M2[id]), covstructure(_LEx, diagonal)
eststo r4: gsem (rsos <- grip matu M1[id] ) (grip <- matu M2[id]), covstructure(_LEx, un)
eststo r5: gsem (rsos <- grip matu M1[id] ) (grip <- matu M2[id]), covstructure(un)
eststo r6: gsem (rsos <- grip matu M1[id] ) (grip <- matu M2[id]), covstructure(un)
eststo r7: gsem (rsos <- grip matu M1[id] ) (grip <- matu M2[id]), covstructure(un)

estimates table r11 r12 r13 r14 r15 , p stats(N ll chi2 aic) 

global RFULL "gsem (rsos <- grip matu M1[id] c.grip#M11[id]) (grip <- matu M2[id])"
global RSING "gsem (rsos <- grip matu M1[id] c.grip#M11[id]) (grip@0 <- )"

constraint 1 _b[rsos:c.grip#M11[id]] = 0

global RFULL "gsem (rsos <- grip matu M1[id]) (grip <- matu M2[id])"
constraint 1 _b[rsos:matu] = 0

*shapiro-wilks: null is distribution is normal
reg rsos grip matu
reg, beta
histogram rsos , normal
histogram tsos, normal
histogram grip, normal
histogram ptiso, normal
histogram godin, normal
histogram matu, normal

swilk rsos tsos grip ptiso godin matu
reg rsos grip matu, beta

gsem (rsos <- grip matu  M1[id] ) 
gsem (rsos <- grip matu  M1[id] )   (grip@0 <- )
gsem (rsos <- grip matu  M1[id] )
gsem (rsos <- grip matu  M1[id] ) (grip <- matu M2[id]) 
gsem (rsos <- grip       M1[id] ) (grip <- matu M2[id]) 

gsem (rsos <- grip godin M1[id] c.grip#M11[id] ) (grip <- matu M2[id]) 

gsem (tsos <- ptiso matu godin M1[id] ) (ptiso <- matu  M2[id])
******************************************************************************
global TRES "if (dtsos>0 & dptiso>0 & falk!=1)"

* Radial

global RFULL "gsem (rsos <- grip matu M1[id]) (grip <- matu M2[id])"
constraint 1 _b[rsos:matu] = 0

eststo r1: gsem (rsos <- grip matu M1[id] )
eststo r2: $RFULL 
eststo r3: $RFULL , constraint(1)
estimates table r1 r2 r3, p stats(N ll chi2 aic) b( %9.2f) p( %9.2f) stf(%9.2f)

* Tibial

gsem (tsos <- ptiso matu godin M1[id] )
global TFULL "gsem (tsos <- ptiso matu godin M1[id] ) (ptiso <- matu godin M2[id])"

constraint 2 _b[tsos:matu] = 0
constraint 3 _b[tsos:godin] = 0

constraint 4 _b[ptiso:matu] = 0
constraint 5 _b[ptiso:godin] = 0

eststo t1: $TFULL $TRES
eststo t2: $TFULL $TRES, constraint(2)
lrtest t1 t2
eststo t3: $TFULL $TRES, constraint(2 3)
lrtest t1 t3
eststo t4: $TFULL $TRES, constraint(2 4 5)
lrtest t1 t4
lrtest
"chi2tail(5, 2*(re-me))
******************************************************************************
eststo ri: gsem  tsos <- ptiso matu godin M1[id] 
eststo ri: gsem  tsos <- ptiso matu godin M1[id] c.ptiso#M11[id] 

*global TFULL "gsem (tsos <- ptiso matu godin M1[id] c.ptiso#M11[id]) (ptiso <- matu M2[id])"
gsem (tsos <- ptiso matu M1[id] c.ptiso#M11[id] ) if (dtsos>0 & dptiso>0)

gsem (tsos <- ptiso matu M1[id] ) if (dtsos>0 & dptiso>0 & falk!=1)
global TFULL "gsem (tsos <- ptiso matu godin M1[id] ) (ptiso <- matu godin M2[id]) if (dtsos>0 & dptiso>0 & falk!=1)"

*constraint 1 _b[tsos:c.ptiso#M11[id]] = 0
constraint 2 _b[tsos:matu] = 0
constraint 3 _b[ptiso:matu] = 0
constraint 4 _b[tsos:godin] = 0
constraint 5 _b[ptiso:godin] = 0

eststo t1: $TFULL
eststo t2: $TFULL , constraint(2)
lrtest t1 t2
eststo t3: $TFULL , constraint(2 4)
lrtest t1 t3
eststo t4: $TFULL , constraint(2 4 5)
lrtest t1 t4
lrtest 
global TFULL2 "gsem (tsos <- ptiso matu paqprvnt M1[id] ) (ptiso <- matu paqprvnt M2[id]) if (dtsos>0 & dptiso>0)"

eststo t1: $TFULL2
eststo t2: $TFULL2 , constraint(3)
lrtest t1 t2
eststo t3: $TFULL2 , constraint(2)
lrtest t1 t3

estimates table t1 t2 t3 t4 , p stats(N ll chi2 aic) 

gsem  (tsos <- ptiso matu godin M1[id]) (ptiso <- matu M2[id])
gsem  (tsos <- ptiso matu godin M1[id]) (ptiso <- matu ), cov(e.tsos*e.ptiso )
eststo ri: gsem  (tsos <- ptiso matu godin M1[id]) (ptiso <- matu M2[id])

constraint 1 _b[rsos:c.grip#M11[id]] = 0
constraint 2 _b[rsos:matu] = 0

eststo r1: $RSING , constraint(1)
eststo r1: $RFULL , constraint(1)
eststo r1: $RFULL , constraint(2)
eststo r1: $RFULL , constraint(1 2)


global RFULL "gsem (rsos <- grip matu M1[id] c.grip#M11[id]) (grip <- matu M2[id])"

gsem (rsos <- grip matu M1[id] ) (grip <- matu M2[id] )
gsem (rsos <- grip matu M1[id] ) (grip <- matu )
gsem (rsos <- grip matu M1[id] )

* random intercepts
eststo ri: gsem  rsos <- grip matu M1[id], coeflegend 
eststo ri: gsem (rsos <- grip matu M1[id] ) (grip@0 <- )

* random intercepts and slope

eststo rs: gsem (rsos <- grip matu M1[id] c.grip#M11[id]) 
eststo rs: gsem (rsos <- grip matu M1[id] c.grip#M11[id]) (grip@0 <- )

eststo re1: gsem rsos <- grip  matu  M1[id] 
eststo re2: gsem rsos <- grip  matu  M1[id] c.grip#M11[id]
lrtest re1 re2

global RFULL "gsem (rsos <- grip matu M1[id] c.grip#M11[id]) (grip <- matu M2[id])"

eststo rfull: $RFULL 
scalar rfull = e(ll)

constraint 1 _b[rsos:matu] = 0
constraint 2 _b[rsos:c.grip#M11[id]] = 0

eststo r1: $RFULL , constraint(1)
eststo r2: $RFULL , constraint(2)

ml_mediation, dv(rsos) iv(grip) mv(matu) l2id(id)

lrtest r2 rfull

eststo r2: $RFULL , constraint(2) cov(M1[id]*M2[id]@0)

eststo re: mixed rsos grip matu || id:grip

eststo re1: gsem rsos <- grip  matu  M1[id] 
eststo re2: gsem rsos <- grip  matu  M1[id] c.grip#M11[id]
lrtest re1 re2


eststo re: gsem rsos <- grip matu  M1[id]
scalar re = e(ll)


eststo me: gsem rsos <- grip matu  M1[id]
eststo me: gsem (rsos <- grip matu M1[id] c.grip#M11[id]) (grip@0 <-  M2[id])
lrtest rfull me

scalar me = e(ll)

di "chi2(2) = " 2*(re-me)
di "Prob > chi2 = "chi2tail(5, 2*(re-me))

estimates table r1 r2 r3 rfull, stats(N ll chi2 aic) 

lrtest r4 r2 , stats
di "chi2(2) = " 2*(r4-r2)
di "Prob > chi2 = "chi2tail(1, 2*(r4-r2))

lrtest r4 r3, stats
di "Prob > chi2 = "chi2tail(1, 2*(r4-r3))

lrtest r4 r1
di "Prob > chi2 = "chi2tail(1, 2*(r4-r1))

di "chi2(2) = " 2*(l1-l2)
di "Prob > chi2 = "chi2tail(1, 2*(l1-l2))

gsem (tsos <- ptiso matu godin M1[id]) (ptiso <- matu godin M2[id])  
gsem (tsos <- ptiso  M1[id]) (ptiso <- matu godin M2[id])  

gsem (rsos <- grip  M1[id] c.grip#M1S[id]) (grip <- matu godin_pa M2[id]) 
gsem (tsos <- ptiso  M1[id]) (ptiso <- matu godin_pa M2[id]) 



xtline rsos

gen lnrsos = ln(rsos)
gen lngrip = ln(grip)
gen lntsos = ln(tsos)
gen lnptiso = ln(ptiso)
gen lnpt60 = ln(pt60)

*Empirical models (random effects, fully mediated, partially mediated)
gsem lnrsos <- grip matu M1[id]
gsem lntsos <- lnpt60 matu godin M1[id] c.ptiso#M1S[id]


gsem rsos <- grip matu M1[nid] if !missing(pt60) & !missing(tsos) 

gsem (rsos <- grip matu M1[nid] c.grip#M1S[nid]) (grip <- matu M2[nid]) 
gsem (rsos <- grip M1[nid] c.grip#M1S[nid]) (grip <- matu M2[nid])

drop if nota==1

* clean
sum *

bys session: tab sequence
sort id sequence
save ./out/dt, replace


*drop if sequence == 1

*drop if missing(radius_sos) | missing(tibial_sos) 
*drop if missing(grip_strength_best) | missing(ptiso)
*drop if missing(age)

*gen miss_sos = ( missing(radius_sos) | missing(tibial_sos) )
*gen miss_grippt = ( missing(grip_strength_best) | missing(ptiso) )
*gen miss_matu = (missing(age))

* new seq 
sort id sequence
by id: egen seq = seq()
order id session sequence seq

rename radius_sos rsos
rename tibial_sos tsos
rename grip_strength_best grip 
rename mat_offset_new matu
rename godin_pa godin
rename paq_total_score totpaq

global X "rsos tsos grip ptiso pt60 matu age godin totpaq "
order id session sequence seq $X

xtset id seq
foreach var in rsos tsos grip ptiso pt60 matu age godin totpaq  {
gen d`var' = `var' - l.`var', after(`var')
}


export delimited using "/home/vmuser/Documents/bone/out/data_examine.csv", replace

drop if nrsos == 1
drop if nrsos == 1
drop if nmatu == 1

drop if missing(rsos) | missing(tsos) 
drop if missing(grip) | missing(ptiso)

by id: egen seq2 = seq()

export delimited using "/home/vmuser/Documents/bone/out/data_positives.csv", replace


gen drsos = rsos - l.rsos, after(rsos)
gen dtsos = tsos - l.tsos, after(tsos)
gen dgrip = grip - l.grip, after(grip)
gen dptiso = ptiso - l.ptiso, after(ptiso)
gen dpt60 = pt60 - l.pt60, after(pt60)
gen dmatu = matu - l.matu, after(matu)
gen dmatu = matu - l.matu, after(matu)
gen dmatu = matu - l.matu, after(matu)


*drop if (drsos<0 | dtsos<0 | dgrip<0 |dmatu<0)
gen decr_rsos = ( drsos<0 )
gen decr_tsos = ( dtsos<0 )
gen decr_grip = ( dgrip<0 )
gen decr_ptiso = ( dptiso<0 )
gen decr_matu = ( dmatu<0 )

tab decr_rsos
tab decr_tsos
tab decr_grip
tab decr_ptiso
tab decr_matu

gen dec_grippt = ( missing(grip_strength_best) | missing(ptiso) )
gen decr_matu = (missing(age))

by id: egen nses = max(seq)
xtset id sequence

*Empirical models (random effects, fully mediated, partially mediated)

gsem rsos <- grip matu godin_pa M1[id]
gsem tsos <- ptiso matu godin_pa M1[id] 

gsem (rsos <- grip matu godin_pa M1[id]) (grip <- matu godin_pa M2[id]) 
gsem (tsos <- ptiso matu  godin_pa M1[id]) (ptiso <- matu godin_pa M2[id]) 

gsem (rsos <- grip  M1[id] c.grip#M1S[id]) (grip <- matu godin_pa M2[id]) 
gsem (tsos <- ptiso  M1[id]) (ptiso <- matu godin_pa M2[id]) 

*drop if seq==1
by id: egen seq2 = seq()
order seq2, after(seq)
gen dseq = seq - seq2, after(seq2)

drop if missing(radius_sos) | missing(tibial_sos)

keep id session seq radius_sos tibial_sos grip_strength_best mat_offset_new age ptiso pt60
rename radius_sos rsos
rename tibial_sos tsos
rename grip_strength_best grip 
rename mat_offset_new matu


xtset id seq
gen drsos = rsos - l.rsos
gen dtsos = tsos - l.tsos
gen dgrip = grip - l.grip
gen dmatu = matu - l.matu
gen dage  = age - l.age

sum *
by id: tab seq

reg grip rsos
predict griphat 
order griphat, after(grip)

gen misgrip = (missing(grip))
bys seq: tab misgrip

gen mispt = (missing(ptiso))
bys seq: tab mispt

gen lnage = ln(age)
gen lngrip = ln(grip)
reg lngrip lnage
predict lngriphat
gen griphat = exp(lngriphat), after(grip)

import excel ./data/NegativeIDs.xls, sheet("Sheet1") firstrow case(lower) clear 

import delimited ./data/muscleStrengthForAnalysis.csv,  case(lower) clear 

import delimited ./data/muscleStrengthForAnalysis.csv,  case(lower) clear 

muscleStrengthForAnalysis


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
global radial_var "id sequence session rsos grip age matu fema vita pact ntxc godin_pa"
global tibial_var "tibial_sos tibial_z wrist_flexion_best grip forearm_length forearm_lean_csa forearm_us_csa anterior_csa anterior_radius ant_rad_csa anterior_ulna ant_ulna_csa posterior post_csa tibialis_anterior  biodex_id pt* tot_mvh tot_sedetary"
keep $radial_var $tibial_var
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
order nid seq rsos grip age matu fema male Cage vita pact $tibial_var

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

drop tibial_z wrist_flexion_best forearm_length forearm_lean_csa forearm_us_csa anterior_csa anterior_radius ant_rad_csa anterior_ulna ant_ulna_csa posterior post_csa tibialis_anterior 
*drop if ptiso==-9999
replace ptiso = . if ptiso==-9999
replace pt60  = . if pt60 ==-9999
replace pt240 = . if pt240==-9999
rename tibial_sos tsos

*Empirical models (random effects, fully mediated, partially mediated)
gsem rsos <- grip matu M1[nid] c.grip#M1S[nid]
gsem rsos <- grip matu M1[nid] if !missing(pt60) & !missing(tsos) 

gsem (rsos <- grip matu M1[nid] c.grip#M1S[nid]) (grip <- matu M2[nid]) 
gsem (rsos <- grip M1[nid] c.grip#M1S[nid]) (grip <- matu M2[nid])
gsem $PM if male==1
gsem $PM if male==0

gsem tsos <- ptiso matu  M1[nid] 
gsem tsos <- pt60  matu  M1[nid] 

gsem (tsos <- ptiso  matu M1[nid]) (ptiso <- matu  ) if !missing(pt60) & !missing(tsos) 
gsem (tsos <- ptiso  matu M1[nid] c.ptiso#M1S[nid] ) (ptiso <- matu pact )
gsem (tsos <- ptiso  M1[nid] c.ptiso#M1S[nid]) (ptiso <- matu pact)


eststo TRE: gsem rsos <- pt matu  M1[nid] 

global TRE240  "rsos <- pt240 matu M1[nid] c.pt240#M1S[nid]"

global TPM60 "(tibial_sos <- pt60  M1[nid] c.pt60#M1S[nid]) (pt60 <- matu M2[nid]) "
global TPM240 "(tibial_sos <- pt240  M1[nid] c.pt240#M1S[nid]) (pt240 <- matu M2[nid]) "

eststo TRE: gsem $TRE60
eststo TRE: gsem $TRE240
eststo TPM60: gsem $TPM60
