

clear 
cd "/mnt/intel1200/projects/git/exercise_physiology/out/"
estimates use ALL
estimate store All
estimates use BOYS
estimate store BOYS
estimates use GIRLS
estimate store GIRLS


estimates replay _all

estimates for _all: test [r]g==0

test [BOYS][r][g]==0
