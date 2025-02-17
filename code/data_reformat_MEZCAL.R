# Reformat MEZCAL data in preparation for analyses focusing on only the data 
# within the 100m isobath. 
# Additionally, rename variables + create groupings for additionall analyses
# Rewritten February 6, 2025 

library(dplyr)
# load data ---------------------------------------
mezcal_2018_files <- list.files("./data/raw/raw_binned_data/MEZCAL/S18/",
                                full.names = TRUE)
mezcal_2019_files <- list.files("./data/raw/raw_binned_data/MEZCAL/S19/",
                                full.names = TRUE)

# load table with 100m long cutoffs 
coord_table <- read.csv("./data/etc/100m_cutoff_transects.csv")

# MEZCAL only has NH - so the transect key is set to NH

transect <- "NH"
long_100m_cutoff <- coord_table$cutoff_lon[coord_table$Transect_ID == transect]
# removing the areas of the transect where the instrument is unable to get close
# to the seafloor (e.g. bottom depth > 100m) -----------------------------------
mezcal_2018_cutoff <- list()
for (fi in mezcal_2018_files) {
  df <- get(load(fi))
  df_cutoff <- df %>%
    filter(Long > long_100m_cutoff)
  if (nrow(df_cutoff) == 0){
    next
  }
  df_cutoff <- df_cutoff %>%
    rename(Longitude = Long,
           Latitude = Lat,
           Temperature = Temp)
  df_cutoff$Transect_ID <- "NH"
  df_cutoff <- df_cutoff %>%
    select(-c("GPS.dist.from.start.km", "GPS.BinDist.km",
              "volume", "vel_cms", "duration", "n", "vertical.vel",
              "Pitch", "Roll", "Heading")) %>%
    select(-contains("Angle")) %>%
    select(-contains("Velocity")) %>%
    select(-contains("mean")) 
  mezcal_2018_cutoff[[length(mezcal_2018_cutoff) + 1]] <- df_cutoff
}

mezcal_2019_cutoff <- list()
for (fi in mezcal_2019_files) {
  df <- get(load(fi))
  df_cutoff <- df %>%
    filter(Long > long_100m_cutoff)
  if (nrow(df_cutoff) == 0){
    next
  }
  df_cutoff <- df_cutoff %>%
    rename(Longitude = Long,
           Latitude = Lat,
           Temperature = Temp)
  df_cutoff$Transect_ID <- "NH"
  df_cutoff <- df_cutoff %>%
    select(-c("GPS.dist.from.start.km", "GPS.BinDist.km",
              "volume", "vel_cms", "duration", "n", "vertical.vel",
              "Pitch", "Roll", "Heading")) %>%
    select(-contains("Angle")) %>%
    select(-contains("Velocity")) %>%
    select(-contains("mean")) 
  mezcal_2019_cutoff[[length(mezcal_2019_cutoff) + 1]] <- df_cutoff
}

remove(biophys.9, coord_table, df, df_cutoff, fi, long_100m_cutoff, 
       mezcal_2018_files, mezcal_2019_files, transect)
