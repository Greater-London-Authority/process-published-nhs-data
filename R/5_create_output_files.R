library(tidyverse)
source("R/functions/add_persons.R")
source("R/functions/aggregate_to_region.R")

fpath <- list(
  processed_data = "data/processed/",
  gp_sya_res_month = "data/intermediate/gp_res_sya/",
  output_gp_sya_lad = "data/processed/gp_sya_lad.rds",
  output_gp_sya_rgn = "data/processed/gp_sya_rgn.rds",
  output_gp_sya_itl = "data/processed/gp_sya_itl.rds",
  lookup_lad_rgn = "lookups/lookup_lad_rgn.rds",
  lookup_lad_itl = "lookups/lookup_lad_itl.rds"
)

if(!dir.exists(fpath$processed_data)) dir.create(fpath$processed_data, recursive = TRUE)

gp_sya_res_lad <- lapply(list.files(fpath$gp_sya_res_month, full.names = TRUE), readRDS) %>%
  bind_rows() %>%
  mutate(measure = "gp_count") %>%
  filter(grepl("E0", gss_code)) %>%
  add_persons() %>%
  arrange(gss_code, sex, extract_date, age)

saveRDS(gp_sya_res_lad, fpath$output_gp_sya_lad)

# create aggregations for regions and subregions and save as separate files
gp_sya_res_rgn <- aggregate_to_region(gp_sya_res_lad,
                                      readRDS(fpath$lookup_lad_rgn)) %>%
  arrange(gss_code, sex, extract_date, age)

saveRDS(gp_sya_res_rgn, fpath$output_gp_sya_rgn)

gp_sya_res_itl <- aggregate_to_region(gp_sya_res_lad,
                                      readRDS(fpath$lookup_lad_itl)) %>%
  arrange(gss_code, sex, extract_date, age)

saveRDS(gp_sya_res_itl, fpath$output_gp_sya_itl)
