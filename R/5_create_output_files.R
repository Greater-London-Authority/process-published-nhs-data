library(tidyverse)
source("R/functions/add_persons.R")
source("R/functions/aggregate_to_region.R")

fpath <- list(
  processed_data = "data/processed/",
  gp_sya_res_month = "data/intermediate/gp_res_sya/",
  lad_output_rds = "data/processed/gp_sya_lad.rds",
  rgn_output_rds = "data/processed/gp_sya_rgn.rds",
  itl_output_rds = "data/processed/gp_sya_itl.rds",
  lad_output_csv = "data/processed/gp_sya_lad.csv",
  rgn_output_csv = "data/processed/gp_sya_rgn.csv",
  itl_output_csv = "data/processed/gp_sya_itl.csv",
  lookup_lad_rgn = "lookups/lookup_lad_rgn.rds",
  lookup_lad_itl = "lookups/lookup_lad_itl.rds"
)

if(!dir.exists(fpath$processed_data)) dir.create(fpath$processed_data, recursive = TRUE)

gp_sya_res_lad <- lapply(list.files(fpath$gp_sya_res_month, full.names = TRUE), readRDS) %>%
  bind_rows() %>%
  mutate(measure = "gp_count",
         geography = "LAD21") %>%
  filter(grepl("E0", gss_code)) %>%
  add_persons() %>%
  mutate(value = round(value, 1)) %>%
  arrange(gss_code, sex, extract_date, age)

saveRDS(gp_sya_res_lad, fpath$lad_output_rds)
write_csv(gp_sya_res_lad, fpath$lad_output_csv)

# create aggregations for regions and subregions and save as separate files
gp_sya_res_rgn <- aggregate_to_region(gp_sya_res_lad,
                                      readRDS(fpath$lookup_lad_rgn)) %>%
  mutate(geography = "RGN21") %>%
  arrange(gss_code, sex, extract_date, age)

saveRDS(gp_sya_res_rgn, fpath$rgn_output_rds)
write_csv(gp_sya_res_rgn, fpath$rgn_output_csv)


gp_sya_res_itl <- aggregate_to_region(gp_sya_res_lad,
                                      readRDS(fpath$lookup_lad_itl)) %>%
  mutate(geography = "ITL221") %>%
  arrange(gss_code, sex, extract_date, age)

saveRDS(gp_sya_res_itl, fpath$itl_output_rds)
write_csv(gp_sya_res_itl, fpath$itl_output_csv)
