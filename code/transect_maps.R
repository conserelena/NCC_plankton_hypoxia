library(ggthemes)
library(marmap)
library(tidyverse)
library(rnaturalearth)
library(sf)
library(metR)

transect_table <- data.frame(matrix(nrow=0, ncol=5))

LP_file <- get(load("./data/raw/raw_binned_data/MBON/F20/binned_data_with_GPS/MBONF20_121_binned_conc_w_dist_corrGPS.Rdata"))
transect_table <- rbind(transect_table, 
                        c("LP", min(LP_file$Long), max(LP_file$Long),
                          mean(LP_file$Lat), median(LP_file$Long)))
remove(biophys.9)
SPECTRA_files <- list.files("./data/raw/raw_binned_data/SPECTRA/S22/",
                            full.names=TRUE)
for (fi in SPECTRA_files){
  df <- get(load(fi))
  transect <- as.character(unique(df$Transect_ID))
  transect_table <- rbind(transect_table,
                          c(as.character(unique(df$Transect_ID)),
                            min(df$Longitude), max(df$Longitude), 
                            mean(df$Latitude), median(df$Longitude)))
}
colnames(transect_table) <- c("transect", "start_long", "end_long", "latitude",
                              "label_long")

transect_table <- transect_table %>%
  mutate(start_long = as.numeric(start_long)) %>%
  mutate(end_long = as.numeric(end_long)) %>%
  mutate(latitude = as.numeric(latitude)) %>%
  mutate(label_long = as.numeric(label_long))

transect_table[6,3] <- 	"-124.0785"
transect_table <- transect_table[-7,]

transect_table[3,3] <- "-124.334335689424"
transect_table <- transect_table[-2, ]

country <- ne_countries(scale="medium", returnclass="sf")
states <- ne_states(country = "united states of america", returnclass="sf")

tiff("./tmp/US_with_studyregion.tiff", units="in", height=4, width=5, res=300)
ggplot() +
  geom_sf(data=country)+
  coord_sf(xlim = c(-73,-130), ylim = c(25, 55))+
  geom_rect(aes(xmin=-126.5, xmax=-123.5, ymin=42.5, ymax=48.5), color="red", fill=NA)+
  scale_x_continuous(breaks = seq(-80, -130, -25))+
  theme_bw()
dev.off()

bathy <- getNOAA.bathy(lon1 = -126.5, lon2=-123, lat1=42, 
                       lat2 = 48.75, resolution =1)
bathy.xyz <- as.xyz(bathy)
bathy.xyz <- bathy.xyz[bathy.xyz$V3<=0,]
quartz()

tiff("transect_map.tiff", units="in", width=5, height = 10, res=300)
ggplot()+
  geom_sf(data=states)+
  geom_tile(data=bathy.xyz, aes(x=V1, y=V2, fill=V3))+
  geom_contour(data=bathy.xyz, aes(x=V1, y=V2, z=V3),
               breaks = c(-100,-200,-500,-1000,-2000,-3500), color = "lightgray", size=0.1)+
  geom_contour(data=bathy.xyz, aes(x=V1, y=V2, z=V3),
               breaks=-100, color="red", size=4) +
  geom_sf(data=states) + 
  geom_segment(data=transect_table, aes(x=start_long, y=latitude, xend=end_long, yend=latitude), color = "lightgray", size=6)+
  geom_text(data=transect_table, aes(x=label_long, y=latitude, label=transect), size=6) +
  scale_x_continuous(breaks = seq(-126.5,-123.5,1.5))+
  coord_sf(xlim = c(-126.5, -123.5),
           ylim = c(43.5,48.25)) +
  labs(x="Longitude", y="Latitude", fill = "Depth (m)") + 
  guides(fill=FALSE)+
  theme_minimal() +
  theme(axis.title = element_text(size=20),
        axis.text = element_text(size = 16))
dev.off()
