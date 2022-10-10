source("filepaths.R")
source("R/functions/get_gp_res_inputs.R")
source(fpaths$lookup_script)

#Run for Jan, April, July, and October folders in dir_inputs -----
#these are currently the only months where residence data is published
fldr_dates <- list.dirs(dirs$inputs,
                        full.names = FALSE,
                        recursive = FALSE)

fldr_dates <- fldr_dates[grepl("_01|_04|_07|_10", fldr_dates)]
existing_dates <- substr(list.files(dirs$gp_res), 1, 7)
sel_dates <- fldr_dates[!fldr_dates %in% existing_dates]

#-------

if(length(sel_dates > 0)){

  for(sel_dt in sel_dates){

    #currently not using the extract date variable in the data as it's somewhat inconsistently formatted
    #TODO add more robust parsing for the date variable and use it directly
    e_date <- as.Date(paste0(sel_dt, "_01"), "%Y_%m_%d")

    data_sel_dt <- get_gp_res_inputs(dir_in = paste0(dirs$inputs, sel_dt),
                                     lookup_lsoa_lad,
                                     e_date)

    saveRDS(data_sel_dt,
            paste0(dirs$gp_res, sel_dt, "_gp_res.rds"))

  }
  rm(data_sel_dt, lookups$lsoa_lad, sel_dt, e_date)
}
rm(fldr_dates, existing_dates, sel_dates)
