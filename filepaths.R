dirs <- list(outputs = "data/outputs/",
             raw = "data/raw/",
             intermediate = "data/intermediate/",
             processed = "data/processed/",
             plots = "data/outputs/plots/")

fpaths <- list(
  consolidated_lad_res_data = paste0(dirs$processed, "gp_lad_res.rds"),
  prop_res = paste0(dirs$processed, "gp_prop_res.rds"),
  output_sya_res_data = paste0(dirs$gp_counts_outputs, "gp_sya_lad21.rds"),
  ldn_gp_output_rds = paste0(dirs$gp_counts_outputs, "gp_sya_ldn.rds"),
  ldn_gp_output_csv = paste0(dirs$gp_counts_outputs, "gp_sya_ldn.csv"),
  cohort_chg_sya = paste0(dirs$gp_counts_outputs, "cohort_change_sya.rds"),
  cohort_chg_age_bands = paste0(dirs$gp_counts_outputs, "cohort_change_age_bands.rds"),
  lookup_script = "R/get_lookups_2021.R",
  nonstandard_place_names = "R/nonstandard_page_names.R"
  )

