source("R/functions/plot_cohort_chg.R")

cohort_chg <- readRDS(fpaths$cohort_chg_age_bands)

for(sel_cd in unique(cohort_chg$gss_code)) {
  
  plt_cd <- plot_cohort_chg(sel_code = sel_cd,
                            in_df = cohort_chg,
                            sel_ages = c("2 to 5", "6 to 10",
                                         "11 to 17", "18 to 24",
                                         "25 to 34", "35 to 49"),
                            dt_start = as.Date("2011-06-30"),
                            d_breaks = "6 months")
  
  ggsave(filename = paste0(dirs$cohort_chg_plots, sel_cd, "_cohort_chg.png"),
         plot = plt_cd, device = "png", height = 4, width = 7)
  
}
