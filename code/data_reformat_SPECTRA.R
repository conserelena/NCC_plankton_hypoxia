# Reformat MEZCAL data in preparation for analyses focusing on only the data 
# within the 100m isobath. 
# Additionally, rename variables + create groupings for additional analyses
# Rewritten February 6, 2025 ---------------------------------------------------

library(dplyr)


# loading data -----------------------------------------------------------------
spectra_2022_data <- list.files("./data/raw/raw_binned_data/SPECTRA/S22",
                                full.names=TRUE)

spectra_2023_data <- list.files(
  "./data/raw/raw_binned_data/SPECTRA/S23/binned_data_DO_fixed/DO_cast_align",
  pattern = ".Rdata", 
  full.names=TRUE)

coord_table <- read.csv("./data/etc/100m_cutoff_transects.csv")

spectra_2022_cutoff_data <- list()
for (fi in spectra_2022_data){
  df <- get(load(fi))
  transect <- as.character(unique(df$Transect_ID))
  if (transect == "NH_inshore"){
    df$Transect_ID <- "NH"
    transect <- "NH"
  }
  lon_cutoff <- coord_table$cutoff_lon[coord_table$Transect_ID == transect]
  df_cutoff <- df %>%
    filter(Longitude > lon_cutoff)
  df_cutoff <- df_cutoff %>%
    select(-any_of(c("GPS.dist.from.start.km", "GPS.BinDist.km",
                   "x", "y", "Sound Velocity", "NA", "height",
                   "horizontal.vel", "Chlorophyll Wavelength","camera",
                   "volume", "vertical.vel", "n", "vel_cms", "duration", 
                   "cast2", "filter_prob_old","Sound.Velocity"))) %>%
    select(-contains("mean"))
  spectra_2022_cutoff_data[[length(spectra_2022_cutoff_data)+1]] <- df_cutoff
}

spectra_2023_cutoff_data <- list()
for (fi in spectra_2023_data){
  df <- get(load(fi))
  transect <- as.character(unique(df$Transect_ID))
  if (length(transect) >0){
    transect <- str_sub(transect[1], 1, 2)
  }
  if (transect == "NH_inshore"){
    df$Transect_ID <- "NH"
    transect <- "NH"
  }
  lon_cutoff <- coord_table$cutoff_lon[coord_table$Transect_ID == transect]
  df_cutoff <- df %>%
    filter(Longitude > lon_cutoff)
  df_cutoff <- df_cutoff %>%
    select(-any_of(c("GPS.dist.from.start.km", "GPS.BinDist.km",
                     "x", "y", "Sound Velocity", "NA", "height",
                     "horizontal.vel", "Chlorophyll Wavelength","camera",
                     "volume", "vertical.vel", "n", "vel_cms", "duration", 
                     "Oxygen", "cast2", "filter_prob_old",
                     "Sound.Velocity", "Longitude_join", "Depth_join"))) %>%
    select(-contains("mean"))
  df_cutoff <- df_cutoff %>%
    rename(Oxygen = oxygen_interp)
  spectra_2023_cutoff_data[[length(spectra_2023_cutoff_data)+1]] <- df_cutoff
}

remove(biophys.9, coord_table, df, df_cutoff, subset_DO,
       fi, lon_cutoff, spectra_2022_data, spectra_2023_data, transect)
