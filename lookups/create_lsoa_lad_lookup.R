library(tidyverse)
library(readxl)

# https://geoportal.statistics.gov.uk/documents/ff21f0cfbdcc4206906920b3a8858867/about
# https://geoportal.statistics.gov.uk/datasets/9dd1fe173d894b6a838b5ee016d3037e_0/explore

fpath <- list(raw_lookup_lsoa11_lad21 = "data/lookups/LSOA11_WD21_LAD21_EW_LU_V2.xlsx",
              raw_lookup_lsoa11_lsoa21 = "data/lookups/LSOA_(2011)_to_LSOA_(2021)_to_Local_Authority_District_(2022)_Best_Fit_Lookup_for_EW_(V2).csv",
              lookup_lsoa_lad = "lookups/lookup_lsoa_lad.rds")

if(file.exists(fpath$raw_lookup_lsoa11_lad21) & file.exists(fpath$raw_lookup_lsoa11_lsoa21)) {

  lookup_lsoa11_lad21 <- read_excel(fpath$raw_lookup_lsoa11_lad21) %>%
    select(LSOA11CD, gss_code = LAD21CD, gss_name = LAD21NM) %>%
    distinct()

  lookup_lsoa11_lsoa21 <- read_csv(fpath$raw_lookup_lsoa11_lsoa21) %>%
    select(LSOA11CD, LSOA21CD)

  lookup_lsoa_lad <- lookup_lsoa11_lad21 %>%
    left_join(lookup_lsoa11_lsoa21, by = "LSOA11CD") %>%
    pivot_longer(cols = c("LSOA11CD", "LSOA21CD"), names_to = "code", values_to = "LSOA_CODE") %>%
    distinct(gss_code, LSOA_CODE, .keep_all = TRUE) %>%
    select(LSOA_CODE, gss_code, gss_name)

  saveRDS(lookup_lsoa_lad, fpath$lookup_lsoa_lad)

} else {

  warning(fpath$raw_lookup_lsoa_lad, " not found. LSOA to Local Authority lookup not created.")

}
