library(dplyr)
source("R/functions/clean_gp_res_lsoa.R")

fpath <- list(
  raw_nhs_month = "data/raw/",
  gp_lsoa_month = "data/intermediate/gp_lsoa_month/",
  gp_lad_month = "data/intermediate/gp_lad_month/",
  lookup_lsoa_lad = "lookups/lookup_lsoa_lad.rds"
)

stub_gp_lsoa <- "_gp_lsoa.rds"
stub_gp_lad <- "_gp_lad.rds"

lookup_lsoa_lad <- readRDS(fpath$lookup_lsoa_lad)

if(!dir.exists(fpath$gp_lsoa_month)) dir.create(fpath$gp_lsoa_month, recursive = TRUE)
if(!dir.exists(fpath$gp_lad_month)) dir.create(fpath$gp_lad_month, recursive = TRUE)

#Run for Jan, April, July, and October folders in dir_inputs -----
#these are currently the only months where residence data is published
fldr_dates <- list.dirs(fpath$raw_nhs_month,
                        full.names = FALSE,
                        recursive = FALSE)

fldr_dates <- fldr_dates[grepl("_01|_04|_07|_10", fldr_dates)]
existing_dates <- substr(list.files(fpath$gp_lsoa_month), 1, 7)
sel_dates <- fldr_dates[!fldr_dates %in% existing_dates]

if(length(sel_dates) == 0) stop("No new residence files to process")

i <- 1
for(sel_dt in sel_dates){

  message("Processing residence data for ", sel_dt, " - ", i, " of ", length(sel_dates))

  #currently not using the extract date variable in the data as it's somewhat inconsistently formatted
  #TODO add more robust parsing for the date variable and use it directly
  e_date <- as.Date(paste0(sel_dt, "_01"), "%Y_%m_%d")

  data_lsoa <- clean_gp_res_lsoa(dir_in = paste0(fpath$raw_nhs_month, sel_dt),
                                 lookup_lsoa_lad,
                                 e_date)

  data_lad <- data_lsoa %>%
    group_by(across(-any_of(c("value", "LSOA11CD")))) %>%
    summarise(value = sum(value), .groups = "drop")

  saveRDS(data_lsoa,
          paste0(fpath$gp_lsoa_month, sel_dt, stub_gp_lsoa))

  saveRDS(data_lad,
          paste0(fpath$gp_lad_month, sel_dt, stub_gp_lad))

  i <- i + 1
}
