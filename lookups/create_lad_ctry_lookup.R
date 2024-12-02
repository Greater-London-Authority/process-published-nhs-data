library(tidyverse)

fpath <- list(raw_lookup_lad_ctry = "data/lookups/Local_Authority_District_to_Country_(April_2023)_Lookup_in_the_UK.csv",
              lookup_lad_ctry = "lookups/lookup_lad_ctry.rds")

if(file.exists(fpath$raw_lookup_lad_ctry)) {

  lookup_lad_ctry <- read_csv(fpath$raw_lookup_lad_ctry) %>%
    select(gss_code = LAD23CD, gss_name = LAD23NM, RGNCD = CTRY23CD, RGNNM = CTRY23NM) %>%
    distinct()


  saveRDS(lookup_lad_ctry, fpath$lookup_lad_ctry)

} else {

  warning(fpath$raw_lookup_lad_ctry, " not found. Local Authority to country lookup not created.")

}
