library(tidyverse)

source("filepaths.R")
source(fpaths$lookup_script)
source("R/functions/add_region.R")
source("R/functions/add_itl.R")
source("R/functions/add_persons.R")

gp_sya_res_all <- lapply(list.files(dirs$gp_res_sya, full.names = TRUE), readRDS) %>%
  bind_rows() %>%
  rename(gss_code = LADCD, gss_name = LADNM, date = extract_date) %>%
  mutate(measure = "gp_count") %>%
  filter(grepl("E0", gss_code)) %>%
  add_region(lookups$lad_rgn) %>%
  add_itl(lookups$lad_itl) %>%
  add_persons()

saveRDS(gp_sya_res_all, fpaths$output_sya_res_data)

ldn_output <- gp_sya_res_all %>%
  filter(grepl("E09|E12000007|E92000001|TLI", gss_code)) %>%
  mutate(value = round(value, 0)) %>%
  arrange(gss_code, desc(sex), date, age) %>%
  select(-measure)

saveRDS(ldn_output, fpaths$ldn_gp_output_rds)

ldn_output_wide <- ldn_output %>%
  pivot_wider(names_from = age, values_from = value)

write_csv(ldn_output_wide, fpaths$ldn_gp_output_csv)       

sya_output_rgns_itl <- gp_sya_res_all %>%
  filter(!grepl("E0", gss_code)) %>%
  select(-c(measure)) %>%
  mutate(value = round(value, 0)) %>%
  pivot_wider(names_from = "date", values_from = "value") %>%
  arrange(gss_code, sex, age)

write_csv(sya_output_rgns_itl, "data/outputs/sya_output_rgns_itl.csv")

sya_output_rgns <- gp_sya_res_all %>%
  filter(!grepl("TL|E0", gss_code)) %>%
  select(-c(measure)) %>%
  mutate(value = round(value, 0)) %>%
  pivot_wider(names_from = "date", values_from = "value") %>%
  arrange(gss_code, sex, age)

write_csv(sya_output_rgns, "data/outputs/sya_output_rgns.csv")
