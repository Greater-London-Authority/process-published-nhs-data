source("filepaths.R")
source("R/functions/download_nhs_month.R")
source("R/functions/extract_delete_zips.R")

dt_start <- as.Date("2015-01-01")
dt_end <- Sys.Date()

all_dates <- format(seq(dt_start, dt_end, by = "month"), "%Y_%m")

fldr_dates <- list.dirs(dirs$inputs, full.names = FALSE, recursive = FALSE)

sel_dates <- all_dates[!all_dates %in% fldr_dates]

for(sel_dt in sel_dates){
  
  download_nhs_month(sel_dt, dirs$inputs)
  extract_delete_zips(sel_dt, dirs$inputs)
  
}
