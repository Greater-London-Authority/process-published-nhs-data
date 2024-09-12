library(tidyverse)

fpath <- list(raw_lookup_lad_rgn = "data/lookups/Local_Authority_District_to_Region_(December_2023)_Lookup_in_England.csv",
              lookup_lad_rgn = "lookups/lookup_lad_rgn.rds")

# note: region lookup only covers England

if(file.exists(fpath$raw_lookup_lad_rgn)) {

lookup_lad_rgn <- read_csv(fpath$raw_lookup_lad_rgn) %>%
  select(gss_code = LAD23CD, gss_name = LAD23NM, RGNCD = RGN23CD, RGNNM = RGN23NM) %>%
  distinct()

saveRDS(lookup_lad_rgn, fpath$lookup_lad_rgn)

} else {

  warning(fpath$raw_lookup_lad_rgn, " not found. Local Authority to region lookup not created.")

}
