source("filepaths.R")
source("R/functions/get_gp_sya_inputs.R")

if(!dir.exists(fpath$gp_sya_month)) dir.create(fpath$gp_sya_month, recursive = TRUE)

#run for all folders with dates that don't already have a processed file
fldr_dates <- list.dirs(fpath$raw_nhs_month, full.names = FALSE, recursive = FALSE)
existing_dates <- substr(list.files(fpath$gp_sya_month), 1, 7)
sel_dates <- fldr_dates[!fldr_dates %in% existing_dates]

if(length(sel_dates > 0)){

  for(sel_dt in sel_dates){

    #currently not using the extract date variable in the data as it's somewhat inconsistently formatted
    #TODO add more robust parsing for the date variable and use it directly
    e_date <- as.Date(paste0(sel_dt, "_01"), "%Y_%m_%d")

    data_sel_dt <- get_gp_sya_inputs(dir_in = paste0(fpath$raw_nhs_month, sel_dt),
                                     e_date)

    saveRDS(data_sel_dt,
            paste0(fpath$gp_sya_month, sel_dt, "_gp_sya.rds"))
  }
}
