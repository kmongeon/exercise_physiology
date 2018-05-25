
capture log close _all
qui log using example, replace

//OFF
cd "/mnt/intel1200/projects/git/exercise_physiology/out/"
estimates use ALL
estimate store All
estimates use BOYS
estimate store BOYS
estimates use GIRLS
estimate store GIRLS


esttab ALL BOYS GIRLS, ///
keep(r:g r:m r:n r:_cons g:m g:c g:_cons var(M1[id]):_cons var(M2[id]):_cons cov(M2[id],M1[id]):_cons ) ///
label b(%9.4f) se(%9.4f)  nostar ///
nodepvars nonumbers parentheses noeqlines compress nonotes alignment(center) ///
mtitles("All" "Boys" "Girls") ///
title("Table 2. Estiamtion results") ///
addnotes("Notes: Standard errors in parentheses. All level-1 fixed effects and level-2 random effects were found to be significant at the 0.05 level") ///
coeflabels(var(M1[id]):_cons "Bone equations" var(M2[id]):_cons "Muscle equations" cov(M2[id],M1[id]):_cons "Covariance") ///
varwidth(20) modelwidth(15)

//ON

txt ///
The estimation results are summarized in Table 2. All level-1 fixed effects and level-2 random effects were found to be significant at the 0.01 level. To facilitate straightforward comparison of the causal effects, all variables were transformed/standardized to a mean of zero and standard deviation of one. Conclusions based on non-standardized values support identical inferences.

txt ///
The results are consistent with the relationships postulated by the functional model of bone development. Physical maturity and nutrition influence muscle strength, which in-turn, along osteoclast activity, and physical maturity influences bone properties. In SEM terminiology, muscle strength mediates the effect of physical maturation and energy intake on bone properties. Therefore, caloric intake indirectly influenced bone properties and physical maturation both directly and indirectly influenced bone properties. 

txt ///
In terms of bone property impacts, muscle strength and osteoclast activity

qui log close
markdoc eresults, replace export(md)
