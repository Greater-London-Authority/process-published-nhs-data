library(tidyverse)
library(readxl)

lookup_lsoa_lad <- read_csv("data/lookups/LSOA11_WD21_LAD21_EW_LU.csv", 
                            show_col_types = FALSE) %>%
  select(LSOA11CD, LADCD = LAD21CD, LADNM = LAD21NM) %>%
  distinct() 

lookup_lad_rgn <- read_csv("data/lookups/Local_Authority_District_to_Region_(April_2021)_Lookup_in_England.csv") %>%
  select(gss_code = LAD21CD, RGNCD = RGN21CD, RGNNM = RGN21NM) %>%
  distinct()

lookup_lad_itl <- read_excel("data/lookups/LAD21_LAU121_ITL321_ITL221_ITL121_UK_LU.xlsx") %>%
  select(gss_code = LAD21CD, ITL221CD, ITL221NM) %>%
  distinct()

lookups <- list(lsoa_lad = lookup_lsoa_lad,
                lad_rgn = lookup_lad_rgn,
                lad_itl = lookup_lad_itl)

rm(lookup_lsoa_lad,
   lookup_lad_rgn,
   lookup_lad_itl)