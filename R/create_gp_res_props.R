library(tidyverse)
source("filepaths.R")
source("R/functions/calculate_gp_res_props.R")

# get the proportional distributions by LAD of residence for each practice and sex ----
# interpolate values for months without data

gp_res <- lapply(list.files(dirs$gp_res, full.names = TRUE), readRDS)%>%
  bind_rows()

last_res_date <- max(gp_res$extract_date)

sya_yyyy_mm <- substr(list.files(dirs$gp_sya), 1, 7)
sya_dates <- as.Date(paste0(sya_yyyy_mm, "_01"), "%Y_%m_%d")
sel_dates <- sya_dates[sya_dates <= last_res_date]

prop_res <- calculate_gp_res_props(gp_res, sel_dates)

saveRDS(prop_res, fpaths$prop_res)

rm(sya_yyyy_mm, sya_dates, sel_dates, gp_res, prop_res)
