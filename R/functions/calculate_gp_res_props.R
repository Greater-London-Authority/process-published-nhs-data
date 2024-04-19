library(dplyr)
library(tidyr)
library(zoo)
# get the proportional distributions by LAD of residence for each practice and sex
# first na.omit is used to remove the patients with missing residence info
# second na.omit is to deal with NaNs where there are no patients of a given sex.
# - listed as 'NO2011' which will have NAs in their LAD fields
# by excluding them here, all patients will get allocated to the LADs of those with residence info

calculate_gp_res_props <- function(gp_res, sel_dates){

  interpolated_gp_res <- gp_res %>%
    complete(nesting(gss_code, gss_name, practice_code, sex), extract_date = sel_dates) %>%
    arrange(extract_date) %>%
    group_by(practice_code, gss_code, gss_name, sex) %>%
    mutate(value = na.approx(value, rule = 2)) %>% # this is the line that does the interpolation
    filter(value > 0,
           extract_date %in% sel_dates) %>%
    data.frame()

  prop_res <- interpolated_gp_res %>%
    na.omit() %>%
    group_by(practice_code, sex, extract_date) %>%
    mutate(total_sex = sum(value)) %>%
    ungroup() %>%
    mutate(prop_res = value/total_sex) %>%
    select(-c(value, total_sex)) %>%
    na.omit()

  return(prop_res)
}


