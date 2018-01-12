
ssc install tabout 
ssc install estout
set more off, perm
clear all

cd "~/analysis"
pwd

global dnm = "data/dm.csv"
global dn1 = "data/NegativeIDs.xls"

import excel "$dn1", sheet("Sheet1") firstrow case(lower) clear 
keep if todrop==1
keep id sequence
sort id sequence 
capture save "data/msObsToDrop.dta", replace

import delimited "$dnm", case(lower) clear
sort id sequence 
merge 1:1 id sequence using "data/msObsToDrop.dta"
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
drop if matu>7

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
order nid seq rsos grip age matu fema male Cage

*data out for 3d plot
export delimited using "out/cleandata.csv", replace

*sex distribution. LR test: null is distribuions are the same
tabulate seq fema, chi2 lrchi2 row

*shapiro-wilks: null is distribution is normal
swilk *
by seq, sort : swilk *
*table:  Summary stats by measurement occasion

tabout seq using "out/table1_all.csv", replace f(4) sum style(csv) ///
c(N rsos mean rsos sd rsos mean grip sd grip mean matu sd matu) 

tabout seq using "out/table1_female.csv" if fema==0, append f(4) sum style(csv) ///
c(N rsos mean rsos sd rsos mean grip sd grip mean matu sd matu) 

tabout seq using "out/table1_male.csv" if fema==1, append f(4) sum style(csv) ///
c(N rsos mean rsos sd rsos mean grip sd grip mean matu sd matu)


**summary
twoway scatter rsos grip || lfit rsos grip 
twoway scatter rsos matu || lfit rsos matu 
twoway scatter grip matu || lfit grip matu 

reg rsos grip 
reg rsos matu 
reg grip matu 

twoway scatter rsos grip || lfit rsos grip, ///
ytitle(Radial SOS (units)) xtitle(Grip strength (kilograms)) ///
graphregion(color(white)) legend(off) 
graph export "out/rsos_grip.png", replace
graph close _all

twoway scatter rsos matu || lfit rsos matu, ///
ytitle(Radial SOS (units)) xtitle(Maturity offset) ///
graphregion(color(white)) legend(off) 
graph export "out/rsos_matu.png", replace
graph close _all

twoway scatter grip matu || lfit grip matu, ///
ytitle(Grip strength (kilograms)) xtitle(Maturity offset) ///
graphregion(color(white)) legend(off) 
graph export "out/grip_matu.png", replace
graph close _all


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



twoway scatter rsos grip || lfit rsos grip if male==1, ///
ytitle(Radial SOS (units)) xtitle(Grip strength (kilograms)) ///
graphregion(color(white)) legend(off) 
graph export "out/male_rsos_grip.png", replace
graph close _all

twoway scatter rsos matu || lfit rsos matu if male==1, ///
ytitle(Radial SOS (units)) xtitle(Maturity offset) ///
graphregion(color(white)) legend(off) 
graph export "out/male_rsos_matu.png", replace
graph close _all

twoway scatter grip matu || lfit grip matu if male==1, ///
ytitle(Grip strength (kilograms)) xtitle(Maturity offset) ///
graphregion(color(white)) legend(off) 
graph export "out/male_grip_matu.png", replace
graph close _all

*female
twoway scatter rsos grip || lfit rsos grip if male==0, ///
ytitle(Radial SOS (units)) xtitle(Grip strength (kilograms)) ///
graphregion(color(white)) legend(off) 
graph export "out/fema_rsos_grip.png", replace
graph close _all

twoway scatter rsos matu || lfit rsos matu if male==0, ///
ytitle(Radial SOS (units)) xtitle(Maturity offset) ///
graphregion(color(white)) legend(off) 
graph export "out/fema_rsos_matu.png", replace
graph close _all

twoway scatter grip matu || lfit grip matu if male==0, ///
ytitle(Grip strength (kilograms)) xtitle(Maturity offset) ///
graphregion(color(white)) legend(off) 
graph export "out/fema_grip_matu.png", replace
graph close _all

findit Sobel-Goodman
sgmediation rsos, mv(matu) iv(grip)

foreach var in  mrsos drsos mgrip dgrip mmatu dmatu {
	capture drop `var'
}

sum rsos
gen mrsos = r(mean)
gen drsos = rsos - mrsos

sum grip
gen mgrip = r(mean)
gen dgrip = grip - mgrip

sum matu
gen mmatu = r(mean)
gen dmatu = matu - mmatu

sum drsos dgrip dmatu

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
*eststo m1: est use "$WE/mixedModelT2"
*est replay m1, coeflegend
*est restore m1

*gender specific models based on Sept 29 meeting with B and N
gsem ($y <- $X $RX) ($g <- $Z $RM) 
gsem ($y <- grip matu $RX) ($g <- matu $RM) 

eststo m_all: gsem ($y <- grip  $RX) ($g <- matu $RM) 
est save "out/mixedModel_all", replace
eststo m_male: gsem ($y <- grip  $RX) ($g <- matu $RM)  if male==1
est save "out/mixedModel_male", replace
eststo m_fema: gsem ($y <- grip  $RX) ($g <- matu $RM)  if male==0
est save "out/mixedModel_female", replace

estout m_all m_male m_fema using "out/mixedResults_sex.csv", cells(b se) replace 
esttab m_all m_male m_fema
 
*chow test
gen mgrip = male*grip
gen fgrip = fema*grip
gen mmatu = male*matu
gen fmatu = fema*matu

sem (rsos <- grip grip) (grip <- matu), coefl
test mgrip mmatu

eststo m_all: gsem ($y <- grip  $RX) ($g <- matu $RM) , standardized
eststo m1: gsem (rsos <- grip M1[nid] c.grip#M1S[nid]) (grip <- matu M2[nid]) 
eststo m2: gsem (rsos <- grip M1[nid] c.grip#M1S[nid]) (grip <- matu M2[nid]) , vce(robust)
eststo m3: gsem (rsos <- grip M1[nid] c.grip#M1S[nid]) (grip <- matu M2[nid]) , vce(robust)

esttab m1 m2
ereturn list
estat summarize
estat vce

predict u*
sum u*
margins, dydx(grip)

est replay m_all, coefl
ereturn list

est use out/mixedModel_all
nlcom _b[rsos:c.grip] * _b[grip:matu]

est use out/mixedModel_male
nlcom _b[rsos:c.grip] * _b[grip:matu]

est use out/mixedModel_female
nlcom _b[rsos:c.grip] * _b[grip:matu]

eststo m1: est use out/mixedModel_all
eststo m2: est use out/mixedModel_male
eststo m3: est use out/mixedModel_female

est replay m1
esttab m1 m2 m3 using out/table2.txt, ci(%12.2fc) nostar wide replace nolines nogaps


*mixed model table 2
eststo m1: est use out/mixedModel_all
est replay m1, coeflegend
est restore m1
est replay m1
mata
mata clear
R 	= st_matrix("r(table)")
T1	= R[2,.] * R[8,1]
st_matrix("M1", T1)
mata describe
end
matrix B = e(b)
global cnames : colnames B
matrix colnames M1 = $cnames
matrix rownames M1 = me
estadd matrix M1, replace
ereturn list

esttab m1, ci(%12.2fc) nostar wide ///
drop(var(e.rsos):_cons var(e.grip):_cons rsos:M1[nid] rsos:c.grip#M1S[nid] grip:M2[nid]) ///
varlabels( rsos:_cons "Constant" grip:_cons "Constant" var(M1[nid]):_cons "Radial: var(radial: part)" var(M1S[nid]):_cons "var(radial:grip strength)" var(M2[nid]):_cons "var(grip: part)" cov(M1S[nid],M1[nid]):_cons "cov(radial: part, radial: grip strength)" cov(M2[nid],M1[nid]):_cons "cov(radial: part, grip: part)" cov(M2[nid],M1S[nid]):_cons "cov(radial: grip strength, grip: part)", elist(grip:_cons "\hline")) ///
nolines collabels(none) label replace csv nonotes nonumbers nogaps obslast  ///
stats(N, fmt(a3) labels("Observations")) ///
addnotes("Notes: All estimates are signifigant at the 0.05 level.")

esttab m1 using out/table2.csv, ci(%12.2fc) nostar wide 

///
drop(var(e.rsos):_cons var(e.grip):_cons rsos:M1[nid] rsos:c.grip#M1S[nid] grip:M2[nid]) ///
title("Multilevel mixed mediated regression results of grip strength, physical maturity, and sex on bone health") ///
eqlabels("" "Grip strength equation" "" "" "" "" "" "") ///
varlabels( rsos:_cons "Constant" grip:_cons "Constant" var(M1[nid]):_cons "Radial: var(radial: part)" var(M1S[nid]):_cons "var(radial:grip strength)" var(M2[nid]):_cons "var(grip: part)" cov(M1S[nid],M1[nid]):_cons "cov(radial: part, radial: grip strength)" cov(M2[nid],M1[nid]):_cons "cov(radial: part, grip: part)" cov(M2[nid],M1S[nid]):_cons "cov(radial: grip strength, grip: part)", elist(grip:_cons "\hline")) ///
nolines collabels(none) label replace csv nonotes nonumbers nogaps obslast ///
stats(N, fmt(a3) labels("Observations")) ///
addnotes("Notes: All estimates are signifigant at the 0.05 level.")

esttab m1 , cells(b(fmt(%12.2fc)) & M1(fmt(%12.2fc)))

esttab m1 using "out/mixedResults.csv", ///
cells(b(fmt(%12.2fc)) & M1(fmt(%12.2fc))) incelldelimiter(",") ///
nolines collabels(none) label replace csv nonotes nonumbers nogaps obslast  ///
varlabels( rsos:_cons "Constant" grip:_cons "Constant" var(M1[nid]):_cons "Radial: var(radial: part)" var(M1S[nid]):_cons "var(radial:grip strength)" var(M2[nid]):_cons "var(grip: part)" cov(M1S[nid],M1[nid]):_cons "cov(radial: part, radial: grip strength)" cov(M2[nid],M1[nid]):_cons "cov(radial: part, grip: part)" cov(M2[nid],M1S[nid]):_cons "cov(radial: grip strength, grip: part)", elist(grip:_cons "\hline")) ///
stats(N, fmt(a3) labels("Observations")) ///
addnotes("\specialcell{Notes: All estimates are signifigant at the 0.05 level.}")
///
drop(var(e.rsos):_cons var(e.grip):_cons rsos:M1[nid] rsos:c.grip#M1S[nid] grip:M2[nid]) ///
title("Multilevel mixed mediated regression results of grip strength, physical maturity, and sex on bone health") 
///
eqlabels("" "Grip strength equation" "" "" "" "" "" "") ///
varlabels( rsos:_cons "Constant" grip:_cons "Constant" var(M1[nid]):_cons "Radial: var(radial: part)" var(M1S[nid]):_cons "var(radial:grip strength)" var(M2[nid]):_cons "var(grip: part)" cov(M1S[nid],M1[nid]):_cons "cov(radial: part, radial: grip strength)" cov(M2[nid],M1[nid]):_cons "cov(radial: part, grip: part)" cov(M2[nid],M1S[nid]):_cons "cov(radial: grip strength, grip: part)", elist(grip:_cons "\hline")) ///
nolines collabels(none) label replace booktabs nonotes nonumbers nogaps obslast  ///
stats(N, fmt(a3) labels("Observations")) ///
addnotes("\specialcell{Notes: All estimates are signifigant at the 0.05 level.}")

esttab m1  using "out/mixedResults.csv", ///
cells(b(fmt(%12.2fc)) & M1(fmt(%12.2fc))) incelldelimiter(", ") ///
drop(var(e.rsos):_cons var(e.grip):_cons rsos:M1[nid] rsos:c.grip#M1S[nid] grip:M2[nid]) ///
title("Multilevel mixed mediated regression results of grip strength, physical maturity, and sex on bone health") ///
eqlabels("" "Grip strength equation" "" "" "" "" "" "") ///
varlabels( rsos:_cons "Constant" grip:_cons "Constant" var(M1[nid]):_cons "Radial: var(radial: part)" var(M1S[nid]):_cons "var(radial:grip strength)" var(M2[nid]):_cons "var(grip: part)" cov(M1S[nid],M1[nid]):_cons "cov(radial: part, radial: grip strength)" cov(M2[nid],M1[nid]):_cons "cov(radial: part, grip: part)" cov(M2[nid],M1S[nid]):_cons "cov(radial: grip strength, grip: part)", elist(grip:_cons "\hline")) ///
nolines collabels(none) label replace csv nonotes nonumbers nogaps obslast  ///
stats(N, fmt(a3) labels("Observations")) ///
addnotes("\specialcell{Notes: All estimates are signifigant at the 0.05 level.}")


*mixed model table 2
eststo m1: est use out/mixedModel_male
est replay m1, coeflegend
est restore m1
est replay m1
mata
mata clear
R 	= st_matrix("r(table)")
T1	= R[2,.] * R[8,1]
st_matrix("M1", T1)
mata describe
end
matrix B = e(b)
global cnames : colnames B
matrix colnames M1 = $cnames
matrix rownames M1 = me
estadd matrix M1, replace
ereturn list

esttab m1 , cells(b(fmt(%12.2fc)) & M1(fmt(%12.2fc)))
esttab m1  using "out/mixed_male.csv", ///
cells(b(fmt(%12.2fc)) & M1(fmt(%12.2fc))) incelldelimiter(" $\pm$ ") ///
drop(var(e.rsos):_cons var(e.grip):_cons rsos:M1[nid] rsos:c.grip#M1S[nid] grip:M2[nid]) ///
title("Multilevel mixed mediated regression results of grip strength, physical maturity, and sex on bone health") ///
eqlabels("" "Grip strength equation" "" "" "" "" "" "") ///
varlabels( rsos:_cons "Constant" grip:_cons "Constant" var(M1[nid]):_cons "Radial: var(radial: part)" var(M1S[nid]):_cons "var(radial:grip strength)" var(M2[nid]):_cons "var(grip: part)" cov(M1S[nid],M1[nid]):_cons "cov(radial: part, radial: grip strength)" cov(M2[nid],M1[nid]):_cons "cov(radial: part, grip: part)" cov(M2[nid],M1S[nid]):_cons "cov(radial: grip strength, grip: part)", elist(grip:_cons "\hline")) ///
nolines collabels(none) label replace booktabs nonotes nonumbers nogaps obslast ///
stats(N, fmt(a3) labels("Observations")) ///
addnotes("\specialcell{Notes: All estimates are signifigant at the 0.05 level.}")

* alignment(>{\centering\arraybackslash}m{2.0in})
*mixed model table 2
eststo m1: est use out/mixedModel_female
est replay m1, coeflegend
est restore m1
est replay m1
mata
mata clear
R 	= st_matrix("r(table)")
T1	= R[2,.] * R[8,1]
st_matrix("M1", T1)
mata describe
end
matrix B = e(b)
global cnames : colnames B
matrix colnames M1 = $cnames
matrix rownames M1 = me
estadd matrix M1, replace
ereturn list

esttab m1 , cells(b(fmt(%12.2fc)) & M1(fmt(%12.2fc)))
esttab m1  using "out/mixed_female.csv", ///
cells(b(fmt(%12.2fc)) & M1(fmt(%12.2fc))) incelldelimiter(" $\pm$ ") ///
drop(var(e.rsos):_cons var(e.grip):_cons rsos:M1[nid] rsos:c.grip#M1S[nid] grip:M2[nid]) ///
title("Multilevel mixed mediated regression results of grip strength, physical maturity, and sex on bone health") ///
eqlabels("" "Grip strength equation" "" "" "" "" "" "") ///
varlabels( rsos:_cons "Constant" grip:_cons "Constant" var(M1[nid]):_cons "Radial: var(radial: part)" var(M1S[nid]):_cons "var(radial:grip strength)" var(M2[nid]):_cons "var(grip: part)" cov(M1S[nid],M1[nid]):_cons "cov(radial: part, radial: grip strength)" cov(M2[nid],M1[nid]):_cons "cov(radial: part, grip: part)" cov(M2[nid],M1S[nid]):_cons "cov(radial: grip strength, grip: part)", elist(grip:_cons "\hline")) ///
nolines collabels(none) label replace booktabs nonotes nonumbers nogaps obslast alignment(>{\centering\arraybackslash}m{2.0in}) ///
stats(N, fmt(a3) labels("Observations")) ///
addnotes("\specialcell{Notes: All estimates are signifigant at the 0.05 level.}")
