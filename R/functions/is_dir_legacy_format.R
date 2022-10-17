is_dir_legacy_format <- function(dir_test) {

  is_legacy <- length(list.files(dir_in, pattern = "gp_syoa|gp-reg-patients-prac-sing-year-age")) > 0

  return(is_legacy)
}
