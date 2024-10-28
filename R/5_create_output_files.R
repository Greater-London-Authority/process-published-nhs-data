library(dplyr)
library(tidyr)
library(readr)
library(gsscoder)
source("R/functions/add_persons.R")
source("R/functions/aggregate_to_region.R")

fpath <- list(
  processed_data = "data/processed/",
  sya_lad_month = "data/intermediate/sya_lad_month/",
  lad_output_rds = "data/processed/gp_sya_lad.rds",
  rgn_output_rds = "data/processed/gp_sya_rgn.rds",
  itl_output_rds = "data/processed/gp_sya_itl.rds",
  ctry_output_rds = "data/processed/gp_sya_ctry.rds",
  lad_output_csv = "data/processed/gp_sya_lad.csv",
  rgn_output_csv = "data/processed/gp_sya_rgn.csv",
  itl_output_csv = "data/processed/gp_sya_itl.csv",
  ctry_output_csv = "data/processed/gp_sya_ctry.csv",
  lookup_lad_rgn = "lookups/lookup_lad_rgn.rds",
  lookup_lad_itl = "lookups/lookup_lad_itl.rds",
  lookup_lad_ctry = "lookups/lookup_lad_ctry.rds"
)

lookup_lad23_names <- readRDS(fpath$lookup_lad_ctry) %>%
  select(gss_code, gss_name)

if(!dir.exists(fpath$processed_data)) dir.create(fpath$processed_data, recursive = TRUE)

gp_sya_res_lad21 <- lapply(list.files(fpath$sya_lad_month, full.names = TRUE), readRDS) %>%
  bind_rows() %>%
  mutate(measure = "gp_count",
         geography = "LAD22") %>%
  filter(grepl("E0", gss_code)) %>%
  add_persons() %>%
  mutate(value = round(value, 1)) %>%
  arrange(gss_code, sex, extract_date, age) %>%
  select(gss_code, gss_name, geography, measure, extract_date, sex, age, everything())

gp_sya_res_lad <- gp_sya_res_lad21 %>%
  select(-c(geography, gss_name)) %>%
  recode_gss(recode_from_year = 2022,
             recode_to_year = 2023) %>%
  left_join(lookup_lad23_names, by = "gss_code") %>%
  mutate(geography = "LAD23")

saveRDS(gp_sya_res_lad, fpath$lad_output_rds)

gp_sya_res_lad_wide <- gp_sya_res_lad %>%
  mutate(value = round(value, 1)) %>%
  pivot_wider(names_from = "age",
              values_from = "value",
              names_prefix = "age_")

write_csv(gp_sya_res_lad_wide, fpath$lad_output_csv)

# create aggregations for regions
gp_sya_res_rgn <- aggregate_to_region(gp_sya_res_lad,
                                      readRDS(fpath$lookup_lad_rgn),
                                      "RGN23") %>%
  arrange(gss_code, sex, extract_date, age)

saveRDS(gp_sya_res_rgn, fpath$rgn_output_rds)

gp_sya_res_rgn_wide <- gp_sya_res_rgn %>%
  mutate(value = round(value, 1)) %>%
  pivot_wider(names_from = "age",
              values_from = "value",
              names_prefix = "age_")

write_csv(gp_sya_res_rgn_wide, fpath$rgn_output_csv)

# create aggregations for ITL2 subregions
gp_sya_res_itl <- aggregate_to_region(gp_sya_res_lad,
                                      readRDS(fpath$lookup_lad_itl),
                                      "ITL221") %>%
  arrange(gss_code, sex, extract_date, age)

saveRDS(gp_sya_res_itl, fpath$itl_output_rds)

gp_sya_res_itl_wide <- gp_sya_res_itl %>%
  mutate(value = round(value, 1)) %>%
  pivot_wider(names_from = "age",
              values_from = "value",
              names_prefix = "age_")

write_csv(gp_sya_res_itl_wide, fpath$itl_output_csv)

# create aggregations for England
gp_sya_res_ctry <- aggregate_to_region(gp_sya_res_lad,
                                       readRDS(fpath$lookup_lad_ctry),
                                       "CTRY23") %>%
  arrange(gss_code, sex, extract_date, age)

saveRDS(gp_sya_res_ctry, fpath$ctry_output_rds)

gp_sya_res_ctry_wide <- gp_sya_res_ctry %>%
  mutate(value = round(value, 1)) %>%
  pivot_wider(names_from = "age",
              values_from = "value",
              names_prefix = "age_")

write_csv(gp_sya_res_ctry_wide, fpath$ctry_output_csv)
