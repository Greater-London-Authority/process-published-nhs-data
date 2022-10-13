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

gp_sya_res_lad_wide <- gp_sya_res_lad %>%
  pivot_wider(names_from = "age",
              values_from = "value",
              names_prefix = "age_")

write_csv(gp_sya_res_lad_wide, fpath$lad_output_csv)

# create aggregations for regions
gp_sya_res_rgn <- aggregate_to_region(gp_sya_res_lad,
                                      readRDS(fpath$lookup_lad_rgn)) %>%
  mutate(geography = "RGN21") %>%
  arrange(gss_code, sex, extract_date, age)

saveRDS(gp_sya_res_rgn, fpath$rgn_output_rds)

gp_sya_res_rgn_wide <- gp_sya_res_rgn %>%
  pivot_wider(names_from = "age",
              values_from = "value",
              names_prefix = "age_")

write_csv(gp_sya_res_rgn_wide, fpath$rgn_output_csv)

# create aggregatations for ITL2 subregions
gp_sya_res_itl <- aggregate_to_region(gp_sya_res_lad,
                                      readRDS(fpath$lookup_lad_itl)) %>%
  mutate(geography = "ITL221") %>%
  arrange(gss_code, sex, extract_date, age)

saveRDS(gp_sya_res_itl, fpath$itl_output_rds)


gp_sya_res_itl_wide <- gp_sya_res_itl %>%
  pivot_wider(names_from = "age",
              values_from = "value",
              names_prefix = "age_")

write_csv(gp_sya_res_itl_wide, fpath$itl_output_csv)
