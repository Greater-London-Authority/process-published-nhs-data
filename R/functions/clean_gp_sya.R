library(dplyr)
library(readr)

clean_gp_sya <- function(dir_in,
                         e_date) {

  #currently not using the extract date variable in the data as it's somewhat inconsistently formatted
  #TODO add more robust parsing for the date variable and use it directly

  fp_gp_sya_male <- list.files(dir_in, pattern = "gp-reg-pat-prac-sing-age-male", full.names = TRUE)
  fp_gp_sya_female <- list.files(dir_in, pattern = "gp-reg-pat-prac-sing-age-female", full.names = TRUE)

  #this lookup is for dealing with inconsistencies in variable naming between files
  name_lookup <- c(`Number of Patients` = "NUMBER_OF_PATIENTS",
                   `Number of Patients` = "Number of patients")

  gp_sya <- bind_rows(read_csv(fp_gp_sya_female, show_col_types = FALSE),
                      read_csv(fp_gp_sya_male, show_col_types = FALSE)
  ) %>%
    rename(any_of(name_lookup)) %>%
    select(practice_code = ORG_CODE,
           sex = SEX,
           age = AGE,
           value = `Number of Patients`) %>%
    filter(age != "ALL") %>%
    mutate(sex = tolower(sex)) %>%
    mutate(age = recode(age,
                        "95+" = "95")) %>%
    mutate(age = as.numeric(age)) %>%
    group_by(practice_code, sex, age) %>%
    summarise(value = sum(value), .groups = "drop") %>%
    mutate(extract_date = e_date)

  return(gp_sya)
}
