library(tidyverse)
library(readxl)

add_itl <- function(in_df, lookup_lad_itl){
  
  itl_df <- in_df %>%
    filter(grepl("E0", gss_code)) %>%
    left_join(lookup_lad_itl, by = NULL) %>%
    group_by(across(-any_of(c("value", "gss_code", "gss_name")))) %>%
    summarise(value = sum(value), .groups = "drop") %>%
    rename(gss_code = ITL221CD, gss_name = ITL221NM) %>%
    na.omit() 
  
  out_df <- bind_rows(in_df,
                      itl_df)
  
  return(out_df)
}
