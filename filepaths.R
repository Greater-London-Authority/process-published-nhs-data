source("R/functions/create_missing_folders.R")

dirs <- list(processed = "data/processed_data/",
             outputs = "data/outputs/",
             gp_counts_outputs = "data/outputs/gp_counts/",
             gp_counts_outputs = "data/outputs/cohort_change/",
             inputs = "data/raw_inputs/",
             gp_sya = "data/processed_data/gp_sya/",
             gp_res = "data/processed_data/gp_res/",
             gp_res_sya = "data/processed_data/gp_res_sya/",
             plots = "plots/",
             cohort_chg_plots = "plots/cohort_change/")

create_missing_folders(dirs)
rm(create_missing_folders)

fpaths <- list(
  consolidated_lad_res_data = paste0(dirs$processed, "gp_lad_res.rds"),
  prop_res = paste0(dirs$processed, "gp_prop_res.rds"),
  output_sya_res_data = paste0(dirs$gp_counts_outputs, "gp_sya_lad21.rds"),
  ldn_gp_output_rds = paste0(dirs$gp_counts_outputs, "gp_sya_ldn.rds"),
  ldn_gp_output_csv = paste0(dirs$gp_counts_outputs, "gp_sya_ldn.csv"),
  cohort_chg_sya = paste0(dirs$gp_counts_outputs, "cohort_change_sya.rds"),
  cohort_chg_age_bands = paste0(dirs$gp_counts_outputs, "cohort_change_age_bands.rds"),
  lookup_script = "R/get_lookups_2021.R"
  )

