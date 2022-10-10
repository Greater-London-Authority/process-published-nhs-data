library(tidyverse)
library(readxl)

fpath <- list(raw_lookup_lad_itl = "data/raw/lookups/LAD21_LAU121_ITL321_ITL221_ITL121_UK_LU.xlsx",
              lookup_lad_itl = "data/processed/lookups/lookup_lad_itl.rds")

# subregions get labelled as regions
# https://geoportal.statistics.gov.uk/datasets/ons::local-authority-district-to-country-april-2021-lookup-in-the-united-kingdom/explore

lookup_lad_itl <- read_excel(fpath$raw_lookup_lad_itl) %>%
  select(gss_code = LAD21CD, gss_name = LAD21NM, RGNCD = ITL221CD, RGNNM = ITL221NM) %>%
  distinct()

saveRDS(lookup_lad_itl, fpath$lookup_lad_itl)
