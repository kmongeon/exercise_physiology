use DM, clear

xtset id trip
global L "rsos  tsos  grip  biodex  ntxc  matu  calo  mvh  Godin_PA  PAQ_PRVNT  BMI  Bone_Age"

foreach var in $L {
    xtsum `var'
    scalar `var'_mea = r(mean)
    scalar `var'_sdn  = r(sd)
    scalar `var'_sdw  = r(sd_w)
    scalar `var'_sdb  = r(sd_b)
    }

ttest rsos = tsos
scalar sos_diff_mu = abs(r(mu_1) - r(mu_2))
scalar sos_diff_pv = r(p)

ttest rsos, by(gender)
scalar rdiff_mu = abs(r(mu_1) - r(mu_2))
scalar rdiff_pv = r(p)

ttest tsos, by(gender)
scalar tdiff_pv = r(p)
scalar tdiff_mu = abs(r(mu_1) - r(mu_2))

