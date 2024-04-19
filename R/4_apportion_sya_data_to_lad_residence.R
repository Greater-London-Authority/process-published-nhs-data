library(dplyr)
source("R/functions/calculate_gp_res_props.R")

fpath <- list(
  gp_sya_month = "data/intermediate/gp_sya_month/",
  gp_lad_month = "data/intermediate/gp_lad_month/",
  sya_lad_month = "data/intermediate/sya_lad_month/",
  prop_res_lad = "data/intermediate/prop_res_lad.rds"
)

stub_gp_sya <- "_gp_sya.rds"
stub_sya_lad <- "_sya_lad.rds"

if(!dir.exists(fpath$sya_lad_month)) dir.create(fpath$sya_lad_month, recursive = TRUE)

# get the proportional distributions by LAD of residence for each practice and sex ----
# interpolate values for months without data

gp_res_dates <- substr(list.files(fpath$gp_lad_month), 1, 7)
last_res_date <- max(gp_res_dates)

gp_sya_dates <- substr(list.files(fpath$gp_sya_month), 1, 7)
processed_sya_lsoa_dates <- substr(list.files(fpath$sya_lad_month), 1, 7)
new_gp_sya_dates <- gp_sya_dates[!gp_sya_dates %in% processed_sya_lsoa_dates]
new_gp_sya_dates <- new_gp_sya_dates[new_gp_sya_dates <= last_res_date] # works because strings are in yyyy_mm format

sya_yyyy_mm <- new_gp_sya_dates
sel_dates <- as.Date(paste0(new_gp_sya_dates, "_01"), "%Y_%m_%d")

gp_res_files <- list.files(fpath$gp_lad_month, full.names = TRUE)
gp_res <- lapply(gp_res_files, readRDS)%>%
  bind_rows()

message("Calculating residence distributions for GP practices")
# This bit is slow: interpolates the residence counts for the dates that the SYA data is given
# Then calculates proportions for each LSOA
prop_res <- calculate_gp_res_props(gp_res, sel_dates)

if (file.exists(fpath$prop_res_lad)) {
  existing_prop_res <-readRDS(fpath$prop_res_lad)
  new_prop_res_dates <- unique(prop_res$extract_date)
  existing_prop_res <- existing_prop_res %>%
    filter(!extract_date %in% new_prop_res_dates)
  prop_res <- bind_rows(existing_prop_res, prop_res)
}

saveRDS(prop_res, fpath$prop_res_lad)

#apply LAD residence proportions to SYA data
i <- 1
for(sel_dt in sya_yyyy_mm){

  message("Creating SYA by LAD estimate for ", sel_dt, " - ", i, " of ", length(sel_dates))

  e_date <- as.Date(paste0(sel_dt, "_01"), "%Y_%m_%d")
  filter_date <- min(e_date, max(prop_res$extract_date))

  # get the residence proportions for that extract date
  prop_res_dt <- prop_res %>%
    filter(extract_date == filter_date) %>%
    select(-extract_date)

  # read in SYA data for that extract date
  gp_sya_dt <- readRDS(paste0(fpath$gp_sya_month, sel_dt, stub_gp_sya))

  # apply res proportions to the SYA data to get SYA by res
  gp_age_res_dt <- gp_sya_dt %>%
    left_join(prop_res_dt, by = c("practice_code", "sex")) %>%
    mutate(value = value * prop_res) %>%
    select(-prop_res) %>%
    filter(value > 0) %>%
    group_by(across(-all_of(c("value", "practice_code")))) %>%
    summarise(value = sum(value), .groups = "drop")

  # save the data as a single file for that extraction date
  saveRDS(gp_age_res_dt, paste0(fpath$sya_lad_month, sel_dt, stub_sya_lad))

  i <- i + 1
}
