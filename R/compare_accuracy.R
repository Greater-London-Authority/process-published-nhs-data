library(tidyverse)
library(gglaplot)
source("filepaths.R")
source("R/functions/add_itl.R")
source("R/functions/add_region.R")
source(fpaths$lookup_script)
source("R/functions/add_ios_to_cornwall.R")

actual_births <- read_csv("data/births/lad_births_cy_2021.csv") %>%
  select(date = year_ending_date, gss_code, value = births) %>%
  mutate(date = as.Date(date, "%d/%m/%Y")) %>%
  filter(grepl("E0", gss_code)) %>%
  mutate(gss_code = recode(gss_code,
                           "E06000052, E06000053" = "E06000052")) %>%
  add_region(lookups$lad_rgn) %>%
  add_itl(lookups$lad_itl) %>%
  select(-gss_name) %>%
  rename(actual = value)

comparison_dates <- unique(actual_births$date)

predicted_births <- readRDS(fpaths$predicted_births) %>%
  filter(date %in% comparison_dates) %>%
  filter(type == "predicted") %>%
  add_ios_to_cornwall()

births_comparison <- actual_births %>%
  left_join(predicted_births, by = c("gss_code", "date")) %>%
  mutate(num_difference = value - actual,
         prop_difference = num_difference/actual,
         abs_difference = abs(prop_difference)) %>%
  mutate(within_range = case_when(
    actual >= ci_lower & actual <= ci_upper ~ "yes",
    TRUE ~ "no"
  )) %>%
  mutate(geography = case_when(
    grepl("E0", gss_code) ~ "Districts",
    grepl("E12", gss_code) ~ "Regions",
    grepl("TL", gss_code) ~ "ITL 2 subregions",
    grepl("E92", gss_code) ~ "National",
    TRUE ~ "NA"
  ))

births_comparison %>%
  filter(geography == "Districts") %>%
  ggplot(aes(x = prop_difference)) +
  theme_gla() +
  geom_histogram(position = "identity", binwidth = 0.01, 
                 alpha = 0.8, fill = "orange") +
  geom_vline(xintercept = 0, linetype = "dotted") +
  scale_x_continuous(labels = scales::label_percent(accuracy = 1), 
                     breaks = seq(-0.14, 0.14, by = 0.04),
                     limits = c(-0.14, 0.14)) 

births_comparison %>%
  filter(geography %in% c("ITL 2 subregions")) %>%
  ggplot(aes(x = prop_difference)) +
  theme_gla() +
  geom_histogram(position = "identity", binwidth = 0.005, 
                 alpha = 0.8, fill = "lightblue") +
  geom_vline(xintercept = 0, linetype = "dotted") +
  scale_x_continuous(labels = scales::label_percent(accuracy = 0.1), 
                     breaks = seq(-0.045, 0.045, by = 0.01),
                     limits = c(-0.04, 0.04))  

births_comparison %>%
  filter(geography %in% c("Regions")) %>%
  ggplot(aes(x = prop_difference)) +
  theme_gla() +
  geom_histogram(position = "identity", binwidth = 0.005, 
                 alpha = 0.8, fill = "pink") +
  geom_vline(xintercept = 0, linetype = "dotted") +
  scale_x_continuous(labels = scales::label_percent(accuracy = 0.01), 
                     breaks = seq(-0.0175, 0.0175, by = 0.005),
                     limits = c(-0.0175, 0.0175))  
