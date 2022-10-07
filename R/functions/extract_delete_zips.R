

extract_delete_zips <- function(sel_dt, dir_raw){
  
  dir_save <- paste0(dir_raw, sel_dt, "/")
  
  zip_files <- list.files(dir_save, full.names = TRUE, pattern = ".zip")
  
  if(length(zip_files) > 0){
    
    for(zf in zip_files){
      
      unzip(zf, exdir = paste0(dir_save, "."))
      file.remove(zf)
      
    }
    
  }
  
}