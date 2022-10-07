library(tidyverse)
library(lubridate)

gp_sya <- readRDS(fpaths$output_sya_res_data)

dt_first_start <- as.Date("2017-04-01")

gp_chg <- gp_sya %>%
  arrange(date, age) %>%
  filter(date >= dt_first_start) %>%
  mutate(cohort = date - years(age)) %>%
  group_by(across(-any_of(c("date", "value", "age")))) %>%
  mutate(prev_value = lag(value, n = 1L)) %>%
  ungroup() %>%
  na.omit() %>%
  mutate(abs_chg = value - prev_value) %>%
  mutate(age = year(date) - year(cohort)) %>%
  select(-cohort)
  
saveRDS(gp_chg, fpaths$cohort_chg_sya)
