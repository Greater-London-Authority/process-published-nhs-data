source("R/functions/download_nhs_month.R")
source("R/functions/extract_delete_zips.R")

fpath <- list(raw_nhs_month = "data/raw/")

if(!dir.exists(fpath$raw_nhs_month)) dir.create(fpath$raw_nhs_month, recursive = TRUE)

# fetch data for any months in the specified period that hasn't already been downloaded

dt_start <- as.Date("2016-01-01")
dt_end <- Sys.Date()

# pages for months that have non-standard names. required format:
# replacement_page_names <- c("<expected page name>" = "<actual page name>")

replacement_page_names <- c(
  "april-2018" = "patients-registered-at-a-gp-practice-april-2018-special-topic---registered-patients-compared-to-the-projected-resident-population-in-england",
  "october-2017" = "patients-registered-at-a-gp-practice-october-2017-special-topic-practice-list-size-comparison-october-2013-to-october-2017"
)

# sel_dates is a vector of all months between dt_start and dt_end for which folders don't exist
# these months are in the format YYYY_MM
all_dates <- format(seq(dt_start, dt_end, by = "month"), "%Y_%m")
fldr_dates <- list.dirs(fpath$raw_nhs_month, full.names = FALSE, recursive = FALSE)
sel_dates <- all_dates[!all_dates %in% fldr_dates]

for(sel_dt in sel_dates){

  dir_save <- paste0(fpath$raw_nhs_month, sel_dt, "/")

  download_nhs_month(sel_dt,
                     dir_save,
                     base_url = "https://digital.nhs.uk/data-and-information/publications/statistical/patients-registered-at-a-gp-practice/",
                     link_pattern = "gp-reg-pat-prac-sing-age-female|gp-reg-pat-prac-sing-age-male|gp-reg-pat-prac-lsoa-male|gp-reg-pat-prac-lsoa-female|gp-reg-pat-prac-lsoa-all-females-males",
                     pg_nm_replace = replacement_page_names)

  extract_delete_zips(sel_dt, dir_save)

}
