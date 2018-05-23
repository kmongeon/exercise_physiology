use http://www.stata-press.com/data/r14/pig, clear

mixed weight week || id:

gsem(weight <-  week M1[id]) 

fvset base none id

set seed 14
bayesmh weight week i.id, likelihood(normal({var_0})) noconstant ///
 prior({weight:i.id}, normal({weight:_cons},{var_id})) ///
 prior({weight:_cons}, normal(0, 100)) ///
 prior({weight:week}, normal(0, 100)) ///
 prior({var_0}, igamma(0.001, 0.001)) ///
 prior({var_id}, igamma(0.001, 0.001)) ///
 mcmcsize(5000) dots
 
 bayesstats summary {weight:week _cons} {var_0} {var_id}
 bayesgraph diagnostics {weight:week}
