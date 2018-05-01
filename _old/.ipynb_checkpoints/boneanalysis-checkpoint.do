clear all
set more off, perm
cd ~

gl PR = "muscleStrength"
gl DH = "~/GitHub/researchGit/projects/exerciseScience/working"
gl DM = "~/GitHub/researchGit/researchModules"
gl WR = "/home/kmongeon/work/projects/tradResearch"
gl DD = "$WR/dataSource/$PR"
gl WW = "$WR/workAnalysis/$PR"

gl WD = "$WW/data"
gl WL = "$WW/logs"
gl WG = "$WW/graphs"
gl WT = "$WW/tables"
gl WE = "$WW/estimates"
gl WP = "$WW/temp"


global dnm = "dm.csv"
global dn1 = "NegativeIDs.xls"

import excel "$DD/$dn1", sheet("Sheet1") firstrow case(lower) clear 
keep if todrop==1
keep id sequence
sort id sequence 
capture save "$WD/msObsToDrop.dta", replace

import delimited "$DD/$dnm", case(lower) clear
sort id sequence 
merge 1:1 id sequence using "$WD/msObsToDrop.dta"
drop if _merge==3 
drop _merge
drop v1

rename radius_sos 		rsos
rename grip_strength_best 	grip
rename mat_offset_new 		matu
rename gender			fema
rename vit_d			vita
rename paq_total_score		pact
rename ntxcreat			ntxc

*summary of all data
sum * , sep(0)
sum * if fema ==0, sep(0)
sum * if fema ==1, sep(0)
 

*data for analysis
local varKeep "id sequence session rsos grip age matu fema vita pact"
keep `varKeep'
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
egen nid = group(id)
drop newSeq newSeq1 newSeq2 newSeq3 id session sequence
order nid seq
sort  nid seq
duplicates report nid seq

xtset nid seq
reg rsos grip matu fema vita pact 
count 
gen Cage = round(age)
tab Cage
replace Cage = 15 if Cage>15
gen drsos = D.rsos
gen dgrip = D.grip
gen dmatu = D.matu
gen lrsos = L.rsos
gen lgrip = L.grip
gen lmatu = L.matu
egen srsos = std(rsos)
egen sgrip = std(grip)
egen smatu = std(matu)
gen grip2 = grip^2
gen mat2 = matu^2
gen male = (fema==0)

la var Cage "Age"
la var rsos "Radial SOS"
la var grip "Grip strength"
la var matu "Maturity offset"
la var fema "Fema"
la var male "Male"
label define gender 0 "Female" 1 "Male" 
label values male gender
order nid seq rsos grip age matu fema male Cage

drop if matu>7
**summary

twoway scatter rsos grip || lfit rsos grip if male==1
twoway scatter rsos matu || lfit rsos matu if male==1
twoway scatter grip matu || lfit grip matu if male==1

reg rsos grip if male==1
reg rsos matu if male==1
reg grip matu if male==1

twoway scatter rsos grip || lfit rsos grip if male==0
twoway scatter rsos matu || lfit rsos matu if male==0
twoway scatter grip matu || lfit grip matu if male==0

reg rsos grip if male==0
reg rsos matu if male==0
reg grip matu if male==0
scat3 grip matu rsos, rot(60) elev(30) 


*commands for est: restore query dir describe replay table stats*/
global y	= "rsos"
global g	= "grip"
global X	= "c.grip#male male"
global Z	= "c.matu#male male"
global RX	= "M1[nid] c.grip#M1S[nid]"
global RM	= "M2[nid]"

set dp period 

*eststo m1: gsem ($y <- $X $RX) ($g <- $Z $RM) 
*est save "$WE/mixedModelT2", replace
eststo m1: est use "$WE/mixedModelT2"
est replay m1, coeflegend
est restore m1
est replay m1

estat recovariance
estat summarize
estat vce, covariance
estat vce, correlation

bys male: sum matu

*gender specific models based on Sept 29 meeting with B and N
gsem ($y <- $X $RX) ($g <- $Z $RM) 
gsem ($y <- grip matu $RX) ($g <- matu $RM) 

bys male: sum matu 
eststo m_all: gsem ($y <- grip  $RX) ($g <- matu $RM) 
est save "$WE/mixedModel_all", replace
eststo m_male: gsem ($y <- grip  $RX) ($g <- matu $RM)  if male==1 
est save "$WE/mixedModel_male", replace
eststo m_fema: gsem ($y <- grip  $RX) ($g <- matu $RM)  if male==0
est save "$WE/mixedModel_female", replace


estout m_all m_male m_fema using "$WT/mixedResults_sexMar2016.csv", ///
cells(b se) replace 


avplot grip

reg rsos grip matu
avplot grip 
avplot matu

reg grip matu
avplot matu
scat3 grip matu rsos, rot(60) elev(30) 
 
scatter rsos grip || lfit rsos matu
scatter grip matu




xtsum rsos grip age matu fema Cage
bys seq: sum rsos grip age

sum matu, detail
capture gen cmat = round(matu)
capture replace cmat = -4 if cmat<-4
replace cmat = 4  if cmat> 4

*table:  Summary stats by measurement occasion
tabout seq using "$WT/table1a.txt", replace f(2) sum style(tex) ///
c(N rsos mean rsos sd rsos mean grip sd grip mean matu sd matu) 

tabout seq using "$WT/table1_all.csv", replace f(2) sum style(csv) ///
c(N rsos mean rsos sd rsos mean grip sd grip mean matu sd matu) 

tabout seq using "$WT/table1_all.csv" if fema==0, append f(2) sum style(csv) ///
c(N rsos mean rsos sd rsos mean grip sd grip mean matu sd matu) 

tabout seq using "$WT/table1_all.csv" if fema==1, append f(2) sum style(csv) ///
c(N rsos mean rsos sd rsos mean grip sd grip mean matu sd matu)

pwcorr rsos grip matu
pwcorr srsos sgrip matu
save "$WD/mslong.dta", replace 

*trends based on averages
collapse (mean) rsos grip srsos sgrip matu, by(cmat)
*Figure 1

*standardized values
graph twoway (line srsos cmat, lpattern("solid") lcolor("black")) ///
(line sgrip cmat, lpattern("dash") lcolor("black")),  ///
ytitle("Standardized values") xtitle("Physical maturity catagory") ylab(-1.5(0.5)1.5) xlab(-4(1)4) ///
legend(order(1 "Radial SOS" 2 "Grip strength") bmargin(zero)) graphregion(color(white)) 

graph export "$WG/fig1_all_standard.pdf", as(pdf) replace
window manage close graph

*real values
graph twoway (line rsos cmat, yaxis(1)  lpattern("solid") lcolor("black")) ///
(line grip cmat, yaxis(2) lpattern("dash") lcolor("black")),  ///
ytitle("Radial SOS", axis(1))  ytitle("Grip strength", axis(2)) ///
ylab(3700(50)4000, axis(1)) ylab(10(5)40, axis(2))  ///
xtitle("Physical maturity catagory") xlab(-4(1)4) ///
legend(order(1 "Radial SOS" 2 "Grip strength") bmargin(zero)) graphregion(color(white)) 

graph export "$WG/fig1_all_real.pdf", as(pdf) replace
window manage close graph

*gender specific plots
use "$WD/mslong.dta", clear
collapse (mean) rsos grip srsos sgrip matu, by(cmat fema) 
*males
*standardized values

graph twoway (line srsos cmat, lpattern("solid") lcolor("black")) ///
(line sgrip cmat, lpattern("dash") lcolor("black")) if fema==0, ///  
ytitle("Standardized values") xtitle("Physical maturity catagory") ylab(-1.5(0.5)1.5) xlab(-4(1)4) ///
legend(order(1 "Radial SOS" 2 "Grip strength") bmargin(zero)) graphregion(color(white)) 

graph export "$WG/fig1_male_standard.pdf", as(pdf) replace
window manage close graph

*real values
graph twoway (line rsos cmat, yaxis(1)  lpattern("solid") lcolor("black")) ///
(line grip cmat, yaxis(2) lpattern("dash") lcolor("black")) if fema==0, /// 
ytitle("Radial SOS", axis(1)) ytitle("Grip strength", axis(2)) ///
ylab(3700(50)4000, axis(1)) ylab(10(5)40, axis(2))  ///
xtitle("Physical maturity catagory") xlab(-4(1)4) ///
legend(order(1 "Radial SOS" 2 "Grip strength") bmargin(zero)) graphregion(color(white)) 

graph export "$WG/fig1_male_real.pdf", as(pdf) replace
window manage close graph

*females
*standardized values
graph twoway (line srsos cmat, lpattern("solid") lcolor("black")) ///
(line sgrip cmat, lpattern("dash") lcolor("black")) if fema==1, /// 
ytitle("Standardized values") xtitle("Physical maturity catagory") ylab(-1.5(0.5)1.5) xlab(-4(1)4) ///
legend(order(1 "Radial SOS" 2 "Grip strength") bmargin(zero)) graphregion(color(white))

graph export "$WG/fig1_female_standard.pdf", as(pdf) replace
window manage close graph

*real values
graph twoway (line rsos cmat, yaxis(1)  lpattern("solid") lcolor("black")) ///
(line grip cmat, yaxis(2) lpattern("dash") lcolor("black")) if fema==1, /// 
ytitle("Radial SOS", axis(1)) ytitle("Grip strength", axis(2)) ///
ylab(3700(50)4000, axis(1)) ylab(10(5)40, axis(2))  ///
xtitle("Physical maturity catagory") xlab(-4(1)4) ///
legend(order(1 "Radial SOS" 2 "Grip strength") bmargin(zero)) graphregion(color(white)) 

graph export "$WG/fig1_female_real.pdf", as(pdf) replace
window manage close graph

**Table. Summary statistics
use "$WD/mslong.dta", clear
tabout Cage using "$WT/table1.tex", replace f(2) sum ///
c(count rsos mean rsos sd grip mean grip sd grip) style(tex) ///
h2(||Radial SOS ||Grip strength|) ///
h3(Age|N |Mean |SD |N |Mean |SD) 

*females
tabout Cage  if fema ==1  using "$WT/table1.tex", append f(2) sum ///
c(count rsos mean rsos sd grip mean grip sd grip) style(tex)
h2(||Radial SOS ||Grip strength|) ///
h3(Age|N |Mean |SD |N |Mean |SD) style(tex)

*males
tabout Cage  if fema ==0  using "$WT/table1.tex", append f(2) sum ///
c(count rsos mean rsos sd grip mean grip sd grip) style(tex) 
///
h2(||Radial SOS ||Grip strength|) ///
h3(Age|N |Mean |SD |N |Mean |SD) style(tex)

use "$WD/mslong.dta", clear
sum *

use "$WD/mslong.dta", clear



/*commands for est: restore query dir describe replay table stats*/
global y	= "rsos"
global g	= "grip"
global X	= "c.grip#male male"
global Z	= "c.matu#male male"
global RX	= "M1[nid] c.grip#M1S[nid]"
global RM	= "M2[nid]"

set dp period 


*eststo m1: gsem ($y <- $X $RX) ($g <- $Z $RM) 
*est save "$WE/mixedModelT2", replace
eststo m1: est use "$WE/mixedModelT2"
est replay m1, coeflegend
est restore m1
est replay m1

estat recovariance
estat summarize
estat vce, covariance
estat vce, correlation

bys male: sum matu

*gender specific models based on Sept 29 meeting with B and N
gsem ($y <- $X $RX) ($g <- $Z $RM) 
gsem ($y <- grip matu $RX) ($g <- matu $RM) 

bys male: sum matu 
eststo m_all: gsem ($y <- grip  $RX) ($g <- matu $RM) 
est save "$WE/mixedModel_all", replace
eststo m_male: gsem ($y <- grip  $RX) ($g <- matu $RM)  if male==1 & matu<7
est save "$WE/mixedModel_male", replace
eststo m_fema: gsem ($y <- grip  $RX) ($g <- matu $RM)  if male==0 & matu<7
est save "$WE/mixedModel_female", replace

estout m_all m_male m_fema using "$WT/mixedResults_sex.csv", ///
cells(b se) replace 
