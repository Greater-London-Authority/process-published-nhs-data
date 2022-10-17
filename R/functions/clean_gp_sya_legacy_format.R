library(dplyr)
library(tidyr)
library(readr)
library(stringr)

clean_gp_sya_legacy_format <- function(dir_in, e_date) {

  #currently not using the extract date variable in the data as it's somewhat inconsistently formatted
  #TODO add more robust parsing for the date variable and use it directly

  fp_gp_sya <- list.files(dir_in, pattern = "gp_syoa|gp-reg-patients-prac-sing-year-age", full.names = TRUE)

  #this lookup is for dealing with inconsistencies in variable naming between files
  name_lookup <- c(`Number of Patients` = "NUMBER_OF_PATIENTS",
                   `Number of Patients` = "Number of patients")

  gp_sya <- read_csv(fp_gp_sya, show_col_types = FALSE)

  names(gp_sya) <- tolower(names(gp_sya))

  out_df <- gp_sya %>%
    select(c(contains("practice_code"), contains("male_"))) %>%
    pivot_longer(cols = !"practice_code", names_to = "sex_age", values_to = "value") %>%
    mutate(sex = str_extract(sex_age, "^[a-z]+"),
           max_age = str_extract(sex_age, "[0-9+]+$"),
           max_age = as.integer(str_extract(max_age, "[0-9]+")),
           min_age = as.integer(str_extract(sex_age, "[0-9+]+(?=_)"))) %>%
    mutate(age = pmin(min_age, max_age, na.rm = TRUE)) %>%
    select(-c(sex_age, min_age, max_age)) %>%
    mutate(extract_date = e_date)

  return(out_df)
}
