library(tidyverse)
library(readxl)

# https://geoportal.statistics.gov.uk/documents/lower-layer-super-output-area-2011-to-ward-2021-to-lad-2021-lookup-in-england-and-wales-v2/about

fpath <- list(raw_lookup_lsoa_lad = "data/raw/LSOA11_WD21_LAD21_EW_LU_V2.xlsx",
              lookup_lsoa_lad = "data/intermediate/lookup_lsoa_lad.rds")

read_excel(fpath$raw_lookup_lsoa_lad) %>%
  select(LSOA11CD, gss_code = LAD21CD, gss_name = LAD21NM) %>%
  distinct() %>%
  saveRDS(fpath$lookup_lsoa_lad)
