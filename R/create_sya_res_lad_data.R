library(tidyverse)
source("filepaths.R")
source("R/functions/calculate_gp_res_props.R")

# get the proportional distributions by LAD of residence for each practice and sex ----
# interpolate values for months without data

gp_res <- lapply(list.files(fpath$gp_res_month, full.names = TRUE), readRDS)%>%
  bind_rows()

last_res_date <- max(gp_res$extract_date)

sya_yyyy_mm <- substr(list.files(fpath$gp_sya_month), 1, 7)
sya_dates <- as.Date(paste0(sya_yyyy_mm, "_01"), "%Y_%m_%d")
sel_dates <- sya_dates[sya_dates <= last_res_date]

prop_res <- calculate_gp_res_props(gp_res, sel_dates)

# sya_dates <- substr(list.files(fpath$gp_sya_month), 1, 7)

#apply LAD residence proportions to SYA data ----
for(sel_dt in sya_yyyy_mm){

  e_date <- as.Date(paste0(sel_dt, "_01"), "%Y_%m_%d")
  filter_date <- min(e_date, max(prop_res$extract_date))

  prop_res_dt <- prop_res %>%
    filter(extract_date == filter_date) %>%
    select(-extract_date)

  gp_sya_dt <- readRDS(paste0(fpath$gp_sya_month, sel_dt, "_gp_sya.rds"))

  gp_age_res_dt <- gp_sya_dt %>%
    left_join(prop_res_dt, by = c("practice_code", "sex")) %>%
    mutate(value = value * prop_res) %>%
    select(-prop_res) %>%
    filter(value > 0) %>%
    group_by(across(-all_of(c("value", "practice_code")))) %>%
    summarise(value = sum(value), .groups = "drop")

  saveRDS(gp_age_res_dt, paste0(fpath$gp_sya_res_month, sel_dt, "_gp_res_sya.rds"))
}
