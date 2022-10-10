dirs <- list(outputs = "outputs/",
             raw = "data/raw/",
             raw_nhs_month = "data/raw/downloaded/",
             raw_lookups = "data/raw/lookups/",
             intermediate = "data/intermediate/",
             gp_sya_month = "data/intermediate/gp_sya/",
             gp_res_month = "data/intermediate/gp_res/",
             processed = "data/processed/",
             gp_sya_month = "data/processed/gp_res_sya/",
             processed_lookups = "data/processed/lookups/")

for(dir_path in dirs){
  if(!dir.exists(dir_path)){
    dir.create(dir_path, recursive = TRUE)
  }
}
