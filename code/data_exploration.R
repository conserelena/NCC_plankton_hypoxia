source("./code/data_concat.R")
library(tidyverse)

#determine taxa that have lower than 5% occurence 

taxa_names <- colnames(all_ISIIS_data)[19:length(colnames(all_ISIIS_data))]
table_props <- data.frame(taxon = character(), 
                          prop_nonzero = numeric(),
                          stringsAsFactors = FALSE)
table_props <- sapply(taxa_names, function(name){
  taxa_vec <- all_ISIIS_data[[name]]
  non_zero <- sum(taxa_vec >0, na.rm = TRUE)
  prop_nonzero <- non_zero/length(taxa_vec)
  return(c(name, prop_nonzero))
})
table_props <- as.data.frame(t(table_props), stringsAsFactors = FALSE)
colnames(table_props) <- c("class", "proportion_nonzero")
table_props$proportion_nonzero <- as.numeric(table_props$proportion_nonzero)

row.names(table_props) <- NULL

table_props <- table_props[order(table_props$proportion_nonzero),]
write.csv(table_props, 
          file = "./tmp/data_exploration/proportion_taxa_occurence.csv",
          row.names=FALSE)

all_ISIIS_data_long <- all_ISIIS_data %>%
  select(taxa_names, Year, Transect_ID) %>%
  pivot_longer(cols = all_of(taxa_names), names_to = "var", values_to = "abund")

lapply(taxa_names, function(name){
  suppressWarnings({
  g<- ggplot(all_ISIIS_data_long[all_ISIIS_data_long$var == name,], 
             aes(x=log(abund+1))) +
    geom_histogram(binwidth = 0.5, fill = "lightpink", color = "black") +
    facet_grid(Year~Transect_ID) + 
    theme_minimal() +
    labs(x = "Log Bin Abundance", title = paste(name))
  ggsave(plot = g, filename = paste0("./tmp/data_exploration/histograms/", name, 
                                     "_abundance_dist.jpg"),
         width = 6, height =4, dpi = 300)
  })
})

