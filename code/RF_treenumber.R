source("./code/data_concat.R")

library(dplyr)
library(caret)
library(gt)
library(iml)

enviro_vars_model <- c("Year", "Oxygen", "Depth", "chl.ug.l", "Temperature", 
                       "Salinity", "Transect_ID", "time_of_day")

taxa_interest <- c("chaetognath", "copepod_calanoid_calanus", "copepod_cyclopoid_oithona", "copepod_cyclopoid_oithona_eggs",
                   "crustacean_euphausiid", "ctenophore_lobate", "fish_clupeiformes", "fish_sebastes", "hydromedusae_narcomedusae_solmaris",
                   "protist_acantharia", "siphonophore_physonect", "tunicate_doliolid", "tunicate_salp")

all_data <- all_data %>%
  filter(Transect != "CM" | Transect != "RR")
set.seed(88)

fit_control <- trainControl(method="oob",
                            verboseIter = TRUE)

num_trees <- c(100, 500, 1000, 1200, 1500, 2000)

for (num in num_trees){
  
}
