source("R/functions/clean_gp_sya.R")

fpath <- list(
  raw_nhs_month = "data/raw/",
  gp_sya_month = "data/intermediate/gp_sya_month/"
)

stub_gp_sya <- "_gp_sya.rds"

if(!dir.exists(fpath$gp_sya_month)) dir.create(fpath$gp_sya_month, recursive = TRUE)

#run for all folders with dates that don't already have a processed file
fldr_dates <- list.dirs(fpath$raw_nhs_month, full.names = FALSE, recursive = FALSE)
existing_dates <- substr(list.files(fpath$gp_sya_month), 1, 7)
sel_dates <- fldr_dates[!fldr_dates %in% existing_dates]

if(length(sel_dates) == 0) stop("No new SYA files to process")

i <- 1
for(sel_dt in sel_dates){

  message("Processing SYA data for ", sel_dt, " - ", i, " of ", length(sel_dates))

  #currently not using the extract date variable in the data as it's somewhat inconsistently formatted
  #TODO add more robust parsing for the date variable and use it directly
  e_date <- as.Date(paste0(sel_dt, "_01"), "%Y_%m_%d")

  data_sel_dt <- clean_gp_sya(dir_in = paste0(fpath$raw_nhs_month, sel_dt),
                              e_date)

  saveRDS(data_sel_dt,
          paste0(fpath$gp_sya_month, sel_dt, stub_gp_sya))

  i <- i + 1
}

