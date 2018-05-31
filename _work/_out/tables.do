capture log close
log using "tables", smcl replace
//_1q
quietly sysuse auto, clear
quietly gen gphm = 100/mpg
quietly regress gphm foreign
mat b = e(b)
quietly sum weight
scalar mw = r(mean)
quietly reg gphm weight foreign
scalar dom = _b[_cons] + _b[weight] * mw
local f %6.2f
//_2
display `f' b[1,1]+b[1,2]
//_3
display `f' dom + _b[foreign]
//_4
display `f' b[1,2]
//_5
display `f' dom
//_^
log close
