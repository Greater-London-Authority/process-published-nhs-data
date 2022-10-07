source("filepaths.R")

#fetch input data
source("R/fetch_nhs_files.R")
#Process input data -----
source("R/consolidate_gp_res_data.R")
source("R/consolidate_gp_sya_data.R")

#appoprtion sya data by residence
source("R/create_gp_res_props.R")
source("R/create_sya_res_lad_data.R")

#create output files
source("R/create_output_files.R")

#create sya cohort change data
source("R/create_cohort_change_sya.R")

#create cohort change outputs for aggregated age groups
source("R/aggregate_cohort_change_age_bands.R")
source("R/create_cohort_chg_plots.R")

#predicted births
source("R/estimate_predicted_births.R")
source("R/create_birth_output_files.R")
source("R/create_birth_plots.R")
