create_missing_folders <- function(dirs_list){
  
  for(dir_path in dirs_list){
    if(!dir.exists(dir_path)){
      dir.create(dir_path, recursive = TRUE)
    }
  }
}
