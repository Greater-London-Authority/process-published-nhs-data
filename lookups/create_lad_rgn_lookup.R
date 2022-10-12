library(tidyverse)

fpath <- list(raw_lookup_lad_rgn = "data/lookups/Local_Authority_District_to_Region_(April_2021)_Lookup_in_England.csv",
              lookup_lad_rgn = "data/lookups/lookup_lad_rgn.rds")

# note: region lookup only covers England
# https://geoportal.statistics.gov.uk/datasets/ons::local-authority-district-to-region-april-2021-lookup-in-england/explore

if(file.exists(fpath$raw_lookup_lad_rgn)) {

lookup_lad_rgn <- read_csv(fpath$raw_lookup_lad_rgn) %>%
  select(gss_code = LAD21CD, gss_name = LAD21NM, RGNCD = RGN21CD, RGNNM = RGN21NM) %>%
  distinct()

saveRDS(lookup_lad_rgn, fpath$lookup_lad_rgn)

} else {

  warning(fpath$raw_lookup_lad_rgn, " not found. Local Authority to region lookup not created.")

}
