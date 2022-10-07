source("R/functions/aggregate_chg_age_bands.R")

chg_sya <- readRDS(fpaths$cohort_chg_sya)

chg_age_bands <- aggregate_chg_age_bands(chg_sya,
                                         c_breaks = c(-Inf, 
                                                      1, 5, 10,
                                                      17, 24, 34, 
                                                      49, 64, Inf),
                                         c_labels = c("0 to 1", "2 to 5", "6 to 10",
                                                      "11 to 17", "18 to 24", "25 to 34", 
                                                      "35 to 49", "50 to 64", "65+"))

saveRDS(chg_age_bands, fpaths$cohort_chg_age_bands)

####TODO move all this
chg_age_bands_csv_output <- chg_age_bands %>%
  filter(!grepl("E0", gss_code)) %>%
  mutate(prop_chg = 100 * abs_chg/prev_value) %>%
  select(-measure)

prop_chg_output <- chg_age_bands_csv_output %>%
  select(-c(value, prev_value, abs_chg)) %>%
  pivot_wider(names_from = "date", values_from = "prop_chg")

abs_chg_output <- chg_age_bands_csv_output %>%
  select(-c(value, prev_value, prop_chg)) %>%
  pivot_wider(names_from = "date", values_from = "abs_chg")

write_csv(prop_chg_output, "data/outputs/percentage_chg_cohort_size.csv")
write_csv(abs_chg_output, "data/outputs/absolute_chg_cohort_size.csv")

chg_sel_bands_rgns <- chg_age_bands %>%
  filter(!grepl("E0", gss_code)) %>%
  filter(age_band %in% c("18 to 24", "25 to 34", "35 to 49")) %>%
  mutate(prev_age_band = case_when(
    age_band == "18 to 24" ~ "17 to 23",
    age_band == "25 to 34" ~ "24 to 33",
    age_band == "35 to 49" ~ "34 to 48",
    TRUE ~ "error"
  )) %>%
  mutate(prop_chg = round(abs_chg/prev_value, 4),
         value = round(value, 0),
         prev_value = round(prev_value, 0),
         abs_chg = round(abs_chg, 0)) %>%
  select(gss_code, gss_name, sex, date, age_band, prev_age_band, value, prev_value, abs_chg, prop_chg) %>%
  arrange(gss_code, sex, age_band, date)

write_csv(chg_sel_bands_rgns, "data/outputs/chg_select_age_bands_rgn_itl.csv")
