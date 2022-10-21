library(dplyr)
library(readr)
library(tidyr)

clean_gp_res_lsoa_legacy_format <- function(dir_in, lookup_lsoa_lad, e_date) {

  #currently not using the extract date variable in the data as it's somewhat inconsistently formatted
  #TODO add more robust parsing for the date variable and use it directly

  fp_gp_lsoa <- list.files(dir_in, pattern = "lsoa-alt-format-tall|gp-reg-patients-lsoa-alt-tall|lsoa-alt-tall", full.names = TRUE)

  #this lookup is for dealing with inconsistencies in variable naming between files
  name_lookup <- c(`male` = "male_patients",
                   `female` = "female_patients",
                   `male` = "male patients",
                   `female` = "female patients",
                   `LSOA11CD` = "lsoa_code")

  gp_res <- read_csv(fp_gp_lsoa, show_col_types = FALSE)

  names(gp_res) <- tolower(names(gp_res))

  out_df <- gp_res %>%
    rename(any_of(name_lookup)) %>%
    select(practice_code, LSOA11CD, male, female) %>%
    pivot_longer(cols = c("male", "female"), names_to = "sex", values_to = "value") %>%
    left_join(lookup_lsoa_lad, by = "LSOA11CD") %>%
    mutate(extract_date = e_date)

  return(out_df)
}
