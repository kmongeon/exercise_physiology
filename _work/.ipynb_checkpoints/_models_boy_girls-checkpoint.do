
do _preamble.do

global L "covstruct(_lexogenous, diagonal) nocapslatent latent(P1 P2)"
global C "cov(e.r_boy*e.t_boy) cov(e.g_boy*e.k_boy) cov(e.r_gir*e.t_gir) cov(e.g_gir*e.k_gir) cov(P1[id]*P2[id])"
global O " noempty vsquish nolog nohead"

#delimit ;

eststo M3: gsem 
    (r_boy <- g_boy@B1) (t_boy <- k_boy@B1) (r_boy t_boy <- m@B2 n@B3 q@B4 i@B5  _cons@B6 P1[id]@1)
    (g_boy k_boy <- m@B7 c@B8 p@B9 i@B10 e@B11 _cons@B12 P2[id]@1)
    (r_gir <- g_gir@G1) (t_gir <- k_gir@G1) (r_gir t_gir <- m@G2 n@G3 q@G4 i@G5  _cons@G6 P1[id]@1)
    (g_gir k_gir <- m@G7 c@G8 p@G9 i@G10 e@G11 _cons@G12 P2[id]@1)
    , $L $C $O;
estimates save M3, replace;


eststo M4: gsem 
    (r_boy <- g_boy) (t_boy <- k_boy) (r_boy t_boy <- m n q i P1[id]@1)
    (g_boy k_boy <- m c p i e P2[id]@1)
    (r_gir <- g_gir) (t_gir <- k_gir) (r_gir t_gir <- m n q i P1[id]@1)
    (g_gir k_gir <- m c p i e P2[id]@1)
    , $L $C $O;
estimates save M4, replace ;

#delimit cr
