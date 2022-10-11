source("filepaths.R")
source("R/functions/download_nhs_month.R")
source("R/functions/extract_delete_zips.R")

if(!dir.exists(fpath$raw_nhs_month)) dir.create(fpath$raw_nhs_month, recursive = TRUE)

# fetch data for any months in the specified period that hasn't already been downloaded

dt_start <- as.Date("2015-01-01")
dt_end <- Sys.Date()

# sel_dates is a vector of all months between dt_start and dt_end for which folders don't exist
# these months are in the format YYYY_MM
all_dates <- format(seq(dt_start, dt_end, by = "month"), "%Y_%m")
fldr_dates <- list.dirs(fpath$raw_nhs_month, full.names = FALSE, recursive = FALSE)
sel_dates <- all_dates[!all_dates %in% fldr_dates]

for(sel_dt in sel_dates){

  dir_save <- paste0(fpath$raw_nhs_month, sel_dt, "/")

  download_nhs_month(sel_dt, dir_save)
  extract_delete_zips(sel_dt, dir_save)

}
