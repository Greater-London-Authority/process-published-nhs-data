library(dplyr)

aggregate_to_region <- function(in_df, lookup, geography_label) {

  out_df <- in_df %>%
    left_join(lookup, by = NULL) %>%
    group_by(across(-any_of(c("value", "gss_code", "gss_name")))) %>%
    summarise(value = sum(value), .groups = "drop") %>%
    rename(gss_code = RGNCD, gss_name = RGNNM) %>%
    mutate(geography = geography_label) %>%
    select(gss_code, gss_name, geography, everything())

  return(out_df)
}
