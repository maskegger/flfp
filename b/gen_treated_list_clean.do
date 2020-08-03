/**********************************/
/* COMBINES KGBV AND NPEGEL LISTS */
/**********************************/

/* open KGBV dataset */
use $ebb/kgbvs_list_clean, clear

/* merge with NPEGEL list */
merge 1:1 pc01_state_id pc01_district_id pc01_block_id using $ebb/npegel_list_clean
drop _merge

/* generate treatment variable */
gen treatment = .
replace treatment = 0 if kgbvs_operational == 0 & npegel == 0
replace treatment = 1 if kgbvs_operational > 0 & npegel == 0
replace treatment = 2 if kgbvs_operational == 0 & npegel == 1
replace treatment = 3 if kgbvs_operational > 0 & npegel == 1

/* label values of treated dummy */
label define treatment_label 0 "No Treatment" 1 "KGBV Only" 2 "NPEGEL Only" 3 "KGBV & NPEGEL"
label values treatment treatment_label

/* label treatment variable */
label var treatment "KGBV/NPEGEL treatment"

/* save dataset */
save $ebb/treated_list_clean, replace
