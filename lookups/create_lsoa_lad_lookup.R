library(tidyverse)
library(readxl)

# https://geoportal.statistics.gov.uk/documents/lower-layer-super-output-area-2011-to-ward-2021-to-lad-2021-lookup-in-england-and-wales-v2/about

fpath <- list(raw_lookup_lsoa_lad = "data/lookups/LSOA11_WD21_LAD21_EW_LU_V2.xlsx",
              lookup_lsoa_lad = "data/lookups/lookup_lsoa_lad.rds")

if(file.exists(fpath$raw_lookup_lsoa_lad)) {

  lookup_lsoa_lad <- read_excel(fpath$raw_lookup_lsoa_lad) %>%
    select(LSOA11CD, gss_code = LAD21CD, gss_name = LAD21NM) %>%
    distinct()

  saveRDS(lookup_lsoa_lad, fpath$lookup_lsoa_lad)

} else {

  warning(fpath$raw_lookup_lsoa_lad, " not found. LSOA to Local Authority lookup not created.")

}
