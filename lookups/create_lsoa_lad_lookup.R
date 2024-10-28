library(tidyverse)
library(readxl)

# https://geoportal.statistics.gov.uk/documents/ff21f0cfbdcc4206906920b3a8858867/about
# https://geoportal.statistics.gov.uk/datasets/9dd1fe173d894b6a838b5ee016d3037e_0/explore

fpath <- list(
  raw_lookup_lsoa21_lad22 = "data/lookups/LSOA_(2021)_to_Built_Up_Area_to_Local_Authority_District_to_Region_(December_2022)_Lookup_in_England_and_Wales_v2.csv",
  raw_lookup_lsoa11_lad22 = "data/lookups/LSOA_(2011)_to_LSOA_(2021)_to_Local_Authority_District_(2022)_Best_Fit_Lookup_for_EW_(V2).csv",
  lookup_lsoa_lad = "lookups/lookup_lsoa_lad.rds")

if(file.exists(fpath$raw_lookup_lsoa11_lsoa21)& file.exists(fpath$raw_lookup_lsoa21_lad22)) {

  lookup_lsoa21_lad22 <- read_csv(fpath$raw_lookup_lsoa21_lad22) %>%
    select(LSOA_CODE = LSOA21CD, gss_code = LAD22CD, gss_name = LAD22NM) %>%
    distinct()

  lookup_lsoa11_lad22 <- read_csv(fpath$raw_lookup_lsoa11_lad22) %>%
    select(LSOA_CODE = LSOA11CD, gss_code = LAD22CD, gss_name = LAD22NM) %>%
    distinct()

  lookup_lsoa_lad <- bind_rows(lookup_lsoa11_lad22, lookup_lsoa21_lad22) %>%
    distinct()

  saveRDS(lookup_lsoa_lad, fpath$lookup_lsoa_lad)

} else {

  warning(fpath$raw_lookup_lsoa_lad, " not found. LSOA to Local Authority lookup not created.")

}
