
use DM, clear

set cformat %6.4f
set sformat %4.2f
set pformat %4.2f

global gdate "` c(current_date)'"
global gtime "` c(current_time)'"

display "Date: "$gdate
display "Time: "$gtime


xtset id trip 
rename gender G
rename st_rsos r  
rename st_tsos t 
rename st_grip g 
rename st_biodex k  
rename st_ntxc n 
rename st_matu m  
rename st_calo c  
rename st_mvh v
rename st_Godin_PA p 
rename st_PAQ_PRVNT q
rename st_BMI i
rename st_Bone_Age e

gen r_boy = r if boy==1
gen t_boy = t if boy==1
gen g_boy = g if boy==1
gen k_boy = k if boy==1

gen r_gir = r if boy==0
gen t_gir = t if boy==0
gen g_gir = g if boy==0
gen k_gir = k if boy==0

label variable r "Radial SOS"
label variable t "Tibial SOS"
label variable g "Grip strength"
label variable k "Knee extensor"
label variable n "Ntx creatinine"

label variable m "Physical maturation"
label variable e "Bone age"

label variable i "BMI
label variable c "Energy intake"
label variable p "PA Godin"
label variable q "PA PRVNT"
label variable v "MVH"

label variable r_boy "Boy Radial SOS"
label variable t_boy "Boy Tibial SOS"
label variable g_boy "Boy Grip strength"
label variable k_boy "Boy Knee extensor"

label variable r_gir "Girl Radial SOS"
label variable t_gir "Girl Tibial SOS"
label variable g_gir "Girl Grip strength"
label variable k_gir "Girl Knee extensor"