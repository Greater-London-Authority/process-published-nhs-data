
################################################################################
## WARNING: running this script will update the public facing datastore page. ##
## Have a human check the output data files before running this.              ##
################################################################################

# Project goal - to add the modelled GP counts by sya and LAD data to the London
# Datastore using the London Datastore API

# N.B. A dataset called "Patients registered at a GP practice" has already been set up on the London Datastore

# N.B. This requires you to have previously installed  ldndatar from Github using a Github auth token and saved your
# London Datastore API Key to your .Renviron file as an object called lds_api_key

# 1.0 Install and attach required packages ---------------------------------

# 1.1 Install and load required packages
# install.packages(c("tidyverse", "magrittr", "devtools", "rmarkdown"))
library(tidyverse)
library(magrittr)
library(devtools)
library(ldndatar)
library(rmarkdown)

# 1.2 Turn off scientific notation
options(scipen=999)

# 1.3 Set my_api_key for the London Datastore
my_api_key<-Sys.getenv("lds_api_key")

# 1.4 the slug is the name of the datastore page as given at the end of the page URL
page_slug<-"patients-registered-at-a-gp-practice"

# Section 2 - Add resources to dataset -------------------------------------

# Create list of resources which need to be uploaded and their descriptions
datastore_resources_list<-
  list(gp_sya_lad = "data/processed/gp_sya_lad.csv",
       gp_sya_rgn = "data/processed/gp_sya_rgn.csv",
       gp_sya_ctry = "data/processed/gp_sya_ctry.csv",
       gp_sya_itl = "data/processed/gp_sya_itl.csv",
       gp_sya_lad_rds = "data/processed/gp_sya_lad.rds") %>%
  rev()


datastore_resources_descriptions<-
  list(gp_sya_lad = "Modelled counts of patients registered at a GP practice by single year of age, sex, and 2021 local authority of residence by date of extract",
       gp_sya_rgn = "Modelled counts of patients registered at a GP practice by single year of age, sex, and region of residence by date of extract",
       gp_sya_ctry = "Modelled counts of patients registered at a GP practice by single year of age, sex, and resident in England by date of extract",
       gp_sya_itl = "Modelled counts of patients registered at a GP practice by single year of age, sex, and ITL 2 subregion of residence by date of extract",
       gp_sya_lad_rds = "Modelled counts of patients registered at a GP practice by single year of age, sex, and 2021 local authority of residence by date of extract. This file is saved in the RDS format native to the R programming language and is intended for use as an input to: https://github.com/Greater-London-Authority/nowcast-birth-estimates") %>%
  rev()

# The following algorithm checks if there are any resources associated with this dataset, and uploads all the ones in
# datastore_resources_list if there aren't any.

# If there are already resources associated with the dataset which is being modified then where a new resource has
# the same name as an existing resource it will replace it. Otherwise the new resources will be added alongside those
# that are already there.

if (!"resource_id" %in% colnames(lds_meta_dataset(slug=page_slug, my_api_key))) {

  mapply(function(x, y) lds_add_resource(file_path = x,
                                         description = y,
                                         slug=page_slug,
                                         my_api_key),
         datastore_resources_list,
         datastore_resources_descriptions)

} else {

  datastore_resources_descriptions<-
    bind_rows(datastore_resources_descriptions) %>%
    gather(list_item, description)

  datastore_resources_list<-
    bind_rows(datastore_resources_list) %>%
    gather(list_item, filepath) %>%
    mutate(name = basename(filepath)) %>%
    left_join(datastore_resources_descriptions, by="list_item") %>%
    select(-list_item)

  current_resources_names<-
    select(as_tibble(lds_meta_dataset(slug=page_slug, my_api_key)),
           resource_title,
           resource_id)

  datastore_resources_list<-
    left_join(datastore_resources_list,
              current_resources_names, by=c("name"="resource_title"))

  for (i in 1:nrow(datastore_resources_list)) {

    if (is.na(datastore_resources_list$resource_id[i])) {

      lds_add_resource(
        file_path = datastore_resources_list$filepath[i],
        res_title = datastore_resources_list$name[i],
        description = datastore_resources_list$description[i],
        slug = page_slug,
        my_api_key
      )
    }

    else {

      lds_replace_resource(
        file_path=datastore_resources_list$filepath[i],
        slug=page_slug,
        res_id=datastore_resources_list$resource_id[i],
        res_title=datastore_resources_list$name[i],
        description = datastore_resources_list$description[i],
        api_key=my_api_key
      )
    }
  }
}

# Section 3 - Clear Environment -------------------------------------------

# 3.1
rm(list = ls())
