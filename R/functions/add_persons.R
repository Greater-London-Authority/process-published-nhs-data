library(dplyr)

add_persons <- function(in_df){

  persons_df <- in_df %>%
    group_by(across(-any_of(c("value", "sex")))) %>%
    summarise(value = sum(value), .groups = "drop") %>%
    mutate(sex = "persons")

  out_df <- bind_rows(in_df, persons_df)

  return(out_df)
}
