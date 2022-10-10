source("filepaths.R")
source("R/functions/get_gp_res_inputs.R")

#Run for Jan, April, July, and October folders in dir_inputs -----
#these are currently the only months where residence data is published
fldr_dates <- list.dirs(fpath$raw_nhs_month,
                        full.names = FALSE,
                        recursive = FALSE)

fldr_dates <- fldr_dates[grepl("_01|_04|_07|_10", fldr_dates)]
existing_dates <- substr(list.files(fpath$gp_res_month), 1, 7)
sel_dates <- fldr_dates[!fldr_dates %in% existing_dates]

lookup_lsoa_lad <- readRDS(fpath$lookup_lsoa_lad)


if(length(sel_dates > 0)){

  for(sel_dt in sel_dates){

    #currently not using the extract date variable in the data as it's somewhat inconsistently formatted
    #TODO add more robust parsing for the date variable and use it directly
    e_date <- as.Date(paste0(sel_dt, "_01"), "%Y_%m_%d")

    data_sel_dt <- get_gp_res_inputs(dir_in = paste0(fpath$raw_nhs_month, sel_dt),
                                     lookup_lsoa_lad,
                                     e_date)

    saveRDS(data_sel_dt,
            paste0(fpath$gp_res_month, sel_dt, "_gp_res.rds"))

  }
  rm(data_sel_dt, sel_dt, e_date)
}
rm(fldr_dates, existing_dates, sel_dates)
