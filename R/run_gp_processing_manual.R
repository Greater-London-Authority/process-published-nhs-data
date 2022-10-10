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
