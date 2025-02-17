# take all input data and concat into one file
library(dplyr)

# loading 100m cutoff data 
source("./code/data_reformat_MEZCAL.R")
source("./code/data_reformat_MBON.R")
source("./code/data_reformat_SPECTRA.R")

# checking 2018 ----------------------------------------------------------------
col_names_list_2018 <- lapply(mezcal_2018_cutoff, names)
differences <- sapply(col_names_list_2018, 
                      function(cols) !setequal(cols, col_names_list_2018[[2]]))
which(differences)
missing_col <- setdiff(col_names_list_2018[[2]], col_names_list_2018[[1]])
df <- mezcal_2018_cutoff[[1]]
df <- df %>%
  mutate(!!missing_col := 0)
df <- df %>%
  select(all_of(col_names_list_2018[[2]]))
mezcal_2018_cutoff[[1]] <- df
missing_col <- setdiff(col_names_list_2018[[2]], col_names_list_2018[[4]])
df <- mezcal_2018_cutoff[[4]]
df <- df %>%
  mutate(!!missing_col := 0)
df <- df %>%
  select(all_of(col_names_list_2018[[2]]))
mezcal_2018_cutoff[[4]] <- df

#checking 2019 -----------------------------------------------------------------
col_names_list_2019 <- lapply(mezcal_2019_cutoff, names)
differences <- sapply(col_names_list_2019, 
                      function(cols) !setequal(cols, col_names_list_2019[[1]]))
which(differences) #no diffs


#checking 2020 -----------------------------------------------------------------
col_names_list_2020 <- lapply(mbon_2020_100m_cutoff, names)
differences <- sapply(col_names_list_2020, 
                      function(cols) !setequal(cols, col_names_list_2020[[1]]))
which(differences) #no diffs

#checking 2021 -----------------------------------------------------------------
col_names_list_2021 <- lapply(mbon_2021_100m_cutoff, names)
differences <- sapply(col_names_list_2021, 
                      function(cols) !setequal(cols, col_names_list_2021[[1]]))
which(differences) #one diff 
missing_col <- setdiff(col_names_list_2021[[3]], col_names_list_2021[[1]])
df <- mbon_2021_100m_cutoff[[3]]
df <- df %>%
  mutate(!!missing_col := 0)
df <- df %>%
  select(all_of(col_names_list_2021[[1]]))
mbon_2021_100m_cutoff[[3]] <- df

# checking 2022 ----------------------------------------------------------------
col_names_list_2022 <- lapply(spectra_2022_cutoff_data, names)
differences <- sapply(col_names_list_2022, 
                      function(cols) !setequal(cols, col_names_list_2022[[1]]))
which(differences) #no diffs 

# checking 2023 ----------------------------------------------------------------
col_names_list_2023 <- lapply(spectra_2023_cutoff_data, names)
differences <- sapply(col_names_list_2023, 
                      function(cols) !setequal(cols, col_names_list_2023[[1]]))
which(differences) #one diff 


# checking between all years ---------------------------------------------------

identical(col_names_list_2018[[1]], col_names_list_2019[[1]]) #TRUE
identical(col_names_list_2019[[1]], col_names_list_2018[[1]]) #TRUE

identical(col_names_list_2018[[1]], col_names_list_2020[[1]]) #FALSE
setdiff(col_names_list_2020[[1]], col_names_list_2018[[1]]) #missing Cruise_Name
for (i in 1:length(mbon_2020_100m_cutoff)){
  fi <- mbon_2020_100m_cutoff[[i]]
  fi$Cruise_Name <- "MBON"
  fi <- fi %>%
    select(all_of(col_names_list_2018[[1]]))
  mbon_2020_100m_cutoff[[i]] <- fi
}
col_names_list_2020 <- lapply(mbon_2020_100m_cutoff, names)
identical(col_names_list_2018[[1]], col_names_list_2020[[1]]) #TRUE NOW

identical(col_names_list_2018[[1]], col_names_list_2021[[1]]) #FALSE
setdiff(col_names_list_2018[[1]], col_names_list_2021[[1]]) #missing 
                                              #hydromedusae_narcomedusae_aegina

for (i in 1:length(mbon_2021_100m_cutoff)){
  fi <- mbon_2021_100m_cutoff[[i]]
  fi$hydromedusae_narcomedusae_aegina <- rep(0, nrow(fi))
  fi <- fi %>%
    select(all_of(col_names_list_2018[[1]]))
  mbon_2021_100m_cutoff[[i]] <- fi
}
col_names_list_2021 <- lapply(mbon_2021_100m_cutoff, names)
identical(col_names_list_2018[[1]], col_names_list_2021[[1]]) #TRUE NOW

identical(col_names_list_2018[[1]], col_names_list_2022[[1]]) #FALSE
setdiff(col_names_list_2022[[1]], col_names_list_2018[[1]]) #missing Cruise_Name
for (i in 1:length(spectra_2022_cutoff_data)){
  fi <- spectra_2022_cutoff_data[[i]]
  fi <- fi %>%
    select(-c("pH", "Conductivity"))
  spectra_2022_cutoff_data[[i]] <- fi
}
col_names_list_2022 <- lapply(spectra_2022_cutoff_data, names)
identical(col_names_list_2018[[1]], col_names_list_2022[[1]]) #TRUE NOW


identical(col_names_list_2018[[1]], col_names_list_2023[[1]]) #FALSE
setdiff(col_names_list_2018[[1]], col_names_list_2023[[1]]) #missing Cruise_Name
for (i in 1:length(spectra_2023_cutoff_data)){
  fi <- spectra_2023_cutoff_data[[i]]
  fi <- fi %>%
    select(-c("pH"))
  fi <- fi %>%
    select(all_of(col_names_list_2018[[1]]))
  spectra_2023_cutoff_data[[i]] <- fi
}

col_names_list_2023 <- lapply(spectra_2023_cutoff_data, names)
identical(col_names_list_2018[[1]], col_names_list_2023[[1]]) #FALSE


rm(list = ls(pattern = "^col_names_list_"))
rm(df, fi, differences, i, missing_col)


all_data <- list(mezcal_2018_cutoff, mezcal_2018_cutoff,
                 mbon_2020_100m_cutoff, mbon_2021_100m_cutoff,
                 spectra_2022_cutoff_data, spectra_2023_cutoff_data)

all_ISIIS_data <- unlist(all_data, recursive = FALSE)

for (i in 1:length(all_ISIIS_data)){
  fi <- all_ISIIS_data[[i]]
  fi$HD_ID <- as.character(fi$HD_ID)
  all_ISIIS_data[[i]] <- fi
}

all_ISIIS_data <- bind_rows(all_ISIIS_data)

remove(fi, i, all_data)
