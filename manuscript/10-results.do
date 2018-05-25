capture log close
log using "10-results", smcl replace
//_1q
quietly{
cd "C:\Users\kevin\Documents\GitHub\exercise_physiology\manuscript"
estimates use ALL
}
    
    
//_2
display %3.2f _b[r:g]
//_3
display %3.2f _b[r:m]
//_4
display %3.2f _b[g:m]
//_5
display %3.2f _b[r:g]*_b[g:m]
//_6
display %3.2f _b[r:g]
//_7
display %3.2f _b[g:m]
//_8
display %3.2f _b[r:m] + _b[r:g]*_b[g:m]
//_9
display %3.2f _b[r:m]
//_10
display %3.2f _b[r:g]
//_11
display %3.2f _b[g:m]
//_^
log close
