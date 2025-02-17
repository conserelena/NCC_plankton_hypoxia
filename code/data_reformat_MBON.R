# Reformat MEZCAL data in preparation for analyses focusing on only the data 
# within the 100m isobath. 
# Additionally, rename variables + create groupings for additional analyses
# Rewritten February 6, 2025 ---------------------------------------------------

library(dplyr)
library(stringr)

#load data ---------------------------------------------------------------------
mbon_2020_data <- list.files(
  "./data/raw/raw_binned_data/MBON/F20/binned_data_with_casts_and_gps/",
                             full.names=TRUE)
mbon_2021_data <- list.files(
  "./data/raw/raw_binned_data/MBON/S21",
                             full.names=TRUE)
# load table with 100m long cutoffs --------------------------------------------
coord_table <- read.csv("./data/etc/100m_cutoff_transects.csv")
mbon_2020_100m_cutoff <- list()

for (fi in mbon_2020_data){
  df <- get(load(fi))
  df$Transect_ID <- str_sub(df$Transect_ID, start=1, end=2)
  if (unique(df$Transect_ID == "HH")){
    df_2 <- df %>%
      filter(Long > -124.346)
    df_3 <- df %>%
      filter(Long > -124.912 & Long < -124.8)
    df_cutoff <- rbind(df_2, df_3)
  } else{
    transect <- unique(df$Transect_ID)
    lon_cutoff <- coord_table$cutoff_lon[coord_table$Transect_ID == transect]
    df_cutoff <- df %>%
      filter(Long > lon_cutoff)
  }
  if (nrow(df_cutoff) == 0){
    next
  }
  df_cutoff <- df_cutoff %>%
    rename(Longitude = Long,
           Latitude = Lat,
           Temperature = Temp)%>%
    select(-any_of(c("volume", "vel_cms", "duration", "vertical.vel",
              "Pitch", "Roll", "Heading", "GPS.dist.from.start.km", 
              "GPS.BinDist.km", "n"))) %>%
    select(-contains("Angle")) %>%
    select(-contains("Velocity")) %>%
    select(-contains("mean")) 
  mbon_2020_100m_cutoff[[length(mbon_2020_100m_cutoff)+1]] <- df_cutoff
}

mbon_2021_100m_cutoff <- list()
for (fi in mbon_2021_data){
  df <- get(load(fi))
  df$Transect_ID <- str_sub(df$Transect_ID, start=1, end=2)
  if (unique(df$Transect_ID == "CC")) {
    next
  }
  if (unique(df$Transect_ID == "HH")){
    df_2 <- df %>%
      filter(Long > -124.346)
    df_3 <- df %>%
      filter(Long > -124.912 & Long < -124.8)
    df_cutoff <- rbind(df_2, df_3)
  } else{
    transect <- unique(df$Transect_ID)
    lon_cutoff <- coord_table$cutoff_lon[coord_table$Transect_ID == transect]
    df_cutoff <- df %>%
      filter(Long > lon_cutoff)
  }
  if (nrow(df_cutoff) == 0){
    next
  }
  df_cutoff <- df_cutoff %>%
    rename(Longitude = Long,
           Latitude = Lat,
           Temperature = Temp)%>%
    select(-any_of(c("volume", "vel_cms", "duration", "vertical.vel",
                     "Pitch", "Roll", "Heading", "GPS.dist.from.start.km",
                     "GPS.BinDist.km", "n"))) %>%
    select(-contains("Angle")) %>%
    select(-contains("Velocity")) %>%
    select(-contains("mean")) 
  mbon_2021_100m_cutoff[[length(mbon_2021_100m_cutoff)+1]] <- df_cutoff
}

remove(biophys.9, coord_table, df, df_2, df_3, df_cutoff,
       fi, lon_cutoff, mbon_2020_data, mbon_2021_data, transect)
