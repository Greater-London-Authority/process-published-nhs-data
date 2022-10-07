library(tidyverse)

aggregate_chg_age_bands <- function(in_df, c_breaks = c(-Inf, 
                                                        1, 5, 10,
                                                        17, 24, 34, 
                                                        49, 64, Inf),
                                    c_labels = c("0 to 1", "2 to 5", "6 to 10",
                                                 "11 to 17", "18 to 24", "25 to 34", 
                                                 "35 to 49", "50 to 64", "65+")){
  
  out_df <- in_df %>%
    mutate(age_band = cut(age,
                          breaks = c_breaks,
                          labels = c_labels)) %>%
    group_by(across(-any_of(c("value", "prev_value", "abs_chg", "age", "lower_age", "upper_age")))) %>%
    summarise(value = sum(value, na.rm = TRUE), 
              prev_value = sum(prev_value, na.rm = TRUE),
              .groups = "drop") %>%
    mutate(abs_chg = value - prev_value)
  
  return(out_df)
}
