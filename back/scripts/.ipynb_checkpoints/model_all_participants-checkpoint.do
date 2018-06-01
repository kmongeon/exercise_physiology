
do ./scripts/_preamble.do

global L "covstruct(_lexogenous, diagonal) nocapslatent latent(P1 P2)"
global C "cov(e.r*e.t) cov(e.g*e.k) cov(P1[id]*P2[id])"
global O " noempty vsquish nolog nohead"

#delimit ;

eststo M1:  gsem 
    (r <- g@R1) (t <- k@R1) (r t <- m@R2 n@R3 q@R4 i@R5 _cons@R6 P1[id]@1)
    (g k <- m@R7 c@R8 p@R9 i@R10 e@R11 _cons@R12 P2[id]@1)
    , $L $C $O;
estimates save M1, replace;


eststo M2: gsem 
    (r <- g) (t <- k) (r t <- m n q i P1[id]@1)
    (g k <- m c p i e P2[id]@1)
    , $L $C $O;
estimates save M2, replace;

#delimit cr
