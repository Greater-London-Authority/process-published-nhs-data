source("filepaths.R")
source("R/functions/get_gp_sya_inputs.R")

#run for all folders with dates that don't already have a processed file
fldr_dates <- list.dirs(dirs$inputs, full.names = FALSE, recursive = FALSE)
existing_dates <- substr(list.files(dirs$gp_sya), 1, 7)
sel_dates <- fldr_dates[!fldr_dates %in% existing_dates]

if(length(sel_dates > 0)){

  for(sel_dt in sel_dates){

    #currently not using the extract date variable in the data as it's somewhat inconsistently formatted
    #TODO add more robust parsing for the date variable and use it directly
    e_date <- as.Date(paste0(sel_dt, "_01"), "%Y_%m_%d")

    data_sel_dt <- get_gp_sya_inputs(dir_in = paste0(dirs$inputs, sel_dt),
                                     e_date)

    saveRDS(data_sel_dt,
            paste0(dirs$gp_sya, sel_dt, "_gp_sya.rds"))
  }
  rm(data_sel_dt, sel_dt, e_date)
}
rm(fldr_dates, existing_dates, sel_dates)
