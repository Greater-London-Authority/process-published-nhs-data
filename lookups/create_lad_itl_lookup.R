library(tidyverse)

fpath <- list(raw_lookup_lad_itl = "data/lookups/Local_Authority_District_(April_2023)_to_LAU1_to_ITL3_to_ITL2_to_ITL1_(January_2021)Lookup.csv",
              lookup_lad_itl = "lookups/lookup_lad_itl.rds")

# note that subregions get labelled as regions here
# https://geoportal.statistics.gov.uk/datasets/ons::local-authority-district-to-country-april-2021-lookup-in-the-united-kingdom/explore

if(file.exists(fpath$raw_lookup_lad_itl)) {

lookup_lad_itl <- read_csv(fpath$raw_lookup_lad_itl) %>%
  select(gss_code = LAD23CD, gss_name = LAD23NM, RGNCD = ITL221CD, RGNNM = ITL221NM) %>%
  distinct()

saveRDS(lookup_lad_itl, fpath$lookup_lad_itl)

} else {

  warning(fpath$raw_lookup_lad_itl, " not found. Local Authority to ITL Subregion lookup not created.")

}
