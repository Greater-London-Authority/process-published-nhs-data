library(lubridate)
library(xml2)
library(rvest)
library(stringr)
library(httr)

download_nhs_month <- function(dt_yyyy_mm, 
                               dir_raw, 
                               base_url = "https://digital.nhs.uk/data-and-information/publications/statistical/patients-registered-at-a-gp-practice/",
                               link_pattern = "gp-reg-pat-prac-sing-age-female|gp-reg-pat-prac-sing-age-male|gp-reg-pat-prac-lsoa-male|gp-reg-pat-prac-lsoa-female|gp-reg-pat-prac-lsoa-all-females-males"){
  

  dir_save <- paste0(dir_raw, dt_yyyy_mm, "/")
  
  mnth <- tolower(month.name[as.integer(substr(dt_yyyy_mm, 6, 7))])
  yr <- substr(dt_yyyy_mm, 1, 4)
  
  pg_nm <- paste0(mnth, "-", yr)
  
  #pages for some months have non-standard names
  #TODO find a better way of doing this or at least review where this lookup is stored
  pg_nm_replace <- c("april-2018" = "patients-registered-at-a-gp-practice-april-2018-special-topic---registered-patients-compared-to-the-projected-resident-population-in-england",
                     "october-2017" = "patients-registered-at-a-gp-practice-october-2017-special-topic-practice-list-size-comparison-october-2013-to-october-2017")
  
  if(pg_nm %in% names(pg_nm_replace)){
    
    pg_nm <- pg_nm_replace[pg_nm]
    
  }
  
  url <- paste0(base_url, pg_nm)
  
  status <- httr::HEAD(url)$all_headers[[1]]$status
  
  if(status == 200){
    
    pg <- read_html(url)
    
    links <- html_attr(html_nodes(pg, "a"), "href")
    
    sya_links <- links[grepl(link_pattern, links)]
    
    if(length(sya_links) > 0){
      
      if(!dir.exists(dir_save)){dir.create(dir_save)}
      
      fp_destfiles <- file.path(paste0(dir_save, basename(sya_links)))
      
      for(i in 1:length(sya_links)){
        message(paste("Writing file: ", fp_destfiles[i]))
        download.file(sya_links[i], destfile = fp_destfiles[i], mode = "wb")
      }
    }
  }
}
