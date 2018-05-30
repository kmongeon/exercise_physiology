capture log close
log using "11-results", smcl replace
//_1q
quietly{
cd "C:\Users\kevin\Documents\GitHub\exercise_physiology\manuscript"
estimates use ALL
    
nlcom _b[r:m] + _b[r:g] * _b[g:m] - _b[r:g]
    

}
    
    
//_2
display %3.2f _b[r:g]
//_3
display %3.2f _b[r:m]
//_4
display %3.2f _b[r:g]*_b[g:m]
//_5
display %3.2f _b[r:g]
//_6
display %3.2f _b[g:m]
//_7
display %3.2f _b[r:m] + _b[r:g]*_b[g:m]
//_8
display %3.2f _b[r:m]
//_9
display %3.2f _b[r:g]
//_10
display %3.2f _b[g:m]
//_11
display %3.2f _b[r:m] + _b[r:g] * _b[g:m] - _b[r:g]
//_12
display %3.2f  _b[r:g]*_b[g:c]
//_13q
quietly{
cd "C:\Users\kevin\Documents\GitHub\exercise_physiology\manuscript"
estimates use M2
}

//_14
display %3.2f _b[r:g] - _b[r:b]
//_15
display %3.2f _b[g:m]
//_16
display %3.2f _b[t:m]
//_17
display %3.2f _b[g:m]
//_18
display %3.2f _b[r:g]*_b[g:m]
//_19
display %3.2f _b[r:g]
//_20
display %3.2f _b[g:m]
//_21
display %3.2f _b[r:m] + _b[r:g]*_b[g:m]
//_22
display %3.2f _b[r:m]
//_23
display %3.2f _b[r:g]
//_24
display %3.2f _b[g:m]
//_25
display %3.2f _b[r:m] + _b[r:g] * _b[g:m] - _b[r:g]
//_^
log close
