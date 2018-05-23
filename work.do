//OFF
import delimited /mnt/intel1200/projects/git/exercise_physiology/out/de.csv, clear case(preserve)

cd "/mnt/intel1200/projects/git/exercise_physiology/out/"
qui log using eresults, replace smcl

global R "r <- g@k1 m@k2 n@k3 M1[id]@1 _cons@kk"
global T "t <- b@k1 m@k2 n@k3 M1[id]@1 _cons@kk"
global M "g b <- m@k4 c@k5 M2[id]@1 _cons@km"
global C "covstruct(_lexogenous, diagonal) nocapslatent latent(M1 M2) cov(e.r*e.t) cov(e.g*e.b) cov(M1[id]*M2[id]) "
global O "nohead nolog"

global RS "tstat pval ci level(95)"

 gsem ($R) ($T) ($M), $C $O

quietly gsem ($R) ($T) ($M), $C $O
estimates store ALL
regsave using out/table2, replace addlabel(M, all) tstat pval ci level(95)

quietly gsem ($R) ($T) ($M) if G == "boy", $C $O
estimates store BOYS
regsave using out/table2, append addlabel(M, boys) tstat pval ci level(95)

quietly gsem ($R) ($T) ($M) if G == "girl", $C $O
estimates store GIRLS
regsave using out/table2, append addlabel(M, girls) tstat pval ci level(95)

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

The estimation results are summarized in Table 2. All level-1 fixed effects and level-2 random effects were found to be significant at the 0.01 level. To facilitate straightforward comparison of the causal effects, all variables were transformed/standardized to a mean of zero and standard deviation of one. Conclusions based on non-standardized values support identical inferences.

The results are consistent with the relationships postulated by the functional model of bone development. Physical maturity and nutrition influence muscle strength, which in-turn, along osteoclast activity, and physical maturity influences bone properties. Although physical maturation has both direct and indirect impacts bone properties, physical maturation and muscle strength had similar total impact. In terms of standard unit changes, the direct impact of muscle strength and
physical maturation on bone properties was {rg} and {rm}. However, physical maturation also influenced bone properties through its impact on muscle strength. The unit impact of physical maturation on grip strength was {gm}. Therefore. the indirect impact of physical maturation on bone properties was {irm}, resulting in a total impact of {trm}.

Osteoclast activity had a similar effect in boys and girls ({bn} and {gn}). The impact of physical maturation on muscle strength was {DMM} points greater for boys than girls, albeit the difference is not significant.

qui log close

markdoc eresults, replace export(md) 




*estimates table ALL BOYS GIRLS, star(.10 .05 .01) b(%8.2f)
*use out/table2, clear
*sort M

*gsem ($R) ($T) ($M), $C $O coeflegend
*test [BOYS]_b[r:g]==[GIRLS]_b[r:g]
