*cd "/mnt/intel1200/projects/git/exercise_physiology/out/"

*import delimited /mnt/intel1200/projects/git/exercise_physiology/out/de.csv, clear case(preserve)

global R "r <- g@k1 m@k2 n@k3 M1[id]@1 _cons@kk"
global T "t <- b@k1 m@k2 n@k3 M1[id]@1 _cons@kk"
global M "g b <- m@k4 c@k5 M2[id]@1 _cons@km"
global C "covstruct(_lexogenous, diagonal) nocapslatent latent(M1 M2) cov(e.r*e.t) cov(e.g*e.b) cov(M1[id]*M2[id]) "
global O "nohead nolog"

global RS "tstat pval ci level(95)"

quietly gsem ($R) ($T) ($M), $C $O
estimates save ALL, replace
estimates store ALL

*regsave using table2, replace addlabel(M, all) tstat pval ci level(95)

quietly gsem ($R) ($T) ($M) if G == "boy", $C $O
estimates save BOYS, replace
estimates store BOYS
*regsave using table2, append addlabel(M, boys) tstat pval ci level(95)

quietly gsem ($R) ($T) ($M) if G == "girl", $C $O
estimates save GIRLS, replace
estimates store GIRLS
*regsave using table2, append addlabel(M, girls) tstat pval ci level(95)

label variable r "Radial SOS"
label variable r "Tibial SOS"
label variable g "Grip strength"
label variable m "Physical maturation"
label variable n "Ntx creatine"
label variable b "Knee extensor"
label variable c "Energy intake"

label variable g "Muscle strength"
label variable r "Bone properties"

esttab ALL BOYS GIRLS, ///
keep(r:g r:m r:n r:_cons g:m g:c g:_cons var(M1[id]):_cons var(M2[id]):_cons cov(M2[id],M1[id]):_cons ) ///
label b(%9.4f) se(%9.4f)  nostar ///
nodepvars nonumbers parentheses noeqlines compress nonotes ///
mtitles("All" "Boys" "Girls") ///
title("Table 2. Estiamtion results") ///
addnotes("Notes: Standard errors in parentheses. All level-1 fixed effects and level-2 random effects were found to be significant at the 0.05 level") ///
coeflabels(var(M1[id]):_cons "Bone equations" var(M2[id]):_cons "Muscle equations" cov(M2[id],M1[id]):_cons "Covariance") ///
varwidth(20) modelwidth(15)
