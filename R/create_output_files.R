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
