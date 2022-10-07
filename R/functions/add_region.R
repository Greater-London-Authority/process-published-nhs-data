library(tidyverse)

add_region <- function(in_df, lookup_lad_rgn){

  rgn_df <- in_df %>%
    left_join(lookup_lad_rgn, by = NULL) %>%
    group_by(across(-any_of(c("value", "gss_code", "gss_name")))) %>%
    summarise(value = sum(value), .groups = "drop") %>%
    rename(gss_code = RGNCD, gss_name = RGNNM) %>%
    na.omit() 
  
  eng_df <- in_df %>%
    filter(grepl("E0", gss_code)) %>%
    group_by(across(-any_of(c("value", "gss_code", "gss_name")))) %>%
    summarise(value = sum(value), .groups = "drop") %>%
    mutate(gss_code = "E92000001", 
           gss_name = "England") %>%
    na.omit() 
  
  roe_df <- in_df %>%
    filter(grepl("E0", gss_code)) %>%
    filter(!grepl("E09", gss_code)) %>%
    group_by(across(-any_of(c("value", "gss_code", "gss_name")))) %>%
    summarise(value = sum(value), .groups = "drop") %>%
    mutate(gss_code = "E9200000X", 
           gss_name = "Rest of England") %>%
    na.omit() 
  
  out_df <- bind_rows(in_df,
                      rgn_df,
                      eng_df,
                      roe_df)
    
  return(out_df)
}
