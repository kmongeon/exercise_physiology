clear all
cd "C:\Users\kevin\Documents\GitHub\exercise_physiology\manuscript"
estimates use ALL

nlcom _b[r:m] + _b[r:g] * _b[g:m] - _b[r:g]
return list
