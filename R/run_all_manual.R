source("R/1_fetch_nhs_files.R")
source("R/2_process_sya_data.R")
source("R/3_process_residence_data.R")
source("R/4_apportion_sya_data_to_lad_residence.R")
source("R/5_create_output_files.R")

# To do the datastore upload run R/6_update_datastore.R
# The file is not sourced here to avoid accidental updates.
