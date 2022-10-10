library(tidyverse)

aggregate_to_region <- function(in_df, lookup) {

  out_df <- in_df %>%
    left_join(lookup, by = NULL) %>%
    group_by(across(-any_of(c("value", "gss_code", "gss_name")))) %>%
    summarise(value = sum(value), .groups = "drop") %>%
    rename(gss_code = RGNCD, gss_name = RGNNM)

  return(out_df)
}
