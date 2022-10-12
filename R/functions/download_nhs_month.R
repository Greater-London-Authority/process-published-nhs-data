library(lubridate)
library(xml2)
library(rvest)
library(stringr)
library(httr)

# download data for specified month from the NHS Digital site

download_nhs_month <- function(dt_yyyy_mm,
                               dir_save,
                               base_url = "https://digital.nhs.uk/data-and-information/publications/statistical/patients-registered-at-a-gp-practice/",
                               link_pattern = "gp-reg-pat-prac-sing-age-female|gp-reg-pat-prac-sing-age-male|gp-reg-pat-prac-lsoa-male|gp-reg-pat-prac-lsoa-female|gp-reg-pat-prac-lsoa-all-females-males",
                               pg_nm_replace = c("<expected page name>" = "<actual page name>")){

  # data for most months is published on pages that have a simple naming convention
  # e.g. "<base_url>/april-2018"

  mnth <- tolower(month.name[as.integer(substr(dt_yyyy_mm, 6, 7))])
  yr <- substr(dt_yyyy_mm, 1, 4)

  pg_nm <- paste0(mnth, "-", yr)

  # pages for some months have non-standard names

  if(pg_nm %in% names(pg_nm_replace)) pg_nm <- pg_nm_replace[pg_nm]

  url <- paste0(base_url, pg_nm)

  status <- httr::HEAD(url)$all_headers[[1]]$status

  if(status == 200){

    pg <- read_html(url)

    links <- html_attr(html_nodes(pg, "a"), "href")

    sya_links <- links[grepl(link_pattern, links)]

    if(length(sya_links) > 0) {

      if(!dir.exists(dir_save)){dir.create(dir_save)}

      fp_destfiles <- file.path(paste0(dir_save, basename(sya_links)))

      for(i in 1:length(sya_links)){
        message(paste("Writing file: ", fp_destfiles[i]))
        download.file(sya_links[i], destfile = fp_destfiles[i], mode = "wb")
      }
    }
  }
}
