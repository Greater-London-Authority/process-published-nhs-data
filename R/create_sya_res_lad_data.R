source("filepaths.R")

#------------

prop_res <- readRDS(fpaths$prop_res)

sya_dates <- substr(list.files(dirs$gp_sya), 1, 7)

last_prop_res_date <- max(prop_res$extract_date)

#apply LAD residence proportions to SYA data ----
for(sel_dt in sya_dates){
  
  e_date <- as.Date(paste0(sel_dt, "_01"), "%Y_%m_%d")
  filter_date <- min(e_date, last_prop_res_date)
    
  prop_res_dt <- prop_res %>%
    filter(extract_date == filter_date) %>%
    select(-extract_date)
    
  gp_sya_dt <- readRDS(paste0(dirs$gp_sya, sel_dt, "_gp_sya.rds"))
  
  gp_age_res_dt <- gp_sya_dt %>%
    left_join(prop_res_dt, by = c("practice_code", "sex")) %>%
    mutate(value = value * prop_res) %>%
    select(-prop_res) %>%
    filter(value > 0) %>%
    group_by(across(-all_of(c("value", "practice_code")))) %>%
    summarise(value = sum(value), .groups = "drop") 
  
  saveRDS(gp_age_res_dt, paste0(dirs$gp_res_sya, sel_dt, "_gp_res_sya.rds"))
}

