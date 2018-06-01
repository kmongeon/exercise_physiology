capture log close
log using "./_tables/table1", smcl replace
//_1q
quietly{
do ./_tables/_make_t1.do
local f %3.2f
}
//_2
display `f' rsos_mea
//_3
display `f' rsos_sdn
//_4
display `f' rsos_sdw
//_5
display `f' rsos_sdb
//_6
display `f' tsos_mea
//_7
display `f' tsos_sdn
//_8
display `f' tsos_sdw
//_9
display `f' tsos_sdb
//_10
display `f' grip_mea
//_11
display `f' grip_sdn
//_12
display `f' grip_sdw
//_13
display `f' grip_sdb
//_14
display `f' biodex_mea
//_15
display `f' biodex_sdn
//_16
display `f' biodex_sdw
//_17
display `f' biodex_sdb
//_18
display `f' ntxc_mea
//_19
display `f' ntxc_sdn
//_20
display `f' ntxc_sdw
//_21
display `f' ntxc_sdb
//_22
display `f' matu_mea
//_23
display `f' matu_sdn
//_24
display `f' matu_sdw
//_25
display `f' matu_sdb
//_26
display `f' calo_mea
//_27
display `f' calo_sdn
//_28
display `f' calo_sdw
//_29
display `f' calo_sdb
//_30
display `f' Godin_PA_mea
//_31
display `f' Godin_PA_sdn
//_32
display `f' Godin_PA_sdw
//_33
display `f' Godin_PA_sdb
//_34
display `f' PAQ_PRVNT_mea
//_35
display `f' PAQ_PRVNT_sdn
//_36
display `f' PAQ_PRVNT_sdw
//_37
display `f' PAQ_PRVNT_sdb
//_38
display `f' BMI_mea
//_39
display `f' BMI_sdn
//_40
display `f' BMI_sdw
//_41
display `f' BMI_sdb
//_42
display `f' Bone_Age_mea
//_43
display `f' Bone_Age_sdn
//_44
display `f' Bone_Age_sdw
//_45
display `f' Bone_Age_sdb
//_^
log close
