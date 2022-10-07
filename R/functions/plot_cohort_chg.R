library(tidyverse)
library(gglaplot)

plot_cohort_chg <- function(sel_code, 
                            in_df, 
                            sel_ages = c("2 to 5", "6 to 10",
                                         "11 to 17", "18 to 24",
                                         "25 to 34", "35 to 49",
                                         "50 to 64", "65+"),
                            dt_start = as.Date("2018-06-30"),
                            d_breaks = "3 months"){
  
  cchg <- in_df %>%
    filter(gss_code == sel_code) %>%
    filter(date >= dt_start) %>%
    filter(age_band %in% sel_ages) %>%
    filter(sex == "persons") %>%
    mutate(prop_chg = abs_chg/prev_value) 
  
  sel_name <- unique(cchg$gss_name)
  
  plt_out <- cchg %>%
    ggplot(aes(x = date, y = prop_chg, colour = age_band)) +
    ggla_line() +
    theme_gla() +
    scale_x_date(date_breaks = d_breaks, date_labels = "%b\n%y") +
    scale_y_continuous(n.breaks = 6, labels = scales::label_percent(accuracy = 1)) +
    labs(title = "Annual change in cohort size on patient register",
         subtitle = sel_name) 
  
  return(plt_out)
}