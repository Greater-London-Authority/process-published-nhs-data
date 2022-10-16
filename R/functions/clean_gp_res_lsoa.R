library(dplyr)
library(readr)

clean_gp_res_lsoa <- function(dir_in,
                              lookup_lsoa_lad,
                              e_date) {

  #currently not using the extract date variable in the data as it's somewhat inconsistently formatted
  #TODO add more robust parsing for the date variable and use it directly

  fp_gp_lsoa_male <- list.files(dir_in, pattern = "gp-reg-pat-prac-lsoa-male", full.names = TRUE)
  fp_gp_lsoa_female <- list.files(dir_in, pattern = "gp-reg-pat-prac-lsoa-female", full.names = TRUE)

  #this lookup is for dealing with inconsistencies in variable naming between files
  name_lookup <- c(`Number of Patients` = "NUMBER_OF_PATIENTS",
                   `Number of Patients` = "Number of patients")

  gp_res <- bind_rows(read_csv(fp_gp_lsoa_female, show_col_types = FALSE),
                      read_csv(fp_gp_lsoa_male, show_col_types = FALSE)) %>%
    rename(any_of(name_lookup)) %>%
    select(practice_code = PRACTICE_CODE,
           LSOA11CD = LSOA_CODE,
           sex = SEX,
           value = `Number of Patients`) %>%
    mutate(sex = tolower(sex)) %>%
    left_join(lookup_lsoa_lad, by = "LSOA11CD") %>%
    mutate(extract_date = e_date)

  return(gp_res)
}
