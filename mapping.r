# MAPPING 
library(geojsonio)
library(sp)
library(sf)
library(tictoc)
library(ggplot2)
library(RColorBrewer)

#import as sp object, then sf
data <- geojsonio::geojson_read("mapdata.geojson", what = "sp")
mapdata <- st_as_sf(mdata)

# Center on Young, AZ near Tonto Forest lng = -111.0875, lat = 34.1066
box <- c(xmin = -112.0875, xmax = -110.0875, ymin = 33.1046, ymax = 35.1066)
young <- st_crop(mapdata,box)
pal <- brewer.pal(3,"RdYlGn")
plot(young[,"delagb"],
     lty=3,
     lwd=0.00001,
     border= NA,
     pal = pal)