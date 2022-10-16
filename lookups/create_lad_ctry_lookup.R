library(tidyverse)

fpath <- list(raw_lookup_lad_ctry = "data/raw/Local_Authority_District_to_Country_(April_2021)_Lookup_in_the_United_Kingdom.csv",
              lookup_lad_ctry = "data/intermediate/lookup_lad_ctry.rds")

# https://geoportal.statistics.gov.uk/datasets/ons::local-authority-district-to-country-april-2021-lookup-in-the-united-kingdom/explore

read_csv(fpath$raw_lookup_lad_ctry) %>%
    select(gss_code = LAD21CD, gss_name = LAD21NM, RGNCD = CTRY21CD, RGNNM = CTRY21NM) %>%
    distinct() %>%
  saveRDS(fpath$lookup_lad_ctry)
